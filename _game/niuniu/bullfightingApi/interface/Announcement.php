<?php
	/**
	 * 获取公告
	 */
    class Announcement extends APIBase {
		
		public $tag = "Announcement";
    	public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$content = $this->cache_redis->hGet("hannounc", "content");
			$this->returnData(array('content' => $content));
		}
		
        public function after() {
			$this->deinitCacheRedis();
		}
    }
?>