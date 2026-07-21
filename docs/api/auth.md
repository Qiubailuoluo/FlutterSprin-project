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
| 404 | 资源不存在 |
| 500 | 服务器错误（另含 `errorId`，无堆栈；用编号在服务端日志排查） |

JWT 有效期：**1 天**。Token 同时存入 Redis：`auth:token:{userId}`。  
请求可带 `X-Request-Id`；响应回写同一编号（未传则服务端生成）。

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
  "nickname": "演示用户",
  "role": 1
}
```

| 字段 | 说明 |
|------|------|
| expiresIn | 秒，86400 = 1 天 |
| role | `1` 普通用户，`2` 管理员 |

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
  "status": 1,
  "role": 1,
  "createdAt": "2026-07-02T10:00:00"
}
```

| 字段 | 说明 |
|------|------|
| status | `1` 正常，`0` 禁用 |
| role | `1` 普通，`2` 管理员 |

---

## PUT /api/user/profile

更新当前用户昵称（需登录）。

**请求体**

```json
{ "nickname": "新昵称" }
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| nickname | string | 是 | 1~64 字符 |

**响应 data**：同 `GET /api/user/profile`。

---

## PUT /api/user/password

修改当前用户密码（需登录）。须校验旧密码；成功后删除 Redis Token，**需重新登录**。

**请求体**

```json
{
  "oldPassword": "123456",
  "newPassword": "654321"
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| oldPassword | string | 是 | 6~32 字符 |
| newPassword | string | 是 | 6~32 字符，且不能与旧密码相同 |

**失败示例**

| 情况 | code | message |
|------|------|---------|
| 旧密码错误 | 400 | 旧密码不正确 |
| 新旧相同 | 400 | 新密码不能与旧密码相同 |

**响应 data**：`null`
