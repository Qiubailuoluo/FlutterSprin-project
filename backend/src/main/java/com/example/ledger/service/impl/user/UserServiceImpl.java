package com.example.ledger.service.impl.user;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.UserRoles;
import com.example.ledger.common.util.AuthRedisService;
import com.example.ledger.dto.user.NicknameUpdateDTO;
import com.example.ledger.dto.user.PasswordUpdateDTO;
import com.example.ledger.entity.user.User;
import com.example.ledger.mapper.user.UserMapper;
import com.example.ledger.service.user.UserService;
import com.example.ledger.vo.user.UserProfileVO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户业务实现。
 */
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final AuthRedisService authRedisService;

    @Override
    public User findByUsername(String username) {
        return userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, username));
    }

    @Override
    public User findById(Long id) {
        return userMapper.selectById(id);
    }

    @Override
    public UserProfileVO getProfile(Long userId) {
        return toProfile(requireUser(userId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserProfileVO updateNickname(Long userId, NicknameUpdateDTO dto) {
        User user = requireUser(userId);
        user.setNickname(dto.getNickname().trim());
        userMapper.updateById(user);
        return toProfile(userMapper.selectById(userId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePassword(Long userId, PasswordUpdateDTO dto) {
        User user = requireUser(userId);
        if (!passwordEncoder.matches(dto.getOldPassword(), user.getPassword())) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "旧密码不正确");
        }
        if (dto.getOldPassword().equals(dto.getNewPassword())) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "新密码不能与旧密码相同");
        }
        user.setPassword(passwordEncoder.encode(dto.getNewPassword()));
        userMapper.updateById(user);
        // 改密后踢下线，强制重新登录
        authRedisService.removeToken(userId);
    }

    private User requireUser(Long userId) {
        User user = findById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }
        return user;
    }

    private UserProfileVO toProfile(User user) {
        return UserProfileVO.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .status(user.getStatus())
                .role(user.getRole() == null ? UserRoles.USER : user.getRole())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
