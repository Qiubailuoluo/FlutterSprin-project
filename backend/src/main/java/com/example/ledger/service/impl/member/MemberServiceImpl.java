package com.example.ledger.service.impl.member;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.dto.member.MemberCreateDTO;
import com.example.ledger.entity.member.FamilyMember;
import com.example.ledger.mapper.member.FamilyMemberMapper;
import com.example.ledger.service.member.MemberService;
import com.example.ledger.vo.member.MemberVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 家庭成员 CRUD。
 *
 * @see docs/api/member.md
 */
@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final FamilyMemberMapper familyMemberMapper;

    @Override
    public List<MemberVO> list(Long userId) {
        return familyMemberMapper.selectList(new LambdaQueryWrapper<FamilyMember>()
                        .eq(FamilyMember::getUserId, userId)
                        .orderByAsc(FamilyMember::getId))
                .stream()
                .map(this::toVO)
                .toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public MemberVO create(Long userId, MemberCreateDTO dto) {
        FamilyMember member = new FamilyMember();
        member.setUserId(userId);
        member.setName(dto.getName().trim());
        familyMemberMapper.insert(member);
        member = familyMemberMapper.selectById(member.getId());
        return toVO(member);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long userId, Long memberId) {
        requireOwned(userId, memberId);
        familyMemberMapper.deleteById(memberId);
    }

    @Override
    public void requireOwned(Long userId, Long memberId) {
        FamilyMember member = familyMemberMapper.selectById(memberId);
        if (member == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "成员不存在");
        }
        if (!member.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.FORBIDDEN, "无权操作该成员");
        }
    }

    private MemberVO toVO(FamilyMember member) {
        return MemberVO.builder()
                .id(member.getId())
                .name(member.getName())
                .createdAt(member.getCreatedAt())
                .build();
    }
}
