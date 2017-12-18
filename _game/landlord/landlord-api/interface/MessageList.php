<?php
	/**
	 * 消息列表
	 */
    class MessageList extends APIBase {
		
		public $tag = "MessageList";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$channel = 'def';
			if(isset($this->param['channel'])){
				$channel = $this->param['channel'];
			}
			$prizeStr = $this->cache_redis->get("smesslist:".$channel);
			$prizeArr = json_decode($prizeStr);
			$this->returnData(array('messages' => $prizeArr));			
		}
		
		public function after() {
			$this->deinitDataRedis();
			$this->deinitCacheRedis();
		}
    }
?>