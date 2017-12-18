<?php
/**
 * 联运公共配置类
 * @author Administrator
 */
class ChannelInfo {
	// QQ 鉴权
	public static $qq_auth_url = "http://msdktest.qq.com/";
	public static $qq_appid = "1103196398"; 						
	public static $qq_appkey = "UGUn7v8JPy3tDwhV"; 	
	// 微信鉴权					
	public static $wx_appid = "wxe26162a0cfe1165b";
	public static $wx_appkey = "73536a1bf82a783e98a0e83d85616d2f";
	public static $proxy_ip = "182.254.211.73";
	public static $proxy_port = 8318;
	// 斯凯冒泡社区支付渠道号
	public static $sky_pay_channel = array(
		'def'=>'18_zhiyifu_',
		'00000001'=>'1_zhiyifu_',
		'00000002'=>'9_zhiyifu',
		'00000003'=>'18_zhiyifu_'
	);
}

?>
