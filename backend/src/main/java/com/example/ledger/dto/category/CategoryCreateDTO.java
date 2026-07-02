package com.example.ledger.dto.category;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 新增自定义分类请求体。
 */
@Data
public class CategoryCreateDTO {

    @NotBlank(message = "分类名不能为空")
    @Size(max = 64, message = "分类名最长 64 字符")
    private String name;

    @NotNull(message = "类型不能为空")
    @Min(value = 1, message = "类型仅支持 1 收入或 2 支出")
    @Max(value = 2, message = "类型仅支持 1 收入或 2 支出")
    private Integer type;
}
