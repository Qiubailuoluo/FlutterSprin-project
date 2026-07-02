# 02 - 统一响应 Result

## 问题：没有统一格式时

每个接口返回格式不一样，前端要写很多 if/else：

```json
// 接口 A
{ "success": true, "data": {} }

// 接口 B
{ "code": 0, "result": {} }
```

## 本项目的约定

**所有接口**都返回：

```json
{
  "code": 200,
  "message": "success",
  "data": { }
}
```

| code | 含义 |
|------|------|
| 200 | 成功 |
| 400 | 参数错误 |
| 401 | 未登录 |
| 403 | 无权限 |
| 500 | 服务器错误 |

注意：HTTP 状态码我们多数情况仍返回 **200**，用 body 里的 `code` 区分业务成功/失败（前后端分离常见做法）。

## 源码解读

### Result.java

```java
// 成功
return Result.ok(billVO);

// 失败（在 GlobalExceptionHandler 里）
return Result.fail(ResultCode.BAD_REQUEST, "用户名已存在");
```

- `Result<T>` 的泛型 `T` 就是 `data` 的类型
- 静态工厂方法 `ok()` / `fail()` 避免到处 new

### ResultCode.java

枚举集中管理错误码和默认文案，避免魔法数字。

## Controller 中的写法

```java
@GetMapping("/profile")
public Result<UserProfileVO> profile() {
    return Result.ok(userService.getProfile(userId));
}
```

Controller **只负责**调 Service 并包一层 Result，不写 try-catch。

## Flutter 端将来怎么用

```dart
// 伪代码
if (response.code == 200) {
  use(response.data);
} else {
  showToast(response.message);
}
```

## 练习

1. 打开 `common/result/Result.java`，看 `ok` 和 `fail` 方法
2. 用 Postman 访问 `GET /api/health`，观察返回结构
3. 访问需登录接口但不带 Token，观察 `code: 401`
