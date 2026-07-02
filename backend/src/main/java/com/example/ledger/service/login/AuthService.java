package com.example.ledger.service.login;

import com.example.ledger.dto.login.LoginDTO;
import com.example.ledger.dto.login.RegisterDTO;
import com.example.ledger.vo.login.LoginVO;
import com.example.ledger.vo.login.RegisterVO;

/**
 * 认证业务接口：注册、登录、退出。
 */
public interface AuthService {

    RegisterVO register(RegisterDTO dto);

    LoginVO login(LoginDTO dto);

    void logout(Long userId);
}
