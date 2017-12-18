<?php
include_once 'commonTool.php';
class APIBase {
	public $tag = "APIBase";
	public $uid;
	public $isLogin = true;
	public $response = array ();
	public $param;
	public $mysql;
	public $mysqlSlave;
	public $data_redis;
	public $cache_redis;
	public function before() {
		return true;
	}
	public function init() {
		if ($this->isLogin) {
			if (! isset ( $_GET ['uid'] ) or ! isset ( $_GET ['skey'] )) {
				$this->returnError ( 301, 'uid or skey must needed' );
			}
			if (empty ( $_GET ['uid'] ) or empty ( $_GET ['skey'] )) {
				$this->returnError ( 301, 'uid or skey error' );
			}
			$this->initDataRedis ( $_GET ['uid'] );
			
			$skey = $this->data_redis->hGet ( "hu:{$_GET['uid']}", 'skey' );
			if (Config::$debug) {
				$this->uid = $_GET ['uid'];
			} else {
				if ($skey == $_GET ['skey']) {
					$this->uid = $_GET ['uid'];
				} else {
					return $this->returnError ( 505, "账号在别处登录了" );
				}
			}
		}
		if (isset ( $_GET ['param'] )) {
			$this->param = ( array ) json_decode ( $_GET ['param'] );
			foreach($this->param as $x => $x_value){
				$this->d($x . ":" . $x_value);
			}
		}
	}
	
	// Uncheck skey,just for some background action
	public function initUnCheckSkey() {
		if (! isset ( $_GET ['uid'] ) || empty ( $_GET ['uid'] )) {
			$this->returnError ( 301, 'uid must needed' );
		}
		$this->initDataRedis ( $_GET ['uid'] );
		$this->uid = $_GET ['uid'];
		if (isset ( $_GET ['param'] )) {
			$this->param = ( array ) json_decode ( $_GET ['param'] );
		}
	}
	public function hincrMoney($money, $type) {
		/*
		 * if(Game::$act_money_status_open==1){ $this->data_redis->hincrBy("hactivity:{$this->uid}", "actWinMonDay", $money); $this->data_redis->hincrBy("hactivity:{$this->uid}", "actWinMonTot", $money); }
		 */
		$mon = $this->data_redis->hincrBy ( "hu:{$this->uid}", "money", $money );
		if ($money > 0) {
			$this->sendFlow ( $type, 0, 0, $mon - $money, $money );
		} else {
			$this->sendFlow ( $type, 0, 1, $mon + $money, $money );
		}
		$this->cache_redis->hincrBy ( "moneystat", $type, $money );
		return $mon;
	}
	public function hincrFunc($type) {
		$this->data_redis->hincrBy ( "uc:{$this->uid}", $type, 1 );
	}
	/**
	 * ts:time
	 * uid:user id
	 * flag:0-money,1-coin...
	 * action:0-ADD,1-SUB
	 * type:0-game,1-gift...
	 * curr_val:current value
	 * diff_val:change value
	 */
	private function sendFlow($type, $flag, $act, $cur_v, $diff_v) {
		$sock = socket_create ( AF_INET, SOCK_DGRAM, SOL_UDP );
		$flow ['uid'] = $this->uid;
		$flow ['tid'] = 0;
		$flow ['vid'] = 0;
		$flow ['ts'] = time ();
		$flow ['type'] = $type;
		$flow ['flag'] = $flag;
		$flow ['action'] = $act;
		$flow ['cur_val'] = $cur_v;
		$flow ['diff_val'] = $diff_v;
		
		$msg = Config::$log_agent ['pass'] . json_encode ( $flow );
		$len = strlen ( $msg );
		socket_sendto ( $sock, $msg, $len, 0, Config::$log_agent ['host'], Config::$log_agent ['port'] );
		socket_close ( $sock );
	}
	public function hincrCoin($money, $type) {
		$coin = $this->data_redis->hincrBy ( "hu:{$this->uid}", "coin", $money );
		if ($money > 0) {
			$this->sendFlow ( $type, 1, 0, $coin - $money, $money );
		} else {
			$this->sendFlow ( $type, 1, 1, $coin + $money, $money );
		}
		$this->cache_redis->hincrBy ( "coinstat", $type, $money );
		return $coin;
	}
	public function hincrExp($money) {
		$coin = $this->data_redis->hincrBy ( "hu:{$this->uid}", "exp", $money );
		$this->upLevel ( $coin );
		return $coin;
	}
	public function getPlayerName() {
		$name = $this->data_redis->hGet ( "hu:{$this->uid}", "name" );
		return $name;
	}
	public function getMoneyUnit($type) {
		if ($type == 0) {
			return "金币";
		} elseif ($type == 1) {
			return "元宝";
		}
	}
	public function deinit() {
		// release
	}
	public function initDataRedis($uid) {
		$mod = Config::$mod;
		$redis_config = Config::$redis_data_config;
		$redis_name = 'redis' . ($uid % $mod);
		$this->data_redis = new redis ();
		$ret = $this->data_redis->connect ( $redis_config [$redis_name] ['host'], $redis_config [$redis_name] ['port'] );
		if (! $ret) {
			$this->e ( "redis connect error." );
			$this->returnError ( 3, "redis connect error." );
		}
		$ret = $this->data_redis->auth ( $redis_config [$redis_name] ['pass'] );
		if (! $ret) {
			$this->e ( "redis auth error11." );
			$this->returnError ( 3, "redis auth error22." );
		}
	}
	public function deinitDataRedis() {
		$this->data_redis->close ();
	}
	public function initCacheRedis() {
		$redis_config = Config::$redis_cache_config;
		$this->cache_redis = new redis ();
		$ret = $this->cache_redis->connect ( $redis_config ['host'], $redis_config ['port'] );
		if (! $ret) {
			$this->e ( "redis connect error." );
			$this->returnError ( 3, "redis connect error." );
		}
		$ret = $this->cache_redis->auth ( $redis_config ['pass'] );
		if (! $ret) {
			$this->e ( "redis auth error33." );
			$this->returnError ( 3, "redis auth error44." );
		}
	}
	public function deinitCacheRedis() {
		$this->cache_redis->close ();
	}
	public function initMysql() {
		$this->mysql = new Mysql ();
		$ret = $this->mysql->connect ( Config::$mysql_config );
		if (! $ret) {
			$this->returnError ( 3, "db connect error." );
		}
	}
	public function deinitMysql() {
		$this->mysql->close ();
	}
	public function exec_logic() {
		$this->init ();
		
		if ($this->before ()) {
			$this->logic ();
			$this->after ();
		}
		
		$this->deinit ();
	}
	public function logic() {
	}
	public function after() {
	}
	public function returnData($data, $ret = 0, $desc = '') {
		$this->response ['ret'] = $ret;
		$this->response ['desc'] = $desc;
		if ($data) {
			$this->response ['data'] = $data;
		}
		echo json_encode ( $this->response );
		return;
	}
	public function returnError($code, $desc) {
		$this->returnData ( null, $code, $desc );
		exit ( 0 );
	}
	public function returnError2($data, $code, $desc) {
		$this->returnData ( $data, $code, $desc );
		exit ( 0 );
	}
	
