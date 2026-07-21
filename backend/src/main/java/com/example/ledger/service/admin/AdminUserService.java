package com.example.ledger.service.admin;

import com.example.ledger.dto.admin.UserStatusUpdateDTO;
import com.example.ledger.vo.admin.AdminUserVO;

import java.util.List;

/**
 * 管理员：用户账户管理。
 */
public interface AdminUserService {

    List<AdminUserVO> listUsers(Long operatorId);

    AdminUserVO updateStatus(Long operatorId, Long targetUserId, UserStatusUpdateDTO dto);
}
