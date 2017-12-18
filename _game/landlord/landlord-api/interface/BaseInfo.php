<?php
	/**
	 * 获取用户信息
	 */
    class BaseInfo extends APIBase {
		
		public $tag = "BaseInfo";
		
        public function before() {
    		return true;
		}
		
		public function logic() {
			$user = $this->data_redis->hMget("hu:{$this->uid}",array("money","coin"));
			$pe = $this->data_redis->hMget("hpe:{$this->uid}", array("telCharge"));
			$user_info = array(
					'm' => (int) $user['money'],
					'c' => (int) $user['coin'],
					't' => isset($pe['telCharge']) ? (int)$pe['telCharge'] : 0
			);
			$this->returnData($user_info);
		}
		
       	public function after() {
    		$this->deinitDataRedis();
		}
    }
?>