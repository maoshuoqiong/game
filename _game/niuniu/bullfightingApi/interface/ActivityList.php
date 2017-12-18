<?php
	/**
	 * 活动配置
	 */
    class ActivityList extends APIBase {
		
		public $tag = "ActivityList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("activitylist");
			if(!$prizeStr){
				$this->returnError(301, "暂无活动");
				return;
			}
			$prizeArr = json_decode($prizeStr);			
			$now = time();
			foreach ($prizeArr as $g) {
				if($g->st>$now || $g->et<$now){
					continue;
				}
				$resArr[] = $g;
			}	
// 			var_dump($resArr);
			$this->returnData(array('res' => $resArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>