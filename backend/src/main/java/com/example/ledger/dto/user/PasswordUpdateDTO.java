package com.example.ledger.dto.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 修改当前用户密码（须校验旧密码）。
 */
@Data
public class PasswordUpdateDTO {

    @NotBlank(message = "旧密码不能为空")
    @Size(min = 6, max = 32, message = "密码长度为 6~32 字符")
    private String oldPassword;

    @NotBlank(message = "新密码不能为空")
    @Size(min = 6, max = 32, message = "密码长度为 6~32 字符")
    private String newPassword;
}
