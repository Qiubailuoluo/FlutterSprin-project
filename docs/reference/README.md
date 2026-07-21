# reference — 补充参考规则（全集源）

本目录是 **reference 全集源（唯一修改入口）**。运行副本在 `.cursor/rules/reference/`（可裁剪）。改规则后须同步到运行副本，见 [project-bootstrap.mdc](project-bootstrap.mdc)「双副本同步」。

**重要：** 仅解压不会自动高效。遵守 [project-bootstrap.mdc](project-bootstrap.mdc)：

1. 按架构/栈删除或忽略未用目录（仅针对**运行副本**）  
2. 大需求先按 [workflow/task-breakdown.mdc](workflow/task-breakdown.mdc)：**清单 + 模式必出**；混合分步/一口气 + **进度落盘**  
3. 二开遵守 [workflow/code-change.mdc](workflow/code-change.mdc)  
4. **每个 P** 声明 1～3 个主专题 → [docs-sync](workflow/docs-sync.mdc) / [acceptance](workflow/acceptance.mdc)（含最低验证）  

## 与 Cursor / 项目规则的关系（避免伤项目）

| 层级 | 是什么 | 对本仓库 Ledger |
|------|--------|-----------------|
| Cursor / 助手侧通用能力 | 产品与对话内的通用编程习惯 | 始终存在，与 reference 无关 |
| 用户规则（User Rules） | 你在 Cursor 设置里的全局偏好 | 如「用中文」等 |
| **项目正式 rules** | `.cursor/rules/*.mdc` | **真正约束本项目** |
| **本包 reference** | 泛类补充，默认 Manual | **源**在 `docs/reference/`；**运行**在 `.cursor/rules/reference/` |

**不会轻易伤项目的原因：**

- 全员 `alwaysApply: false`、无宽 globs → 不会偷偷全局注入。  
- 明文优先级：本地代码 > 项目正式 rules/docs > reference。  
- 与正式规则重复时**不删正式侧**；冲突听本地。  

## 定位

| 是什么 | 不是什么 |
|--------|----------|
| 使用中补充词典 | 覆盖本地架构 |
| 可同步到目标 `.cursor/rules/reference/` | 替代项目专用正式规则 |

**优先级：** 本地代码 → 项目专用 rules/docs → reference。

| 文档 | 用途 |
|------|------|
| [project-bootstrap.mdc](project-bootstrap.mdc) | 高效用法入口 + 双副本同步 |
| [workflow/task-breakdown.mdc](workflow/task-breakdown.mdc) | P1…Pn、混合执行、每 P 主规则 |
| [workflow/code-change.mdc](workflow/code-change.mdc) | 修改已有代码 |
| [workflow/docs-sync.mdc](workflow/docs-sync.mdc) | docs 同步 |
| [workflow/acceptance.mdc](workflow/acceptance.mdc) | 收尾 + 最低验证 + 基础设施测试 |

## 目录

```text
docs/reference/          ← 全集源（改这里）
  README.md
  project-bootstrap.mdc
  workflow/
  middleware/
  backend/
  frontend/

.cursor/rules/reference/ ← 运行副本（同步后再裁剪未用栈）
```

## 推荐分发

```text
目标项目/.cursor/rules/reference/
  （从本源同步后按栈裁剪）
```

## 交给 AI 的推荐开场

```text
请先阅读并遵守 @.cursor/rules/reference/project-bootstrap.mdc：
1）运行副本裁剪未用目录；改规则只改 docs/reference 再同步；
2）大需求：task-breakdown 清单+模式必出；每 P 主规则 1～3；混合分步/一口气+落盘；
3）code-change 最小改动；
4）冲突以本地代码与项目正式 rules 为准；
5）docs-sync；收尾 acceptance（最低验证；改 Result/异常/鉴权核心须带测试）。
当前任务：……
```

## 演练日志 DRILL.md（可选 · 阶段性）

| 是 | 不是 |
|----|------|
| 练习 reference 时的进度落盘、用例与验收记录 | 正式 API / 表结构 / 架构说明 |
| 可阶段性清空或按轮次归档（如 `DRILL-2026-07.md`） | 替代 `docs/api` 等长期文档 |

正式交付只认项目 `docs/` 业务文档 + 本目录 `.mdc` 规则正文。进度落盘优先写本文件；无演练任务时不必维护。

## 维护

- **只改本目录（全集源），再同步运行副本。**  
- 单文件保持短；缺了再补；勿 Always 整包。  
- 勿提交密钥与生产配置。
