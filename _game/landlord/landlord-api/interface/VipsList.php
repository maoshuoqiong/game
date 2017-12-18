<?php
	/**
	 * 获取award列表
	 */
    class VipsList extends APIBase {
		
		public $tag = "VipsList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("svips");
			$prizeArr = json_decode($prizeStr);
// 			var_dump($prizeArr);
			$this->returnData(array('vips' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>