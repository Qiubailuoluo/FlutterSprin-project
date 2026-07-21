# 健康检查

基址：`http://localhost:8080`  
**无需登录**（Security 白名单）。

## GET /api/health

探测服务是否启动。

**响应示例**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "status": "UP",
    "app": "ledger",
    "time": "2026-07-21T06:00:00Z"
  }
}
```

| data 字段 | 说明 |
|-----------|------|
| status | 固定 `UP` 表示进程可用 |
| app | 应用标识 |
| time | 服务器当前 UTC 时间（ISO-8601） |
