<?php

/*
 * action : Update
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "Update";

$param = array();

$query = array();

$query['action'] = $action;
/* $param['cpId'] = "1000000mm000001";
$param['appId'] = "com.landlord.ddzmm.landlordmm.1"; */

$param['cpId'] = "100paymarket000031";
$param['appId'] = "com.landlord.ddzxh.1";
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>