	// 广播
	public function sendBroadcast($content, $type) {
		$prizeStr = $this->cache_redis->get ( "sysmess" );
		$msg ['type'] = $type;
		$msg ['msg'] = $content;
		$msg ['time'] = time ();
		if ($prizeStr) {
			$prizeArr = json_decode ( $prizeStr );
			$size = sizeof ( $prizeArr ) - 10;
			if ($size >= 0) {
				for($i = 0; $i <= $size; $i ++) {
					array_pop ( $prizeArr );
				}
			}
		} else {
			$prizeArr = array ();
		}
		array_unshift ( $prizeArr, $msg );
		$enMsg = json_encode ( $prizeArr );
		$this->cache_redis->set ( "sysmess", $enMsg );
	}
	
	// 私人消息
	public function sendPersonMsg($uid, $type = 'sys', $content) {
		$prizeStr = $this->data_redis->get ( "pmess:{$uid}" );
		$bln = 0;
		$msg ['type'] = $type;
		$msg ['msg'] = $content;
		$msg ['time'] = time ();
		$msg ['ir'] = 0;
		if ($prizeStr) {
			$prizeArr = json_decode ( $prizeStr );
			$size = sizeof ( $prizeArr );
			if ($size > 20) {
				for($i = 0; $i < $size; $i ++) {
					array_pop ( $prizeArr );
				}
			}
		} else {
			$prizeArr = array ();
		}
		array_unshift ( $prizeArr, $msg );
		$enMsg = json_encode ( $prizeArr );
		$this->data_redis->set ( "pmess:{$uid}", $enMsg );
	}
	public function initPlayerExt($uid) {
		// insert DB
		$player_ext = array ();
		$player_ext ['uid'] = $uid;
		$player_ext ['create_time'] = date('Y-m-d H:i:s', time());
		$this->mysql->insert ( "playerext", $player_ext );
	}
	
