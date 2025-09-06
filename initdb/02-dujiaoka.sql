-- Dujiaoka数据库初始化脚本
-- 设置字符集
SET NAMES utf8mb4;
SET CHARACTER_SET_CLIENT = utf8mb4;
SET CHARACTER_SET_CONNECTION = utf8mb4;
SET CHARACTER_SET_DATABASE = utf8mb4;
SET CHARACTER_SET_RESULTS = utf8mb4;
SET CHARACTER_SET_SERVER = utf8mb4;
SET COLLATION_CONNECTION = utf8mb4_unicode_ci;
SET COLLATION_DATABASE = utf8mb4_unicode_ci;
SET COLLATION_SERVER = utf8mb4_unicode_ci;

-- 创建Dujiaoka数据库
CREATE DATABASE IF NOT EXISTS dujiaoka CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用dujiaoka数据库
USE dujiaoka;

-- 创建用户并授权
-- 让dujiaoka用户同时访问两个数据库
GRANT ALL PRIVILEGES ON dujiaoka.* TO 'dujiaoka'@'%';
GRANT ALL PRIVILEGES ON epusdt.* TO 'dujiaoka'@'%';
FLUSH PRIVILEGES;

-- 创建Dujiaoka需要的完整表结构（基于原项目真实结构）
-- 管理员菜单表
CREATE TABLE IF NOT EXISTS `admin_menu` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NOT NULL DEFAULT '0',
  `order` int NOT NULL DEFAULT '0',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uri` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extension` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `show` tinyint NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 管理员权限表
