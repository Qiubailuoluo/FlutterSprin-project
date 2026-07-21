package com.example.ledger.vo.stats;

import lombok.Builder;
import lombok.Data;

/**
 * 分类占比一项（饼图）。
 */
@Data
@Builder
public class CategoryShareItemVO {

    private Long categoryId;
    private String categoryName;
    /** 金额，两位小数 */
    private String amount;
    /** 占支出合计的比例 0~1 */
    private Double ratio;
}
