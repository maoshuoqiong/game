<?php

/*
 * action : GoodsList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "DownloadImag";

$param = array();
$query = array();

$query['action'] = $action;
$query['uid'] = 271;
$query['isbig'] = 1;
$query['skey'] = "ffffffffffffffffffffffffffffffffffff";
$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo $client->get($url);

?>