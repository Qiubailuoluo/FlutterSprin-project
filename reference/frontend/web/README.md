# frontend / web

原生 **HTML / CSS / SCSS / JavaScript**，与 Vue、Flutter 分离。

| 文件 | 何时引用 |
|------|----------|
| [html.mdc](html.mdc) | 改结构、语义化标签、无障碍基础 |
| [css.mdc](css.mdc) | 纯 CSS、布局、变量 |
| [scss.mdc](scss.mdc) | 预处理器、嵌套、模块拆分 |
| [javascript.mdc](javascript.mdc) | 原生 JS 模块、DOM、请求 |

同时写样式时：已用 SCSS 则优先只挂 `scss.mdc`；纯 CSS 项目只挂 `css.mdc`。
