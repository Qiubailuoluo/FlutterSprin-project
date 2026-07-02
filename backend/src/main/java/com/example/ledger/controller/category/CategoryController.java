package com.example.ledger.controller.category;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.dto.category.CategoryCreateDTO;
import com.example.ledger.service.category.CategoryService;
import com.example.ledger.vo.category.CategoryVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 分类接口：系统预设 + 用户自定义。
 *
 * @see docs/api/category.md
 */
@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    /**
     * 分类列表（系统预设 + 当前用户自定义）
     */
    @GetMapping
    public Result<List<CategoryVO>> list(@RequestParam(required = false) Integer type) {
        Long userId = requireUserId();
        return Result.ok(categoryService.list(userId, type));
    }

    /**
     * 新增用户自定义分类
     */
    @PostMapping
    public Result<CategoryVO> create(@Valid @RequestBody CategoryCreateDTO dto) {
        Long userId = requireUserId();
        return Result.ok(categoryService.create(userId, dto));
    }

    /**
     * 删除用户自定义分类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        Long userId = requireUserId();
        categoryService.delete(userId, id);
        return Result.ok();
    }

    private Long requireUserId() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return userId;
    }
}
