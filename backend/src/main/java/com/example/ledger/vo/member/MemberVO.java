package com.example.ledger.vo.member;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 家庭成员响应。
 */
@Data
@Builder
public class MemberVO {

    private Long id;
    private String name;
    private LocalDateTime createdAt;
}
