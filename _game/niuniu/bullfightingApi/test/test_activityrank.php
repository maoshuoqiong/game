<?php

/*
 * action : UserInfo
 * param: uid、skey
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "ActivityRank";

$param = array();
$param['id'] = "6";

$query = array();
$query['action'] = $action;
$query['uid'] = 11952;
$query['skey'] = "7cb53f0a5700220e267a62be5126d4a2";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>