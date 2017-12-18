<?php

/*
 * action : InitCache
 * param: 
 * return: 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "InitCache";

$param = array();
$param['venue'] = 1;
$param['announcement'] = 1;
$param['goods'] = 1;
$param['award'] = 1;
$param['rank'] = 1;
$param['pass'] = "ddzcache";

$query = array();

$query['action'] = $action;
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>