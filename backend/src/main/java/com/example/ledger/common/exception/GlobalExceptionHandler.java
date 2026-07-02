package com.example.ledger.common.exception;

import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public Result<Void> handleBusinessException(BusinessException e) {
        return Result.fail(e.getCode(), e.getMessage());
    }

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

    /** 浏览器自动请求 favicon，忽略即可 */
    @ExceptionHandler(NoResourceFoundException.class)
    public Result<Void> handleNoResourceFound(NoResourceFoundException e) {
        if (e.getMessage() != null && e.getMessage().contains("favicon.ico")) {
            return Result.fail(ResultCode.NOT_FOUND);
        }
        return Result.fail(ResultCode.NOT_FOUND, e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e) {
        log.error("未处理异常", e);
        return Result.fail(ResultCode.INTERNAL_ERROR);
    }
}
