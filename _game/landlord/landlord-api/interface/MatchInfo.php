<?php
	/**
	 * 获取award列表
	 */
    class MatchInfo extends APIBase {
		
		public $tag = "MatchInfo";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("smatchInfo");
			$prizeArr = json_decode($prizeStr);
// 			var_dump($prizeArr);
			$this->returnData(array('res' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>