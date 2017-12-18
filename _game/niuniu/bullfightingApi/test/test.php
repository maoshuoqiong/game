<?php
include_once '../lib/commonTool.php';

$p = $_GET ['phn'];

echo $p . "<br/>";

$ret = CommonTool::preg_mobile ( $p );
echo "result:" . $ret . "   <br/>";

//$user_reg = '/^[a-zA-Z0-9]{4,20}$/'; // '/^[a-z\d_]{6,18}$/i'
                                     
$user_reg = '/^[a-z\d_]{6,18}$/i';
                                     // $user_reg = '/^[a-zA-Z0-9]{4,20}$/';
$str =$_GET ['user'];
echo $str . ":" . $user_reg . "<br/>";
$ret = preg_match ( $user_reg, $str );

echo $ret . "<br/>";

?>
