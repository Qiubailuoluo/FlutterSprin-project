# 后端学习文档

面向本地练习，结合本项目源码讲解 Spring Boot 后端核心知识点。

## 阅读顺序（建议）

| 序号 | 文档 | 内容 |
|------|------|------|
| 1 | [01-项目结构与分层](01-package-structure.md) | 包结构、各层职责 |
| 2 | [02-统一响应 Result](02-unified-response.md) | 为什么需要统一格式 |
| 3 | [03-全局异常处理](03-global-exception.md) | BusinessException + RestControllerAdvice |
| 4 | [04-登录与 JWT](04-login-jwt.md) | 注册、登录、过滤器、Security |
| 5 | [05-Redis 实战](05-redis.md) | Token 存储、统计缓存 |
| 6 | [06-MyBatis-Plus CRUD](06-mybatis-crud.md) | 增删改查、分页、条件查询 |
| 7 | [07-统计与缓存策略](07-stats-cache.md) | 聚合查询、缓存失效 |

## 配合阅读

- 接口契约：`docs/api/`
- 表结构：`docs/database/schema.sql`
- 测试账号：`docs/test-accounts.md`
- 源码注释：打开 `backend/src/main/java` 中对应类

## 学习建议

1. 先跑通 `docs/dev-setup.md` 环境，用 `testuser` 调几个接口
2. 按上表顺序读文档，并在 IDE 里 **Ctrl+点击** 跳转到对应 Java 类
3. 改一行代码（如修改错误提示）→ 重启 → 看接口变化，加深理解
