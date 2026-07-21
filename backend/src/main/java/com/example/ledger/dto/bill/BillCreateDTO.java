package com.example.ledger.dto.bill;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 新增账单请求体。
 */
@Data
public class BillCreateDTO {

    @NotNull(message = "分类不能为空")
    private Long categoryId;

    @NotNull(message = "类型不能为空")
    @Min(value = 1, message = "类型仅支持 1 收入或 2 支出")
    @Max(value = 2, message = "类型仅支持 1 收入或 2 支出")
    private Integer type;

    @NotNull(message = "金额不能为空")
    @DecimalMin(value = "0.01", message = "金额必须大于 0")
    private BigDecimal amount;

    @NotNull(message = "账单日期不能为空")
    private LocalDate billDate;

    /** 可选家庭成员 */
    private Long memberId;

    @Size(max = 255, message = "备注最长 255 字符")
    private String remark;
}
