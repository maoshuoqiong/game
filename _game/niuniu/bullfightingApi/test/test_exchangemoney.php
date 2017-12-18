<?php

/*
 * action : ExchangeMoney
 * param: uid、skey、goods_id
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

// $action = "ExchangeMoney";
$action = "PayMoney";

$param = array();
$param['goods_id'] = 1;
// $param['vid'] = 1;
$param['orderId'] = "140625533000000697775773";
$param['req'] = "server";

$query = array();

$query['action'] = $action;
$query['uid'] = 10000;
$query['skey'] = "cc65158d686de543f89ba9e7357ce4db";

$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>