# 06 - MyBatis-Plus CRUD

[MyBatis-Plus](https://baomidou.com/) 在 MyBatis 基础上增强，减少样板 SQL。

## Entity 与表映射

`entity/bill/Bill.java`：

```java
@Data
@TableName("bill")
public class Bill {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    // ...
}
```

- 驼峰 `userId` ↔ 下划线 `user_id`（`application.yml` 已开启 map-underscore-to-camel-case）
- `@TableId` 主键自增

## Mapper 接口

```java
public interface BillMapper extends BaseMapper<Bill> {
}
```

继承 `BaseMapper` 即拥有：

| 方法 | SQL 等价 |
|------|----------|
| insert(entity) | INSERT |
| deleteById(id) | DELETE |
| updateById(entity) | UPDATE |
| selectById(id) | SELECT |
| selectPage(page, wrapper) | SELECT + 分页 |

无需写 XML（简单场景）。

## 条件查询：LambdaQueryWrapper

`BillServiceImpl.buildQueryWrapper()`：

```java
wrapper.eq(Bill::getUserId, userId);           // WHERE user_id = ?
wrapper.ge(Bill::getBillDate, startDate);       // AND bill_date >= ?
wrapper.le(Bill::getBillDate, endDate);         // AND bill_date <= ?
```

类型安全，字段改名时编译期可发现错误。

## 分页

```java
Page<Bill> pageResult = billMapper.selectPage(new Page<>(page, size), wrapper);
pageResult.getTotal();    // 总条数
pageResult.getRecords();  // 当前页数据
```

分页插件：`config/MybatisPlusConfig.java` 注册 `PaginationInnerInterceptor`。

## CRUD 对照（账单模块）

| 操作 | HTTP | Service 方法 | Mapper |
|------|------|--------------|--------|
| 查列表 | GET /api/bills | page() | selectPage |
| 增 | POST /api/bills | create() | insert |
| 改 | PUT /api/bills/{id} | update() | updateById |
| 删 | DELETE /api/bills/{id} | delete() | deleteById |

## 关联数据：分类名称

账单表只存 `category_id`，列表要显示 `categoryName`：

1. 分页查出 Bill 列表
2. 收集 categoryId，**批量** `categoryMapper.selectBatchIds()`
3. 组装成 BillVO

避免 N+1：不要每条账单单独查一次分类。

## 分类模块（更简单的 CRUD）

`CategoryServiceImpl` 适合入门阅读：

- `list()`：`(user_id IS NULL OR user_id = ?)` 查系统+自己的分类
- `create()`：insert 自定义分类
- `delete()`：只能删自己的，系统预设抛 403

## 事务

```java
@Transactional(rollbackFor = Exception.class)
public BillVO create(...) { ... }
```

方法内任意异常会回滚数据库操作。注册、账单写入等写操作都加了事务。

## 练习

1. 阅读 `BillServiceImpl.create()` 完整流程
2. 对比 `CategoryServiceImpl`，理解「查列表」与「增删」的差异
3. 在 MySQL 执行 `SELECT * FROM bill WHERE user_id = 2` 对照接口返回
