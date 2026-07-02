package com.example.ledger.common.security;

import com.example.ledger.common.util.AuthRedisService;
import com.example.ledger.common.util.JwtUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * JWT 认证过滤器（在 Spring Security 过滤器链中运行）。
 * <p>
 * 每个 HTTP 请求都会经过此过滤器，流程：
 * </p>
 * <ol>
 *   <li>从 Header {@code Authorization: Bearer xxx} 取出 Token</li>
 *   <li>解析 JWT，得到 userId、username</li>
 *   <li>检查 Redis 中 Token 是否仍存在（未退出）</li>
 *   <li>将用户信息放入 {@link SecurityContextHolder}，供后续 Controller 使用</li>
 * </ol>
 *
 * @see SecurityConfig
 * @see docs/learn/04-login-jwt.md
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final AuthRedisService authRedisService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String token = resolveToken(request);
        if (StringUtils.hasText(token)) {
            try {
                Claims claims = jwtUtil.parseToken(token);
                Long userId = jwtUtil.getUserId(claims);
                String username = claims.get("username", String.class);
                // 必须 JWT 有效且 Redis 中存在，才算已登录
                if (authRedisService.isTokenValid(userId, token)) {
                    LoginUser loginUser = new LoginUser(userId, username);
                    UsernamePasswordAuthenticationToken authentication =
                            new UsernamePasswordAuthenticationToken(loginUser, null, loginUser.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
            } catch (Exception ignored) {
                // Token 无效时不设置认证信息，后续 Security 会返回 401
                SecurityContextHolder.clearContext();
            }
        }
        // 无论是否登录，都继续执行后续过滤器与 Controller
        filterChain.doFilter(request, response);
    }

    /** 解析 Authorization 头，格式必须为 Bearer {token} */
    private String resolveToken(HttpServletRequest request) {
        String bearer = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (StringUtils.hasText(bearer) && bearer.startsWith("Bearer ")) {
            return bearer.substring(7);
        }
        return null;
    }
}
