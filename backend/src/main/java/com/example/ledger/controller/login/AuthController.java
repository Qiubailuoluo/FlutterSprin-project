package com.example.ledger.controller.login;

import com.example.ledger.common.result.Result;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.dto.login.LoginDTO;
import com.example.ledger.dto.login.RegisterDTO;
import com.example.ledger.service.login.AuthService;
import com.example.ledger.vo.login.LoginVO;
import com.example.ledger.vo.login.RegisterVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 认证接口：注册、登录、退出。
 *
 * @see docs/api/auth.md
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /** 用户注册 */
    @PostMapping("/register")
    public Result<RegisterVO> register(@Valid @RequestBody RegisterDTO dto) {
        return Result.ok(authService.register(dto));
    }

    /** 用户登录，返回 JWT Token */
    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO dto) {
        return Result.ok(authService.login(dto));
    }

    /** 退出登录，清除 Redis 中的 Token */
    @PostMapping("/logout")
    public Result<Void> logout() {
        Long userId = SecurityUtils.getUserId();
        if (userId != null) {
            authService.logout(userId);
        }
        return Result.ok();
    }
}