CREATE TABLE IF NOT EXISTS `admin_permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `http_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `http_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `order` int NOT NULL DEFAULT '0',
  `parent_id` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_permissions_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 管理员角色表
CREATE TABLE IF NOT EXISTS `admin_roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_roles_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 管理员用户表
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_users_username_unique` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 权限菜单关联表
CREATE TABLE IF NOT EXISTS `admin_permission_menu` (
  `permission_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `admin_permission_menu_permission_id_menu_id_unique` (`permission_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 角色菜单关联表
CREATE TABLE IF NOT EXISTS `admin_role_menu` (
  `role_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `admin_role_menu_role_id_menu_id_unique` (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 角色权限关联表
CREATE TABLE IF NOT EXISTS `admin_role_permissions` (
  `role_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `admin_role_permissions_role_id_permission_id_unique` (`role_id`,`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 角色用户关联表
CREATE TABLE IF NOT EXISTS `admin_role_users` (
  `role_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `admin_role_users_role_id_user_id_unique` (`role_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 卡密表
CREATE TABLE IF NOT EXISTS `carmis` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goods_id` int NOT NULL COMMENT '所属商品',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1未售出 2已售出',
  `is_loop` tinyint(1) NOT NULL DEFAULT '0' COMMENT '循环卡密 1是 0否',
  `carmi` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '卡密',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_goods_id` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci COMMENT='卡密表';

-- 优惠券表
CREATE TABLE IF NOT EXISTS `coupons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `is_use` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否已经使用 1未使用 2已使用',
  `is_open` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用 1是 0否',
  `coupon` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '优惠码',
  `ret` int NOT NULL DEFAULT '0' COMMENT '剩余使用次数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_coupon` (`coupon`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci COMMENT='优惠码表';

-- 优惠码关联商品表
CREATE TABLE IF NOT EXISTS `coupons_goods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NOT NULL COMMENT '商品id',
  `coupons_id` int NOT NULL COMMENT '优惠码id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci COMMENT='优惠码关联商品表';

-- 邮件模板表
CREATE TABLE IF NOT EXISTS `emailtpls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tpl_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件标题',
  `tpl_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件内容',
  `tpl_token` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮件标识',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mail_token` (`tpl_token`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 失败任务表
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 商品表
CREATE TABLE IF NOT EXISTS `goods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL COMMENT '所属分类id',
  `gd_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `gd_description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品描述',
  `gd_keywords` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品关键字',
  `picture` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT '商品图片',
  `retail_price` decimal(10,2) DEFAULT '0.00' COMMENT '零售价',
  `actual_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际售价',
  `in_stock` int NOT NULL DEFAULT '0' COMMENT '库存',
  `sales_volume` int DEFAULT '0' COMMENT '销量',
  `ord` int DEFAULT '1' COMMENT '排序权重 越大越靠前',
  `buy_limit_num` int NOT NULL DEFAULT '0' COMMENT '限制单次购买最大数量，0为不限制',
  `buy_prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '购买提示',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '商品描述',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '商品类型  1自动发货 2人工处理',
  `wholesale_price_cnf` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '批发价配置',
  `other_ipu_cnf` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '其他输入框配置',
  `api_hook` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '回调事件',
  `is_open` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用，1是 0否',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci COMMENT='商品表';

-- 商品分类表
CREATE TABLE IF NOT EXISTS `goods_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gp_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '分类名称',
  `is_open` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用，1是 0否',
  `ord` int NOT NULL DEFAULT '1' COMMENT '排序权重 越大越靠前',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci COMMENT='商品分类表';

-- 迁移表
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 订单表（Dujiaoka版本，使用原表名）
CREATE TABLE IF NOT EXISTS `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '订单号',
  `goods_id` int NOT NULL COMMENT '关联商品id',
  `coupon_id` int DEFAULT '0' COMMENT '关联优惠码id',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单名称',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1自动发货 2人工处理',
  `goods_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品单价',
  `buy_amount` int NOT NULL DEFAULT '1' COMMENT '购买数量',
  `coupon_discount_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠码优惠价格',
  `wholesale_discount_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '批发价优惠',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单总价',
  `actual_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际支付价格',
  `search_pwd` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '查询密码',
  `email` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '下单邮箱',
  `info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '订单详情',
  `pay_id` int DEFAULT NULL COMMENT '支付通道id',
  `buy_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '购买者下单IP地址',
  `trade_no` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '第三方支付订单号',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1待支付 2待处理 3处理中 4已完成 5处理失败 6异常 -1过期',
  `coupon_ret_back` tinyint(1) NOT NULL DEFAULT '0' COMMENT '优惠码使用次数是否已经回退 0否 1是',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_order_sn` (`order_sn`) USING BTREE,
  KEY `idx_goods_id` (`goods_id`) USING BTREE,
  KEY `idex_email` (`email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci COMMENT='订单表';

-- 支付方式表
CREATE TABLE IF NOT EXISTS `pays` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pay_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付名称',
  `pay_check` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付标识',
  `pay_method` tinyint(1) NOT NULL COMMENT '支付方式 1跳转 2扫码',
  `pay_client` tinyint(1) NOT NULL DEFAULT '1' COMMENT '支付场景：1电脑pc 2手机 3全部',
  `merchant_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商户 ID',
  `merchant_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '商户 KEY',
  `merchant_pem` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商户密钥',
  `pay_handleroute` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付处理路由',
  `is_open` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用 1是 0否',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_pay_check` (`pay_check`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入管理员角色数据
INSERT IGNORE INTO `admin_roles` VALUES 
(1, 'Administrator', 'administrator', 1, NOW(), NOW());

-- 插入管理员用户数据（使用源项目的真实密码哈希）
-- 注意：这个用户的密码将在启动脚本中被更新为环境变量中的值
INSERT IGNORE INTO `admin_users` VALUES 
(1, 'admin', '$2y$10$e7z99Mhxm9BOHL55xHZTx.QcNTZJC6ftRXHCR/ZkBja/jBeasVeBy', 'Administrator', NULL, '4UAXF2BEw9EL1Tr2aGmwkv5DKwxqRF6djOMAHSiBMSOrPfPNHYrjCCQMtnTC', NOW(), NOW());
-- 密码哈希来自源项目，启动脚本会更新为环境变量中的值

-- 管理员用户将通过启动脚本动态更新，配置在docker-compose.yml中

-- 插入管理员权限数据
INSERT IGNORE INTO `admin_permissions` (`id`, `name`, `slug`, `http_method`, `http_path`, `order`, `parent_id`, `created_at`, `updated_at`) VALUES
(1, 'Auth management', 'auth-management', '', '', 1, 0, NOW(), NOW()),
(2, 'Users', 'users', '', '/auth/users*', 2, 1, NOW(), NOW()),
(3, 'Roles', 'roles', '', '/auth/roles*', 3, 1, NOW(), NOW()),
(4, 'Permissions', 'permissions', '', '/auth/permissions*', 4, 1, NOW(), NOW()),
(5, 'Menu', 'menu', '', '/auth/menu*', 5, 1, NOW(), NOW()),
(6, 'Extension', 'extension', '', '/auth/extensions*', 6, 1, NOW(), NOW());

-- 插入管理员菜单数据
INSERT IGNORE INTO `admin_menu` VALUES 
(1, 0, 1, 'Index', 'feather icon-bar-chart-2', '/', '', 1, NOW(), NOW()),
(2, 0, 2, 'Admin', 'feather icon-settings', '', '', 1, NOW(), NOW()),
(3, 2, 3, 'Users', '', 'auth/users', '', 1, NOW(), NOW()),
(4, 2, 4, 'Roles', '', 'auth/roles', '', 1, NOW(), NOW()),
(5, 2, 5, 'Permission', '', 'auth/permissions', '', 1, NOW(), NOW()),
(6, 2, 6, 'Menu', '', 'auth/menu', '', 1, NOW(), NOW()),
(7, 2, 7, 'Extensions', '', 'auth/extensions', '', 1, NOW(), NOW()),
(11, 0, 9, 'Goods_Manage', 'fa-shopping-bag', NULL, '', 1, NOW(), NOW()),
(12, 11, 11, 'Goods', 'fa-shopping-bag', '/goods', '', 1, NOW(), NOW()),
(13, 11, 10, 'Goods_Group', 'fa-star-half-o', '/goods-group', '', 1, NOW(), NOW()),
(14, 0, 12, 'Carmis_Manage', 'fa-credit-card-alt', NULL, '', 1, NOW(), NOW()),
(15, 14, 13, 'Carmis', 'fa-credit-card', '/carmis', '', 1, NOW(), NOW()),
(16, 14, 14, 'Import_Carmis', 'fa-plus-circle', '/import-carmis', '', 1, NOW(), NOW()),
(17, 18, 16, 'Coupon', 'fa-dollar', '/coupon', '', 1, NOW(), NOW()),
(18, 0, 15, 'Coupon_Manage', 'fa-diamond', NULL, '', 1, NOW(), NOW()),
(19, 0, 17, 'Configuration', 'fa-wrench', NULL, '', 1, NOW(), NOW()),
(20, 19, 18, 'Email_Template_Configuration', 'fa-envelope', '/emailtpl', '', 1, NOW(), NOW()),
(21, 19, 19, 'Pay_Configuration', 'fa-cc-visa', '/pay', '', 1, NOW(), NOW()),
(22, 0, 8, 'Order_Manage', 'fa-table', NULL, '', 1, NOW(), NOW()),
(23, 22, 20, 'Order', 'fa-heart', '/order', '', 1, NOW(), NOW()),
(24, 19, 21, 'System_Setting', 'fa-cogs', '/system-setting', '', 1, NOW(), NOW()),
(25, 19, 22, 'Email_Test', 'fa-envelope', '/email-test', '', 1, NOW(), NOW());

-- 插入支付方式数据（包括EPUSDT）
INSERT IGNORE INTO `pays` VALUES 
(1, '支付宝当面付', 'zfbf2f', 2, 3, '商户号', '支付宝公钥', '商户私钥', '/pay/alipay', 1, NOW(), NOW(), NULL),
(2, '支付宝 PC', 'aliweb', 1, 1, '商户号', '', '密钥', '/pay/alipay', 1, NOW(), NOW(), NULL),
(3, '码支付 QQ', 'mqq', 1, 1, '商户号', '', '密钥', '/pay/mapay', 1, NOW(), NOW(), NULL),
(4, '码支付支付宝', 'mzfb', 1, 1, '商户号', '', '密钥', '/pay/mapay', 1, NOW(), NOW(), NULL),
(5, '码支付微信', 'mwx', 1, 1, '商户号', '', '密钥', '/pay/mapay', 1, NOW(), NOW(), NULL),
(6, 'Paysapi 支付宝', 'pszfb', 1, 1, '商户号', '', '密钥', '/pay/paysapi', 1, NOW(), NOW(), NULL),
(7, 'Paysapi 微信', 'pswx', 1, 1, '商户号', '', '密钥', '/pay/paysapi', 1, NOW(), NOW(), NULL),
(8, '微信扫码', 'wescan', 2, 1, '商户号', '', '密钥', '/pay/wepay', 1, NOW(), NOW(), NULL),
(11, 'Payjs 微信扫码', 'payjswescan', 1, 1, '商户号', '', '密钥', '/pay/payjs', 1, NOW(), NOW(), NULL),
(14, '易支付-支付宝', 'alipay', 1, 1, '商户号', '', '密钥', '/pay/yipay', 2, NOW(), NOW(), NULL),
(15, '易支付-微信', 'wxpay', 1, 1, '商户号', NULL, '密钥', '/pay/yipay', 1, NOW(), NOW(), NULL),
(16, '易支付-QQ 钱包', 'qqpay', 1, 1, '商户号', NULL, '密钥', '/pay/yipay', 1, NOW(), NOW(), NULL),
(17, 'PayPal', 'paypal', 1, 1, '商户号', NULL, '密钥', '/pay/paypal', 1, NOW(), NOW(), NULL),
(19, 'V 免签支付宝', 'vzfb', 1, 1, 'V 免签通讯密钥', NULL, 'V 免签地址 例如 https://vpay.qq.com/    结尾必须有/', 'pay/vpay', 1, NOW(), NOW(), NULL),
(20, 'V 免签微信', 'vwx', 1, 1, 'V 免签通讯密钥', NULL, 'V 免签地址 例如 https://vpay.qq.com/    结尾必须有/', 'pay/vpay', 1, NOW(), NOW(), NULL),
(21, 'Stripe[微信支付宝]', 'stripe', 1, 1, 'pk开头的可发布密钥', NULL, 'sk开头的密钥', 'pay/stripe', 1, NOW(), NOW(), NULL),
(22, 'Coinbase[加密货币]', 'coinbase', 1, 3, '费率', 'API密钥', '共享密钥', 'pay/coinbase', 0, NOW(), NOW(), NULL),
(23, 'Epusdt[trc20]', 'epusdt', 1, 3, 'API密钥', '不填即可', 'api请求地址', 'pay/epusdt', 1, NOW(), NOW(), NULL);

-- 插入角色权限关联数据
INSERT IGNORE INTO `admin_role_permissions` (`role_id`, `permission_id`, `created_at`, `updated_at`) VALUES
(1, 1, NOW(), NOW()),
(1, 2, NOW(), NOW()),
(1, 3, NOW(), NOW()),
(1, 4, NOW(), NOW()),
(1, 5, NOW(), NOW()),
(1, 6, NOW(), NOW());

-- 插入角色用户关联数据
INSERT IGNORE INTO `admin_role_users` (`role_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, NOW(), NOW());

-- 插入角色菜单关联数据
INSERT IGNORE INTO `admin_role_menu` (`role_id`, `menu_id`, `created_at`, `updated_at`) VALUES
(1, 1, NOW(), NOW()),
(1, 2, NOW(), NOW()),
(1, 3, NOW(), NOW()),
(1, 4, NOW(), NOW()),
(1, 5, NOW(), NOW()),
(1, 6, NOW(), NOW()),
(1, 7, NOW(), NOW()),
(1, 11, NOW(), NOW()),
(1, 12, NOW(), NOW()),
(1, 13, NOW(), NOW()),
(1, 14, NOW(), NOW()),
(1, 15, NOW(), NOW()),
(1, 16, NOW(), NOW()),
(1, 17, NOW(), NOW()),
(1, 18, NOW(), NOW()),
(1, 19, NOW(), NOW()),
(1, 20, NOW(), NOW()),
(1, 21, NOW(), NOW()),
(1, 22, NOW(), NOW()),
(1, 23, NOW(), NOW()),
(1, 24, NOW(), NOW()),
(1, 25, NOW(), NOW());

-- 插入权限菜单关联数据
INSERT IGNORE INTO `admin_permission_menu` (`permission_id`, `menu_id`, `created_at`, `updated_at`) VALUES
(1, 2, NOW(), NOW()),
(2, 3, NOW(), NOW()),
(3, 4, NOW(), NOW()),
(4, 5, NOW(), NOW()),
(5, 6, NOW(), NOW()),
(6, 7, NOW(), NOW());
