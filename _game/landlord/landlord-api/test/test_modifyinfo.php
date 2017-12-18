<?php

/*
 * action : ModifyInfo
 * param: uid、skey、name、sex
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "ModifyInfo";

$param = array();
$param['name'] = 'dadizhu';
$param['sex'] = 2;

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