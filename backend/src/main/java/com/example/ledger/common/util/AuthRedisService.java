package com.example.ledger.common.util;

import com.example.ledger.common.constant.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * 登录 Token 的 Redis 存取。
 * <p>
 * 为什么登录后还要写 Redis？仅靠 JWT 无法「主动退出」——Token 在过期前始终有效。
 * 将 Token 存 Redis 后，退出时删除 key，过滤器校验时发现 Redis 无 Token 即视为未登录。
 * </p>
 *
 * <p>Key 格式：{@code auth:token:{userId}}，TTL 与 JWT 过期时间一致。</p>
 *
 * @see docs/learn/05-redis.md
 */
@Component
@RequiredArgsConstructor
public class AuthRedisService {

    private final StringRedisTemplate stringRedisTemplate;

    /**
     * 登录成功：写入 Token，并设置过期时间（毫秒）。
     * 同一用户再次登录会覆盖旧 Token，实现「单端登录」效果。
     */
    public void saveToken(Long userId, String token, long ttlMs) {
        stringRedisTemplate.opsForValue().set(
                RedisKeyConstants.authToken(userId),
                token,
                ttlMs,
                TimeUnit.MILLISECONDS
        );
    }

    /**
     * 请求鉴权：Redis 中的 Token 必须与请求携带的一致。
     * 退出后 key 被删，此处返回 false，过滤器不会设置登录态。
     */
    public boolean isTokenValid(Long userId, String token) {
        String stored = stringRedisTemplate.opsForValue().get(RedisKeyConstants.authToken(userId));
        return token != null && token.equals(stored);
    }

    /** 退出登录：删除 key，Token 立即失效（对本系统而言） */
    public void removeToken(Long userId) {
        stringRedisTemplate.delete(RedisKeyConstants.authToken(userId));
    }
}
