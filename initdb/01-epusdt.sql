-- EPUSDT数据库初始化脚本
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

-- 创建EPUSDT数据库
CREATE DATABASE IF NOT EXISTS epusdt CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用epusdt数据库
USE epusdt;

-- EPUSDT订单表（恢复原表名）
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trade_id VARCHAR(32) NOT NULL COMMENT 'epusdt订单号',
    order_id VARCHAR(32) NOT NULL COMMENT '客户交易id',
    block_transaction_id VARCHAR(128) NULL COMMENT '区块唯一编号',
    actual_amount DECIMAL(19, 4) NOT NULL COMMENT '订单实际需要支付的金额，保留4位小数',
    amount DECIMAL(19, 4) NOT NULL COMMENT '订单金额，保留4位小数',
    token VARCHAR(50) NOT NULL COMMENT '所属钱包地址',
    status INT DEFAULT 1 NOT NULL COMMENT '1：等待支付，2：支付成功，3：已过期',
    notify_url VARCHAR(128) NOT NULL COMMENT '异步回调地址',
    redirect_url VARCHAR(128) NULL COMMENT '同步回调地址',
    callback_num INT DEFAULT 0 NULL COMMENT '回调次数',
    callback_confirm INT DEFAULT 2 NULL COMMENT '回调是否已确认？ 1是 2否',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    CONSTRAINT orders_order_id_uindex UNIQUE (order_id),
    CONSTRAINT orders_trade_id_uindex UNIQUE (trade_id)
);

-- EPUSDT钱包地址表（恢复原表名）
CREATE TABLE IF NOT EXISTS wallet_address (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(50) NOT NULL COMMENT '钱包token',
    status INT DEFAULT 1 NOT NULL COMMENT '1:启用 2:禁用',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL
) COMMENT '钱包表';

-- 创建EPUSDT表索引（MySQL 8.0兼容语法）
CREATE INDEX orders_block_transaction_id_index ON orders(block_transaction_id);
CREATE INDEX wallet_address_token_index ON wallet_address(token);
