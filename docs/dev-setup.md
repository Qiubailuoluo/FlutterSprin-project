# 开发环境

## 环境清单

| 工具 | 版本/路径 | 说明 |
|------|-----------|------|
| JDK | 17 | 后端运行 |
| Maven | `D:\My_download\java_MAVEN\apache-maven-3.6.3` | 后端构建 |
| MySQL | 8.0（本机已安装） | 数据持久化 |
| Redis | 本机默认 6379 | Token + 统计缓存 |
| Flutter | 支持 Windows + Web | 前端 |

## MySQL

### 连接信息（已验证）

| 项 | 值 |
|----|-----|
| 主机 | `localhost` |
| 端口 | `3306` |
| 用户 | `root` |
| 密码 | `root` |
| 可执行文件 | `C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe` |

验证命令（PowerShell）：

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "SELECT VERSION();"
```

### 初始化数据库

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot < docs\database\schema.sql
```

或在 MySQL Workbench 中执行 `docs/database/schema.sql`。

## Redis

| 项 | 值 |
|----|-----|
| 主机 | `localhost` |
| 端口 | `6379` |
| 密码 | 无（默认） |
| 可执行文件 | `D:\My_download\Redis\Redis-x64-5.0.14.1\redis-server.exe` |

启动（PowerShell）：

```powershell
& "D:\My_download\Redis\Redis-x64-5.0.14.1\redis-server.exe"
```

验证（同目录下有 `redis-cli.exe`）：

```powershell
& "D:\My_download\Redis\Redis-x64-5.0.14.1\redis-cli.exe" ping
```

应返回 `PONG`。

## Maven

将 Maven 加入 PATH（可选，便于命令行使用）：

```text
D:\My_download\java_MAVEN\apache-maven-3.6.3\bin
```

验证：

```powershell
mvn -version
```

## 后端（待创建）

工程目录：`backend/`

```powershell
cd backend
mvn spring-boot:run
```

默认地址：`http://localhost:8080`

### application.yml 参考配置

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ledger_db?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
    username: root
    password: root
  data:
    redis:
      host: localhost
      port: 6379

server:
  port: 8080

jwt:
  expiration: 86400000  # 1 天，毫秒
```

## Flutter（待创建）

工程目录：`flutter_app/`

```powershell
cd flutter_app
flutter pub get
flutter run -d windows
flutter run -d chrome
```

API 基址（开发）：`http://localhost:8080`

## 常见问题

### mysql 命令找不到

使用完整路径：`C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe`

### 端口 8080 被占用（启动失败）

若上次未正常退出，8080 可能仍被占用。PowerShell 查杀：

```powershell
netstat -ano | findstr ":8080"
taskkill /PID <上一步看到的PID> /F
```

然后重新执行 `mvn spring-boot:run`。

### 浏览器访问根路径报 favicon 错误

属正常现象，请访问 `http://localhost:8080/api/health` 验证。已在全局异常中忽略 favicon 误报。

### Web 跨域

后端需配置 CORS 允许 `localhost` 来源（创建 backend 时配置）。
