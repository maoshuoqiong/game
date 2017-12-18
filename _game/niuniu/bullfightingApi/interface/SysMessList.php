<?php
	/**
	 * 消息列表
	 */
    class SysMessList extends APIBase {
		
		public $tag = "SysMessList";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$prizeStr = $this->cache_redis->get("sysmess");
			if(!$prizeStr){
				$this->returnError(301, "暂无消息");
				return;
			}
			$prizeArr = json_decode($prizeStr);
			$ct = $this->data_redis->hGet("hu:{$this->uid}","create_time");
			$awardes = array();
			foreach ($prizeArr as $award) {
				if($ct>0 && $award->time<$ct){
					break;
				}
				$awardes[] = $award;
			}
			if(sizeof($awardes)<=0){
				$this->returnError(301, "暂无消息");
				return;
			}
			$this->returnData(array('mes' => $awardes));			
		}
		
		public function after() {
			$this->deinitDataRedis();
			$this->deinitCacheRedis();
		}
    }
?>