	// mysql 192.168.0.59
	public function initMysqlSlave() {
		$this->mysqlSlave = new Mysql ();
		$ret = $this->mysqlSlave->connect ( Config::$mysql_slave_config );
		if (! $ret) {
			$this->returnError ( 4, "db connect error." );
		}
	}
	public function deinitMysqlSlave() {
		$this->mysqlSlave->close ();
	}
	public function getVipInfo($level) {
		$prizeStr = $this->cache_redis->get ( "svips" );
		$prizeArr = json_decode ( $prizeStr );
		foreach ( $prizeArr as $g ) {
			if ($g->level == $level) {
				return $g;
			}
		}
		return null;
	}
	public function upTasksStatus($taskId) {
		$tn = "t" . $taskId;
		$gn = "g" . $taskId;
		$pbt = $this->data_redis->hMget ( "hubta:{$this->uid}", array (
				$tn,
				$gn 
		) );
		if ((isset ( $pbt [$gn] ) && $pbt [$gn] > 0) || (isset ( $pbt [$tn] ) && $pbt [$tn] > 0)) {
			return;
		}
		$this->data_redis->hIncrBy ( "hubta:{$this->uid}", $tn, 1 );
	}
	public function upVipLevel() {
		$pInfo = $this->data_redis->hMget ( "hu:{$this->uid}", array (
				"exp",
				"vipLevel",
				"charm" 
		) );
		$prizeStr = $this->cache_redis->get ( "svips" );
		$prizeArr = json_decode ( $prizeStr );
		$time12MonthBef = time()-86400*365;
		// 12个月内的充值总和
		$row = $this->mysql->select ( "payorder", "sum(rmb) as tr", array (
						'uid' => $this->uid,
						'success' => 1 
				)," and created_at>'".$time12MonthBef."'" );
		$rmb12Month = isset($row[0]['tr'])?(int)$row[0]['tr']:0;
		// echo $pInfo['exp'].'-'.$pInfo['inc_recharge'].'-'.$pInfo['vipLevel'].'-'.$pInfo['charm'];
// 		$this->d("upVip uid is ".$this->uid.",curr rmb is ".$rmb12Month.",vip is ".$pInfo ['vipLevel']);
		foreach ( $prizeArr as $g ) {
			if ($rmb12Month >= $g->min_recharge && $pInfo ['exp'] >= $g->min_exp) {
				if ($g->level != $pInfo ['vipLevel']) {
// 					$this->d("upVip uid is ".$this->uid.",new vip is ".$g->level);
					$this->data_redis->hSet ( "hu:{$this->uid}", "vipLevel", $g->level );
				}
				return;
			}
		}
	}
	/**
	 * 根据EXP更新等级
	 */
	public function upLevel($exp) {
		$pInfo = $this->data_redis->hMget ( "hu:{$this->uid}", array (
				"level" 
		) );
		$prizeStr = $this->cache_redis->get ( "slevel" );
		$prizeArr = json_decode ( $prizeStr );
		foreach ( $prizeArr as $g ) {
			if ($exp >= $g->minExp && ($exp <= $g->maxExp || $g->maxExp == 0)) {
				if ($g->level != $pInfo ['level']) {
					$this->data_redis->hSet ( "hu:{$this->uid}", "level", $g->level );
				}
				return;
			}
		}
	}
	
	// 获取头衔
	public function getTitleInfo($money) {
		$money = isset ( $money ) ? $money : 0;
		$prizeStr = $this->cache_redis->get ( "stitle" );
		$prizeArr = json_decode ( $prizeStr );
		foreach ( $prizeArr as $g ) {
			if ($money >= $g->minMoney && ($money <= $g->maxMoney || $g->maxMoney == 0)) {
				return $g->title;
			}
		}
		return "";
	}
	// 检查版本更新 、屏蔽模块
	public function check_app_info($package, $channel, $curver,$safebox,$total_board) {
		$verinfo = array ();
// 		echo $package.':'.$channel.':'.$curver;
		$ver_last = 0;
		$upInfo = '';
		$ver = '';
		$isforce = 0;
		
		$prizeStr = $this->cache_redis->get ( "sappupcontrol" );
		$prizeArr = json_decode ( $prizeStr );
		$now = time();
		// 优先检查是否有特殊的版本更新
		if (! empty ( $prizeArr ) && sizeof ( $prizeArr ) > 0) {
			foreach ( $prizeArr as $g ) {
				if ($g->startTime<=$now && $g->endTime>=$now && $g->package == $package && $g->channel == $channel) {
					$ver_last = $g->ver_last;
					$upInfo = $g->memo;
					$ver = $g->ver;
					$isforce = $g->isforce;
					break;
				}
			}
		}
		// 常规的版本更新检查
		if($ver_last==0){
			$prizeStr = $this->cache_redis->get ( "sapps" );
			$prizeArr = json_decode ( $prizeStr );
			if (! empty ( $prizeArr ) && sizeof ( $prizeArr ) > 0) {
				foreach ( $prizeArr as $g ) {
					if ($g->package == $package) {
						$ver_last = $g->ver_last;
						$upInfo = $g->memo;
						$ver = $g->ver;
						$isforce = $g->isforce;
						break;
					}
				}
			}
		}		
		
		// 更新文件的url
		// 判断是否有更新文件的存在
		if ($ver_last > 0 && $curver > 0 && $curver < $ver_last) {
			$url_update = Config::$url_update_app;			
			
			if (array_key_exists($package, Config::$url_update_app_dir)) {
				$url_update = Config::$url_update_app_dir[$package];
			}
			
			if ($channel == '3003967959') {
			    $url_update = "http://182.254.211.73/bull/" . "test";
			}
			
			// 有新版本，判断是否存在新版本的文件
			$url = $url_update . $ver_last . "/" . $channel . "." . $ver_last . ".apk";
			$array = get_headers ( $url, 1 );
			if (preg_match ( '/200/', $array [0] )) {
				$verinfo ['url'] = $url;
			} else {
				// 文件不存在，检查是否有替换渠道版本更新
				$row2 = $this->mysql->select ( "channel_infos", "*", array (
						'channel' => $channel 
				) );
				foreach ( $row2 as $ro ) {
					$chn_upd = $ro ['channel_update'];
				}
				if (isset ( $chn_upd ) && strlen ( $chn_upd ) > 0) {
					$url = $url_update . $ver_last . "/" . $chn_upd . "." . $ver_last . ".apk";
					$arr2 = get_headers ( $url, 1 );
					if (preg_match ( '/200/', $arr2 [0] )) {
						$verinfo ['url'] = $url;
					}
				}
			}
			$pkgMd5 = $this->cache_redis->get ( "pkgMd5:".$channel);
			$verinfo ['upInfo'] = $upInfo;
			$verinfo ['upVer'] = $ver_last;
			$verinfo ['upMd5'] = $pkgMd5;
			$verinfo ['isforce'] = $isforce;
		}
		
		// 检查是否有需要屏蔽的模块
		/*
		 * $row = $this->mysql->select("app_modules", "module_id as id", array('type_value' => $appid,'type_id' => 1,'closed' => 1)); if (empty($row) || sizeof($row)<1) { $row = $this->mysql->select("app_modules", "module_id as id", array('type_value' => $cpid,'type_id' => 0,'closed' => 1)); } if (!empty($row) && sizeof($row)>0) { $verinfo["closeModel"] = $row; }
		 */
		$prizeStr = $this->cache_redis->get ( "sappmodules" );
		$prizeArr = json_decode ( $prizeStr );
		if (! empty ( $prizeArr ) && sizeof ( $prizeArr ) > 0) {
			foreach ( $prizeArr as $g ) {
				if ($g->closed == 1 && $g->type_value == $package && $g->type_id == 1) {				
					if (strcmp( $package, "com.tencent.tmgp.chjie.dcow") == 0 && $total_board > 50 ) {
						//腾讯版本 玩家玩了>50盘后，开放屏蔽模块
					}	
					else {				
						if ( ($curver >= 3) && (strcmp( $package, "com.chjie.dcow.nearme.gamecenter") == 0) && (strcmp( $g->module_id, "slot") == 0) )  {					
							//可可版本 slot 模块 ver>=3 打开
						}
						elseif ( ($curver >= 5) && (strcmp( $g->module_id, "share") == 0) )  {
							//分享模块 v1.4 ver>=5  打开 
						}
						else {
							$r ['id'] = $g->module_id;
							$temp_app_sdk [] = $r;
						}
					}
				}
				if ($g->closed == 1 && $g->type_value == $channel && $g->type_id == 0) {
					$r ['id'] = $g->module_id;
					$temp_app_sdk [] = $r;
				}
			}
			if($safebox==0){
				$r ['id'] = 'safebox';
				$temp_app_sdk [] = $r;
			}
			if (! empty ( $temp_app_sdk )) {
				$verinfo ["closeModel"] = $temp_app_sdk;
			}
		}
		
		if ($channel == '3003967959') {
		    $this->i("url=". (isset($verinfo ['url']) ? $verinfo ['url'] : "  ver_last=". $ver_last)) ;
		}
		return $verinfo;
	}
	
