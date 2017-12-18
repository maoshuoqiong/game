<?php

/*
 * action : BrokeGet
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "PerMessSend";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$param['content'] = "时的快感5".rand(1, 10000);
$param['type'] = "feedback";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>