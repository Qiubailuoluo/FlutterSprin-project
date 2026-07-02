package com.example.ledger.mapper.user;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.ledger.entity.user.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户表 Mapper。
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
}
