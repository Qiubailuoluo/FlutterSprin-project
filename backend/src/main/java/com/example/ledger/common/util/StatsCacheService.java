package com.example.ledger.common.util;

import com.example.ledger.common.constant.RedisKeyConstants;
import com.example.ledger.vo.stats.MonthStatsVO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

/**
 * 月度统计 Redis 缓存：读取、写入、失效。
 * <p>
 * Cache-Aside 模式：读时先查 Redis，miss 则查 MySQL 并回填；
 * 账单增删改时由 {@link com.example.ledger.service.impl.bill.BillServiceImpl} 调用 {@link #invalidateMonth} 删除缓存。
 * </p>
 *
 * @see docs/learn/07-stats-cache.md
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class StatsCacheService {

    private static final long CACHE_TTL_MINUTES = 5;

    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;

    public Optional<MonthStatsVO> get(Long userId, int year, int month) {
        String json = stringRedisTemplate.opsForValue().get(RedisKeyConstants.statsMonth(userId, year, month));
        if (json == null || json.isBlank()) {
            return Optional.empty();
        }
        try {
            return Optional.of(objectMapper.readValue(json, MonthStatsVO.class));
        } catch (JsonProcessingException e) {
            log.warn("统计缓存解析失败，将重新计算: {}", e.getMessage());
            invalidateMonth(userId, year, month);
            return Optional.empty();
        }
    }

    public void put(Long userId, MonthStatsVO stats) {
        try {
            String json = objectMapper.writeValueAsString(stats);
            stringRedisTemplate.opsForValue().set(
                    RedisKeyConstants.statsMonth(userId, stats.getYear(), stats.getMonth()),
                    json,
                    CACHE_TTL_MINUTES,
                    TimeUnit.MINUTES
            );
        } catch (JsonProcessingException e) {
            log.warn("统计缓存写入失败: {}", e.getMessage());
        }
    }

    /** 删除指定账单日期所在月份的统计缓存 */
    public void invalidateMonth(Long userId, LocalDate billDate) {
        if (userId == null || billDate == null) {
            return;
        }
        invalidateMonth(userId, billDate.getYear(), billDate.getMonthValue());
    }

    public void invalidateMonth(Long userId, int year, int month) {
        if (userId == null) {
            return;
        }
        stringRedisTemplate.delete(RedisKeyConstants.statsMonth(userId, year, month));
    }
}
