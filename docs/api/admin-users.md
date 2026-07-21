# 管理员 — 账户管理

需登录，且当前用户 `role = 2`（管理员）。普通用户调用返回 `403`。

| 接口 | 用途 |
|------|------|
| `GET /api/admin/users` | 全部用户列表 |
| `PUT /api/admin/users/{id}/status` | 封禁 / 解封 |

角色约定（`user.role`）：`1` 普通，`2` 管理员。  
状态约定（`user.status`）：`1` 正常，`0` 禁用。禁用后无法登录；封禁时会删除该用户 Redis Token（立即下线）。

---

## GET /api/admin/users

**响应 data**

```json
[
  {
    "id": 2,
    "username": "testuser",
    "nickname": "测试用户",
    "status": 1,
    "role": 2,
    "createdAt": "2026-07-01T10:00:00"
  }
]
```

不含密码字段。

---

## PUT /api/admin/users/{id}/status

**请求体**

```json
{ "status": 0 }
```

| status | 含义 |
|--------|------|
| 0 | 封禁（禁用） |
| 1 | 解封（恢复） |

**约束**

- 不能修改自己的状态（400）
- 目标用户不存在（404）
- 非管理员（403）

**响应 data**：更新后的用户对象（同列表项结构）。
