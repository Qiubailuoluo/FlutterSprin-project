package com.example.ledger.mapper.bill;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.ledger.entity.bill.Bill;
import org.apache.ibatis.annotations.Mapper;

/**
 * 账单表 Mapper。
 */
@Mapper
public interface BillMapper extends BaseMapper<Bill> {
}