	// 检查用户是否有特惠坑
	public function check_trap_special($uid, $imsi, $imei) {
		$ret = 1;
		$trap = $this->data_redis->hMget ( "htrap:{$uid}", array (
				"sdate",
				"edate" 
		) );
		
		$start = 0;
		$end = 0;
		// 当前时间戳
		$nowtime = time ();
		if (isset ( $trap ["sdate"] ) && isset ( $trap ["edate"] )) {
			$start = sprintf ( "%u", $trap ["sdate"] );
			$end = sprintf ( "%u", $trap ["edate"] );
			if ($nowtime >= $start && $nowtime <= $end) {
				$ret = 0;
			} else {
				$ret = 1;
			}
		}
		
// 		$this->i ( "check_trap_special: uid={$uid} ; now={$nowtime} ; start={$start} ; end={$end}" );
		
		return $ret;
	}
	
	// 判断移动用户是否需要打开 0.1元的开关  0=关闭  ； 1=开启
	public function check_rmb10fen($uid, $imsi) {
		$ret = 0;
		$flag = 0 ;
		/* 20141205 close 
		//判断imsi 是移动的
		$op = CommonTool::getOP($imsi);
		if ($op == 1) {
			if (isset($imsi)) {
				$ret = (int) $this->cache_redis->hget ( "fen:{$imsi}", "times");
			}
			if ($ret <= 0) {
				$ret = (int) $this->cache_redis->hget ( "fen:{$uid}", "times");
			}
			
			if ($ret > 0 ) {
				$flag = 0;
			}
			else {
				$flag = 1;
			}
		}
		*/
		return $flag;
	}
	
	
	// 获取指定日期所在星期的开始时间与结束时间
	// $ret=getWeekRange(date('Y-m-d'));
	public function getWeekRange($date) {
		$ret = array ();
		$timestamp = strtotime ( $date );
		$w = strftime ( '%u', $timestamp );
		$ret ['sdate'] = date ( 'Y-m-d 00:00:00', $timestamp - ($w - 1) * 86400 );
		$ret ['edate'] = date ( 'Y-m-d 23:59:59', $timestamp + (7 - $w) * 86400 );
		return $ret;
	}
		
	// 获取指定日期所在星期的开始时间与结束时间
	public function getWeekRangeStamp($date) {
		$ret = array ();
		$dt = 5; // 间隔天数
		$timestamp = strtotime ( $date );
		//$w = strftime ( '%u', $timestamp );
		$w = 1;
		$ret ['sdate'] = strtotime ( date ( 'Y-m-d 00:00:00', $timestamp - ($w - 1) * 86400 ) );
		$ret ['edate'] = strtotime ( date ( 'Y-m-d 23:59:59', $timestamp + ($dt - $w) * 86400 ) );
	
		return $ret;
	}
	
