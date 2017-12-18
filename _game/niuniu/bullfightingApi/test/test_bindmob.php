<?php

/*
 * action : VenueList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "BindMob";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 286;
$query['skey'] = "79a69280cd663159ac9ce90c91aebb86";
// $param['at']= "list";
$param['mob']= "13418099366";
$query['param'] = json_encode($param);

// echo $query['param'];
$url = $url_prefix . http_build_query($query);
$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>