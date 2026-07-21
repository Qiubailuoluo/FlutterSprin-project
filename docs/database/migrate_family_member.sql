-- 练习/二开增量：家庭成员 + 账单 member_id（可对已有库重复执行需注意 IF NOT EXISTS）
USE ledger_db;

CREATE TABLE IF NOT EXISTS `family_member` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`      BIGINT       NOT NULL COMMENT '账本主人',
  `name`         VARCHAR(64)  NOT NULL COMMENT '成员显示名',
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='家庭成员';

-- 已有 bill 表补列（若已存在会报错，可忽略）
SET @col_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'ledger_db' AND TABLE_NAME = 'bill' AND COLUMN_NAME = 'member_id'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE `bill` ADD COLUMN `member_id` BIGINT DEFAULT NULL COMMENT ''家庭成员，NULL=未指定'' AFTER `category_id`, ADD KEY `idx_member` (`member_id`)',
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
