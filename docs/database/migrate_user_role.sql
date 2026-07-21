-- 用户角色：1=普通用户 2=管理员（已有 status：1正常 0禁用）
-- 执行：mysql -u root -proot ledger_db < docs/database/migrate_user_role.sql

USE ledger_db;

ALTER TABLE `user`
  ADD COLUMN `role` TINYINT NOT NULL DEFAULT 1 COMMENT '1普通 2管理员' AFTER `status`;

-- 将默认测试账号提升为管理员（若不存在则跳过影响行）
UPDATE `user` SET `role` = 2 WHERE `username` = 'testuser';
