package com.example.ledger.vo.stats;

import lombok.Builder;
import lombok.Data;

/**
 * 月度统计响应。
 */
@Data
@Builder
public class MonthStatsVO {

    private Integer year;
    private Integer month;
    /** 当月收入合计 */
    private String income;
    /** 当月支出合计 */
    private String expense;
    /** 结余 = income - expense */
    private String balance;
}
