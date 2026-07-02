package com.example.ledger.common.constant;

public final class RedisKeyConstants {

    private RedisKeyConstants() {
    }

    public static final String AUTH_TOKEN_PREFIX = "auth:token:";
    public static final String STATS_MONTH_PREFIX = "stats:user:";

    public static String authToken(Long userId) {
        return AUTH_TOKEN_PREFIX + userId;
    }

    public static String statsMonth(Long userId, int year, int month) {
        return STATS_MONTH_PREFIX + userId + ":month:" + year + "-" + String.format("%02d", month);
    }
}
