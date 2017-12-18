<?php
	/**
	 * 渠道特殊参数
	 */
    class ChannelConf extends APIBase {
		public $tag = "ChannelConf";
		public $isLogin = false; 
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			if (!isset($this->param['channel'])) {
				$this->returnError(301, '参数错误');
				return;
			}
			$channel = $this->param['channel'];
			// 斯凯子渠道的支付渠道Key
			foreach (ChannelInfo::$sky_pay_channel as $k=>$v){
	    		if($k == $channel){
	    			$this->returnData(array('pay_key' => $v));
	    			return; 
	    		}
	    	}
	    	$this->returnData(array('pay_key' => ChannelInfo::$sky_pay_channel['def']));
		}
		
		public function after() {
			$this->deinitCacheRedis();
		}
    }
?>