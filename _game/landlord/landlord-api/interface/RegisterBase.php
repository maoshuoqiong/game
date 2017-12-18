<?php
	/**
	 *  注册基类
	 */
    class RegisterBase {
    	/**
    	 * loadCacheData TODO:
    	 */
    	public static function loadCacheData($soc, $uid) {
    		$row = $soc->mysql->select ( "playerext", "*", array (
    				'uid' => $uid
    		) );
    		if(sizeof($row)>0){
    			if(isset($row[0]['giftinfo'])){
    				$giftStr = $row[0]['giftinfo'];
    				$giftMap = array();
    				if(strlen($giftStr)>0){
    					$giftArr = explode(",", $giftStr);
    					if(sizeof($giftArr)>0){
    						foreach ($giftArr as $val){
    							$tmp = explode(":", $val);
    							$giftMap[$tmp[0]] = $tmp[1];
    						}
    						$soc->data_redis->hMset ( "ugift:{$uid}", $giftMap );
    					}
    				}
    			}
    			if(isset($row[0]['tasksAch'])){
    				$taskaStr = $row[0]['tasksAch'];
    				$taskaMap = array();
    				if(strlen($taskaStr)>0){
    					$taskaArr = explode(",", $taskaStr);
    					if(sizeof($taskaArr)>0){
    						foreach ($taskaArr as $val){
    							$tmp = explode(":", $val);
    							$taskaMap[$tmp[0]] = $tmp[1];
    						}
    						$soc->data_redis->hMset ( "hubta:{$uid}", $taskaMap );
    					}
    				}
    			}
    			$tempA = array();
    			if(isset($row[0]['mob'])){
    				$tempA['mob'] = $row[0]['mob'];    				
    			}
    			if(isset($row[0]['telCharge'])){
    				$tempA['telCharge'] = $row[0]['telCharge'];
    			}
    			if(isset($row[0]['vipenddate'])){
    				$tempA['vipenddate'] = $row[0]['vipenddate'];
    			}
    			if(isset($row[0]['avatar'])){
    				$tempA['avatar'] = $row[0]['avatar'];
    			}
    			if(isset($row[0]['hasRecharge'])){
    				$tempA['hasRecharge'] = $row[0]['hasRecharge'];
    			}
    			if(isset($row[0]['modifyName'])){
    				$tempA['modifyName'] = $row[0]['modifyName'];
    			}
    			$soc->data_redis->hMset ( "hpe:{$uid}", $tempA);
    		}
    	}
    	/**
    	 * 连续登录
    	 */
    	public static function continuous_landing($soc,$uid) {
    		$ts = strtotime(date("Y-m-d"));
    		$update_time = $soc->data_redis->hGet("hu:{$uid}", 'update_time');
    		if ($update_time <= $ts) {
    			if ($update_time > ($ts - 86400)) {
    				$soc->data_redis->hincrBy("hu:{$uid}", "login_days", 1);
    				$soc->data_redis->hset("hu:{$uid}", "is_get", 0);
    			} else {
    				$soc->data_redis->hMset("hu:{$uid}", array("login_days" => 1, "is_get" => 0));
    			}
    			$soc->data_redis->hMset ( "uSignin:{$uid}", array ("today_login_times" => 1));
    		}else{
				$soc->data_redis->hincrBy ( "uSignin:{$uid}", "today_login_times",1);
			}
    	}
    	
    	/**
    	 * 更新用户当前版本信息
    	 */
    	public static function update_user_appver($soc,$uid, $ver,$last_chn) {
    		if ($ver == 0) {
    			$sqlstr = "UPDATE `playermark` SET cur_ver=reg_ver,last_channel='".$last_chn."',last_time=".time()." where uid=".$uid." AND cur_ver!=reg_ver";
    			$soc->mysql->query($sqlstr);
    		}
    		else {
    			$sqlstr = "UPDATE `playermark` SET cur_ver=".$ver.",last_channel='".$last_chn."',last_time=".time()." where uid=".$uid;
    			$soc->mysql->query($sqlstr);
    			$soc->data_redis->hMset("hpe:{$uid}", array("cur_ver" => $ver));
    		}
    	}
    	
    	public static function commLogin($soc,$data, $login_type){
    		if($data['status']==0){
    			$soc->returnError(301, '您的账号已被禁用');
    			return;
    		}
    		$uid = $data['id'];
    		$soc->initDataRedis($uid);
    		$isExists = $soc->data_redis->exists("hu:{$uid}");
    		if (!$isExists) {
    			$soc->data_redis->hMset("hu:{$uid}", $data);
    			// 将过期删除的缓冲数据从DB中加载回Cache
				RegisterBase::loadCacheData ( $soc, $uid );
    		}
    			
    		RegisterBase::continuous_landing($soc,$uid);
    		$now = time();
    		$skey = md5($now . Game::$salt_password);
    			
    		$soc->data_redis->hMset("hu:$uid", array("update_time" => $now, "heartbeat_at" => $now, "skey" => $skey));
    		$hasRc = $soc->data_redis->hGetAll("hpe:{$uid}");
    		$user_info = $soc->data_redis->hMget("hu:$uid", array(
    				'user', 'name', 'sex', 'money', 'rmb', 'coin', 'skey',
    				'login_days', 'is_get', 'total_board', 'total_win', 'exp'
    		));
    		$user_info['uid'] = (int)$uid;
    		$user_info['sex'] = (int)$user_info['sex'];
    		$user_info['money'] = (int)$user_info['money'];
    		$user_info['rmb'] = (int)$user_info['rmb'];
    		$user_info['coin'] = (int)$user_info['coin'];
    		$user_info['login_days'] = (int)$user_info['login_days'];
    		$user_info['is_get'] = (int)$user_info['is_get'];
    		$total_lose = $user_info['total_board'] - $user_info['total_win'];
    		$user_info['history'] = array((int)$user_info['total_win'], (int)$total_lose);
    		$user_info['total_board'] = (int)$user_info['total_board'];
    		$user_info['total_win'] = (int)$user_info['total_win'];
    		$user_info['exp'] = (int)$user_info['exp'];
    		$user_info['hasrc'] = (int) (isset($hasRc['hasRecharge']) ? $hasRc['hasRecharge'] : 0);
    		$user_info['mob'] = isset($hasRc['mob']) && strlen($hasRc['mob'])>0 ? $hasRc['mob'] : "0";
    		$user_info['headtime'] = isset($hasRc['avatar']) && strlen($hasRc['avatar'])>0 ? (int)$hasRc['avatar'] : 0;
    		
    		if($login_type!='comm'){
    			$needUp = false;if (isset($soc->param['name']) && strlen($soc->param['name'])>0 && $soc->param['name'] != $user_info ['name'] ) {
    				$user_info ['name'] = $soc->param['name'];
    				$needUp = true;
    			}
    			if (isset($soc->param['sex']) && strlen($soc->param['sex'])>0 && $soc->param['sex'] != $user_info ['sex']) {
    				$user_info ['sex'] = (int)$soc->param['sex']==1?1:0;
    				$needUp = true;
    			}
    			if (isset($soc->param['user']) && strlen($soc->param['user'])>0 && $soc->param['user'] != $user_info ['user']) {
    				$user_info ['user'] = $soc->param['user'];
    				$needUp = true;
    			}
    			if($needUp){
    				$soc->data_redis->hMset ( "hu:$uid",array('name'=>$user_info ['name'],'sex'=>$user_info ['sex'],'user'=>$user_info ['user']));
    				$soc->mysql->update("player",array('name'=>$user_info ['name'],'sex'=>$user_info ['sex'],'user'=>$user_info ['user']),
    						array('id'=>$uid));
    			}
    		}	
    		// base info 
    		$base_pkg= isset($soc->param['package']) ? $soc->param['package'] : "";
    		$base_chn= isset($soc->param['cpId']) ? $soc->param['cpId'] : "";
    		$base_ver= isset($soc->param['ver']) ? $soc->param['ver'] : "";
    		$base_imsi=isset($soc->param['imsi']) ? $soc->param['imsi'] : "";
    		$base_imei=isset($soc->param['imei']) ? $soc->param['imei'] : "";   		 
    		
    		// 把常用的 imsi imei ver 信息保存到redis, PayTrap接口需要
    		$soc->data_redis->hMset ( "hu:{$uid}", array (
    				"imsi" => $base_imsi,
    				"imei" => $base_imei,
    				"ver" => $base_ver,
    				"pkg" => $base_pkg,
    				"channel" => $base_chn
    		) );
    		
    		//log login
    		$ver = "0";
    		if (isset($soc->param['ver'])) {
    			$ver = $soc->param['ver'];
    		}    		
    		$login_log['uid'] = (int)$uid;
    		$login_log['verCode'] = (int)$ver;
    		$vip = CommonTool::vipDays($soc->data_redis,$uid);
    		$user_info['vip'] = $vip;
    		$soc->mysql->insert("log_login", $login_log);
    		//update version
    		RegisterBase::update_user_appver($soc,(int)$uid, (int)$ver,$base_chn);
    		// 公告签到显示优先级
    		$user_info['show_ind'] = CommonTool::getShowInd($soc,$uid);
    		// 判断是否有特惠坑
			$trap = $soc->check_trap_special ( $uid, $base_imsi, $base_imei );
			$user_info ['trap'] = ( int ) $trap;
			// 获得任务可领奖数
			$user_info['gettask'] = CommonTool::getTaskRewardNum($soc,$uid);
			// 判断0.1元开关
			$ten_cents = $soc->check_rmb10fen($uid, $base_imsi) ;
			$user_info ['ten_cents'] = ( int ) $ten_cents;
			
			$arrReturn = array ();
			// 判断是否有新版本及需要屏蔽的功能模块			
			$arr_upd = $soc->check_app_info ( $base_pkg, $base_chn, $base_ver );			
			if (isset ( $arr_upd ) && count ( $arr_upd ) > 0) {
				$arrReturn = array_merge ( $user_info, $arr_upd );
			} else {
				$arrReturn = $user_info;
			}
			
			$arrReturn = $user_info;
    		return $arrReturn;
    	}

    	/**
    	 * 判断该用户注册了多少次
    	 *
    	 * @param unknown $soc
    	 * @param unknown $imsi
    	 * @param unknown $imei
    	 * @return number
    	 */
    	static function check_register_times($soc, $imsi, $imei) {
    		$num = 0;
    		if (isset ( $imsi ) && strlen ( $imsi ) > 6) {
    			$row = $soc->mysql->select ( "playermark", "uid", array (
    					'imsi' => $imsi
    			) );
    			$num = count ( $row );
    		}
    		/*
    		 * else if (isset ( $imei )) { $row = $soc->mysql->select ( "playermark", "uid", array ( 'imei' => $imei ) ); $num = count ( $row ); }
    		*/
    		return $num;
    	}
    	public static function commReg($soc,$user,$name,$passwd,$sex,$isauto) {
    		$pmark = RegisterBase::createPlayerMark($soc);   		
    		if (strlen ( $pmark['imsi'] ) > 0) {
    			// 检查imsi、imei的注册数是否超过了限制数
    			$reg_times = RegisterBase::check_register_times ( $soc, $pmark['imsi'], $pmark['imei'] ); 
    			if ($reg_times >= Game::$register_times && !in_array($pmark['imsi'], Game::$white_imsi)) {
    				$soc->returnError ( 300, "您已注册了多次，请用回之前的帐号，谢谢。" );
    				return;
    			}
    		}
    		$new_user = RegisterBase::createUser($user,$name,$passwd,$sex,$isauto);
    		$uid = $soc->mysql->insert("player", $new_user);
    		if ($uid == 0) {
    			$soc->e("insert user error");
    			$soc->returnError(500, "内部错误");
    		}    		
    		$pmark["uid"] = $uid;
			//获取版本号和包名
			$pkg = $pmark['appId'];
			$arrTmp = explode(".", $pmark['appId']);
			if (count($arrTmp) > 1) {
				$pmark['reg_ver'] =(int)$arrTmp[count($arrTmp)-1];
				$pmark['cur_ver'] = $pmark['reg_ver'];
				$pmark['package'] = str_replace(".".$arrTmp[count($arrTmp)-1], "", $pkg);
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
					 $pmark['package'] = "com.landlord.ddzmm";
				}	
			}
			else {
				 $pmark['package'] = "com.landlord.ddz";
			}	
			$soc->mysql->insert("playermark", $pmark);			
			// init player ext info
			$soc->initDataRedis($uid);
			$soc->initPlayerExt($uid);
			$new_user['id'] = $uid;
			$ret = $soc->data_redis->hMset("hu:{$uid}", $new_user);
			if (!$ret) {
				$soc->e("redis hMset error.");
				$soc->returnError(3, "内部错误，请重试.");
			}
			
			// 把常用的 imsi imei ver 信息保存到redis, PayTrap接口需要
			// base info
			$base_pkg= $pmark['package'];
			$base_chn= $pmark['cpId'];
			$base_ver= $pmark['reg_ver'] ;
			$base_imsi= $pmark['imsi'];
			$base_imei= $pmark['imei'];
			//获取版本号和包名
			// 把常用的 imsi imei ver 信息保存到redis, PayTrap接口需要
			$soc->data_redis->hMset ( "hu:{$uid}", array (
					"imsi" => $base_imsi,
					"imei" => $base_imei,
					"ver" => $base_ver,
					"pkg" => $base_pkg,
					"channel" => $base_chn
			) );
			
			// 记录登录日志
			$login_log['uid'] = (int)$uid;
			$login_log['verCode'] = (int)$base_ver;			
			$soc->mysql->insert("log_login", $login_log);
			
			if($pmark['cpId']!=Game::$special_channel){
				$title = "欢迎您来到" . Game::$appname;
				$content = "欢迎您来到" . Game::$appname . "首次登陆赠送" . Game::$init_money . "金币，连续每日登陆，还能获得更多免费金币，首次充值也会赠首充礼包哦！";
				$soc->sendPersonMsg($uid, "sys",$title, $content);
			}			
			$user_info = $soc->data_redis->hMget("hu:$uid", array(
					'user', 'name', 'sex', 'money', 'rmb', 'coin', 'skey',
					'login_days', 'is_get', 'total_board', 'total_win', 'exp'
			));
			$user_info = RegisterBase::userInfo($user_info,$uid);
			$user_info['pwd'] = $passwd;
			$user_info['vip'] = 0;
			// 公告、签到展示的优先级
			$user_info['show_ind'] = 1;
			// 判断是否有特惠坑
			$trap = $soc->check_trap_special ( $uid, $base_imsi, $base_imei );
			$user_info ['trap'] = ( int ) $trap;
			// 获得任务可领奖数
			$user_info['gettask'] = [0,0];
			// 判断0.1元开关
			$ten_cents = $soc->check_rmb10fen($uid, $base_imsi) ;
			$user_info ['ten_cents'] = ( int ) $ten_cents;
			
			// 判断是否有新版本及需要屏蔽的功能模块
			$arr_upd = $soc->check_app_info ( $base_pkg, $base_chn, $base_ver );
			$arrReturn = array ();
			if (isset ( $arr_upd ) && count ( $arr_upd ) > 0) {
				$arrReturn = array_merge ( $user_info, $arr_upd );
			} else {
				$arrReturn = $user_info;
			}			
    		return $arrReturn;
    	}
    	
    	public static function userInfo($user_info,$uid) {
    		$user_info['uid'] = (int)$uid;
    		$user_info['sex'] = (int)$user_info['sex'];
    		$user_info['money'] = (int)$user_info['money'];
    		$user_info['rmb'] = (int)$user_info['rmb'];
    		$user_info['coin'] = (int)$user_info['coin'];
    		$user_info['login_days'] = (int)$user_info['login_days'];
    		$user_info['is_get'] = (int)$user_info['is_get'];
    		$total_lose = $user_info['total_board'] - $user_info['total_win'];
    		$user_info['history'] = array((int)$user_info['total_win'], (int)$total_lose);
    		$user_info['total_board'] = (int)$user_info['total_board'];
    		$user_info['total_win'] = (int)$user_info['total_win'];
    		$user_info['exp'] = (int)$user_info['exp'];
    		$user_info['hasrc'] = 0;
    		return $user_info;
    	}
    	
		public static function createUser($user,$name,$pwd,$sex,$isauto) {
			$now = time();
			$salt = Game::$salt_password;
			$user_info = array();
			$user_info["user"] = $user;
			$user_info["name"] = $name;
			$user_info["password"] = md5($pwd . $salt);			
			$user_info["salt"] = $salt;
			$user_info["status"] = 1; // 0：为封号的
			$user_info["sex"] = $sex;
			$user_info["money"] = Game::$init_money;
			$user_info["rmb"] = 0;
			$user_info["coin"] = Game::$init_coin;
		    $user_info ["isauto"] = $isauto;
			if ($sex == 0)
				$user_info["avater"] = "mm.png";
			else
				$user_info["avater"] = "gg.png";
			$user_info["skey"] = md5(time().$salt);
			$user_info["login_days"] = 1;
			$user_info["is_get"] = 0;
			$user_info["total_board"] = 0;
			$user_info["total_win"] = 0;
			$user_info["exp"] = 0;
			$user_info["heartbeat_at"] = $now;
			$user_info["broke_num"] = 0;
			$user_info["broke_time"] = 0;
			$user_info["create_time"] = $now;
			$user_info["update_time"] = $now;
			$user_info["charm"] = 0;
			$user_info ["sign"] = "这屌丝很不犀利,什么都没留下!";
			return $user_info;
		}
		
		public static function createPlayerMark($soc) {
			$cpId = "";
			$appId = "0";
			$imsi = "";
			$imei = "";
			$mtype = "0";
			$package = "0";
			$ver = "0";
			// insert playermark
			if (isset($soc->param['cpId'])) {
				$cpId = $soc->param['cpId'];
			}
			if (isset($soc->param['appId'])) {
				$appId = $soc->param['appId'];
			}
			if (isset($soc->param['imsi'])) {
				$imsi = $soc->param['imsi'];
			}
			if (isset($soc->param['imei'])) {
				$imei = $soc->param['imei'];
			}
			if (isset($soc->param['mtype'])) {
				$mtype = $soc->param['mtype'];
			}
			if (isset($soc->param['package'])) {
				$package = $soc->param['package'];
			}
			if (isset($soc->param['ver'])) {
				$ver = $soc->param['ver'];
			}
			$user_info = array();
			$user_info["cpId"] = $cpId;
			$user_info["appId"] = $appId;
			$user_info["imsi"] = $imsi;
			$user_info["imei"] = $imei;
			$user_info["mtype"] = $mtype;
			$user_info["create_time"] = time();	
			$user_info["reg_ver"] = $ver;
			$user_info["cur_ver"] = $ver;
			$user_info["package"] = $package;	
			return $user_info;
		}
    }
?>