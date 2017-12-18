<?php
	/**
	 * 获取award列表V19
	 */
    class AwardCoinList extends APIBase {
		
		public $tag = "AwardCoinList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("sAwardV19");
			$prizeArr = json_decode($prizeStr);
			$this->returnData(array('res' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>