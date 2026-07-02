package com.example.ledger.service.impl.login;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.util.AuthRedisService;
import com.example.ledger.common.util.JwtUtil;
import com.example.ledger.config.JwtProperties;
import com.example.ledger.dto.login.LoginDTO;
import com.example.ledger.dto.login.RegisterDTO;
import com.example.ledger.entity.user.User;
import com.example.ledger.mapper.user.UserMapper;
import com.example.ledger.service.login.AuthService;
import com.example.ledger.service.user.UserService;
import com.example.ledger.vo.login.LoginVO;
import com.example.ledger.vo.login.RegisterVO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

/**
 * 认证业务实现：注册、登录、退出。
 * <p>
 * 登录流程：校验密码 → 签发 JWT → 写入 Redis（支持退出失效）。
 * 密码绝不存明文，使用 BCrypt 单向哈希。
 * </p>
 *
 * @see docs/learn/04-login-jwt.md
 * @see docs/learn/05-redis.md
 */
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserMapper userMapper;
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final JwtProperties jwtProperties;
    private final AuthRedisService authRedisService;

    /**
     * 注册：查重 → BCrypt 加密密码 → 插入 user 表。
     * {@code @Transactional} 保证插入失败时回滚。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public RegisterVO register(RegisterDTO dto) {
        if (userService.findByUsername(dto.getUsername()) != null) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "用户名已存在");
        }
        User user = new User();
        user.setUsername(dto.getUsername());
        // BCrypt 每次加密结果不同，但 matches() 可验证同一明文
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setNickname(StringUtils.hasText(dto.getNickname()) ? dto.getNickname() : dto.getUsername());
        user.setStatus(1);
        userMapper.insert(user);
        return RegisterVO.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .build();
    }

    /**
     * 登录：校验账号密码 → 生成 JWT → 存入 Redis。
     * Redis 中 Token 用于：退出时删除、请求时二次校验（防止 Token 被伪造后长期使用）。
     */
    @Override
    public LoginVO login(LoginDTO dto) {
        User user = userService.findByUsername(dto.getUsername());
        if (user == null || !passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            // 不明确提示「用户不存在」或「密码错误」，防止撞库
            throw new BusinessException(ResultCode.UNAUTHORIZED, "用户名或密码错误");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BusinessException(ResultCode.FORBIDDEN, "账号已禁用");
        }
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        authRedisService.saveToken(user.getId(), token, jwtProperties.getExpirationMs());
        return LoginVO.builder()
                .token(token)
                .expiresIn(jwtUtil.getExpirationSeconds())
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .build();
    }

    /** 退出：仅删除 Redis 中的 Token，JWT 本身仍会过期但无法再访问接口 */
    @Override
    public void logout(Long userId) {
        authRedisService.removeToken(userId);
    }
}
