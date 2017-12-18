<?php
	/**
	 * 获取MoreGame列表
	 */
    class MoreGame extends APIBase {		
		public $tag = "MoreGame";
		public $isLogin = false;
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (isset ( $_GET ['isChess'] )) {				
				$prizeStr = $this->cache_redis->get("scMoregame");
			}else{
				$prizeStr = $this->cache_redis->get("sMoregame");
			}
			$prizeArr = json_decode($prizeStr);
// 			var_dump($prizeArr);
			$this->returnData(array('res' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>