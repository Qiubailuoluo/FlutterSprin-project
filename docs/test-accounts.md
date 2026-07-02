# 测试账号

本地练习用账号，**仅用于开发测试**，勿用于生产或真实场景。

## 默认测试用户

| 字段 | 值 |
|------|-----|
| 用户名 | `testuser` |
| 密码 | `123456` |
| 昵称 | `测试用户` |

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
