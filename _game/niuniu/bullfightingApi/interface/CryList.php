<?php
	/**
	 * 喊话列表
	 */
    class CryList extends APIBase {
		public $tag = "CryList";
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
			$this->returnData(array('mes' => $prizeArr));
		}
		
		public function after() {
			$this->deinitCacheRedis();
		}
    }
?>