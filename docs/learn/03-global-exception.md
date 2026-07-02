# 03 - 全局异常处理

## 问题：每个接口自己 try-catch

```java
// ❌ 不推荐
@PostMapping("/register")
public Result<?> register(...) {
    try {
        ...
    } catch (Exception e) {
        return Result.fail(500, e.getMessage());
    }
}
```

重复代码多，且容易漏掉某些异常。

## 解决方案

1. **Service 抛业务异常**：`throw new BusinessException(ResultCode.BAD_REQUEST, "用户名已存在");`
2. **全局处理器捕获**：`@RestControllerAdvice` + `@ExceptionHandler`
3. **统一转成 Result** 返回给前端

## 源码解读

### BusinessException

- 继承 `RuntimeException`，不用强制 throws
- 携带 `code` 字段，对应 Result 的 code

### GlobalExceptionHandler

| 异常类型 | 何时触发 | 返回 |
|----------|----------|------|
| BusinessException | Service 主动 throw | 自定义 message |
| MethodArgumentNotValidException | @Valid 校验失败 | 字段上的 message |
| Exception | 其它未捕获错误 | 500，并打日志 |

### 参数校验示例

`RegisterDTO` 上：

```java
@NotBlank(message = "用户名不能为空")
@Size(min = 3, max = 64, message = "用户名长度为 3~64 字符")
private String username;
```

Controller 方法参数加 `@Valid`，校验失败**不会进入方法体**，直接被 `GlobalExceptionHandler` 处理。

## 请求流程图

```
Controller 调用 Service
    → Service throw BusinessException
    → GlobalExceptionHandler.handleBusinessException()
    → 返回 { "code": 400, "message": "用户名已存在" }
```

## 练习

1. 注册时故意传空用户名，看返回的 message
2. 在 `AuthServiceImpl` 找到 `throw new BusinessException` 的几处，理解何时该用 400 / 401 / 403
3. 阅读 `GlobalExceptionHandler` 每个 `@ExceptionHandler` 方法
