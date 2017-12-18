/*
Navicat MySQL Data Transfer

Source Server         : 121.40.68.234_3306
Source Server Version : 50538
Source Host           : 121.40.68.234:3306
Source Database       : bullfighting

Target Server Type    : MYSQL
Target Server Version : 50538
File Encoding         : 65001

Date: 2017-02-08 16:47:00
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for access
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
-- Records of access
-- ----------------------------
INSERT INTO `access` VALUES ('3', '85', '2', '84', null);
INSERT INTO `access` VALUES ('3', '86', '2', '84', null);
INSERT INTO `access` VALUES ('3', '89', '2', '84', null);
INSERT INTO `access` VALUES ('3', '90', '2', '84', null);
INSERT INTO `access` VALUES ('3', '91', '2', '84', null);
INSERT INTO `access` VALUES ('3', '92', '2', '84', null);
INSERT INTO `access` VALUES ('3', '93', '2', '84', null);
INSERT INTO `access` VALUES ('3', '95', '2', '84', null);
INSERT INTO `access` VALUES ('3', '99', '2', '84', null);
INSERT INTO `access` VALUES ('3', '84', '1', '0', null);
INSERT INTO `access` VALUES ('3', '2', '2', '1', null);
INSERT INTO `access` VALUES ('3', '6', '2', '1', null);
INSERT INTO `access` VALUES ('3', '7', '2', '1', null);
INSERT INTO `access` VALUES ('3', '40', '2', '1', null);

-- ----------------------------
-- Table structure for activityaward
-- ----------------------------
DROP TABLE IF EXISTS `activityaward`;
CREATE TABLE `activityaward` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `activityid` int(4) DEFAULT NULL COMMENT '活动ID',
  `sortnum` int(4) DEFAULT NULL COMMENT '排名',
  `awardlimit` int(4) DEFAULT NULL,
  `awardtype` tinyint(4) DEFAULT NULL COMMENT '奖励类型:0,金币;1,元宝',
  `awardamount` bigint(8) DEFAULT NULL COMMENT '奖励金额',
  `desc` varchar(50) DEFAULT NULL COMMENT '奖品描述',
  `create_time` int(4) DEFAULT NULL,
  `update_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of activityaward
-- ----------------------------
INSERT INTO `activityaward` VALUES ('1', '2', '1', null, '2', '1', '苹果5S', '1389940250', '1390206342');
INSERT INTO `activityaward` VALUES ('2', '2', '2', null, '3', '1', '三星S4', '1389940320', '1390206364');
INSERT INTO `activityaward` VALUES ('3', '2', '3', null, '4', '1', 'IPAD mini 2', '1389940320', '1390206384');
INSERT INTO `activityaward` VALUES ('4', '2', '4', null, '5', '1', '佳能数码相机', '1389940320', '1390206423');
INSERT INTO `activityaward` VALUES ('5', '2', '5', null, '6', '1', '小米手机', '1389940320', '1390206448');
INSERT INTO `activityaward` VALUES ('6', '2', '6', null, '1', '5000', '元宝', '1390205720', '1390206477');
INSERT INTO `activityaward` VALUES ('7', '2', '7', null, '1', '2500', '元宝', '1390205732', '1390206488');
INSERT INTO `activityaward` VALUES ('8', '2', '8', null, '1', '2500', '元宝', '1390205757', '1390206500');
INSERT INTO `activityaward` VALUES ('9', '2', '9', null, '1', '2000', '元宝', '1390205783', '1390206573');
INSERT INTO `activityaward` VALUES ('10', '2', '10', null, '1', '1500', '元宝', '1390205796', '1390206558');
INSERT INTO `activityaward` VALUES ('11', '1', '1', null, '1', '368', '元宝', '1390205818', '1390206656');
INSERT INTO `activityaward` VALUES ('12', '1', '2', null, '1', '368', '元宝', '1390205831', '1390206669');
INSERT INTO `activityaward` VALUES ('13', '1', '3', null, '1', '368', '元宝', '1390205843', '1390206683');
INSERT INTO `activityaward` VALUES ('14', '1', '4', null, '1', '288', '元宝', '1390205854', '1390206743');
INSERT INTO `activityaward` VALUES ('15', '1', '5', null, '1', '288', '元宝', '1390205879', '1390206753');
INSERT INTO `activityaward` VALUES ('16', '1', '6', null, '1', '288', '元宝', '1390205903', '1390206764');
INSERT INTO `activityaward` VALUES ('17', '1', '7', null, '1', '166', '元宝', '1390205912', '1390207801');
INSERT INTO `activityaward` VALUES ('18', '1', '8', null, '1', '166', '元宝', '1390205923', '1390207812');
INSERT INTO `activityaward` VALUES ('19', '1', '9', null, '1', '166', '元宝', '1390205938', '1390207821');
INSERT INTO `activityaward` VALUES ('20', '1', '10', null, '1', '166', '元宝', '1390205954', '1390207829');
INSERT INTO `activityaward` VALUES ('21', '1', '11', null, '0', '10000', '金币', '1390207994', '1390207994');
INSERT INTO `activityaward` VALUES ('22', '1', '12', null, '0', '10000', '金币', '1390208005', '1390208005');
INSERT INTO `activityaward` VALUES ('23', '1', '13', null, '0', '10000', '金币', '1390208020', '1390208020');
INSERT INTO `activityaward` VALUES ('24', '1', '14', null, '0', '10000', '金币', '1390208033', '1390208033');
INSERT INTO `activityaward` VALUES ('25', '1', '15', null, '0', '10000', '金币', '1390208050', '1390209437');
INSERT INTO `activityaward` VALUES ('26', '4', '1', null, '1', '188', '元宝', '1395391558', '1395391622');
INSERT INTO `activityaward` VALUES ('27', '4', '2', null, '1', '88', '元宝', '1395391569', '1395391632');
INSERT INTO `activityaward` VALUES ('28', '4', '3', null, '1', '66', '元宝', '1395391576', '1395391642');
INSERT INTO `activityaward` VALUES ('29', '5', '1', null, '1', '388', '元宝', '1395391576', '1395814973');
INSERT INTO `activityaward` VALUES ('30', '5', '2', null, '1', '288', '元宝', '1395391576', '1395814982');
INSERT INTO `activityaward` VALUES ('31', '5', '3', null, '1', '188', '元宝', '1395391576', '1395814995');
INSERT INTO `activityaward` VALUES ('32', '6', '1', null, '1', '188', '元宝', '1395391576', '1395815006');
INSERT INTO `activityaward` VALUES ('33', '6', '2', null, '1', '88', '元宝', '1395391576', '1395815014');
INSERT INTO `activityaward` VALUES ('34', '6', '3', null, '1', '66', '元宝', '1395391576', '1395815044');
INSERT INTO `activityaward` VALUES ('36', '7', '1', '100', '1', '50', '元宝', '1395391576', '1395391576');
INSERT INTO `activityaward` VALUES ('37', '7', '2', '50', '1', '25', '元宝', '1395391576', '1395391576');
INSERT INTO `activityaward` VALUES ('38', '7', '3', '20', '1', '10', '元宝', '1395391576', '1395391576');

-- ----------------------------
-- Table structure for activityawardlog
-- ----------------------------
DROP TABLE IF EXISTS `activityawardlog`;
CREATE TABLE `activityawardlog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `activityid` int(4) DEFAULT NULL,
  `sortid` int(4) DEFAULT NULL,
  `awardtype` tinyint(4) DEFAULT NULL,
  `awardamount` bigint(8) DEFAULT NULL,
  `curramount` bigint(8) DEFAULT NULL COMMENT '中奖时的值',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of activityawardlog
-- ----------------------------

-- ----------------------------
-- Table structure for activityconf
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of activityconf
-- ----------------------------
INSERT INTO `activityconf` VALUES ('1', '0', '0', '一马当先', '每日统计所有玩家总的赢利额，进行排名(最低8000金币)，排名前十的玩家将获得丰厚奖励.<br/>\r\n活动奖励：每天赢利榜前十名即可获奖<br/>\r\n第1-3名：368元宝<br/>\r\n第4-6名：288元宝<br/>\r\n第7-10名：166元宝<br/>\r\n第10-15名：10000金币<br/>\r\n排名会在每日24:00结算,奖品由系统自动发放,届时将有系统消息通知,敬请关注!\r\n', 'activity_1.jpg', '0', '1000', '1390060800', '1393171320', '1389939916', '1393904441');
INSERT INTO `activityconf` VALUES ('2', '1', '0', '马到成功', '活动期间内统计所有玩家赢利总额，进行排名(最低50000金币)，排名前十的玩家将获得丰厚奖励.<br/>\r\n活动奖励：每天赢利榜前十名即可获奖<br/>\r\n第1名：苹果5S手机一部（土豪金）<br/>\r\n第2名：三星S4手机一部<br/>\r\n第3名：IPAD mini2一部<br/>\r\n第5名：佳能数码相机一部<br/>\r\n第6名：小米手机一部<br/>\r\n第7名：元宝5000<br/>\r\n第8名：元宝2500<br/>\r\n第9名：元宝2000<br/>\r\n第10名：元宝1500<br/>\r\n最终排名会在2014年2月24日结算,奖品由客服联系送出,届时将有系统消息通知,敬请关注!<br/>', 'activity_2.jpg', '1', '1000', '1390060800', '1393171320', '1389940189', '1393904578');
INSERT INTO `activityconf` VALUES ('3', '5', '1', '首充翻倍', '    首次充值，好礼相送！只要你充我们就送，首次充值，金币元宝双倍送！充值金额越多，优惠力度越大！机会仅此一次，赶紧行动吧！', 'activity_3.jpg', '-1', '1', '0', '1515513600', '1390204786', '1393904558');
INSERT INTO `activityconf` VALUES ('4', '2', '0', '土豪炸翻天', '活动内容：每日统计所有玩家单局最高倍率，进行排名（最低48倍计入），排名前三的玩家将获得丰厚奖励.（倍率相同，则按照单日赢牌局数多少排序）\r\n活动奖励：每天倍率榜前三名即可获奖\r\n第1名：188元宝\r\n第2名：88元宝\r\n第3名：66元宝\r\n排名会在每日24:00结算,奖品由系统自动发放,届时将有系统消息通知,敬请关注!', 'activity_4.jpg', '0', '50', '1397752200', '1397924400', '1395391401', '1395819074');
INSERT INTO `activityconf` VALUES ('5', '3', '0', '我为“斗”狂', '活动内容：统计所有玩家日赢局总数，进行排名（最低20局计入），排名前三的玩家将获得丰厚奖励.\r\n第1名：188元宝\r\n第2名：88元宝\r\n第3名：66元宝\r\n排名会在每日24:00结算,奖品由系统自动发放,届时将有系统消息通知,敬请关注!\r\n', 'activity_5.jpg', '0', '20', '1396542600', '1396887600', '1395391401', '1395819270');
INSERT INTO `activityconf` VALUES ('6', '4', '0', '日进斗金', '活动内容：每日统计所有玩家单局赢取最高金币数，进行排名（最低1万计入），排名前三的玩家将获得丰厚奖励.（单局赢取金币数目相同，则按照单日赢牌总局数多少排序）\r\n活动奖励：每天单局盈利榜前三名即可获奖\r\n第1名：188元宝\r\n第2名：88元宝\r\n第3名：66元宝\r\n排名会在每日24:00结算,奖品由系统自动发放,届时将有系统消息通知,敬请关注!', 'activity_6.jpg', '0', '10000', '1397145600', '1397404800', '1395391401', '1395819519');
INSERT INTO `activityconf` VALUES ('7', '6', '1', '劳动光荣', '活动期间，只要你来就有机会获得丰厚元宝奖励，任意场馆赢取的局数（胜局数每天0点重置）达到一定数额，即可获得大量元宝奖励：</br>胜20局：10元宝</br>胜50局：25元宝</br>胜100局：50元宝</br>满足对局要求后，系统自动发放奖励，届时会有系统消息通知，敬请留意！机不可失，亲，赶紧来参加吧。', 'activity_7.jpg', '0', '0', '1397145600', '1515513600', '1395391401', '1395391401');

-- ----------------------------
-- Table structure for addmoneycoinlog
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
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of addmoneycoinlog
-- ----------------------------
INSERT INTO `addmoneycoinlog` VALUES ('1', '10000', '1', '500000', '0', '', '1406192717');
INSERT INTO `addmoneycoinlog` VALUES ('2', '56', '1', '100', '0', '', '1407236753');
INSERT INTO `addmoneycoinlog` VALUES ('3', '56', '1', '40', '0', '', '1407236753');
INSERT INTO `addmoneycoinlog` VALUES ('4', '56', '1', '300', '0', '', '1407237304');
INSERT INTO `addmoneycoinlog` VALUES ('5', '10191', '1', '-1800', '0', '', '1407237723');
INSERT INTO `addmoneycoinlog` VALUES ('6', '10191', '1', '-700', '0', '', '1407237820');
INSERT INTO `addmoneycoinlog` VALUES ('7', '10182', '1', '100000', '0', '', '1407301111');
INSERT INTO `addmoneycoinlog` VALUES ('8', '46', '1', '150000', '0', '', '1407305306');
INSERT INTO `addmoneycoinlog` VALUES ('9', '46', '1', '1250000', '0', '', '1407305306');
INSERT INTO `addmoneycoinlog` VALUES ('10', '46', '1', '4500000', '0', '', '1407305306');
INSERT INTO `addmoneycoinlog` VALUES ('11', '46', '1', '450000', '0', '', '1407305306');
INSERT INTO `addmoneycoinlog` VALUES ('12', '50', '1', '-700', '0', '', '1407308320');
INSERT INTO `addmoneycoinlog` VALUES ('13', '50', '1', '700', '0', '', '1407308320');
INSERT INTO `addmoneycoinlog` VALUES ('14', '50', '1', '100', '0', '', '1407308320');
INSERT INTO `addmoneycoinlog` VALUES ('15', '49', '1', '260', '0', '', '1407311507');
INSERT INTO `addmoneycoinlog` VALUES ('16', '49', '1', '2900', '0', '', '1407312389');
INSERT INTO `addmoneycoinlog` VALUES ('17', '49', '1', '28000', '0', '', '1407312881');
INSERT INTO `addmoneycoinlog` VALUES ('18', '49', '1', '2000', '0', '', '1407312924');
INSERT INTO `addmoneycoinlog` VALUES ('19', '49', '1', '280000', '0', '', '1407312924');
INSERT INTO `addmoneycoinlog` VALUES ('20', '49', '1', '1280000', '0', '', '1407312924');
INSERT INTO `addmoneycoinlog` VALUES ('21', '49', '1', '5280000', '0', '', '1407312924');
INSERT INTO `addmoneycoinlog` VALUES ('22', '10216', '1', '500000', '0', '', '1407460514');
INSERT INTO `addmoneycoinlog` VALUES ('23', '10216', '1', '500000', '0', '', '1407460708');
INSERT INTO `addmoneycoinlog` VALUES ('24', '10232', '1', '0', '10000', '', '1407478219');
INSERT INTO `addmoneycoinlog` VALUES ('25', '10232', '1', '500000', '0', '', '1407480052');
INSERT INTO `addmoneycoinlog` VALUES ('26', '10255', '1', '3000', '0', '', '1407738822');
INSERT INTO `addmoneycoinlog` VALUES ('27', '10259', '1', '3000', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('28', '10259', '1', '1200', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('29', '10259', '1', '30000', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('30', '10259', '1', '300000', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('31', '10259', '1', '100000', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('32', '10259', '1', '200000', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('33', '10259', '1', '1250000', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('34', '10259', '1', '5000000', '0', '', '1407739246');
INSERT INTO `addmoneycoinlog` VALUES ('35', '10258', '1', '3000', '0', '', '1407740378');
INSERT INTO `addmoneycoinlog` VALUES ('36', '10258', '1', '30000', '0', '', '1407740378');
INSERT INTO `addmoneycoinlog` VALUES ('37', '10258', '1', '10000', '0', '', '1407740378');
INSERT INTO `addmoneycoinlog` VALUES ('38', '10258', '1', '280000', '0', '', '1407740378');
INSERT INTO `addmoneycoinlog` VALUES ('39', '10258', '1', '1300000', '0', '', '1407740378');
INSERT INTO `addmoneycoinlog` VALUES ('40', '10258', '1', '6000000', '0', '', '1407740378');
INSERT INTO `addmoneycoinlog` VALUES ('41', '56', '1', '550', '0', '', '1407743228');
INSERT INTO `addmoneycoinlog` VALUES ('42', '56', '1', '-900', '0', '', '1407743228');
INSERT INTO `addmoneycoinlog` VALUES ('43', '56', '1', '200', '0', '', '1407743228');
INSERT INTO `addmoneycoinlog` VALUES ('44', '10259', '1', '100000', '0', '', '1407745638');
INSERT INTO `addmoneycoinlog` VALUES ('45', '10291', '1', '50000', '0', '', '1407825813');
INSERT INTO `addmoneycoinlog` VALUES ('46', '10291', '1', '50000', '0', '', '1407825862');
INSERT INTO `addmoneycoinlog` VALUES ('47', '10297', '1', '5000', '0', '', '1407832122');
INSERT INTO `addmoneycoinlog` VALUES ('48', '10297', '1', '0', '10000', '', '1407832148');
INSERT INTO `addmoneycoinlog` VALUES ('49', '10269', '1', '500000', '0', '', '1407832490');
INSERT INTO `addmoneycoinlog` VALUES ('50', '10694', '1', '50', '0', '', '1407998367');
INSERT INTO `addmoneycoinlog` VALUES ('51', '10694', '1', '300', '0', '', '1407998367');
INSERT INTO `addmoneycoinlog` VALUES ('52', '10694', '1', '200', '0', '', '1407998367');
INSERT INTO `addmoneycoinlog` VALUES ('53', '10234', '1', '100', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('54', '10234', '1', '180', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('55', '10234', '1', '20', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('56', '10234', '1', '300', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('57', '10234', '1', '170', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('58', '10234', '1', '300', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('59', '10234', '1', '3000', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('60', '10234', '1', '30000', '0', '', '1408067571');
INSERT INTO `addmoneycoinlog` VALUES ('61', '10991', '1', '30000', '0', '', '1408069551');
INSERT INTO `addmoneycoinlog` VALUES ('62', '10232', '1', '36136', '0', '', '1408341851');
INSERT INTO `addmoneycoinlog` VALUES ('63', '10233', '1', '568009', '0', '', '1408341882');
INSERT INTO `addmoneycoinlog` VALUES ('64', '10233', '1', '990', '0', '', '1408341882');
INSERT INTO `addmoneycoinlog` VALUES ('65', '10233', '1', '1500', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('66', '10233', '1', '1500', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('67', '10233', '1', '1500', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('68', '10233', '1', '1000', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('69', '10233', '1', '3700', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('70', '10233', '1', '1700', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('71', '10233', '1', '2600', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('72', '10233', '1', '1000', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('73', '10233', '1', '700', '0', '', '1408344932');
INSERT INTO `addmoneycoinlog` VALUES ('74', '12104', '1', '100000', '0', '', '1408347965');
INSERT INTO `addmoneycoinlog` VALUES ('75', '12104', '1', '20000', '0', '', '1408349110');
INSERT INTO `addmoneycoinlog` VALUES ('76', '11113', '1', '2000000', '0', '', '1408438029');
INSERT INTO `addmoneycoinlog` VALUES ('77', '10166', '1', '100000', '0', '', '1408501294');
INSERT INTO `addmoneycoinlog` VALUES ('78', '10166', '1', '3000001', '1', '', '1408501294');

-- ----------------------------
-- Table structure for agent_log_201608
-- ----------------------------
DROP TABLE IF EXISTS `agent_log_201608`;
CREATE TABLE `agent_log_201608` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT '0' COMMENT '玩家ID',
  `tid` smallint(2) DEFAULT NULL COMMENT '桌牌ID',
  `vid` tinyint(1) DEFAULT NULL COMMENT '场馆ID',
  `type` varchar(50) COLLATE utf8_unicode_ci DEFAULT '0' COMMENT '类型:game,gift,cry,brokeGet,slot,tasks...',
  `flag` smallint(2) DEFAULT '0' COMMENT '0-money,1-coin...',
  `action` tinyint(1) DEFAULT '0' COMMENT '0-ADD,1-SUB',
  `cur_val` bigint(8) DEFAULT NULL COMMENT '前值当',
  `diff_val` bigint(8) DEFAULT NULL COMMENT '变动的值',
  `create_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=381297 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态:0,未生效;1,生效',
  `title` varchar(100) NOT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '内容',
  `channel` varchar(50) DEFAULT NULL,
  `start_time` int(11) DEFAULT NULL,
  `end_time` int(11) DEFAULT NULL,
  `create_time` int(11) NOT NULL COMMENT '注册时间',
  `update_time` int(11) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COMMENT='公告';

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES ('23', '0', '公告测试', '<h1 class=\"title\" style=\"margin: 0px; padding: 0px; font-size: 26px; font-weight: normal; line-height: 55px; font-family: &#39;microsoft yahei&#39;; text-align: left;\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;《斗牛》超级VIP会员</h1><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; font-size: 12px; line-height: 18px; color: rgb(172, 172, 172);\"><br/></p><p>尊敬的玩家们：<br/><br/>&nbsp; &nbsp; &nbsp;成为《斗牛》超级VIP会员可享受给力优惠！只要您累计充值达到<span style=\"color: rgb(241, 11, 0);\"><strong>1000元</strong></span>即可成为超级VIP会员！您可以添加我们的专属美女运营官QQ进行专属的优质服务！并获得专属的<span style=\"color: rgb(241, 11, 0);\">超级</span><strong><span style=\"color: rgb(241, 11, 0);\">会员礼包</span></strong>！以及后续优惠的福利哦！赶快加入吧O(∩_∩)O。（<span style=\"color: rgb(241, 11, 0);\">满足金额可先联系客服人员进行核实，后续将会推出超级会员功能，大家可在游戏内即可查看到！</span>）<br/></p><p>------------------------------------------------------------------------------</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<span style=\"font-size: 24px;\">&nbsp;<strong>【第一期】斗牛周赛获奖玩家名单</strong></span></p><p><br/></p><p>亲爱的乐友们：</p><p>&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; 快乐之都第一期<a href=\"http://www.383k.com/about/games_6.html\" target=\"_blank\" style=\"padding: 0px; margin: 0px auto; color: rgb(69, 69, 69); text-decoration: none;\"></a><a href=\"http://www.383k.com/about/games_6.html\" target=\"_blank\" class=\"infotextkey\" style=\"padding: 0px; margin: 0px auto; color: rgb(69, 69, 69); text-decoration: none;\">斗</a>牛周赛已于昨晚21:38:32顺利结束，获得本场比赛冠军荣誉的是一位来自广东东莞的玩家——“博翌”。在激烈的竞争压力下，“博翌”始终不急不躁，坚持稳中求进。良好的心态，加上队友的给力配合，让他在本场比赛中如鱼得水，最终轻松夺得冠军，拿下大奖。恭喜“博翌”！</p><p>&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; 以下是本场比赛前12名获奖玩家名单： &nbsp;</p><p>&nbsp;</p><p><img src=\"/announcement/Public/ueditor/php/upload/image/20140711/1405062571692065.jpg\" alt=\"第76期周赛获奖名单.jpg\" style=\"padding: 0px; margin: 0px auto;\"/></p><p>--------------------------------------------------------------------------------------------</p><p><img src=\"/announcement/Public/ueditor/php/upload/image/20140710/1404976651811539.png\" title=\"1404976651811539.png\" alt=\"public_line.png\"/>&nbsp;</p><p><br/></p><p><img src=\"http://203.86.3.245:99/Public/ueditor/themes/default/images/spacer.gif\" word_img=\"file:///C:\\Users\\yi\\Documents\\Tencent Files\\290107640\\Image\\@J@{DWGCRC@([1G)R}F1ZCN.jpg\" style=\"background:url(http://203.86.3.245:99/Public/ueditor/lang/zh-cn/images/localimage.png) no-repeat center center;border:1px solid #ddd\"/></p><p><img src=\"/announcement/Public/ueditor/php/upload/image/20140714/1405318540691257.jpg\" title=\"1405318540691257.jpg\" alt=\"111.jpg\" width=\"465\" height=\"516\" style=\"width: 465px; height: 516px; float: left;\"/></p>', 'def', '1407139656', '1407226059', '1405062276', '1405062276');
INSERT INTO `announcement` VALUES ('27', '0', '排行榜活动，首充翻倍', '<p><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\"></span></strong></span></p><p><strong style=\"color: rgb(0, 112, 192);\">排行榜充值有活动啦~</strong></p><p>当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr/><p><span style=\"color: rgb(0, 112, 192);\"><strong>首充翻倍！</strong></span><br/></p><p style=\"white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"white-space: normal;\">※额外赠送的金币立即到账,购买时请留意~</p>', 'def', '1412069062', '1422719999', '1407917269', '1407917269');
INSERT INTO `announcement` VALUES ('28', '0', '8月14~8月23_回馈活动公告', '<p><strong><span style=\"font-family: 宋体, SimSun;\">“惊喜大回馈”活动开始啦~~</span></strong></p><p><span style=\"font-family: 宋体, SimSun;\">为感谢玩家们对我们游戏一如既往的支持,凡于8月14 ~8月23日期间每天连续登录者,若当天胜局数≥10局,则奖励5个元宝；第2天胜局数≥10局，则奖励10个元宝；第3天4天5天。。。。。。第10天≥10局，则奖励15/20/25/30/35/40/45/50个元宝,10天最多共可获275个元宝。另外,活动结束后,总局数≥500局的用户所获得的元宝翻倍哦(必须10天连续登陆，每天胜10局以上），10天最多可获550个~~</span></p><p><span style=\"font-family: 宋体, SimSun;\">别忘了,要来玩哦^^</span></p><p><span style=\"font-family: 宋体, SimSun;\">※以上所有元宝奖品,都将于8月23日活动结束之后三天内发放</span></p><p><span style=\"font-family: 宋体, SimSun;\">※ 任何疑问或建议请联系牛牛客服^</span></p><p><span style=\"font-family: 宋体, SimSun;\"></span></p><hr/><p><strong>你找Bug，我送大奖~</strong></p><p style=\"white-space: normal;\">即日~8月31日期间，凡发现游戏Bug并向客服反馈，经核实的玩家，官方将重奖，包括话费充值卡/金币/元宝/魅力值等丰厚诱人的奖品！游戏团队后续会努力提升体验和开发更多新的玩法，期待您的参与~</p><p style=\"white-space: normal;\">客服电话：400-658-6158 &nbsp;</p><p style=\"white-space: normal;\">客服QQ：515151060，515151061</p><hr/><p><strong>严禁私下买卖金币！举报有奖！</strong></p><p>在游戏内私下买卖金币等非法交易金币行为，一经查获买卖双方将会被永久停封账号！最先提供确凿证据的举报者，将获得丰厚的奖励！请玩家自觉抵制卖币和非法刷币行为！</p>', 'def', '1407945600', '1408809345', '1407918224', '1407918224');
INSERT INTO `announcement` VALUES ('29', '0', '8月14 ~8月23日<惊喜大回馈>活动获奖名单', '<p><strong>&lt;惊喜大回馈&gt;活动获奖名单</strong><br/>为期十天的惊喜大回馈活动圆满结束了，本次活中获得元宝者达八千余人，获得元宝最多的前5名的玩家公布如下：<br/>牛牛牛牛妞（ID：11030），获得	550个元宝	<br/>bblk783376（ID：11101），获得550个元宝	<br/>牛牛大王（ID：10589），获得275个元宝	<br/>小牛吃嫩草（ID：10684），获得	275个元宝	<br/>angel251（ID：11147），获得275个元宝<br/>。。。。。。<br/>※元宝将于8月26日前由系统自动发放到获奖玩家账户中<br/>※今后,奖励元宝话费等活动将不断推出,欢迎您踊跃参与<br/>※任何疑问或建议请联系牛牛客服^^&nbsp;</p><hr/><p style=\"white-space: normal;\"><strong>你找Bug，我送大奖~</strong></p><p style=\"white-space: normal;\">即日~8月31日期间，凡发现游戏Bug并向客服反馈，经核实的玩家，官方将重奖，包括话费充值卡/金币/元宝/魅力值等丰厚诱人的奖品！游戏团队后续会努力提升体验和开发更多新的玩法，期待您的参与~</p><p style=\"white-space: normal;\">客服电话：400-658-6158 &nbsp;</p><p style=\"white-space: normal;\">客服QQ：515151060，515151061</p><hr style=\"white-space: normal;\"/><p style=\"white-space: normal;\"><strong>严禁私下买卖金币！举报有奖！</strong></p><p style=\"white-space: normal;\">在游戏内私下买卖金币等非法交易金币行为，一经查获买卖双方将会被永久停封账号！最先提供确凿证据的举报者，将获得丰厚的奖励！请玩家自觉抵制卖币和非法刷币行为！</p><p><br/></p>', 'def', '1408954615', '1409155200', '1408954715', '1408954715');
INSERT INTO `announcement` VALUES ('30', '0', '9月3日~9月16日中秋大礼，首充翻倍', '<p><strong>中秋大礼，首充翻倍</strong>！</p><p>即日~9月16日，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。</p><p>例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 12px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p>超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p>※额外赠送的金币立即到账,购买时请留意~</p><p>※任何疑问或建议请联系牛牛客服^^</p><hr/><p><strong>你找Bug，我送大奖~</strong></p><p>即日~9月30日期间，凡发现游戏Bug并向客服反馈，经核实的玩家，官方将重奖，包括话费充值卡/金币/元宝/魅力值等丰厚诱人的奖品！游戏团队后续会努力提升体验和开发更多新的玩法，期待您的参与~</p><p>客服电话：400-658-6158 &nbsp;</p><p>客服QQ：515151060，515151061</p><hr/><p><strong>严禁私下买卖金币！举报有奖！</strong></p><p>在游戏内私下买卖金币等非法交易金币行为，一经查获买卖双方将会被永久停封账号！最先提供确凿证据的举报者，将获得重奖！请玩家自觉抵制卖币和非法刷币行为！</p>', 'll', '1409725711', '1411487999', '1409725795', '1409725795');
INSERT INTO `announcement` VALUES ('31', '0', '双11限时特惠，赠30%！', '<p style=\"font-size: medium; white-space: normal; font-family: Simsun;\"><strong>双11限时特惠，赠30%！</strong></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">限时充值优惠开始啦，11.11号~11.13号期间，每笔充值额外赠送30%金币，及时到账，多买多送，上不封顶（20元特大优惠不参与）</p><hr/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><strong>排行榜充值有活动啦~</strong></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><strong>首充翻倍！</strong><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※额外赠送的金币立即到账,购买时请留意~</p>', 'def', '1415635200', '1415894399', '1415615055', '1415615055');
INSERT INTO `announcement` VALUES ('32', '0', '火爆比赛场~有奖!', '<p><strong>活动1:火爆比赛场~有奖!</strong></p><p>开放时间：2014年11月25日－2014年11月27日(每天11:30~14:30、19:00~22:00)&nbsp;</p><p>奖品发放：每天冠亚季军各1/2/3人<span style=\"font-family: Simsun; font-size: medium;\">，</span>分别奖50元话费/1000金元宝/5W金币; 每周冠亚季军各1/3/10人<span style=\"font-size: medium; font-family: Simsun;\">，</span>分别奖100元/50元/10元话费</p><p>※奖励于结果出来后3个工作日内发放<span style=\"font-family: Simsun; font-size: medium;\">。</span>大奖多多,欢迎踊跃参与!</p><hr/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><strong><span style=\"font-family: 宋体;\">活动2:版本更新有惊喜啦!</span></strong></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"font-family: 宋体;\">即日</span>起<span style=\"font-family: 宋体;\">，所有老用户升级到最新的</span><span style=\"font-family: 宋体;\">V</span>1.4<span style=\"font-family: 宋体;\">版本，可免费获得</span>28<span style=\"font-family: 宋体;\">金元宝，新版更炫更精彩，快去更新吧！请到任务界面领取^_^</span></p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><strong>活动3:排行榜充值有活动!</strong><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><strong>活动4:首充翻倍！</strong><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※额外赠送的金币立即到账,购买时请留意!</p>', 'def', '1416825834', '1417103999', '1416826158', '1416826158');
INSERT INTO `announcement` VALUES ('33', '0', '火爆比赛场—第一届（获奖名单公布）', '<p style=\"white-space: normal;\"><strong><span style=\"font-family: 宋体;\"></span></strong></p><p style=\"white-space: normal;\"><strong><span style=\"font-family: 宋体;\"></span></strong></p><p><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">火爆比赛场，获奖名单！</span></strong></span></p><p style=\"white-space: normal;\"><span style=\"font-family: 宋体;\"></span></p><p style=\"line-height: normal;\"><span style=\";font-family:宋体\">首届土豪牛牛《火爆斗牛大赛》</span><span style=\";font-family:宋体\">圆满结束,获奖部分玩家名单公布如下：</span></p><p style=\"line-height: normal;\"><span style=\"font-family: 宋体\">日赛冠军，</span><span style=\"font-family: 宋体\">奖</span>50<span style=\"font-family: 宋体\">元话费</span>：&nbsp;&nbsp;&nbsp; <span style=\"font-family: 宋体\">ID:</span> <span style=\"font-family: 宋体\">243403</span><span style=\"font-family: 宋体\">、96204、238595</span></p><p><span style=\"font-family: 宋体\">周赛冠军，</span><span style=\"font-family: 宋体\">奖</span>100<span style=\"font-family: 宋体\">元话费</span>：&nbsp;&nbsp; <span style=\"font-family: 宋体\">ID:</span> <span style=\"font-family: 宋体\">10751</span></p><p><span style=\"font-family: 宋体\">周赛亚军，奖</span>50<span style=\"font-family: 宋体\">元话费</span>:&nbsp;&nbsp;&nbsp;&nbsp; <span style=\"font-family: 宋体\">ID:</span> <span style=\"font-family: 宋体\">243403</span><span style=\"font-family: 宋体\">、24091、11105</span></p><p><span style=\"font-family: 宋体\">周赛季军，</span><span style=\"font-family: 宋体\">奖10元话费</span><span style=\"font-family: 宋体\">：</span>&nbsp;&nbsp;&nbsp; <span style=\"font-family: 宋体\">ID:</span> <span style=\"font-family: 宋体\">95662</span><span style=\"font-family: 宋体\">。。。。。。等10名玩家</span><span style=\"font-family: 宋体;\">&nbsp;</span></p><p><span style=\";font-family:宋体\">a.</span><span style=\";font-family: 宋体\">恭喜以上获奖玩家,请获奖玩家于12月5日前联系客服提供手机号码,以予登记和核实发奖,逾期视作放弃!</span></p><p><span style=\";font-family:宋体\">b.</span><span style=\";font-family: 宋体\">获得游戏金币和元宝的奖励于12月2日前由系统自动发放到获奖账号中。</span></p><p style=\"white-space: normal;\"><span style=\"font-family: 宋体;\"></span></p><hr/><p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">版本更新有惊喜啦</span>~</strong></span><br/></p><p style=\"white-space: normal;\"><span style=\"font-family: 宋体;\">即日</span>起<span style=\"font-family: 宋体;\">，所有老用户升级到最新的</span><span style=\"font-family: 宋体;\">V</span>1.4<span style=\"font-family: 宋体;\">版本，可免费获得</span>28<span style=\"font-family: 宋体;\">金元宝，新版更炫更精彩，快去更新吧！请到任务界面领取^_^</span></p><hr style=\"white-space: normal;\"/><p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>排行榜充值有活动啦~</strong></span><br/></p><p style=\"white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"white-space: normal;\"/><p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>首充翻倍！</strong></span><br/></p><p style=\"white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"white-space: normal;\">※额外赠送的金币立即到账,购买时请留意~</p>', 'def', '1417163633', '1417410300', '1417163992', '1417163992');
INSERT INTO `announcement` VALUES ('34', '0', '火爆比赛场(第二届）', '<p><span style=\"color: rgb(0, 112, 192);\"><strong style=\"font-family: Simsun; font-size: medium;\">活动1:火爆比赛场~有奖!</strong></span><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">开放时间：2014年12月3日－2014年12月7日（每天11:00~15:00、18:30~22:30）</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">奖品发放：每天冠亚季军各1/2/3人,分别奖50元话费/1000元宝/5W金币;<span style=\"font-family: sans-serif; font-size: 16px;\">每周冠亚季军各1/3/10人,分别奖iphone6手机一部/50元话费/10元话费&nbsp;</span></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※请玩家绑定手机号码，便于比赛结果出来后3个工作日内发放奖励。大奖多多,欢迎踊跃参与!</p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">活动2:版本更新有惊喜啦!</span></strong></span></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"font-family: 宋体;\">即日</span>起<span style=\"font-family: 宋体;\">，所有老用户升级到最新的</span><span style=\"font-family: 宋体;\">V</span>1.4<span style=\"font-family: 宋体;\">版本，可免费获得</span>28<span style=\"font-family: 宋体;\">元宝，新版更炫更精彩，快去更新吧！请到任务界面领取^_^</span></p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动3:排行榜充值有活动!</strong></span><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动4:首充翻倍！</strong></span><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※额外赠送的金币立即到账,购买时请留意!</p>', 'def', '1417410356', '1417962600', '1417410640', '1417410640');
INSERT INTO `announcement` VALUES ('36', '0', '火爆比赛场—第二届（获奖名单公布）', '<p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\"></span></strong></span></p><p><span style=\"color: rgb(0, 112, 192);\"></span></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">新版更新有惊喜！</span></strong></span><br/></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\"><span style=\"font-family: 宋体;\"></span><span style=\"font-size: medium; font-family: 宋体;\">即日</span><span style=\"font-family: Simsun; font-size: medium;\">起</span><span style=\"font-size: medium; font-family: 宋体;\">，所有老用户升级到最新的</span><span style=\"font-size: medium; font-family: 宋体;\">V</span><span style=\"font-family: Simsun; font-size: medium;\">1.5</span><span style=\"font-size: medium; font-family: 宋体;\">版本，可免费获得</span><span style=\"font-family: Simsun; font-size: medium;\">28</span><span style=\"font-size: medium; font-family: 宋体;\">元宝，新版更炫更精彩，快去更新吧！请到任务界面领取^_^</span><span style=\"font-family: 宋体;\"></span></p><p><strong style=\"color: rgb(0, 112, 192);\"></strong></p><hr/><p><strong style=\"color: rgb(0, 112, 192);\">火爆比赛场，获奖名单</strong><br/></p><p>第二届土豪牛牛《火爆斗牛大赛》圆满结束,获奖部分玩家名单公布如下：</p><p><strong>日赛冠军</strong>（50元话费）： wapx370680(6**72) 、啊呵呵哈哈哈(2***00)、牛姐(1**51)</p><p><strong>周赛冠军</strong>（iphone手机一部）：wapx370680(6**72)</p><p><strong>周赛亚军</strong>（50元话费）：牛姐(1**51)、逢赌必败(9**75)、dfxw502622(6**69)</p><p><strong>周赛季军</strong>（10元话费）：寂寞才说爱(1***86)、超帅(5**35)、啊呵呵哈哈哈(2***00)、zkbu697312(2***70)。。。等10名</p><p>a.恭喜以上获奖玩家,请获奖玩家于12月12日前联系客服提供手机号码和身份证,以予登记和核实发奖,逾期视作放弃!</p><p>b.获得游戏金币和元宝的奖励于12月10日前由系统自动发放到获奖账号中。</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\"></span></strong></span></p><hr/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><strong style=\"color: rgb(0, 112, 192);\">排行榜充值有活动啦~</strong><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>首充翻倍！</strong></span><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※额外赠送的金币立即到账,购买时请留意~</p>', 'def', '1418027902', '1418227199', '1418028170', '1418028170');
INSERT INTO `announcement` VALUES ('37', '0', '渠道测试1', '<p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">版本更新有惊喜啦!</span></strong></span></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"font-family: 宋体;\">即日</span>起<span style=\"font-family: 宋体;\">，所有老用户升级到最新的</span><span style=\"font-family: 宋体;\">V</span>1.4<span style=\"font-family: 宋体;\">版本，可免费获得</span>28<span style=\"font-family: 宋体;\">元宝，新版更炫更精彩，快去更新吧！请到任务界面领取^_^</span></p>', '100custest000002', '1418186421', '1418272823', '1418186740', '1418186740');
INSERT INTO `announcement` VALUES ('38', '0', '渠道测试2', '<p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><strong style=\"color: rgb(0, 112, 192);\">排行榜充值有活动啦~</strong><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><p><br/></p>', '100custest000001', '1418186490', '1418272893', '1418186806', '1418186806');
INSERT INTO `announcement` VALUES ('39', '0', '火爆比赛场（第三届）', '<p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong style=\"font-family: Simsun; font-size: medium;\">活动1:火爆比赛场~有奖!</strong></span><br/></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">开放时间：2014年12月20日－2014年12月24日（每天11:30~14:30、19:00~22:00）</p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">奖品发放：每天冠亚季军各1/2/3人,分别奖50元话费/1000元宝/5W金币;<span style=\"font-family: sans-serif; font-size: 16px;\">每周冠亚季军各1/3/10人,分别奖500元话费/100元话费/20元话费&nbsp;</span></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">※请玩家绑定手机号码，便于比赛结果出来后3个工作日内发放奖励。大奖多多,欢迎踊跃参与!</p><hr style=\"font-size: medium; white-space: normal; font-family: Simsun;\"/><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">活动2:版本更新有惊喜啦!</span></strong></span></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\"><span style=\"font-family: 宋体;\">即日</span>起<span style=\"font-family: 宋体;\">，所有老用户升级到最新的</span><span style=\"font-family: 宋体;\">V</span>1.6<span style=\"font-family: 宋体;\">版本，可免费获得</span>28<span style=\"font-family: 宋体;\">元宝，新版更炫更精彩，快去更新吧！请到任务界面领取^_^</span></p><hr style=\"font-size: medium; white-space: normal; font-family: Simsun;\"/><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动3:排行榜充值有活动!</strong></span><br/></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"font-size: medium; white-space: normal; font-family: Simsun;\"/><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动4:首充翻倍！</strong></span><br/></p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"font-size: medium; white-space: normal; font-family: Simsun;\">※额外赠送的金币立即到账,购买时请留意!</p><p><br/></p>', 'def', '1418972470', '1419429600', '1418972990', '1418972990');
INSERT INTO `announcement` VALUES ('41', '0', '火爆比赛场—第三界（获奖名单）+圣诞', '<p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">活动1：圣诞狂欢，元宝金币拿不停！</span></strong></span></p><p style=\"white-space: normal;\">玩牌局赚元宝，活动时间：2014年12月25日-12月27日</p><p style=\"white-space: normal;\">1、任意场馆：每天进行30次牌局，可以领取1688金币（每天限领3次)</p><p style=\"white-space: normal;\">2、牛比轰轰场馆：每天玩牌268次，可以领取1100元宝；玩牌388次，可以领取3300元宝（每天限领1次)。</p><p style=\"white-space: normal;\">3、牛气冲天场馆：每天玩牌128次，可以领取5500元宝（每天限领1次)。</p><p style=\"white-space: normal;\">4、牛炸天场馆：每天玩牌108次，可以领取11000元宝（每天限领1次)。</p><p style=\"white-space: normal;\">※请到每日任务界面查看并领取奖励！数量有限，先到先得，赶快下手吧！</p><p><strong><span style=\";font-family:宋体\"></span></strong></p><hr/><p><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"color: rgb(0, 112, 192); font-family: 宋体;\">活动2：火爆比赛场，获奖名单！</span></strong></span><br/></p><p><span style=\";font-family:宋体\">第</span>3<span style=\";font-family:宋体\">届土豪牛牛《火爆斗牛大赛》</span><span style=\";font-family:宋体\">圆满结束,获奖部分玩家名单公布如下：</span></p><p><span style=\"font-family: 宋体\">日赛冠军，</span><span style=\"font-family: 宋体\">奖</span>50<span style=\"font-family: 宋体\">元话费</span>&nbsp; &nbsp; <span style=\"font-family: 宋体\">ID:</span> 285699<span style=\"font-family:宋体\">、</span>345532<span style=\"font-family:宋体\">、</span>285699<span style=\"font-family:宋体\">、</span>217640<span style=\"font-family:宋体\">、</span>345532</p><p><span style=\"font-family: 宋体\">周赛冠军，</span><span style=\"font-family: 宋体\">奖</span>500<span style=\"font-family: 宋体\">元话费</span>&nbsp; &nbsp;<span style=\"font-family: 宋体\">ID:</span> <span style=\"font-family: 宋体\">345532</span></p><p><span style=\"font-family: 宋体\">周赛亚军，奖</span>100<span style=\"font-family: 宋体\">元话费</span>&nbsp; &nbsp;<span style=\"font-family: 宋体\">ID:</span> 285699<span style=\"font-family:宋体\">、</span>340900<span style=\"font-family:宋体\">、</span>345542</p><p><span style=\"font-family: 宋体\">周赛季军，</span><span style=\"font-family: 宋体\">奖20元话费</span>&nbsp; &nbsp;&nbsp;<span style=\"font-family: 宋体\">ID:</span> <span style=\"font-family: 宋体\">345752</span><span style=\"font-family: 宋体\">。。。。。。等10名玩家</span><span style=\"font-family: 宋体;\">&nbsp;</span></p><p><span style=\"font-family: 宋体;\">a.</span><span style=\"font-family: 宋体;\">恭喜以上获奖玩家,请获奖玩家于12月29日前联系客服提供手机号码和身份证,以予登记和核实发奖,逾期视作放弃!</span><br/></p><p><span style=\";font-family:宋体\">b.</span><span style=\";font-family: 宋体\">获得游戏金币和元宝的奖励于12月26日前由系统自动发放到获奖账号中。</span></p><p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\"></span></strong></span></p><hr/><p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong><span style=\"font-family: 宋体;\">活动3：版本更新有惊喜啦</span>~</strong></span><br/></p><p style=\"white-space: normal;\"><span style=\"font-family: 宋体;\">即日</span>起<span style=\"font-family: 宋体;\">，所有老用户升级到最新的</span><span style=\"font-family: 宋体;\">V</span>1.6<span style=\"font-family: 宋体;\">版本，可免费获得</span>28<span style=\"font-family: 宋体;\">元宝，新版更炫更精彩，快去更新吧！请到任务界面领取^_^</span></p><hr style=\"white-space: normal;\"/><p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动4：排行榜充值有活动啦~</strong></span><br/></p><p style=\"white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"white-space: normal;\"/><p style=\"white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动5：首充翻倍！</strong></span><br/></p><p style=\"white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"white-space: normal;\">※额外赠送的金币立即到账,购买时请留意~</p><p><br/></p>', 'def', '1419479159', '1419695999', '1419479572', '1419479572');
INSERT INTO `announcement` VALUES ('42', '0', '限时大赠送，充100送100！', '<p><span style=\"color: rgb(0, 112, 192);\"><strong><strong style=\"color: rgb(0, 112, 192); font-family: Simsun; font-size: medium; white-space: normal;\">活动1：</strong></strong></span><span style=\"color: rgb(0, 112, 192);\"><strong>限时大赠送！充100送100！</strong></span></p><p>1月16日~1月18日，当天使用支付宝/银联/神州付充值满100元，将额外赠送100万金币（话费充值满100元赠送30万金币）。请直接联系客服QQ领取金币（客服QQ：515151061，客服电话：4006586158）。限时优惠，机不可失，赶快来参与吧！</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"></span></p><hr/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动2：排行榜充值有活动啦~</strong></span><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">当日充值，排行榜前3名获得充值100%奖励，4-15名获得充值50%奖励，次日0时生效，快快参与吧！</p><hr style=\"font-family: Simsun; font-size: medium; white-space: normal;\"/><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\"><span style=\"color: rgb(0, 112, 192);\"><strong>活动3：首充翻倍！</strong></span><br/></p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">即日起，所有玩家首次充值，可获得金币和元宝翻倍的机会，最高赠送600万金币和600个元宝（特大优惠充值不享受）。例如：现价￥100元=210万金币+210个元宝（<span style=\"font-size: 11px;\">原价￥100元=105万金币+105个元宝</span>）。</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※超值机会不容错过！还在犹豫什么，赶快参与吧！</p><p style=\"font-family: Simsun; font-size: medium; white-space: normal;\">※额外赠送的金币立即到账,购买时请留意~</p>', 'def', '1421310446', '1421596799', '1419999191', '1419999191');

-- ----------------------------
-- Table structure for apps
-- ----------------------------
DROP TABLE IF EXISTS `apps`;
CREATE TABLE `apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appName` varchar(50) DEFAULT '',
  `package` varchar(50) DEFAULT NULL COMMENT '包名',
  `ver_last` int(11) DEFAULT '1' COMMENT '最新版本号',
  `ver` varchar(20) DEFAULT NULL,
  `isforce` int(4) DEFAULT '0' COMMENT '是否强迫更新:0,不强迫；1，强迫',
  `memo` text COMMENT '更新说明',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `package` (`package`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of apps
-- ----------------------------
INSERT INTO `apps` VALUES ('1', '土豪牛牛', 'com.chjie.dcow', '12', 'v1.9', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝', '2015-09-23 16:11:53');
INSERT INTO `apps` VALUES ('2', '土豪牛牛(送话费)', 'com.chjie.dcow.nearme.gamecenter', '15', 'v1.9', '0', '经典三张牌玩法，火爆来袭，万人同时在线，等你来战', '2016-03-04 17:48:45');
INSERT INTO `apps` VALUES ('3', '土豪牛牛送话费', 'com.tencent.tmgp.wbl.dcow', '1', 'test', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝', '2015-09-09 13:45:55');
INSERT INTO `apps` VALUES ('4', '土豪牛牛腾讯SDK', 'com.tencent.tmgp.chjie.dcow', '15', '1.9', '0', '经典三张牌玩法，火爆来袭，万人同时在线，等你来战等你来战', '2016-03-04 17:49:08');
INSERT INTO `apps` VALUES ('5', '土豪牛牛斯凯SDK', 'com.chjie.dcow.mopo', '11', '1.8', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝送28元宝', '2015-09-23 16:12:12');
INSERT INTO `apps` VALUES ('6', '土豪牛牛(益玩子包A)', 'com.chjie.dcow.yiwan1', '11', 'v1.9', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝', '2015-09-23 16:12:03');
INSERT INTO `apps` VALUES ('7', '土豪牛牛(益玩子包B)', 'com.chjie.dcow.yiwan2', '11', 'v1.9', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝', '2015-09-23 16:12:05');
INSERT INTO `apps` VALUES ('8', '土豪牛牛(益玩子包C)', 'com.chjie.dcow.yiwan3', '11', 'v1.9', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝', '2015-09-21 15:29:05');
INSERT INTO `apps` VALUES ('9', '土豪牛牛(益玩子包D)', 'com.chjie.dcow.yiwan4', '11', 'v1.9', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝', '2015-09-21 15:29:04');
INSERT INTO `apps` VALUES ('10', '土豪牛牛(钱学)', 'com.chjie.dcow.qx', '11', 'v1.9', '0', '更新有礼\r\n1、全新的大厅、商场UI布局，更流畅的体验\r\n2、新增激情百人场、畅快私人场和金币月卡\r\n3、更新就送28元宝', '2015-09-21 15:29:02');
INSERT INTO `apps` VALUES ('11', '土豪牛牛(益玩)', 'com.chjie.dcow.ewan', '12', 'v1.9', '0', '接入益玩SDK', '2015-10-27 11:08:04');
INSERT INTO `apps` VALUES ('12', '土豪牛牛keke(高舟)', 'com.gaozhou.dcow.nearme.gamecenter', '15', 'v1.9', '0', '', '2016-03-05 11:20:14');

-- ----------------------------
-- Table structure for apps_history
-- ----------------------------
DROP TABLE IF EXISTS `apps_history`;
CREATE TABLE `apps_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appName` varchar(50) DEFAULT '',
  `package` varchar(50) DEFAULT NULL COMMENT '包名',
  `ver_last` int(11) DEFAULT '1' COMMENT '版本号',
  `ver` varchar(20) DEFAULT NULL,
  `memo` text COMMENT '更新说明',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `package` (`package`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of apps_history
-- ----------------------------

-- ----------------------------
-- Table structure for app_channel_up
-- ----------------------------
DROP TABLE IF EXISTS `app_channel_up`;
CREATE TABLE `app_channel_up` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `channel` varchar(50) DEFAULT NULL,
  `pkgMd5` varchar(100) DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of app_channel_up
-- ----------------------------
INSERT INTO `app_channel_up` VALUES ('1', '000000000000', '17B8572E739B8CE3DA5457CD9AA18CEC', '2015-05-28 14:03:49');
INSERT INTO `app_channel_up` VALUES ('3', '3003918429', '7A80C9C266354C80F1533068C1285EF7', '2015-05-28 14:30:26');

-- ----------------------------
-- Table structure for app_modules
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
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8 COMMENT='控制应用的功能模块是否在客户端启用';

-- ----------------------------
-- Records of app_modules
-- ----------------------------
INSERT INTO `app_modules` VALUES ('8', '1', 'com.chjie.dcow', 'shop', '0', '2014-07-24 14:44:42');
INSERT INTO `app_modules` VALUES ('9', '1', 'com.chjie.dcow', 'lottery', '0', '2014-07-18 11:51:00');
INSERT INTO `app_modules` VALUES ('10', '1', 'com.chjie.dcow', 'more_game', '0', '2014-07-18 13:42:24');
INSERT INTO `app_modules` VALUES ('11', '0', '000000000000', 'slot', '1', '2015-12-09 09:32:19');
INSERT INTO `app_modules` VALUES ('14', '0', '000000000000', 'lottery', '1', '2015-12-09 09:32:14');
INSERT INTO `app_modules` VALUES ('15', '0', '000000000000', 'exchange', '1', '2015-12-09 09:32:09');
INSERT INTO `app_modules` VALUES ('17', '0', '0000000002', 'slot', '1', '2014-08-18 14:16:09');
INSERT INTO `app_modules` VALUES ('18', '0', '0000000002', 'exchange', '1', '2014-08-18 14:16:27');
INSERT INTO `app_modules` VALUES ('19', '0', '0000000002', 'shop', '1', '2014-08-18 14:16:45');
INSERT INTO `app_modules` VALUES ('20', '0', '3003918429', 'slot', '1', '2014-08-21 11:16:55');
INSERT INTO `app_modules` VALUES ('21', '1', 'com.chjie.dcow.nearme.gamecenter', 'more_game', '1', '2014-09-01 11:31:55');
INSERT INTO `app_modules` VALUES ('23', '0', '0000000004', 'slot', '1', '2014-09-01 11:39:18');
INSERT INTO `app_modules` VALUES ('24', '0', '0000000004', 'exchange', '1', '2014-09-01 11:39:19');
INSERT INTO `app_modules` VALUES ('25', '0', '0000000004', 'lottery', '1', '2014-09-01 11:39:21');
INSERT INTO `app_modules` VALUES ('27', '0', '100lianyun001', 'more_game', '1', '2014-09-10 11:41:55');
INSERT INTO `app_modules` VALUES ('28', '1', 'com.chjie.dcow.nearme.gamecenter', 'slot', '1', '2014-09-29 11:00:40');
INSERT INTO `app_modules` VALUES ('29', '0', '0000000005', 'slot', '1', '2014-10-09 15:29:41');
INSERT INTO `app_modules` VALUES ('30', '0', '0000000005', 'lottery', '1', '2014-10-09 15:29:56');
INSERT INTO `app_modules` VALUES ('31', '0', '0000000005', 'exchange', '1', '2014-10-09 15:30:19');
INSERT INTO `app_modules` VALUES ('32', '0', '0000000005', 'more_game', '1', '2014-10-09 15:32:09');
INSERT INTO `app_modules` VALUES ('33', '1', 'com.chjie.dcow', 'share', '0', '2015-08-05 09:57:54');
INSERT INTO `app_modules` VALUES ('34', '0', '0000000006', 'more_game', '1', '2014-10-21 14:06:16');
INSERT INTO `app_modules` VALUES ('35', '0', '0000000006', 'exchange', '1', '2014-10-21 14:06:26');
INSERT INTO `app_modules` VALUES ('36', '0', '0000000006', 'lottery', '1', '2014-10-21 14:06:38');
INSERT INTO `app_modules` VALUES ('37', '0', '0000000006', 'slot', '1', '2014-10-21 14:06:48');
INSERT INTO `app_modules` VALUES ('38', '0', '0000000006', 'shop', '1', '2014-10-22 09:28:20');
INSERT INTO `app_modules` VALUES ('39', '0', '0000000007', 'more_game', '1', '2014-10-28 10:07:26');
INSERT INTO `app_modules` VALUES ('40', '0', '0000000007', 'exchange', '1', '2014-10-28 10:07:34');
INSERT INTO `app_modules` VALUES ('41', '0', '0000000007', 'lottery', '1', '2014-10-28 10:07:48');
INSERT INTO `app_modules` VALUES ('42', '0', '0000000007', 'slot', '1', '2014-10-28 10:07:58');
INSERT INTO `app_modules` VALUES ('44', '0', '2200126429', 'shop', '1', '2014-10-29 16:07:22');
INSERT INTO `app_modules` VALUES ('45', '0', '0000000005', 'shop', '1', '2014-10-29 17:18:55');
INSERT INTO `app_modules` VALUES ('46', '0', '3003918532', 'exchange', '1', '2014-11-04 11:50:58');
INSERT INTO `app_modules` VALUES ('47', '0', '3003918532', 'more_game', '1', '2014-11-04 15:46:31');
INSERT INTO `app_modules` VALUES ('48', '0', '3003918532', 'slot', '1', '2014-11-07 10:09:18');
INSERT INTO `app_modules` VALUES ('49', '0', '0000000008', 'more_game', '1', '2014-11-07 11:26:28');
INSERT INTO `app_modules` VALUES ('50', '0', '0000000008', 'exchange', '1', '2014-11-07 11:26:43');
INSERT INTO `app_modules` VALUES ('51', '0', '0000000008', 'lottery', '1', '2014-11-07 11:26:50');
INSERT INTO `app_modules` VALUES ('52', '0', '0000000008', 'slot', '1', '2014-11-07 11:27:02');
INSERT INTO `app_modules` VALUES ('53', '0', '2200127169', 'more_game', '1', '2014-11-12 15:54:51');
INSERT INTO `app_modules` VALUES ('54', '0', '2200127238', 'more_game', '1', '2014-11-12 15:55:06');
INSERT INTO `app_modules` VALUES ('55', '0', '2200125277', 'more_game', '1', '2014-11-12 15:55:16');
INSERT INTO `app_modules` VALUES ('56', '0', '100custest000002', 'shop', '1', '2014-12-04 11:56:11');
INSERT INTO `app_modules` VALUES ('57', '1', 'com.tencent.tmgp.wbl.dcow', 'shop', '0', '2014-12-04 16:52:47');
INSERT INTO `app_modules` VALUES ('60', '0', '2200123317', 'more_game', '1', '2015-01-23 13:37:45');
INSERT INTO `app_modules` VALUES ('61', '0', '100custest000001', 'lottery', '0', '2015-01-29 13:28:14');
INSERT INTO `app_modules` VALUES ('63', '0', '0000000010', 'shop', '0', '2015-01-30 11:31:42');
INSERT INTO `app_modules` VALUES ('64', '0', '0000000010', 'slot', '0', '2015-01-30 11:31:38');
INSERT INTO `app_modules` VALUES ('65', '0', '0000000010', 'lottery', '0', '2015-01-30 11:31:33');
INSERT INTO `app_modules` VALUES ('66', '0', '0000000010', 'exchange', '0', '2015-01-30 11:31:29');
INSERT INTO `app_modules` VALUES ('69', '1', 'com.tencent.tmgp.chjie.dcow', 'shop', '1', '2015-10-30 10:22:27');
INSERT INTO `app_modules` VALUES ('70', '0', '000000000000', 'shop', '1', '2015-12-09 09:32:03');
INSERT INTO `app_modules` VALUES ('73', '0', '000000000000', 'more_game', '1', '2015-12-09 09:31:51');
INSERT INTO `app_modules` VALUES ('74', '1', 'com.tencent.tmgp.chjie.dcow', 'slot', '1', '2015-10-30 10:22:21');
INSERT INTO `app_modules` VALUES ('75', '0', '000000000000', 'twice_noticy', '0', '2015-11-30 15:58:53');
INSERT INTO `app_modules` VALUES ('77', '0', '000000000000', '', '1', '2015-11-30 15:58:04');
INSERT INTO `app_modules` VALUES ('78', '0', '2200163860', 'shop', '1', '2015-04-21 14:33:52');
INSERT INTO `app_modules` VALUES ('79', '1', 'com.tencent.tmgp.chjie.dcow', 'exchange', '1', '2015-10-30 10:22:15');
INSERT INTO `app_modules` VALUES ('80', '1', 'com.tencent.tmgp.chjie.dcow', 'lottery', '1', '2015-10-30 10:22:10');
INSERT INTO `app_modules` VALUES ('81', '1', 'com.tencent.tmgp.chjie.dcow', 'tencent_shop', '1', '2015-09-15 15:02:17');
INSERT INTO `app_modules` VALUES ('82', '0', '2200163860', 'more_game', '1', '2015-05-04 16:21:44');
INSERT INTO `app_modules` VALUES ('83', '0', '000000000000', 'safebox', '1', '2015-06-29 14:24:40');
INSERT INTO `app_modules` VALUES ('84', '1', 'com.chjie.dcow.mopo', 'mopo', '1', '2015-05-18 18:03:14');
INSERT INTO `app_modules` VALUES ('92', '1', 'com.chjie.dcow.mopo', 'safebox', '1', '2015-05-19 15:41:21');
INSERT INTO `app_modules` VALUES ('93', '1', 'com.chjie.dcow.mopo', 'more_game', '1', '2015-05-20 10:42:18');
INSERT INTO `app_modules` VALUES ('94', '0', '2200165911', 'more_game', '1', '2015-06-25 11:33:36');
INSERT INTO `app_modules` VALUES ('95', '0', '2200165911', 'twice_noticy', '1', '2015-06-25 14:42:28');
INSERT INTO `app_modules` VALUES ('96', '0', '2200166217', 'more_game', '1', '2015-07-07 09:36:21');
INSERT INTO `app_modules` VALUES ('97', '0', '2200166217', 'shop', '1', '2015-07-07 09:36:26');
INSERT INTO `app_modules` VALUES ('98', '0', '2200110945', 'more_game', '1', '2015-07-30 14:18:10');
INSERT INTO `app_modules` VALUES ('99', '0', '2200110945', 'slot', '1', '2015-07-30 14:18:23');
INSERT INTO `app_modules` VALUES ('100', '1', 'com.chjie.dcow.nearme.gamecenter', 'shop', '0', '2015-08-05 09:47:56');
INSERT INTO `app_modules` VALUES ('101', '1', 'com.chjie.dcow.nearme.gamecenter', 'lottery', '1', '2015-08-05 09:59:31');
INSERT INTO `app_modules` VALUES ('102', '0', 'com.chjie.dcow.nearme.gamecenter', 'shop', '0', '2015-08-05 10:00:05');
INSERT INTO `app_modules` VALUES ('103', '1', 'com.chjie.dcow.qx', 'shop', '1', '2015-08-17 13:58:05');
INSERT INTO `app_modules` VALUES ('104', '0', '3004001284', 'more_game', '1', '2015-08-24 18:08:56');
INSERT INTO `app_modules` VALUES ('105', '0', 'MIGU000001', 'more_game', '1', '2015-10-19 10:04:51');
INSERT INTO `app_modules` VALUES ('106', '0', 'MIGU000001', 'slot', '1', '2015-10-19 10:04:46');
INSERT INTO `app_modules` VALUES ('107', '0', 'MIGU000001', 'exchange', '1', '2015-10-19 10:04:39');
INSERT INTO `app_modules` VALUES ('108', '0', 'MIGU000001', 'lottery', '1', '2015-10-19 10:04:32');
INSERT INTO `app_modules` VALUES ('109', '0', 'MIGU000001', 'safebox', '1', '2015-10-19 10:04:27');
INSERT INTO `app_modules` VALUES ('110', '0', 'MIGU000001', 'twice_noticy', '1', '2015-10-19 10:04:21');
INSERT INTO `app_modules` VALUES ('111', '0', 'MIGU000001', 'shop', '1', '2015-10-19 10:04:16');
INSERT INTO `app_modules` VALUES ('112', '1', 'com.chjie.dcow.ewan', 'more_game', '1', '2015-10-22 17:03:50');
INSERT INTO `app_modules` VALUES ('113', '1', 'com.chjie.dcow.ewan', 'slot', '1', '2015-10-22 17:04:00');
INSERT INTO `app_modules` VALUES ('114', '1', 'com.chjie.dcow.ewan', 'exchange', '1', '2015-10-22 17:04:06');
INSERT INTO `app_modules` VALUES ('115', '1', 'com.chjie.dcow.ewan', 'lottery', '1', '2015-10-22 17:04:12');
INSERT INTO `app_modules` VALUES ('116', '1', 'com.chjie.dcow.ewan', 'shop', '1', '2015-10-22 17:04:41');
INSERT INTO `app_modules` VALUES ('117', '0', '2200110945', 'exchange', '1', '2015-10-27 15:53:37');
INSERT INTO `app_modules` VALUES ('118', '0', 'JBSM000001', 'more_game', '1', '2015-11-03 14:01:08');
INSERT INTO `app_modules` VALUES ('120', '0', 'JBSM000001', 'slot', '1', '2015-11-03 14:01:33');
INSERT INTO `app_modules` VALUES ('121', '0', 'JBSM000001', 'exchange', '1', '2015-11-03 14:01:39');
INSERT INTO `app_modules` VALUES ('122', '0', 'JBSM000001', 'lottery', '1', '2015-11-03 14:01:47');
INSERT INTO `app_modules` VALUES ('123', '0', 'JBSM000001', 'share', '1', '2015-11-03 14:01:58');
INSERT INTO `app_modules` VALUES ('124', '0', 'JBSM000001', 'safebox', '1', '2015-11-03 14:02:28');
INSERT INTO `app_modules` VALUES ('125', '0', 'JBSM000001', 'twice_noticy', '1', '2015-11-03 14:02:34');
INSERT INTO `app_modules` VALUES ('126', '1', 'com.chjie.dcow.ewan2', 'shop', '1', '2015-11-05 11:37:20');
INSERT INTO `app_modules` VALUES ('127', '1', 'com.chjie.dcow.ewan2', 'lottery', '1', '2015-11-05 11:37:27');
INSERT INTO `app_modules` VALUES ('128', '1', 'com.chjie.dcow.ewan2', 'exchange', '1', '2015-11-05 11:37:33');
INSERT INTO `app_modules` VALUES ('129', '1', 'com.chjie.dcow.ewan2', 'slot', '1', '2015-11-05 11:37:41');
INSERT INTO `app_modules` VALUES ('130', '1', 'com.chjie.dcow.ewan2', 'more_game', '1', '2015-11-05 11:37:47');
INSERT INTO `app_modules` VALUES ('131', '1', 'com.chjie.dcow.ewan3', 'more_game', '1', '2015-11-05 11:38:03');
INSERT INTO `app_modules` VALUES ('132', '1', 'com.chjie.dcow.ewan3', 'slot', '1', '2015-11-05 11:38:18');
INSERT INTO `app_modules` VALUES ('133', '1', 'com.chjie.dcow.ewan3', 'exchange', '1', '2015-11-05 11:38:26');
INSERT INTO `app_modules` VALUES ('134', '1', 'com.chjie.dcow.ewan3', 'lottery', '1', '2015-11-05 11:38:36');
INSERT INTO `app_modules` VALUES ('135', '1', 'com.chjie.dcow.ewan3', 'shop', '1', '2015-11-05 11:38:43');
INSERT INTO `app_modules` VALUES ('136', '1', 'com.chjie.dcow.ewan4', 'shop', '1', '2015-11-05 11:39:21');
INSERT INTO `app_modules` VALUES ('137', '1', 'com.chjie.dcow.ewan4', 'lottery', '1', '2015-11-05 11:39:26');
INSERT INTO `app_modules` VALUES ('138', '1', 'com.chjie.dcow.ewan4', 'exchange', '1', '2015-11-05 11:39:33');
INSERT INTO `app_modules` VALUES ('139', '1', 'com.chjie.dcow.ewan4', 'slot', '1', '2015-11-05 11:39:41');
INSERT INTO `app_modules` VALUES ('140', '1', 'com.chjie.dcow.ewan4', 'more_game', '1', '2015-11-05 11:39:51');
INSERT INTO `app_modules` VALUES ('141', '1', 'com.chjie.dcow.ewan5', 'shop', '1', '2015-11-05 11:40:01');
INSERT INTO `app_modules` VALUES ('142', '1', 'com.chjie.dcow.ewan5', 'lottery', '1', '2015-11-05 11:40:16');
INSERT INTO `app_modules` VALUES ('143', '1', 'com.chjie.dcow.ewan5', 'exchange', '1', '2015-11-05 11:40:21');
INSERT INTO `app_modules` VALUES ('144', '1', 'com.chjie.dcow.ewan5', 'slot', '1', '2015-11-05 11:40:30');
INSERT INTO `app_modules` VALUES ('145', '1', 'com.chjie.dcow.ewan5', 'more_game', '1', '2015-11-05 11:40:40');

-- ----------------------------
-- Table structure for app_up_control
-- ----------------------------
DROP TABLE IF EXISTS `app_up_control`;
CREATE TABLE `app_up_control` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `channel` varchar(50) DEFAULT NULL COMMENT '渠道号',
  `package` varchar(100) DEFAULT NULL COMMENT '包名',
  `startTime` bigint(8) DEFAULT NULL COMMENT '开始更新时间',
  `endTime` bigint(8) DEFAULT NULL COMMENT '停止更新时间',
  `ver_last` int(4) DEFAULT NULL COMMENT '目标版本',
  `ver` varchar(20) DEFAULT NULL COMMENT '目标版本描述',
  `isforce` int(4) DEFAULT '0',
  `memo` varchar(100) DEFAULT NULL COMMENT '更新描述',
  `updatedate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of app_up_control
-- ----------------------------
INSERT INTO `app_up_control` VALUES ('1', '3003918429', 'com.chjie.dcow', '1418900400', '1418943600', '8', 'v1.6.1', '0', '广点通', '2014-12-18 18:14:42');
INSERT INTO `app_up_control` VALUES ('2', '3003918547', 'com.chjie.dcow', '1418900400', '1418943600', '8', 'v1.6.1', '0', '炸金花更多游戏', '2014-12-18 18:14:33');
INSERT INTO `app_up_control` VALUES ('3', '100custest000001', 'com.chjie.dcow', '1418887219', '1418906401', '8', 'v1.6.1', '0', '', '2014-12-18 16:49:01');

-- ----------------------------
-- Table structure for award
-- ----------------------------
DROP TABLE IF EXISTS `award`;
CREATE TABLE `award` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  `type` tinyint(4) NOT NULL COMMENT '宝元兑换类型:0,话费;3,金币;4~n具体实物',
  `coin` int(11) NOT NULL COMMENT '要需消耗的元宝',
  `awardnum` int(11) NOT NULL COMMENT '兑换获得的物品数量',
  `imag` varchar(30) DEFAULT NULL,
  `num` int(4) NOT NULL COMMENT '物品总数:-1为不限数量',
  `desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `sortId` smallint(2) NOT NULL COMMENT '排序ID',
  `start_time` int(11) NOT NULL COMMENT '兑换开始时间',
  `end_time` int(11) NOT NULL COMMENT '兑换结束时间',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='奖品表';

-- ----------------------------
-- Records of award
-- ----------------------------
INSERT INTO `award` VALUES ('1', '10元话费', '1', '0', '1100', '1', '', '-1', '需1100元宝', '1', '0', '0', '1370093026', '1388049745');
INSERT INTO `award` VALUES ('2', '50元话费', '1', '0', '5500', '1', '', '-1', '需5500元宝', '2', '0', '0', '1370093145', '1388049728');
INSERT INTO `award` VALUES ('7', '2000金币', '1', '3', '22', '2000', '', '-1', '需22元宝', '7', '0', '0', '1387941267', '1388049588');
INSERT INTO `award` VALUES ('8', '10元话费', '2', '0', '1100', '1', null, '-1', '需1100元宝', '1', '0', '0', '1370093026', '1370093026');
INSERT INTO `award` VALUES ('10', '50元话费', '2', '0', '5500', '1', null, '-1', '需5500元宝', '2', '0', '0', '1370093026', '1370093026');
INSERT INTO `award` VALUES ('11', '10000金币', '1', '3', '100', '10000', null, '-1', '需100元宝', '8', '0', '0', '1370093026', '1370093026');

-- ----------------------------
-- Table structure for awardlog
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
  `user_id` int(11) DEFAULT '0' COMMENT '处理人id',
  `desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `who` varchar(50) DEFAULT NULL COMMENT '处理人',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=306814 DEFAULT CHARSET=utf8 COMMENT='兑换记录';

-- ----------------------------
-- Records of awardlog
-- ----------------------------

-- ----------------------------
-- Table structure for backup_payorder
-- ----------------------------
DROP TABLE IF EXISTS `backup_payorder`;
CREATE TABLE `backup_payorder` (
  `id` bigint(20) NOT NULL,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `order_id` varchar(30) DEFAULT NULL COMMENT '订单号',
  `sdk` varchar(10) DEFAULT NULL COMMENT 'sdk代号',
  `rmb` int(11) DEFAULT NULL,
  `mac` varchar(30) DEFAULT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `success` tinyint(4) DEFAULT '0' COMMENT '0=初始订单;1=成功支付订单',
  `money` int(11) DEFAULT '0',
  `coin` int(11) DEFAULT '0',
  `istrap` tinyint(4) DEFAULT '0' COMMENT '是否付费坑的订单',
  `trap` int(11) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `money0` bigint(20) DEFAULT '0' COMMENT '玩家充值前的金币数',
  `money1` bigint(20) DEFAULT '0' COMMENT '玩家充值后的金币数',
  `rmb_fen` int(11) DEFAULT '0' COMMENT '金额(分)',
  `ccd` tinyint(4) DEFAULT '0' COMMENT '0=服务器端校验; 1=客户端校验',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  KEY `uid` (`uid`,`order_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `sdk` (`sdk`) USING BTREE,
  KEY `rmb` (`rmb`) USING BTREE,
  KEY `updated_at` (`updated_at`) USING BTREE,
  KEY `created_at` (`created_at`) USING BTREE,
  KEY `success` (`success`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Table structure for blackword
-- ----------------------------
DROP TABLE IF EXISTS `blackword`;
CREATE TABLE `blackword` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` varchar(30) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `word` (`word`)
) ENGINE=InnoDB AUTO_INCREMENT=648 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blackword
-- ----------------------------
INSERT INTO `blackword` VALUES ('1', '习近平', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('2', '李源潮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('3', '李克强', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('4', '攻击党政', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('5', '攻击共党', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('6', '共匪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('7', '獨立臺灣', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('8', '台独', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('9', '疆独', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('10', '新疆独立', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('11', '反共', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('12', '分裂国家', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('13', '反政府', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('14', '反动', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('15', '反革命', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('16', '反华', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('17', '反右题材', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('18', '反中游行', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('19', '藏独', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('20', '藏獨', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('21', '西藏獨立', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('22', '西藏流亡政府', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('23', '1夜情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('24', 'AV出售', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('25', 'AV电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('26', 'AV女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('27', 'AV女优', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('28', 'A级', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('29', 'A片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('30', 'a片网', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('31', 'bt成人', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('32', 'b好痒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('33', 'b穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('34', 'b痒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('35', 'H电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('36', 'H片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('37', 'H图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('38', 'H站', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('39', 'j巴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('40', 'j吧', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('41', 'sex', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('42', 'SF网站定做', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('43', 'SM虐待', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('44', 'x伴侣', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('45', 'yindi', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('46', 'yinshui', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('47', 'yin部', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('48', 'yin道', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('49', 'yin毛', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('50', 'y蒂', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('51', 'y户', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('52', 'y茎', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('53', '爱液', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('54', '爆乳', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('55', '被人干', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('56', '屄儿', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('57', '屄裏', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('58', '屄友', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('59', '逼好痒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('60', '逼毛', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('61', '逼穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('62', '逼痒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('63', '博彩', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('64', '彩票机', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('65', '插爆', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('66', '插逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('67', '插的好舒服', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('68', '插肛', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('69', '插进来', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('70', '插进你下面', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('71', '插进穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('72', '插妹妹', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('73', '插弄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('74', '插女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('75', '插肉', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('76', '插入穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('77', '插穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('78', '潮吹', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('79', '成人', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('80', '激情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('81', '赤裸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('82', '抽插', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('83', '出售AV', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('84', '出售处男', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('85', '出售处女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('86', '出售假币', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('87', '出售美女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('88', '出售妹妹', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('89', '出售枪支', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('90', '出售手枪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('91', '处男出售', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('92', '处女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('93', '处女出售', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('94', '处女穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('95', '處女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('96', '處女膜', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('97', '吹箫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('98', '春宫图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('99', '春宵', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('100', '春药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('101', '肏屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('102', '肏干', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('103', '肏她', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('104', '肏妹妹', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('105', '肏妳', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('106', '肏娘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('107', '肏破', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('108', '肏入', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('109', '肏死', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('110', '肏我', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('111', '肏穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('112', '肏这', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('113', '操逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('114', '操比', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('115', '操小逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('116', '操穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('117', '打飞机', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('118', '打炮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('119', '等你插', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('120', '第一次破处', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('121', '点对点裸聊', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('122', '电车之狼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('123', '电影色情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('124', '赌博', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('125', '赌场', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('126', '赌城', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('127', '赌钱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('128', '赌球', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('129', '赌骰子', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('130', '发浪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('131', '发情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('132', '发骚', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('133', '粉红小b', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('134', '粉红小逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('135', '丰满坚挺', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('136', '丰乳肥臀', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('137', '丰韵少妇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('138', '风尘劫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('139', '风骚', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('140', '风骚侍女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('141', '肤白胸大', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('142', '肛插', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('143', '肛交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('144', '肛恋', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('145', '高潮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('146', '睪丸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('147', '搞个处女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('148', '你jj', '2014-12-12 11:14:11');
INSERT INTO `blackword` VALUES ('149', '合采开奖', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('150', '合彩', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('151', '合彩开奖', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('152', '和采开奖', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('153', '和彩开奖', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('154', '黃色小電影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('155', '黄片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('156', '黄色', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('157', '黄小说', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('158', '黄站', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('159', '鸡巴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('160', '鸡吧', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('161', '雞八', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('162', '雞巴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('163', '雞雞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('164', '妓女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('165', '奸淫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('166', '茎精', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('167', '精液', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('168', '老虎机', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('169', '菊花洞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('170', '菊花蕾', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('171', '菊花穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('172', '菊穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('173', '巨乳', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('174', '抠b', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('175', '抠逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('176', '口活', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('177', '口技', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('178', '口交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('179', '狂插', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('180', '狂穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('181', '两乳之间', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('182', '淫乱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('183', '露逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('184', '露穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('185', '卵蛋', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('186', '乱伦', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('187', '乱伦熟女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('188', '乱淫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('189', '亂倫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('190', '伦理片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('191', '轮奸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('192', '裸聊', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('193', '裸陪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('194', '裸体', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('195', '裸體', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('196', '裸照', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('197', '卖逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('198', '卖骚', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('199', '卖淫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('200', '毛片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('201', '美屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('202', '美女出售', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('203', '美女会所', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('204', '美女兼职', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('205', '美女裸体', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('206', '美女全套', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('207', '美女上门', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('208', '美女脱衣', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('209', '美少妇的哀羞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('210', '美少女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('211', '美穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('212', '妹的服务', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('213', '妹开苞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('214', '妹妹出售', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('215', '妹妹的屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('216', '妹妹穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('217', '猛操', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('218', '猛插', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('219', '猛料', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('220', '蒙汗', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('221', '蒙汗药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('222', '迷幻喷雾', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('223', '迷幻香烟', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('224', '迷昏药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('225', '迷魂', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('226', '迷魂药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('227', '迷奸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('228', '迷奸药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('229', '迷歼药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('230', '迷情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('231', '迷药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('232', '秘部', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('233', '秘處', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('234', '秘唇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('235', '秘肉', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('236', '密穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('237', '蜜唇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('238', '蜜洞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('239', '蜜壶', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('240', '蜜穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('241', '免费a片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('242', '摸奶', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('243', '摸胸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('244', '内射', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('245', '奶子', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('246', '公关', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('247', '嫩b', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('248', '嫩屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('249', '嫩逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('250', '嫩穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('251', '你敢上吗', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('252', '弄穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('253', '女孩上门', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('254', '女模招聘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('255', '女人穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('256', '女上门', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('257', '女死囚', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('258', '女体', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('259', '女优', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('260', '虐恋', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('261', '欧美色图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('262', '歐美bt', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('263', '牌九', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('264', '炮片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('265', '炮图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('266', '陪护私人', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('267', '陪裸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('268', '喷潮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('269', '喷尿', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('270', '喷雾型迷药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('271', '屁穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('272', '屁眼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('273', '嫖娼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('274', '破处', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('275', '枪淫少妇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('276', '强j', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('277', '强奸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('278', '强姦', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('279', '亲蛋蛋', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('280', '亲吻蛋蛋', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('281', '情色', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('282', '情色网', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('283', '情欲', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('284', '全套美女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('285', '群奸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('286', '群交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('287', '人妻小说', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('288', '肉棒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('289', '肉屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('290', '肉洞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('291', '肉缝', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('292', '肉根', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('293', '肉棍', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('294', '肉壶', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('295', '肉击', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('296', '肉茎', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('297', '肉具', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('298', '肉门', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('299', '肉丘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('300', '肉圈', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('301', '肉体交融', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('302', '肉臀', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('303', '肉穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('304', '肉芽', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('305', '乳fan', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('306', '乳房', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('307', '乳交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('308', '乳球', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('309', '乳首', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('310', '乳晕', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('311', '色情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('312', '三级片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('313', '搔穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('314', '骚屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('315', '骚逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('316', '骚比', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('317', '骚婊', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('318', '骚货', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('319', '骚姐姐', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('320', '骚浪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('321', '骚妹', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('322', '骚水', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('323', '骚穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('324', '骚痒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('325', '骚姊姊', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('326', '騷逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('327', '騷穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('328', '色电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('329', '色图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('330', '色淫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('331', '色友', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('332', '色诱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('333', '色欲', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('334', '少妇穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('335', '少女高潮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('336', '舌头添', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('337', '舌头舔', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('338', '射出来', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('339', '射精', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('340', '射乳', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('341', '涉毒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('342', '涉黄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('343', '涉枪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('344', '绳虐', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('345', '湿穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('346', '手淫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('347', '兽交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('348', '熟女俱乐部', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('349', '双腿叉开', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('350', '双腿间的禁地', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('351', '爽电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('352', '爽片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('353', '私密处', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('354', '添逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('355', '添你下面', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('356', '添阴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('357', '舔xue', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('358', '舔逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('359', '舔便', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('360', '舔遍', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('361', '舔肛', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('362', '舔花苞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('363', '舔奶', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('364', '舔弄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('365', '舔批', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('366', '舔舐', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('367', '舔吮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('368', '舔下面', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('369', '舔穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('370', '舔阴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('371', '偷窥', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('372', '偷拍', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('373', '透视', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('374', '臀洞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('375', '臀沟', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('376', '臀孔', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('377', '臀丘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('378', '无码片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('379', '小屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('380', '小电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('381', '小洞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('382', '小姐', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('383', '坐台', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('384', '小穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('385', '小姨子穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('386', '性爱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('387', '性吧', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('388', '性伴侣', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('389', '性电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('390', '性服务', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('391', '性服务工作者', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('392', '性感', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('393', '性高潮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('394', '性虎', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('395', '性交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('396', '性教官', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('397', '性开放的', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('398', '性开放俱乐部', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('399', '性奴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('400', '性虐待', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('401', '性启蒙老师', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('402', '性器', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('403', '性色', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('404', '性色社区', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('405', '性事', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('406', '性学教授', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('407', '性游戏', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('408', '性友谊', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('409', '性欲', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('410', '穴洞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('411', '穴口', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('412', '穴里', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('413', '穴前庭', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('414', '穴肉', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('415', '穴穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('416', '穴淫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('417', '亚洲色图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('418', '亞洲bt', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('419', '亞洲圖區', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('420', '阳具', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('421', '阳物', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('422', '摇头丸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('423', '夜场兼职', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('424', '夜场女模特', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('425', '夜场招聘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('426', '夜场直招', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('427', '夜情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('428', '夜总会公关', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('429', '夜总会模特', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('430', '夜总会招聘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('431', '一夜情', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('432', '阴chun', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('433', '阴dao', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('434', '阴di', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('435', '阴壁', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('436', '阴部', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('437', '阴纯', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('438', '阴唇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('439', '阴道', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('440', '阴蒂', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('441', '阴阜', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('442', '阴核', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('443', '阴户', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('444', '阴护', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('445', '阴茎', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('446', '阴毛', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('447', '阴丘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('448', '阴水', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('449', '阴穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('450', '陰部', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('451', '陰唇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('452', '陰道', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('453', '陰蒂', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('454', '陰核', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('455', '陰戶', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('456', '陰户', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('457', '陰茎', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('458', '陰莖', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('459', '陰毛', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('460', '陰穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('461', '婬水', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('462', '淫b', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('463', '淫暴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('464', '淫屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('465', '淫逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('466', '淫传', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('467', '淫唇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('468', '淫荡', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('469', '淫蕩少婦', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('470', '淫蕩丗家', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('471', '淫蕩孕婦', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('472', '淫道', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('473', '淫电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('474', '淫洞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('475', '淫妇', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('476', '淫棍', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('477', '淫秽词语', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('478', '淫奸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('479', '淫间道', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('480', '淫叫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('481', '淫浪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('482', '淫乱电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('483', '淫亂', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('484', '淫美贴图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('485', '淫妹', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('486', '淫靡', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('487', '淫民', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('488', '淫魔舞会', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('489', '淫男', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('490', '淫娘', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('491', '淫女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('492', '淫虐', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('493', '淫片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('494', '淫妻', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('495', '淫情女教师', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('496', '淫情贴图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('497', '淫色', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('498', '淫色网站', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('499', '淫声', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('500', '淫兽', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('501', '淫兽学园', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('502', '淫术炼金士', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('503', '淫水', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('504', '淫贴图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('505', '淫图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('506', '淫臀', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('507', '淫穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('508', '淫液', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('509', '淫阴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('510', '淫影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('511', '淫影片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('512', '淫影院', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('513', '淫欲', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('514', '淫汁', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('515', '有码片', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('516', '有碼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('517', '幼b', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('518', '幼逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('519', '幼交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('520', '幼女', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('521', '幼穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('522', '诱惑电影', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('523', '诱惑视频', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('524', '诱奸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('525', '诱人双峰', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('526', '玉女吹箫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('527', '玉蒲团', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('528', '玉穴', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('529', '欲生欲死', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('530', '援交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('531', '自慰', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('532', '最新黄站', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('533', '最淫官员', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('534', '作爱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('535', '做ai', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('536', '做爱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('537', '做愛', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('538', '做鸡', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('539', '日逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('540', 'G点高潮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('541', 'H动漫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('542', 'H漫画', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('543', 'P眼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('544', 'SM', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('545', '屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('546', '獸交', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('547', '包皮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('548', '避孕套', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('549', '操屄', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('550', '操蛋', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('551', '操', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('552', '超级性虐', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('553', '成人交友', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('554', '成人书库', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('555', '成人图', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('556', '成人用品', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('557', '臭逼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('558', '处女膜', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('559', '处女终结者', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('560', '床上猛男', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('561', '吹气娃娃', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('562', '激情陪聊', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('563', '鸡八', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('564', '鸡把', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('565', '鸡奸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('566', '奸尸', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('567', '奸幼', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('568', '性交易', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('569', '性经验', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('570', '性', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('571', '性骚扰', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('572', '淫', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('573', 'K粉', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('574', '本拉登', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('575', '冰毒', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('576', '病毒营销', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('577', '催情药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('578', '盗窃', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('579', '盗取', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('580', '东突', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('581', '动乱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('582', '動乱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('583', '毒品', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('584', '發票', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('585', '法lun功', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('586', '法轮', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('587', '法轮大法', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('588', '法轮功', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('589', '法輪功', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('590', '仿54', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('591', '仿64', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('592', '仿六四', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('593', '仿五四', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('594', '仿真假钞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('595', '仿真枪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('596', '高薪日结', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('597', '假币', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('598', '假钞', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('599', '假钱', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('600', '买卖枪支', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('601', '买枪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('602', '卖枪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('603', '枪支弹药', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('604', '窃听', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('605', '窃听器', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('606', '窃听器材', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('607', '售枪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('608', '双管立式猎枪', '2014-10-29 10:49:14');
INSERT INTO `blackword` VALUES ('609', '双管猎枪', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('610', '小口径步枪', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('611', '证件办理', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('612', '自制枪', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('613', '自制手枪', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('614', '枪', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('615', '海洛因', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('616', '骰宝', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('617', 'FaLunGong', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('618', 'Fa Lun Gong', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('619', 'FLG', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('620', '操', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('621', '操你妈', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('622', '操你奶奶', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('623', '干你娘', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('624', '他妈的', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('625', '我操', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('626', '日你妈', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('627', 'fuck', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('628', '操尼妈', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('629', '幹你娘', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('630', '逼样', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('631', '草逼', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('632', '草你妈', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('633', '草你吗', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('634', '草死', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('635', '草他', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('636', '草她', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('637', '荡妇', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('638', '狗b', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('639', '狗操', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('640', '狗卵子', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('641', '贱逼', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('642', '贱比', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('643', '贱货', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('644', '贱人', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('645', '你妈', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('646', '靠', '2014-10-29 10:49:15');
INSERT INTO `blackword` VALUES ('647', '傻B', '2014-10-29 10:49:15');

-- ----------------------------
-- Table structure for channel_infos
-- ----------------------------
DROP TABLE IF EXISTS `channel_infos`;
CREATE TABLE `channel_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(50) DEFAULT NULL COMMENT '渠道名称',
  `channel` varchar(50) DEFAULT '' COMMENT '渠道号',
  `channel_mode` varchar(50) DEFAULT NULL COMMENT '推广模式',
  `channel_update` varchar(50) DEFAULT NULL COMMENT '更新渠道ID',
  `memo` varchar(50) DEFAULT NULL COMMENT '商务',
  `validper` float DEFAULT '1' COMMENT '0~1之间的数，表示该渠道结算有效用户数时的真实数据的百分比，用于扣量',
  `memo2` varchar(100) DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '日期',
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel` (`channel`) USING BTREE,
  KEY `channel_name` (`channel_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=324 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of channel_infos
-- ----------------------------
INSERT INTO `channel_infos` VALUES ('1', '内部测试', '100custest000001', '', '', '', '1', null, '2014-07-01 09:43:10');
INSERT INTO `channel_infos` VALUES ('2', '炸金花更多游戏', '3003918547', 'free', '', '黄俊桥', '1', '', '2014-08-12 00:00:00');
INSERT INTO `channel_infos` VALUES ('3', '商用测试渠道', '3003918544', 'free', '', '', '1', '', '2014-08-12 11:15:57');
INSERT INTO `channel_infos` VALUES ('4', 'MM渠道', '0000000000', 'free', '3003997519', '', '1', '', '2014-08-12 00:00:00');
INSERT INTO `channel_infos` VALUES ('5', '玩家下载', '3003918421', 'free', '', '', '1', '', '2014-08-12 11:15:57');
INSERT INTO `channel_infos` VALUES ('6', '联通wo商城', '0000000002', 'free', '3003918405', '', '1', '', '2014-08-19 10:10:05');
INSERT INTO `channel_infos` VALUES ('7', '广点通', '3003918429', 'CPC', '', '李恺', '1', 'v1.8', '2014-08-19 00:00:00');
INSERT INTO `channel_infos` VALUES ('8', '搜狗手机助手', '3003918407', 'free', '', '张凯', '1', null, '2014-09-19 17:55:29');
INSERT INTO `channel_infos` VALUES ('9', '迈奔', '2200016447', 'CPS', '', '张凯', '1', null, '2014-09-22 15:24:54');
INSERT INTO `channel_infos` VALUES ('10', '爱奇艺', '2200139630', '其他', '', '', '1', null, '2014-08-21 10:59:21');
INSERT INTO `channel_infos` VALUES ('11', '美传网络', '3003918414', 'CPA', '', '周敏', '1', 'v1.2', '2014-08-21 18:17:48');
INSERT INTO `channel_infos` VALUES ('12', '成都当乐', '2200112286', 'CPS', '', '张凯', '1', 'v2.1', '2015-11-05 00:00:00');
INSERT INTO `channel_infos` VALUES ('13', '应用汇', '2200000165', 'CPS', '', '张凯', '1', 'v2.1', '2015-11-05 00:00:00');
INSERT INTO `channel_infos` VALUES ('14', 'wifipush', '3003918412', 'CPA', '', '张凯', '1', null, '2014-10-29 11:11:26');
INSERT INTO `channel_infos` VALUES ('15', '搜狗搜索', '3003918432', 'CPS', '', '张凯', '1', null, '2014-09-19 17:56:23');
INSERT INTO `channel_infos` VALUES ('16', '乐语世纪', '2200139649', 'CPS', '', '张凯', '1', null, '2014-08-26 15:20:55');
INSERT INTO `channel_infos` VALUES ('17', '飞流', '3003918435', 'CPS', '', '张凯', '1', null, '2014-08-26 17:21:19');
INSERT INTO `channel_infos` VALUES ('18', 'wifipush2', '3003918436', 'CPA', '', '张凯', '1', 'v1.9', '2015-06-04 00:00:00');
INSERT INTO `channel_infos` VALUES ('19', '土豪牛牛(KeKe)测试渠道', '0000000003', '其他', '', '测试', '1', null, '2014-08-28 09:41:15');
INSERT INTO `channel_infos` VALUES ('20', 'WIFI万能钥匙', '3003918444', 'CPS', '', '张凯', '1', 'v1.8', '2015-05-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('21', 'WIFIPUSH1', '3003918449', 'CPA', '', '张凯', '1', null, '2014-09-01 14:03:46');
INSERT INTO `channel_infos` VALUES ('22', '土豪牛牛(KeKe)MM渠道审核', '0000000004', '其他', '', '测试', '1', null, '2014-09-01 14:04:48');
INSERT INTO `channel_infos` VALUES ('23', '土豪一锅端更多游戏', '3003918543', 'free', '', '小欧', '1', '', '2014-09-02 00:00:00');
INSERT INTO `channel_infos` VALUES ('24', '多米', '3003918454', 'CPA', '', '张凯', '1', 'v2.1', '2015-11-05 00:00:00');
INSERT INTO `channel_infos` VALUES ('25', '历趣市场', '2200126314', 'CPS', '', '张凯', '1', null, '2014-09-03 15:32:21');
INSERT INTO `channel_infos` VALUES ('26', '浩游网讯', '2200125254', 'CPS', '', '张凯', '1', null, '2014-09-03 15:32:42');
INSERT INTO `channel_infos` VALUES ('27', '客户蒋', '3003918476', 'CPA', '', '余沛', '1', '', '2014-09-04 09:25:27');
INSERT INTO `channel_infos` VALUES ('28', 'PTBUS', '2200131081', 'CPS', '', '张凯', '1', null, '2014-09-04 11:13:51');
INSERT INTO `channel_infos` VALUES ('29', '北京千尺无限软件技术有限公司', '2200123317', 'free', '', '李媛珍', '1', 'v1.8', '2015-05-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('30', '欧乐吧', '2200127675', 'CPS', '', '张凯', '1', null, '2014-09-04 11:15:14');
INSERT INTO `channel_infos` VALUES ('31', '网易', '3003918457', 'free', '', '周全', '1', null, '2014-09-04 11:57:10');
INSERT INTO `channel_infos` VALUES ('32', '历趣', '3003918459', 'CPA', '', '张凯', '1', null, '2014-09-04 14:18:44');
INSERT INTO `channel_infos` VALUES ('33', '安贝市场', '3003918460', 'free', '', '周全', '1', '', '2014-09-05 11:51:40');
INSERT INTO `channel_infos` VALUES ('34', '广狐市场', '3003918467', 'CPS', '', '张凯', '1', '', '2014-09-05 11:54:23');
INSERT INTO `channel_infos` VALUES ('35', 'UUC', '100lianyun001', 'CPS', '', '张凯', '1', 'UUC 联运版本，支付只有UUC的短代支付，不走MM派生包', '2014-09-05 14:07:22');
INSERT INTO `channel_infos` VALUES ('36', '金立易用汇', '3003918469', 'free', '', '周全', '1', '', '2014-09-05 14:35:23');
INSERT INTO `channel_infos` VALUES ('37', '魅族(安徽尚趣玩)', '2200144172', 'CPS', '', '张凯', '1', null, '2014-09-10 11:52:49');
INSERT INTO `channel_infos` VALUES ('38', '金立通信', '2200126429', 'CPS', '', '张凯', '1', '渠道派生', '2014-09-11 11:27:18');
INSERT INTO `channel_infos` VALUES ('39', 'freewifi渠道', '3003918470', '', '', 'Sam', '1', '', '2014-09-12 09:42:15');
INSERT INTO `channel_infos` VALUES ('40', '斯凯网络子渠道6-冒泡市场', '2200105212', 'CPS', '', '张凯', '1', '', '2014-09-15 14:34:44');
INSERT INTO `channel_infos` VALUES ('41', '斯凯网络子渠道38-冒泡游戏中心', '2200105905', 'CPS', '', '张凯', '1', '', '2014-09-15 14:37:58');
INSERT INTO `channel_infos` VALUES ('42', '搜狗信息', '2200124080', 'CPS', '', '张凯', '1', '渠道从MM自派生包', '2014-09-22 14:04:59');
INSERT INTO `channel_infos` VALUES ('43', '安智平台', '3003918474', 'CPA', '', '张凯', '1', '', '2014-09-16 13:56:39');
INSERT INTO `channel_infos` VALUES ('44', '北京联想调频', '2200125875', 'free', '', '李恺', '1', 'v1.2', '2014-09-22 09:55:19');
INSERT INTO `channel_infos` VALUES ('45', '湖北省联通线下渠道', '3003918478', 'CPS', '', '李恺', '1', 'v1.2', '2014-09-22 10:53:29');
INSERT INTO `channel_infos` VALUES ('47', 'wifipush3', '3003918481', 'CPA', '', '张凯', '1', 'v1.8', '2015-05-13 00:00:00');
INSERT INTO `channel_infos` VALUES ('48', '爱手游网', '3003918483', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:40:42');
INSERT INTO `channel_infos` VALUES ('49', '木蚂蚁', '2200123528', 'CPS', '', '李恺', '1', 'v1.2', '2014-09-23 14:26:55');
INSERT INTO `channel_infos` VALUES ('50', '安卓商店', '3003918485', 'free', '', '周全', '1', 'v1.2', '2014-09-23 15:14:15');
INSERT INTO `channel_infos` VALUES ('51', '游戏多', '3003918486', 'CPA', '', 'Sam', '1', 'v1.2', '2014-09-24 16:40:43');
INSERT INTO `channel_infos` VALUES ('52', '联通wo商城更新渠道', '3003918405', 'free', '', '李媛珍', '1', 'v1.2', '2015-12-03 14:25:20');
INSERT INTO `channel_infos` VALUES ('53', '桌乐市场', '3003918490', '', '', '张俪', '1', 'v1.2', '2014-09-26 09:43:11');
INSERT INTO `channel_infos` VALUES ('54', '联通派生包测试', '3003918542', '', '', '', '1', 'v1.2，在MM上用来测试，', '2014-09-28 11:12:06');
INSERT INTO `channel_infos` VALUES ('55', '可可联运', '2200110945', '', '', '张凯', '1', 'v1.1 版本，接入可可支付，话费支付，MM派生包 土豪牛牛（送话费）\r\nV1.9\r\nv2.0\r\n高舟', '2015-12-09 00:00:00');
INSERT INTO `channel_infos` VALUES ('56', '微信群发平台', '3003918488', '', '', '余帆', '1', 'v1.2', '2014-10-08 10:14:06');
INSERT INTO `channel_infos` VALUES ('57', '和游戏审核版本', '0000000005', '其他', '', '', '1', 'v1.2', '2014-10-09 14:15:19');
INSERT INTO `channel_infos` VALUES ('58', '金立游戏大厅', '3003918492', '', '', '黄振', '1', 'v1.2', '2014-10-09 16:08:15');
INSERT INTO `channel_infos` VALUES ('59', '360', '2200003386', 'CPS', '', '张凯', '1', 'v1.2', '2014-10-21 09:58:52');
INSERT INTO `channel_infos` VALUES ('60', '宝瓶网', '3003918495', 'free', '', '周全', '1', 'v1.2', '2014-10-10 10:42:20');
INSERT INTO `channel_infos` VALUES ('61', '艺泰', '3003918497', '', '', '张浩', '1', 'v1.2', '2014-10-10 11:12:24');
INSERT INTO `channel_infos` VALUES ('62', '十字猫', '3003918499', 'free', '', '周全', '1', 'v1.2', '2014-10-10 15:48:23');
INSERT INTO `channel_infos` VALUES ('63', '北京创思（老虎地图）', '3003918501', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-29 11:11:34');
INSERT INTO `channel_infos` VALUES ('64', '深圳六吉', '3003918505', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-13 14:50:20');
INSERT INTO `channel_infos` VALUES ('65', '深圳市微腾之讯', '3003918508', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-13 14:50:57');
INSERT INTO `channel_infos` VALUES ('66', '七匣子网站', '3003918512', 'CPS', '', '李媛珍', '1', 'v1.2', '2015-12-03 14:40:37');
INSERT INTO `channel_infos` VALUES ('67', '三体科技', '3003918528', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-29 11:12:00');
INSERT INTO `channel_infos` VALUES ('68', '北京中讯搜', '3003918529', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-16 16:51:56');
INSERT INTO `channel_infos` VALUES ('70', '掌盟软件', '2200125829', 'free', '', '张凯', '1', '渠道从MM上自动取包 v1.2', '2015-12-03 15:09:09');
INSERT INTO `channel_infos` VALUES ('71', '蓝蛙科技', '3003918530', 'CPS', '', '周敏', '1', 'v1.2', '2014-10-29 11:12:19');
INSERT INTO `channel_infos` VALUES ('72', '欢乐人生', '3003918531', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-29 11:11:12');
INSERT INTO `channel_infos` VALUES ('73', '云帆', '3003918532', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-20 18:45:17');
INSERT INTO `channel_infos` VALUES ('75', 'v5手游平台', '3003918534', 'CPS', '', '李媛珍', '1', 'v1.2', '2015-12-03 14:31:04');
INSERT INTO `channel_infos` VALUES ('76', '电信送审版本', '0000000006', 'free', '', '送审', '1', 'v1.3', '2014-10-21 14:04:08');
INSERT INTO `channel_infos` VALUES ('77', '苏晴4', '3003918535', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-29 11:12:24');
INSERT INTO `channel_infos` VALUES ('80', '飞讯传媒', '3003918536', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-21 17:02:55');
INSERT INTO `channel_infos` VALUES ('81', '奥软网络科技', '2200113199', 'free', '', '', '1', '渠道从MM上自动取包   v1.2', '2014-10-21 17:46:14');
INSERT INTO `channel_infos` VALUES ('82', '杭州点告网络技术', '3003918537', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-22 10:47:45');
INSERT INTO `channel_infos` VALUES ('83', '中科天朗', '3003918539', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-22 16:09:12');
INSERT INTO `channel_infos` VALUES ('84', '汇和信息', '3003918540', 'CPA', '', '周敏', '1', 'v1.2', '2014-10-29 11:11:55');
INSERT INTO `channel_infos` VALUES ('86', '牛牛微信分享', '3003967914', 'free', '', '张凯', '1', 'v1.3', '2015-12-03 15:09:04');
INSERT INTO `channel_infos` VALUES ('87', '牛牛微博分享', '3003967915', 'free', '', '刘华', '1', 'v1.3', '2014-10-23 00:00:00');
INSERT INTO `channel_infos` VALUES ('88', '牛牛QQ空间分享', '3003967916', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:25:15');
INSERT INTO `channel_infos` VALUES ('89', 'ANG网盟推广', '3003967917', '', '', '', '1', 'v1.3', '2014-10-23 16:46:03');
INSERT INTO `channel_infos` VALUES ('90', '道有道', '3003967919', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-24 10:33:12');
INSERT INTO `channel_infos` VALUES ('91', '瞻宇软件1', '3003967920', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-29 11:11:17');
INSERT INTO `channel_infos` VALUES ('92', '瞻宇软件2', '3003967921', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-29 11:11:39');
INSERT INTO `channel_infos` VALUES ('93', '随e行', '3003967923', 'CPA', '', 'Sam', '1', 'v1.3', '2014-10-24 12:22:45');
INSERT INTO `channel_infos` VALUES ('94', '汇和信息2', '3003967924', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-24 14:42:37');
INSERT INTO `channel_infos` VALUES ('95', '蜂巢网络', '3003967925', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-29 11:12:10');
INSERT INTO `channel_infos` VALUES ('96', '北京万普世纪科技有限公司', '3003967926', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-24 14:43:59');
INSERT INTO `channel_infos` VALUES ('97', '美传网络2', '3003968000', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-27 09:52:41');
INSERT INTO `channel_infos` VALUES ('98', '成都当乐2', '3003967927', 'CPS', '', '张凯', '1', 'v2.1', '2015-11-05 00:00:00');
INSERT INTO `channel_infos` VALUES ('99', '泡椒思志子渠道4', '2200054047', 'free', '', '张浩', '1', 'v1.3', '2014-10-27 11:43:03');
INSERT INTO `channel_infos` VALUES ('100', '深圳百乐星科技有限公司', '3003968001', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-27 11:50:10');
INSERT INTO `channel_infos` VALUES ('101', '斯凯子渠道-冒泡浏览器', '2200105311', '', '', '张凯', '1', 'v1.3', '2014-10-27 15:03:10');
INSERT INTO `channel_infos` VALUES ('102', '可可MM送审版本', '0000000007', 'free', '', '送审', '1', 'v1.3', '2014-10-21 14:04:08');
INSERT INTO `channel_infos` VALUES ('103', '云测试包', '3003968016', 'free', '', '', '1', 'v1.3', '2014-10-21 14:04:08');
INSERT INTO `channel_infos` VALUES ('104', 'apk8', '3003967928', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:34');
INSERT INTO `channel_infos` VALUES ('105', '5G游戏库', '3003967929', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:31:00');
INSERT INTO `channel_infos` VALUES ('106', '游戏部落', '3003967930', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:55');
INSERT INTO `channel_infos` VALUES ('107', '笨手机', '3003968002', 'CPS', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:29');
INSERT INTO `channel_infos` VALUES ('108', '百度', '3003967931', '', '', '李恺', '1', 'v1.3', '2014-10-29 14:06:29');
INSERT INTO `channel_infos` VALUES ('109', '深圳有信1', '3003968003', 'CPS', '', '周敏', '1', 'v1.3', '2014-10-29 17:01:22');
INSERT INTO `channel_infos` VALUES ('110', '深圳有信2', '3003968005', 'CPS', '', '周敏', '1', 'v1.3', '2014-10-29 17:01:22');
INSERT INTO `channel_infos` VALUES ('111', '绿豆刷机', '3003968006', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-29 17:03:03');
INSERT INTO `channel_infos` VALUES ('112', '3G门户', '3003967932', 'CPS', '', '陈景', '1', 'v1.3', '2014-10-29 18:00:07');
INSERT INTO `channel_infos` VALUES ('113', '壹信', '3003967933', 'CPS', '', '张浩', '1', 'v1.3', '2014-10-30 10:49:31');
INSERT INTO `channel_infos` VALUES ('114', '魔头网', '3003968007', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-30 10:50:10');
INSERT INTO `channel_infos` VALUES ('115', 'APK安卓网', '3003968008', 'CPA', '', '周敏', '1', 'v1.3', '2014-10-30 14:40:59');
INSERT INTO `channel_infos` VALUES ('116', '北京欢乐人生', '3003968011', 'CPS', '', '周敏', '1', 'v1.3', '2014-10-31 14:12:28');
INSERT INTO `channel_infos` VALUES ('117', 'i9133', '3003967934', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:50');
INSERT INTO `channel_infos` VALUES ('118', '66游手机游戏', '3003967935', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:46');
INSERT INTO `channel_infos` VALUES ('119', '72G手机游戏门户', '3003968012', 'CPA', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:24');
INSERT INTO `channel_infos` VALUES ('120', '泡椒网', '3003967936', 'CPS', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:40:32');
INSERT INTO `channel_infos` VALUES ('121', '游戏园', '3003967940', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:20');
INSERT INTO `channel_infos` VALUES ('122', '趣创科技', '3003967941', 'CPS', '', '周全', '1', 'v1.3', '2014-11-04 11:30:04');
INSERT INTO `channel_infos` VALUES ('123', '北京中讯搜1', '3003968013', 'CPA', '', '周敏', '1', 'v1.3', '2014-11-04 14:33:23');
INSERT INTO `channel_infos` VALUES ('124', '北京中讯搜2', '3003968014', 'CPA', '', '周敏', '1', 'v1.3', '2014-11-04 14:33:23');
INSERT INTO `channel_infos` VALUES ('125', '游吧', '3003967942', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:16');
INSERT INTO `channel_infos` VALUES ('126', '优游网', '3003967943', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:42');
INSERT INTO `channel_infos` VALUES ('127', '手游天下', '3003967945', 'CPS', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:40:28');
INSERT INTO `channel_infos` VALUES ('128', 'yoyo手游', '3003967946', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:37');
INSERT INTO `channel_infos` VALUES ('129', 'apk8', '3003968015', 'CPS', '', '周敏', '1', 'v1.3', '2014-11-06 15:13:38');
INSERT INTO `channel_infos` VALUES ('130', '叶子猪手游通', '3003967947', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:11');
INSERT INTO `channel_infos` VALUES ('131', '久乐游网', '3003967948', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:33');
INSERT INTO `channel_infos` VALUES ('132', '暴风影音', '3003967989', 'CPS', '', '李媛珍', '1', 'v1.3', '2015-07-27 10:41:47');
INSERT INTO `channel_infos` VALUES ('133', '中手游1', '2200127169', 'CPS', '', '李媛珍', '1', 'v1.3 合成联通计费后，从MM上派生，tuhaobull_v1.3_20141110_zhongshouyou.apk', '2016-01-20 17:04:12');
INSERT INTO `channel_infos` VALUES ('134', '中手游2', '2200127238', 'CPS', '', '李媛珍', '1', 'v1.3 合成联通计费后，从MM上派生，tuhaobull_v1.3_20141110_zhongshouyou.apk', '2016-01-20 17:04:06');
INSERT INTO `channel_infos` VALUES ('135', 'MM送审渠道包', '0000000008', 'free', '', '', '1', '', '2014-11-07 10:46:24');
INSERT INTO `channel_infos` VALUES ('136', '不凡PC玩', '3003967949', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:06');
INSERT INTO `channel_infos` VALUES ('137', '飞鹏网', '3003967950', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:27');
INSERT INTO `channel_infos` VALUES ('138', '上方网', '3003967951', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:22');
INSERT INTO `channel_infos` VALUES ('139', '牛牛短信分享', '3003967952', 'free', '', '刘华', '1', '', '2014-11-10 00:00:00');
INSERT INTO `channel_infos` VALUES ('140', '超好玩', '3003967953', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:40:23');
INSERT INTO `channel_infos` VALUES ('141', '移动免商店', '3003967990', 'CPS', '', '周敏', '1', 'v1.3', '2014-11-11 11:54:42');
INSERT INTO `channel_infos` VALUES ('142', '游戏堡', '3003967954', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:26:01');
INSERT INTO `channel_infos` VALUES ('143', '打茄子手游网', '3003967955', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:30:17');
INSERT INTO `channel_infos` VALUES ('144', '微玩手游', '3003967956', 'free', '', '李媛珍', '1', 'v1.3', '2015-12-03 14:40:18');
INSERT INTO `channel_infos` VALUES ('145', '聚乐', '2200125277', 'CPS', '', '周敏', '1', 'v1.3 合成联通计费后，从MM上派生，tuhaobull_v1.3_20141110_jule.apk, 加了电信支付', '2014-11-12 09:22:20');
INSERT INTO `channel_infos` VALUES ('146', '金山网络', '2200123413', 'CPS', '', '周敏', '1', 'v1.3 合成联通计费后，从MM上派生，tuhaobull_v1.3_20141110_jinshan.apk, 加了电信支付', '2014-11-12 09:22:20');
INSERT INTO `channel_infos` VALUES ('147', '有米传媒', '3003967992', 'CPA', '', '周敏', '1', 'v1.3', '2014-11-17 11:16:22');
INSERT INTO `channel_infos` VALUES ('148', '北京景唐盛世', '3003967991', 'CPS', '', '周敏', '1', 'v1.3', '2014-11-18 11:03:26');
INSERT INTO `channel_infos` VALUES ('149', '野火网络子渠道44', '2200125530', 'free', '', '', '1', 'MM上自动抓取', '2014-11-17 15:40:51');
INSERT INTO `channel_infos` VALUES ('150', '火星网络', '2200130553', 'free', '', '', '1', 'MM上自动抓取', '2014-11-17 15:42:06');
INSERT INTO `channel_infos` VALUES ('151', '炫量', '3003967985', 'CPS', '', '周敏', '1', 'v1.4', '2014-11-21 13:07:20');
INSERT INTO `channel_infos` VALUES ('152', '靠谱助手', '3003967972', 'free', '', '李媛珍', '1', 'v1.4', '2015-12-03 14:30:11');
INSERT INTO `channel_infos` VALUES ('153', 'uc安卓应用商店', '3003967973', 'free', '', '李媛珍', '1', 'v1.4', '2015-12-03 14:30:07');
INSERT INTO `channel_infos` VALUES ('154', '广州七达信息', '3003967993', 'CPS', '', '周敏', '1', 'v1.4', '2014-11-25 14:05:31');
INSERT INTO `channel_infos` VALUES ('155', '线上社区推广', '3003967974', 'free', '', '周全', '1', 'v1.4', '2014-11-25 17:28:56');
INSERT INTO `channel_infos` VALUES ('156', '搜狐应用中心', '3003967977', 'free', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:25:09');
INSERT INTO `channel_infos` VALUES ('157', '上海横纵通模式', '3003967986', 'CPA', '', '周敏', '1', 'v1.4', '2014-11-27 15:30:27');
INSERT INTO `channel_infos` VALUES ('158', '冉十科技模式', '3003967987', 'CPA', '', '周敏', '1', 'v1.4', '2014-11-27 15:30:56');
INSERT INTO `channel_infos` VALUES ('159', '100TV', '3003967957', 'CPS', '', '张凯', '1', 'v1.4', '2014-12-01 10:59:25');
INSERT INTO `channel_infos` VALUES ('160', '北京搜狐', '2200007648', 'free', '', '李媛珍', '1', 'v1.4', '2015-12-03 14:25:05');
INSERT INTO `channel_infos` VALUES ('161', '日结', '3003967958', 'CPS', '', '张凯', '1', 'v1.4', '2014-12-03 17:16:40');
INSERT INTO `channel_infos` VALUES ('162', '内部测试2', '100custest000002', '其他', '', '', '1', '', '2014-12-04 11:55:21');
INSERT INTO `channel_infos` VALUES ('163', '腾讯959', '3003967959', 'free', '', '周全', '1', '土豪牛牛  v2.0', '2015-05-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('164', '91桌面', '3003967994', 'CPA', '', '周敏', '1', 'v1.4', '2014-12-05 09:31:27');
INSERT INTO `channel_infos` VALUES ('165', '铭智华通', '3003967988', 'CPA', '', '周敏', '1', 'v1.4', '2014-12-08 10:29:44');
INSERT INTO `channel_infos` VALUES ('166', '万普2', '3003967960', '其他', '', '周敏', '1', 'v1.6', '2014-12-18 13:47:22');
INSERT INTO `channel_infos` VALUES ('167', '华为', '2200109612', 'free', '', '张凯', '1', 'v1.6', '2015-12-03 15:08:59');
INSERT INTO `channel_infos` VALUES ('168', '2345助手', '3003967966', 'CPA', '', '周敏', '1', 'v1.6', '2014-12-23 15:10:05');
INSERT INTO `channel_infos` VALUES ('169', '子恒科技', '3003967961', 'CPS', '', '周全', '1', 'v1.6', '2015-01-04 12:03:54');
INSERT INTO `channel_infos` VALUES ('170', '子恒科技2', '3003967963', 'CPS', '', '周全', '1', 'v1.6', '2015-01-06 10:04:03');
INSERT INTO `channel_infos` VALUES ('171', '网博视讯', '3003967964', 'CPS', '', '李媛珍', '1', 'v1.6', '2015-12-03 14:29:45');
INSERT INTO `channel_infos` VALUES ('175', '九号塔', '3003967965', 'CPS', '', '李媛珍', '1', 'v1.6', '2015-12-03 14:25:57');
INSERT INTO `channel_infos` VALUES ('177', '广州e时代', '3003967967', 'CPS', '', '李媛珍', '1', 'v1.6', '2015-12-03 14:29:40');
INSERT INTO `channel_infos` VALUES ('178', '辑文信息‍', '3003967968', 'CPA', '', '李媛珍', '1', 'v1.6', '2015-12-03 14:29:36');
INSERT INTO `channel_infos` VALUES ('179', '杭州谋百网络科技有限公司', '3003967969', 'CPS', '', '李媛珍', '1', 'v1.6', '2015-01-29 15:30:32');
INSERT INTO `channel_infos` VALUES ('180', '北京致轩永业科技有限公司', '3003967970', 'CPS', '', '周全', '1', 'v1.6', '2015-01-30 16:24:08');
INSERT INTO `channel_infos` VALUES ('181', '广州优蜜信息科技有限公司', '3003967971', 'CPA', '', '张浩', '1', 'v1.6', '2015-01-30 16:46:42');
INSERT INTO `channel_infos` VALUES ('183', '爱点信息', '3003967979', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:29:32');
INSERT INTO `channel_infos` VALUES ('184', '掌时信息‍‍', '3003967980', 'CPA', '', '张浩', '1', 'v1.6', '2015-01-30 17:08:32');
INSERT INTO `channel_infos` VALUES ('185', '豌豆实验室', '2200000060', 'free', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:25:00');
INSERT INTO `channel_infos` VALUES ('186', '盟果', '3003967981', 'CPA', '', '李媛珍', '1', 'v1.6', '2015-12-03 14:42:45');
INSERT INTO `channel_infos` VALUES ('187', '杭州奕天', '3003967982', 'CPA', '', '张凯', '1', 'v1.6', '2015-02-04 15:43:25');
INSERT INTO `channel_infos` VALUES ('189', '豪游网络', '3003967983', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:24:54');
INSERT INTO `channel_infos` VALUES ('190', '天地在线', '3003967984', 'CPA', '', '张凯', '1', 'v1.6', '2015-02-05 14:44:19');
INSERT INTO `channel_infos` VALUES ('194', '联连', '3003967995', 'CPA', '', '张凯', '1', 'v2.1', '2015-11-10 00:00:00');
INSERT INTO `channel_infos` VALUES ('195', '爱德思奇', '3003967997', 'CPA', '', '张凯', '1', 'v1.7', '2015-02-06 16:30:42');
INSERT INTO `channel_infos` VALUES ('197', '有wifi', '3003967998', 'CPA', '', '张凯', '0.8', 'v1.7', '2015-02-10 16:01:42');
INSERT INTO `channel_infos` VALUES ('198', '上海猎鹰网络有限公司', '3003967999', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-02-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('199', '安卓园', '3003968010', 'free', '', '李恺', '1', 'v1.8', '2015-05-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('200', '北京触控科技有限公司', '3003985560', 'CPA', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:42:30');
INSERT INTO `channel_infos` VALUES ('201', '墨迹天气', '3003985568', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:24:49');
INSERT INTO `channel_infos` VALUES ('202', '神游网', '3003985571', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:29:26');
INSERT INTO `channel_infos` VALUES ('203', '果萌', '3003985572', 'free', '', '李恺', '0.1', 'v1.7', '2015-03-31 11:30:44');
INSERT INTO `channel_infos` VALUES ('204', '上海广升信息技术有限公司', '3003985573', 'CPA', '', '李媛珍', '0.6', 'v1.7', '2015-12-03 14:42:26');
INSERT INTO `channel_infos` VALUES ('205', 'baoruan', '3003985575', 'CPA', '', '张浩', '0.4', 'v1.8', '2015-05-20 00:00:00');
INSERT INTO `channel_infos` VALUES ('206', '光美', '3003985576', 'CPA', '', '张浩', '1', 'v1.7', '2015-03-12 14:38:12');
INSERT INTO `channel_infos` VALUES ('207', '酷米', '3003985577', 'CPA', '', '李媛珍', '0.1', 'v1.7', '2015-12-03 14:32:19');
INSERT INTO `channel_infos` VALUES ('208', '秀卓网络', '3003985578', 'CPA', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:42:20');
INSERT INTO `channel_infos` VALUES ('209', '大唐高鸿', '3003989503', 'CPA', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:42:15');
INSERT INTO `channel_infos` VALUES ('210', '魅族', '2200162546', 'free', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:24:44');
INSERT INTO `channel_infos` VALUES ('211', '国峰', '3003989506', 'CPA', '', '张浩', '1', 'v1.7', '2015-03-25 17:15:04');
INSERT INTO `channel_infos` VALUES ('212', '37互娱', '2200145410', 'free', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:24:37');
INSERT INTO `channel_infos` VALUES ('213', '深圳沃沃旺', '3003989509', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:45');
INSERT INTO `channel_infos` VALUES ('214', '余总', '3003989511', '', '', '余总', '1', 'v1.7', '2015-03-28 10:16:44');
INSERT INTO `channel_infos` VALUES ('215', '戴思软件‍', '3003989512', 'CPA', '', '李媛珍', '0.7', 'v1.7', '2015-12-03 14:28:41');
INSERT INTO `channel_infos` VALUES ('217', '酱游', '3003989516', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:35');
INSERT INTO `channel_infos` VALUES ('218', '新浪', '3003989518', 'CPC', '', '李恺', '1', 'v1.7', '2015-04-03 16:05:08');
INSERT INTO `channel_infos` VALUES ('220', '星星萌萌哒游戏平台', '3003989519', 'free', '', '黄俊桥', '1', 'v1.7', '2015-04-07 09:43:27');
INSERT INTO `channel_infos` VALUES ('221', '杭州蓝蛙', '3003992711', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:31');
INSERT INTO `channel_infos` VALUES ('222', '流量大爆炸', '3003992712', 'CPA', '', '李媛珍', '0', 'v1.7', '2015-12-03 14:25:52');
INSERT INTO `channel_infos` VALUES ('223', '果盟平台', '3003992714', 'CPA', '', '李媛珍', '0', 'v1.7', '2015-04-10 09:53:23');
INSERT INTO `channel_infos` VALUES ('224', '土豪斗地主（送话费）平台', '3003992715', '', '', '小欧', '1', 'v1.7', '2015-04-09 00:00:00');
INSERT INTO `channel_infos` VALUES ('225', '广狐', '3003992716', 'CPS', '', '李媛珍', '0.8', 'v1.8', '2015-07-27 10:42:07');
INSERT INTO `channel_infos` VALUES ('226', '今日头条大图', '3003992717', 'CPC', '', '周全', '1', 'v1.7', '2015-04-09 16:07:49');
INSERT INTO `channel_infos` VALUES ('227', '杭州蓝蛙2', '3003992718', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:26');
INSERT INTO `channel_infos` VALUES ('228', '今日头条小图', '3003992719', 'CPC', '', '周全', '1', 'v1.7', '2015-04-10 09:35:55');
INSERT INTO `channel_infos` VALUES ('229', '今日头条大图CPM', '3003992720', 'CPC', '', '周全', '1', 'v1.7', '2015-04-10 09:36:50');
INSERT INTO `channel_infos` VALUES ('230', '魅族通讯子渠道1', '2200163860', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:42:10');
INSERT INTO `channel_infos` VALUES ('231', '猎豹', '3003992721', 'CPA', '', '李媛珍', '0.7', 'v1.7', '2015-12-03 14:42:06');
INSERT INTO `channel_infos` VALUES ('232', '兴赛客网络', '3003992724', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-04-15 11:30:09');
INSERT INTO `channel_infos` VALUES ('233', '米拓', '3003992725', 'CPA', '', '张凯', '0.1', 'v1.7', '2015-05-11 16:15:52');
INSERT INTO `channel_infos` VALUES ('234', '舜邦', '2200161561', '', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:24:25');
INSERT INTO `channel_infos` VALUES ('235', '下载吧', '3003992727', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:22');
INSERT INTO `channel_infos` VALUES ('236', '宇龙计算机通信', '2200131904', '', '', '张凯', '1', 'v1.9', '2015-06-05 00:00:00');
INSERT INTO `channel_infos` VALUES ('237', '上海益玩子渠道10', '2200164704', '', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:18');
INSERT INTO `channel_infos` VALUES ('238', '上海益玩子渠道11', '2200164721', '', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:13');
INSERT INTO `channel_infos` VALUES ('239', '上海益玩子渠道3', '2200164687', '', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:28:08');
INSERT INTO `channel_infos` VALUES ('240', '上海益玩子渠道6', '2200163932', '', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:53');
INSERT INTO `channel_infos` VALUES ('241', '爆米花视频', '3003992728', 'CPS', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:27:49');
INSERT INTO `channel_infos` VALUES ('242', '广州众合', '3003992729', 'CPS', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:44');
INSERT INTO `channel_infos` VALUES ('243', '畅想科技', '2200130531', '', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:31:40');
INSERT INTO `channel_infos` VALUES ('244', '海涌杰信息', '3003992730', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:24:07');
INSERT INTO `channel_infos` VALUES ('245', '点乐', '3003992731', 'CPA', '', '黄正', '0.7', 'v1.7', '2015-04-29 00:00:00');
INSERT INTO `channel_infos` VALUES ('246', '金山', '3003992732', 'CPA', '', '张凯', '0.1', 'v1.8', '2015-06-02 11:37:38');
INSERT INTO `channel_infos` VALUES ('247', '有米信息', '3003992734', 'CPA', '', '李媛珍', '0.7', 'v1.7', '2015-12-03 14:42:01');
INSERT INTO `channel_infos` VALUES ('248', '广州豆点信息', '3003992735', 'CPA', '', '李媛珍', '0.6', 'v1.7', '2015-04-29 16:59:44');
INSERT INTO `channel_infos` VALUES ('249', '多游网', '3003996332', 'free', '', '李媛珍', '1', 'v1.7', '2015-12-03 14:31:35');
INSERT INTO `channel_infos` VALUES ('250', '广州趣游', '3003996333', 'CPA', '', '李媛珍', '0.5', 'v1.7', '2015-12-03 14:29:16');
INSERT INTO `channel_infos` VALUES ('251', '拓世纪', '3003996334', 'CPA', '', '李媛珍', '0.2', 'v1.8', '2015-12-03 14:29:06');
INSERT INTO `channel_infos` VALUES ('252', '深圳市圣盛网络', '3003996335', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:25:46');
INSERT INTO `channel_infos` VALUES ('253', '地主游戏大厅', '3003996337', '', '', '刘华', '1', 'v1.8', '2015-05-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('254', '金花游戏大厅', '3003996338', '', '', '', '1', 'v1.8', '2015-05-04 00:00:00');
INSERT INTO `channel_infos` VALUES ('255', '力天', '2200169878', '', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:39');
INSERT INTO `channel_infos` VALUES ('256', '飞游网', '3003996344', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:31:30');
INSERT INTO `channel_infos` VALUES ('257', '疯游', '3003996345', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:41:56');
INSERT INTO `channel_infos` VALUES ('258', '天翼WIFI', '3003996346', 'CPA', '', '李媛珍', '0.1', 'v1.8', '2015-12-03 14:32:15');
INSERT INTO `channel_infos` VALUES ('259', '聚侠网', '3003996347', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:31:25');
INSERT INTO `channel_infos` VALUES ('260', '北京青柠', '2200165894', '其他', '', '李媛珍', '1', 'v1.8', '2015-05-13 00:00:00');
INSERT INTO `channel_infos` VALUES ('261', 'MM渠道新版本', '000000000000', 'free', '3003997519', '', '1', '', '2014-08-12 00:00:00');
INSERT INTO `channel_infos` VALUES ('262', '搜狗', '3003996348', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:41:51');
INSERT INTO `channel_infos` VALUES ('263', '酷传', '3003996349', 'free', '', '李恺', '1', 'v1.8', '2015-05-15 00:00:00');
INSERT INTO `channel_infos` VALUES ('264', '联通116114', '3003996350', 'CPS', '', '李媛珍', '1', 'v1.8', '2015-12-03 14:32:10');
INSERT INTO `channel_infos` VALUES ('265', '斯凯冒泡社区1', '3003996351', 'CPS', '', '张凯', '1', '斯凯联运，无需派生v1.8', '2015-05-18 00:00:00');
INSERT INTO `channel_infos` VALUES ('266', '斯凯冒泡社区2', '3003996352', 'CPS', '', '张凯', '1', '斯凯联运，无需派生v1.8', '2015-05-18 00:00:00');
INSERT INTO `channel_infos` VALUES ('267', '斯凯冒泡社区3', '3003997517', 'CPS', '', '张凯', '1', '斯凯联运，无需派生v1.8', '2015-05-18 00:00:00');
INSERT INTO `channel_infos` VALUES ('268', '拇指玩', '2200163644', '其他', '', '李媛珍', '1', 'v1.8', '2015-05-20 00:00:00');
INSERT INTO `channel_infos` VALUES ('269', '美图秀秀', '2200166217', '', '', '李媛珍', '1', 'v1.9', '2015-07-01 00:00:00');
INSERT INTO `channel_infos` VALUES ('270', 'MM审核版本替换包', '3003997519', '', '', '刘华', '1', 'v1.9', '2015-05-25 00:00:00');
INSERT INTO `channel_infos` VALUES ('271', '加沃', '3003997520', 'CPA', '', '李媛珍', '0.7', 'v1.9', '2015-12-03 14:32:06');
INSERT INTO `channel_infos` VALUES ('272', '点狐助手', '3003997522', 'CPS', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:35');
INSERT INTO `channel_infos` VALUES ('273', '指奥', '3003997523', 'CPA', '', '张凯', '0.2', 'v1.9', '2015-06-08 16:09:41');
INSERT INTO `channel_infos` VALUES ('274', '阿里云', '3003997525', 'CPS', '', '张凯', '1', 'v2.1', '2015-11-05 00:00:00');
INSERT INTO `channel_infos` VALUES ('275', '康佳', '3003997526', 'CPA', '', '张凯', '1', 'v1.9', '2015-06-08 00:00:00');
INSERT INTO `channel_infos` VALUES ('276', '卓大师', '3003997528', 'CPA', '', '张凯', '0.5', 'v1.9', '2015-06-12 16:13:22');
INSERT INTO `channel_infos` VALUES ('277', '小辣椒科技', '2200170898', '', '', '张凯', '1', 'v2.1', '2015-11-05 00:00:00');
INSERT INTO `channel_infos` VALUES ('278', '上海二三四五移动', '2200165911', '', '', '李媛珍', '1', 'v1.9', '2015-06-25 00:00:00');
INSERT INTO `channel_infos` VALUES ('279', '北界无限', '2200096280', '其他', '', '张凯', '1', 'v1.9', '2015-06-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('280', '上海酷睿', '2200127353', '', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:30');
INSERT INTO `channel_infos` VALUES ('281', '亿信刷卡01', '3004002609', '', '', '姚总', '1', 'v1.8', '2015-06-15 00:00:00');
INSERT INTO `channel_infos` VALUES ('282', '捷通', '3003997529', 'CPA', '', '张凯', '1', 'v1.9', '2015-06-16 00:00:00');
INSERT INTO `channel_infos` VALUES ('283', '喜阅刷卡', '3004003274', '', '', '姚总', '1', 'v1.9', '2015-06-23 00:00:00');
INSERT INTO `channel_infos` VALUES ('284', '汉威刷卡', '3004004347', '', '', '姚总', '1', 'v1.8', '2015-07-02 00:00:00');
INSERT INTO `channel_infos` VALUES ('285', '亿信刷卡02', '3004002610', '', '', '姚总', '1', 'v1.8', '2015-07-07 00:00:00');
INSERT INTO `channel_infos` VALUES ('286', '牛仁网', '3003997530', 'CPA', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:26');
INSERT INTO `channel_infos` VALUES ('287', '高舟破解', '3004005397', '', '', '黄正', '1', 'v1.9', '2015-07-13 00:00:00');
INSERT INTO `channel_infos` VALUES ('288', '方明', '3004001273', 'CPS', '', '姚总', '1', 'v1.9', '2015-07-14 00:00:00');
INSERT INTO `channel_infos` VALUES ('289', 'banner', '3004001275', 'CPS', '', '张凯', '1', 'v1.9', '2015-07-21 00:00:00');
INSERT INTO `channel_infos` VALUES ('290', '百宝箱', '3004001276', 'CPS', '', '张凯', '1', 'v1.9', '2015-07-21 00:00:00');
INSERT INTO `channel_infos` VALUES ('291', '掌盟', '3004001277', 'CPS', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:22');
INSERT INTO `channel_infos` VALUES ('292', '图维破解', '3004004623', '', '', '黄正', '1', 'v1.9', '2015-08-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('293', '领誉破解', '3004006866', '', '', '黄正', '1', 'v1.9', '2015-07-30 00:00:00');
INSERT INTO `channel_infos` VALUES ('294', '趣娱', '3004001278', 'CPS', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:17');
INSERT INTO `channel_infos` VALUES ('295', '高舟恬静版破解', '3004007170', '', '', '黄正', '1', 'v1.9', '2015-08-03 00:00:00');
INSERT INTO `channel_infos` VALUES ('296', '高舟遥望版破解', '3004007235', '', '', '黄正', '1', 'v1.9', '2015-08-04 00:00:00');
INSERT INTO `channel_infos` VALUES ('297', '高舟极速版破解', '3004007267', '', '', '黄正', '1', 'v1.9', '2015-08-04 00:00:00');
INSERT INTO `channel_infos` VALUES ('298', '钱学', '3004001280', 'CPS', '', '姚总', '1', 'v1.9', '2015-08-06 00:00:00');
INSERT INTO `channel_infos` VALUES ('299', '沃非机智版破解', '3004007746', '', '', '黄正', '1', 'v1.9', '2015-08-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('300', '灵动横冲版破解', '3004007702', '', '', '黄正', '1', 'v1.9', '2015-08-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('301', '互达欢快版破解', '3004007680', '', '', '潘全泉', '1', 'v1.9', '2015-08-11 00:00:00');
INSERT INTO `channel_infos` VALUES ('302', '遇见派生', '2200163482', '', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:13');
INSERT INTO `channel_infos` VALUES ('303', '遇见', '3004001281', '', '', '李媛珍', '1', 'v1.9', '2015-12-03 14:27:07');
INSERT INTO `channel_infos` VALUES ('304', 'PRE', '3004001283', '', '', '李恺', '1', 'v1.9', '2015-08-19 00:00:00');
INSERT INTO `channel_infos` VALUES ('305', '钱学01', '3004008693', 'CPS', '', '姚总', '1', 'v1.9', '2015-08-20 00:00:00');
INSERT INTO `channel_infos` VALUES ('306', '钱学02', '3004008694', 'CPS', '', '姚总', '1', 'v1.9', '2015-08-20 00:00:00');
INSERT INTO `channel_infos` VALUES ('307', '钱学03', '3004008695', 'CPS', '', '姚总', '1', 'v1.9', '2015-08-20 00:00:00');
INSERT INTO `channel_infos` VALUES ('308', '钱学04', '3004008696', 'CPS', '', '姚总', '1', 'v1.9', '2015-08-20 00:00:00');
INSERT INTO `channel_infos` VALUES ('309', '钱学05', '3004008697', 'CPS', '', '姚总', '1', 'v1.9', '2015-08-20 00:00:00');
INSERT INTO `channel_infos` VALUES ('310', '杭州搜影', '3004001284', 'CPS', '', '李媛珍', '1', 'v1.9', '2015-08-24 00:00:00');
INSERT INTO `channel_infos` VALUES ('311', 'sina', '3004001287', 'CPS', '', '姚总', '1', 'v1.9', '2015-08-31 00:00:00');
INSERT INTO `channel_infos` VALUES ('312', '广州阳光信息科技', '3004007442', 'CPS', '', '李媛珍', '1', 'v2.0', '2015-09-21 00:00:00');
INSERT INTO `channel_infos` VALUES ('313', '风行', '3004010994', 'CPS', '', '李媛珍', '1', 'v2.0', '2015-09-21 00:00:00');
INSERT INTO `channel_infos` VALUES ('314', '破解', '3004010995', '', '', '小欧', '1', 'v2.0', '2015-09-22 00:00:00');
INSERT INTO `channel_infos` VALUES ('315', '益玩1', 'EWAN000001', '', '', '李媛珍', '1', '', '2015-10-27 00:00:00');
INSERT INTO `channel_infos` VALUES ('317', '博远', '3004010996', 'CPS', '', '余总', '1', 'v2.1', '2015-11-09 00:00:00');
INSERT INTO `channel_infos` VALUES ('318', '上海仁盈软件', '2200173015', '', '', '李媛珍', '1', 'v2.1', '2015-11-10 00:00:00');
INSERT INTO `channel_infos` VALUES ('319', '益玩百思', 'EWAN000002', '', '', '李媛珍', '1', 'v2.0', '2015-11-10 00:00:00');
INSERT INTO `channel_infos` VALUES ('320', '益玩夫妻宝典', 'EWAN000003', '', '', '李媛珍', '1', 'v2.0', '2015-11-10 00:00:00');
INSERT INTO `channel_infos` VALUES ('321', '益玩菊花宝典', 'EWAN000004', '', '', '李媛珍', '1', 'v2.0', '2015-11-10 00:00:00');
INSERT INTO `channel_infos` VALUES ('322', '益玩遇见', 'EWAN000005', '', '', '李媛珍', '1', 'v2.0', '2015-11-10 00:00:00');
INSERT INTO `channel_infos` VALUES ('323', 'ROOT静默安装_测试', '3004007738', 'free', '', '小欧', '1', 'v2.0', '2015-12-29 00:00:00');

-- ----------------------------
-- Table structure for cheat
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
) ENGINE=InnoDB AUTO_INCREMENT=162433 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of cheat
-- ----------------------------

-- ----------------------------
-- Table structure for core_prov
-- ----------------------------
DROP TABLE IF EXISTS `core_prov`;
CREATE TABLE `core_prov` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prov` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prov` (`prov`,`city`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=470 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of core_prov
-- ----------------------------
INSERT INTO `core_prov` VALUES ('1', '安徽', '滁州', '550', 'AH');
INSERT INTO `core_prov` VALUES ('2', '安徽', '合肥', '551', 'AH');
INSERT INTO `core_prov` VALUES ('3', '安徽', '蚌埠', '552', 'AH');
INSERT INTO `core_prov` VALUES ('4', '安徽', '芜湖', '553', 'AH');
INSERT INTO `core_prov` VALUES ('5', '安徽', '淮南', '554', 'AH');
INSERT INTO `core_prov` VALUES ('6', '安徽', '马鞍山', '555', 'AH');
INSERT INTO `core_prov` VALUES ('7', '安徽', '安庆', '556', 'AH');
INSERT INTO `core_prov` VALUES ('8', '安徽', '宿州', '557', 'AH');
INSERT INTO `core_prov` VALUES ('9', '安徽', '毫州', '558', 'AH');
INSERT INTO `core_prov` VALUES ('10', '安徽', '阜阳', '558', 'AH');
INSERT INTO `core_prov` VALUES ('11', '安徽', '亳州', '558', 'AH');
INSERT INTO `core_prov` VALUES ('12', '安徽', '黄山', '559', 'AH');
INSERT INTO `core_prov` VALUES ('13', '安徽', '淮北', '561', 'AH');
INSERT INTO `core_prov` VALUES ('14', '安徽', '铜陵', '562', 'AH');
INSERT INTO `core_prov` VALUES ('15', '安徽', '宣城', '563', 'AH');
INSERT INTO `core_prov` VALUES ('16', '安徽', '六安', '564', 'AH');
INSERT INTO `core_prov` VALUES ('17', '安徽', '巢湖', '565', 'AH');
INSERT INTO `core_prov` VALUES ('18', '安徽', '贵池', '566', 'AH');
INSERT INTO `core_prov` VALUES ('19', '安徽', '池州', '566', 'AH');
INSERT INTO `core_prov` VALUES ('20', '北京', '北京', '010', 'BJ');
INSERT INTO `core_prov` VALUES ('21', '重庆', '涪陵', '023', 'CQ');
INSERT INTO `core_prov` VALUES ('22', '重庆', '重庆', '023', 'CQ');
INSERT INTO `core_prov` VALUES ('23', '重庆', '万州', '023', 'CQ');
INSERT INTO `core_prov` VALUES ('24', '重庆', '黔江', '023', 'CQ');
INSERT INTO `core_prov` VALUES ('25', '福建', '福州', '591', 'FJ');
INSERT INTO `core_prov` VALUES ('26', '福建', '厦门', '592', 'FJ');
INSERT INTO `core_prov` VALUES ('27', '福建', '宁德', '593', 'FJ');
INSERT INTO `core_prov` VALUES ('28', '福建', '莆田', '594', 'FJ');
INSERT INTO `core_prov` VALUES ('29', '福建', '泉州', '595', 'FJ');
INSERT INTO `core_prov` VALUES ('30', '福建', '漳州', '596', 'FJ');
INSERT INTO `core_prov` VALUES ('31', '福建', '龙岩', '597', 'FJ');
INSERT INTO `core_prov` VALUES ('32', '福建', '三明', '598', 'FJ');
INSERT INTO `core_prov` VALUES ('33', '福建', '南平', '599', 'FJ');
INSERT INTO `core_prov` VALUES ('34', '广东', '花都', '020', 'GD');
INSERT INTO `core_prov` VALUES ('35', '广东', '番禺', '020', 'GD');
INSERT INTO `core_prov` VALUES ('36', '广东', '从化', '020', 'GD');
INSERT INTO `core_prov` VALUES ('37', '广东', '广州', '020', 'GD');
INSERT INTO `core_prov` VALUES ('38', '广东', '汕尾', '660', 'GD');
INSERT INTO `core_prov` VALUES ('39', '广东', '阳江', '662', 'GD');
INSERT INTO `core_prov` VALUES ('40', '广东', '揭阳', '663', 'GD');
INSERT INTO `core_prov` VALUES ('41', '广东', '茂名', '668', 'GD');
INSERT INTO `core_prov` VALUES ('42', '广东', '江门', '750', 'GD');
INSERT INTO `core_prov` VALUES ('43', '广东', '韶关', '751', 'GD');
INSERT INTO `core_prov` VALUES ('44', '广东', '惠州', '752', 'GD');
INSERT INTO `core_prov` VALUES ('45', '广东', '梅州', '753', 'GD');
INSERT INTO `core_prov` VALUES ('46', '广东', '汕头', '754', 'GD');
INSERT INTO `core_prov` VALUES ('47', '广东', '深圳', '755', 'GD');
INSERT INTO `core_prov` VALUES ('48', '广东', '珠海', '756', 'GD');
INSERT INTO `core_prov` VALUES ('49', '广东', '佛山', '757', 'GD');
INSERT INTO `core_prov` VALUES ('50', '广东', '肇庆', '758', 'GD');
INSERT INTO `core_prov` VALUES ('51', '广东', '湛江', '759', 'GD');
INSERT INTO `core_prov` VALUES ('52', '广东', '中山', '760', 'GD');
INSERT INTO `core_prov` VALUES ('53', '广东', '河源', '762', 'GD');
INSERT INTO `core_prov` VALUES ('54', '广东', '清远', '763', 'GD');
INSERT INTO `core_prov` VALUES ('55', '广东', '顺德', '765', 'GD');
INSERT INTO `core_prov` VALUES ('56', '广东', '云浮', '766', 'GD');
INSERT INTO `core_prov` VALUES ('57', '广东', '潮州', '768', 'GD');
INSERT INTO `core_prov` VALUES ('58', '广东', '东莞', '769', 'GD');
INSERT INTO `core_prov` VALUES ('59', '甘肃', '临夏', '930', 'GS');
INSERT INTO `core_prov` VALUES ('60', '甘肃', '兰州', '931', 'GS');
INSERT INTO `core_prov` VALUES ('61', '甘肃', '定西', '932', 'GS');
INSERT INTO `core_prov` VALUES ('62', '甘肃', '平凉', '933', 'GS');
INSERT INTO `core_prov` VALUES ('63', '甘肃', '西峰', '934', 'GS');
INSERT INTO `core_prov` VALUES ('64', '甘肃', '庆阳', '934', 'GS');
INSERT INTO `core_prov` VALUES ('65', '甘肃', '金昌', '935', 'GS');
INSERT INTO `core_prov` VALUES ('66', '甘肃', '金昌武威', '935', 'GS');
INSERT INTO `core_prov` VALUES ('67', '甘肃', '武威/金昌', '935', 'GS');
INSERT INTO `core_prov` VALUES ('68', '甘肃', '武威', '935', 'GS');
INSERT INTO `core_prov` VALUES ('69', '甘肃', '张掖', '936', 'GS');
INSERT INTO `core_prov` VALUES ('70', '甘肃', '酒泉', '937', 'GS');
INSERT INTO `core_prov` VALUES ('71', '甘肃', '嘉峪关', '937', 'GS');
INSERT INTO `core_prov` VALUES ('72', '甘肃', '酒泉/嘉峪关', '937', 'GS');
INSERT INTO `core_prov` VALUES ('73', '甘肃', '酒泉嘉峪关', '937', 'GS');
INSERT INTO `core_prov` VALUES ('74', '甘肃', '天水', '938', 'GS');
INSERT INTO `core_prov` VALUES ('75', '甘肃', '武都', '939', 'GS');
INSERT INTO `core_prov` VALUES ('76', '甘肃', '陇南', '939', 'GS');
INSERT INTO `core_prov` VALUES ('77', '甘肃', '甘南', '941', 'GS');
INSERT INTO `core_prov` VALUES ('78', '甘肃', '白银', '943', 'GS');
INSERT INTO `core_prov` VALUES ('79', '广西', '防城港', '770', 'GX');
INSERT INTO `core_prov` VALUES ('80', '广西', '崇左', '771', 'GX');
INSERT INTO `core_prov` VALUES ('81', '广西', '南宁', '771', 'GX');
INSERT INTO `core_prov` VALUES ('82', '广西', '来宾', '772', 'GX');
INSERT INTO `core_prov` VALUES ('83', '广西', '柳州', '772', 'GX');
INSERT INTO `core_prov` VALUES ('84', '广西', '桂林', '773', 'GX');
INSERT INTO `core_prov` VALUES ('85', '广西', '贺州', '774', 'GX');
INSERT INTO `core_prov` VALUES ('86', '广西', '贺州地区', '774', 'GX');
INSERT INTO `core_prov` VALUES ('87', '广西', '梧州', '774', 'GX');
INSERT INTO `core_prov` VALUES ('88', '广西', '梧州/贺州', '774', 'GX');
INSERT INTO `core_prov` VALUES ('89', '广西', '玉林/贵港', '775', 'GX');
INSERT INTO `core_prov` VALUES ('90', '广西', '玉林', '775', 'GX');
INSERT INTO `core_prov` VALUES ('91', '广西', '贵港', '775', 'GX');
INSERT INTO `core_prov` VALUES ('92', '广西', '百色', '776', 'GX');
INSERT INTO `core_prov` VALUES ('93', '广西', '钦州', '777', 'GX');
INSERT INTO `core_prov` VALUES ('94', '广西', '河池', '778', 'GX');
INSERT INTO `core_prov` VALUES ('95', '广西', '北海', '779', 'GX');
INSERT INTO `core_prov` VALUES ('96', '贵州', '贵阳', '851', 'GZ');
INSERT INTO `core_prov` VALUES ('97', '贵州', '遵义', '852', 'GZ');
INSERT INTO `core_prov` VALUES ('98', '贵州', '安顺', '853', 'GZ');
INSERT INTO `core_prov` VALUES ('99', '贵州', '都匀', '854', 'GZ');
INSERT INTO `core_prov` VALUES ('100', '贵州', '黔南(都匀)', '854', 'GZ');
INSERT INTO `core_prov` VALUES ('101', '贵州', '黔南', '854', 'GZ');
INSERT INTO `core_prov` VALUES ('102', '贵州', '黔东南', '855', 'GZ');
INSERT INTO `core_prov` VALUES ('103', '贵州', '凯里', '855', 'GZ');
INSERT INTO `core_prov` VALUES ('104', '贵州', '黔东南(凯里)', '855', 'GZ');
INSERT INTO `core_prov` VALUES ('105', '贵州', '铜仁', '856', 'GZ');
INSERT INTO `core_prov` VALUES ('106', '贵州', '毕节', '857', 'GZ');
INSERT INTO `core_prov` VALUES ('107', '贵州', '六盘水', '858', 'GZ');
INSERT INTO `core_prov` VALUES ('108', '贵州', '黔西南(兴义)', '859', 'GZ');
INSERT INTO `core_prov` VALUES ('109', '贵州', '黔西南', '859', 'GZ');
INSERT INTO `core_prov` VALUES ('110', '贵州', '兴义', '859', 'GZ');
INSERT INTO `core_prov` VALUES ('111', '海南', '海南', '890', 'HAIN');
INSERT INTO `core_prov` VALUES ('112', '海南', '海口', '898', 'HAIN');
INSERT INTO `core_prov` VALUES ('113', '海南', '海口/三亚', '898', 'HAIN');
INSERT INTO `core_prov` VALUES ('114', '湖北', '江汉', '027', 'HB');
INSERT INTO `core_prov` VALUES ('115', '湖北', '江汉(天门/仙桃/潜江)', '027', 'HB');
INSERT INTO `core_prov` VALUES ('116', '湖北', '武汉', '027', 'HB');
INSERT INTO `core_prov` VALUES ('117', '湖北', '襄樊', '710', 'HB');
INSERT INTO `core_prov` VALUES ('118', '湖北', '鄂州', '711', 'HB');
INSERT INTO `core_prov` VALUES ('119', '湖北', '孝感', '712', 'HB');
INSERT INTO `core_prov` VALUES ('120', '湖北', '黄冈', '713', 'HB');
INSERT INTO `core_prov` VALUES ('121', '湖北', '黄石', '714', 'HB');
INSERT INTO `core_prov` VALUES ('122', '湖北', '咸宁', '715', 'HB');
INSERT INTO `core_prov` VALUES ('123', '湖北', '荆州', '716', 'HB');
INSERT INTO `core_prov` VALUES ('124', '湖北', '宜昌', '717', 'HB');
INSERT INTO `core_prov` VALUES ('125', '湖北', '恩施', '718', 'HB');
INSERT INTO `core_prov` VALUES ('126', '湖北', '十堰', '719', 'HB');
INSERT INTO `core_prov` VALUES ('127', '湖北', '随州', '722', 'HB');
INSERT INTO `core_prov` VALUES ('128', '湖北', '荆门', '724', 'HB');
INSERT INTO `core_prov` VALUES ('129', '湖北', '仙桃', '728', 'HB');
INSERT INTO `core_prov` VALUES ('130', '湖北', '潜江', '728', 'HB');
INSERT INTO `core_prov` VALUES ('131', '湖北', '天门', '728', 'HB');
INSERT INTO `core_prov` VALUES ('132', '河北', '邯郸', '310', 'HEB');
INSERT INTO `core_prov` VALUES ('133', '河北', '石家庄', '311', 'HEB');
INSERT INTO `core_prov` VALUES ('134', '河北', '保定', '312', 'HEB');
INSERT INTO `core_prov` VALUES ('135', '河北', '张家口', '313', 'HEB');
INSERT INTO `core_prov` VALUES ('136', '河北', '承德', '314', 'HEB');
INSERT INTO `core_prov` VALUES ('137', '河北', '唐山', '315', 'HEB');
INSERT INTO `core_prov` VALUES ('138', '河北', '廊坊', '316', 'HEB');
INSERT INTO `core_prov` VALUES ('139', '河北', '沧州', '317', 'HEB');
INSERT INTO `core_prov` VALUES ('140', '河北', '衡水', '318', 'HEB');
INSERT INTO `core_prov` VALUES ('141', '河北', '邢台', '319', 'HEB');
INSERT INTO `core_prov` VALUES ('142', '河北', '秦皇岛', '335', 'HEB');
INSERT INTO `core_prov` VALUES ('143', '黑龙江', '哈尔滨', '451', 'HLJ');
INSERT INTO `core_prov` VALUES ('144', '黑龙江', '齐齐哈尔', '452', 'HLJ');
INSERT INTO `core_prov` VALUES ('145', '黑龙江', '牡丹江', '453', 'HLJ');
INSERT INTO `core_prov` VALUES ('146', '黑龙江', '佳木斯', '454', 'HLJ');
INSERT INTO `core_prov` VALUES ('147', '黑龙江', '绥化', '455', 'HLJ');
INSERT INTO `core_prov` VALUES ('148', '黑龙江', '黑河', '456', 'HLJ');
INSERT INTO `core_prov` VALUES ('149', '黑龙江', '大兴安岭', '457', 'HLJ');
INSERT INTO `core_prov` VALUES ('150', '黑龙江', '伊春', '458', 'HLJ');
INSERT INTO `core_prov` VALUES ('151', '黑龙江', '大庆', '459', 'HLJ');
INSERT INTO `core_prov` VALUES ('152', '黑龙江', '七台河', '464', 'HLJ');
INSERT INTO `core_prov` VALUES ('153', '黑龙江', '鸡西', '467', 'HLJ');
INSERT INTO `core_prov` VALUES ('154', '黑龙江', '鹤岗', '468', 'HLJ');
INSERT INTO `core_prov` VALUES ('155', '黑龙江', '双鸭山', '469', 'HLJ');
INSERT INTO `core_prov` VALUES ('156', '河南', '商丘', '370', 'HN');
INSERT INTO `core_prov` VALUES ('157', '河南', '郑州', '371', 'HN');
INSERT INTO `core_prov` VALUES ('158', '河南', '安阳', '372', 'HN');
INSERT INTO `core_prov` VALUES ('159', '河南', '新乡', '373', 'HN');
INSERT INTO `core_prov` VALUES ('160', '河南', '许昌', '374', 'HN');
INSERT INTO `core_prov` VALUES ('161', '河南', '平顶山', '375', 'HN');
INSERT INTO `core_prov` VALUES ('162', '河南', '信阳', '376', 'HN');
INSERT INTO `core_prov` VALUES ('163', '河南', '潢川', '376', 'HN');
INSERT INTO `core_prov` VALUES ('164', '河南', '南阳', '377', 'HN');
INSERT INTO `core_prov` VALUES ('165', '河南', '开封', '378', 'HN');
INSERT INTO `core_prov` VALUES ('166', '河南', '洛阳', '379', 'HN');
INSERT INTO `core_prov` VALUES ('167', '河南', '焦作/济源', '391', 'HN');
INSERT INTO `core_prov` VALUES ('168', '河南', '焦作', '391', 'HN');
INSERT INTO `core_prov` VALUES ('169', '河南', '鹤壁', '392', 'HN');
INSERT INTO `core_prov` VALUES ('170', '河南', '濮阳', '393', 'HN');
INSERT INTO `core_prov` VALUES ('171', '河南', '周口', '394', 'HN');
INSERT INTO `core_prov` VALUES ('172', '河南', '漯河', '395', 'HN');
INSERT INTO `core_prov` VALUES ('173', '河南', '驻马店', '396', 'HN');
INSERT INTO `core_prov` VALUES ('174', '河南', '三门峡', '398', 'HN');
INSERT INTO `core_prov` VALUES ('175', '湖南', '岳阳', '730', 'HUN');
INSERT INTO `core_prov` VALUES ('176', '湖南', '株洲', '731', 'HUN');
INSERT INTO `core_prov` VALUES ('177', '湖南', '长沙', '731', 'HUN');
INSERT INTO `core_prov` VALUES ('178', '湖南', '湘潭', '731', 'HUN');
INSERT INTO `core_prov` VALUES ('179', '湖南', '衡阳', '734', 'HUN');
INSERT INTO `core_prov` VALUES ('180', '湖南', '郴州', '735', 'HUN');
INSERT INTO `core_prov` VALUES ('181', '湖南', '常德', '736', 'HUN');
INSERT INTO `core_prov` VALUES ('182', '湖南', '益阳', '737', 'HUN');
INSERT INTO `core_prov` VALUES ('183', '湖南', '娄底', '738', 'HUN');
INSERT INTO `core_prov` VALUES ('184', '湖南', '邵阳', '739', 'HUN');
INSERT INTO `core_prov` VALUES ('185', '湖南', '吉首', '743', 'HUN');
INSERT INTO `core_prov` VALUES ('186', '湖南', '湘西', '743', 'HUN');
INSERT INTO `core_prov` VALUES ('187', '湖南', '湘西(吉首)', '743', 'HUN');
INSERT INTO `core_prov` VALUES ('188', '湖南', '张家界', '744', 'HUN');
INSERT INTO `core_prov` VALUES ('189', '湖南', '怀化', '745', 'HUN');
INSERT INTO `core_prov` VALUES ('190', '湖南', '永州', '746', 'HUN');
INSERT INTO `core_prov` VALUES ('191', '吉林', '长春', '431', 'JL');
INSERT INTO `core_prov` VALUES ('192', '吉林', '吉林', '432', 'JL');
INSERT INTO `core_prov` VALUES ('193', '吉林', '延吉', '433', 'JL');
INSERT INTO `core_prov` VALUES ('194', '吉林', '延边', '433', 'JL');
INSERT INTO `core_prov` VALUES ('195', '吉林', '延边(延吉/珲春)', '433', 'JL');
INSERT INTO `core_prov` VALUES ('196', '吉林', '珲春', '433', 'JL');
INSERT INTO `core_prov` VALUES ('197', '吉林', '四平', '434', 'JL');
INSERT INTO `core_prov` VALUES ('198', '吉林', '通化', '435', 'JL');
INSERT INTO `core_prov` VALUES ('199', '吉林', '梅河口', '435', 'JL');
INSERT INTO `core_prov` VALUES ('200', '吉林', '白城', '436', 'JL');
INSERT INTO `core_prov` VALUES ('201', '吉林', '辽源', '437', 'JL');
INSERT INTO `core_prov` VALUES ('202', '吉林', '松原', '438', 'JL');
INSERT INTO `core_prov` VALUES ('203', '吉林', '白山', '439', 'JL');
INSERT INTO `core_prov` VALUES ('204', '江苏', '南京', '025', 'JS');
INSERT INTO `core_prov` VALUES ('205', '江苏', '无锡', '510', 'JS');
INSERT INTO `core_prov` VALUES ('206', '江苏', '镇江', '511', 'JS');
INSERT INTO `core_prov` VALUES ('207', '江苏', '苏州', '512', 'JS');
INSERT INTO `core_prov` VALUES ('208', '江苏', '南通', '513', 'JS');
INSERT INTO `core_prov` VALUES ('209', '江苏', '扬州', '514', 'JS');
INSERT INTO `core_prov` VALUES ('210', '江苏', '盐城', '515', 'JS');
INSERT INTO `core_prov` VALUES ('211', '江苏', '徐州', '516', 'JS');
INSERT INTO `core_prov` VALUES ('212', '江苏', '淮阴', '517', 'JS');
INSERT INTO `core_prov` VALUES ('213', '江苏', '淮安', '517', 'JS');
INSERT INTO `core_prov` VALUES ('214', '江苏', '连云港', '518', 'JS');
INSERT INTO `core_prov` VALUES ('215', '江苏', '常州', '519', 'JS');
INSERT INTO `core_prov` VALUES ('216', '江苏', '泰州', '523', 'JS');
INSERT INTO `core_prov` VALUES ('217', '江苏', '宿迁', '527', 'JS');
INSERT INTO `core_prov` VALUES ('218', '江西', '鹰潭', '701', 'JX');
INSERT INTO `core_prov` VALUES ('219', '江西', '新余', '790', 'JX');
INSERT INTO `core_prov` VALUES ('220', '江西', '南昌', '791', 'JX');
INSERT INTO `core_prov` VALUES ('221', '江西', '九江', '792', 'JX');
INSERT INTO `core_prov` VALUES ('222', '江西', '上饶', '793', 'JX');
INSERT INTO `core_prov` VALUES ('223', '江西', '抚州', '794', 'JX');
INSERT INTO `core_prov` VALUES ('224', '江西', '宜春', '795', 'JX');
INSERT INTO `core_prov` VALUES ('225', '江西', '吉安', '796', 'JX');
INSERT INTO `core_prov` VALUES ('226', '江西', '赣州', '797', 'JX');
INSERT INTO `core_prov` VALUES ('227', '江西', '景德镇', '798', 'JX');
INSERT INTO `core_prov` VALUES ('228', '江西', '萍乡', '799', 'JX');
INSERT INTO `core_prov` VALUES ('229', '辽宁', '沈阳', '024', 'LN');
INSERT INTO `core_prov` VALUES ('230', '辽宁', '铁岭', '410', 'LN');
INSERT INTO `core_prov` VALUES ('231', '辽宁', '大连', '411', 'LN');
INSERT INTO `core_prov` VALUES ('232', '辽宁', '鞍山', '412', 'LN');
INSERT INTO `core_prov` VALUES ('233', '辽宁', '抚顺', '413', 'LN');
INSERT INTO `core_prov` VALUES ('234', '辽宁', '本溪', '414', 'LN');
INSERT INTO `core_prov` VALUES ('235', '辽宁', '丹东', '415', 'LN');
INSERT INTO `core_prov` VALUES ('236', '辽宁', '锦州', '416', 'LN');
INSERT INTO `core_prov` VALUES ('237', '辽宁', '营口', '417', 'LN');
INSERT INTO `core_prov` VALUES ('238', '辽宁', '阜新', '418', 'LN');
INSERT INTO `core_prov` VALUES ('239', '辽宁', '辽阳', '419', 'LN');
INSERT INTO `core_prov` VALUES ('240', '辽宁', '朝阳', '421', 'LN');
INSERT INTO `core_prov` VALUES ('241', '辽宁', '盘锦', '427', 'LN');
INSERT INTO `core_prov` VALUES ('242', '辽宁', '葫芦岛', '429', 'LN');
INSERT INTO `core_prov` VALUES ('243', '内蒙古', '呼伦贝尔', '470', 'NMG');
INSERT INTO `core_prov` VALUES ('244', '内蒙古', '呼伦贝尔市', '470', 'NMG');
INSERT INTO `core_prov` VALUES ('245', '内蒙古', '海拉尔', '470', 'NMG');
INSERT INTO `core_prov` VALUES ('246', '内蒙古', '呼和浩特', '471', 'NMG');
INSERT INTO `core_prov` VALUES ('247', '内蒙古', '包头', '472', 'NMG');
INSERT INTO `core_prov` VALUES ('248', '内蒙古', '乌海', '473', 'NMG');
INSERT INTO `core_prov` VALUES ('249', '内蒙古', '集宁', '474', 'NMG');
INSERT INTO `core_prov` VALUES ('250', '内蒙古', '乌兰察布', '474', 'NMG');
INSERT INTO `core_prov` VALUES ('251', '内蒙古', '通辽', '475', 'NMG');
INSERT INTO `core_prov` VALUES ('252', '内蒙古', '赤峰', '476', 'NMG');
INSERT INTO `core_prov` VALUES ('253', '内蒙古', '东胜', '477', 'NMG');
INSERT INTO `core_prov` VALUES ('254', '内蒙古', '鄂尔多斯', '477', 'NMG');
INSERT INTO `core_prov` VALUES ('255', '内蒙古', '巴彦淖尔', '478', 'NMG');
INSERT INTO `core_prov` VALUES ('256', '内蒙古', '临河', '478', 'NMG');
INSERT INTO `core_prov` VALUES ('257', '内蒙古', '巴彦浩特', '478', 'NMG');
INSERT INTO `core_prov` VALUES ('258', '内蒙古', '锡林浩特', '479', 'NMG');
INSERT INTO `core_prov` VALUES ('259', '内蒙古', '锡林郭勒', '479', 'NMG');
INSERT INTO `core_prov` VALUES ('260', '内蒙古', '锡林郭勒盟', '479', 'NMG');
INSERT INTO `core_prov` VALUES ('261', '内蒙古', '兴安盟', '482', 'NMG');
INSERT INTO `core_prov` VALUES ('262', '内蒙古', '兴安', '482', 'NMG');
INSERT INTO `core_prov` VALUES ('263', '内蒙古', '乌兰浩特', '482', 'NMG');
INSERT INTO `core_prov` VALUES ('264', '内蒙古', '乌兰查布', '482', 'NMG');
INSERT INTO `core_prov` VALUES ('265', '内蒙古', '巴彦浩特2', '483', 'NMG');
INSERT INTO `core_prov` VALUES ('266', '内蒙古', '阿拉善左旗', '483', 'NMG');
INSERT INTO `core_prov` VALUES ('267', '内蒙古', '阿拉善盟', '483', 'NMG');
INSERT INTO `core_prov` VALUES ('268', '内蒙古', '阿拉善', '483', 'NMG');
INSERT INTO `core_prov` VALUES ('269', '内蒙古', '阿盟', '483', 'NMG');
INSERT INTO `core_prov` VALUES ('270', '宁夏', '银川', '951', 'NX');
INSERT INTO `core_prov` VALUES ('271', '宁夏', '石嘴山', '952', 'NX');
INSERT INTO `core_prov` VALUES ('272', '宁夏', '吴忠', '953', 'NX');
INSERT INTO `core_prov` VALUES ('273', '宁夏', '固原', '954', 'NX');
INSERT INTO `core_prov` VALUES ('274', '宁夏', '中卫', '955', 'NX');
INSERT INTO `core_prov` VALUES ('275', '青海', '海北', '970', 'QH');
INSERT INTO `core_prov` VALUES ('276', '青海', '海晏', '970', 'QH');
INSERT INTO `core_prov` VALUES ('277', '青海', '海北州', '970', 'QH');
INSERT INTO `core_prov` VALUES ('278', '青海', '西宁', '971', 'QH');
INSERT INTO `core_prov` VALUES ('279', '青海', '海东', '972', 'QH');
INSERT INTO `core_prov` VALUES ('280', '青海', '同仁', '973', 'QH');
INSERT INTO `core_prov` VALUES ('281', '青海', '黄南', '973', 'QH');
INSERT INTO `core_prov` VALUES ('282', '青海', '共和', '974', 'QH');
INSERT INTO `core_prov` VALUES ('283', '青海', '海南州', '974', 'QH');
INSERT INTO `core_prov` VALUES ('284', '青海', '玛沁', '975', 'QH');
INSERT INTO `core_prov` VALUES ('285', '青海', '果洛', '975', 'QH');
INSERT INTO `core_prov` VALUES ('286', '青海', '玉树', '976', 'QH');
INSERT INTO `core_prov` VALUES ('287', '青海', '海西州', '977', 'QH');
INSERT INTO `core_prov` VALUES ('288', '青海', '德令哈', '977', 'QH');
INSERT INTO `core_prov` VALUES ('289', '青海', '海西', '979', 'QH');
INSERT INTO `core_prov` VALUES ('290', '青海', '德令哈', '979', 'QH');
INSERT INTO `core_prov` VALUES ('291', '青海', '海西州', '979', 'QH');
INSERT INTO `core_prov` VALUES ('292', '青海', '格尔木', '979', 'QH');
INSERT INTO `core_prov` VALUES ('293', '四川', '成都', '028', 'SC');
INSERT INTO `core_prov` VALUES ('294', '四川', '攀枝花', '812', 'SC');
INSERT INTO `core_prov` VALUES ('295', '四川', '自贡', '813', 'SC');
INSERT INTO `core_prov` VALUES ('296', '四川', '绵阳', '816', 'SC');
INSERT INTO `core_prov` VALUES ('297', '四川', '南充', '817', 'SC');
INSERT INTO `core_prov` VALUES ('298', '四川', '达州', '818', 'SC');
INSERT INTO `core_prov` VALUES ('299', '四川', '遂宁', '825', 'SC');
INSERT INTO `core_prov` VALUES ('300', '四川', '广安', '826', 'SC');
INSERT INTO `core_prov` VALUES ('301', '四川', '巴中', '827', 'SC');
INSERT INTO `core_prov` VALUES ('302', '四川', '泸州', '830', 'SC');
INSERT INTO `core_prov` VALUES ('303', '四川', '宜宾', '831', 'SC');
INSERT INTO `core_prov` VALUES ('304', '四川', '内江', '832', 'SC');
INSERT INTO `core_prov` VALUES ('305', '四川', '资阳', '832', 'SC');
INSERT INTO `core_prov` VALUES ('306', '四川', '资阳/内江', '832', 'SC');
INSERT INTO `core_prov` VALUES ('307', '四川', '乐山', '833', 'SC');
INSERT INTO `core_prov` VALUES ('308', '四川', '乐山/眉山', '833', 'SC');
INSERT INTO `core_prov` VALUES ('309', '四川', '眉山', '833', 'SC');
INSERT INTO `core_prov` VALUES ('310', '四川', '凉山', '834', 'SC');
INSERT INTO `core_prov` VALUES ('311', '四川', '凉山(西昌)', '834', 'SC');
INSERT INTO `core_prov` VALUES ('312', '四川', '凉山州', '834', 'SC');
INSERT INTO `core_prov` VALUES ('313', '四川', '西昌', '834', 'SC');
INSERT INTO `core_prov` VALUES ('314', '四川', '雅安', '835', 'SC');
INSERT INTO `core_prov` VALUES ('315', '四川', '甘孜(康定)', '836', 'SC');
INSERT INTO `core_prov` VALUES ('316', '四川', '康定', '836', 'SC');
INSERT INTO `core_prov` VALUES ('317', '四川', '甘孜', '836', 'SC');
INSERT INTO `core_prov` VALUES ('318', '四川', '甘孜州', '836', 'SC');
INSERT INTO `core_prov` VALUES ('319', '四川', '马尔康', '837', 'SC');
INSERT INTO `core_prov` VALUES ('320', '四川', '阿坝', '837', 'SC');
INSERT INTO `core_prov` VALUES ('321', '四川', '德阳', '838', 'SC');
INSERT INTO `core_prov` VALUES ('322', '四川', '广元', '839', 'SC');
INSERT INTO `core_prov` VALUES ('323', '山东', '菏泽', '530', 'SD');
INSERT INTO `core_prov` VALUES ('324', '山东', '济南', '531', 'SD');
INSERT INTO `core_prov` VALUES ('325', '山东', '青岛', '532', 'SD');
INSERT INTO `core_prov` VALUES ('326', '山东', '淄博', '533', 'SD');
INSERT INTO `core_prov` VALUES ('327', '山东', '德州', '534', 'SD');
INSERT INTO `core_prov` VALUES ('328', '山东', '烟台', '535', 'SD');
INSERT INTO `core_prov` VALUES ('329', '山东', '潍坊', '536', 'SD');
INSERT INTO `core_prov` VALUES ('330', '山东', '济宁', '537', 'SD');
INSERT INTO `core_prov` VALUES ('331', '山东', '泰安', '538', 'SD');
INSERT INTO `core_prov` VALUES ('332', '山东', '临沂', '539', 'SD');
INSERT INTO `core_prov` VALUES ('333', '山东', '滨州', '543', 'SD');
INSERT INTO `core_prov` VALUES ('334', '山东', '东营', '546', 'SD');
INSERT INTO `core_prov` VALUES ('335', '山东', '威海', '631', 'SD');
INSERT INTO `core_prov` VALUES ('336', '山东', '枣庄', '632', 'SD');
INSERT INTO `core_prov` VALUES ('337', '山东', '日照', '633', 'SD');
INSERT INTO `core_prov` VALUES ('338', '山东', '莱芜', '634', 'SD');
INSERT INTO `core_prov` VALUES ('339', '山东', '聊城', '635', 'SD');
INSERT INTO `core_prov` VALUES ('340', '上海', '上海', '021', 'SH');
INSERT INTO `core_prov` VALUES ('341', '山西', '朔州', '349', 'SHX');
INSERT INTO `core_prov` VALUES ('342', '山西', '忻州', '350', 'SHX');
INSERT INTO `core_prov` VALUES ('343', '山西', '太原', '351', 'SHX');
INSERT INTO `core_prov` VALUES ('344', '山西', '大同', '352', 'SHX');
INSERT INTO `core_prov` VALUES ('345', '山西', '阳泉', '353', 'SHX');
INSERT INTO `core_prov` VALUES ('346', '山西', '晋中', '354', 'SHX');
INSERT INTO `core_prov` VALUES ('347', '山西', '榆次', '354', 'SHX');
INSERT INTO `core_prov` VALUES ('348', '山西', '长治', '355', 'SHX');
INSERT INTO `core_prov` VALUES ('349', '山西', '晋城', '356', 'SHX');
INSERT INTO `core_prov` VALUES ('350', '山西', '临汾', '357', 'SHX');
INSERT INTO `core_prov` VALUES ('351', '山西', '吕梁', '358', 'SHX');
INSERT INTO `core_prov` VALUES ('352', '山西', '运城', '359', 'SHX');
INSERT INTO `core_prov` VALUES ('353', '陕西', '西安', '029', 'SX');
INSERT INTO `core_prov` VALUES ('354', '陕西', '咸阳', '029', 'SX');
INSERT INTO `core_prov` VALUES ('355', '陕西', '延安', '911', 'SX');
INSERT INTO `core_prov` VALUES ('356', '陕西', '榆林', '912', 'SX');
INSERT INTO `core_prov` VALUES ('357', '陕西', '渭南', '913', 'SX');
INSERT INTO `core_prov` VALUES ('358', '陕西', '商洛', '914', 'SX');
INSERT INTO `core_prov` VALUES ('359', '陕西', '安康', '915', 'SX');
INSERT INTO `core_prov` VALUES ('360', '陕西', '汉中', '916', 'SX');
INSERT INTO `core_prov` VALUES ('361', '陕西', '宝鸡', '917', 'SX');
INSERT INTO `core_prov` VALUES ('362', '陕西', '铜川', '919', 'SX');
INSERT INTO `core_prov` VALUES ('363', '天津', '天津', '022', 'TJ');
INSERT INTO `core_prov` VALUES ('469', '新疆', null, '000', 'XJ');
INSERT INTO `core_prov` VALUES ('374', '新疆', '塔城', '901', 'XJ');
INSERT INTO `core_prov` VALUES ('375', '新疆', '哈密', '902', 'XJ');
INSERT INTO `core_prov` VALUES ('376', '新疆', '和田', '903', 'XJ');
INSERT INTO `core_prov` VALUES ('377', '新疆', '阿勒泰', '906', 'XJ');
INSERT INTO `core_prov` VALUES ('378', '新疆', '克州', '908', 'XJ');
INSERT INTO `core_prov` VALUES ('379', '新疆', '阿图什', '908', 'XJ');
INSERT INTO `core_prov` VALUES ('380', '新疆', '克孜勒苏', '908', 'XJ');
INSERT INTO `core_prov` VALUES ('381', '新疆', '博乐', '909', 'XJ');
INSERT INTO `core_prov` VALUES ('382', '新疆', '博尔塔拉', '909', 'XJ');
INSERT INTO `core_prov` VALUES ('383', '新疆', '克拉玛依', '990', 'XJ');
INSERT INTO `core_prov` VALUES ('384', '新疆', '乌鲁木齐', '991', 'XJ');
INSERT INTO `core_prov` VALUES ('385', '新疆', '伊犁', '992', 'XJ');
INSERT INTO `core_prov` VALUES ('386', '新疆', '奎屯', '992', 'XJ');
INSERT INTO `core_prov` VALUES ('387', '新疆', '石河子', '993', 'XJ');
INSERT INTO `core_prov` VALUES ('388', '新疆', '昌吉', '994', 'XJ');
INSERT INTO `core_prov` VALUES ('389', '新疆', '吐鲁番', '995', 'XJ');
INSERT INTO `core_prov` VALUES ('390', '新疆', '库尔勒', '996', 'XJ');
INSERT INTO `core_prov` VALUES ('391', '新疆', '巴音郭楞(库尔勒)', '996', 'XJ');
INSERT INTO `core_prov` VALUES ('392', '新疆', '巴音郭楞', '996', 'XJ');
INSERT INTO `core_prov` VALUES ('393', '新疆', '阿克苏', '997', 'XJ');
INSERT INTO `core_prov` VALUES ('394', '新疆', '喀什', '998', 'XJ');
INSERT INTO `core_prov` VALUES ('395', '新疆', '伊犁', '999', 'XJ');
INSERT INTO `core_prov` VALUES ('396', '西藏', '拉萨', '891', 'XZ');
INSERT INTO `core_prov` VALUES ('397', '西藏', '日喀则', '892', 'XZ');
INSERT INTO `core_prov` VALUES ('398', '西藏', '山南', '893', 'XZ');
INSERT INTO `core_prov` VALUES ('399', '西藏', '林芝', '894', 'XZ');
INSERT INTO `core_prov` VALUES ('400', '西藏', '昌都', '895', 'XZ');
INSERT INTO `core_prov` VALUES ('401', '西藏', '那曲', '896', 'XZ');
INSERT INTO `core_prov` VALUES ('402', '西藏', '阿里', '897', 'XZ');
INSERT INTO `core_prov` VALUES ('403', '云南', '版纳', '691', 'YN');
INSERT INTO `core_prov` VALUES ('404', '云南', '景洪', '691', 'YN');
INSERT INTO `core_prov` VALUES ('405', '云南', '西双版纳', '691', 'YN');
INSERT INTO `core_prov` VALUES ('406', '云南', '潞西', '692', 'YN');
INSERT INTO `core_prov` VALUES ('407', '云南', '德宏', '692', 'YN');
INSERT INTO `core_prov` VALUES ('408', '云南', '昭通', '870', 'YN');
INSERT INTO `core_prov` VALUES ('409', '云南', '昆明', '871', 'YN');
INSERT INTO `core_prov` VALUES ('410', '云南', '大理', '872', 'YN');
INSERT INTO `core_prov` VALUES ('411', '云南', '红河', '873', 'YN');
INSERT INTO `core_prov` VALUES ('412', '云南', '个旧', '873', 'YN');
INSERT INTO `core_prov` VALUES ('413', '云南', '曲靖', '874', 'YN');
INSERT INTO `core_prov` VALUES ('414', '云南', '保山', '875', 'YN');
INSERT INTO `core_prov` VALUES ('415', '云南', '文山', '876', 'YN');
INSERT INTO `core_prov` VALUES ('416', '云南', '玉溪', '877', 'YN');
INSERT INTO `core_prov` VALUES ('417', '云南', '楚雄', '878', 'YN');
INSERT INTO `core_prov` VALUES ('418', '云南', '思茅', '879', 'YN');
INSERT INTO `core_prov` VALUES ('419', '云南', '普洱', '879', 'YN');
INSERT INTO `core_prov` VALUES ('420', '云南', '临沧', '883', 'YN');
INSERT INTO `core_prov` VALUES ('421', '云南', '六库', '886', 'YN');
INSERT INTO `core_prov` VALUES ('422', '云南', '怒江', '886', 'YN');
INSERT INTO `core_prov` VALUES ('423', '云南', '中甸', '887', 'YN');
INSERT INTO `core_prov` VALUES ('424', '云南', '迪庆', '887', 'YN');
INSERT INTO `core_prov` VALUES ('425', '云南', '丽江', '888', 'YN');
INSERT INTO `core_prov` VALUES ('426', '浙江', '衢州', '570', 'ZJ');
INSERT INTO `core_prov` VALUES ('427', '浙江', '杭州', '571', 'ZJ');
INSERT INTO `core_prov` VALUES ('428', '浙江', '湖州', '572', 'ZJ');
INSERT INTO `core_prov` VALUES ('429', '浙江', '嘉兴', '573', 'ZJ');
INSERT INTO `core_prov` VALUES ('430', '浙江', '宁波', '574', 'ZJ');
INSERT INTO `core_prov` VALUES ('431', '浙江', '绍兴', '575', 'ZJ');
INSERT INTO `core_prov` VALUES ('432', '浙江', '台州', '576', 'ZJ');
INSERT INTO `core_prov` VALUES ('433', '浙江', '温州', '577', 'ZJ');
INSERT INTO `core_prov` VALUES ('434', '浙江', '丽水', '578', 'ZJ');
INSERT INTO `core_prov` VALUES ('435', '浙江', '金华', '579', 'ZJ');
INSERT INTO `core_prov` VALUES ('436', '浙江', '舟山', '580', 'ZJ');

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `type` int(11) NOT NULL COMMENT '类型',
  `status` int(11) NOT NULL COMMENT '状态(0 : 未处理, 1 : 已经处理)',
  `content` varchar(512) DEFAULT NULL COMMENT '反馈内容',
  `reply` varchar(512) DEFAULT NULL COMMENT '回复内容',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '回复人',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8506 DEFAULT CHARSET=utf8 COMMENT='反馈';

-- ----------------------------
-- Records of feedback
-- ----------------------------

-- ----------------------------
-- Table structure for fight_award_log
-- ----------------------------
DROP TABLE IF EXISTS `fight_award_log`;
CREATE TABLE `fight_award_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `topType` smallint(2) DEFAULT '0' COMMENT '排行类型:0日榜，1周榜',
  `uid` bigint(8) DEFAULT NULL,
  `no` int(4) DEFAULT NULL COMMENT '行排',
  `point` bigint(8) DEFAULT NULL COMMENT '积分',
  `awardAmount` int(4) DEFAULT NULL COMMENT '奖励额度',
  `awardType` smallint(2) DEFAULT NULL COMMENT '奖励类型:0金币1元宝2话费',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of fight_award_log
-- ----------------------------

-- ----------------------------
-- Table structure for fight_config
-- ----------------------------
DROP TABLE IF EXISTS `fight_config`;
CREATE TABLE `fight_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `dt_start` datetime DEFAULT NULL COMMENT '比赛开始时间',
  `dt_end` datetime DEFAULT NULL COMMENT '比赛结束时间',
  `memo` text COMMENT '比赛说明',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `dt_start` (`dt_start`,`dt_end`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fight_config
-- ----------------------------
INSERT INTO `fight_config` VALUES ('1', 'Test 1', '2014-11-17 00:00:00', '2014-11-20 11:51:14', 'test', '2014-11-20 11:51:32');

-- ----------------------------
-- Table structure for fight_point_log
-- ----------------------------
DROP TABLE IF EXISTS `fight_point_log`;
CREATE TABLE `fight_point_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `todaypoint` bigint(8) DEFAULT '0' COMMENT '今天的积分',
  `totalpoint` bigint(8) DEFAULT NULL COMMENT '总积分',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1359 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of fight_point_log
-- ----------------------------

-- ----------------------------
-- Table structure for fight_top_temp
-- ----------------------------
DROP TABLE IF EXISTS `fight_top_temp`;
CREATE TABLE `fight_top_temp` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `todaypoint` bigint(8) DEFAULT '0' COMMENT '今天的积分',
  `totalpoint` bigint(8) DEFAULT NULL COMMENT '总积分',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of fight_top_temp
-- ----------------------------

-- ----------------------------
-- Table structure for flipcard_control
-- ----------------------------
DROP TABLE IF EXISTS `flipcard_control`;
CREATE TABLE `flipcard_control` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `level` int(4) DEFAULT '0' COMMENT '控制级别',
  `type` smallint(2) DEFAULT NULL COMMENT '类型：0，大盘控制；1，个人盘控制',
  `minMoney` bigint(8) DEFAULT '0' COMMENT '盘左区间：0为无穷小',
  `maxMoney` bigint(8) DEFAULT '0' COMMENT '盘右区间：0为无穷大',
  `initRatio` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '发牌时的剔除好牌控制n%(小牛花牛四炸,牛8~牛牛,牛丁~牛7)',
  `oneChangeRatio` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '第一次换牌剔除好牌控制n%',
  `twoChangeRatio` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '第二次换牌剔除好牌控制n%',
  `threeChangeRatio` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '第3次换牌剔除好牌控制n%',
  `createdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of flipcard_control
-- ----------------------------
INSERT INTO `flipcard_control` VALUES ('1', '1', '0', '0', '-20000000', '100,100,100', '100,100,100', '60,60,60', '20,20,20', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('2', '2', '0', '-20000000', '-10000000', '100,100,50', '100,100,50', '60,60,30', '20,20,10', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('3', '3', '0', '-10000000', '1', '100,100,50', '100,100,50', '60,50,30', '20,20,10', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('4', '4', '0', '1', '20000000', '100,50,40', '100,50,40', '60,40,24', '20,10,8', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('5', '5', '0', '20000000', '50000000', '90,50,30', '90,40,30', '54,30,18', '18,10,6', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('6', '6', '0', '50000000', '100000000', '80,30,10', '80,30,10', '48,20,10', '17,8,4', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('7', '7', '0', '100000000', '200000000', '60,20,0', '60,20,0', '36,12,0', '16,6,2', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('8', '8', '0', '200000000', '400000000', '40,10,0', '40,10,0', '24,6,0', '8,2,0', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('9', '9', '0', '400000000', '800000000', '20,0,0', '20,0,0', '12,0,0', '4,0,0', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('10', '10', '0', '800000000', '0', '0,0,0', '0,0,0', '0,0,0', '0,0,0', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('11', '1', '1', '3000000', '0', '100,100,100', '100,100,100', '60,60,60', '20,20,20', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('12', '2', '1', '2000000', '3000000', '100,100,50', '100,100,50', '60,60,30', '20,20,10', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('13', '3', '1', '1000000', '2000000', '100,100,50', '100,100,50', '60,50,30', '20,20,10', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('14', '4', '1', '500000', '1000000', '100,50,40', '100,50,40', '60,40,24', '20,10,8', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('15', '5', '1', '1', '500000', '90,50,30', '90,40,30', '54,30,18', '18,10,6', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('16', '6', '1', '-500000', '1', '80,30,10', '80,30,10', '48,20,10', '17,8,4', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('17', '7', '1', '-1000000', '-500000', '60,20,0', '60,20,0', '36,12,0', '16,6,2', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('18', '8', '1', '-2000000', '-1000000', '40,10,0', '40,10,0', '24,6,0', '8,2,0', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('19', '9', '1', '-3000000', '-2000000', '20,0,0', '20,0,0', '12,0,0', '4,0,0', '2014-09-24 10:33:51');
INSERT INTO `flipcard_control` VALUES ('20', '10', '1', '0', '-3000000', '0,0,0', '0,0,0', '0,0,0', '0,0,0', '2014-09-24 10:33:51');

-- ----------------------------
-- Table structure for flipcard_log
-- ----------------------------
DROP TABLE IF EXISTS `flipcard_log`;
CREATE TABLE `flipcard_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT '0',
  `cardType` smallint(2) DEFAULT '0' COMMENT '牌类型',
  `betNum` bigint(8) DEFAULT '0' COMMENT '注下额',
  `changeNum` tinyint(1) DEFAULT '0' COMMENT '换牌次数',
  `changeMoney` bigint(8) DEFAULT '0' COMMENT '牌换消耗金币',
  `consumeMoney` bigint(8) DEFAULT '0' COMMENT '消耗的金币',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2338148 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of flipcard_log
-- ----------------------------

-- ----------------------------
-- Table structure for gifts
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
-- Records of gifts
-- ----------------------------
INSERT INTO `gifts` VALUES ('1', '1', 'n1', '200', '2');
INSERT INTO `gifts` VALUES ('2', '2', 'n2', '200', '2');
INSERT INTO `gifts` VALUES ('3', '3', 'n3', '2000', '10');
INSERT INTO `gifts` VALUES ('4', '4', 'n4', '20000', '90');
INSERT INTO `gifts` VALUES ('5', '5', 'n5', '100000', '500');

-- ----------------------------
-- Table structure for gifts_log
-- ----------------------------
DROP TABLE IF EXISTS `gifts_log`;
CREATE TABLE `gifts_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid_give` int(11) DEFAULT NULL COMMENT '送礼uid',
  `uid_received` int(11) DEFAULT NULL COMMENT '收礼uid',
  `gift_id` int(11) DEFAULT NULL COMMENT '礼物id',
  `money` int(11) DEFAULT '0' COMMENT '所花金币',
  `charm` int(11) DEFAULT '0' COMMENT '魅力值',
  `create_time` int(11) DEFAULT NULL COMMENT '记录时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of gifts_log
-- ----------------------------

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `gtype` int(11) NOT NULL COMMENT '商品类别，类别不同，赠送的金币也不一样',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `rmb` int(11) NOT NULL COMMENT '价钱rmb',
  `money` int(11) NOT NULL COMMENT '所得金币',
  `give_money` int(11) NOT NULL DEFAULT '0' COMMENT '多赠送金币',
  `give_coin` int(11) NOT NULL DEFAULT '0' COMMENT ' 多赠送的元宝',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='商品表';

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES ('1', '1', '2元换金币', '2', '20000', '1000', '2', '1386295517', '1370066504');
INSERT INTO `goods` VALUES ('2', '1', '5元换金币', '5', '50000', '3000', '5', '1384481965', '1370067376');
INSERT INTO `goods` VALUES ('3', '1', '10元换金币', '10', '100000', '7000', '10', '1386295543', '1370067923');
INSERT INTO `goods` VALUES ('4', '2', '2元换金币', '2', '40000', '2000', '4', '1370038956', '1370038956');
INSERT INTO `goods` VALUES ('5', '2', '5元换金币', '5', '100000', '6000', '10', '1370037923', '1370037923');
INSERT INTO `goods` VALUES ('6', '2', '10元换金币', '10', '200000', '14000', '20', '1370038956', '1370038956');
INSERT INTO `goods` VALUES ('7', '3', '20元换金币', '20', '200000', '15000', '20', '1387940539', '1387940453');
INSERT INTO `goods` VALUES ('8', '3', '30元换金币', '30', '300000', '24000', '30', '1387940547', '1387940488');
INSERT INTO `goods` VALUES ('9', '3', '50元换金币', '50', '500000', '50000', '50', '1387940556', '1387940512');
INSERT INTO `goods` VALUES ('10', '4', '20元换金币', '20', '400000', '30000', '40', '1388048228', '1388048228');
INSERT INTO `goods` VALUES ('11', '4', '30元换金币', '30', '600000', '48000', '60', '1388048267', '1388048267');
INSERT INTO `goods` VALUES ('12', '4', '50元换金币', '50', '1000000', '100000', '100', '1388048300', '1388048300');
INSERT INTO `goods` VALUES ('13', '1', '200元换金币', '200', '2000000', '400000', '200', '1392776789', '1392087250');
INSERT INTO `goods` VALUES ('14', '1', '500元换金币', '500', '5000000', '1500000', '500', '1392776809', '1392087293');
INSERT INTO `goods` VALUES ('15', '2', '200元换金币', '200', '4000000', '800000', '400', '1392776860', '1392087401');
INSERT INTO `goods` VALUES ('16', '2', '500元换金币', '500', '10000000', '3000000', '1000', '1392776892', '1392087440');

-- ----------------------------
-- Table structure for goodslog
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品兑换记录表';

-- ----------------------------
-- Records of goodslog
-- ----------------------------

-- ----------------------------
-- Table structure for goods_sdk
-- ----------------------------
DROP TABLE IF EXISTS `goods_sdk`;
CREATE TABLE `goods_sdk` (
  `id` int(11) DEFAULT NULL,
  `sdk` varchar(10) DEFAULT NULL,
  `goods_id` int(11) DEFAULT NULL COMMENT 'goods.id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of goods_sdk
-- ----------------------------

-- ----------------------------
-- Table structure for group
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
-- Records of group
-- ----------------------------
INSERT INTO `group` VALUES ('2', 'App', '应用中心', '1222841259', '0', '1', '0', '0');

-- ----------------------------
-- Table structure for groups
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` mediumint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of groups
-- ----------------------------
INSERT INTO `groups` VALUES ('1', '项目组1');
INSERT INTO `groups` VALUES ('2', '项目组2');
INSERT INTO `groups` VALUES ('3', '项目组3');

-- ----------------------------
-- Table structure for level_info
-- ----------------------------
DROP TABLE IF EXISTS `level_info`;
CREATE TABLE `level_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` int(4) DEFAULT NULL COMMENT '级等值',
  `minExp` bigint(11) DEFAULT '0' COMMENT '最小经验值',
  `maxExp` bigint(11) DEFAULT '0' COMMENT '最大经验值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of level_info
-- ----------------------------
INSERT INTO `level_info` VALUES ('1', '1', '0', '9');
INSERT INTO `level_info` VALUES ('2', '2', '10', '19');
INSERT INTO `level_info` VALUES ('3', '3', '20', '29');
INSERT INTO `level_info` VALUES ('4', '4', '30', '39');
INSERT INTO `level_info` VALUES ('5', '5', '40', '59');
INSERT INTO `level_info` VALUES ('6', '6', '60', '79');
INSERT INTO `level_info` VALUES ('7', '7', '80', '99');
INSERT INTO `level_info` VALUES ('8', '8', '100', '119');
INSERT INTO `level_info` VALUES ('9', '9', '120', '139');
INSERT INTO `level_info` VALUES ('10', '10', '140', '179');
INSERT INTO `level_info` VALUES ('11', '11', '180', '219');
INSERT INTO `level_info` VALUES ('12', '12', '220', '259');
INSERT INTO `level_info` VALUES ('13', '13', '260', '299');
INSERT INTO `level_info` VALUES ('14', '14', '300', '339');
INSERT INTO `level_info` VALUES ('15', '15', '340', '399');
INSERT INTO `level_info` VALUES ('16', '16', '400', '459');
INSERT INTO `level_info` VALUES ('17', '17', '460', '519');
INSERT INTO `level_info` VALUES ('18', '18', '520', '579');
INSERT INTO `level_info` VALUES ('19', '19', '580', '659');
INSERT INTO `level_info` VALUES ('20', '20', '660', '739');
INSERT INTO `level_info` VALUES ('21', '21', '740', '819');
INSERT INTO `level_info` VALUES ('22', '22', '820', '899');
INSERT INTO `level_info` VALUES ('23', '23', '900', '979');
INSERT INTO `level_info` VALUES ('24', '24', '980', '1059');
INSERT INTO `level_info` VALUES ('25', '25', '1060', '1199');
INSERT INTO `level_info` VALUES ('26', '26', '1200', '1399');
INSERT INTO `level_info` VALUES ('27', '27', '1400', '1599');
INSERT INTO `level_info` VALUES ('28', '28', '1600', '1799');
INSERT INTO `level_info` VALUES ('29', '29', '1800', '2599');
INSERT INTO `level_info` VALUES ('30', '30', '2600', '3499');
INSERT INTO `level_info` VALUES ('31', '31', '3500', '4499');
INSERT INTO `level_info` VALUES ('32', '32', '4500', '5999');
INSERT INTO `level_info` VALUES ('33', '33', '6000', '7499');
INSERT INTO `level_info` VALUES ('34', '34', '7500', '8999');
INSERT INTO `level_info` VALUES ('35', '35', '9000', '11999');
INSERT INTO `level_info` VALUES ('36', '36', '12000', '14999');
INSERT INTO `level_info` VALUES ('37', '37', '15000', '17999');
INSERT INTO `level_info` VALUES ('38', '38', '18000', '20999');
INSERT INTO `level_info` VALUES ('39', '39', '21000', '23999');
INSERT INTO `level_info` VALUES ('40', '40', '24000', '26999');
INSERT INTO `level_info` VALUES ('41', '41', '27000', '29999');
INSERT INTO `level_info` VALUES ('42', '42', '30000', '39999');
INSERT INTO `level_info` VALUES ('43', '43', '40000', '49999');
INSERT INTO `level_info` VALUES ('44', '44', '50000', '59999');
INSERT INTO `level_info` VALUES ('45', '45', '60000', '69999');
INSERT INTO `level_info` VALUES ('46', '46', '70000', '89999');
INSERT INTO `level_info` VALUES ('47', '47', '90000', '119999');
INSERT INTO `level_info` VALUES ('48', '48', '120000', '149999');
INSERT INTO `level_info` VALUES ('49', '49', '150000', '199999');
INSERT INTO `level_info` VALUES ('50', '50', '200000', '299999');
INSERT INTO `level_info` VALUES ('51', '51', '300000', '399999');
INSERT INTO `level_info` VALUES ('52', '52', '400000', '499999');
INSERT INTO `level_info` VALUES ('53', '53', '500000', '699999');
INSERT INTO `level_info` VALUES ('54', '54', '700000', '999999');
INSERT INTO `level_info` VALUES ('55', '55', '1000000', '1399999');
INSERT INTO `level_info` VALUES ('56', '56', '1400000', '1999999');
INSERT INTO `level_info` VALUES ('57', '57', '2000000', '3999999');
INSERT INTO `level_info` VALUES ('58', '58', '4000000', '7999999');
INSERT INTO `level_info` VALUES ('59', '59', '8000000', '9999999');
INSERT INTO `level_info` VALUES ('60', '60', '10000000', '0');

-- ----------------------------
-- Table structure for loginreward
-- ----------------------------
DROP TABLE IF EXISTS `loginreward`;
CREATE TABLE `loginreward` (
  `id` smallint(2) NOT NULL AUTO_INCREMENT,
  `contday` smallint(2) NOT NULL COMMENT '连续登录天数',
  `awardtype` tinyint(4) NOT NULL COMMENT '奖励类型',
  `amount` int(11) NOT NULL COMMENT '奖励数额',
  `create_time` int(11) NOT NULL,
  `update_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of loginreward
-- ----------------------------
INSERT INTO `loginreward` VALUES ('1', '1', '0', '1000', '0', '1384483161');
INSERT INTO `loginreward` VALUES ('2', '2', '0', '1200', '0', '1384483172');
INSERT INTO `loginreward` VALUES ('3', '3', '0', '1500', '0', '1384483181');
INSERT INTO `loginreward` VALUES ('4', '4', '0', '1800', '0', '1384483195');
INSERT INTO `loginreward` VALUES ('5', '5', '0', '2100', '0', '1384483206');
INSERT INTO `loginreward` VALUES ('6', '6', '0', '2500', '0', '0');
INSERT INTO `loginreward` VALUES ('7', '7', '1', '5', '0', '0');

-- ----------------------------
-- Table structure for login_log
-- ----------------------------
DROP TABLE IF EXISTS `login_log`;
CREATE TABLE `login_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `uid` int(11) DEFAULT NULL,
  `channel` varchar(64) DEFAULT NULL COMMENT '联运渠道',
  `login_type` varchar(20) DEFAULT NULL,
  `package` varchar(50) DEFAULT NULL COMMENT 'app包名',
  `ver` varchar(10) DEFAULT NULL COMMENT '注册版本号',
  `ip` varchar(20) DEFAULT NULL COMMENT '注册IP',
  `imsi` varchar(50) DEFAULT NULL,
  `imei` varchar(50) DEFAULT NULL,
  `mtype` varchar(50) DEFAULT NULL,
  `create_time` int(11) DEFAULT NULL COMMENT '登录时间',
  PRIMARY KEY (`id`),
  KEY `package` (`package`) USING BTREE,
  KEY `channel` (`channel`) USING BTREE,
  KEY `ver` (`ver`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `create_time` (`create_time`),
  KEY `uid_2` (`uid`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=18613501 DEFAULT CHARSET=utf8 COMMENT='游戏玩家表';

-- ----------------------------
-- Records of login_log
-- ----------------------------

-- ----------------------------
-- Table structure for lottery
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
-- Records of lottery
-- ----------------------------
INSERT INTO `lottery` VALUES ('1', '0', '1', '9395,8300', '0', '500,600,800', '0', '金币', '1370067923', '1390198213');
INSERT INTO `lottery` VALUES ('2', '0', '1', '500,1520', '5', '1000,1500,2000', '0', '金币', '1370067923', '1390198162');
INSERT INTO `lottery` VALUES ('3', '0', '1', '50,100', '3', '3000,5000', '0', '金币', '1370067923', '1390197993');
INSERT INTO `lottery` VALUES ('4', '0', '1', '0,50', '7', '20000,50000', '1', '金币', '1370067923', '1386901423');
INSERT INTO `lottery` VALUES ('5', '1', '1', '50,20', '8', '2,5,8', '1', '元宝', '1370067923', '1390198068');
INSERT INTO `lottery` VALUES ('6', '1', '1', '5,10', '1', '10,20,30', '1', '元宝', '1370067923', '1390198106');
INSERT INTO `lottery` VALUES ('7', '1', '1', '0,0', '4', '100,150', '1', '元宝', '1370067923', '1386901270');
INSERT INTO `lottery` VALUES ('8', '2', '1', '0,0', '6', '1,2,3', '1', '话费券', '1370067923', '1390197763');
INSERT INTO `lottery` VALUES ('9', '2', '1', '0,0', '9', '5,8', '1', '话费券', '1370067923', '1386901510');
INSERT INTO `lottery` VALUES ('10', '3', '1', '0,0', '2', '1', '1', '超级大奖', '1370067923', '1382523168');
INSERT INTO `lottery` VALUES ('11', '-1', '2', '3454,3454', '0', '0', '0', '再接再励', '1370067923', '1387447613');
INSERT INTO `lottery` VALUES ('12', '0', '2', '6380,6380', '5', '1000', '0', '金币', '1370067923', '1387447644');
INSERT INTO `lottery` VALUES ('13', '1', '2', '150,150', '3', '6', '0', '元宝', '1370067923', '1387447759');
INSERT INTO `lottery` VALUES ('14', '1', '2', '10,10', '7', '18', '2', '元宝', '1370067923', '1387447632');
INSERT INTO `lottery` VALUES ('15', '2', '2', '5,5', '8', '3', '2', '话费劵', '1370067923', '1387447581');
INSERT INTO `lottery` VALUES ('16', '2', '2', '1,1', '1', '8', '2', '话费劵', '1370067923', '1387447551');
INSERT INTO `lottery` VALUES ('17', '2', '2', '0,0', '4', '99', '2', '话费劵', '1370067923', '1387447521');
INSERT INTO `lottery` VALUES ('18', '4', '2', '0,0', '6', '1', '2', 'IPAD mini', '1370067923', '1382577992');
INSERT INTO `lottery` VALUES ('19', '5', '2', '0,0', '9', '1', '2', '三星S4', '1370067923', '1382578016');
INSERT INTO `lottery` VALUES ('20', '6', '2', '0,0', '2', '1', '2', '土豪金', '1370067923', '1382523168');

-- ----------------------------
-- Table structure for lotterylog
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
) ENGINE=InnoDB AUTO_INCREMENT=10809493 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Table structure for luckdraw
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
-- Records of luckdraw
-- ----------------------------
INSERT INTO `luckdraw` VALUES ('1', '0', '1', '90,80,70', '1', '600,800', null, null, '金币', '1370067923', '1390198213');
INSERT INTO `luckdraw` VALUES ('2', '0', '1', '0,30,40', '6', '12000,14000,16000', null, '', '金币', '1370067923', '1390198162');
INSERT INTO `luckdraw` VALUES ('3', '0', '1', '100,60,50', '12', '400,500,600', null, null, '金币', '1370067923', '1390197993');
INSERT INTO `luckdraw` VALUES ('4', '0', '1', '0,20,30', '18', '20000,30000,40000', null, '天降奇财!{user}在抽奖中获得{amount}金币', '金币', '1370067923', '1386901423');
INSERT INTO `luckdraw` VALUES ('5', '1', '1', '0,10,20', '2', '4,5', null, '{user}抽奖获得{amount}元宝,离兑换话费又近了一步', '元宝', '1370067923', '1390198068');
INSERT INTO `luckdraw` VALUES ('6', '1', '1', '100,80,70', '7', '1,2', null, '', '元宝', '1370067923', '1390198106');
INSERT INTO `luckdraw` VALUES ('7', '1', '1', '0,20,30', '13', '3,4', null, '', '元宝', '1370067923', '1386901270');
INSERT INTO `luckdraw` VALUES ('8', '1', '1', '90,80,70', '19', '2,3', null, '', '元宝', '1370067923', '1390197763');
INSERT INTO `luckdraw` VALUES ('9', '2', '1', '10,20,40', '3', '1', '3,4', '', '礼物', '1370067923', '1386901510');
INSERT INTO `luckdraw` VALUES ('10', '2', '1', '0,0,10', '10', '1', '4,5', '{user}在抽奖中获得了{amount},珍贵礼物轻松入手', '礼物', '1370067923', '1382523168');
INSERT INTO `luckdraw` VALUES ('11', '2', '1', '180,170,140', '16', '1', '1,2', null, '礼物', '1370067923', '1387447613');
INSERT INTO `luckdraw` VALUES ('12', '3', '1', '0,10,20', '4', '40,50', null, '{user}抽奖获得{amount}魅力值,翩翩风度好不惹眼', '魅力值', '1370067923', '1387447644');
INSERT INTO `luckdraw` VALUES ('13', '3', '1', '20,40,60', '9', '20,30', null, '', '魅力值', '1370067923', '1387447759');
INSERT INTO `luckdraw` VALUES ('14', '3', '1', '170,140,110', '17', '10,15', null, null, '魅力值', '1370067923', '1387447632');
INSERT INTO `luckdraw` VALUES ('15', '4', '1', '150,130,110', '15', '6,8', null, null, '经验值', '1370067923', '1387447581');
INSERT INTO `luckdraw` VALUES ('16', '4', '1', '40,60,80', '20', '16,18', null, '', '经验值', '1370067923', '1387447551');
INSERT INTO `luckdraw` VALUES ('17', '5', '1', '20,20,20', '8', '1', null, null, '免费机会', '1370067923', '1387447521');
INSERT INTO `luckdraw` VALUES ('18', '5', '1', '10,10,10', '0', '2', null, null, '免费机会', '1370067923', '1382577992');
INSERT INTO `luckdraw` VALUES ('19', '6', '1', '0,0,0', '14', '10,20', null, '吊爆啦,{user}抽奖获得{amount}元话费', '话费', '1370067923', '1382578016');
INSERT INTO `luckdraw` VALUES ('20', '6', '1', '0,0,0', '21', '30,50', null, '吊炸天了,{user}抽奖获得{amount}元话费', '话费', '1370067923', '1382523168');
INSERT INTO `luckdraw` VALUES ('21', '7', '1', '20,20,20', '11', '1', null, null, '奖励翻倍', '1382523168', '1382523168');
INSERT INTO `luckdraw` VALUES ('22', '8', '1', '0,0,0', '5', '1', null, null, '数码大奖', '1382523168', '1382523168');

-- ----------------------------
-- Table structure for marquee
-- ----------------------------
DROP TABLE IF EXISTS `marquee`;
CREATE TABLE `marquee` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `msg` varchar(200) DEFAULT NULL,
  `create_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of marquee
-- ----------------------------

-- ----------------------------
-- Table structure for message
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES ('5', '271', '地地道道的', '顶顶顶顶顶顶', '1', '1390374346', '1390374346');
INSERT INTO `message` VALUES ('6', '0', '鹅鹅鹅', '吾问无为谓王吾问无为谓', '1', '1390374357', '1390374357');
INSERT INTO `message` VALUES ('7', '271', 'gwegwe', 'ethrth', '1', '1395038961', '1395038961');
INSERT INTO `message` VALUES ('8', '271', 'ghhhhh', 'rrrrrr', '1', '1395038985', '1395038985');
INSERT INTO `message` VALUES ('9', '271', 'wwwww', 'eeeeee', '1', '1395038992', '1395038992');
INSERT INTO `message` VALUES ('10', '1712', '测试消息', '加快速度解放路阿斯顿交罚款了见识到了看风景了', '1', '1404812885', '1404812885');
INSERT INTO `message` VALUES ('11', '1710', '个人消息', '撒的发生的进口复合塑料袋咖啡壶圣诞节分开了实打实的健康傅雷家书的', '1', '1404812992', '1406014327');
INSERT INTO `message` VALUES ('12', '1', '忐忐忑忑', '啊啊啊啊啊啊啊啊啊啊', '0', '1408936554', '1408936558');

-- ----------------------------
-- Table structure for mmcrack_channel_info
-- ----------------------------
DROP TABLE IF EXISTS `mmcrack_channel_info`;
CREATE TABLE `mmcrack_channel_info` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `payType` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `appId` varchar(100) DEFAULT NULL,
  `appKey` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mmcrack_channel_info
-- ----------------------------
INSERT INTO `mmcrack_channel_info` VALUES ('1', 'mm_weak', '3004010995', 'app_wbPs6RhVZeUA', 'sk_iWWIqsYQiDsC');
INSERT INTO `mmcrack_channel_info` VALUES ('2', 'mm_weak', '3003967959', 'app_uuapKol9m1ke', 'sk_gYShuOPLmMdB');

-- ----------------------------
-- Table structure for moregame
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
-- Records of moregame
-- ----------------------------
INSERT INTO `moregame` VALUES ('1', '土豪炸翻天', '2014高档炸金花会所;<br/>男人的战场,女人的欢场;<br/>不为社交愁,不为金币忧,狂赢话费不是梦;<br/>摸了个金花,瞬间爽到家;<br/>土豪与高手云集,炸得你欲罢不能忘返难离;<br/>当美女遇上土豪,更有N番韵味;<br/>牌桌巅峰对决即在当下,好运难挡!', 'http://121.40.68.234:99/Public/moregame/th_zhafantian.png', 'http://121.40.68.234:99/Public/moregame/zjh_001.jpg,http://121.40.68.234:99/Public/moregame/zjh_002.jpg,http://121.40.68.234:99/Public/moregame/zjh_003.jpg,http://121.40.68.234:99/Public/moregame/zjh_004.jpg,http://121.40.68.234:99/Public/moregame/zjh_005.jpg', 'http://115.29.11.227/zjh/more/tuhaoniuniu/download.php', '1', '9.7', '1', '1', 'V1.9.1', 'Android 2.1以上', '5', '棋牌', '3BE5429F9F3F53ED97D934A86AFD783A', 'com.lizi.zjh');
INSERT INTO `moregame` VALUES ('2', '土豪斗地主', '2014最受期待的棋牌游戏火爆来袭！土豪斗地主爆笑登场，极简安装包，联网流量最低最流畅，玩法丰富奖励多多，小米机，大苹果任你挑！首推大满贯翻倍特色，高翻倍玩法让您畅爽赢到底！ <br/>游戏特色 ：<br/>1.首发语音系统，是真正的语音斗地主！解放双手，畅聊无极限！<br/>2.超小的手机安装包，超低的资源占用，支持各种网络接入方式，美女帅哥真人PK，流量超省，速度超快！<br/>3.个性化头像，场景任由挑选，拉风的称号等你来收集！\r\n4.丰富的游戏活动，每天都有话费拿，周周都有酷机送！<br/>5.每日任务独特新颖，丰厚奖励乐不思蜀，土豪斗地主！<br/>6.搞笑语音、魔法表情，爆笑的台词设计，流畅的操作手感，土豪赢大奖HIGH翻天！<br/>7.土豪斗地主=语音斗地主+赢话费斗地主+欢乐斗地主。', 'http://121.40.68.234:99/Public/moregame/th_doudizhu.png', 'http://121.40.68.234:99/Public/moregame/ddz_001.jpg,http://121.40.68.234:99/Public/moregame/ddz_002.jpg,http://121.40.68.234:99/Public/moregame/ddz_003.jpg,http://121.40.68.234:99/Public/moregame/ddz_004.jpg,http://121.40.68.234:99/Public/moregame/ddz_005.jpg', 'http://203.86.3.244:9090/ddz/20/landlord_4-0_-100paymarket000089.apk', '1', '10.2', '7', '1', 'v4.0', 'Android 2.1以上', '5', '棋牌', 'A59C4A71CC342B4631873A10283274DB', 'com.landlord.ddz');
INSERT INTO `moregame` VALUES ('7', '土豪牛牛', '2014高档斗牛会所;<br/>男人的战场,女人的欢场;<br/>不为社交愁,不为金币忧,狂赢话费不是梦;<br/>摸了个牛牛,瞬间精神擞;<br/>土豪与高手云集,斗得你忘返难离;<br/>当美女遇上土豪,更有N番韵味;<br/>牌桌巅峰对决即在当下,好运难挡!', 'http://121.40.68.234:99/Public/moregame/th_douniu.png', 'http://121.40.68.234:99/Public/moregame/nn_001.jpg,http://121.40.68.234:99/Public/moregame/nn_002.jpg,http://121.40.68.234:99/Public/moregame/nn_003.jpg,http://121.40.68.234:99/Public/moregame/nn_004.jpg,http://121.40.68.234:99/Public/moregame/nn_005.jpg', 'http://203.86.3.244:9090/bull/7/3003967914.7.apk', '-1', '8.0', '4', '1', 'v1.6', 'Android 2.1以上', '5', '棋牌', 'E42FD6EDC186897E18404DC406B9482E', 'com.chjie.dcow');
INSERT INTO `moregame` VALUES ('8', '土豪一锅端', '土豪一锅端,起源于国内流行的扑克玩法；<br/>三五个好友围成一团,盯着锅底的筹码伺机下注；<br/>走运时一锅端走所有金币,霉运时金币嗖嗖飞入锅底；<br/>跌宕的音乐、华丽的画面,配着大起大落的输赢,快哉快哉!', 'http://121.40.68.234:99/Public/moregame/th_yiguoduan.png', 'http://121.40.68.234:99/Public/moregame/hg_001.jpg,http://121.40.68.234:99/Public/moregame/hg_002.jpg,http://121.40.68.234:99/Public/moregame/hg_003.jpg,http://121.40.68.234:99/Public/moregame/hg_004.jpg,http://121.40.68.234:99/Public/moregame/hg_005.jpg', 'http://203.86.3.244:9090/chhg/2/3003918412.2.apk', '-2', '9.6', '3', '1', 'v1.1', 'Android 2.1以上', '5', '棋牌', '44426B1068FACB7A4A9392AD84817185', 'com.chjie.chhg');
INSERT INTO `moregame` VALUES ('9', '随e行', '“随e行”是中国移动通信集团公司开发的一款帮助用户便捷接入中国移动WLAN网络的客户端软件，能够主动为用户检查WLAN网络状态，根据系统能力自动帮助用户打开手机WLAN开关、自动连接中国移动的WLAN网络，并提供一键快速接入；便捷的下线操作，支持自动升级。移动用户输入用户名（手机号）和密码便可接入中国移动WLAN网络。<br/>随e行送流量啦!!2014年10月1日~10月31日期间，通过随e行WLAN客户端成功登录CMCC/CMCC-AUTO/CMCC-EDU网络，即送流量700M。<br/>活动规则:<br/>1、本次活动针对随e行WLAN手机客户端用户（包括 Android版、iPhone版、iPad版、Windows Phone版）；<br/>2、赠送的流量适用于登录CMCC和CMCC-AUTO网络；赠送的流量当月未使用完，次月失效;<br/>3、若用户在月末最后两天满足条件，则不赠送流量。<br/>活动详情请点击http://wlan.10086.cn/cmcc/hd/index.html<br/>随e行WLAN—最受欢迎的WIFI管理工具，7亿移动用户接入中国移动WLAN热点必备软件。<br/>中国移动唯一官方版本，完美适配中国移动WLAN热点(CMCC/ CMCC-AUTO/CMCC-EDU)，助您便捷接入各类WLAN网络。<br/>众多用户选择随e行WLAN的理由：<br/>1.一键轻松登录，用户名和密码免记忆；<br/>2.身边热点智能提醒，400万热点在线查询；<br/>3.各类套餐在线订购、查询；<br/>4.支持多个国家/地区的境外漫游；<br/>5.WLAN香港漫游只需6元/天，超过12000热点，覆盖海港城、朗豪坊、港铁全线车站、电话亭、星巴克、太平洋咖啡、711便利店等；<br/>联系我们：<br/>1.官方微信：公众号，搜索“中国移动随e行WLAN”<br/>2.官方微博：http://weibo.com/suiexing<br/>3.客服邮箱： wlansupport@139.com<br/>了解WLAN更多详情，请访问WLAN官方网站：http://wlan.10086.cn', 'http://121.40.68.234:99/Public/moregame/suiexing.png', 'http://121.40.68.234:99/Public/moregame/syx_001.png,http://121.40.68.234:99/Public/moregame/syx_002.png,http://121.40.68.234:99/Public/moregame/syx_003.png', 'http://203.86.3.244:9090/bull/e/CMCCWifi690918_0929_android3144000001.apk', '1', '8.3', '6', '0', 'v6.9.0918', 'Android 2.1以上', '5', '应用', '5A8D380822764C1C4C3CF85B2D74B3BE', 'com.chinamobile.cmccwifi');
INSERT INTO `moregame` VALUES ('10', '宠物消消乐2014', '风靡全球的超人气消除游戏萌翻来袭！<br/>全民一起卖萌消消乐！<br/>简单好玩，无广告，无需联网，无尽关卡，无限乐趣！<br/>★★★超华丽的星空爆炸特效，精心设计、惊喜不断的关卡类型，全新、与众不同的障碍和体验。<br/>★★★爆炸、变色、旋转...丰富好玩的道具系统，欢乐无极限！<br/>★★★限时礼包大派送，史上最高分不是梦，还有更多惊喜彩蛋等你来拿！<br/>可爱无比萌翻天的一大波宠物正在等着你的到来，让我们一起出发吧！', 'http://121.40.68.234:99/Public/moregame/xmxx.png', 'http://121.40.68.234:99/Public/moregame/xmxx_001.jpg,http://121.40.68.234:99/Public/moregame/xmxx_002.jpg,http://121.40.68.234:99/Public/moregame/xmxx_003.jpg,http://121.40.68.234:99/Public/moregame/xmxx_004.jpg,http://121.40.68.234:99/Public/moregame/xmxx_005.jpg', 'http://121.40.140.63:8080/apks/popstar-happy-1104-1.2.9-Signed_300008439792_3003970750.apk', '1', '2.6', '5', '0', 'v1.2.9', 'Android 2.1以上', '5', '休闲游戏', '6CBED91423671791BB570818997E61E5', 'com.PopHappy.org');
INSERT INTO `moregame` VALUES ('11', '土豪德州', '德州扑克哪家强？尽在土豪德州;<br/>男人的战场,女人的欢场;不为社交愁,不为金币忧,狂赢话费不是梦;摸了个金刚,一把全赢光;土豪与高手云集,爽得你忘返难离;当美女遇上土豪,更有N番韵味;牌桌巅峰对决即在当下,好运难挡!', 'http://121.40.68.234:99/Public/moregame/th_dezhou.jpg', 'http://121.40.68.234:99/Public/moregame/thdz_001.jpg,http://121.40.68.234:99/Public/moregame/thdz_002.jpg,http://121.40.68.234:99/Public/moregame/thdz_003.jpg,http://121.40.68.234:99/Public/moregame/thdz_004.jpg,http://121.40.68.234:99/Public/moregame/thdz_005.jpg', 'http://115.29.11.227/more_games/texas_in_nn_more/download.php', '1', '13.1', '2', '1', 'v1.3.0', 'Android 2.1以上', '5', '棋牌', 'E1C07451EAEA5208B9DEC05BC0B262A9', 'com.lizi.texas.wubile');

-- ----------------------------
-- Table structure for moregamelog
-- ----------------------------
DROP TABLE IF EXISTS `moregamelog`;
CREATE TABLE `moregamelog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `gameId` smallint(2) DEFAULT NULL COMMENT '目标游戏ID:0,首页;1-n,moregame对应的游戏ID',
  `etype` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '访客入口:客户端自定义',
  `uid` bigint(8) DEFAULT NULL COMMENT '访客游戏ID',
  `create_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of moregamelog
-- ----------------------------

-- ----------------------------
-- Table structure for node
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
  KEY `level` (`level`) USING BTREE,
  KEY `pid` (`pid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=110 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of node
-- ----------------------------
INSERT INTO `node` VALUES ('49', 'read', '查看', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('40', 'Index', '默认模块', '1', '', '1', '1', '2', '0', '2');
INSERT INTO `node` VALUES ('39', 'index', '列表', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('37', 'resume', '恢复', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('36', 'forbid', '禁用', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('35', 'foreverdelete', '删除', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('34', 'update', '更新', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('33', 'edit', '编辑', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('32', 'insert', '写入', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('31', 'add', '新增', '1', '', null, '30', '3', '0', '0');
INSERT INTO `node` VALUES ('30', 'Public', '公共模块', '1', '', '2', '1', '2', '0', '2');
INSERT INTO `node` VALUES ('7', 'User', '后台用户', '1', '', '4', '1', '2', '0', '2');
INSERT INTO `node` VALUES ('6', 'Role', '角色管理', '1', '', '3', '1', '2', '0', '2');
INSERT INTO `node` VALUES ('2', 'Node', '节点管理', '1', '', '2', '1', '2', '0', '2');
INSERT INTO `node` VALUES ('1', 'Admin', '系统管理', '0', '', '3', '0', '1', '0', '0');
INSERT INTO `node` VALUES ('50', 'main', '空白首页', '1', '', null, '40', '3', '0', '0');
INSERT INTO `node` VALUES ('84', 'Game', '游戏管理', '1', '', '1', '0', '1', '0', '0');
INSERT INTO `node` VALUES ('85', 'Player', '玩家管理', '1', '', '1', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('86', 'Announcement', '公告管理', '0', '', '3', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('87', 'Operation', '运营数据', '0', '', '2', '0', '1', '0', '0');
INSERT INTO `node` VALUES ('88', 'Payrecord', 'RMB充值记录', '1', '', '1', '87', '2', '0', '0');
INSERT INTO `node` VALUES ('89', 'Feedback', '反馈管理', '1', '', '4', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('90', 'Message', '消息管理', '0', '', '5', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('91', 'Venue', '场馆管理', '0', '', '2', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('92', 'Rank', '排名管理', '0', '', '6', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('93', 'Goods', 'RMB兑换管理', '0', '', '7', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('94', 'Goodslog', 'RMB兑换记录', '0', '', '3', '87', '2', '0', '0');
INSERT INTO `node` VALUES ('95', 'Award', '元宝兑奖管理', '0', '', '8', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('96', 'Awardlog', '元宝兑奖记录', '1', '', '3', '87', '2', '0', '0');
INSERT INTO `node` VALUES ('97', 'Onplay', '在玩用户统计', '1', '', '4', '87', '2', '0', '0');
INSERT INTO `node` VALUES ('98', 'Payrecordday', '每日充值统计', '1', '', '2', '87', '2', '0', '0');
INSERT INTO `node` VALUES ('99', 'Lottery', '抽奖管理', '0', null, '9', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('100', 'Loginreward', '登陆奖励', '0', null, '10', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('101', 'Tasksconf', '任务管理', '0', null, '11', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('102', 'Notice', '大喇叭管理', '0', null, '12', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('103', 'Speaker', '推送大喇叭', '0', null, '13', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('104', 'Activityconf', '活动管理', '0', null, '14', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('105', 'Activityaward', '活动奖励管理', '0', null, '15', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('106', 'Addmoneycoinlog', '加金币元宝日志', '1', null, '6', '87', '2', '0', '0');
INSERT INTO `node` VALUES ('107', 'Playerext', '玩家扩展信息', '0', null, '16', '84', '2', '0', '0');
INSERT INTO `node` VALUES ('109', 'Cheat', '举报管理', '1', null, '17', '84', '2', '0', '0');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `type` smallint(2) NOT NULL,
  `desc` varchar(100) NOT NULL,
  `create_time` int(4) DEFAULT NULL,
  `update_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES ('1', '101', 'RP爆发,{user}在每日免费抽奖中抽到{desp}', '1386034357', '1386034320');
INSERT INTO `notice` VALUES ('2', '102', '恭喜恭喜,{user}在幸运大抽奖中抽到{desp}', '1386034357', '1386034311');

-- ----------------------------
-- Table structure for onplay
-- ----------------------------
DROP TABLE IF EXISTS `onplay`;
CREATE TABLE `onplay` (
  `vid` int(11) NOT NULL COMMENT '房间ID',
  `timestamp` int(10) NOT NULL COMMENT '时间戳',
  `amount` int(11) NOT NULL COMMENT '人数',
  PRIMARY KEY (`vid`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线人数';

-- ----------------------------
-- Records of onplay
-- ----------------------------

-- ----------------------------
-- Table structure for open_act_award_log
-- ----------------------------
DROP TABLE IF EXISTS `open_act_award_log`;
CREATE TABLE `open_act_award_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `awardcoin` int(4) DEFAULT NULL,
  `wintimes` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5587 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of open_act_award_log
-- ----------------------------

-- ----------------------------
-- Table structure for open_act_log
-- ----------------------------
DROP TABLE IF EXISTS `open_act_log`;
CREATE TABLE `open_act_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `winTime` bigint(8) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=745975 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of open_act_log
-- ----------------------------

-- ----------------------------
-- Table structure for payback_log
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
) ENGINE=InnoDB AUTO_INCREMENT=1400492 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of payback_log
-- ----------------------------
-- ----------------------------
-- Table structure for payorder
-- ----------------------------
DROP TABLE IF EXISTS `payorder`;
CREATE TABLE `payorder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `order_id` varchar(30) DEFAULT NULL COMMENT '订单号',
  `sdk` varchar(10) DEFAULT NULL COMMENT 'sdk代号',
  `rmb` int(11) DEFAULT NULL,
  `mac` varchar(30) DEFAULT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `success` tinyint(4) DEFAULT '0' COMMENT '0=初始订单;1=成功支付订单',
  `money` int(11) DEFAULT '0',
  `coin` int(11) DEFAULT '0',
  `istrap` tinyint(4) DEFAULT '0' COMMENT '是否付费坑的订单',
  `trap` int(11) DEFAULT '-2',
  `pos` int(11) DEFAULT '-2',
  `money0` bigint(20) DEFAULT '0' COMMENT '玩家充值前的金币数',
  `money1` bigint(20) DEFAULT '0' COMMENT '玩家充值后的金币数',
  `rmb_fen` int(11) DEFAULT '0' COMMENT '金额(分)',
  `ccd` tinyint(4) DEFAULT '0' COMMENT '0=服务器端校验; 1=客户端校验',
  `goods_id` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`order_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `sdk` (`sdk`) USING BTREE,
  KEY `rmb` (`rmb`) USING BTREE,
  KEY `updated_at` (`updated_at`) USING BTREE,
  KEY `created_at` (`created_at`) USING BTREE,
  KEY `success` (`success`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5658474 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of payorder
-- ----------------------------

-- ----------------------------
-- Table structure for payrecord
-- ----------------------------
DROP TABLE IF EXISTS `payrecord`;
CREATE TABLE `payrecord` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(1) NOT NULL COMMENT '用户ID',
  `rmb` int(1) NOT NULL COMMENT '充值人民币数',
  `sdkId` varchar(10) DEFAULT '0',
  `orderId` varchar(50) DEFAULT '0',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8 COMMENT='充值记录表';

-- ----------------------------
-- Records of payrecord
-- ----------------------------

-- ----------------------------
-- Table structure for payrule
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='某个appid或者cpid的需要用到的支付SDK';

-- ----------------------------
-- Records of payrule
-- ----------------------------
INSERT INTO `payrule` VALUES ('2', 'cm', '0', '100mmytest000001', '10', '2014-01-16 14:22:00');
INSERT INTO `payrule` VALUES ('3', 'cu', '0', '100mmytest000001', '10', '2014-01-16 14:22:13');
INSERT INTO `payrule` VALUES ('4', 'ct', '0', '100mmytest000001', '10', '2014-01-16 14:22:28');
INSERT INTO `payrule` VALUES ('5', 'cm', '0', '100mumayi000001', '10', '2014-01-17 14:10:44');
INSERT INTO `payrule` VALUES ('6', 'cu', '0', '100mumayi000001', '10', '2014-01-17 13:58:30');
INSERT INTO `payrule` VALUES ('7', 'ct', '0', '100mumayi000001', '10', '2014-01-17 13:58:40');
INSERT INTO `payrule` VALUES ('8', 'cm', '0', '100lianyun000001', '10', '2014-01-23 11:24:08');
INSERT INTO `payrule` VALUES ('9', 'cu', '0', '100lianyun000001', '10', '2014-01-23 11:24:27');
INSERT INTO `payrule` VALUES ('10', 'ct', '0', '100lianyun000001', '10', '2014-01-23 11:24:35');
INSERT INTO `payrule` VALUES ('11', 'cu', '0', '100unitest000001', '02', '2014-01-23 16:46:06');
INSERT INTO `payrule` VALUES ('12', 'ct', '0', '100dianxin000001', '04', '2014-02-28 16:41:11');
INSERT INTO `payrule` VALUES ('13', 'cu', '0', '100dianxin000001', '04', '2014-02-28 16:41:58');
INSERT INTO `payrule` VALUES ('14', 'cm', '0', '100dianxin000001', '04', '2014-02-28 16:42:09');
INSERT INTO `payrule` VALUES ('15', 'ct', '0', '100unitest000001', '02', '2014-03-05 13:59:04');
INSERT INTO `payrule` VALUES ('16', 'cm', '0', '100unitest000001', '02', '2014-03-05 13:59:14');
INSERT INTO `payrule` VALUES ('17', 'cu', '0', '1000000mm000001', '01', '2014-03-14 09:59:02');
INSERT INTO `payrule` VALUES ('18', 'ct', '0', '1000000mm000001', '01', '2014-03-14 09:59:12');
INSERT INTO `payrule` VALUES ('19', 'cm', '0', '1000000mm000001', '01', '2014-03-14 09:59:32');

-- ----------------------------
-- Table structure for pay_limit
-- ----------------------------
DROP TABLE IF EXISTS `pay_limit`;
CREATE TABLE `pay_limit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `limit_key` enum('uid','imsi','imei') DEFAULT 'imsi' COMMENT 'uid=用户ID；imsi=sim卡；imei=设备',
  `limit_value` varchar(50) DEFAULT NULL COMMENT '数值',
  `day_rmb` int(11) DEFAULT '200' COMMENT '日限额(元)',
  `month_rmb` int(11) DEFAULT '1500' COMMENT '月限额(元)',
  `day_rmb_old` int(11) DEFAULT '0' COMMENT '修改前日限额',
  `month_rmb_old` int(11) DEFAULT '0' COMMENT '修改前月限额',
  `memo` varchar(100) DEFAULT NULL COMMENT '备注',
  `who` varchar(30) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `limit_key` (`limit_key`,`limit_value`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay_limit
-- ----------------------------
INSERT INTO `pay_limit` VALUES ('6', 'uid', '39140', '2', '30', '0', '0', '', 'xiaoy', '2014-09-26 10:11:37');
INSERT INTO `pay_limit` VALUES ('7', 'imsi', '460017915438831', '7', '750', '7', '1500', '月份达限,月限额减半', 'system', '2014-11-01 06:20:06');
INSERT INTO `pay_limit` VALUES ('8', 'uid', '85201', '7', '750', '13', '750', '连续3日达限，日限额减半', 'system', '2014-11-05 00:49:42');
INSERT INTO `pay_limit` VALUES ('9', 'imei', '864833010258258', '7', '750', '7', '1500', '月份达限,月限额减半', 'system', '2014-11-01 06:20:06');
INSERT INTO `pay_limit` VALUES ('10', 'imsi', '460014196232620', '100', '750', '200', '750', '连续3日达限，日限额减半', 'system', '2014-11-02 18:06:26');
INSERT INTO `pay_limit` VALUES ('11', 'imei', '358198056835432', '100', '750', '200', '750', '连续3日达限，日限额减半', 'system', '2014-11-02 18:06:26');
INSERT INTO `pay_limit` VALUES ('12', 'imsi', '460030960247012', '13', '750', '13', '1500', '月份达限,月限额减半', 'system', '2014-12-06 14:01:59');
INSERT INTO `pay_limit` VALUES ('13', 'uid', '129406', '13', '750', '13', '1500', '月份达限,月限额减半', 'system', '2014-12-06 14:01:59');
INSERT INTO `pay_limit` VALUES ('14', 'imei', 'a0000042c39650', '13', '750', '13', '1500', '月份达限,月限额减半', 'system', '2014-12-06 14:01:59');
INSERT INTO `pay_limit` VALUES ('15', 'uid', '70447', '200', '750', '200', '1500', '月份达限,月限额减半', 'system', '2014-11-03 17:18:05');
INSERT INTO `pay_limit` VALUES ('16', 'imsi', '460020847595487', '200', '188', '200', '375', '月份达限,月限额减半', 'system', '2015-06-07 20:14:57');
INSERT INTO `pay_limit` VALUES ('17', 'uid', '92424', '200', '188', '200', '375', '月份达限,月限额减半', 'system', '2015-06-07 20:14:57');
INSERT INTO `pay_limit` VALUES ('18', 'imei', '351868060057275', '200', '188', '200', '375', '月份达限,月限额减半', 'system', '2015-06-07 20:14:57');
INSERT INTO `pay_limit` VALUES ('19', 'imei', '358584059238668', '200', '94', '200', '188', '月份达限,月限额减半', 'system', '2015-03-01 05:28:28');
INSERT INTO `pay_limit` VALUES ('20', 'imsi', '460010065093500', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-05 14:14:56');
INSERT INTO `pay_limit` VALUES ('21', 'uid', '317334', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-05 14:14:57');
INSERT INTO `pay_limit` VALUES ('22', 'imei', '862940015030533', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-05 14:14:57');
INSERT INTO `pay_limit` VALUES ('23', 'imei', '863786020526729', '7', '500', '7', '1000', '月份达限,月限额减半', 'system', '2015-01-05 13:15:01');
INSERT INTO `pay_limit` VALUES ('24', 'uid', '364017', '13', '1000', '25', '1000', '连续3日达限，日限额减半', 'system', '2014-12-27 04:04:16');
INSERT INTO `pay_limit` VALUES ('25', 'imsi', '460023152974235', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-22 00:35:39');
INSERT INTO `pay_limit` VALUES ('26', 'imei', '864319020015953', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-22 00:35:39');
INSERT INTO `pay_limit` VALUES ('27', 'imsi', '460079298479217', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2014-12-25 11:56:09');
INSERT INTO `pay_limit` VALUES ('28', 'imei', '865886010172423', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2014-12-25 11:56:10');
INSERT INTO `pay_limit` VALUES ('29', 'imsi', '460029153393057', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-29 04:32:01');
INSERT INTO `pay_limit` VALUES ('30', 'uid', '380978', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-29 04:32:02');
INSERT INTO `pay_limit` VALUES ('31', 'imei', '355735000792481', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2014-12-29 04:32:02');
INSERT INTO `pay_limit` VALUES ('32', 'imsi', '460014695906650', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2014-12-31 00:30:46');
INSERT INTO `pay_limit` VALUES ('33', 'uid', '355112', '100', '375', '100', '750', '月份达限,月限额减半', 'system', '2015-02-02 13:02:33');
INSERT INTO `pay_limit` VALUES ('34', 'imei', '864821027374762', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-01-07 00:23:40');
INSERT INTO `pay_limit` VALUES ('35', 'uid', '203063', '200', '375', '200', '750', '月份达限,月限额减半', 'system', '2015-02-03 12:17:33');
INSERT INTO `pay_limit` VALUES ('36', 'imei', '864566029226920', '200', '375', '200', '750', '月份达限,月限额减半', 'system', '2015-02-03 12:17:34');
INSERT INTO `pay_limit` VALUES ('37', 'imsi', '460017972035542', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-01-07 22:37:08');
INSERT INTO `pay_limit` VALUES ('38', 'uid', '393537', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-01-07 22:37:08');
INSERT INTO `pay_limit` VALUES ('39', 'imei', '356512051354953', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-01-07 22:37:08');
INSERT INTO `pay_limit` VALUES ('40', 'imsi', '460026181197996', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-01-10 10:08:05');
INSERT INTO `pay_limit` VALUES ('41', 'imei', '863469020709781', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-01-10 10:08:05');
INSERT INTO `pay_limit` VALUES ('42', 'imsi', '460014232270171', '7', '1000', '13', '1000', '连续3日达限，日限额减半', 'system', '2015-02-02 22:15:07');
INSERT INTO `pay_limit` VALUES ('43', 'uid', '181906', '7', '1000', '13', '1000', '连续3日达限，日限额减半', 'system', '2015-02-14 15:45:41');
INSERT INTO `pay_limit` VALUES ('44', 'imei', '869032660110811', '7', '1000', '13', '1000', '连续3日达限，日限额减半', 'system', '2015-02-02 22:15:07');
INSERT INTO `pay_limit` VALUES ('45', 'imsi', '460036820674314', '50', '500', '50', '1000', '月份达限,月限额减半', 'system', '2015-02-02 00:13:23');
INSERT INTO `pay_limit` VALUES ('46', 'imei', 'a1000041cea354', '50', '500', '50', '1000', '月份达限,月限额减半', 'system', '2015-02-02 00:13:24');
INSERT INTO `pay_limit` VALUES ('47', 'uid', '403142', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-01-17 15:53:21');
INSERT INTO `pay_limit` VALUES ('48', 'imei', '863590010830152', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-01-17 15:53:21');
INSERT INTO `pay_limit` VALUES ('49', 'imsi', '460023178281403', '50', '500', '50', '1000', '月份达限,月限额减半', 'system', '2015-02-22 18:11:01');
INSERT INTO `pay_limit` VALUES ('50', 'imei', '865391017047074', '50', '500', '50', '1000', '月份达限,月限额减半', 'system', '2015-02-22 18:11:01');
INSERT INTO `pay_limit` VALUES ('51', 'imsi', '460025168829138', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-02-01 01:24:48');
INSERT INTO `pay_limit` VALUES ('52', 'imei', '869488000330636', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-02-01 01:24:48');
INSERT INTO `pay_limit` VALUES ('53', 'uid', '358422', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-02-02 00:13:24');
INSERT INTO `pay_limit` VALUES ('54', 'imsi', '460018644303432', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-02-02 10:59:52');
INSERT INTO `pay_limit` VALUES ('55', 'imei', '864605021102034', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-02-02 10:59:52');
INSERT INTO `pay_limit` VALUES ('56', 'uid', '241731', '200', '750', '200', '1500', '月份达限,月限额减半', 'system', '2015-02-02 16:37:53');
INSERT INTO `pay_limit` VALUES ('57', 'imei', '866645010009930', '200', '750', '200', '1500', '月份达限,月限额减半', 'system', '2015-02-02 16:37:53');
INSERT INTO `pay_limit` VALUES ('58', 'uid', '429792', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-02-09 22:03:21');
INSERT INTO `pay_limit` VALUES ('59', 'imsi', '460030814449053', '25', '500', '25', '1000', '月份达限,月限额减半', 'system', '2015-03-02 17:14:12');
INSERT INTO `pay_limit` VALUES ('60', 'uid', '468857', '25', '500', '25', '1000', '月份达限,月限额减半', 'system', '2015-03-02 17:14:12');
INSERT INTO `pay_limit` VALUES ('61', 'imei', 'a000002e6b4eb4', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-02-23 07:17:28');
INSERT INTO `pay_limit` VALUES ('62', 'imsi', '460023585947777', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-02-26 05:50:22');
INSERT INTO `pay_limit` VALUES ('63', 'uid', '515018', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-02-26 05:50:22');
INSERT INTO `pay_limit` VALUES ('64', 'imei', '863738026303496', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-02-26 05:50:22');
INSERT INTO `pay_limit` VALUES ('65', 'imsi', '460023456316189', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-03-01 09:13:09');
INSERT INTO `pay_limit` VALUES ('66', 'uid', '384428', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-03-01 09:13:09');
INSERT INTO `pay_limit` VALUES ('67', 'imei', '867987010042133', '100', '500', '100', '1000', '月份达限,月限额减半', 'system', '2015-03-01 09:13:09');
INSERT INTO `pay_limit` VALUES ('68', 'imei', '864891029377204', '50', '375', '50', '750', '月份达限,月限额减半', 'system', '2015-05-08 13:32:27');
INSERT INTO `pay_limit` VALUES ('69', 'imsi', '460019044211583', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-03-21 14:18:47');
INSERT INTO `pay_limit` VALUES ('70', 'uid', '590671', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-03-21 14:18:47');
INSERT INTO `pay_limit` VALUES ('71', 'imei', '869937011050419', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-03-21 14:18:47');
INSERT INTO `pay_limit` VALUES ('72', 'imsi', '460031549915645', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-03-24 17:05:41');
INSERT INTO `pay_limit` VALUES ('73', 'uid', '622793', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-03-24 17:05:41');
INSERT INTO `pay_limit` VALUES ('74', 'imei', 'a000004f842431', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-03-24 17:05:41');
INSERT INTO `pay_limit` VALUES ('75', 'imsi', '460000144714232', '7', '1500', '13', '1500', '连续3日达限，日限额减半', 'system', '2015-04-19 06:11:59');
INSERT INTO `pay_limit` VALUES ('76', 'uid', '656703', '7', '1500', '13', '1500', '连续3日达限，日限额减半', 'system', '2015-04-19 06:11:59');
INSERT INTO `pay_limit` VALUES ('77', 'imei', '864678020318992', '7', '1500', '13', '1500', '连续3日达限，日限额减半', 'system', '2015-04-19 06:11:59');
INSERT INTO `pay_limit` VALUES ('78', 'uid', '524059', '200', '750', '200', '1500', '月份达限,月限额减半', 'system', '2015-04-01 11:09:00');
INSERT INTO `pay_limit` VALUES ('79', 'imei', '866022027794558', '200', '750', '200', '1500', '月份达限,月限额减半', 'system', '2015-04-01 11:09:00');
INSERT INTO `pay_limit` VALUES ('80', 'imsi', '460030911624118', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-04-14 23:39:32');
INSERT INTO `pay_limit` VALUES ('81', 'imei', 'a000004f0b39aa', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-04-14 23:39:33');
INSERT INTO `pay_limit` VALUES ('82', 'imsi', '460027031059718', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-04-27 08:54:13');
INSERT INTO `pay_limit` VALUES ('83', 'uid', '776648', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-04-27 08:54:13');
INSERT INTO `pay_limit` VALUES ('84', 'imei', '864468020126451', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-04-27 08:54:13');
INSERT INTO `pay_limit` VALUES ('85', 'imsi', '460022702598268', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-05-06 16:12:28');
INSERT INTO `pay_limit` VALUES ('86', 'uid', '558852', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-05-06 16:12:28');
INSERT INTO `pay_limit` VALUES ('87', 'imei', '865881023300517', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-05-06 16:12:28');
INSERT INTO `pay_limit` VALUES ('88', 'imsi', '460004369780667', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-05-10 22:41:13');
INSERT INTO `pay_limit` VALUES ('89', 'uid', '796211', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-05-10 22:41:13');
INSERT INTO `pay_limit` VALUES ('90', 'imei', '860991022520000', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-05-10 22:41:13');
INSERT INTO `pay_limit` VALUES ('91', 'imsi', '460022927799460', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-05-19 00:26:53');
INSERT INTO `pay_limit` VALUES ('92', 'uid', '940685', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-05-19 00:26:54');
INSERT INTO `pay_limit` VALUES ('93', 'imei', '865763022893041', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-05-19 00:26:54');
INSERT INTO `pay_limit` VALUES ('94', 'imsi', '460014926937207', '25', '1000', '50', '1000', '连续3日达限，日限额减半', 'system', '2015-05-23 13:54:57');
INSERT INTO `pay_limit` VALUES ('95', 'uid', '943407', '25', '1000', '50', '1000', '连续3日达限，日限额减半', 'system', '2015-05-23 13:54:57');
INSERT INTO `pay_limit` VALUES ('96', 'imei', '867034010304468', '25', '1000', '50', '1000', '连续3日达限，日限额减半', 'system', '2015-05-23 13:54:57');
INSERT INTO `pay_limit` VALUES ('97', 'imsi', '460012315201375', '7', '750', '13', '750', '连续3日达限，日限额减半', 'system', '2015-07-08 19:54:48');
INSERT INTO `pay_limit` VALUES ('98', 'uid', '386339', '50', '750', '50', '1500', '月份达限,月限额减半', 'system', '2015-07-01 14:53:14');
INSERT INTO `pay_limit` VALUES ('99', 'imei', '862139020215417', '7', '750', '13', '750', '连续3日达限，日限额减半', 'system', '2015-07-08 19:54:48');
INSERT INTO `pay_limit` VALUES ('100', 'imsi', '460036970253989', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-06-22 01:45:14');
INSERT INTO `pay_limit` VALUES ('101', 'uid', '1027118', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-06-22 01:45:14');
INSERT INTO `pay_limit` VALUES ('102', 'imei', 'A000005544519E', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-06-22 01:45:15');
INSERT INTO `pay_limit` VALUES ('103', 'imsi', '460029944439971', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-06-29 11:00:19');
INSERT INTO `pay_limit` VALUES ('104', 'imei', '864061020320989', '50', '1000', '100', '1000', '连续3日达限，日限额减半', 'system', '2015-06-29 11:00:19');
INSERT INTO `pay_limit` VALUES ('105', 'uid', '1093973', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-07-11 17:26:09');
INSERT INTO `pay_limit` VALUES ('106', 'uid', '1093974', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-07-14 11:48:29');
INSERT INTO `pay_limit` VALUES ('107', 'uid', '1092563', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-07-15 14:20:43');
INSERT INTO `pay_limit` VALUES ('108', 'uid', '1048500', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-07-16 11:28:41');
INSERT INTO `pay_limit` VALUES ('109', 'uid', '1104899', '25', '1500', '50', '1500', '连续3日达限，日限额减半', 'system', '2015-07-19 09:29:10');
INSERT INTO `pay_limit` VALUES ('110', 'uid', '1105635', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-07-19 09:30:35');
INSERT INTO `pay_limit` VALUES ('111', 'uid', '1104901', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-07-16 11:28:58');
INSERT INTO `pay_limit` VALUES ('112', 'uid', '1104898', '50', '1500', '100', '1500', '连续3日达限，日限额减半', 'system', '2015-07-19 09:32:30');
INSERT INTO `pay_limit` VALUES ('113', 'uid', '1106026', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-07-18 10:53:39');
INSERT INTO `pay_limit` VALUES ('114', 'uid', '1048504', '100', '1500', '200', '1500', '连续3日达限，日限额减半', 'system', '2015-07-19 10:17:38');

-- ----------------------------
-- Table structure for pay_limit_log
-- ----------------------------
DROP TABLE IF EXISTS `pay_limit_log`;
CREATE TABLE `pay_limit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `limit_key` enum('uid','imsi','imei') DEFAULT 'imsi' COMMENT 'uid=用户ID；imsi=sim卡；imei=设备',
  `limit_value` varchar(50) DEFAULT NULL COMMENT '数值',
  `day_rmb` int(11) DEFAULT '200' COMMENT '日限额(元)',
  `month_rmb` int(11) DEFAULT '1500' COMMENT '月限额(元)',
  `day_rmb_old` int(11) DEFAULT '0' COMMENT '修改前日限额',
  `month_rmb_old` int(11) DEFAULT '0' COMMENT '修改前月限额',
  `memo` varchar(100) DEFAULT NULL,
  `who` varchar(30) DEFAULT NULL COMMENT '操作人员',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `limit_key` (`limit_key`,`limit_value`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay_limit_log
-- ----------------------------

-- ----------------------------
-- Table structure for pay_limit_log_invalid
-- ----------------------------
DROP TABLE IF EXISTS `pay_limit_log_invalid`;
CREATE TABLE `pay_limit_log_invalid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `sdk` varchar(10) DEFAULT NULL COMMENT 'sdk代号',
  `rmb` int(11) DEFAULT '0' COMMENT '防刷金额',
  `errcode` varchar(10) DEFAULT NULL COMMENT '错误码',
  `memo` varchar(50) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `uid_2` (`uid`,`sdk`),
  KEY `errcode` (`errcode`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=20777 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay_limit_log_invalid
-- ----------------------------

-- ----------------------------
-- Table structure for pay_msg
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
-- Records of pay_msg
-- ----------------------------
INSERT INTO `pay_msg` VALUES ('1', ',2,5,', '$p1充值$p2元获得了$p3金币,好惬意~', '2014-07-02 17:31:20');
INSERT INTO `pay_msg` VALUES ('2', ',10,20,', '$p1充值$p2元获得了$p3金币,真爽!', '2014-07-02 17:31:43');
INSERT INTO `pay_msg` VALUES ('3', ',30,50,', '$p1充值$p2元获得了$p3金币,嗨大了^^', '2014-07-02 17:32:06');
INSERT INTO `pay_msg` VALUES ('4', ',100,', '$p1充值$p2元获得了$p3金币,灰常给力', '2014-07-02 17:33:24');
INSERT INTO `pay_msg` VALUES ('5', ',300,', '$p1充值$p2元获得了$p3金币,惊呆了~', '2014-07-02 17:33:49');
INSERT INTO `pay_msg` VALUES ('6', ',500,1000,2000,3000,', '$p1充值$p2元获得了$p3金币,感觉像在飞', '2014-07-02 17:34:37');

-- ----------------------------
-- Table structure for pay_points
-- ----------------------------
DROP TABLE IF EXISTS `pay_points`;
CREATE TABLE `pay_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pay_sdk_id` int(11) DEFAULT NULL COMMENT 'pay_sdk.id',
  `point` varchar(50) DEFAULT NULL COMMENT '计费点',
  `point_name` varchar(50) DEFAULT NULL COMMENT 'boss.goods.id',
  `goods_type` int(11) DEFAULT '0' COMMENT '商品类型:0,金币;1,道具',
  `goods_id` int(11) DEFAULT '0' COMMENT '商品ID',
  `fee` int(11) DEFAULT '0' COMMENT '资费(分)',
  `rmb` int(11) DEFAULT '0' COMMENT '资费(元)',
  `money` int(11) DEFAULT '0' COMMENT '购买金币',
  `coin` int(11) DEFAULT '0' COMMENT '元宝',
  `a` tinyint(4) DEFAULT '0' COMMENT '0|1；计费点是否超值',
  `b` tinyint(4) DEFAULT '0' COMMENT '0|1；计费点是否热销',
  `desp` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '描述',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sdk` (`point_name`) USING BTREE,
  KEY `pay_sdk_id` (`pay_sdk_id`) USING BTREE,
  KEY `point` (`point`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=374 DEFAULT CHARSET=utf8 COMMENT='计费点信息';

-- ----------------------------
-- Records of pay_points
-- ----------------------------
INSERT INTO `pay_points` VALUES ('1', '1', '1', '2.1万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-06-16 15:53:22');
INSERT INTO `pay_points` VALUES ('2', '1', '2', '5.3万金币', '0', '0', '500', '5', '53000', '5', '0', '1', null, '2015-06-16 15:53:29');
INSERT INTO `pay_points` VALUES ('3', '1', '3', '10.7万金币', '0', '0', '1000', '10', '107000', '10', '0', '1', null, '2015-06-16 15:53:08');
INSERT INTO `pay_points` VALUES ('4', '1', '4', '21.5万金币', '0', '0', '2000', '20', '215000', '20', '1', '0', null, '2015-06-16 15:53:34');
INSERT INTO `pay_points` VALUES ('5', '1', '5', '32.4万金币', '0', '0', '3000', '30', '324000', '30', '1', '0', null, '2015-06-16 15:54:05');
INSERT INTO `pay_points` VALUES ('6', '2', '140808049878', '2万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-06-01 10:21:12');
INSERT INTO `pay_points` VALUES ('7', '2', '140808049879', '5万金币', '0', '0', '500', '5', '53000', '5', '0', '1', null, '2015-06-01 10:21:13');
INSERT INTO `pay_points` VALUES ('8', '2', '140808049880', '10万金币', '0', '0', '1000', '10', '107000', '10', '0', '1', null, '2015-06-01 10:21:14');
INSERT INTO `pay_points` VALUES ('9', '2', '140808049881', '20万金币', '0', '0', '2000', '20', '215000', '20', '1', '0', null, '2015-06-01 10:21:14');
INSERT INTO `pay_points` VALUES ('10', '2', '140808049882', '30万金币', '0', '0', '3000', '30', '324000', '30', '1', '0', null, '2015-06-01 10:21:15');
INSERT INTO `pay_points` VALUES ('249', '3', '1', '2.1万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-06-16 15:54:24');
INSERT INTO `pay_points` VALUES ('250', '3', '2', '5.3万金币', '0', '0', '500', '5', '53000', '5', '0', '1', null, '2015-06-16 15:54:35');
INSERT INTO `pay_points` VALUES ('251', '3', '3', '10.7万金币', '0', '0', '1000', '10', '107000', '10', '0', '1', null, '2015-06-16 15:54:40');
INSERT INTO `pay_points` VALUES ('252', '3', '4', '21.5万金币', '0', '0', '2000', '20', '215000', '20', '1', '0', null, '2015-06-16 15:54:43');
INSERT INTO `pay_points` VALUES ('253', '3', '5', '32.4万金币', '0', '0', '3000', '30', '324000', '30', '1', '0', null, '2015-06-16 15:54:46');
INSERT INTO `pay_points` VALUES ('256', '4', '1', '21.8万金币', '0', '0', '2000', '20', '218000', '20', '0', '0', null, '2015-06-16 15:54:55');
INSERT INTO `pay_points` VALUES ('257', '4', '2', '32.7万金币', '0', '0', '3000', '30', '327000', '30', '0', '0', null, '2015-06-16 15:54:59');
INSERT INTO `pay_points` VALUES ('258', '4', '3', '54.8万金币', '0', '0', '5000', '50', '548000', '50', '0', '0', null, '2015-06-16 15:55:04');
INSERT INTO `pay_points` VALUES ('259', '4', '4', '110万金币', '0', '0', '10000', '100', '1100000', '100', '0', '0', null, '2015-06-16 15:55:10');
INSERT INTO `pay_points` VALUES ('260', '4', '5', '350万金币', '0', '0', '30000', '300', '3500000', '300', '0', '0', null, '2015-06-16 15:55:14');
INSERT INTO `pay_points` VALUES ('263', '5', '1', '3.5万金币', '0', '0', '300', '3', '35000', '3', '0', '0', null, '2015-06-16 15:55:18');
INSERT INTO `pay_points` VALUES ('264', '5', '2', '12万金币', '0', '0', '1000', '10', '120000', '10', '0', '0', null, '2015-06-16 15:55:23');
INSERT INTO `pay_points` VALUES ('265', '5', '3', '39万金币', '0', '0', '3000', '30', '390000', '30', '0', '1', null, '2015-06-16 15:55:26');
INSERT INTO `pay_points` VALUES ('266', '5', '4', '140万金币', '0', '0', '10000', '100', '1400000', '100', '0', '1', null, '2015-06-16 15:55:30');
INSERT INTO `pay_points` VALUES ('267', '5', '5', '450万金币', '0', '0', '30000', '300', '4500000', '300', '0', '0', null, '2015-06-16 15:55:34');
INSERT INTO `pay_points` VALUES ('270', '5', '6', '850万金币', '0', '0', '50000', '500', '8500000', '500', '1', '0', null, '2015-06-16 15:55:39');
INSERT INTO `pay_points` VALUES ('271', '5', '7', '1800万金币', '0', '0', '100000', '1000', '18000000', '1000', '0', '0', null, '2015-06-16 15:55:46');
INSERT INTO `pay_points` VALUES ('272', '5', '8', '4000万金币', '0', '0', '200000', '2000', '40000000', '2000', '1', '0', null, '2015-06-16 15:55:52');
INSERT INTO `pay_points` VALUES ('273', '5', '9', '1亿金币', '0', '0', '500000', '5000', '100000000', '7000', '0', '0', null, '2015-06-16 15:56:03');
INSERT INTO `pay_points` VALUES ('277', '4', '6', '79万金币', '0', '0', '50000', '500', '7900000', '500', '0', '0', null, '2015-06-16 15:56:19');
INSERT INTO `pay_points` VALUES ('278', '6', '1', '3.5万金币', '0', '0', '300', '3', '35000', '3', '0', '0', null, '2015-06-16 15:56:22');
INSERT INTO `pay_points` VALUES ('279', '6', '2', '12万金币', '0', '0', '1000', '10', '120000', '10', '0', '0', null, '2015-06-16 15:56:25');
INSERT INTO `pay_points` VALUES ('280', '6', '3', '39万金币', '0', '0', '3000', '30', '390000', '30', '0', '0', null, '2015-06-16 15:56:27');
INSERT INTO `pay_points` VALUES ('281', '6', '4', '140万金币', '0', '0', '10000', '100', '1400000', '100', '0', '0', null, '2015-06-16 15:56:31');
INSERT INTO `pay_points` VALUES ('282', '6', '5', '450万金币', '0', '0', '30000', '300', '4500000', '300', '0', '0', null, '2015-06-16 15:56:33');
INSERT INTO `pay_points` VALUES ('283', '6', '6', '850万金币', '0', '0', '50000', '500', '8500000', '500', '0', '0', null, '2015-06-16 15:56:35');
INSERT INTO `pay_points` VALUES ('284', '6', '7', '1800万金币', '0', '0', '100000', '1000', '18000000', '1000', '0', '0', null, '2015-06-16 15:56:38');
INSERT INTO `pay_points` VALUES ('285', '6', '8', '4000万金币', '0', '0', '200000', '2000', '40000000', '2000', '0', '0', null, '2015-06-16 15:56:41');
INSERT INTO `pay_points` VALUES ('286', '6', '9', '1亿金币', '0', '0', '500000', '5000', '100000000', '5000', '0', '0', null, '2015-06-16 15:56:58');
INSERT INTO `pay_points` VALUES ('287', '7', '1', '2万金币', '0', '0', '200', '2', '20000', '2', '0', '0', null, '2015-06-16 15:57:07');
INSERT INTO `pay_points` VALUES ('288', '7', '2', '5万金币', '0', '0', '500', '5', '50000', '5', '0', '0', null, '2015-06-16 15:57:09');
INSERT INTO `pay_points` VALUES ('289', '7', '3', '10万金币', '0', '0', '1000', '10', '100000', '10', '0', '0', null, '2015-06-16 15:57:11');
INSERT INTO `pay_points` VALUES ('290', '7', '4', '20万金币', '0', '0', '2000', '20', '200000', '20', '0', '0', null, '2015-06-16 15:57:13');
INSERT INTO `pay_points` VALUES ('291', '7', '5', '30万金币', '0', '0', '3000', '30', '300000', '30', '0', '0', null, '2015-06-16 15:57:15');
INSERT INTO `pay_points` VALUES ('292', '16', '1', '2万金币', '0', '0', '200', '2', '20000', '2', '0', '0', null, '2015-06-16 15:57:17');
INSERT INTO `pay_points` VALUES ('293', '16', '2', '6万金币', '0', '0', '600', '6', '60000', '6', '0', '0', null, '2015-06-16 15:57:19');
INSERT INTO `pay_points` VALUES ('294', '16', '3', '10万金币', '0', '0', '1000', '10', '100000', '10', '0', '0', null, '2015-06-16 15:57:21');
INSERT INTO `pay_points` VALUES ('295', '16', '4', '20万金币', '0', '0', '2000', '20', '200000', '20', '0', '0', null, '2015-06-16 15:57:23');
INSERT INTO `pay_points` VALUES ('296', '17', '1', '2.1万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-06-16 15:57:34');
INSERT INTO `pay_points` VALUES ('297', '17', '2', '5.3万金币', '0', '0', '500', '5', '53000', '5', '0', '1', null, '2015-06-16 15:57:36');
INSERT INTO `pay_points` VALUES ('298', '17', '3', '10.7万金币', '0', '0', '1000', '10', '107000', '10', '0', '1', null, '2015-06-16 15:57:39');
INSERT INTO `pay_points` VALUES ('299', '17', '4', '21.5万金币', '0', '0', '2000', '20', '215000', '20', '1', '0', null, '2015-06-16 15:57:42');
INSERT INTO `pay_points` VALUES ('300', '17', '5', '32.4万金币', '0', '0', '3000', '30', '324000', '30', '1', '0', null, '2015-06-16 15:57:44');
INSERT INTO `pay_points` VALUES ('303', '18', '1', '2.1万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-06-16 15:57:47');
INSERT INTO `pay_points` VALUES ('304', '18', '2', '5.3万金币', '0', '0', '500', '5', '53000', '5', '0', '0', null, '2015-06-16 15:57:50');
INSERT INTO `pay_points` VALUES ('305', '18', '3', '10.7万金币', '0', '0', '1000', '10', '107000', '10', '0', '0', null, '2015-06-16 15:57:53');
INSERT INTO `pay_points` VALUES ('306', '18', '4', '21.5万金币', '0', '0', '2000', '20', '215000', '20', '0', '0', null, '2015-06-16 15:57:56');
INSERT INTO `pay_points` VALUES ('307', '18', '5', '32.4万金币', '0', '0', '3000', '30', '324000', '30', '0', '0', null, '2015-06-16 15:58:00');
INSERT INTO `pay_points` VALUES ('310', '4', '0', '10.8万金币', '0', '0', '1000', '10', '108000', '10', '0', '0', null, '2015-06-16 15:58:07');
INSERT INTO `pay_points` VALUES ('311', '18', '6', '54.5万金币', '0', '0', '5000', '50', '545000', '50', '0', '0', null, '2015-06-16 15:58:16');
INSERT INTO `pay_points` VALUES ('312', '18', '7', '110万金币', '0', '0', '10000', '100', '1100000', '100', '0', '0', null, '2015-06-16 15:58:20');
INSERT INTO `pay_points` VALUES ('313', '19', '1', '3.1万金币', '0', '0', '300', '3', '31000', '3', '0', '0', null, '2015-06-16 15:58:23');
INSERT INTO `pay_points` VALUES ('314', '19', '2', '10.8万金币', '0', '0', '1000', '10', '108000', '10', '0', '0', null, '2015-06-16 15:58:27');
INSERT INTO `pay_points` VALUES ('315', '19', '3', '32.7万金币', '0', '0', '3000', '30', '327000', '30', '0', '0', null, '2015-06-16 15:58:30');
INSERT INTO `pay_points` VALUES ('316', '19', '4', '110万金币', '0', '0', '10000', '100', '1100000', '100', '0', '0', null, '2015-06-16 15:58:32');
INSERT INTO `pay_points` VALUES ('317', '19', '5', '350万金币', '0', '0', '30000', '300', '3500000', '300', '0', '0', null, '2015-06-16 15:58:36');
INSERT INTO `pay_points` VALUES ('318', '19', '6', '790万金币', '0', '0', '50000', '500', '7900000', '500', '0', '0', null, '2015-06-16 15:58:40');
INSERT INTO `pay_points` VALUES ('322', '20', '1', '2.1万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-06-16 15:58:56');
INSERT INTO `pay_points` VALUES ('323', '20', '2', '5.3万金币', '0', '0', '500', '5', '53000', '5', '0', '0', null, '2015-06-16 15:59:06');
INSERT INTO `pay_points` VALUES ('324', '20', '3', '10.7万金币', '0', '0', '1000', '10', '107000', '10', '0', '0', null, '2015-06-16 15:59:10');
INSERT INTO `pay_points` VALUES ('325', '20', '4', '21.5万金币', '0', '0', '2000', '20', '215000', '20', '0', '0', null, '2015-06-16 15:59:12');
INSERT INTO `pay_points` VALUES ('326', '20', '5', '32.4万金币', '0', '0', '3000', '30', '324000', '30', '0', '0', null, '2015-06-16 15:59:16');
INSERT INTO `pay_points` VALUES ('327', '20', '6', '54.5万金币', '0', '0', '5000', '50', '545000', '50', '0', '0', null, '2015-06-16 15:59:22');
INSERT INTO `pay_points` VALUES ('328', '20', '7', '110万金币', '0', '0', '10000', '100', '1100000', '100', '0', '0', null, '2015-06-16 15:59:24');
INSERT INTO `pay_points` VALUES ('329', '19', '7', '1600万金币', '0', '0', '100000', '1000', '16000000', '1000', '0', '0', null, '2015-06-16 15:59:29');
INSERT INTO `pay_points` VALUES ('330', '19', '8', '3300万金币', '0', '0', '200000', '2000', '33000000', '2000', '0', '0', null, '2015-06-16 15:59:35');
INSERT INTO `pay_points` VALUES ('331', '19', '9', '8500万金币', '0', '0', '500000', '5000', '85000000', '5000', '0', '0', null, '2015-06-16 15:59:49');
INSERT INTO `pay_points` VALUES ('332', '21', '1', '2.1万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-06-16 15:59:53');
INSERT INTO `pay_points` VALUES ('333', '21', '2', '4.2万金币', '0', '0', '400', '4', '42000', '4', '0', '0', null, '2015-06-16 15:59:56');
INSERT INTO `pay_points` VALUES ('334', '21', '3', '6.4万金币', '0', '0', '600', '6', '64000', '6', '0', '0', null, '2015-06-16 15:59:59');
INSERT INTO `pay_points` VALUES ('335', '21', '4', '8.6万金币', '0', '0', '800', '8', '86000', '8', '0', '0', null, '2015-06-16 16:00:01');
INSERT INTO `pay_points` VALUES ('336', '22', '1', '2万金币', '0', '0', '200', '2', '20000', '0', '0', '0', null, '2015-07-09 14:51:23');
INSERT INTO `pay_points` VALUES ('337', '22', '2', '5万金币', '0', '0', '500', '5', '50000', '0', '0', '0', null, '2015-07-09 14:51:21');
INSERT INTO `pay_points` VALUES ('338', '22', '3', '10万金币', '0', '0', '1000', '10', '100000', '0', '0', '0', null, '2015-07-09 14:51:21');
INSERT INTO `pay_points` VALUES ('339', '22', '4', '20万金币', '0', '0', '2000', '20', '200000', '0', '0', '0', null, '2015-07-09 14:51:20');
INSERT INTO `pay_points` VALUES ('340', '22', '5', '30万金币', '0', '0', '3000', '30', '300000', '0', '0', '0', null, '2015-07-09 14:51:18');
INSERT INTO `pay_points` VALUES ('349', '4', '2', '	普通月卡', '1', '1', '3000', '30', '300000', '0', '0', '0', '购买立获30万金币,之后30天,每天领5千金币,每月限购一次', '2015-06-16 16:07:09');
INSERT INTO `pay_points` VALUES ('350', '4', '4', '黄金月卡', '1', '2', '10000', '100', '1000000', '0', '0', '0', '购买立获100万金币,之后30天,每天领2万金币,每月限购一次', '2015-06-16 16:07:12');
INSERT INTO `pay_points` VALUES ('351', '4', '5', '钻石月卡', '1', '3', '30000', '300', '3000000', '0', '0', '0', '购买立获300万金币,之后30天,每天领8W金币,每月限购一次', '2015-06-16 16:07:13');
INSERT INTO `pay_points` VALUES ('352', '5', '3', '普通月卡', '1', '1', '3000', '30', '300000', '0', '0', '1', '购买立获30万金币,之后30天,每天领5千金币,每月限购一次', '2015-06-16 16:07:15');
INSERT INTO `pay_points` VALUES ('353', '5', '4', '黄金月卡', '1', '2', '10000', '100', '1000000', '0', '0', '1', '购买立获100万金币,之后30天,每天领2万金币,每月限购一次', '2015-06-16 16:07:18');
INSERT INTO `pay_points` VALUES ('354', '5', '5', '钻石月卡', '1', '3', '30000', '300', '3000000', '0', '0', '0', '购买立获300万金币,之后30天,每天领8W金币,每月限购一次', '2015-06-16 16:07:20');
INSERT INTO `pay_points` VALUES ('355', '6', '3', '普通月卡', '1', '1', '3000', '30', '300000', '0', '0', '0', '购买立获30万金币,之后30天,每天领5千金币,每月限购一次', '2015-06-16 16:07:21');
INSERT INTO `pay_points` VALUES ('356', '6', '4', '黄金月卡', '1', '2', '10000', '100', '1000000', '0', '0', '0', '购买立获100万金币,之后30天,每天领2万金币,每月限购一次', '2015-06-16 16:07:23');
INSERT INTO `pay_points` VALUES ('357', '6', '5', '钻石月卡', '1', '3', '30000', '300', '3000000', '0', '0', '0', '购买立获300万金币,之后30天,每天领8W金币,每月限购一次', '2015-06-16 16:07:25');
INSERT INTO `pay_points` VALUES ('358', '7', '5', '普通月卡', '1', '1', '3000', '30', '300000', '0', '0', '0', '购买立获30万金币,之后30天,每天领5千金币,每月限购一次', '2015-06-16 16:07:27');
INSERT INTO `pay_points` VALUES ('362', '19', '3', '普通月卡', '1', '1', '3000', '30', '300000', '0', '0', '0', '购买立获30万金币,之后30天,每天领5千金币,每月限购一次', '2015-06-16 16:07:34');
INSERT INTO `pay_points` VALUES ('363', '19', '4', '黄金月卡', '1', '2', '10000', '100', '1000000', '0', '0', '0', '购买立获100万金币,之后30天,每天领2万金币,每月限购一次', '2015-06-16 16:07:36');
INSERT INTO `pay_points` VALUES ('364', '19', '5', '钻石月卡', '1', '3', '30000', '300', '3000000', '0', '0', '0', '购买立获300万金币,之后30天,每天领8W金币,每月限购一次', '2015-06-16 16:07:39');
INSERT INTO `pay_points` VALUES ('365', '25', '1', '2.1万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-07-31 10:12:58');
INSERT INTO `pay_points` VALUES ('366', '25', '2', '5.3万金币', '0', '0', '500', '5', '53000', '5', '0', '1', null, '2015-07-31 10:12:59');
INSERT INTO `pay_points` VALUES ('367', '25', '3', '10.7万金币', '0', '0', '1000', '10', '107000', '10', '0', '1', null, '2015-07-31 10:13:00');
INSERT INTO `pay_points` VALUES ('368', '25', '4', '21.5万金币', '0', '0', '2000', '20', '215000', '20', '1', '0', null, '2015-07-31 10:13:01');
INSERT INTO `pay_points` VALUES ('369', '25', '5', '32.4万金币', '0', '0', '3000', '30', '324000', '30', '1', '0', null, '2015-07-31 10:13:02');
INSERT INTO `pay_points` VALUES ('370', '27', '1', '2万金币', '0', '0', '200', '2', '21000', '2', '0', '0', null, '2015-10-21 10:15:57');
INSERT INTO `pay_points` VALUES ('371', '27', '2', '5万金币', '0', '0', '500', '5', '53000', '5', '0', '0', null, '2015-10-21 10:16:28');
INSERT INTO `pay_points` VALUES ('372', '27', '3', '10万金币', '0', '0', '1000', '10', '107000', '10', '0', '0', null, '2015-10-21 10:16:43');
INSERT INTO `pay_points` VALUES ('373', '27', '4', '20万金币', '0', '0', '2000', '20', '215000', '20', '0', '0', null, '2015-10-21 10:17:17');

-- ----------------------------
-- Table structure for pay_sdk
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
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay_sdk
-- ----------------------------
INSERT INTO `pay_sdk` VALUES ('1', '1', '01', 'mm', 'appid', 'appname', 'wbl', 'cpkey', 'cpid', '1', '2', '', '2014-10-16 14:15:10');
INSERT INTO `pay_sdk` VALUES ('2', '1', '02', '联通wo', '9020702937020140808090104944100', '土豪斗翻天', '广州无比乐网络技术有限公司', '5578afd1874603540f67', '86011296', '1', '2', '', '2014-10-16 14:15:34');
INSERT INTO `pay_sdk` VALUES ('3', '9', '03', 'ct', 'F33306A94EDC22D9E0430100007F918E', '土豪牛牛', '深圳市畅捷数码科技有限公司', '', '', '1', '2', '深圳市畅捷数码科技有限公司', '2014-10-21 10:41:40');
INSERT INTO `pay_sdk` VALUES ('4', '2', '04', '神州付充值卡', '', '', '', '', '', '1', '3', '', '2014-10-16 14:16:25');
INSERT INTO `pay_sdk` VALUES ('5', '3', '05', '支付宝', '', '', '', '', '', '1', '3', '', '2014-10-16 14:16:41');
INSERT INTO `pay_sdk` VALUES ('6', '4', '06', '银联', '', '', '', '', '', '1', '3', '', '2014-10-16 14:16:54');
INSERT INTO `pay_sdk` VALUES ('7', '5', '10', '可可支付', '', '', '', '', '', '1', '0', '可可支付', '2014-08-25 14:59:55');
INSERT INTO `pay_sdk` VALUES ('16', '6', '12', '悠悠村', null, null, null, null, null, '1', '0', null, '2014-09-05 15:49:30');
INSERT INTO `pay_sdk` VALUES ('17', '7', '08', 'mm弱联网', '', '', '', '', '', '1', '2', '', '2014-10-16 14:23:28');
INSERT INTO `pay_sdk` VALUES ('18', '8', '09', '和游戏', null, null, null, null, null, '1', '0', null, '2014-09-30 16:54:20');
INSERT INTO `pay_sdk` VALUES ('19', '10', '07', '腾讯支付', '', '土豪牛牛', '广州无比乐网络技术有限公司', '', '', '1', '0', '腾讯', '2015-03-12 15:50:15');
INSERT INTO `pay_sdk` VALUES ('20', '18', '18', 'MM支付special', '', '土豪牛牛', '广州无比乐网络技术有限公司', '', '', '1', '0', '', '2014-11-28 17:48:07');
INSERT INTO `pay_sdk` VALUES ('21', '11', '11', '冒泡支付', null, null, null, null, null, '1', '0', '冒泡斯凯社区', '2015-05-07 14:26:41');
INSERT INTO `pay_sdk` VALUES ('22', '19', '19', 'MM审核专供', null, null, null, null, null, '1', '0', null, '2015-05-07 18:32:00');
INSERT INTO `pay_sdk` VALUES ('25', '14', '14', '钱学', null, null, null, null, null, '1', '0', '钱学', '2015-08-18 17:13:32');
INSERT INTO `pay_sdk` VALUES ('26', '15', '15', 'MM破解', null, null, null, null, null, '1', '0', 'MM破解', '2015-08-18 17:13:38');
INSERT INTO `pay_sdk` VALUES ('27', '16', '16', '益玩SDK', '', '土豪牛牛', '', '', '', '1', '0', '益玩SDK', '2015-10-21 10:15:26');

-- ----------------------------
-- Table structure for pay_sdk_channel
-- ----------------------------
DROP TABLE IF EXISTS `pay_sdk_channel`;
CREATE TABLE `pay_sdk_channel` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `pkg` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `pt_list` varchar(100) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pkg` (`pkg`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay_sdk_channel
-- ----------------------------
INSERT INTO `pay_sdk_channel` VALUES ('1', 'com.chjie.dcow.nearme.gamecenter', '可可', '5', null);
INSERT INTO `pay_sdk_channel` VALUES ('3', 'com.chjie.dcow.uuc', '悠悠村', '6', '2014-09-05 15:55:51');
INSERT INTO `pay_sdk_channel` VALUES ('4', 'com.chjie.dcow.mmweak', 'mm弱联网', '7,2,3,4', '2014-09-10 09:38:18');
INSERT INTO `pay_sdk_channel` VALUES ('5', 'def', '默认', '7,2,3,4', '2014-09-19 10:36:57');
INSERT INTO `pay_sdk_channel` VALUES ('6', 'com.chjie.dcow.cmgame', '和游戏', '8', '2014-09-30 17:06:37');
INSERT INTO `pay_sdk_channel` VALUES ('7', 'com.chjie.dcow.ct', '电信', '9', '2014-10-21 10:25:46');
INSERT INTO `pay_sdk_channel` VALUES ('8', 'com.tencent.tmgp.chjie.dcow', '腾讯', '10', '2014-12-04 17:58:11');
INSERT INTO `pay_sdk_channel` VALUES ('9', 'com.chjie.dcow.mopo', '斯凯冒泡社区', '11,7,2,3,4', '2015-05-05 15:35:18');
INSERT INTO `pay_sdk_channel` VALUES ('10', '000000000000', 'MM审核专供', '19', '2015-05-07 14:28:43');
INSERT INTO `pay_sdk_channel` VALUES ('14', 'com.chjie.dcow.qx', '钱学', '14,7', '2015-07-31 10:18:52');
INSERT INTO `pay_sdk_channel` VALUES ('15', 'com.chjie.dcow.ewan', '益玩SDK', '16', '2015-10-21 10:21:53');
INSERT INTO `pay_sdk_channel` VALUES ('16', 'com.gaozhou.dcow.nearme.gamecenter', '可可', '5', '2015-11-30 15:32:51');

-- ----------------------------
-- Table structure for pay_special_config
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
  KEY `package` (`package`,`channel`),
  KEY `tm_start` (`tm_start`),
  KEY `tm_end` (`tm_end`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay_special_config
-- ----------------------------
INSERT INTO `pay_special_config` VALUES ('1', '1', 'com.chjie.dcow', '0000000000', '2014-12-01 10:00:00', '2014-12-01 18:00:00', '1', '', '0', '2014-12-16 11:31:45');
INSERT INTO `pay_special_config` VALUES ('3', '1', 'com.chjie.dcow', '3003918454', '2014-12-05 09:57:56', '2014-12-05 12:01:41', '2', '', '0', '2014-12-16 11:31:38');
INSERT INTO `pay_special_config` VALUES ('4', '1', 'com.chjie.dcow', '3003918458', '2014-12-02 17:59:23', '2014-12-12 17:59:25', '0', '', '0', '2014-12-16 11:31:33');
INSERT INTO `pay_special_config` VALUES ('5', '1', 'com.chjie.dcow', '100custest000005', '2014-12-16 10:25:13', '2014-12-16 12:25:16', '1', '', '0', '2014-12-16 11:31:27');
INSERT INTO `pay_special_config` VALUES ('6', '1', 'com.chjie.dcow', '3003918544', '2014-12-16 10:51:27', '2014-12-16 11:51:29', '1', '', '0', '2014-12-16 10:58:36');
INSERT INTO `pay_special_config` VALUES ('7', '1', 'com.chjie.dcow', '3003918444', '2014-12-18 19:00:00', '2014-12-19 07:00:00', '2', 'wifi万能钥匙', '1', '2014-12-18 18:13:56');
INSERT INTO `pay_special_config` VALUES ('10', '1', 'com.chjie.dcow', '3003918547', '2014-12-17 19:00:00', '2014-12-18 07:00:00', '2', '金花更多游戏', '0', '2014-12-18 18:09:21');
INSERT INTO `pay_special_config` VALUES ('11', '1', 'com.chjie.dcow', '3003967923', '2014-12-18 19:00:00', '2014-12-19 07:00:00', '2', '随e行', '1', '2014-12-18 18:12:56');
INSERT INTO `pay_special_config` VALUES ('12', '1', 'com.chjie.dcow', '3003967926', '2014-12-18 19:00:00', '2014-12-19 07:00:00', '2', '万普', '1', '2014-12-18 18:11:49');

-- ----------------------------
-- Table structure for pay_special_value
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
-- Records of pay_special_value
-- ----------------------------
INSERT INTO `pay_special_value` VALUES ('1', '3003918414', '', '447EE58F105821FDD29D49EE7D51921E', '', '', '', '', 'app-v1', '2014-12-16 10:40:20');
INSERT INTO `pay_special_value` VALUES ('2', '3003918429', '', 'FE07B143E228252F12646EF68ECAC267', '', '', '', '', 'app-v1', '2014-12-16 10:40:27');
INSERT INTO `pay_special_value` VALUES ('3', '3003918444', '', '23B04DE7B9A0937D9AB59EA6CC059CEA', '', '', '', '', 'app-v1', '2014-12-16 10:39:05');
INSERT INTO `pay_special_value` VALUES ('4', '3003918454', '', 'E3A784543F83155C6EEF584FE0A70B69', '', '', '', '', 'app-v1', '2014-12-16 10:38:54');
INSERT INTO `pay_special_value` VALUES ('5', '3003918532', '', 'B163DD3282D23A1452836124C437A061', '', '', '', '', 'app-v1', '2014-12-16 10:38:41');
INSERT INTO `pay_special_value` VALUES ('6', '3003918547', '', '7C9D28A4BF932B276750EDACE9E48621', '', '', '', '', 'app-v1', '2014-12-16 10:38:30');
INSERT INTO `pay_special_value` VALUES ('7', '3003967914', '', '266DE503A1D74B4DFC4D68B1F44A5E52', '', '', '', '', 'app-v1', '2014-12-16 10:38:16');
INSERT INTO `pay_special_value` VALUES ('8', '3003967923', '', '3FBAF2D3E6854EC3D85F5DB5613F5C8C', '', '', '', '', 'app-v1', '2014-12-16 10:37:55');
INSERT INTO `pay_special_value` VALUES ('9', '3003967926', '', 'BC5F4982C8AC767CACFE916E1539C8A6', '', '', '', '', 'app-v1', '2014-12-16 10:37:31');
INSERT INTO `pay_special_value` VALUES ('10', '3003967927', '', '49ED476FEAFA9F8622FCCDF47F7CE8F3', '', '', '', '', 'app-v1', '2014-12-16 10:37:16');

-- ----------------------------
-- Table structure for pbindachtasks
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
-- Records of pbindachtasks
-- ----------------------------

-- ----------------------------
-- Table structure for platforminfo
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
-- Records of platforminfo
-- ----------------------------
INSERT INTO `platforminfo` VALUES ('1', '炸金花', 'com.lizi.zjh', 'http://121.40.68.234:99/Public/platform/pf_zft.png', 'http://115.29.11.227/zjh/more/tuhaoniuniu/download.php', 'ABD4DA88DF1E92FA07FE41137B82F09A', '1', '0', '0', '0', '3', '2015-03-17 17:43:45');
INSERT INTO `platforminfo` VALUES ('2', '牛牛', 'com.chjie.dcow', 'http://121.40.68.234:99/Public/platform/pf_dn.png', 'http://apk.mmarket.com/rs/prepublish_open12/23/2015/04/03/a447/734/42734447/tuhaobull_v1.7_20150203_300008375860_3003992715.apk', '48B54507BBFBF7E6CD9B37F4A131C5A7', '1', '1', '0', '1', '1', '2015-03-17 17:45:45');
INSERT INTO `platforminfo` VALUES ('3', '一锅端', 'com.chjie.chhg', 'http://121.40.68.234:99/Public/platform/pf_ygd.png', 'http://apk.mmarket.com/rs/prepublish_open12/23/2015/04/09/a748/808/42808748/tuhaoygd_v1.4_20141215_300008384455_3003992715.apk', '816FCF485A1879557EC7B3B7039D9816', '-1', '0', '1', '0', '2', '2015-03-17 17:47:25');
INSERT INTO `platforminfo` VALUES ('4', '土豪德州', 'com.lizi.texas.wubile', 'http://121.40.68.234:99/Public/platform/pf_dz.png', 'http://apk.mmarket.com/rs/prepublish_open10/23/2015/02/04/a136/787/41787136/texas_v1.3.0_20150105c_300008385728_3003918436.apk', 'D47F808046A3C4471B9334E52BBAD6D6', '-1', '0', '0', '0', '4', '2015-03-17 17:48:37');
INSERT INTO `platforminfo` VALUES ('6', '消灭星星', 'com.wbl.xmxx2015', 'http://121.40.68.234:99/Public/platform/pf_xmxx.png', 'http://203.86.3.244:9090/xmxx/xmxx2015_v1.5.1_0068.apk', 'AC0818D10EE5D25EEDB6567DC23D0F47', '-1', '0', '0', '0', '5', '2015-03-18 09:34:08');
INSERT INTO `platforminfo` VALUES ('7', '斗地主', 'com.landlord.ddz', 'http://121.40.68.234:99/Public/platform/pf_ddz.png', 'http://203.86.3.244:9090/ddz/20/landlord_4-0_-200freemarket000095.apk', '6648A0A9EA97475CCC62A043BAA4916B', '1', '0', '0', '0', '6', '2015-03-17 17:43:45');
INSERT INTO `platforminfo` VALUES ('8', '泡泡龙', 'com.wubile.ppl2015', 'http://121.40.68.234:99/Public/platform/ppl_2015.png', 'http://apk.mmarket.com/rs/prepublish_open12/23/2015/03/31/a354/632/42632354/ppl_chjie_pplduocai_2.00_20150303_300008898106_3003986320.apk', 'AC8D369C5E68CB9C54FBF9098DA329D7', '1', '0', '0', '0', '7', '2015-04-09 11:26:16');
INSERT INTO `platforminfo` VALUES ('14', '宠物大消除', 'com.PopCleanUpDztKd.org', 'http://121.40.68.234:99/Public/platform/pf_cwdxc.png', 'http://apk.mmarket.com/rs/prepublish_open13/23/2015/04/24/a924/139/43139924/kd_pop_cleanup_dzt_0408_v1.3.3_300008973639_3003995846.apk', 'A9872F1BF6B45B758EC11759884FFEE4', '1', '1', '1', '0', '8', '2015-05-08 10:57:41');
INSERT INTO `platforminfo` VALUES ('15', '绝命狙击', 'com.wubile.shoot', 'http://121.40.68.234:99/Public/platform/pf_jmjj.png', 'http://apk.mmarket.com/rs/prepublish_open13/23/2015/05/04/a773/334/43334773/jmjj_wbl_v1.1_20150105_300008734181_3003996339.apk', '8EFC50A2B909AA0AB96DAA544A1A9954', '1', '0', '0', '0', '9', '2015-05-08 10:57:44');

-- ----------------------------
-- Table structure for platformswitch
-- ----------------------------
DROP TABLE IF EXISTS `platformswitch`;
CREATE TABLE `platformswitch` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `channel` varchar(100) DEFAULT NULL,
  `flag` int(4) DEFAULT '1' COMMENT '关开:0,关闭；1，打开',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of platformswitch
-- ----------------------------
INSERT INTO `platformswitch` VALUES ('1', '000000000000', '1', '2015-04-14 11:45:47');
INSERT INTO `platformswitch` VALUES ('5', '2200163860', '1', '2015-05-04 16:23:41');
INSERT INTO `platformswitch` VALUES ('6', '2200123317', '1', '2015-05-11 09:51:11');
INSERT INTO `platformswitch` VALUES ('7', '3003918547', '1', null);
INSERT INTO `platformswitch` VALUES ('8', '3003996337', '1', null);
INSERT INTO `platformswitch` VALUES ('9', '3003992715', '1', null);
INSERT INTO `platformswitch` VALUES ('10', '2200110945', '1', null);
INSERT INTO `platformswitch` VALUES ('11', '3004001284', '1', null);
INSERT INTO `platformswitch` VALUES ('12', 'JBSM000001', '1', '2015-10-12 11:20:32');
INSERT INTO `platformswitch` VALUES ('13', 'MIGU000001', '1', '2015-10-19 10:08:16');

-- ----------------------------
-- Table structure for player
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user` varchar(64) NOT NULL COMMENT '账户名',
  `name` varchar(64) NOT NULL COMMENT '昵称',
  `password` varchar(64) DEFAULT '' COMMENT '密码',
  `salt` varchar(64) NOT NULL COMMENT '密码salt',
  `sex` int(11) NOT NULL COMMENT '性别 0：女 1：男',
  `avater` varchar(255) NOT NULL DEFAULT '0' COMMENT '头像URL',
  `skey` varchar(64) DEFAULT NULL COMMENT '会话session key',
  `city` varchar(10) DEFAULT '' COMMENT '城市区号',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态 0=无效；1=有效',
  `login_times` int(11) DEFAULT '1' COMMENT '登录次数',
  `login_days` int(11) NOT NULL DEFAULT '1' COMMENT '连续登录天数',
  `isauto` tinyint(4) DEFAULT '1' COMMENT '是否自动注册用户:0=手动；1=自动',
  `sign` varchar(100) DEFAULT NULL COMMENT '个性签名',
  `mobile` varchar(50) DEFAULT NULL COMMENT '用户手机号',
  `money` int(11) NOT NULL DEFAULT '0' COMMENT '金币',
  `coin` int(11) NOT NULL DEFAULT '0' COMMENT '金叶子数量',
  `rmb` int(11) DEFAULT '0' COMMENT '充值总金额',
  `online_time` int(11) DEFAULT '1' COMMENT '在线时长(秒)',
  `is_get` int(11) NOT NULL DEFAULT '0' COMMENT '是否领取连续登陆的奖励',
  `total_board` int(11) NOT NULL DEFAULT '0' COMMENT '玩牌总次数',
  `total_win` int(11) NOT NULL DEFAULT '0' COMMENT '胜利总次数',
  `level` int(11) DEFAULT '1' COMMENT '等级',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `heartbeat_at` int(11) NOT NULL COMMENT '最后活动时间',
  `broke_num` int(11) NOT NULL DEFAULT '0' COMMENT '破产次数',
  `broke_time` int(11) NOT NULL DEFAULT '0' COMMENT '破产时间',
  `vipLevel` int(11) DEFAULT '0' COMMENT 'v标志等级 , >0才是vip',
  `inc_recharge` int(11) DEFAULT '0' COMMENT '累计充值金额',
  `monthcardId` int(11) DEFAULT '0' COMMENT '月卡',
  `monthcardEndtime` bigint(11) DEFAULT '0' COMMENT '卡月结束时间',
  `charm` int(11) DEFAULT '0' COMMENT '魅力值',
  `telCharge` int(11) DEFAULT '0' COMMENT '话费卷',
  `headtime` int(11) DEFAULT '0' COMMENT '头像更新时间',
  `title` varchar(50) DEFAULT NULL,
  `extid` varchar(100) DEFAULT '0' COMMENT '扩展ID，用于联运接入',
  `safeboxflag` int(4) DEFAULT '0' COMMENT '是否购买了保险箱',
  `safeboxmoney` bigint(8) DEFAULT '0' COMMENT '保险箱现存金币',
  `update_time` int(11) DEFAULT NULL COMMENT '登录时间',
  `create_time` int(11) NOT NULL COMMENT '注册时间',
  PRIMARY KEY (`id`),
  KEY `mobile` (`mobile`) USING BTREE,
  KEY `user` (`user`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `money` (`money`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1618224 DEFAULT CHARSET=utf8 COMMENT='游戏玩家表';

-- ----------------------------
-- Records of player
-- ----------------------------
-- ----------------------------
-- Table structure for playerext
-- ----------------------------
DROP TABLE IF EXISTS `playerext`;
CREATE TABLE `playerext` (
  `uid` bigint(8) NOT NULL,
  `giftinfo` varchar(200) DEFAULT NULL,
  `tasksAch` varchar(1200) DEFAULT NULL,
  `guideAward` varchar(10) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of playerext
-- ----------------------------

-- ----------------------------
-- Table structure for playermark
-- ----------------------------
DROP TABLE IF EXISTS `playermark`;
CREATE TABLE `playermark` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `uid` int(11) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL COMMENT '联运渠道',
  `package` varchar(50) DEFAULT NULL COMMENT 'app包名',
  `ver` varchar(10) DEFAULT NULL COMMENT '注册版本号',
  `ip` varchar(20) DEFAULT NULL COMMENT '注册IP',
  `imsi` varchar(50) DEFAULT NULL,
  `imei` varchar(50) DEFAULT NULL,
  `mtype` varchar(50) DEFAULT NULL,
  `create_time` int(11) DEFAULT NULL COMMENT '注册时间',
  `last_channel` varchar(50) DEFAULT NULL,
  `last_package` varchar(50) DEFAULT NULL,
  `last_ver` int(11) DEFAULT NULL,
  `last_ip` varchar(20) DEFAULT NULL,
  `last_imsi` varchar(50) DEFAULT NULL,
  `last_imei` varchar(50) DEFAULT NULL,
  `last_mtype` varchar(50) DEFAULT NULL,
  `last_time` int(11) DEFAULT NULL,
  `login_times` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `package` (`package`) USING BTREE,
  KEY `channel` (`channel`) USING BTREE,
  KEY `ver` (`ver`) USING BTREE,
  KEY `imsi` (`imsi`) USING BTREE,
  KEY `imei` (`imei`) USING BTREE,
  KEY `last_channel` (`last_channel`,`last_package`,`last_ver`),
  KEY `channel_2` (`channel`,`package`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1595721 DEFAULT CHARSET=utf8 COMMENT='游戏玩家表';

-- ----------------------------
-- Records of playermark
-- ----------------------------
-- ----------------------------
-- Table structure for player_copy
-- ----------------------------
DROP TABLE IF EXISTS `player_copy`;
CREATE TABLE `player_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user` varchar(64) NOT NULL COMMENT '账户名',
  `name` varchar(64) NOT NULL COMMENT '昵称',
  `password` varchar(64) DEFAULT '' COMMENT '密码',
  `salt` varchar(64) NOT NULL COMMENT '密码salt',
  `sex` int(11) NOT NULL COMMENT '性别 0：女 1：男',
  `avater` varchar(255) NOT NULL DEFAULT '0' COMMENT '头像URL',
  `skey` varchar(64) DEFAULT NULL COMMENT '会话session key',
  `city` varchar(10) DEFAULT '' COMMENT '城市区号',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态 0=无效；1=有效',
  `login_times` int(11) DEFAULT '1' COMMENT '登录次数',
  `login_days` int(11) NOT NULL DEFAULT '1' COMMENT '连续登录天数',
  `isauto` tinyint(4) DEFAULT '1' COMMENT '是否自动注册用户:0=手动；1=自动',
  `sign` varchar(100) DEFAULT NULL COMMENT '个性签名',
  `mobile` varchar(50) DEFAULT NULL COMMENT '用户手机号',
  `money` int(11) NOT NULL DEFAULT '0' COMMENT '金币',
  `coin` int(11) NOT NULL DEFAULT '0' COMMENT '金叶子数量',
  `rmb` int(11) DEFAULT '0' COMMENT '充值总金额',
  `online_time` int(11) DEFAULT '1' COMMENT '在线时长(秒)',
  `is_get` int(11) NOT NULL DEFAULT '0' COMMENT '是否领取连续登陆的奖励',
  `total_board` int(11) NOT NULL DEFAULT '0' COMMENT '玩牌总次数',
  `total_win` int(11) NOT NULL DEFAULT '0' COMMENT '胜利总次数',
  `level` int(11) DEFAULT '1' COMMENT '等级',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `heartbeat_at` int(11) NOT NULL COMMENT '最后活动时间',
  `broke_num` int(11) NOT NULL DEFAULT '0' COMMENT '破产次数',
  `broke_time` int(11) NOT NULL DEFAULT '0' COMMENT '破产时间',
  `vipLevel` int(11) DEFAULT '0' COMMENT 'v标志等级 , >0才是vip',
  `inc_recharge` int(11) DEFAULT '0' COMMENT '累计充值金额',
  `monthcardId` int(11) DEFAULT '0' COMMENT '月卡',
  `monthcardEndtime` bigint(11) DEFAULT '0' COMMENT '卡月结束时间',
  `charm` int(11) DEFAULT '0' COMMENT '魅力值',
  `telCharge` int(11) DEFAULT '0' COMMENT '话费卷',
  `headtime` int(11) DEFAULT '0' COMMENT '头像更新时间',
  `title` varchar(50) DEFAULT NULL,
  `extid` varchar(100) DEFAULT '0' COMMENT '扩展ID，用于联运接入',
  `safeboxflag` int(4) DEFAULT '0' COMMENT '是否购买了保险箱',
  `safeboxmoney` bigint(8) DEFAULT '0' COMMENT '保险箱现存金币',
  `update_time` int(11) DEFAULT NULL COMMENT '登录时间',
  `create_time` int(11) NOT NULL COMMENT '注册时间',
  PRIMARY KEY (`id`),
  KEY `mobile` (`mobile`) USING BTREE,
  KEY `user` (`user`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `money` (`money`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1618224 DEFAULT CHARSET=utf8 COMMENT='游戏玩家表';

-- ----------------------------
-- Records of player_copy
-- ----------------------------
-- ----------------------------
-- Table structure for player_has_moblie
-- ----------------------------
DROP TABLE IF EXISTS `player_has_moblie`;
CREATE TABLE `player_has_moblie` (
  `id` int(8) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `rmb` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of player_has_moblie
-- ----------------------------

-- ----------------------------
-- Table structure for prop_info
-- ----------------------------
DROP TABLE IF EXISTS `prop_info`;
CREATE TABLE `prop_info` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '品商名称',
  `desc` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '品商描述',
  `fatherId` int(4) DEFAULT '0' COMMENT '父ID',
  `num` int(4) DEFAULT NULL COMMENT '商品数量',
  `buymoney` bigint(11) DEFAULT '0' COMMENT '入买价格',
  `sellmoney` bigint(11) DEFAULT '0' COMMENT '卖出价格',
  `ishot` int(4) DEFAULT NULL COMMENT '是否畅销产品:0,不是;1,热销;2,超值',
  `create_time` timestamp NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of prop_info
-- ----------------------------

-- ----------------------------
-- Table structure for prop_info_copy
-- ----------------------------
DROP TABLE IF EXISTS `prop_info_copy`;
CREATE TABLE `prop_info_copy` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '品商名称',
  `desc` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '品商描述',
  `fatherId` int(4) DEFAULT '0' COMMENT '父ID',
  `num` int(4) DEFAULT NULL COMMENT '商品数量',
  `buymoney` bigint(11) DEFAULT '0' COMMENT '入买价格',
  `sellmoney` bigint(11) DEFAULT '0' COMMENT '卖出价格',
  `ishot` int(4) DEFAULT NULL COMMENT '是否畅销产品:0,不是;1,热销;2,超值',
  `create_time` timestamp NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of prop_info_copy
-- ----------------------------
INSERT INTO `prop_info_copy` VALUES ('21', '黄金戒指', '稀有戒指', '21', '1', '100000', '95000', '0', '2015-06-17 16:36:25');
INSERT INTO `prop_info_copy` VALUES ('22', '铂金戒指', '传说戒指', '22', '1', '300000', '285000', '0', '2015-06-17 16:36:26');
INSERT INTO `prop_info_copy` VALUES ('23', '钻石戒指', '史诗戒指', '23', '1', '1000000', '950000', '1', '2015-06-17 16:36:29');

-- ----------------------------
-- Table structure for prop_trade_log
-- ----------------------------
DROP TABLE IF EXISTS `prop_trade_log`;
CREATE TABLE `prop_trade_log` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `type` int(4) DEFAULT '0' COMMENT '交易类型:0,购买；1,出售；2,赠送',
  `propid` int(4) DEFAULT '1' COMMENT '具道ID',
  `ouid` bigint(11) DEFAULT '0' COMMENT '所有者UID',
  `tuid` bigint(11) DEFAULT '0' COMMENT '受赠者UID(0表示卖给系统)',
  `num` bigint(11) DEFAULT NULL COMMENT '交易数量',
  `money` bigint(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of prop_trade_log
-- ----------------------------

-- ----------------------------
-- Table structure for pushmsg
-- ----------------------------
DROP TABLE IF EXISTS `pushmsg`;
CREATE TABLE `pushmsg` (
  `id` int(4) NOT NULL,
  `msg` varchar(255) DEFAULT NULL,
  `create_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pushmsg
-- ----------------------------
INSERT INTO `pushmsg` VALUES ('1', '癞子玩法已上线', '1370057530');
INSERT INTO `pushmsg` VALUES ('2', '多玩多送', '1370057530');
INSERT INTO `pushmsg` VALUES ('3', 'nnhhhh', '1375184848');

-- ----------------------------
-- Table structure for rank
-- ----------------------------
DROP TABLE IF EXISTS `rank`;
CREATE TABLE `rank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank` int(11) DEFAULT NULL COMMENT '等级',
  `exp_min` int(11) DEFAULT NULL COMMENT '最小经验值',
  `exp_max` int(11) DEFAULT NULL COMMENT '最大经验值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rank` (`rank`) USING BTREE,
  KEY `exp_min` (`exp_min`) USING BTREE,
  KEY `exp_max` (`exp_max`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 COMMENT='等级表';

-- ----------------------------
-- Records of rank
-- ----------------------------
INSERT INTO `rank` VALUES ('1', '0', '0', '0');
INSERT INTO `rank` VALUES ('2', '1', '0', '9');
INSERT INTO `rank` VALUES ('3', '2', '10', '19');
INSERT INTO `rank` VALUES ('4', '3', '20', '29');
INSERT INTO `rank` VALUES ('5', '4', '30', '39');
INSERT INTO `rank` VALUES ('6', '5', '40', '59');
INSERT INTO `rank` VALUES ('7', '6', '60', '79');
INSERT INTO `rank` VALUES ('8', '7', '80', '99');
INSERT INTO `rank` VALUES ('9', '8', '100', '119');
INSERT INTO `rank` VALUES ('10', '9', '120', '139');
INSERT INTO `rank` VALUES ('11', '10', '140', '179');
INSERT INTO `rank` VALUES ('12', '11', '180', '219');
INSERT INTO `rank` VALUES ('13', '12', '220', '259');
INSERT INTO `rank` VALUES ('14', '13', '260', '299');
INSERT INTO `rank` VALUES ('15', '14', '300', '339');
INSERT INTO `rank` VALUES ('16', '15', '340', '399');
INSERT INTO `rank` VALUES ('17', '16', '400', '459');
INSERT INTO `rank` VALUES ('18', '17', '460', '519');
INSERT INTO `rank` VALUES ('19', '18', '520', '579');
INSERT INTO `rank` VALUES ('20', '19', '580', '659');
INSERT INTO `rank` VALUES ('21', '20', '660', '739');
INSERT INTO `rank` VALUES ('22', '21', '740', '819');
INSERT INTO `rank` VALUES ('23', '22', '820', '899');
INSERT INTO `rank` VALUES ('24', '23', '900', '979');
INSERT INTO `rank` VALUES ('25', '24', '980', '1059');
INSERT INTO `rank` VALUES ('26', '25', '1060', '1199');
INSERT INTO `rank` VALUES ('27', '26', '1200', '1399');
INSERT INTO `rank` VALUES ('28', '27', '1400', '1599');
INSERT INTO `rank` VALUES ('29', '28', '1600', '1799');
INSERT INTO `rank` VALUES ('30', '29', '1800', '2599');
INSERT INTO `rank` VALUES ('31', '30', '2600', '3499');
INSERT INTO `rank` VALUES ('32', '31', '3500', '4499');
INSERT INTO `rank` VALUES ('33', '32', '4500', '5999');
INSERT INTO `rank` VALUES ('34', '33', '6000', '7499');
INSERT INTO `rank` VALUES ('35', '34', '7500', '8999');
INSERT INTO `rank` VALUES ('36', '35', '9000', '11999');
INSERT INTO `rank` VALUES ('37', '36', '12000', '14999');
INSERT INTO `rank` VALUES ('38', '37', '15000', '17999');
INSERT INTO `rank` VALUES ('39', '38', '18000', '20999');
INSERT INTO `rank` VALUES ('40', '39', '21000', '23999');
INSERT INTO `rank` VALUES ('41', '40', '24000', '26999');
INSERT INTO `rank` VALUES ('42', '41', '27000', '29999');
INSERT INTO `rank` VALUES ('43', '42', '30000', '39999');
INSERT INTO `rank` VALUES ('44', '43', '40000', '49999');
INSERT INTO `rank` VALUES ('45', '44', '50000', '59999');
INSERT INTO `rank` VALUES ('46', '45', '60000', '69999');
INSERT INTO `rank` VALUES ('47', '46', '70000', '89999');
INSERT INTO `rank` VALUES ('48', '47', '90000', '119999');
INSERT INTO `rank` VALUES ('49', '48', '120000', '149999');
INSERT INTO `rank` VALUES ('50', '49', '150000', '199999');
INSERT INTO `rank` VALUES ('51', '50', '200000', '299999');
INSERT INTO `rank` VALUES ('52', '51', '300000', '399999');
INSERT INTO `rank` VALUES ('53', '52', '400000', '499999');
INSERT INTO `rank` VALUES ('54', '53', '500000', '699999');
INSERT INTO `rank` VALUES ('55', '54', '700000', '999999');
INSERT INTO `rank` VALUES ('56', '55', '1000000', '1399999');
INSERT INTO `rank` VALUES ('57', '56', '1400000', '1999999');
INSERT INTO `rank` VALUES ('58', '57', '2000000', '3999999');
INSERT INTO `rank` VALUES ('59', '58', '4000000', '7999999');
INSERT INTO `rank` VALUES ('60', '59', '8000000', '9999999');
INSERT INTO `rank` VALUES ('61', '60', '10000000', '2147483647');

-- ----------------------------
-- Table structure for researchconf
-- ----------------------------
DROP TABLE IF EXISTS `researchconf`;
CREATE TABLE `researchconf` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `tid` int(4) DEFAULT NULL COMMENT '调研批次ID',
  `title` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '研调题目',
  `status` int(4) DEFAULT '0' COMMENT '是否生效：0，不生效；1，生效',
  `ind` varchar(10) DEFAULT 't1' COMMENT '填必，再页面上显示的顺序，却必须t0/t1/t2..tn递增',
  `items` varchar(500) CHARACTER SET utf8 DEFAULT NULL COMMENT '研调选项，分号分隔',
  `inputType` int(4) DEFAULT NULL COMMENT '项选类型：0，单选；1，多项；2，手动输入',
  `createtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of researchconf
-- ----------------------------
INSERT INTO `researchconf` VALUES ('1', '1', '1、游戏的登陆界面您是否喜欢？', '1', 't1', 'A.喜欢;B.不喜欢', '0', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('2', '1', '2、您在日常登陆游戏时是否会查看公告了解游戏动态？', '1', 't2', 'A.会;B.不会', '0', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('3', '1', '3、游戏中每次举行活动您是否知道？', '1', 't3', 'A.知道;B.不知道;C.活动开始很久才发现', '0', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('4', '1', '4、您是怎么知道活动的呢？', '1', 't4', 'A.看公告;B.无意中发现;C.完全不了解', '0', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('5', '1', '5、大厅给您的感觉是怎样的？（多选）', '1', 't5', 'A.按钮太多;B.非常拥挤;C.布局不好;D.用起来不习惯', '1', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('6', '1', '6、对于游戏中的各个功能您觉得最重要的是什么？（多选）', '1', 't6', 'A.公告;B.签到;C.喇叭;D.信息;E.系统;F.兑换;G.抽奖;H.任务;I.排行;J.商城;L.分享', '1', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('7', '1', '7、您在进入游戏后选择房间时是否会左右拉动选择房间？', '1', 't7', 'A.会滑动查看后面的房间;B.3W分的不是最高场？;C.原来后面还有房间!', '0', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('8', '1', '8、您是否参加过我们举办的比赛场？', '1', 't8', 'A.参加过;B.没有', '0', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('9', '1', '9、如果您参加过您是怎样找到比赛场的呢？', '1', 't9', 'A.滑动场馆就找到了;B.找了半天才找到;C.完全不知道', '0', '2015-01-21 17:10:37');
INSERT INTO `researchconf` VALUES ('10', '1', '10、您觉得我们有什么方面需要改进？', '1', 't10', '', '2', '2015-01-21 17:10:37');

-- ----------------------------
-- Table structure for researchlog
-- ----------------------------
DROP TABLE IF EXISTS `researchlog`;
CREATE TABLE `researchlog` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `tid` int(4) DEFAULT NULL,
  `uid` bigint(8) DEFAULT NULL,
  `t1` varchar(20) DEFAULT NULL,
  `t2` varchar(20) DEFAULT NULL,
  `t3` varchar(20) DEFAULT NULL,
  `t4` varchar(20) DEFAULT NULL,
  `t5` varchar(20) DEFAULT NULL,
  `t6` varchar(20) DEFAULT NULL,
  `t7` varchar(20) DEFAULT NULL,
  `t8` varchar(20) DEFAULT NULL,
  `t9` varchar(20) DEFAULT NULL,
  `t10` varchar(500) DEFAULT NULL,
  `createtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of researchlog
-- ----------------------------
INSERT INTO `researchlog` VALUES ('78', '1', '354521', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-29 18:26:17');
INSERT INTO `researchlog` VALUES ('79', '1', '521', 'B.不喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', 'B.非常拥挤,C.布局不好', 'B.签到,C.喇叭', 'A.会滑动查看后面的房间', 'B.没有', 'B.找了半天才找到', '', '2015-01-29 18:27:02');
INSERT INTO `researchlog` VALUES ('80', '1', '266987', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'B.无意中发现', null, 'B.签到,H.任务', 'C.原来后面还有房间!', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-29 18:31:52');
INSERT INTO `researchlog` VALUES ('81', '1', '236345', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'C.完全不了解', null, null, 'C.原来后面还有房间!', 'B.没有', 'C.完全不知道', '', '2015-01-29 18:44:34');
INSERT INTO `researchlog` VALUES ('82', '1', '223871', 'A.喜欢', 'A.会', 'B.不知道', 'B.无意中发现', null, null, 'C.原来后面还有房间!', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-29 18:45:48');
INSERT INTO `researchlog` VALUES ('83', '1', '243865', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,C.喇叭,F.兑换,G.抽奖', 'B.3W分的不是最高场？', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-29 18:51:40');
INSERT INTO `researchlog` VALUES ('84', '1', '405441', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'B.无意中发现', null, null, 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-29 18:54:09');
INSERT INTO `researchlog` VALUES ('85', '1', '374644', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'A.看公告', null, 'A.公告,B.签到', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '没', '2015-01-29 19:08:39');
INSERT INTO `researchlog` VALUES ('86', '1', '362606', 'B.不喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-29 19:09:27');
INSERT INTO `researchlog` VALUES ('87', '1', '251633', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,B.签到,G.抽奖,L.分享', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '没', '2015-01-29 19:12:18');
INSERT INTO `researchlog` VALUES ('88', '1', '370010', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,B.签到,F.兑换,G.抽奖', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-29 19:34:03');
INSERT INTO `researchlog` VALUES ('89', '1', '401112', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'B.3W分的不是最高场？', 'A.参加过', 'A.滑动场馆就找到了', 'ag', '2015-01-29 20:13:05');
INSERT INTO `researchlog` VALUES ('90', '1', '317905', 'A.喜欢', 'B.不会', 'C.活动开始很久才发现', 'B.无意中发现', null, null, 'C.原来后面还有房间!', 'B.没有', 'C.完全不知道', '', '2015-01-29 20:13:07');
INSERT INTO `researchlog` VALUES ('91', '1', '411801', 'A.喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-29 20:13:25');
INSERT INTO `researchlog` VALUES ('92', '1', '401815', 'A.喜欢', 'B.不会', 'B.不知道', 'C.完全不了解', null, null, 'B.3W分的不是最高场？', 'B.没有', 'C.完全不知道', '1', '2015-01-29 20:16:22');
INSERT INTO `researchlog` VALUES ('93', '1', '331449', 'A.喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', null, 'F.兑换,G.抽奖,H.任务', 'C.原来后面还有房间!', 'B.没有', 'B.找了半天才找到', '抽奖几率太低！需要改进点', '2015-01-29 20:46:38');
INSERT INTO `researchlog` VALUES ('94', '1', '206294', 'B.不喜欢', 'B.不会', 'B.不知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '抽筋根本就抽不到大奖', '2015-01-29 20:58:59');
INSERT INTO `researchlog` VALUES ('95', '1', '252027', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-29 21:12:08');
INSERT INTO `researchlog` VALUES ('96', '1', '221067', 'A.喜欢', 'B.不会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-29 21:44:45');
INSERT INTO `researchlog` VALUES ('97', '1', '417616', 'A.喜欢', 'B.不会', 'A.知道', 'A.看公告', 'C.布局不好,D.用起来不习惯', 'A.公告,B.签到,C.喇叭,D.信息,', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-29 22:05:54');
INSERT INTO `researchlog` VALUES ('98', '1', '215311', 'A.喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', null, 'B.签到,G.抽奖', 'C.原来后面还有房间!', 'B.没有', 'B.找了半天才找到', '', '2015-01-29 22:09:24');
INSERT INTO `researchlog` VALUES ('99', '1', '318893', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '做爱', '2015-01-29 22:19:40');
INSERT INTO `researchlog` VALUES ('100', '1', '340785', 'B.不喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'B.找了半天才找到', '', '2015-01-29 22:40:37');
INSERT INTO `researchlog` VALUES ('101', '1', '413990', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', 'A.按钮太多,C.布局不好,D.用起来不', 'B.签到,D.信息,G.抽奖,H.任务', 'C.原来后面还有房间!', 'B.没有', 'C.完全不知道', '', '2015-01-29 22:42:19');
INSERT INTO `researchlog` VALUES ('102', '1', '352728', 'A.喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', 'A.按钮太多,B.非常拥挤,C.布局不好', 'A.公告,B.签到,C.喇叭,D.信息,', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '当没有金币时。应该发二到三次金他。', '2015-01-29 22:42:43');
INSERT INTO `researchlog` VALUES ('103', '1', '361585', 'B.不喜欢', 'B.不会', 'C.活动开始很久才发现', 'C.完全不了解', null, null, 'B.3W分的不是最高场？', 'B.没有', 'B.找了半天才找到', '', '2015-01-29 22:45:43');
INSERT INTO `researchlog` VALUES ('104', '1', '260924', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', 'B.非常拥挤,D.用起来不习惯', 'A.公告,B.签到,F.兑换,G.抽奖,', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-29 22:45:53');
INSERT INTO `researchlog` VALUES ('105', '1', '373838', 'B.不喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', null, null, 'B.3W分的不是最高场？', 'B.没有', 'B.找了半天才找到', '', '2015-01-29 23:03:54');
INSERT INTO `researchlog` VALUES ('106', '1', '185920', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'C.完全不了解', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '都还好吧    不用了', '2015-01-29 23:10:24');
INSERT INTO `researchlog` VALUES ('107', '1', '429454', 'B.不喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', 'B.非常拥挤,C.布局不好', null, 'C.原来后面还有房间!', 'B.没有', 'C.完全不知道', '', '2015-01-29 23:19:54');
INSERT INTO `researchlog` VALUES ('108', '1', '357690', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', 'A.按钮太多,B.非常拥挤,C.布局不好', 'A.公告,B.签到,C.喇叭,D.信息,', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '当金币用完了，应多补两次。', '2015-01-29 23:23:52');
INSERT INTO `researchlog` VALUES ('109', '1', '416766', 'B.不喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,F.兑换,G.抽奖,H.任务', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-29 23:38:45');
INSERT INTO `researchlog` VALUES ('110', '1', '288440', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '有时还是会出错相同点数内区分大小容易错', '2015-01-29 23:40:31');
INSERT INTO `researchlog` VALUES ('111', '1', '285699', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,G.抽奖', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '同点数比大小容易出错', '2015-01-29 23:47:31');
INSERT INTO `researchlog` VALUES ('112', '1', '395926', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,E.系统,F.兑换,G.抽奖,', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 00:04:57');
INSERT INTO `researchlog` VALUES ('113', '1', '284583', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,B.签到,D.信息,E.系统,', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 00:06:33');
INSERT INTO `researchlog` VALUES ('114', '1', '250568', 'A.喜欢', 'B.不会', 'A.知道', 'A.看公告', null, 'A.公告,B.签到,C.喇叭,D.信息,', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '太坑人了', '2015-01-30 00:09:59');
INSERT INTO `researchlog` VALUES ('115', '1', '184771', 'B.不喜欢', 'B.不会', 'B.不知道', 'C.完全不了解', null, 'G.抽奖,H.任务,J.商城', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 00:13:36');
INSERT INTO `researchlog` VALUES ('116', '1', '113416', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,G.抽奖', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 00:22:54');
INSERT INTO `researchlog` VALUES ('117', '1', '252101', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-30 00:31:07');
INSERT INTO `researchlog` VALUES ('118', '1', '283687', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-30 00:32:02');
INSERT INTO `researchlog` VALUES ('119', '1', '276644', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'A.看公告', null, 'A.公告,B.签到,H.任务,L.分享', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-30 00:32:58');
INSERT INTO `researchlog` VALUES ('120', '1', '230071', 'B.不喜欢', 'B.不会', 'C.活动开始很久才发现', 'C.完全不了解', null, 'B.签到,C.喇叭,D.信息', 'C.原来后面还有房间!', 'B.没有', 'B.找了半天才找到', '任务需要改进', '2015-01-30 00:38:22');
INSERT INTO `researchlog` VALUES ('121', '1', '73499', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,H.任务', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-30 00:47:28');
INSERT INTO `researchlog` VALUES ('122', '1', '304926', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'B.无意中发现', null, 'B.签到,D.信息,E.系统,G.抽奖,', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 01:11:15');
INSERT INTO `researchlog` VALUES ('123', '1', '111891', 'A.喜欢', 'A.会', 'B.不知道', 'B.无意中发现', 'B.非常拥挤,D.用起来不习惯', 'B.签到,F.兑换,H.任务', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 01:11:46');
INSERT INTO `researchlog` VALUES ('124', '1', '254481', 'A.喜欢', 'B.不会', 'C.活动开始很久才发现', 'C.完全不了解', null, 'B.签到,D.信息,E.系统,F.兑换,', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '签到可以再多点金币', '2015-01-30 01:31:00');
INSERT INTO `researchlog` VALUES ('125', '1', '99331', 'B.不喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', null, 'A.公告,B.签到,D.信息,E.系统,', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '继续努力', '2015-01-30 01:51:19');
INSERT INTO `researchlog` VALUES ('126', '1', '263776', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'B.3W分的不是最高场？', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-30 02:07:11');
INSERT INTO `researchlog` VALUES ('127', '1', '263843', 'A.喜欢', 'B.不会', 'C.活动开始很久才发现', 'B.无意中发现', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 02:35:54');
INSERT INTO `researchlog` VALUES ('128', '1', '263908', 'A.喜欢', 'B.不会', 'C.活动开始很久才发现', 'B.无意中发现', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 02:38:02');
INSERT INTO `researchlog` VALUES ('129', '1', '277438', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-30 04:02:39');
INSERT INTO `researchlog` VALUES ('130', '1', '412507', 'B.不喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,B.签到,D.信息,E.系统,', 'B.3W分的不是最高场？', 'B.没有', 'C.完全不知道', '', '2015-01-30 04:07:31');
INSERT INTO `researchlog` VALUES ('131', '1', '264854', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '不知道', '2015-01-30 04:08:27');
INSERT INTO `researchlog` VALUES ('132', '1', '284246', 'B.不喜欢', 'A.会', 'A.知道', 'A.看公告', 'C.布局不好,D.用起来不习惯', 'A.公告,B.签到,C.喇叭,D.信息,', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-30 04:10:48');
INSERT INTO `researchlog` VALUES ('133', '1', '384101', 'B.不喜欢', 'B.不会', 'C.活动开始很久才发现', 'C.完全不了解', 'C.布局不好,D.用起来不习惯', 'D.信息,I.排行', 'B.3W分的不是最高场？', 'B.没有', 'B.找了半天才找到', '不好', '2015-01-30 06:22:38');
INSERT INTO `researchlog` VALUES ('134', '1', '319294', 'A.喜欢', 'A.会', 'B.不知道', 'B.无意中发现', null, 'B.签到,G.抽奖,L.分享', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 06:33:50');
INSERT INTO `researchlog` VALUES ('135', '1', '310283', 'A.喜欢', 'A.会', 'A.知道', 'B.无意中发现', null, null, 'C.原来后面还有房间!', 'B.没有', 'A.滑动场馆就找到了', '抽奖沒用', '2015-01-30 06:50:01');
INSERT INTO `researchlog` VALUES ('136', '1', '363778', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,G.抽奖', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-30 07:42:43');
INSERT INTO `researchlog` VALUES ('137', '1', '255679', 'B.不喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'C.原来后面还有房间!', 'B.没有', 'B.找了半天才找到', '', '2015-01-30 08:14:23');
INSERT INTO `researchlog` VALUES ('138', '1', '169966', 'A.喜欢', 'B.不会', 'C.活动开始很久才发现', 'B.无意中发现', null, 'G.抽奖,H.任务,J.商城', 'C.原来后面还有房间!', 'B.没有', 'C.完全不知道', '每天签到送得太少', '2015-01-30 08:18:37');
INSERT INTO `researchlog` VALUES ('139', '1', '29785', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'B.无意中发现', null, 'A.公告,F.兑换,G.抽奖,H.任务,', 'B.3W分的不是最高场？', 'B.没有', 'B.找了半天才找到', '万事如意', '2015-01-30 08:21:56');
INSERT INTO `researchlog` VALUES ('140', '1', '321574', 'B.不喜欢', 'B.不会', 'A.知道', 'B.无意中发现', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 08:30:17');
INSERT INTO `researchlog` VALUES ('141', '1', '329870', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'B.无意中发现', 'A.按钮太多,C.布局不好', 'B.签到,E.系统,G.抽奖,H.任务', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 08:52:25');
INSERT INTO `researchlog` VALUES ('142', '1', '430228', 'A.喜欢', 'A.会', 'A.知道', 'B.无意中发现', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '', '2015-01-30 08:56:09');
INSERT INTO `researchlog` VALUES ('143', '1', '274467', 'A.喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', null, 'B.签到,D.信息,F.兑换,G.抽奖,', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '还好吧', '2015-01-30 08:57:26');
INSERT INTO `researchlog` VALUES ('144', '1', '279413', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,G.抽奖', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-30 09:00:00');
INSERT INTO `researchlog` VALUES ('145', '1', '289538', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,B.签到,G.抽奖', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '很好啊', '2015-01-30 09:02:47');
INSERT INTO `researchlog` VALUES ('146', '1', '280890', 'A.喜欢', 'B.不会', 'C.活动开始很久才发现', 'B.无意中发现', null, null, 'B.3W分的不是最高场？', 'B.没有', 'A.滑动场馆就找到了', '抽奖机率中金币大奖太少了', '2015-01-30 09:11:13');
INSERT INTO `researchlog` VALUES ('147', '1', '225215', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'B.签到,G.抽奖', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-30 09:19:21');
INSERT INTO `researchlog` VALUES ('148', '1', '280878', 'A.喜欢', 'B.不会', 'C.活动开始很久才发现', 'B.无意中发现', null, null, 'B.3W分的不是最高场？', 'B.没有', 'A.滑动场馆就找到了', '为什么会打不了字呢  怎么回事  打不了字 不好玩 ', '2015-01-30 09:31:28');
INSERT INTO `researchlog` VALUES ('149', '1', '325863', 'A.喜欢', 'A.会', 'C.活动开始很久才发现', 'B.无意中发现', null, 'A.公告,E.系统,G.抽奖,H.任务,', 'A.会滑动查看后面的房间', 'B.没有', 'C.完全不知道', '单机', '2015-01-30 09:31:37');
INSERT INTO `researchlog` VALUES ('150', '1', '284537', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,G.抽奖', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '很好啊', '2015-01-30 09:41:03');
INSERT INTO `researchlog` VALUES ('151', '1', '336134', 'B.不喜欢', 'B.不会', 'C.活动开始很久才发现', 'B.无意中发现', null, null, 'B.3W分的不是最高场？', 'B.没有', 'A.滑动场馆就找到了', '为什么打不了字呢  有的打到的我的打不了字', '2015-01-30 09:45:32');
INSERT INTO `researchlog` VALUES ('152', '1', '289723', 'B.不喜欢', 'B.不会', 'B.不知道', 'C.完全不了解', null, null, 'C.原来后面还有房间!', 'B.没有', 'C.完全不知道', '删掉', '2015-01-30 10:10:20');
INSERT INTO `researchlog` VALUES ('153', '1', '447328', 'B.不喜欢', 'B.不会', 'A.知道', 'B.无意中发现', 'C.布局不好,D.用起来不习惯', 'B.签到,H.任务', 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '', '2015-01-30 10:11:46');
INSERT INTO `researchlog` VALUES ('154', '1', '245870', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, null, 'A.会滑动查看后面的房间', 'A.参加过', 'A.滑动场馆就找到了', '没有了', '2015-01-30 10:13:14');
INSERT INTO `researchlog` VALUES ('155', '1', '328724', 'B.不喜欢', 'A.会', 'C.活动开始很久才发现', 'B.无意中发现', null, 'B.签到,G.抽奖,H.任务', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '抽奖不好', '2015-01-30 10:14:06');
INSERT INTO `researchlog` VALUES ('156', '1', '519', 'B.不喜欢', 'B.不会', 'B.不知道', 'B.无意中发现', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'B.找了半天才找到', '', '2015-01-30 10:32:50');
INSERT INTO `researchlog` VALUES ('157', '1', '219147', 'A.喜欢', 'A.会', 'A.知道', 'A.看公告', null, 'A.公告,B.签到,C.喇叭,D.信息,', 'A.会滑动查看后面的房间', 'B.没有', 'A.滑动场馆就找到了', '', '2015-01-30 10:38:29');
INSERT INTO `researchlog` VALUES ('158', '1', '284118', 'B.不喜欢', 'A.会', 'B.不知道', 'C.完全不了解', null, null, 'A.会滑动查看后面的房间', 'B.没有', 'B.找了半天才找到', '没有', '2015-01-30 10:42:25');

-- ----------------------------
-- Table structure for robot_name
-- ----------------------------
DROP TABLE IF EXISTS `robot_name`;
CREATE TABLE `robot_name` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `sex` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1055 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of robot_name
-- ----------------------------
INSERT INTO `robot_name` VALUES ('1', '昵称', '1');
INSERT INTO `robot_name` VALUES ('2', '昨夜的梦', '1');
INSERT INTO `robot_name` VALUES ('3', '醉红尘', '0');
INSERT INTO `robot_name` VALUES ('4', '最怕猪一样的队友', '0');
INSERT INTO `robot_name` VALUES ('5', '最冷不过人心', '1');
INSERT INTO `robot_name` VALUES ('6', '最爱燕燕', '0');
INSERT INTO `robot_name` VALUES ('7', '祖凌青', '0');
INSERT INTO `robot_name` VALUES ('8', '宗翠绿', '1');
INSERT INTO `robot_name` VALUES ('9', '自我凌乱', '1');
INSERT INTO `robot_name` VALUES ('10', '自我超远', '0');
INSERT INTO `robot_name` VALUES ('11', '自我', '1');
INSERT INTO `robot_name` VALUES ('12', '卓三娘', '0');
INSERT INTO `robot_name` VALUES ('13', '追寻自由', '0');
INSERT INTO `robot_name` VALUES ('14', '庄1536546', '0');
INSERT INTO `robot_name` VALUES ('15', '赚钱', '0');
INSERT INTO `robot_name` VALUES ('16', '转载', '1');
INSERT INTO `robot_name` VALUES ('17', '转角风太大', '0');
INSERT INTO `robot_name` VALUES ('18', '专业一个', '0');
INSERT INTO `robot_name` VALUES ('19', '专业丶地主', '1');
INSERT INTO `robot_name` VALUES ('20', '专门打游戏', '0');
INSERT INTO `robot_name` VALUES ('21', '猪一样的队友', '0');
INSERT INTO `robot_name` VALUES ('22', '周喜晚', '0');
INSERT INTO `robot_name` VALUES ('23', '周剑峰', '1');
INSERT INTO `robot_name` VALUES ('24', '仲唯雪', '1');
INSERT INTO `robot_name` VALUES ('25', '中华英雄', '1');
INSERT INTO `robot_name` VALUES ('26', '中国移动通信', '0');
INSERT INTO `robot_name` VALUES ('27', '智智', '1');
INSERT INTO `robot_name` VALUES ('28', '至尊冷酷', '1');
INSERT INTO `robot_name` VALUES ('29', '至尊地主王', '0');
INSERT INTO `robot_name` VALUES ('30', '纸妹你是哥的', '0');
INSERT INTO `robot_name` VALUES ('31', '执子之手', '0');
INSERT INTO `robot_name` VALUES ('32', '只想一点点', '0');
INSERT INTO `robot_name` VALUES ('33', '只靠自己', '1');
INSERT INTO `robot_name` VALUES ('34', '支映秋', '0');
INSERT INTO `robot_name` VALUES ('35', '甄问柳', '0');
INSERT INTO `robot_name` VALUES ('36', '真真8假假', '1');
INSERT INTO `robot_name` VALUES ('37', '真心寻另一半', '1');
INSERT INTO `robot_name` VALUES ('38', '真武小龙', '0');
INSERT INTO `robot_name` VALUES ('39', '珍惜果果', '0');
INSERT INTO `robot_name` VALUES ('40', '珍荣益', '0');
INSERT INTO `robot_name` VALUES ('41', '珍1227601400', '0');
INSERT INTO `robot_name` VALUES ('42', '这样说的', '1');
INSERT INTO `robot_name` VALUES ('43', '喆喆', '1');
INSERT INTO `robot_name` VALUES ('44', '赵杰儿', '1');
INSERT INTO `robot_name` VALUES ('45', '赵杰Algtxysys', '0');
INSERT INTO `robot_name` VALUES ('46', '长孙寻桃', '1');
INSERT INTO `robot_name` VALUES ('47', '章平露', '0');
INSERT INTO `robot_name` VALUES ('48', '张彦兴旺', '0');
INSERT INTO `robot_name` VALUES ('49', '张娴娴', '0');
INSERT INTO `robot_name` VALUES ('50', '张无忌', '1');
INSERT INTO `robot_name` VALUES ('51', '张帅', '1');
INSERT INTO `robot_name` VALUES ('52', '张静涵', '0');
INSERT INTO `robot_name` VALUES ('53', '戰神0528', '0');
INSERT INTO `robot_name` VALUES ('54', '站在城楼观景', '1');
INSERT INTO `robot_name` VALUES ('55', '战无不输', '0');
INSERT INTO `robot_name` VALUES ('56', '战神草你MM', '0');
INSERT INTO `robot_name` VALUES ('57', '炸炸炸', '0');
INSERT INTO `robot_name` VALUES ('58', '炸到你叫爹', '1');
INSERT INTO `robot_name` VALUES ('59', '炸弹又见炸弹', '1');
INSERT INTO `robot_name` VALUES ('60', '炸弹蛮天飞', '0');
INSERT INTO `robot_name` VALUES ('61', '炸0炸0炸0', '0');
INSERT INTO `robot_name` VALUES ('62', '咋都不会输', '1');
INSERT INTO `robot_name` VALUES ('63', '咂到你老母', '0');
INSERT INTO `robot_name` VALUES ('64', '云宇之恋1314', '1');
INSERT INTO `robot_name` VALUES ('65', '云随风雪', '1');
INSERT INTO `robot_name` VALUES ('66', '云随风飘雪', '1');
INSERT INTO `robot_name` VALUES ('67', '云随风飘清', '0');
INSERT INTO `robot_name` VALUES ('68', '云随风流血', '0');
INSERT INTO `robot_name` VALUES ('69', '晕乎乎啊', '0');
INSERT INTO `robot_name` VALUES ('70', '月光明正大', '1');
INSERT INTO `robot_name` VALUES ('71', '袁泽鹏', '0');
INSERT INTO `robot_name` VALUES ('72', '袁师歌', '1');
INSERT INTO `robot_name` VALUES ('73', '袁强赢了', '0');
INSERT INTO `robot_name` VALUES ('74', '爰久', '1');
INSERT INTO `robot_name` VALUES ('75', '元始天尊', '1');
INSERT INTO `robot_name` VALUES ('76', '元宝小圣', '0');
INSERT INTO `robot_name` VALUES ('77', '浴血枫淋', '1');
INSERT INTO `robot_name` VALUES ('78', '狱血魔神88', '0');
INSERT INTO `robot_name` VALUES ('79', '玉树临风', '0');
INSERT INTO `robot_name` VALUES ('80', '玉皇大帝', '1');
INSERT INTO `robot_name` VALUES ('81', '禹鸿', '1');
INSERT INTO `robot_name` VALUES ('82', '雨天的记忆', '1');
INSERT INTO `robot_name` VALUES ('83', '雨龙', '1');
INSERT INTO `robot_name` VALUES ('84', '雨季', '0');
INSERT INTO `robot_name` VALUES ('85', '雨点随风落', '1');
INSERT INTO `robot_name` VALUES ('86', '羽s煌', '1');
INSERT INTO `robot_name` VALUES ('87', '宇少', '0');
INSERT INTO `robot_name` VALUES ('88', '与龙共舞', '1');
INSERT INTO `robot_name` VALUES ('89', '愚乐为主', '0');
INSERT INTO `robot_name` VALUES ('90', '渝龙', '0');
INSERT INTO `robot_name` VALUES ('91', '鱼仙', '1');
INSERT INTO `robot_name` VALUES ('92', '鱼狼共舞', '0');
INSERT INTO `robot_name` VALUES ('93', '鱼儿', '0');
INSERT INTO `robot_name` VALUES ('94', '余长友', '0');
INSERT INTO `robot_name` VALUES ('95', '於以山', '0');
INSERT INTO `robot_name` VALUES ('96', '有炸快炸', '0');
INSERT INTO `robot_name` VALUES ('97', '有牌没牌快点出呀', '1');
INSERT INTO `robot_name` VALUES ('98', '有你有我有意思', '0');
INSERT INTO `robot_name` VALUES ('99', '有你的幸福', '0');
INSERT INTO `robot_name` VALUES ('100', '有梦想的皮卡丘', '0');
INSERT INTO `robot_name` VALUES ('101', '友谊战', '0');
INSERT INTO `robot_name` VALUES ('102', '游林杰我女神', '0');
INSERT INTO `robot_name` VALUES ('103', '尤尔丝', '1');
INSERT INTO `robot_name` VALUES ('104', '悠悠我心你是', '0');
INSERT INTO `robot_name` VALUES ('105', '幽奈魅雪', '0');
INSERT INTO `robot_name` VALUES ('106', '呦呦诶呦', '0');
INSERT INTO `robot_name` VALUES ('107', '用一生爱你', '0');
INSERT INTO `robot_name` VALUES ('108', '用户昵称', '1');
INSERT INTO `robot_name` VALUES ('109', '勇哥斗地主', '1');
INSERT INTO `robot_name` VALUES ('110', '雍晓蕾', '1');
INSERT INTO `robot_name` VALUES ('111', '影魔', '1');
INSERT INTO `robot_name` VALUES ('112', '影灵', '0');
INSERT INTO `robot_name` VALUES ('113', '颖泉', '1');
INSERT INTO `robot_name` VALUES ('114', '赢的就是你', '1');
INSERT INTO `robot_name` VALUES ('115', '樱花之道', '1');
INSERT INTO `robot_name` VALUES ('116', '樱花草', '1');
INSERT INTO `robot_name` VALUES ('117', '隠形的翅膀', '0');
INSERT INTO `robot_name` VALUES ('118', '尹老师', '0');
INSERT INTO `robot_name` VALUES ('119', '意随风云动', '0');
INSERT INTO `robot_name` VALUES ('120', '益煌870760385', '0');
INSERT INTO `robot_name` VALUES ('121', '益煌82406098', '1');
INSERT INTO `robot_name` VALUES ('122', '易890825', '1');
INSERT INTO `robot_name` VALUES ('123', '乂妳', '1');
INSERT INTO `robot_name` VALUES ('124', '依恋', '0');
INSERT INTO `robot_name` VALUES ('125', '依赖式习惯', '0');
INSERT INTO `robot_name` VALUES ('126', '伊博中华一辈子', '0');
INSERT INTO `robot_name` VALUES ('127', '一叶知秋', '1');
INSERT INTO `robot_name` VALUES ('128', '一丨丨丨丨丨丨丨丨丨', '1');
INSERT INTO `robot_name` VALUES ('129', '一身无悔', '1');
INSERT INTO `robot_name` VALUES ('130', '一切皆有可能', '0');
INSERT INTO `robot_name` VALUES ('131', '一秒钟的记忆', '0');
INSERT INTO `robot_name` VALUES ('132', '一缕阳光', '0');
INSERT INTO `robot_name` VALUES ('133', '一剪梅', '0');
INSERT INTO `robot_name` VALUES ('134', '一辉', '1');
INSERT INTO `robot_name` VALUES ('135', '一个失了心的孩子', '1');
INSERT INTO `robot_name` VALUES ('136', '一朵小红花', '0');
INSERT INTO `robot_name` VALUES ('137', '葉釹', '1');
INSERT INTO `robot_name` VALUES ('138', '夜袭寡妇鎮', '1');
INSERT INTO `robot_name` VALUES ('139', '夜无聊', '1');
INSERT INTO `robot_name` VALUES ('140', '夜未央桔色', '1');
INSERT INTO `robot_name` VALUES ('141', '夜猫子', '0');
INSERT INTO `robot_name` VALUES ('142', '爷爷0', '0');
INSERT INTO `robot_name` VALUES ('143', '要号码送元宝', '1');
INSERT INTO `robot_name` VALUES ('144', '要不起都炸', '1');
INSERT INTO `robot_name` VALUES ('145', '姚迎蓉', '0');
INSERT INTO `robot_name` VALUES ('146', '杨子君心', '1');
INSERT INTO `robot_name` VALUES ('147', '杨晓', '0');
INSERT INTO `robot_name` VALUES ('148', '杨少', '1');
INSERT INTO `robot_name` VALUES ('149', '杨蕤蔓', '1');
INSERT INTO `robot_name` VALUES ('150', '杨华乐', '1');
INSERT INTO `robot_name` VALUES ('151', '羊仔', '1');
INSERT INTO `robot_name` VALUES ('152', '羊羊羊', '1');
INSERT INTO `robot_name` VALUES ('153', '羊小翠', '1');
INSERT INTO `robot_name` VALUES ('154', '燕子姐', '1');
INSERT INTO `robot_name` VALUES ('155', '燕子菲', '0');
INSERT INTO `robot_name` VALUES ('156', '燕姐', '1');
INSERT INTO `robot_name` VALUES ('157', '燕辉', '0');
INSERT INTO `robot_name` VALUES ('158', '掩饰悲伤', '0');
INSERT INTO `robot_name` VALUES ('159', '颜儿m', '0');
INSERT INTO `robot_name` VALUES ('160', '阎思萱', '1');
INSERT INTO `robot_name` VALUES ('161', '阎青文', '0');
INSERT INTO `robot_name` VALUES ('162', '烟云', '1');
INSERT INTO `robot_name` VALUES ('163', '雅诗兰黛', '1');
INSERT INTO `robot_name` VALUES ('164', '雅骚', '1');
INSERT INTO `robot_name` VALUES ('165', '荀曼冬', '0');
INSERT INTO `robot_name` VALUES ('166', '寻找真爱', '1');
INSERT INTO `robot_name` VALUES ('167', '寻找高手', '1');
INSERT INTO `robot_name` VALUES ('168', '血色玫瑰', '1');
INSERT INTO `robot_name` VALUES ('169', '血娇', '1');
INSERT INTO `robot_name` VALUES ('170', '雪豹', '1');
INSERT INTO `robot_name` VALUES ('171', '炫魅昕昕', '0');
INSERT INTO `robot_name` VALUES ('172', '嬛小妞', '1');
INSERT INTO `robot_name` VALUES ('173', '萱儿', '0');
INSERT INTO `robot_name` VALUES ('174', '宣绝义', '0');
INSERT INTO `robot_name` VALUES ('175', '轩辕小凝', '0');
INSERT INTO `robot_name` VALUES ('176', '轩辕三颜', '0');
INSERT INTO `robot_name` VALUES ('177', '轩辕绿蕊', '1');
INSERT INTO `robot_name` VALUES ('178', '虚伪的人', '1');
INSERT INTO `robot_name` VALUES ('179', '虚空盛行', '0');
INSERT INTO `robot_name` VALUES ('180', '熊熊抱', '0');
INSERT INTO `robot_name` VALUES ('181', '熊猫', '1');
INSERT INTO `robot_name` VALUES ('182', '雄鹰无悔', '1');
INSERT INTO `robot_name` VALUES ('183', '雄哥斗地主', '0');
INSERT INTO `robot_name` VALUES ('184', '胸场', '1');
INSERT INTO `robot_name` VALUES ('185', '兄弟给我炸', '0');
INSERT INTO `robot_name` VALUES ('186', '性冲动', '0');
INSERT INTO `robot_name` VALUES ('187', '幸福是被你需要', '0');
INSERT INTO `robot_name` VALUES ('188', '幸福的微笑', '1');
INSERT INTO `robot_name` VALUES ('189', '幸福', '0');
INSERT INTO `robot_name` VALUES ('190', '新来的咋滴', '1');
INSERT INTO `robot_name` VALUES ('191', '欣紫怡', '1');
INSERT INTO `robot_name` VALUES ('192', '昕星', '0');
INSERT INTO `robot_name` VALUES ('193', '心梦无痕', '0');
INSERT INTO `robot_name` VALUES ('194', '心婧', '1');
INSERT INTO `robot_name` VALUES ('195', '心病i', '1');
INSERT INTO `robot_name` VALUES ('196', '谢霆锋889', '0');
INSERT INTO `robot_name` VALUES ('197', '携手', '1');
INSERT INTO `robot_name` VALUES ('198', '邪恶的小混蛋', '0');
INSERT INTO `robot_name` VALUES ('199', '笑着说再见', '1');
INSERT INTO `robot_name` VALUES ('200', '笑傲江湖', '1');
INSERT INTO `robot_name` VALUES ('201', '晓婷', '1');
INSERT INTO `robot_name` VALUES ('202', '小智星', '1');
INSERT INTO `robot_name` VALUES ('203', '小振', '0');
INSERT INTO `robot_name` VALUES ('204', '小炸几小下', '0');
INSERT INTO `robot_name` VALUES ('205', '小云升13458083248', '0');
INSERT INTO `robot_name` VALUES ('206', '小袁', '0');
INSERT INTO `robot_name` VALUES ('207', '小宇么么', '1');
INSERT INTO `robot_name` VALUES ('208', '小宇bb', '1');
INSERT INTO `robot_name` VALUES ('209', '小艺', '0');
INSERT INTO `robot_name` VALUES ('210', '小岩', '0');
INSERT INTO `robot_name` VALUES ('211', '小雅lyh', '1');
INSERT INTO `robot_name` VALUES ('212', '小雪不吃饭', '0');
INSERT INTO `robot_name` VALUES ('213', '小雪', '0');
INSERT INTO `robot_name` VALUES ('214', '小心的', '0');
INSERT INTO `robot_name` VALUES ('215', '小五爷', '1');
INSERT INTO `robot_name` VALUES ('216', '小五毛K', '0');
INSERT INTO `robot_name` VALUES ('217', '小尾巴', '0');
INSERT INTO `robot_name` VALUES ('218', '小王', '1');
INSERT INTO `robot_name` VALUES ('219', '小桃', '1');
INSERT INTO `robot_name` VALUES ('220', '小松', '1');
INSERT INTO `robot_name` VALUES ('221', '小色鬼', '0');
INSERT INTO `robot_name` VALUES ('222', '小仨', '1');
INSERT INTO `robot_name` VALUES ('223', '小苹果', '1');
INSERT INTO `robot_name` VALUES ('224', '小妹仔', '0');
INSERT INTO `robot_name` VALUES ('225', '小鹿斑比', '0');
INSERT INTO `robot_name` VALUES ('226', '小林哥哥', '1');
INSERT INTO `robot_name` VALUES ('227', '小历', '1');
INSERT INTO `robot_name` VALUES ('228', '小澜', '0');
INSERT INTO `robot_name` VALUES ('229', '小俊瓜', '0');
INSERT INTO `robot_name` VALUES ('230', '小杰传奇', '1');
INSERT INTO `robot_name` VALUES ('231', '小会', '1');
INSERT INTO `robot_name` VALUES ('232', '小海别忧伤', '1');
INSERT INTO `robot_name` VALUES ('233', '小海', '0');
INSERT INTO `robot_name` VALUES ('234', '小孩', '0');
INSERT INTO `robot_name` VALUES ('235', '小峰2014', '1');
INSERT INTO `robot_name` VALUES ('236', '小虫小庄', '0');
INSERT INTO `robot_name` VALUES ('237', '小草莓', '1');
INSERT INTO `robot_name` VALUES ('238', '小布丁', '1');
INSERT INTO `robot_name` VALUES ('239', '小宝贝o', '1');
INSERT INTO `robot_name` VALUES ('240', '小八路', '1');
INSERT INTO `robot_name` VALUES ('241', '逍丿遥', '1');
INSERT INTO `robot_name` VALUES ('242', '枭喆', '1');
INSERT INTO `robot_name` VALUES ('243', '像风一样自由', '0');
INSERT INTO `robot_name` VALUES ('244', '向左转54', '0');
INSERT INTO `robot_name` VALUES ('245', '向阳花', '0');
INSERT INTO `robot_name` VALUES ('246', '向我看齐', '0');
INSERT INTO `robot_name` VALUES ('247', '向往水电工资队', '1');
INSERT INTO `robot_name` VALUES ('248', '想做爱', '1');
INSERT INTO `robot_name` VALUES ('249', '想念你的吻别', '1');
INSERT INTO `robot_name` VALUES ('250', '想你到高潮', '1');
INSERT INTO `robot_name` VALUES ('251', '翔哥', '1');
INSERT INTO `robot_name` VALUES ('252', '香总v5', '0');
INSERT INTO `robot_name` VALUES ('253', '香水', '0');
INSERT INTO `robot_name` VALUES ('254', '香飘飘', '1');
INSERT INTO `robot_name` VALUES ('255', '相信自己', '1');
INSERT INTO `robot_name` VALUES ('256', '相信有你', '0');
INSERT INTO `robot_name` VALUES ('257', '仙女神童', '1');
INSERT INTO `robot_name` VALUES ('258', '夏雨天', '1');
INSERT INTO `robot_name` VALUES ('259', '夏猩', '0');
INSERT INTO `robot_name` VALUES ('260', '夏天的知鸟', '1');
INSERT INTO `robot_name` VALUES ('261', '夏末蓝珊', '0');
INSERT INTO `robot_name` VALUES ('262', '夏安露', '0');
INSERT INTO `robot_name` VALUES ('263', '下面好湿', '1');
INSERT INTO `robot_name` VALUES ('264', '侠客行', '1');
INSERT INTO `robot_name` VALUES ('265', '锡华', '0');
INSERT INTO `robot_name` VALUES ('266', '昔菁', '0');
INSERT INTO `robot_name` VALUES ('267', '西西一笑倾城', '1');
INSERT INTO `robot_name` VALUES ('268', '西北狼', '1');
INSERT INTO `robot_name` VALUES ('269', '夕若', '0');
INSERT INTO `robot_name` VALUES ('270', '舞谢楼台', '1');
INSERT INTO `robot_name` VALUES ('271', '武动老饿', '0');
INSERT INTO `robot_name` VALUES ('272', '伍文', '1');
INSERT INTO `robot_name` VALUES ('273', '午夜牛郎', '1');
INSERT INTO `robot_name` VALUES ('274', '五月龙啸', '1');
INSERT INTO `robot_name` VALUES ('275', '无语', '0');
INSERT INTO `robot_name` VALUES ('276', '无水的鱼', '1');
INSERT INTO `robot_name` VALUES ('277', '无人能', '0');
INSERT INTO `robot_name` VALUES ('278', '无量天尊', '0');
INSERT INTO `robot_name` VALUES ('279', '无泪', '1');
INSERT INTO `robot_name` VALUES ('280', '无悔', '1');
INSERT INTO `robot_name` VALUES ('281', '嗚嗚嗚嗚嗚嗚', '0');
INSERT INTO `robot_name` VALUES ('282', '巫马安露', '0');
INSERT INTO `robot_name` VALUES ('283', '卧槽潦倒', '1');
INSERT INTO `robot_name` VALUES ('284', '我总是心太软', '0');
INSERT INTO `robot_name` VALUES ('285', '我知你心', '1');
INSERT INTO `robot_name` VALUES ('286', '我只在呼你', '1');
INSERT INTO `robot_name` VALUES ('287', '我只是为了话费', '0');
INSERT INTO `robot_name` VALUES ('288', '我在zlt123456', '1');
INSERT INTO `robot_name` VALUES ('289', '我欲飞翔', '0');
INSERT INTO `robot_name` VALUES ('290', '我有魅力', '1');
INSERT INTO `robot_name` VALUES ('291', '我要找mm', '0');
INSERT INTO `robot_name` VALUES ('292', '我要你的爱', '1');
INSERT INTO `robot_name` VALUES ('293', '我要斗地主', '0');
INSERT INTO `robot_name` VALUES ('294', '我要操你逼', '1');
INSERT INTO `robot_name` VALUES ('295', '我寻找爱情', '1');
INSERT INTO `robot_name` VALUES ('296', '我心依旧', '0');
INSERT INTO `robot_name` VALUES ('297', '我是熊大出快点', '1');
INSERT INTO `robot_name` VALUES ('298', '我是新手别欺负我', '1');
INSERT INTO `robot_name` VALUES ('299', '我是谁', '1');
INSERT INTO `robot_name` VALUES ('300', '我是鹏哥', '1');
INSERT INTO `robot_name` VALUES ('301', '我视猪', '0');
INSERT INTO `robot_name` VALUES ('302', '我没币', '0');
INSERT INTO `robot_name` VALUES ('303', '我家睿睿', '1');
INSERT INTO `robot_name` VALUES ('304', '我和你拼了', '0');
INSERT INTO `robot_name` VALUES ('305', '我好人', '0');
INSERT INTO `robot_name` VALUES ('306', '我行我速', '1');
INSERT INTO `robot_name` VALUES ('307', '我发表情你就炸', '1');
INSERT INTO `robot_name` VALUES ('308', '我等你为了你', '1');
INSERT INTO `robot_name` VALUES ('309', '我等到花儿谢了', '0');
INSERT INTO `robot_name` VALUES ('310', '我的小名叫栋栋', '0');
INSERT INTO `robot_name` VALUES ('311', '我的王子思朗', '0');
INSERT INTO `robot_name` VALUES ('312', '我不是丑女', '1');
INSERT INTO `robot_name` VALUES ('313', '我不怕你', '0');
INSERT INTO `robot_name` VALUES ('314', '我爱英英', '1');
INSERT INTO `robot_name` VALUES ('315', '我爱小利', '1');
INSERT INTO `robot_name` VALUES ('316', '我爱泡美女', '1');
INSERT INTO `robot_name` VALUES ('317', '我爱你小宝贝', '0');
INSERT INTO `robot_name` VALUES ('318', '我爱老婆', '0');
INSERT INTO `robot_name` VALUES ('319', '我123456h', '0');
INSERT INTO `robot_name` VALUES ('320', '稳稳的小幸福', '0');
INSERT INTO `robot_name` VALUES ('321', '温柔港湾', '0');
INSERT INTO `robot_name` VALUES ('322', '位超', '0');
INSERT INTO `robot_name` VALUES ('323', '卫太君', '1');
INSERT INTO `robot_name` VALUES ('324', '维维', '0');
INSERT INTO `robot_name` VALUES ('325', '维obb', '1');
INSERT INTO `robot_name` VALUES ('326', '唯一', '0');
INSERT INTO `robot_name` VALUES ('327', '唯美老姐打不', '1');
INSERT INTO `robot_name` VALUES ('328', '为你改变', '0');
INSERT INTO `robot_name` VALUES ('329', '为理想奋斗', '0');
INSERT INTO `robot_name` VALUES ('330', '微笑丫头', '0');
INSERT INTO `robot_name` VALUES ('331', '忘了你我很快乐', '0');
INSERT INTO `robot_name` VALUES ('332', '王者天尊', '0');
INSERT INTO `robot_name` VALUES ('333', '王者是我2', '1');
INSERT INTO `robot_name` VALUES ('334', '王鹏层', '1');
INSERT INTO `robot_name` VALUES ('335', '王嘉龙', '0');
INSERT INTO `robot_name` VALUES ('336', '王皓恬173086166', '1');
INSERT INTO `robot_name` VALUES ('337', '王大师', '0');
INSERT INTO `robot_name` VALUES ('338', '王qi1', '0');
INSERT INTO `robot_name` VALUES ('339', '汪建青', '0');
INSERT INTO `robot_name` VALUES ('340', '万储', '0');
INSERT INTO `robot_name` VALUES ('341', '晚酒早班', '1');
INSERT INTO `robot_name` VALUES ('342', '宛利丽123', '1');
INSERT INTO `robot_name` VALUES ('343', '玩出快乐', '1');
INSERT INTO `robot_name` VALUES ('344', '弯月', '1');
INSERT INTO `robot_name` VALUES ('345', '佟觅云', '1');
INSERT INTO `robot_name` VALUES ('346', '佟玲', '1');
INSERT INTO `robot_name` VALUES ('347', '挺怪个人', '0');
INSERT INTO `robot_name` VALUES ('348', '婷婷', '1');
INSERT INTO `robot_name` VALUES ('349', '甜甜密密', '1');
INSERT INTO `robot_name` VALUES ('350', '甜甜520', '1');
INSERT INTO `robot_name` VALUES ('351', '田关58楼面点大陆', '1');
INSERT INTO `robot_name` VALUES ('352', '天涯流浪客', '0');
INSERT INTO `robot_name` VALUES ('353', '天涯浪子', '1');
INSERT INTO `robot_name` VALUES ('354', '天涯共此时', '0');
INSERT INTO `robot_name` VALUES ('355', '天下无聊', '0');
INSERT INTO `robot_name` VALUES ('356', '天下第一1580', '1');
INSERT INTO `robot_name` VALUES ('357', '天下', '0');
INSERT INTO `robot_name` VALUES ('358', '天下', '0');
INSERT INTO `robot_name` VALUES ('359', '天天快乐', '0');
INSERT INTO `robot_name` VALUES ('360', '天使与魔鬼', '0');
INSERT INTO `robot_name` VALUES ('361', '天赐恩典', '1');
INSERT INTO `robot_name` VALUES ('362', '陶醉居', '1');
INSERT INTO `robot_name` VALUES ('363', '陶乙', '0');
INSERT INTO `robot_name` VALUES ('364', '陶善若', '0');
INSERT INTO `robot_name` VALUES ('365', '陶丙', '0');
INSERT INTO `robot_name` VALUES ('366', '陶A', '0');
INSERT INTO `robot_name` VALUES ('367', '唐太兰', '1');
INSERT INTO `robot_name` VALUES ('368', '唐飞风', '1');
INSERT INTO `robot_name` VALUES ('369', '唐朝和尚', '0');
INSERT INTO `robot_name` VALUES ('370', '汤常德123456', '1');
INSERT INTO `robot_name` VALUES ('371', '谭玥', '1');
INSERT INTO `robot_name` VALUES ('372', '太真太假', '1');
INSERT INTO `robot_name` VALUES ('373', '太帅了', '1');
INSERT INTO `robot_name` VALUES ('374', '太累了', '0');
INSERT INTO `robot_name` VALUES ('375', '抬头见喜', '1');
INSERT INTO `robot_name` VALUES ('376', '台北angel', '0');
INSERT INTO `robot_name` VALUES ('377', '梭哈', '1');
INSERT INTO `robot_name` VALUES ('378', '孙雨桐大哥', '1');
INSERT INTO `robot_name` VALUES ('379', '孙世林', '0');
INSERT INTO `robot_name` VALUES ('380', '孙菲菲', '1');
INSERT INTO `robot_name` VALUES ('381', '随你神庙', '0');
INSERT INTO `robot_name` VALUES ('382', '随风飘雪雨', '1');
INSERT INTO `robot_name` VALUES ('383', '嵩哥', '0');
INSERT INTO `robot_name` VALUES ('384', '四季大发财', '0');
INSERT INTO `robot_name` VALUES ('385', '亖叶', '0');
INSERT INTO `robot_name` VALUES ('386', '死硬硬死', '1');
INSERT INTO `robot_name` VALUES ('387', '死不悔改', '0');
INSERT INTO `robot_name` VALUES ('388', '思雨', '0');
INSERT INTO `robot_name` VALUES ('389', '思念丽', '0');
INSERT INTO `robot_name` VALUES ('390', '司空紫槐', '0');
INSERT INTO `robot_name` VALUES ('391', '司空雁蓉', '1');
INSERT INTO `robot_name` VALUES ('392', '瞬间格式化', '1');
INSERT INTO `robot_name` VALUES ('393', '睡莲', '1');
INSERT INTO `robot_name` VALUES ('394', '水煮鱼', '1');
INSERT INTO `robot_name` VALUES ('395', '水韵s', '0');
INSERT INTO `robot_name` VALUES ('396', '水是冰的眼泪', '0');
INSERT INTO `robot_name` VALUES ('397', '水晶心', '1');
INSERT INTO `robot_name` VALUES ('398', '水电全免', '0');
INSERT INTO `robot_name` VALUES ('399', '谁淫谁来脱', '1');
INSERT INTO `robot_name` VALUES ('400', '谁敢挡', '1');
INSERT INTO `robot_name` VALUES ('401', '爽儿', '1');
INSERT INTO `robot_name` VALUES ('402', '双双他爹', '1');
INSERT INTO `robot_name` VALUES ('403', '双龙管业', '1');
INSERT INTO `robot_name` VALUES ('404', '帅锅', '0');
INSERT INTO `robot_name` VALUES ('405', '帅的被人砍', '0');
INSERT INTO `robot_name` VALUES ('406', '舒雅', '1');
INSERT INTO `robot_name` VALUES ('407', '舒跟夏天的甜蜜', '0');
INSERT INTO `robot_name` VALUES ('408', '书记', '1');
INSERT INTO `robot_name` VALUES ('409', '守望廊桥', '1');
INSERT INTO `robot_name` VALUES ('410', '誓约我和你', '1');
INSERT INTO `robot_name` VALUES ('411', '嗜神之主', '1');
INSERT INTO `robot_name` VALUES ('412', '实现梦想', '1');
INSERT INTO `robot_name` VALUES ('413', '时慧宝', '1');
INSERT INTO `robot_name` VALUES ('414', '石头', '0');
INSERT INTO `robot_name` VALUES ('415', '十指紧扣', '0');
INSERT INTO `robot_name` VALUES ('416', '失意', '0');
INSERT INTO `robot_name` VALUES ('417', '失落C凡尘', '1');
INSERT INTO `robot_name` VALUES ('418', '胜者为王廖贤光', '0');
INSERT INTO `robot_name` VALUES ('419', '圣骑斗士', '0');
INSERT INTO `robot_name` VALUES ('420', '生死与共', '1');
INSERT INTO `robot_name` VALUES ('421', '神码都是浮云', '1');
INSERT INTO `robot_name` VALUES ('422', '神兵小将', '1');
INSERT INTO `robot_name` VALUES ('423', '什么事别往心里去', '0');
INSERT INTO `robot_name` VALUES ('424', '深巷的猫与魂', '0');
INSERT INTO `robot_name` VALUES ('425', '舍我其谁', '0');
INSERT INTO `robot_name` VALUES ('426', '舍得', '0');
INSERT INTO `robot_name` VALUES ('427', '韶雨真', '1');
INSERT INTO `robot_name` VALUES ('428', '尚子淇', '0');
INSERT INTO `robot_name` VALUES ('429', '上三下五', '0');
INSERT INTO `robot_name` VALUES ('430', '上官', '1');
INSERT INTO `robot_name` VALUES ('431', '上车走吧', '1');
INSERT INTO `robot_name` VALUES ('432', '上班族', '0');
INSERT INTO `robot_name` VALUES ('433', '伤心流泪', '0');
INSERT INTO `robot_name` VALUES ('434', '珊儿', '1');
INSERT INTO `robot_name` VALUES ('435', '傻妞来袭', '1');
INSERT INTO `robot_name` VALUES ('436', '傻i', '0');
INSERT INTO `robot_name` VALUES ('437', '啥都不管', '1');
INSERT INTO `robot_name` VALUES ('438', '沙贞', '0');
INSERT INTO `robot_name` VALUES ('439', '杀手来了2', '1');
INSERT INTO `robot_name` VALUES ('440', '杀犬', '0');
INSERT INTO `robot_name` VALUES ('441', '森林狼', '1');
INSERT INTO `robot_name` VALUES ('442', '色彩魅力', '0');
INSERT INTO `robot_name` VALUES ('443', '散兵', '0');
INSERT INTO `robot_name` VALUES ('444', '三爷', '0');
INSERT INTO `robot_name` VALUES ('445', '三鑫哥', '0');
INSERT INTO `robot_name` VALUES ('446', '三丿马子丶', '1');
INSERT INTO `robot_name` VALUES ('447', '三宝美女', '1');
INSERT INTO `robot_name` VALUES ('448', '若旖旎', '1');
INSERT INTO `robot_name` VALUES ('449', '若曦', '1');
INSERT INTO `robot_name` VALUES ('450', '瑞兴', '1');
INSERT INTO `robot_name` VALUES ('451', '蕊蕊', '1');
INSERT INTO `robot_name` VALUES ('452', '乳此动人', '1');
INSERT INTO `robot_name` VALUES ('453', '如烟漠漠', '1');
INSERT INTO `robot_name` VALUES ('454', '如薇', '1');
INSERT INTO `robot_name` VALUES ('455', '如果云知道', '0');
INSERT INTO `robot_name` VALUES ('456', '镕千古留名', '1');
INSERT INTO `robot_name` VALUES ('457', '日不落帝国成人', '0');
INSERT INTO `robot_name` VALUES ('458', '任天宇', '0');
INSERT INTO `robot_name` VALUES ('459', '任天晴', '0');
INSERT INTO `robot_name` VALUES ('460', '忍者之刃', '1');
INSERT INTO `robot_name` VALUES ('461', '忍者魔刃', '0');
INSERT INTO `robot_name` VALUES ('462', '忍者魔剑', '0');
INSERT INTO `robot_name` VALUES ('463', '忍者光刃', '1');
INSERT INTO `robot_name` VALUES ('464', '人之初', '0');
INSERT INTO `robot_name` VALUES ('465', '人笙偌隻洳處見', '1');
INSERT INTO `robot_name` VALUES ('466', '人生几何332233', '1');
INSERT INTO `robot_name` VALUES ('467', '人生', '0');
INSERT INTO `robot_name` VALUES ('468', '人间冷暖', '1');
INSERT INTO `robot_name` VALUES ('469', '群雄地主', '1');
INSERT INTO `robot_name` VALUES ('470', '泉水叮咚', '1');
INSERT INTO `robot_name` VALUES ('471', '全部是炸弹和火箭', '1');
INSERT INTO `robot_name` VALUES ('472', '屈向雪', '1');
INSERT INTO `robot_name` VALUES ('473', '邱芝明', '0');
INSERT INTO `robot_name` VALUES ('474', '晴天娃娃', '0');
INSERT INTO `robot_name` VALUES ('475', '晴天龙哥', '1');
INSERT INTO `robot_name` VALUES ('476', '情兽', '1');
INSERT INTO `robot_name` VALUES ('477', '情人', '1');
INSERT INTO `robot_name` VALUES ('478', '情定虹', '0');
INSERT INTO `robot_name` VALUES ('479', '青青菩提树', '1');
INSERT INTO `robot_name` VALUES ('480', '青青河边草', '0');
INSERT INTO `robot_name` VALUES ('481', '秦王豪爷', '1');
INSERT INTO `robot_name` VALUES ('482', '秦海', '1');
INSERT INTO `robot_name` VALUES ('483', '亲爱Di国Ge', '1');
INSERT INTO `robot_name` VALUES ('484', '茄子5188', '0');
INSERT INTO `robot_name` VALUES ('485', '强哥哥II', '0');
INSERT INTO `robot_name` VALUES ('486', '枪花', '0');
INSERT INTO `robot_name` VALUES ('487', '倩倩', '1');
INSERT INTO `robot_name` VALUES ('488', '千年等一回', '1');
INSERT INTO `robot_name` VALUES ('489', '千亩葡萄园', '1');
INSERT INTO `robot_name` VALUES ('490', '气死我了', '1');
INSERT INTO `robot_name` VALUES ('491', '启瑞', '1');
INSERT INTO `robot_name` VALUES ('492', '骑驴赶马', '1');
INSERT INTO `robot_name` VALUES ('493', '期盼', '0');
INSERT INTO `robot_name` VALUES ('494', '戚戚', '1');
INSERT INTO `robot_name` VALUES ('495', '戚灵松', '1');
INSERT INTO `robot_name` VALUES ('496', '七月飞雪', '0');
INSERT INTO `robot_name` VALUES ('497', '蒲公英', '0');
INSERT INTO `robot_name` VALUES ('498', '扑克', '1');
INSERT INTO `robot_name` VALUES ('499', '萍波永久1314', '0');
INSERT INTO `robot_name` VALUES ('500', '苹果', '1');
INSERT INTO `robot_name` VALUES ('501', '平凡', '0');
INSERT INTO `robot_name` VALUES ('502', '拼死的鱼', '0');
INSERT INTO `robot_name` VALUES ('503', '飘雪', '1');
INSERT INTO `robot_name` VALUES ('504', '骗子傻子白痴', '0');
INSERT INTO `robot_name` VALUES ('505', '骗我死全家', '1');
INSERT INTO `robot_name` VALUES ('506', '痞子', '1');
INSERT INTO `robot_name` VALUES ('507', '琵琶', '0');
INSERT INTO `robot_name` VALUES ('508', '泡妞哥', '1');
INSERT INTO `robot_name` VALUES ('509', '胖子', '0');
INSERT INTO `robot_name` VALUES ('510', '潘世鑫', '1');
INSERT INTO `robot_name` VALUES ('511', '牌友', '0');
INSERT INTO `robot_name` VALUES ('512', '牌霸', '1');
INSERT INTO `robot_name` VALUES ('513', '趴着爽', '1');
INSERT INTO `robot_name` VALUES ('514', '钕人', '1');
INSERT INTO `robot_name` VALUES ('515', '女汉子斗地主', '0');
INSERT INTO `robot_name` VALUES ('516', '钮曼香', '0');
INSERT INTO `robot_name` VALUES ('517', '牛魔王猪猪猪', '0');
INSERT INTO `robot_name` VALUES ('518', '牛魔王啧啧啧', '0');
INSERT INTO `robot_name` VALUES ('519', '牛魔王有意义', '1');
INSERT INTO `robot_name` VALUES ('520', '牛魔王哟哟哟', '0');
INSERT INTO `robot_name` VALUES ('521', '牛魔王摇一摇', '0');
INSERT INTO `robot_name` VALUES ('522', '牛魔王嘻嘻嘻', '0');
INSERT INTO `robot_name` VALUES ('523', '牛魔王嘻嘻', '0');
INSERT INTO `robot_name` VALUES ('524', '牛魔王哇哇哇', '0');
INSERT INTO `robot_name` VALUES ('525', '牛魔王头痛痛', '1');
INSERT INTO `robot_name` VALUES ('526', '牛魔王婷婷', '0');
INSERT INTO `robot_name` VALUES ('527', '牛魔王跳跳糖', '0');
INSERT INTO `robot_name` VALUES ('528', '牛魔王三十岁', '0');
INSERT INTO `robot_name` VALUES ('529', '牛魔王揉揉如', '1');
INSERT INTO `robot_name` VALUES ('530', '牛魔王人人人', '1');
INSERT INTO `robot_name` VALUES ('531', '牛魔王去去去', '1');
INSERT INTO `robot_name` VALUES ('532', '牛魔王亲亲亲', '0');
INSERT INTO `robot_name` VALUES ('533', '牛魔王呸呸呸', '0');
INSERT INTO `robot_name` VALUES ('534', '牛魔王啪啪啪', '1');
INSERT INTO `robot_name` VALUES ('535', '牛魔王你你你', '1');
INSERT INTO `robot_name` VALUES ('536', '牛魔王某某某', '0');
INSERT INTO `robot_name` VALUES ('537', '牛魔王喵喵喵', '0');
INSERT INTO `robot_name` VALUES ('538', '牛魔王快快快', '0');
INSERT INTO `robot_name` VALUES ('539', '牛魔王可可', '0');
INSERT INTO `robot_name` VALUES ('540', '牛魔王咔咔咔', '0');
INSERT INTO `robot_name` VALUES ('541', '牛魔王歼击机', '1');
INSERT INTO `robot_name` VALUES ('542', '牛魔王嘿嘿嘿', '1');
INSERT INTO `robot_name` VALUES ('543', '牛魔王呵呵呵', '0');
INSERT INTO `robot_name` VALUES ('544', '牛魔王行行行', '0');
INSERT INTO `robot_name` VALUES ('545', '牛魔王滚滚滚', '0');
INSERT INTO `robot_name` VALUES ('546', '牛魔王哥哥', '1');
INSERT INTO `robot_name` VALUES ('547', '牛魔王嘎嘎嘎', '1');
INSERT INTO `robot_name` VALUES ('548', '牛魔王凤飞飞', '1');
INSERT INTO `robot_name` VALUES ('549', '牛魔王放放风', '0');
INSERT INTO `robot_name` VALUES ('550', '牛魔王烦烦烦', '0');
INSERT INTO `robot_name` VALUES ('551', '牛魔王呃呃呃', '1');
INSERT INTO `robot_name` VALUES ('552', '牛魔王对对对', '0');
INSERT INTO `robot_name` VALUES ('553', '牛魔王弟弟', '0');
INSERT INTO `robot_name` VALUES ('554', '牛魔王大大的', '0');
INSERT INTO `robot_name` VALUES ('555', '牛魔王出差', '1');
INSERT INTO `robot_name` VALUES ('556', '牛魔王啵啵啵', '1');
INSERT INTO `robot_name` VALUES ('557', '牛魔王啊啊啊', '0');
INSERT INTO `robot_name` VALUES ('558', '牛魔王VVV', '1');
INSERT INTO `robot_name` VALUES ('559', '牛魔王VV', '1');
INSERT INTO `robot_name` VALUES ('560', '牛魔王UUU', '0');
INSERT INTO `robot_name` VALUES ('561', '牛魔王III', '0');
INSERT INTO `robot_name` VALUES ('562', '牛歌小宝贝', '0');
INSERT INTO `robot_name` VALUES ('563', '牛初蓝', '0');
INSERT INTO `robot_name` VALUES ('564', '宁梦君', '0');
INSERT INTO `robot_name` VALUES ('565', '宁凡儿', '0');
INSERT INTO `robot_name` VALUES ('566', '聂艳一', '0');
INSERT INTO `robot_name` VALUES ('567', '逆天大圣', '0');
INSERT INTO `robot_name` VALUES ('568', '你爷爷哟', '0');
INSERT INTO `robot_name` VALUES ('569', '你们这些煞笔', '0');
INSERT INTO `robot_name` VALUES ('570', '你妈的群', '0');
INSERT INTO `robot_name` VALUES ('571', '你来我往', '0');
INSERT INTO `robot_name` VALUES ('572', '你好多', '1');
INSERT INTO `robot_name` VALUES ('573', '你好liumkjuo', '1');
INSERT INTO `robot_name` VALUES ('574', '你的网名为谁写', '0');
INSERT INTO `robot_name` VALUES ('575', '你大爷熊伟', '0');
INSERT INTO `robot_name` VALUES ('576', '你大爷乞千', '0');
INSERT INTO `robot_name` VALUES ('577', '你吖', '0');
INSERT INTO `robot_name` VALUES ('578', '南宁人', '1');
INSERT INTO `robot_name` VALUES ('579', '奈何', '1');
INSERT INTO `robot_name` VALUES ('580', '奶奶的熊', '0');
INSERT INTO `robot_name` VALUES ('581', '那沫陽光', '0');
INSERT INTO `robot_name` VALUES ('582', '那么历害', '1');
INSERT INTO `robot_name` VALUES ('583', '那里景色彩虹', '0');
INSERT INTO `robot_name` VALUES ('584', '慕容欣', '1');
INSERT INTO `robot_name` VALUES ('585', '牧天玉', '1');
INSERT INTO `robot_name` VALUES ('586', '木里宁静', '0');
INSERT INTO `robot_name` VALUES ('587', '谋谟帷幄', '1');
INSERT INTO `robot_name` VALUES ('588', '漠颜', '1');
INSERT INTO `robot_name` VALUES ('589', '莫惜天', '0');
INSERT INTO `robot_name` VALUES ('590', '莫陌', '0');
INSERT INTO `robot_name` VALUES ('591', '摩羯座', '1');
INSERT INTO `robot_name` VALUES ('592', '尛斌', '0');
INSERT INTO `robot_name` VALUES ('593', '缪忆曼', '0');
INSERT INTO `robot_name` VALUES ('594', '命运的错误', '1');
INSERT INTO `robot_name` VALUES ('595', '明星同乐会', '1');
INSERT INTO `robot_name` VALUES ('596', '名胜世界', '0');
INSERT INTO `robot_name` VALUES ('597', '名人', '0');
INSERT INTO `robot_name` VALUES ('598', '闵又槐', '0');
INSERT INTO `robot_name` VALUES ('599', '幂衂', '0');
INSERT INTO `robot_name` VALUES ('600', '宓语芙', '0');
INSERT INTO `robot_name` VALUES ('601', '宓盈', '0');
INSERT INTO `robot_name` VALUES ('602', '觅途瑶', '0');
INSERT INTO `robot_name` VALUES ('603', '米娜', '0');
INSERT INTO `robot_name` VALUES ('604', '米粒儿', '1');
INSERT INTO `robot_name` VALUES ('605', '糜颜演', '1');
INSERT INTO `robot_name` VALUES ('606', '迷上了雪儿', '0');
INSERT INTO `robot_name` VALUES ('607', '梦换才宝宝', '1');
INSERT INTO `robot_name` VALUES ('608', '梦幻心语', '0');
INSERT INTO `robot_name` VALUES ('609', '梦幻精灵', '1');
INSERT INTO `robot_name` VALUES ('610', '梦幻彩虹', '0');
INSERT INTO `robot_name` VALUES ('611', '孟诗翠', '0');
INSERT INTO `robot_name` VALUES ('612', '萌萌达PHJ', '0');
INSERT INTO `robot_name` VALUES ('613', '萌萌柴', '0');
INSERT INTO `robot_name` VALUES ('614', '妹子来了', '1');
INSERT INTO `robot_name` VALUES ('615', '妹子加1105893592', '1');
INSERT INTO `robot_name` VALUES ('616', '美女枪花', '1');
INSERT INTO `robot_name` VALUES ('617', '美女回来了', '1');
INSERT INTO `robot_name` VALUES ('618', '美女抱', '1');
INSERT INTO `robot_name` VALUES ('619', '美猴王', '1');
INSERT INTO `robot_name` VALUES ('620', '每次要赢都断线', '1');
INSERT INTO `robot_name` VALUES ('621', '每次必胜', '0');
INSERT INTO `robot_name` VALUES ('622', '梅幸福女人', '0');
INSERT INTO `robot_name` VALUES ('623', '没事斗两把', '0');
INSERT INTO `robot_name` VALUES ('624', '没什么大不了', '1');
INSERT INTO `robot_name` VALUES ('625', '么鄂', '1');
INSERT INTO `robot_name` VALUES ('626', '猫咪西施霸王', '1');
INSERT INTO `robot_name` VALUES ('627', '猫咪咪', '0');
INSERT INTO `robot_name` VALUES ('628', '慢半拍', '0');
INSERT INTO `robot_name` VALUES ('629', '麦梓', '0');
INSERT INTO `robot_name` VALUES ('630', '麦多公主', '1');
INSERT INTO `robot_name` VALUES ('631', '马到功成', '1');
INSERT INTO `robot_name` VALUES ('632', '马13529048672', '0');
INSERT INTO `robot_name` VALUES ('633', '麻雀游神', '0');
INSERT INTO `robot_name` VALUES ('634', '落幕飞雪1', '1');
INSERT INTO `robot_name` VALUES ('635', '落幕的飞雪', '0');
INSERT INTO `robot_name` VALUES ('636', '罗兰', '1');
INSERT INTO `robot_name` VALUES ('637', '罗金兰ljl', '0');
INSERT INTO `robot_name` VALUES ('638', '罗大脚', '1');
INSERT INTO `robot_name` VALUES ('639', '路丝雨', '0');
INSERT INTO `robot_name` VALUES ('640', '路路', '0');
INSERT INTO `robot_name` VALUES ('641', '陆贞', '0');
INSERT INTO `robot_name` VALUES ('642', '龙跃', '0');
INSERT INTO `robot_name` VALUES ('643', '龙泉虎', '0');
INSERT INTO `robot_name` VALUES ('644', '龙景湾', '0');
INSERT INTO `robot_name` VALUES ('645', '龙回头', '0');
INSERT INTO `robot_name` VALUES ('646', '龙行天涯', '0');
INSERT INTO `robot_name` VALUES ('647', '龙15707531624', '0');
INSERT INTO `robot_name` VALUES ('648', '六六一一天天', '1');
INSERT INTO `robot_name` VALUES ('649', '六六六九九九999', '0');
INSERT INTO `robot_name` VALUES ('650', '六六', '1');
INSERT INTO `robot_name` VALUES ('651', '流萤心悸', '0');
INSERT INTO `robot_name` VALUES ('652', '流氓大哥', '1');
INSERT INTO `robot_name` VALUES ('653', '留在明天用', '1');
INSERT INTO `robot_name` VALUES ('654', '刘莫邪', '1');
INSERT INTO `robot_name` VALUES ('655', '刘军', '0');
INSERT INTO `robot_name` VALUES ('656', '刘2511882103', '0');
INSERT INTO `robot_name` VALUES ('657', '零零八', '1');
INSERT INTO `robot_name` VALUES ('658', '凌煊', '0');
INSERT INTO `robot_name` VALUES ('659', '玲珑儿', '0');
INSERT INTO `robot_name` VALUES ('660', '灵犀剑', '0');
INSERT INTO `robot_name` VALUES ('661', '灵幻幽魔', '1');
INSERT INTO `robot_name` VALUES ('662', '林总', '0');
INSERT INTO `robot_name` VALUES ('663', '林少爷', '0');
INSERT INTO `robot_name` VALUES ('664', '林家二少', '1');
INSERT INTO `robot_name` VALUES ('665', '林洪', '1');
INSERT INTO `robot_name` VALUES ('666', '邻家小伙', '0');
INSERT INTO `robot_name` VALUES ('667', '廖寻凝', '0');
INSERT INTO `robot_name` VALUES ('668', '亮蛋很亮', '0');
INSERT INTO `robot_name` VALUES ('669', '啢両', '0');
INSERT INTO `robot_name` VALUES ('670', '梁家公子丶', '1');
INSERT INTO `robot_name` VALUES ('671', '梁翠月', '0');
INSERT INTO `robot_name` VALUES ('672', '凉城薄梦', '0');
INSERT INTO `robot_name` VALUES ('673', '恋恋不忘', '0');
INSERT INTO `robot_name` VALUES ('674', '丽丽丽', '1');
INSERT INTO `robot_name` VALUES ('675', '丽丽llili', '0');
INSERT INTO `robot_name` VALUES ('676', '丽儿', '1');
INSERT INTO `robot_name` VALUES ('677', '理解', '1');
INSERT INTO `robot_name` VALUES ('678', '李总521', '1');
INSERT INTO `robot_name` VALUES ('679', '李志强', '1');
INSERT INTO `robot_name` VALUES ('680', '李志芳mm', '0');
INSERT INTO `robot_name` VALUES ('681', '李者sss', '1');
INSERT INTO `robot_name` VALUES ('682', '李小米', '1');
INSERT INTO `robot_name` VALUES ('683', '李小欢', '0');
INSERT INTO `robot_name` VALUES ('684', '李丹', '1');
INSERT INTO `robot_name` VALUES ('685', '李088921', '0');
INSERT INTO `robot_name` VALUES ('686', '雷紫安', '0');
INSERT INTO `robot_name` VALUES ('687', '雷靖仇', '1');
INSERT INTO `robot_name` VALUES ('688', '乐正尔曼', '1');
INSERT INTO `robot_name` VALUES ('689', '乐乐领悟', '0');
INSERT INTO `robot_name` VALUES ('690', '老子不会玩', '1');
INSERT INTO `robot_name` VALUES ('691', '老子', '1');
INSERT INTO `robot_name` VALUES ('692', '老王', '0');
INSERT INTO `robot_name` VALUES ('693', '老太', '0');
INSERT INTO `robot_name` VALUES ('694', '老苏', '0');
INSERT INTO `robot_name` VALUES ('695', '老四', '1');
INSERT INTO `robot_name` VALUES ('696', '老是shu', '0');
INSERT INTO `robot_name` VALUES ('697', '老三', '0');
INSERT INTO `robot_name` VALUES ('698', '老男人呀', '0');
INSERT INTO `robot_name` VALUES ('699', '老鹤', '1');
INSERT INTO `robot_name` VALUES ('700', '老郭的生活', '1');
INSERT INTO `robot_name` VALUES ('701', '老地主', '0');
INSERT INTO `robot_name` VALUES ('702', '老大哥', '1');
INSERT INTO `robot_name` VALUES ('703', '狼人', '1');
INSERT INTO `robot_name` VALUES ('704', '烂泥', '1');
INSERT INTO `robot_name` VALUES ('705', '蓝色的天空', '1');
INSERT INTO `robot_name` VALUES ('706', '蓝魔', '1');
INSERT INTO `robot_name` VALUES ('707', '蓝兰', '0');
INSERT INTO `robot_name` VALUES ('708', '蓝飞宇', '0');
INSERT INTO `robot_name` VALUES ('709', '兰兰', '0');
INSERT INTO `robot_name` VALUES ('710', '赖上你的微笑', '0');
INSERT INTO `robot_name` VALUES ('711', '來吧孫兒', '1');
INSERT INTO `robot_name` VALUES ('712', '来世相恋', '0');
INSERT INTO `robot_name` VALUES ('713', '来美女', '1');
INSERT INTO `robot_name` VALUES ('714', '来了来了来了了来了', '1');
INSERT INTO `robot_name` VALUES ('715', '来啦', '1');
INSERT INTO `robot_name` VALUES ('716', '狂野男人', '0');
INSERT INTO `robot_name` VALUES ('717', '狂龙123', '1');
INSERT INTO `robot_name` VALUES ('718', '狂干美妹', '0');
INSERT INTO `robot_name` VALUES ('719', '快一点你们', '1');
INSERT INTO `robot_name` VALUES ('720', '快乐小燕子', '0');
INSERT INTO `robot_name` VALUES ('721', '快乐生活', '1');
INSERT INTO `robot_name` VALUES ('722', '快乐回到原点', '0');
INSERT INTO `robot_name` VALUES ('723', '快乐的玩玩', '0');
INSERT INTO `robot_name` VALUES ('724', '快乐的梦想', '1');
INSERT INTO `robot_name` VALUES ('725', '快乐宝贝', '1');
INSERT INTO `robot_name` VALUES ('726', '胯下有神器丶', '1');
INSERT INTO `robot_name` VALUES ('727', '哭泣的恶魔', '1');
INSERT INTO `robot_name` VALUES ('728', '哭了', '0');
INSERT INTO `robot_name` VALUES ('729', '铿锵', '1');
INSERT INTO `robot_name` VALUES ('730', '克隆', '0');
INSERT INTO `robot_name` VALUES ('731', '可怜人', '0');
INSERT INTO `robot_name` VALUES ('732', '可爱美少女', '0');
INSERT INTO `robot_name` VALUES ('733', '可爱的家', '1');
INSERT INTO `robot_name` VALUES ('734', '柯誉', '1');
INSERT INTO `robot_name` VALUES ('735', '柯夏云', '1');
INSERT INTO `robot_name` VALUES ('736', '柯若菱', '1');
INSERT INTO `robot_name` VALUES ('737', '看我表情你就炸', '1');
INSERT INTO `robot_name` VALUES ('738', '恺撒', '1');
INSERT INTO `robot_name` VALUES ('739', '凯伦', '1');
INSERT INTO `robot_name` VALUES ('740', '凯凯mm', '1');
INSERT INTO `robot_name` VALUES ('741', '开心果来了', '1');
INSERT INTO `robot_name` VALUES ('742', '开卜卜心', '1');
INSERT INTO `robot_name` VALUES ('743', '浚燕', '0');
INSERT INTO `robot_name` VALUES ('744', '军歌嘹亮', '1');
INSERT INTO `robot_name` VALUES ('745', '卷发美女', '1');
INSERT INTO `robot_name` VALUES ('746', '娟娟jz', '0');
INSERT INTO `robot_name` VALUES ('747', '菊花康', '0');
INSERT INTO `robot_name` VALUES ('748', '就好干', '1');
INSERT INTO `robot_name` VALUES ('749', '酒鬼', '0');
INSERT INTO `robot_name` VALUES ('750', '九儿家爸爸', '0');
INSERT INTO `robot_name` VALUES ('751', '静享人生', '0');
INSERT INTO `robot_name` VALUES ('752', '静儿', '0');
INSERT INTO `robot_name` VALUES ('753', '静等桃花开', '0');
INSERT INTO `robot_name` VALUES ('754', '景非笑', '1');
INSERT INTO `robot_name` VALUES ('755', '晶晶姐姐', '1');
INSERT INTO `robot_name` VALUES ('756', '晶晶的妈', '1');
INSERT INTO `robot_name` VALUES ('757', '惊魂野马', '0');
INSERT INTO `robot_name` VALUES ('758', '京哥', '0');
INSERT INTO `robot_name` VALUES ('759', '尽在娱乐', '0');
INSERT INTO `robot_name` VALUES ('760', '金莎', '0');
INSERT INTO `robot_name` VALUES ('761', '金色海岸', '1');
INSERT INTO `robot_name` VALUES ('762', '金金子', '0');
INSERT INTO `robot_name` VALUES ('763', '金国水', '0');
INSERT INTO `robot_name` VALUES ('764', '姐弟恋', '0');
INSERT INTO `robot_name` VALUES ('765', '江南美人鱼', '0');
INSERT INTO `robot_name` VALUES ('766', '江湖', '0');
INSERT INTO `robot_name` VALUES ('767', '剑哥', '1');
INSERT INTO `robot_name` VALUES ('768', '简单爱', '0');
INSERT INTO `robot_name` VALUES ('769', '坚强', '0');
INSERT INTO `robot_name` VALUES ('770', '假正经', '1');
INSERT INTO `robot_name` VALUES ('771', '假面的微笑', '0');
INSERT INTO `robot_name` VALUES ('772', '贾谷蓝', '1');
INSERT INTO `robot_name` VALUES ('773', '佳佳520', '0');
INSERT INTO `robot_name` VALUES ('774', '加盟', '0');
INSERT INTO `robot_name` VALUES ('775', '季末流年88', '0');
INSERT INTO `robot_name` VALUES ('776', '极影狂人', '0');
INSERT INTO `robot_name` VALUES ('777', '吉利鞋材', '1');
INSERT INTO `robot_name` VALUES ('778', '吉代曼', '0');
INSERT INTO `robot_name` VALUES ('779', '嵇芷云', '1');
INSERT INTO `robot_name` VALUES ('780', '嵇傲儿', '0');
INSERT INTO `robot_name` VALUES ('781', '叽叽墨墨', '0');
INSERT INTO `robot_name` VALUES ('782', '火焱', '0');
INSERT INTO `robot_name` VALUES ('783', '火箭升空L', '1');
INSERT INTO `robot_name` VALUES ('784', '火箭', '0');
INSERT INTO `robot_name` VALUES ('785', '火狐花少', '0');
INSERT INTO `robot_name` VALUES ('786', '慧琳', '0');
INSERT INTO `robot_name` VALUES ('787', '回答以前', '1');
INSERT INTO `robot_name` VALUES ('788', '黄晓明', '1');
INSERT INTO `robot_name` VALUES ('789', '黄靖哲', '1');
INSERT INTO `robot_name` VALUES ('790', '黄家驹真的爱你', '1');
INSERT INTO `robot_name` VALUES ('791', '黄哥', '0');
INSERT INTO `robot_name` VALUES ('792', '黄飞红', '1');
INSERT INTO `robot_name` VALUES ('793', '黄安淇', '1');
INSERT INTO `robot_name` VALUES ('794', '皇后', '0');
INSERT INTO `robot_name` VALUES ('795', '焕然', '0');
INSERT INTO `robot_name` VALUES ('796', '坏坏男人', '1');
INSERT INTO `robot_name` VALUES ('797', '坏蛋', '1');
INSERT INTO `robot_name` VALUES ('798', '华中华', '0');
INSERT INTO `robot_name` VALUES ('799', '华隶', '1');
INSERT INTO `robot_name` VALUES ('800', '花心纠结', '0');
INSERT INTO `robot_name` VALUES ('801', '虎哥', '0');
INSERT INTO `robot_name` VALUES ('802', '蝴蝶飞', '1');
INSERT INTO `robot_name` VALUES ('803', '湖滨崎步', '0');
INSERT INTO `robot_name` VALUES ('804', '胡小炜', '1');
INSERT INTO `robot_name` VALUES ('805', '胡苏南', '0');
INSERT INTO `robot_name` VALUES ('806', '胡苏南', '0');
INSERT INTO `robot_name` VALUES ('807', '呼呼啦啦', '1');
INSERT INTO `robot_name` VALUES ('808', '猴子', '1');
INSERT INTO `robot_name` VALUES ('809', '洪泽汇', '0');
INSERT INTO `robot_name` VALUES ('810', '洪胜江', '1');
INSERT INTO `robot_name` VALUES ('811', '红线石', '0');
INSERT INTO `robot_name` VALUES ('812', '红尘鎄殇', '0');
INSERT INTO `robot_name` VALUES ('813', '恨你', '1');
INSERT INTO `robot_name` VALUES ('814', '嗨15987041304', '0');
INSERT INTO `robot_name` VALUES ('815', '黑嗨鸡', '1');
INSERT INTO `robot_name` VALUES ('816', '和平', '1');
INSERT INTO `robot_name` VALUES ('817', '浩轩博', '0');
INSERT INTO `robot_name` VALUES ('818', '耗子', '1');
INSERT INTO `robot_name` VALUES ('819', '郝先生', '1');
INSERT INTO `robot_name` VALUES ('820', '好运会有地', '0');
INSERT INTO `robot_name` VALUES ('821', '好想找个男朋友噢', '1');
INSERT INTO `robot_name` VALUES ('822', '好然然', '0');
INSERT INTO `robot_name` VALUES ('823', '好男不跟女斗', '0');
INSERT INTO `robot_name` VALUES ('824', '好吗', '1');
INSERT INTO `robot_name` VALUES ('825', '好好想你', '1');
INSERT INTO `robot_name` VALUES ('826', '好败者', '0');
INSERT INTO `robot_name` VALUES ('827', '好啊', '1');
INSERT INTO `robot_name` VALUES ('828', '航姐', '1');
INSERT INTO `robot_name` VALUES ('829', '行找钱偶', '1');
INSERT INTO `robot_name` VALUES ('830', '海星', '1');
INSERT INTO `robot_name` VALUES ('831', '海田沧桑', '1');
INSERT INTO `robot_name` VALUES ('832', '海哥的忧伤', '1');
INSERT INTO `robot_name` VALUES ('833', '国王万岁', '0');
INSERT INTO `robot_name` VALUES ('834', '国产小钢炮', '0');
INSERT INTO `robot_name` VALUES ('835', '郭浩460807', '1');
INSERT INTO `robot_name` VALUES ('836', '龟头正红', '0');
INSERT INTO `robot_name` VALUES ('837', '圭圭', '1');
INSERT INTO `robot_name` VALUES ('838', '广州车展', '0');
INSERT INTO `robot_name` VALUES ('839', '光星', '0');
INSERT INTO `robot_name` VALUES ('840', '光头佬', '0');
INSERT INTO `robot_name` VALUES ('841', '顾倾城', '0');
INSERT INTO `robot_name` VALUES ('842', '顾客就是上帝', '1');
INSERT INTO `robot_name` VALUES ('843', '谷粱惜筠', '1');
INSERT INTO `robot_name` VALUES ('844', '古乐天', '0');
INSERT INTO `robot_name` VALUES ('845', '孤影', '1');
INSERT INTO `robot_name` VALUES ('846', '孤独剑', '0');
INSERT INTO `robot_name` VALUES ('847', '咕噜', '0');
INSERT INTO `robot_name` VALUES ('848', '公主殿下', '0');
INSERT INTO `robot_name` VALUES ('849', '工头又叫我搬砖了', '1');
INSERT INTO `robot_name` VALUES ('850', '工程机械', '0');
INSERT INTO `robot_name` VALUES ('851', '跟着自己的心走', '0');
INSERT INTO `robot_name` VALUES ('852', '给爷笑一个', '0');
INSERT INTO `robot_name` VALUES ('853', '给爷乐一个', '0');
INSERT INTO `robot_name` VALUES ('854', '给未来的自己8', '1');
INSERT INTO `robot_name` VALUES ('855', '隔壁老王', '1');
INSERT INTO `robot_name` VALUES ('856', '格格吉祥2007827', '1');
INSERT INTO `robot_name` VALUES ('857', '哥斯拉2014', '0');
INSERT INTO `robot_name` VALUES ('858', '哥是王者', '1');
INSERT INTO `robot_name` VALUES ('859', '哥来赐你一死', '0');
INSERT INTO `robot_name` VALUES ('860', '哥就是个传说', '1');
INSERT INTO `robot_name` VALUES ('861', '哥哥波', '0');
INSERT INTO `robot_name` VALUES ('862', '哥的情伤', '1');
INSERT INTO `robot_name` VALUES ('863', '哥不是高富帅', '0');
INSERT INTO `robot_name` VALUES ('864', '高冬花我爱你', '1');
INSERT INTO `robot_name` VALUES ('865', '钢铁洪流', '0');
INSERT INTO `robot_name` VALUES ('866', '刚好', '0');
INSERT INTO `robot_name` VALUES ('867', '刚哥', '0');
INSERT INTO `robot_name` VALUES ('868', '干死你个鸟人', '0');
INSERT INTO `robot_name` VALUES ('869', '橄榄绿', '1');
INSERT INTO `robot_name` VALUES ('870', '感慨倪gj', '0');
INSERT INTO `robot_name` VALUES ('871', '甘苦', '1');
INSERT INTO `robot_name` VALUES ('872', '富豪', '0');
INSERT INTO `robot_name` VALUES ('873', '佛之缘', '1');
INSERT INTO `robot_name` VALUES ('874', '逢赌必贏', '1');
INSERT INTO `robot_name` VALUES ('875', '冯骥才', '1');
INSERT INTO `robot_name` VALUES ('876', '疯子哥', '0');
INSERT INTO `robot_name` VALUES ('877', '疯狂宝贝', '1');
INSERT INTO `robot_name` VALUES ('878', '风中浪子', '1');
INSERT INTO `robot_name` VALUES ('879', '风云乍起', '0');
INSERT INTO `robot_name` VALUES ('880', '风雨同舟', '0');
INSERT INTO `robot_name` VALUES ('881', '风一样的男子', '0');
INSERT INTO `robot_name` VALUES ('882', '风一样的', '1');
INSERT INTO `robot_name` VALUES ('883', '风花雪月', '0');
INSERT INTO `robot_name` VALUES ('884', '风儿', '1');
INSERT INTO `robot_name` VALUES ('885', '风吹裤裆蛋蛋凉', '0');
INSERT INTO `robot_name` VALUES ('886', '奋斗', '0');
INSERT INTO `robot_name` VALUES ('887', '费中道', '0');
INSERT INTO `robot_name` VALUES ('888', '费以冬', '1');
INSERT INTO `robot_name` VALUES ('889', '非你莫属', '0');
INSERT INTO `robot_name` VALUES ('890', '飞翔的梦', '1');
INSERT INTO `robot_name` VALUES ('891', '飞龙在天', '1');
INSERT INTO `robot_name` VALUES ('892', '飞龙', '1');
INSERT INTO `robot_name` VALUES ('893', '芳名草丽', '0');
INSERT INTO `robot_name` VALUES ('894', '方鹏涛', '0');
INSERT INTO `robot_name` VALUES ('895', '繁华落尽s', '1');
INSERT INTO `robot_name` VALUES ('896', '发短信火锅', '0');
INSERT INTO `robot_name` VALUES ('897', '发财哥', '1');
INSERT INTO `robot_name` VALUES ('898', '恩泽爱晶晶', '0');
INSERT INTO `robot_name` VALUES ('899', '恶魔界', '0');
INSERT INTO `robot_name` VALUES ('900', '额无奈了', '1');
INSERT INTO `robot_name` VALUES ('901', '对酒当歌人生几何', '1');
INSERT INTO `robot_name` VALUES ('902', '度龟', '1');
INSERT INTO `robot_name` VALUES ('903', '赌王呵呵', '1');
INSERT INTO `robot_name` VALUES ('904', '赌神他爷', '1');
INSERT INTO `robot_name` VALUES ('905', '赌神发哥', '0');
INSERT INTO `robot_name` VALUES ('906', '赌怪', '0');
INSERT INTO `robot_name` VALUES ('907', '赌痴', '1');
INSERT INTO `robot_name` VALUES ('908', '独狼', '1');
INSERT INTO `robot_name` VALUES ('909', '独行者', '0');
INSERT INTO `robot_name` VALUES ('910', '斗志齐天', '0');
INSERT INTO `robot_name` VALUES ('911', '斗战胜佛', '0');
INSERT INTO `robot_name` VALUES ('912', '斗歪你', '1');
INSERT INTO `robot_name` VALUES ('913', '斗死你日', '1');
INSERT INTO `robot_name` VALUES ('914', '斗你没商量', '1');
INSERT INTO `robot_name` VALUES ('915', '斗眉美', '0');
INSERT INTO `robot_name` VALUES ('916', '斗地主挣钱', '0');
INSERT INTO `robot_name` VALUES ('917', '兜兜风升级', '1');
INSERT INTO `robot_name` VALUES ('918', '都給我跪下', '0');
INSERT INTO `robot_name` VALUES ('919', '董东', '0');
INSERT INTO `robot_name` VALUES ('920', '咚咚', '1');
INSERT INTO `robot_name` VALUES ('921', '冬天', '0');
INSERT INTO `robot_name` VALUES ('922', '冬瓜', '1');
INSERT INTO `robot_name` VALUES ('923', '东艳颖妍', '0');
INSERT INTO `robot_name` VALUES ('924', '顶死你', '1');
INSERT INTO `robot_name` VALUES ('925', '丁夏瑶', '0');
INSERT INTO `robot_name` VALUES ('926', '丁三颜', '0');
INSERT INTO `robot_name` VALUES ('927', '蝶影依默', '1');
INSERT INTO `robot_name` VALUES ('928', '钓鱼者', '1');
INSERT INTO `robot_name` VALUES ('929', '屌丝男', '1');
INSERT INTO `robot_name` VALUES ('930', '殿皇', '0');
INSERT INTO `robot_name` VALUES ('931', '蔕主之谊', '1');
INSERT INTO `robot_name` VALUES ('932', '蒂娜', '1');
INSERT INTO `robot_name` VALUES ('933', '地主重现', '1');
INSERT INTO `robot_name` VALUES ('934', '地主王123', '1');
INSERT INTO `robot_name` VALUES ('935', '地主天王', '1');
INSERT INTO `robot_name` VALUES ('936', '地主他爷爷', '0');
INSERT INTO `robot_name` VALUES ('937', '地主迷', '0');
INSERT INTO `robot_name` VALUES ('938', '地主大侠', '0');
INSERT INTO `robot_name` VALUES ('939', '地狱噬魂', '0');
INSERT INTO `robot_name` VALUES ('940', '地上走', '0');
INSERT INTO `robot_name` VALUES ('941', '邓荣强', '1');
INSERT INTO `robot_name` VALUES ('942', '等你', '0');
INSERT INTO `robot_name` VALUES ('943', '灯火阑珊', '0');
INSERT INTO `robot_name` VALUES ('944', '刀客8888', '1');
INSERT INTO `robot_name` VALUES ('945', '蛋蛋的忧伤', '0');
INSERT INTO `robot_name` VALUES ('946', '单晓丝', '1');
INSERT INTO `robot_name` VALUES ('947', '单身汉找老婆', '1');
INSERT INTO `robot_name` VALUES ('948', '带刺的玫瑰', '1');
INSERT INTO `robot_name` VALUES ('949', '大艺术家', '1');
INSERT INTO `robot_name` VALUES ('950', '大王是最力害的', '0');
INSERT INTO `robot_name` VALUES ('951', '大王来了', '1');
INSERT INTO `robot_name` VALUES ('952', '大头', '1');
INSERT INTO `robot_name` VALUES ('953', '大石头', '0');
INSERT INTO `robot_name` VALUES ('954', '大街', '1');
INSERT INTO `robot_name` VALUES ('955', '大海天空', '1');
INSERT INTO `robot_name` VALUES ('956', '打土豪', '1');
INSERT INTO `robot_name` VALUES ('957', '打牌不行不要上', '0');
INSERT INTO `robot_name` VALUES ('958', '打到地主', '0');
INSERT INTO `robot_name` VALUES ('959', '崔国军小雅', '1');
INSERT INTO `robot_name` VALUES ('960', '純情做作尼瑪隔壁', '0');
INSERT INTO `robot_name` VALUES ('961', '春天哥', '1');
INSERT INTO `robot_name` VALUES ('962', '春明不觉晓', '0');
INSERT INTO `robot_name` VALUES ('963', '床上你妹', '0');
INSERT INTO `robot_name` VALUES ('964', '传奇人物夜', '0');
INSERT INTO `robot_name` VALUES ('965', '出不去别乱炸', '0');
INSERT INTO `robot_name` VALUES ('966', '臭青蛙', '0');
INSERT INTO `robot_name` VALUES ('967', '崇霸', '0');
INSERT INTO `robot_name` VALUES ('968', '迟来的幸福', '0');
INSERT INTO `robot_name` VALUES ('969', '吃醋的天真', '1');
INSERT INTO `robot_name` VALUES ('970', '程天宇', '0');
INSERT INTO `robot_name` VALUES ('971', '铖铖', '1');
INSERT INTO `robot_name` VALUES ('972', '陈华wa1314520', '1');
INSERT INTO `robot_name` VALUES ('973', '沉世一', '1');
INSERT INTO `robot_name` VALUES ('974', '扯淡的人生', '1');
INSERT INTO `robot_name` VALUES ('975', '常胜将军', '0');
INSERT INTO `robot_name` VALUES ('976', '常来常往', '1');
INSERT INTO `robot_name` VALUES ('977', '肠子都悔青了', '0');
INSERT INTO `robot_name` VALUES ('978', '差不多先森', '0');
INSERT INTO `robot_name` VALUES ('979', '草要赢就卡', '0');
INSERT INTO `robot_name` VALUES ('980', '操尼玛', '0');
INSERT INTO `robot_name` VALUES ('981', '灿烂辉煌', '1');
INSERT INTO `robot_name` VALUES ('982', '残忍的我', '0');
INSERT INTO `robot_name` VALUES ('983', '彩虹世界', '1');
INSERT INTO `robot_name` VALUES ('984', '不要走', '0');
INSERT INTO `robot_name` VALUES ('985', '不要乱接牌', '1');
INSERT INTO `robot_name` VALUES ('986', '不要回头', '1');
INSERT INTO `robot_name` VALUES ('987', '不想赢', '1');
INSERT INTO `robot_name` VALUES ('988', '不死灬狂少', '1');
INSERT INTO `robot_name` VALUES ('989', '不怕', '1');
INSERT INTO `robot_name` VALUES ('990', '不离不弃913', '0');
INSERT INTO `robot_name` VALUES ('991', '不可开交', '0');
INSERT INTO `robot_name` VALUES ('992', '不和猪和作', '1');
INSERT INTO `robot_name` VALUES ('993', '不懂叫啥好', '1');
INSERT INTO `robot_name` VALUES ('994', '不曾赢过', '1');
INSERT INTO `robot_name` VALUES ('995', '不变的爱mnh', '1');
INSERT INTO `robot_name` VALUES ('996', '不爱你爱谁宝贝', '0');
INSERT INTO `robot_name` VALUES ('997', '兵果', '1');
INSERT INTO `robot_name` VALUES ('998', '冰银神王', '0');
INSERT INTO `robot_name` VALUES ('999', '冰兒', '0');
INSERT INTO `robot_name` VALUES ('1000', '冰点柔情aaa', '0');
INSERT INTO `robot_name` VALUES ('1001', '冰城浪子', '1');
INSERT INTO `robot_name` VALUES ('1002', '别样女儿红', '1');
INSERT INTO `robot_name` VALUES ('1003', '别跟俺抢地主', '0');
INSERT INTO `robot_name` VALUES ('1004', '别扯后腿', '0');
INSERT INTO `robot_name` VALUES ('1005', '笨蛋才斗地主', '1');
INSERT INTO `robot_name` VALUES ('1006', '笨笨的土豆', '1');
INSERT INTO `robot_name` VALUES ('1007', '本逢赌必赢', '1');
INSERT INTO `robot_name` VALUES ('1008', '背景象', '0');
INSERT INTO `robot_name` VALUES ('1009', '贝壳', '0');
INSERT INTO `robot_name` VALUES ('1010', '暴打地主', '0');
INSERT INTO `robot_name` VALUES ('1011', '鲍尔冬', '1');
INSERT INTO `robot_name` VALUES ('1012', '保爷', '1');
INSERT INTO `robot_name` VALUES ('1013', '宝贝宇航', '0');
INSERT INTO `robot_name` VALUES ('1014', '宝贝诚', '1');
INSERT INTO `robot_name` VALUES ('1015', '龅牙珍', '0');
INSERT INTO `robot_name` VALUES ('1016', '包输不赢', '1');
INSERT INTO `robot_name` VALUES ('1017', '般若小琪', '0');
INSERT INTO `robot_name` VALUES ('1018', '百思不得鸭', '1');
INSERT INTO `robot_name` VALUES ('1019', '白衣梦', '0');
INSERT INTO `robot_name` VALUES ('1020', '霸王', '0');
INSERT INTO `robot_name` VALUES ('1021', '爸妈妈hhy', '0');
INSERT INTO `robot_name` VALUES ('1022', '爸爸说', '1');
INSERT INTO `robot_name` VALUES ('1023', '巴阿巴', '0');
INSERT INTO `robot_name` VALUES ('1024', '俺真是飞哥', '0');
INSERT INTO `robot_name` VALUES ('1025', '安然3', '1');
INSERT INTO `robot_name` VALUES ('1026', '安哥', '0');
INSERT INTO `robot_name` VALUES ('1027', '安迪888', '1');
INSERT INTO `robot_name` VALUES ('1028', '爱小娴', '1');
INSERT INTO `robot_name` VALUES ('1029', '爱死了昨天', '0');
INSERT INTO `robot_name` VALUES ('1030', '爱上你mm', '1');
INSERT INTO `robot_name` VALUES ('1031', '爱上你', '1');
INSERT INTO `robot_name` VALUES ('1032', '爱上斗地主', '1');
INSERT INTO `robot_name` VALUES ('1033', '爱上地主婆', '1');
INSERT INTO `robot_name` VALUES ('1034', '爱莎', '1');
INSERT INTO `robot_name` VALUES ('1035', '爱情乞丐', '0');
INSERT INTO `robot_name` VALUES ('1036', '爱情回来了', '1');
INSERT INTO `robot_name` VALUES ('1037', '爱情好无奈', '0');
INSERT INTO `robot_name` VALUES ('1038', '爱你我比谁都真', '1');
INSERT INTO `robot_name` VALUES ('1039', '爱你王小丽', '1');
INSERT INTO `robot_name` VALUES ('1040', '爱兰一族', '0');
INSERT INTO `robot_name` VALUES ('1041', '爱得宝贝', '1');
INSERT INTO `robot_name` VALUES ('1042', '爱宝贝艺', '0');
INSERT INTO `robot_name` VALUES ('1043', '爱13413396713', '0');
INSERT INTO `robot_name` VALUES ('1044', '唉2583619261', '0');
INSERT INTO `robot_name` VALUES ('1045', '埃及', '0');
INSERT INTO `robot_name` VALUES ('1046', '啊你咋滴', '1');
INSERT INTO `robot_name` VALUES ('1047', '啊8888888888啊', '0');
INSERT INTO `robot_name` VALUES ('1048', '阿晓', '0');
INSERT INTO `robot_name` VALUES ('1049', '阿文', '1');
INSERT INTO `robot_name` VALUES ('1050', '阿妹', '0');
INSERT INTO `robot_name` VALUES ('1051', '阿廖', '1');
INSERT INTO `robot_name` VALUES ('1052', '阿建', '1');
INSERT INTO `robot_name` VALUES ('1053', '阿辉哥', '1');
INSERT INTO `robot_name` VALUES ('1054', '阿宝', '0');

-- ----------------------------
-- Table structure for role
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
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '领导组', '0', '1', '', '', '1208784792', '1254325558');
INSERT INTO `role` VALUES ('2', '员工组', '0', '1', '', '', '1215496283', '1254325566');
INSERT INTO `role` VALUES ('3', '演示组', '0', '1', '', null, '1254325787', '0');

-- ----------------------------
-- Table structure for role_user
-- ----------------------------
DROP TABLE IF EXISTS `role_user`;
CREATE TABLE `role_user` (
  `role_id` mediumint(9) unsigned DEFAULT NULL,
  `user_id` char(32) DEFAULT NULL,
  KEY `group_id` (`role_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role_user
-- ----------------------------
INSERT INTO `role_user` VALUES ('3', '2');

-- ----------------------------
-- Table structure for share_click_log
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
) ENGINE=InnoDB AUTO_INCREMENT=808784 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of share_click_log
-- ----------------------------
-- ----------------------------
-- Table structure for share_log
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
) ENGINE=InnoDB AUTO_INCREMENT=713981 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of share_log
-- ----------------------------

-- ----------------------------
-- Table structure for signin
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
-- Records of signin
-- ----------------------------
INSERT INTO `signin` VALUES ('1', '0:2000,1:2', '1', '5', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('2', '0:3800,1:5', '1', '12', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('3', '0:8000,1:10', '1', '26', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('4', '0:1000,4:10', '0', '1', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('5', '0:1200,4:20', '0', '2', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('6', '0:1500,4:30', '0', '3', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('7', '0:1800,4:40', '0', '4', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('8', '0:2000,4:50', '0', '5', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('9', '0:2500,4:50', '0', '6', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('10', '0:3000,1:1', '0', '7', '2014-09-09 09:53:48');
INSERT INTO `signin` VALUES ('11', '0:800', '2', '1', '2014-09-09 09:53:48');

-- ----------------------------
-- Table structure for signin_log
-- ----------------------------
DROP TABLE IF EXISTS `signin_log`;
CREATE TABLE `signin_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT '0' COMMENT '用户ID',
  `signintype` int(4) DEFAULT '0' COMMENT '奖领类型:0,连续签到；1，vip领奖;2,累计签到',
  `signintotal` int(4) DEFAULT '0',
  `awardmoney` int(4) DEFAULT '0' COMMENT '奖励的金币',
  `awardcoin` int(4) DEFAULT '0' COMMENT '奖励的元宝',
  `awardexp` int(4) DEFAULT '0' COMMENT '励奖的经验',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `create_time` (`create_time`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=8710999 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of signin_log
-- ----------------------------
-- ----------------------------
-- Table structure for slot
-- ----------------------------
DROP TABLE IF EXISTS `slot`;
CREATE TABLE `slot` (
  `id` smallint(2) NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL,
  `odds` smallint(2) NOT NULL,
  `prob` smallint(2) NOT NULL,
  `desc` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of slot
-- ----------------------------
INSERT INTO `slot` VALUES ('1', '-1', '6', '1600', '燕子');
INSERT INTO `slot` VALUES ('2', '-1', '8', '1250', '鸽子');
INSERT INTO `slot` VALUES ('3', '-1', '8', '1250', '孔雀');
INSERT INTO `slot` VALUES ('4', '-1', '12', '700', '老鹰');
INSERT INTO `slot` VALUES ('5', '0', '12', '700', '狮子');
INSERT INTO `slot` VALUES ('6', '0', '8', '1250', '熊猫');
INSERT INTO `slot` VALUES ('7', '0', '8', '1250', '猴子');
INSERT INTO `slot` VALUES ('8', '0', '6', '1600', '兔子');
INSERT INTO `slot` VALUES ('9', '1', '24', '320', '银鲨');
INSERT INTO `slot` VALUES ('10', '2', '99', '80', '金鲨');

-- ----------------------------
-- Table structure for speaker
-- ----------------------------
DROP TABLE IF EXISTS `speaker`;
CREATE TABLE `speaker` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `msg` varchar(200) DEFAULT NULL,
  `create_time` int(4) DEFAULT NULL,
  `update_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of speaker
-- ----------------------------

-- ----------------------------
-- Table structure for stat_flag_name
-- ----------------------------
DROP TABLE IF EXISTS `stat_flag_name`;
CREATE TABLE `stat_flag_name` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `flag` varchar(30) DEFAULT NULL,
  `desc` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of stat_flag_name
-- ----------------------------
INSERT INTO `stat_flag_name` VALUES ('1', 'exchangeAward', '兑换');
INSERT INTO `stat_flag_name` VALUES ('2', 'exchangeMoney', '充值');
INSERT INTO `stat_flag_name` VALUES ('3', 'loginReward', '登陆奖励');
INSERT INTO `stat_flag_name` VALUES ('4', 'lottery', '抽奖');
INSERT INTO `stat_flag_name` VALUES ('5', 'tasks', '成就|每日任务');
INSERT INTO `stat_flag_name` VALUES ('6', 'taskRou', '牌局任务');
INSERT INTO `stat_flag_name` VALUES ('7', 'brokeGet', '破产');
INSERT INTO `stat_flag_name` VALUES ('8', 'lotteryPay', '有偿抽奖');
INSERT INTO `stat_flag_name` VALUES ('9', 'playNReward', '玩N局奖励');
INSERT INTO `stat_flag_name` VALUES ('10', 'slot', '老虎机');
INSERT INTO `stat_flag_name` VALUES ('11', 'pump', '抽水');
INSERT INTO `stat_flag_name` VALUES ('12', 'rob', '机器人');
INSERT INTO `stat_flag_name` VALUES ('13', 'freeLottery', '免费抽奖');
INSERT INTO `stat_flag_name` VALUES ('14', 'payLottery', '有偿抽奖');
INSERT INTO `stat_flag_name` VALUES ('15', 'dayTasks', '日常任务');
INSERT INTO `stat_flag_name` VALUES ('16', 't1', '新手场');
INSERT INTO `stat_flag_name` VALUES ('17', 't2', '初级场');
INSERT INTO `stat_flag_name` VALUES ('18', 't3', '高级场');
INSERT INTO `stat_flag_name` VALUES ('19', 't4', '至尊场');
INSERT INTO `stat_flag_name` VALUES ('20', 'marquee', '喊话');
INSERT INTO `stat_flag_name` VALUES ('21', 'slotCoin', '老虎机元宝');
INSERT INTO `stat_flag_name` VALUES ('22', 'modifyName', '修改昵称');

-- ----------------------------
-- Table structure for stat_player_act_log
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
  `w1` int(4) DEFAULT '0' COMMENT '场馆1胜局次数',
  `w2` int(4) DEFAULT '0',
  `w3` int(4) DEFAULT '0',
  `w4` int(4) DEFAULT '0',
  `w5` int(4) DEFAULT '0',
  `w6` int(4) DEFAULT '0',
  `w7` int(4) DEFAULT NULL,
  `log_day` date DEFAULT NULL COMMENT '日志记录日期',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `log_day` (`log_day`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=8328264 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of stat_player_act_log
-- ----------------------------
-- ----------------------------
-- Table structure for stat_play_time
-- ----------------------------
DROP TABLE IF EXISTS `stat_play_time`;
CREATE TABLE `stat_play_time` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `playTime` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11664 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of stat_play_time
-- ----------------------------

-- ----------------------------
-- Table structure for stat_temp_func
-- ----------------------------
DROP TABLE IF EXISTS `stat_temp_func`;
CREATE TABLE `stat_temp_func` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) DEFAULT '0' COMMENT '统计类型：0元宝统计,1金币统计,2功能使用统计(人数去重),3功能使用统计(人次)',
  `flag` varchar(30) DEFAULT NULL,
  `val` bigint(8) DEFAULT '0' COMMENT '前值当',
  `createtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48786 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of stat_temp_func
-- ----------------------------

-- ----------------------------
-- Table structure for stat_time
-- ----------------------------
DROP TABLE IF EXISTS `stat_time`;
CREATE TABLE `stat_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tmKey` varchar(50) NOT NULL,
  `tmValue` datetime NOT NULL,
  `updated_tm` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tmKey` (`tmKey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stat_time
-- ----------------------------

-- ----------------------------
-- Table structure for system_change_log
-- ----------------------------
DROP TABLE IF EXISTS `system_change_log`;
CREATE TABLE `system_change_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `who` varchar(30) DEFAULT NULL COMMENT '操作者',
  `uid` int(11) DEFAULT '0' COMMENT '用户ID',
  `money` int(11) DEFAULT '0' COMMENT '加的金币数',
  `coin` int(11) DEFAULT '0' COMMENT '加的元宝数',
  `password` varchar(255) DEFAULT NULL COMMENT '修改密码',
  `memo` varchar(100) DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of system_change_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_money
-- ----------------------------
DROP TABLE IF EXISTS `system_money`;
CREATE TABLE `system_money` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `money` bigint(20) DEFAULT '10000000000' COMMENT '系统金币库(手工对用户增加的金币源)',
  `coin` int(11) DEFAULT '100000000' COMMENT '系统元宝库(手工对用户增加的元宝源)',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of system_money
-- ----------------------------
INSERT INTO `system_money` VALUES ('1', '9875232142', '99989102', '2016-02-16 18:26:07');

-- ----------------------------
-- Table structure for tasksawardlog
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
) ENGINE=InnoDB AUTO_INCREMENT=11703631 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of tasksawardlog
-- ----------------------------

-- ----------------------------
-- Table structure for tasksconf
-- ----------------------------
DROP TABLE IF EXISTS `tasksconf`;
CREATE TABLE `tasksconf` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `ttype` tinyint(4) NOT NULL COMMENT '任务类型',
  `finishnum` int(4) NOT NULL COMMENT '完成条件',
  `limitnum` int(4) DEFAULT '0',
  `awardtype` tinyint(4) NOT NULL COMMENT '奖励类型',
  `awardmount` int(4) NOT NULL COMMENT '奖励数额',
  `title` varchar(20) DEFAULT NULL COMMENT '称号',
  `desc` varchar(50) NOT NULL COMMENT '描述',
  `create_time` bigint(8) DEFAULT NULL,
  `update_time` bigint(8) DEFAULT NULL,
  `finishtype` smallint(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of tasksconf
-- ----------------------------
INSERT INTO `tasksconf` VALUES ('1', '1', '1', '0', '0', '500', '个性昵称', '修改昵称,从此与众不同!', '1386670126', '1389864463', '204');
INSERT INTO `tasksconf` VALUES ('2', '1', '1', '0', '0', '1000', '闪靓登场', '上传靓丽头像,展示真实的自我!', '1386670141', '1389864452', '205');
INSERT INTO `tasksconf` VALUES ('3', '-1', '10', '0', '0', '300', '畅游10局', '在任意对局场进行10局游戏!', '1386669897', '1387158803', '101');
INSERT INTO `tasksconf` VALUES ('4', '-1', '10', '0', '0', '800', '常胜将军', '在任意对局场赢10局!', '1386669913', '1387158815', '102');
INSERT INTO `tasksconf` VALUES ('5', '-1', '2', '0', '0', '1200', '挑战高手', '在牛比轰轰或更高场次的房间赢2局!', '1386669930', '1387158824', '103');
INSERT INTO `tasksconf` VALUES ('9', '1', '5', '0', '0', '2000', '购物达人', '在商城累计消费5元!', '1386670023', '1386728825', '202');
INSERT INTO `tasksconf` VALUES ('10', '1', '12', '0', '0', '3000', '购物达人', '在商城累计消费12元!', '1386670038', '1386728786', '202');
INSERT INTO `tasksconf` VALUES ('11', '1', '35', '0', '0', '4000', '购物达人', '在商城累计消费35元!', '1386670050', '1389864527', '202');
INSERT INTO `tasksconf` VALUES ('12', '1', '100', '0', '0', '5000', '购物达人', '在商城累计消费100元!', '1386670023', '1386728825', '202');
INSERT INTO `tasksconf` VALUES ('13', '1', '200', '0', '0', '6000', '购物达人', '在商城累计消费200元!', '1386670038', '1386728786', '202');
INSERT INTO `tasksconf` VALUES ('14', '1', '500', '0', '0', '10000', '购物达人', '在商城累计消费500元!', '1386670050', '1389864527', '202');
INSERT INTO `tasksconf` VALUES ('15', '1', '1300', '0', '0', '20000', '购物达人', '在商城累计消费1300元!', '1386670023', '1386728825', '202');
INSERT INTO `tasksconf` VALUES ('16', '1', '2000', '0', '0', '50000', '购物达人', '在商城累计消费2000元!', '1386670038', '1386728786', '202');
INSERT INTO `tasksconf` VALUES ('17', '1', '3500', '0', '0', '50000', '购物达人', '在商城累计消费3500元!', '1386670050', '1389864527', '202');
INSERT INTO `tasksconf` VALUES ('18', '1', '5000', '0', '0', '50000', '购物达人', '在商城累计消费5000元!', '1386670023', '1386728825', '202');
INSERT INTO `tasksconf` VALUES ('19', '1', '10000', '0', '0', '50000', '购物达人', '在商城累计消费10000元!', '1386670038', '1386728786', '202');
INSERT INTO `tasksconf` VALUES ('20', '1', '30000', '0', '0', '100000', '购物达人', '在商城累计消费30000元!', '1386670050', '1389864527', '202');
INSERT INTO `tasksconf` VALUES ('21', '1', '50000', '0', '0', '100000', '购物达人', '在商城累计消费50000元!', '1386670023', '1386728825', '202');
INSERT INTO `tasksconf` VALUES ('22', '1', '70000', '0', '0', '100000', '购物达人', '在商城累计消费70000元!', '1386670038', '1386728786', '202');
INSERT INTO `tasksconf` VALUES ('23', '1', '100000', '0', '0', '100000', '购物达人', '在商城累计消费100000元!', '1386670050', '1389864527', '202');
INSERT INTO `tasksconf` VALUES ('24', '1', '5', '0', '0', '500', '茁壮成长', '等级升到5级! ', '1386670081', '1389864536', '203');
INSERT INTO `tasksconf` VALUES ('25', '1', '10', '0', '0', '600', '茁壮成长', '等级升到10级!', '1386670097', '1389864599', '203');
INSERT INTO `tasksconf` VALUES ('26', '1', '15', '0', '0', '800', '茁壮成长', '等级升到15级!', '1386670110', '1389864589', '203');
INSERT INTO `tasksconf` VALUES ('27', '1', '20', '0', '0', '1000', '茁壮成长', '等级升到20级! ', '1386670081', '1389864536', '203');
INSERT INTO `tasksconf` VALUES ('28', '1', '25', '0', '0', '1500', '茁壮成长', '等级升到25级!', '1386670097', '1389864599', '203');
INSERT INTO `tasksconf` VALUES ('29', '1', '30', '0', '0', '1800', '茁壮成长', '等级升到30级!', '1386670110', '1389864589', '203');
INSERT INTO `tasksconf` VALUES ('30', '1', '35', '0', '0', '2000', '茁壮成长', '等级升到35级! ', '1386670081', '1389864536', '203');
INSERT INTO `tasksconf` VALUES ('31', '1', '40', '0', '0', '2500', '茁壮成长', '等级升到40级!', '1386670097', '1389864599', '203');
INSERT INTO `tasksconf` VALUES ('32', '1', '45', '0', '0', '3000', '茁壮成长', '等级升到45级!', '1386670110', '1389864589', '203');
INSERT INTO `tasksconf` VALUES ('33', '1', '50', '0', '0', '5000', '茁壮成长', '等级升到50级! ', '1386670081', '1389864536', '203');
INSERT INTO `tasksconf` VALUES ('34', '1', '52', '0', '0', '8000', '茁壮成长', '等级升到52级!', '1386670097', '1389864599', '203');
INSERT INTO `tasksconf` VALUES ('35', '1', '55', '0', '0', '8000', '茁壮成长', '等级升到55级!', '1386670110', '1389864589', '203');
INSERT INTO `tasksconf` VALUES ('36', '1', '57', '0', '0', '10000', '茁壮成长', '等级升到57级! ', '1386670081', '1389864536', '203');
INSERT INTO `tasksconf` VALUES ('37', '1', '60', '0', '0', '10000', '茁壮成长', '等级升到60级!', '1386670097', '1389864599', '203');
INSERT INTO `tasksconf` VALUES ('38', '1', '10', '0', '0', '300', '胜者为王', '游戏胜利总局数达到10局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('39', '1', '20', '0', '0', '300', '胜者为王', '游戏胜利总局数达到20局!', '1386670010', '1386728860', '201');
INSERT INTO `tasksconf` VALUES ('40', '1', '30', '0', '0', '300', '胜者为王', '游戏胜利总局数达到30局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('41', '1', '50', '0', '0', '600', '胜者为王', '游戏胜利总局数达到50局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('42', '1', '100', '0', '0', '800', '胜者为王', '游戏胜利总局数达到100局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('43', '1', '200', '0', '0', '1000', '胜者为王', '游戏胜利总局数达到200局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('44', '1', '500', '0', '0', '1200', '胜者为王', '游戏胜利总局数达到500局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('45', '1', '800', '0', '0', '1500', '胜者为王', '游戏胜利总局数达到800局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('46', '1', '1200', '0', '0', '2500', '胜者为王', '游戏胜利总局数达到1200局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('47', '1', '2000', '0', '0', '5000', '胜者为王', '游戏胜利总局数达到2000局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('48', '1', '3000', '0', '0', '8000', '胜者为王', '游戏胜利总局数达到3000局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('49', '1', '5000', '0', '0', '10000', '胜者为王', '游戏胜利总局数达到5000局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('50', '1', '10000', '0', '0', '10000', '胜者为王', '游戏胜利总局数达到10000局!', '1386669996', '1386728891', '201');
INSERT INTO `tasksconf` VALUES ('73', '-1', '3', '0', '0', '600', '欢乐庄家', '做庄家达3次!', '1386669996', '1386669996', '104');
INSERT INTO `tasksconf` VALUES ('74', '-1', '2', '0', '0', '800', '牛牛达人', '抓到牛牛牌型并获胜2次!', '1386669996', '1386669996', '105');
INSERT INTO `tasksconf` VALUES ('81', '0', '168', '30', '1', '188', '名动四方', '在牛比轰轰玩牌168局,剩余:', '1386669996', '1386669996', '106');
INSERT INTO `tasksconf` VALUES ('82', '0', '388', '10', '1', '288', '威震江湖', '在牛比轰轰玩牌388局,剩余:', '1386669996', '1386669996', '106');
INSERT INTO `tasksconf` VALUES ('83', '0', '128', '5', '1', '888', '绝世高手', '在牛气冲天玩牌188局,剩余:', '1386669996', '1386669996', '107');
INSERT INTO `tasksconf` VALUES ('84', '0', '108', '3', '1', '888', '独孤求败', '在牛炸天玩牌188局,剩余:', '1386669996', '1386669996', '108');
INSERT INTO `tasksconf` VALUES ('86', '1', '11', '0', '1', '28', '更新有礼', '新版更炫更精彩,升级至最新版!', '1386669996', '1386669996', '206');
INSERT INTO `tasksconf` VALUES ('89', '0', '80', '0', '0', '3888', '畅游80局', '在任意对局场进行80局游戏!', '1386669996', '1386669996', '101');
INSERT INTO `tasksconf` VALUES ('90', '0', '150', '0', '0', '2888', '畅游150局', '在任意对局场进行150局游戏!', '1386669996', '1386669996', '101');
INSERT INTO `tasksconf` VALUES ('92', '0', '280', '0', '0', '3888', '畅游280局', '在任意对局场进行280局游戏!', '1386669996', '1386669996', '101');
INSERT INTO `tasksconf` VALUES ('93', '0', '400', '0', '0', '5888', '畅游400局', '在任意对局场进行400局游戏!', '1386669996', '1386669996', '101');
INSERT INTO `tasksconf` VALUES ('96', '1', '12', '0', '1', '28', '更新有礼', '新版更炫更精彩,升级至最新版!', '1386669996', '1386669996', '206');

-- ----------------------------
-- Table structure for temp8
-- ----------------------------
DROP TABLE IF EXISTS `temp8`;
CREATE TABLE `temp8` (
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `tm_min` bigint(21) DEFAULT NULL,
  `money` bigint(20) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of temp8
-- ----------------------------

-- ----------------------------
-- Table structure for temp_rankactivity
-- ----------------------------
DROP TABLE IF EXISTS `temp_rankactivity`;
CREATE TABLE `temp_rankactivity` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `montot` bigint(8) DEFAULT '0' COMMENT '当月挣金币',
  `monday` bigint(8) DEFAULT '0' COMMENT '当日赚金币',
  `maxratio` bigint(8) DEFAULT '0' COMMENT '当天最高倍率',
  `boardwin` bigint(8) DEFAULT '0' COMMENT '当天赢牌次数',
  `maxwinmoney` bigint(8) DEFAULT '0' COMMENT '当日单局赢金币',
  `createtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of temp_rankactivity
-- ----------------------------

-- ----------------------------
-- Table structure for title_info
-- ----------------------------
DROP TABLE IF EXISTS `title_info`;
CREATE TABLE `title_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL COMMENT '头衔名称',
  `minMoney` bigint(11) DEFAULT '0',
  `maxMoney` bigint(20) DEFAULT NULL COMMENT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `honor_name` (`title`) USING BTREE,
  KEY `money_min` (`minMoney`) USING BTREE,
  KEY `money_max` (`maxMoney`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='头衔表';

-- ----------------------------
-- Records of title_info
-- ----------------------------
INSERT INTO `title_info` VALUES ('1', '小萌牛', '0', '2999');
INSERT INTO `title_info` VALUES ('2', '蜗牛^^', '3000', '9999');
INSERT INTO `title_info` VALUES ('3', '牛犊子', '10000', '29999');
INSERT INTO `title_info` VALUES ('4', '小水牛', '30000', '49999');
INSERT INTO `title_info` VALUES ('5', '大壮牛', '50000', '149999');
INSERT INTO `title_info` VALUES ('6', '孺子牛', '150000', '299999');
INSERT INTO `title_info` VALUES ('7', '老黄牛', '300000', '499999');
INSERT INTO `title_info` VALUES ('8', '犀牛', '500000', '1199999');
INSERT INTO `title_info` VALUES ('9', '大角牛', '1200000', '2999999');
INSERT INTO `title_info` VALUES ('10', '牦牛', '3000000', '7999999');
INSERT INTO `title_info` VALUES ('11', '咕噜牛', '8000000', '14999999');
INSERT INTO `title_info` VALUES ('12', '鲁西黄牛', '15000000', '49999999');
INSERT INTO `title_info` VALUES ('13', '利木赞牛', '50000000', '89999999');
INSERT INTO `title_info` VALUES ('14', '夏洛莱牛', '90000000', '119999999');
INSERT INTO `title_info` VALUES ('15', '犀牛王', '120000000', '139999999');
INSERT INTO `title_info` VALUES ('16', '西门塔尔牛', '140000000', '149999999');
INSERT INTO `title_info` VALUES ('17', '牛比轰轰', '150000000', '299999999');
INSERT INTO `title_info` VALUES ('18', '牛炸天', '300000000', '599999999');
INSERT INTO `title_info` VALUES ('19', '牛气冲天', '500000000', '999999999');
INSERT INTO `title_info` VALUES ('20', '牛魔王', '1000000000', '0');

-- ----------------------------
-- Table structure for tmp007
-- ----------------------------
DROP TABLE IF EXISTS `tmp007`;
CREATE TABLE `tmp007` (
  `手机号码` varchar(255) DEFAULT NULL,
  `orderid` varchar(255) DEFAULT NULL,
  `AP名称` varchar(255) DEFAULT NULL,
  `企业代码` varchar(255) DEFAULT NULL,
  `应用名称` varchar(255) DEFAULT NULL,
  `道具名称` varchar(255) DEFAULT NULL,
  `应用ID` varchar(255) DEFAULT NULL,
  `订购时间` varchar(255) DEFAULT NULL,
  `订购途径` varchar(255) DEFAULT NULL,
  `业务资费` varchar(255) DEFAULT NULL,
  `订购金额` varchar(255) DEFAULT NULL,
  `业务类型` varchar(255) DEFAULT NULL,
  `计费类型` varchar(255) DEFAULT NULL,
  `下载状态` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tmp007
-- ----------------------------
INSERT INTO `tmp007` VALUES ('手机号码', '订单号', 'AP名称', '企业代码', '应用名称', '道具名称', '应用ID', '订购时间', '订购途径', '业务资费', '订购金额', '业务类型', '计费类型', '下载状态');
INSERT INTO `tmp007` VALUES ('15081797018', '11150105200829840370', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2015-01-05 20:08:29', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11150105200502479762', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '20万金币', '300008375860', '2015-01-05 20:05:02', '短信网关', '20.0', '20.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11150105200305061867', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2015-01-05 20:03:05', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11150105200202979876', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2015-01-05 20:02:02', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11150105190217377122', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2015-01-05 19:02:17', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11150101193812119956', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2015-01-01 19:38:12', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11150101193447184622', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2015-01-01 19:34:47', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11150101193000114353', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2015-01-01 19:30:00', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230153826459388', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-30 15:38:26', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230153626399148', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-30 15:36:26', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230153238412578', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2014-12-30 15:32:38', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230134410226194', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-30 13:44:10', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230134151846313', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-30 13:41:51', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230133742925344', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-30 13:37:42', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230133618723343', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-30 13:36:18', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230133452279665', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-30 13:34:52', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141230124223377225', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-30 12:42:23', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229192204329914', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-29 19:22:04', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229182830898842', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-29 18:28:30', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229182331414607', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-29 18:23:31', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229182054906343', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-29 18:20:54', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229181927629593', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-29 18:19:27', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229181552687121', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-29 18:15:52', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229163529239505', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-29 16:35:29', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229163300540923', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-29 16:33:00', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141229105059105315', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-29 10:50:59', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228223953464016', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:39:53', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228223731572837', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:37:31', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228223518445567', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:35:18', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228222017866991', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:20:17', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228221755577796', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:17:55', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228221412815862', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:14:12', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228221157648163', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:11:57', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141228221028628278', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-28 22:10:28', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227180517444227', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-27 18:05:17', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227175737357774', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-27 17:57:37', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227175716753419', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-27 17:57:16', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227175123704785', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '20万金币', '300008375860', '2014-12-27 17:51:23', '短信网关', '20.0', '20.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227175004298473', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-27 17:50:04', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227174539560612', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-27 17:45:39', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227174139581596', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-27 17:41:39', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227163651524729', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2014-12-27 16:36:51', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141227163251340014', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-27 16:32:51', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226180416127845', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 18:04:16', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226180110269636', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2014-12-26 18:01:10', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226175411722628', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-26 17:54:11', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226175138438961', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 17:51:38', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226174334530356', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 17:43:34', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226174215561359', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 17:42:15', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226165719931787', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-26 16:57:19', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226165025845419', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 16:50:25', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226164900667716', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2014-12-26 16:49:00', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226164719837540', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 16:47:19', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226135150065500', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 13:51:50', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226135036819923', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 13:50:36', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226132937642713', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 13:29:37', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226132810501242', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 13:28:10', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226131827534267', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 13:18:27', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226130648861956', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 13:06:48', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226125900928557', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 12:59:00', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141226125404360163', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-26 12:54:04', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141225194108690353', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '10万金币', '300008375860', '2014-12-25 19:41:08', '短信网关', '10.0', '10.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141225193806059818', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-25 19:38:06', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141225193050617377', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-25 19:30:50', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141225185733836539', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '5万金币', '300008375860', '2014-12-25 18:57:33', '短信网关', '5.0', '5.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141225181943814274', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2014-12-25 18:19:43', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');
INSERT INTO `tmp007` VALUES ('15081797018', '11141225172011595858', '广州无比乐网络技术有限公司', '100113', '土豪牛牛', '2万金币', '300008375860', '2014-12-25 17:20:11', '短信网关', '2.0', '2.0', '应用内计费', '按次', '成功');

-- ----------------------------
-- Table structure for top_recharge_award_log
-- ----------------------------
DROP TABLE IF EXISTS `top_recharge_award_log`;
CREATE TABLE `top_recharge_award_log` (
  `id` bigint(8) NOT NULL AUTO_INCREMENT,
  `uid` bigint(8) DEFAULT NULL,
  `rmb` int(4) DEFAULT NULL,
  `sortnum` int(4) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8601 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of top_recharge_award_log
-- ----------------------------

-- ----------------------------
-- Table structure for trap_apptype
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of trap_apptype
-- ----------------------------
INSERT INTO `trap_apptype` VALUES ('1', '2', 'com.chjie.dcow', '100lianyun001', '2014-09-05 16:03:36');
INSERT INTO `trap_apptype` VALUES ('2', '3', 'com.chjie.dcow.mopo', '3003997517', '2015-05-18 16:59:18');
INSERT INTO `trap_apptype` VALUES ('3', '3', 'com.chjie.dcow.mopo', '3003996352', '2015-05-18 16:46:04');
INSERT INTO `trap_apptype` VALUES ('4', '3', 'com.chjie.dcow.mopo', '3003996351', '2015-05-18 16:46:14');
INSERT INTO `trap_apptype` VALUES ('5', '4', 'com.chjie.dcow.ewan', 'EWAN000001', '2015-10-22 13:58:58');

-- ----------------------------
-- Table structure for trap_info
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
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of trap_info
-- ----------------------------
INSERT INTO `trap_info` VALUES ('1', '1', '0', '大厅', '0', '1', '特惠', '01', '20', '688888', '20', null, '1', '1', '2014-08-05 14:39:32');
INSERT INTO `trap_info` VALUES ('2', '1', '0', '大厅', '1', '1', '大厅快充', '01', '5', '53000', '5', null, '1', '1', '2014-10-24 11:34:38');
INSERT INTO `trap_info` VALUES ('3', '1', '0', '大厅', '5', '1', '老虎机拦截', '01', '20', '215000', '20', null, '1', '1', '2015-05-09 20:02:32');
INSERT INTO `trap_info` VALUES ('4', '1', '0', '大厅', '6', '11', '充值榜快充', '01', '5', '53000', '5', null, '1', '1', '2014-10-24 11:34:38');
INSERT INTO `trap_info` VALUES ('5', '1', '1', '场馆2', '3', '1', '入房拦截', '01', '5', '53000', '5', null, '0', '1', '2015-06-11 16:09:47');
INSERT INTO `trap_info` VALUES ('6', '1', '1', '场馆2', '4', '1', '超次破产', '01', '5', '53000', '5', null, '0', '1', '2015-06-11 16:09:48');
INSERT INTO `trap_info` VALUES ('7', '1', '1', '场馆2', '2', '1', '桌上快充', '01', '5', '53000', '5', null, '0', '1', '2015-06-11 16:09:50');
INSERT INTO `trap_info` VALUES ('8', '1', '3', '场馆3', '4', '1', '超次破产', '01', '10', '107000', '10', null, '0', '1', '2015-06-11 15:51:07');
INSERT INTO `trap_info` VALUES ('9', '1', '3', '场馆3', '3', '1', '入房拦截', '01', '10', '107000', '10', null, '0', '1', '2015-06-11 15:51:07');
INSERT INTO `trap_info` VALUES ('10', '1', '3', '场馆3', '2', '1', '桌上快充', '01', '10', '107000', '10', null, '0', '1', '2015-06-11 15:51:08');
INSERT INTO `trap_info` VALUES ('11', '1', '2', '场馆1', '2', '1', '桌上快充', '01', '2', '21000', '2', null, '0', '1', '2015-06-11 16:09:41');
INSERT INTO `trap_info` VALUES ('12', '1', '2', '场馆1', '3', '1', '入房拦截', '01', '2', '21000', '2', null, '0', '1', '2015-06-11 16:09:43');
INSERT INTO `trap_info` VALUES ('13', '1', '2', '场馆1', '4', '1', '超次破产', '01', '2', '21000', '2', null, '0', '1', '2015-06-11 16:09:45');
INSERT INTO `trap_info` VALUES ('14', '1', '4', '场馆4', '4', '1', '超次破产', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:11');
INSERT INTO `trap_info` VALUES ('15', '1', '4', '场馆4', '3', '1', '入房拦截', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:12');
INSERT INTO `trap_info` VALUES ('16', '1', '4', '场馆4', '2', '1', '桌上快充', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:12');
INSERT INTO `trap_info` VALUES ('17', '1', '5', '场馆5', '4', '1', '超次破产', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:13');
INSERT INTO `trap_info` VALUES ('18', '1', '5', '场馆5', '3', '1', '入房拦截', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:14');
INSERT INTO `trap_info` VALUES ('19', '1', '5', '场馆5', '2', '1', '桌上快充', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:14');
INSERT INTO `trap_info` VALUES ('20', '1', '6', '场馆6', '4', '1', '超次破产', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:15');
INSERT INTO `trap_info` VALUES ('21', '1', '6', '场馆6', '3', '1', '入房拦截', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:15');
INSERT INTO `trap_info` VALUES ('22', '1', '6', '场馆6', '2', '1', '桌上快充', '01', '30', '324000', '30', null, '0', '1', '2015-06-11 15:51:17');
INSERT INTO `trap_info` VALUES ('23', '2', '0', '大厅', '0', '1', '特惠', '12', '20', '688888', '20', null, '1', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('24', '2', '0', '大厅', '1', '1', '大厅快充', '12', '6', '60000', '6', null, '1', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('25', '2', '0', '大厅', '5', '1', '老虎机拦截', '12', '10', '100000', '10', null, '1', '1', '2014-12-09 16:28:13');
INSERT INTO `trap_info` VALUES ('26', '2', '0', '大厅', '6', '11', '充值榜快充', '12', '6', '60000', '6', null, '1', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('27', '2', '1', '场馆1', '3', '1', '入房拦截', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('28', '2', '1', '场馆1', '4', '1', '超次破产', '12', '2', '20000', '2', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('29', '2', '1', '场馆1', '2', '1', '桌上快充', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('30', '2', '3', '场馆3', '4', '1', '超次破产', '12', '5', '50000', '5', null, '0', '1', '2014-12-09 16:26:38');
INSERT INTO `trap_info` VALUES ('31', '2', '3', '场馆3', '3', '1', '入房拦截', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('32', '2', '3', '场馆3', '2', '1', '桌上快充', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('33', '2', '2', '场馆2', '2', '1', '桌上快充', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('34', '2', '2', '场馆2', '3', '1', '入房拦截', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('35', '2', '2', '场馆2', '4', '1', '超次破产', '12', '2', '20000', '2', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('36', '2', '4', '场馆4', '4', '1', '超次破产', '12', '10', '100000', '10', null, '0', '1', '2014-12-09 16:26:45');
INSERT INTO `trap_info` VALUES ('37', '2', '4', '场馆4', '3', '1', '入房拦截', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('38', '2', '4', '场馆4', '2', '1', '桌上快充', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('39', '2', '5', '场馆5', '4', '1', '超次破产', '12', '10', '100000', '10', null, '0', '1', '2014-12-09 16:26:56');
INSERT INTO `trap_info` VALUES ('40', '2', '5', '场馆5', '3', '1', '入房拦截', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('41', '2', '5', '场馆5', '2', '1', '桌上快充', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('42', '2', '6', '场馆6', '4', '1', '超次破产', '12', '10', '100000', '10', null, '0', '1', '2014-12-09 16:27:05');
INSERT INTO `trap_info` VALUES ('43', '2', '6', '场馆6', '3', '1', '入房拦截', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('44', '2', '6', '场馆6', '2', '1', '桌上快充', '12', '6', '60000', '6', null, '0', '1', '2014-09-05 16:38:26');
INSERT INTO `trap_info` VALUES ('54', '1', '0', '大厅', '7', '1', '0.1元', '01', '0', '18888', '0', null, '1', '1', '2014-12-03 10:29:11');
INSERT INTO `trap_info` VALUES ('55', '1', '0', '保险箱', '8', '1', '购买保险箱', '01', '20', '0', '0', null, '0', '1', '2015-04-29 11:00:15');
INSERT INTO `trap_info` VALUES ('56', '2', '0', '保险箱', '8', '1', '购买保险箱', '12', '20', '0', '0', null, '0', '1', '2015-04-29 11:00:47');
INSERT INTO `trap_info` VALUES ('57', '3', '0', '大厅', '0', '1', '特惠', '11', '8', '168888', '8', null, '1', '1', '2015-05-04 15:15:34');
INSERT INTO `trap_info` VALUES ('58', '3', '0', '大厅', '1', '1', '大厅快充', '11', '6', '64000', '6', null, '1', '1', '2015-05-04 15:13:55');
INSERT INTO `trap_info` VALUES ('59', '3', '0', '大厅', '5', '1', '老虎机拦截', '11', '8', '86000', '8', null, '1', '1', '2015-05-04 15:14:58');
INSERT INTO `trap_info` VALUES ('60', '3', '0', '大厅', '6', '11', '充值榜快充', '11', '6', '64000', '6', null, '1', '1', '2015-05-04 15:13:58');
INSERT INTO `trap_info` VALUES ('61', '3', '1', '场馆1', '3', '1', '入房拦截', '11', '2', '21000', '2', null, '0', '1', '2015-05-04 15:13:23');
INSERT INTO `trap_info` VALUES ('62', '3', '1', '场馆1', '4', '1', '超次破产', '11', '2', '21000', '2', null, '0', '1', '2014-10-24 11:33:42');
INSERT INTO `trap_info` VALUES ('63', '3', '1', '场馆1', '2', '1', '桌上快充', '11', '2', '21000', '2', null, '0', '1', '2015-05-04 15:13:28');
INSERT INTO `trap_info` VALUES ('64', '3', '3', '场馆3', '4', '1', '超次破产', '11', '6', '64000', '6', null, '0', '1', '2015-05-04 15:13:42');
INSERT INTO `trap_info` VALUES ('65', '3', '3', '场馆3', '3', '1', '入房拦截', '11', '6', '64000', '6', null, '0', '1', '2015-05-04 15:13:48');
INSERT INTO `trap_info` VALUES ('66', '3', '3', '场馆3', '2', '1', '桌上快充', '11', '6', '64000', '6', null, '0', '1', '2015-05-04 15:13:48');
INSERT INTO `trap_info` VALUES ('67', '3', '2', '场馆2', '2', '1', '桌上快充', '11', '2', '21000', '2', null, '0', '1', '2015-05-04 15:13:34');
INSERT INTO `trap_info` VALUES ('68', '3', '2', '场馆2', '3', '1', '入房拦截', '11', '2', '21000', '2', null, '0', '1', '2015-05-04 15:13:35');
INSERT INTO `trap_info` VALUES ('69', '3', '2', '场馆2', '4', '1', '超次破产', '11', '2', '21000', '2', null, '0', '1', '2014-10-24 11:33:42');
INSERT INTO `trap_info` VALUES ('70', '3', '4', '场馆4', '4', '1', '超次破产', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:33');
INSERT INTO `trap_info` VALUES ('71', '3', '4', '场馆4', '3', '1', '入房拦截', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:35');
INSERT INTO `trap_info` VALUES ('72', '3', '4', '场馆4', '2', '1', '桌上快充', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:36');
INSERT INTO `trap_info` VALUES ('73', '3', '5', '场馆5', '4', '1', '超次破产', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:36');
INSERT INTO `trap_info` VALUES ('74', '3', '5', '场馆5', '3', '1', '入房拦截', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:37');
INSERT INTO `trap_info` VALUES ('75', '3', '5', '场馆5', '2', '1', '桌上快充', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:37');
INSERT INTO `trap_info` VALUES ('76', '3', '6', '场馆6', '4', '1', '超次破产', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:41');
INSERT INTO `trap_info` VALUES ('77', '3', '6', '场馆6', '3', '1', '入房拦截', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:42');
INSERT INTO `trap_info` VALUES ('78', '3', '6', '场馆6', '2', '1', '桌上快充', '11', '8', '86000', '8', null, '0', '1', '2015-05-04 15:14:42');
INSERT INTO `trap_info` VALUES ('79', '3', '0', '保险箱', '8', '1', '购买保险箱', '11', '8', '0', '0', null, '0', '1', '2015-05-04 15:10:10');
INSERT INTO `trap_info` VALUES ('81', '0', '0', '大厅', '1', '1', '大厅快充', '01', '5', '50000', '5', null, '1', '1', '2015-05-07 14:45:19');
INSERT INTO `trap_info` VALUES ('82', '0', '0', '大厅', '5', '1', '老虎机拦截', '01', '10', '100000', '10', null, '1', '1', '2015-05-07 14:45:23');
INSERT INTO `trap_info` VALUES ('83', '0', '0', '大厅', '6', '11', '充值榜快充', '01', '5', '50000', '5', null, '1', '1', '2015-05-07 14:45:28');
INSERT INTO `trap_info` VALUES ('84', '0', '1', '场馆2', '3', '1', '入房拦截', '01', '5', '50000', '5', null, '0', '1', '2015-06-11 16:34:59');
INSERT INTO `trap_info` VALUES ('85', '0', '1', '场馆2', '4', '1', '超次破产', '01', '5', '50000', '5', null, '0', '1', '2015-06-11 16:35:01');
INSERT INTO `trap_info` VALUES ('86', '0', '1', '场馆2', '2', '1', '桌上快充', '01', '5', '50000', '5', null, '0', '1', '2015-06-11 16:35:03');
INSERT INTO `trap_info` VALUES ('87', '0', '3', '场馆3', '4', '1', '超次破产', '01', '5', '50000', '5', null, '0', '1', '2015-05-07 14:45:30');
INSERT INTO `trap_info` VALUES ('88', '0', '3', '场馆3', '3', '1', '入房拦截', '01', '5', '50000', '5', null, '0', '1', '2015-05-07 14:45:30');
INSERT INTO `trap_info` VALUES ('89', '0', '3', '场馆3', '2', '1', '桌上快充', '01', '5', '50000', '5', null, '0', '1', '2015-05-07 14:45:30');
INSERT INTO `trap_info` VALUES ('90', '0', '2', '场馆1', '2', '1', '桌上快充', '01', '5', '50000', '5', null, '0', '1', '2015-06-11 16:34:52');
INSERT INTO `trap_info` VALUES ('91', '0', '2', '场馆1', '3', '1', '入房拦截', '01', '5', '50000', '5', null, '0', '1', '2015-06-11 16:34:54');
INSERT INTO `trap_info` VALUES ('92', '0', '2', '场馆1', '4', '1', '超次破产', '01', '5', '50000', '5', null, '0', '1', '2015-06-11 16:34:57');
INSERT INTO `trap_info` VALUES ('93', '0', '4', '场馆4', '4', '1', '超次破产', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:33');
INSERT INTO `trap_info` VALUES ('94', '0', '4', '场馆4', '3', '1', '入房拦截', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:32');
INSERT INTO `trap_info` VALUES ('95', '0', '4', '场馆4', '2', '1', '桌上快充', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:32');
INSERT INTO `trap_info` VALUES ('96', '0', '5', '场馆5', '4', '1', '超次破产', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:31');
INSERT INTO `trap_info` VALUES ('97', '0', '5', '场馆5', '3', '1', '入房拦截', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:30');
INSERT INTO `trap_info` VALUES ('98', '0', '5', '场馆5', '2', '1', '桌上快充', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:30');
INSERT INTO `trap_info` VALUES ('99', '0', '6', '场馆6', '4', '1', '超次破产', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:29');
INSERT INTO `trap_info` VALUES ('100', '0', '6', '场馆6', '3', '1', '入房拦截', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:28');
INSERT INTO `trap_info` VALUES ('101', '0', '6', '场馆6', '2', '1', '桌上快充', '01', '30', '300000', '30', null, '0', '1', '2015-06-11 15:51:28');
INSERT INTO `trap_info` VALUES ('102', '0', '0', '大厅', '7', '1', '0.1元', '01', '0', '18888', '0', null, '1', '1', '2014-12-03 10:29:11');
INSERT INTO `trap_info` VALUES ('103', '0', '0', '保险箱', '8', '1', '购买保险箱', '01', '20', '0', '0', null, '0', '1', '2015-04-29 11:00:15');
INSERT INTO `trap_info` VALUES ('108', '1', '0', '大厅', '9', '1', '百人场拦截', '01', '10', '107000', '10', null, '1', '1', '2015-09-08 16:07:37');
INSERT INTO `trap_info` VALUES ('109', '4', '0', '大厅', '7', '1', '0.1元', '16', '0', '18888', '0', null, '1', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('110', '4', '2', '场馆1', '2', '1', '桌上快充', '16', '2', '21000', '2', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('111', '4', '2', '场馆1', '3', '1', '入房拦截', '16', '2', '21000', '2', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('112', '4', '2', '场馆1', '4', '1', '超次破产', '16', '2', '21000', '2', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('113', '4', '0', '大厅', '1', '1', '大厅快充', '16', '5', '53000', '5', null, '1', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('114', '4', '0', '大厅', '6', '11', '充值榜快充', '16', '5', '53000', '5', null, '1', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('115', '4', '1', '场馆2', '3', '1', '入房拦截', '16', '5', '53000', '5', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('116', '4', '1', '场馆2', '4', '1', '超次破产', '16', '5', '53000', '5', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('117', '4', '1', '场馆2', '2', '1', '桌上快充', '16', '5', '53000', '5', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('118', '4', '3', '场馆3', '4', '1', '超次破产', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('119', '4', '3', '场馆3', '3', '1', '入房拦截', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('120', '4', '3', '场馆3', '2', '1', '桌上快充', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('121', '4', '0', '大厅', '9', '1', '百人场拦截', '16', '10', '107000', '10', null, '1', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('122', '4', '0', '大厅', '0', '1', '特惠', '16', '20', '688888', '20', null, '1', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('123', '4', '0', '大厅', '5', '1', '老虎机拦截', '16', '20', '215000', '20', null, '1', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('124', '4', '0', '保险箱', '8', '1', '购买保险箱', '16', '20', '0', '0', null, '0', '1', '2015-10-21 17:35:15');
INSERT INTO `trap_info` VALUES ('125', '4', '4', '场馆4', '4', '1', '超次破产', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:39:45');
INSERT INTO `trap_info` VALUES ('126', '4', '4', '场馆4', '3', '1', '入房拦截', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:39:46');
INSERT INTO `trap_info` VALUES ('127', '4', '4', '场馆4', '2', '1', '桌上快充', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:39:47');
INSERT INTO `trap_info` VALUES ('128', '4', '5', '场馆5', '4', '1', '超次破产', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:39:48');
INSERT INTO `trap_info` VALUES ('129', '4', '5', '场馆5', '3', '1', '入房拦截', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:39:57');
INSERT INTO `trap_info` VALUES ('130', '4', '5', '场馆5', '2', '1', '桌上快充', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:39:58');
INSERT INTO `trap_info` VALUES ('131', '4', '6', '场馆6', '4', '1', '超次破产', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:39:59');
INSERT INTO `trap_info` VALUES ('132', '4', '6', '场馆6', '3', '1', '入房拦截', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:40:00');
INSERT INTO `trap_info` VALUES ('133', '4', '6', '场馆6', '2', '1', '桌上快充', '16', '10', '107000', '10', null, '0', '1', '2015-10-21 17:40:01');

-- ----------------------------
-- Table structure for trap_order
-- ----------------------------
DROP TABLE IF EXISTS `trap_order`;
CREATE TABLE `trap_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(50) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `imei` varchar(50) DEFAULT NULL,
  `imsi` varchar(50) DEFAULT NULL,
  `trap_pos` int(11) DEFAULT NULL,
  `trap_id` int(11) DEFAULT NULL,
  `sdk_old` varchar(10) DEFAULT NULL,
  `sdk` varchar(10) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE,
  KEY `imei` (`imei`) USING BTREE,
  KEY `imsi` (`imsi`) USING BTREE,
  KEY `order_id_2` (`order_id`,`uid`,`trap_pos`,`trap_id`),
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2333726 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of trap_order
-- ----------------------------
-- ----------------------------
-- Table structure for user
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
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', '管理员', 'wetwqerhgerhwerhwerwertwertwert', '', '1408930193', '183.16.110.135', '1182', '8888', 'ss@gmail.com', '备注信息', '1222907803', '1370015717', '1', '0', '');
INSERT INTO `user` VALUES ('2', 'demo', '演示', '96e79218965eb72c92a549dd5a330112', '', '1382523616', '127.0.0.1', '141', '8888', '', '', '1239783735', '1254325770', '1', '0', '');
INSERT INTO `user` VALUES ('3', 'member', '员工', '96e79218965eb72c92a549dd5a330112', '', '1382497864', '127.0.0.1', '18', '', '', '', '1253514375', '1254325728', '1', '0', '');
INSERT INTO `user` VALUES ('4', 'leader', '领导', '96e79218965eb72c92a549dd5a330112', '', '1284542339', '127.0.0.1', '17', '', '', '领导', '1253514575', '1254325705', '1', '0', '');

-- ----------------------------
-- Table structure for venue
-- ----------------------------
DROP TABLE IF EXISTS `venue`;
CREATE TABLE `venue` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `vid` int(11) DEFAULT NULL COMMENT '场馆ID',
  `rpid` int(11) DEFAULT NULL,
  `name` varchar(64) NOT NULL COMMENT '房间名称',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '有效状态：0=无效，1=有效',
  `room_limit` int(11) DEFAULT '3000' COMMENT '牌桌最大限制',
  `base_money` int(11) NOT NULL COMMENT '底注',
  `min_money` int(11) NOT NULL COMMENT '金币值(最小限入) >=0； 0=不限金币数',
  `max_money` int(11) NOT NULL COMMENT '金币值(最大限入) >=0；0=不限金币数',
  `ip` varchar(64) NOT NULL COMMENT 'IP',
  `port` int(11) NOT NULL COMMENT '端口',
  `online_lower` int(11) DEFAULT '50' COMMENT '虚拟的在线人数下限',
  `online_upper` int(11) DEFAULT '1000' COMMENT '虚拟的在线人数上限',
  `vtype` int(4) DEFAULT '0' COMMENT '馆场类型:0,普通场;1,癞子场;2,武将场',
  `vip_limit` int(11) DEFAULT '0' COMMENT '准入vip限制',
  `game_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '场馆玩法:0普通场,1任务场,2卡牌场..',
  `is_pcheat` tinyint(4) DEFAULT '0' COMMENT '是否防作弊场:1,是;0,不是',
  `robot` tinyint(4) DEFAULT '0' COMMENT '是否需要机器人：0=NO，1=yes',
  `ratio_min` int(11) DEFAULT '1' COMMENT '最小倍数',
  `ratio_max` int(11) DEFAULT '99' COMMENT '最大倍数',
  `tax` float DEFAULT '0.1' COMMENT '抽水税率',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='场馆表';

-- ----------------------------
-- Records of venue
-- ----------------------------
INSERT INTO `venue` VALUES ('1', '2', '0', '小试牛刀', '1', '3000', '200', '5000', '499999', '121.199.36.31', '50002', '50', '2000', '0', '0', '0', '1', '0', '1', '99', '0.1', '1370057530', '1383622599');
INSERT INTO `venue` VALUES ('2', '1', '0', '初生牛犊', '1', '3000', '50', '1000', '49999', '121.199.36.31', '50001', '50', '1000', '0', '0', '0', '0', '0', '1', '99', '0.1', '1370057530', '1393379816');
INSERT INTO `venue` VALUES ('3', '3', '0', '牛比轰轰', '1', '3000', '800', '50000', '0', '121.199.36.31', '50003', '50', '3000', '0', '0', '0', '0', '0', '1', '99', '0.1', '1370057530', '1393379841');
INSERT INTO `venue` VALUES ('4', '4', '0', '牛气冲天', '1', '3000', '2000', '100000', '0', '121.199.36.31', '50004', '50', '4000', '0', '0', '0', '1', '0', '1', '99', '0.1', '1370057530', '1393379725');
INSERT INTO `venue` VALUES ('5', '5', '0', '牛炸天', '1', '3000', '5000', '500000', '0', '121.199.36.31', '50005', '50', '1000', '0', '0', '0', '0', '0', '1', '99', '0.2', '1370057530', '1386216062');
INSERT INTO `venue` VALUES ('6', '6', '0', '牛魔王', '1', '3000', '10000', '1000000', '0', '121.199.36.31', '50006', '50', '1000', '0', '0', '0', '1', '0', '1', '99', '0.2', '1370057530', '1393379206');
INSERT INTO `venue` VALUES ('9', '7', '6', '比赛场', '2', '3000', '500', '30000', '0', '121.199.36.31', '50007', '50', '3000', '1', '0', '0', '0', '0', '1', '99', '0.1', '0', '0');
INSERT INTO `venue` VALUES ('10', '8', '0', '百人牛牛', '3', '3000', '500', '300', '0', '121.199.36.31', '70001', '50', '1000', '0', '0', '0', '0', '0', '1', '99', '0.1', '0', '0');
INSERT INTO `venue` VALUES ('11', '9', '0', '私人场', '4', '3000', '0', '0', '0', '121.199.36.31', '80001', '50', '1000', '0', '0', '0', '0', '0', '1', '99', '0.1', '0', '0');

-- ----------------------------
-- Table structure for venue_backup
-- ----------------------------
DROP TABLE IF EXISTS `venue_backup`;
CREATE TABLE `venue_backup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(64) NOT NULL COMMENT '房间名称',
  `status` int(11) NOT NULL COMMENT '状态',
  `base_money` int(11) NOT NULL COMMENT '底注',
  `min_money` int(11) NOT NULL COMMENT '金币值(最小限入)',
  `max_money` int(11) NOT NULL COMMENT '金币值(最大限入)',
  `ip` varchar(64) NOT NULL COMMENT 'IP',
  `port` int(11) NOT NULL COMMENT '端口',
  `onplay` int(11) DEFAULT '0' COMMENT '在线人数',
  `vtype` int(4) DEFAULT '0' COMMENT '馆场类型:0,普通场;1,癞子场;2,武将场',
  `game_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '场馆玩法:0普通场,1任务场,2卡牌场..',
  `is_pcheat` tinyint(4) DEFAULT '0' COMMENT '是否防作弊场:1,是;0,不是',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='场馆表';

-- ----------------------------
-- Records of venue_backup
-- ----------------------------
INSERT INTO `venue_backup` VALUES ('1', '新手场', '1', '100', '500', '49999', '203.86.3.245', '50001', '0', '0', '0', '0', '1370057530', '1383622599');
INSERT INTO `venue_backup` VALUES ('2', '初级场', '1', '1000', '1000', '0', '203.86.3.245', '50002', '0', '0', '1', '1', '1370057530', '1393379816');
INSERT INTO `venue_backup` VALUES ('3', '超级场', '1', '50', '5000', '0', '203.86.3.245', '50003', '0', '1', '2', '0', '1370057530', '1393379841');
INSERT INTO `venue_backup` VALUES ('4', '至尊场', '1', '500', '100000', '0', '203.86.3.245', '50004', '0', '1', '2', '1', '1370057530', '1393379725');
INSERT INTO `venue_backup` VALUES ('5', 'T新手场', '2', '100', '2000', '49999', '127.0.0.1', '40001', '0', '0', '0', '0', '1370057530', '1386216062');
INSERT INTO `venue_backup` VALUES ('6', 'T初级场', '2', '1000', '50000', '0', '127.0.0.1', '40002', '0', '0', '1', '1', '1370057530', '1393379206');
INSERT INTO `venue_backup` VALUES ('7', 'T超级场', '2', '50', '5000', '0', '127.0.0.1', '40003', '0', '1', '2', '0', '1370008545', '1393379855');
INSERT INTO `venue_backup` VALUES ('8', 'T至尊场', '2', '500', '100000', '0', '127.0.0.1', '40004', '0', '1', '2', '1', '1370552503', '1393379138');

-- ----------------------------
-- Table structure for vips
-- ----------------------------
DROP TABLE IF EXISTS `vips`;
CREATE TABLE `vips` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `level` int(4) DEFAULT NULL COMMENT 'vip等级',
  `min_recharge` int(4) DEFAULT NULL COMMENT '最小充值额',
  `min_exp` bigint(4) DEFAULT NULL COMMENT '最小经验值',
  `ext_award` int(4) DEFAULT NULL COMMENT '每天额外奖励的金币',
  `create_time` bigint(8) DEFAULT NULL,
  `update_time` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of vips
-- ----------------------------
INSERT INTO `vips` VALUES ('4', '0', '0', '0', '0', null, null);
INSERT INTO `vips` VALUES ('5', '1', '1', '0', '1000', null, null);
INSERT INTO `vips` VALUES ('6', '2', '20', '0', '3000', null, null);
INSERT INTO `vips` VALUES ('7', '3', '50', '0', '10000', null, null);
INSERT INTO `vips` VALUES ('8', '4', '300', '2000', '20000', null, null);
INSERT INTO `vips` VALUES ('9', '5', '600', '4000', '40000', null, null);
INSERT INTO `vips` VALUES ('10', '6', '1500', '10000', '60000', null, null);
INSERT INTO `vips` VALUES ('11', '7', '5000', '20000', '80000', null, null);
INSERT INTO `vips` VALUES ('12', '8', '10000', '30000', '100000', null, null);
INSERT INTO `vips` VALUES ('13', '9', '15000', '40000', '150000', null, null);
INSERT INTO `vips` VALUES ('14', '10', '30000', '50000', '200000', null, null);
INSERT INTO `vips` VALUES ('15', '11', '60000', '60000', '300000', null, null);
INSERT INTO `vips` VALUES ('16', '12', '120000', '70000', '400000', null, null);

-- ----------------------------
-- Table structure for web_dict
-- ----------------------------
DROP TABLE IF EXISTS `web_dict`;
CREATE TABLE `web_dict` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) DEFAULT NULL,
  `type_desc` varchar(50) DEFAULT NULL,
  `keyid` varchar(50) DEFAULT NULL,
  `keyvalue` varchar(50) DEFAULT NULL,
  `memo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8 COMMENT='运营后台-词典';

-- ----------------------------
-- Records of web_dict
-- ----------------------------
INSERT INTO `web_dict` VALUES ('1', 'is_update', '是否更新', '1', '更新', '');
INSERT INTO `web_dict` VALUES ('2', 'is_update', '是否更新', '0', '不更新', '');
INSERT INTO `web_dict` VALUES ('3', 'func_block', '功能块', '0', '元宝统计', '');
INSERT INTO `web_dict` VALUES ('4', 'func_block', '功能块', '1', '金币统计', '');
INSERT INTO `web_dict` VALUES ('5', 'func_block', '功能块', '2', '功能使用统计(人数去重)', '');
INSERT INTO `web_dict` VALUES ('6', 'func_block', '功能块', '3', '功能使用统计(人次)', '');
INSERT INTO `web_dict` VALUES ('7', 'awardlog_status', '兑奖状态', '0', '未处理', '');
INSERT INTO `web_dict` VALUES ('8', 'awardlog_status', '兑奖状态', '1', '处理中', '');
INSERT INTO `web_dict` VALUES ('9', 'awardlog_status', '兑奖状态', '2', '处理完毕', '');
INSERT INTO `web_dict` VALUES ('11', 'sdk_code', '充值SDK', '01', '移动MM', '');
INSERT INTO `web_dict` VALUES ('12', 'sdk_code', '充值SDK', '02', '联通wo', '');
INSERT INTO `web_dict` VALUES ('13', 'sdk_code', '充值SDK', '03', '电信', '');
INSERT INTO `web_dict` VALUES ('14', 'sdk_code', '充值SDK', '04', '神州付', '');
INSERT INTO `web_dict` VALUES ('15', 'sdk_code', '充值SDK', '05', '支付宝', '');
INSERT INTO `web_dict` VALUES ('16', 'sdk_code', '充值SDK', '06', '银联', '');
INSERT INTO `web_dict` VALUES ('17', 'activity_type', '活动类型', '0', '日赚金币', '');
INSERT INTO `web_dict` VALUES ('18', 'activity_type', '活动类型', '1', '月赚金币', '');
INSERT INTO `web_dict` VALUES ('19', 'activity_type', '活动类型', '2', '日最大倍率', '');
INSERT INTO `web_dict` VALUES ('20', 'activity_type', '活动类型', '3', '日最大玩牌数', '');
INSERT INTO `web_dict` VALUES ('21', 'activity_type', '活动类型', '4', '日单局赢金币', '');
INSERT INTO `web_dict` VALUES ('22', 'activity_type', '活动类型', '5', '仅展示', '');
INSERT INTO `web_dict` VALUES ('23', 'channel_mode', '推广模式', 'CPA', 'CPA', '');
INSERT INTO `web_dict` VALUES ('24', 'channel_mode', '推广模式', 'CPS', 'CPS', '');
INSERT INTO `web_dict` VALUES ('25', 'channel_mode', '推广模式', '联运', '联运', '');
INSERT INTO `web_dict` VALUES ('26', 'channel_mode', '推广模式', '其他', '其他', '');
INSERT INTO `web_dict` VALUES ('27', 'pay_type', '支付类型', '1', '话费支付', '话费支付');
INSERT INTO `web_dict` VALUES ('28', 'pay_type', '支付类型', '2', '神州付', '');
INSERT INTO `web_dict` VALUES ('29', 'pay_type', '支付类型', '3', '支付宝', '');
INSERT INTO `web_dict` VALUES ('30', 'pay_type', '支付类型', '4', '银联', '');
INSERT INTO `web_dict` VALUES ('31', 'hot_type', '计费点是否做活动优惠', '0', '否', '');
INSERT INTO `web_dict` VALUES ('32', 'sdk_code', '充值SDK', '10', '可可支付', '');
INSERT INTO `web_dict` VALUES ('33', 'pay_type', '支付类型', '5', '可可支付', '');
INSERT INTO `web_dict` VALUES ('34', 'channel_mode', '推广模式', 'free', '免费', '');
INSERT INTO `web_dict` VALUES ('35', 'feeback_status', '是否反馈', '0', '未处理', '');
INSERT INTO `web_dict` VALUES ('36', 'feeback_status', '是否反馈', '1', '已处理', '');
INSERT INTO `web_dict` VALUES ('37', 'channel_mode', '推广模式', 'CPC', 'CPC', '');
INSERT INTO `web_dict` VALUES ('38', 'award_do_type', '奖品兑换类型', '0', '未处理', '');
INSERT INTO `web_dict` VALUES ('39', 'award_do_type', '奖品兑换类型', '1', '处理中', '');
INSERT INTO `web_dict` VALUES ('40', 'award_do_type', '奖品兑换类型', '2', '已处理', '');
INSERT INTO `web_dict` VALUES ('41', 'award_do_type', '奖品兑换类型', '2', '处理完毕', '');
INSERT INTO `web_dict` VALUES ('42', 'sdk_code', '充值SDK', '12', '悠悠村', '');
INSERT INTO `web_dict` VALUES ('43', 'sdk_code', '充值SDK', '08', '移动弱', '');
INSERT INTO `web_dict` VALUES ('44', 'pay_limit_type', '防刷类型', 'uid', '用户ID', '');
INSERT INTO `web_dict` VALUES ('45', 'pay_limit_type', '防刷类型', 'imsi', 'sim卡', '');
INSERT INTO `web_dict` VALUES ('46', 'pay_limit_type', '防刷类型', 'imei', '手机设备', '');
INSERT INTO `web_dict` VALUES ('47', 'sdk_code', '充值SDK', '09', '和游戏', '和游戏');
INSERT INTO `web_dict` VALUES ('48', 'channel_mode', '推广模式', '预装渠道', '预装渠道', '预装渠道');
INSERT INTO `web_dict` VALUES ('49', 'pay_type', '支付类型', '6', '悠悠村', '');
INSERT INTO `web_dict` VALUES ('50', 'pay_type', '支付类型', '7', '移动弱联网', '');
INSERT INTO `web_dict` VALUES ('51', 'pay_type', '支付类型', '8', '和游戏', '');
INSERT INTO `web_dict` VALUES ('52', 'fight_awardtype', '奖励类型', '0', '金币', '');
INSERT INTO `web_dict` VALUES ('53', 'fight_awardtype', '奖励类型', '1', '元宝', '');
INSERT INTO `web_dict` VALUES ('54', 'fight_awardtype', '奖励类型', '2', '话费', '');
INSERT INTO `web_dict` VALUES ('55', 'pay_type', '支付类型', '9', '腾讯支付', '');
INSERT INTO `web_dict` VALUES ('56', 'sdk_code', '充值SDK', '13', '腾讯支付', '');
INSERT INTO `web_dict` VALUES ('57', 'sdk_code', '充值SDK', '18', 'MM支付special', '移动MM弱联网特殊支付');
INSERT INTO `web_dict` VALUES ('58', 'pay_type', '支付类型', '18', 'MM支付special', '');
INSERT INTO `web_dict` VALUES ('59', 'pay_special_app', '应用名称', 'com.chjie.dcow', '土豪牛牛', '');
INSERT INTO `web_dict` VALUES ('60', 'pay_special_flag', '规则类型', '0', '所有', '');
INSERT INTO `web_dict` VALUES ('61', 'pay_special_flag', '规则类型', '1', '商城', '');
INSERT INTO `web_dict` VALUES ('62', 'pay_special_flag', '规则类型', '2', '付费坑', '');
INSERT INTO `web_dict` VALUES ('63', 'pay_special_app', '应用名称', 'com.tencent.tmgp.wbl.dcow', '土豪牛牛送话费', '腾讯');
INSERT INTO `web_dict` VALUES ('64', 'pay_special_sdk', 'SDK类型', '1', 'SDK-18', '');
INSERT INTO `web_dict` VALUES ('65', 'pay_special_sdk', 'SDK类型', '2', 'SDK01斗地主', '');
INSERT INTO `web_dict` VALUES ('66', 'channel_mode', '推广模式', 'CPM', 'CPM', '');
INSERT INTO `web_dict` VALUES ('67', 'pay_type', '支付类型', '15', 'MM破解', '');
INSERT INTO `web_dict` VALUES ('68', 'pay_type', '支付类型', '16', '益玩SDK', '');
INSERT INTO `web_dict` VALUES ('69', 'sdk_code', '充值SDK', '15', 'MM破解', '移动MM弱联网特殊支付');
INSERT INTO `web_dict` VALUES ('70', 'sdk_code', '充值SDK', '16', '益玩SDK', '');

-- ----------------------------
-- View structure for view_player_edit
-- ----------------------------
DROP VIEW IF EXISTS `view_player_edit`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_player_edit` AS select `player`.`id` AS `id`,`player`.`user` AS `user`,`player`.`name` AS `name`,`player`.`password` AS `password`,`player`.`money` AS `money`,`player`.`coin` AS `coin`,'' AS `memo` from `player` ;
DROP TRIGGER IF EXISTS `t_stat_user_daily_order_upd`;
DELIMITER ;;
CREATE TRIGGER `t_stat_user_daily_order_upd` AFTER UPDATE ON `payorder` FOR EACH ROW BEGIN
	
	 
	DECLARE t_count INT;
	DECLARE trmb INT ; 
	DECLARE vdt DATE ;
	 
	SET trmb = 0;	
	SET t_count = 0;
	SET vdt = CURDATE() ;
	
	IF (new.success = 1 AND old.success = 0) THEN		 
	    SELECT COUNT(0) INTO t_count FROM cms.stat_user_daily_order WHERE uid=new.uid AND dt=vdt ;		
	    SELECT total_rmb INTO trmb FROM cms.stat_user_daily_order WHERE uid=old.uid AND dt<=vdt ORDER BY dt DESC LIMIT 1 ;
	    IF t_count = 0 THEN
	    	INSERT INTO cms.stat_user_daily_order(uid, dt, rmb, total_rmb ) VALUES (new.uid, vdt, new.rmb, new.rmb + IFNULL(trmb,0) ) ;
	    ELSE
	    	UPDATE cms.stat_user_daily_order SET rmb=rmb + new.rmb, total_rmb=total_rmb + new.rmb WHERE uid=new.uid AND dt=vdt;
	    END IF;
	    
	END IF;
	
    END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `trigger_pay_limit_insert`;
DELIMITER ;;
CREATE TRIGGER `trigger_pay_limit_insert` AFTER INSERT ON `pay_limit` FOR EACH ROW BEGIN
		INSERT INTO pay_limit_log(limit_key,limit_value,day_rmb,month_rmb,day_rmb_old,month_rmb_old,who,memo)
			VALUES(new.limit_key,new.limit_value,new.day_rmb,new.month_rmb,new.day_rmb_old,new.month_rmb_old,new.who,new.memo);
    END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `trigger_pay_limit_update`;
DELIMITER ;;
CREATE TRIGGER `trigger_pay_limit_update` AFTER UPDATE ON `pay_limit` FOR EACH ROW BEGIN
		IF (old.day_rmb != new.day_rmb || old.month_rmb != new.month_rmb) THEN
	    	INSERT INTO pay_limit_log(limit_key,limit_value,day_rmb,month_rmb,day_rmb_old,month_rmb_old,who,memo)
			VALUES(new.limit_key,new.limit_value,new.day_rmb,new.month_rmb,new.day_rmb_old,new.month_rmb_old,new.who,new.memo);
		END IF ;
    END
;;
DELIMITER ;
