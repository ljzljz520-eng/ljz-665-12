# Implementation Plan（实施计划）

## 背景

目标是在不改动官方 MySQL 初始化数据源的前提下，让项目可在 SQL Server 上完成“建表 + 初始化数据”并通过 Docker Compose 一键启动。

## 方案

- 引入 `db-init` 初始化容器：
  - 等待 SQL Server 就绪并创建目标库；
  - 将 MySQL 脚本转换为 T-SQL；
  - 执行初始化。
- 转换器聚焦“可执行性优先”：处理类型差异、移除不兼容语法、规避初始化阶段约束冲突。

## 已落地的关键实现点

- 修复/增强 MySQL→SQL Server 转换器：
  - 列后缀清理（字符集、排序规则、注释、`DEFAULT NULL`、`ON UPDATE` 等）。
  - 类型映射增强：`json`、`varchar(>4000)`、`float(m,n)`/`double(m,n)` 等。
  - 处理超长插入语句切分，避免 SQL Server 对单条语句/参数长度限制。
  - 跳过外键声明，避免跨表依赖导致初始化失败。
  - 唯一索引原样保留（转换为 `CREATE UNIQUE INDEX`），由数据库层保证唯一性。
  - 避免自动使用 `IDENTITY`，以便种子数据可直接插入。

## 验收标准

- `docker compose up -d` 后：
  - `db-init` 最终 `Exited (0)` 且日志包含 `Database initialization finished.`
  - `backend` 可连接 SQL Server 且无启动期 SQL 异常
  - `frontend` 可访问登录页
- SQL Server 中存在核心基础表与种子数据（如 `sys_user`）。

