package com.example.ledger.controller.admin;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.dto.admin.UserStatusUpdateDTO;
import com.example.ledger.service.admin.AdminUserService;
import com.example.ledger.vo.admin.AdminUserVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 管理员：账户管理。
 *
 * @see docs/api/admin-users.md
 */
@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
public class AdminUserController {

    private final AdminUserService adminUserService;

    /** 全部用户列表 */
    @GetMapping
    public Result<List<AdminUserVO>> list() {
        return Result.ok(adminUserService.listUsers(requireUserId()));
    }

    /**
     * 封禁 / 解封：status=0 禁用，status=1 恢复。
     */
    @PutMapping("/{id}/status")
    public Result<AdminUserVO> updateStatus(@PathVariable Long id,
                                            @Valid @RequestBody UserStatusUpdateDTO dto) {
        return Result.ok(adminUserService.updateStatus(requireUserId(), id, dto));
    }

    private Long requireUserId() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return userId;
    }
}
