<?php

/*
 * action : VenueList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Lottery";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 1;
$query['skey'] = "ffffffffffffffffffffffffffffffffffff";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>