<?php

/*
 * action : ModifyInfo
 * param: uid、skey、name、sex
 * 
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "ModifyInfoNew";

// for($i=1300;$i<=1500;$i++){
	$param = array();
	$param['name'] = "东方不败不败";
	$param['sex'] = 2;
	
	$query = array();
	
	$query['action'] = $action;
	$query['uid'] = 271;
	$query['skey'] = "ffffffffffffffffffffffffffffffffffff";
	$query['param'] = json_encode($param);
	
	$url = $url_prefix . http_build_query($query);
	
	$client = new HttpClient();
	echo "<pre />";
	echo $client->get($url);
// }

?>