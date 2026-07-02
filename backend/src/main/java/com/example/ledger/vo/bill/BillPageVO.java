package com.example.ledger.vo.bill;

import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * 账单分页响应。
 */
@Data
@Builder
public class BillPageVO {

    private Long total;
    private Long page;
    private Long size;
    private List<BillVO> records;
}
