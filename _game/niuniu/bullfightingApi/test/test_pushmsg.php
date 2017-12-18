<?php

/*
 * action : Update
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "PushMsg";

$param = array();

$query = array();

$query['action'] = $action;
$query['param'] = json_encode($param);
$query['uid'] = 271;
$query['skey'] = "dfwegjidjglasdkjgkdkfjalfsdjoaisf";

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url);
?>