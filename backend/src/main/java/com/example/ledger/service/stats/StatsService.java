package com.example.ledger.service.stats;

import com.example.ledger.vo.stats.MonthStatsVO;

/**
 * 统计业务接口。
 */
public interface StatsService {

    /**
     * 查询指定月份的收入、支出、结余汇总。
     *
     * @param userId 当前用户
     * @param year   年，null 则取当前年
     * @param month  月 1~12，null 则取当前月
     */
    MonthStatsVO getMonthStats(Long userId, Integer year, Integer month);
}
