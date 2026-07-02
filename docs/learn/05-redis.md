# 05 - Redis 实战

本项目 Redis 有两个用途：**登录 Token** 和 **月度统计缓存**。

## Redis 是什么？

内存数据库，读写极快，适合：

- 会话 / Token
- 热点数据缓存
- 计数器、排行榜

本地连接：`localhost:6379`（见 `docs/dev-setup.md`）

## 用途一：登录 Token

### Key 设计

```
auth:token:{userId}
```

定义在 `common/constant/RedisKeyConstants.java`，集中管理 key 前缀，避免拼写错误。

### 代码路径

| 操作 | 类与方法 |
|------|----------|
| 登录写入 | `AuthRedisService.saveToken()` |
| 请求校验 | `AuthRedisService.isTokenValid()` |
| 退出删除 | `AuthRedisService.removeToken()` |

### 手动验证

```powershell
# 登录后（userId 假设为 2）
& "D:\My_download\Redis\Redis-x64-5.0.14.1\redis-cli.exe" GET auth:token:2
```

## 用途二：月度统计缓存

### Key 设计

```
stats:user:{userId}:month:{yyyy-MM}
```

例如：`stats:user:2:month:2026-07`

### 读写逻辑

`StatsCacheService`：

- `get()`：有缓存直接返回 JSON
- `put()`：写入缓存，**TTL 5 分钟**
- `invalidateMonth()`：账单变更时删除，保证数据新鲜

### 为什么账单变更要删缓存？

统计来自 MySQL 聚合。若只缓存不删除，新增账单后统计仍是旧数字。所以在 `BillServiceImpl` 的增删改后调用：

```java
statsCacheService.invalidateMonth(userId, bill.getBillDate());
```

## StringRedisTemplate

Spring 提供的 Redis 操作模板。本项目 value 存 **字符串**（Token 原文、统计 JSON）。

配置：`config/RedisConfig.java`

## 缓存策略小结

| 场景 | 策略 |
|------|------|
| Token | 与 JWT 同寿命，退出主动删 |
| 统计 | 5 分钟过期 + 账单变更主动删 |

这叫 **Cache-Aside**：先读缓存，miss 则查库并回填；写库时删缓存。

## 练习

1. 登录后 `redis-cli GET auth:token:你的userId`
2. 调用 `GET /api/stats/month` 两次，第二次应更快（命中缓存）
3. 新增一笔账单后再查统计，观察 expense 变化（缓存已失效）
