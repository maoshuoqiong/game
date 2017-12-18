<?php

date_default_timezone_set('Asia/Shanghai');
//ini_set('error_reporting', 'E_ALL ^ E_NOTICE');
error_reporting(E_ALL);

class Config {
	public static $mysql_config = array(
		'host' => '127.0.0.1',
		'port' => 3306,
		'username' => 'root',
		'password' => '',
		'dbname' => 'boss',
		'charset' => 'utf8',
	);
	
	public static $mysql_slave_config = array(
		'host' => '127.0.0.1',
                'port' => 3306,
                'username' => 'root',
                'password' => '',
                'dbname' => 'boss',
                'charset' => 'utf8',
	);
	
	public static $mod = 5;
	public static $redis_data_config = array(
		'redis0' => array('host' => '127.0.0.1', 'port' => 23000, 'pass' => 'yourpassword'),
		'redis1' => array('host' => '127.0.0.1', 'port' => 23000, 'pass' => 'yourpassword'),
		'redis2' => array('host' => '127.0.0.1', 'port' => 23000, 'pass' => 'yourpassword'),
		'redis3' => array('host' => '127.0.0.1', 'port' => 23000, 'pass' => 'yourpassword'),
		'redis4' => array('host' => '127.0.0.1', 'port' => 23000, 'pass' => 'yourpassword'),
	);
	
	public static $redis_cache_config = array(
		'host' => '127.0.0.1',
		'port' => 23000,
		'pass' => 'yourpassword',
	);
	
	public static $log_agent = array(
		'host' => '127.0.0.1',
		'port' => 23002,
		'pass' => 'yourpasswd'
	);
	
	public static $cache_pass = "lxx1027";
	
	public static $logger = null;
	
	public static $debug = false;
        
        public static $logger_request = null;
	
	public static $testUser = "";
	
	public static $lotteryMaxTime = 3;
	// 机器人ID区间,需同步修改game里的
	public static $robotList = "1000,1200";
	
	public static $activity_url = "http://203.86.3.249:89/";
//	public static $activity_url = "http://192.168.1.109/activity/";
}

Config::$logger =  new Logger("logs/ddz.log");

Config::$logger_request =  new Logger("logs/request.log");

?>
