<?php

class Config {
	public static $url_prefix = "http://192.168.1.109/bullfightingApi/api.php?";
// 	public static $url_prefix = "http://203.86.3.245:88/api.php?";
	public static $mysql_config = array(
		'host' => '127.0.0.1',
		'port' => 3306,
		'username' => 'root',
		'password' => '111111',
		'dbname' => 'bullfighting',
		'charset' => 'utf8',
	);
	
	public static $logger = null;
}
?>
