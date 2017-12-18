<?php

date_default_timezone_set('Asia/Shanghai');
//ini_set('error_reporting', 'E_ALL ^ E_NOTICE');
error_reporting(E_ALL);

class Config {
	public static $mysql_config = array(
		'host' => '127.0.0.1',
		'port' => 3306,
		'username' => 'ddz',
		'password' => 'Bull123qaZ.',
		'dbname' => 'bullfighting',
		'charset' => 'utf8',
	);
	public static $mysql_slave_config = array(
		'host' => '127.0.0.1',
		'port' => 3306,
		'username' => 'ddz',
		'password' => 'Bull123qaZ.',
		'dbname' => 'bullfighting',
		'charset' => 'utf8',
	);
	public static $mod = 5;
	public static $redis_data_config = array(
		'redis0' => array('host' => '127.0.0.1', 'port' => 6579, 'pass' => 'bullfighting'),
		'redis1' => array('host' => '127.0.0.1', 'port' => 6579, 'pass' => 'bullfighting'),
		'redis2' => array('host' => '127.0.0.1', 'port' => 6579, 'pass' => 'bullfighting'),
		'redis3' => array('host' => '127.0.0.1', 'port' => 6579, 'pass' => 'bullfighting'),
		'redis4' => array('host' => '127.0.0.1', 'port' => 6579, 'pass' => 'bullfighting'),
	);
	
	public static $redis_cache_config = array(
		'host' => '127.0.0.1',
		'port' => 6580,
		'pass' => 'bullfighting',
	);
	
	public static $log_agent = array(
		'host' => '10.171.194.228',
		'port' => 8001,
		'pass' => 'bfight'
	);
	
	public static $cache_pass = "lyx091027";
	
	public static $logger = null;
	
	public static $debug = false;
	
	public static $testUser = "263,257,255";
	
	public static $lotteryMaxTime = 3;
	// 机器人ID区间,需同步修改game里的
	public static $robotList = "345500,345800";
	// 百人牛牛庄家
	public static $robotBanker = 345501;
	public static $logger_request = null;
	public static $activity_url = "http://127.0.0.1:89/activity/";

    public static $gift_money = array(200, 500, 1000, 5000, 10000);

	//软件更新域名地址
	public static $url_update_app = "http://203.86.3.244:9090/bull/";
	public static $url_update_app_dir = array(
			'com.chjie.dcow.nearme.gamecenter' => 'http://203.86.3.244:9090/nearme/'
	);

	//银联支付tn获取地址
	#public static $url_upmp = "http://10.171.194.228:8888/paybull/upmpOrder";
	public static $url_upmp = "http://10.171.194.228:8888/unionpay/order";
	//imsi白名单
	public static $white_imsi = array('460030872266047','460012228602609','460001591367753',
		'460028802467000','460020180261420','460003402243567','460079738402056');
	//天翼WIFI通知地址
	public static $url_ct_wifi = "http://180.166.7.150/wificp/AppNotifyService";
	//天翼WIFI渠道号
	public static $channel_ct_wifi = "3003996346";
	// MM破解程序地址
	public static $mmcrack_url = "http://121.40.68.234:8888/paybull/mmcrack";
}


Config::$logger =  new Logger("logs/game.log");
Config::$logger_request =  new Logger("logs/request.log");

?>