	// 24位数的订单号 - 联通
	public function build_order() {
		$id = rand ( 1, 1234567890 );
		$pre = sprintf ( '%014d', $id );
		$order = time () . $pre;
		
		return $order;
	}
	
	// http的get方式请求，返回请求后的内容
	public function http_get($url, $arr_data) {
		$opts = array (
				'http' => array (
						'method' => "GET",
						'timeout' => 60 
				) 
		);
		if (! empty ( $arr_data )) {
			$query = @http_build_query ( $arr_data );
			$url = $url . '?' . $query;
		}
		$context = stream_context_create ( $opts );
		$ret = @file_get_contents ( $url, false, $context );
		return $ret;
	}
	
	// http的post方式请求，返回请求后的内容
	public function http_post($url, $arr_data = null) {
		$context = array ();
		if (is_array ( $arr_data )) {
			ksort ( $arr_data );
			$context ['http'] = array (
					'timeout' => 60,
					'method' => 'POST',
					'content' => @http_build_query ( $arr_data, '', '&' ) 
			);
		}
		$ret = @file_get_contents ( $url, false, stream_context_create ( $context ) );
		
		return $ret;
	}
	
	// 16位数的订单号--电信
	public function build_order_ct() {
		$id = rand ( 1, 123456 );
		$pre = sprintf ( '%06d', $id );
		$order = time () . $pre;
		return $order;
	}
	public function get_pay_order($sdk, $rmb,$pkg) {
		$order_id = "";
		// 判断用户是否恶意刷话费
		if (strcmp ( $sdk, "12" ) == 0) {
			// 悠悠村, 查询该用户30秒内是否有成功订单，如果有，则限制其或者订单号，返回错误信息。
			$sql = "select uid from payorder where success=1 AND sdk='12' AND uid='{$this->uid}' AND TIMESTAMPDIFF(SECOND, updated_at, NOW() ) < 30 ";
			$row = $this->mysql->find ( $sql );
			if (count ( $row ) > 0) {
				$this->mysql->insert ( "pay_limit_log_invalid", array (
						'uid' => $this->uid,
						'sdk' => $sdk,
						'rmb' => $rmb,
						'errcode' => '801',
						'memo' => '悠悠村30秒内防刷' 
				) );
				$this->returnError ( 801, '抱歉，话费支付受限，请用其他支付方式。' );
				return;
			}
		}
		
		// 判断是否话费防刷
		$arrflag = $this->is_black_pay ( $this->uid, $sdk ,$pkg);
		if ($arrflag ['flag'] > 0) {
			$errcode = '800';
			if ($arrflag ['flag'] == 1) {
				$errcode = '802';
			}
			else {
				$errcode = '803';
			}
			$this->mysql->insert ( "pay_limit_log_invalid", array (
					'uid' => $this->uid,
					'sdk' => $sdk,
					'rmb' => $rmb,
					'errcode' => $errcode,
					'memo' => $arrflag ['desc'] 
			) );
			$this->returnError ( 802, '抱歉，话费支付受限，请用其他支付方式。' );
			return;
		}
		
		if (strcmp ( $sdk, "02" ) == 0) {
			// 联通 24 位
			$order_id = $this->build_order ();
		} else {
			// 电信 和其他支付方式 16位
			$order_id = $this->build_order_ct ();
		}
		return $order_id;
	}
	
