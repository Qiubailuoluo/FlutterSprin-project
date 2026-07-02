package com.example.ledger.entity.category;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 分类表实体，对应表 {@code category}。
 * userId 为 null 表示系统预设分类。
 */
@Data
@TableName("category")
public class Category {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** null = 系统预设 */
    private Long userId;

    private String name;

    /** 1 收入，2 支出 */
    private Integer type;

    private Integer sortOrder;

    private LocalDateTime createdAt;
}
