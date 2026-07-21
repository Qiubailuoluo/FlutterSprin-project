package com.example.ledger.vo.user;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 当前用户资料响应。
 */
@Data
@Builder
public class UserProfileVO {

    private Long userId;
    private String username;
    private String nickname;
    /** 1 正常，0 禁用 */
    private Integer status;
    /** 1 普通用户，2 管理员 */
    private Integer role;
    private LocalDateTime createdAt;
}
