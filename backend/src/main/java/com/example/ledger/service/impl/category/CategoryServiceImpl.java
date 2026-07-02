package com.example.ledger.service.impl.category;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.dto.category.CategoryCreateDTO;
import com.example.ledger.entity.category.Category;
import com.example.ledger.mapper.category.CategoryMapper;
import com.example.ledger.service.category.CategoryService;
import com.example.ledger.vo.category.CategoryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 分类业务实现。
 */
@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryMapper categoryMapper;

    @Override
    public List<CategoryVO> list(Long userId, Integer type) {
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.and(w -> w.isNull(Category::getUserId).or().eq(Category::getUserId, userId));
        if (type != null) {
            wrapper.eq(Category::getType, type);
        }
        wrapper.orderByAsc(Category::getSortOrder).orderByAsc(Category::getId);
        return categoryMapper.selectList(wrapper).stream()
                .map(this::toVO)
                .toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CategoryVO create(Long userId, CategoryCreateDTO dto) {
        if (existsByName(userId, dto.getName(), dto.getType())) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "该类型下分类名已存在");
        }
        Category category = new Category();
        category.setUserId(userId);
        category.setName(dto.getName());
        category.setType(dto.getType());
        category.setSortOrder(0);
        categoryMapper.insert(category);
        return toVO(category);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long userId, Long categoryId) {
        Category category = categoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "分类不存在");
        }
        if (category.getUserId() == null) {
            throw new BusinessException(ResultCode.FORBIDDEN, "不能删除系统预设分类");
        }
        if (!category.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.FORBIDDEN, "无权删除该分类");
        }
        categoryMapper.deleteById(categoryId);
    }

    @Override
    public Category requireAccessible(Long userId, Long categoryId) {
        Category category = categoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "分类不存在");
        }
        if (category.getUserId() != null && !category.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.FORBIDDEN, "无权使用该分类");
        }
        return category;
    }

    /** 检查用户可见范围内是否已有同名同类型分类 */
    private boolean existsByName(Long userId, String name, Integer type) {
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Category::getName, name)
                .eq(Category::getType, type)
                .and(w -> w.isNull(Category::getUserId).or().eq(Category::getUserId, userId));
        return categoryMapper.selectCount(wrapper) > 0;
    }

    private CategoryVO toVO(Category category) {
        return CategoryVO.builder()
                .id(category.getId())
                .name(category.getName())
                .type(category.getType())
                .system(category.getUserId() == null)
                .sortOrder(category.getSortOrder())
                .build();
    }
}
