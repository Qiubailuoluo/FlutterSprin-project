# reference 练习记录（阶段性 · 可清空）

> **定位**：验证泛类规则时的**演练流水账**（用例、验证结果、规则结论）。  
> **不是**正式产品文档；接口/表结构/架构仍以 `docs/api`、`docs/database`、`docs/architecture` 等为准。  
> **维护**：一轮练习结束 → 有价值结论写入 `reference/*.mdc` 或项目正式 docs → **本文件可归档改名或清空**，下次新开一轮再记。勿无限堆长。

## 环境确认

| 项 | 值 |
|----|-----|
| 分支 | `practice/reference-drill` |
| 项目栈 | Spring Boot **单体** + **Flutter** + MySQL + Redis |
| 运行副本 | `.cursor/rules/reference/`（已裁剪） |
| 全集源 | `docs/reference/` |

---

## 用例 A：账单备注关键字搜索（后端）

**需求**：`GET /api/bills?keyword=` 模糊匹配备注。

| 步骤 | 结果 |
|------|------|
| health 含 time | 通过 |
| 登录 testuser | 200 |
| 创建→关键字命中→乱关键字未命中→删除 | 通过（回归复测通过） |

规则：`code-change` + 分层 + `docs-sync`（`docs/api/bill.md`）。

---

## 用例 B：前端模块 / 多语言 i18n

**规则新增**：`frontend/i18n.mdc`（docs + rules 已同步）。

**需求（按规则落地最小演示）**：

- 文案 key 化（`home.*` / `app.title` / `lang.*`）
- 支持 **zh / en / ja** 切换并持久化
- 首页概览相关文案走 `AppStrings`（不全量改造其他页，符合最小改动）

**实现**：

- `lib/core/l10n/app_locale.dart`、`app_strings.dart`
- `LedgerApp` + `HomePage` 语言菜单
- 单元测试 `test/app_strings_test.dart`

| 验证 | 结果 |
|------|------|
| `flutter test test/app_strings_test.dart` | **All tests passed**（中英日文案不同；缺 key fallback） |
| HTTP 回归（keyword） | **通过** |

---

## 用例 C：统计页 + 家庭成员（端到端）

**需求**：左侧导航「统计」；饼图/折线/柱状；添加家庭成员，账单可关联成员并进入统计。

**拆任务（task-breakdown）**：

| 子任务 | 范围 |
|--------|------|
| T1 | `family_member` + `bill.member_id` + schema/migrate |
| T2 | Member CRUD + stats 三图 API + docs |
| T3 | Flutter 统计页 / 导航 / 成员 / 记账选成员 / i18n key |
| T4 | HTTP 联调 + analyze + DRILL 结论 |

**启用的 reference 专题**：`workflow/task-breakdown`、`code-change`、`docs-sync`、`acceptance`、`backend/common/*`、`backend/monolith`、`middleware/mysql`、`frontend/flutter`、`frontend/i18n`（未拉 vue/微服务/minio）。

**实现要点**：

- 后端：`/api/members`；`/api/stats/category-share|trend|by-member`；账单 `memberId`（更新传 `<=0` 清空）
- 前端：侧栏「统计」→ `/stats`；`fl_chart` 三图；成员增删；账单表单成员下拉
- 文档：`docs/api/member.md`、`docs/api/stats.md`、`schema.sql`、migrate 脚本

| 验证 | 结果 |
|------|------|
| 登录 + POST 成员 + 带 memberId 记账 | **200** |
| category-share / trend / by-member | **200**（by-member 含成员支出） |
| `flutter analyze`（统计/导航/表单相关） | **No issues** |
| `flutter test test/app_strings_test.dart` | **通过**（含 `stats.*` / `nav.stats` 文案表） |
| Flutter Web `http://localhost:8081` | 热重启后侧栏可见「统计」 |

---

## acceptance（本轮）

