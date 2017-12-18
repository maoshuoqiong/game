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
			$channel = "def";
			if(isset($this->param['channel'])){
				$channel = $this->param['channel'];
			}
			$content = $this->cache_redis->hGet("hannounc:".$channel, "content");
			if(!$content){
				$content = $this->cache_redis->hGet("hannounc:def", "content");
			}
			$this->returnData(array('content' => $content));
		}
		
        public function after() {
			$this->deinitCacheRedis();
		}
    }
?>