<?php

/*
 * action : VenueList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Pay_Rule";

$param = array();

$query = array();

$query['action'] = $action;
$query['imsi'] = "51989184654645";
$query['phn'] = "13418099964";
$query['appid'] = "125";
$query['param'] = json_encode($param);

// echo $query['param'];
$url = $url_prefix . http_build_query($query);
$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>