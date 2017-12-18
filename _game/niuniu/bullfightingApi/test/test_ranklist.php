<?php

/*
 * action : RankList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "RankList";

$param = array();
$query = array();

$query['action'] = $action;

$query['uid'] = 270;
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>