# Docker Dujiaoka + EPUSDT 集成部署

使用dockercompose集成部署Dujiaoka 商城系统和 EPUSDT 支付系统，部署更快，维护更方便。

Dujiaoka项目地址: [https://github.com/assimon/dujiaoka](https://github.com/assimon/dujiaoka)

EPUSDT项目地址: [https://github.com/assimon/epusdt](https://github.com/assimon/epusdt)

## 使用步骤

### 1. 克隆项目

```bash
git clone https://github.com/DEKVIW/docker-dujiaoka.git
cd docker-dujiaoka
```

### 2. 配置环境

#### 2.1 修改 Docker Compose 配置

编辑 `docker-compose.yml` 文件，修改以下配置：

```yaml
services:
  mysql:
    environment:
      MYSQL_ROOT_PASSWORD: your_root_password # 修改MySQL root密码
      MYSQL_PASSWORD: your_user_password # 修改应用数据库用户密码

  dujiaoka:
    ports:
      - "8971:80" # Dujiaoka访问端口(冒号左边可修改)

  epusdt:
    ports:
      - "8686:8000" # EPUSDT访问端口 (冒号左边可修改)
```

#### 2.2 配置 Dujiaoka

编辑 `dujiaoka/env.conf` 文件：

```ini
# 应用配置
APP_KEY=base64:your_app_key_here      # Laravel应用密钥
APP_URL=https://your-domain           # 修改为你的域名

# 数据库配置
DB_PASSWORD=your_user_password        # 与docker-compose.yml中的MYSQL_PASSWORD一致

# 后台配置
ADMIN_ROUTE_PREFIX=/admin             # 后台登录路径
ADMIN_HTTPS=false                     # 是否强制HTTPS，当使用https时必须打开，否则后台登陆页样式会丢失
```

**生成 APP_KEY 命令**：

```bash
openssl rand -base64 32
```

#### 2.3 配置 EPUSDT

编辑 `epusdt/env.conf` 文件：

```ini
# 应用配置
app_uri=http://your-domain:8686           # 修改为你的域名

# 数据库配置
mysql_passwd=your_user_password           # 与docker-compose.yml中的MYSQL_PASSWORD一致

# Telegram机器人配置
tg_bot_token=your_bot_token               # Telegram机器人Token，电报搜botfather进行获取
tg_manage=your_telegram_id                # Telegram用户 ID，电报搜userinfobot进行获取

# API认证Token
api_auth_token=your_api_token             # 生成随机字符串作为API认证Token，作为dujiaka后台配置usdt支付的商户id
```

### 3. 启动服务

```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 4. 访问服务（默认）

- **Dujiaoka 前台**: http://your-domain:8971
- **Dujiaoka 后台**: http://your-domain:8971/admin
- **EPUSDT 支付**: http://your-domain:8686

### 5.usdt后台配置

- 商户ID修改为epusd配置文件API认证Token
- 商户密钥填写API地址`https://usdt域名/api/v1/order/create-transaction`

