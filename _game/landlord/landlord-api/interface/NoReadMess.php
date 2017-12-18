<?php
	/**
	 * 是否有未读消息
	 */
    class NoReadMess extends APIBase {
		
		public $tag = "NoReadMess";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$hasNoRead = CommonTool::hasNoReadMes($this->cache_redis,$this->data_redis,$this->uid);
			$this->returnData(array('noread' => $hasNoRead));
		}
		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
		}
    }
?>