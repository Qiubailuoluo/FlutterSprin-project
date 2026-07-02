package com.example.ledger.common.util;

import com.example.ledger.common.constant.RedisKeyConstants;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

/**
 * 统计缓存失效工具：账单变更时删除对应月份 Redis key。
 */
@Component
@RequiredArgsConstructor
public class StatsCacheService {

    private final StringRedisTemplate stringRedisTemplate;

    /** 删除指定账单日期所在月份的统计缓存 */
    public void invalidateMonth(Long userId, LocalDate billDate) {
        if (userId == null || billDate == null) {
            return;
        }
        stringRedisTemplate.delete(RedisKeyConstants.statsMonth(
                userId, billDate.getYear(), billDate.getMonthValue()));
    }
}
