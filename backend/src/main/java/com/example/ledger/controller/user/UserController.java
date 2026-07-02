package com.example.ledger.controller.user;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.service.user.UserService;
import com.example.ledger.vo.user.UserProfileVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 用户信息接口。
 *
 * @see docs/api/auth.md
 */
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /** 获取当前登录用户资料 */
    @GetMapping("/profile")
    public Result<UserProfileVO> profile() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return Result.ok(userService.getProfile(userId));
    }
}
