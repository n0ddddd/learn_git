## mysql5.7
import re
from datetime import datetime
import os
import json
from pathlib import Path
from collections import defaultdict

# ... existing code ...

def parse_binlog_text(binlog_text_path):
    transactions = []
    current_tx = None
    current_pos = None
    current_ts = None
    current_table = None  # 当前操作的表

    # 关键修复：强制指定文件编码为 utf-8
    with open(binlog_text_path, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            line = line.strip()

            # 解析事件位置（格式：# at 123456）
            pos_match = re.match(r'^# at (\d+)', line)
            if pos_match:
                current_pos = int(pos_match.group(1))

            # 解析时间戳（格式：#250227 8:13:09）- 注意支持小时的单位数格式
            ts_match = re.match(r'^#(\d{6})\s+(\d{1,2}):(\d{2}):(\d{2})', line)
            if ts_match:
                date_str = ts_match.group(1)
                hour = int(ts_match.group(2))
                minute = int(ts_match.group(3))
                second = int(ts_match.group(4))

                # 尝试解析更精确的时间（如果有毫秒信息）
                microsecond = 0
                if 'exec_time=' in line:
                    exec_time_match = re.search(r'exec_time=(\d+)', line)
                    if exec_time_match:
                        microsecond = int(exec_time_match.group(1)) * 1000  # 转换为微秒

                # 日期转换（250227 → 2025-02-27）
                year = 2000 + int(date_str[0:2])
                month = int(date_str[2:4])
                day = int(date_str[4:6])
                current_ts = datetime(year, month, day, hour, minute, second, microsecond)

            # 事务开始（注意：BEGIN前面可能有其他内容）
            if 'BEGIN' in line:
                if current_ts:
                    current_tx = {
                        'start_pos': current_pos,
                        'start_ts': current_ts,
                        'last_event_ts': current_ts,
                        'end_pos': current_pos,
                        'events': [],  # 添加事件列表以记录事务内的操作
                        'exec_times': [],  # 记录每个事件的执行时间
                        'table_ops': defaultdict(lambda: {'UPDATE': 0, 'INSERT': 0, 'DELETE': 0})  # 记录每个表的操作次数
                    }
                else:
                    print(f"警告：在位置 {current_pos} 处发现BEGIN，但没有有效的时间戳")

            # 记录事务内的事件
            if current_tx and current_pos:
                current_tx['end_pos'] = current_pos
                if current_ts:
                    current_tx['last_event_ts'] = current_ts

                # 处理UPDATE语句
                if line.upper().startswith('UPDATE'):
                    table_name = re.search(r'UPDATE\s+(\S+)\s+SET', line, re.IGNORECASE)
                    if table_name:
                        table = table_name.group(1)
                        current_tx['table_ops'][table]['UPDATE'] += 1
                
                # 处理INSERT语句
                elif line.upper().startswith('INSERT'):
                    table_name = re.search(r'INSERT\s+INTO\s+(\S+)\s+', line, re.IGNORECASE)
                    if table_name:
                        table = table_name.group(1)
                        current_tx['table_ops'][table]['INSERT'] += 1
                
                # 处理DELETE语句
                elif line.upper().startswith('DELETE'):
                    table_name = re.search(r'DELETE\s+FROM\s+(\S+)\s+', line, re.IGNORECASE)
                    if table_name:
                        table = table_name.group(1)
                        current_tx['table_ops'][table]['DELETE'] += 1

                # 提取表信息 (保留原有的 Table_map 处理逻辑)
                if 'Table_map:' in line:
                    table_info = re.search(r'`([^`]+)`.`([^`]+)`', line)
                    if table_info:
                        db_name, table_name = table_info.groups()
                        current_table = f"{db_name}.{table_name}"

                # 保留原有的 rows 事件处理逻辑
                if 'Write_rows:' in line and current_table:
                    current_tx['table_ops'][current_table]['INSERT'] += 1
                if 'Update_rows:' in line and current_table:
                    current_tx['table_ops'][current_table]['UPDATE'] += 1
                if 'Delete_rows:' in line and current_table:
                    current_tx['table_ops'][current_table]['DELETE'] += 1

                # 记录事件
                if 'Table_map:' in line or 'Write_rows:' in line or 'Update_rows:' in line or 'Delete_rows:' in line or 'Query' in line:
                    current_tx['events'].append(line)

                # 记录执行时间
                exec_time = 0
                if 'exec_time=' in line:
                    exec_time_match = re.search(r'exec_time=(\d+)', line)
                    if exec_time_match:
                        exec_time = int(exec_time_match.group(1))
                    current_tx['exec_times'].append(exec_time)

            # 事务提交（注意：COMMIT前面可能有其他内容）
            if 'COMMIT' in line and current_tx:
                if current_tx['last_event_ts'] and current_tx['start_ts']:
                    # 计算总持续时间（毫秒）
                    duration_td = current_tx['last_event_ts'] - current_tx['start_ts']
                    duration_ms = duration_td.total_seconds() * 1000

                    # 计算实际执行时间（毫秒）
                    total_exec_time = sum(current_tx['exec_times'])
                    tx_size = current_tx['end_pos'] - current_tx['start_pos']

                    transactions.append({
                        'size': tx_size,
                        'start_pos': current_tx['start_pos'],
                        'end_pos': current_tx['end_pos'],
                        'duration_ms': duration_ms,
                        'exec_time_ms': total_exec_time,
                        'start_time': current_tx['start_ts'].strftime('%Y-%m-%d %H:%M:%S.%f')[:-3],
                        'event_count': len(current_tx['events']),
                        'events': current_tx['events'],
                        'exec_times': current_tx['exec_times'],
                        'table_ops': dict(current_tx['table_ops'])  # 将 defaultdict 转换为普通字典
                    })
                else:
                    print(f"警告：事务在位置 {current_pos} 处提交，但时间戳无效")
                current_tx = None
                current_table = None  # 重置当前操作的表

    # 修改排序逻辑：按照事务的大小降序排序
    transactions.sort(key=lambda x: x['size'], reverse=True)

    return transactions


def save_analysis_results(transactions, input_file_path):
    # 获取输入文件的目录和文件名
    input_path = Path(input_file_path)
    output_dir = input_path.parent
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')

    # 创建两个输出文件：一个JSON格式的详细数据，一个易读的文本摘要
    json_output_path = output_dir / f'binlog_analysis_{timestamp}.json'
    text_output_path = output_dir / f'binlog_analysis_{timestamp}.txt'

    # 保存JSON格式的详细数据
    with open(json_output_path, 'w', encoding='utf-8') as f:
        json.dump({
            'analysis_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3],
            'input_file': str(input_file_path),
            'total_transactions': len(transactions),
            'transactions': transactions
        }, f, ensure_ascii=False, indent=2)

    # 保存易读的文本摘要
    with open(text_output_path, 'w', encoding='utf-8') as f:
        f.write(f"Binlog分析报告\n")
        f.write(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]}\n")
        f.write(f"输入文件: {input_file_path}\n")
        f.write(f"总事务数: {len(transactions)}\n\n")

        for idx, tx in enumerate(transactions, 1):
            f.write(f"\n=== 事务 #{idx} ===\n")
            f.write(f"大小: {tx['size']} 字节\n")
            f.write(f"开始位置: {tx['start_pos']}\n")
            f.write(f"结束位置: {tx['end_pos']}\n")
            f.write(f"开始时间: {tx['start_time']}\n")
            f.write(f"总持续时间: {tx['duration_ms']:.2f} 毫秒\n")
            f.write(f"实际执行时间: {tx['exec_time_ms']:.2f} 毫秒\n")
            f.write(f"事件数量: {tx['event_count']}\n")
            f.write("事务操作:\n")
            for event in tx['events']:
                if 'Table_map:' in event:
                    # 提取数据库和表名
                    table_info = re.search(r'`([^`]+)`.`([^`]+)`', event)
                    if table_info:
                        db_name, table_name = table_info.groups()
                        f.write(f" 准备操作表: {db_name}.{table_name}\n")
                elif 'Write_rows:' in event:
                    f.write(f" 写入数据: {event}\n")
                elif 'Update_rows:' in event:
                    f.write(f" 更新数据: {event}\n")
                elif 'Delete_rows:' in event:
                    f.write(f" 删除数据: {event}\n")
                elif 'Query' in event:
                    # 提取执行时间和SQL类型
                    exec_time = re.search(r'exec_time=(\d+)', event)
                    query_type = re.search(r'Query.*?(BEGIN|COMMIT|SET|CREATE|INSERT|UPDATE|DELETE)', event)
                    if query_type:
                        query_name = query_type.group(1)
                        exec_time_str = f"(执行耗时: {exec_time.group(1)}ms)" if exec_time else ""
                        f.write(f" SQL命令: {query_name} {exec_time_str}\n")
            f.write("\n")

            # 添加执行时间分析
            if 'exec_times' in tx and tx['exec_times']:
                f.write("执行时间分析:\n")
                f.write(f" 最长单次执行: {max(tx['exec_times'])} 毫秒\n")
                f.write(f" 平均执行时间: {sum(tx['exec_times']) / len(tx['exec_times']):.2f} 毫秒\n")
                f.write(f" 总执行时间: {sum(tx['exec_times'])} 毫秒\n")
                f.write(f" 空闲时间: {tx['duration_ms'] - sum(tx['exec_times']):.2f} 毫秒\n")

            # 添加涉及的表及其操作次数
            if 'table_ops' in tx and tx['table_ops']:
                f.write("涉及的表及其操作次数:\n")
                for table, ops in tx['table_ops'].items():
                    f.write(f" 表: {table}\n")
                    f.write(f"   INSERT 操作次数: {ops['INSERT']}\n")
                    f.write(f"   UPDATE 操作次数: {ops['UPDATE']}\n")
                    f.write(f"   DELETE 操作次数: {ops['DELETE']}\n")

    return json_output_path, text_output_path

if __name__ == '__main__':
    binlog_text_path = 'C:\\Users\\xu\\Desktop\\yanchi0701.txt'  # 你的文件路径 win需转义
    transactions = parse_binlog_text(binlog_text_path)

    # 保存分析结果到文件
    json_file, text_file = save_analysis_results(transactions, binlog_text_path)

    print(f"\n分析完成，共发现 {len(transactions)} 个事务")
    print(f"详细JSON报告已保存至: {json_file}")
    print(f"文本摘要报告已保存至: {text_file}")

    if not transactions:
        print("未发现任何完整事务！")