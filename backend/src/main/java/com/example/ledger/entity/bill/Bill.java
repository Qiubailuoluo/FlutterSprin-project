package com.example.ledger.entity.bill;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 账单表实体，对应表 {@code bill}。
 */
@Data
@TableName("bill")
public class Bill {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long categoryId;

    /** 家庭成员，可空 */
    private Long memberId;

    /** 1 收入，2 支出 */
    private Integer type;

    private BigDecimal amount;

    private LocalDate billDate;

    private String remark;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
