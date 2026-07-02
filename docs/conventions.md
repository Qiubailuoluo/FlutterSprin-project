# 编码规范

本文档供开发人员查阅；AI 协同开发时以 `.cursor/rules/` 为准。

## 后端（Spring Boot）

### 包命名

- 根包：`com.example.ledger`
- 业务模块：`auth.login`、`user`、`bill`、`category`、`stats`

### 分层

```
controller/   → 接参、校验、调 Service、返回 Result
service/      → 接口定义
service/impl/ → 业务实现
mapper/       → 数据访问
entity/       → 表实体
dto/          → 入参
vo/           → 出参
```

### Controller 禁止事项

- 不写业务 if/else 逻辑
- 不编写或拼接 SQL
- 不直接注入 Mapper、RedisTemplate
- 不 try-catch 后静默返回

### 示例（正确）

```java
@PostMapping("/api/bills")
public Result<Long> create(@Valid @RequestBody BillCreateDTO dto) {
    return Result.ok(billService.create(dto));
}
```

## 前端（Flutter）

### 目录

- `features/{模块}/data/` — API、Model
- `features/{模块}/presentation/` — 页面
- `core/` — Dio、Token、ApiResult

### 禁止事项

- Widget 内硬编码 API URL
- 在 UI 层直接解析原始 JSON（应经 Model + ApiResult）

## 文档同步

以下变更必须同步更新文档：

| 变更类型 | 更新文件 |
|----------|----------|
| 新增/修改接口 | `docs/api/*.md` |
| 表结构变更 | `docs/database/schema.sql` |
| 环境依赖变更 | `docs/dev-setup.md` |

## Git 提交建议

- `feat:` 新功能
- `fix:` 修复
- `docs:` 仅文档
- `refactor:` 重构

## 注释与 API 文档

### 后端

- 类、接口、Controller 公共方法：JavaDoc
- Controller 标注 `@see docs/api/xxx.md`
- 业务规则、Redis key 策略等非直观逻辑：简短行内注释

### 前端

- Feature 入口页面、API 客户端类：顶部说明
- Model 字段注释与接口文档一致

### 文档同步

新增或变更接口时，**代码与 `docs/api/` 同一次提交**。
