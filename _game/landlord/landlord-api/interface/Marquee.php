<?php
	/**
	 * 跑马灯信息
	 */
    class Marquee extends APIBase {
		public $tag = "Marquee";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$this->returnData(array('marquees' => Game::$marquee_info));
		}
		
		public function after() {
			$this->deinitCacheRedis();
		}
    }
?>