<?php
	/**
	 *  版本更新信息
	 *  test:
	 *  http://api.53jiankang.com:88/api.php?action=Update&param={"appId":"appId", "cpId":"cpId0001"}
	 */
	
    class Update extends APIBase {
		
		public $tag = "Update";
		public $isLogin = false;
		
		public function before() {
// 			$this->initMysqlSlave();
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {		
			$uid = "0";
			if (isset($_GET['uid'])) {
				$uid =  $_GET['uid'];
			}	
			//"cpId":"100000001000001","appId":"com.landlord.ddz.landlord.1"
			$curver = 0;
			$appver = "";
			$appid = "";
			$cpid = "";
			if (isset($this->param['appId'])) {
				$appid =  $this->param['appId'];	
			}
			if (isset($this->param['cpId'])) {
				$cpid =  $this->param['cpId'];	
			}
			
			$pkg = $appid;
			$arrTmp = explode(".", $appid);
			if (count($arrTmp) > 0) {			
				$pkg = str_replace(".".$arrTmp[count($arrTmp)-1], "", $pkg);
				$curver = (int) $arrTmp[count($arrTmp)-1];
			}
			//对以前不规范的包名进行更正
			$tpkg = "com.landlord.ddz.";
			$tpos = strpos( $pkg, $tpkg);
			if ($tpos === FALSE) {
				$tpkg2 = "com.landlord.ddzmm.";
				$tpos2 = strpos( $pkg, $tpkg2);
				if ($tpos2 === FALSE) {
				}
				else {
					 $pkg = "com.landlord.ddzmm";
				}	
			}
			else {
				 $pkg = "com.landlord.ddz";
			}
				
			$verinfo = $this->check_app_info($pkg, $cpid, $curver);
			// 更新内容			
			$this->returnData($verinfo);		
		}
		
    	public function after() {
//     		$this->deinitMysqlSlave();
    		$this->deinitMysql();
    		$this->deinitCacheRedis();
		}
		
		
    }
?>