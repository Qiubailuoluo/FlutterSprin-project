package com.example.ledger.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.user.entity.User;
import com.example.ledger.user.mapper.UserMapper;
import com.example.ledger.user.service.UserService;
import com.example.ledger.user.vo.UserProfileVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 用户业务实现。
 */
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;

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
        User user = findById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }
        return UserProfileVO.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
