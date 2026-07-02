package com.example.ledger.controller.stats;

import com.example.ledger.common.exception.BusinessException;
import com.example.ledger.common.result.Result;
import com.example.ledger.common.result.ResultCode;
import com.example.ledger.common.security.SecurityUtils;
import com.example.ledger.service.stats.StatsService;
import com.example.ledger.vo.stats.MonthStatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 统计接口：月度汇总。
 *
 * @see docs/api/stats.md
 */
@RestController
@RequestMapping("/api/stats")
@RequiredArgsConstructor
public class StatsController {

    private final StatsService statsService;

    /**
     * 指定月份收入、支出、结余汇总（Redis 缓存 5 分钟）
     */
    @GetMapping("/month")
    public Result<MonthStatsVO> monthStats(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return Result.ok(statsService.getMonthStats(requireUserId(), year, month));
    }

    private Long requireUserId() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED);
        }
        return userId;
    }
}