	/**
	 * 该用户是否被限制刷话费, $arr['flag']=0：没有；$arr['flag']>0:有 1=day;2=month
	 */
	private function is_black_pay($uid, $sdk, $pkg) {
		$black_flag = 0;
		$black_key = "";
		if(in_array($pkg, Game::$pay_ban_pkg_list)){
			$arr = array ();
			$arr ['flag'] = $black_flag;
			$arr ['desc'] = $black_key;			
			return $arr;
		}
		if (empty($sdk)) {
			$sdk = "000";
		}
		// 话费支付sdks
		$sdks = ",01,02,03,08,12,";
		$pos = strpos ( $sdks, $sdk );
		if ($pos === false) {
			$black_flag = 0;
		} else {
			// 是话费支付
			// 获取用户设备标识
			$user_info = $this->data_redis->hMget ( "hu:$uid", array (
					'imsi',
					'imei' 
			) );
			$imsi = isset ( $user_info ['imsi'] ) ? $user_info ['imsi'] : "";
			$imei = isset ( $user_info ['imei'] ) ? $user_info ['imei'] : "";
			// 具有有效的话费卡
			if (strlen ( $imsi ) > 5) {
				if ($black_flag == 0) {
					// imsi black_key
					$black_key = "blackpay:imsi:{$imsi}";
					$black_flag = $this->get_black_flag ( $black_key );
				}
				if ($black_flag == 0) {
					// uid black_key
					$black_key = "blackpay:uid:{$uid}";
					$black_flag = $this->get_black_flag ( $black_key );
				}
				if ($black_flag == 0) {
					// imei black_key
					$black_key = "blackpay:imei:{$imei}";
					$black_flag = $this->get_black_flag ( $black_key );
				}
			}
		}
		
		$arr = array ();
		$arr ['flag'] = $black_flag;
		$arr ['desc'] = $black_key;
		
		return $arr;
	}
	// 0:无;>0有 1=day;2=month
	private function get_black_flag($black_key) {
		$black_flag = 0;
		$day_rmb = 0;
		$month_rmb = 0;
		$dsum = 0;
		$msum = 0;
		$tm = "";
		
		if ($black_flag == 0) {
			$black = $this->cache_redis->hMGet ( $black_key, array (
					"day_rmb",
					"month_rmb",
					"dsum",
					"msum",
					"tm" 
			) );
			
			if ($black ['day_rmb'] && $black ['month_rmb']) {
				$tm = $black ['tm'];
				$arrDay = $this->if_time_equal ( $tm );
				if ($arrDay ['day'] == 1 && $black_flag == 0) {
					// 当天
					$day_rmb = ( int ) $black ['day_rmb'];
					$dsum = ( int ) $black ['dsum'];
					if ($day_rmb > 0 && $dsum >= $day_rmb) {
						$black_flag = 1;
					}
				}
				if ($arrDay ['month'] == 1 && $black_flag == 0) {
					// 当月
					$month_rmb = ( int ) $black ['month_rmb'];
					$msum = ( int ) $black ['msum'];
					if ($month_rmb > 0 && $msum >= $month_rmb) {
						$black_flag = 2;
					}
				}
			}
		}
		return $black_flag;
	}
	/**
	 * 防刷时间段判断，日、月
	 * 1:日相等，月相等
	 */
	private function if_time_equal($tm) {
		$the_month = date ( "Y-m", strtotime ( $tm ) );
		$the_day = date ( "Y-m-d", strtotime ( $tm ) );
		
		$now_day = date ( "Y-m-d", time () );
		$now_month = date ( "Y-m", time () );
		
		$arr = array ();
		if ($the_day == $now_day) {
			$arr ['day'] = 1;
		} else {
			$arr ['day'] = 0;
		}
		
		if ($the_month == $now_month) {
			$arr ['month'] = 1;
		} else {
			$arr ['month'] = 0;
		}
		return $arr;
	}
	
	/**
	 * 判断日、月是否相等或者相差1天
	 * flag: 0=判断日期是否相连; 1=判断月份是否相连
	 * tm: 时间
	 * 时间差
	 */
	private function if_time_continuous($tm, $flag) {
		$num = 0 ;
		if ($flag == 0) {
			$the_day = date ( "Y-m-d", strtotime ( $tm ) );
			$now = date ( "Y-m-d", time () );			 
			//得到两个时间之间间隔的天数（整数）。
			$num = ROUND( (strtotime ( $now ) - strtotime($the_day)) / (60 * 60 * 24) );
		}
		else { //月份相差			
			$date1 = explode("-", date ( "Y-m", time () ));
			$date2 = explode("-", date ( "Y-m", strtotime ( $tm ) ));
			$num = ($date1[0] - $date2[0]) * 12 + ($date1[1] - $date2[1]);
		}
		return $num;
	}
	
