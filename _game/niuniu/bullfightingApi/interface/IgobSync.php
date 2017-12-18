<?php
	/**
	 * 和游戏登录信息同步
	 */
    class IgobSync extends APIBase {
		public $tag = "IgobSync";
		
		public function before() {
			$this->initMysql();
			return true;
		}
		public function logic() {
			
		}
		public function after() {			
			$this->deinitMysql();
			$this->deinitDataRedis();
		}
    }
?>