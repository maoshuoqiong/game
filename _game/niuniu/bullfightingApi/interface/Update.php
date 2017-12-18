<?php
	/**
	 *  版本更新信息
	 *  test:  
	 *  http://203.86.3.245:88/api.php?action=Update&param={"package":"", "channel":"123456", "ver":1}
	 */
	
    class Update extends APIBase {
		
		public $tag = "Update";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {		
			$uid = 0;
			if (isset($_GET['uid'])) {
				$uid =  $_GET['uid'];
			}	
			//"cpId":"100000001000001","appId":"com.landlord.ddz.landlord.1"
			$curver = 0;
			$appver = "";
			$package = isset($this->param['package']) ? $this->param['package'] : null;
			$channel = isset($this->param['channel']) ? $this->param['channel'] : null;
			$ver = isset($this->param['ver']) ? $this->param['ver'] : null;
			
			if (isset($package) && isset($channel) && isset($ver)) {
				$verinfo = $this->check_app_info($package, $channel, $ver,0,0);				
				//更新内容
				if (isset($verinfo) && count($verinfo) > 0) {
					$this->returnData($verinfo);
					return;
				}
			}
							
			$this->returnError(301, "");
			
		}
		
    	public function after() {
    		$this->deinitMysql();
    		$this->deinitCacheRedis();
		}
		
		
    }
?>