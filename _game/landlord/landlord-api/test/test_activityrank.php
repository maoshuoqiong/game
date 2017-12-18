<?php

/*
 * action : BrokeGet
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "ActivityRank";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 9457;
$query['skey'] = "55a875d9e61bc7fcff2d3988d52ae9e4";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>
