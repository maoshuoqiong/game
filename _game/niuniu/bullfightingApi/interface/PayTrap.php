<?php
/**
	 * 获取付费坑信息
	 * @test  http://203.86.3.245:88/api.php?uid=1510&skey=f95d87d0412fb03a182cd464e58bea6e&action=PayTrap&param={%22pos%22:%220%22,%20%22trap%22:%220%22,%20%22mac%22:%22%22,%20%22ip%22:%22%22,%20%22sdk%22:%2201%22}
	 * 
	 */
class PayTrap extends APIBase {
	public $tag = "PayTrap";
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis();
		return true;
	}
	public function logic() {
		$uid = $_GET ['uid'];
		$mac = "";
		if (isset ( $this->param ['mac'] )) {
			// 把分隔符":" 替换为""
			$mac = str_replace ( ":", "", $this->param ['mac'] );			
		}
		
		$ip = isset($this->param ['ip']) ? $this->param ['ip'] : "";
		$pos = isset($this->param ['pos']) ? (int) $this->param ['pos'] : -1;
		$trap = isset($this->param ['trap']) ? (int) $this->param ['trap'] : -1;
		$sdk_get = isset($this->param ['sdk']) ? $this->param ['sdk'] : "01";
		
		//获取用户设备标识
		$user_info = $this->data_redis->hMget ( "hu:$uid", array (
				'imsi',
				'imei',
				'pkg',
				'ver',
				'channel'
		) );
		
		$pkg = isset($user_info['pkg']) ?  $user_info['pkg'] : "";
		$channel = isset($user_info['channel']) ?  $user_info['channel'] : "";		
		// 益玩SDK
		if (stripos($pkg, "com.chjie.dcow.ewan") !== false ) {
			//$this->returnError(301, "no data");
		}
			
		$sdk = '';
		$rmb = '';
		//返回信息
		$ret_info = array ();		
		$apptype = 1;
		// 获取用户的package、channel
		$sql = "select apptype from trap_apptype where package='{$pkg}' and channel='{$channel}'";
		$row = $this->mysql->find ( $sql );
		if (count ( $row ) > 0) {
			$apptype = (int) $row[0]['apptype'];
		}
		else {
			$apptype = 1;
		}
		
		// 根据sdk rmb 查找 计费点信息，判断有效性
		$sql = "select * from trap_info where isopen=1 and pos='{$pos}' and trap='{$trap}' and apptype='{$apptype}'";
		$row = $this->mysql->find ( $sql );
		$info = array();
		foreach ( $row as $r ) {
			//$info['sdk'] = $r['sdk'];
			$info['rmb'] = (int) $r['rmb'];
			$info['money'] = (int) $r['money'];
			$info['coin'] = (int) $r['coin'];
			$info['isgoods'] = (int) $r['isgoods'];
			
			$sdk = $r['sdk'];
			if (strcmp ( $sdk, "01" ) == 0) {
				//这里 01 表示话费支付
				$sdk = $sdk_get;
			}			
			$rmb = $r['rmb'];
		}
				
		// 根据sdk rmb 查找 计费点信息，判断有效性		
		$sql = "select b.money,b.coin,b.rmb from pay_sdk a join pay_points b on a.id=b.pay_sdk_id where a.sdk='{$sdk}' and b.rmb='{$rmb}'";
		$row = $this->mysql->find ( $sql );
		foreach ( $row as $r ) {
			$info['moneydef'] = (int) $r['money'];
			//$info['coindef'] = $r['coin']; 
		}
		
		//取到坑数据
		if(!empty($info)) {									
			$sdk_old = $sdk;			
			//判断是否有话费卡 ,如果没有，则换为支付宝支付
			$imsi = isset($user_info['imsi']) ?  $user_info['imsi'] : "";
			if (strlen($imsi) < 5  ) {
				$sdk = "05";
			}
			
			//电信、联通的，需判断是否支持计费
			$ver = (int) $user_info['ver'];			
			if ($sdk == "03") {
				//if ($ver < 3) {
					//判断是否联通测试渠道					
					if (  strcmp ( $pkg, "com.chjie.dcow.nearme.gamecenter" ) == 0) {
						$sdk = "10";
					}
					else {
						//3以下不支持联通、电信计费，则换为支付宝
						$sdk = "05";
					}
				//}		
			}
			if ($sdk == "02") {
				$pkg = isset($user_info['pkg']) ?  $user_info['pkg'] : "";
				if ( $ver < 3 && strcmp ( $pkg, "com.chjie.dcow" ) == 0) {
					$sdk = "05";
				}
			}
					
			
			$info['sdk'] = $sdk;
			
			$order_id = $this->get_pay_order($sdk, $rmb,$pkg);
			
			//从登录日志表里面获取
			$imei = $user_info['imei'];
			// $imsi = $user_info['imsi'];	
			// 记录订单日志
			$order_log = array();
			$order_log['money'] = $info['money'];
			$order_log['coin'] = $info['coin'];
			$order_log['rmb'] = $info['rmb'];
			$order_log['sdk'] = $sdk;
			$order_log['uid'] = $uid;
			$order_log['order_id'] = $order_id;
			$order_log['mac'] = $mac;
			$order_log['ip'] = $ip;
			$order_log['updated_at'] = date ( 'Y-m-d H:i:s' );
			$order_log['created_at'] = date ( 'Y-m-d H:i:s' );	
			$order_log['istrap'] = 1;

			// 2014.11.27 add rmb_fen , money0			
			// 获取用户当前金币数
			$money0 = (int) $this->data_redis->hGet("hu:{$uid}", "money" );
			$tmp_rmb = (int)(100 * $order_log['rmb']);
			$order_log['rmb_fen'] = $tmp_rmb;
			$order_log['money0'] = $money0;
			
			//产生订单记录
			$this->mysql->insert ( "payorder", $order_log );
			
			//记录坑的订单信息
			$trap_log = array();
			$trap_log['order_id'] = $order_id;
			$trap_log['uid'] = $uid;
			$trap_log['imei'] = $imei;
			$trap_log['imsi'] = $imsi;
			$trap_log['trap_pos'] = $pos;
			$trap_log['trap_id'] = $trap;
			$trap_log['sdk_old'] = $sdk_old;
			$this->mysql->insert ( "trap_order", $trap_log );
			
			//返回坑信息
			$info ["orderId"] = $order_id;
			$this->returnData ( $info );			
		}
		else {
			$this->returnError(301, "no data");
		}
		
	}
	
	public function after() {
		$this->deinitMysql ();
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
	}
}
?>