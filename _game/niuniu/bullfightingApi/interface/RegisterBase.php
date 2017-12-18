<?php
/**
	 *  注册基类
	 */
class RegisterBase {
	/**
	 * 连续登录
	 */
	public static function continuous_landing($soc, $uid) {
		$ts = strtotime ( date ( "Y-m-d" ) );
		$update_time = $soc->data_redis->hGet ( "hu:{$uid}", 'update_time' );
		if ($update_time <= $ts) {
			if ($update_time > ($ts - 86400)) {
				// 登录时间间隔大于 1 天
				$soc->data_redis->hincrBy ( "hu:{$uid}", "login_days", 1 );
				$soc->data_redis->hset ( "hu:{$uid}", "is_get", 0 );
			} else {
				$soc->data_redis->hMset ( "hu:{$uid}", array (
						"login_days" => 1,
						"is_get" => 0 
				) );
			}
			$soc->data_redis->hMset ( "uSignin:{$uid}", array ("today_login_times" => 1));
		}else{
			$soc->data_redis->hincrBy ( "uSignin:{$uid}", "today_login_times",1);
		}
	}
	/**
	 * 连续登录
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
			if(isset($row[0]['guideAward']) && Game::$game_type=="hotpot"){
				$ga = (int)$row[0]['guideAward'];
				$soc->data_redis->hSet ( "hpe:{$uid}", "isGetGuideAward", $ga);
			}			
		}
	}
	/**
	 * 登录
	 *
	 * @param unknown $soc        	
	 * @param unknown $data        	
	 * @return void number
	 */
	public static function commLogin($soc, $data, $login_type) {
		if ($data ['status'] == 0) {
			$soc->returnError ( 301, '您的账号已被禁用' );
			return;
		}
		$uid = $data ['id'];
		$soc->initDataRedis ( $uid );
		$isExists = $soc->data_redis->exists ( "hu:{$uid}" );
		if (! $isExists) {
			$soc->data_redis->hMset ( "hu:{$uid}", $data );
			// 将过期删除的缓冲数据从DB中加载回Cache
			RegisterBase::loadCacheData ( $soc, $uid );
		}
		$checkLogin = $soc->data_redis->hMget ( "hu:$uid", array (
				'heartbeat_at'
		));
		/* if (strncmp($login_type,"c_",2)==0 && $checkLogin['heartbeat_at']+60>time()) {
			$soc->returnError ( 301, '登录失败，您的账号已经在其他设备登录' );
			return;
		} */
		RegisterBase::continuous_landing ( $soc, $uid );
		$now = time ();
		$skey = md5 ( $now . Game::$salt_password );
		
		$soc->data_redis->hMset ( "hu:$uid", array (
				"update_time" => $now,
				"heartbeat_at" => $now,
				"skey" => $skey 
		) );
		// 登录次数+1
		$soc->data_redis->hincrBy ( "hu:{$uid}", "login_times", 1 );
		
		// $hasRc = $soc->data_redis->hGetAll ( "hpe:{$uid}" );
		
		$user_info = $soc->data_redis->hMget ( "hu:$uid", array (
				'user',
				'name',
				'sex',
				'skey',
				'money',
				'coin',
				'login_days',
				'is_get',
				'headtime',
				'telCharge',
				'vipLevel',
				'charm',
				'title',
				'rmb',
				'safeboxflag' 
		) );
		$user_info ['uid'] = ( int ) $uid;
		$user_info ['sex'] = ( int ) $user_info ['sex'];
		$user_info ['money'] = ( int ) $user_info ['money'];
		$user_info ['coin'] = ( int ) $user_info ['coin'];
		$user_info ['login_days'] = ( int ) $user_info ['login_days'];
		$user_info ['is_get'] = ( int ) $user_info ['is_get'];
		$user_info ['headtime'] = ( int ) $user_info ['headtime'];
		$user_info ['telCharge'] = ( int ) $user_info ['telCharge'];
		$user_info ['vip'] = ( int ) $user_info ['vipLevel'];
		$user_info ['charm'] = ( int ) $user_info ['charm'];
		$user_info ['title'] = isset ( $user_info ['title'] ) ? $user_info ['title'] : "";
		$user_info ['hasrc'] = isset( $user_info['rmb']) && (int) $user_info['rmb']>0? 1 : 0;
		// $user_info ['hasrc'] = ( int ) (isset ( $hasRc ['hasRecharge'] ) ? $hasRc ['hasRecharge'] : 0);
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
		// 基本信息
		$pmark = RegisterBase::createPlayerMark ( $soc, $uid );
		$pmark['login_type'] = $login_type;
		//login_log		
		RegisterBase::login_log($soc, $pmark);
		// 获得初始化版本号
		RegisterBase::getInitVer($soc, $uid);
		// 获得任务可领奖数
		$user_info['gettask'] = CommonTool::getTaskRewardNum($soc,$uid);
		// 公告、签到展示的优先级
		$user_info['show_ind'] = CommonTool::getShowInd($soc,$uid);
		$user_info ['safebox'] = isset( $user_info['safeboxflag']) && (int) $user_info['safeboxflag']>0? 1 : 0;
		
		if(Game::$game_type=="hotpot"){
			$isGet = $soc->data_redis->hGet("hpe:{$uid}",'isGetGuideAward');
			$user_info['show_ind'] = ($isGet && $isGet==1)?$user_info['show_ind']:3;
		}
		// 是否比赛周期
		$user_info['isFightDate'] = CommonTool::isFightDate();
		$user_info['isFightTime'] = CommonTool::isFightTime();
		// 判断是否有特惠坑
		$trap = $soc->check_trap_special ( $uid, $pmark ['imsi'], $pmark ['imei'] );
		if (isset($pmark ['channel']) && $pmark ['channel'] == "3003967982" )  {
			$trap = 0 ;
		}
		//益玩SDK		
		if (isset($pmark ['package']) && (stripos($pmark ['package'], "com.chjie.dcow.ewan") !== false ) )  {
			$trap = 0 ;
		}
		
		$user_info ['trap'] = ( int ) $trap;
		// 判断0.1元开关
		$ten_cents = $soc->check_rmb10fen($uid, $pmark ['imsi']) ;
		$user_info ['ten_cents'] = ( int ) $ten_cents;
		// 用户调研开关
		$user_info ['research'] = CommonTool::getResearch($soc, $uid);
		// 公告活跃
		$user_info ['notice_effect'] = Game::$notice_effect;
		// 基础数据序列号
		$currSeqId = $soc->cache_redis->get("data_seqId");
		$user_info ['data_seqId'] = $currSeqId;
		// 月卡道具状态
		$user_info ['monthcardMsg'] = RegisterBase::getMonthCardInfo ( $soc, $user_info );
		
		$total_board = RegisterBase::get_user_totalboard($soc, $uid, $pmark ['package']);
		// 判断是否有新版本及需要屏蔽的功能模块
		$arr_upd = $soc->check_app_info ( $pmark ['package'], $pmark ['channel'], $pmark ['ver'] ,$user_info ['safebox'], $total_board);
		$arrReturn = array ();
		if (isset ( $arr_upd ) && count ( $arr_upd ) > 0) {
			$arrReturn = array_merge ( $user_info, $arr_upd );
		} else {
			$arrReturn = $user_info;
		}
		return $arrReturn;
	}	
	
