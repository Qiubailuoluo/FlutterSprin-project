package com.example.ledger.dto.bill;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 更新账单请求体，字段均为可选（传则更新）。
 */
@Data
public class BillUpdateDTO {

    private Long categoryId;

    @Min(value = 1, message = "类型仅支持 1 收入或 2 支出")
    @Max(value = 2, message = "类型仅支持 1 收入或 2 支出")
    private Integer type;

    @DecimalMin(value = "0.01", message = "金额必须大于 0")
    private BigDecimal amount;

    private LocalDate billDate;

    @Size(max = 255, message = "备注最长 255 字符")
    private String remark;
}
