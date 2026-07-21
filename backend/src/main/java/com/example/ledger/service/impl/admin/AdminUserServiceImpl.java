package com.example.ledger.service.impl.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.UserRoles;
import com.example.ledger.common.util.AuthRedisService;
import com.example.ledger.dto.admin.UserStatusUpdateDTO;
import com.example.ledger.entity.user.User;
import com.example.ledger.mapper.user.UserMapper;
import com.example.ledger.service.admin.AdminUserService;
import com.example.ledger.service.user.UserService;
import com.example.ledger.vo.admin.AdminUserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 管理员用户管理：列表、封禁/解封。
 */
@Service
@RequiredArgsConstructor
public class AdminUserServiceImpl implements AdminUserService {

    private final UserMapper userMapper;
    private final UserService userService;
    private final AuthRedisService authRedisService;

    @Override
    public List<AdminUserVO> listUsers(Long operatorId) {
        requireAdmin(operatorId);
        return userMapper.selectList(new LambdaQueryWrapper<User>()
                        .orderByAsc(User::getId))
                .stream()
                .map(this::toVo)
                .toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AdminUserVO updateStatus(Long operatorId, Long targetUserId, UserStatusUpdateDTO dto) {
        requireAdmin(operatorId);
        if (operatorId.equals(targetUserId)) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "不能修改自己的账号状态");
        }
        User target = userService.findById(targetUserId);
        if (target == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }
        target.setStatus(dto.getStatus());
        userMapper.updateById(target);
        // 封禁后踢下线，已签发 Token 立即失效
        if (dto.getStatus() != null && dto.getStatus() == 0) {
            authRedisService.removeToken(targetUserId);
        }
        return toVo(userMapper.selectById(targetUserId));
    }

    private void requireAdmin(Long operatorId) {
        User operator = userService.findById(operatorId);
        if (operator == null || !UserRoles.isAdmin(operator.getRole())) {
            throw new BusinessException(ResultCode.FORBIDDEN, "需要管理员权限");
        }
        if (operator.getStatus() != null && operator.getStatus() == 0) {
            throw new BusinessException(ResultCode.FORBIDDEN, "账号已禁用");
        }
    }

    private AdminUserVO toVo(User user) {
        return AdminUserVO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .status(user.getStatus())
                .role(user.getRole() == null ? UserRoles.USER : user.getRole())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
