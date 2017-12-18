<?php

/*
 * action : GoodsList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "GoodsList";
$action = "GoodsListNew";
// $action = "FirstGoodsList";
// $action = "FirstGoodsListNew";

$param = array();
$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$query['skey'] = "ffffffffffffffffffffffffffffffffffff";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>