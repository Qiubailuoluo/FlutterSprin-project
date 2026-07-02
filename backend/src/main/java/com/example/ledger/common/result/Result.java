package com.example.ledger.common.result;

import lombok.Data;

/**
 * 统一 API 响应包装类。
 * <p>
 * 前端/Flutter 只需判断 {@code code == 200} 即表示业务成功，
 * 具体数据从 {@code data} 字段读取。这样所有接口格式一致，便于封装网络层。
 * </p>
 *
 * <pre>
 * 成功：{ "code": 200, "message": "success", "data": { ... } }
 * 失败：{ "code": 400, "message": "参数错误", "data": null }
 * </pre>
 *
 * @param <T> data 字段的类型，如 BillVO、List 等
 * @see ResultCode
 * @see docs/learn/02-unified-response.md
 */
@Data
public class Result<T> {

    /** 业务状态码，200 表示成功 */
    private int code;
    /** 提示信息，失败时给前端展示 */
    private String message;
    /** 业务数据，失败时通常为 null */
    private T data;

    private Result(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    /** 成功并返回数据 */
    public static <T> Result<T> ok(T data) {
        return new Result<>(ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), data);
    }

    /** 成功且无数据（如删除、退出） */
    public static <T> Result<T> ok() {
        return ok(null);
    }

    /** 失败，使用预定义错误码的默认文案 */
    public static <T> Result<T> fail(ResultCode resultCode) {
        return new Result<>(resultCode.getCode(), resultCode.getMessage(), null);
    }

    /** 失败，使用预定义错误码但自定义文案（如「用户名已存在」） */
    public static <T> Result<T> fail(ResultCode resultCode, String message) {
        return new Result<>(resultCode.getCode(), message, null);
    }

    /** 失败，完全自定义 code 与 message */
    public static <T> Result<T> fail(int code, String message) {
        return new Result<>(code, message, null);
    }
}
