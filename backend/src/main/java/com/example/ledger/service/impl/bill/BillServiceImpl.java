package com.example.ledger.service.impl.bill;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.util.StatsCacheService;
import com.example.ledger.dto.bill.BillCreateDTO;
import com.example.ledger.dto.bill.BillQueryDTO;
import com.example.ledger.dto.bill.BillUpdateDTO;
import com.example.ledger.entity.bill.Bill;
import com.example.ledger.entity.category.Category;
import com.example.ledger.mapper.bill.BillMapper;
import com.example.ledger.mapper.category.CategoryMapper;
import com.example.ledger.service.bill.BillService;
import com.example.ledger.service.category.CategoryService;
import com.example.ledger.vo.bill.BillPageVO;
import com.example.ledger.vo.bill.BillVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 账单业务实现（标准 CRUD + 分页 + 关联查询示例）。
 * <p>
 * 学习要点：
 * </p>
 * <ul>
 *   <li>Create：校验分类 → insert → 清除统计缓存</li>
 *   <li>Read：MyBatis-Plus 分页 + 批量查分类名</li>
 *   <li>Update：校验归属权 → 部分字段更新 → 缓存失效</li>
 *   <li>Delete：校验归属权 → delete → 缓存失效</li>
 * </ul>
 *
 * @see docs/learn/06-mybatis-crud.md
 */
@Service
@RequiredArgsConstructor
public class BillServiceImpl implements BillService {

    private static final int MAX_PAGE_SIZE = 100;

    private final BillMapper billMapper;
    private final CategoryMapper categoryMapper;
    private final CategoryService categoryService;
    private final StatsCacheService statsCacheService;

    @Override
    public BillPageVO page(Long userId, BillQueryDTO query) {
        int page = query.getPage() == null || query.getPage() < 1 ? 1 : query.getPage();
        int size = query.getSize() == null || query.getSize() < 1 ? 20 : Math.min(query.getSize(), MAX_PAGE_SIZE);

        LambdaQueryWrapper<Bill> wrapper = buildQueryWrapper(userId, query);
        wrapper.orderByDesc(Bill::getBillDate).orderByDesc(Bill::getId);

        Page<Bill> pageResult = billMapper.selectPage(new Page<>(page, size), wrapper);
        Map<Long, Category> categoryMap = loadCategoryMap(pageResult.getRecords());

        List<BillVO> records = pageResult.getRecords().stream()
                .map(bill -> toVO(bill, categoryMap.get(bill.getCategoryId())))
                .toList();

        return BillPageVO.builder()
                .total(pageResult.getTotal())
                .page(pageResult.getCurrent())
                .size(pageResult.getSize())
                .records(records)
                .build();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public BillVO create(Long userId, BillCreateDTO dto) {
        Category category = categoryService.requireAccessible(userId, dto.getCategoryId());
        validateTypeMatch(category, dto.getType());

        Bill bill = new Bill();
        bill.setUserId(userId);
        bill.setCategoryId(dto.getCategoryId());
        bill.setType(dto.getType());
        bill.setAmount(normalizeAmount(dto.getAmount()));
        bill.setBillDate(dto.getBillDate());
        bill.setRemark(dto.getRemark());
        billMapper.insert(bill);
        bill = billMapper.selectById(bill.getId());

        statsCacheService.invalidateMonth(userId, bill.getBillDate());
        return toVO(bill, category);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public BillVO update(Long userId, Long billId, BillUpdateDTO dto) {
        Bill bill = requireOwnedBill(userId, billId);
        LocalDate oldDate = bill.getBillDate();

        if (dto.getCategoryId() != null) {
            bill.setCategoryId(dto.getCategoryId());
        }
        if (dto.getType() != null) {
            bill.setType(dto.getType());
        }
        if (dto.getAmount() != null) {
            bill.setAmount(normalizeAmount(dto.getAmount()));
        }
        if (dto.getBillDate() != null) {
            bill.setBillDate(dto.getBillDate());
        }
        if (dto.getRemark() != null) {
            bill.setRemark(StringUtils.hasText(dto.getRemark()) ? dto.getRemark() : null);
        }

        Category category = categoryService.requireAccessible(userId, bill.getCategoryId());
        validateTypeMatch(category, bill.getType());

        billMapper.updateById(bill);
        bill = billMapper.selectById(bill.getId());
        statsCacheService.invalidateMonth(userId, oldDate);
        if (!oldDate.equals(bill.getBillDate())) {
            statsCacheService.invalidateMonth(userId, bill.getBillDate());
        }
        return toVO(bill, category);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long userId, Long billId) {
        Bill bill = requireOwnedBill(userId, billId);
        billMapper.deleteById(billId);
        statsCacheService.invalidateMonth(userId, bill.getBillDate());
    }

    private Bill requireOwnedBill(Long userId, Long billId) {
        Bill bill = billMapper.selectById(billId);
        if (bill == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账单不存在");
        }
        if (!bill.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.FORBIDDEN, "无权操作该账单");
        }
        return bill;
    }

    private LambdaQueryWrapper<Bill> buildQueryWrapper(Long userId, BillQueryDTO query) {
        LambdaQueryWrapper<Bill> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Bill::getUserId, userId);
        if (query.getType() != null) {
            wrapper.eq(Bill::getType, query.getType());
        }
        if (query.getCategoryId() != null) {
            wrapper.eq(Bill::getCategoryId, query.getCategoryId());
        }
        if (query.getStartDate() != null) {
            wrapper.ge(Bill::getBillDate, query.getStartDate());
        }
        if (query.getEndDate() != null) {
            wrapper.le(Bill::getBillDate, query.getEndDate());
        }
        return wrapper;
    }

    private Map<Long, Category> loadCategoryMap(List<Bill> bills) {
        List<Long> categoryIds = bills.stream()
                .map(Bill::getCategoryId)
                .filter(Objects::nonNull)
                .distinct()
                .toList();
        if (categoryIds.isEmpty()) {
            return Map.of();
        }
        return categoryMapper.selectBatchIds(categoryIds).stream()
                .collect(Collectors.toMap(Category::getId, Function.identity()));
    }

    private void validateTypeMatch(Category category, Integer type) {
        if (!category.getType().equals(type)) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "分类类型与账单类型不一致");
        }
    }

    private BigDecimal normalizeAmount(BigDecimal amount) {
        return amount.setScale(2, RoundingMode.HALF_UP);
    }

    private BillVO toVO(Bill bill, Category category) {
        return BillVO.builder()
                .id(bill.getId())
                .categoryId(bill.getCategoryId())
                .categoryName(category != null ? category.getName() : null)
                .type(bill.getType())
                .amount(formatAmount(bill.getAmount()))
                .billDate(bill.getBillDate())
                .remark(bill.getRemark())
                .createdAt(bill.getCreatedAt())
                .build();
    }

    private String formatAmount(BigDecimal amount) {
        if (amount == null) {
            return null;
        }
        return amount.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }
}
