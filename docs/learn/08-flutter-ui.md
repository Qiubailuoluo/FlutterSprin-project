# 08 - Flutter UI 规范与组件库选型

## 和 Vue3 + Element Plus 的对应关系

Flutter 没有 Element Plus 的一比一移植，但可以选择**企业后台风格**的组件库或主题方案：

| 方案 | 风格 | Web 支持 | 说明 |
|------|------|----------|------|
| **Material 3（当前）** | Google 现代风 | ✅ | Flutter 内置，零依赖，阶段 1 已用 |
| **[TDesign Flutter](https://tdesign.tencent.com/flutter/overview)** | 腾讯 TDesign，接近 Element 企业风 | ✅ | **推荐阶段 2+ 引入**，表格/表单/按钮齐全 |
| **Bruno** | 字节跳动 B 端组件 | ✅ | 偏移动端 B 端，Web 可用 |
| **fluent_ui** | Microsoft Fluent | ✅ 桌面更佳 | 偏 Windows 原生感 |

**本项目建议路径**：

1. **阶段 1~2**：Material 3 + 自定义主题（主色 `#1677FF` 接近 Element 蓝）
2. **阶段 3+**：若希望更像 Element Admin，引入 **TDesign Flutter**，逐步替换 Button、Input、Table、Dialog

## 布局规范（类似 Element Admin）

```
┌──────────┬─────────────────────────────┐
│          │  TopBar（页面标题）          │
│ SideNav  ├─────────────────────────────┤
│          │                             │
│  首页    │  Content（Card 包裹内容）    │
│  账单    │                             │
│  分类    │                             │
└──────────┴─────────────────────────────┘
```

实现：`features/shell/presentation/app_shell.dart`

- 宽度 > 900px：`NavigationRail` 展开显示文字
- 内容区使用 `Card` + 统一 padding（24）

## 视觉规范

| 项 | 约定 |
|----|------|
| 主色 | `#1677FF`（Element 类似蓝） |
| 背景 | `#F5F7FA` 页面灰底 |
| 卡片 | 白底、圆角 8、浅灰边框 |
| 最大表单宽度 | 400~480（登录页） |
| 内容区 padding | 24 |

定义位置：`lib/app/theme/app_theme.dart`

## 组件使用原则

1. **优先用主题**：`Theme.of(context).textTheme`，少写死字号颜色
2. **表单**：`TextField` + `InputDecorationTheme` 统一边框；阶段 2+ 可换 `TDInput`
3. **按钮**：主要操作用 `FilledButton`，次要用 `OutlinedButton`
4. **列表/表格**：阶段 4 账单用 `DataTable` 或 TDesign `TDTable`
5. **反馈**：`SnackBar` 显示错误；阶段 2+ 可用 `TDMessage`

## 页面结构规范

```dart
// presentation 层页面模板
class XxxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: ..., // 具体内容
      ),
    );
  }
}
```

## 禁止事项

- Widget 内硬编码 `http://localhost:8080`
- 在 UI 层 `jsonDecode` 原始响应（走 data 层 Model + ApiResult）
- 每个页面各自一套颜色/圆角（应走 Theme）

## 练习

1. 打开 `app_theme.dart`，尝试修改 `seedColor` 观察全局变色
2. 阅读 `app_shell.dart`，理解侧边栏 + 内容区布局
3. 浏览 [TDesign Flutter 文档](https://tdesign.tencent.com/flutter/overview)，对比 Element Plus 组件列表
