package com.example.ledger.service.member;

import com.example.ledger.dto.member.MemberCreateDTO;
import com.example.ledger.vo.member.MemberVO;

import java.util.List;

/**
 * 家庭成员业务。
 */
public interface MemberService {

    List<MemberVO> list(Long userId);

    MemberVO create(Long userId, MemberCreateDTO dto);

    void delete(Long userId, Long memberId);

    /** 校验成员属于当前用户，返回实体或抛错 */
    void requireOwned(Long userId, Long memberId);
}
