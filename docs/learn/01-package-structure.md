# 01 - 项目结构与分层

## 为什么「先分层、再模块」？

重构后的包结构：

```
com.example.ledger/
├── controller/     # 接 HTTP，调 Service
│   ├── login/
│   ├── user/
│   ├── category/
│   ├── bill/
│   └── stats/
├── service/        # 业务接口
├── service/impl/   # 业务实现
├── mapper/         # 数据库访问
├── entity/         # 表实体（与数据库字段对应）
├── dto/            # 入参（前端 → 后端）
├── vo/             # 出参（后端 → 前端）
├── common/         # 公共：Result、异常、工具、安全
└── config/         # 配置类
```

**好处**：找「所有 Controller」时打开 `controller/` 即可；企业项目常按技术层划分，便于代码审查和分工。

## 各层职责（必须遵守）

| 层 | 做什么 | 不做什么 |
|----|--------|----------|
| Controller | 参数校验、调 Service、返回 Result | 写业务 if/else、写 SQL |
| Service | 业务逻辑、事务、调 Mapper/Redis | 处理 HTTP 细节 |
| Mapper | 增删改查数据库 | 业务判断 |
| Entity | 映射表字段 | 直接返回给前端（用 VO） |
| DTO | 接收请求参数 | — |
| VO | 返回给前端的数据 | — |

## 一次请求的完整路径

以「新增账单」为例：

```
POST /api/bills
  → BillController.create()          // 校验 DTO，调 Service
  → BillServiceImpl.create()         // 校验分类、插库、清缓存
  → BillMapper.insert()              // MyBatis-Plus 生成 SQL
  → MySQL bill 表
  ← BillVO 包装进 Result 返回 JSON
```

## 对应源码

- 入口：`LedgerApplication.java`
- Controller 示例：`controller/bill/BillController.java`
- Service 示例：`service/impl/bill/BillServiceImpl.java`
- Mapper 示例：`mapper/bill/BillMapper.java`

## 练习

1. 在 IDE 中展开 `controller/login`，找到 `AuthController`，看它注入了哪个 Service
2. 打开 `service/impl/login/AuthServiceImpl`，看它注入了哪些 Mapper 和工具类
3. 思考：如果把 SQL 写在 Controller 里会有什么问题？（难测试、难复用、违反分层）
