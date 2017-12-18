<?php

/*
 * action : MessageList
 * param: uid、skey
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "SysMessList";

$param = array();
$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$query['skey'] = "9f7d9557740a020ba053a7ee22f2e7e9";

// $param['id'] = 14;
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>