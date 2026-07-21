package com.example.ledger.service.user;

import com.example.ledger.dto.user.NicknameUpdateDTO;
import com.example.ledger.dto.user.PasswordUpdateDTO;
import com.example.ledger.entity.user.User;
import com.example.ledger.vo.user.UserProfileVO;

/**
 * 用户业务接口。
 */
public interface UserService {

    User findByUsername(String username);

    User findById(Long id);

    UserProfileVO getProfile(Long userId);

    UserProfileVO updateNickname(Long userId, NicknameUpdateDTO dto);

    /** 修改密码成功后会使当前会话失效，需重新登录。 */
    void updatePassword(Long userId, PasswordUpdateDTO dto);
}
