# 编码规范

本文档供开发人员查阅；AI 协同开发时以 `.cursor/rules/` 为准。

## 后端（Spring Boot）

### 包命名

- 根包：`com.example.ledger`
- **先分层、再模块**：如 `controller.login`、`service.user`、`mapper.bill`
- 业务模块：`login`、`user`、`bill`、`category`、`stats`

### 分层目录

```
controller/{模块}/   → 接参、校验、调 Service、返回 Result
service/{模块}/      → 接口定义
service/impl/{模块}/ → 业务实现
mapper/{模块}/       → 数据访问
entity/{模块}/       → 表实体
dto/{模块}/          → 入参
vo/{模块}/           → 出参
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

**规则：修改代码完成后，必须检查并更新 docs，与代码同一次提交。**

| 变更类型 | 更新文件 |
|----------|----------|
| 新增/修改/删除接口 | `docs/api/*.md` |
| 表结构变更 | `docs/database/schema.sql` |
| 架构、模块划分 | `docs/architecture.md` |
| 环境、Flutter/后端运行 | `docs/dev-setup.md` |
| 编码规范 | `docs/conventions.md` |
| 学习讲解、流程说明 | `docs/learn/*.md` |
| 测试账号与示例 | `docs/test-accounts.md` |
| 开发阶段进度 | `docs/backend-phases.md`、`create.md` |

## Git 提交建议

- `feat:` 新功能
- `fix:` 修复
- `docs:` 仅文档
- `refactor:` 重构

## 注释与 API 文档

### 后端

| 位置 | 要求 |
|------|------|
| 类 | JavaDoc + `@see docs/...` |
| public 方法 | JavaDoc：用途、参数、异常 |
| 非直观业务行 | 行内 `//`：为什么这样写 |
| Controller | 每个接口方法链接 `docs/api/xxx.md` |

### 前端（Flutter）

| 位置 | 要求 |
|------|------|
| 页面/API 类 | 文件顶部或类注释说明职责 |
| public 方法 | `///` 文档注释 |
| 复杂 Widget/状态逻辑 | 行内简短注释 |
| Model 字段 | `///` 与 `docs/api` 字段一致 |

### 原则

- 注释解释「为什么」，避免复述代码
- 禁止无意义注释
- **改代码 → 改 docs → 一起提交**
