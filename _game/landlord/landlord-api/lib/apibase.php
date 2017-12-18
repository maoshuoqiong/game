<?php
	include_once 'commonTool.php';
	
    class APIBase {		
		public $tag = "APIBase";
		public $uid;
		public $isLogin = true;
		public $response = array();
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
				if (!isset($_GET['uid']) or !isset($_GET['skey'])) {
					$this->returnError(301, 'uid or skey must needed');
				}
				if (empty($_GET['uid']) or empty($_GET['skey'])) {
					$this->returnError(301, 'uid or skey error');
				}
				$this->initDataRedis($_GET['uid']);
				
				$skey = $this->data_redis->hGet("hu:{$_GET['uid']}", 'skey');
				if (Config::$debug) {
					$this->uid = $_GET['uid'];
				} else {
					if ($skey == $_GET['skey']) {
						$this->uid = $_GET['uid'];
					} else {
						return $this->returnError(505, "skey error");
					}
				}
			}
			if (isset($_GET['param'])) {
				$this->param = (array)json_decode($_GET['param']);
			}
		}
		
		// Uncheck skey,just for some background action
		public function initUnCheckSkey() {
			if (!isset($_GET['uid']) || empty($_GET['uid'])) {
				$this->returnError(301, 'uid must needed');
			}
			$this->initDataRedis($_GET['uid']);
			$this->uid = $_GET['uid'];				
			if (isset($_GET['param'])) {
				$this->param = (array)json_decode($_GET['param']);
			}
		}
		
		public function hincrMoney($money,$type){
			if(Game::$act_money_status_open==1){
				$this->data_redis->hincrBy("hactivity:{$this->uid}", "actWinMonDay", $money);
				$this->data_redis->hincrBy("hactivity:{$this->uid}", "actWinMonTot", $money);
			}			
			$mon = $this->data_redis->hincrBy("hu:{$this->uid}", "money", $money);
			$this->cache_redis->hincrBy("moneystat",$type,$money);
			return $mon;
		}
		
		public function hincrFunc($type){
			$this->data_redis->hincrBy("uc:{$this->uid}",$type,1);
		}
		
		public function hincrCoin($money,$type){
			$coin = $this->data_redis->hincrBy("hu:{$this->uid}", "coin", $money);
			$this->cache_redis->hincrBy("coinstat",$type,$money);
			return $coin;
		}
		
		public function hincrExp($money) {
			$coin = $this->data_redis->hincrBy ( "hu:{$this->uid}", "exp", $money );
			return $coin;
		}
		
		public function sendBroadcast($content,$type){
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
		
		public function deinit() {
			// release 	
		}
		
		public function initDataRedis($uid) {
			$mod = Config::$mod;
			$redis_config = Config::$redis_data_config;
			$redis_name = 'redis'.($uid % $mod);
			$this->data_redis = new redis();
			$ret = $this->data_redis->connect($redis_config[$redis_name]['host'],
					$redis_config[$redis_name]['port']);
			if (!$ret) {
				$this->e("redis connect error.");
				$this->returnError(3, "redis connect error.");
			}
			$ret = $this->data_redis->auth($redis_config[$redis_name]['pass']);
			if (!$ret) {
				$this->e("redis auth error11.");
				$this->returnError(3, "redis auth error22.");
			}
		}
		
    	public function deinitDataRedis() {
			$this->data_redis->close();
		}

		public function initCacheRedis() {
			$redis_config = Config::$redis_cache_config;
			$this->cache_redis = new redis();
			$ret = $this->cache_redis->connect($redis_config['host'], $redis_config['port']);
			if (!$ret) {
				$this->e("redis connect error.");
				$this->returnError(3, "redis connect error.");
			}
			$ret = $this->cache_redis->auth($redis_config['pass']);
			if (!$ret) {
				$this->e("redis auth error33.");
				$this->returnError(3, "redis auth error44.");
			}
		}
		
    	public function deinitCacheRedis() {
			$this->cache_redis->close();
		}

		public function initMysql() {
			$this->mysql = new Mysql();
			$ret = $this->mysql->connect(Config::$mysql_config);
			if (!$ret) {
				$this->returnError(3, "db connect error.");
			}
		}
		
		public  function deinitMysql() {
			$this->mysql->close();
		}
		
		public function exec_logic() {
			$this->init();
			
			if ($this->before()) {
				$this->logic();
				$this->after();
			}
			
			$this->deinit();
		}
		
		public function logic() {
			
		}
		
		public function after() {
		
		}
		
		public function returnData($data, $ret = 0, $desc = '') {
			$this->response['ret'] = $ret;
			$this->response['desc'] = $desc;
			if ($data) {
				$this->response['data'] = $data;	
			}
			echo json_encode($this->response);
			return;
		}
		
		public function returnError($code, $desc) {
			$this->returnData(null, $code, $desc);
			exit(0);
		}
		
    	public function returnError2($data, $code, $desc) {
        	$this->returnData($data, $code, $desc);
            exit(0);
        }
		
		public function sendPersonMsg($uid, $type='sys',$title, $content) {
			$prizeStr = $this->data_redis->get("pmess:{$uid}");

			$msgArr = array();
			$bln = 0;
			if($prizeStr){
				$prizeArr = json_decode($prizeStr);
// 				echo "pmess:{$uid}";
// 				var_dump($prizeArr);
				$inc = 0;
				foreach ($prizeArr as $key){
					$msg['ty'] = $key->ty;
					$msg['ti'] = $key->ti;					
					$msg['d'] = $key->d;
					$msg['ir'] = $key->ir;
					if(($key->ty=="fb" || $key->ty=="pm") && $key->ti==$title){
						$msg['c'] = $content;
						$bln = 1;
					}else {
						$msg['c'] = $key->c;
					}
					$inc++;
					if($inc<10 || ($inc==10 && $bln==1)){
						$msgArr[] = $msg;
					}else{
						break;
					}
				}
			}
			if($bln==0){
				$msg['ty'] = $type;
				$msg['ti'] = $title;
				$msg['c'] = $content;
				$msg['d'] = time();
				$msg['ir'] = 0;
				array_unshift($msgArr,$msg);
			}	
			$enMsg = json_encode($msgArr);
			$this->data_redis->set("pmess:{$uid}",$enMsg);
		}
		
		private function sendFlow($flow) {
			$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
			$msg = Config::$log_agent['pass'] . json_encode($flow);
			$len = strlen($msg);
			socket_sendto($sock, $msg, $len, 0, Config::$log_agent['host'], Config::$log_agent['port']);
			socket_close($sock);
		}
		
		public function initPlayerExt($uid) {
			// insert DB
			$player_ext = array();
			$player_ext['uid'] = $uid;
			$player_ext['telCharge'] = 0;
			$player_ext['mob'] = 0;
			$player_ext['updatedate'] = date('Y-m-d H:i:s');
			$this->mysql->insert("playerext", $player_ext);			

			// insert cache
/* 			$player_ext['actWinMonTot'] = 0;
			$player_ext['actWinMonDay'] = 0; */
			$player_ext['lastLotteryDate'] = 0;
			$player_ext['lastPrizeDate'] = 0;
			$player_ext['lastDayTaskDate'] = 0;
			$player_ext['currLotteryNum'] = 0;
			$player_ext['hasRecharge'] = 0;
			$ret = $this->data_redis->hMset("hpe:{$uid}", $player_ext);
			if (!$ret) {
				$this->e("redis hMset initPlayerExt error.");
				$this->returnError(3, "redis hMset initPlayerExt error.");
			}
			return $player_ext;
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
		
		public function get_pay_order($sdk, $rmb) {
			$order_id = "";		
			if (strcmp ( $sdk, "02" ) == 0) {
				// 联通 24 位
				$order_id = $this->build_order ();
			} else {
				// 电信 和其他支付方式 16位
				$order_id = $this->build_order_ct ();
			}
// 			$this->i("sdk:".$sdk.",rmb:".$rmb.",ord:".$order_id);
			return $order_id;
		}
		// 16位数的订单号--电信
		public function build_order_ct() {
			$id = rand ( 1, 123456 );
			$pre = sprintf ( '%06d', $id );
			$order = time () . $pre;
			return $order;
		}
		// 24位数的订单号 - 联通
		public function build_order() {
			$id = rand ( 1, 1234567890 );
			$pre = sprintf ( '%014d', $id );
			$order = time () . $pre;
		
			return $order;
		}
		// http的get方式请求，返回请求后的内容
		public function https_get($url) {
			$curl = curl_init();
			curl_setopt($curl, CURLOPT_URL, $url);
			curl_setopt($curl, CURLOPT_HEADER, FALSE);
			curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($curl, CURLOPT_TIMEOUT, 30);//设置cURL允许执行的最长秒数
// 			curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);//这个是重点。
// 			curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
			$data = curl_exec($curl);
			curl_close($curl);
			return $data;
		}
		// http的get方式请求，返回请求后的内容
		public function https_post($url,$params) {
			$curl = curl_init();
			curl_setopt($curl, CURLOPT_URL, $url);
			curl_setopt($curl, CURLOPT_HEADER, 1);
			curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);//这个是重点。
						curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
			curl_setopt($curl, CURLOPT_POST, 1);    // post 提交方式
			curl_setopt($curl, CURLOPT_POSTFIELDS, $params);
			$data = curl_exec($curl);
			$this->i('dd:'.$data);
			return $data;
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
		
			$sdk = '';
			$rmb = '';
			// 返回信息
			$ret_info = array ();
			$apptype = 1;
			// 获取用户的package、channel
			$sql = "select apptype from trap_apptype where package='{$pkg}' and channel='{$channel}'";
			$row = $this->mysql->find ( $sql );
			if (count ( $row ) > 0) {
				$apptype = ( int ) $row [0] ['apptype'];
			} else {
				$apptype = 1;
			}
		
			// 根据sdk rmb 查找 计费点信息，判断有效性
			$sql = "select * from trap_info where isopen=1 and pos='{$pos}' and trap='{$trap}' and apptype='{$apptype}'";
			$row = $this->mysql->find ( $sql );
			$info = array ();
			foreach ( $row as $r ) {
					
				$info ['rmb'] = ( int ) $r ['rmb'];
				$info ['money'] = ( int ) $r ['money'];
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
		
			// 	$this->i ( "check_trap_special: uid={$uid} ; now={$nowtime} ; start={$start} ; end={$end}" );
		
			return $ret;
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
		
		// mysql 192.168.0.59 
    	public function initMysqlSlave() {
			$this->mysqlSlave = new Mysql();
			$ret = $this->mysqlSlave->connect(Config::$mysql_slave_config);
			if (!$ret) {
				$this->returnError(3, "db connect error.");
			}
		}		
		public  function deinitMysqlSlave() {
			$this->mysqlSlave->close();
		}
		// end 
		// 检查版本更新 、屏蔽模块
		public function check_app_info($pkg, $cpid, $curver) {			
			$ver_last = 0;
			$verinfo = array();
			$resArr = array();
			$verinfo["url"] = "";
			$verinfo["award"] = "";
			$verinfo["info"] = "";
			
			$prizeStr = $this->cache_redis->get("sapps");
			$prizeArr = json_decode($prizeStr);
			if (!empty($prizeArr) && sizeof($prizeArr)>0) {
				foreach ($prizeArr as $g) {
					if($g->package==$pkg){
// 						var_dump($g);
						$ver_last = $g->ver_last;
						$verinfo["info"] = $g->memo;
						$verinfo["award"] = $g->award;
					}
				}
			}
// 			echo $cpid;
			/*
			//更新文件的url
			$url = Game::$url_update_app.$ver_last."/".$cpid.".".$ver_last.".apk";			
			$this->i ( "url={$url} ; ver_last={$ver_last} ; curver={$curver} " );						
			//判断是否有更新文件的存在			
			if ($ver_last > 0 && $curver > 0 && $curver < $ver_last) {
				//有新版本，判断是否存在新版本的文件			
				//$url = "http://203.86.3.244:9090/".$ver_last."/".$cpid.".".$ver_last.".apk";
				$array = get_headers($url,1);
				if(preg_match('/200/',$array[0])){
					$verinfo["url"] = $url;
				}
				else {
					//文件不存在，检查是否有替换渠道版本更新
					$row2 = $this->mysql->select("channel_infos", "*", array('channel_id' => $cpid));
					$cpid_upd = "";
					foreach ($row2 as $ro) {
						$cpid_upd = $ro['channel_update'];		 					
					}
					if (isset($cpid_upd) && strlen($cpid_upd) > 0) {
						$url = Game::$url_update_app.$ver_last."/".$cpid_upd.".".$ver_last.".apk";
						$arr2 = get_headers($url,1);
						if(preg_match('/200/',$arr2[0])){
							$verinfo["url"] = $url;
						}
					}
				}
				
			}
			*/
// 			$this->i('$pkg:'.$pkg.'$cpid:'.$cpid.'$curver:'.$curver.'$ver_last:'.$ver_last.'url:'.$url);
			$prizeStr = $this->cache_redis->get("sappmodules");
			$prizeArr = json_decode($prizeStr);
			if (!empty($prizeArr) && sizeof($prizeArr)>0) {
				foreach ($prizeArr as $g) {
					if($g->closed==1 && $g->type_value==$pkg && $g->type_id==1){
						$r['id']=$g->module_id;
						$temp_app_sdk[] = $r;
					}
					if($g->closed==1 && $g->type_value==$cpid && $g->type_id==0){
						$r['id']=$g->module_id;
						$temp_cp_sdk[] = $r;
					}
				}
				if(!empty($temp_app_sdk)){
					$resArr["closeModel"] = $temp_app_sdk;
				}else if (!empty($temp_cp_sdk)) {
					$resArr["closeModel"] = $temp_cp_sdk;
				}
			}
			if(strlen($verinfo['url'])>0){
				$resArr['update'] = $verinfo;
			}
			return $resArr;
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
		public function d($msg) {
			Config::$logger->debug($this->tag, $msg);
		}
		public function i($msg) {
			Config::$logger->info($this->tag, $msg);
		}
		public function w($msg) {
			Config::$logger->warn($this->tag, $msg);
		}
		public function e($msg) {
			Config::$logger->error($this->tag, $msg);
		}
		public function f($msg) {
			Config::$logger->fatal($this->tag, $msg);
		}
    }
?>