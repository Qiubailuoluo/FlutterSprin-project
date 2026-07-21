# reference / backend

当前目录内容以 **Java / Spring Boot** 约定为主（分层包名、JavaDoc、注解、`@RestControllerAdvice` 等）。

## 语言栈策略（稳健 · 少目录）

| 状态 | 路径 | 说明 |
|------|------|------|
| **已有** | `common/` · `monolith/` · `microservices/` | 即本仓库现在的 Java/Spring 规则（路径暂不改） |
| **计划** | `java/` · `go/` · `python/` | **有第一份对应语言的 `.mdc` 时再建**；届时把现有三目录迁入 `java/` |
| **禁止** | 空的 `go/`、`python/` 占位目录 | 与「够痛再加」一致；扩展意图写在本表即可 |

中间件（MySQL/Redis 等）仍在 [`../middleware/`](../middleware/)，与语言目录分开。

## 架构裁剪（Java 项目内）

```text
backend/                    # 当前 = Java/Spring（未迁 java/ 前）
  common/                   单体与微服务共用
  monolith/                 仅单体
  microservices/            仅多服务
```

| 项目类型 | 保留 / 引用 | 删除或忽略 |
|----------|-------------|------------|
| 单体 / 模块化单体 | `common/` + `monolith/` | 整个 `microservices/` |
| 微服务 | `common/` + `microservices/` | 整个 `monolith/` |
| 非 Java 后端 | 忽略整个 `backend/` 下 Java 专题，等有 `go/`/`python/` 再引用 | 勿把 Java 注解约定套到别的语言 |

每次仍只 `@` 当前 P 的 1～3 个主专题。Frontmatter 均为 Manual。  
优先级：本地代码与专用 rules > 本目录。

## common/（Java）

| 文件 | 主题 |
|------|------|
| [layering.mdc](common/layering.mdc) | 分层、DTO/VO、解耦 |
| [scaffold.mdc](common/scaffold.mdc) | 新建类 Checklist |
| [request-flow.mdc](common/request-flow.mdc) | 请求链路 |
| [exception.mdc](common/exception.mdc) | 全局异常 |
| [api-design.mdc](common/api-design.mdc) | API 约定 |
| [dependencies.mdc](common/dependencies.mdc) | 依赖方向 |
| [security.mdc](common/security.mdc) | 鉴权与授权 |
| [comments-annotations.mdc](common/comments-annotations.mdc) | JavaDoc、行内注释与框架注解 |

## monolith/

| 文件 | 主题 |
|------|------|
| [overview.mdc](monolith/overview.mdc) | 单体/模块化单体边界 |

## microservices/

| 文件 | 主题 |
|------|------|
| [architecture.mdc](microservices/architecture.mdc) | 服务拆分与协作 |

工作流见 [`../workflow/`](../workflow/)。  
选用表见 [`../project-bootstrap.mdc`](../project-bootstrap.mdc)。
