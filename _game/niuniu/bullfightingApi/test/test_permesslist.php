<?php

/*
 * action : MessageList
 * param: uid、skey
 * 
 */

include_once("httpclient.php");
include_once('config.php');
header("Content-type: text/html; charset=UTF-8");
$url_prefix = Config::$url_prefix;

$action = "PerMessList";

$param = array();
$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$query['skey'] = "f5c0682b2720983a0dd02c62882c0a6d";

$param['id'] = 1;
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>