	/**
	 * 该用户是否被被设置了话费防刷，PayMoney接口调用
	 * $uid 用户ID
	 * $sdk 当前充值sdk
	 * $rmb 当前充值金额
	 */
	public function is_black_pay_set($uid, $sdk, $rmb) {
		$black_flag = 0;
		// 话费支付sdks
		$sdks = ",01,02,03,08,12,";
		$pos = strpos ( $sdks, $sdk );
		if ($pos === false) {
			$black_flag = 0;
		} else {
			// 是话费支付
			// 获取用户设备标识
			$user_info = $this->data_redis->hMget ( "hu:$uid", array (
					'imsi',
					'imei' 
			) );
			$imsi = isset ( $user_info ['imsi'] ) ? $user_info ['imsi'] : "";
			$imei = isset ( $user_info ['imei'] ) ? $user_info ['imei'] : "";
			// 具有有效的话费卡
			if (strlen ( $imsi ) > 5) {
				$black_flag = 1;
				// imsi black_key
				$black_key = "blackpay:imsi:{$imsi}";
				$this->black_key_set ( $black_key, $rmb, $sdk );
				// uid black_key
				$black_key = "blackpay:uid:{$uid}";
				$this->black_key_set ( $black_key, $rmb, $sdk );
			}
			if (strlen ( $imei ) > 5) {
				// imei black_key
				$black_key = "blackpay:imei:{$imei}";
				$this->black_key_set ( $black_key, $rmb, $sdk );
			}
		}
		return 0;
	}
	private function black_key_set($black_key, $rmb, $sdk='00') {
		//默认值
		$def_day_rmb = 200;
		$def_month_rmb = 1500;
		
		$day_rmb = 200;
		$month_rmb = 1500;
		if (isset($sdk) && $sdk=='12') {
			//悠悠村
			$def_day_rmb = 100;
			$def_month_rmb = 1000;
			
			$day_rmb = 100;
			$month_rmb = 1000;
		}
		
		$dsum = $rmb;
		$msum = $rmb;
		
		$tm = date ( "Y-m-d H:i:s", time () );
		$dtimes = 0;
		$mtimes = 0;		
		$lastd = $tm; //最近的超限日期 (日)
		$lastm = $tm; //最近的超限日期 (月)
		
		$black = $this->cache_redis->hMGet ( $black_key, array (
				"day_rmb",
				"month_rmb",
				"tm",
				"dtimes",
				"mtimes",
				"lastd",
				"lastm"
		) );
		// 只要是付费成功了，都记录
		if ($rmb > 0) {			
			if ($black ['day_rmb'] && $black ['month_rmb']) {				
				$day_rmb = ( int ) $black ['day_rmb'];
				$month_rmb = ( int ) $black ['month_rmb'];
				if ($day_rmb <= 0) {
					$day_rmb = $def_day_rmb;
				}
				if ($month_rmb <=0 ) {
					$month_rmb = $def_month_rmb;
				}
				
				$tm = $black ['tm'];
				$arrDay = $this->if_time_equal ( $tm );
				if ($arrDay ['day'] == 1) {
					$dsum = $this->cache_redis->hincrBy ( $black_key, "dsum", $dsum );
				} else {
					$this->cache_redis->hset ( $black_key, "dsum", $dsum );
				}					
				if ($arrDay ['month'] == 1) {
					$msum = $this->cache_redis->hincrBy ( $black_key, "msum", $msum );
				} else {
					$this->cache_redis->hset ( $black_key, "msum", $msum );
				}
				$this->cache_redis->hset ( $black_key, "tm", date ( "Y-m-d H:i:s", time () ) );	
				
				$dtimes = isset($black ['dtimes']) ? (int)$black ['dtimes'] : 0;
				$mtimes = isset($black ['mtimes']) ? (int)$black ['mtimes'] : 0;
				$lastd = isset($black ['lastd']) ? $black ['lastd'] : date ( "Y-m-d H:i:s", time () );
				$lastm = isset($black ['lastm']) ? $black ['lastm'] : date ( "Y-m-d H:i:s", time () );
				
			} else {				
				$this->cache_redis->hMset ( $black_key, array(
					"day_rmb" => $day_rmb,
					"month_rmb" => $month_rmb,
					"dsum" => $dsum,
					"msum" => $msum,
					"tm" => $tm
			    ));			
			}
			
			/*
			 日限自动减半：
			连续三天达限额的80%,则第四天限额自动减半；减半后,若再连续3天达限额的80*继续减半,直至减到10元以内为止（取整）
			月限自动减半：
			若当月话费支付达限额的80%,则次月额度自动减半；减半后,若次月再达限额继续减半,直至减到100元以内为止（取整）
			*/
			// $dtimes > 3 次
			if ($dtimes > 3 && $day_rmb > 10 ) {
				$month_rmb_old = $month_rmb;
				$day_rmb_old = $day_rmb;
				
				$day_rmb = ROUND($day_rmb * 0.5);
				$dtimes = 0;
				$this->cache_redis->hMset ( $black_key, array(
						"day_rmb" => $day_rmb,
						"dtimes" => $dtimes
				));				
				//把更改写到表里面
				$this->update_table_limit($black_key, $day_rmb, $month_rmb,$day_rmb_old,$month_rmb_old,'连续3日达限，日限额减半');			
			}		
			if ($dsum >= ROUND($day_rmb * 0.8)) {
				//超限, 如果日期相等 或者相差一天
				$num = $this->if_time_continuous($lastd, 0) ;
				if ($num == 1) {
					//日期相差一天					
					$dtimes = $this->cache_redis->hincrBy ( $black_key, "dtimes", 1 );					
				}
				else if ($num > 1) {
					$dtimes = 1;
					$this->cache_redis->hset ( $black_key, "dtimes", $dtimes );
				}
				else { //同一天					
					if ($dtimes == 0) {
						$dtimes = 1;
						$this->cache_redis->hset ( $black_key, "dtimes", $dtimes );
					}
				}
				$this->cache_redis->hset ( $black_key, "lastd", date ( "Y-m-d H:i:s", time () ) );				
			}
			
			//月限自动减半
			// 当前时间与上次超限时间比较
			$num = $this->if_time_continuous($lastm, 1);
			if ($num > 0 && $mtimes > 0 && $month_rmb > 100) {
				//不同月
				$month_rmb_old = $month_rmb;
				$day_rmb_old = $day_rmb;
				
				$mtimes = 0 ;
				$this->cache_redis->hset ( $black_key, "mtimes", $mtimes);
				if ($month_rmb > 100) {
					$month_rmb = ROUND($month_rmb * 0.5);
					$this->cache_redis->hset ( $black_key, "month_rmb", $month_rmb );					
				}
				//把更改写到表里面
				$this->update_table_limit($black_key, $day_rmb, $month_rmb,$day_rmb_old,$month_rmb_old,'月份达限,月限额减半');
				
			}
			if ($msum >= ROUND($month_rmb * 0.8)) {
				$mtimes = $this->cache_redis->hincrBy ( $black_key, "mtimes", 1 );
				$this->cache_redis->hset ( $black_key, "lastm", date ( "Y-m-d H:i:s", time () ) );
			}
		}
		
		return 0;
	}
	
