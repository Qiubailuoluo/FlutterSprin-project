package com.example.ledger.vo.stats;

import lombok.Builder;
import lombok.Data;

/**
 * 按成员汇总（柱状图）。
 */
@Data
@Builder
public class MemberStatItemVO {

    /** null 表示未指定成员 */
    private Long memberId;
    private String memberName;
    private String income;
    private String expense;
}
