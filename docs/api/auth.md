# 认证接口

基址：`http://localhost:8080`  
需登录接口在请求头携带：`Authorization: Bearer {token}`

## 统一响应

```json
{
  "code": 200,
  "message": "success",
  "data": null
}
```

| code | 含义 |
|------|------|
| 200 | 成功 |
| 400 | 参数错误 |
| 401 | 未登录或 Token 无效 |
| 403 | 无权限 |
| 500 | 服务器错误 |

JWT 有效期：**1 天**。Token 同时存入 Redis：`auth:token:{userId}`。

---

## POST /api/auth/register

注册。

**请求体**

```json
{
  "username": "demo",
  "password": "123456",
  "nickname": "演示用户"
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | string | 是 | 3~64 字符，唯一 |
| password | string | 是 | 6~32 字符 |
| nickname | string | 否 | 昵称，默认同 username |

**响应 data**

```json
{
  "userId": 1,
  "username": "demo",
  "nickname": "演示用户"
}
```

---

## POST /api/auth/login

登录。

**请求体**

```json
{
  "username": "demo",
  "password": "123456"
}
```

**响应 data**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "expiresIn": 86400,
  "userId": 1,
  "username": "demo",
  "nickname": "演示用户"
}
```

| 字段 | 说明 |
|------|------|
| expiresIn | 秒，86400 = 1 天 |

---

## POST /api/auth/logout

退出（需登录）。删除 Redis 中 Token。

**响应 data**：`null`

---

## GET /api/user/profile

当前用户信息（需登录）。

**响应 data**

```json
{
  "userId": 1,
  "username": "demo",
  "nickname": "演示用户",
  "createdAt": "2026-07-02T10:00:00"
}
```
