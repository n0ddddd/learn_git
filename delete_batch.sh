#!/bin/bash
# Oracle 数据分批删除工具 - 删除函数部分
# 作者：数据架构专家
# 日期：2023-12-01

# 配置参数（根据实际环境修改）
DB_CONN="data_mig/data_mig@192.168.68.71:1521/pdb1"
DBA_CONN="sys/syspassword as sysdba"  # 需要DBMS_LOCK包访问权限
DELETE_ROWS=10000                    # 每批删除的行数
SLEEP_SEC=1                          # 批次间隔秒数
LOG_FILE="delete_operation_$(date +%Y%m%d).log"

# 执行分批删除函数
delete_data_batch() {
  local table="$1"
  local condition="$2"
  
  echo "$(date +'%Y-%m-%d %H:%M:%S') - 开始清理表: $table" | tee -a $LOG_FILE
  
  sqlplus -s $DB_CONN << EOF
  SET SERVEROUTPUT ON
  SET TIMING ON
  DECLARE
    v_deleted_rows NUMBER := 0;
    v_total_rows NUMBER := 0;
    v_batch_count NUMBER := 0;
  BEGIN
    -- 获取初始行数
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM $table WHERE $condition'
      INTO v_total_rows;
    
    DBMS_OUTPUT.PUT_LINE('待删除总行数: ' || v_total_rows);
    
    WHILE v_deleted_rows < v_total_rows LOOP
      EXECUTE IMMEDIATE 
        'DELETE FROM $table 
         WHERE $condition
         AND ROWNUM <= $DELETE_ROWS'
        RETURNING SQL%ROWCOUNT INTO v_batch_count;
      
      v_deleted_rows := v_deleted_rows + v_batch_count;
      COMMIT;
      
      DBMS_OUTPUT.PUT_LINE(
        '表: $table | ' ||
        '已删除: ' || v_deleted_rows || '/' || v_total_rows || ' | ' ||
        '进度: ' || ROUND(v_deleted_rows / v_total_rows * 100, 2) || '%'
      );
      
      EXIT WHEN v_batch_count = 0;
      DBMS_LOCK.SLEEP($SLEEP_SEC);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('表 $table 清理完成');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('清理失败: ' || SQLERRM);
      RAISE;
  END;
/
EXIT
EOF
}