- [x] 后端扩展有文档与实调
- [x] i18n 规则已写入并可指导实现
- [x] 首页可切换中/英/日（需在 Flutter Web 手测语言按钮）
- [x] 未强行全项目去硬编码（仅触及首页模块 + 统计相关 key）
- [x] 统计页 + 成员端到端 API 通过；导航与图表页已接入
- [ ] 账单/登录等页仍有中文硬编码（后续按规则渐进抽 key）

## 规则修订：混合执行（P1…Pn）

已写入 `workflow/task-breakdown.mdc`（并同步 acceptance / bootstrap / README）：

- 大需求默认 **分步**：做完当前 P → 检查点 → 暂停等「继续」
- 小需求默认 **一口气**
- 用户可用「分步 / 一口气」随时覆盖；推荐进度落盘（如本文件）

下次练大需求时可验证断线续作是否顺手。

---

## 用例 D：管理员账户管理（一口气）

**模式**：一口气（用户要求自测后自行验证）。

| P | 内容 | 状态 |
|---|------|------|
| P1 | `user.role` + migrate + schema | 完成 |
| P2 | `/api/admin/users` 列表与封禁/解封 | 完成 |
| P3 | Flutter「账户管理」+ 管理员侧栏 | 完成 |
| P4 | testuser=管理员；demo/normaluser=普通；HTTP 自测 | 完成 |

HTTP：管理员列表 200；普通用户 403；封禁后登录 403；解封恢复；不可封自己。

---

## 规则复盘优化（2026-07-21）

根据练习暴露的问题，已优化全集源（并同步运行副本）：

| 项 | 变更 |
|----|------|
| 双副本 | `docs/reference` 为唯一修改入口；改完同步 `.cursor/rules/reference` |
| 混合模式 | 清单+模式必出；落盘为主；分步默认可被用户语义覆盖 |
| 每 P 主规则 | 取代「整需求只挂 1～3」的假 KPI |
| acceptance | 最低验证表；Result/异常/鉴权核心改动须带测试 |
| security | 补授权（角色门闩、封禁踢会话、勿只靠前端显隐） |
| i18n | 触及即抽 key；禁止验收幻觉「已全面 i18n」 |

---

## 用例 E：个人资料改昵称 / 改密码（自拟 · 一口气 · 规则演练）

**模式**：一口气（自提需求并自测）

| P | 内容 | 主规则 | 状态 |
|---|------|--------|------|
| P1 | `PUT /api/user/profile`、`PUT /api/user/password` + docs | docs-sync | 完成 |
| P2 | UserService 旧密码校验、改密踢 Token | code-change · security | 完成 |
| P3 | 顶栏点昵称 → 资料对话框；profile.* i18n | flutter · i18n | 完成 |
| P4 | HTTP 成功/失败 + app_strings 测试 + 落盘 | acceptance | 完成 |

**最低验证**

| 项 | 结果 |
|----|------|
| 改昵称成功 | 200 |
| 空昵称 | 400 |
| 旧密码错误 / 新旧相同 | 400（无 errorId） |
| 改密成功后旧 Token | 401；新密码可登录；已恢复 `123456` |
| `flutter test test/app_strings_test.dart` | 通过（含 profile.title） |
| `flutter analyze`（触及文件） | No issues |

手测：登录 → 点顶栏昵称 → 改昵称；改密码后应回到登录页。

---

## 结论（规则高效 / 有效性）

| 项 | 结论 |
|----|------|
| 拆任务 | **有效**：4 个子任务边界清晰，避免一次改全栈失控 |
| 裁剪后的 reference | **高效**：只挂单体 + Flutter + MySQL + i18n，未干扰无关栈 |
| code-change + docs-sync | **有效**：接口/表结构与 `docs/api/*`、`schema.sql` 同轮落地 |
| i18n 补充规则 | **有效**：统计页文案可直接按 key 表扩展 zh/en/ja |
| 与正式 rules 关系 | 本地正式规则优先；reference 作补充词典，不冲突 |
| 总体 | **规则包达到练习目标**：指导落地完整功能，且保持最小改动 |

手测：启动后端 + Flutter Web → 登录 → 侧栏「统计」→ 添加成员 → 账单页记账选成员 → 刷新统计看三图。
