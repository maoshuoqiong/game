<?php
	/**
	 * 获取场馆列表
	 */
    class VenueList extends APIBase {
		
		public $tag = "VenueList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("svelist");
			$prizeArr = json_decode($prizeStr);
			foreach ($prizeArr as $g) {
				$g->olnum = mt_rand(200, 800);								
			}
			
			$this->returnData(array('venues' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>