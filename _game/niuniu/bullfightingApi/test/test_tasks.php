<?php

/*
 * action : Register
 * param: user、password、sex
 * return: uid、sex、money、rmb、coin、login_days、is_get、history[2] (total_win、total_lose)、total_borad、total_win、exp
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Tasks";


$param = array();
$param['ttype'] = "achList";
// $param['ttype'] = "dayList";
// $param['id'] = 40;

$query = array();

$query['action'] = $action;
$query['uid'] = 10166;
$query['skey'] = "60ba5299d31eb38d792a1be9b061402c";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url); 
?>