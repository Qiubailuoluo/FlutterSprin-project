package com.example.ledger.controller.stats;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.service.stats.StatsService;
import com.example.ledger.vo.stats.CategoryShareItemVO;
import com.example.ledger.vo.stats.MemberStatItemVO;
import com.example.ledger.vo.stats.MonthStatsVO;
import com.example.ledger.vo.stats.TrendPointVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 统计接口：月度汇总 + 图表数据。
 *
 * @see docs/api/stats.md
 */
@RestController
@RequestMapping("/api/stats")
@RequiredArgsConstructor
public class StatsController {

    private final StatsService statsService;

    @GetMapping("/month")
    public Result<MonthStatsVO> monthStats(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return Result.ok(statsService.getMonthStats(requireUserId(), year, month));
    }

    /** 支出分类占比（饼图） */
    @GetMapping("/category-share")
    public Result<List<CategoryShareItemVO>> categoryShare(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return Result.ok(statsService.getCategoryShare(requireUserId(), year, month));
    }

    /** 近 N 月收支趋势（折线） */
    @GetMapping("/trend")
    public Result<List<TrendPointVO>> trend(
            @RequestParam(required = false, defaultValue = "6") Integer months) {
        return Result.ok(statsService.getTrend(requireUserId(), months));
    }

    /** 按家庭成员汇总（柱状） */
    @GetMapping("/by-member")
    public Result<List<MemberStatItemVO>> byMember(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return Result.ok(statsService.getByMember(requireUserId(), year, month));
    }

    private Long requireUserId() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return userId;
    }
}
