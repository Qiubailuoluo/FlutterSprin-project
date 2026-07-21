package com.example.ledger.service.impl.stats;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.util.StatsCacheService;
import com.example.ledger.entity.bill.Bill;
import com.example.ledger.entity.category.Category;
import com.example.ledger.entity.member.FamilyMember;
import com.example.ledger.mapper.bill.BillMapper;
import com.example.ledger.mapper.category.CategoryMapper;
import com.example.ledger.mapper.member.FamilyMemberMapper;
import com.example.ledger.service.stats.StatsService;
import com.example.ledger.vo.stats.CategoryShareItemVO;
import com.example.ledger.vo.stats.MemberStatItemVO;
import com.example.ledger.vo.stats.MonthStatsVO;
import com.example.ledger.vo.stats.TrendPointVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 统计：月汇总（缓存）+ 分类占比 / 趋势 / 成员柱状。
 *
 * @see docs/api/stats.md
 * @see docs/learn/07-stats-cache.md
 */
@Service
@RequiredArgsConstructor
public class StatsServiceImpl implements StatsService {

    private static final int TYPE_INCOME = 1;
    private static final int TYPE_EXPENSE = 2;

    private final BillMapper billMapper;
    private final CategoryMapper categoryMapper;
    private final FamilyMemberMapper familyMemberMapper;
    private final StatsCacheService statsCacheService;

    @Override
    public MonthStatsVO getMonthStats(Long userId, Integer year, Integer month) {
        int[] ym = resolveYearMonth(year, month);
        return statsCacheService.get(userId, ym[0], ym[1])
                .orElseGet(() -> computeAndCache(userId, ym[0], ym[1]));
    }

    @Override
    public List<CategoryShareItemVO> getCategoryShare(Long userId, Integer year, Integer month) {
        int[] ym = resolveYearMonth(year, month);
        YearMonth yearMonth = YearMonth.of(ym[0], ym[1]);
        LocalDate start = yearMonth.atDay(1);
        LocalDate end = yearMonth.atEndOfMonth();

        QueryWrapper<Bill> wrapper = new QueryWrapper<>();
        wrapper.select("category_id AS categoryId", "IFNULL(SUM(amount), 0) AS total")
                .eq("user_id", userId)
                .eq("type", TYPE_EXPENSE)
                .ge("bill_date", start)
                .le("bill_date", end)
                .groupBy("category_id");
        List<Map<String, Object>> rows = billMapper.selectMaps(wrapper);

        BigDecimal sum = BigDecimal.ZERO;
        List<BigDecimal> amounts = new ArrayList<>();
        List<Long> categoryIds = new ArrayList<>();
        for (Map<String, Object> row : rows) {
            Long categoryId = toLong(row.get("categoryId"));
            BigDecimal amount = toDecimal(row.get("total"));
            categoryIds.add(categoryId);
            amounts.add(amount);
            sum = sum.add(amount);
        }

        Map<Long, Category> categoryMap = categoryIds.isEmpty()
                ? Map.of()
                : categoryMapper.selectBatchIds(categoryIds).stream()
                .collect(Collectors.toMap(Category::getId, Function.identity()));

        List<CategoryShareItemVO> result = new ArrayList<>();
        for (int i = 0; i < categoryIds.size(); i++) {
            Long categoryId = categoryIds.get(i);
            BigDecimal amount = amounts.get(i);
            Category category = categoryMap.get(categoryId);
            double ratio = sum.compareTo(BigDecimal.ZERO) == 0
                    ? 0
                    : amount.divide(sum, 4, RoundingMode.HALF_UP).doubleValue();
            result.add(CategoryShareItemVO.builder()
                    .categoryId(categoryId)
                    .categoryName(category != null ? category.getName() : ("#" + categoryId))
                    .amount(formatAmount(amount))
                    .ratio(ratio)
                    .build());
        }
        result.sort((a, b) -> Double.compare(b.getRatio(), a.getRatio()));
        return result;
    }

    @Override
    public List<TrendPointVO> getTrend(Long userId, Integer months) {
        int n = months == null ? 6 : Math.min(Math.max(months, 1), 24);
        YearMonth cursor = YearMonth.now();
        List<TrendPointVO> points = new ArrayList<>();
        for (int i = n - 1; i >= 0; i--) {
            YearMonth ym = cursor.minusMonths(i);
            LocalDate start = ym.atDay(1);
            LocalDate end = ym.atEndOfMonth();
            BigDecimal income = sumByType(userId, TYPE_INCOME, start, end);
            BigDecimal expense = sumByType(userId, TYPE_EXPENSE, start, end);
            points.add(TrendPointVO.builder()
                    .year(ym.getYear())
                    .month(ym.getMonthValue())
                    .income(formatAmount(income))
                    .expense(formatAmount(expense))
                    .build());
        }
        return points;
    }

