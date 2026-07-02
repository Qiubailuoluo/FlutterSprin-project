package com.example.ledger.user.service;

import com.example.ledger.user.entity.User;
import com.example.ledger.user.vo.UserProfileVO;

/**
 * 用户业务接口。
 */
public interface UserService {

    User findByUsername(String username);

    User findById(Long id);

    UserProfileVO getProfile(Long userId);
}
