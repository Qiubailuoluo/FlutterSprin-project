# 后端开发阶段说明

## 阶段划分

| 阶段 | 内容 | 状态 |
|------|------|------|
| 1 | Maven 骨架、统一响应、全局异常、MyBatis-Plus/Redis/CORS 配置、健康检查 | 已完成 |
| 2 | Spring Security + JWT + 注册/登录/退出/用户信息 | 已完成 |
| 3 | 分类模块（预设 + 自定义） | 待开始 |
| 4 | 账单 CRUD + 分页筛选 | 待开始 |
| 5 | 月度统计 + Redis 缓存 | 待开始 |

## 阶段 1 验证

```powershell
cd backend
D:\My_download\java_MAVEN\apache-maven-3.6.3\bin\mvn.cmd spring-boot:run
```

访问：`GET http://localhost:8080/api/health`

预期响应：

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "status": "UP",
    "app": "ledger"
  }
}
```

**注意**：启动前需确保 MySQL 已执行 `docs/database/schema.sql`，且 Redis 已运行。

## 阶段 2 验证

```powershell
# 注册
Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post `
  -Body '{"username":"demo","password":"123456"}' -ContentType "application/json"

# 登录
$login = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post `
  -Body '{"username":"demo","password":"123456"}' -ContentType "application/json"
$token = $login.data.token

# 获取资料
Invoke-RestMethod -Uri "http://localhost:8080/api/user/profile" `
  -Headers @{Authorization="Bearer $token"}
```
