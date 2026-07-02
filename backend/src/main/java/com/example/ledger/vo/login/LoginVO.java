package com.example.ledger.vo.login;

import lombok.Builder;
import lombok.Data;

/**
 * 登录成功响应，包含 JWT Token。
 */
@Data
@Builder
public class LoginVO {

    private String token;
    /** 过期时间（秒） */
    private Long expiresIn;
    private Long userId;
    private String username;
    private String nickname;
}
