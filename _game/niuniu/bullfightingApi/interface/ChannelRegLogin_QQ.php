<?php
	include_once 'RegisterBase.php';
	
	/**
	 *  注册
	 */
    class ChannelRegLogin_QQ extends APIBase {
		
		public $tag = "ChannelRegLogin_QQ";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['uOpenID']) || !isset($this->param['uNikeName']) 
					|| !isset($this->param['uSex']) || !isset($this->param['uHeadImg'])
					|| !isset($this->param['uAccess_token']) || !isset($this->param['uRefresh_token'])
					|| !isset($this->param['uType'])){
				$this->returnError(301, "参数错误");
				$this->i("参数错误");
			}
			// 平台接入参数
			$timestamp = time();
			$encode = 1;								// 时间戳
			$uType = $this->param['uType'];				// 用户来源:qq或者wx						
			$msdkExtInfo = '';							// 透传的参数

			// QQ、微信用户基础信息
			$uAccess_token = $this->param['uAccess_token'];							 
			$uRefresh_token = $this->param['uRefresh_token'];
			$uOpenID = $this->param['uOpenID'];			// 账号ID
			$uNikeName = strlen($this->param['uNikeName'])>0?$this->param['uNikeName']:
							CommonTool::getRandomKeys ( 4 ).CommonTool::getRandomKeys(6, false);		// 昵称
			$uSex = strlen($this->param['uSex'])>0?(int)$this->param['uSex']:1;				// 性别
			$uHeadImg = $this->param['uHeadImg'];		// 头像
			
			if($uType == 'qq'){
				// /auth/verify_login/?timestamp=*&appid=**&sig=***&openid=**&encode=1
				$appid = ChannelInfo::$qq_appid;							// 游戏在微信或者手Q平台所对应的唯一ID
				$sig = md5(ChannelInfo::$qq_appkey.$timestamp);				// 加密串
				$userip = '127.0.0.1';
				$url = ChannelInfo::$qq_auth_url.'auth/verify_login/?timestamp='.$timestamp.
								'&appid='.$appid.'&sig='.$sig.'&openid='.$uOpenID.'&encode=1';
				$param = array(
					'appid'=> $appid,
					'openid'=> $uOpenID,
					'openkey'=> $uAccess_token,
					'userip'=>$userip
				);				
				$res = CommonTool::do_post_request($url,json_encode($param));
				$jsonRes = json_decode($res);
// 				var_dump($jsonRes);
				if(!isset($jsonRes->ret)){
					$this->returnError(301, "验证失败，请重新登录");
					$this->i("QQ验证失败，无返回结果");
					return;
				}elseif ($jsonRes->ret!=0){
					$this->returnError(301, "鉴权失败，请重新登录");
					$this->i("QQ:"+$jsonRes->ret+":"+$jsonRes->msg);
					return;
				}				
			}elseif ($uType == 'wx'){
				// /auth/check_token/?timestamp=*&appid=**&sig=***&openid=**&encode=1
				$sig = md5(ChannelInfo::$wx_appkey.$timestamp);				// 加密串
				$url = ChannelInfo::$qq_auth_url.'auth/check_token/?timestamp='.$timestamp.
								'&appid='.ChannelInfo::$wx_appid.'&sig='.$sig.'&openid='.$uOpenID.'&encode=1';
				$param = array(
					'openid'=> $uOpenID,
					'accessToken'=> $uAccess_token
				);
 				$res = CommonTool::do_post_request($url,json_encode($param));
 				$jsonRes = json_decode($res);
//  				var_dump($jsonRes);
 				if(!isset($jsonRes->ret)){
 					$this->returnError(301, "验证失败，请重新登录");
 					$this->i("WX验证失败，无返回结果");
 					return;
 				}elseif ($jsonRes->ret!=0){
 					$this->returnError(301, "鉴权失败，请重新登录");
 					$this->i("WX:"+$jsonRes->ret+":"+$jsonRes->msg);
 					return; 					 					
 				}
			}
			$this->initDataRedis ( 1000 );
			$password = Game::$channel_default_password;
			// 兼容原有sdk接入的QQ、微信用户
			$extid = 'ly_'.$uType."_".$uOpenID;
			$row = $this->mysql->select("player", "*", array('extid'=>$extid));
			if (!empty($row) && sizeof($row[0]) >= 1) {
				$user_info = RegisterBase::commLogin($this, $row[0],'c_'.$uType);
			}else {
				$user_info = RegisterBase::commReg($this,$uNikeName,$uNikeName,$password,$uSex,1,$extid);
			}
			if(strlen($uHeadImg)>0)	{
				$avaterUrl = $this->data_redis->hGet("hu:".$user_info['uid'],"avaterUrl");
				if ($uType == 'wx'){
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