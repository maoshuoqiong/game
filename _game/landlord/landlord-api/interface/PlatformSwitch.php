<?php
	/**
	 * 平台开关
	 */
    class PlatformSwitch extends APIBase {
		
		public $tag = "PlatformSwitch";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if(Game::$platformSwitch == 0){
				$this->returnData(array('res' => 0));
				return;
			}
			if (!isset($this->param['channel'])) {
				$this->returnData(array('res' => 0));
				return;
			}
			$channel = $this->param['channel'];
			$switch = $this->cache_redis->hGet("spfSwitch:".$channel,'flag');
			if ($switch==1) {
				$this->returnData(array('res' => 0));
				return;
			}	
			$this->returnData(array('res' => 1));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>