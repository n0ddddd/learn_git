#!/bin/bash
# Oracle 数据库数据迁移工具
# 作者：数据架构专家
# 日期：2025-01-06
# 描述：此脚本用于从源数据库导出数据并导入到目标数据库，包括导出、导入和数据检查步骤。

# 配置参数（建议通过环境变量设置以提高安全性）
DB_USER=${DB_USER:-"data_mig"}
DB_PASS=${DB_PASS:-"data_mig"}
DB_HOST=${DB_HOST:-"192.168.68.71"}
DB_PORT=${DB_PORT:-"1521"}
DB_SID=${DB_SID:-"pdb1"}
DB_CONN="$DB_USER/$DB_PASS@$DB_HOST:$DB_PORT/$DB_SID"

# 日志和参数文件配置
LOG_FILE=${LOG_FILE:-"data_migration_$(date +%Y%m%d_%H%M%S).log"}
EXPORT_PARFILE=${EXPORT_PARFILE:-"par.file"}
IMPORT_PARFILE=${IMPORT_PARFILE:-"impar.file"}

# 数据检查配置
SOURCE_TABLE1=${SOURCE_TABLE1:-"data_mig.UH_APPOINT_RECORD_LOG"}
SOURCE_TABLE2=${SOURCE_TABLE2:-"data_mig.UH_IP_RECORD_LOG"}
TARGET_TABLE1=${TARGET_TABLE1:-"SCOTT.HIS_UH_APPOINT_RECORD_LOG"}
TARGET_TABLE2=${TARGET_TABLE2:-"SCOTT.HIS_UH_IP_RECORD_LOG"}
DATE_UPPER=${DATE_UPPER:-"2022-01-01 00:00:00"}
DATE_LOWER=${DATE_LOWER:-"2021-01-01 00:00:00"}

# 函数：记录日志
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1" | tee -a $LOG_FILE
}

# 函数：检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        log_message "错误：命令 $1 未找到，请确保Oracle客户端已正确安装"
        exit 1
    fi
}

# 函数：检查文件是否存在
check_file() {
    if [ ! -f "$1" ]; then
        log_message "错误：文件 $1 未找到"
        exit 1
    fi
}

# 函数：检查数据库连接
check_db_connection() {
    log_message "检查数据库连接..."
    sqlplus -s $DB_CONN << EOF > /dev/null 2>&1
    SELECT 1 FROM dual;
    EXIT;
EOF
    if [ $? -ne 0 ]; then
        log_message "错误：无法连接到数据库 $DB_CONN"
        exit 1
    fi
    log_message "数据库连接检查成功"
}

# 函数：检查磁盘空间
check_disk_space() {
    local dump_dir="/home/oracle/dbdump"
    local required_space=50  # 50GB
    local available_space=$(df -BG $dump_dir | awk 'NR==2 {print $4}' | sed 's/G//')
    
    if [ $available_space -lt $required_space ]; then
        log_message "警告：磁盘空间不足，可用空间 ${available_space}GB，建议至少 ${required_space}GB"
        read -p "是否继续执行？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# 主程序开始
main() {
    log_message "=== Oracle 数据迁移开始 ==="
    
    # 前置检查
    check_command "sqlplus"
    check_command "expdp"
    check_command "impdp"
    check_file "$EXPORT_PARFILE"
    check_file "$IMPORT_PARFILE"
    check_db_connection
    check_disk_space
    
    # 步骤1：导出数据
    log_message "步骤1：开始导出数据"
    log_message "使用参数文件: $EXPORT_PARFILE"
    
    expdp $DB_CONN network_link=sourcedb parfile=$EXPORT_PARFILE >> $LOG_FILE 2>&1
    
    if [ $? -eq 0 ]; then
        log_message "步骤1完成：数据导出成功"
    else
        log_message "步骤1失败：数据导出失败"
        log_message "错误详情："
        grep -i "ORA-" $LOG_FILE | tail -10 | tee -a $LOG_FILE
        exit 1
    fi
    
    # 步骤2：导入数据
    log_message "步骤2：开始导入数据"
    log_message "使用参数文件: $IMPORT_PARFILE"
    
    impdp $DB_CONN parfile=$IMPORT_PARFILE >> $LOG_FILE 2>&1
    
    if [ $? -eq 0 ]; then
        log_message "步骤2完成：数据导入成功"
    else
        log_message "步骤2失败：数据导入失败"
        log_message "错误详情："
        grep -i "ORA-" $LOG_FILE | tail -10 | tee -a $LOG_FILE
        exit 1
    fi
    
    # 步骤3：数据检查
    log_message "步骤3：开始数据检查"
    log_message "检查时间范围: $DATE_LOWER 到 $DATE_UPPER"
    
    # 创建临时SQL文件
    cat > /tmp/data_check.sql << EOF
SET LINESIZE 200
SET PAGESIZE 100
COLUMN db FORMAT A10
COLUMN UH_APPOINT_RECORD_LOG FORMAT 999,999,999
COLUMN UH_IP_RECORD_LOG FORMAT 999,999,999

SELECT 
  '源数据库' AS db,
  (SELECT COUNT(*) FROM $SOURCE_TABLE1@sourcedb 
   WHERE ts < '$DATE_UPPER') AS UH_APPOINT_RECORD_LOG,
  (SELECT COUNT(*) FROM $SOURCE_TABLE2@sourcedb 
   WHERE ts < '$DATE_UPPER') AS UH_IP_RECORD_LOG
FROM DUAL
UNION ALL
SELECT 
  '历史数据库' AS db,
  (SELECT COUNT(*) FROM $TARGET_TABLE1 
   WHERE ts < '$DATE_UPPER' 
   AND ts >= '$DATE_LOWER') AS UH_APPOINT_RECORD_LOG,
  (SELECT COUNT(*) FROM $TARGET_TABLE2 
   WHERE ts < '$DATE_UPPER' 
   AND ts >= '$DATE_LOWER') AS UH_IP_RECORD_LOG
FROM DUAL;

EXIT;
EOF
    
    sqlplus -s $DB_CONN @/tmp/data_check.sql >> $LOG_FILE 2>&1
    
    if [ $? -eq 0 ]; then
        log_message "步骤3完成：数据检查完成"
        log_message "数据检查结果："
        echo "----------------------------------------"
        sqlplus -s $DB_CONN @/tmp/data_check.sql
        echo "----------------------------------------"
    else
        log_message "步骤3失败：数据检查失败"
        exit 1
    fi
    
    # 清理临时文件
    rm -f /tmp/data_check.sql
    
    log_message "=== Oracle 数据迁移完成 ==="
    log_message "详细日志请查看: $LOG_FILE"
}

# 错误处理
trap 'log_message "脚本执行被中断"; exit 1' INT TERM

# 执行主程序
main "$@"

