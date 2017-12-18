<?php

/*
 * action : Register
 * param: user、password、sex
 * return: uid、sex、money、rmb、coin、login_days、is_get、history[2] (total_win、total_lose)、total_borad、total_win、exp
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Register";

/*  $param = array();

$param['password'] = "123456";
$param['sex'] = rand(1, 2);
$param['cpId'] = "1";
$param['appId'] = "1.1";

$query = array();
$query['action'] = $action;

for ($i=0;$i<5;$i++){
	$param['user'] = "big" . $i;
	$query['param'] = json_encode($param);
	$url = $url_prefix . http_build_query($query);

	$client = new HttpClient();
	echo "<pre />";
	echo $client->get($url);
} */

$param = array();
$param['user'] = "aabb" . rand(1, 100000);
$param['password'] = "123456";
$param['sex'] = rand(1, 2);
$param['imsi'] = "ccccccc";
$param['imei'] = "ddddddddd";
$param['mtype'] = "CCC";
$param['channel'] = "channel";
$param['package'] = "package";
$param['ver'] = "ver";
$param['ip'] = "ip";
$param['auto'] = "1";
$query = array();

$query['action'] = $action;
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url); 
?>