    @Override
    public List<MemberStatItemVO> getByMember(Long userId, Integer year, Integer month) {
        int[] ym = resolveYearMonth(year, month);
        YearMonth yearMonth = YearMonth.of(ym[0], ym[1]);
        LocalDate start = yearMonth.atDay(1);
        LocalDate end = yearMonth.atEndOfMonth();

        QueryWrapper<Bill> wrapper = new QueryWrapper<>();
        wrapper.select("member_id AS memberId", "type", "IFNULL(SUM(amount), 0) AS total")
                .eq("user_id", userId)
                .ge("bill_date", start)
                .le("bill_date", end)
                .groupBy("member_id", "type");
        List<Map<String, Object>> rows = billMapper.selectMaps(wrapper);

        Map<Long, MemberAgg> agg = new HashMap<>();
        for (Map<String, Object> row : rows) {
            Long memberId = toLong(row.get("memberId"));
            int type = toInt(row.get("type"));
            BigDecimal amount = toDecimal(row.get("total"));
            MemberAgg bucket = agg.computeIfAbsent(memberId, id -> new MemberAgg());
            if (type == TYPE_INCOME) {
                bucket.income = bucket.income.add(amount);
            } else if (type == TYPE_EXPENSE) {
                bucket.expense = bucket.expense.add(amount);
            }
        }

        Map<Long, String> names = familyMemberMapper.selectList(
                        new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<FamilyMember>()
                                .eq(FamilyMember::getUserId, userId))
                .stream()
                .collect(Collectors.toMap(FamilyMember::getId, FamilyMember::getName));

        List<MemberStatItemVO> result = new ArrayList<>();
        for (Map.Entry<Long, MemberAgg> e : agg.entrySet()) {
            Long memberId = e.getKey();
            MemberAgg a = e.getValue();
            String name = memberId == null ? "未指定" : names.getOrDefault(memberId, "#" + memberId);
            result.add(MemberStatItemVO.builder()
                    .memberId(memberId)
                    .memberName(name)
                    .income(formatAmount(a.income))
                    .expense(formatAmount(a.expense))
                    .build());
        }
        result.sort((a, b) -> new BigDecimal(b.getExpense()).compareTo(new BigDecimal(a.getExpense())));
        return result;
    }

    private MonthStatsVO computeAndCache(Long userId, int year, int month) {
        YearMonth yearMonth = YearMonth.of(year, month);
        LocalDate start = yearMonth.atDay(1);
        LocalDate end = yearMonth.atEndOfMonth();

        BigDecimal income = sumByType(userId, TYPE_INCOME, start, end);
        BigDecimal expense = sumByType(userId, TYPE_EXPENSE, start, end);
        BigDecimal balance = income.subtract(expense);

        MonthStatsVO stats = MonthStatsVO.builder()
                .year(year)
                .month(month)
                .income(formatAmount(income))
                .expense(formatAmount(expense))
                .balance(formatAmount(balance))
                .build();
        statsCacheService.put(userId, stats);
        return stats;
    }

    private BigDecimal sumByType(Long userId, int type, LocalDate start, LocalDate end) {
        QueryWrapper<Bill> wrapper = new QueryWrapper<>();
        wrapper.select("IFNULL(SUM(amount), 0) AS total")
                .eq("user_id", userId)
                .eq("type", type)
                .ge("bill_date", start)
                .le("bill_date", end);
        Map<String, Object> result = billMapper.selectMaps(wrapper).get(0);
        return toDecimal(result.get("total"));
    }

    private int[] resolveYearMonth(Integer year, Integer month) {
        LocalDate now = LocalDate.now();
        int targetYear = year != null ? year : now.getYear();
        int targetMonth = month != null ? month : now.getMonthValue();
        if (targetMonth < 1 || targetMonth > 12) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "月份必须为 1~12");
        }
        if (targetYear < 1970 || targetYear > 2100) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "年份不合法");
        }
        return new int[]{targetYear, targetMonth};
    }

    private String formatAmount(BigDecimal amount) {
        return amount.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }

    private BigDecimal toDecimal(Object total) {
        if (total instanceof BigDecimal bigDecimal) {
            return bigDecimal;
        }
        if (total == null) {
            return BigDecimal.ZERO;
        }
        return new BigDecimal(total.toString());
    }

    private Long toLong(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Number number) {
            return number.longValue();
        }
        return Long.parseLong(value.toString());
    }

    private int toInt(Object value) {
        if (value instanceof Number number) {
            return number.intValue();
        }
        return Integer.parseInt(Objects.requireNonNull(value).toString());
    }

    private static final class MemberAgg {
        private BigDecimal income = BigDecimal.ZERO;
        private BigDecimal expense = BigDecimal.ZERO;
    }
}
