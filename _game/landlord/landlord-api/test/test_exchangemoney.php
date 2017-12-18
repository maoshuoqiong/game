<?php

/*
 * action : ExchangeMoney
 * param: uid、skey、goods_id
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "ExchangeMoney";

$param = array();
$param['goods_id'] = 2;

$query = array();

$query['action'] = $action;
$query['uid'] = 31;
$query['skey'] = "ffffffffffffffffffffffffffffffffffff";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>