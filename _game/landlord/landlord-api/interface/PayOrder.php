<?php
	/**
	 * 在支付前生成系统的订单号
	 * @test http://api.53jiankang.com:88/api.php?uid=32308&skey=2a0ccf663061299553fbb46319d49dc4&action=PayOrder&param={"goods_id":"1", "sdkId":"01", "appkey":"", "point":"", "mac":""}
	 */
    class PayOrder extends APIBase {
		
		public $tag = "PayOrder";
		
		public function before() {
			$this->initMysql();
			return true;
		}
		
		public function logic() {
			$uid =  $_GET['uid'];
			if (!isset($this->param['goods_id']) || !isset($this->param['sdkId'])) {
				$this->returnError(300, 'goods_id, sdkId is needed');
			}
			
			//返回订单信息
			$order_info = array();
			
			$sdk_id = "";
			$goods_id = 0;
			$appkey = "";
			$point = "";
			$mac = "";
			$ip = "127.0.0.1";
			
			$vid = 0;
			
			if (isset($this->param['goods_id'])) {
				$goods_id = (int) $this->param['goods_id'];	
			}
			if (isset($this->param['sdkId'])) {
				$sdk_id = $this->param['sdkId'];	
			}
			
			if (isset($this->param['appkey'])) {
				$appkey = $this->param['appkey'];	
			}
			if (isset($this->param['point'])) {
				$point = $this->param['point'];	
			}
			if (isset($this->param['ip'])) {
				$ip = $this->param['ip'];	
			}
			// 20140422
			if (isset($this->param['vid'])) {
				$vid = (int) $this->param['vid'];
				$order_info["vid"] = $vid;
			}
			
			if (isset($this->param['mac'])) {
				//把分隔符":" 替换为""
				$mac = str_replace(":", "" , $this->param['mac']);
				//save mac
				//if (strlen($mac) >= 6) {
				//	$this->updateMac($uid, $mac);
				//}
			}
			
			// 电信、和游戏订单号
			if (strcmp($sdk_id,"04") == 0 || strcmp($sdk_id,"09") == 0) {
				//如果是电信的，则获取16位订单号
				$order_id = $this->build_order_ct();
			}
			else {
				$order_id = $this->build_order();	
			}
			
			//记录订单日志			
			$this->addOrderLog($uid, $goods_id, $sdk_id, $order_id, $appkey, $point, $mac, $ip, $vid);
			
			
			$order_info["orderId"] = $order_id;
			$order_info["goods_id"] = $goods_id;
			$order_info["sdkId"] = $sdk_id;
					
			$this->returnData($order_info);
		}
		
		 		
		public function addOrderLog($uid, $goods_id, $sdk_id, $order_id, $appkey, $point, $mac, $ip, $vid) {
			$now = date('Y-m-d H:i:s');
			$order_log = array(
				'uid'=> $uid,
				'goods_id'=> $goods_id,
				'sdk'=> $sdk_id,
				'order_id' => $order_id,
				'mac' => $mac,
				'ip' => $ip,
				'vid' => $vid,
				'created_at' => $now
			);
			//如果appkey有效，则增加
			if (isset($appkey) && strlen($appkey) > 0) {
				$order_log["appkey"] = $appkey;
				$order_log["point"] = $point;				
			}
							
			$this->mysql->insert("payorder", $order_log);
		}
		
		//24位数的订单号
    	function build_order() {
		    $id= rand(1,1234567890);
		    $pre = sprintf('%014d', $id );
		    $order = time().$pre ;
		    
		    return $order;
		}		
		
    	//16位数的订单号--电信
    	function build_order_ct() {
		    $id= rand(1,123456);
		    $pre = sprintf('%06d', $id );
		    $order = time().$pre ;		    
		    return $order;
		}
		
		
    	public function updateMac($uid, $mac) {			
    		$this->mysql->update("playermark", array('mac' => $mac), array('uid' => $uid));
		}
		
		
        public function after() {
    		$this->deinitMysql();
		}
		
		
	    
    }
?>