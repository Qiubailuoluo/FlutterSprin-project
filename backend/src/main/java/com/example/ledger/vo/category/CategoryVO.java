package com.example.ledger.vo.category;

import lombok.Builder;
import lombok.Data;

/**
 * 分类列表/详情响应。
 */
@Data
@Builder
public class CategoryVO {

    private Long id;
    private String name;
    /** 1 收入，2 支出 */
    private Integer type;
    /** true=系统预设，false=用户自定义 */
    private Boolean system;
    private Integer sortOrder;
}
