package com.example.ledger.common.util;

import com.example.ledger.common.constant.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * 认证相关 Redis 操作：Token 存取与校验。
 */
@Component
@RequiredArgsConstructor
public class AuthRedisService {

    private final StringRedisTemplate stringRedisTemplate;

    /**
     * 登录成功后保存 Token，TTL 与 JWT 一致。
     */
    public void saveToken(Long userId, String token, long ttlMs) {
        stringRedisTemplate.opsForValue().set(
                RedisKeyConstants.authToken(userId),
                token,
                ttlMs,
                TimeUnit.MILLISECONDS
        );
    }

    /** 校验 Redis 中 Token 是否与当前一致 */
    public boolean isTokenValid(Long userId, String token) {
        String stored = stringRedisTemplate.opsForValue().get(RedisKeyConstants.authToken(userId));
        return token != null && token.equals(stored);
    }

    /** 退出登录时删除 Token */
    public void removeToken(Long userId) {
        stringRedisTemplate.delete(RedisKeyConstants.authToken(userId));
    }
}
