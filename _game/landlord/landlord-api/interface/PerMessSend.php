<?php
	/**
	 * 发送个人消息（特殊处理不需要校验Skey,主要用于后台处理一些不太重要的缓冲信息）
	 */
    class PerMessSend extends APIBase {
		
		public $tag = "PerMessSend";
		public $isLogin = false;
		
		public function before() {
			$this->initUnCheckSkey();
			return true;
		}
		
		public function logic() {
			if(!isset($this->param['title']) || empty($this->param['title'])|| $this->param['title']==null || 
				!isset($this->param['content']) || empty($this->param['content'])|| $this->param['content']==null || 
				!isset($this->param['type']) || empty($this->param['type']) || $this->param['type']==null){
				return;
			}	
			$this->sendPersonMsg($this->uid, $this->param['type'],$this->param['title'], $this->param['content']);
		}
		
		public function after() {
			$this->deinitDataRedis();
		}
    }
?>