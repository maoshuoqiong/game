<?php

/*
 * action : VenueList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
include_once('../lib/commonTool.php');
$url_prefix = Config::$url_prefix;

$action = "FlipCard";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$query['skey'] = "79a69280cd663159ac9ce90c91aebb86";
$param['type']= "start";
$param['type']= "change";
$param['type']= "end";
$param['betnum']= 10000;
$param['ind']= "2";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);
$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>