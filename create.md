我们将从零开始讨论创建一个微小型的项目：

1. 我们先多轮确认信息讨论，不要也不允许直接创建代码  

2. 我们使用flitter和springboot框架。中间件包含redis，mysql，git
    2.1 其中：JDK17, mysql 如果需要你也需要给出创建的sql语句，创建数据库

3.在这个文件夹你可以创建，删除文件操作，方便你创建项目和其他内容 

4.我们需要添加一些项目创建的约束，或者skill文件
    4.1 我们后端springboot：文件需要根据功能划分：比如controller，service，serviceimpl，mapper等分层，其中每一层又按照内容添加文件夹：Loginin，User等，方便快速查询管理。
    4.2 文件约束和规范也需要符合实际的企业开发生产标准，比如controller，不允许添加额外的逻辑处理，编写sql语句等等，这不符合规范
    4.3 前端flutter 也是类似我们后端的划分

5. 我们还需要在文件夹中添加docs文档，用来添加一些文本信息，方便开发人员快速查阅各部份的框架，接口资料，数据库资料等等，便于阅读，也方便ai协同开发快速定位

6. 其他部分：
    6.1 我们后端：还需要添加全局异常处理，统一响应类型

7. 我们先继续讨论确认，一步步完善我们的初始内容：而且我这个项目我需要小而完备，内容我还没确认做什么，你可以给点建议，就当是给我学习一下，完全本地学习，不会涉及任何敏感信息

---

## 已确认配置（讨论结果）

| 项 | 选择 |
|----|------|
| 项目 | 方案 A：个人记账本（小账本） |
| 包名/应用名 | `com.example.ledger` / 小账本 |
| 前端平台 | Flutter Windows + Web |
| 后端 | Spring Boot 3.x + JDK 17 + Maven 3.6.3 |
| Maven 路径 | `D:\My_download\java_MAVEN\apache-maven-3.6.3` |
| ORM | MyBatis-Plus |
| 密码 | BCrypt |
| 分类 | 系统预设 + 用户自定义 |
| 统计 MVP | 仅本月收入/支出/结余 |
| 登录 | JWT（1 天）+ Redis Token |
| Redis | Token + 统计缓存（5 分钟 TTL） |
| API | REST + `{ code, message, data }` |
| 后端端口 | 8080 |
| MySQL | root / root，8.0.39，已验证 |
| 约束文件 | 本项目 `.cursor/rules/*.mdc`（不影响其他项目） |

## 创建进度

- [x] 讨论与需求确认
- [x] `.cursor/rules/`（project-overview、backend、flutter）
- [x] `docs/`（架构、规范、环境、API、schema.sql）
- [x] `backend/` 阶段1（骨架、统一响应、全局异常、健康检查）
- [x] `backend/` 阶段2（Security + JWT + 认证）
- [x] `backend/` 阶段3（分类模块）
- [x] `backend/` 阶段4（账单模块）
- [x] `backend/` 阶段5（月度统计）
- [x] 代码注释增强 + `docs/learn/` 学习文档
- [x] `flutter_app/` 阶段1（Web 骨架、主题、路由、健康检查）
- [x] `flutter_app/` 阶段2（登录/注册、Token、路由守卫）
- [x] `flutter_app/` 阶段3（首页统计卡片 + 分类列表）
- [x] `flutter_app/` 阶段4（账单列表/表单 CRUD）
- [x] `flutter_app/` 阶段5（交互优化、统一反馈、401 处理）

## MVP 状态

**学习用 MVP 已全部完成**（后端 5 阶段 + Flutter 5 阶段）。可选扩展见下方。

### 已完成能力

- 注册 / 登录 / 退出（JWT + Redis）
- 分类（系统 + 自定义）
- 账单 CRUD + 分页筛选
- 本月收入 / 支出 / 结余统计（Redis 缓存）
- Flutter Web（Edge）完整 UI

### 未做 / 可选扩展（不影响 MVP 完结）

- Windows 桌面（需安装 Visual Studio C++）
- 图表、导出 Excel、多账本、预算提醒等
- TDesign 换肤（已确认不需要）
- 生产部署（HTTPS、Docker、CI/CD）

演示数据：`docs/database/seed_testuser.sql`
