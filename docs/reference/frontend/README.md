# reference / frontend — 前端参考规范

前端按**技术栈分目录**。解压后：**删除或忽略**未使用的栈（用 Vue 就删/忽略 `flutter/`，禁止混用）。

**优先级**：本地代码与项目专用 rules > 本目录。全部 Manual（无 globs）。

## 目录怎么选

| 你的项目 | 使用目录 | 删除或忽略 |
|----------|----------|------------|
| Flutter / Dart | [`flutter/`](flutter/) | `vue/`、不用的 `web/` |
| Vue 3 | [`vue/`](vue/) | `flutter/`；原生页才留 `web/` |
| 原生页 / 静态站 | [`web/`](web/) | `flutter/`、`vue/` |
| 混合 | 各引用对应子目录单文件 | 整包全挂 |

解压到目标项目时推荐：

```text
.cursor/rules/reference/frontend/flutter/   # 只放这一份，若项目是 Flutter
```

而不是把整个 `frontend/` 无差别拷进去。

## 引用原则（高效）

1. 先读该子目录 `README.md`，再 `@` 1～2 个 `.mdc`。  
2. **多语言 / 功能模块文案**：另加 [`i18n.mdc`](i18n.mdc)（与栈目录可同时引用）。  
3. 样式只改 SCSS 时，只挂 `web/scss.mdc`，不必同时挂 `css.mdc`（除非在迁移）。  
4. 与后端联调时，再按需 `@` backend 专题，不要一次挂满。

## 与本仓库 Ledger

Ledger 正式前端规则在 `.cursor/rules/flutter-app.mdc`。本目录是泛类补充；冲突以正式规则与 `flutter_app/` 代码为准。
