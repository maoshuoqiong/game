<?php
	/**
	 * 向客户端推送的通知栏消息
	 */
    class PushMsg extends APIBase {
		
		public $tag = "PushMsg";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$prizeStr = $this->cache_redis->hGetAll("hpushmsg");
			if(!$prizeStr || $prizeStr['msg']==""){
				$this->returnError(301, "");
			}
			$this->returnData(array('msg' => $prizeStr['msg']));
		}
		
		public function after() {
			$this->deinitCacheRedis();
		}
    }
?>