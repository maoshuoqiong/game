<?php

/*
 * action : UserInfo
 * param: uid、skey
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "BroadcastList";

$param = array();

$query = array();
$query['action'] = $action;
$query['uid'] = 271;
$query['skey'] = "d40eee09be4ec19365da7cdb9a9b2abf";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>