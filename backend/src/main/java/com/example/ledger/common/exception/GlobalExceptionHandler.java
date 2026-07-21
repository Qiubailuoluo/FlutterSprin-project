package com.example.ledger.common.exception;

import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.util.ErrorIds;
import com.example.ledger.common.web.RequestIdFilter;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException;

/**
 * 全局异常处理器。
 * <p>
 * {@code @RestControllerAdvice} 会拦截所有 Controller 抛出的异常，
 * 统一转成 {@link Result} JSON，避免每个接口各自处理异常。
 * </p>
 *
 * <p>处理顺序（Spring 会匹配最具体的异常类型）：</p>
 * <ol>
 *   <li>{@link BusinessException} — 业务错误，如用户名重复、无权限</li>
 *   <li>参数校验异常 — {@code @Valid} 校验失败时触发</li>
 *   <li>{@link NoResourceFoundException} — 静态资源不存在（如 favicon）</li>
 *   <li>{@link Exception} — 兜底，记录日志并返回 500 + errorId</li>
 * </ol>
 *
 * @see docs/learn/03-global-exception.md
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /** 业务异常：Service 中 throw new BusinessException(...) */
    @ExceptionHandler(BusinessException.class)
    public Result<Void> handleBusinessException(BusinessException e) {
        log.warn("业务异常 code={} msg={} requestId={}",
                e.getCode(), e.getMessage(), currentRequestId());
        return Result.fail(e.getCode(), e.getMessage());
    }

    /**
     * 参数校验异常：DTO 上 @NotBlank、@Size 等校验失败时，
     * Spring 在进入 Controller 方法体之前就会抛出这些异常。
     */
    @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
    public Result<Void> handleValidationException(Exception e) {
        String message = ResultCode.BAD_REQUEST.getMessage();
        if (e instanceof MethodArgumentNotValidException ex && ex.getBindingResult().getFieldError() != null) {
            message = ex.getBindingResult().getFieldError().getDefaultMessage();
        } else if (e instanceof BindException ex && ex.getBindingResult().getFieldError() != null) {
            message = ex.getBindingResult().getFieldError().getDefaultMessage();
        }
        return Result.fail(ResultCode.BAD_REQUEST, message);
    }

    /** 浏览器访问根路径时会自动请求 favicon.ico，没有该文件时不应打 500 日志 */
    @ExceptionHandler(NoResourceFoundException.class)
    public Result<Void> handleNoResourceFound(NoResourceFoundException e) {
        return Result.fail(ResultCode.NOT_FOUND);
    }

    /**
     * 未预料的异常：记录完整堆栈，对外只返回固定文案 + errorId（= requestId）。
     */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e) {
        String errorId = currentRequestId();
        if (errorId == null || errorId.isBlank()) {
            errorId = ErrorIds.newId();
        }
        log.error("未处理异常 errorId={}", errorId, e);
        return Result.fail(
                ResultCode.INTERNAL_ERROR,
                ResultCode.INTERNAL_ERROR.getMessage(),
                errorId
        );
    }

    private static String currentRequestId() {
        return MDC.get(RequestIdFilter.MDC_REQUEST_ID);
    }
}
