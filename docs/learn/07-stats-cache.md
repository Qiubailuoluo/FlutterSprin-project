# 07 - 统计与缓存策略

## 需求

首页展示：**本月收入、支出、结余**。

```
income  = SUM(账单.amount) WHERE type=1 AND 本月
expense = SUM(账单.amount) WHERE type=2 AND 本月
balance = income - expense
```

## 接口

`GET /api/stats/month?year=2026&month=7`

不传 year/month 则默认当前年月。

## 实现：StatsServiceImpl

### 1. 先查 Redis

```java
statsCacheService.get(userId, year, month)
    .orElseGet(() -> computeAndCache(...));
```

### 2. 未命中则聚合 MySQL

使用 `QueryWrapper` 写聚合：

```java
wrapper.select("IFNULL(SUM(amount), 0) AS total")
    .eq("user_id", userId)
    .eq("type", type)
    .ge("bill_date", start)
    .le("bill_date", end);
```

分别查 type=1（收入）和 type=2（支出）。

### 3. 写入 Redis

JSON 格式存入 `stats:user:{userId}:month:2026-07`，TTL 5 分钟。

## 缓存失效时机

| 事件 | 动作 |
|------|------|
| 新增账单 | 删该账单日期所在月的 key |
| 修改账单 | 删旧月份 key；若改日期则再删新月份 |
| 删除账单 | 删该账单日期所在月的 key |

实现：`BillServiceImpl` → `StatsCacheService.invalidateMonth()`

## 为什么用字符串存金额？

API 返回 `"8000.00"` 而非数字，避免 JSON 浮点精度问题（前端展示、对账更稳妥）。

## 流程图

```
GET /api/stats/month
    │
    ├─ Redis 有缓存？─是→ 直接返回
    │
    └─ 否 → MySQL SUM → 组装 MonthStatsVO → 写 Redis → 返回
```

## 扩展思考（本项目未做）

- 按分类饼图：需 `GROUP BY category_id`
- 按日折线：需 `GROUP BY bill_date`
- 更长 TTL vs 实时性：账单 APP 通常「写时删缓存」即可

## 练习

1. 阅读 `StatsServiceImpl.computeAndCache()`
2. 用 testuser 造几笔收入/支出，调用统计接口手算核对
3. `redis-cli GET stats:user:2:month:2026-07` 查看缓存 JSON
