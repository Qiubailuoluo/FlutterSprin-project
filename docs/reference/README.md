# reference — 补充参考规则（全集源）

本目录是 **reference 全集源（唯一修改入口）**。运行副本常见路径：`.cursor/rules/reference/`（可裁剪）。改完后同步运行副本，见 [project-bootstrap.mdc](project-bootstrap.mdc)。

**其他项目**：仓库名/产品名可不同；入口文件约定为包内的 `project-bootstrap.mdc`（若改名，在目标项目 README 标明「reference 入口」）。路径按实际 `@`，不要写死某一业务专名。

## 开场习惯（流程生效率）

按 reference 干活时，**先 `@` 入口协议**再开工：

```text
请先阅读并遵守 @.cursor/rules/reference/project-bootstrap.mdc
（若运行副本路径不同，改为实际路径；只要指向入口协议即可）
栈：……；新项目/二开；当前任务：……
```

仅解压不会自动高效。入口协议要求：

1. 按架构/栈裁剪**运行副本**  
2. 大需求：`task-breakdown` 清单 + 模式 + 落盘  
3. `code-change`：需求不清先澄清；禁止盲目改  
4. 每 P 主规则 1～3 → `docs-sync` / `acceptance`  

## 与 Cursor / 项目规则的关系

| 层级 | 是什么 | 说明 |
|------|--------|------|
| Cursor / 助手侧 | 通用编程习惯 | 与 reference 无关 |
| 用户规则 | 全局偏好 | 如语言、提交习惯 |
| **项目正式 rules** | 该仓库 `.cursor/rules` 专用约定 | **真正约束本项目** |
| **本包 reference** | 泛类补充，默认 Manual | 源与运行副本路径以各项目为准 |

- 全员 `alwaysApply: false` → 不偷偷全局注入。  
- 优先级：本地代码 > 项目正式 rules/docs > reference。  

## 定位

| 是什么 | 不是什么 |
|--------|----------|
| 使用中补充词典 | 覆盖本地架构 |
| 可同步到目标 `.cursor/rules/reference/` | 替代项目专用正式规则 |

## 文档索引

| 文档 | 用途 |
|------|------|
| [project-bootstrap.mdc](project-bootstrap.mdc) | **入口协议**（开场必引用） |
| [workflow/task-breakdown.mdc](workflow/task-breakdown.mdc) | P1…Pn、混合执行 |
| [workflow/code-change.mdc](workflow/code-change.mdc) | 澄清后再改；最小改动 |
| [workflow/docs-sync.mdc](workflow/docs-sync.mdc) | 项目 docs 同步 |
| [workflow/acceptance.mdc](workflow/acceptance.mdc) | 最低验证、基础设施测试 |

## 目录

```text
docs/reference/   或  仓库根 reference/   ← 全集源（改这里）
  project-bootstrap.mdc   ← 入口
  workflow/
  middleware/
  backend/     ← 当前 Java/Spring；Go/Python 有内容再建
  frontend/    ← flutter / vue / web

.cursor/rules/reference/   ← 运行副本（示例路径；同步后再裁剪）
```

## 演练日志 DRILL.md（可选 · 阶段性）

练习流水账；**不是**正式 API/表结构文档；练完可归档或清空。正式契约写在**当前项目**的 `docs/api` 等处。

## 维护

- **只改全集源，再同步运行副本**（若有双副本）。  
- 单文件保持短；缺了再补；勿 Always 整包。  
- 勿提交密钥与生产配置。  
- 规则正文避免绑定单一产品名；示例可写「如某记账应用」，以本地 docs 为准。
