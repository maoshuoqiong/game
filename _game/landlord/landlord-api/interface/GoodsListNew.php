<?php
	/**
	 * 获取goods列表
	 */
    class GoodsListNew extends APIBase {
		
		public $tag = "GoodsListNew";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$pkg = isset($this->param['pkg']) ? $this->param['pkg'] : "";
			
			if (!empty($pkg)) {
				$key = "sglist_channel:" . $pkg ;				
				$prizeStr = $this->cache_redis->get($key);
				$prizeArr = json_decode($prizeStr);
				// 			var_dump($prizeArr);
				$this->returnData(array('goodses' => $prizeArr));
			}
			else {
				$prizeStr = $this->cache_redis->get("sgnlist");
				$prizeArr = json_decode($prizeStr);
	// 			var_dump($prizeArr);
				$this->returnData(array('goodses' => $prizeArr));
			}

			/*						
			if(strlen($pkg) == 0) {
				$pkg = 'def' ;
			}
			$prizeStr = $this->cache_redis->get("sgoods_channel:".$pkg);
			if(!$prizeStr){
				$prizeStr = $this->cache_redis->get("sgoods");
			}
			if(!$prizeStr){
				$prizeArr = json_decode($prizeStr);k
			    // var_dump($prizeArr);
				$this->returnData(array('goods' => $prizeArr));
			}
			else {
				$this->returnError("302", "no goods list.") ;
			}
			*/
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>