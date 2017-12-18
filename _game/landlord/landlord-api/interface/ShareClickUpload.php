<?php
	/**
	 * 分享点击统计
	 */
    class ShareClickUpload extends APIBase {
		
		public $tag = "ShareClickUpload";
		
    	public function before() {
    		$this->initCacheRedis();
    		$this->initMysql();
			return true;
		}
		
		public function logic() {
			if (!isset($this->param ['smsClick']) || !isset($this->param ['qqClick']) ||
				!isset($this->param ['wxClick']) || !isset($this->param ['wbClick'])) {
				$this->returnError(301, "参数错误~" );
				return;
			}
			$smsC = $this->param ['smsClick'];
			$qqC = $this->param ['qqClick'];
			$wxC = $this->param ['wxClick'];
			$wbC = $this->param ['wbClick'];
			if($smsC==0 && $qqC==0 && $wxC==0 && $wbC==0){
				$this->returnData('ok');
				return;
			}
			$share_log = array(
					'uid'=>$this->uid,
					'sms'=>$smsC,
					'qq'=>$qqC,
					'wx'=>$wxC,
					'wb'=>$wbC,
					'create_time'=>date('Y-m-d H:i:s', time())
			);
			$this->mysql->insert('share_click_log', $share_log);
			$this->returnData('ok');		
		}
		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
			$this->deinitMysql();
		}
    }
?>