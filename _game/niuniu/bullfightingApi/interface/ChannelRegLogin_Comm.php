<?php
	include_once 'RegisterBase.php';
	
	/**
	 *  注册
	 */
    class ChannelRegLogin_Comm extends APIBase {
		
		public $tag = "ChannelRegLogin_Comm";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['uOpenID']) || !isset($this->param['uNikeName']) 
					|| !isset($this->param['channel']) || !isset($this->param['uType'])
					||  !isset($this->param['uHeadImg']) || !isset($this->param['uSex'])) {
				$this->returnError(301, "参数错误");
			}
			$password = Game::$channel_default_password;
			$uNikeName = $this->param['uNikeName'];
			$utype = $this->param['uType'];
			$extid = $utype."_".$this->param['uOpenID'];
			$uHeadImg = $this->param['uHeadImg'];
			$uSex = $this->param['uSex'];
			$row = $this->mysql->select("player", "*", array('extid'=>$extid));
			if (!empty($row) && sizeof($row[0]) >= 1) {
				$user_info = RegisterBase::commLogin($this, $row[0],'s_'.$utype);
			}else {
				$extid = "wb_".$this->param['uOpenID'];
				$row = $this->mysql->select("player", "*", array('extid'=>$extid));
				if (!empty($row) && sizeof($row[0]) >= 1) {
					$user_info = RegisterBase::commLogin($this, $row[0],'s_'.$utype);
				}else{
					$user_info = RegisterBase::commReg($this,$uNikeName,$uNikeName,$password,$uSex,1,$extid);
				}				
			}	
			$user_info['uType'] = $utype;
			if(strlen($uHeadImg)>0)	{
				$avaterUrl = $this->data_redis->hGet("hu:".$user_info['uid'],"avaterUrl");
				if ($utype == 'wx'){
					$lastTwoChar = substr($uHeadImg, strlen($uHeadImg)-2);
					if($lastTwoChar!='/0'){
						$uHeadImg .= '/0';
					}
				}
				if($avaterUrl!=$uHeadImg){
					$now = time();
					$this->data_redis->hMset("hu:".$user_info['uid'],array('avaterUrlCurr'=>$uHeadImg,'headtime'=>$now));
					$user_info['headtime'] = $now;
				}
			}
			$this->returnData($user_info);
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>