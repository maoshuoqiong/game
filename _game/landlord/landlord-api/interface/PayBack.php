<?php
/**
	 * 客户端支付完成后，当支付不成功，回调该接口记录失败原因。
	 */

// http://203.86.3.245:88/api.php?uid=298&skey=52f04e8f0595198f7070d455f1a4a860&action=PayMoney&param={%22orderId%22:%22140412282400000264406642%22,%22req%22:%22server%22}
class PayBack extends APIBase {
	public $tag = "PayBack";
	public function before() {
		$this->initMysql ();
		return true;
	}
	public function logic() {
		$orderId = isset($this->param ['orderId']) ? $this->param ['orderId'] : "";
		
		if (! isset ( $orderId )) {
			$this->returnError ( 300, 'orderId is needed' );
		}
		
		$ok = isset($this->param ['ok']) ? $this->param ['ok'] : "" ;
		
		$this->addPayBackLog($this->uid , $orderId, $ok);
		 
	}
	 
	public function addPayBackLog($uid, $orderId, $ok) {
		$paybacklog = array (
				'uid' => $uid,
				'order_id' => $orderId,
				'ok' => $ok 
		);
		
		$this->mysql->insert ( "payback_log", $paybacklog );
	}
	 
	public function after() {
		$this->deinitDataRedis ();
		$this->deinitMysql ();
	}
}
?>