<?php

include_once("httpclient.php");
include_once('config.php');
include_once('mysql.php');
/*
$mysql = new Mysql();
$ret = $mysql->connect(Config::$mysql_config);
if (!$ret) {
	echo("db connect error.");
}
$result = $mysql->find("select * from player");
print_r($result);
$mysql->close();
*/

function login($name, $password) {
	$url_prefix = Config::$url_prefix;

	$action = "Login";

	$param = array();
	$param['user'] = $name;
	$param['password'] = $password;

	$query = array();

	$query['action'] = $action;
	$query['param'] = json_encode($param);

	$url = $url_prefix . http_build_query($query);

	$client = new HttpClient();
	echo "<pre />";
	echo $client->get($url);
}

function http_post($url, $arr_data = null) {
    $context = array ();
    if (is_array ( $arr_data )) {
        ksort ( $arr_data );
        $context ['http'] = array (
            'timeout' => 60,
            'method' => 'POST',
            'content' => @http_build_query ( $arr_data, '', '&' )
        );
    }
    $ret = @file_get_contents ( $url, false, stream_context_create ( $context ) );

    return $ret;
}

function http_get($url, $arr_data) {
    $opts = array (
        'http' => array (
            'method' => "GET",
            'timeout' => 60
        )
    );
    if (! empty ( $arr_data )) {
        $query = @http_build_query ( $arr_data );
        $url = $url . '?' . $query;
    }
    $context = stream_context_create ( $opts );
    $ret = @file_get_contents ( $url, false, $context );
    return $ret;
}

function callQx(){
    $url = 'http://120.26.119.149:9101/qy/nnpayres/mr2';
    $query = array();
    $query['orderId'] = '1424445684848';
    $query['rmb'] = 10;
    $query['channel'] = '3000554984';
    $jstr = http_get($url, $query);
    echo 'you resp is:'.$jstr.'<br/>';
    // 接受成功则回写succ，否则失败
    if($jstr == 'ok'){
        echo 'test call back succ~~~~';
    }
}

callQx();

/* $url = "http://121.40.68.234:8888/paybull/mmcrack";
$query = array();
$query['gprice'] = "10";
$query['gid'] = "000000000000";
$query['imei'] = "864910020686700";
$query['imsi'] = "460024090702238";
$query['os_model'] = "Coolpad+8089";
$query['os_info'] = "4.0.3";
$query['net_info'] = "WIFI";
$query['client_ip'] = "192.168.0.2";
$query['orderid'] = "94358173060220";
$jstr = http_post($url, $query);
echo $jstr; */
// login('aaaaaa', '123456');
// date_default_timezone_set('PRC');
//  echo date('w', 1410019260)."</br>";
// echo date('Y-m-d H:i:s', 1407982978)."</br>";
// echo floor(1898238*3/10);
// echo strtotime("2014-10-01 10:01:00")."\n"; 
?>
