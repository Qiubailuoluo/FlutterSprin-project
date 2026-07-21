# workflow — 工作流与元规则

本目录放**怎么用 reference 干活**的约定（与 backend/frontend 技术专题分离）。

| 文件 | 用途 |
|------|------|
| [task-breakdown.mdc](task-breakdown.mdc) | P1…Pn；清单+模式必出；每 P 主规则；混合+落盘 |
| [code-change.mdc](code-change.mdc) | 修改已有代码（最小改动） |
| [docs-sync.mdc](docs-sync.mdc) | 项目 `docs/` 创建与代码同步 |
| [acceptance.mdc](acceptance.mdc) | 收尾；最低验证；基础设施须测试 |

入口协议仍在上级：[project-bootstrap.mdc](../project-bootstrap.mdc)（先读）。

典型顺序：`project-bootstrap` →（大则 `task-breakdown`）→ **`code-change`（二开/修改）** → 技术专题 → `docs-sync` / `acceptance`。
