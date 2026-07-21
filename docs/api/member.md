# 家庭成员

需登录：`Authorization: Bearer {token}`

成员归属当前登录用户的账本；账单可通过 `memberId` 关联成员后进入「按成员」统计。

## GET /api/members

成员列表。

**响应 data**：`[{ "id", "name", "createdAt" }]`

## POST /api/members

新增成员。

```json
{ "name": "小明" }
```

**响应 data**：新建成员对象。

## DELETE /api/members/{id}

删除成员（不级联删账单；账单 `member_id` 可仍指向已删 id，统计时显示 `#id`）。
