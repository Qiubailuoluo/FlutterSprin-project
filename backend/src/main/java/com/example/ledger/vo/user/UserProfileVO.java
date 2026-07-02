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
    private LocalDateTime createdAt;
}
