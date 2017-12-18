<?php

/*
 * action : Feedback
 * param: uid、skey、content
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Feedback";

$param = array();
$param['content'] = '你们的游戏做得真是好啊。～～～';

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