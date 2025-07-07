# Oracle 数据迁移工具

## 概述

这是一个用于Oracle数据库数据迁移的自动化脚本，支持从源数据库导出数据并导入到目标数据库，包括数据验证功能。

## 功能特性

- ✅ 自动化数据导出和导入
- ✅ 完整的错误处理和日志记录
- ✅ 数据完整性检查
- ✅ 环境变量配置支持
- ✅ 前置条件检查（磁盘空间、数据库连接等）
- ✅ 参数文件配置

## 文件结构

```
.
├── data_mig.sh          # 主脚本文件
├── par.file             # 导出参数文件
├── impar.file           # 导入参数文件
└── README.md            # 使用说明
```

## 前置条件

### 1. 数据库对象准备

确保目标数据库已创建以下对象：

```sql
-- 创建目录
CREATE DIRECTORY data_mig AS '/home/oracle/dbdump';
GRANT READ, WRITE ON DIRECTORY data_mig TO public;

-- 创建数据库链接
CREATE public DATABASE LINK sourcedb 
CONNECT TO system IDENTIFIED BY "system"
USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.1.52)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=xuhsdb)))';
```

### 2. Oracle客户端环境

确保已安装Oracle客户端工具：
- sqlplus
- expdp
- impdp

### 3. 参数文件准备

确保以下参数文件存在且配置正确：
- `par.file` - 导出参数文件
- `impar.file` - 导入参数文件

## 使用方法

### 基本用法

```bash
# 使用默认配置运行
./data_mig.sh

# 使用环境变量自定义配置
export DB_USER="your_user"
export DB_PASS="your_password"
export DB_HOST="your_host"
./data_mig.sh
```

### 环境变量配置

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| DB_USER | data_mig | 数据库用户名 |
| DB_PASS | data_mig | 数据库密码 |
| DB_HOST | 192.168.68.71 | 数据库主机地址 |
| DB_PORT | 1521 | 数据库端口 |
| DB_SID | pdb1 | 数据库SID |
| LOG_FILE | data_migration_YYYYMMDD_HHMMSS.log | 日志文件名 |
| EXPORT_PARFILE | par.file | 导出参数文件名 |
| IMPORT_PARFILE | impar.file | 导入参数文件名 |

### 数据检查配置

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| SOURCE_TABLE1 | data_mig.UH_APPOINT_RECORD_LOG | 源表1 |
| SOURCE_TABLE2 | data_mig.UH_IP_RECORD_LOG | 源表2 |
| TARGET_TABLE1 | SCOTT.HIS_UH_APPOINT_RECORD_LOG | 目标表1 |
| TARGET_TABLE2 | SCOTT.HIS_UH_IP_RECORD_LOG | 目标表2 |
| DATE_UPPER | 2022-01-01 00:00:00 | 检查时间上限 |
| DATE_LOWER | 2021-01-01 00:00:00 | 检查时间下限 |

## 执行流程

1. **前置检查**
   - 检查Oracle客户端工具是否安装
   - 验证参数文件是否存在
   - 测试数据库连接
   - 检查磁盘空间（建议至少50GB）

2. **数据导出**
   - 使用expdp从源数据库导出数据
   - 支持并行导出和压缩
   - 按时间条件过滤数据

3. **数据导入**
   - 使用impdp导入数据到目标数据库
   - 支持模式、表名和表空间映射
   - 支持表存在时的追加操作

4. **数据验证**
   - 比较源数据库和目标数据库的记录数
   - 按时间范围进行数据统计
   - 生成详细的对比报告

## 日志文件

脚本执行过程中会生成详细的日志文件，包含：
- 执行时间戳
- 每个步骤的执行状态
- 错误信息和堆栈跟踪
- 数据检查结果

## 错误处理

脚本包含完善的错误处理机制：
- 命令执行失败时自动退出
- 显示详细的错误信息
- 支持中断信号处理
- 自动清理临时文件

## 安全建议

1. **密码安全**
   - 避免在脚本中硬编码密码
   - 使用环境变量或配置文件存储敏感信息
   - 定期更换数据库密码

2. **权限控制**
   - 使用最小权限原则
   - 定期审查数据库用户权限
   - 限制脚本执行权限

3. **数据备份**
   - 执行迁移前备份目标数据库
   - 保留原始数据文件
   - 建立数据恢复流程

## 故障排除

### 常见问题

1. **连接失败**
   - 检查网络连接
   - 验证数据库服务状态
   - 确认用户名密码正确

2. **权限不足**
   - 检查目录权限
   - 验证数据库用户权限
   - 确认dblink配置正确

3. **磁盘空间不足**
   - 清理临时文件
   - 增加磁盘空间
   - 调整导出文件大小

### 调试模式

可以通过设置环境变量启用详细日志：

```bash
export DEBUG=1
./data_mig.sh
```

## 版本信息

- 版本：1.0.0
- 作者：数据架构专家
- 更新日期：2025-01-06

