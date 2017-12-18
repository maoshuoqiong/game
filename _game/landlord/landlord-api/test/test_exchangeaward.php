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
$param['mobile'] = '13728085125';

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