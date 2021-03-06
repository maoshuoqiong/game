<?php
	/**
	 * 后台发送大喇叭消息
	 */
    class Speaker extends APIBase {		
		public $tag = "Speaker";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			$this->initMysql ();
			return true;
		}
		
		public function logic() {
			if(!isset($this->param['msg']) || empty($this->param['msg']) || strlen($this->param['msg'])<=0){
				return;
			}			
			$this->sendBroadcast($this->param['msg'], "1");
		}
		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitMysql ();
		}
    }
?>