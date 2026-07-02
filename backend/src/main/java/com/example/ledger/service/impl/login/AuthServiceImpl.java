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
 * 认证业务实现：BCrypt 密码、JWT 签发、Redis Token 存储。
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

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RegisterVO register(RegisterDTO dto) {
        if (userService.findByUsername(dto.getUsername()) != null) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "用户名已存在");
        }
        User user = new User();
        user.setUsername(dto.getUsername());
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

    @Override
    public LoginVO login(LoginDTO dto) {
        User user = userService.findByUsername(dto.getUsername());
        if (user == null || !passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
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

    @Override
    public void logout(Long userId) {
        authRedisService.removeToken(userId);
    }
}
