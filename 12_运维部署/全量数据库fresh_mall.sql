/*
 Navicat Premium Data Transfer

 Source Server         : 111.XX1.21.XXXX
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : 111.XX1.21.XXX:3306
 Source Schema         : fresh_mall

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

 Date: 14/08/2026 16:40:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` bigint unsigned NOT NULL COMMENT '管理员ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录账号',
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码密文(BCrypt)',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0-禁用 1-启用',
  `last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '$2a$10$hltcRW9VLEnCyyg4U2XMmOajsxHsRB82Ax9hDP7FCVRvdPA./L1R.', '管理员', NULL, 1, '2026-08-14 15:19:58', '117.169.196.32', '2026-08-08 12:28:28', '2026-08-08 12:28:28', 0);

-- ----------------------------
-- Table structure for admin_login_log
-- ----------------------------
DROP TABLE IF EXISTS `admin_login_log`;
CREATE TABLE `admin_login_log`  (
  `id` bigint unsigned NOT NULL COMMENT '日志ID',
  `admin_id` bigint unsigned NOT NULL COMMENT '管理员ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录账号(冗余)',
  `login_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录IP',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '登录时间',
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器UA',
  `login_result` tinyint(1) NOT NULL DEFAULT 1 COMMENT '登录结果:0-失败 1-成功',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '失败原因',
  `create_time` datetime(0) NOT NULL COMMENT '登录时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_admin_id`(`admin_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_login_time`(`login_time`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员登录日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_login_log
-- ----------------------------
INSERT INTO `admin_login_log` VALUES (2, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-08 21:00:23', NULL, 0, '密码错误', '2026-08-08 21:00:23', '2026-08-08 21:00:23', 0);
INSERT INTO `admin_login_log` VALUES (3, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 00:15:42', NULL, 0, '密码错误', '2026-08-09 00:15:42', '2026-08-09 00:15:42', 0);
INSERT INTO `admin_login_log` VALUES (4, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 00:15:45', NULL, 0, '密码错误', '2026-08-09 00:15:45', '2026-08-09 00:15:45', 0);
INSERT INTO `admin_login_log` VALUES (5, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 00:15:48', NULL, 1, NULL, '2026-08-09 00:15:48', '2026-08-09 00:15:48', 0);
INSERT INTO `admin_login_log` VALUES (6, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 01:57:20', NULL, 1, NULL, '2026-08-09 01:57:20', '2026-08-09 01:57:20', 0);
INSERT INTO `admin_login_log` VALUES (7, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 03:58:03', NULL, 1, NULL, '2026-08-09 03:58:03', '2026-08-09 03:58:03', 0);
INSERT INTO `admin_login_log` VALUES (8, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 10:44:35', NULL, 1, NULL, '2026-08-09 10:44:35', '2026-08-09 10:44:35', 0);
INSERT INTO `admin_login_log` VALUES (9, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 13:13:19', NULL, 1, NULL, '2026-08-09 13:13:19', '2026-08-09 13:13:19', 0);
INSERT INTO `admin_login_log` VALUES (10, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 15:14:27', NULL, 1, NULL, '2026-08-09 15:14:27', '2026-08-09 15:14:27', 0);
INSERT INTO `admin_login_log` VALUES (11, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 15:25:02', NULL, 1, NULL, '2026-08-09 15:25:02', '2026-08-09 15:25:02', 0);
INSERT INTO `admin_login_log` VALUES (12, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:07:30', NULL, 1, NULL, '2026-08-09 16:07:30', '2026-08-09 16:07:30', 0);
INSERT INTO `admin_login_log` VALUES (13, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:07:31', NULL, 1, NULL, '2026-08-09 16:07:31', '2026-08-09 16:07:31', 0);
INSERT INTO `admin_login_log` VALUES (14, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:07:37', NULL, 1, NULL, '2026-08-09 16:07:37', '2026-08-09 16:07:37', 0);
INSERT INTO `admin_login_log` VALUES (15, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:07:38', NULL, 1, NULL, '2026-08-09 16:07:38', '2026-08-09 16:07:38', 0);
INSERT INTO `admin_login_log` VALUES (16, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:08:20', NULL, 1, NULL, '2026-08-09 16:08:20', '2026-08-09 16:08:20', 0);
INSERT INTO `admin_login_log` VALUES (17, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:08:21', NULL, 1, NULL, '2026-08-09 16:08:21', '2026-08-09 16:08:21', 0);
INSERT INTO `admin_login_log` VALUES (18, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:08:29', NULL, 1, NULL, '2026-08-09 16:08:29', '2026-08-09 16:08:29', 0);
INSERT INTO `admin_login_log` VALUES (19, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-09 16:17:22', NULL, 1, NULL, '2026-08-09 16:17:22', '2026-08-09 16:17:22', 0);
INSERT INTO `admin_login_log` VALUES (20, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-10 11:40:10', NULL, 1, NULL, '2026-08-10 11:40:10', '2026-08-10 11:40:10', 0);
INSERT INTO `admin_login_log` VALUES (21, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-10 13:42:25', NULL, 1, NULL, '2026-08-10 13:42:25', '2026-08-10 13:42:25', 0);
INSERT INTO `admin_login_log` VALUES (22, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-10 14:32:52', NULL, 1, NULL, '2026-08-10 14:32:52', '2026-08-10 14:32:52', 0);
INSERT INTO `admin_login_log` VALUES (23, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-10 17:13:12', NULL, 1, NULL, '2026-08-10 17:13:12', '2026-08-10 17:13:12', 0);
INSERT INTO `admin_login_log` VALUES (24, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-10 19:57:40', NULL, 1, NULL, '2026-08-10 19:57:40', '2026-08-10 19:57:40', 0);
INSERT INTO `admin_login_log` VALUES (25, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-11 11:31:56', NULL, 1, NULL, '2026-08-11 11:31:56', '2026-08-11 11:31:56', 0);
INSERT INTO `admin_login_log` VALUES (26, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-11 13:56:46', NULL, 1, NULL, '2026-08-11 13:56:46', '2026-08-11 13:56:46', 0);
INSERT INTO `admin_login_log` VALUES (27, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-12 15:28:41', NULL, 1, NULL, '2026-08-12 15:28:41', '2026-08-12 15:28:41', 0);
INSERT INTO `admin_login_log` VALUES (28, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-13 08:30:30', NULL, 1, NULL, '2026-08-13 08:30:30', '2026-08-13 08:30:30', 0);
INSERT INTO `admin_login_log` VALUES (29, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-13 10:32:13', NULL, 1, NULL, '2026-08-13 10:32:13', '2026-08-13 10:32:13', 0);
INSERT INTO `admin_login_log` VALUES (30, 1, 'admin', '0:0:0:0:0:0:0:1', '2026-08-13 15:27:45', NULL, 1, NULL, '2026-08-13 15:27:45', '2026-08-13 15:27:45', 0);

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` bigint unsigned NOT NULL COMMENT 'Banner ID',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片URL',
  `link_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '跳转类型:0-不跳转 1-商品详情 2-分类页',
  `link_value` bigint unsigned NULL COMMENT '跳转目标ID(spu_id/category_id)',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序值(升序)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '上下线:0-下线 1-上线',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_sort`(`status`, `sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, NULL, '/uploads/2026/08/生鲜商城1_20260809153528.jpg', 0, NULL, 10, 1, '2026-08-09 15:35:29', '2026-08-09 15:35:29', 0);
INSERT INTO `banner` VALUES (2, NULL, '/uploads/2026/08/生鲜区2_20260809153535.webp', 0, NULL, 20, 1, '2026-08-09 15:35:38', '2026-08-09 15:35:38', 0);

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` bigint unsigned NOT NULL COMMENT '购物车ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `spu_id` bigint unsigned NOT NULL COMMENT '商品SPU ID',
  `sku_id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `quantity` int(0) NOT NULL DEFAULT 1 COMMENT '数量(单种上限99)',
  `checked` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否勾选:0-否 1-是',
  `create_time` datetime(0) NOT NULL COMMENT '加入时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_sku`(`user_id`, `sku_id`, `deleted`) USING BTREE,
  INDEX `idx_sku_id`(`sku_id`) USING BTREE,
  INDEX `idx_spu_id`(`spu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (2, 1, 15001, 15001, 1, 0, '2026-08-11 10:57:39', '2026-08-11 10:57:39', 1);
INSERT INTO `cart` VALUES (3, 1, 18001, 18001, 1, 1, '2026-08-11 10:59:53', '2026-08-11 10:59:53', 1);
INSERT INTO `cart` VALUES (4, 1, 19001, 19002, 1, 1, '2026-08-12 00:51:53', '2026-08-14 15:24:16', 1);
INSERT INTO `cart` VALUES (6, 1, 4003, 2082, 1, 1, '2026-08-12 00:53:51', '2026-08-12 00:53:51', 1);
INSERT INTO `cart` VALUES (7, 1, 18001, 18002, 1, 1, '2026-08-12 01:16:27', '2026-08-13 20:26:53', 1);
INSERT INTO `cart` VALUES (8, 1, 6001, 2107, 1, 1, '2026-08-12 10:09:16', '2026-08-12 10:09:16', 1);
INSERT INTO `cart` VALUES (9, 1, 4001, 2080, 1, 1, '2026-08-12 10:09:19', '2026-08-14 10:14:37', 1);
INSERT INTO `cart` VALUES (10, 1, 17001, 17002, 1, 1, '2026-08-12 10:15:52', '2026-08-12 10:15:52', 1);
INSERT INTO `cart` VALUES (11, 1, 15001, 15002, 1, 1, '2026-08-12 10:15:55', '2026-08-14 04:56:50', 1);
INSERT INTO `cart` VALUES (12, 1, 13001, 13001, 1, 1, '2026-08-12 10:15:59', '2026-08-12 10:15:59', 1);
INSERT INTO `cart` VALUES (13, 1, 11001, 11002, 1, 1, '2026-08-12 11:02:50', '2026-08-12 11:02:50', 1);
INSERT INTO `cart` VALUES (14, 1, 10001, 10002, 1, 1, '2026-08-12 11:02:54', '2026-08-12 11:02:54', 1);
INSERT INTO `cart` VALUES (15, 1, 7001, 7001, 2, 1, '2026-08-12 11:02:56', '2026-08-12 11:02:56', 1);
INSERT INTO `cart` VALUES (16, 1, 3001, 2065, 1, 1, '2026-08-12 11:03:02', '2026-08-12 11:03:02', 1);
INSERT INTO `cart` VALUES (17, 1, 6002, 2108, 2, 1, '2026-08-12 11:03:21', '2026-08-12 11:03:21', 1);
INSERT INTO `cart` VALUES (18, 1, 21002, 21003, 1, 1, '2026-08-12 11:40:36', '2026-08-12 11:40:36', 1);
INSERT INTO `cart` VALUES (19, 1, 7002, 7003, 1, 1, '2026-08-12 11:40:56', '2026-08-12 11:40:56', 1);
INSERT INTO `cart` VALUES (20, 1, 17003, 17004, 1, 1, '2026-08-12 11:41:10', '2026-08-12 11:41:10', 1);
INSERT INTO `cart` VALUES (21, 1, 16004, 16006, 1, 1, '2026-08-12 13:20:38', '2026-08-12 13:20:38', 1);
INSERT INTO `cart` VALUES (22, 1, 5005, 2095, 1, 1, '2026-08-12 13:20:48', '2026-08-12 13:20:48', 1);
INSERT INTO `cart` VALUES (23, 1, 23005, 23005, 1, 1, '2026-08-14 15:29:19', '2026-08-14 15:29:19', 1);
INSERT INTO `cart` VALUES (24, 1, 1024, 2034, 1, 1, '2026-08-14 15:29:23', '2026-08-14 15:44:46', 1);
INSERT INTO `cart` VALUES (25, 1, 18005, 18008, 1, 1, '2026-08-14 15:45:28', '2026-08-14 15:45:28', 1);
INSERT INTO `cart` VALUES (26, 1, 21005, 21009, 1, 1, '2026-08-14 15:45:58', '2026-08-14 15:45:58', 1);
INSERT INTO `cart` VALUES (27, 1, 1005, 2007, 1, 1, '2026-08-14 15:46:36', '2026-08-14 15:46:36', 1);

-- ----------------------------
-- Table structure for cart_bak_0813
-- ----------------------------
DROP TABLE IF EXISTS `cart_bak_0813`;
CREATE TABLE `cart_bak_0813`  (
  `id` bigint unsigned NOT NULL COMMENT '购物车ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `spu_id` bigint unsigned NOT NULL COMMENT '商品SPU ID',
  `sku_id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `quantity` int(0) NOT NULL DEFAULT 1 COMMENT '数量(单种上限99)',
  `checked` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否勾选:0-否 1-是',
  `create_time` datetime(0) NOT NULL COMMENT '加入时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart_bak_0813
-- ----------------------------
INSERT INTO `cart_bak_0813` VALUES (2, 1, 15001, 15001, 1, 0, '2026-08-11 10:57:39', '2026-08-11 10:57:39', 1);
INSERT INTO `cart_bak_0813` VALUES (3, 1, 18001, 18001, 1, 1, '2026-08-11 10:59:53', '2026-08-11 10:59:53', 1);
INSERT INTO `cart_bak_0813` VALUES (4, 1, 19001, 19002, 2, 1, '2026-08-12 00:51:53', '2026-08-12 00:51:53', 1);
INSERT INTO `cart_bak_0813` VALUES (6, 1, 4003, 2082, 1, 1, '2026-08-12 00:53:51', '2026-08-12 00:53:51', 1);
INSERT INTO `cart_bak_0813` VALUES (7, 1, 18001, 18002, 1, 1, '2026-08-12 01:16:27', '2026-08-12 01:16:27', 1);
INSERT INTO `cart_bak_0813` VALUES (8, 1, 6001, 2107, 1, 1, '2026-08-12 10:09:16', '2026-08-12 10:09:16', 1);
INSERT INTO `cart_bak_0813` VALUES (9, 1, 4001, 2080, 1, 1, '2026-08-12 10:09:19', '2026-08-12 10:09:19', 1);
INSERT INTO `cart_bak_0813` VALUES (10, 1, 17001, 17002, 1, 1, '2026-08-12 10:15:52', '2026-08-12 10:15:52', 1);
INSERT INTO `cart_bak_0813` VALUES (11, 1, 15001, 15002, 1, 1, '2026-08-12 10:15:55', '2026-08-12 10:15:55', 1);
INSERT INTO `cart_bak_0813` VALUES (12, 1, 13001, 13001, 1, 1, '2026-08-12 10:15:59', '2026-08-12 10:15:59', 1);
INSERT INTO `cart_bak_0813` VALUES (13, 1, 11001, 11002, 1, 1, '2026-08-12 11:02:50', '2026-08-12 11:02:50', 1);
INSERT INTO `cart_bak_0813` VALUES (14, 1, 10001, 10002, 1, 1, '2026-08-12 11:02:54', '2026-08-12 11:02:54', 1);
INSERT INTO `cart_bak_0813` VALUES (15, 1, 7001, 7001, 2, 1, '2026-08-12 11:02:56', '2026-08-12 11:02:56', 1);
INSERT INTO `cart_bak_0813` VALUES (16, 1, 3001, 2065, 1, 1, '2026-08-12 11:03:02', '2026-08-12 11:03:02', 1);
INSERT INTO `cart_bak_0813` VALUES (17, 1, 6002, 2108, 2, 1, '2026-08-12 11:03:21', '2026-08-12 11:03:21', 1);
INSERT INTO `cart_bak_0813` VALUES (18, 1, 21002, 21003, 1, 1, '2026-08-12 11:40:36', '2026-08-12 11:40:36', 1);
INSERT INTO `cart_bak_0813` VALUES (19, 1, 7002, 7003, 1, 1, '2026-08-12 11:40:56', '2026-08-12 11:40:56', 1);
INSERT INTO `cart_bak_0813` VALUES (20, 1, 17003, 17004, 1, 1, '2026-08-12 11:41:10', '2026-08-12 11:41:10', 1);
INSERT INTO `cart_bak_0813` VALUES (21, 1, 16004, 16006, 1, 1, '2026-08-12 13:20:38', '2026-08-12 13:20:38', 1);
INSERT INTO `cart_bak_0813` VALUES (22, 1, 5005, 2095, 1, 1, '2026-08-12 13:20:48', '2026-08-12 13:20:48', 1);

-- ----------------------------
-- Table structure for goods_category
-- ----------------------------
DROP TABLE IF EXISTS `goods_category`;
CREATE TABLE `goods_category`  (
  `id` bigint unsigned NOT NULL COMMENT '分类ID',
  `parent_id` bigint unsigned NOT NULL COMMENT '父分类ID,0=一级分类',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类图标URL',
  `bg_color` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '金刚区底色(如 #E8F8EF)',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序值(升序)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0-禁用 1-启用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE,
  INDEX `idx_sort`(`sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_category
-- ----------------------------
INSERT INTO `goods_category` VALUES (1, 0, '蔬菜', '/uploads/2026/08/蔬菜类_20260809140646.jpg', '#E8F8EF', 1, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (2, 0, '水果', '/uploads/2026/08/水果类_20260809140659.jpg', '#FFF3E8', 2, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (3, 0, '肉禽蛋', '/uploads/2026/08/肉禽蛋_20260809140709.png', '#FFF7E8', 3, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (4, 0, '水产海鲜', '/uploads/2026/08/水产海鲜_20260809140720.jpg', '#E8F3FC', 4, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (5, 0, '粮油副食', '/uploads/2026/08/粮油_20260809140740.webp', '#E8F8EF', 5, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (6, 0, '豆制品', '/uploads/2026/08/豆制品_20260809140827.webp', '#F2EDE5', 6, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (11, 1, '叶菜类', NULL, NULL, 1, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (12, 1, '茄果瓜类', NULL, NULL, 2, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (13, 1, '根茎薯芋类', NULL, NULL, 3, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (14, 1, '菌菇类', NULL, NULL, 4, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (15, 1, '葱姜蒜类', NULL, NULL, 5, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (16, 1, '豆角荚类', NULL, NULL, 6, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (21, 2, '时令瓜果', NULL, NULL, 1, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (22, 2, '葡萄与浆果', NULL, NULL, 2, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (23, 2, '热带水果', NULL, NULL, 3, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (24, 2, '苹果梨桃李', NULL, NULL, 4, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (31, 3, '猪肉', NULL, NULL, 1, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (32, 3, '牛羊肉', NULL, NULL, 2, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (33, 3, '禽肉', NULL, NULL, 3, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (34, 3, '蛋品', NULL, NULL, 4, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (41, 4, '淡水鱼', NULL, NULL, 1, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (42, 4, '海鱼', NULL, NULL, 2, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (43, 4, '虾蟹贝类', NULL, NULL, 3, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (51, 5, '大米杂粮', NULL, NULL, 1, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (52, 5, '面粉挂面', NULL, NULL, 2, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (53, 5, '食用油', NULL, NULL, 3, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (54, 5, '调味品', NULL, NULL, 4, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (61, 6, '豆腐类', NULL, NULL, 1, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_category` VALUES (62, 6, '豆干豆皮类', NULL, NULL, 2, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);

-- ----------------------------
-- Table structure for goods_inventory
-- ----------------------------
DROP TABLE IF EXISTS `goods_inventory`;
CREATE TABLE `goods_inventory`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `spu_id` bigint(0) NOT NULL COMMENT '商品SPU ID(冗余便于列表)',
  `sku_id` bigint(0) NOT NULL COMMENT '关联 goods_sku.id',
  `stock` int(0) NOT NULL DEFAULT 0 COMMENT '可用库存',
  `locked_stock` int(0) NOT NULL DEFAULT 0 COMMENT '占用库存(预留, 下单锁定用)',
  `warn_stock` int(0) NOT NULL DEFAULT 0 COMMENT '库存预警阈值(低于则提醒)',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` tinyint(0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sku`(`sku_id`) USING BTREE,
  INDEX `idx_spu`(`spu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 310 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生鲜实时库存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_inventory
-- ----------------------------
INSERT INTO `goods_inventory` VALUES (1, 1001, 2001, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (2, 1001, 2002, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (3, 1002, 2003, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (4, 1002, 2004, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (5, 1003, 2005, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (6, 1004, 2006, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (7, 1005, 2007, 49, 0, 0, 1, '2026-08-09 14:59:40', '2026-08-14 15:46:48', 0);
INSERT INTO `goods_inventory` VALUES (8, 1005, 2008, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (9, 1006, 2009, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (10, 1006, 2010, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (11, 1007, 2011, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (12, 1007, 2012, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (13, 1008, 2013, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (14, 1008, 2014, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (15, 1009, 2015, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (16, 1010, 2016, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (17, 1011, 2017, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (18, 1012, 2018, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (19, 1012, 2019, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (20, 1013, 2020, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (21, 1013, 2021, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (22, 1014, 2022, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (23, 1015, 2023, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (24, 1016, 2024, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (25, 1017, 2025, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (26, 1018, 2026, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (27, 1018, 2027, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (28, 1019, 2028, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (29, 1019, 2029, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (30, 1020, 2030, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (31, 1021, 2031, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (32, 1022, 2032, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (33, 1023, 2033, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (34, 1024, 2034, 150, 0, 0, 2, '2026-08-09 14:59:40', '2026-08-14 15:42:57', 0);
INSERT INTO `goods_inventory` VALUES (35, 1025, 2035, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (36, 1026, 2036, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (37, 1027, 2037, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (38, 1027, 2038, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (39, 1028, 2039, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (40, 1029, 2040, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (41, 1030, 2041, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (42, 1031, 2042, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (43, 2001, 2043, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (44, 2001, 2044, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (45, 2002, 2045, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (46, 2003, 2046, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (47, 2004, 2047, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (48, 2005, 2048, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (49, 2005, 2049, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (50, 2006, 2050, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (51, 2007, 2051, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (52, 2008, 2052, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (53, 2009, 2053, 10, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (54, 2010, 2054, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (55, 2011, 2055, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (56, 2012, 2056, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (57, 2013, 2057, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (58, 2014, 2058, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (59, 2014, 2059, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (60, 2015, 2060, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (61, 2016, 2061, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (62, 2017, 2062, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (63, 2018, 2063, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (64, 3001, 2064, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (65, 3001, 2065, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (66, 3002, 2066, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (67, 3003, 2067, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (68, 3004, 2068, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (69, 3005, 2069, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (70, 3006, 2070, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (71, 3007, 2071, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (72, 3008, 2072, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (73, 3009, 2073, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (74, 3010, 2074, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (75, 3011, 2075, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (76, 3012, 2076, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (77, 3013, 2077, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (78, 3014, 2078, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (79, 3015, 2079, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (80, 4001, 2080, 14, 0, 0, 1, '2026-08-09 14:59:40', '2026-08-14 10:14:41', 0);
INSERT INTO `goods_inventory` VALUES (81, 4002, 2081, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (82, 4003, 2082, 15, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (83, 4004, 2083, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (84, 4005, 2084, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (85, 4006, 2085, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (86, 4007, 2086, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (87, 4008, 2087, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (88, 4009, 2088, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (89, 4010, 2089, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (90, 5001, 2090, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (91, 5001, 2091, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (92, 5002, 2092, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (93, 5003, 2093, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (94, 5004, 2094, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (95, 5005, 2095, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (96, 5006, 2096, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (97, 5007, 2097, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (98, 5008, 2098, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (99, 5009, 2099, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (100, 5010, 2100, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (101, 5011, 2101, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (102, 5012, 2102, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (103, 5013, 2103, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (104, 5014, 2104, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (105, 5015, 2105, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (106, 5016, 2106, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (107, 6001, 2107, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (108, 6002, 2108, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (109, 6003, 2109, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (110, 6004, 2110, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (111, 6005, 2111, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (112, 6006, 2112, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (113, 7001, 7001, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (114, 7001, 7002, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (115, 7002, 7003, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (116, 7003, 7004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (117, 7004, 7005, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (118, 7005, 7006, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (119, 7005, 7007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (120, 7006, 7008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (121, 7007, 7009, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (122, 7008, 7010, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (123, 7008, 7011, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (124, 7009, 7012, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (125, 7010, 7013, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (126, 7011, 7014, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (127, 7012, 7015, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (128, 7013, 7016, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (129, 7014, 7017, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (130, 7015, 7018, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (131, 7016, 7019, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (132, 7017, 7020, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (133, 7018, 7021, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (134, 7019, 7022, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (135, 7020, 7023, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (136, 7021, 7024, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (137, 7022, 7025, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (138, 7023, 7026, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (139, 7024, 7027, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (140, 7025, 7028, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (141, 7025, 7029, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (142, 7026, 7030, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (143, 7026, 7031, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (144, 7027, 7032, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (145, 7027, 7033, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (146, 7028, 7034, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (147, 7028, 7035, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (148, 7029, 7036, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (149, 7030, 7037, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (150, 7031, 7038, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (151, 7032, 7039, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (152, 8001, 8001, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (153, 8002, 8002, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (154, 8003, 8003, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (155, 8004, 8004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (156, 8005, 8005, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (157, 8006, 8006, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (158, 8007, 8007, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (159, 8008, 8008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (160, 8009, 8009, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (161, 8010, 8010, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (162, 8011, 8011, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (163, 8012, 8012, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (164, 9001, 9001, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (165, 9002, 9002, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (166, 9003, 9003, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (167, 9004, 9004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (168, 9005, 9005, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (169, 9006, 9006, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (170, 9007, 9007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (171, 9008, 9008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (172, 9009, 9009, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (173, 9010, 9010, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (174, 10001, 10001, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (175, 10001, 10002, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (176, 10002, 10003, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (177, 10002, 10004, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (178, 10003, 10005, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (179, 10003, 10006, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (180, 10004, 10007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (181, 10004, 10008, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (182, 10005, 10009, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (183, 10005, 10010, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (184, 10006, 10011, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (185, 10006, 10012, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (186, 10007, 10013, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (187, 10007, 10014, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (188, 10008, 10015, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (189, 10009, 10016, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (190, 10010, 10017, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (191, 10010, 10018, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (192, 11001, 11001, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (193, 11001, 11002, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (194, 11002, 11003, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (195, 11002, 11004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (196, 11003, 11005, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (197, 11003, 11006, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (198, 11004, 11007, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (199, 11004, 11008, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (200, 11005, 11009, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (201, 11006, 11010, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (202, 11007, 11011, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (203, 12001, 12001, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (204, 12001, 12002, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (205, 12002, 12003, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (206, 12002, 12004, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (207, 12003, 12005, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (208, 12003, 12006, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (209, 12004, 12007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (210, 12004, 12008, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (211, 13001, 13001, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (212, 13001, 13002, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (213, 13002, 13003, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (214, 13003, 13004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (215, 13003, 13005, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (216, 13004, 13006, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (217, 13004, 13007, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (218, 13005, 13008, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (219, 13006, 13009, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (220, 13007, 13010, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (221, 13008, 13011, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (222, 14001, 14001, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (223, 14001, 14002, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (224, 14002, 14003, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (225, 14002, 14004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (226, 14003, 14005, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (227, 14003, 14006, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (228, 14004, 14007, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (229, 15001, 15001, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (230, 15001, 15002, 30, 0, 0, 2, '2026-08-09 14:59:40', '2026-08-14 14:49:34', 0);
INSERT INTO `goods_inventory` VALUES (231, 15002, 15003, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (232, 15002, 15004, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (233, 15003, 15005, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (234, 15003, 15006, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (235, 15004, 15007, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (236, 15004, 15008, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (237, 15005, 15009, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (238, 15006, 15010, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (239, 16001, 16001, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (240, 16001, 16002, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (241, 16002, 16003, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (242, 16002, 16004, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (243, 16003, 16005, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (244, 16004, 16006, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (245, 16005, 16007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (246, 16006, 16008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (247, 17001, 17001, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (248, 17001, 17002, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (249, 17002, 17003, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (250, 17003, 17004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (251, 17004, 17005, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (252, 17004, 17006, 15, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (253, 17005, 17007, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (254, 17006, 17008, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (255, 18001, 18001, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (256, 18001, 18002, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (257, 18002, 18003, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (258, 18002, 18004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (259, 18003, 18005, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (260, 18003, 18006, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (261, 18004, 18007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (262, 18005, 18008, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (263, 18006, 18009, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (264, 18007, 18010, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (265, 18008, 18011, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (266, 18009, 18012, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (267, 19001, 19001, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (268, 19001, 19002, 80, 0, 0, 4, '2026-08-09 14:59:40', '2026-08-14 15:42:57', 0);
INSERT INTO `goods_inventory` VALUES (269, 19002, 19003, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (270, 19002, 19004, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (271, 19003, 19005, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (272, 19003, 19006, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (273, 19004, 19007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (274, 20001, 20001, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (275, 20001, 20002, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (276, 20002, 20003, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (277, 20002, 20004, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (278, 20003, 20005, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (279, 20003, 20006, 149, 0, 0, 1, '2026-08-09 14:59:40', '2026-08-14 16:15:42', 0);
INSERT INTO `goods_inventory` VALUES (280, 20004, 20007, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (281, 20004, 20008, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (282, 20005, 20009, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (283, 20005, 20010, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (284, 20006, 20011, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (285, 20006, 20012, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (286, 21001, 21001, 300, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (287, 21001, 21002, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (288, 21002, 21003, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (289, 21002, 21004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (290, 21003, 21005, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (291, 21003, 21006, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (292, 21004, 21007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (293, 21004, 21008, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (294, 21005, 21009, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (295, 21005, 21010, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (296, 21006, 21011, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-13 16:30:05', 1);
INSERT INTO `goods_inventory` VALUES (297, 21007, 21012, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (298, 21008, 21013, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (299, 22001, 22001, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (300, 22002, 22002, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (301, 22003, 22003, 180, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (302, 22004, 22004, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (303, 22005, 22005, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (304, 23001, 23001, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (305, 23002, 23002, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (306, 23003, 23003, 180, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (307, 23004, 23004, 180, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory` VALUES (308, 23005, 23005, 200, 0, 0, 2, '2026-08-09 14:59:40', '2026-08-14 15:42:57', 0);
INSERT INTO `goods_inventory` VALUES (309, 23006, 23006, 0, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);

-- ----------------------------
-- Table structure for goods_inventory_bak_0813
-- ----------------------------
DROP TABLE IF EXISTS `goods_inventory_bak_0813`;
CREATE TABLE `goods_inventory_bak_0813`  (
  `id` bigint(0) NOT NULL DEFAULT 0,
  `spu_id` bigint(0) NOT NULL COMMENT '商品SPU ID(冗余便于列表)',
  `sku_id` bigint(0) NOT NULL COMMENT '关联 goods_sku.id',
  `stock` int(0) NOT NULL DEFAULT 0 COMMENT '可用库存',
  `locked_stock` int(0) NOT NULL DEFAULT 0 COMMENT '占用库存(预留, 下单锁定用)',
  `warn_stock` int(0) NOT NULL DEFAULT 0 COMMENT '库存预警阈值(低于则提醒)',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` tinyint(0) NOT NULL DEFAULT 0
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_inventory_bak_0813
-- ----------------------------
INSERT INTO `goods_inventory_bak_0813` VALUES (1, 1001, 2001, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (2, 1001, 2002, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (3, 1002, 2003, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (4, 1002, 2004, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (5, 1003, 2005, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (6, 1004, 2006, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (7, 1005, 2007, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (8, 1005, 2008, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (9, 1006, 2009, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (10, 1006, 2010, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (11, 1007, 2011, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (12, 1007, 2012, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (13, 1008, 2013, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (14, 1008, 2014, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (15, 1009, 2015, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (16, 1010, 2016, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (17, 1011, 2017, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (18, 1012, 2018, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (19, 1012, 2019, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (20, 1013, 2020, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (21, 1013, 2021, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (22, 1014, 2022, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (23, 1015, 2023, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (24, 1016, 2024, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (25, 1017, 2025, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (26, 1018, 2026, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (27, 1018, 2027, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (28, 1019, 2028, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (29, 1019, 2029, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (30, 1020, 2030, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (31, 1021, 2031, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (32, 1022, 2032, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (33, 1023, 2033, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (34, 1024, 2034, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (35, 1025, 2035, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (36, 1026, 2036, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (37, 1027, 2037, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (38, 1027, 2038, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (39, 1028, 2039, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (40, 1029, 2040, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (41, 1030, 2041, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (42, 1031, 2042, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (43, 2001, 2043, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (44, 2001, 2044, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (45, 2002, 2045, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (46, 2003, 2046, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (47, 2004, 2047, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (48, 2005, 2048, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (49, 2005, 2049, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (50, 2006, 2050, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (51, 2007, 2051, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (52, 2008, 2052, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (53, 2009, 2053, 10, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (54, 2010, 2054, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (55, 2011, 2055, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (56, 2012, 2056, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (57, 2013, 2057, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (58, 2014, 2058, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (59, 2014, 2059, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (60, 2015, 2060, 90, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (61, 2016, 2061, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (62, 2017, 2062, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (63, 2018, 2063, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (64, 3001, 2064, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (65, 3001, 2065, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (66, 3002, 2066, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (67, 3003, 2067, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (68, 3004, 2068, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (69, 3005, 2069, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (70, 3006, 2070, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (71, 3007, 2071, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (72, 3008, 2072, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (73, 3009, 2073, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (74, 3010, 2074, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (75, 3011, 2075, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (76, 3012, 2076, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (77, 3013, 2077, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (78, 3014, 2078, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (79, 3015, 2079, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (80, 4001, 2080, 15, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (81, 4002, 2081, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (82, 4003, 2082, 15, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (83, 4004, 2083, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (84, 4005, 2084, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (85, 4006, 2085, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (86, 4007, 2086, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (87, 4008, 2087, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (88, 4009, 2088, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (89, 4010, 2089, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (90, 5001, 2090, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (91, 5001, 2091, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (92, 5002, 2092, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (93, 5003, 2093, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (94, 5004, 2094, 70, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (95, 5005, 2095, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (96, 5006, 2096, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (97, 5007, 2097, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (98, 5008, 2098, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (99, 5009, 2099, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (100, 5010, 2100, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (101, 5011, 2101, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (102, 5012, 2102, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (103, 5013, 2103, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (104, 5014, 2104, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (105, 5015, 2105, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (106, 5016, 2106, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (107, 6001, 2107, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (108, 6002, 2108, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (109, 6003, 2109, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (110, 6004, 2110, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (111, 6005, 2111, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (112, 6006, 2112, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (113, 7001, 7001, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (114, 7001, 7002, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (115, 7002, 7003, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (116, 7003, 7004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (117, 7004, 7005, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (118, 7005, 7006, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (119, 7005, 7007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (120, 7006, 7008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (121, 7007, 7009, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (122, 7008, 7010, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (123, 7008, 7011, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (124, 7009, 7012, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (125, 7010, 7013, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (126, 7011, 7014, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (127, 7012, 7015, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (128, 7013, 7016, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (129, 7014, 7017, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (130, 7015, 7018, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (131, 7016, 7019, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (132, 7017, 7020, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (133, 7018, 7021, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (134, 7019, 7022, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (135, 7020, 7023, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (136, 7021, 7024, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (137, 7022, 7025, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (138, 7023, 7026, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (139, 7024, 7027, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (140, 7025, 7028, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (141, 7025, 7029, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (142, 7026, 7030, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (143, 7026, 7031, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (144, 7027, 7032, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (145, 7027, 7033, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (146, 7028, 7034, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (147, 7028, 7035, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (148, 7029, 7036, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (149, 7030, 7037, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (150, 7031, 7038, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (151, 7032, 7039, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (152, 8001, 8001, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (153, 8002, 8002, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (154, 8003, 8003, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (155, 8004, 8004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (156, 8005, 8005, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (157, 8006, 8006, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (158, 8007, 8007, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (159, 8008, 8008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (160, 8009, 8009, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (161, 8010, 8010, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (162, 8011, 8011, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (163, 8012, 8012, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (164, 9001, 9001, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (165, 9002, 9002, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (166, 9003, 9003, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (167, 9004, 9004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (168, 9005, 9005, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (169, 9006, 9006, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (170, 9007, 9007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (171, 9008, 9008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (172, 9009, 9009, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (173, 9010, 9010, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (174, 10001, 10001, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (175, 10001, 10002, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (176, 10002, 10003, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (177, 10002, 10004, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (178, 10003, 10005, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (179, 10003, 10006, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (180, 10004, 10007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (181, 10004, 10008, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (182, 10005, 10009, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (183, 10005, 10010, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (184, 10006, 10011, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (185, 10006, 10012, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (186, 10007, 10013, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (187, 10007, 10014, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (188, 10008, 10015, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (189, 10009, 10016, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (190, 10010, 10017, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (191, 10010, 10018, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (192, 11001, 11001, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (193, 11001, 11002, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (194, 11002, 11003, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (195, 11002, 11004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (196, 11003, 11005, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (197, 11003, 11006, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (198, 11004, 11007, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (199, 11004, 11008, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (200, 11005, 11009, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (201, 11006, 11010, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (202, 11007, 11011, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (203, 12001, 12001, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (204, 12001, 12002, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (205, 12002, 12003, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (206, 12002, 12004, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (207, 12003, 12005, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (208, 12003, 12006, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (209, 12004, 12007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (210, 12004, 12008, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (211, 13001, 13001, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (212, 13001, 13002, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (213, 13002, 13003, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (214, 13003, 13004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (215, 13003, 13005, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (216, 13004, 13006, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (217, 13004, 13007, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (218, 13005, 13008, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (219, 13006, 13009, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (220, 13007, 13010, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (221, 13008, 13011, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (222, 14001, 14001, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (223, 14001, 14002, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (224, 14002, 14003, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (225, 14002, 14004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (226, 14003, 14005, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (227, 14003, 14006, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (228, 14004, 14007, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (229, 15001, 15001, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (230, 15001, 15002, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (231, 15002, 15003, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (232, 15002, 15004, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (233, 15003, 15005, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (234, 15003, 15006, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (235, 15004, 15007, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (236, 15004, 15008, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (237, 15005, 15009, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (238, 15006, 15010, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (239, 16001, 16001, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (240, 16001, 16002, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (241, 16002, 16003, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (242, 16002, 16004, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (243, 16003, 16005, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (244, 16004, 16006, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (245, 16005, 16007, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (246, 16006, 16008, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (247, 17001, 17001, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (248, 17001, 17002, 20, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (249, 17002, 17003, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (250, 17003, 17004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (251, 17004, 17005, 30, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (252, 17004, 17006, 15, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (253, 17005, 17007, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (254, 17006, 17008, 60, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (255, 18001, 18001, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (256, 18001, 18002, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (257, 18002, 18003, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (258, 18002, 18004, 40, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (259, 18003, 18005, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (260, 18003, 18006, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (261, 18004, 18007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (262, 18005, 18008, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (263, 18006, 18009, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (264, 18007, 18010, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (265, 18008, 18011, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (266, 18009, 18012, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (267, 19001, 19001, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (268, 19001, 19002, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (269, 19002, 19003, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (270, 19002, 19004, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (271, 19003, 19005, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (272, 19003, 19006, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (273, 19004, 19007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (274, 20001, 20001, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (275, 20001, 20002, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (276, 20002, 20003, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (277, 20002, 20004, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (278, 20003, 20005, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (279, 20003, 20006, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (280, 20004, 20007, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (281, 20004, 20008, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (282, 20005, 20009, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (283, 20005, 20010, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (284, 20006, 20011, 50, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (285, 20006, 20012, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (286, 21001, 21001, 300, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (287, 21001, 21002, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (288, 21002, 21003, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (289, 21002, 21004, 80, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (290, 21003, 21005, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (291, 21003, 21006, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (292, 21004, 21007, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (293, 21004, 21008, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (294, 21005, 21009, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (295, 21005, 21010, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (296, 21006, 21011, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (297, 21007, 21012, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (298, 21008, 21013, 100, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (299, 22001, 22001, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (300, 22002, 22002, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (301, 22003, 22003, 180, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (302, 22004, 22004, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (303, 22005, 22005, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (304, 23001, 23001, 150, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (305, 23002, 23002, 120, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (306, 23003, 23003, 180, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (307, 23004, 23004, 180, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (308, 23005, 23005, 200, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);
INSERT INTO `goods_inventory_bak_0813` VALUES (309, 23006, 23006, 0, 0, 0, 0, '2026-08-09 14:59:40', '2026-08-09 14:59:40', 0);

-- ----------------------------
-- Table structure for goods_recommend
-- ----------------------------
DROP TABLE IF EXISTS `goods_recommend`;
CREATE TABLE `goods_recommend`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `spu_id` bigint(0) NOT NULL COMMENT '商品SPU ID',
  `rank` int(0) NOT NULL COMMENT '推荐排名(1起,越小越靠前)',
  `recommend_date` date NOT NULL COMMENT '推荐日期(每日快照)',
  `create_time` datetime(0) NOT NULL COMMENT '快照生成时间',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `deleted` int(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_spu_date`(`spu_id`, `recommend_date`) USING BTREE,
  INDEX `idx_date_rank`(`recommend_date`, `rank`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8845 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '今日推荐每日快照(按销量排名)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_recommend
-- ----------------------------
INSERT INTO `goods_recommend` VALUES (2155, 23001, 1, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2156, 22001, 2, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2157, 21001, 3, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2158, 20001, 4, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2159, 19001, 5, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2160, 18001, 6, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2161, 17001, 7, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2162, 16001, 8, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2163, 15001, 9, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2164, 14001, 10, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2165, 13001, 11, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2166, 12001, 12, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2167, 11001, 13, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2168, 10001, 14, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2169, 9001, 15, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2170, 8001, 16, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2171, 7001, 17, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2172, 6001, 18, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2173, 5001, 19, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2174, 4001, 20, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2175, 3001, 21, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2176, 2001, 22, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2177, 1001, 23, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2178, 23002, 24, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2179, 22002, 25, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2180, 21002, 26, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2181, 20002, 27, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2182, 19002, 28, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2183, 18002, 29, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2184, 17002, 30, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2185, 16002, 31, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2186, 15002, 32, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2187, 14002, 33, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2188, 13002, 34, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2189, 12002, 35, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2190, 11002, 36, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2191, 10002, 37, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend` VALUES (2192, 9002, 38, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2193, 8002, 39, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2194, 7002, 40, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2195, 6002, 41, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2196, 5002, 42, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2197, 4002, 43, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2198, 3002, 44, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2199, 2002, 45, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2200, 1002, 46, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2201, 23003, 47, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2202, 22003, 48, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2203, 21003, 49, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2204, 20003, 50, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2205, 19003, 51, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2206, 18003, 52, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2207, 17003, 53, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2208, 16003, 54, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2209, 15003, 55, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2210, 14003, 56, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2211, 13003, 57, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2212, 12003, 58, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2213, 11003, 59, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2214, 10003, 60, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2215, 9003, 61, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2216, 8003, 62, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2217, 7003, 63, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2218, 6003, 64, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2219, 5003, 65, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2220, 4003, 66, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2221, 3003, 67, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2222, 2003, 68, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2223, 1003, 69, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2224, 23004, 70, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2225, 22004, 71, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2226, 21004, 72, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2227, 20004, 73, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2228, 19004, 74, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2229, 18004, 75, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2230, 17004, 76, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2231, 16004, 77, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2232, 15004, 78, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2233, 14004, 79, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2234, 13004, 80, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2235, 12004, 81, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2236, 11004, 82, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2237, 10004, 83, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2238, 9004, 84, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2239, 8004, 85, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2240, 7004, 86, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2241, 6004, 87, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2242, 5004, 88, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2243, 4004, 89, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2244, 3004, 90, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2245, 2004, 91, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2246, 1004, 92, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2247, 23006, 93, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2248, 23005, 94, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2249, 22005, 95, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2250, 21005, 96, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2251, 20005, 97, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2252, 18005, 98, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2253, 17005, 99, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2254, 16005, 100, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2255, 15005, 101, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2256, 13005, 102, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2257, 11005, 103, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2258, 10005, 104, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2259, 9005, 105, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2260, 8005, 106, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2261, 7005, 107, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2262, 6005, 108, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2263, 5005, 109, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2264, 4005, 110, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2265, 3005, 111, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2266, 2005, 112, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2267, 1005, 113, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2268, 21006, 114, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2269, 20006, 115, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2270, 18006, 116, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2271, 17006, 117, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2272, 16006, 118, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2273, 15006, 119, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2274, 13006, 120, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2275, 11006, 121, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2276, 10006, 122, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2277, 9006, 123, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2278, 8006, 124, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2279, 7006, 125, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2280, 6006, 126, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2281, 5006, 127, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2282, 4006, 128, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2283, 3006, 129, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2284, 2006, 130, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2285, 1006, 131, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2286, 21007, 132, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2287, 18007, 133, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2288, 13007, 134, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2289, 11007, 135, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2290, 10007, 136, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2291, 9007, 137, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2292, 8007, 138, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2293, 7007, 139, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2294, 5007, 140, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2295, 4007, 141, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2296, 3007, 142, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2297, 2007, 143, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2298, 1007, 144, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2299, 21008, 145, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2300, 18008, 146, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2301, 13008, 147, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2302, 10008, 148, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2303, 9008, 149, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2304, 8008, 150, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2305, 7008, 151, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2306, 5008, 152, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2307, 4008, 153, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2308, 3008, 154, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2309, 2008, 155, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2310, 1008, 156, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2311, 18009, 157, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2312, 10009, 158, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2313, 9009, 159, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2314, 8009, 160, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2315, 7009, 161, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2316, 5009, 162, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2317, 4009, 163, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2318, 3009, 164, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2319, 2009, 165, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2320, 1009, 166, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2321, 10010, 167, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2322, 9010, 168, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2323, 8010, 169, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2324, 7010, 170, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2325, 5010, 171, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2326, 4010, 172, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2327, 3010, 173, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2328, 2010, 174, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2329, 1010, 175, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2330, 8011, 176, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2331, 7011, 177, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2332, 5011, 178, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2333, 3011, 179, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2334, 2011, 180, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2335, 1011, 181, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2336, 8012, 182, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2337, 7012, 183, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2338, 5012, 184, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2339, 3012, 185, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2340, 2012, 186, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2341, 1012, 187, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2342, 7013, 188, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2343, 5013, 189, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2344, 3013, 190, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2345, 2013, 191, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2346, 1013, 192, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2347, 7014, 193, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2348, 5014, 194, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2349, 3014, 195, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2350, 2014, 196, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2351, 1014, 197, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2352, 7015, 198, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2353, 5015, 199, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2354, 3015, 200, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2355, 2015, 201, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2356, 1015, 202, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2357, 7016, 203, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2358, 5016, 204, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2359, 2016, 205, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2360, 1016, 206, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2361, 7017, 207, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2362, 2017, 208, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2363, 1017, 209, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2364, 7018, 210, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2365, 2018, 211, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2366, 1018, 212, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2367, 7019, 213, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2368, 1019, 214, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2369, 7020, 215, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2370, 1020, 216, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2371, 7021, 217, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2372, 1021, 218, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2373, 7022, 219, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2374, 1022, 220, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2375, 7023, 221, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2376, 1023, 222, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2377, 7024, 223, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2378, 1024, 224, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2379, 7025, 225, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2380, 1025, 226, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2381, 7026, 227, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2382, 1026, 228, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2383, 7027, 229, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2384, 1027, 230, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2385, 7028, 231, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2386, 1028, 232, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2387, 7029, 233, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2388, 1029, 234, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2389, 7030, 235, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2390, 1030, 236, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2391, 7031, 237, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (2392, 1031, 238, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend` VALUES (2393, 7032, 239, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 1);
INSERT INTO `goods_recommend` VALUES (3589, 23001, 1, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3590, 22001, 2, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3591, 21001, 3, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3592, 20001, 4, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3593, 19001, 5, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3594, 18001, 6, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3595, 17001, 7, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3596, 16001, 8, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3597, 15001, 9, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3598, 14001, 10, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3599, 13001, 11, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3600, 12001, 12, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3601, 11001, 13, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3602, 10001, 14, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3603, 9001, 15, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3604, 8001, 16, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3605, 7001, 17, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3606, 6001, 18, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3607, 5001, 19, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3608, 4001, 20, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3609, 3001, 21, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3610, 2001, 22, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3611, 1001, 23, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3612, 23002, 24, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3613, 22002, 25, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3614, 21002, 26, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3615, 20002, 27, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3616, 19002, 28, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3617, 18002, 29, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3618, 17002, 30, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3619, 16002, 31, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3620, 15002, 32, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3621, 14002, 33, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3622, 13002, 34, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3623, 12002, 35, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3624, 11002, 36, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3625, 10002, 37, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3626, 9002, 38, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3627, 8002, 39, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3628, 7002, 40, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3629, 6002, 41, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3630, 5002, 42, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3631, 4002, 43, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3632, 3002, 44, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3633, 2002, 45, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3634, 1002, 46, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3635, 23003, 47, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3636, 22003, 48, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3637, 21003, 49, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3638, 20003, 50, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3639, 19003, 51, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3640, 18003, 52, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3641, 17003, 53, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3642, 16003, 54, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3643, 15003, 55, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3644, 14003, 56, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3645, 13003, 57, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3646, 12003, 58, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3647, 11003, 59, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3648, 10003, 60, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3649, 9003, 61, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3650, 8003, 62, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3651, 7003, 63, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3652, 6003, 64, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3653, 5003, 65, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3654, 4003, 66, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3655, 3003, 67, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3656, 2003, 68, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3657, 1003, 69, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3658, 23004, 70, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3659, 22004, 71, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3660, 21004, 72, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3661, 20004, 73, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3662, 19004, 74, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3663, 18004, 75, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3664, 17004, 76, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3665, 16004, 77, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3666, 15004, 78, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3667, 14004, 79, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3668, 13004, 80, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3669, 12004, 81, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3670, 11004, 82, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3671, 10004, 83, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3672, 9004, 84, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3673, 8004, 85, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3674, 7004, 86, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3675, 6004, 87, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3676, 5004, 88, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3677, 4004, 89, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3678, 3004, 90, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3679, 2004, 91, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3680, 1004, 92, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3681, 23006, 93, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3682, 23005, 94, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3683, 22005, 95, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3684, 21005, 96, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3685, 20005, 97, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3686, 18005, 98, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3687, 17005, 99, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3688, 16005, 100, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3689, 15005, 101, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3690, 13005, 102, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3691, 11005, 103, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3692, 10005, 104, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3693, 9005, 105, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3694, 8005, 106, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3695, 7005, 107, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3696, 6005, 108, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3697, 5005, 109, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3698, 4005, 110, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3699, 3005, 111, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3700, 2005, 112, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3701, 1005, 113, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3702, 21006, 114, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3703, 20006, 115, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3704, 18006, 116, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3705, 17006, 117, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3706, 16006, 118, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3707, 15006, 119, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3708, 13006, 120, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3709, 11006, 121, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3710, 10006, 122, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3711, 9006, 123, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3712, 8006, 124, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3713, 7006, 125, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3714, 6006, 126, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3715, 5006, 127, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3716, 4006, 128, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3717, 3006, 129, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3718, 2006, 130, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3719, 1006, 131, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3720, 21007, 132, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3721, 18007, 133, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3722, 13007, 134, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3723, 11007, 135, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3724, 10007, 136, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3725, 9007, 137, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3726, 8007, 138, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3727, 7007, 139, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3728, 5007, 140, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3729, 4007, 141, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3730, 3007, 142, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3731, 2007, 143, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3732, 1007, 144, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3733, 21008, 145, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3734, 18008, 146, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3735, 13008, 147, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3736, 10008, 148, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3737, 9008, 149, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3738, 8008, 150, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3739, 7008, 151, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3740, 5008, 152, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3741, 4008, 153, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3742, 3008, 154, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3743, 2008, 155, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3744, 1008, 156, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3745, 18009, 157, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3746, 10009, 158, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3747, 9009, 159, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3748, 8009, 160, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3749, 7009, 161, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3750, 5009, 162, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3751, 4009, 163, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3752, 3009, 164, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3753, 2009, 165, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3754, 1009, 166, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3755, 10010, 167, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3756, 9010, 168, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3757, 8010, 169, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3758, 7010, 170, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3759, 5010, 171, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3760, 4010, 172, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3761, 3010, 173, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3762, 2010, 174, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3763, 1010, 175, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3764, 8011, 176, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3765, 7011, 177, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3766, 5011, 178, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3767, 3011, 179, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3768, 2011, 180, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3769, 1011, 181, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3770, 8012, 182, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3771, 7012, 183, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3772, 5012, 184, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3773, 3012, 185, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3774, 2012, 186, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3775, 1012, 187, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3776, 7013, 188, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3777, 5013, 189, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3778, 3013, 190, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3779, 2013, 191, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3780, 1013, 192, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3781, 7014, 193, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3782, 5014, 194, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3783, 3014, 195, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3784, 2014, 196, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3785, 1014, 197, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3786, 7015, 198, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3787, 5015, 199, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3788, 3015, 200, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3789, 2015, 201, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3790, 1015, 202, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3791, 7016, 203, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3792, 5016, 204, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3793, 2016, 205, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3794, 1016, 206, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3795, 7017, 207, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3796, 2017, 208, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3797, 1017, 209, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3798, 7018, 210, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3799, 2018, 211, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3800, 1018, 212, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3801, 7019, 213, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3802, 1019, 214, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3803, 7020, 215, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3804, 1020, 216, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3805, 7021, 217, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3806, 1021, 218, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3807, 7022, 219, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3808, 1022, 220, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3809, 7023, 221, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3810, 1023, 222, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3811, 7024, 223, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3812, 1024, 224, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3813, 7025, 225, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3814, 1025, 226, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3815, 7026, 227, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3816, 1026, 228, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3817, 7027, 229, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3818, 1027, 230, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3819, 7028, 231, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3820, 1028, 232, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3821, 7029, 233, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3822, 1029, 234, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3823, 7030, 235, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3824, 1030, 236, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3825, 7031, 237, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (3826, 1031, 238, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend` VALUES (3827, 7032, 239, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 1);
INSERT INTO `goods_recommend` VALUES (5262, 23001, 1, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5263, 22001, 2, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5264, 21001, 3, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5265, 20001, 4, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5266, 19001, 5, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5267, 18001, 6, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5268, 17001, 7, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5269, 16001, 8, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5270, 15001, 9, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5271, 14001, 10, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5272, 13001, 11, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5273, 12001, 12, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5274, 11001, 13, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5275, 10001, 14, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5276, 9001, 15, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5277, 8001, 16, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5278, 7001, 17, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5279, 6001, 18, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5280, 5001, 19, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5281, 4001, 20, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5282, 3001, 21, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5283, 2001, 22, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5284, 1001, 23, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5285, 23002, 24, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5286, 22002, 25, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5287, 21002, 26, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5288, 20002, 27, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5289, 19002, 28, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5290, 18002, 29, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5291, 17002, 30, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5292, 16002, 31, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5293, 15002, 32, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5294, 14002, 33, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5295, 13002, 34, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5296, 12002, 35, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5297, 11002, 36, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5298, 10002, 37, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5299, 9002, 38, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5300, 8002, 39, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5301, 7002, 40, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5302, 6002, 41, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5303, 5002, 42, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5304, 4002, 43, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5305, 3002, 44, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5306, 2002, 45, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5307, 1002, 46, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5308, 23003, 47, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5309, 22003, 48, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5310, 21003, 49, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5311, 20003, 50, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5312, 19003, 51, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5313, 18003, 52, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5314, 17003, 53, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5315, 16003, 54, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5316, 15003, 55, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5317, 14003, 56, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5318, 13003, 57, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5319, 12003, 58, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5320, 11003, 59, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5321, 10003, 60, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5322, 9003, 61, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5323, 8003, 62, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5324, 7003, 63, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5325, 6003, 64, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5326, 5003, 65, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5327, 4003, 66, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5328, 3003, 67, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5329, 2003, 68, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5330, 1003, 69, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5331, 23004, 70, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5332, 22004, 71, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5333, 21004, 72, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5334, 20004, 73, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5335, 19004, 74, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5336, 18004, 75, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5337, 17004, 76, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5338, 16004, 77, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5339, 15004, 78, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5340, 14004, 79, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5341, 13004, 80, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5342, 12004, 81, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5343, 11004, 82, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5344, 10004, 83, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5345, 9004, 84, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5346, 8004, 85, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5347, 7004, 86, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5348, 6004, 87, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5349, 5004, 88, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5350, 4004, 89, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5351, 3004, 90, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5352, 2004, 91, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5353, 1004, 92, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5354, 23006, 93, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5355, 23005, 94, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5356, 22005, 95, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5357, 21005, 96, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend` VALUES (5358, 20005, 97, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 1);
INSERT INTO `goods_recommend` VALUES (5359, 18005, 98, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5360, 17005, 99, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5361, 16005, 100, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5362, 15005, 101, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5363, 13005, 102, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5364, 11005, 103, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5365, 10005, 104, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5366, 9005, 105, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5367, 8005, 106, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5368, 7005, 107, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5369, 6005, 108, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5370, 5005, 109, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5371, 4005, 110, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5372, 3005, 111, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5373, 2005, 112, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5374, 1005, 113, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5375, 21006, 114, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5376, 20006, 115, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5377, 18006, 116, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5378, 17006, 117, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5379, 16006, 118, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5380, 15006, 119, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5381, 13006, 120, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5382, 11006, 121, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5383, 10006, 122, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5384, 9006, 123, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5385, 8006, 124, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5386, 7006, 125, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5387, 6006, 126, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5388, 5006, 127, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5389, 4006, 128, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5390, 3006, 129, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5391, 2006, 130, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5392, 1006, 131, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5393, 21007, 132, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5394, 18007, 133, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5395, 13007, 134, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5396, 11007, 135, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5397, 10007, 136, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5398, 9007, 137, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5399, 8007, 138, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5400, 7007, 139, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5401, 5007, 140, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5402, 4007, 141, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5403, 3007, 142, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5404, 2007, 143, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5405, 1007, 144, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5406, 21008, 145, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5407, 18008, 146, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5408, 13008, 147, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5409, 10008, 148, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5410, 9008, 149, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5411, 8008, 150, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5412, 7008, 151, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5413, 5008, 152, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5414, 4008, 153, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5415, 3008, 154, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5416, 2008, 155, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5417, 1008, 156, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5418, 18009, 157, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5419, 10009, 158, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5420, 9009, 159, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5421, 8009, 160, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5422, 7009, 161, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5423, 5009, 162, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5424, 4009, 163, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5425, 3009, 164, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5426, 2009, 165, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5427, 1009, 166, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5428, 10010, 167, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5429, 9010, 168, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5430, 8010, 169, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5431, 7010, 170, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5432, 5010, 171, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5433, 4010, 172, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5434, 3010, 173, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5435, 2010, 174, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5436, 1010, 175, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5437, 8011, 176, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5438, 7011, 177, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5439, 5011, 178, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5440, 3011, 179, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5441, 2011, 180, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5442, 1011, 181, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5443, 8012, 182, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5444, 7012, 183, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5445, 5012, 184, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5446, 3012, 185, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5447, 2012, 186, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5448, 1012, 187, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5449, 7013, 188, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5450, 5013, 189, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5451, 3013, 190, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5452, 2013, 191, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5453, 1013, 192, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5454, 7014, 193, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5455, 5014, 194, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5456, 3014, 195, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5457, 2014, 196, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5458, 1014, 197, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5459, 7015, 198, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5460, 5015, 199, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5461, 3015, 200, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5462, 2015, 201, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5463, 1015, 202, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5464, 7016, 203, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5465, 5016, 204, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5466, 2016, 205, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5467, 1016, 206, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5468, 7017, 207, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5469, 2017, 208, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5470, 1017, 209, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5471, 7018, 210, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5472, 2018, 211, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5473, 1018, 212, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5474, 7019, 213, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5475, 1019, 214, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5476, 7020, 215, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5477, 1020, 216, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5478, 7021, 217, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5479, 1021, 218, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5480, 7022, 219, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5481, 1022, 220, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5482, 7023, 221, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5483, 1023, 222, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5484, 7024, 223, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5485, 1024, 224, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5486, 7025, 225, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5487, 1025, 226, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5488, 7026, 227, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5489, 1026, 228, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5490, 7027, 229, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5491, 1027, 230, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5492, 7028, 231, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5493, 1028, 232, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5494, 7029, 233, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5495, 1029, 234, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5496, 7030, 235, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5497, 1030, 236, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5498, 7031, 237, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (5499, 1031, 238, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend` VALUES (5500, 7032, 239, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 1);
INSERT INTO `goods_recommend` VALUES (6696, 23001, 1, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6697, 22001, 2, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6698, 21001, 3, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6699, 20001, 4, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6700, 19001, 5, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6701, 18001, 6, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6702, 17001, 7, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6703, 16001, 8, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6704, 15001, 9, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6705, 14001, 10, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6706, 13001, 11, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6707, 12001, 12, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6708, 11001, 13, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6709, 10001, 14, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6710, 9001, 15, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6711, 8001, 16, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6712, 7001, 17, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6713, 6001, 18, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6714, 5001, 19, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6715, 4001, 20, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6716, 3001, 21, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6717, 2001, 22, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6718, 1001, 23, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6719, 23002, 24, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6720, 22002, 25, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend` VALUES (6721, 21002, 26, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6722, 20002, 27, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6723, 19002, 28, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6724, 18002, 29, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6725, 17002, 30, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6726, 16002, 31, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6727, 15002, 32, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6728, 14002, 33, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6729, 13002, 34, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6730, 12002, 35, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6731, 11002, 36, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6732, 10002, 37, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6733, 9002, 38, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6734, 8002, 39, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6735, 7002, 40, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6736, 6002, 41, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6737, 5002, 42, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6738, 4002, 43, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6739, 3002, 44, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6740, 2002, 45, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6741, 1002, 46, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6742, 23003, 47, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6743, 22003, 48, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6744, 21003, 49, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6745, 20003, 50, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6746, 19003, 51, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6747, 18003, 52, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6748, 17003, 53, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6749, 16003, 54, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6750, 15003, 55, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6751, 14003, 56, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6752, 13003, 57, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6753, 12003, 58, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6754, 11003, 59, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6755, 10003, 60, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6756, 9003, 61, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6757, 8003, 62, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6758, 7003, 63, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6759, 6003, 64, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6760, 5003, 65, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6761, 4003, 66, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6762, 3003, 67, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6763, 2003, 68, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6764, 1003, 69, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6765, 23004, 70, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6766, 22004, 71, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6767, 21004, 72, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6768, 20004, 73, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6769, 19004, 74, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6770, 18004, 75, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6771, 17004, 76, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6772, 16004, 77, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6773, 15004, 78, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6774, 14004, 79, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6775, 13004, 80, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6776, 12004, 81, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6777, 11004, 82, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6778, 10004, 83, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6779, 9004, 84, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6780, 8004, 85, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6781, 7004, 86, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6782, 6004, 87, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6783, 5004, 88, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6784, 4004, 89, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6785, 3004, 90, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6786, 2004, 91, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6787, 1004, 92, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6788, 23006, 93, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6789, 23005, 94, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6790, 22005, 95, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6791, 21005, 96, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6792, 20005, 97, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6793, 18005, 98, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6794, 17005, 99, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6795, 16005, 100, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6796, 15005, 101, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6797, 13005, 102, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6798, 11005, 103, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6799, 10005, 104, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6800, 9005, 105, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6801, 8005, 106, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6802, 7005, 107, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6803, 6005, 108, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6804, 5005, 109, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6805, 4005, 110, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6806, 3005, 111, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6807, 2005, 112, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6808, 1005, 113, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6809, 21006, 114, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6810, 20006, 115, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6811, 18006, 116, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6812, 17006, 117, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6813, 16006, 118, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6814, 15006, 119, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6815, 13006, 120, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6816, 11006, 121, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6817, 10006, 122, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6818, 9006, 123, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6819, 8006, 124, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6820, 7006, 125, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6821, 6006, 126, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6822, 5006, 127, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6823, 4006, 128, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6824, 3006, 129, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6825, 2006, 130, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6826, 1006, 131, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6827, 21007, 132, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6828, 18007, 133, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6829, 13007, 134, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6830, 11007, 135, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6831, 10007, 136, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6832, 9007, 137, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6833, 8007, 138, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6834, 7007, 139, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6835, 5007, 140, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6836, 4007, 141, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6837, 3007, 142, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6838, 2007, 143, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6839, 1007, 144, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6840, 21008, 145, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6841, 18008, 146, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6842, 13008, 147, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6843, 10008, 148, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6844, 9008, 149, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6845, 8008, 150, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6846, 7008, 151, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6847, 5008, 152, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6848, 4008, 153, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6849, 3008, 154, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6850, 2008, 155, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6851, 1008, 156, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6852, 18009, 157, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6853, 10009, 158, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6854, 9009, 159, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6855, 8009, 160, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6856, 7009, 161, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6857, 5009, 162, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6858, 4009, 163, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6859, 3009, 164, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6860, 2009, 165, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6861, 1009, 166, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6862, 10010, 167, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6863, 9010, 168, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6864, 8010, 169, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6865, 7010, 170, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6866, 5010, 171, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6867, 4010, 172, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6868, 3010, 173, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6869, 2010, 174, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6870, 1010, 175, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6871, 8011, 176, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6872, 7011, 177, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6873, 5011, 178, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6874, 3011, 179, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6875, 2011, 180, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6876, 1011, 181, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6877, 8012, 182, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6878, 7012, 183, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6879, 5012, 184, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6880, 3012, 185, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6881, 2012, 186, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6882, 1012, 187, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6883, 7013, 188, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6884, 5013, 189, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6885, 3013, 190, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6886, 2013, 191, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6887, 1013, 192, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6888, 7014, 193, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6889, 5014, 194, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6890, 3014, 195, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6891, 2014, 196, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6892, 1014, 197, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6893, 7015, 198, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6894, 5015, 199, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6895, 3015, 200, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6896, 2015, 201, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6897, 1015, 202, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6898, 7016, 203, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6899, 5016, 204, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6900, 2016, 205, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6901, 1016, 206, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6902, 7017, 207, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6903, 2017, 208, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6904, 1017, 209, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6905, 7018, 210, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6906, 2018, 211, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6907, 1018, 212, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6908, 7019, 213, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6909, 1019, 214, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6910, 7020, 215, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6911, 1020, 216, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6912, 7021, 217, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6913, 1021, 218, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6914, 7022, 219, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6915, 1022, 220, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6916, 7023, 221, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6917, 1023, 222, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6918, 7024, 223, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6919, 1024, 224, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6920, 7025, 225, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6921, 1025, 226, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6922, 7026, 227, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6923, 1026, 228, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6924, 7027, 229, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6925, 1027, 230, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6926, 7028, 231, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6927, 1028, 232, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6928, 7029, 233, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6929, 1029, 234, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6930, 7030, 235, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6931, 1030, 236, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6932, 7031, 237, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (6933, 1031, 238, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend` VALUES (6934, 7032, 239, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 1);
INSERT INTO `goods_recommend` VALUES (9082, 23001, 1, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9083, 22001, 2, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9084, 21001, 3, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9085, 20001, 4, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9086, 19001, 5, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9087, 18001, 6, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9088, 17001, 7, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9089, 16001, 8, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9090, 15001, 9, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9091, 14001, 10, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9092, 13001, 11, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9093, 12001, 12, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9094, 11001, 13, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9095, 10001, 14, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9096, 9001, 15, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9097, 8001, 16, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9098, 7001, 17, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9099, 6001, 18, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9100, 5001, 19, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9101, 4001, 20, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9102, 3001, 21, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9103, 2001, 22, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9104, 1001, 23, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9105, 23002, 24, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9106, 22002, 25, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9107, 21002, 26, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9108, 20002, 27, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9109, 19002, 28, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9110, 18002, 29, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9111, 17002, 30, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9112, 16002, 31, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9113, 15002, 32, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9114, 14002, 33, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9115, 13002, 34, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9116, 12002, 35, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9117, 11002, 36, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9118, 10002, 37, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9119, 9002, 38, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9120, 8002, 39, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9121, 7002, 40, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9122, 6002, 41, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9123, 5002, 42, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9124, 4002, 43, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9125, 3002, 44, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9126, 2002, 45, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9127, 1002, 46, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9128, 23003, 47, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9129, 22003, 48, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9130, 21003, 49, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9131, 20003, 50, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9132, 19003, 51, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9133, 18003, 52, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9134, 17003, 53, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9135, 16003, 54, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9136, 15003, 55, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9137, 14003, 56, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9138, 13003, 57, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9139, 12003, 58, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9140, 10003, 59, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9141, 9003, 60, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9142, 1003, 61, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9143, 23004, 62, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9144, 22004, 63, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9145, 21004, 64, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9146, 18004, 65, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9147, 17004, 66, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9148, 23006, 67, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9149, 23005, 68, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9150, 22005, 69, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9151, 21005, 70, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9152, 18005, 71, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9153, 1005, 72, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9154, 11006, 73, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9155, 21007, 74, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9156, 18007, 75, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9157, 21008, 76, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9158, 1009, 77, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9159, 1024, 78, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9160, 1031, 79, '2026-08-13', '2026-08-13 21:08:34', '2026-08-13 21:08:34', 0);
INSERT INTO `goods_recommend` VALUES (9951, 4001, 1, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9952, 1005, 2, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9953, 23001, 3, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9954, 22001, 4, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9955, 21001, 5, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9956, 20001, 6, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9957, 19001, 7, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9958, 18001, 8, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9959, 17001, 9, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9960, 16001, 10, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9961, 15001, 11, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9962, 14001, 12, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9963, 13001, 13, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9964, 12001, 14, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9965, 11001, 15, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9966, 10001, 16, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9967, 9001, 17, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9968, 8001, 18, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9969, 7001, 19, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9970, 6001, 20, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9971, 5001, 21, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9972, 3001, 22, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9973, 2001, 23, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9974, 1001, 24, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9975, 23002, 25, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9976, 22002, 26, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9977, 21002, 27, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9978, 20002, 28, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9979, 19002, 29, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9980, 18002, 30, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9981, 17002, 31, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9982, 16002, 32, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9983, 15002, 33, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9984, 14002, 34, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9985, 13002, 35, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9986, 12002, 36, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9987, 11002, 37, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9988, 10002, 38, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9989, 9002, 39, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9990, 8002, 40, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9991, 7002, 41, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9992, 6002, 42, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9993, 5002, 43, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9994, 4002, 44, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9995, 3002, 45, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9996, 2002, 46, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9997, 1002, 47, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9998, 23003, 48, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (9999, 22003, 49, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10000, 21003, 50, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10001, 20003, 51, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10002, 19003, 52, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10003, 18003, 53, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10004, 17003, 54, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10005, 16003, 55, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10006, 15003, 56, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10007, 14003, 57, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10008, 13003, 58, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10009, 12003, 59, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10010, 10003, 60, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10011, 9003, 61, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10012, 1003, 62, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10013, 23004, 63, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10014, 22004, 64, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10015, 21004, 65, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10016, 18004, 66, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10017, 17004, 67, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10018, 23006, 68, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10019, 23005, 69, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10020, 22005, 70, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10021, 21005, 71, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10022, 18005, 72, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10023, 11006, 73, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10024, 21007, 74, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10025, 18007, 75, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10026, 21008, 76, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10027, 1009, 77, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10028, 1024, 78, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);
INSERT INTO `goods_recommend` VALUES (10029, 1031, 79, '2026-08-14', '2026-08-14 16:14:33', '2026-08-14 16:14:33', 0);

-- ----------------------------
-- Table structure for goods_recommend_bak_0813
-- ----------------------------
DROP TABLE IF EXISTS `goods_recommend_bak_0813`;
CREATE TABLE `goods_recommend_bak_0813`  (
  `id` bigint(0) NOT NULL DEFAULT 0,
  `spu_id` bigint(0) NOT NULL COMMENT '商品SPU ID',
  `rank` int(0) NOT NULL COMMENT '推荐排名(1起,越小越靠前)',
  `recommend_date` date NOT NULL COMMENT '推荐日期(每日快照)',
  `create_time` datetime(0) NOT NULL COMMENT '快照生成时间',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `deleted` int(0) NULL DEFAULT 0
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_recommend_bak_0813
-- ----------------------------
INSERT INTO `goods_recommend_bak_0813` VALUES (2155, 23001, 1, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2156, 22001, 2, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2157, 21001, 3, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2158, 20001, 4, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2159, 19001, 5, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2160, 18001, 6, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2161, 17001, 7, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2162, 16001, 8, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2163, 15001, 9, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2164, 14001, 10, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2165, 13001, 11, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2166, 12001, 12, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2167, 11001, 13, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2168, 10001, 14, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2169, 9001, 15, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2170, 8001, 16, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2171, 7001, 17, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2172, 6001, 18, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2173, 5001, 19, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2174, 4001, 20, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2175, 3001, 21, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2176, 2001, 22, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2177, 1001, 23, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2178, 23002, 24, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2179, 22002, 25, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2180, 21002, 26, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2181, 20002, 27, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2182, 19002, 28, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2183, 18002, 29, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2184, 17002, 30, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2185, 16002, 31, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2186, 15002, 32, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2187, 14002, 33, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2188, 13002, 34, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2189, 12002, 35, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2190, 11002, 36, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2191, 10002, 37, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:12', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2192, 9002, 38, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2193, 8002, 39, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2194, 7002, 40, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2195, 6002, 41, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2196, 5002, 42, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2197, 4002, 43, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2198, 3002, 44, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2199, 2002, 45, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2200, 1002, 46, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2201, 23003, 47, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2202, 22003, 48, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2203, 21003, 49, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2204, 20003, 50, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2205, 19003, 51, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2206, 18003, 52, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2207, 17003, 53, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2208, 16003, 54, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2209, 15003, 55, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2210, 14003, 56, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2211, 13003, 57, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2212, 12003, 58, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2213, 11003, 59, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2214, 10003, 60, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2215, 9003, 61, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2216, 8003, 62, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2217, 7003, 63, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2218, 6003, 64, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2219, 5003, 65, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2220, 4003, 66, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2221, 3003, 67, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2222, 2003, 68, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2223, 1003, 69, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2224, 23004, 70, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2225, 22004, 71, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2226, 21004, 72, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2227, 20004, 73, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2228, 19004, 74, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2229, 18004, 75, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2230, 17004, 76, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2231, 16004, 77, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2232, 15004, 78, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2233, 14004, 79, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2234, 13004, 80, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2235, 12004, 81, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2236, 11004, 82, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2237, 10004, 83, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2238, 9004, 84, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2239, 8004, 85, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2240, 7004, 86, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2241, 6004, 87, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2242, 5004, 88, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2243, 4004, 89, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2244, 3004, 90, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2245, 2004, 91, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2246, 1004, 92, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2247, 23006, 93, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2248, 23005, 94, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2249, 22005, 95, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2250, 21005, 96, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2251, 20005, 97, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2252, 18005, 98, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2253, 17005, 99, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2254, 16005, 100, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2255, 15005, 101, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2256, 13005, 102, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2257, 11005, 103, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2258, 10005, 104, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2259, 9005, 105, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2260, 8005, 106, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2261, 7005, 107, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2262, 6005, 108, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2263, 5005, 109, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2264, 4005, 110, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2265, 3005, 111, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2266, 2005, 112, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2267, 1005, 113, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2268, 21006, 114, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2269, 20006, 115, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2270, 18006, 116, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2271, 17006, 117, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2272, 16006, 118, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2273, 15006, 119, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2274, 13006, 120, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2275, 11006, 121, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2276, 10006, 122, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2277, 9006, 123, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2278, 8006, 124, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2279, 7006, 125, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2280, 6006, 126, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2281, 5006, 127, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2282, 4006, 128, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2283, 3006, 129, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2284, 2006, 130, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2285, 1006, 131, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2286, 21007, 132, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2287, 18007, 133, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2288, 13007, 134, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2289, 11007, 135, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2290, 10007, 136, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2291, 9007, 137, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2292, 8007, 138, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2293, 7007, 139, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2294, 5007, 140, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2295, 4007, 141, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2296, 3007, 142, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2297, 2007, 143, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2298, 1007, 144, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2299, 21008, 145, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2300, 18008, 146, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2301, 13008, 147, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2302, 10008, 148, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2303, 9008, 149, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2304, 8008, 150, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2305, 7008, 151, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2306, 5008, 152, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2307, 4008, 153, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2308, 3008, 154, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2309, 2008, 155, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2310, 1008, 156, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2311, 18009, 157, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2312, 10009, 158, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2313, 9009, 159, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2314, 8009, 160, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2315, 7009, 161, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2316, 5009, 162, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2317, 4009, 163, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2318, 3009, 164, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2319, 2009, 165, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2320, 1009, 166, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2321, 10010, 167, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2322, 9010, 168, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2323, 8010, 169, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2324, 7010, 170, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2325, 5010, 171, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2326, 4010, 172, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2327, 3010, 173, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2328, 2010, 174, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2329, 1010, 175, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2330, 8011, 176, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2331, 7011, 177, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2332, 5011, 178, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2333, 3011, 179, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2334, 2011, 180, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2335, 1011, 181, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2336, 8012, 182, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2337, 7012, 183, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2338, 5012, 184, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2339, 3012, 185, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2340, 2012, 186, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2341, 1012, 187, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2342, 7013, 188, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2343, 5013, 189, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2344, 3013, 190, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2345, 2013, 191, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2346, 1013, 192, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2347, 7014, 193, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2348, 5014, 194, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2349, 3014, 195, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2350, 2014, 196, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2351, 1014, 197, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2352, 7015, 198, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2353, 5015, 199, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2354, 3015, 200, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2355, 2015, 201, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2356, 1015, 202, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2357, 7016, 203, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2358, 5016, 204, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2359, 2016, 205, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2360, 1016, 206, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2361, 7017, 207, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2362, 2017, 208, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2363, 1017, 209, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2364, 7018, 210, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2365, 2018, 211, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2366, 1018, 212, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2367, 7019, 213, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2368, 1019, 214, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2369, 7020, 215, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2370, 1020, 216, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2371, 7021, 217, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2372, 1021, 218, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2373, 7022, 219, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2374, 1022, 220, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2375, 7023, 221, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2376, 1023, 222, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2377, 7024, 223, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2378, 1024, 224, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2379, 7025, 225, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2380, 1025, 226, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2381, 7026, 227, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2382, 1026, 228, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2383, 7027, 229, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2384, 1027, 230, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2385, 7028, 231, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2386, 1028, 232, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2387, 7029, 233, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2388, 1029, 234, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2389, 7030, 235, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2390, 1030, 236, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2391, 7031, 237, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2392, 1031, 238, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (2393, 7032, 239, '2026-08-09', '2026-08-09 23:20:12', '2026-08-09 23:20:13', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3589, 23001, 1, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3590, 22001, 2, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3591, 21001, 3, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3592, 20001, 4, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3593, 19001, 5, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3594, 18001, 6, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3595, 17001, 7, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3596, 16001, 8, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3597, 15001, 9, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3598, 14001, 10, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3599, 13001, 11, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3600, 12001, 12, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3601, 11001, 13, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3602, 10001, 14, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3603, 9001, 15, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3604, 8001, 16, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3605, 7001, 17, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3606, 6001, 18, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3607, 5001, 19, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3608, 4001, 20, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3609, 3001, 21, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3610, 2001, 22, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3611, 1001, 23, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3612, 23002, 24, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3613, 22002, 25, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3614, 21002, 26, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3615, 20002, 27, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3616, 19002, 28, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3617, 18002, 29, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3618, 17002, 30, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3619, 16002, 31, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3620, 15002, 32, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3621, 14002, 33, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3622, 13002, 34, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3623, 12002, 35, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3624, 11002, 36, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3625, 10002, 37, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3626, 9002, 38, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3627, 8002, 39, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3628, 7002, 40, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3629, 6002, 41, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3630, 5002, 42, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3631, 4002, 43, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3632, 3002, 44, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3633, 2002, 45, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3634, 1002, 46, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3635, 23003, 47, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3636, 22003, 48, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3637, 21003, 49, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3638, 20003, 50, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3639, 19003, 51, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3640, 18003, 52, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3641, 17003, 53, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3642, 16003, 54, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3643, 15003, 55, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3644, 14003, 56, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3645, 13003, 57, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3646, 12003, 58, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3647, 11003, 59, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3648, 10003, 60, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3649, 9003, 61, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3650, 8003, 62, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3651, 7003, 63, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3652, 6003, 64, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3653, 5003, 65, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3654, 4003, 66, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3655, 3003, 67, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3656, 2003, 68, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3657, 1003, 69, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3658, 23004, 70, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3659, 22004, 71, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3660, 21004, 72, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3661, 20004, 73, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3662, 19004, 74, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3663, 18004, 75, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3664, 17004, 76, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3665, 16004, 77, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3666, 15004, 78, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3667, 14004, 79, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3668, 13004, 80, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3669, 12004, 81, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3670, 11004, 82, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3671, 10004, 83, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3672, 9004, 84, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3673, 8004, 85, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3674, 7004, 86, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3675, 6004, 87, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3676, 5004, 88, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3677, 4004, 89, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3678, 3004, 90, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3679, 2004, 91, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3680, 1004, 92, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3681, 23006, 93, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3682, 23005, 94, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3683, 22005, 95, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3684, 21005, 96, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3685, 20005, 97, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3686, 18005, 98, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3687, 17005, 99, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3688, 16005, 100, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3689, 15005, 101, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3690, 13005, 102, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3691, 11005, 103, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3692, 10005, 104, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3693, 9005, 105, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3694, 8005, 106, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3695, 7005, 107, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3696, 6005, 108, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3697, 5005, 109, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3698, 4005, 110, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3699, 3005, 111, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3700, 2005, 112, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3701, 1005, 113, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3702, 21006, 114, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3703, 20006, 115, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3704, 18006, 116, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3705, 17006, 117, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3706, 16006, 118, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3707, 15006, 119, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3708, 13006, 120, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3709, 11006, 121, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3710, 10006, 122, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3711, 9006, 123, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3712, 8006, 124, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3713, 7006, 125, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3714, 6006, 126, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3715, 5006, 127, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3716, 4006, 128, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3717, 3006, 129, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3718, 2006, 130, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3719, 1006, 131, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3720, 21007, 132, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3721, 18007, 133, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3722, 13007, 134, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3723, 11007, 135, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3724, 10007, 136, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3725, 9007, 137, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3726, 8007, 138, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3727, 7007, 139, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3728, 5007, 140, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3729, 4007, 141, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3730, 3007, 142, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3731, 2007, 143, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3732, 1007, 144, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3733, 21008, 145, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3734, 18008, 146, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3735, 13008, 147, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3736, 10008, 148, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3737, 9008, 149, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3738, 8008, 150, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3739, 7008, 151, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3740, 5008, 152, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3741, 4008, 153, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3742, 3008, 154, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3743, 2008, 155, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3744, 1008, 156, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3745, 18009, 157, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3746, 10009, 158, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3747, 9009, 159, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3748, 8009, 160, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3749, 7009, 161, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3750, 5009, 162, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3751, 4009, 163, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3752, 3009, 164, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3753, 2009, 165, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3754, 1009, 166, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3755, 10010, 167, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3756, 9010, 168, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3757, 8010, 169, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3758, 7010, 170, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3759, 5010, 171, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3760, 4010, 172, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3761, 3010, 173, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3762, 2010, 174, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3763, 1010, 175, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3764, 8011, 176, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3765, 7011, 177, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3766, 5011, 178, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3767, 3011, 179, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3768, 2011, 180, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3769, 1011, 181, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3770, 8012, 182, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3771, 7012, 183, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3772, 5012, 184, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3773, 3012, 185, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3774, 2012, 186, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3775, 1012, 187, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3776, 7013, 188, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3777, 5013, 189, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3778, 3013, 190, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3779, 2013, 191, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3780, 1013, 192, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3781, 7014, 193, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3782, 5014, 194, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3783, 3014, 195, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3784, 2014, 196, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3785, 1014, 197, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3786, 7015, 198, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3787, 5015, 199, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3788, 3015, 200, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3789, 2015, 201, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3790, 1015, 202, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3791, 7016, 203, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3792, 5016, 204, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3793, 2016, 205, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3794, 1016, 206, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3795, 7017, 207, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3796, 2017, 208, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3797, 1017, 209, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3798, 7018, 210, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3799, 2018, 211, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3800, 1018, 212, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3801, 7019, 213, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3802, 1019, 214, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3803, 7020, 215, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3804, 1020, 216, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3805, 7021, 217, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3806, 1021, 218, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3807, 7022, 219, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3808, 1022, 220, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3809, 7023, 221, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3810, 1023, 222, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3811, 7024, 223, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3812, 1024, 224, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3813, 7025, 225, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3814, 1025, 226, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3815, 7026, 227, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3816, 1026, 228, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3817, 7027, 229, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3818, 1027, 230, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3819, 7028, 231, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3820, 1028, 232, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3821, 7029, 233, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3822, 1029, 234, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3823, 7030, 235, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3824, 1030, 236, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3825, 7031, 237, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3826, 1031, 238, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (3827, 7032, 239, '2026-08-10', '2026-08-10 17:12:43', '2026-08-10 17:12:43', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5262, 23001, 1, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5263, 22001, 2, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5264, 21001, 3, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5265, 20001, 4, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5266, 19001, 5, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5267, 18001, 6, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5268, 17001, 7, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5269, 16001, 8, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5270, 15001, 9, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5271, 14001, 10, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5272, 13001, 11, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5273, 12001, 12, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5274, 11001, 13, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5275, 10001, 14, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5276, 9001, 15, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5277, 8001, 16, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5278, 7001, 17, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5279, 6001, 18, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5280, 5001, 19, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5281, 4001, 20, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5282, 3001, 21, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5283, 2001, 22, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5284, 1001, 23, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5285, 23002, 24, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5286, 22002, 25, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5287, 21002, 26, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5288, 20002, 27, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5289, 19002, 28, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5290, 18002, 29, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5291, 17002, 30, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5292, 16002, 31, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5293, 15002, 32, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5294, 14002, 33, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5295, 13002, 34, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5296, 12002, 35, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5297, 11002, 36, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5298, 10002, 37, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5299, 9002, 38, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5300, 8002, 39, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5301, 7002, 40, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5302, 6002, 41, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5303, 5002, 42, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5304, 4002, 43, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5305, 3002, 44, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5306, 2002, 45, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5307, 1002, 46, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5308, 23003, 47, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5309, 22003, 48, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5310, 21003, 49, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5311, 20003, 50, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5312, 19003, 51, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5313, 18003, 52, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5314, 17003, 53, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5315, 16003, 54, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5316, 15003, 55, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5317, 14003, 56, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5318, 13003, 57, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5319, 12003, 58, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5320, 11003, 59, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5321, 10003, 60, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5322, 9003, 61, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5323, 8003, 62, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5324, 7003, 63, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5325, 6003, 64, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5326, 5003, 65, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5327, 4003, 66, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5328, 3003, 67, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5329, 2003, 68, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5330, 1003, 69, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5331, 23004, 70, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5332, 22004, 71, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5333, 21004, 72, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5334, 20004, 73, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5335, 19004, 74, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5336, 18004, 75, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5337, 17004, 76, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5338, 16004, 77, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5339, 15004, 78, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5340, 14004, 79, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5341, 13004, 80, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5342, 12004, 81, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5343, 11004, 82, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5344, 10004, 83, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5345, 9004, 84, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5346, 8004, 85, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5347, 7004, 86, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5348, 6004, 87, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5349, 5004, 88, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5350, 4004, 89, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5351, 3004, 90, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5352, 2004, 91, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5353, 1004, 92, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5354, 23006, 93, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5355, 23005, 94, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5356, 22005, 95, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5357, 21005, 96, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5358, 20005, 97, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:56', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5359, 18005, 98, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5360, 17005, 99, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5361, 16005, 100, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5362, 15005, 101, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5363, 13005, 102, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5364, 11005, 103, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5365, 10005, 104, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5366, 9005, 105, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5367, 8005, 106, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5368, 7005, 107, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5369, 6005, 108, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5370, 5005, 109, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5371, 4005, 110, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5372, 3005, 111, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5373, 2005, 112, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5374, 1005, 113, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5375, 21006, 114, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5376, 20006, 115, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5377, 18006, 116, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5378, 17006, 117, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5379, 16006, 118, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5380, 15006, 119, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5381, 13006, 120, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5382, 11006, 121, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5383, 10006, 122, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5384, 9006, 123, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5385, 8006, 124, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5386, 7006, 125, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5387, 6006, 126, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5388, 5006, 127, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5389, 4006, 128, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5390, 3006, 129, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5391, 2006, 130, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5392, 1006, 131, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5393, 21007, 132, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5394, 18007, 133, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5395, 13007, 134, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5396, 11007, 135, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5397, 10007, 136, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5398, 9007, 137, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5399, 8007, 138, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5400, 7007, 139, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5401, 5007, 140, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5402, 4007, 141, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5403, 3007, 142, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5404, 2007, 143, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5405, 1007, 144, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5406, 21008, 145, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5407, 18008, 146, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5408, 13008, 147, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5409, 10008, 148, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5410, 9008, 149, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5411, 8008, 150, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5412, 7008, 151, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5413, 5008, 152, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5414, 4008, 153, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5415, 3008, 154, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5416, 2008, 155, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5417, 1008, 156, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5418, 18009, 157, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5419, 10009, 158, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5420, 9009, 159, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5421, 8009, 160, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5422, 7009, 161, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5423, 5009, 162, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5424, 4009, 163, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5425, 3009, 164, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5426, 2009, 165, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5427, 1009, 166, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5428, 10010, 167, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5429, 9010, 168, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5430, 8010, 169, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5431, 7010, 170, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5432, 5010, 171, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5433, 4010, 172, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5434, 3010, 173, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5435, 2010, 174, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5436, 1010, 175, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5437, 8011, 176, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5438, 7011, 177, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5439, 5011, 178, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5440, 3011, 179, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5441, 2011, 180, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5442, 1011, 181, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5443, 8012, 182, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5444, 7012, 183, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5445, 5012, 184, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5446, 3012, 185, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5447, 2012, 186, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5448, 1012, 187, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5449, 7013, 188, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5450, 5013, 189, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5451, 3013, 190, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5452, 2013, 191, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5453, 1013, 192, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5454, 7014, 193, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5455, 5014, 194, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5456, 3014, 195, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5457, 2014, 196, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5458, 1014, 197, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5459, 7015, 198, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5460, 5015, 199, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5461, 3015, 200, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5462, 2015, 201, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5463, 1015, 202, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5464, 7016, 203, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5465, 5016, 204, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5466, 2016, 205, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5467, 1016, 206, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5468, 7017, 207, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5469, 2017, 208, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5470, 1017, 209, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5471, 7018, 210, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5472, 2018, 211, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5473, 1018, 212, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5474, 7019, 213, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5475, 1019, 214, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5476, 7020, 215, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5477, 1020, 216, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5478, 7021, 217, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5479, 1021, 218, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5480, 7022, 219, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5481, 1022, 220, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5482, 7023, 221, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5483, 1023, 222, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5484, 7024, 223, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5485, 1024, 224, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5486, 7025, 225, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5487, 1025, 226, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5488, 7026, 227, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5489, 1026, 228, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5490, 7027, 229, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5491, 1027, 230, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5492, 7028, 231, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5493, 1028, 232, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5494, 7029, 233, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5495, 1029, 234, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5496, 7030, 235, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5497, 1030, 236, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5498, 7031, 237, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5499, 1031, 238, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (5500, 7032, 239, '2026-08-11', '2026-08-11 17:59:56', '2026-08-11 17:59:57', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6696, 23001, 1, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6697, 22001, 2, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6698, 21001, 3, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6699, 20001, 4, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6700, 19001, 5, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6701, 18001, 6, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6702, 17001, 7, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6703, 16001, 8, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6704, 15001, 9, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6705, 14001, 10, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6706, 13001, 11, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6707, 12001, 12, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6708, 11001, 13, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6709, 10001, 14, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6710, 9001, 15, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6711, 8001, 16, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6712, 7001, 17, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6713, 6001, 18, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6714, 5001, 19, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6715, 4001, 20, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6716, 3001, 21, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6717, 2001, 22, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6718, 1001, 23, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6719, 23002, 24, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6720, 22002, 25, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:37', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6721, 21002, 26, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6722, 20002, 27, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6723, 19002, 28, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6724, 18002, 29, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6725, 17002, 30, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6726, 16002, 31, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6727, 15002, 32, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6728, 14002, 33, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6729, 13002, 34, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6730, 12002, 35, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6731, 11002, 36, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6732, 10002, 37, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6733, 9002, 38, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6734, 8002, 39, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6735, 7002, 40, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6736, 6002, 41, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6737, 5002, 42, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6738, 4002, 43, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6739, 3002, 44, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6740, 2002, 45, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6741, 1002, 46, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6742, 23003, 47, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6743, 22003, 48, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6744, 21003, 49, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6745, 20003, 50, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6746, 19003, 51, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6747, 18003, 52, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6748, 17003, 53, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6749, 16003, 54, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6750, 15003, 55, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6751, 14003, 56, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6752, 13003, 57, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6753, 12003, 58, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6754, 11003, 59, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6755, 10003, 60, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6756, 9003, 61, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6757, 8003, 62, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6758, 7003, 63, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6759, 6003, 64, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6760, 5003, 65, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6761, 4003, 66, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6762, 3003, 67, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6763, 2003, 68, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6764, 1003, 69, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6765, 23004, 70, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6766, 22004, 71, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6767, 21004, 72, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6768, 20004, 73, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6769, 19004, 74, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6770, 18004, 75, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6771, 17004, 76, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6772, 16004, 77, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6773, 15004, 78, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6774, 14004, 79, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6775, 13004, 80, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6776, 12004, 81, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6777, 11004, 82, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6778, 10004, 83, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6779, 9004, 84, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6780, 8004, 85, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6781, 7004, 86, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6782, 6004, 87, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6783, 5004, 88, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6784, 4004, 89, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6785, 3004, 90, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6786, 2004, 91, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6787, 1004, 92, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6788, 23006, 93, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6789, 23005, 94, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6790, 22005, 95, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6791, 21005, 96, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6792, 20005, 97, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6793, 18005, 98, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6794, 17005, 99, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6795, 16005, 100, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6796, 15005, 101, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6797, 13005, 102, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6798, 11005, 103, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6799, 10005, 104, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6800, 9005, 105, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6801, 8005, 106, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6802, 7005, 107, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6803, 6005, 108, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6804, 5005, 109, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6805, 4005, 110, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6806, 3005, 111, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6807, 2005, 112, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6808, 1005, 113, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6809, 21006, 114, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6810, 20006, 115, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6811, 18006, 116, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6812, 17006, 117, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6813, 16006, 118, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6814, 15006, 119, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6815, 13006, 120, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6816, 11006, 121, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6817, 10006, 122, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6818, 9006, 123, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6819, 8006, 124, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6820, 7006, 125, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6821, 6006, 126, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6822, 5006, 127, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6823, 4006, 128, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6824, 3006, 129, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6825, 2006, 130, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6826, 1006, 131, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6827, 21007, 132, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6828, 18007, 133, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6829, 13007, 134, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6830, 11007, 135, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6831, 10007, 136, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6832, 9007, 137, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6833, 8007, 138, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6834, 7007, 139, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6835, 5007, 140, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6836, 4007, 141, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6837, 3007, 142, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6838, 2007, 143, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6839, 1007, 144, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6840, 21008, 145, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6841, 18008, 146, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6842, 13008, 147, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6843, 10008, 148, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6844, 9008, 149, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6845, 8008, 150, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6846, 7008, 151, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6847, 5008, 152, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6848, 4008, 153, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6849, 3008, 154, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6850, 2008, 155, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6851, 1008, 156, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6852, 18009, 157, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6853, 10009, 158, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6854, 9009, 159, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6855, 8009, 160, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6856, 7009, 161, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6857, 5009, 162, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6858, 4009, 163, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6859, 3009, 164, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6860, 2009, 165, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6861, 1009, 166, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6862, 10010, 167, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6863, 9010, 168, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6864, 8010, 169, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6865, 7010, 170, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6866, 5010, 171, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6867, 4010, 172, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6868, 3010, 173, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6869, 2010, 174, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6870, 1010, 175, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6871, 8011, 176, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6872, 7011, 177, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6873, 5011, 178, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6874, 3011, 179, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6875, 2011, 180, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6876, 1011, 181, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6877, 8012, 182, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6878, 7012, 183, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6879, 5012, 184, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6880, 3012, 185, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6881, 2012, 186, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6882, 1012, 187, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6883, 7013, 188, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6884, 5013, 189, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6885, 3013, 190, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6886, 2013, 191, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6887, 1013, 192, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6888, 7014, 193, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6889, 5014, 194, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6890, 3014, 195, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6891, 2014, 196, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6892, 1014, 197, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6893, 7015, 198, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6894, 5015, 199, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6895, 3015, 200, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6896, 2015, 201, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6897, 1015, 202, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6898, 7016, 203, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6899, 5016, 204, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6900, 2016, 205, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6901, 1016, 206, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6902, 7017, 207, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6903, 2017, 208, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6904, 1017, 209, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6905, 7018, 210, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6906, 2018, 211, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6907, 1018, 212, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6908, 7019, 213, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6909, 1019, 214, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6910, 7020, 215, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6911, 1020, 216, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6912, 7021, 217, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6913, 1021, 218, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6914, 7022, 219, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6915, 1022, 220, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6916, 7023, 221, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6917, 1023, 222, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6918, 7024, 223, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6919, 1024, 224, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6920, 7025, 225, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6921, 1025, 226, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6922, 7026, 227, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6923, 1026, 228, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6924, 7027, 229, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6925, 1027, 230, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6926, 7028, 231, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6927, 1028, 232, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6928, 7029, 233, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6929, 1029, 234, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6930, 7030, 235, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6931, 1030, 236, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6932, 7031, 237, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6933, 1031, 238, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (6934, 7032, 239, '2026-08-12', '2026-08-12 15:33:37', '2026-08-12 15:33:38', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8369, 23001, 1, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8370, 22001, 2, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8371, 21001, 3, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8372, 20001, 4, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8373, 19001, 5, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8374, 18001, 6, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8375, 17001, 7, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8376, 16001, 8, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8377, 15001, 9, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8378, 14001, 10, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8379, 13001, 11, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8380, 12001, 12, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8381, 11001, 13, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8382, 10001, 14, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8383, 9001, 15, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8384, 8001, 16, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8385, 7001, 17, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8386, 6001, 18, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8387, 5001, 19, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8388, 4001, 20, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8389, 3001, 21, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8390, 2001, 22, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8391, 1001, 23, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8392, 23002, 24, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8393, 22002, 25, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8394, 21002, 26, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8395, 20002, 27, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8396, 19002, 28, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8397, 18002, 29, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8398, 17002, 30, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8399, 16002, 31, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8400, 15002, 32, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8401, 14002, 33, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8402, 13002, 34, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8403, 12002, 35, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8404, 11002, 36, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8405, 10002, 37, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8406, 9002, 38, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8407, 8002, 39, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8408, 7002, 40, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8409, 6002, 41, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8410, 5002, 42, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8411, 4002, 43, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8412, 3002, 44, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8413, 2002, 45, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8414, 1002, 46, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8415, 23003, 47, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8416, 22003, 48, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8417, 21003, 49, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8418, 20003, 50, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8419, 19003, 51, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8420, 18003, 52, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8421, 17003, 53, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8422, 16003, 54, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8423, 15003, 55, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8424, 14003, 56, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8425, 13003, 57, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8426, 12003, 58, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8427, 11003, 59, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8428, 10003, 60, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8429, 9003, 61, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8430, 8003, 62, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8431, 7003, 63, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8432, 6003, 64, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8433, 5003, 65, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8434, 4003, 66, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8435, 3003, 67, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8436, 2003, 68, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8437, 1003, 69, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8438, 23004, 70, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8439, 22004, 71, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8440, 21004, 72, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8441, 20004, 73, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8442, 19004, 74, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8443, 18004, 75, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8444, 17004, 76, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8445, 16004, 77, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8446, 15004, 78, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8447, 14004, 79, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8448, 13004, 80, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8449, 12004, 81, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8450, 11004, 82, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8451, 10004, 83, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8452, 9004, 84, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8453, 8004, 85, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8454, 7004, 86, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8455, 6004, 87, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8456, 5004, 88, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8457, 4004, 89, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8458, 3004, 90, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8459, 2004, 91, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8460, 1004, 92, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8461, 23006, 93, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8462, 23005, 94, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8463, 22005, 95, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8464, 21005, 96, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8465, 20005, 97, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8466, 18005, 98, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8467, 17005, 99, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8468, 16005, 100, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8469, 15005, 101, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8470, 13005, 102, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8471, 11005, 103, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8472, 10005, 104, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8473, 9005, 105, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8474, 8005, 106, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8475, 7005, 107, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8476, 6005, 108, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8477, 5005, 109, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8478, 4005, 110, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8479, 3005, 111, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8480, 2005, 112, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8481, 1005, 113, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8482, 21006, 114, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8483, 20006, 115, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8484, 18006, 116, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8485, 17006, 117, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8486, 16006, 118, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8487, 15006, 119, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8488, 13006, 120, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8489, 11006, 121, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8490, 10006, 122, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8491, 9006, 123, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8492, 8006, 124, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8493, 7006, 125, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8494, 6006, 126, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8495, 5006, 127, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8496, 4006, 128, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8497, 3006, 129, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8498, 2006, 130, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8499, 1006, 131, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8500, 21007, 132, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8501, 18007, 133, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8502, 13007, 134, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8503, 11007, 135, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8504, 10007, 136, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8505, 9007, 137, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8506, 8007, 138, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8507, 7007, 139, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8508, 5007, 140, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8509, 4007, 141, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8510, 3007, 142, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8511, 2007, 143, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8512, 1007, 144, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8513, 21008, 145, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8514, 18008, 146, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8515, 13008, 147, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8516, 10008, 148, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8517, 9008, 149, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8518, 8008, 150, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8519, 7008, 151, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8520, 5008, 152, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8521, 4008, 153, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8522, 3008, 154, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8523, 2008, 155, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8524, 1008, 156, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8525, 18009, 157, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8526, 10009, 158, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8527, 9009, 159, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8528, 8009, 160, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8529, 7009, 161, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8530, 5009, 162, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8531, 4009, 163, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8532, 3009, 164, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8533, 2009, 165, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8534, 1009, 166, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8535, 10010, 167, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8536, 9010, 168, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8537, 8010, 169, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8538, 7010, 170, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8539, 5010, 171, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8540, 4010, 172, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8541, 3010, 173, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8542, 2010, 174, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8543, 1010, 175, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8544, 8011, 176, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8545, 7011, 177, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8546, 5011, 178, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8547, 3011, 179, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8548, 2011, 180, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8549, 1011, 181, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8550, 8012, 182, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8551, 7012, 183, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8552, 5012, 184, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8553, 3012, 185, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8554, 2012, 186, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8555, 1012, 187, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8556, 7013, 188, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8557, 5013, 189, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8558, 3013, 190, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8559, 2013, 191, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8560, 1013, 192, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8561, 7014, 193, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8562, 5014, 194, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8563, 3014, 195, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8564, 2014, 196, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8565, 1014, 197, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8566, 7015, 198, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8567, 5015, 199, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8568, 3015, 200, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8569, 2015, 201, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8570, 1015, 202, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8571, 7016, 203, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8572, 5016, 204, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8573, 2016, 205, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8574, 1016, 206, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8575, 7017, 207, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8576, 2017, 208, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8577, 1017, 209, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8578, 7018, 210, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8579, 2018, 211, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8580, 1018, 212, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8581, 7019, 213, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8582, 1019, 214, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8583, 7020, 215, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8584, 1020, 216, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8585, 7021, 217, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8586, 1021, 218, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8587, 7022, 219, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8588, 1022, 220, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8589, 7023, 221, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8590, 1023, 222, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8591, 7024, 223, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8592, 1024, 224, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8593, 7025, 225, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8594, 1025, 226, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8595, 7026, 227, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8596, 1026, 228, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8597, 7027, 229, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8598, 1027, 230, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8599, 7028, 231, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8600, 1028, 232, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8601, 7029, 233, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8602, 1029, 234, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8603, 7030, 235, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8604, 1030, 236, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8605, 7031, 237, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8606, 1031, 238, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);
INSERT INTO `goods_recommend_bak_0813` VALUES (8607, 7032, 239, '2026-08-13', '2026-08-13 15:16:44', '2026-08-13 15:16:44', 0);

-- ----------------------------
-- Table structure for goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `goods_sku`;
CREATE TABLE `goods_sku`  (
  `id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `spu_id` bigint unsigned NOT NULL COMMENT 'SPU ID',
  `sku_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格名称(如500g)',
  `price` decimal(10, 2) NOT NULL COMMENT '售价',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价(划线价)',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SKU图片',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0-停用 1-启用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_spu_sku`(`spu_id`, `sku_name`) USING BTREE,
  INDEX `idx_spu_id`(`spu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23007 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品SKU表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_sku
-- ----------------------------
INSERT INTO `goods_sku` VALUES (2001, 1001, '250g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2002, 1001, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2003, 1002, '300g/份', 3.29, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2004, 1002, '500g/份', 3.29, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2005, 1003, '300g/份', 4.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2006, 1004, '300g/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2007, 1005, '1颗约2kg', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2008, 1005, '1颗约3kg', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2009, 1006, '1颗约400g', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2010, 1006, '2颗装', 8.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2011, 1007, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2012, 1007, '1kg/份', 5.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2013, 1008, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2014, 1008, '1kg/份', 5.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2015, 1009, '500g/份', 2.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2016, 1010, '500g/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2017, 1011, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2018, 1012, '1kg/份', 1.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2019, 1012, '2kg/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2020, 1013, '500g/份', 1.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2021, 1013, '2.5kg/袋', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2022, 1014, '500g/份', 1.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2023, 1015, '1根约1kg', 2.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2024, 1016, '500g/份', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2025, 1017, '1kg/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2026, 1018, '2根装', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2027, 1018, '4根装', 6.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2028, 1019, '250g/盒', 4.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2029, 1019, '500g/盒', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2030, 1020, '300g/袋', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2031, 1021, '500g/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2032, 1022, '300g/盒', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2033, 1023, '500g/捆', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2034, 1024, '100g/把', 1.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2035, 1025, '100g/把', 2.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2036, 1026, '250g/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2037, 1027, '250g/袋', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2038, 1027, '500g/袋', 6.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2039, 1028, '400g/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2040, 1029, '400g/份', 4.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2041, 1030, '200g/份', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2042, 1031, '500g/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2043, 2001, '1个约3kg', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2044, 2001, '半个约1.5kg', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2045, 2002, '1个约4kg', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2046, 2003, '1kg/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2047, 2004, '500g/份', 5.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2048, 2005, '1kg/串', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2049, 2005, '500g/份', 5.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2050, 2006, '500g/串', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2051, 2007, '125g/盒', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2052, 2008, '500g/盒', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2053, 2009, '1个约2kg', 79.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2054, 2010, '2个装约1kg', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2055, 2011, '1kg/份', 5.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2056, 2012, '1kg/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2057, 2013, '2个装', 15.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2058, 2014, '1kg/份', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2059, 2014, '2.5kg/箱', 29.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2060, 2015, '1kg/份', 6.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2061, 2016, '1kg/份', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2062, 2017, '1kg/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2063, 2018, '500g/盒', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2064, 3001, '500g/份', 15.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2065, 3001, '1kg/份', 15.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2066, 3002, '500g/份', 16.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2067, 3003, '500g/份', 22.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2068, 3004, '500g/份', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2069, 3005, '2只约1kg', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2070, 3006, '500g/份', 21.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2071, 3007, '500g/份', 24.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2072, 3008, '500g/盒', 29.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2073, 3009, '500g/份', 26.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2074, 3010, '500g/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2075, 3011, '500g/份', 8.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2076, 3012, '1只约1.2kg', 29.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2077, 3013, '30枚装', 25.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2078, 3014, '10枚装', 8.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2079, 3015, '6枚装', 11.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2080, 4001, '1条约1.2kg', 27.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2081, 4002, '1条约400g', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2082, 4003, '1条约500g', 16.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2083, 4004, '500g/袋', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2084, 4005, '500g/条', 24.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2085, 4006, '500g/条', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2086, 4007, '500g/份', 39.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2087, 4008, '500g/份', 16.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2088, 4009, '500g/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2089, 4010, '6只装', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2090, 5001, '5kg/袋', 36.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2091, 5001, '2.5kg/袋', 36.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2092, 5002, '5kg/袋', 39.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2093, 5003, '1kg/袋', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2094, 5004, '500g/袋', 6.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2095, 5005, '2.5kg/袋', 12.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2096, 5006, '1kg/袋', 7.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2097, 5007, '900g/袋', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2098, 5008, '5L/桶', 89.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2099, 5009, '5L/桶', 69.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2100, 5010, '5L/桶', 49.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2101, 5011, '400ml/瓶', 19.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2102, 5012, '1.8L/瓶', 15.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2103, 5013, '700g/瓶', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2104, 5014, '2L/桶', 12.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2105, 5015, '1kg/袋', 6.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2106, 5016, '500g×2袋', 3.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2107, 6001, '400g/块', 3.50, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2108, 6002, '400g/盒', 3.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku` VALUES (2109, 6003, '350g/盒', 2.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2110, 6004, '300g/袋', 5.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2111, 6005, '300g/袋', 4.50, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (2112, 6006, '300g/袋', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_sku` VALUES (7001, 7001, '1个约3kg', 12.99, 24.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku` VALUES (7002, 7001, '1个约5kg', 12.99, 24.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku` VALUES (7003, 7002, '1个约2kg', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku` VALUES (7004, 7003, '1个约1.5kg', 8.99, 11.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7005, 7004, '1个约1.5kg', 7.99, 9.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7006, 7005, '1个约400g', 6.99, 8.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7007, 7005, '2个装', 12.99, 16.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7008, 7006, '6个装', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7009, 7007, '3个装', 18.99, 22.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7010, 7008, '500g/份', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7011, 7008, '1kg/份', 18.99, 23.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7012, 7009, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7013, 7010, '1kg/份', 25.99, 32.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7014, 7011, '1个约2kg', 59.99, 79.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7015, 7012, '1个约500g', 29.99, 39.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7016, 7013, '1个约1.5kg', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7017, 7014, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7018, 7015, '1个约1.5kg', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7019, 7016, '125g/盒', 19.99, 25.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7020, 7017, '125g/盒', 22.99, 29.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7021, 7018, '125g/盒', 18.99, 24.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7022, 7019, '250g/盒', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7023, 7020, '500g/份', 16.99, 21.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7024, 7021, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7025, 7022, '500g/份', 19.99, 25.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7026, 7023, '500g/份', 21.99, 27.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7027, 7024, '1kg/份', 5.99, 7.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7028, 7025, '500g/份', 7.99, 9.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7029, 7025, '1kg/份', 14.99, 18.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7030, 7026, '500g/份', 6.99, 8.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7031, 7026, '1kg/份', 12.99, 16.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7032, 7027, '500g/份', 7.99, 9.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7033, 7027, '1kg/份', 14.99, 18.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7034, 7028, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7035, 7028, '1kg/份', 16.99, 21.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7036, 7029, '1个约1.5kg', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7037, 7030, '500g/份', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7038, 7031, '500g/份', 25.99, 32.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (7039, 7032, '1个约1.5kg', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 1);
INSERT INTO `goods_sku` VALUES (8001, 8001, '500g/份', 19.99, 25.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku` VALUES (8002, 8002, '500g/份', 18.99, 23.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku` VALUES (8003, 8003, '500g/份', 39.99, 49.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8004, 8004, '125g/盒', 18.99, 24.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8005, 8005, '250g/盒', 15.99, 19.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8006, 8006, '500g/份', 15.99, 19.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8007, 8007, '125g/盒', 19.99, 25.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8008, 8008, '125g/盒', 22.99, 29.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8009, 8009, '125g/盒', 25.99, 32.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8010, 8010, '500g/份', 22.99, 29.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8011, 8011, '125g/盒', 29.99, 39.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (8012, 8012, '125g/盒', 19.99, 25.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 1);
INSERT INTO `goods_sku` VALUES (9001, 9001, '1kg/份', 5.99, 7.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku` VALUES (9002, 9002, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku` VALUES (9003, 9003, '1个约400g', 6.99, 8.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku` VALUES (9004, 9004, '1个约1.5kg', 9.99, 12.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 1);
INSERT INTO `goods_sku` VALUES (9005, 9005, '1个约2kg', 59.99, 79.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 1);
INSERT INTO `goods_sku` VALUES (9006, 9006, '1个约500g', 29.99, 39.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 1);
INSERT INTO `goods_sku` VALUES (9007, 9007, '1个约1.5kg', 15.99, 19.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 1);
INSERT INTO `goods_sku` VALUES (9008, 9008, '6个装', 15.99, 19.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 1);
INSERT INTO `goods_sku` VALUES (9009, 9009, '3个装', 18.99, 22.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 1);
INSERT INTO `goods_sku` VALUES (9010, 9010, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 1);
INSERT INTO `goods_sku` VALUES (10001, 10001, '500g/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku` VALUES (10002, 10001, '1kg/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku` VALUES (10003, 10002, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku` VALUES (10004, 10002, '1kg/份', 16.99, 21.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku` VALUES (10005, 10003, '500g/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku` VALUES (10006, 10003, '1kg/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku` VALUES (10007, 10004, '500g/份', 6.99, 8.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10008, 10004, '1kg/份', 12.99, 16.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10009, 10005, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10010, 10005, '1kg/份', 26.99, 33.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10011, 10006, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10012, 10006, '1kg/份', 23.99, 29.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10013, 10007, '500g/份', 13.99, 17.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10014, 10007, '1kg/份', 25.99, 31.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10015, 10008, '500g/份', 11.99, 14.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10016, 10009, '500g/份', 9.99, 12.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10017, 10010, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (10018, 10010, '1kg/份', 16.99, 21.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 1);
INSERT INTO `goods_sku` VALUES (11001, 11001, '500g/份', 15.99, 36.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (11002, 11001, '1kg/份', 15.99, 36.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (11003, 11002, '500g/份', 22.99, 52.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (11004, 11002, '1kg/份', 22.99, 52.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (11005, 11003, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (11006, 11003, '1kg/份', 27.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (11007, 11004, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (11008, 11004, '1kg/份', 23.99, 29.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (11009, 11005, '500g/份', 9.99, 12.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (11010, 11006, '500g/份', 13.99, 16.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (11011, 11007, '500g/份', 16.99, 20.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (12001, 12001, '500g/份', 35.99, 44.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (12002, 12001, '1kg/份', 68.99, 84.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (12003, 12002, '500g/份', 49.99, 119.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (12004, 12002, '1kg/份', 49.99, 119.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (12005, 12003, '500g/份', 38.99, 48.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (12006, 12003, '1kg/份', 73.99, 91.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (12007, 12004, '500g/份', 45.99, 56.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (12008, 12004, '1kg/份', 88.99, 109.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (13001, 13001, '1只约1.5kg', 25.99, 39.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (13002, 13001, '1只约2kg', 25.99, 39.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (13003, 13002, '1只约1.8kg', 38.99, 48.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (13004, 13003, '500g/份', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (13005, 13003, '1kg/份', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (13006, 13004, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (13007, 13004, '1kg/份', 23.99, 29.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (13008, 13005, '半只约1.2kg', 28.99, 35.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (13009, 13006, '10枚/盒', 18.99, 23.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (13010, 13007, '1只约400g', 22.99, 28.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (13011, 13008, '20枚/盒', 15.99, 19.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (14001, 14001, '10枚/盒', 9.99, 23.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (14002, 14001, '20枚/盒', 9.99, 23.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (14003, 14002, '10枚/盒', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (14004, 14002, '20枚/盒', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (14005, 14003, '10枚/盒', 18.99, 44.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (14006, 14003, '20枚/盒', 18.99, 44.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku` VALUES (14007, 14004, '20枚/盒', 15.99, 19.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 1);
INSERT INTO `goods_sku` VALUES (15001, 15001, '1条约1kg', 18.99, 33.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (15002, 15001, '1条约1.5kg', 18.99, 33.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (15003, 15002, '1条约1kg', 16.99, 29.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (15004, 15002, '1条约1.5kg', 16.99, 29.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (15005, 15003, '1条约500g', 12.99, 28.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (15006, 15003, '1条约1kg', 12.99, 28.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (15007, 15004, '1条约1kg', 14.99, 18.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (15008, 15004, '1条约1.5kg', 20.99, 26.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (15009, 15005, '1条约1.5kg', 18.99, 23.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (15010, 15006, '1条约500g', 25.99, 32.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (16001, 16001, '500g/份', 18.99, 43.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (16002, 16001, '1kg/份', 18.99, 43.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (16003, 16002, '500g/份', 22.99, 53.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (16004, 16002, '1kg/份', 22.99, 53.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (16005, 16003, '500g/份', 35.99, 44.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (16006, 16004, '1条约500g', 28.99, 35.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (16007, 16005, '1条约500g', 38.99, 48.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (16008, 16006, '500g/份', 25.99, 32.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (17001, 17001, '500g/份', 45.99, 109.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (17002, 17001, '1kg/份', 45.99, 109.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (17003, 17002, '500g/份', 38.99, 48.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (17004, 17003, '500g/份', 28.99, 35.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (17005, 17004, '1只约200g', 68.99, 159.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (17006, 17004, '2只装约400g', 68.99, 159.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku` VALUES (17007, 17005, '500g/份', 32.99, 40.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (17008, 17006, '500g/份', 25.99, 32.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 1);
INSERT INTO `goods_sku` VALUES (18001, 18001, '5kg/袋', 69.99, 159.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18002, 18001, '10kg/袋', 69.99, 159.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18003, 18002, '5kg/袋', 89.99, 199.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18004, 18002, '10kg/袋', 89.99, 199.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18005, 18003, '1kg/袋', 9.99, 28.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18006, 18003, '2.5kg/袋', 9.99, 28.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18007, 18004, '1kg/袋', 12.99, 15.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18008, 18005, '1kg/袋', 11.99, 14.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18009, 18006, '1kg/袋', 13.99, 17.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (18010, 18007, '1kg/袋', 15.99, 19.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (18011, 18008, '1kg/袋', 18.99, 23.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (18012, 18009, '1kg/袋', 8.99, 11.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (19001, 19001, '5kg/袋', 18.99, 42.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (19002, 19001, '10kg/袋', 18.99, 42.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (19003, 19002, '500g/袋', 6.99, 15.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (19004, 19002, '1kg/袋', 6.99, 15.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (19005, 19003, '5kg/袋', 19.99, 44.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (19006, 19003, '10kg/袋', 19.99, 44.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (19007, 19004, '300g/袋', 8.99, 11.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (20001, 20001, '5L/桶', 29.99, 89.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (20002, 20001, '1.8L/桶', 29.99, 89.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (20003, 20002, '5L/桶', 32.99, 99.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (20004, 20002, '1.8L/桶', 32.99, 99.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (20005, 20003, '5L/桶', 26.99, 82.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (20006, 20003, '1.8L/桶', 26.99, 82.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku` VALUES (20007, 20004, '5L/桶', 75.99, 94.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (20008, 20004, '1.8L/桶', 30.99, 38.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (20009, 20005, '5L/桶', 72.99, 90.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (20010, 20005, '1.8L/桶', 28.99, 35.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (20011, 20006, '5L/桶', 129.99, 159.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (20012, 20006, '1.8L/桶', 52.99, 65.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 1);
INSERT INTO `goods_sku` VALUES (21001, 21001, '400g/袋', 3.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21002, 21001, '1kg/袋', 3.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21003, 21002, '1kg/袋', 6.99, 36.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21004, 21002, '5kg/袋', 6.99, 36.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21005, 21003, '500ml/瓶', 12.99, 28.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21006, 21003, '1L/瓶', 12.99, 28.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21007, 21004, '500ml/瓶', 9.99, 20.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21008, 21004, '1L/瓶', 9.99, 20.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21009, 21005, '200g/瓶', 8.99, 23.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21010, 21005, '500g/袋', 8.99, 23.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21011, 21006, '50g/瓶', 12.99, 15.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 1);
INSERT INTO `goods_sku` VALUES (21012, 21007, '20g/瓶', 9.99, 12.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (21013, 21008, '20g/瓶', 14.99, 18.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (22001, 22001, '300g/盒', 4.99, 6.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (22002, 22002, '300g/盒', 4.49, 5.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (22003, 22003, '300g/盒', 5.49, 6.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (22004, 22004, '1L/瓶', 8.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (22005, 22005, '200g/碗', 6.99, 8.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (23001, 23001, '200g/包', 7.99, 9.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (23002, 23002, '200g/包', 8.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (23003, 23003, '200g/包', 6.99, 8.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (23004, 23004, '200g/包', 6.99, 8.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (23005, 23005, '300g/袋', 4.99, 6.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku` VALUES (23006, 23006, '500g', 2.00, 4.00, NULL, 1, '2026-08-09 14:55:47', '2026-08-09 14:55:47', 0);

-- ----------------------------
-- Table structure for goods_sku_bak_0813
-- ----------------------------
DROP TABLE IF EXISTS `goods_sku_bak_0813`;
CREATE TABLE `goods_sku_bak_0813`  (
  `id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `spu_id` bigint unsigned NOT NULL COMMENT 'SPU ID',
  `sku_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格名称(如500g)',
  `price` decimal(10, 2) NOT NULL COMMENT '售价',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价(划线价)',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SKU图片',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0-停用 1-启用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_sku_bak_0813
-- ----------------------------
INSERT INTO `goods_sku_bak_0813` VALUES (2001, 1001, '250g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2002, 1001, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2003, 1002, '300g/份', 3.29, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2004, 1002, '500g/份', 3.29, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2005, 1003, '300g/份', 4.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2006, 1004, '300g/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2007, 1005, '1颗约2kg', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2008, 1005, '1颗约3kg', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2009, 1006, '1颗约400g', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2010, 1006, '2颗装', 8.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2011, 1007, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2012, 1007, '1kg/份', 5.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2013, 1008, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2014, 1008, '1kg/份', 5.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2015, 1009, '500g/份', 2.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2016, 1010, '500g/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2017, 1011, '500g/份', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2018, 1012, '1kg/份', 1.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2019, 1012, '2kg/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2020, 1013, '500g/份', 1.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2021, 1013, '2.5kg/袋', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2022, 1014, '500g/份', 1.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2023, 1015, '1根约1kg', 2.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2024, 1016, '500g/份', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2025, 1017, '1kg/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2026, 1018, '2根装', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2027, 1018, '4根装', 6.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2028, 1019, '250g/盒', 4.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2029, 1019, '500g/盒', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2030, 1020, '300g/袋', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2031, 1021, '500g/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2032, 1022, '300g/盒', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2033, 1023, '500g/捆', 2.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2034, 1024, '100g/把', 1.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2035, 1025, '100g/把', 2.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2036, 1026, '250g/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2037, 1027, '250g/袋', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2038, 1027, '500g/袋', 6.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2039, 1028, '400g/份', 3.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2040, 1029, '400g/份', 4.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2041, 1030, '200g/份', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2042, 1031, '500g/份', 3.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2043, 2001, '1个约3kg', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2044, 2001, '半个约1.5kg', 7.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2045, 2002, '1个约4kg', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2046, 2003, '1kg/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2047, 2004, '500g/份', 5.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2048, 2005, '1kg/串', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2049, 2005, '500g/份', 5.49, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2050, 2006, '500g/串', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2051, 2007, '125g/盒', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2052, 2008, '500g/盒', 4.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2053, 2009, '1个约2kg', 79.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2054, 2010, '2个装约1kg', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2055, 2011, '1kg/份', 5.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2056, 2012, '1kg/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2057, 2013, '2个装', 15.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2058, 2014, '1kg/份', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2059, 2014, '2.5kg/箱', 29.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2060, 2015, '1kg/份', 6.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2061, 2016, '1kg/份', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2062, 2017, '1kg/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2063, 2018, '500g/盒', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2064, 3001, '500g/份', 15.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2065, 3001, '1kg/份', 15.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2066, 3002, '500g/份', 16.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2067, 3003, '500g/份', 22.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2068, 3004, '500g/份', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2069, 3005, '2只约1kg', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2070, 3006, '500g/份', 21.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2071, 3007, '500g/份', 24.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2072, 3008, '500g/盒', 29.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2073, 3009, '500g/份', 26.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2074, 3010, '500g/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2075, 3011, '500g/份', 8.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2076, 3012, '1只约1.2kg', 29.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2077, 3013, '30枚装', 25.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2078, 3014, '10枚装', 8.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2079, 3015, '6枚装', 11.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2080, 4001, '1条约1.2kg', 27.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2081, 4002, '1条约400g', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2082, 4003, '1条约500g', 16.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2083, 4004, '500g/袋', 12.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2084, 4005, '500g/条', 24.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2085, 4006, '500g/条', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2086, 4007, '500g/份', 39.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2087, 4008, '500g/份', 16.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2088, 4009, '500g/份', 9.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2089, 4010, '6只装', 19.99, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2090, 5001, '5kg/袋', 36.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2091, 5001, '2.5kg/袋', 36.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2092, 5002, '5kg/袋', 39.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2093, 5003, '1kg/袋', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2094, 5004, '500g/袋', 6.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2095, 5005, '2.5kg/袋', 12.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2096, 5006, '1kg/袋', 7.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2097, 5007, '900g/袋', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2098, 5008, '5L/桶', 89.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2099, 5009, '5L/桶', 69.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2100, 5010, '5L/桶', 49.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2101, 5011, '400ml/瓶', 19.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2102, 5012, '1.8L/瓶', 15.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2103, 5013, '700g/瓶', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2104, 5014, '2L/桶', 12.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2105, 5015, '1kg/袋', 6.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2106, 5016, '500g×2袋', 3.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2107, 6001, '400g/块', 3.50, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2108, 6002, '400g/盒', 3.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2109, 6003, '350g/盒', 2.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2110, 6004, '300g/袋', 5.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2111, 6005, '300g/袋', 4.50, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (2112, 6006, '300g/袋', 9.90, NULL, NULL, 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7001, 7001, '1个约3kg', 12.99, 24.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7002, 7001, '1个约5kg', 12.99, 24.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7003, 7002, '1个约2kg', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7004, 7003, '1个约1.5kg', 8.99, 11.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7005, 7004, '1个约1.5kg', 7.99, 9.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7006, 7005, '1个约400g', 6.99, 8.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7007, 7005, '2个装', 12.99, 16.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7008, 7006, '6个装', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7009, 7007, '3个装', 18.99, 22.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7010, 7008, '500g/份', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7011, 7008, '1kg/份', 18.99, 23.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7012, 7009, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7013, 7010, '1kg/份', 25.99, 32.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7014, 7011, '1个约2kg', 59.99, 79.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7015, 7012, '1个约500g', 29.99, 39.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7016, 7013, '1个约1.5kg', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7017, 7014, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7018, 7015, '1个约1.5kg', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7019, 7016, '125g/盒', 19.99, 25.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7020, 7017, '125g/盒', 22.99, 29.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7021, 7018, '125g/盒', 18.99, 24.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7022, 7019, '250g/盒', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7023, 7020, '500g/份', 16.99, 21.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7024, 7021, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7025, 7022, '500g/份', 19.99, 25.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7026, 7023, '500g/份', 21.99, 27.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7027, 7024, '1kg/份', 5.99, 7.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7028, 7025, '500g/份', 7.99, 9.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7029, 7025, '1kg/份', 14.99, 18.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7030, 7026, '500g/份', 6.99, 8.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7031, 7026, '1kg/份', 12.99, 16.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7032, 7027, '500g/份', 7.99, 9.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7033, 7027, '1kg/份', 14.99, 18.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7034, 7028, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7035, 7028, '1kg/份', 16.99, 21.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7036, 7029, '1个约1.5kg', 9.99, 12.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7037, 7030, '500g/份', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7038, 7031, '500g/份', 25.99, 32.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (7039, 7032, '1个约1.5kg', 15.99, 19.99, '', 1, '2026-08-09 13:29:40', '2026-08-09 13:29:40', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8001, 8001, '500g/份', 19.99, 25.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8002, 8002, '500g/份', 18.99, 23.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8003, 8003, '500g/份', 39.99, 49.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8004, 8004, '125g/盒', 18.99, 24.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8005, 8005, '250g/盒', 15.99, 19.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8006, 8006, '500g/份', 15.99, 19.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8007, 8007, '125g/盒', 19.99, 25.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8008, 8008, '125g/盒', 22.99, 29.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8009, 8009, '125g/盒', 25.99, 32.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8010, 8010, '500g/份', 22.99, 29.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8011, 8011, '125g/盒', 29.99, 39.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (8012, 8012, '125g/盒', 19.99, 25.99, '', 1, '2026-08-09 13:30:49', '2026-08-09 13:30:49', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9001, 9001, '1kg/份', 5.99, 7.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9002, 9002, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9003, 9003, '1个约400g', 6.99, 8.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9004, 9004, '1个约1.5kg', 9.99, 12.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9005, 9005, '1个约2kg', 59.99, 79.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9006, 9006, '1个约500g', 29.99, 39.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9007, 9007, '1个约1.5kg', 15.99, 19.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9008, 9008, '6个装', 15.99, 19.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9009, 9009, '3个装', 18.99, 22.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (9010, 9010, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:32:00', '2026-08-09 13:32:00', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10001, 10001, '500g/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10002, 10001, '1kg/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10003, 10002, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10004, 10002, '1kg/份', 16.99, 21.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10005, 10003, '500g/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10006, 10003, '1kg/份', 7.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10007, 10004, '500g/份', 6.99, 8.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10008, 10004, '1kg/份', 12.99, 16.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10009, 10005, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10010, 10005, '1kg/份', 26.99, 33.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10011, 10006, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10012, 10006, '1kg/份', 23.99, 29.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10013, 10007, '500g/份', 13.99, 17.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10014, 10007, '1kg/份', 25.99, 31.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10015, 10008, '500g/份', 11.99, 14.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10016, 10009, '500g/份', 9.99, 12.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10017, 10010, '500g/份', 8.99, 11.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (10018, 10010, '1kg/份', 16.99, 21.99, '', 1, '2026-08-09 13:32:35', '2026-08-09 13:32:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11001, 11001, '500g/份', 15.99, 36.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11002, 11001, '1kg/份', 15.99, 36.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11003, 11002, '500g/份', 22.99, 52.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11004, 11002, '1kg/份', 22.99, 52.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11005, 11003, '500g/份', 14.99, 18.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11006, 11003, '1kg/份', 27.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11007, 11004, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11008, 11004, '1kg/份', 23.99, 29.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11009, 11005, '500g/份', 9.99, 12.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11010, 11006, '500g/份', 13.99, 16.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (11011, 11007, '500g/份', 16.99, 20.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12001, 12001, '500g/份', 35.99, 44.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12002, 12001, '1kg/份', 68.99, 84.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12003, 12002, '500g/份', 49.99, 119.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12004, 12002, '1kg/份', 49.99, 119.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12005, 12003, '500g/份', 38.99, 48.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12006, 12003, '1kg/份', 73.99, 91.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12007, 12004, '500g/份', 45.99, 56.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (12008, 12004, '1kg/份', 88.99, 109.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13001, 13001, '1只约1.5kg', 25.99, 39.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13002, 13001, '1只约2kg', 25.99, 39.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13003, 13002, '1只约1.8kg', 38.99, 48.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13004, 13003, '500g/份', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13005, 13003, '1kg/份', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13006, 13004, '500g/份', 12.99, 15.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13007, 13004, '1kg/份', 23.99, 29.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13008, 13005, '半只约1.2kg', 28.99, 35.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13009, 13006, '10枚/盒', 18.99, 23.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13010, 13007, '1只约400g', 22.99, 28.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (13011, 13008, '20枚/盒', 15.99, 19.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (14001, 14001, '10枚/盒', 9.99, 23.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (14002, 14001, '20枚/盒', 9.99, 23.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (14003, 14002, '10枚/盒', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (14004, 14002, '20枚/盒', 14.99, 34.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (14005, 14003, '10枚/盒', 18.99, 44.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (14006, 14003, '20枚/盒', 18.99, 44.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (14007, 14004, '20枚/盒', 15.99, 19.99, '', 1, '2026-08-09 13:33:35', '2026-08-09 13:33:35', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15001, 15001, '1条约1kg', 18.99, 33.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15002, 15001, '1条约1.5kg', 18.99, 33.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15003, 15002, '1条约1kg', 16.99, 29.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15004, 15002, '1条约1.5kg', 16.99, 29.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15005, 15003, '1条约500g', 12.99, 28.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15006, 15003, '1条约1kg', 12.99, 28.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15007, 15004, '1条约1kg', 14.99, 18.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15008, 15004, '1条约1.5kg', 20.99, 26.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15009, 15005, '1条约1.5kg', 18.99, 23.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (15010, 15006, '1条约500g', 25.99, 32.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16001, 16001, '500g/份', 18.99, 43.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16002, 16001, '1kg/份', 18.99, 43.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16003, 16002, '500g/份', 22.99, 53.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16004, 16002, '1kg/份', 22.99, 53.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16005, 16003, '500g/份', 35.99, 44.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16006, 16004, '1条约500g', 28.99, 35.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16007, 16005, '1条约500g', 38.99, 48.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (16008, 16006, '500g/份', 25.99, 32.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17001, 17001, '500g/份', 45.99, 109.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17002, 17001, '1kg/份', 45.99, 109.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17003, 17002, '500g/份', 38.99, 48.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17004, 17003, '500g/份', 28.99, 35.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17005, 17004, '1只约200g', 68.99, 159.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17006, 17004, '2只装约400g', 68.99, 159.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17007, 17005, '500g/份', 32.99, 40.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (17008, 17006, '500g/份', 25.99, 32.99, '', 1, '2026-08-09 13:34:36', '2026-08-09 13:34:36', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18001, 18001, '5kg/袋', 69.99, 159.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18002, 18001, '10kg/袋', 69.99, 159.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18003, 18002, '5kg/袋', 89.99, 199.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18004, 18002, '10kg/袋', 89.99, 199.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18005, 18003, '1kg/袋', 9.99, 28.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18006, 18003, '2.5kg/袋', 9.99, 28.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18007, 18004, '1kg/袋', 12.99, 15.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18008, 18005, '1kg/袋', 11.99, 14.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18009, 18006, '1kg/袋', 13.99, 17.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18010, 18007, '1kg/袋', 15.99, 19.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18011, 18008, '1kg/袋', 18.99, 23.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (18012, 18009, '1kg/袋', 8.99, 11.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (19001, 19001, '5kg/袋', 18.99, 42.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (19002, 19001, '10kg/袋', 18.99, 42.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (19003, 19002, '500g/袋', 6.99, 15.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (19004, 19002, '1kg/袋', 6.99, 15.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (19005, 19003, '5kg/袋', 19.99, 44.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (19006, 19003, '10kg/袋', 19.99, 44.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (19007, 19004, '300g/袋', 8.99, 11.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20001, 20001, '5L/桶', 29.99, 89.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20002, 20001, '1.8L/桶', 29.99, 89.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20003, 20002, '5L/桶', 32.99, 99.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20004, 20002, '1.8L/桶', 32.99, 99.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20005, 20003, '5L/桶', 26.99, 82.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20006, 20003, '1.8L/桶', 26.99, 82.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20007, 20004, '5L/桶', 75.99, 94.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20008, 20004, '1.8L/桶', 30.99, 38.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20009, 20005, '5L/桶', 72.99, 90.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20010, 20005, '1.8L/桶', 28.99, 35.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20011, 20006, '5L/桶', 129.99, 159.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (20012, 20006, '1.8L/桶', 52.99, 65.99, '', 1, '2026-08-09 13:35:19', '2026-08-09 13:35:19', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21001, 21001, '400g/袋', 3.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21002, 21001, '1kg/袋', 3.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21003, 21002, '1kg/袋', 6.99, 36.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21004, 21002, '5kg/袋', 6.99, 36.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21005, 21003, '500ml/瓶', 12.99, 28.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21006, 21003, '1L/瓶', 12.99, 28.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21007, 21004, '500ml/瓶', 9.99, 20.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21008, 21004, '1L/瓶', 9.99, 20.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21009, 21005, '200g/瓶', 8.99, 23.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21010, 21005, '500g/袋', 8.99, 23.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21011, 21006, '50g/瓶', 12.99, 15.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21012, 21007, '20g/瓶', 9.99, 12.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (21013, 21008, '20g/瓶', 14.99, 18.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (22001, 22001, '300g/盒', 4.99, 6.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (22002, 22002, '300g/盒', 4.49, 5.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (22003, 22003, '300g/盒', 5.49, 6.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (22004, 22004, '1L/瓶', 8.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (22005, 22005, '200g/碗', 6.99, 8.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (23001, 23001, '200g/包', 7.99, 9.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (23002, 23002, '200g/包', 8.99, 11.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (23003, 23003, '200g/包', 6.99, 8.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (23004, 23004, '200g/包', 6.99, 8.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (23005, 23005, '300g/袋', 4.99, 6.99, '', 1, '2026-08-09 13:36:08', '2026-08-09 13:36:08', 0);
INSERT INTO `goods_sku_bak_0813` VALUES (23006, 23006, '500g', 2.00, 4.00, NULL, 1, '2026-08-09 14:55:47', '2026-08-09 14:55:47', 0);

-- ----------------------------
-- Table structure for goods_spu
-- ----------------------------
DROP TABLE IF EXISTS `goods_spu`;
CREATE TABLE `goods_spu`  (
  `id` bigint unsigned NOT NULL COMMENT 'SPU ID',
  `category_id` bigint unsigned NOT NULL COMMENT '分类ID(二级分类)',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
  `main_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主图URL',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '轮播图URL数组(JSON字符串)',
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情图文(纯文本/富文本)',
  `sales` int(0) NOT NULL DEFAULT 0 COMMENT '销量(已完成订单累计)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '上下架:0-下架 1-上架',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序值',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '现价(展示用,保存时自动取SKU最低价)',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价(划线价,展示用)',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category_id`(`category_id`) USING BTREE,
  INDEX `idx_status_sort`(`status`, `sort`) USING BTREE,
  INDEX `idx_sales`(`sales`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23007 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品SPU表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_spu
-- ----------------------------
INSERT INTO `goods_spu` VALUES (1001, 11, '本地奶白菜', '/uploads/2026/08/本地奶白菜_20260813154317.jpg', '[\"https://cdn.example.com/spu/1001_1.jpg\", \"https://cdn.example.com/spu/1001_2.jpg\"]', '<p>本地奶白菜，叶片肥厚鲜嫩，口感清甜，富含维生素C和膳食纤维。</p><p>产地直采，当日采摘当日发货，保证新鲜度。建议烹饪前用淡盐水浸泡10分钟。</p>', 0, 1, 1, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (1002, 11, '有机上海青', '/uploads/2026/08/有机上海青_20260813160308.jpeg', '[\"https://cdn.example.com/spu/1002_1.jpg\", \"https://cdn.example.com/spu/1002_2.jpg\"]', '<p>有机认证上海青，无农残无激素，叶绿茎白，清脆可口。</p><p>适合炒食、煮汤、涮火锅，烹饪时间短，营养流失少。</p>', 0, 1, 2, 3.29, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (1003, 11, '高山娃娃菜', '/uploads/2026/08/高山娃娃菜_20260813160411.jpg', NULL, '<p>高山娃娃菜帮薄叶嫩，口感清甜爽脆，富含维生素和膳食纤维。</p><p>高海拔冷凉气候种植，虫害少，当日采摘当日发货。适合清炒、上汤、火锅涮煮。</p>', 0, 1, 3, 4.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (1004, 11, '大叶菠菜', '', NULL, '<p>大叶菠菜叶片肥厚，色泽深绿，富含铁元素和叶酸，口感柔嫩微甜。</p><p>产地直采，带根发货更新鲜。建议焯水后凉拌或清炒，去除草酸更营养。</p>', 0, 1, 4, 3.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1005, 11, '生菜', '/uploads/2026/08/生菜_20260813160513.webp', NULL, '<p>生菜叶片脆嫩多汁，口感清甜爽口，低热量高纤维。</p><p>奶油生菜品种，层层包心紧实。适合沙拉、汉堡、烤肉伴侣，洗净即食。</p>', 1, 1, 5, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (1006, 11, '油麦菜', '', NULL, '<p>油麦菜茎秆脆嫩，叶片翠绿，口感清香微甜，富含维生素和钙质。</p><p>当日采摘，水分充足不发蔫。蒜蓉清炒、涮火锅、蚝油淋汁都美味。</p>', 0, 1, 6, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1007, 11, '小香芹', '', NULL, '<p>小香芹香气浓郁，茎秆细嫩，富含挥发性芳香物质和多种维生素。</p><p>根茎连体采收，鲜度持久。炒肉、包饺子、凉拌提香，西芹平替之选。</p>', 0, 1, 7, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1008, 11, '韭菜', '', NULL, '<p>韭菜叶片宽厚，辛香浓郁，富含硫化物和膳食纤维，有助开胃。</p><p>头茬韭菜更鲜嫩。韭菜盒子、炒鸡蛋、烤韭菜经典吃法，现买现吃风味最佳。</p>', 0, 1, 8, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1009, 11, '空心菜', '/uploads/2026/08/空心菜_20260809145619.jpg', NULL, '<p>空心菜茎秆脆嫩，叶片碧绿，口感清爽，富含维生素C和叶绿素。</p><p>夏秋应季蔬菜，当日采摘。蒜蓉爆炒、清炒虾酱是粤式经典，焯水凉拌亦可。</p>', 0, 1, 9, 2.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (1010, 11, '大白菜', '', NULL, '<p>大白菜菜帮脆甜，菜心鲜嫩，含水量高，清甜爽口。</p><p>冬储菜之王，耐储存。炖粉条、醋溜白菜、腌酸菜、涮火锅百搭首选。</p>', 0, 1, 10, 3.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1011, 11, '卷心菜', '', NULL, '<p>卷心菜球体紧实，叶片脆嫩，口感清甜，富含维生素K和抗氧化物。</p><p>春季应季，切丝手撕皆宜。手撕包菜、炒粉条、沙拉、泡菜全能选手。</p>', 0, 1, 11, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1012, 11, '西兰花', '', NULL, '<p>西兰花花球紧实翠绿，口感爽脆，被称为蔬菜皇冠，营养密度极高。</p><p>低温冷链保鲜发货。白灼、蒜蓉、清炒，焯水1分钟口感最佳，营养保留最多。</p>', 0, 1, 12, 1.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1013, 11, '紫甘蓝', '', NULL, '<p>紫甘蓝色泽紫红艳丽，口感爽脆微甜，富含花青素和维生素。</p><p>凉拌沙拉首选，腌制后色泽更艳。切丝越细口感越好，搭配柠檬汁更清脆。</p>', 0, 1, 13, 1.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1014, 11, '快菜', '', NULL, '<p>快菜生长周期短，叶片柔嫩，口感清甜，是小白菜的优选品种。</p><p>当季现采，嫩度极佳。煮面、清炒、做汤快手菜必备，几分钟就能上桌。</p>', 0, 1, 14, 1.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1015, 11, '芥兰', '', NULL, '<p>芥兰茎秆脆嫩，叶片翠绿，口感清甜带微苦，富含钙和维生素C。</p><p>广式经典绿叶菜。白灼芥兰、蚝油芥兰，大火快炒锁住爽脆。</p>', 0, 1, 15, 2.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1016, 11, '奶白菜苗', '', NULL, '<p>奶白菜苗鲜嫩无比，叶片柔软，口感清甜，富含维生素和叶酸。</p><p>幼苗期采摘，纤维少更嫩口。清炒、煮汤、涮火锅，焯水即食最鲜甜。</p>', 0, 1, 16, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1017, 11, '菜心', '', NULL, '<p>菜心茎嫩叶绿，花蕾初开，口感清甜爽脆，是岭南名菜之魂。</p><p>当季现摘，鲜度满分。白灼菜心淋豉油，粤菜馆同款，简单又高级。</p>', 0, 1, 17, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1018, 11, '茼蒿', '', NULL, '<p>茼蒿自带独特香气，叶片柔嫩，口感清爽，富含挥发性精油和维生素。</p><p>有菊花香气辨识度高。涮火锅、清炒、蒸茼蒿麦饭，秋冬滋补好选择。</p>', 0, 1, 18, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1019, 11, '苋菜', '', NULL, '<p>苋菜叶片红绿相间，口感滑嫩，富含铁和钙，有红苋菜之称。</p><p>炒出来的红汤汁拌饭是经典吃法。蒜蓉爆炒、上汤苋菜，营养又下饭。</p>', 0, 1, 19, 4.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1020, 11, '小白菜', '', NULL, '<p>小白菜叶片翠绿柔嫩，菜帮清甜，富含维生素和矿物质，清淡可口。</p><p>当日现摘，鲜嫩多汁。清炒、煮汤、烫火锅，家常餐桌高频绿叶菜。</p>', 0, 1, 20, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1021, 11, '黄心菜', '', NULL, '<p>黄心菜菜心金黄鲜嫩，叶片肥厚，口感清甜，冬季时令佳品。</p><p>低温环境生长更甜。霜打后的黄心菜格外清甜，清炒或炖肉皆宜。</p>', 0, 1, 21, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1022, 11, '苦菊', '', NULL, '<p>苦菊叶形优美，口感微苦回甘，清脆爽口，富含维生素和膳食纤维。</p><p>轻食沙拉首选，搭配油醋汁口感绝佳。凉拌去火，夏季开胃好食材。</p>', 0, 1, 22, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1023, 11, '上海青', '', NULL, '<p>有机上海青叶绿茎白，清脆可口，无农残无激素，健康安心。</p><p>有机认证基地直供。清炒、煮面、涮火锅，简单烹饪还原自然清甜。</p>', 0, 1, 23, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1024, 11, '娃娃菜', '/uploads/2026/08/娃娃菜_20260813160422.webp', NULL, '<p>娃娃菜小巧精致，菜心鲜嫩，口感清甜，一人食分量刚刚好。</p><p>外叶包裹紧实，保鲜度高。上汤娃娃菜、蒜蓉粉丝蒸、涮火锅经典搭配。</p>', 0, 1, 24, 1.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (1025, 11, '芹菜', '', NULL, '<p>芹菜茎秆粗壮脆嫩，香气浓郁，富含膳食纤维和芹菜素。</p><p>本芹炒菜香，西芹拌菜脆。芹菜炒香干、芹菜炒肉丝、榨芹菜汁皆宜。</p>', 0, 1, 25, 2.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1026, 11, '大葱', '', NULL, '<p>大葱葱白长且粗壮，辛辣味足，是做菜提香的核心佐料。</p><p>章丘大葱品质优良。爆锅炝香、京酱肉丝配菜、葱爆羊肉的灵魂伴侣。</p>', 0, 1, 26, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1027, 11, '香菜', '', NULL, '<p>香菜叶片翠绿，香气浓烈，富含维生素C，是提味增香的点睛之笔。</p><p>当日采摘带根发货，保鲜持久。凉拌、涮锅、煲汤最后撒一把，香气四溢。</p>', 0, 1, 27, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1028, 11, '金丝白', '', NULL, '<p>金丝白叶片金黄带光泽，菜帮薄嫩，口感清甜，颜值与美味并存。</p><p>黄心白菜品种，纤维少甜度高。清炒、炖汤、涮火锅，颜色喜庆寓意好。</p>', 0, 1, 28, 3.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1029, 11, '毛白菜', '', NULL, '<p>毛白菜叶片鲜嫩，菜帮微脆，口感清甜带青草香，家常味道。</p><p>现摘现发，水分足。猪油渣炒毛白菜是地道家常菜，简单快手。</p>', 0, 1, 29, 4.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1030, 11, '广东菜心', '', NULL, '<p>广东菜心茎秆爽脆，叶片翠绿，花蕾鲜嫩，清甜无渣。</p><p>广式茶餐厅同款。白灼淋热油豉油，锅气十足，简单烹饪就很鲜美。</p>', 0, 1, 30, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (1031, 11, '有机菠菜', '/uploads/2026/08/有机菠菜_20260813160325.webp', NULL, '<p>有机菠菜叶片厚实，根红叶绿，富含铁质和多种维生素，营养标杆。</p><p>有机认证，全程无化学农药。焯水凉拌、蒜蓉清炒、煮猪肝汤滋补又美味。</p>', 0, 1, 31, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (2001, 12, '黄瓜', '/uploads/2026/08/黄瓜_20260813154307.jpg', NULL, '<p>黄瓜顶花带刺，清脆多汁，口感爽利，低热量高水分。</p><p>产地直采，脆嫩无苦味。凉拌拍黄瓜、黄瓜炒蛋、蘸酱生吃，夏日解腻必备。</p>', 0, 1, 1, 7.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (2002, 12, '西红柿', '/uploads/2026/08/西红柿_20260813160224.jpg', '[\"https://cdn.example.com/spu/2002_1.jpg\", \"https://cdn.example.com/spu/2002_2.jpg\"]', '<p>西红柿果形饱满，色泽红润，沙瓤多汁，酸甜适口，番茄红素丰富。</p><p>自然熟采摘，果香浓郁。西红柿炒蛋、西红柿牛腩汤、凉拌西红柿，家常经典。</p>', 0, 1, 2, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (2003, 12, '青椒', '', NULL, '<p>青椒果肉厚实，微辣清甜，富含维生素C，是蔬菜中的维C之王。</p><p>现摘现发，光泽饱满。虎皮青椒、青椒肉丝、青椒炒蛋，家常下饭利器。</p>', 0, 1, 3, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2004, 12, '茄子', '', NULL, '<p>茄子紫亮饱满，肉质细嫩，口感绵软吸汁，富含花青素。</p><p>长茄炒食，圆茄红烧。鱼香茄子、蒜蓉烤茄子、红烧茄子，米饭杀手。</p>', 0, 1, 4, 5.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2005, 12, '丝瓜', '', NULL, '<p>丝瓜翠绿鲜嫩，口感滑嫩清甜，富含黏液蛋白和维生素。</p><p>夏秋季应季蔬菜。丝瓜炒蛋、丝瓜汤、蒜蓉粉丝蒸丝瓜，清淡又滋补。</p>', 0, 1, 5, 5.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2006, 12, '苦瓜', '', NULL, '<p>苦瓜纹理分明，清脆微苦回甘，富含苦瓜苷和维生素C，清热降火。</p><p>苦瓜炒蛋、苦瓜酿肉、凉拌苦瓜经典做法。怕苦可先用盐腌去涩。</p>', 0, 1, 6, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2007, 12, '冬瓜', '', NULL, '<p>冬瓜瓜肉洁白厚实，口感清润，热量极低，适合控脂人群。</p><p>冬瓜排骨汤、红烧冬瓜、冬瓜丸子汤，清爽解腻，老幼皆宜。</p>', 0, 1, 7, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2008, 12, '南瓜', '', NULL, '<p>南瓜金黄绵密，口感香甜软糯，富含胡萝卜素和膳食纤维。</p><p>贝贝南瓜更粉糯。蒸南瓜、南瓜粥、南瓜饼，早餐加餐两相宜。</p>', 0, 1, 8, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2009, 12, '西葫芦', '', NULL, '<p>西葫芦皮薄肉嫩，口感清甜爽脆，水分足热量低。</p><p>西葫芦炒蛋、西葫芦糊塌子、凉拌西葫芦丝，快手家常菜好选择。</p>', 0, 1, 9, 79.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2010, 12, '杭椒', '', NULL, '<p>杭椒细长微辣，香气浓郁，口感脆嫩，是湘菜馆的灵魂配料。</p><p>杭椒牛柳、杭椒炒蛋、小炒肉，辣度适中，开胃下饭。</p>', 0, 1, 10, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2011, 12, '豆角', '', NULL, '<p>豆角翠绿饱满，肉质厚实，口感清甜，富含蛋白质和膳食纤维。</p><p>干煸豆角、豆角焖面、豆角炖土豆，一定要炒熟煮透再食用。</p>', 0, 1, 11, 5.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2012, 12, '长豆角', '', NULL, '<p>长豆角细长嫩脆，口感清甜，纤维少，越嫩越好吃。</p><p>手撕豆角、豇豆炒肉、酸豆角腌制，夏日开胃菜首选。</p>', 0, 1, 12, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2013, 12, '毛豆', '', NULL, '<p>毛豆翠绿饱满，豆香浓郁，口感清甜粉糯，蛋白质含量高。</p><p>水煮毛豆配啤酒是夏日经典。毛豆炒肉、毛豆炖鸡，鲜香下饭。</p>', 0, 1, 13, 15.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2014, 12, '玉米', '', NULL, '<p>玉米颗粒饱满，甜糯适口，富含膳食纤维和多种维生素。</p><p>水果玉米清甜爆汁，蒸煮烤皆可。玉米排骨汤、玉米烙，家常好味。</p>', 0, 1, 14, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2015, 12, '彩椒', '', NULL, '<p>彩椒色泽鲜艳，果肉厚实脆甜，不辣，富含维生素C和花青素。</p><p>红黄绿三色齐配，是摆盘颜值担当。彩椒炒肉、彩椒鸡丁、烤箱烤彩椒。</p>', 0, 1, 15, 6.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2016, 12, '西芹', '', NULL, '<p>西芹茎秆粗壮厚实，口感脆嫩，香气清淡，纤维感十足。</p><p>西芹炒百合、西芹拌腰果、西芹榨汁，清脆爽口，健康轻食。</p>', 0, 1, 16, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2017, 12, '香芹', '', NULL, '<p>香芹茎秆细嫩，香气浓郁，比西芹更香更嫩。</p><p>芹菜炒香干、芹菜馅饺子、芹菜粥，去腥增香好帮手。</p>', 0, 1, 17, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (2018, 12, '蒜苔', '', NULL, '<p>蒜苔脆嫩碧绿，蒜香浓郁，口感爽脆，富含大蒜素。</p><p>蒜苔炒肉丝、蒜苔炒鸡蛋、腌蒜苔，春天里的时令好味。</p>', 0, 1, 18, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3001, 13, '土豆', '/uploads/2026/08/土豆_20260813154300.jpg', NULL, '<p>土豆沙瓤粉糯，口感绵密，是餐桌上的百搭之王。</p><p>黄心土豆炖煮更糯。酸辣土豆丝、土豆炖牛腩、椒盐薯条，怎么做都好吃。</p>', 0, 1, 1, 15.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (3002, 13, '胡萝卜', '/uploads/2026/08/胡萝卜_20260813154436.jpg', NULL, '<p>胡萝卜色泽橙红，口感清甜脆嫩，富含胡萝卜素，护眼又营养。</p><p>胡萝卜炒肉、胡萝卜炖排骨、榨胡萝卜汁，生熟皆宜营养丰富。</p>', 0, 1, 2, 16.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (3003, 13, '白萝卜', '', NULL, '<p>白萝卜水分充足，口感脆嫩微辛，清热润燥，冬季养生首选。</p><p>萝卜炖羊肉、萝卜丝饼、腌萝卜皮，去腻解馋样样行。</p>', 0, 1, 3, 22.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3004, 13, '红薯', '', NULL, '<p>红薯香甜软糯，蜜心流油，富含膳食纤维和多种矿物质。</p><p>烤红薯满屋飘香，蒸红薯软糯清甜，红薯粥养胃，冬日暖身好物。</p>', 0, 1, 4, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3005, 13, '山药', '', NULL, '<p>山药质地细腻，口感粉糯，黏液蛋白丰富，健脾养胃。</p><p>铁棍山药药食同源。山药炖排骨、蓝莓山药泥、山药粥，滋补日常。</p>', 0, 1, 5, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3006, 13, '莲藕', '', NULL, '<p>莲藕洁白脆嫩，生吃清甜，熟吃粉糯，富含黏液蛋白和膳食纤维。</p><p>凉拌藕片爽脆，莲藕排骨汤鲜甜，藕盒炸制香酥，一藕多吃。</p>', 0, 1, 6, 21.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3007, 13, '洋葱', '', NULL, '<p>洋葱紫皮紧实，辛辣味足，富含槲皮素，切丁爆香是灵魂调味。</p><p>洋葱炒牛肉、洋葱圈炸制、洋葱拌木耳，生吃降脂，熟吃甜香。</p>', 0, 1, 7, 24.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3008, 13, '姜', '', NULL, '<p>生姜辛辣浓郁，姜香十足，去腥暖胃，厨房必备调味。</p><p>炒菜炝锅、炖肉去腥、姜汤驱寒。老姜味足，嫩姜泡醋更爽脆。</p>', 0, 1, 8, 29.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3009, 13, '蒜', '', NULL, '<p>大蒜蒜瓣饱满，蒜香浓郁，杀菌提味，是中华美食的灵魂。</p><p>蒜蓉爆炒、糖蒜腌制、腊八蒜变绿更开胃。家常炒菜炝锅必备。</p>', 0, 1, 9, 26.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3010, 13, '芋头', '', NULL, '<p>芋头粉糯细腻，口感绵密，自带淡淡芋香，饱腹感强。</p><p>香芋蒸排骨、芋头扣肉、糖芋苗，秋冬滋补，粉糯香甜。</p>', 0, 1, 10, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3011, 13, '紫薯', '', NULL, '<p>紫薯色泽深紫，口感香甜粉糯，富含花青素和膳食纤维。</p><p>蒸紫薯软糯，紫薯粥香甜，紫薯银耳羹颜值高，减脂人群好主食。</p>', 0, 1, 11, 8.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3012, 13, '红薯粉条', '', NULL, '<p>红薯粉条久煮不烂，口感劲道爽滑，吸汁入味。</p><p>猪肉炖粉条东北名菜，酸辣粉快手解馋，涮火锅必点主食。</p>', 0, 1, 12, 29.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3013, 13, '莴笋', '', NULL, '<p>莴笋茎秆翠绿脆嫩，口感清爽，富含钾元素和膳食纤维。</p><p>凉拌莴笋丝爽脆，莴笋炒肉片、莴笋炖汤，清脆解腻好食材。</p>', 0, 1, 13, 25.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3014, 13, '蒜黄', '', NULL, '<p>蒜黄金黄鲜嫩，蒜香浓郁，口感柔嫩，是冬春时令菜。</p><p>蒜黄炒鸡蛋、蒜黄炒肉丝、蒜黄馅饺子，香气扑鼻，鲜嫩多汁。</p>', 0, 1, 14, 8.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (3015, 13, '生姜', '', NULL, '<p>生姜辛香浓郁，肉质饱满，姜汁充足，品质上乘。</p><p>去腥增香，煲汤炖肉好伴侣。泡姜更开胃，感冒姜汤暖身必备。</p>', 0, 1, 15, 11.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4001, 14, '香菇', '/uploads/2026/08/香菇_20260813154254.jpeg', NULL, '<p>香菇伞盖厚实，菇香浓郁，肉质肥美，被称为山珍之王。</p><p>干鲜两种吃法都香。香菇炖鸡、香菇油菜、蚝油香菇，提鲜一绝。</p>', 1, 1, 1, 27.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (4002, 14, '平菇', '/uploads/2026/08/平菇_20260813154501.webp', NULL, '<p>平菇叶片肥厚，口感滑嫩，鲜味足，蛋白质含量高。</p><p>平菇炒肉、平菇蛋汤、椒盐平菇，家常实惠，老少皆宜。</p>', 0, 1, 2, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (4003, 14, '金针菇', '', NULL, '<p>金针菇菌柄细长脆嫩，口感爽滑，富含氨基酸和膳食纤维。</p><p>火锅必点，烧烤伴侣。金针菇肥牛卷、凉拌金针菇，爽口开胃。</p>', 0, 1, 3, 16.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4004, 14, '杏鲍菇', '', NULL, '<p>杏鲍菇肉质厚实肥美，口感似鲍鱼，菌香浓郁，嚼劲十足。</p><p>手撕杏鲍菇凉拌，蚝油杏鲍菇、椒盐杏鲍菇，素食也能吃出肉味。</p>', 0, 1, 4, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4005, 14, '白玉菇', '', NULL, '<p>白玉菇洁白如玉，菌盖圆润，口感清甜爽滑，营养丰富。</p><p>白玉菇炒蛋、菌菇汤、涮火锅，清淡鲜美，颜值担当。</p>', 0, 1, 5, 24.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4006, 14, '海鲜菇', '', NULL, '<p>海鲜菇自带海鲜般鲜甜，口感脆嫩，菇香淡雅。</p><p>海鲜菇蛋花汤、海鲜菇炒肉、菌菇煲，鲜味十足，素食提鲜神器。</p>', 0, 1, 6, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4007, 14, '蟹味菇', '', NULL, '<p>蟹味菇有淡淡蟹香，口感爽滑，鲜味独特，颜值高。</p><p>蟹味菇炒蛋、菌菇蒸蛋羹、涮火锅，鲜美滑嫩，孩子也爱吃。</p>', 0, 1, 7, 39.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4008, 14, '茶树菇', '', NULL, '<p>茶树菇菌柄脆嫩，菇香浓郁，自带独特香气，煲汤一绝。</p><p>茶树菇老鸭汤、茶树菇炒腊肉、干锅茶树菇，越嚼越香。</p>', 0, 1, 8, 16.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4009, 14, '口蘑', '', NULL, '<p>口蘑菌盖圆润厚实，口感鲜嫩弹滑，自带鲜美汤汁。</p><p>煎口蘑原汁原味，口蘑炒肉、奶油口蘑汤，西餐中餐皆宜。</p>', 0, 1, 9, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (4010, 14, '黑木耳', '', NULL, '<p>黑木耳肉厚耳脆，口感爽滑弹牙，富含胶质和铁元素。</p><p>凉拌木耳开胃，木耳炒肉、木耳鸡汤。泡发后焯水再烹饪更安心。</p>', 0, 1, 10, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5001, 15, '生姜', '/uploads/2026/08/生姜_20260813154244.jpg', NULL, '<p>生姜辛香浓郁，姜汁充足，去腥暖胃，厨房调味必备。</p><p>炝锅提香、炖肉去腥、姜汤驱寒。嫩姜炒菜，老姜煲汤更出味。</p>', 0, 1, 1, 36.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (5002, 15, '大蒜', '/uploads/2026/08/大蒜_20260813154430.jpg', NULL, '<p>大蒜蒜瓣饱满紧实，蒜香浓郁，杀菌提味两不误。</p><p>蒜蓉爆香、糖蒜泡制、腊八蒜，家家户户离不开的调味主角。</p>', 0, 1, 2, 39.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (5003, 15, '小葱', '', NULL, '<p>小葱翠绿鲜嫩，葱香清雅，是出锅前的点睛之笔。</p><p>葱花炒蛋、葱油拌面、小葱蘸酱，提味增香，清新爽口。</p>', 0, 1, 3, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5004, 15, '蒜苗', '', NULL, '<p>蒜苗翠绿挺拔，蒜香浓郁带清甜，口感脆嫩。</p><p>蒜苗炒腊肉经典下饭，蒜苗回锅肉、蒜苗炒鸡蛋，香气四溢。</p>', 0, 1, 4, 6.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5005, 15, '蒜黄', '', NULL, '<p>蒜黄金黄柔嫩，蒜香浓而不冲，口感软嫩清甜。</p><p>蒜黄炒鸡蛋、蒜黄肉丝、蒜黄饺子，冬春时令鲜美之选。</p>', 0, 1, 5, 12.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5006, 15, '洋葱', '', NULL, '<p>洋葱紫皮紧实，辛辣微甜，切丁爆香香气扑鼻。</p><p>洋葱炒蛋、洋葱牛柳、凉拌洋葱，生熟皆宜，家常必备。</p>', 0, 1, 6, 7.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5007, 15, '小香葱', '', NULL, '<p>小香葱根细叶翠，香气浓郁清甜，比大葱更细腻。</p><p>撒葱花提香，葱油拌面，小香葱煎蛋，简单食材做出好味道。</p>', 0, 1, 7, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5008, 15, '小蒜头', '', NULL, '<p>小蒜头颗粒饱满，蒜香纯正，腌制后酸甜开胃。</p><p>糖蒜、醋蒜经典腌法，吃面配蒜，烤肉伴侣，生吃杀菌。</p>', 0, 1, 8, 89.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5009, 15, '香菜', '', NULL, '<p>香菜叶片翠绿，香气浓烈，富含维生素，增香去腥。</p><p>凉拌香菜、牛肉面灵魂配菜、涮火锅蘸料必备，撒一把就够香。</p>', 0, 1, 9, 69.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5010, 15, '小葱苗', '', NULL, '<p>小葱苗鲜嫩水灵，葱香清甜，比大葱更柔和。</p><p>蘸酱生吃、炒鸡蛋、做葱油，春天气息满满，鲜嫩无比。</p>', 0, 1, 10, 49.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5011, 15, '大葱', '', NULL, '<p>大葱葱白粗长，辛辣味足，是北方菜的调味基石。</p><p>葱爆羊肉、京酱肉丝、炝锅炒菜，大葱蘸酱更是豪迈吃法。</p>', 0, 1, 11, 19.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5012, 15, '姜', '', NULL, '<p>生姜肉质饱满，辛辣浓郁，姜香十足，品质新鲜。</p><p>煲汤炖肉去腥，炒菜炝锅，红糖姜茶暖身，居家必备。</p>', 0, 1, 12, 15.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5013, 15, '蒜', '', NULL, '<p>大蒜蒜瓣白净饱满，蒜素含量高，辛辣提味。</p><p>拍蒜爆香、蒜蓉粉丝蒸、腊八蒜，中餐灵魂调味，每餐必备。</p>', 0, 1, 13, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5014, 15, '洋葱头', '', NULL, '<p>洋葱头紧实圆润，层次分明，辛辣中带甜，营养丰富。</p><p>洋葱炒肉、洋葱圈、罗宋汤必备。放冰箱冷藏更耐储存。</p>', 0, 1, 14, 12.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5015, 15, '香葱', '', NULL, '<p>香葱细嫩翠绿，葱香清甜浓郁，出锅撒香是点睛之笔。</p><p>葱油拌面、香葱煎蛋、煲汤提香，葱香四溢，食欲大开。</p>', 0, 1, 15, 6.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (5016, 15, '蒜苗', '', NULL, '<p>蒜苗青翠挺拔，蒜香清甜，口感脆嫩，时令鲜蔬。</p><p>蒜苗炒肉、蒜苗回锅肉、蒜苗炒香干，香气浓郁超下饭。</p>', 0, 1, 16, 3.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (6001, 16, '四季豆', '/uploads/2026/08/四季豆_20260813154223.jpeg', NULL, '<p>四季豆翠绿饱满，口感清甜脆嫩，蛋白质丰富。</p><p>干煸四季豆、四季豆炒肉末、豆角焖面，务必炒熟透再食用。</p>', 0, 1, 1, 3.50, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (6002, 16, '荷兰豆', '/uploads/2026/08/荷兰豆_20260813154510.jpg', NULL, '<p>荷兰豆色泽翠绿，豆荚薄脆，口感清甜爽脆。</p><p>荷兰豆炒腊肠、清炒荷兰豆、蒜蓉荷兰豆，大火快炒锁住脆嫩。</p>', 0, 1, 2, 3.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (6003, 16, '豇豆', '', NULL, '<p>豇豆细长翠绿，肉质厚实，口感清甜，越嫩越好吃。</p><p>手撕豇豆、豇豆炒肉、酸豆角，夏日餐桌人气豆角。</p>', 0, 1, 3, 2.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (6004, 16, '毛豆', '', NULL, '<p>毛豆翠绿饱满，豆香清甜，蛋白质含量高，越嚼越香。</p><p>水煮毛豆配啤酒，毛豆炒肉、毛豆炖汤，夏日鲜香好味。</p>', 0, 1, 4, 5.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (6005, 16, '长豆角', '', NULL, '<p>长豆角嫩绿细长，口感脆嫩清甜，纤维少不塞牙。</p><p>干煸豆角、豇豆肉末、腌酸豆角，怎么做都下饭。</p>', 0, 1, 5, 4.50, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (6006, 16, '芸豆', '', NULL, '<p>芸豆颗粒饱满，豆香浓郁，口感粉糯，蛋白质丰富。</p><p>芸豆炖排骨、蜜芸豆、芸豆米饭，粉糯香甜，营养饱腹。</p>', 0, 1, 6, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7001, 21, '西瓜', '/uploads/2026/08/西瓜_20260813160007.jpg', '[\"https://cdn.example.com/spu/7001_1.jpg\", \"https://cdn.example.com/spu/7001_2.jpg\"]', '<p>西瓜皮薄肉厚，沙瓤多汁，糖度12°+，清甜解渴。</p><p>基地直发，采摘后24小时内发货。收货后建议放置2-3小时再切开，口感更佳。</p>', 0, 1, 1, 12.99, 24.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (7002, 21, '哈密瓜', '/uploads/2026/08/哈密瓜_20260813160125.jpg', NULL, '<p>哈密瓜果肉橙黄，香甜多汁，脆嫩爽口，糖度极高。</p><p>新疆产地直发。冰镇后切块，清甜解暑，夏日水果之王。</p>', 0, 1, 2, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (7003, 21, '香瓜', '', NULL, '<p>香瓜果香浓郁，肉质绵甜多汁，口感细腻。</p><p>皮薄肉厚，籽少味甜。冰镇食用风味更佳，夏日消暑佳品。</p>', 0, 1, 3, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7004, 21, '甜瓜', '', NULL, '<p>甜瓜白绿相间，清甜爽脆，汁水丰盈，果香清新。</p><p>现摘现发，自然熟。冷藏后口感更佳，清爽解腻，全家爱吃。</p>', 0, 1, 4, 7.99, 9.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7005, 21, '火龙果', '', NULL, '<p>火龙果果肉红艳，清甜多汁，籽粒脆爽，富含花青素和膳食纤维。</p><p>红心火龙果甜度更高。切块即食、榨汁、拌酸奶，颜值与营养并存。</p>', 0, 1, 5, 6.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7006, 21, '百香果', '', NULL, '<p>百香果果香馥郁，酸甜可口，富含维生素C，有果汁之王之称。</p><p>对半切开挖籽冲蜂蜜水，做百香果柠檬茶，果香浓郁超解腻。</p>', 0, 1, 6, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7007, 21, '杨桃', '', NULL, '<p>杨桃果形五棱，晶莹剔透，口感清甜爽脆，水分充足。</p><p>星形切面颜值高。直接切片食用，蘸盐或梅子粉风味更独特。</p>', 0, 1, 7, 18.99, 22.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7008, 21, '桃子', '', NULL, '<p>桃子粉嫩饱满，果肉细腻，香甜多汁，桃香浓郁。</p><p>水蜜桃品种，软硬两吃。硬吃脆甜，放软后汁水爆浆，香气四溢。</p>', 0, 1, 8, 9.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7009, 21, '李子', '', NULL, '<p>李子色泽紫红，果肉紧实，酸甜开胃，汁水充足。</p><p>放软后风味更佳。冰镇食用，酸甜解腻，夏日开胃水果。</p>', 0, 1, 9, 12.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7010, 21, '荔枝', '', NULL, '<p>荔枝果壳鲜红，果肉晶莹剔透，清甜多汁，香气独特。</p><p>当日采摘冷链发货。冰镇后食用，甜而不腻，岭南佳果。</p>', 0, 1, 10, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7011, 21, '榴莲', '', NULL, '<p>榴莲果肉金黄绵密，香气浓郁，口感如奶油般丝滑，甜而不腻。</p><p>猫山王品质之选。冰镇食用像冰淇淋，炖鸡汤更滋补，榴莲控福音。</p>', 0, 1, 11, 59.99, 79.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7012, 21, '山竹', '', NULL, '<p>山竹果肉洁白如蒜瓣，清甜微酸，口感细腻，果香清新。</p><p>水果皇后，和榴莲是绝配。冰镇食用，解腻降火，夏日必备。</p>', 0, 1, 12, 29.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7013, 21, '椰子', '', NULL, '<p>椰子椰汁清甜，椰肉厚实，清香自然，天然解渴。</p><p>椰汁直接饮用，椰肉挖取食用。椰青炖鸡、椰子水打底做饮品皆宜。</p>', 0, 1, 13, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7014, 21, '芒果', '', NULL, '<p>芒果果肉金黄，香甜多汁，纤维细腻，香气浓郁。</p><p>成熟度恰到好处。直接食用、榨芒果汁、做芒果糯米饭，热带风情十足。</p>', 0, 1, 14, 14.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7015, 21, '菠萝', '', NULL, '<p>菠萝果肉金黄，酸甜多汁，纤维适中，香气浓郁。</p><p>削皮后用盐水浸泡更佳。菠萝咕咾肉、菠萝炒饭、鲜榨菠萝汁，开胃解腻。</p>', 0, 1, 15, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7016, 21, '杨梅', '', NULL, '<p>杨梅色泽乌红，果肉饱满，酸甜多汁，风味独特。</p><p>时令短促，且吃且珍惜。冰镇杨梅、杨梅汤、泡杨梅酒，酸甜开胃。</p>', 0, 1, 16, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7017, 21, '樱桃', '', NULL, '<p>樱桃果皮红润，果肉脆甜，汁水丰盈，入口爆汁。</p><p>车厘子品质，颗颗精选。冰镇食用更佳，补铁护眼，水果贵族。</p>', 0, 1, 17, 22.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7018, 21, '蓝莓', '', NULL, '<p>蓝莓果粉完整，颗粒饱满，酸甜可口，富含花青素。</p><p>护眼抗氧化。直接食用、拌酸奶、做蓝莓酱，健康零食首选。</p>', 0, 1, 18, 18.99, 24.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7019, 21, '草莓', '', NULL, '<p>草莓果形饱满，色泽红润，香甜多汁，草莓香气浓郁。</p><p>当天采摘当天发货。直接食用、草莓蛋糕、草莓酱，红颜满屋香。</p>', 0, 1, 19, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7020, 21, '葡萄', '', NULL, '<p>葡萄颗粒饱满，果肉紧实，甜度高，汁水丰盈。</p><p>皮薄肉脆，冰镇后食用风味更佳。洗后食用，榨汁做沙拉皆宜。</p>', 0, 1, 20, 16.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7021, 21, '柠檬', '', NULL, '<p>柠檬果皮金黄，香气清新，酸度纯正，富含维生素C。</p><p>柠檬蜂蜜水、柠檬泡椒凤爪、烤鱼提香。切片泡水，美白解腻。</p>', 0, 1, 21, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7022, 21, '青提', '', NULL, '<p>青提翡翠碧绿，皮薄无籽，脆甜多汁，入口爽利。</p><p>阳光充足糖分高。冷藏后食用冰爽脆甜，一颗接一颗停不下来。</p>', 0, 1, 22, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7023, 21, '红提', '', NULL, '<p>红提色泽红润，果粒紧实，清甜脆爽，带籽可嚼。</p><p>耐储存，冰箱冷藏可保存一周。洗净即食，招待客人有面子。</p>', 0, 1, 23, 21.99, 27.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7024, 21, '香蕉', '', NULL, '<p>香蕉果肉绵密，香甜软糯，即买即食，老少皆宜。</p><p>自然熟更香甜。香蕉牛奶、香蕉燕麦、香蕉松饼，营养早餐好伴侣。</p>', 0, 1, 24, 5.99, 7.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7025, 21, '苹果', '', NULL, '<p>苹果果皮红亮，果肉脆甜，汁水充足，苹果香气纯正。</p><p>现摘现发，颗颗饱满。直接食用，榨汁、烤苹果、苹果派皆宜。</p>', 0, 1, 25, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7026, 21, '梨', '', NULL, '<p>梨果形饱满，果肉细腻，清甜多汁，润肺止咳。</p><p>汁水丰盈，生吃清甜，冰糖雪梨汤润喉。秋季干燥，吃梨正当时。</p>', 0, 1, 26, 6.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7027, 21, '桔子', '', NULL, '<p>桔子果皮金黄，果肉酸甜多汁，桔香浓郁。</p><p>皮薄易剥，一瓣一瓣停不下。剥皮即食，榨汁、做桔子罐头皆宜。</p>', 0, 1, 27, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7028, 21, '橙子', '', NULL, '<p>橙子果皮光滑，果肉紧实，酸甜多汁，维生素C丰富。</p><p>手剥橙汁水丰盈。直接食用、鲜榨橙汁、盐蒸橙子止咳，营养满满。</p>', 0, 1, 28, 8.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7029, 21, '柚子', '', NULL, '<p>柚子果肉晶莹，清甜微酸，汁水充足，富含维生素C。</p><p>柚子皮除味，柚子茶清甜。秋冬干燥季，补水润燥佳品。</p>', 0, 1, 29, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7030, 21, '猕猴桃', '', NULL, '<p>猕猴桃果肉翠绿，籽粒细腻，酸甜多汁，维C含量极高。</p><p>放软后食用更甜。猕猴桃酸奶、榨汁、切盘，健康水果之选。</p>', 0, 1, 30, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7031, 21, '冬枣', '', NULL, '<p>冬枣圆润饱满，皮薄肉脆，甘甜多汁，维C含量水果之冠。</p><p>咬一口脆甜爆汁。洗净即食，冷冻后口感如冰沙，一口一个。</p>', 0, 1, 31, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (7032, 21, '椰子', '', NULL, '<p>椰青椰汁清甜冰爽，椰肉嫩滑，天然补水神器。</p><p>开孔插吸管直接喝。椰汁炖鸡、椰子冻、椰肉椰奶，夏日清爽组合。</p>', 0, 1, 32, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8001, 22, '巨峰葡萄', '/uploads/2026/08/巨峰葡萄_20260813160000.jpg', NULL, '<p>巨峰葡萄果粒硕大，果皮紫黑，肉厚多汁，甜中带微酸。</p><p>经典老牌品种。冰镇后食用风味更佳，榨汁、酿酒皆宜。</p>', 0, 1, 1, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (8002, 22, '夏黑葡萄', '/uploads/2026/08/夏黑葡萄_20260813160142.jpg', NULL, '<p>夏黑葡萄无籽皮薄，果肉紧实，脆甜多汁，甜度极高。</p><p>一口一个不用吐籽。冷藏后冰爽脆甜，夏日解暑优选。</p>', 0, 1, 2, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (8003, 22, '阳光玫瑰', '', NULL, '<p>阳光玫瑰果粒翠绿，玫瑰香气浓郁，皮薄无籽，甜度极高。</p><p>高端葡萄之选。香气独特，冷藏后风味更佳，送礼有面子。</p>', 0, 1, 3, 39.99, 49.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8004, 22, '蓝莓', '', NULL, '<p>蓝莓果粉完整，果粒饱满，酸甜适口，花青素丰富。</p><p>护眼抗氧化。洗净即食，拌酸奶、做蓝莓酱，健康零食首选。</p>', 0, 1, 4, 18.99, 24.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8005, 22, '草莓', '', NULL, '<p>草莓果形端正，色泽鲜红，香甜多汁，草莓香浓郁。</p><p>当日现摘现发。直接食用、草莓奶昔、草莓蛋糕，甜蜜满屋。</p>', 0, 1, 5, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8006, 22, '猕猴桃', '', NULL, '<p>猕猴桃果肉翠绿，酸甜多汁，维C之王，营养密度高。</p><p>放软后食用更香甜。猕猴桃酸奶、榨汁、果盘搭配，健康首选。</p>', 0, 1, 6, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8007, 22, '杨梅', '', NULL, '<p>杨梅乌红饱满，酸甜多汁，果香浓郁，时令珍果。</p><p>鲜食期短，且吃且珍惜。冰镇杨梅、杨梅汤、杨梅酒，夏日限定。</p>', 0, 1, 7, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8008, 22, '樱桃', '', NULL, '<p>樱桃红润饱满，果肉脆甜，汁水丰盈，颗颗爆汁。</p><p>精品大果，冷链发货。冰镇食用口感更佳，补铁护眼，甜蜜享受。</p>', 0, 1, 8, 22.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8009, 22, '桑葚', '', NULL, '<p>桑葚紫黑饱满，汁水丰盈，清甜带酸，花青素含量极高。</p><p>采摘期短，珍贵时令果。桑葚酱、桑葚酒，补血养颜。</p>', 0, 1, 9, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8010, 22, '黑布林', '', NULL, '<p>黑布林果皮深紫，果肉紧实，酸甜浓郁，风味独特。</p><p>放软后口感更佳。冰镇食用，酸甜解腻，餐后水果好选择。</p>', 0, 1, 10, 22.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8011, 22, '无花果', '', NULL, '<p>无花果果肉粉红绵密，香甜软糯，种子细腻，营养丰富。</p><p>高纤通便。直接食用、做无花果酱、配沙拉，甜蜜养生。</p>', 0, 1, 11, 29.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (8012, 22, '西梅', '', NULL, '<p>西梅果皮紫蓝，果肉紧实，清甜多汁，膳食纤维丰富。</p><p>通便小能手。直接食用、做成西梅干，软糯香甜，健康零食。</p>', 0, 1, 12, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (9001, 23, '香蕉', '/uploads/2026/08/香蕉_20260813155948.webp', NULL, '<p>香蕉果肉绵密，香甜软糯，自然熟更甜，老少皆宜。</p><p>香蕉牛奶、香蕉燕麦早餐、香蕉派，营养快手两不误。</p>', 0, 1, 1, 5.99, 7.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (9002, 23, '芒果', '/uploads/2026/08/芒果_20260813160132.jpg', NULL, '<p>芒果果肉金黄细腻，香甜多汁，纤维少，香气浓郁。</p><p>现摘现发。直接食用、芒果沙冰、芒果糯米粉，热带风情满满。</p>', 0, 1, 2, 14.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (9003, 23, '火龙果', '/uploads/2026/08/火龙果_20260813160102.jpg', NULL, '<p>火龙果果肉红艳，清甜多汁，籽粒爽脆，营养丰富。</p><p>红心甜度更高。切块即食、榨汁、拌酸奶，清爽解腻。</p>', 0, 1, 3, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (9004, 23, '菠萝', '', NULL, '<p>菠萝金黄多汁，酸甜可口，香气浓郁，纤维适中。</p><p>盐水浸泡后食用更佳。菠萝炒饭、菠萝咕咾肉、鲜榨果汁，开胃必备。</p>', 0, 1, 4, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (9005, 23, '榴莲', '', NULL, '<p>榴莲果肉金黄绵密，香气浓郁，口感丝滑，甜而不腻。</p><p>佳品金枕。冰镇后如冰淇淋，榴莲炖鸡滋补，榴莲控福利。</p>', 0, 1, 5, 59.99, 79.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (9006, 23, '山竹', '', NULL, '<p>山竹果肉洁白细嫩，清甜微酸，果香清新，营养丰富。</p><p>水果皇后。冷藏后食用更佳，解腻降火，和榴莲是黄金搭档。</p>', 0, 1, 6, 29.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (9007, 23, '椰子', '', NULL, '<p>椰青椰汁清甜，椰肉嫩滑，天然补水，清香自然。</p><p>开盖即饮，椰汁清冽解渴。椰汁炖汤、椰子冻、椰奶，清爽一夏。</p>', 0, 1, 7, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (9008, 23, '百香果', '', NULL, '<p>百香果果香馥郁，酸甜多汁，维C丰富，果汁之王。</p><p>挖籽冲蜜水、做百香果柠檬茶，果香浓郁，天然好喝。</p>', 0, 1, 8, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (9009, 23, '杨桃', '', NULL, '<p>杨桃晶莹五棱，清甜爽脆，水分充足，颜值超高。</p><p>星形切片摆盘惊艳。直接食用、蘸梅子粉，清爽开胃。</p>', 0, 1, 9, 18.99, 22.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (9010, 23, '柠檬', '', NULL, '<p>柠檬果香清新，酸度纯正，维C丰富，百搭水果。</p><p>柠檬蜂蜜水、柠檬茶、烤鱼提香。切片泡水，美白解腻。</p>', 0, 1, 10, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (10001, 24, '红富士苹果', '/uploads/2026/08/红富士苹果_20260813155940.jpg', '[\"https://cdn.example.com/spu/10001_1.jpg\", \"https://cdn.example.com/spu/10001_2.jpg\"]', '<p>红富士苹果果形端正，色泽红亮，肉质细脆多汁，香甜爽口。</p><p>产地冷藏保鲜，果面天然果蜡，可连皮食用。常温保存15天，冷藏30天。</p>', 0, 1, 1, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (10002, 24, '嘎啦苹果', '/uploads/2026/08/苹果_20260809150317.jpg', NULL, '<p>嘎啦苹果果皮红亮，果肉脆甜，香气浓郁，酸甜适口。</p><p>早熟品种口感佳。现摘现发，直接食用，榨汁做派皆宜。</p>', 0, 1, 2, 8.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (10003, 24, '皇冠梨', '/uploads/2026/08/皇冠梨_20260813160112.jpg', NULL, '<p>皇冠梨果皮金黄，果肉细腻，清甜多汁，核小肉厚。</p><p>润肺止咳。生吃清甜，冰糖雪梨汤润喉，秋燥必备。</p>', 0, 1, 3, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (10004, 24, '鸭梨', '', NULL, '<p>鸭梨果形饱满，果肉细脆，清甜多汁，梨香清新。</p><p>皮薄多汁。直接食用、煮梨汤，润燥清甜，全家都爱。</p>', 0, 1, 4, 6.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (10005, 24, '水蜜桃', '', NULL, '<p>水蜜桃果皮粉嫩，果肉细腻，香甜爆汁，桃香浓郁。</p><p>放软后汁水更足。硬吃脆甜，软吃流蜜，夏天就要吃桃。</p>', 0, 1, 5, 14.99, 33.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (10006, 24, '黄桃', '', NULL, '<p>黄桃果肉金黄，绵密香甜，桃香浓郁，口感厚实。</p><p>直接食用或做黄桃罐头。黄桃酸奶、黄桃蛋糕，甜蜜诱惑。</p>', 0, 1, 6, 12.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (10007, 24, '油桃', '', NULL, '<p>油桃果皮光滑油亮，果肉紧实脆甜，汁水充足，香气浓郁。</p><p>洗净即食，脆甜爽口。放软后更香甜，夏日水果佳选。</p>', 0, 1, 7, 13.99, 31.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (10008, 24, '李子', '', NULL, '<p>李子果皮紫红，果肉紧实，酸甜开胃，汁水丰富。</p><p>放软后风味更佳。冰镇食用，酸甜解腻，开胃好水果。</p>', 0, 1, 8, 11.99, 14.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (10009, 24, '蜜桔', '', NULL, '<p>蜜桔果皮金黄，皮薄易剥，果肉细嫩，蜜甜多汁。</p><p>无渣化口，一颗接一颗。剥皮即食，秋冬季甜蜜担当。</p>', 0, 1, 9, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (10010, 24, '橙子', '', NULL, '<p>橙子果皮光滑，果肉紧实，酸甜多汁，维C丰富。</p><p>手剥汁水丰盈。鲜榨橙汁、盐蒸橙子，补充维C，元气满满。</p>', 0, 1, 10, 8.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (11001, 31, '猪五花肉', '/uploads/2026/08/猪五花肉_20260813155725.jpeg', '[\"https://cdn.example.com/spu/11001_1.jpg\", \"https://cdn.example.com/spu/11001_2.jpg\"]', '<p>猪五花肉肥瘦相间，皮白肉红，肥而不腻，瘦而不柴。</p><p>冷鲜肉当日屠宰，酸排酬处理，红烧肉、梅菜扣肉、回锅肉首选部位。</p>', 0, 1, 1, 15.99, 36.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (11002, 31, '猪里脊', '/uploads/2026/08/猪里脊_20260813155836.jpg', NULL, '<p>猪里脊肉质细嫩，脂肪少，口感滑嫩，是猪身上最嫩的部位。</p><p>糖醋里脊、鱼香肉丝、小炒里脊，切丝切片大火快炒，嫩滑多汁。</p>', 0, 1, 2, 22.99, 52.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (11003, 31, '猪排骨', '', NULL, '<p>猪排骨肉质紧实，骨髓丰富，炖煮后鲜香入味，口感弹嫩。</p><p>糖醋排骨、排骨炖汤、红烧排骨，家常硬菜担当，汤汁拌饭一绝。</p>', 0, 1, 3, 14.99, 34.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (11004, 31, '猪蹄', '', NULL, '<p>猪蹄皮厚筋多，胶原蛋白丰富，炖煮后软糯弹牙，Q弹十足。</p><p>红烧猪蹄、黄豆炖猪蹄、烤猪蹄，美容养颜，越啃越香。</p>', 0, 1, 4, 12.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (11005, 31, '猪肝', '', NULL, '<p>猪肝鲜嫩细腻，铁元素丰富，补铁养血，营养密度高。</p><p>爆炒猪肝嫩滑，菠菜猪肝汤滋补。切片泡水去腥，大火快炒锁嫩。</p>', 0, 1, 5, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (11006, 31, '猪头肉', '/uploads/2026/08/猪肉_20260809150237.jpg', NULL, '<p>猪头肉肥瘦相间，胶质丰富，卤制后香气浓郁，口感Q弹。</p><p>卤猪头肉切片凉拌，下酒神器。蒜泥白肉、猪头肉拌黄瓜，越嚼越香。</p>', 0, 1, 6, 13.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (11007, 31, '猪腰子', '', NULL, '<p>猪腰子肉质脆嫩，处理得当后口感爽脆，营养丰富。</p><p>爆炒腰花、葱爆腰花经典做法。去膜去筋切花刀，大火爆炒才嫩。</p>', 0, 1, 7, 16.99, 20.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (12001, 32, '牛腱子肉', '/uploads/2026/08/牛肉_20260809150258.jpg', NULL, '<p>牛腱子肉筋肉交错，口感筋道有嚼劲，卤制后香气十足。</p><p>卤牛肉切片下酒，酱牛肉、牛腱炖萝卜，越嚼越有滋味。</p>', 0, 1, 1, 35.99, 84.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (12002, 32, '牛里脊', '/uploads/2026/08/牛里脊_20260813155817.webp', NULL, '<p>牛里脊肉质细嫩，纤维细腻，口感滑嫩，是牛排和炒菜的首选。</p><p>黑椒牛柳、西芹炒牛肉、嫩牛肉火锅，大火快炒嫩滑多汁。</p>', 0, 1, 2, 49.99, 119.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (12003, 32, '羊腿肉', '/uploads/2026/08/羊肉_20260809150220.jpg', NULL, '<p>羊腿肉肉质紧实，膻味轻，瘦肉多，炖煮后鲜嫩入味。</p><p>羊肉炖萝卜暖身，孜然羊肉、羊肉手抓饭，秋冬滋补首选。</p>', 0, 1, 3, 38.99, 91.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (12004, 32, '羊排', '', NULL, '<p>羊排肉质细嫩，肥瘦相间，烤制后外焦里嫩，香气四溢。</p><p>烤羊排、红烧羊排、羊排萝卜汤，孜然辣椒一撒，满屋飘香。</p>', 0, 1, 4, 45.99, 109.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (13001, 33, '三黄鸡', '/uploads/2026/08/三黄鸡_20260813155715.jpg', NULL, '<p>三黄鸡皮黄肉嫩，肉质细滑，鲜味足，适合白切和煲汤。</p><p>白切鸡、盐焗鸡、鸡汤，肉质鲜嫩不柴，做法多样。</p>', 0, 1, 1, 25.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (13002, 33, '土鸡', '/uploads/2026/08/土鸡_20260813155800.jpg', NULL, '<p>土鸡散养长大，肉质紧实鲜美，汤味浓郁，营养更丰富。</p><p>老母鸡炖汤最滋补，红烧土鸡、清炖土鸡，汤鲜肉香，家常大补。</p>', 0, 1, 2, 38.99, 48.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (13003, 33, '鸡腿', '/uploads/2026/08/鸡腿_20260813155913.jpeg', NULL, '<p>鸡腿肉质厚实细嫩，口感多汁，怎么做都好吃。</p><p>香煎鸡腿、照烧鸡腿、炸鸡腿，奥尔良烤鸡腿，肉食爱好者最爱。</p>', 0, 1, 3, 14.99, 34.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (13004, 33, '鸡翅', '', NULL, '<p>鸡翅皮嫩肉滑，胶原蛋白丰富，烤制煎炸都香气扑鼻。</p><p>可乐鸡翅、蜜汁烤翅、椒盐鸡翅，外焦里嫩，大人小孩都爱。</p>', 0, 1, 4, 12.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (13005, 33, '鸭肉', '', NULL, '<p>鸭肉肉质紧实，皮薄脂肪适中，香味独特，滋阴润燥。</p><p>啤酒鸭、红烧鸭、老鸭汤，家常硬菜，越炖越香。</p>', 0, 1, 5, 28.99, 35.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (13006, 33, '鸭蛋', '', NULL, '<p>鸭蛋蛋壳光滑，蛋黄橙红起沙，口感醇厚，营养丰富。</p><p>咸鸭蛋流油起沙，炒鸭蛋、鸭蛋蒸蛋羹，早餐粥的黄金搭档。</p>', 0, 1, 6, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (13007, 33, '鸽子', '', NULL, '<p>鸽子肉质细嫩鲜美，蛋白质含量高，炖汤滋补，营养丰富。</p><p>鸽子汤滋补养身，红烧鸽子、烤乳鸽，汤鲜肉嫩，滋补佳品。</p>', 0, 1, 7, 22.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (13008, 33, '鹌鹑蛋', '', NULL, '<p>鹌鹑蛋小巧圆润，蛋黄细腻，营养是鸡蛋的数倍。</p><p>卤鹌鹑蛋、虎皮鹌鹑蛋、火锅配菜，一口一个，孩子最爱。</p>', 0, 1, 8, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (14001, 34, '鸡蛋', '/uploads/2026/08/鸡蛋_20260813155708.jpg', NULL, '<p>鸡蛋蛋壳干净，蛋黄饱满橙黄，蛋清浓稠，新鲜可溯。</p><p>当天产蛋当天发货。蒸蛋羹、炒蛋、煮蛋、蛋花汤，营养早餐标配。</p>', 0, 1, 1, 9.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (14002, 34, '土鸡蛋', '/uploads/2026/08/土鸡蛋_20260813155750.jpeg', NULL, '<p>土鸡蛋蛋黄橙红，口感醇香，蛋白浓稠，散养更营养。</p><p>农家散养鸡产蛋。水煮蛋、蒸蛋羹、糖水蛋，蛋香浓郁，安心之选。</p>', 0, 1, 2, 14.99, 34.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (14003, 34, '鸭蛋', '/uploads/2026/08/鸭蛋_20260813155858.jpg', NULL, '<p>鸭蛋蛋黄大而红，蛋白质地细腻，风味独特。</p><p>咸鸭蛋流油起沙，炒鸭蛋、蛋花汤，早餐下饭两相宜。</p>', 0, 1, 3, 18.99, 44.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (14004, 34, '鹌鹑蛋', '', NULL, '<p>鹌鹑蛋小巧营养高，蛋黄细腻，富含卵磷脂和蛋白质。</p><p>卤蛋一口一个，火锅必备。虎皮鹌鹑蛋、糖醋鹌鹑蛋，孩子爱吃。</p>', 0, 1, 4, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (15001, 41, '草鱼', '/uploads/2026/08/草鱼_20260809134918.jpg', '[\"https://cdn.example.com/spu/15001_1.jpg\", \"https://cdn.example.com/spu/15001_2.jpg\"]', '<p>草鱼肉质细嫩，刺少肉多，富含不饱和脂肪酸，适合红烧、清蒸、鱼头豆腐汤。</p><p>活鱼现杀，去鳞去鳃去内脏，冰袋保鲜发货。收货后建议1小时内烹饪。</p>', 0, 1, 1, 18.99, 33.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (15002, 41, '鲤鱼', '/uploads/2026/08/鲤鱼_20260813155540.jpg', NULL, '<p>鲤鱼鱼肉紧实，肉质鲜嫩，鱼刺分明，越煮越鲜。</p><p>红烧鲤鱼、糖醋鲤鱼、鲤鱼炖豆腐，家常鱼菜经典，鲜美下饭。</p>', 0, 1, 2, 16.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (15003, 41, '鲫鱼', '/uploads/2026/08/鲫鱼_20260813155620.jpg', NULL, '<p>鲫鱼鱼肉细嫩鲜美，汤味奶白浓郁，滋补养身。</p><p>鲫鱼豆腐汤奶白鲜香，红烧鲫鱼、鲫鱼蒸蛋，汤鲜肉嫩，老幼皆宜。</p>', 0, 1, 3, 12.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (15004, 41, '鲢鱼', '', NULL, '<p>鲢鱼鱼头肥美，鱼肉细嫩，胶质丰富，炖汤一绝。</p><p>剁椒鱼头、鱼头豆腐汤、红烧鲢鱼，鱼头是灵魂，越吃越香。</p>', 0, 1, 4, 14.99, 26.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (15005, 41, '鳙鱼', '', NULL, '<p>鳙鱼鱼头硕大肥美，鱼肉细嫩，胶质丰富，营养滋补。</p><p>剁椒鱼头湘味经典，鱼头汤奶白鲜美，鱼身红烧，一鱼两吃。</p>', 0, 1, 5, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (15006, 41, '黄鳝', '', NULL, '<p>黄鳝肉质细嫩，刺少肉厚，口感弹滑，营养丰富。</p><p>鳝丝炒茭白、红烧黄鳝、响油鳝糊，浓油赤酱，鲜美无比。</p>', 0, 1, 6, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (16001, 42, '带鱼', '/uploads/2026/08/带鱼_20260813155338.jpg', NULL, '<p>带鱼鱼身银亮，肉质紧实细嫩，刺少肉厚，鲜味足。</p><p>香煎带鱼外酥里嫩，红烧带鱼、糖醋带鱼，家常下饭好菜。</p>', 0, 1, 1, 18.99, 43.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (16002, 42, '黄花鱼', '/uploads/2026/08/黄花鱼_20260813155515.webp', NULL, '<p>黄花鱼肉质细嫩如蒜瓣，刺少味鲜，营养丰富。</p><p>清蒸黄花鱼原汁原味，红烧黄花鱼、香煎黄花鱼，鲜嫩不腥。</p>', 0, 1, 2, 22.99, 53.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (16003, 42, '鲳鱼', '/uploads/2026/08/鲳鱼_20260813155605.webp', NULL, '<p>鲳鱼肉质细嫩，刺少肉厚，味道鲜美，老少皆宜。</p><p>清蒸鲳鱼鲜嫩，香煎鲳鱼外酥里嫩，红烧鲳鱼，怎么做都好吃。</p>', 0, 1, 3, 35.99, 44.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (16004, 42, '鲈鱼', '', NULL, '<p>鲈鱼肉质细嫩洁白，刺少味鲜，是清蒸鱼首选。</p><p>清蒸鲈鱼鲜嫩多汁，葱油鲈鱼、红烧鲈鱼，宴客家常两相宜。</p>', 0, 1, 4, 28.99, 35.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (16005, 42, '鳕鱼', '', NULL, '<p>鳕鱼肉质细嫩，口感滑嫩，刺少肉厚，高蛋白低脂肪。</p><p>香煎鳕鱼外焦里嫩，清蒸鳕鱼、鳕鱼炖豆腐，宝宝辅食优选。</p>', 0, 1, 5, 38.99, 48.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (16006, 42, '鱿鱼', '', NULL, '<p>鱿鱼肉质厚实弹韧，口感爽脆，鲜味十足。</p><p>铁板鱿鱼、爆炒鱿鱼须、鱿鱼圈炸制，烧烤界人气王。</p>', 0, 1, 6, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (17001, 43, '基围虾', '/uploads/2026/08/基围虾_20260813155333.jpg', NULL, '<p>基围虾壳薄肉厚，虾肉弹嫩鲜甜，虾头虾膏饱满。</p><p>白灼基围虾原汁原味，蒜蓉开背虾、油焖大虾，宴客硬菜。</p>', 0, 1, 1, 45.99, 109.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (17002, 43, '明虾', '/uploads/2026/08/明虾_20260813155450.webp', NULL, '<p>明虾个大肉厚，虾肉弹滑，鲜甜可口，虾味浓郁。</p><p>清蒸、白灼、椒盐皆宜。虾仁炒蛋、鲜虾粥，鲜上加鲜。</p>', 0, 1, 2, 38.99, 48.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (17003, 43, '花蛤', '/uploads/2026/08/花蛤_20260813155559.jpeg', NULL, '<p>花蛤鲜活吐沙，肉质鲜嫩肥美，自带海水鲜味。</p><p>爆炒花蛤配啤酒，花蛤蒸蛋鲜嫩，紫菜花蛤汤，鲜掉眉毛。</p>', 0, 1, 3, 28.99, 35.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (17004, 43, '大闸蟹', '/uploads/2026/08/大闸蟹_20260813155631.jpg', NULL, '<p>大闸蟹青壳白肚，蟹黄饱满流油，蟹肉清甜细嫩。</p><p>清蒸大闸蟹配姜醋，阳澄湖同款品质，金秋蟹宴主角。</p>', 0, 1, 4, 68.99, 159.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (17005, 43, '生蚝', '', NULL, '<p>生蚝肥美多汁，蚝肉鲜嫩，海水味清新，营养丰富。</p><p>蒜蓉粉丝烤生蚝，清蒸生蚝配柠檬，生蚝煎蛋，鲜甜爆汁。</p>', 0, 1, 5, 32.99, 40.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (17006, 43, '牡蛎', '', NULL, '<p>牡蛎肥美饱满，蚝肉滑嫩，鲜味浓郁，富含锌元素。</p><p>蒜蓉烤牡蛎、牡蛎煎蛋、牡蛎豆腐汤，鲜美滋补两不误。</p>', 0, 1, 6, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (18001, 51, '东北大米', '/uploads/2026/08/东北大米_20260813154715.webp', '[\"https://cdn.example.com/spu/18001_1.jpg\", \"https://cdn.example.com/spu/18001_2.jpg\"]', '<p>东北大米粒粒饱满，晶莹剔透，蒸煮后米香浓郁，米饭软糯香甜。</p><p>黑土地种植，生长周期长，积累更多干物质。真空包装防潮防虫，常温保存12个月。</p>', 0, 1, 1, 69.99, 159.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (18002, 51, '五常大米', '/uploads/2026/08/五常大米_20260813154858.jpg', NULL, '<p>五常大米颗粒饱满，米香浓郁，蒸煮后软糯弹牙，油光发亮。</p><p>黑土地孕育，稻花香品种。新米当季，煮粥煮饭都香气扑鼻。</p>', 0, 1, 2, 89.99, 199.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (18003, 51, '小米', '/uploads/2026/08/小米_20260813160623.webp', NULL, '<p>小米颗粒金黄，米香醇厚，熬粥后绵软起油皮，养胃暖身。</p><p>陕北小米品质优良。小米南瓜粥、小米红枣粥，早餐养生首选。</p>', 0, 1, 3, 9.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (18004, 51, '黄豆', '/uploads/2026/08/黄豆_20260813160631.jpg', NULL, '<p>黄豆颗粒饱满，豆香浓郁，蛋白质含量高，大豆异黄酮丰富。</p><p>打豆浆浓香细腻，发豆芽、炖猪蹄、卤黄豆，一豆多吃。</p>', 0, 1, 4, 12.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (18005, 51, '绿豆', '/uploads/2026/08/绿豆_20260813160638.webp', NULL, '<p>绿豆颗粒翠绿饱满，煮后绵沙起沙，清热解暑。</p><p>绿豆汤解暑神器，绿豆糕、绿豆粥，夏日清凉必备。</p>', 0, 1, 5, 11.99, 14.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (18006, 51, '红豆', '', NULL, '<p>红豆颗粒饱满，色泽红润，煮后绵软起沙，补血养颜。</p><p>红豆沙甜品经典，红豆粥、红豆薏米水，甜蜜养生两不误。</p>', 0, 1, 6, 13.99, 17.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (18007, 51, '黑米', '/uploads/2026/08/黑米_20260813160736.webp', NULL, '<p>黑米颗粒乌黑油亮，米香浓郁，富含花青素，营养丰富。</p><p>黑米粥浓稠滋补，黑米糕、黑米豆浆，粗粮细吃更健康。</p>', 0, 1, 7, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (18008, 51, '燕麦', '', NULL, '<p>燕麦颗粒饱满，麦香浓郁，膳食纤维丰富，饱腹感强。</p><p>燕麦牛奶早餐标配，燕麦粥、燕麦饼干，健康减脂好主食。</p>', 0, 1, 8, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (18009, 51, '玉米碴', '', NULL, '<p>玉米碴金黄粗粝，煮粥绵香，粗粮纤维丰富。</p><p>玉米碴粥配咸菜，东北大碴子粥经典，粗粮健康之选。</p>', 0, 1, 9, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (19001, 52, '小麦粉', '/uploads/2026/08/小麦粉_20260813154721.jpg', NULL, '<p>小麦粉筋度高，洁白细腻，麦香浓郁，做面食弹性好。</p><p>高筋面粉馒头包子饺子，面条筋道不破皮，面食爱好者首选。</p>', 0, 1, 1, 18.99, 42.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (19002, 52, '挂面', '/uploads/2026/08/挂面_20260813154825.webp', NULL, '<p>挂面细滑筋道，煮后不易糊，麦香浓郁，快手主食。</p><p>鸡蛋挂面汤、葱油拌面、西红柿鸡蛋面，几分钟一碗热乎面。</p>', 0, 1, 2, 6.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (19003, 52, '面粉', '/uploads/2026/08/面粉_20260813160658.jpg', NULL, '<p>面粉洁白细腻，吸水性强，麦香自然，家用全能粉。</p><p>包子馒头饺子面条全能，烙饼、炸油条，家常面食一袋搞定。</p>', 0, 1, 3, 19.99, 44.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (19004, 52, '饺子皮', '', NULL, '<p>饺子皮筋道弹牙，薄厚均匀，不易破皮，包饺子省心。</p><p>现压饺子皮更耐煮。猪肉白菜饺、韭菜鸡蛋饺，皮薄馅大才好吃。</p>', 0, 1, 4, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (20001, 53, '菜籽油', '/uploads/2026/08/菜籽油_20260813154640.webp', '[\"https://cdn.example.com/spu/20001_1.jpg\", \"https://cdn.example.com/spu/20001_2.jpg\"]', '<p>菜籽油物理压榨，保留菜籽天然营养，油色金黄，香味浓郁。</p><p>烟点高，适合爆炒、油炸、凉拌。非转基因，无添加抗氧化剂。</p>', 0, 1, 1, 29.99, 89.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (20002, 53, '花生油', '/uploads/2026/08/花生油_20260813154817.webp', NULL, '<p>花生油金黄透亮，花生香气浓郁，煎炒炸都香。</p><p>物理压榨更纯正。炒菜提香，煎炸上色好，家常烹饪首选。</p>', 0, 1, 2, 32.99, 99.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (20003, 53, '大豆油', '/uploads/2026/08/大豆油_20260813154935.jpg', NULL, '<p>大豆油色泽清亮，油烟少，口感清爽，营养均衡。</p><p>精炼一级大豆油。炒菜煎炸皆宜，清淡不抢味，日常烹饪百搭。</p>', 1, 1, 3, 26.99, 82.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (20004, 53, '葵花籽油', '', NULL, '<p>葵花籽油色泽浅黄，口感清淡，富含维生素E，油烟少。</p><p>轻脂健康之选。凉拌、清炒、煎蛋，清淡不油腻，厨房好帮手。</p>', 0, 1, 4, 30.99, 94.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (20005, 53, '玉米油', '', NULL, '<p>玉米油清透轻盈，烟点高，口感清爽，适合煎炸。</p><p>非转基因玉米压榨。炒菜煎炸不油腻，健康烹饪好选择。</p>', 0, 1, 5, 28.99, 90.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (20006, 53, '橄榄油', '', NULL, '<p>橄榄油金黄透亮，果香清新，单不饱和脂肪酸丰富，健康之选。</p><p>特级初榨品质。凉拌沙拉、蘸面包、低温煎炒，地中海式健康饮食。</p>', 0, 1, 6, 52.99, 159.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (21001, 54, '食盐', '/uploads/2026/08/食盐_20260813154549.jpg', NULL, '<p>食盐颗粒细腻，咸味纯正，碘元素补充，日常必备。</p><p>加碘食用盐，家庭烹饪基础调味，炒菜煲汤样样离不开。</p>', 0, 1, 1, 3.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (21002, 54, '白糖', '/uploads/2026/08/白糖_20260813154809.jpg', NULL, '<p>白糖颗粒晶莹，甜味纯正，溶解快，烹饪百搭。</p><p>炒菜提鲜、红烧上色、甜品烘焙，厨房必备基础甜味。</p>', 0, 1, 2, 6.99, 36.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (21003, 54, '酱油', '/uploads/2026/08/酱油_20260813154915.webp', NULL, '<p>酱油酱香浓郁，咸鲜适口，色泽红亮，提鲜上色。</p><p>生抽提鲜、老抽上色。红烧肉、炒菜、蘸料，中餐灵魂调味。</p>', 0, 1, 3, 12.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (21004, 54, '醋', '/uploads/2026/08/醋_20260813160717.jpg', NULL, '<p>醋香浓郁，酸味柔和，开胃解腻，去腥提香。</p><p>凉拌菜点睛，糖醋排骨、醋溜白菜，吃饺子蘸醋，酸香开胃。</p>', 0, 1, 4, 9.99, 20.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (21005, 54, '鸡精', '/uploads/2026/08/鸡精_20260813160855.webp', NULL, '<p>鸡精颗粒鲜香，提鲜增味，炒菜煲汤一勺搞定。</p><p>鲜味浓郁自然。炒菜、炖汤、煮面撒一点，鲜味瞬间提升。</p>', 0, 1, 5, 8.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (21006, 54, '花椒', '', NULL, '<p>花椒颗粒饱满，麻香浓郁，麻味纯正，川菜灵魂。</p><p>麻婆豆腐、水煮鱼、椒麻鸡，热油泼香，麻辣鲜香一锅端。</p>', 0, 1, 6, 12.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 1);
INSERT INTO `goods_spu` VALUES (21007, 54, '八角', '/uploads/2026/08/八角_20260813160752.jpg', NULL, '<p>八角瓣大饱满，香气浓郁，炖肉卤味必备香料。</p><p>红烧肉、卤牛肉、炖排骨，放两粒香气四溢，去腥增香。</p>', 0, 1, 7, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (21008, 54, '桂皮', '/uploads/2026/08/桂皮_20260813160808.jpg', NULL, '<p>桂皮卷紧厚实，甜香浓郁，炖肉卤味提香去腥。</p><p>红烧肉、卤味、茶叶蛋必备，与八角花椒是黄金搭档。</p>', 0, 1, 8, 14.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (22001, 61, '嫩豆腐', '/uploads/2026/08/嫩豆腐_20260813155008.jpg', NULL, '<p>豆腐鲜嫩细腻，豆香浓郁，入口即化，优质蛋白来源。</p><p>当日现做发货。麻婆豆腐、鲫鱼豆腐汤、香煎豆腐，家常百搭。</p>', 0, 1, 1, 4.99, 6.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (22002, 61, '老豆腐', '/uploads/2026/08/老豆腐_20260813155103.jpg', NULL, '<p>嫩豆腐滑嫩如脂，口感细腻，入口即化，豆香清甜。</p><p>皮蛋豆腐、虾仁蒸豆腐、豆腐脑，清淡鲜美，老幼皆宜。</p>', 0, 1, 2, 4.49, 5.99, '2026-08-09 00:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (22003, 61, '内酯豆腐', '/uploads/2026/08/内酯豆腐_20260813155148.jpg', NULL, '<p>老豆腐质地紧实，久煮不碎，豆香醇厚，越煮越入味。</p><p>冻豆腐炖菜吸汁，香煎豆腐外焦里嫩，家常豆腐经典做法。</p>', 0, 1, 3, 5.49, 6.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (22004, 61, '豆浆', '/uploads/2026/08/豆浆_20260813155224.webp', NULL, '<p>内酯豆腐极嫩滑，细腻如蛋羹，口感轻盈，豆香淡雅。</p><p>凉拌内酯豆腐、皮蛋豆腐、豆腐羹，清淡爽口，夏日开胃。</p>', 0, 1, 4, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (22005, 61, '豆腐脑', '/uploads/2026/08/豆腐脑_20260813155256.webp', NULL, '<p>豆腐皮薄如纸，豆香浓郁，口感柔韧，营养丰富。</p><p>凉拌豆腐皮爽口，炒青椒、涮火锅，素食高蛋白之选。</p>', 0, 1, 5, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (23001, 62, '豆腐干', '/uploads/2026/08/豆干_20260813155001.jpg', NULL, '<p>豆干紧实弹牙，豆香浓郁，卤香入味，越嚼越香。</p><p>凉拌豆干、青椒炒豆干、卤豆干，下酒下饭两相宜。</p>', 0, 1, 1, 7.99, 9.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (23002, 62, '腐竹', '/uploads/2026/08/腐竹_20260813155038.webp', NULL, '<p>千张薄而有韧性，豆香浓郁，口感筋道，越煮越入味。</p><p>千张结烧肉、凉拌千张丝、千张卷金针菇，家常美味。</p>', 0, 1, 2, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (23003, 62, '千张', '/uploads/2026/08/千张_20260813155125.jpeg', NULL, '<p>腐竹金黄透亮，豆香浓郁，泡发后柔韧爽滑，营养丰富。</p><p>凉拌腐竹爽口，腐竹焖鸭、腐竹鸡蛋汤，素食黄金搭档。</p>', 0, 1, 3, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (23004, 62, '豆腐皮', '/uploads/2026/08/豆腐皮_20260813155205.webp', NULL, '<p>豆腐泡金黄鼓胀，内部蜂窝多孔，吸汁能力一流。</p><p>关东煮灵魂、卤豆腐泡、炖菜吸汁，一口爆汁，豆香十足。</p>', 0, 1, 4, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (23005, 62, '豆芽', '/uploads/2026/08/豆芽_20260813155240.jpg', NULL, '<p>豆腐丝细如发丝，口感爽滑，豆香清纯，凉拌最佳。</p><p>凉拌豆腐丝、豆腐丝炒肉丝、卷饼配菜，清爽开胃，快手小菜。</p>', 0, 1, 5, 4.99, 6.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu` VALUES (23006, 11, '空心菜', '/uploads/2026/08/空心菜_20260809145519.jpg', NULL, NULL, 0, 1, 5, 2.00, 4.00, '2026-08-09 14:55:46', '2026-08-09 14:55:46', 0);

-- ----------------------------
-- Table structure for goods_spu_bak_0813
-- ----------------------------
DROP TABLE IF EXISTS `goods_spu_bak_0813`;
CREATE TABLE `goods_spu_bak_0813`  (
  `id` bigint unsigned NOT NULL COMMENT 'SPU ID',
  `category_id` bigint unsigned NOT NULL COMMENT '分类ID(二级分类)',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
  `main_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主图URL',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '轮播图URL数组(JSON字符串)',
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情图文(纯文本/富文本)',
  `sales` int(0) NOT NULL DEFAULT 0 COMMENT '销量(已完成订单累计)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '上下架:0-下架 1-上架',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序值',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '现价(展示用,保存时自动取SKU最低价)',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价(划线价,展示用)',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_spu_bak_0813
-- ----------------------------
INSERT INTO `goods_spu_bak_0813` VALUES (1001, 11, '本地奶白菜', '/uploads/2026/08/本地奶白菜_20260813154317.jpg', '[\"https://cdn.example.com/spu/1001_1.jpg\", \"https://cdn.example.com/spu/1001_2.jpg\"]', '<p>本地奶白菜，叶片肥厚鲜嫩，口感清甜，富含维生素C和膳食纤维。</p><p>产地直采，当日采摘当日发货，保证新鲜度。建议烹饪前用淡盐水浸泡10分钟。</p>', 0, 1, 1, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1002, 11, '有机上海青', '/uploads/2026/08/有机上海青_20260813160308.jpeg', '[\"https://cdn.example.com/spu/1002_1.jpg\", \"https://cdn.example.com/spu/1002_2.jpg\"]', '<p>有机认证上海青，无农残无激素，叶绿茎白，清脆可口。</p><p>适合炒食、煮汤、涮火锅，烹饪时间短，营养流失少。</p>', 0, 1, 2, 3.29, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1003, 11, '高山娃娃菜', '/uploads/2026/08/高山娃娃菜_20260813160411.jpg', NULL, '<p>高山娃娃菜帮薄叶嫩，口感清甜爽脆，富含维生素和膳食纤维。</p><p>高海拔冷凉气候种植，虫害少，当日采摘当日发货。适合清炒、上汤、火锅涮煮。</p>', 0, 1, 3, 4.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1004, 11, '大叶菠菜', '', NULL, '<p>大叶菠菜叶片肥厚，色泽深绿，富含铁元素和叶酸，口感柔嫩微甜。</p><p>产地直采，带根发货更新鲜。建议焯水后凉拌或清炒，去除草酸更营养。</p>', 0, 1, 4, 3.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1005, 11, '生菜', '/uploads/2026/08/生菜_20260813160513.webp', NULL, '<p>生菜叶片脆嫩多汁，口感清甜爽口，低热量高纤维。</p><p>奶油生菜品种，层层包心紧实。适合沙拉、汉堡、烤肉伴侣，洗净即食。</p>', 0, 1, 5, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1006, 11, '油麦菜', '', NULL, '<p>油麦菜茎秆脆嫩，叶片翠绿，口感清香微甜，富含维生素和钙质。</p><p>当日采摘，水分充足不发蔫。蒜蓉清炒、涮火锅、蚝油淋汁都美味。</p>', 0, 1, 6, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1007, 11, '小香芹', '', NULL, '<p>小香芹香气浓郁，茎秆细嫩，富含挥发性芳香物质和多种维生素。</p><p>根茎连体采收，鲜度持久。炒肉、包饺子、凉拌提香，西芹平替之选。</p>', 0, 1, 7, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1008, 11, '韭菜', '', NULL, '<p>韭菜叶片宽厚，辛香浓郁，富含硫化物和膳食纤维，有助开胃。</p><p>头茬韭菜更鲜嫩。韭菜盒子、炒鸡蛋、烤韭菜经典吃法，现买现吃风味最佳。</p>', 0, 1, 8, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1009, 11, '空心菜', '/uploads/2026/08/空心菜_20260809145619.jpg', NULL, '<p>空心菜茎秆脆嫩，叶片碧绿，口感清爽，富含维生素C和叶绿素。</p><p>夏秋应季蔬菜，当日采摘。蒜蓉爆炒、清炒虾酱是粤式经典，焯水凉拌亦可。</p>', 0, 1, 9, 2.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1010, 11, '大白菜', '', NULL, '<p>大白菜菜帮脆甜，菜心鲜嫩，含水量高，清甜爽口。</p><p>冬储菜之王，耐储存。炖粉条、醋溜白菜、腌酸菜、涮火锅百搭首选。</p>', 0, 1, 10, 3.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1011, 11, '卷心菜', '', NULL, '<p>卷心菜球体紧实，叶片脆嫩，口感清甜，富含维生素K和抗氧化物。</p><p>春季应季，切丝手撕皆宜。手撕包菜、炒粉条、沙拉、泡菜全能选手。</p>', 0, 1, 11, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1012, 11, '西兰花', '', NULL, '<p>西兰花花球紧实翠绿，口感爽脆，被称为蔬菜皇冠，营养密度极高。</p><p>低温冷链保鲜发货。白灼、蒜蓉、清炒，焯水1分钟口感最佳，营养保留最多。</p>', 0, 1, 12, 1.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1013, 11, '紫甘蓝', '', NULL, '<p>紫甘蓝色泽紫红艳丽，口感爽脆微甜，富含花青素和维生素。</p><p>凉拌沙拉首选，腌制后色泽更艳。切丝越细口感越好，搭配柠檬汁更清脆。</p>', 0, 1, 13, 1.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1014, 11, '快菜', '', NULL, '<p>快菜生长周期短，叶片柔嫩，口感清甜，是小白菜的优选品种。</p><p>当季现采，嫩度极佳。煮面、清炒、做汤快手菜必备，几分钟就能上桌。</p>', 0, 1, 14, 1.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1015, 11, '芥兰', '', NULL, '<p>芥兰茎秆脆嫩，叶片翠绿，口感清甜带微苦，富含钙和维生素C。</p><p>广式经典绿叶菜。白灼芥兰、蚝油芥兰，大火快炒锁住爽脆。</p>', 0, 1, 15, 2.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1016, 11, '奶白菜苗', '', NULL, '<p>奶白菜苗鲜嫩无比，叶片柔软，口感清甜，富含维生素和叶酸。</p><p>幼苗期采摘，纤维少更嫩口。清炒、煮汤、涮火锅，焯水即食最鲜甜。</p>', 0, 1, 16, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1017, 11, '菜心', '', NULL, '<p>菜心茎嫩叶绿，花蕾初开，口感清甜爽脆，是岭南名菜之魂。</p><p>当季现摘，鲜度满分。白灼菜心淋豉油，粤菜馆同款，简单又高级。</p>', 0, 1, 17, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1018, 11, '茼蒿', '', NULL, '<p>茼蒿自带独特香气，叶片柔嫩，口感清爽，富含挥发性精油和维生素。</p><p>有菊花香气辨识度高。涮火锅、清炒、蒸茼蒿麦饭，秋冬滋补好选择。</p>', 0, 1, 18, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1019, 11, '苋菜', '', NULL, '<p>苋菜叶片红绿相间，口感滑嫩，富含铁和钙，有红苋菜之称。</p><p>炒出来的红汤汁拌饭是经典吃法。蒜蓉爆炒、上汤苋菜，营养又下饭。</p>', 0, 1, 19, 4.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1020, 11, '小白菜', '', NULL, '<p>小白菜叶片翠绿柔嫩，菜帮清甜，富含维生素和矿物质，清淡可口。</p><p>当日现摘，鲜嫩多汁。清炒、煮汤、烫火锅，家常餐桌高频绿叶菜。</p>', 0, 1, 20, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1021, 11, '黄心菜', '', NULL, '<p>黄心菜菜心金黄鲜嫩，叶片肥厚，口感清甜，冬季时令佳品。</p><p>低温环境生长更甜。霜打后的黄心菜格外清甜，清炒或炖肉皆宜。</p>', 0, 1, 21, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1022, 11, '苦菊', '', NULL, '<p>苦菊叶形优美，口感微苦回甘，清脆爽口，富含维生素和膳食纤维。</p><p>轻食沙拉首选，搭配油醋汁口感绝佳。凉拌去火，夏季开胃好食材。</p>', 0, 1, 22, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1023, 11, '上海青', '', NULL, '<p>有机上海青叶绿茎白，清脆可口，无农残无激素，健康安心。</p><p>有机认证基地直供。清炒、煮面、涮火锅，简单烹饪还原自然清甜。</p>', 0, 1, 23, 2.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1024, 11, '娃娃菜', '/uploads/2026/08/娃娃菜_20260813160422.webp', NULL, '<p>娃娃菜小巧精致，菜心鲜嫩，口感清甜，一人食分量刚刚好。</p><p>外叶包裹紧实，保鲜度高。上汤娃娃菜、蒜蓉粉丝蒸、涮火锅经典搭配。</p>', 0, 1, 24, 1.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1025, 11, '芹菜', '', NULL, '<p>芹菜茎秆粗壮脆嫩，香气浓郁，富含膳食纤维和芹菜素。</p><p>本芹炒菜香，西芹拌菜脆。芹菜炒香干、芹菜炒肉丝、榨芹菜汁皆宜。</p>', 0, 1, 25, 2.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1026, 11, '大葱', '', NULL, '<p>大葱葱白长且粗壮，辛辣味足，是做菜提香的核心佐料。</p><p>章丘大葱品质优良。爆锅炝香、京酱肉丝配菜、葱爆羊肉的灵魂伴侣。</p>', 0, 1, 26, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1027, 11, '香菜', '', NULL, '<p>香菜叶片翠绿，香气浓烈，富含维生素C，是提味增香的点睛之笔。</p><p>当日采摘带根发货，保鲜持久。凉拌、涮锅、煲汤最后撒一把，香气四溢。</p>', 0, 1, 27, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1028, 11, '金丝白', '', NULL, '<p>金丝白叶片金黄带光泽，菜帮薄嫩，口感清甜，颜值与美味并存。</p><p>黄心白菜品种，纤维少甜度高。清炒、炖汤、涮火锅，颜色喜庆寓意好。</p>', 0, 1, 28, 3.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1029, 11, '毛白菜', '', NULL, '<p>毛白菜叶片鲜嫩，菜帮微脆，口感清甜带青草香，家常味道。</p><p>现摘现发，水分足。猪油渣炒毛白菜是地道家常菜，简单快手。</p>', 0, 1, 29, 4.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1030, 11, '广东菜心', '', NULL, '<p>广东菜心茎秆爽脆，叶片翠绿，花蕾鲜嫩，清甜无渣。</p><p>广式茶餐厅同款。白灼淋热油豉油，锅气十足，简单烹饪就很鲜美。</p>', 0, 1, 30, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (1031, 11, '有机菠菜', '/uploads/2026/08/有机菠菜_20260813160325.webp', NULL, '<p>有机菠菜叶片厚实，根红叶绿，富含铁质和多种维生素，营养标杆。</p><p>有机认证，全程无化学农药。焯水凉拌、蒜蓉清炒、煮猪肝汤滋补又美味。</p>', 0, 1, 31, 3.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2001, 12, '黄瓜', '/uploads/2026/08/黄瓜_20260813154307.jpg', NULL, '<p>黄瓜顶花带刺，清脆多汁，口感爽利，低热量高水分。</p><p>产地直采，脆嫩无苦味。凉拌拍黄瓜、黄瓜炒蛋、蘸酱生吃，夏日解腻必备。</p>', 0, 1, 1, 7.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2002, 12, '西红柿', '/uploads/2026/08/西红柿_20260813160224.jpg', '[\"https://cdn.example.com/spu/2002_1.jpg\", \"https://cdn.example.com/spu/2002_2.jpg\"]', '<p>西红柿果形饱满，色泽红润，沙瓤多汁，酸甜适口，番茄红素丰富。</p><p>自然熟采摘，果香浓郁。西红柿炒蛋、西红柿牛腩汤、凉拌西红柿，家常经典。</p>', 0, 1, 2, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2003, 12, '青椒', '', NULL, '<p>青椒果肉厚实，微辣清甜，富含维生素C，是蔬菜中的维C之王。</p><p>现摘现发，光泽饱满。虎皮青椒、青椒肉丝、青椒炒蛋，家常下饭利器。</p>', 0, 1, 3, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2004, 12, '茄子', '', NULL, '<p>茄子紫亮饱满，肉质细嫩，口感绵软吸汁，富含花青素。</p><p>长茄炒食，圆茄红烧。鱼香茄子、蒜蓉烤茄子、红烧茄子，米饭杀手。</p>', 0, 1, 4, 5.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2005, 12, '丝瓜', '', NULL, '<p>丝瓜翠绿鲜嫩，口感滑嫩清甜，富含黏液蛋白和维生素。</p><p>夏秋季应季蔬菜。丝瓜炒蛋、丝瓜汤、蒜蓉粉丝蒸丝瓜，清淡又滋补。</p>', 0, 1, 5, 5.49, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2006, 12, '苦瓜', '', NULL, '<p>苦瓜纹理分明，清脆微苦回甘，富含苦瓜苷和维生素C，清热降火。</p><p>苦瓜炒蛋、苦瓜酿肉、凉拌苦瓜经典做法。怕苦可先用盐腌去涩。</p>', 0, 1, 6, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2007, 12, '冬瓜', '', NULL, '<p>冬瓜瓜肉洁白厚实，口感清润，热量极低，适合控脂人群。</p><p>冬瓜排骨汤、红烧冬瓜、冬瓜丸子汤，清爽解腻，老幼皆宜。</p>', 0, 1, 7, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2008, 12, '南瓜', '', NULL, '<p>南瓜金黄绵密，口感香甜软糯，富含胡萝卜素和膳食纤维。</p><p>贝贝南瓜更粉糯。蒸南瓜、南瓜粥、南瓜饼，早餐加餐两相宜。</p>', 0, 1, 8, 4.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2009, 12, '西葫芦', '', NULL, '<p>西葫芦皮薄肉嫩，口感清甜爽脆，水分足热量低。</p><p>西葫芦炒蛋、西葫芦糊塌子、凉拌西葫芦丝，快手家常菜好选择。</p>', 0, 1, 9, 79.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2010, 12, '杭椒', '', NULL, '<p>杭椒细长微辣，香气浓郁，口感脆嫩，是湘菜馆的灵魂配料。</p><p>杭椒牛柳、杭椒炒蛋、小炒肉，辣度适中，开胃下饭。</p>', 0, 1, 10, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2011, 12, '豆角', '', NULL, '<p>豆角翠绿饱满，肉质厚实，口感清甜，富含蛋白质和膳食纤维。</p><p>干煸豆角、豆角焖面、豆角炖土豆，一定要炒熟煮透再食用。</p>', 0, 1, 11, 5.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2012, 12, '长豆角', '', NULL, '<p>长豆角细长嫩脆，口感清甜，纤维少，越嫩越好吃。</p><p>手撕豆角、豇豆炒肉、酸豆角腌制，夏日开胃菜首选。</p>', 0, 1, 12, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2013, 12, '毛豆', '', NULL, '<p>毛豆翠绿饱满，豆香浓郁，口感清甜粉糯，蛋白质含量高。</p><p>水煮毛豆配啤酒是夏日经典。毛豆炒肉、毛豆炖鸡，鲜香下饭。</p>', 0, 1, 13, 15.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2014, 12, '玉米', '', NULL, '<p>玉米颗粒饱满，甜糯适口，富含膳食纤维和多种维生素。</p><p>水果玉米清甜爆汁，蒸煮烤皆可。玉米排骨汤、玉米烙，家常好味。</p>', 0, 1, 14, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2015, 12, '彩椒', '', NULL, '<p>彩椒色泽鲜艳，果肉厚实脆甜，不辣，富含维生素C和花青素。</p><p>红黄绿三色齐配，是摆盘颜值担当。彩椒炒肉、彩椒鸡丁、烤箱烤彩椒。</p>', 0, 1, 15, 6.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2016, 12, '西芹', '', NULL, '<p>西芹茎秆粗壮厚实，口感脆嫩，香气清淡，纤维感十足。</p><p>西芹炒百合、西芹拌腰果、西芹榨汁，清脆爽口，健康轻食。</p>', 0, 1, 16, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2017, 12, '香芹', '', NULL, '<p>香芹茎秆细嫩，香气浓郁，比西芹更香更嫩。</p><p>芹菜炒香干、芹菜馅饺子、芹菜粥，去腥增香好帮手。</p>', 0, 1, 17, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (2018, 12, '蒜苔', '', NULL, '<p>蒜苔脆嫩碧绿，蒜香浓郁，口感爽脆，富含大蒜素。</p><p>蒜苔炒肉丝、蒜苔炒鸡蛋、腌蒜苔，春天里的时令好味。</p>', 0, 1, 18, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3001, 13, '土豆', '/uploads/2026/08/土豆_20260813154300.jpg', NULL, '<p>土豆沙瓤粉糯，口感绵密，是餐桌上的百搭之王。</p><p>黄心土豆炖煮更糯。酸辣土豆丝、土豆炖牛腩、椒盐薯条，怎么做都好吃。</p>', 0, 1, 1, 15.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3002, 13, '胡萝卜', '/uploads/2026/08/胡萝卜_20260813154436.jpg', NULL, '<p>胡萝卜色泽橙红，口感清甜脆嫩，富含胡萝卜素，护眼又营养。</p><p>胡萝卜炒肉、胡萝卜炖排骨、榨胡萝卜汁，生熟皆宜营养丰富。</p>', 0, 1, 2, 16.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3003, 13, '白萝卜', '', NULL, '<p>白萝卜水分充足，口感脆嫩微辛，清热润燥，冬季养生首选。</p><p>萝卜炖羊肉、萝卜丝饼、腌萝卜皮，去腻解馋样样行。</p>', 0, 1, 3, 22.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3004, 13, '红薯', '', NULL, '<p>红薯香甜软糯，蜜心流油，富含膳食纤维和多种矿物质。</p><p>烤红薯满屋飘香，蒸红薯软糯清甜，红薯粥养胃，冬日暖身好物。</p>', 0, 1, 4, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3005, 13, '山药', '', NULL, '<p>山药质地细腻，口感粉糯，黏液蛋白丰富，健脾养胃。</p><p>铁棍山药药食同源。山药炖排骨、蓝莓山药泥、山药粥，滋补日常。</p>', 0, 1, 5, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3006, 13, '莲藕', '', NULL, '<p>莲藕洁白脆嫩，生吃清甜，熟吃粉糯，富含黏液蛋白和膳食纤维。</p><p>凉拌藕片爽脆，莲藕排骨汤鲜甜，藕盒炸制香酥，一藕多吃。</p>', 0, 1, 6, 21.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3007, 13, '洋葱', '', NULL, '<p>洋葱紫皮紧实，辛辣味足，富含槲皮素，切丁爆香是灵魂调味。</p><p>洋葱炒牛肉、洋葱圈炸制、洋葱拌木耳，生吃降脂，熟吃甜香。</p>', 0, 1, 7, 24.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3008, 13, '姜', '', NULL, '<p>生姜辛辣浓郁，姜香十足，去腥暖胃，厨房必备调味。</p><p>炒菜炝锅、炖肉去腥、姜汤驱寒。老姜味足，嫩姜泡醋更爽脆。</p>', 0, 1, 8, 29.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3009, 13, '蒜', '', NULL, '<p>大蒜蒜瓣饱满，蒜香浓郁，杀菌提味，是中华美食的灵魂。</p><p>蒜蓉爆炒、糖蒜腌制、腊八蒜变绿更开胃。家常炒菜炝锅必备。</p>', 0, 1, 9, 26.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3010, 13, '芋头', '', NULL, '<p>芋头粉糯细腻，口感绵密，自带淡淡芋香，饱腹感强。</p><p>香芋蒸排骨、芋头扣肉、糖芋苗，秋冬滋补，粉糯香甜。</p>', 0, 1, 10, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3011, 13, '紫薯', '', NULL, '<p>紫薯色泽深紫，口感香甜粉糯，富含花青素和膳食纤维。</p><p>蒸紫薯软糯，紫薯粥香甜，紫薯银耳羹颜值高，减脂人群好主食。</p>', 0, 1, 11, 8.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3012, 13, '红薯粉条', '', NULL, '<p>红薯粉条久煮不烂，口感劲道爽滑，吸汁入味。</p><p>猪肉炖粉条东北名菜，酸辣粉快手解馋，涮火锅必点主食。</p>', 0, 1, 12, 29.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3013, 13, '莴笋', '', NULL, '<p>莴笋茎秆翠绿脆嫩，口感清爽，富含钾元素和膳食纤维。</p><p>凉拌莴笋丝爽脆，莴笋炒肉片、莴笋炖汤，清脆解腻好食材。</p>', 0, 1, 13, 25.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3014, 13, '蒜黄', '', NULL, '<p>蒜黄金黄鲜嫩，蒜香浓郁，口感柔嫩，是冬春时令菜。</p><p>蒜黄炒鸡蛋、蒜黄炒肉丝、蒜黄馅饺子，香气扑鼻，鲜嫩多汁。</p>', 0, 1, 14, 8.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (3015, 13, '生姜', '', NULL, '<p>生姜辛香浓郁，肉质饱满，姜汁充足，品质上乘。</p><p>去腥增香，煲汤炖肉好伴侣。泡姜更开胃，感冒姜汤暖身必备。</p>', 0, 1, 15, 11.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4001, 14, '香菇', '/uploads/2026/08/香菇_20260813154254.jpeg', NULL, '<p>香菇伞盖厚实，菇香浓郁，肉质肥美，被称为山珍之王。</p><p>干鲜两种吃法都香。香菇炖鸡、香菇油菜、蚝油香菇，提鲜一绝。</p>', 0, 1, 1, 27.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4002, 14, '平菇', '/uploads/2026/08/平菇_20260813154501.webp', NULL, '<p>平菇叶片肥厚，口感滑嫩，鲜味足，蛋白质含量高。</p><p>平菇炒肉、平菇蛋汤、椒盐平菇，家常实惠，老少皆宜。</p>', 0, 1, 2, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4003, 14, '金针菇', '', NULL, '<p>金针菇菌柄细长脆嫩，口感爽滑，富含氨基酸和膳食纤维。</p><p>火锅必点，烧烤伴侣。金针菇肥牛卷、凉拌金针菇，爽口开胃。</p>', 0, 1, 3, 16.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4004, 14, '杏鲍菇', '', NULL, '<p>杏鲍菇肉质厚实肥美，口感似鲍鱼，菌香浓郁，嚼劲十足。</p><p>手撕杏鲍菇凉拌，蚝油杏鲍菇、椒盐杏鲍菇，素食也能吃出肉味。</p>', 0, 1, 4, 12.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4005, 14, '白玉菇', '', NULL, '<p>白玉菇洁白如玉，菌盖圆润，口感清甜爽滑，营养丰富。</p><p>白玉菇炒蛋、菌菇汤、涮火锅，清淡鲜美，颜值担当。</p>', 0, 1, 5, 24.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4006, 14, '海鲜菇', '', NULL, '<p>海鲜菇自带海鲜般鲜甜，口感脆嫩，菇香淡雅。</p><p>海鲜菇蛋花汤、海鲜菇炒肉、菌菇煲，鲜味十足，素食提鲜神器。</p>', 0, 1, 6, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4007, 14, '蟹味菇', '', NULL, '<p>蟹味菇有淡淡蟹香，口感爽滑，鲜味独特，颜值高。</p><p>蟹味菇炒蛋、菌菇蒸蛋羹、涮火锅，鲜美滑嫩，孩子也爱吃。</p>', 0, 1, 7, 39.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4008, 14, '茶树菇', '', NULL, '<p>茶树菇菌柄脆嫩，菇香浓郁，自带独特香气，煲汤一绝。</p><p>茶树菇老鸭汤、茶树菇炒腊肉、干锅茶树菇，越嚼越香。</p>', 0, 1, 8, 16.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4009, 14, '口蘑', '', NULL, '<p>口蘑菌盖圆润厚实，口感鲜嫩弹滑，自带鲜美汤汁。</p><p>煎口蘑原汁原味，口蘑炒肉、奶油口蘑汤，西餐中餐皆宜。</p>', 0, 1, 9, 9.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (4010, 14, '黑木耳', '', NULL, '<p>黑木耳肉厚耳脆，口感爽滑弹牙，富含胶质和铁元素。</p><p>凉拌木耳开胃，木耳炒肉、木耳鸡汤。泡发后焯水再烹饪更安心。</p>', 0, 1, 10, 19.99, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5001, 15, '生姜', '/uploads/2026/08/生姜_20260813154244.jpg', NULL, '<p>生姜辛香浓郁，姜汁充足，去腥暖胃，厨房调味必备。</p><p>炝锅提香、炖肉去腥、姜汤驱寒。嫩姜炒菜，老姜煲汤更出味。</p>', 0, 1, 1, 36.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5002, 15, '大蒜', '/uploads/2026/08/大蒜_20260813154430.jpg', NULL, '<p>大蒜蒜瓣饱满紧实，蒜香浓郁，杀菌提味两不误。</p><p>蒜蓉爆香、糖蒜泡制、腊八蒜，家家户户离不开的调味主角。</p>', 0, 1, 2, 39.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5003, 15, '小葱', '', NULL, '<p>小葱翠绿鲜嫩，葱香清雅，是出锅前的点睛之笔。</p><p>葱花炒蛋、葱油拌面、小葱蘸酱，提味增香，清新爽口。</p>', 0, 1, 3, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5004, 15, '蒜苗', '', NULL, '<p>蒜苗翠绿挺拔，蒜香浓郁带清甜，口感脆嫩。</p><p>蒜苗炒腊肉经典下饭，蒜苗回锅肉、蒜苗炒鸡蛋，香气四溢。</p>', 0, 1, 4, 6.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5005, 15, '蒜黄', '', NULL, '<p>蒜黄金黄柔嫩，蒜香浓而不冲，口感软嫩清甜。</p><p>蒜黄炒鸡蛋、蒜黄肉丝、蒜黄饺子，冬春时令鲜美之选。</p>', 0, 1, 5, 12.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5006, 15, '洋葱', '', NULL, '<p>洋葱紫皮紧实，辛辣微甜，切丁爆香香气扑鼻。</p><p>洋葱炒蛋、洋葱牛柳、凉拌洋葱，生熟皆宜，家常必备。</p>', 0, 1, 6, 7.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5007, 15, '小香葱', '', NULL, '<p>小香葱根细叶翠，香气浓郁清甜，比大葱更细腻。</p><p>撒葱花提香，葱油拌面，小香葱煎蛋，简单食材做出好味道。</p>', 0, 1, 7, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5008, 15, '小蒜头', '', NULL, '<p>小蒜头颗粒饱满，蒜香纯正，腌制后酸甜开胃。</p><p>糖蒜、醋蒜经典腌法，吃面配蒜，烤肉伴侣，生吃杀菌。</p>', 0, 1, 8, 89.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5009, 15, '香菜', '', NULL, '<p>香菜叶片翠绿，香气浓烈，富含维生素，增香去腥。</p><p>凉拌香菜、牛肉面灵魂配菜、涮火锅蘸料必备，撒一把就够香。</p>', 0, 1, 9, 69.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5010, 15, '小葱苗', '', NULL, '<p>小葱苗鲜嫩水灵，葱香清甜，比大葱更柔和。</p><p>蘸酱生吃、炒鸡蛋、做葱油，春天气息满满，鲜嫩无比。</p>', 0, 1, 10, 49.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5011, 15, '大葱', '', NULL, '<p>大葱葱白粗长，辛辣味足，是北方菜的调味基石。</p><p>葱爆羊肉、京酱肉丝、炝锅炒菜，大葱蘸酱更是豪迈吃法。</p>', 0, 1, 11, 19.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5012, 15, '姜', '', NULL, '<p>生姜肉质饱满，辛辣浓郁，姜香十足，品质新鲜。</p><p>煲汤炖肉去腥，炒菜炝锅，红糖姜茶暖身，居家必备。</p>', 0, 1, 12, 15.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5013, 15, '蒜', '', NULL, '<p>大蒜蒜瓣白净饱满，蒜素含量高，辛辣提味。</p><p>拍蒜爆香、蒜蓉粉丝蒸、腊八蒜，中餐灵魂调味，每餐必备。</p>', 0, 1, 13, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5014, 15, '洋葱头', '', NULL, '<p>洋葱头紧实圆润，层次分明，辛辣中带甜，营养丰富。</p><p>洋葱炒肉、洋葱圈、罗宋汤必备。放冰箱冷藏更耐储存。</p>', 0, 1, 14, 12.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5015, 15, '香葱', '', NULL, '<p>香葱细嫩翠绿，葱香清甜浓郁，出锅撒香是点睛之笔。</p><p>葱油拌面、香葱煎蛋、煲汤提香，葱香四溢，食欲大开。</p>', 0, 1, 15, 6.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (5016, 15, '蒜苗', '', NULL, '<p>蒜苗青翠挺拔，蒜香清甜，口感脆嫩，时令鲜蔬。</p><p>蒜苗炒肉、蒜苗回锅肉、蒜苗炒香干，香气浓郁超下饭。</p>', 0, 1, 16, 3.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (6001, 16, '四季豆', '/uploads/2026/08/四季豆_20260813154223.jpeg', NULL, '<p>四季豆翠绿饱满，口感清甜脆嫩，蛋白质丰富。</p><p>干煸四季豆、四季豆炒肉末、豆角焖面，务必炒熟透再食用。</p>', 0, 1, 1, 3.50, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (6002, 16, '荷兰豆', '/uploads/2026/08/荷兰豆_20260813154510.jpg', NULL, '<p>荷兰豆色泽翠绿，豆荚薄脆，口感清甜爽脆。</p><p>荷兰豆炒腊肠、清炒荷兰豆、蒜蓉荷兰豆，大火快炒锁住脆嫩。</p>', 0, 1, 2, 3.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (6003, 16, '豇豆', '', NULL, '<p>豇豆细长翠绿，肉质厚实，口感清甜，越嫩越好吃。</p><p>手撕豇豆、豇豆炒肉、酸豆角，夏日餐桌人气豆角。</p>', 0, 1, 3, 2.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (6004, 16, '毛豆', '', NULL, '<p>毛豆翠绿饱满，豆香清甜，蛋白质含量高，越嚼越香。</p><p>水煮毛豆配啤酒，毛豆炒肉、毛豆炖汤，夏日鲜香好味。</p>', 0, 1, 4, 5.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (6005, 16, '长豆角', '', NULL, '<p>长豆角嫩绿细长，口感脆嫩清甜，纤维少不塞牙。</p><p>干煸豆角、豇豆肉末、腌酸豆角，怎么做都下饭。</p>', 0, 1, 5, 4.50, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (6006, 16, '芸豆', '', NULL, '<p>芸豆颗粒饱满，豆香浓郁，口感粉糯，蛋白质丰富。</p><p>芸豆炖排骨、蜜芸豆、芸豆米饭，粉糯香甜，营养饱腹。</p>', 0, 1, 6, 9.90, NULL, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7001, 21, '西瓜', '/uploads/2026/08/西瓜_20260813160007.jpg', '[\"https://cdn.example.com/spu/7001_1.jpg\", \"https://cdn.example.com/spu/7001_2.jpg\"]', '<p>西瓜皮薄肉厚，沙瓤多汁，糖度12°+，清甜解渴。</p><p>基地直发，采摘后24小时内发货。收货后建议放置2-3小时再切开，口感更佳。</p>', 0, 1, 1, 12.99, 24.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7002, 21, '哈密瓜', '/uploads/2026/08/哈密瓜_20260813160125.jpg', NULL, '<p>哈密瓜果肉橙黄，香甜多汁，脆嫩爽口，糖度极高。</p><p>新疆产地直发。冰镇后切块，清甜解暑，夏日水果之王。</p>', 0, 1, 2, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7003, 21, '香瓜', '', NULL, '<p>香瓜果香浓郁，肉质绵甜多汁，口感细腻。</p><p>皮薄肉厚，籽少味甜。冰镇食用风味更佳，夏日消暑佳品。</p>', 0, 1, 3, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7004, 21, '甜瓜', '', NULL, '<p>甜瓜白绿相间，清甜爽脆，汁水丰盈，果香清新。</p><p>现摘现发，自然熟。冷藏后口感更佳，清爽解腻，全家爱吃。</p>', 0, 1, 4, 7.99, 9.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7005, 21, '火龙果', '', NULL, '<p>火龙果果肉红艳，清甜多汁，籽粒脆爽，富含花青素和膳食纤维。</p><p>红心火龙果甜度更高。切块即食、榨汁、拌酸奶，颜值与营养并存。</p>', 0, 1, 5, 6.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7006, 21, '百香果', '', NULL, '<p>百香果果香馥郁，酸甜可口，富含维生素C，有果汁之王之称。</p><p>对半切开挖籽冲蜂蜜水，做百香果柠檬茶，果香浓郁超解腻。</p>', 0, 1, 6, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7007, 21, '杨桃', '', NULL, '<p>杨桃果形五棱，晶莹剔透，口感清甜爽脆，水分充足。</p><p>星形切面颜值高。直接切片食用，蘸盐或梅子粉风味更独特。</p>', 0, 1, 7, 18.99, 22.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7008, 21, '桃子', '', NULL, '<p>桃子粉嫩饱满，果肉细腻，香甜多汁，桃香浓郁。</p><p>水蜜桃品种，软硬两吃。硬吃脆甜，放软后汁水爆浆，香气四溢。</p>', 0, 1, 8, 9.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7009, 21, '李子', '', NULL, '<p>李子色泽紫红，果肉紧实，酸甜开胃，汁水充足。</p><p>放软后风味更佳。冰镇食用，酸甜解腻，夏日开胃水果。</p>', 0, 1, 9, 12.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7010, 21, '荔枝', '', NULL, '<p>荔枝果壳鲜红，果肉晶莹剔透，清甜多汁，香气独特。</p><p>当日采摘冷链发货。冰镇后食用，甜而不腻，岭南佳果。</p>', 0, 1, 10, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7011, 21, '榴莲', '', NULL, '<p>榴莲果肉金黄绵密，香气浓郁，口感如奶油般丝滑，甜而不腻。</p><p>猫山王品质之选。冰镇食用像冰淇淋，炖鸡汤更滋补，榴莲控福音。</p>', 0, 1, 11, 59.99, 79.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7012, 21, '山竹', '', NULL, '<p>山竹果肉洁白如蒜瓣，清甜微酸，口感细腻，果香清新。</p><p>水果皇后，和榴莲是绝配。冰镇食用，解腻降火，夏日必备。</p>', 0, 1, 12, 29.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7013, 21, '椰子', '', NULL, '<p>椰子椰汁清甜，椰肉厚实，清香自然，天然解渴。</p><p>椰汁直接饮用，椰肉挖取食用。椰青炖鸡、椰子水打底做饮品皆宜。</p>', 0, 1, 13, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7014, 21, '芒果', '', NULL, '<p>芒果果肉金黄，香甜多汁，纤维细腻，香气浓郁。</p><p>成熟度恰到好处。直接食用、榨芒果汁、做芒果糯米饭，热带风情十足。</p>', 0, 1, 14, 14.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7015, 21, '菠萝', '', NULL, '<p>菠萝果肉金黄，酸甜多汁，纤维适中，香气浓郁。</p><p>削皮后用盐水浸泡更佳。菠萝咕咾肉、菠萝炒饭、鲜榨菠萝汁，开胃解腻。</p>', 0, 1, 15, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7016, 21, '杨梅', '', NULL, '<p>杨梅色泽乌红，果肉饱满，酸甜多汁，风味独特。</p><p>时令短促，且吃且珍惜。冰镇杨梅、杨梅汤、泡杨梅酒，酸甜开胃。</p>', 0, 1, 16, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7017, 21, '樱桃', '', NULL, '<p>樱桃果皮红润，果肉脆甜，汁水丰盈，入口爆汁。</p><p>车厘子品质，颗颗精选。冰镇食用更佳，补铁护眼，水果贵族。</p>', 0, 1, 17, 22.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7018, 21, '蓝莓', '', NULL, '<p>蓝莓果粉完整，颗粒饱满，酸甜可口，富含花青素。</p><p>护眼抗氧化。直接食用、拌酸奶、做蓝莓酱，健康零食首选。</p>', 0, 1, 18, 18.99, 24.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7019, 21, '草莓', '', NULL, '<p>草莓果形饱满，色泽红润，香甜多汁，草莓香气浓郁。</p><p>当天采摘当天发货。直接食用、草莓蛋糕、草莓酱，红颜满屋香。</p>', 0, 1, 19, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7020, 21, '葡萄', '', NULL, '<p>葡萄颗粒饱满，果肉紧实，甜度高，汁水丰盈。</p><p>皮薄肉脆，冰镇后食用风味更佳。洗后食用，榨汁做沙拉皆宜。</p>', 0, 1, 20, 16.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7021, 21, '柠檬', '', NULL, '<p>柠檬果皮金黄，香气清新，酸度纯正，富含维生素C。</p><p>柠檬蜂蜜水、柠檬泡椒凤爪、烤鱼提香。切片泡水，美白解腻。</p>', 0, 1, 21, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7022, 21, '青提', '', NULL, '<p>青提翡翠碧绿，皮薄无籽，脆甜多汁，入口爽利。</p><p>阳光充足糖分高。冷藏后食用冰爽脆甜，一颗接一颗停不下来。</p>', 0, 1, 22, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7023, 21, '红提', '', NULL, '<p>红提色泽红润，果粒紧实，清甜脆爽，带籽可嚼。</p><p>耐储存，冰箱冷藏可保存一周。洗净即食，招待客人有面子。</p>', 0, 1, 23, 21.99, 27.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7024, 21, '香蕉', '', NULL, '<p>香蕉果肉绵密，香甜软糯，即买即食，老少皆宜。</p><p>自然熟更香甜。香蕉牛奶、香蕉燕麦、香蕉松饼，营养早餐好伴侣。</p>', 0, 1, 24, 5.99, 7.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7025, 21, '苹果', '', NULL, '<p>苹果果皮红亮，果肉脆甜，汁水充足，苹果香气纯正。</p><p>现摘现发，颗颗饱满。直接食用，榨汁、烤苹果、苹果派皆宜。</p>', 0, 1, 25, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7026, 21, '梨', '', NULL, '<p>梨果形饱满，果肉细腻，清甜多汁，润肺止咳。</p><p>汁水丰盈，生吃清甜，冰糖雪梨汤润喉。秋季干燥，吃梨正当时。</p>', 0, 1, 26, 6.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7027, 21, '桔子', '', NULL, '<p>桔子果皮金黄，果肉酸甜多汁，桔香浓郁。</p><p>皮薄易剥，一瓣一瓣停不下。剥皮即食，榨汁、做桔子罐头皆宜。</p>', 0, 1, 27, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7028, 21, '橙子', '', NULL, '<p>橙子果皮光滑，果肉紧实，酸甜多汁，维生素C丰富。</p><p>手剥橙汁水丰盈。直接食用、鲜榨橙汁、盐蒸橙子止咳，营养满满。</p>', 0, 1, 28, 8.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7029, 21, '柚子', '', NULL, '<p>柚子果肉晶莹，清甜微酸，汁水充足，富含维生素C。</p><p>柚子皮除味，柚子茶清甜。秋冬干燥季，补水润燥佳品。</p>', 0, 1, 29, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7030, 21, '猕猴桃', '', NULL, '<p>猕猴桃果肉翠绿，籽粒细腻，酸甜多汁，维C含量极高。</p><p>放软后食用更甜。猕猴桃酸奶、榨汁、切盘，健康水果之选。</p>', 0, 1, 30, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7031, 21, '冬枣', '', NULL, '<p>冬枣圆润饱满，皮薄肉脆，甘甜多汁，维C含量水果之冠。</p><p>咬一口脆甜爆汁。洗净即食，冷冻后口感如冰沙，一口一个。</p>', 0, 1, 31, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (7032, 21, '椰子', '', NULL, '<p>椰青椰汁清甜冰爽，椰肉嫩滑，天然补水神器。</p><p>开孔插吸管直接喝。椰汁炖鸡、椰子冻、椰肉椰奶，夏日清爽组合。</p>', 0, 1, 32, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8001, 22, '巨峰葡萄', '/uploads/2026/08/巨峰葡萄_20260813160000.jpg', NULL, '<p>巨峰葡萄果粒硕大，果皮紫黑，肉厚多汁，甜中带微酸。</p><p>经典老牌品种。冰镇后食用风味更佳，榨汁、酿酒皆宜。</p>', 0, 1, 1, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8002, 22, '夏黑葡萄', '/uploads/2026/08/夏黑葡萄_20260813160142.jpg', NULL, '<p>夏黑葡萄无籽皮薄，果肉紧实，脆甜多汁，甜度极高。</p><p>一口一个不用吐籽。冷藏后冰爽脆甜，夏日解暑优选。</p>', 0, 1, 2, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8003, 22, '阳光玫瑰', '', NULL, '<p>阳光玫瑰果粒翠绿，玫瑰香气浓郁，皮薄无籽，甜度极高。</p><p>高端葡萄之选。香气独特，冷藏后风味更佳，送礼有面子。</p>', 0, 1, 3, 39.99, 49.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8004, 22, '蓝莓', '', NULL, '<p>蓝莓果粉完整，果粒饱满，酸甜适口，花青素丰富。</p><p>护眼抗氧化。洗净即食，拌酸奶、做蓝莓酱，健康零食首选。</p>', 0, 1, 4, 18.99, 24.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8005, 22, '草莓', '', NULL, '<p>草莓果形端正，色泽鲜红，香甜多汁，草莓香浓郁。</p><p>当日现摘现发。直接食用、草莓奶昔、草莓蛋糕，甜蜜满屋。</p>', 0, 1, 5, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8006, 22, '猕猴桃', '', NULL, '<p>猕猴桃果肉翠绿，酸甜多汁，维C之王，营养密度高。</p><p>放软后食用更香甜。猕猴桃酸奶、榨汁、果盘搭配，健康首选。</p>', 0, 1, 6, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8007, 22, '杨梅', '', NULL, '<p>杨梅乌红饱满，酸甜多汁，果香浓郁，时令珍果。</p><p>鲜食期短，且吃且珍惜。冰镇杨梅、杨梅汤、杨梅酒，夏日限定。</p>', 0, 1, 7, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8008, 22, '樱桃', '', NULL, '<p>樱桃红润饱满，果肉脆甜，汁水丰盈，颗颗爆汁。</p><p>精品大果，冷链发货。冰镇食用口感更佳，补铁护眼，甜蜜享受。</p>', 0, 1, 8, 22.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8009, 22, '桑葚', '', NULL, '<p>桑葚紫黑饱满，汁水丰盈，清甜带酸，花青素含量极高。</p><p>采摘期短，珍贵时令果。桑葚酱、桑葚酒，补血养颜。</p>', 0, 1, 9, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8010, 22, '黑布林', '', NULL, '<p>黑布林果皮深紫，果肉紧实，酸甜浓郁，风味独特。</p><p>放软后口感更佳。冰镇食用，酸甜解腻，餐后水果好选择。</p>', 0, 1, 10, 22.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8011, 22, '无花果', '', NULL, '<p>无花果果肉粉红绵密，香甜软糯，种子细腻，营养丰富。</p><p>高纤通便。直接食用、做无花果酱、配沙拉，甜蜜养生。</p>', 0, 1, 11, 29.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (8012, 22, '西梅', '', NULL, '<p>西梅果皮紫蓝，果肉紧实，清甜多汁，膳食纤维丰富。</p><p>通便小能手。直接食用、做成西梅干，软糯香甜，健康零食。</p>', 0, 1, 12, 19.99, 25.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9001, 23, '香蕉', '/uploads/2026/08/香蕉_20260813155948.webp', NULL, '<p>香蕉果肉绵密，香甜软糯，自然熟更甜，老少皆宜。</p><p>香蕉牛奶、香蕉燕麦早餐、香蕉派，营养快手两不误。</p>', 0, 1, 1, 5.99, 7.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9002, 23, '芒果', '/uploads/2026/08/芒果_20260813160132.jpg', NULL, '<p>芒果果肉金黄细腻，香甜多汁，纤维少，香气浓郁。</p><p>现摘现发。直接食用、芒果沙冰、芒果糯米粉，热带风情满满。</p>', 0, 1, 2, 14.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9003, 23, '火龙果', '/uploads/2026/08/火龙果_20260813160102.jpg', NULL, '<p>火龙果果肉红艳，清甜多汁，籽粒爽脆，营养丰富。</p><p>红心甜度更高。切块即食、榨汁、拌酸奶，清爽解腻。</p>', 0, 1, 3, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9004, 23, '菠萝', '', NULL, '<p>菠萝金黄多汁，酸甜可口，香气浓郁，纤维适中。</p><p>盐水浸泡后食用更佳。菠萝炒饭、菠萝咕咾肉、鲜榨果汁，开胃必备。</p>', 0, 1, 4, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9005, 23, '榴莲', '', NULL, '<p>榴莲果肉金黄绵密，香气浓郁，口感丝滑，甜而不腻。</p><p>佳品金枕。冰镇后如冰淇淋，榴莲炖鸡滋补，榴莲控福利。</p>', 0, 1, 5, 59.99, 79.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9006, 23, '山竹', '', NULL, '<p>山竹果肉洁白细嫩，清甜微酸，果香清新，营养丰富。</p><p>水果皇后。冷藏后食用更佳，解腻降火，和榴莲是黄金搭档。</p>', 0, 1, 6, 29.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9007, 23, '椰子', '', NULL, '<p>椰青椰汁清甜，椰肉嫩滑，天然补水，清香自然。</p><p>开盖即饮，椰汁清冽解渴。椰汁炖汤、椰子冻、椰奶，清爽一夏。</p>', 0, 1, 7, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9008, 23, '百香果', '', NULL, '<p>百香果果香馥郁，酸甜多汁，维C丰富，果汁之王。</p><p>挖籽冲蜜水、做百香果柠檬茶，果香浓郁，天然好喝。</p>', 0, 1, 8, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9009, 23, '杨桃', '', NULL, '<p>杨桃晶莹五棱，清甜爽脆，水分充足，颜值超高。</p><p>星形切片摆盘惊艳。直接食用、蘸梅子粉，清爽开胃。</p>', 0, 1, 9, 18.99, 22.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (9010, 23, '柠檬', '', NULL, '<p>柠檬果香清新，酸度纯正，维C丰富，百搭水果。</p><p>柠檬蜂蜜水、柠檬茶、烤鱼提香。切片泡水，美白解腻。</p>', 0, 1, 10, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10001, 24, '红富士苹果', '/uploads/2026/08/红富士苹果_20260813155940.jpg', '[\"https://cdn.example.com/spu/10001_1.jpg\", \"https://cdn.example.com/spu/10001_2.jpg\"]', '<p>红富士苹果果形端正，色泽红亮，肉质细脆多汁，香甜爽口。</p><p>产地冷藏保鲜，果面天然果蜡，可连皮食用。常温保存15天，冷藏30天。</p>', 0, 1, 1, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10002, 24, '嘎啦苹果', '/uploads/2026/08/苹果_20260809150317.jpg', NULL, '<p>嘎啦苹果果皮红亮，果肉脆甜，香气浓郁，酸甜适口。</p><p>早熟品种口感佳。现摘现发，直接食用，榨汁做派皆宜。</p>', 0, 1, 2, 8.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10003, 24, '皇冠梨', '/uploads/2026/08/皇冠梨_20260813160112.jpg', NULL, '<p>皇冠梨果皮金黄，果肉细腻，清甜多汁，核小肉厚。</p><p>润肺止咳。生吃清甜，冰糖雪梨汤润喉，秋燥必备。</p>', 0, 1, 3, 7.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10004, 24, '鸭梨', '', NULL, '<p>鸭梨果形饱满，果肉细脆，清甜多汁，梨香清新。</p><p>皮薄多汁。直接食用、煮梨汤，润燥清甜，全家都爱。</p>', 0, 1, 4, 6.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10005, 24, '水蜜桃', '', NULL, '<p>水蜜桃果皮粉嫩，果肉细腻，香甜爆汁，桃香浓郁。</p><p>放软后汁水更足。硬吃脆甜，软吃流蜜，夏天就要吃桃。</p>', 0, 1, 5, 14.99, 33.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10006, 24, '黄桃', '', NULL, '<p>黄桃果肉金黄，绵密香甜，桃香浓郁，口感厚实。</p><p>直接食用或做黄桃罐头。黄桃酸奶、黄桃蛋糕，甜蜜诱惑。</p>', 0, 1, 6, 12.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10007, 24, '油桃', '', NULL, '<p>油桃果皮光滑油亮，果肉紧实脆甜，汁水充足，香气浓郁。</p><p>洗净即食，脆甜爽口。放软后更香甜，夏日水果佳选。</p>', 0, 1, 7, 13.99, 31.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10008, 24, '李子', '', NULL, '<p>李子果皮紫红，果肉紧实，酸甜开胃，汁水丰富。</p><p>放软后风味更佳。冰镇食用，酸甜解腻，开胃好水果。</p>', 0, 1, 8, 11.99, 14.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10009, 24, '蜜桔', '', NULL, '<p>蜜桔果皮金黄，皮薄易剥，果肉细嫩，蜜甜多汁。</p><p>无渣化口，一颗接一颗。剥皮即食，秋冬季甜蜜担当。</p>', 0, 1, 9, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (10010, 24, '橙子', '', NULL, '<p>橙子果皮光滑，果肉紧实，酸甜多汁，维C丰富。</p><p>手剥汁水丰盈。鲜榨橙汁、盐蒸橙子，补充维C，元气满满。</p>', 0, 1, 10, 8.99, 21.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (11001, 31, '猪五花肉', '/uploads/2026/08/猪五花肉_20260813155725.jpeg', '[\"https://cdn.example.com/spu/11001_1.jpg\", \"https://cdn.example.com/spu/11001_2.jpg\"]', '<p>猪五花肉肥瘦相间，皮白肉红，肥而不腻，瘦而不柴。</p><p>冷鲜肉当日屠宰，酸排酬处理，红烧肉、梅菜扣肉、回锅肉首选部位。</p>', 0, 1, 1, 15.99, 36.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (11002, 31, '猪里脊', '/uploads/2026/08/猪里脊_20260813155836.jpg', NULL, '<p>猪里脊肉质细嫩，脂肪少，口感滑嫩，是猪身上最嫩的部位。</p><p>糖醋里脊、鱼香肉丝、小炒里脊，切丝切片大火快炒，嫩滑多汁。</p>', 0, 1, 2, 22.99, 52.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (11003, 31, '猪排骨', '', NULL, '<p>猪排骨肉质紧实，骨髓丰富，炖煮后鲜香入味，口感弹嫩。</p><p>糖醋排骨、排骨炖汤、红烧排骨，家常硬菜担当，汤汁拌饭一绝。</p>', 0, 1, 3, 14.99, 34.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (11004, 31, '猪蹄', '', NULL, '<p>猪蹄皮厚筋多，胶原蛋白丰富，炖煮后软糯弹牙，Q弹十足。</p><p>红烧猪蹄、黄豆炖猪蹄、烤猪蹄，美容养颜，越啃越香。</p>', 0, 1, 4, 12.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (11005, 31, '猪肝', '', NULL, '<p>猪肝鲜嫩细腻，铁元素丰富，补铁养血，营养密度高。</p><p>爆炒猪肝嫩滑，菠菜猪肝汤滋补。切片泡水去腥，大火快炒锁嫩。</p>', 0, 1, 5, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (11006, 31, '猪头肉', '/uploads/2026/08/猪肉_20260809150237.jpg', NULL, '<p>猪头肉肥瘦相间，胶质丰富，卤制后香气浓郁，口感Q弹。</p><p>卤猪头肉切片凉拌，下酒神器。蒜泥白肉、猪头肉拌黄瓜，越嚼越香。</p>', 0, 1, 6, 13.99, 16.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (11007, 31, '猪腰子', '', NULL, '<p>猪腰子肉质脆嫩，处理得当后口感爽脆，营养丰富。</p><p>爆炒腰花、葱爆腰花经典做法。去膜去筋切花刀，大火爆炒才嫩。</p>', 0, 1, 7, 16.99, 20.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (12001, 32, '牛腱子肉', '/uploads/2026/08/牛肉_20260809150258.jpg', NULL, '<p>牛腱子肉筋肉交错，口感筋道有嚼劲，卤制后香气十足。</p><p>卤牛肉切片下酒，酱牛肉、牛腱炖萝卜，越嚼越有滋味。</p>', 0, 1, 1, 35.99, 84.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (12002, 32, '牛里脊', '/uploads/2026/08/牛里脊_20260813155817.webp', NULL, '<p>牛里脊肉质细嫩，纤维细腻，口感滑嫩，是牛排和炒菜的首选。</p><p>黑椒牛柳、西芹炒牛肉、嫩牛肉火锅，大火快炒嫩滑多汁。</p>', 0, 1, 2, 49.99, 119.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (12003, 32, '羊腿肉', '/uploads/2026/08/羊肉_20260809150220.jpg', NULL, '<p>羊腿肉肉质紧实，膻味轻，瘦肉多，炖煮后鲜嫩入味。</p><p>羊肉炖萝卜暖身，孜然羊肉、羊肉手抓饭，秋冬滋补首选。</p>', 0, 1, 3, 38.99, 91.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (12004, 32, '羊排', '', NULL, '<p>羊排肉质细嫩，肥瘦相间，烤制后外焦里嫩，香气四溢。</p><p>烤羊排、红烧羊排、羊排萝卜汤，孜然辣椒一撒，满屋飘香。</p>', 0, 1, 4, 45.99, 109.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13001, 33, '三黄鸡', '/uploads/2026/08/三黄鸡_20260813155715.jpg', NULL, '<p>三黄鸡皮黄肉嫩，肉质细滑，鲜味足，适合白切和煲汤。</p><p>白切鸡、盐焗鸡、鸡汤，肉质鲜嫩不柴，做法多样。</p>', 0, 1, 1, 25.99, 39.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13002, 33, '土鸡', '/uploads/2026/08/土鸡_20260813155800.jpg', NULL, '<p>土鸡散养长大，肉质紧实鲜美，汤味浓郁，营养更丰富。</p><p>老母鸡炖汤最滋补，红烧土鸡、清炖土鸡，汤鲜肉香，家常大补。</p>', 0, 1, 2, 38.99, 48.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13003, 33, '鸡腿', '/uploads/2026/08/鸡腿_20260813155913.jpeg', NULL, '<p>鸡腿肉质厚实细嫩，口感多汁，怎么做都好吃。</p><p>香煎鸡腿、照烧鸡腿、炸鸡腿，奥尔良烤鸡腿，肉食爱好者最爱。</p>', 0, 1, 3, 14.99, 34.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13004, 33, '鸡翅', '', NULL, '<p>鸡翅皮嫩肉滑，胶原蛋白丰富，烤制煎炸都香气扑鼻。</p><p>可乐鸡翅、蜜汁烤翅、椒盐鸡翅，外焦里嫩，大人小孩都爱。</p>', 0, 1, 4, 12.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13005, 33, '鸭肉', '', NULL, '<p>鸭肉肉质紧实，皮薄脂肪适中，香味独特，滋阴润燥。</p><p>啤酒鸭、红烧鸭、老鸭汤，家常硬菜，越炖越香。</p>', 0, 1, 5, 28.99, 35.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13006, 33, '鸭蛋', '', NULL, '<p>鸭蛋蛋壳光滑，蛋黄橙红起沙，口感醇厚，营养丰富。</p><p>咸鸭蛋流油起沙，炒鸭蛋、鸭蛋蒸蛋羹，早餐粥的黄金搭档。</p>', 0, 1, 6, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13007, 33, '鸽子', '', NULL, '<p>鸽子肉质细嫩鲜美，蛋白质含量高，炖汤滋补，营养丰富。</p><p>鸽子汤滋补养身，红烧鸽子、烤乳鸽，汤鲜肉嫩，滋补佳品。</p>', 0, 1, 7, 22.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (13008, 33, '鹌鹑蛋', '', NULL, '<p>鹌鹑蛋小巧圆润，蛋黄细腻，营养是鸡蛋的数倍。</p><p>卤鹌鹑蛋、虎皮鹌鹑蛋、火锅配菜，一口一个，孩子最爱。</p>', 0, 1, 8, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (14001, 34, '鸡蛋', '/uploads/2026/08/鸡蛋_20260813155708.jpg', NULL, '<p>鸡蛋蛋壳干净，蛋黄饱满橙黄，蛋清浓稠，新鲜可溯。</p><p>当天产蛋当天发货。蒸蛋羹、炒蛋、煮蛋、蛋花汤，营养早餐标配。</p>', 0, 1, 1, 9.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (14002, 34, '土鸡蛋', '/uploads/2026/08/土鸡蛋_20260813155750.jpeg', NULL, '<p>土鸡蛋蛋黄橙红，口感醇香，蛋白浓稠，散养更营养。</p><p>农家散养鸡产蛋。水煮蛋、蒸蛋羹、糖水蛋，蛋香浓郁，安心之选。</p>', 0, 1, 2, 14.99, 34.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (14003, 34, '鸭蛋', '/uploads/2026/08/鸭蛋_20260813155858.jpg', NULL, '<p>鸭蛋蛋黄大而红，蛋白质地细腻，风味独特。</p><p>咸鸭蛋流油起沙，炒鸭蛋、蛋花汤，早餐下饭两相宜。</p>', 0, 1, 3, 18.99, 44.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (14004, 34, '鹌鹑蛋', '', NULL, '<p>鹌鹑蛋小巧营养高，蛋黄细腻，富含卵磷脂和蛋白质。</p><p>卤蛋一口一个，火锅必备。虎皮鹌鹑蛋、糖醋鹌鹑蛋，孩子爱吃。</p>', 0, 1, 4, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (15001, 41, '草鱼', '/uploads/2026/08/草鱼_20260809134918.jpg', '[\"https://cdn.example.com/spu/15001_1.jpg\", \"https://cdn.example.com/spu/15001_2.jpg\"]', '<p>草鱼肉质细嫩，刺少肉多，富含不饱和脂肪酸，适合红烧、清蒸、鱼头豆腐汤。</p><p>活鱼现杀，去鳞去鳃去内脏，冰袋保鲜发货。收货后建议1小时内烹饪。</p>', 0, 1, 1, 18.99, 33.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (15002, 41, '鲤鱼', '/uploads/2026/08/鲤鱼_20260813155540.jpg', NULL, '<p>鲤鱼鱼肉紧实，肉质鲜嫩，鱼刺分明，越煮越鲜。</p><p>红烧鲤鱼、糖醋鲤鱼、鲤鱼炖豆腐，家常鱼菜经典，鲜美下饭。</p>', 0, 1, 2, 16.99, 29.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (15003, 41, '鲫鱼', '/uploads/2026/08/鲫鱼_20260813155620.jpg', NULL, '<p>鲫鱼鱼肉细嫩鲜美，汤味奶白浓郁，滋补养身。</p><p>鲫鱼豆腐汤奶白鲜香，红烧鲫鱼、鲫鱼蒸蛋，汤鲜肉嫩，老幼皆宜。</p>', 0, 1, 3, 12.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (15004, 41, '鲢鱼', '', NULL, '<p>鲢鱼鱼头肥美，鱼肉细嫩，胶质丰富，炖汤一绝。</p><p>剁椒鱼头、鱼头豆腐汤、红烧鲢鱼，鱼头是灵魂，越吃越香。</p>', 0, 1, 4, 14.99, 26.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (15005, 41, '鳙鱼', '', NULL, '<p>鳙鱼鱼头硕大肥美，鱼肉细嫩，胶质丰富，营养滋补。</p><p>剁椒鱼头湘味经典，鱼头汤奶白鲜美，鱼身红烧，一鱼两吃。</p>', 0, 1, 5, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (15006, 41, '黄鳝', '', NULL, '<p>黄鳝肉质细嫩，刺少肉厚，口感弹滑，营养丰富。</p><p>鳝丝炒茭白、红烧黄鳝、响油鳝糊，浓油赤酱，鲜美无比。</p>', 0, 1, 6, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (16001, 42, '带鱼', '/uploads/2026/08/带鱼_20260813155338.jpg', NULL, '<p>带鱼鱼身银亮，肉质紧实细嫩，刺少肉厚，鲜味足。</p><p>香煎带鱼外酥里嫩，红烧带鱼、糖醋带鱼，家常下饭好菜。</p>', 0, 1, 1, 18.99, 43.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (16002, 42, '黄花鱼', '/uploads/2026/08/黄花鱼_20260813155515.webp', NULL, '<p>黄花鱼肉质细嫩如蒜瓣，刺少味鲜，营养丰富。</p><p>清蒸黄花鱼原汁原味，红烧黄花鱼、香煎黄花鱼，鲜嫩不腥。</p>', 0, 1, 2, 22.99, 53.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (16003, 42, '鲳鱼', '/uploads/2026/08/鲳鱼_20260813155605.webp', NULL, '<p>鲳鱼肉质细嫩，刺少肉厚，味道鲜美，老少皆宜。</p><p>清蒸鲳鱼鲜嫩，香煎鲳鱼外酥里嫩，红烧鲳鱼，怎么做都好吃。</p>', 0, 1, 3, 35.99, 44.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (16004, 42, '鲈鱼', '', NULL, '<p>鲈鱼肉质细嫩洁白，刺少味鲜，是清蒸鱼首选。</p><p>清蒸鲈鱼鲜嫩多汁，葱油鲈鱼、红烧鲈鱼，宴客家常两相宜。</p>', 0, 1, 4, 28.99, 35.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (16005, 42, '鳕鱼', '', NULL, '<p>鳕鱼肉质细嫩，口感滑嫩，刺少肉厚，高蛋白低脂肪。</p><p>香煎鳕鱼外焦里嫩，清蒸鳕鱼、鳕鱼炖豆腐，宝宝辅食优选。</p>', 0, 1, 5, 38.99, 48.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (16006, 42, '鱿鱼', '', NULL, '<p>鱿鱼肉质厚实弹韧，口感爽脆，鲜味十足。</p><p>铁板鱿鱼、爆炒鱿鱼须、鱿鱼圈炸制，烧烤界人气王。</p>', 0, 1, 6, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (17001, 43, '基围虾', '/uploads/2026/08/基围虾_20260813155333.jpg', NULL, '<p>基围虾壳薄肉厚，虾肉弹嫩鲜甜，虾头虾膏饱满。</p><p>白灼基围虾原汁原味，蒜蓉开背虾、油焖大虾，宴客硬菜。</p>', 0, 1, 1, 45.99, 109.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (17002, 43, '明虾', '/uploads/2026/08/明虾_20260813155450.webp', NULL, '<p>明虾个大肉厚，虾肉弹滑，鲜甜可口，虾味浓郁。</p><p>清蒸、白灼、椒盐皆宜。虾仁炒蛋、鲜虾粥，鲜上加鲜。</p>', 0, 1, 2, 38.99, 48.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (17003, 43, '花蛤', '/uploads/2026/08/花蛤_20260813155559.jpeg', NULL, '<p>花蛤鲜活吐沙，肉质鲜嫩肥美，自带海水鲜味。</p><p>爆炒花蛤配啤酒，花蛤蒸蛋鲜嫩，紫菜花蛤汤，鲜掉眉毛。</p>', 0, 1, 3, 28.99, 35.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (17004, 43, '大闸蟹', '/uploads/2026/08/大闸蟹_20260813155631.jpg', NULL, '<p>大闸蟹青壳白肚，蟹黄饱满流油，蟹肉清甜细嫩。</p><p>清蒸大闸蟹配姜醋，阳澄湖同款品质，金秋蟹宴主角。</p>', 0, 1, 4, 68.99, 159.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (17005, 43, '生蚝', '', NULL, '<p>生蚝肥美多汁，蚝肉鲜嫩，海水味清新，营养丰富。</p><p>蒜蓉粉丝烤生蚝，清蒸生蚝配柠檬，生蚝煎蛋，鲜甜爆汁。</p>', 0, 1, 5, 32.99, 40.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (17006, 43, '牡蛎', '', NULL, '<p>牡蛎肥美饱满，蚝肉滑嫩，鲜味浓郁，富含锌元素。</p><p>蒜蓉烤牡蛎、牡蛎煎蛋、牡蛎豆腐汤，鲜美滋补两不误。</p>', 0, 1, 6, 25.99, 32.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18001, 51, '东北大米', '/uploads/2026/08/东北大米_20260813154715.webp', '[\"https://cdn.example.com/spu/18001_1.jpg\", \"https://cdn.example.com/spu/18001_2.jpg\"]', '<p>东北大米粒粒饱满，晶莹剔透，蒸煮后米香浓郁，米饭软糯香甜。</p><p>黑土地种植，生长周期长，积累更多干物质。真空包装防潮防虫，常温保存12个月。</p>', 0, 1, 1, 69.99, 159.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18002, 51, '五常大米', '/uploads/2026/08/五常大米_20260813154858.jpg', NULL, '<p>五常大米颗粒饱满，米香浓郁，蒸煮后软糯弹牙，油光发亮。</p><p>黑土地孕育，稻花香品种。新米当季，煮粥煮饭都香气扑鼻。</p>', 0, 1, 2, 89.99, 199.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18003, 51, '小米', '/uploads/2026/08/小米_20260813160623.webp', NULL, '<p>小米颗粒金黄，米香醇厚，熬粥后绵软起油皮，养胃暖身。</p><p>陕北小米品质优良。小米南瓜粥、小米红枣粥，早餐养生首选。</p>', 0, 1, 3, 9.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18004, 51, '黄豆', '/uploads/2026/08/黄豆_20260813160631.jpg', NULL, '<p>黄豆颗粒饱满，豆香浓郁，蛋白质含量高，大豆异黄酮丰富。</p><p>打豆浆浓香细腻，发豆芽、炖猪蹄、卤黄豆，一豆多吃。</p>', 0, 1, 4, 12.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18005, 51, '绿豆', '/uploads/2026/08/绿豆_20260813160638.webp', NULL, '<p>绿豆颗粒翠绿饱满，煮后绵沙起沙，清热解暑。</p><p>绿豆汤解暑神器，绿豆糕、绿豆粥，夏日清凉必备。</p>', 0, 1, 5, 11.99, 14.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18006, 51, '红豆', '', NULL, '<p>红豆颗粒饱满，色泽红润，煮后绵软起沙，补血养颜。</p><p>红豆沙甜品经典，红豆粥、红豆薏米水，甜蜜养生两不误。</p>', 0, 1, 6, 13.99, 17.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18007, 51, '黑米', '/uploads/2026/08/黑米_20260813160736.webp', NULL, '<p>黑米颗粒乌黑油亮，米香浓郁，富含花青素，营养丰富。</p><p>黑米粥浓稠滋补，黑米糕、黑米豆浆，粗粮细吃更健康。</p>', 0, 1, 7, 15.99, 19.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18008, 51, '燕麦', '', NULL, '<p>燕麦颗粒饱满，麦香浓郁，膳食纤维丰富，饱腹感强。</p><p>燕麦牛奶早餐标配，燕麦粥、燕麦饼干，健康减脂好主食。</p>', 0, 1, 8, 18.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (18009, 51, '玉米碴', '', NULL, '<p>玉米碴金黄粗粝，煮粥绵香，粗粮纤维丰富。</p><p>玉米碴粥配咸菜，东北大碴子粥经典，粗粮健康之选。</p>', 0, 1, 9, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (19001, 52, '小麦粉', '/uploads/2026/08/小麦粉_20260813154721.jpg', NULL, '<p>小麦粉筋度高，洁白细腻，麦香浓郁，做面食弹性好。</p><p>高筋面粉馒头包子饺子，面条筋道不破皮，面食爱好者首选。</p>', 0, 1, 1, 18.99, 42.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (19002, 52, '挂面', '/uploads/2026/08/挂面_20260813154825.webp', NULL, '<p>挂面细滑筋道，煮后不易糊，麦香浓郁，快手主食。</p><p>鸡蛋挂面汤、葱油拌面、西红柿鸡蛋面，几分钟一碗热乎面。</p>', 0, 1, 2, 6.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (19003, 52, '面粉', '/uploads/2026/08/面粉_20260813160658.jpg', NULL, '<p>面粉洁白细腻，吸水性强，麦香自然，家用全能粉。</p><p>包子馒头饺子面条全能，烙饼、炸油条，家常面食一袋搞定。</p>', 0, 1, 3, 19.99, 44.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (19004, 52, '饺子皮', '', NULL, '<p>饺子皮筋道弹牙，薄厚均匀，不易破皮，包饺子省心。</p><p>现压饺子皮更耐煮。猪肉白菜饺、韭菜鸡蛋饺，皮薄馅大才好吃。</p>', 0, 1, 4, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (20001, 53, '菜籽油', '/uploads/2026/08/菜籽油_20260813154640.webp', '[\"https://cdn.example.com/spu/20001_1.jpg\", \"https://cdn.example.com/spu/20001_2.jpg\"]', '<p>菜籽油物理压榨，保留菜籽天然营养，油色金黄，香味浓郁。</p><p>烟点高，适合爆炒、油炸、凉拌。非转基因，无添加抗氧化剂。</p>', 0, 1, 1, 29.99, 89.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (20002, 53, '花生油', '/uploads/2026/08/花生油_20260813154817.webp', NULL, '<p>花生油金黄透亮，花生香气浓郁，煎炒炸都香。</p><p>物理压榨更纯正。炒菜提香，煎炸上色好，家常烹饪首选。</p>', 0, 1, 2, 32.99, 99.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (20003, 53, '大豆油', '/uploads/2026/08/大豆油_20260813154935.jpg', NULL, '<p>大豆油色泽清亮，油烟少，口感清爽，营养均衡。</p><p>精炼一级大豆油。炒菜煎炸皆宜，清淡不抢味，日常烹饪百搭。</p>', 0, 1, 3, 26.99, 82.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (20004, 53, '葵花籽油', '', NULL, '<p>葵花籽油色泽浅黄，口感清淡，富含维生素E，油烟少。</p><p>轻脂健康之选。凉拌、清炒、煎蛋，清淡不油腻，厨房好帮手。</p>', 0, 1, 4, 30.99, 94.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (20005, 53, '玉米油', '', NULL, '<p>玉米油清透轻盈，烟点高，口感清爽，适合煎炸。</p><p>非转基因玉米压榨。炒菜煎炸不油腻，健康烹饪好选择。</p>', 0, 1, 5, 28.99, 90.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (20006, 53, '橄榄油', '', NULL, '<p>橄榄油金黄透亮，果香清新，单不饱和脂肪酸丰富，健康之选。</p><p>特级初榨品质。凉拌沙拉、蘸面包、低温煎炒，地中海式健康饮食。</p>', 0, 1, 6, 52.99, 159.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21001, 54, '食盐', '/uploads/2026/08/食盐_20260813154549.jpg', NULL, '<p>食盐颗粒细腻，咸味纯正，碘元素补充，日常必备。</p><p>加碘食用盐，家庭烹饪基础调味，炒菜煲汤样样离不开。</p>', 0, 1, 1, 3.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21002, 54, '白糖', '/uploads/2026/08/白糖_20260813154809.jpg', NULL, '<p>白糖颗粒晶莹，甜味纯正，溶解快，烹饪百搭。</p><p>炒菜提鲜、红烧上色、甜品烘焙，厨房必备基础甜味。</p>', 0, 1, 2, 6.99, 36.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21003, 54, '酱油', '/uploads/2026/08/酱油_20260813154915.webp', NULL, '<p>酱油酱香浓郁，咸鲜适口，色泽红亮，提鲜上色。</p><p>生抽提鲜、老抽上色。红烧肉、炒菜、蘸料，中餐灵魂调味。</p>', 0, 1, 3, 12.99, 28.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21004, 54, '醋', '/uploads/2026/08/醋_20260813160717.jpg', NULL, '<p>醋香浓郁，酸味柔和，开胃解腻，去腥提香。</p><p>凉拌菜点睛，糖醋排骨、醋溜白菜，吃饺子蘸醋，酸香开胃。</p>', 0, 1, 4, 9.99, 20.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21005, 54, '鸡精', '/uploads/2026/08/鸡精_20260813160855.webp', NULL, '<p>鸡精颗粒鲜香，提鲜增味，炒菜煲汤一勺搞定。</p><p>鲜味浓郁自然。炒菜、炖汤、煮面撒一点，鲜味瞬间提升。</p>', 0, 1, 5, 8.99, 23.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21006, 54, '花椒', '', NULL, '<p>花椒颗粒饱满，麻香浓郁，麻味纯正，川菜灵魂。</p><p>麻婆豆腐、水煮鱼、椒麻鸡，热油泼香，麻辣鲜香一锅端。</p>', 0, 1, 6, 12.99, 15.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21007, 54, '八角', '/uploads/2026/08/八角_20260813160752.jpg', NULL, '<p>八角瓣大饱满，香气浓郁，炖肉卤味必备香料。</p><p>红烧肉、卤牛肉、炖排骨，放两粒香气四溢，去腥增香。</p>', 0, 1, 7, 9.99, 12.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (21008, 54, '桂皮', '/uploads/2026/08/桂皮_20260813160808.jpg', NULL, '<p>桂皮卷紧厚实，甜香浓郁，炖肉卤味提香去腥。</p><p>红烧肉、卤味、茶叶蛋必备，与八角花椒是黄金搭档。</p>', 0, 1, 8, 14.99, 18.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (22001, 61, '嫩豆腐', '/uploads/2026/08/嫩豆腐_20260813155008.jpg', NULL, '<p>豆腐鲜嫩细腻，豆香浓郁，入口即化，优质蛋白来源。</p><p>当日现做发货。麻婆豆腐、鲫鱼豆腐汤、香煎豆腐，家常百搭。</p>', 0, 1, 1, 4.99, 6.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (22002, 61, '老豆腐', '/uploads/2026/08/老豆腐_20260813155103.jpg', NULL, '<p>嫩豆腐滑嫩如脂，口感细腻，入口即化，豆香清甜。</p><p>皮蛋豆腐、虾仁蒸豆腐、豆腐脑，清淡鲜美，老幼皆宜。</p>', 0, 1, 2, 4.49, 5.99, '2026-08-09 00:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (22003, 61, '内酯豆腐', '/uploads/2026/08/内酯豆腐_20260813155148.jpg', NULL, '<p>老豆腐质地紧实，久煮不碎，豆香醇厚，越煮越入味。</p><p>冻豆腐炖菜吸汁，香煎豆腐外焦里嫩，家常豆腐经典做法。</p>', 0, 1, 3, 5.49, 6.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (22004, 61, '豆浆', '/uploads/2026/08/豆浆_20260813155224.webp', NULL, '<p>内酯豆腐极嫩滑，细腻如蛋羹，口感轻盈，豆香淡雅。</p><p>凉拌内酯豆腐、皮蛋豆腐、豆腐羹，清淡爽口，夏日开胃。</p>', 0, 1, 4, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (22005, 61, '豆腐脑', '/uploads/2026/08/豆腐脑_20260813155256.webp', NULL, '<p>豆腐皮薄如纸，豆香浓郁，口感柔韧，营养丰富。</p><p>凉拌豆腐皮爽口，炒青椒、涮火锅，素食高蛋白之选。</p>', 0, 1, 5, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (23001, 62, '豆腐干', '/uploads/2026/08/豆干_20260813155001.jpg', NULL, '<p>豆干紧实弹牙，豆香浓郁，卤香入味，越嚼越香。</p><p>凉拌豆干、青椒炒豆干、卤豆干，下酒下饭两相宜。</p>', 0, 1, 1, 7.99, 9.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (23002, 62, '腐竹', '/uploads/2026/08/腐竹_20260813155038.webp', NULL, '<p>千张薄而有韧性，豆香浓郁，口感筋道，越煮越入味。</p><p>千张结烧肉、凉拌千张丝、千张卷金针菇，家常美味。</p>', 0, 1, 2, 8.99, 11.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (23003, 62, '千张', '/uploads/2026/08/千张_20260813155125.jpeg', NULL, '<p>腐竹金黄透亮，豆香浓郁，泡发后柔韧爽滑，营养丰富。</p><p>凉拌腐竹爽口，腐竹焖鸭、腐竹鸡蛋汤，素食黄金搭档。</p>', 0, 1, 3, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (23004, 62, '豆腐皮', '/uploads/2026/08/豆腐皮_20260813155205.webp', NULL, '<p>豆腐泡金黄鼓胀，内部蜂窝多孔，吸汁能力一流。</p><p>关东煮灵魂、卤豆腐泡、炖菜吸汁，一口爆汁，豆香十足。</p>', 0, 1, 4, 6.99, 8.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (23005, 62, '豆芽', '/uploads/2026/08/豆芽_20260813155240.jpg', NULL, '<p>豆腐丝细如发丝，口感爽滑，豆香清纯，凉拌最佳。</p><p>凉拌豆腐丝、豆腐丝炒肉丝、卷饼配菜，清爽开胃，快手小菜。</p>', 0, 1, 5, 4.99, 6.99, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `goods_spu_bak_0813` VALUES (23006, 11, '空心菜', '/uploads/2026/08/空心菜_20260809145519.jpg', NULL, NULL, 0, 1, 5, 2.00, 4.00, '2026-08-09 14:55:46', '2026-08-09 14:55:46', 0);

-- ----------------------------
-- Table structure for inventory_log
-- ----------------------------
DROP TABLE IF EXISTS `inventory_log`;
CREATE TABLE `inventory_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `spu_id` bigint(0) NOT NULL,
  `sku_id` bigint(0) NOT NULL,
  `change_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'INIT 初始化/ORDER_DEDUCT 订单扣减/ORDER_REFUND 退款回滚/ADJUST 手动调整/STOCK_IN 入库/CHECK 盘点',
  `change_qty` int(0) NOT NULL COMMENT '变动量, 正增负减',
  `before_qty` int(0) NOT NULL,
  `after_qty` int(0) NOT NULL,
  `operator_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'SYSTEM' COMMENT 'ADMIN/SYSTEM/USER',
  `operator_id` bigint(0) NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sku`(`sku_id`) USING BTREE,
  INDEX `idx_create`(`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存变动流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory_log
-- ----------------------------
INSERT INTO `inventory_log` VALUES (34, 19001, 19002, 'ORDER_DEDUCT', -3, 80, 77, 'SYSTEM', NULL, '订单扣减', '2026-08-14 05:11:18');
INSERT INTO `inventory_log` VALUES (35, 15001, 15002, 'ORDER_DEDUCT', -1, 30, 29, 'SYSTEM', NULL, '订单扣减', '2026-08-14 05:11:18');
INSERT INTO `inventory_log` VALUES (36, 4001, 2080, 'ORDER_DEDUCT', -1, 15, 14, 'SYSTEM', NULL, '订单扣减', '2026-08-14 10:14:41');
INSERT INTO `inventory_log` VALUES (37, 19001, 19002, 'ORDER_REFUND', 3, 77, 80, 'SYSTEM', NULL, '退款/取消回滚', '2026-08-14 14:49:34');
INSERT INTO `inventory_log` VALUES (38, 15001, 15002, 'ORDER_REFUND', 1, 29, 30, 'SYSTEM', NULL, '退款/取消回滚', '2026-08-14 14:49:34');
INSERT INTO `inventory_log` VALUES (39, 19001, 19002, 'ORDER_DEDUCT', -1, 80, 79, 'SYSTEM', NULL, '订单扣减', '2026-08-14 15:29:34');
INSERT INTO `inventory_log` VALUES (40, 23005, 23005, 'ORDER_DEDUCT', -1, 200, 199, 'SYSTEM', NULL, '订单扣减', '2026-08-14 15:29:34');
INSERT INTO `inventory_log` VALUES (41, 1024, 2034, 'ORDER_DEDUCT', -1, 150, 149, 'SYSTEM', NULL, '订单扣减', '2026-08-14 15:29:34');
INSERT INTO `inventory_log` VALUES (42, 19001, 19002, 'ORDER_REFUND', 1, 79, 80, 'SYSTEM', NULL, '退款/取消回滚', '2026-08-14 15:42:57');
INSERT INTO `inventory_log` VALUES (43, 23005, 23005, 'ORDER_REFUND', 1, 199, 200, 'SYSTEM', NULL, '退款/取消回滚', '2026-08-14 15:42:57');
INSERT INTO `inventory_log` VALUES (44, 1024, 2034, 'ORDER_REFUND', 1, 149, 150, 'SYSTEM', NULL, '退款/取消回滚', '2026-08-14 15:42:57');
INSERT INTO `inventory_log` VALUES (45, 1005, 2007, 'ORDER_DEDUCT', -1, 50, 49, 'SYSTEM', NULL, '订单扣减', '2026-08-14 15:46:48');
INSERT INTO `inventory_log` VALUES (46, 20003, 20006, 'ORDER_DEDUCT', -1, 150, 149, 'SYSTEM', NULL, '订单扣减', '2026-08-14 16:15:42');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` bigint unsigned NOT NULL COMMENT '公告ID',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公告标题',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告内容',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '开关:0-关闭 1-开启',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公告弹窗表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '热烈开业｜鲜到家生鲜商城正式上线', '亲爱的顾客朋友们：\n鲜到家生鲜商城于2026年8月9日正式开业啦！全场蔬菜、水果、肉禽蛋品、水产海鲜、粮油调味、豆制品六大品类一站购齐，每日凌晨产地直采，全程冷链配送到家。\n\n开业三重礼：\n1. 全场满49元立减10元；\n2. 新用户首单立减15元（注册即送5元无门槛券）；\n3. 下单满99元享免费配送到家。\n\n当日下单，最快2小时极速送达，坏果包赔、缺斤退差，买得放心，吃得安心。欢迎进店选购！', 1, '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info`  (
  `id` bigint unsigned NOT NULL COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号(PT前缀)',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人姓名(快照)',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人电话(快照)',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货地址(快照)',
  `total_num` int(0) NOT NULL DEFAULT 0 COMMENT '商品总数',
  `pro_total_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '商品总价',
  `total_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单总价(=商品总价,无运费)',
  `pay_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  `paid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '支付状态:0-未支付 1-已支付',
  `pay_time` datetime(0) NULL DEFAULT NULL COMMENT '支付时间',
  `pay_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式:weixin',
  `pay_channel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付渠道:mini',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信侧商户单号',
  `transaction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信支付交易号',
  `status` int(0) NOT NULL DEFAULT 0 COMMENT '订单状态:0待付款,1待发货,2待收货,3已完成,9已取消',
  `cancel_status` int(0) NOT NULL DEFAULT 0 COMMENT '取消状态:0未取消,1系统取消,2用户取消',
  `refund_status` int(0) NOT NULL DEFAULT 0 COMMENT '退款状态:0未退款,1退款中,3已退款',
  `cancel_time` datetime(0) NULL DEFAULT NULL COMMENT '取消时间',
  `delivery_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货方式:express/merchant(商家配送)',
  `express_company` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递公司',
  `express_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递单号',
  `delivery_time` datetime(0) NULL DEFAULT NULL COMMENT '发货时间',
  `receive_time` datetime(0) NULL DEFAULT NULL COMMENT '确认收货时间',
  `user_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户备注',
  `source_cart_ids` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '本次下单来源购物车条目ID(逗号分隔);立即购买为空。支付成功后据此清空购物车',
  `version` bigint(0) NOT NULL DEFAULT 0 COMMENT '乐观锁版本号(防并发丢失更新,禁止手动赋值)',
  `admin_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '后台内部备注',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_out_trade_no`(`out_trade_no`) USING BTREE,
  INDEX `idx_transaction_id`(`transaction_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '主订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_info
-- ----------------------------
INSERT INTO `order_info` VALUES (7, 'PT202608140511180002764', 1, '刘', '1887025XXXX', '浙江省杭州市余杭区未知', 4, 75.96, 75.96, 75.96, 1, '2026-08-14 05:11:19', 'demo', 'mini', NULL, 'MOCK_PT202608140511180002764', 9, 2, 3, '2026-08-14 14:49:35', 'merchant', NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, '2026-08-14 05:11:19', '2026-08-14 05:11:19', 0);
INSERT INTO `order_info` VALUES (8, 'PT202608141014410001802', 1, '刘', '1887025XXXX', '浙江省杭州市余杭区未知', 1, 27.99, 27.99, 27.99, 1, '2026-08-14 10:14:42', 'demo', 'mini', NULL, 'MOCK_PT202608141014410001802', 3, 0, 0, NULL, 'merchant', NULL, NULL, '2026-08-14 10:16:13', '2026-08-14 10:16:24', NULL, '9', 5, NULL, '2026-08-14 10:14:42', '2026-08-14 10:14:42', 0);
INSERT INTO `order_info` VALUES (9, 'PT202608141529340001962', 1, '刘', '1887025XXXX', '浙江省杭州市余杭区未知', 3, 25.47, 25.47, 25.47, 1, '2026-08-14 15:29:35', 'demo', 'mini', NULL, 'MOCK_PT202608141529340001962', 9, 2, 3, '2026-08-14 15:42:58', 'merchant', NULL, NULL, NULL, NULL, NULL, '4,23,24', 5, NULL, '2026-08-14 15:29:35', '2026-08-14 15:29:35', 0);
INSERT INTO `order_info` VALUES (10, 'PT202608141546480003996', 1, '刘', '1887025XXXX', '浙江省杭州市余杭区未知', 1, 4.99, 4.99, 4.99, 1, '2026-08-14 15:46:49', 'demo', 'mini', NULL, 'MOCK_PT202608141546480003996', 3, 0, 0, NULL, 'merchant', NULL, NULL, '2026-08-14 15:47:43', '2026-08-14 15:48:32', NULL, NULL, 5, NULL, '2026-08-14 15:46:49', '2026-08-14 15:46:49', 0);
INSERT INTO `order_info` VALUES (11, 'PT202608141615420001766', 1, '刘', '1887025XXXX', '浙江省杭州市余杭区未知', 1, 26.99, 26.99, 26.99, 1, '2026-08-14 16:15:43', 'demo', 'mini', NULL, 'MOCK_PT202608141615420001766', 3, 0, 0, NULL, 'merchant', NULL, NULL, '2026-08-14 16:17:09', '2026-08-14 16:32:14', NULL, NULL, 5, NULL, '2026-08-14 16:15:43', '2026-08-14 16:15:43', 0);

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint unsigned NOT NULL COMMENT '明细ID',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号(冗余)',
  `spu_id` bigint unsigned NOT NULL COMMENT 'SPU ID(快照)',
  `sku_id` bigint unsigned NOT NULL COMMENT 'SKU ID',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称(快照)',
  `sku_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格名称(快照)',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片(快照)',
  `price` decimal(10, 2) NOT NULL COMMENT '成交单价(快照)',
  `num` int(0) NOT NULL COMMENT '购买数量',
  `total_price` decimal(10, 2) NOT NULL COMMENT '小计',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  INDEX `idx_sku_id`(`sku_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 7, 'PT202608140511180002764', 19001, 19002, '小麦粉', '10kg/袋', '/uploads/2026/08/小麦粉_20260813154721.jpg', 18.99, 3, 56.97, '2026-08-14 05:11:19');
INSERT INTO `order_item` VALUES (2, 7, 'PT202608140511180002764', 15001, 15002, '草鱼', '1条约1.5kg', '/uploads/2026/08/草鱼_20260809134918.jpg', 18.99, 1, 18.99, '2026-08-14 05:11:19');
INSERT INTO `order_item` VALUES (3, 8, 'PT202608141014410001802', 4001, 2080, '香菇', '1条约1.2kg', '/uploads/2026/08/香菇_20260813154254.jpeg', 27.99, 1, 27.99, '2026-08-14 10:14:42');
INSERT INTO `order_item` VALUES (4, 9, 'PT202608141529340001962', 19001, 19002, '小麦粉', '10kg/袋', '/uploads/2026/08/小麦粉_20260813154721.jpg', 18.99, 1, 18.99, '2026-08-14 15:29:35');
INSERT INTO `order_item` VALUES (5, 9, 'PT202608141529340001962', 23005, 23005, '豆芽', '300g/袋', '/uploads/2026/08/豆芽_20260813155240.jpg', 4.99, 1, 4.99, '2026-08-14 15:29:35');
INSERT INTO `order_item` VALUES (6, 9, 'PT202608141529340001962', 1024, 2034, '娃娃菜', '100g/把', '/uploads/2026/08/娃娃菜_20260813160422.webp', 1.49, 1, 1.49, '2026-08-14 15:29:35');
INSERT INTO `order_item` VALUES (7, 10, 'PT202608141546480003996', 1005, 2007, '生菜', '1颗约2kg', '/uploads/2026/08/生菜_20260813160513.webp', 4.99, 1, 4.99, '2026-08-14 15:46:49');
INSERT INTO `order_item` VALUES (8, 11, 'PT202608141615420001766', 20003, 20006, '大豆油', '1.8L/桶', '/uploads/2026/08/大豆油_20260813154935.jpg', 26.99, 1, 26.99, '2026-08-14 16:15:43');

-- ----------------------------
-- Table structure for order_status_log
-- ----------------------------
DROP TABLE IF EXISTS `order_status_log`;
CREATE TABLE `order_status_log`  (
  `id` bigint unsigned NOT NULL COMMENT '日志ID',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号(冗余)',
  `change_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型:create/pay/delivery/receive/cancel/refund',
  `from_status` int(0) NULL DEFAULT NULL COMMENT '原状态',
  `to_status` int(0) NULL DEFAULT NULL COMMENT '新状态',
  `change_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作说明',
  `operator_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'system' COMMENT '操作方:user/admin/system/wechat',
  `create_time` datetime(0) NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单状态流转日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_status_log
-- ----------------------------
INSERT INTO `order_status_log` VALUES (1, 7, 'PT202608140511180002764', 'create', NULL, 0, '创建订单', 'user', '2026-08-14 05:11:19');
INSERT INTO `order_status_log` VALUES (2, 7, 'PT202608140511180002764', 'pay', 0, 1, '微信支付成功', 'wechat', '2026-08-14 05:11:19');
INSERT INTO `order_status_log` VALUES (3, 8, 'PT202608141014410001802', 'create', NULL, 0, '创建订单', 'user', '2026-08-14 10:14:42');
INSERT INTO `order_status_log` VALUES (4, 8, 'PT202608141014410001802', 'pay', 0, 1, '微信支付成功', 'wechat', '2026-08-14 10:14:42');
INSERT INTO `order_status_log` VALUES (5, 8, 'PT202608141014410001802', 'accept', 1, 4, '接单/开始配送', 'admin', '2026-08-14 10:15:16');
INSERT INTO `order_status_log` VALUES (6, 8, 'PT202608141014410001802', 'delivery', 4, 2, '配送完成', 'admin', '2026-08-14 10:16:13');
INSERT INTO `order_status_log` VALUES (7, 8, 'PT202608141014410001802', 'receive', 2, 3, '确认收货', 'admin', '2026-08-14 10:16:25');
INSERT INTO `order_status_log` VALUES (8, 7, 'PT202608140511180002764', 'refund', 0, 1, '用户申请售后', 'user', '2026-08-14 14:48:49');
INSERT INTO `order_status_log` VALUES (9, 7, 'PT202608140511180002764', 'refund', 1, 3, '微信退款成功', 'wechat', '2026-08-14 14:49:35');
INSERT INTO `order_status_log` VALUES (10, 7, 'PT202608140511180002764', 'cancel', 1, 9, '未发货仅退款成功,订单取消', 'system', '2026-08-14 14:49:35');
INSERT INTO `order_status_log` VALUES (11, 9, 'PT202608141529340001962', 'create', NULL, 0, '创建订单', 'user', '2026-08-14 15:29:35');
INSERT INTO `order_status_log` VALUES (12, 9, 'PT202608141529340001962', 'pay', 0, 1, '微信支付成功', 'wechat', '2026-08-14 15:29:35');
INSERT INTO `order_status_log` VALUES (13, 9, 'PT202608141529340001962', 'refund', 0, 1, '用户取消订单·发起原路退款', 'user', '2026-08-14 15:42:58');
INSERT INTO `order_status_log` VALUES (14, 9, 'PT202608141529340001962', 'refund', 1, 3, '微信退款成功', 'wechat', '2026-08-14 15:42:58');
INSERT INTO `order_status_log` VALUES (15, 9, 'PT202608141529340001962', 'cancel', 1, 9, '未发货仅退款成功,订单取消', 'system', '2026-08-14 15:42:58');
INSERT INTO `order_status_log` VALUES (16, 10, 'PT202608141546480003996', 'create', NULL, 0, '创建订单', 'user', '2026-08-14 15:46:49');
INSERT INTO `order_status_log` VALUES (17, 10, 'PT202608141546480003996', 'pay', 0, 1, '微信支付成功', 'wechat', '2026-08-14 15:46:49');
INSERT INTO `order_status_log` VALUES (18, 10, 'PT202608141546480003996', 'accept', 1, 4, '接单/开始配送', 'admin', '2026-08-14 15:47:24');
INSERT INTO `order_status_log` VALUES (19, 10, 'PT202608141546480003996', 'delivery', 4, 2, '配送完成', 'admin', '2026-08-14 15:47:43');
INSERT INTO `order_status_log` VALUES (20, 10, 'PT202608141546480003996', 'receive', 2, 3, '确认收货', 'user', '2026-08-14 15:48:32');
INSERT INTO `order_status_log` VALUES (21, 11, 'PT202608141615420001766', 'create', NULL, 0, '创建订单', 'user', '2026-08-14 16:15:43');
INSERT INTO `order_status_log` VALUES (22, 11, 'PT202608141615420001766', 'pay', 0, 1, '微信支付成功', 'wechat', '2026-08-14 16:15:43');
INSERT INTO `order_status_log` VALUES (23, 11, 'PT202608141615420001766', 'accept', 1, 4, '接单/开始配送', 'admin', '2026-08-14 16:16:18');
INSERT INTO `order_status_log` VALUES (24, 11, 'PT202608141615420001766', 'delivery', 4, 2, '配送完成', 'admin', '2026-08-14 16:17:09');
INSERT INTO `order_status_log` VALUES (25, 11, 'PT202608141615420001766', 'receive', 2, 3, '确认收货', 'user', '2026-08-14 16:32:14');

-- ----------------------------
-- Table structure for pay_callback_log
-- ----------------------------
DROP TABLE IF EXISTS `pay_callback_log`;
CREATE TABLE `pay_callback_log`  (
  `id` bigint unsigned NOT NULL COMMENT '日志ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联订单号',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户单号',
  `transaction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信交易号',
  `callback_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型:pay-支付通知 refund-退款通知',
  `raw_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '原始报文全文',
  `decrypted_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '解密后明文',
  `trade_state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易状态',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '通知金额',
  `verify_result` tinyint(1) NOT NULL DEFAULT 0 COMMENT '验签结果:0-未验/失败 1-通过',
  `process_result` tinyint(1) NOT NULL DEFAULT 0 COMMENT '处理结果:0-未处理/失败 1-成功 2-幂等跳过',
  `fail_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '失败原因',
  `create_time` datetime(0) NOT NULL COMMENT '收到回调时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_out_trade_no`(`out_trade_no`) USING BTREE,
  INDEX `idx_transaction_id`(`transaction_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '支付回调日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pay_order
-- ----------------------------
DROP TABLE IF EXISTS `pay_order`;
CREATE TABLE `pay_order`  (
  `id` bigint unsigned NOT NULL COMMENT '流水ID',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务订单号(冗余)',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `pay_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'weixin' COMMENT '支付方式:weixin',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户单号(微信侧商户订单号)',
  `transaction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信支付交易号',
  `attach` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附加数据(JSON:type+userId)',
  `pay_amount` decimal(10, 2) NOT NULL COMMENT '应支付金额',
  `cash_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '微信实收金额',
  `trade_state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'NOTPAY' COMMENT '微信交易状态:NOTPAY/SUCCESS/CLOSED/REFUND/PAYERROR',
  `paid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支付成功:0-否 1-是',
  `pay_time` datetime(0) NULL DEFAULT NULL COMMENT '支付成功时间',
  `notify_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '回调地址',
  `err_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误码',
  `err_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误描述',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间(预下单)',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_out_trade_no`(`out_trade_no`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  INDEX `idx_transaction_id`(`transaction_id`) USING BTREE,
  INDEX `idx_trade_state`(`trade_state`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '支付流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_order
-- ----------------------------
INSERT INTO `pay_order` VALUES (1, 7, 'PT202608140511180002764', 1, 'demo', 'PT202608140511180002764', 'MOCK_PT202608140511180002764', 'PT202608140511180002764', 75.96, NULL, 'REFUND', 1, '2026-08-14 05:11:19', NULL, NULL, NULL, '2026-08-14 05:11:19', '2026-08-14 05:11:19', 0);
INSERT INTO `pay_order` VALUES (2, 8, 'PT202608141014410001802', 1, 'demo', 'PT202608141014410001802', 'MOCK_PT202608141014410001802', 'PT202608141014410001802', 27.99, NULL, 'SUCCESS', 1, '2026-08-14 10:14:42', NULL, NULL, NULL, '2026-08-14 10:14:42', '2026-08-14 10:14:42', 0);
INSERT INTO `pay_order` VALUES (3, 9, 'PT202608141529340001962', 1, 'demo', 'PT202608141529340001962', 'MOCK_PT202608141529340001962', 'PT202608141529340001962', 25.47, NULL, 'REFUND', 1, '2026-08-14 15:29:35', NULL, NULL, NULL, '2026-08-14 15:29:35', '2026-08-14 15:29:35', 0);
INSERT INTO `pay_order` VALUES (4, 10, 'PT202608141546480003996', 1, 'demo', 'PT202608141546480003996', 'MOCK_PT202608141546480003996', 'PT202608141546480003996', 4.99, NULL, 'SUCCESS', 1, '2026-08-14 15:46:49', NULL, NULL, NULL, '2026-08-14 15:46:49', '2026-08-14 15:46:49', 0);
INSERT INTO `pay_order` VALUES (5, 11, 'PT202608141615420001766', 1, 'demo', 'PT202608141615420001766', 'MOCK_PT202608141615420001766', 'PT202608141615420001766', 26.99, NULL, 'SUCCESS', 1, '2026-08-14 16:15:43', NULL, NULL, NULL, '2026-08-14 16:15:43', '2026-08-14 16:15:43', 0);

-- ----------------------------
-- Table structure for refund_order
-- ----------------------------
DROP TABLE IF EXISTS `refund_order`;
CREATE TABLE `refund_order`  (
  `id` bigint unsigned NOT NULL COMMENT '退款单ID',
  `refund_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款单号(RE前缀)',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号(冗余)',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `reason` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款原因(枚举)',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '问题描述',
  `images` json NULL COMMENT '凭证图片数组(最多6张)',
  `refund_amount` decimal(10, 2) NOT NULL COMMENT '退款金额(=实付全额)',
  `status` int(0) NOT NULL DEFAULT 0 COMMENT '状态:0处理中,1已拒绝,2退款成功,3已撤销',
  `refuse_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `out_refund_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信退款单号',
  `refund_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信侧退款ID',
  `refund_success_time` datetime(0) NULL DEFAULT NULL COMMENT '退款成功时间',
  `cancel_time` datetime(0) NULL DEFAULT NULL COMMENT '撤销时间',
  `create_time` datetime(0) NOT NULL COMMENT '申请时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  `refund_type` tinyint(0) NOT NULL DEFAULT 2 COMMENT '退款类型:1仅退款(不退货,适用待发货/待收货/已完成),2退货退款',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_refund_no`(`refund_no`) USING BTREE,
  UNIQUE INDEX `uk_order_id`(`order_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_out_refund_no`(`out_refund_no`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '退款单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_order
-- ----------------------------
INSERT INTO `refund_order` VALUES (1, 'RE202608141448480001958', 7, 'PT202608140511180002764', 1, '不想要了', NULL, '[]', 75.96, 2, NULL, 'MOCK_RE202608141448480001958', NULL, '2026-08-14 14:49:34', NULL, '2026-08-14 14:48:49', '2026-08-14 14:49:35', 0, 1);
INSERT INTO `refund_order` VALUES (2, 'RE202608141542570002947', 9, 'PT202608141529340001962', 1, '用户取消订单·未发货原路退款', NULL, NULL, 25.47, 2, NULL, 'MOCK_RE202608141542570002947', NULL, '2026-08-14 15:42:57', NULL, '2026-08-14 15:42:58', '2026-08-14 15:42:58', 0, 1);

-- ----------------------------
-- Table structure for refund_order_item
-- ----------------------------
DROP TABLE IF EXISTS `refund_order_item`;
CREATE TABLE `refund_order_item`  (
  `id` bigint unsigned NOT NULL COMMENT '明细ID',
  `refund_order_id` bigint unsigned NOT NULL COMMENT '退款单ID',
  `order_id` bigint unsigned NOT NULL COMMENT '订单ID',
  `order_item_id` bigint unsigned NOT NULL COMMENT '订单明细ID',
  `spu_id` bigint unsigned NOT NULL COMMENT '商品SPU ID',
  `sku_id` bigint unsigned NOT NULL COMMENT '商品SKU ID',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称(快照)',
  `sku_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格名称(快照)',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片(快照)',
  `price` decimal(10, 2) NOT NULL COMMENT '单价(快照)',
  `num` int(0) NOT NULL COMMENT '退款数量',
  `refund_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '该明细退款金额(price*num)',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_refund_id`(`refund_order_id`) USING BTREE,
  INDEX `idx_order_item_id`(`order_item_id`) USING BTREE,
  INDEX `idx_refund_order_id`(`refund_order_id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '退款明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_order_item
-- ----------------------------
INSERT INTO `refund_order_item` VALUES (1, 1, 7, 1, 19001, 19002, '小麦粉', '10kg/袋', '/uploads/2026/08/小麦粉_20260813154721.jpg', 18.99, 3, 56.97, '2026-08-14 14:48:49', '2026-08-14 14:48:49', 0);
INSERT INTO `refund_order_item` VALUES (2, 1, 7, 2, 15001, 15002, '草鱼', '1条约1.5kg', '/uploads/2026/08/草鱼_20260809134918.jpg', 18.99, 1, 18.99, '2026-08-14 14:48:49', '2026-08-14 14:48:49', 0);
INSERT INTO `refund_order_item` VALUES (3, 2, 9, 4, 19001, 19002, '小麦粉', '10kg/袋', '/uploads/2026/08/小麦粉_20260813154721.jpg', 18.99, 1, 18.99, '2026-08-14 15:42:58', '2026-08-14 15:42:58', 0);
INSERT INTO `refund_order_item` VALUES (4, 2, 9, 5, 23005, 23005, '豆芽', '300g/袋', '/uploads/2026/08/豆芽_20260813155240.jpg', 4.99, 1, 4.99, '2026-08-14 15:42:58', '2026-08-14 15:42:58', 0);
INSERT INTO `refund_order_item` VALUES (5, 2, 9, 6, 1024, 2034, '娃娃菜', '100g/把', '/uploads/2026/08/娃娃菜_20260813160422.webp', 1.49, 1, 1.49, '2026-08-14 15:42:58', '2026-08-14 15:42:58', 0);

-- ----------------------------
-- Table structure for shop_config
-- ----------------------------
DROP TABLE IF EXISTS `shop_config`;
CREATE TABLE `shop_config`  (
  `id` bigint unsigned NOT NULL COMMENT '主键ID（单商户固定为1，全局唯一一条店铺记录）',
  `shop_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '店铺名称（展示在首页/店铺页顶部）',
  `shop_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '店铺Logo图标URL（由商家在后台自主上传，存OSS/CDN地址）',
  `business_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '营业状态：0-已打烊（不可下单） 1-营业中',
  `close_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '打烊内容（打烊时展示给用户的提示文案，如“今日休息，明日8:00营业”）',
  `is_popup` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否弹窗：0-不弹窗 1-进入店铺/首页时弹窗提示（配合 close_content 或公告使用）',
  `free_shipping_threshold` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '免运费门槛金额（元）：订单满该金额包邮，0=不包邮',
  `shipping_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '基础运费（元）：未满免邮门槛时向用户收取的运费',
  `aftersale_days` int(0) NOT NULL DEFAULT 7 COMMENT '售后有效期（天）：收货后多少天内可申请仅退款',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `business_start` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业开始时间(HH:mm)，如 08:00；NULL表示不启用按时自动打烊',
  `business_end` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业结束时间(HH:mm)，如 22:00；支持跨天(如22:00-06:00)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺信息表(单商户唯一一条)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_config
-- ----------------------------
INSERT INTO `shop_config` VALUES (1, '蕴宇生鲜', '/uploads/2026/08/upload_20260813180737.png', 1, '店铺休息中，请稍后再来', 1, 0.00, 0.00, 7, '2026-08-09 00:45:53', '2026-08-09 00:45:53', NULL, NULL);

-- ----------------------------
-- Table structure for shop_config_kv_bak
-- ----------------------------
DROP TABLE IF EXISTS `shop_config_kv_bak`;
CREATE TABLE `shop_config_kv_bak`  (
  `id` bigint unsigned NOT NULL COMMENT '配置ID',
  `config_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置键',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置值',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '说明',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for shop_qrcode
-- ----------------------------
DROP TABLE IF EXISTS `shop_qrcode`;
CREATE TABLE `shop_qrcode`  (
  `id` bigint unsigned NOT NULL COMMENT '二维码ID',
  `type` tinyint(0) NOT NULL DEFAULT 1 COMMENT '类型: 1-平台客服 2-粉丝群',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称(如:专属客服-小云 / 生鲜福利1群)',
  `wx_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信号(type=1 客服微信号，支持一键复制；粉丝群可为空)',
  `qrcode_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '二维码图片URL(客服个人码 / 微信群码)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '说明文案(如:长按识别二维码添加，工作日秒回)',
  `service_time` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '服务时间(仅客服使用，如 08:00-20:00)',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客服电话(仅客服使用，选填，小程序可一键拨号)',
  `expire_date` date NULL DEFAULT NULL COMMENT '二维码有效期(微信群码7天失效，到期后台提醒更换；NULL=长期有效)',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序值(升序，越小越靠前)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态: 0-停用 1-启用(仅启用项在小程序展示)',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0-正常 1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type_status_sort`(`type`, `status`, `sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客服二维码表(1=平台客服微信,2=粉丝群二维码)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_qrcode
-- ----------------------------
INSERT INTO `shop_qrcode` VALUES (1, 1, '专属客服', '', '', '长按识别二维码添加客服微信，下单/售后有问题随时找我', '08:00-20:00', NULL, NULL, 1, 0, '2026-08-11 12:38:17', '2026-08-11 12:38:17', 0);
INSERT INTO `shop_qrcode` VALUES (2, 2, '生鲜福利群', NULL, '/uploads/2026/08/alipay_20260811130602.jpg', '长按识别进群，每天开抢特价菜与满减券', NULL, NULL, NULL, 1, 1, '2026-08-11 12:38:17', '2026-08-11 12:38:17', 0);

-- ----------------------------
-- Table structure for shop_service_item
-- ----------------------------
DROP TABLE IF EXISTS `shop_service_item`;
CREATE TABLE `shop_service_item`  (
  `id` bigint unsigned NOT NULL COMMENT '服务项ID',
  `type` tinyint(0) NOT NULL DEFAULT 1 COMMENT '类型: 1-服务承诺 2-保障标签',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '小标题(如:品质保障 / 当日鲜采)',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '说明(如:缺货包退 / 冷链直送)',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标URL(仅 type=2 保障标签使用)',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序值(升序)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态: 0停用 1启用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type_status_sort`(`type`, `status`, `sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺服务项表(1=服务承诺,2=保障标签;商品详情页服务保障区)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_service_item
-- ----------------------------
INSERT INTO `shop_service_item` VALUES (1, 1, '品质承诺', '所有生鲜当日采摘、冷链直送，不新鲜包退。', NULL, 10, 1, '2026-08-10 15:13:16', '2026-08-10 15:13:16', 0);
INSERT INTO `shop_service_item` VALUES (2, 1, '时效承诺', '下单后24小时内发货，超时主动赔付。', NULL, 20, 1, '2026-08-10 15:13:16', '2026-08-10 15:13:16', 0);
INSERT INTO `shop_service_item` VALUES (3, 1, '售后承诺', '签收后24小时内发现坏果，拍照联系客服即刻理赔。', NULL, 30, 1, '2026-08-10 15:13:16', '2026-08-10 15:13:16', 0);
INSERT INTO `shop_service_item` VALUES (4, 2, '品质保障', '当日鲜采，劣质包退', NULL, 1, 1, '2026-08-10 13:58:21', '2026-08-10 13:58:21', 0);
INSERT INTO `shop_service_item` VALUES (5, 2, '缺货包退', '库存不足自动退款', NULL, 2, 1, '2026-08-10 13:58:21', '2026-08-10 13:58:21', 0);
INSERT INTO `shop_service_item` VALUES (6, 2, '破损包赔', '签收24h内拍照理赔', NULL, 3, 1, '2026-08-10 13:58:21', '2026-08-10 13:58:21', 0);
INSERT INTO `shop_service_item` VALUES (7, 2, '准时送达', '超时未达补偿', NULL, 4, 1, '2026-08-10 13:58:21', '2026-08-10 13:58:21', 0);
INSERT INTO `shop_service_item` VALUES (11, 3, '坏果包赔', '签收24h内拍照联系客服，属实即刻赔付', NULL, 1, 1, '2026-08-10 17:06:31', '2026-08-10 17:06:31', 0);
INSERT INTO `shop_service_item` VALUES (12, 3, '退换时效', '签收后7天内可申请售后', NULL, 2, 1, '2026-08-10 17:06:31', '2026-08-10 17:06:31', 0);
INSERT INTO `shop_service_item` VALUES (13, 3, '不支持退换', '拆封/鲜活易腐类食品非质量问题不退换', NULL, 3, 1, '2026-08-10 17:06:31', '2026-08-10 17:06:31', 0);

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint unsigned NOT NULL COMMENT '主键ID（固定为1，全局唯一一条系统配置记录）',
  `wxpay_enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '微信支付开关：0-关闭（下单直接拦截，用于未配置完成时保护） 1-开启',
  `pay_demo_enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '模拟支付(演示)开关：0-关闭(走真实微信支付) 1-开启(模拟支付,无任何真实金额交易,仅供体验版演示)',
  `wxpay_appid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信支付AppID：小程序的AppID（wx开头），必须与发起支付的小程序一致，否则报\"appid与mchid不匹配\"',
  `wxpay_mch_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信支付商户号MchID：微信商户平台10位数字，如 1723097745',
  `wxpay_api_v3_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'APIv3密钥（密文存储）：商户平台自行设置的32位字符串，用于回调报文解密与敏感信息加解密',
  `wxpay_cert_serial_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户API证书序列号：40位十六进制，由 openssl x509 -in apiclient_cert.pem -noout -serial 获取，请求签名时放在HTTP头',
  `wxpay_private_key_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户API私钥文件路径：apiclient_key.pem 在服务器上的绝对/相对路径，用于请求签名（最高机密，泄露=可代付款）',
  `wxpay_private_cert_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户API证书文件路径：apiclient_cert.pem 在服务器上的路径，用于部分需要双向认证的接口',
  `wxpay_public_key_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信支付公钥ID：PUB_KEY_ID_开头，2024年后新商户使用「公钥模式」验签时必填（旧商户用平台证书模式可留空）',
  `wxpay_public_key_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信支付公钥文件路径：从商户平台下载的 wechatpay_xxx.pem，用于验证微信回调报文签名',
  `wxpay_notify_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付结果回调地址：必须是公网可访问的HTTPS地址，微信付款成功后异步通知到此URL',
  `wxpay_refund_notify_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款结果回调地址：必须是公网可访问的HTTPS地址，退款到账后异步通知到此URL',
  `storage_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '存储方式：1-本地磁盘（存服务器目录，适合单机/内网） 2-腾讯云COS（对象存储，适合多机部署与CDN加速）',
  `local_storage_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT './uploads' COMMENT '【本地存储】文件根目录：相对路径以服务启动目录为基准，生产建议用绝对路径并挂载持久化磁盘（容器部署不挂载则重启丢图）',
  `local_access_domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '【本地存储】外链访问域名：如 https://shop.example.com，留空则自动取当前请求域名（本地开发即 http://localhost:8080）',
  `cos_secret_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '【COS】腾讯云 SecretId：访问密钥ID，建议使用子账号并仅授予该存储桶的读写权限',
  `cos_secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '【COS】腾讯云 SecretKey（密文存储）：访问密钥，泄露=存储桶被任意读写',
  `cos_region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '【COS】存储桶地域：如 ap-guangzhou / ap-shanghai，必须与桶所在地域完全一致',
  `cos_bucket` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '【COS】存储桶名称：需带APPID后缀，如 fresh-mall-1250000000',
  `cos_domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '【COS】访问域名：自定义CDN域名或默认域名，留空则用 https://{bucket}.cos.{region}.myqcloud.com 拼接',
  `cos_dir_prefix` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'mall' COMMENT '【COS】对象目录前缀：所有文件统一放在该目录下，便于与桶内其它业务隔离，如 mall',
  `image_compress_enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '图片自动压缩开关：0-关闭（原图直传） 1-开启（上传时自动压缩，视觉无损、显著降体积）',
  `image_compress_quality` int(0) NOT NULL DEFAULT 85 COMMENT '压缩质量（1-100）：85为视觉无损推荐值，低于70肉眼可见劣化，100等于不压缩',
  `image_max_width` int(0) NOT NULL DEFAULT 1920 COMMENT '图片最大宽度(px)：超出则等比缩放，高度自适应；0=不限制尺寸只做质量压缩',
  `image_compress_threshold_kb` int(0) NOT NULL DEFAULT 200 COMMENT '压缩触发阈值(KB)：小于该体积的图片直接原样保存，避免小图越压越大',
  `image_max_size_mb` int(0) NOT NULL DEFAULT 5 COMMENT '单张图片大小上限(MB)：超过直接拒绝上传（须 <= spring.servlet.multipart.max-file-size）',
  `image_allow_ext` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'jpg,jpeg,png,gif,webp,bmp' COMMENT '允许上传的图片扩展名白名单：逗号分隔、全小写，防止上传脚本文件',
  `ext_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '扩展配置(JSON字符串)：后续新增的零散开关放这里，避免频繁改表结构；格式 {\"key\":\"value\"}',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注：记录本次配置调整的原因/操作人，便于运维追溯',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置表(全局唯一一条:支付/存储/图片处理)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, 0, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, './uploads', NULL, NULL, NULL, NULL, NULL, NULL, 'mall', 1, 85, 1920, 200, 5, 'jpg,jpeg,png,gif,webp,bmp', NULL, '系统初始化默认配置', '2026-08-09 01:55:31', '2026-08-09 01:55:31');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint unsigned NOT NULL COMMENT '用户ID',
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '微信openid',
  `unionid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信unionid',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信头像URL',
  `gender` tinyint(1) NOT NULL DEFAULT 0 COMMENT '性别:0-未知 1-男 2-女',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0-禁用 1-正常',
  `last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime(0) NOT NULL COMMENT '注册时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_openid`(`openid`) USING BTREE,
  INDEX `idx_unionid`(`unionid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '微信用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'oBL805XZh89gIqo-JicSQC_A-D_4', NULL, '生鲜顾客_954685', '/static/avatarfreeMall_compressed.jpg', 0, NULL, 1, '2026-08-14 15:49:31', '2026-08-10 09:46:12', '2026-08-10 09:46:12', 0);

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` bigint unsigned NOT NULL COMMENT '地址ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收货人电话',
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '省',
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '市',
  `district` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区/县',
  `detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '详细地址',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认地址:0-否 1-是',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_address
-- ----------------------------
INSERT INTO `user_address` VALUES (1, 1, '刘', '1887025XXXX', '浙江省', '杭州市', '余杭区', '未知', 1, '2026-08-13 20:18:20', '2026-08-13 20:18:20', 0);
INSERT INTO `user_address` VALUES (2, 1, '213', '15132518821', '北京市', '北京市', '朝阳区', '123', 0, '2026-08-13 23:42:40', '2026-08-13 23:42:40', 0);

-- ----------------------------
-- Table structure for user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite`;
CREATE TABLE `user_favorite`  (
  `id` bigint unsigned NOT NULL COMMENT '收藏ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `spu_id` bigint unsigned NOT NULL COMMENT '商品SPU ID',
  `create_time` datetime(0) NOT NULL COMMENT '收藏时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除:0-未删 1-已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_spu`(`user_id`, `spu_id`, `deleted`) USING BTREE,
  INDEX `idx_spu_id`(`spu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_favorite
-- ----------------------------
INSERT INTO `user_favorite` VALUES (1, 1, 19001, '2026-08-10 20:08:51', '2026-08-10 20:12:22', 1);
INSERT INTO `user_favorite` VALUES (2, 1, 19001, '2026-08-10 20:12:24', '2026-08-10 20:12:24', 0);
INSERT INTO `user_favorite` VALUES (3, 1, 15001, '2026-08-10 20:21:20', '2026-08-10 20:21:21', 1);
INSERT INTO `user_favorite` VALUES (4, 1, 15001, '2026-08-10 20:21:22', '2026-08-10 20:21:22', 0);
INSERT INTO `user_favorite` VALUES (5, 1, 18003, '2026-08-13 16:27:55', '2026-08-13 16:27:55', 0);
INSERT INTO `user_favorite` VALUES (6, 1, 20003, '2026-08-14 16:15:29', '2026-08-14 16:15:29', 0);

SET FOREIGN_KEY_CHECKS = 1;
