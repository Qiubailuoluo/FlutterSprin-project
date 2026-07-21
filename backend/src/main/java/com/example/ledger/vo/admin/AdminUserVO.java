package com.example.ledger.vo.admin;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 管理员视角的用户列表项（不含密码）。
 */
@Data
@Builder
public class AdminUserVO {

    private Long id;
    private String username;
    private String nickname;
    /** 1 正常，0 禁用 */
    private Integer status;
    /** 1 普通，2 管理员 */
    private Integer role;
    private LocalDateTime createdAt;
}
