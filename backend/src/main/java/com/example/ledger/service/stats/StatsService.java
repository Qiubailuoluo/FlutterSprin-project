package com.example.ledger.service.stats;

import com.example.ledger.vo.stats.CategoryShareItemVO;
import com.example.ledger.vo.stats.MemberStatItemVO;
import com.example.ledger.vo.stats.MonthStatsVO;
import com.example.ledger.vo.stats.TrendPointVO;

import java.util.List;

/**
 * 统计业务接口。
 */
public interface StatsService {

    MonthStatsVO getMonthStats(Long userId, Integer year, Integer month);

    /** 当月支出分类占比（饼图） */
    List<CategoryShareItemVO> getCategoryShare(Long userId, Integer year, Integer month);

    /** 近 months 个月收入/支出趋势（折线） */
    List<TrendPointVO> getTrend(Long userId, Integer months);

    /** 当月按家庭成员汇总（柱状） */
    List<MemberStatItemVO> getByMember(Long userId, Integer year, Integer month);
}
