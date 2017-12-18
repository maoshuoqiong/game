<?php

/*
 * action : LoginReward
 * param: uid、skey
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "LoginReward";

$param = array();
$query = array();

$param['actType']= "rres";
// $param['actType']= "rlist";
$query['param'] = json_encode($param);

$query['action'] = $action;
$query['uid'] = 268;
$query['skey'] = "79a69280cd663159ac9ce90c91aebb86";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>