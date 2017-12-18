<?php
	/**
	 * 心跳
	 */
    class HeartBeat extends APIBase {
		
		public $tag = "HeartBeat";
		
		public function before() {
			return true;
		}
		
		public function logic() {
			$this->data_redis->hSet("hu:{$this->uid}", "heartbeat_at", time());
			/* $pay_info = $this->data_redis->hmGet("hu:{$this->uid}", array('pay_ok', 'pay_ng'));
			$pay_ok = (int)$pay_info['pay_ok'];
			$pay_ng = (int)$pay_info['pay_ng'];
			if ($pay_ok > 0) {
				$this->data_redis->hincrBy("hu:{$this->uid}", "pay_ok", 0 - $pay_ok);
			}
			if ($pay_ng > 0) {
				$this->data_redis->hincrBy("hu:{$this->uid}", "pay_ng", 0 - $pay_ng);
			}
			$data = array();
			$data['pay_ok'] = $pay_ok;
			$data['pay_ng'] = $pay_ng; */
			$data['pay_ok'] = 0;
			$data['pay_ng'] = 0;
			$this->returnData($data);
		}
		
    		
		public function after() {
    		$this->deinitDataRedis();
		}
    }
?>