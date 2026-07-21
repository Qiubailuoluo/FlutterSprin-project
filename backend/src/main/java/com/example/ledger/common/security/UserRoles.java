package com.example.ledger.common.security;

/**
 * 用户角色常量（对应 user.role）。
 */
public final class UserRoles {

    private UserRoles() {
    }

    /** 普通用户 */
    public static final int USER = 1;

    /** 管理员 */
    public static final int ADMIN = 2;

    public static boolean isAdmin(Integer role) {
        return role != null && role == ADMIN;
    }
}
