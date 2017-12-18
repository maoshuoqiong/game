<?php

/*
 * action : Register
 * param: user、password、sex
 * return: uid、sex、money、rmb、coin、login_days、is_get、history[2] (total_win、total_lose)、total_borad、total_win、exp
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "ChannelRegLogin_QQ";

$param = array();

$param['channel'] = "QQ";
$param['package'] = "kkk.jj.gg.dd";
$param['ver'] = "1.8";
$param['ip'] = "127.0.0.1";
$param['imsi'] = "AAAA".rand(1, 10000);
$param['imei'] = "BBB".rand(1, 10000);
$param['mtype'] = "CCC".rand(1, 10000);

// $param['user'] = "aabb" . rand(1, 100000);
$param['openID'] = "oid".rand(1, 10000);
$param['tNikeName'] = "aabb".rand(1, 10000);
$param['tSex'] = rand(1, 2);
$param['tHeadImg'] = "nnnnnnn";
$param['access_token'] = "accc".rand(1, 10000);
$param['refresh_token'] = "ref".rand(1, 10000);
$param['utype'] = "qq";
// $param['type'] = "wx";

$query = array();

$query['action'] = $action;
$query['param'] = json_encode($param);

$url = $url_prefix . http_build_query($query);

$client = new HttpClient();
echo "<pre />";
echo $client->get($url); 
?>