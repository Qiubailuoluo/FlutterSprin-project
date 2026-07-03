-- ============================================================
-- testuser 演示数据（可重复执行）
-- 前置：已执行 schema.sql，且 testuser 已注册
-- 系统分类 id 约定：与 schema.sql 插入顺序一致（1~8）
-- 执行（PowerShell）：
--   cmd /c "`"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe`" -u root -proot --default-character-set=utf8mb4 ledger_db < D:\FlutterSp-project\docs\database\seed_testuser.sql"
-- ============================================================

SET NAMES utf8mb4;
USE ledger_db;

SET @uid = (SELECT id FROM user WHERE username = 'testuser' LIMIT 1);

SELECT IF(
  @uid IS NULL,
  'SKIP: register testuser first (docs/test-accounts.md)',
  CONCAT('Seeding testuser id=', @uid)
) AS seed_status;

DELETE FROM bill WHERE user_id = @uid;
DELETE FROM category WHERE user_id = @uid;

-- 自定义分类
INSERT INTO `category` (`user_id`, `name`, `type`, `sort_order`) VALUES
(@uid, '宠物', 2, 0),
(@uid, '健身', 2, 0);

SET @cat_chongwu  = (SELECT id FROM category WHERE user_id = @uid AND name = '宠物' LIMIT 1);
SET @cat_jianshen = (SELECT id FROM category WHERE user_id = @uid AND name = '健身' LIMIT 1);

-- 系统分类 id（schema.sql 预设顺序）
-- 1工资 2兼职 3理财 | 4餐饮 5交通 6购物 7住房 8其他支出

-- 2026-07 本月：收入 9200.00，支出 2912.90，结余 6287.10
INSERT INTO `bill` (`user_id`, `category_id`, `type`, `amount`, `bill_date`, `remark`) VALUES
(@uid, 1, 1, 8000.00, '2026-07-05', '七月工资'),
(@uid, 2, 1, 1200.00, '2026-07-15', '周末兼职'),
(@uid, 7, 2, 2200.00, '2026-07-01', '房租'),
(@uid, 4, 2,   28.50, '2026-07-01', '早餐'),
(@uid, 4, 2,   35.50, '2026-07-02', '午饭'),
(@uid, 4, 2,   42.00, '2026-07-03', '晚饭'),
(@uid, 4, 2,   18.00, '2026-07-04', '咖啡'),
(@uid, 5, 2,    6.00, '2026-07-02', '地铁'),
(@uid, 5, 2,   25.00, '2026-07-08', '打车'),
(@uid, 6, 2,  199.00, '2026-07-06', '日用品'),
(@uid, 6, 2,   89.90, '2026-07-12', 'T恤'),
(@uid, @cat_chongwu,  2, 120.00, '2026-07-10', '猫粮'),
(@uid, @cat_jianshen, 2,  99.00, '2026-07-01', '健身房月卡'),
(@uid, 8, 2,   50.00, '2026-07-20', '话费充值');

-- 2026-06 跨月数据（列表练习）
INSERT INTO `bill` (`user_id`, `category_id`, `type`, `amount`, `bill_date`, `remark`) VALUES
(@uid, 1, 1, 8000.00, '2026-06-05', '六月工资'),
(@uid, 7, 2, 2200.00, '2026-06-01', '房租'),
(@uid, 4, 2,  320.50, '2026-06-15', '聚餐'),
(@uid, 5, 2,  150.00, '2026-06-20', '加油'),
(@uid, 6, 2,  399.00, '2026-06-25', '耳机');

SELECT
  (SELECT COUNT(*) FROM bill WHERE user_id = @uid) AS total_bills,
  (SELECT COUNT(*) FROM category WHERE user_id = @uid) AS custom_categories,
  (SELECT ROUND(SUM(amount),2) FROM bill WHERE user_id = @uid AND type = 1 AND bill_date BETWEEN '2026-07-01' AND '2026-07-31') AS jul_income,
  (SELECT ROUND(SUM(amount),2) FROM bill WHERE user_id = @uid AND type = 2 AND bill_date BETWEEN '2026-07-01' AND '2026-07-31') AS jul_expense;
