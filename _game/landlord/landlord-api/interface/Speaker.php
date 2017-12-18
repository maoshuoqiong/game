<?php
	/**
	 * 系统发送大喇叭消息
	 */
    class Speaker extends APIBase {		
		public $tag = "Speaker";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			if(!isset($this->param['msg']) || empty($this->param['msg']) || strlen($this->param['msg'])<=0){
				return;
			}	
			$msg = $this->param['msg'];
			$this->sendBroadcast($msg, "sys");
		}
		
		public function after() {
			$this->deinitCacheRedis();
		}
    }
?>