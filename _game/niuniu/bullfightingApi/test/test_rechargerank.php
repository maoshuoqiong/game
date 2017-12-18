<?php

/*
 * action : RankList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "RechargeRank";

$param = array();
$query = array();

$query['action'] = $action;

$query['uid'] = 9457;
$query['skey'] = "41f2bba52f219589096faff1a6d23b88";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>