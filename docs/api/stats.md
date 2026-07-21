# 统计接口

需登录：`Authorization: Bearer {token}`

| 接口 | 用途 |
|------|------|
| `GET /api/stats/month` | 月度汇总（缓存） |
| `GET /api/stats/category-share` | 支出分类占比（饼图） |
| `GET /api/stats/trend` | 近 N 月收支趋势（折线） |
| `GET /api/stats/by-member` | 按家庭成员汇总（柱状） |

月度汇总缓存：
- Key：`stats:user:{userId}:month:{yyyy-MM}`
- TTL：5 分钟
- 账单增删改时删除对应 key

---

## GET /api/stats/month

**Query**：`year`、`month` 可选。

**响应 data**：`{ year, month, income, expense, balance }`

---

## GET /api/stats/category-share

当月**支出**按分类占比。

**Query**：`year`、`month` 可选。

**响应 data**

```json
[
  { "categoryId": 4, "categoryName": "餐饮", "amount": "120.00", "ratio": 0.4 }
]
```

`ratio` 为 0~1。

---

## GET /api/stats/trend

**Query**：`months` 可选，默认 6，最大 24。

**响应 data**

```json
[
  { "year": 2026, "month": 2, "income": "8000.00", "expense": "2000.00" }
]
```

按时间升序。

---

## GET /api/stats/by-member

当月按家庭成员汇总收入/支出。`memberId` 为 `null` 表示账单未指定成员。

**Query**：`year`、`month` 可选。

**响应 data**

```json
[
  { "memberId": 1, "memberName": "小明", "income": "0.00", "expense": "300.00" },
  { "memberId": null, "memberName": "未指定", "income": "8000.00", "expense": "500.00" }
]
```
