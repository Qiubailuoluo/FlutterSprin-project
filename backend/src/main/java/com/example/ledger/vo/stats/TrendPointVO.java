package com.example.ledger.vo.stats;

import lombok.Builder;
import lombok.Data;

/**
 * 趋势图月度点（折线）。
 */
@Data
@Builder
public class TrendPointVO {

    private Integer year;
    private Integer month;
    private String income;
    private String expense;
}
