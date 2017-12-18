/*
 Navicat Premium Data Transfer

 Source Server         : ddz-203.86.3.244
 Source Server Type    : MySQL
 Source Server Version : 50534
 Source Host           : 203.86.3.244
 Source Database       : boss

 Target Server Type    : MySQL
 Target Server Version : 50534
 File Encoding         : utf-8

 Date: 11/02/2017 17:22:01 PM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `access`
-- ----------------------------
DROP TABLE IF EXISTS `access`;
CREATE TABLE `access` (
  `role_id` smallint(6) unsigned NOT NULL,
  `node_id` smallint(6) unsigned NOT NULL,
  `level` tinyint(1) NOT NULL,
  `pid` smallint(6) NOT NULL,
  `module` varchar(50) DEFAULT NULL,
  KEY `groupId` (`role_id`) USING BTREE,
  KEY `nodeId` (`node_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `activityaward`
-- ----------------------------
DROP TABLE IF EXISTS `activityaward`;
CREATE TABLE `activityaward` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `activityid` int(4) DEFAULT NULL COMMENT '活动ID',
  `sortnum` int(4) DEFAULT NULL COMMENT '排名',
  `awardlimit` int(4) DEFAULT '0',
  `awardtype` tinyint(1) DEFAULT NULL COMMENT '奖励类型:0,金币;1,元宝',
  `awardamount` bigint(8) DEFAULT NULL COMMENT '奖励金额',
  `desc` varchar(50) DEFAULT NULL COMMENT '奖品描述',
  `create_time` int(4) DEFAULT NULL,
  `update_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `activityawardlog`
-- ----------------------------
DROP TABLE IF EXISTS `activityawardlog`;
CREATE TABLE `activityawardlog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `activityid` int(4) DEFAULT NULL,
  `sortid` int(4) DEFAULT NULL,
  `awardtype` tinyint(1) DEFAULT NULL,
  `awardamount` bigint(8) DEFAULT NULL,
  `curramount` bigint(8) DEFAULT NULL COMMENT '中奖时的值',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2976 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `activityconf`
-- ----------------------------
DROP TABLE IF EXISTS `activityconf`;
CREATE TABLE `activityconf` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `atype` tinyint(4) DEFAULT '0' COMMENT '动活类型:0,日赚金币;1,月赚金币;2,日最大倍率;3,日最大玩牌数;4,日单局赢金币;5,仅展示',
  `type` tinyint(4) DEFAULT NULL COMMENT '户端客定义类型:0,跳转至榜单;1,仅展示',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '标题',
  `content` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '内容',
  `imag` varchar(200) DEFAULT NULL COMMENT '图片路径',
  `endtype` tinyint(4) DEFAULT NULL COMMENT '结算方式:0,每日0点结算;1,结束时间当天0点结算',
  `award_limit` bigint(8) DEFAULT NULL COMMENT '可获奖下限',
  `start_time` int(4) DEFAULT NULL COMMENT '开始时间',
  `end_time` int(4) DEFAULT NULL COMMENT '截止时间',
  `create_time` int(4) DEFAULT NULL,
  `update_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `addmoneycoinlog`
-- ----------------------------
DROP TABLE IF EXISTS `addmoneycoinlog`;
CREATE TABLE `addmoneycoinlog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `user_id` bigint(8) DEFAULT NULL,
  `money` bigint(8) DEFAULT NULL,
  `coin` int(4) DEFAULT NULL,
  `desc` varchar(500) DEFAULT NULL,
  `create_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=359 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `announcement`
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(11) NOT NULL COMMENT '发布人',
  `type` tinyint(4) DEFAULT '0',
  `title` varchar(100) NOT NULL,
  `status` int(11) DEFAULT '1' COMMENT '状态',
  `channel` varchar(50) DEFAULT 'def' COMMENT '道渠号:不指定渠道时默认为def',
  `content` varchar(512) NOT NULL COMMENT '内容',
  `create_time` int(11) NOT NULL COMMENT '注册时间',
  `update_time` int(11) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COMMENT='公告';

-- ----------------------------
--  Table structure for `app_modules`
-- ----------------------------
DROP TABLE IF EXISTS `app_modules`;
CREATE TABLE `app_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` tinyint(4) DEFAULT '0' COMMENT 'type_id=0，type_value=cpId；type_id=1，type_value=appId；',
  `type_value` varchar(50) DEFAULT NULL COMMENT 'type_id=0，type_value=cpId；type_id=1，type_value=appId；',
  `module_id` varchar(50) DEFAULT NULL COMMENT '模块标识',
  `closed` tinyint(4) DEFAULT '0' COMMENT '0:开放；1:关闭',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_id` (`type_id`,`type_value`,`module_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COMMENT='控制应用的功能模块是否在客户端启用';

-- ----------------------------
--  Table structure for `apps`
-- ----------------------------
DROP TABLE IF EXISTS `apps`;
CREATE TABLE `apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appName` varchar(50) DEFAULT 'xhddz',
  `package` varchar(50) DEFAULT NULL COMMENT '包名',
  `ver_last` int(11) DEFAULT '1' COMMENT '最新版本号',
  `ver` varchar(20) DEFAULT NULL,
  `memo` text COMMENT '备注',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `package` (`package`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `award`
-- ----------------------------
DROP TABLE IF EXISTS `award`;
CREATE TABLE `award` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  `type` tinyint(4) NOT NULL COMMENT '物品类型:0,话费;1,Q币;2,实物;3,元宝兑换金币',
  `coin` int(11) NOT NULL COMMENT '元宝',
  `imag` varchar(30) DEFAULT NULL,
  `num` int(4) NOT NULL COMMENT '物品总数',
  `desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `sortId` smallint(2) NOT NULL COMMENT '排序ID',
  `start_time` int(11) NOT NULL COMMENT '兑换开始时间',
  `end_time` int(11) NOT NULL COMMENT '兑换结束时间',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='奖品表';

-- ----------------------------
--  Table structure for `awardlog`
-- ----------------------------
DROP TABLE IF EXISTS `awardlog`;
CREATE TABLE `awardlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL COMMENT '玩家id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态（0：未处理，1：处理中，2：处理完毕）',
  `type` tinyint(4) NOT NULL,
  `coin` int(11) NOT NULL COMMENT '元宝',
  `award_id` int(11) NOT NULL COMMENT '奖品id',
  `qq` varchar(32) DEFAULT '0',
  `mobile` varchar(32) DEFAULT NULL COMMENT '电话(或QQ)',
  `user_id` int(11) NOT NULL COMMENT '处理人id',
  `desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4740 DEFAULT CHARSET=utf8 COMMENT='兑换记录';

-- ----------------------------
--  Table structure for `blackword`
-- ----------------------------
DROP TABLE IF EXISTS `blackword`;
CREATE TABLE `blackword` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` varchar(30) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `word` (`word`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=648 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `channel_infos`
-- ----------------------------
DROP TABLE IF EXISTS `channel_infos`;
CREATE TABLE `channel_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(50) DEFAULT NULL,
  `channel_id` varchar(50) DEFAULT '' COMMENT '推广渠道ID, cpId',
  `channel_mode` varchar(50) DEFAULT NULL COMMENT '推广模式',
  `channel_update` varchar(50) DEFAULT NULL COMMENT '更新渠道ID',
  `memo` varchar(100) DEFAULT NULL COMMENT '备注',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '日期',
  PRIMARY KEY (`id`),
  KEY `channel_name` (`channel_name`,`channel_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `cheat`
-- ----------------------------
DROP TABLE IF EXISTS `cheat`;
CREATE TABLE `cheat` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `suid` bigint(8) DEFAULT NULL COMMENT '举报人ID',
  `tuid` bigint(8) DEFAULT NULL COMMENT '被举报者ID',
  `ctype` varchar(50) DEFAULT '0' COMMENT '举报类型(0:作弊,1:色情)',
  `reply` varchar(100) DEFAULT NULL,
  `create_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38433 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `cu_points`
-- ----------------------------
DROP TABLE IF EXISTS `cu_points`;
CREATE TABLE `cu_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `point` varchar(50) DEFAULT NULL COMMENT '计费点',
  `point_name` varchar(50) DEFAULT NULL COMMENT 'boss.goods.id',
  `fee` int(11) DEFAULT '0' COMMENT '资费(分)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sdk` (`point_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='联通计费点信息';

-- ----------------------------
--  Table structure for `feedback`
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `type` int(11) NOT NULL COMMENT '类型',
  `status` int(11) NOT NULL COMMENT '状态(0 : 未处理, 1 : 已经处理)',
  `content` varchar(512) DEFAULT NULL COMMENT '反馈内容',
  `reply` varchar(512) DEFAULT NULL COMMENT '回复内容',
  `user_id` int(11) NOT NULL COMMENT '回复人',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3903 DEFAULT CHARSET=utf8 COMMENT='反馈';

-- ----------------------------
--  Table structure for `gifts`
-- ----------------------------
DROP TABLE IF EXISTS `gifts`;
CREATE TABLE `gifts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gift_id` int(11) DEFAULT NULL COMMENT '礼物id',
  `gift_name` varchar(255) DEFAULT NULL COMMENT '名称',
  `money` int(11) DEFAULT '0' COMMENT '所花金币',
  `charm` int(11) DEFAULT '0' COMMENT '魅力值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `goods`
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `status` int(11) NOT NULL COMMENT '状态',
  `rmb` int(11) NOT NULL COMMENT '价钱rmb',
  `money` int(11) NOT NULL COMMENT '所得金币',
  `give_money` int(11) NOT NULL COMMENT '多赠送金币',
  `give_coin` int(11) NOT NULL,
  `desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='商品表';

-- ----------------------------
--  Table structure for `goodslog`
-- ----------------------------
DROP TABLE IF EXISTS `goodslog`;
CREATE TABLE `goodslog` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` varchar(64) NOT NULL COMMENT '玩家id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `rmb` int(11) NOT NULL COMMENT '价钱rmb',
  `money` int(11) NOT NULL COMMENT '所得金币',
  `give_money` int(11) NOT NULL COMMENT '多赠送金币',
  `give_coin` int(11) NOT NULL,
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8 COMMENT='商品兑换记录表';

-- ----------------------------
--  Table structure for `group`
-- ----------------------------
DROP TABLE IF EXISTS `group`;
CREATE TABLE `group` (
  `id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `title` varchar(50) NOT NULL,
  `create_time` int(11) unsigned NOT NULL,
  `update_time` int(11) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sort` smallint(3) unsigned NOT NULL DEFAULT '0',
  `show` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `groups`
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` mediumint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `log_login`
-- ----------------------------
DROP TABLE IF EXISTS `log_login`;
CREATE TABLE `log_login` (
  `uid` int(11) NOT NULL DEFAULT '0',
  `verCode` smallint(6) DEFAULT '0',
  `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `uid` (`uid`),
  KEY `login_time` (`login_time`),
  KEY `uid_2` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `loginreward`
-- ----------------------------
DROP TABLE IF EXISTS `loginreward`;
CREATE TABLE `loginreward` (
  `id` smallint(2) NOT NULL AUTO_INCREMENT,
  `contday` smallint(2) NOT NULL COMMENT '连续登录天数',
  `awardtype` tinyint(4) NOT NULL COMMENT '奖励类型',
  `amount` int(4) NOT NULL COMMENT '奖励数额',
  `create_time` int(4) NOT NULL,
  `update_time` int(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `lottery`
-- ----------------------------
DROP TABLE IF EXISTS `lottery`;
CREATE TABLE `lottery` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `awardType` tinyint(4) NOT NULL COMMENT '励奖类型(0:金币,1:元宝,2:话费券,3:IPHONE5,IPAD,其他)',
  `status` tinyint(4) NOT NULL COMMENT '生效状态:1,生效;0,不生效',
  `userTypeProb` varchar(50) NOT NULL COMMENT '对应用户类型的开奖几率(5200,4300,1200...)',
  `sortInd` tinyint(4) NOT NULL COMMENT '客户端排序位置',
  `amount` varchar(50) NOT NULL COMMENT '奖励数额(2,5,15..)',
  `noticeId` smallint(2) NOT NULL DEFAULT '0',
  `desp` varchar(50) DEFAULT NULL COMMENT '奖励描述',
  `createDate` bigint(8) DEFAULT NULL,
  `updateDate` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `lotterylog`
-- ----------------------------
DROP TABLE IF EXISTS `lotterylog`;
CREATE TABLE `lotterylog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) NOT NULL COMMENT '用户ID',
  `awardType` tinyint(1) NOT NULL COMMENT '励奖类型',
  `amount` bigint(8) NOT NULL COMMENT '励奖数额',
  `hasGet` tinyint(1) NOT NULL COMMENT '否是已领取(1:YES,0:NO)',
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `luckdraw`
-- ----------------------------
DROP TABLE IF EXISTS `luckdraw`;
CREATE TABLE `luckdraw` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `awardType` tinyint(4) NOT NULL COMMENT '励奖类型(0:金币,1:元宝,2:话费券,3:IPHONE5,IPAD,其他)',
  `status` tinyint(4) NOT NULL COMMENT '生效状态:1,生效;0,不生效',
  `userTypeProb` varchar(50) NOT NULL COMMENT '对应用户类型的开奖几率(5200,4300,1200...)',
  `sortInd` tinyint(4) NOT NULL COMMENT '客户端排序位置',
  `amount` varchar(50) NOT NULL COMMENT '奖励数额(2,5,15..)',
  `extId` varchar(50) DEFAULT NULL COMMENT '扩展ID，目前仅用于标示礼物类别',
  `noticeMsg` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '通知消息',
  `desp` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '奖励描述',
  `createDate` bigint(8) DEFAULT NULL,
  `updateDate` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `message`
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `msg` varchar(500) DEFAULT NULL,
  `user_id` bigint(8) DEFAULT NULL,
  `create_time` bigint(8) DEFAULT NULL,
  `update_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `moregame`
-- ----------------------------
DROP TABLE IF EXISTS `moregame`;
CREATE TABLE `moregame` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '戏游名称',
  `desp` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '游戏描述',
  `imagPath` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'logo路径',
  `extImag` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '附属图片路径，逗号分隔',
  `url` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '下载地址',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态：0，尽请期待；1，上线',
  `size` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '包大小',
  `sortind` smallint(2) DEFAULT NULL COMMENT '展示排序，小到大',
  `ischess` tinyint(1) DEFAULT '0' COMMENT '否是棋牌游戏',
  `ver` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '当前版本',
  `dev` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '系统要求',
  `star` smallint(2) DEFAULT NULL COMMENT '星级',
  `type` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '游戏类型',
  `md5` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `packageName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '包名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
--  Table structure for `moregamelog`
-- ----------------------------
DROP TABLE IF EXISTS `moregamelog`;
CREATE TABLE `moregamelog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `pagetype` smallint(2) DEFAULT '0',
  `gameId` smallint(2) DEFAULT NULL COMMENT '目标游戏ID:0,首页;1-n,moregame对应的游戏ID',
  `etype` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '访客入口:客户端自定义',
  `uid` bigint(8) DEFAULT NULL COMMENT '访客游戏ID',
  `create_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
--  Table structure for `node`
-- ----------------------------
DROP TABLE IF EXISTS `node`;
CREATE TABLE `node` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0',
  `remark` varchar(255) DEFAULT NULL,
  `sort` smallint(6) unsigned DEFAULT NULL,
  `pid` smallint(6) unsigned NOT NULL,
  `level` tinyint(1) unsigned NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `group_id` tinyint(3) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `level` (`level`),
  KEY `pid` (`pid`),
  KEY `status` (`status`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=109 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `notice`
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `type` smallint(2) NOT NULL,
  `desc` varchar(100) NOT NULL,
  `create_time` int(4) DEFAULT NULL,
  `update_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `onplay`
-- ----------------------------
DROP TABLE IF EXISTS `onplay`;
CREATE TABLE `onplay` (
  `vid` int(11) NOT NULL COMMENT '房间ID',
  `timestamp` int(10) NOT NULL COMMENT '时间戳',
  `amount` int(11) NOT NULL COMMENT '人数',
  PRIMARY KEY (`vid`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线人数';

-- ----------------------------
--  Table structure for `pay_msg`
-- ----------------------------
DROP TABLE IF EXISTS `pay_msg`;
CREATE TABLE `pay_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rmbs` varchar(100) DEFAULT '0' COMMENT '充值的金额（元）',
  `msg` varchar(300) DEFAULT NULL COMMENT '充值成功后，广播的消息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `rmb` (`rmbs`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `pay_points`
-- ----------------------------
DROP TABLE IF EXISTS `pay_points`;
CREATE TABLE `pay_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pay_sdk_id` int(11) DEFAULT NULL COMMENT 'pay_sdk.id',
  `point` varchar(50) DEFAULT NULL COMMENT '计费点',
  `point_name` varchar(50) DEFAULT NULL COMMENT 'boss.goods.id',
  `fee` int(11) DEFAULT '0' COMMENT '资费(分)',
  `rmb` int(11) DEFAULT '0' COMMENT '资费(元)',
  `money` int(11) DEFAULT '0' COMMENT '购买金币',
  `coin` int(11) DEFAULT '0' COMMENT '元宝',
  `a` tinyint(4) DEFAULT '0' COMMENT '0|1；计费点是否超值',
  `b` tinyint(4) DEFAULT '0' COMMENT '0|1；计费点是否热销',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sdk` (`point_name`) USING BTREE,
  KEY `pay_sdk_id` (`pay_sdk_id`) USING BTREE,
  KEY `point` (`point`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=341 DEFAULT CHARSET=utf8 COMMENT='计费点信息';

-- ----------------------------
--  Table structure for `pay_sdk`
-- ----------------------------
DROP TABLE IF EXISTS `pay_sdk`;
CREATE TABLE `pay_sdk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pay_type` int(11) DEFAULT '1' COMMENT '支付类型 1=话费支付；2=充值卡；3=支付宝、银联、微信',
  `sdk` varchar(10) DEFAULT NULL COMMENT 'sdk代码',
  `sdk_name` varchar(100) DEFAULT NULL COMMENT 'sdk名称',
  `app_key` varchar(50) DEFAULT NULL COMMENT '支付appkey(appid)',
  `app_name` varchar(50) DEFAULT NULL COMMENT '应用名称',
  `corp` varchar(100) DEFAULT NULL COMMENT '公司名称',
  `cpkey` varchar(50) DEFAULT NULL COMMENT '密钥(如有)',
  `cpid` varchar(50) DEFAULT NULL COMMENT 'cp代码',
  `app_id` int(11) DEFAULT '0' COMMENT 'apps.id',
  `hot` int(11) DEFAULT '0' COMMENT '>0，表示某个计费点在做活动，该计费点充值会多加金币。',
  `memo` varchar(300) DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `app_key` (`app_key`) USING BTREE,
  KEY `sdk` (`sdk`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `pay_sdk_channel`
-- ----------------------------
DROP TABLE IF EXISTS `pay_sdk_channel`;
CREATE TABLE `pay_sdk_channel` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `pkg` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `pt_list` varchar(100) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pkg` (`pkg`,`channel`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `pay_special_config`
-- ----------------------------
DROP TABLE IF EXISTS `pay_special_config`;
CREATE TABLE `pay_special_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mmtype` tinyint(4) DEFAULT '1' COMMENT '1=SDK18的配置；2=嘻哈斗地主的开关',
  `package` varchar(50) DEFAULT NULL COMMENT '包名',
  `channel` varchar(30) DEFAULT NULL COMMENT '渠道号',
  `tm_start` datetime DEFAULT NULL COMMENT '开始时间',
  `tm_end` datetime DEFAULT NULL COMMENT '结束时间',
  `flag` tinyint(4) DEFAULT '0' COMMENT '0=all；1=商城；2=付费坑',
  `memo` text COMMENT '备注',
  `isvalid` tinyint(4) DEFAULT '1' COMMENT '1=有效配置；0=无效配置',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `package` (`package`,`channel`) USING BTREE,
  KEY `tm_start` (`tm_start`) USING BTREE,
  KEY `tm_end` (`tm_end`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `pay_special_value`
-- ----------------------------
DROP TABLE IF EXISTS `pay_special_value`;
CREATE TABLE `pay_special_value` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(30) DEFAULT NULL COMMENT '渠道号',
  `sh` varchar(100) DEFAULT NULL COMMENT '开始时间',
  `s5` varchar(100) DEFAULT NULL COMMENT '结束时间',
  `pdi` varchar(50) DEFAULT NULL,
  `sg` text,
  `aey` varchar(50) DEFAULT NULL,
  `spcode` varchar(50) DEFAULT NULL,
  `tag` varchar(100) DEFAULT NULL COMMENT '参数标记',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `payback_log`
-- ----------------------------
DROP TABLE IF EXISTS `payback_log`;
CREATE TABLE `payback_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) DEFAULT NULL,
  `order_id` varchar(50) DEFAULT NULL COMMENT '订单号',
  `ok` varchar(20) DEFAULT NULL COMMENT '支付结果; 2=支付失败 , 3=支付取消',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `payorder`
-- ----------------------------
DROP TABLE IF EXISTS `payorder`;
CREATE TABLE `payorder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `goods_id` int(11) DEFAULT '0' COMMENT '商品ID',
  `sdk` varchar(10) DEFAULT NULL COMMENT 'sdk代号',
  `order_id` varchar(30) DEFAULT NULL COMMENT '订单号',
  `success` tinyint(4) DEFAULT '0' COMMENT '0=初始订单;1=成功支付订单',
  `appkey` varchar(100) DEFAULT NULL,
  `point` varchar(100) DEFAULT NULL,
  `mac` varchar(30) DEFAULT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `vid` int(11) DEFAULT '0' COMMENT '是否vip订单',
  `rmb` int(11) DEFAULT '0',
  `money` int(11) DEFAULT '0',
  `coin` int(11) DEFAULT '0',
  `istrap` tinyint(4) DEFAULT '0' COMMENT '是否付费坑的订单',
  `pos` int(11) DEFAULT '-1',
  `trap` int(11) DEFAULT '-1',
  `money0` bigint(20) DEFAULT '0' COMMENT '玩家充值前的金币数',
  `money1` bigint(20) DEFAULT '0' COMMENT '玩家充值后的金币数',
  `rmb_fen` int(11) DEFAULT '0' COMMENT '金额(分)',
  `ccd` tinyint(4) DEFAULT '0' COMMENT '0=服务器端校验; 1=客户端校验',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`order_id`),
  KEY `order_id` (`order_id`),
  KEY `sdk` (`sdk`),
  KEY `rmb` (`rmb`),
  KEY `updated_at` (`updated_at`),
  KEY `created_at` (`created_at`),
  KEY `success` (`success`),
  KEY `uid_2` (`uid`,`goods_id`,`sdk`)
) ENGINE=InnoDB AUTO_INCREMENT=338925 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `payrecord`
-- ----------------------------
DROP TABLE IF EXISTS `payrecord`;
CREATE TABLE `payrecord` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(1) NOT NULL COMMENT '用户ID',
  `rmb` int(1) NOT NULL COMMENT '充值人民币数',
  `orderId` varchar(50) DEFAULT '0',
  `sdkId` varchar(10) DEFAULT '0',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=110221 DEFAULT CHARSET=utf8 COMMENT='充值记录表';

-- ----------------------------
--  Table structure for `payrule`
-- ----------------------------
DROP TABLE IF EXISTS `payrule`;
CREATE TABLE `payrule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `op` varchar(10) DEFAULT NULL COMMENT '运营商cu=联通，cm=移动，ct=电信',
  `type_id` tinyint(4) DEFAULT '0' COMMENT 'type_id=0，type_value=cpId；type_id=1，type_value=appId；',
  `type_value` varchar(50) DEFAULT NULL COMMENT 'type_id=0，type_value=cpId；type_id=1，type_value=appId；',
  `sdk` varchar(10) DEFAULT NULL COMMENT 'SDK代号',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_id` (`type_id`,`type_value`,`op`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='某个appid或者cpid的需要用到的支付SDK';

-- ----------------------------
--  Table structure for `pbindachtasks`
-- ----------------------------
DROP TABLE IF EXISTS `pbindachtasks`;
CREATE TABLE `pbindachtasks` (
  `uid` bigint(8) NOT NULL,
  `tinfo` varchar(500) DEFAULT NULL,
  `ginfo` varchar(500) DEFAULT NULL,
  `updatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `platforminfo`
-- ----------------------------
DROP TABLE IF EXISTS `platforminfo`;
CREATE TABLE `platforminfo` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `appName` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '应用名称',
  `packageName` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '包名',
  `iconUrl` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '游戏Icon URL',
  `apkUrl` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT 'App下载链接',
  `apkMD5` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT 'App安装包MD5',
  `status` int(4) DEFAULT NULL,
  `hot` smallint(2) DEFAULT NULL COMMENT '是否热门推荐游戏',
  `new` smallint(2) DEFAULT NULL COMMENT '是否新上架游戏',
  `isHost` smallint(2) DEFAULT '0' COMMENT '主宿',
  `sortind` smallint(2) DEFAULT NULL COMMENT '排序',
  `createtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `platformswitch`
-- ----------------------------
DROP TABLE IF EXISTS `platformswitch`;
CREATE TABLE `platformswitch` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `channel` varchar(100) DEFAULT NULL,
  `flag` int(4) DEFAULT '1' COMMENT '关开:0,关闭；1，打开',
  `desp` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `player`
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user` varchar(64) NOT NULL COMMENT '账户名',
  `channel` varchar(64) DEFAULT NULL COMMENT '联运渠道名',
  `name` varchar(64) NOT NULL COMMENT '昵称',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(64) NOT NULL COMMENT '密码salt',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  `sex` int(11) NOT NULL COMMENT '性别 2：女 1：男',
  `money` int(11) NOT NULL DEFAULT '0' COMMENT '金币',
  `rmb` int(11) NOT NULL DEFAULT '0' COMMENT '人民币',
  `coin` int(11) NOT NULL DEFAULT '0' COMMENT '元宝数',
  `avater` varchar(255) NOT NULL DEFAULT '0' COMMENT '头像URL',
  `isauto` tinyint(4) DEFAULT '1',
  `skey` varchar(64) NOT NULL COMMENT '会话session key',
  `login_days` int(11) NOT NULL DEFAULT '0' COMMENT '连续登录天数',
  `is_get` int(11) NOT NULL DEFAULT '0' COMMENT '是否领取连续登陆的奖励',
  `total_board` int(11) NOT NULL DEFAULT '0' COMMENT '玩牌总次数',
  `total_win` int(11) NOT NULL DEFAULT '0' COMMENT '胜利总次数',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `charm` bigint(8) DEFAULT '0',
  `sign` varchar(100) DEFAULT NULL,
  `heartbeat_at` int(11) NOT NULL COMMENT '最后活动时间',
  `broke_num` int(11) NOT NULL DEFAULT '0' COMMENT '破产次数',
  `broke_time` int(11) NOT NULL DEFAULT '0' COMMENT '破产时间',
  `create_time` int(11) NOT NULL COMMENT '注册时间',
  `update_time` int(11) DEFAULT NULL COMMENT '登录时间',
  PRIMARY KEY (`id`),
  KEY `create_time` (`create_time`),
  KEY `update_time` (`update_time`),
  KEY `heartbeat_at` (`heartbeat_at`)
) ENGINE=InnoDB AUTO_INCREMENT=587035 DEFAULT CHARSET=utf8 COMMENT='游戏玩家表';

-- ----------------------------
--  Table structure for `player_has_moblie`
-- ----------------------------
DROP TABLE IF EXISTS `player_has_moblie`;
CREATE TABLE `player_has_moblie` (
  `id` int(8) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `rmb` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `playerext`
-- ----------------------------
DROP TABLE IF EXISTS `playerext`;
CREATE TABLE `playerext` (
  `uid` bigint(8) NOT NULL,
  `mob` varchar(20) DEFAULT '0',
  `telCharge` int(4) DEFAULT '0' COMMENT '当前话费券',
  `vipenddate` bigint(8) DEFAULT NULL,
  `avatar` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `giftinfo` varchar(200) DEFAULT NULL,
  `tasksAch` varchar(1000) DEFAULT NULL,
  `hasRecharge` int(4) DEFAULT NULL,
  `modifyName` int(4) DEFAULT NULL,
  `updateDate` datetime NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `playermark`
-- ----------------------------
DROP TABLE IF EXISTS `playermark`;
CREATE TABLE `playermark` (
  `uid` bigint(8) NOT NULL,
  `cpId` varchar(50) CHARACTER SET gbk DEFAULT NULL COMMENT '渠道ID',
  `appId` varchar(50) CHARACTER SET gbk DEFAULT NULL COMMENT '版本号',
  `imsi` varchar(50) CHARACTER SET gbk DEFAULT NULL COMMENT 'sim卡序列号',
  `imei` varchar(50) CHARACTER SET gbk DEFAULT NULL COMMENT '手机序列号',
  `mtype` varchar(50) CHARACTER SET gbk DEFAULT NULL COMMENT '手机型号',
  `reg_ver` smallint(6) DEFAULT '1' COMMENT '注册时的版本号',
  `cur_ver` smallint(6) DEFAULT '0' COMMENT '当前的版本号',
  `last_channel` varchar(50) DEFAULT NULL,
  `last_time` bigint(8) DEFAULT NULL,
  `package` varchar(50) CHARACTER SET gbk DEFAULT NULL COMMENT '应用包名',
  `mac` varchar(30) CHARACTER SET gbk DEFAULT NULL COMMENT 'mac地址',
  `create_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  KEY `uid_2` (`uid`,`cur_ver`),
  KEY `uid_3` (`uid`,`reg_ver`,`cur_ver`),
  KEY `uid` (`uid`,`create_time`) USING BTREE,
  KEY `package` (`package`,`cpId`) USING BTREE,
  KEY `uid_4` (`uid`),
  KEY `cpId` (`cpId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `rank`
-- ----------------------------
DROP TABLE IF EXISTS `rank`;
CREATE TABLE `rank` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` int(11) NOT NULL COMMENT '类型（0 : 财富榜 1 : 达人榜 2 : 潜力榜）',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '昵称',
  `sex` int(11) NOT NULL COMMENT '性别',
  `no` int(11) NOT NULL COMMENT '名次',
  `amount` int(11) NOT NULL COMMENT '数值',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COMMENT='排行表';

-- ----------------------------
--  Table structure for `rank_info`
-- ----------------------------
DROP TABLE IF EXISTS `rank_info`;
CREATE TABLE `rank_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank` varchar(50) DEFAULT NULL COMMENT '等级名称',
  `minExp` int(11) DEFAULT '0' COMMENT '最小经验值',
  `maxExp` int(11) DEFAULT '0' COMMENT '最大经验值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `pid` smallint(6) DEFAULT NULL,
  `status` tinyint(1) unsigned DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `ename` varchar(5) DEFAULT NULL,
  `create_time` int(11) unsigned NOT NULL,
  `update_time` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parentId` (`pid`) USING BTREE,
  KEY `ename` (`ename`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `role_user`
-- ----------------------------
DROP TABLE IF EXISTS `role_user`;
CREATE TABLE `role_user` (
  `role_id` mediumint(9) unsigned DEFAULT NULL,
  `user_id` char(32) DEFAULT NULL,
  KEY `group_id` (`role_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `share_click_log`
-- ----------------------------
DROP TABLE IF EXISTS `share_click_log`;
CREATE TABLE `share_click_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `sms` int(4) DEFAULT NULL,
  `qq` int(4) DEFAULT NULL,
  `wx` int(4) DEFAULT NULL,
  `wb` int(4) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `share_log`
-- ----------------------------
DROP TABLE IF EXISTS `share_log`;
CREATE TABLE `share_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `isReward` tinyint(1) DEFAULT NULL,
  `shareType` varchar(20) COLLATE utf8_unicode_ci DEFAULT '0' COMMENT '分享类型:wx，微信朋友圈；wb，微博；qq，QQ空间..',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2009 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
--  Table structure for `signin`
-- ----------------------------
DROP TABLE IF EXISTS `signin`;
CREATE TABLE `signin` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `awardItem` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '奖励明细(0:100,1:200,2:5,逗号分隔奖项，分号分隔奖励类型和数额)，奖励类型-0：金币,1：元宝,2：礼物,3：魅力值,4：经验值',
  `signType` tinyint(1) DEFAULT '0' COMMENT '签到奖励类型:0,连续签到；1，累积签到;2,VIP每日签到',
  `signTotal` smallint(2) DEFAULT NULL COMMENT '完成条件(天数)',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
--  Table structure for `signin_log`
-- ----------------------------
DROP TABLE IF EXISTS `signin_log`;
CREATE TABLE `signin_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT '0' COMMENT '用户ID',
  `signintype` int(4) DEFAULT '0' COMMENT '奖领类型:0,连续签到；1，vip领奖;2,累计签到',
  `signintotal` int(4) DEFAULT NULL,
  `awardmoney` int(4) DEFAULT '0' COMMENT '奖励的金币',
  `awardcoin` int(4) DEFAULT '0' COMMENT '奖励的元宝',
  `awardexp` int(4) DEFAULT '0' COMMENT '励奖的经验',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `slot`
-- ----------------------------
DROP TABLE IF EXISTS `slot`;
CREATE TABLE `slot` (
  `id` smallint(2) NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL,
  `odds` smallint(2) NOT NULL,
  `prob` smallint(2) NOT NULL,
  `desc` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `speaker`
-- ----------------------------
DROP TABLE IF EXISTS `speaker`;
CREATE TABLE `speaker` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `msg` varchar(200) DEFAULT NULL,
  `create_time` int(4) DEFAULT NULL,
  `update_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `stat_flag_name`
-- ----------------------------
DROP TABLE IF EXISTS `stat_flag_name`;
CREATE TABLE `stat_flag_name` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `flag` varchar(30) DEFAULT NULL,
  `desc` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `stat_player_act_log`
-- ----------------------------
DROP TABLE IF EXISTS `stat_player_act_log`;
CREATE TABLE `stat_player_act_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) NOT NULL,
  `t1` int(4) DEFAULT '0' COMMENT '场馆1玩牌次数',
  `t2` int(4) DEFAULT '0',
  `t3` int(4) DEFAULT '0',
  `t4` int(4) DEFAULT '0',
  `t5` int(4) DEFAULT '0',
  `t6` int(4) DEFAULT '0',
  `t7` int(4) DEFAULT NULL,
  `t8` int(4) DEFAULT '0' COMMENT '场馆1胜局次数',
  `log_day` date DEFAULT NULL COMMENT '日志记录日期',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=189603 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
--  Table structure for `stat_temp_func`
-- ----------------------------
DROP TABLE IF EXISTS `stat_temp_func`;
CREATE TABLE `stat_temp_func` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) DEFAULT '0' COMMENT '统计类型：0元宝统计,1金币统计,2功能使用统计(人数去重),3功能使用统计(人次)',
  `flag` varchar(30) DEFAULT NULL,
  `val` bigint(8) DEFAULT '0' COMMENT '前值当',
  `createtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30027 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `tasksawardlog`
-- ----------------------------
DROP TABLE IF EXISTS `tasksawardlog`;
CREATE TABLE `tasksawardlog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) NOT NULL,
  `taskid` int(4) NOT NULL,
  `awardtype` tinyint(1) NOT NULL,
  `awardamount` int(4) NOT NULL,
  `create_time` int(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125298 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `tasksconf`
-- ----------------------------
DROP TABLE IF EXISTS `tasksconf`;
CREATE TABLE `tasksconf` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `ttype` tinyint(4) NOT NULL COMMENT '任务类型',
  `finishnum` int(4) NOT NULL COMMENT '完成条件',
  `awardtype` tinyint(4) NOT NULL COMMENT '奖励类型',
  `awardmount` int(4) NOT NULL COMMENT '奖励数额',
  `title` varchar(20) DEFAULT NULL COMMENT '称号',
  `desc` varchar(50) NOT NULL COMMENT '描述',
  `create_time` bigint(8) DEFAULT NULL,
  `update_time` bigint(8) DEFAULT NULL,
  `finishtype` smallint(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `trap_apptype`
-- ----------------------------
DROP TABLE IF EXISTS `trap_apptype`;
CREATE TABLE `trap_apptype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `apptype` int(11) DEFAULT NULL,
  `package` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `package` (`package`,`channel`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `trap_info`
-- ----------------------------
DROP TABLE IF EXISTS `trap_info`;
CREATE TABLE `trap_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `apptype` int(11) DEFAULT '1' COMMENT 'apptype区分不同需求的坑设置。',
  `pos` int(11) NOT NULL COMMENT '游戏位置ID，该位置设坑',
  `pos_name` varchar(50) DEFAULT NULL COMMENT '位置说明',
  `trap` int(11) NOT NULL COMMENT '当前位置所执行的动作，坑',
  `trap_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=主动呼出；2=被动拦截；3=特惠',
  `trap_desc` varchar(300) DEFAULT NULL COMMENT '动作说明',
  `sdk` varchar(10) NOT NULL COMMENT 'sdk代码',
  `rmb` int(11) NOT NULL COMMENT '价格（元）',
  `money` int(11) DEFAULT '0' COMMENT '充值后的金币',
  `coin` int(11) DEFAULT '0' COMMENT '元宝',
  `img` varchar(20) DEFAULT NULL COMMENT '图片ID',
  `isgoods` tinyint(4) DEFAULT '0' COMMENT '更多商品的开关：0=关；1=开',
  `isopen` tinyint(4) DEFAULT '1' COMMENT '这个坑是否有效：1=有效；0=无效',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `apptype` (`apptype`,`pos`,`trap`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `account` varchar(64) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `password` char(32) NOT NULL,
  `bind_account` varchar(50) NOT NULL,
  `last_login_time` int(11) unsigned DEFAULT '0',
  `last_login_ip` varchar(40) DEFAULT NULL,
  `login_count` mediumint(8) unsigned DEFAULT '0',
  `verify` varchar(32) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `remark` varchar(255) NOT NULL,
  `create_time` int(11) unsigned NOT NULL,
  `update_time` int(11) unsigned NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  `type_id` tinyint(2) unsigned DEFAULT '0',
  `info` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account` (`account`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `venue`
-- ----------------------------
DROP TABLE IF EXISTS `venue`;
CREATE TABLE `venue` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(64) NOT NULL COMMENT '房间名称',
  `status` int(11) NOT NULL COMMENT '状态',
  `base_money` int(11) NOT NULL COMMENT '底注',
  `min_money` int(11) NOT NULL COMMENT '金币值(最小限入)',
  `max_money` int(11) NOT NULL COMMENT '金币值(最大限入)',
  `ip` varchar(64) NOT NULL COMMENT 'IP',
  `port` int(11) NOT NULL COMMENT '端口',
  `onplay` int(11) DEFAULT '0' COMMENT '在线人数',
  `vtype` int(4) DEFAULT '0' COMMENT '馆场类型(客户端标识):0,普通场;1,癞子场;2,比赛场',
  `game_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '额外玩法:0，普通；1，元宝任务；2，癞子玩法',
  `is_pcheat` tinyint(4) DEFAULT '0',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='场馆表';

-- ----------------------------
--  Table structure for `vips`
-- ----------------------------
DROP TABLE IF EXISTS `vips`;
CREATE TABLE `vips` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `days` int(4) DEFAULT NULL,
  `gid` int(4) DEFAULT NULL COMMENT 'goods id',
  `rmb` int(4) DEFAULT NULL,
  `give_money` bigint(8) DEFAULT NULL,
  `desp` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `sdk` varchar(10) DEFAULT '01',
  `create_time` bigint(8) DEFAULT NULL,
  `update_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Table structure for `vipslog`
-- ----------------------------
DROP TABLE IF EXISTS `vipslog`;
CREATE TABLE `vipslog` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `vid` int(4) DEFAULT NULL,
  `rmb` int(4) DEFAULT NULL,
  `create_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=gbk;

-- ----------------------------
--  Triggers structure for table payorder
-- ----------------------------
DROP TRIGGER IF EXISTS `t_stat_user_daily_order_upd`;
delimiter ;;
CREATE TRIGGER `t_stat_user_daily_order_upd` AFTER UPDATE ON `payorder` FOR EACH ROW BEGIN
	
	 
	DECLARE t_count INT;
	DECLARE trmb INT ; 
	DECLARE vdt DATE ;
	
	DECLARE vvrmb INT ; 
	 
	SET vvrmb = new.rmb ;
	SET trmb = 0;	
	SET t_count = 0;
	SET vdt = CURDATE() ;
	
	IF (new.success = 1 AND old.success = 0) THEN		 
	    SELECT COUNT(0) INTO t_count FROM cms.stat_user_daily_order WHERE uid=new.uid AND dt=vdt ;		
	    SELECT total_rmb INTO trmb FROM cms.stat_user_daily_order WHERE uid=new.uid AND dt<=vdt ORDER BY dt DESC LIMIT 1 ;
	    
	    IF (new.goods_id > 0 AND vvrmb<=0) THEN
	       SELECT rmb into @goods_rmb FROM goods WHERE id=new.goods_id ;
	       IF (@goods_rmb > 0) THEN
	           SET vvrmb=@goods_rmb ;
	       END IF ;
	    END IF ;
	    
	    IF t_count = 0 THEN
	    	INSERT INTO cms.stat_user_daily_order(uid, dt, rmb, total_rmb ) VALUES (new.uid, vdt, vvrmb, vvrmb + IFNULL(trmb,0) ) ;
	    ELSE
	    	UPDATE cms.stat_user_daily_order SET rmb=rmb + vvrmb, total_rmb=total_rmb + vvrmb WHERE uid=new.uid AND dt=vdt;
	    END IF;
	    
	END IF;
	
    END
 ;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
