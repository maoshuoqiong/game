<?php

/*
 * action : ExchangeAward
 * param: uid、skey、award_id
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "ExchangeAward";

$param = array();
$param['award_id'] = 2;
// $param['qq'] = 2558774589;
$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$query['skey'] = "53bc7a66c8fd55723e4d9304b35e5558";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
// echo $url."<br/>";
echo $client->get($url);
?>