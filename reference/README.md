# reference — 补充参考规则（源包）

本目录是**使用中的泛类补充规范**：按需引用，不是开工闭环说明书。

**重要：** 仅解压不会自动高效。遵守 [project-bootstrap.mdc](project-bootstrap.mdc)：

1. 按架构/栈删除或忽略未用目录  
2. 大需求先按 [workflow/task-breakdown.mdc](workflow/task-breakdown.mdc) 拆解  
3. 二开/改代码遵守 [workflow/code-change.mdc](workflow/code-change.mdc)（最小改动）  
4. 每子任务只 `@` 1～3 个技术专题 → [docs-sync](workflow/docs-sync.mdc) / [acceptance](workflow/acceptance.mdc) 收尾  

## 与 Cursor / 项目规则的关系（避免伤项目）

| 层级 | 是什么 | 对本仓库 Ledger |
|------|--------|-----------------|
| Cursor / 助手侧通用能力 | 产品与对话内的通用编程习惯 | 始终存在，与 reference 无关 |
| 用户规则（User Rules） | 你在 Cursor 设置里的全局偏好 | 如「用中文」等 |
| **项目正式 rules** | `.cursor/rules/*.mdc` | **真正约束本项目**（如 `project-overview`、`backend-springboot`） |
| **本包 reference** | 泛类补充，默认 Manual | 源包在仓库根；**不自动生效**，除非 `@` 或解压进 `.cursor/rules/reference/` 后再引用 |

**不会轻易伤项目的原因：**

- 全员 `alwaysApply: false`、无宽 globs → 不会偷偷全局注入。  
- 明文优先级：本地代码 > 项目正式 rules/docs > reference。  
- 与正式规则重复时**不删正式侧**；冲突听本地。  

**若仍担心：** 本 Ledger 开发可继续只靠 `.cursor/rules/`；reference 仅当源包压缩给其他项目。解压到新项目时也保持 Manual，并裁剪未用目录。规则变糊时优先改短、改选用表，而不是改成 Always。

## 定位

| 是什么 | 不是什么 |
|--------|----------|
| 使用中补充词典 | 覆盖本地架构 |
| 可解压到目标 `.cursor/rules/reference/` | 替代项目专用正式规则 |

**优先级：** 本地代码 → 项目专用 rules/docs → reference。

| 文档 | 用途 |
|------|------|
| [project-bootstrap.mdc](project-bootstrap.mdc) | 高效用法入口 |
| [workflow/task-breakdown.mdc](workflow/task-breakdown.mdc) | 任务拆解 |
| [workflow/code-change.mdc](workflow/code-change.mdc) | 修改已有代码 |
| [workflow/docs-sync.mdc](workflow/docs-sync.mdc) | docs 同步 |
| [workflow/acceptance.mdc](workflow/acceptance.mdc) | 收尾验收 |

## 目录

```text
reference/
  README.md
  project-bootstrap.mdc     ← 入口
  workflow/                 拆解、docs、验收
  middleware/
  backend/
    common/ | monolith/ | microservices/
  frontend/
    flutter/ | vue/ | web/
```

## 推荐分发

```text
目标项目/.cursor/rules/reference/
  project-bootstrap.mdc
  workflow/
  middleware/  backend/  frontend/   # 裁剪后
```

## 交给 AI 的推荐开场

```text
请先阅读并遵守 @.cursor/rules/reference/project-bootstrap.mdc：
1）裁剪未用目录（单体忽略 microservices；Vue 忽略 flutter 等）；
2）若需求较大，先按 workflow/task-breakdown 拆成子任务再实现当前块；
3）二开/改代码遵守 workflow/code-change（先读后改、最小改动、不顺手重构）；
4）每子任务只选用 1～3 个技术专题；冲突以本地代码与项目正式 rules 为准；
5）需要时 workflow/docs-sync；收尾 workflow/acceptance。
当前任务：……（新项目/二开；栈：……；单体或微服务：……）
```

源包在仓库根时，把 `@` 路径改成 `@reference/project-bootstrap.mdc` 即可。

## 维护

- 单文件保持短；工作流进 `workflow/`，技术专题进 backend/frontend/middleware。  
- 缺了再补；勿 Always 整包。  
- 勿提交密钥与生产配置。
