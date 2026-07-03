# 测试账号

本地练习用账号，**仅用于开发测试**，勿用于生产或真实场景。

## 默认测试用户

| 字段 | 值 |
|------|-----|
| 用户名 | `testuser` |
| 密码 | `123456` |
| 昵称 | `测试用户` |

## 演示数据（推荐）

执行 `docs/database/seed_testuser.sql` 可为 testuser 写入完整演示数据（可重复执行）：

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot --default-character-set=utf8mb4 ledger_db -e "source D:/FlutterSp-project/docs/database/seed_testuser.sql"
```

写入后概览：

| 项 | 数量/金额 |
|----|-----------|
| 账单总数 | 19 条（含 6 月 + 7 月） |
| 自定义分类 | 2 个（宠物、健身） |
| 2026-07 收入 | ¥9200.00 |
| 2026-07 支出 | ¥2912.90 |
| 2026-07 结余 | ¥6287.10 |

登录 Flutter 首页可看到本月统计；账单页可分页浏览。若统计仍为旧数字，等 5 分钟缓存过期或重启后端。

## 快速登录

```powershell
$login = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" `
  -Method Post -Body '{"username":"testuser","password":"123456"}' `
  -ContentType "application/json; charset=utf-8"
$token = $login.data.token
```

后续请求携带：

```text
Authorization: Bearer {token}
```

## 注册（若账号不存在）

```powershell
Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" `
  -Method Post -Body '{"username":"testuser","password":"123456","nickname":"测试用户"}' `
  -ContentType "application/json; charset=utf-8"
```

## 分类接口测试示例

```powershell
# 查询支出分类
Invoke-RestMethod -Uri "http://localhost:8080/api/categories?type=2" `
  -Headers @{Authorization="Bearer $token"}

# 新增自定义分类
Invoke-RestMethod -Uri "http://localhost:8080/api/categories" -Method Post `
  -Headers @{Authorization="Bearer $token"} `
  -Body '{"name":"宠物","type":2}' -ContentType "application/json; charset=utf-8"
```

## 账单接口测试示例

```powershell
# 新增支出账单（categoryId=4 为系统分类「餐饮」）
Invoke-RestMethod -Uri "http://localhost:8080/api/bills" -Method Post `
  -Headers @{Authorization="Bearer $token"} `
  -Body '{"categoryId":4,"type":2,"amount":35.50,"billDate":"2026-07-01","remark":"午饭"}' `
  -ContentType "application/json; charset=utf-8"

# 分页查询
Invoke-RestMethod -Uri "http://localhost:8080/api/bills?page=1&size=20&type=2" `
  -Headers @{Authorization="Bearer $token"}
```

## 统计接口测试示例

```powershell
# 本月汇总
Invoke-RestMethod -Uri "http://localhost:8080/api/stats/month?year=2026&month=7" `
  -Headers @{Authorization="Bearer $token"}
```
