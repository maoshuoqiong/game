<?php
	include_once 'RegisterBase.php';
	include_once './lib/gc_login.class.php';
	
	/**
	 *  第三方公共注册登录接口
	 */
    class ChannelRegLogin_Pub extends APIBase {
		
		public $tag = "ChannelRegLogin_Pub";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			// 除游戏原有登陆注册接口需要传递的参数，客户端还必须额外传递以下6个参数
			if (!isset($this->param['uOpenID'])  
				|| !isset($this->param['channel'])
				|| !isset($this->param['uType'])
				) {
				$this->returnError(301, "参数错误");
				return;
			}
			
			$utype = $this->param['uType'];						// 第三方类型，微信：wx/腾讯：qq/微博：wb，其中已使用(keke/wx/qq/wb/ly/comm)
			$password = Game::$channel_default_password;		// 默认的初始化密码			
			$uOpenID = $this->param['uOpenID'];					// 第三方用户的唯一标示
			$extid = $utype."_".$uOpenID;						// 游戏内部用户标示
			
			$uNikeName = isset($this->param['uNikeName']) ? $this->param['uNikeName'] : $uOpenID ;	// 昵称			
			$uHeadImg = isset($this->param['uHeadImg']) ? $this->param['uHeadImg'] : ""; // 头像的URL
			$uSex = isset($this->param['uSex']) ? (int) $this->param['uSex'] : 0 ;						// 性别			
			
			// 这个可以根据utype做第三方特定的验证或处理TODO：
			/* if($utype === 'keke'){
				$gclogin= new gc_login_base('363f00ae149e452e14849ee1b5c59ee4','3021a57b1dd0c49ac397ca5344e4eb0d');
				$user = $gclogin->getUserInfo();
			} */
			// 完成游戏内部登陆注册流程
			$row = $this->mysql->select("player", "*", array('extid'=>$extid));
			if (!empty($row) && sizeof($row[0]) >= 1) {
				$user_info = RegisterBase::commLogin($this, $row[0],'s_'.$utype);
			}else {
				$user_info = RegisterBase::commReg($this,$uNikeName,$uNikeName,$password,$uSex,1,$extid);								
			}	
			
			if(strlen($uHeadImg)>0)	{
				$avaterUrl = $this->data_redis->hGet("hu:".$user_info['uid'],"avaterUrl");
				// 如果头像URL有变更，则更新
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