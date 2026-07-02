package com.example.ledger.vo.bill;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 账单响应。
 */
@Data
@Builder
public class BillVO {

    private Long id;
    private Long categoryId;
    private String categoryName;
    /** 1 收入，2 支出 */
    private Integer type;
    /** 金额字符串，保留两位小数 */
    private String amount;
    private LocalDate billDate;
    private String remark;
    private LocalDateTime createdAt;
}
