# 统计接口

需登录：`Authorization: Bearer {token}`

MVP 仅提供**月度汇总**（收入、支出、结余），不含图表。

缓存：
- Key：`stats:user:{userId}:month:{yyyy-MM}`
- TTL：5 分钟
- 账单增删改时删除对应 key

---

## GET /api/stats/month

指定月份汇总。

**Query**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| year | int | 否 | 默认当前年 |
| month | int | 否 | 默认当前月，1~12 |

**响应 data**

```json
{
  "year": 2026,
  "month": 7,
  "income": "8000.00",
  "expense": "2350.50",
  "balance": "5649.50"
}
```

| 字段 | 说明 |
|------|------|
| income | 当月收入合计 |
| expense | 当月支出合计 |
| balance | income - expense |

金额均为字符串或 decimal，保留两位小数，与账单表一致。
