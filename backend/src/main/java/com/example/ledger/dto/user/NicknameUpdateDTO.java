package com.example.ledger.dto.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 更新当前用户昵称。
 */
@Data
public class NicknameUpdateDTO {

    @NotBlank(message = "昵称不能为空")
    @Size(min = 1, max = 64, message = "昵称长度为 1~64 字符")
    private String nickname;
}
