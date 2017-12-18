<?php

/*
 * action : VenueList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Stat_Func";

$param = array();

$query = array();

$query['action'] = $action;
// $param['at']= "list";
$param['st']= "2014-03-28";
$param['et']= "2014-04-04";
$param['type']= "playTime";
// $param['type']= "money";
$query['param'] = json_encode($param);

// echo $query['param'];
$url = $url_prefix . http_build_query($query);
$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>