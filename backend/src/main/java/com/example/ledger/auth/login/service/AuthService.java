package com.example.ledger.auth.login.service;

import com.example.ledger.auth.login.dto.LoginDTO;
import com.example.ledger.auth.login.dto.RegisterDTO;
import com.example.ledger.auth.login.vo.LoginVO;
import com.example.ledger.auth.login.vo.RegisterVO;

/**
 * 认证业务接口：注册、登录、退出。
 */
public interface AuthService {

    RegisterVO register(RegisterDTO dto);

    LoginVO login(LoginDTO dto);

    void logout(Long userId);
}
