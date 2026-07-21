package com.example.ledger.dto.admin;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 更新用户状态：1 正常，0 禁用（封禁）。
 */
@Data
public class UserStatusUpdateDTO {

    @NotNull(message = "status 不能为空")
    @Min(value = 0, message = "status 只能为 0 或 1")
    @Max(value = 1, message = "status 只能为 0 或 1")
    private Integer status;
}
