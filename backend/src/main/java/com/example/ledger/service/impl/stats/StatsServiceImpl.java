package com.example.ledger.service.impl.stats;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.util.StatsCacheService;
import com.example.ledger.entity.bill.Bill;
import com.example.ledger.mapper.bill.BillMapper;
import com.example.ledger.service.stats.StatsService;
import com.example.ledger.vo.stats.MonthStatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.Map;

/**
 * 统计业务实现：MySQL 聚合 + Redis 缓存（5 分钟）。
 * <p>
 * 对 bill 表按月份、类型 SUM(amount)，结果缓存到 Redis。
 * 收入 type=1，支出 type=2，结余 = 收入 - 支出。
 * </p>
 *
 * @see docs/learn/07-stats-cache.md
 */
@Service
@RequiredArgsConstructor
public class StatsServiceImpl implements StatsService {

    private static final int TYPE_INCOME = 1;
    private static final int TYPE_EXPENSE = 2;

    private final BillMapper billMapper;
    private final StatsCacheService statsCacheService;

    @Override
    public MonthStatsVO getMonthStats(Long userId, Integer year, Integer month) {
        LocalDate now = LocalDate.now();
        int targetYear = year != null ? year : now.getYear();
        int targetMonth = month != null ? month : now.getMonthValue();
        validateYearMonth(targetYear, targetMonth);

        return statsCacheService.get(userId, targetYear, targetMonth)
                .orElseGet(() -> computeAndCache(userId, targetYear, targetMonth));
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
        Object total = result.get("total");
        if (total instanceof BigDecimal bigDecimal) {
            return bigDecimal;
        }
        return new BigDecimal(total.toString());
    }

    private void validateYearMonth(int year, int month) {
        if (month < 1 || month > 12) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "月份必须为 1~12");
        }
        if (year < 1970 || year > 2100) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "年份不合法");
        }
    }

    private String formatAmount(BigDecimal amount) {
        return amount.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }
}
