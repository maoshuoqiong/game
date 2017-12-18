<?php
	include_once 'RegisterBase.php';
	
	/**
	 *  第三方公共注册登录接口
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
			// 除游戏原有登陆注册接口需要传递的参数，客户端还必须额外传递以下6个参数
			if (!isset($this->param['uOpenID'])	|| !isset($this->param['uType'])
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
			
 			if($utype == 'huawei'){
				$uAccesstoken = $this->param['uAccesstoken'];
				$curr = time();
				$temp = urlencode($uAccesstoken);
				$temp = str_replace('+', '%2B', $temp);
				$url = ChannelInfo::$huawei_auth_url.'?nsp_svc=OpenUP.User.getInfo&nsp_ts='.time().'&access_token='.$temp;
				$jstr = $this->https_get($url);
				$now = time()-$curr;
				$this->i('huawei Login:'.$jstr);
				if(!isset($jstr)) {
					$this->returnError(301, "验证失败,非法登陆");
					return;
				}
				$retArr = json_decode($jstr);
				if(!isset($retArr->userID) || $retArr->userID<=0){
					$this->returnError(301, "验证失败,非法登陆");
					return;
				}
				$uNikeName = $retArr->userName;
			} 
			// 完成游戏内部登陆注册流程
			$row = $this->mysql->select("player", "*", array('user'=>$extid));
			if (!empty($row) && sizeof($row[0]) >= 1) {
				$user_info = RegisterBase::commLogin($this, $row[0],'s_'.$utype);
			}else {
				$user_info = RegisterBase::commReg($this,$extid,$uNikeName,$password,$uSex,0);								
			}	
			$user_info['uType'] = $utype;
			if(strlen($uHeadImg)>0)	{
				$avaterUrl = $this->data_redis->hGet("hpe:".$user_info['uid'],"avaterUrl");
				// 如果头像URL有变更，则更新
				if($avaterUrl!=$uHeadImg){
					$now = time();
					$this->data_redis->hMset("hpe:".$user_info['uid'],array('avaterUrlCurr'=>$uHeadImg,'avatar'=>$now));
					$this->mysql->update("playerext",array('avatar' => $now), array('uid' => $this->uid));
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