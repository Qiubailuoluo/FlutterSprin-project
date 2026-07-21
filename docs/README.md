# 小账本 — 文档索引

本文说明 **docs 里放什么、不放什么**，以及改代码时同步哪里。

## 文档服务什么（总原则）

文档与规则的存在，是为了让 **AI 与开发人员**写代码时同时满足：

| 目标 | 文档侧怎么做 |
|------|----------------|
| **有效** | 契约层（api / database / architecture）与代码一致；冲突以代码为准并立刻改文档 |
| **高效** | 目录少、索引短；AI/人先读 `README` 再进一处；不把流水账、空目录、重复长文塞进检索路径 |
| **便于扩展** | 模块边界写在 architecture；新能力按现有 `api/` 一页一资源扩展；复杂方案**够痛再**建 `design/` |
| **便于维护** | 改代码必同步对应薄文档；修复靠 Git；阶段文档可冻结；`DRILL` 可清空 |

**默认策略：少目录、浓缩。**  
主路径保持：`architecture` + `api/` + `database/` + `dev-setup` / `conventions`。  
`learn/` 服务本项目学习目标，可保留但勿替代契约。  
仅当「单写进 architecture 会明显臃肿或难检索」时，再增 `design/`、`flows/`、`changelog.md`。

## 文档分层（必读）

| 层 | 目录/文件 | 写什么 | 生命周期 |
|----|-----------|--------|----------|
| **契约真相** | `api/`、`database/`、`architecture.md` | 与代码必须一致的接口、表、模块边界、主流程 | 长期；改代码必同步 |
| **工程协作** | `dev-setup.md`、`conventions.md`、`test-accounts.md` | 怎么跑、怎么写、测谁 | 长期；环境/约定变了再改 |
| **机制讲解** | `learn/` | 为什么这样设计（JWT、Redis、CRUD…），面向学习 | 长期；可略滞后，但**不得与代码矛盾** |
| **阶段进度** | `backend-phases.md`、`flutter-phases.md`、根目录 `create.md` | 里程碑、讨论结论摘要 | 阶段性；完成后可冻结，不必每 bug 追加 |
| **泛类规则源** | `reference/*.mdc` | 可复用到其他项目的补充规则 | 长期；**只改本目录再同步运行副本** |
| **演练流水账** | `reference/DRILL.md` | 规则练习用例与验收 | **可选、阶段性**；练完归档/清空 |

**不要**把下列内容塞进 `api/` 或 `architecture.md`：

- 每次修 bug 的流水（用 Git 提交 / 可选 `changelog`）
- 聊天式讨论全文（可摘要进 `create.md` 或阶段文档）
- 泛类规则全文（放 `reference/`，勿复制进业务文档）

## 推荐目录树

```text
docs/
  README.md                 ← 本索引 + 分层说明
  architecture.md           ← 架构、模块、认证/缓存等主流程
  conventions.md            ← 编码与目录约定
  dev-setup.md              ← 环境与启动
  test-accounts.md          ← 本地测试账号与示例命令
  backend-phases.md         ← 后端阶段进度（可冻结）
  flutter-phases.md         ← 前端阶段进度（可冻结）
  api/                      ← 接口契约（按资源拆分）
  database/                 ← schema.sql、migrate_*.sql、seed
  learn/                    ← 机制学习文
  reference/                ← 泛类规则全集源 + 可选 DRILL.md
  # 按需（默认不建空目录；够痛再加）：
  # design/                 ← 单模块方案（仅复杂模块）
  # flows/                  ← 跨模块时序（仅 architecture 装不下时）
  # changelog.md            ← 面向发布的版本摘要（可选）
```

**扩展时**：优先在现有 `api/新资源.md`、`architecture` 增一小节；不要为每个小功能新建一层文件夹。

## 各类内容写哪里

| 你想记录的 | 放哪里 |
|------------|--------|
| 接口路径、入参出参、错误码 | `api/*.md` |
| 表字段、迁移脚本 | `database/` |
| 模块划分、鉴权/缓存主流程 | `architecture.md` |
| 「登录怎么走 Filter→Redis」细讲 | `learn/`（可与 architecture 互链） |
| 复杂模块的方案取舍（为何不选 A） | 可选 `design/{模块}.md`；简单模块不必单独建 |
| 跨模块调用链路/时序 | 可选 `flows/` 或画在 `architecture.md`；勿复制粘贴代码 |
| 编码规范 | `conventions.md` + `.cursor/rules` |
| 修复记录（何时修了什么） | **Git log** 为主；重要版本可写 `changelog.md` |
| 需求讨论过程 | 根目录 `create.md` 摘要；勿堆进 api |
| 规则练习过程 | `reference/DRILL.md`（可清空） |

## 索引表

| 文档 | 说明 |
|------|------|
| [architecture.md](architecture.md) | 系统架构与模块 |
| [conventions.md](conventions.md) | 前后端编码规范 |
| [dev-setup.md](dev-setup.md) | 本地环境（JDK/Maven/MySQL/Redis/Flutter） |
| [database/schema.sql](database/schema.sql) | 建库建表 SQL |
| [api/auth.md](api/auth.md) | 注册、登录、用户资料 |
| [api/category.md](api/category.md) | 分类 |
| [api/bill.md](api/bill.md) | 账单 |
| [api/stats.md](api/stats.md) | 月度统计与图表 |
| [api/member.md](api/member.md) | 家庭成员 |
| [api/admin-users.md](api/admin-users.md) | 管理员账户管理 |
| [api/health.md](api/health.md) | 健康检查 |
| [test-accounts.md](test-accounts.md) | 本地测试账号 |
| [learn/](learn/README.md) | 学习文档（分层、登录、Redis、CRUD 等） |
| [flutter-phases.md](flutter-phases.md) | Flutter 分阶段开发 |
| [backend-phases.md](backend-phases.md) | 后端分阶段开发 |
| [reference/](reference/README.md) | 补充规则源包；[DRILL.md](reference/DRILL.md) 为可选演练日志 |

项目根目录 [create.md](../create.md) 记录需求与讨论过程摘要。

> 练习分支：`docs/reference/` 为规则全集源；`.cursor/rules/reference/` 为裁剪后的运行副本。

## 改代码如何同步文档

与 `.cursor/rules` / `reference/workflow/docs-sync` 一致：**同一次任务内**更新对应层，冲突以代码为准并立刻改文档。

| 变更 | 更新 |
|------|------|
| 接口 | `api/` |
| 表结构 | `database/` |
| 架构/主流程 | `architecture.md` |
| 环境/启动 | `dev-setup.md` |
| 编码约定 | `conventions.md` |
| 机制讲解 | `learn/`（可选） |
