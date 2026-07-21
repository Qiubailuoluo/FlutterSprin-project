-- ============================================================
-- 小账本 ledger_db — 建库与建表
-- MySQL 8.x | 字符集 utf8mb4
-- 执行：mysql -u root -proot < docs/database/schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS ledger_db
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ledger_db;

-- ------------------------------------------------------------
-- 用户表
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username`     VARCHAR(64)  NOT NULL COMMENT '登录名',
  `password`     VARCHAR(128) NOT NULL COMMENT 'BCrypt 哈希',
  `nickname`     VARCHAR(64)  DEFAULT NULL COMMENT '昵称',
  `status`       TINYINT      NOT NULL DEFAULT 1 COMMENT '1正常 0禁用',
  `role`         TINYINT      NOT NULL DEFAULT 1 COMMENT '1普通 2管理员',
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户';

-- ------------------------------------------------------------
-- 分类表（user_id NULL = 系统预设，非 NULL = 用户自定义）
-- type: 1收入 2支出
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `category` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`      BIGINT       DEFAULT NULL COMMENT 'NULL=系统预设',
  `name`         VARCHAR(64)  NOT NULL COMMENT '分类名',
  `type`         TINYINT      NOT NULL COMMENT '1收入 2支出',
  `sort_order`   INT          NOT NULL DEFAULT 0,
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_type` (`user_id`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='账单分类';

-- ------------------------------------------------------------
-- 账单表
-- type: 1收入 2支出；amount 为正数
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `bill` (
  `id`           BIGINT         NOT NULL AUTO_INCREMENT,
  `user_id`      BIGINT         NOT NULL,
  `category_id`  BIGINT         NOT NULL,
  `member_id`    BIGINT         DEFAULT NULL COMMENT '家庭成员，NULL=未指定',
  `type`         TINYINT        NOT NULL COMMENT '1收入 2支出',
  `amount`       DECIMAL(12,2)  NOT NULL COMMENT '金额',
  `bill_date`    DATE           NOT NULL COMMENT '账单日期',
  `remark`       VARCHAR(255)   DEFAULT NULL,
  `created_at`   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_date` (`user_id`, `bill_date`),
  KEY `idx_user_type` (`user_id`, `type`),
  KEY `idx_category` (`category_id`),
  KEY `idx_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='账单';

-- ------------------------------------------------------------
-- 家庭成员（归属当前登录用户的账本）
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `family_member` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`      BIGINT       NOT NULL COMMENT '账本主人',
  `name`         VARCHAR(64)  NOT NULL COMMENT '成员显示名',
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='家庭成员';

-- ------------------------------------------------------------
-- 系统预设分类（可重复执行时需先清空或改用 INSERT IGNORE）
-- ------------------------------------------------------------
INSERT INTO `category` (`user_id`, `name`, `type`, `sort_order`) VALUES
(NULL, '工资',     1, 1),
(NULL, '兼职',     1, 2),
(NULL, '理财',     1, 3),
(NULL, '餐饮',     2, 1),
(NULL, '交通',     2, 2),
(NULL, '购物',     2, 3),
(NULL, '住房',     2, 4),
(NULL, '其他支出', 2, 99);

-- ------------------------------------------------------------
-- 表关系说明
-- user 1:N bill
-- user 1:N family_member
-- category 1:N bill
-- family_member 1:N bill（可选）
-- 查询用户可见分类：WHERE user_id IS NULL OR user_id = ?
-- ------------------------------------------------------------
