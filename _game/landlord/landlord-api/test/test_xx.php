<?php

include_once("httpclient.php");
include_once('config.php');
include_once('mysql.php');
/*
$mysql = new Mysql();
$ret = $mysql->connect(Config::$mysql_config);
if (!$ret) {
	echo("db connect error.");
}
$result = $mysql->find("select * from player");
print_r($result);
$mysql->close();
*/

function login($name, $password) {
	$url_prefix = Config::$url_prefix;

	$action = "Login";

	$param = array();
	$param['user'] = $name;
	$param['password'] = $password;

	$query = array();

	$query['action'] = $action;
	$query['param'] = json_encode($param);

	$url = $url_prefix . http_build_query($query);

	$client = new HttpClient();
	echo "<pre />";
	echo $client->get($url);
}

login('aaaaaa', '123456');
login('bbbbbb', '123456');
login('cccccc', '123456');

?>