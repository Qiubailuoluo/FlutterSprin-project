package com.example.ledger.mapper.category;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.ledger.entity.category.Category;
import org.apache.ibatis.annotations.Mapper;

/**
 * 分类表 Mapper。
 */
@Mapper
public interface CategoryMapper extends BaseMapper<Category> {
}