	public static function getMonthCardInfo($soc, $user_info) {
		$uinfo = $soc->data_redis->hMget ( "hu:{$user_info['uid']}", array (
				'monthAwardTime',
				'monthcardId',
				'monthcardEndtime'
		)); 
		$now = time();
		$msg = '';
		if($uinfo['monthcardId']>0 && $uinfo['monthcardEndtime']>$now
			 && CommonTool::isSameDay($uinfo['monthAwardTime'], $now) &&
				isset(Game::$monthcard_give_money[$uinfo['monthcardId']])){
			$money = Game::$monthcard_give_money[$uinfo['monthcardId']];
			$soc->hincrMoney($money, 'monthcard');
			$msg = '您拥有月卡,今天获得'.$money.'金币';
			$soc->data_redis->hset ( "hu:{$user_info['uid']}", 'monthAwardTime',$now);
		}
		return $msg;
	}
	
	public static function getInitVer($soc, $uid) {
		$row = $soc->mysql->select ( "playermark", "ver", array (
				'uid' => $uid
		) );
		if(sizeof($row)>0){
			$soc->data_redis->hSet ( "hu:{$uid}","initVer",$row[0]['ver']);
		}else{
			$soc->data_redis->hSet ( "hu:{$uid}","initVer",0);
		}
	}
	/**
	 * 注册
	 *
	 * @param unknown $soc        	
	 * @param unknown $user        	
	 * @param unknown $name        	
	 * @param unknown $passwd        	
	 * @param unknown $sex        	
	 * @param unknown $isauto        	
	 * @return number
	 */
	public static function commReg($soc, $user, $name, $passwd, $sex, $isauto, $channelUid) {
		$imsi = $soc->param ['imsi'];
		$imei = $soc->param ['imei'];
		// 检查imsi、imei的注册数是否超过了限制数
		$reg_times = RegisterBase::check_register_times ( $soc, $imsi, $imei );
		
		if (strlen ( $imsi ) > 0) {
			if ($reg_times >= Game::$register_times && !in_array($imsi, Config::$white_imsi) && $channelUid=="0") {
				$soc->returnError ( 300, "您已注册了多次，请用回之前的帐号，谢谢。" );
				return;
			}
		}
		
		$new_user = RegisterBase::createUser ( $user, $name, $passwd, $sex, $isauto );
		// 获取头衔
		$new_user ['title'] = $soc->getTitleInfo ( ( int ) $new_user ['money'] );
		if($channelUid!="0"){
			$new_user ['extid'] = $channelUid;
		}
		$uid = $soc->mysql->insert ( "player", $new_user );
		if ($uid == 0) {
			$soc->e ( "insert user error" );
			$soc->returnError ( 500, "内部错误" );
		}
		
		// init redis
		$soc->initDataRedis ( $uid );
		
		// 注册基本信息
		$pmark = RegisterBase::createPlayerMark ( $soc, $uid );
		$soc->mysql->insert ( "playermark", $pmark );
		//login_log		
		RegisterBase::login_log($soc, $pmark);
		// init player ext info
		
		$soc->initPlayerExt ( $uid );
		
		// 缓存
		$new_user ['id'] = $uid;
		$ret = $soc->data_redis->hMset ( "hu:{$uid}", $new_user );
		if (! $ret) {
			$soc->e ( "redis hMset error." );
			$soc->returnError ( 3, "内部错误，请重试." );
		}
		$title = "欢迎您来到" . Game::$appname;
		$content = "欢迎您来到" . Game::$appname . "首次登陆赠送" . Game::$init_money . "金币，连续每日登陆，还能获得更多免费金币！";
		$soc->sendPersonMsg ( $uid, "sys", $content );
		$user_info = $soc->data_redis->hMget ( "hu:$uid", array (
				'user',
				'name',
				'sex',
				'skey',
				'money',
				'coin',
				'rmb',
				'login_days',
				'is_get',
				'total_board',
				'total_win',
				'exp',
				'level',
				'charm',
				'vipLevel',
				'headtime',
				'telCharge',
				'title' 
		) );
		$user_info = RegisterBase::userInfo ( $user_info, $uid );
		$user_info ['pwd'] = $passwd;
		$user_info ['hasrc'] = 0;
		// return $user_info;
		// 公告、签到展示的优先级
		$user_info['show_ind'] = 3;
		$user_info ['safebox'] = 0;
		// 获得任务可领奖数
		$user_info['gettask'] = CommonTool::getTaskRewardNum($soc,$uid);
		// 是否比赛周期
		$user_info['isFightDate'] = CommonTool::isFightDate();
		$user_info['isFightTime'] = CommonTool::isFightTime();
		// 判断是否有特惠坑
		$trap = $soc->check_trap_special ( $uid, $pmark ['imsi'], $pmark ['imei'] );
		if (isset($pmark ['channel']) && $pmark ['channel'] == "3003967982")  {
			$trap = 0 ;
		}
		//益玩SDK
		if (isset($pmark ['package']) && (stripos($pmark ['package'], "com.chjie.dcow.ewan") !== false ) )  {
			$trap = 0 ;
		}
		
		$user_info ['trap'] = ( int ) $trap;
		// 判断0.1元开关
		$ten_cents = $soc->check_rmb10fen($uid, $pmark ['imsi']) ;
		$user_info ['ten_cents'] = ( int ) $ten_cents;
		// 用户调研开关
		$user_info ['research'] = "-1";
		// 基础数据序列号
		$currSeqId = $soc->cache_redis->get("data_seqId");
		$user_info ['data_seqId'] = $currSeqId;
		$user_info ['monthcardMsg'] = '';
		// $ret = $soc->data_redis->hMset ( "hu:{$uid}", $new_user );
		
		$total_board = RegisterBase::get_user_totalboard($soc, $uid, $pmark ['package']);		
		// 判断是否有新版本及需要屏蔽的功能模块
		$arr_upd = $soc->check_app_info ( $pmark ['package'], $pmark ['channel'], $pmark ['ver'] ,0, $total_board);
		$arrReturn = array ();
		if (isset ( $arr_upd ) && count ( $arr_upd ) > 0) {
			$arrReturn = array_merge ( $user_info, $arr_upd );
		} else {
			$arrReturn = $user_info;
		}
		// 如果用户来源天翼WIFI推广
		if($pmark['channel']==Config::$channel_ct_wifi){
			$sender_id = '1019';
			$secret_key = 'Jq3IalQ2acCQqw3ygZYI';
			$url = Config::$url_ct_wifi;
			$now = time();
			$query = array();
			$query['sender_id'] = $sender_id;
			$query['device_id'] =  $pmark['imei'];
			$query['app_name'] = '土豪牛牛'; // rmb 单位为元，转为分
			$query['pack_name'] = 'com.chjie.dcow';
			$query['app_cid'] = Config::$channel_ct_wifi;
			$query['trade_type'] = 2;
			$query['time_stamp'] = date('YmdHis', $now);
			$query['token'] = md5($query['time_stamp'].$secret_key);			
			$jstr = $soc->http_get($url, $query);				
			if(isset($jstr)) {
				$retArr = json_decode($jstr);
				if(isset($retArr->result) && $retArr->result!=0){
					$soc->i('ct wifi channel error');
				}
			}
		}
		return $arrReturn;
	}
	public static function userInfo($user_info, $uid) {
		$ret = array ();
		$ret ['uid'] = ( int ) $uid;
		$ret ['user'] = $user_info ['user'];
		$ret ['name'] = $user_info ['name'];
		$ret ['skey'] = $user_info ['skey'];
		$ret ['sex'] = ( int ) $user_info ['sex'];
		$ret ['money'] = ( int ) $user_info ['money'];
		$ret ['coin'] = ( int ) $user_info ['coin'];
		$ret ['login_days'] = ( int ) $user_info ['login_days'];
		$ret ['is_get'] = ( int ) $user_info ['is_get'];
		$ret ['vip'] = ( int ) $user_info ['vipLevel'];
		$ret ['headtime'] = ( int ) $user_info ['headtime'];
		$ret ['telCharge'] = ( int ) $user_info ['telCharge'];
		$ret ['title'] = $user_info ['title'];
		;
		
		return $ret;
	}
	public static function createUser($user, $name, $pwd, $sex, $isauto) {
		$now = time ();
		$salt = Game::$salt_password;
		$user_info = array ();
		$user_info ["user"] = $user;
		$user_info ["name"] = $name;
		$user_info ["password"] = md5 ( $pwd . $salt );
		$user_info ["salt"] = $salt;
		$user_info ["status"] = 1; // 0：为封号的
		$user_info ["sex"] = $sex;
		$user_info ["money"] = Game::$init_money;
		$user_info ["isauto"] = $isauto;
		$user_info ["coin"] = Game::$init_coin;
		if ($sex == 0)
			$user_info ["avater"] = "mm.png";
		else
			$user_info ["avater"] = "gg.png";
		
		$user_info ["skey"] = md5 ( time () . $salt );
		$user_info ["login_times"] = 1;
		$user_info ["login_days"] = 1;
		$user_info ["online_time"] = 1;
		$user_info ["is_get"] = 0;
		$user_info ["total_board"] = 0;
		$user_info ["total_win"] = 0;
		$user_info ['rmb'] = 0;
		$user_info ["level"] = 1;
		$user_info ["exp"] = 0;
		$user_info ["vipLevel"] = 0;
		$user_info ["broke_num"] = 0;
		$user_info ["broke_time"] = 0;
		$user_info ["charm"] = 0;
		$user_info ["telCharge"] = 0;
		$user_info ["headtime"] = 0;
		
		$regtm = $now;
		$user_info ["heartbeat_at"] = $regtm;
		$user_info ["create_time"] = $regtm;
		$user_info ["update_time"] = $regtm;
		// 初始化
		$user_info ["sign"] = "这屌丝很不犀利,什么都没留下!";

		return $user_info;
	}
	public static function createPlayerMark($soc, $uid) {
		$channel = "";
		$package = "";
		$ver = "";
		$ip = "";
		$imsi = "";
		$imei = "";
		$mtype = "";
		
		if (isset ( $soc->param ['channel'] )) {
			$channel = $soc->param ['channel'];
		}
		
		if (isset ( $soc->param ['package'] )) {
			$package = $soc->param ['package'];
		}
		if (isset ( $soc->param ['ver'] )) {
			$ver = $soc->param ['ver'];
		}
		if (isset ( $soc->param ['ip'] )) {
			$ip = $soc->param ['ip'];
		}
		if (isset ( $soc->param ['imsi'] )) {
			$imsi = $soc->param ['imsi'];
		}
		if (isset ( $soc->param ['imei'] )) {
			$imei = $soc->param ['imei'];
		}
		if (isset ( $soc->param ['mtype'] )) {
			$mtype = $soc->param ['mtype'];
		}
		
		// 把常用的 imsi imei ver 信息保存到redis, PayTrap接口需要
		$soc->data_redis->hMset ( "hu:{$uid}", array (
				"imsi" => $imsi,
				"imei" => $imei,
				"ver" => $ver,
				"pkg" => $package,
				"channel" => $channel
		) );

		
		$user_info = array ();
		$user_info ["uid"] = ( int ) $uid;
		$user_info ["channel"] = $channel;
		$user_info ["package"] = $package;
		$user_info ["ver"] = $ver;
		$user_info ["ip"] = $ip;
		$user_info ["imsi"] = $imsi;
		$user_info ["imei"] = $imei;
		$user_info ["mtype"] = $mtype;
		$user_info ["create_time"] = time ();
		
		return $user_info;
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
	
	/** 记录登录信息 */
	static function login_log($soc, $pmark) {
		//登录日志
		$soc->mysql->insert ( "login_log", $pmark );
		//用户登录信息更新
		$sql = "update playermark set last_channel='".$pmark['channel']."'".
				",last_package='".$pmark['package']."'".				
				",last_ver='".$pmark['ver']."'".
				",last_ip='".$pmark['ip']."'".
				",last_imsi='".$pmark['imsi']."'".
				",last_imei='".$pmark['imei']."'".
				",last_mtype='".$pmark['mtype']."'".
				",last_time=UNIX_TIMESTAMP(now())".
				",login_times=login_times+1 ".
				" where uid=".$pmark['uid'];		
		
		// $soc->i($sql);
		
		$soc->mysql->query($sql);
	}
	
	/**
	 * 
	 * 获取玩家玩的牌数。
	 *
	 * @param unknown $soc
	 * @param unknown $uid 
	 * @return number
	 */
	static function get_user_totalboard($soc, $uid, $package) {
		$total_board = 0;
		if (strcmp( $package, "com.chjie.dcow.nearme.gamecenter") == 0) {
			$user_arr = $soc->data_redis->hMget ( "hu:$uid", array ('total_board') );
			$total_board = ( int ) $user_arr ['total_board'];
		}
		return $total_board;
	}
}
?>
