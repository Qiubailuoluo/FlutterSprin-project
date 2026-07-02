# 账单接口

需登录：`Authorization: Bearer {token}`

`type`：1 = 收入，2 = 支出  
`amount`：正数，保留两位小数

账单变更后应清除 Redis 统计缓存：`stats:user:{userId}:month:{yyyy-MM}`

---

## GET /api/bills

分页列表。

**Query**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| page | int | 否 | 页码，默认 1 |
| size | int | 否 | 每页条数，默认 20，最大 100 |
| type | int | 否 | 1 收入 / 2 支出 |
| categoryId | long | 否 | 分类 ID |
| startDate | string | 否 | 开始日期 yyyy-MM-dd |
| endDate | string | 否 | 结束日期 yyyy-MM-dd |

**响应 data**

```json
{
  "total": 100,
  "page": 1,
  "size": 20,
  "records": [
    {
      "id": 1,
      "categoryId": 4,
      "categoryName": "餐饮",
      "type": 2,
      "amount": "35.50",
      "billDate": "2026-07-01",
      "remark": "午饭",
      "createdAt": "2026-07-01T12:00:00"
    }
  ]
}
```

---

## POST /api/bills

新增账单。

**请求体**

```json
{
  "categoryId": 4,
  "type": 2,
  "amount": 35.50,
  "billDate": "2026-07-01",
  "remark": "午饭"
}
```

**响应 data**：新建账单对象（含 `id`）

---

## PUT /api/bills/{id}

更新账单（仅能改自己的）。

**请求体**：同 POST，字段均可选（部分更新按实现约定）

**响应 data**：更新后的账单对象

---

## DELETE /api/bills/{id}

删除账单（仅能删自己的）。

**响应 data**：`null`
