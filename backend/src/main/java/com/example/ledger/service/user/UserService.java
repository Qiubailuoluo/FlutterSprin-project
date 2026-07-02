package com.example.ledger.service.user;

import com.example.ledger.entity.user.User;
import com.example.ledger.vo.user.UserProfileVO;

/**
 * 用户业务接口。
 */
public interface UserService {

    User findByUsername(String username);

    User findById(Long id);

    UserProfileVO getProfile(Long userId);
}
