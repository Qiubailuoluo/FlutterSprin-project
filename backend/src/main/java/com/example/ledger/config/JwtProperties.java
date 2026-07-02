package com.example.ledger.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * JWT 配置项，对应 application.yml 中 jwt 节点。
 */
@Data
@Component
@ConfigurationProperties(prefix = "jwt")
public class JwtProperties {

    /** 签名密钥，生产环境务必更换 */
    private String secret;

    /** Token 有效期（毫秒），默认 1 天 */
    private long expirationMs = 86400000L;
}
