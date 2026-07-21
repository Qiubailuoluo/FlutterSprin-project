# reference / backend

按架构分目录，便于扩展与裁剪；**每次仍只 `@` 1～3 个文件**，效率靠选用协议而非少文件夹。

```text
backend/
  common/          单体与微服务共用（分层、API、异常、安全…）
  monolith/        仅单体
  microservices/   仅多服务
```

| 项目类型 | 保留 / 引用 | 删除或忽略 |
|----------|-------------|------------|
| 单体 / 模块化单体 | `common/` + `monolith/` | 整个 `microservices/` |
| 微服务 | `common/` + `microservices/` | 整个 `monolith/` |

Frontmatter 均为 Manual。优先级：本地代码与专用 rules > 本目录。

## common/

| 文件 | 主题 |
|------|------|
| [layering.mdc](common/layering.mdc) | 分层、DTO/VO、解耦 |
| [scaffold.mdc](common/scaffold.mdc) | 新建类 Checklist |
| [request-flow.mdc](common/request-flow.mdc) | 请求链路 |
| [exception.mdc](common/exception.mdc) | 全局异常 |
| [api-design.mdc](common/api-design.mdc) | API 约定 |
| [dependencies.mdc](common/dependencies.mdc) | 依赖方向 |
| [security.mdc](common/security.mdc) | 鉴权与密钥 |

## monolith/

| 文件 | 主题 |
|------|------|
| [overview.mdc](monolith/overview.mdc) | 单体/模块化单体边界 |

## microservices/

| 文件 | 主题 |
|------|------|
| [architecture.mdc](microservices/architecture.mdc) | 服务拆分与协作 |

中间件见 [`../middleware/`](../middleware/)。  
工作流见 [`../workflow/`](../workflow/)。  
选用表见 [`../project-bootstrap.mdc`](../project-bootstrap.mdc)。
