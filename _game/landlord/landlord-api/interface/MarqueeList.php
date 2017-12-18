<?php
	/**
	 * 喊话列表
	 */
    class MarqueeList extends APIBase {
		public $tag = "MarqueeList";
		public $isLogin = false;
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {	
			$prizeStr = $this->cache_redis->get("sSpeakerList");
			if (!$prizeStr) {
				$this->returnError(301, "暂无人喊话");
				return;
			}
			$prizeArr = json_decode($prizeStr);
			$this->returnData(array('rec' => $prizeArr));
		}
		
		public function after() {
			$this->deinitCacheRedis();
		}
    }
?>