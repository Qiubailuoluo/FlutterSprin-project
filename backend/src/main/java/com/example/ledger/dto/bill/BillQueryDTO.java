package com.example.ledger.dto.bill;

import lombok.Data;

import java.time.LocalDate;

/**
 * 账单分页查询参数。
 */
@Data
public class BillQueryDTO {

    private Integer page = 1;
    private Integer size = 20;
    private Integer type;
    private Long categoryId;
    private LocalDate startDate;
    private LocalDate endDate;
}
