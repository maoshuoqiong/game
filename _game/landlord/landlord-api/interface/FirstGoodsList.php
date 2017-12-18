<?php
	/**
	 * 获取首次充值goods列表
	 */
    class FirstGoodsList extends APIBase {		
		public $tag = "FirstGoodsList";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$hasRc = $this->data_redis->hGetAll("hpe:{$this->uid}");	
			$prizeStr = "";
			if(isset($hasRc['hasRecharge']) && $hasRc['hasRecharge']==1){
				$prizeStr = $this->cache_redis->get("sglist");
			}else{
				$prizeStr = $this->cache_redis->get("sgflist");
			}						
			$prizeArr = json_decode($prizeStr);
// 			var_dump($prizeArr);
			$this->returnData(array('goodses' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
    		$this->deinitDataRedis();
		}
    }
?>