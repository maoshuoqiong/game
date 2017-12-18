<?php

/*
 * action : GoodsList
 * param:
 * return:
 */

include_once("httpclient.php");
include_once('config.php');
$url_prefix = Config::$url_prefix;

$action = "UploadImag";

$param = array();
$query = array();

$query['action'] = $action;
$query['uid'] = 9457;
$query['skey'] = "3e137200a336186840810bcddcf5b5b7";
$url = $url_prefix . http_build_query($query);

// echo $url;
/* $client = new HttpClient();
echo "<pre />";
echo $client->get($url); */
?>

<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<head>
<title>图片上传DEMO</title>
</head>
<body>
<form id="upfile" name="upform" enctype="multipart/form-data" method="post" action="<?php echo $url?>">
  <label for="upfile">上传文件：</label>
  <input type="file" name="upfile" id="fileField" />
  <input type="hidden" name="ttt" id="fileField" value="444444" />
    <input type="hidden" name="yyyy" id="fileField" value="5555" />
  <input type="submit" name="submit" value="上传"/>
</form>
</body></html>