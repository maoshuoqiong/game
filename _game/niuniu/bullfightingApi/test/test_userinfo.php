<?php

/*
 * action : UserInfo
 * param: uid、skey
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "UserInfo";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$query['skey'] = "a3c07c3936564b3b5854c4b6e1da6356";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>