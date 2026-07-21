package com.example.ledger.controller.user;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.dto.user.NicknameUpdateDTO;
import com.example.ledger.dto.user.PasswordUpdateDTO;
import com.example.ledger.service.user.UserService;
import com.example.ledger.vo.user.UserProfileVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
        return Result.ok(userService.getProfile(requireUserId()));
    }

    /** 更新当前用户昵称 */
    @PutMapping("/profile")
    public Result<UserProfileVO> updateProfile(@Valid @RequestBody NicknameUpdateDTO dto) {
        return Result.ok(userService.updateNickname(requireUserId(), dto));
    }

    /**
     * 修改当前用户密码。成功后当前 Token 失效，需重新登录。
     */
    @PutMapping("/password")
    public Result<Void> updatePassword(@Valid @RequestBody PasswordUpdateDTO dto) {
        userService.updatePassword(requireUserId(), dto);
        return Result.ok();
    }

    private Long requireUserId() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return userId;
    }
}
