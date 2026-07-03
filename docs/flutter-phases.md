# Flutter 开发阶段

目标平台：**Web（Edge）**；Windows 桌面暂缓。

## 阶段划分

| 阶段 | 内容 | 状态 |
|------|------|------|
| 1 | 工程骨架、Material3 主题、路由、Dio/ApiResult、Shell 布局、健康检查 | 已完成 |
| 2 | 登录/注册页 + Token 存储 + 路由守卫 | 已完成 |
| 3 | 首页统计卡片 + 分类列表 | 已完成 |
| 4 | 账单列表/表单 CRUD | 待开始 |
| 5 | 完善交互、错误提示、UI 组件库（可选 TDesign） | 待开始 |

## 阶段 3 验证

1. 登录后进入首页，应显示「本月概览」三张卡片（收入/支出/结余）
2. 侧边栏点击「分类」→ 进入分类管理页
3. 切换「全部/收入/支出」筛选，列表应变化
4. 点击「新增分类」添加自定义分类；系统分类显示「系统」标签且不可删
5. `flutter analyze` + `flutter test`

详见 [learn/10-flutter-stats-category.md](learn/10-flutter-stats-category.md)

## 阶段 2 验证

1. 确保 backend 已启动
2. `flutter run -d edge`
3. 使用 `testuser` / `123456` 登录 → 进入首页，顶栏显示昵称
4. 刷新页面 → 应保持登录（Token 恢复）
5. 点击「退出」→ 回到登录页；手动访问 `/home` 应被重定向
6. 自动化：`flutter analyze` + `flutter test`（含登录集成测试，需 backend 运行）

详见 [learn/09-flutter-auth.md](learn/09-flutter-auth.md)

## 阶段 1 验证

```powershell
# 1. 启动后端
cd D:\FlutterSp-project\backend
D:\My_download\java_MAVEN\apache-maven-3.6.3\bin\mvn.cmd spring-boot:run

# 2. 启动 Flutter Web
cd D:\FlutterSp-project\flutter_app
flutter pub get
flutter run -d edge
```

操作：登录页 →「进入首页」→ 点击「检测 /api/health」应显示 `后端正常：UP / ledger`。

## 目录结构

```
flutter_app/lib/
├── main.dart
├── app/              # 入口、主题、路由
├── core/             # 常量、ApiResult、Dio、Token、DI
└── features/
    ├── auth/         # 登录
    ├── home/         # 首页
    ├── category/     # 分类
    ├── stats/        # 统计 API
    └── shell/        # 侧边栏布局
```

## UI 规范

见 [learn/08-flutter-ui.md](learn/08-flutter-ui.md)