	function update_table_limit($black_key, $day_rmb, $month_rmb,$day_rmb_old,$month_rmb_old,$memo) {
		$keys = explode(":", $black_key);
		if (isset($keys[1]) && isset($keys[2])) {
			$sql = "select id from pay_limit where limit_key='{$keys[1]}' and limit_value='{$keys[2]}'";
			$row = $this->mysql->find ( $sql );
			if (count ( $row ) > 0) {				
				$this->mysql->update ( "pay_limit", array (
						'day_rmb' => $day_rmb,
						'month_rmb' => $month_rmb,
						'day_rmb_old' => $day_rmb_old,
						'month_rmb_old' => $month_rmb_old,
						'memo' => $memo,
						'who' => 'system'						
						),
						array (
						'limit_key' => $keys[1],
						'limit_value' => $keys[2]
						));
			} else {
				$this->mysql->insert('pay_limit', array(
					'limit_key' => $keys[1],
					'limit_value' => $keys[2],
					'day_rmb' => $day_rmb,
					'month_rmb' => $month_rmb,
					'day_rmb_old' => $day_rmb_old,
					'month_rmb_old' => $month_rmb_old,
					'memo' => $memo,
					'who' => 'system'
				));
			}
		}
		return 0;
	}
	/**
	 * 获取付费坑信息
	 *
	 * @param $uid 用户ID        	
	 * @param $pos 坑位置        	
	 * @param $trap 坑ID        	
	 * @param $flag flag=1
	 *        	查询计费点表，否则不查
	 */
	public function get_trap_info($uid, $pos, $trap, $flag) {
		$info = array ();
		// 获取用户设备标识
		$user_info = $this->data_redis->hMget ( "hu:$uid", array (
				'imsi',
				'imei',
				'pkg',
				'ver',
				'channel' 
		) );
		
		$pkg = isset ( $user_info ['pkg'] ) ? $user_info ['pkg'] : "";
		$channel = isset ( $user_info ['channel'] ) ? $user_info ['channel'] : "";
		
		//益玩SDK		
		if (stripos($pkg, "com.chjie.dcow.ewan") !== false ) {
			return $info;
		}
		//20151012 和游戏 审核渠道没有坑 
		//if (isset($channel) && $channel == "JBSM000001") {
		//	return $info;
		//}
		
		$sdk = '';
		$rmb = '';
		// 返回信息
		$ret_info = array ();
		$apptype = 1;
		// 获取用户的package、channel
		$sql = "select apptype from trap_apptype where package='{$pkg}' and channel='{$channel}'";
		$row = $this->mysql->find ( $sql );
		$isMM_audit = $this->cache_redis->get ( "smm_audit");
		if (count ( $row ) > 0) {
			$apptype = ( int ) $row [0] ['apptype'];
		} else {
			$apptype = 1;
		}
		
		// 根据sdk rmb 查找 计费点信息，判断有效性
		$sql = "select * from trap_info where isopen=1 and pos='{$pos}' and trap='{$trap}' and apptype='{$apptype}'";
		$row = $this->mysql->find ( $sql );
		
		foreach ( $row as $r ) {			
			$info ['rmb'] = ( int ) $r ['rmb'];
			// 如果是MM审核阶段，则使用无赠送的计费点
			if($channel=='000000000000' && isset($isMM_audit) && $isMM_audit==1){
				$info ['money'] = $info ['rmb']*10000;
			}else{
				$info ['money'] = ( int ) $r ['money'];
			}			
			$info ['coin'] = ( int ) $r ['coin'];
			//$info ['isgoods'] = ( int ) $r ['isgoods'];
			$info ['sdk'] = $r ['sdk'];
			
			$info ['pos'] = $pos;
			$info ['trap'] = $trap;
			
			$sdk = $r ['sdk'];
			$rmb = ( int ) $r ['rmb'];
		}
		
		if ($flag == 1 && ! empty ( $info )) {
			// 根据sdk rmb 查找 计费点信息，判断有效性
			$sql = "select b.money,b.coin,b.rmb from pay_sdk a join pay_points b on a.id=b.pay_sdk_id where a.sdk='{$sdk}' and b.rmb='{$rmb}'";
			$row = $this->mysql->find ( $sql );
			if (count ( $row ) > 0) {
				$info ['moneydef'] = ( int ) $row [0] ['money'];
			} else {
				$info ['moneydef'] = $info ['money'];
			}
		}
		
		return $info;
	}
	
	public function priTodayRechargeInfo($rmb){
		$tot = 0;
		$pe = $this->data_redis->hMget ( "hpe:{$this->uid}", array("lastRechargeTime","todayRechargeTot"));
		$now = time();
		$bln = false;
		if(!$pe['lastRechargeTime'] || !CommonTool::isSameDay(time(), $pe['lastRechargeTime'])){
			$tot = $rmb;
		}else{
			$tot = $pe['todayRechargeTot'] + $rmb;
		}
		$this->data_redis->hMset ( "hpe:{$this->uid}", array(
				"lastRechargeTime"=>$now,
				"todayRechargeTot"=>$tot
		));
	}
	
	public function d($msg) {
		Config::$logger->debug ( $this->tag, $msg );
	}
	public function i($msg) {
		Config::$logger->info ( $this->tag, $msg );
	}
	public function w($msg) {
		Config::$logger->warn ( $this->tag, $msg );
	}
	public function e($msg) {
		Config::$logger->error ( $this->tag, $msg );
	}
	public function f($msg) {
		Config::$logger->fatal ( $this->tag, $msg );
	}
}
?>
