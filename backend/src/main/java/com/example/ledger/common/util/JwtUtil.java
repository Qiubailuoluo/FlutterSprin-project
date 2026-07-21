package com.example.ledger.common.util;

import com.example.ledger.common.security.UserRoles;
import com.example.ledger.config.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * JWT（JSON Web Token）签发与解析工具。
 * <p>
 * JWT 由三部分组成：Header.Payload.Signature，登录成功后返回给前端，
 * 前端后续请求在 Header 中携带：{@code Authorization: Bearer {token}}。
 * </p>
 * <ul>
 *   <li>subject：存 userId</li>
 *   <li>claim username：存用户名，减少查库</li>
 *   <li>expiration：过期时间，本项目为 1 天</li>
 * </ul>
 *
 * @see docs/learn/04-login-jwt.md
 */
@Component
public class JwtUtil {

    private final JwtProperties jwtProperties;
    private final SecretKey secretKey;

    public JwtUtil(JwtProperties jwtProperties) {
        this.jwtProperties = jwtProperties;
        // 使用配置的 secret 生成 HMAC 签名密钥
        this.secretKey = Keys.hmacShaKeyFor(jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8));
    }

    /**
     * 签发 Token。Payload 中的 sub=userId，自定义 claim 存 username、role。
     */
    public String generateToken(Long userId, String username, Integer role) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + jwtProperties.getExpirationMs());
        return Jwts.builder()
                .subject(String.valueOf(userId))
                .claim("username", username)
                .claim("role", role == null ? UserRoles.USER : role)
                .issuedAt(now)
                .expiration(expiry)
                .signWith(secretKey)
                .compact();
    }

    /** 解析并验签 Token，过期或篡改会抛异常 */
    public Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public Long getUserId(Claims claims) {
        return Long.parseLong(claims.getSubject());
    }

    public long getExpirationSeconds() {
        return jwtProperties.getExpirationMs() / 1000;
    }
}
