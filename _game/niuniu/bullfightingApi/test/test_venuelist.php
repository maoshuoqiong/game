<?php

/*
 * action : VenueList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "VenueList";

$param = array();

$query = array();

$query['action'] = $action;
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);
// echo $url;
$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>