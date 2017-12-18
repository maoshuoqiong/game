<?php

/*
 * action : VenueList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Slot";

$param = array();

$query = array();

$query['action'] = $action;
$query['uid'] = 270;
$query['skey'] = "79a69280cd663159ac9ce90c91aebb86";
// $param['at']= "list";
$param['at']= "bet";
$param['ba']= "10000";
$zhu = array();

$zhu['i0'] = 1;
// $zhu['i-1'] = 1; 
// $zhu['i1'] = 1;
// $zhu['i2'] = 1;
// $zhu['i3'] = 1;
// $zhu['i4'] = 1;
// $zhu['i5'] = 1;
// $zhu['i6'] = 1;
// $zhu['i7'] = 1;
// $zhu['i8'] = 1;
$zhu['i9'] = 1;
$zhu['i10'] = 1;
$param['zhu']= json_encode($zhu);
$query['param'] = json_encode($param);

// echo $query['param'];
$url = $url_prefix . http_build_query($query);
$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>