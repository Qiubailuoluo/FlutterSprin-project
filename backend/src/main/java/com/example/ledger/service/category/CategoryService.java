package com.example.ledger.service.category;

import com.example.ledger.dto.category.CategoryCreateDTO;
import com.example.ledger.vo.category.CategoryVO;

import java.util.List;

/**
 * 分类业务接口：系统预设 + 用户自定义。
 */
public interface CategoryService {

    /**
     * 查询当前用户可见分类（系统预设 + 自己的自定义）。
     *
     * @param userId 当前用户 ID
     * @param type   可选，1 收入 / 2 支出
     */
    List<CategoryVO> list(Long userId, Integer type);

    /** 新增用户自定义分类 */
    CategoryVO create(Long userId, CategoryCreateDTO dto);

    /** 删除用户自定义分类 */
    void delete(Long userId, Long categoryId);
}
