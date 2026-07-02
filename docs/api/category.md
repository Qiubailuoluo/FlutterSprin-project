# 分类接口

需登录：`Authorization: Bearer {token}`

分类规则：
- `user_id` 为 NULL → 系统预设，所有用户可见
- `user_id` 有值 → 仅该用户的自定义分类
- 用户只能删除自己的自定义分类，不能删系统预设

`type`：1 = 收入，2 = 支出

---

## GET /api/categories

分类列表。

**Query**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| type | int | 否 | 1 收入 / 2 支出，不传返回全部 |

**响应 data**

```json
[
  {
    "id": 1,
    "name": "工资",
    "type": 1,
    "system": true,
    "sortOrder": 1
  },
  {
    "id": 10,
    "name": "宠物",
    "type": 2,
    "system": false,
    "sortOrder": 0
  }
]
```

| 字段 | 说明 |
|------|------|
| system | true=系统预设，false=用户自定义 |

---

## POST /api/categories

新增用户自定义分类。

**请求体**

```json
{
  "name": "宠物",
  "type": 2
}
```

**响应 data**

```json
{
  "id": 10,
  "name": "宠物",
  "type": 2,
  "system": false
}
```

---

## DELETE /api/categories/{id}

删除自定义分类。系统预设或他人分类返回 403。

**路径参数**：`id` — 分类 ID

**响应 data**：`null`
