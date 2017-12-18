<?php
	/**
	 * 获取award列表V18
	 */
    class AwardListNew extends APIBase {
		
		public $tag = "AwardListNew";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("sAwardV18");
			$prizeArr = json_decode($prizeStr);
			$this->returnData(array('res' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>