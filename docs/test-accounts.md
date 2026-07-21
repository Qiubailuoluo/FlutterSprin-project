# 测试账号

本地练习用账号，**仅用于开发测试**，勿用于生产或真实场景。

## 账号一览

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| `testuser` | `123456` | **管理员**（role=2） | 默认测试 / 管理员；侧栏可见「账户管理」 |
| `demo` | `123456` | 普通用户（role=1） | 已有普通账号；用于验证非管理员无账户管理入口 |
| `normaluser` | `123456` | 普通用户（role=1） | 可选；若不存在可用下方注册命令创建 |

角色：`1` 普通，`2` 管理员。状态：`1` 正常，`0` 禁用。

提升管理员（库内已对 testuser 执行过时可跳过）：

```sql
UPDATE `user` SET `role` = 2 WHERE `username` = 'testuser';
```

迁移脚本：`docs/database/migrate_user_role.sql`。

## 默认测试用户（管理员）

| 字段 | 值 |
|------|-----|
| 用户名 | `testuser` |
| 密码 | `123456` |
| 昵称 | `测试用户` |
| 角色 | 管理员 |

## 普通用户（demo）

| 字段 | 值 |
|------|-----|
| 用户名 | `demo` |
| 密码 | `123456`（若登录失败请用注册接口重置或改密） |
| 角色 | 普通用户 |

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

## 注册普通用户（若需要）

```powershell
Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" `
  -Method Post -Body '{"username":"normaluser","password":"123456","nickname":"普通用户"}' `
  -ContentType "application/json; charset=utf-8"
```

## 管理员账户接口示例

```powershell
# 用户列表
Invoke-RestMethod -Uri "http://localhost:8080/api/admin/users" `
  -Headers @{Authorization="Bearer $token"}

# 封禁 id=1
Invoke-RestMethod -Uri "http://localhost:8080/api/admin/users/1/status" -Method Put `
  -Headers @{Authorization="Bearer $token"} `
  -Body '{"status":0}' -ContentType "application/json; charset=utf-8"

# 解封
Invoke-RestMethod -Uri "http://localhost:8080/api/admin/users/1/status" -Method Put `
  -Headers @{Authorization="Bearer $token"} `
  -Body '{"status":1}' -ContentType "application/json; charset=utf-8"
```

## 个人资料

```powershell
# 改昵称
Invoke-RestMethod -Uri "http://localhost:8080/api/user/profile" -Method Put `
  -Headers @{Authorization="Bearer $token"} `
  -Body '{"nickname":"新昵称"}' -ContentType "application/json; charset=utf-8"

# 改密码（成功后需重新登录）
Invoke-RestMethod -Uri "http://localhost:8080/api/user/password" -Method Put `
  -Headers @{Authorization="Bearer $token"} `
  -Body '{"oldPassword":"123456","newPassword":"654321"}' `
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
