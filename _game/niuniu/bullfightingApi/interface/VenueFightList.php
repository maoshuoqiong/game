<?php
	/**
	 * 获取场馆列表
	 */
    class VenueFightList extends APIBase {
		
		public $tag = "VenueFightList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("sveFightlist");			
			$prizeArr = json_decode($prizeStr);
			foreach ($prizeArr as $g) {			
				/* $arr = $g->online;
				if (isset($arr) && count($arr) > 0 ) {
					$g->olnum = mt_rand((int) $arr[0], (int) $arr[1]);										
				}
				else { */
					$g->olnum = mt_rand(200, 800);
				/* }
				unset($g->online); */								
			}			
			$this->returnData(array('venues' => $prizeArr));
		}
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>