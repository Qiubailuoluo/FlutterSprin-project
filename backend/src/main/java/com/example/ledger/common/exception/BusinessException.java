package com.example.ledger.common.exception;

import com.example.ledger.common.result.ResultCode;
import lombok.Getter;

/**
 * 业务异常：Service 层主动抛出，由全局异常处理器转为统一 {@link com.example.ledger.common.result.Result}。
 * <p>
 * 用法：{@code throw new BusinessException(ResultCode.BAD_REQUEST, "用户名已存在");}
 * 不要在 Controller 里 try-catch，直接抛出即可。
 * </p>
 *
 * @see GlobalExceptionHandler
 * @see docs/learn/03-global-exception.md
 */
@Getter
public class BusinessException extends RuntimeException {

    /** 返回给前端的业务错误码 */
    private final int code;

    public BusinessException(ResultCode resultCode) {
        super(resultCode.getMessage());
        this.code = resultCode.getCode();
    }

    public BusinessException(ResultCode resultCode, String message) {
        super(message);
        this.code = resultCode.getCode();
    }

    public BusinessException(int code, String message) {
        super(message);
        this.code = code;
    }
}
