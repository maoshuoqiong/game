<?php

/*
 * action : BrokeGet
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "GuideAward";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 270;
$query['skey'] = "dcc39277a1b2754f7cf625d11bdbd98a";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>