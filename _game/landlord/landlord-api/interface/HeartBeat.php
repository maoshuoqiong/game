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
			$data['pay_ok'] = 0;
			$data['pay_ng'] = 0;
			$this->returnData($data);
		}
		
    		
		public function after() {
    		$this->deinitDataRedis();
		}
    }
?>