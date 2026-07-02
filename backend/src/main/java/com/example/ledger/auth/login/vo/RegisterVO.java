package com.example.ledger.auth.login.vo;

import lombok.Builder;
import lombok.Data;

/**
 * 注册成功响应。
 */
@Data
@Builder
public class RegisterVO {

    private Long userId;
    private String username;
    private String nickname;
}
