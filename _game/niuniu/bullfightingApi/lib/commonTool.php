<?php
class CommonTool {
	
	
	/**
	 * 验证手机号码
	 * @param $test 待验证的手机号码
	 * @return unknown
	 */
	public static function preg_mobile($test) {
		/**
		 * 匹配手机号码
		 * 规则：
		 * 手机号码基本格式：
		 * 前面三位为：
		 * 移动：134-139 147 150-152 157-159 182 187 188
		 * 联通：130-132 155-156 185 186
		 * 电信：133 153 180 189
		 * 后面八位为：
		 * 0-9位的数字
		 */
		if (!isset($test)) {
			return 0;
		}
		
		// $rule = "/^((13[0-9])|147|(15[0-35-9])|180|182|(18[5-9]))[0-9]{8}$/A";
		$rule = "/^((13[0-9])|147|(15[0-9])|(18[0-9]))[0-9]{8}$/A";
		
		return preg_match ( $rule, $test);
		
	}
	
	/**
	 * 获得SDK
	 *
	 * @param unknown $cache_redis        	
	 * @param unknown $data_redis        	
	 * @param unknown $uid        	
	 */
	public static function getSdk($cache_redis, $uid, $imsi, $appid, $cpid, $sdks) {
		$sdk = "01";
		$curver = 0;
		if (isset ( $appid )) {
			$arrTmp = explode ( ".", $appid );
			if (count ( $arrTmp ) > 0) {
				$curver = ( int ) $arrTmp [count ( $arrTmp ) - 1];
			}
		}
		if ($curver > 10) {
			$sdk = "05";
		}
		// 运营商标记, 默认为移动
		$op = "cm";
		if (isset ( $imsi )) {
			$si = substr ( $imsi, 0, 5 );
			// 1:中国移动 46000 46002 46007
			// 2:中国联通 46001 46010
			// 3:中国电信 46003
			if (strcmp ( $si, "46000" ) == 0 || strcmp ( $si, "46002" ) == 0 || strcmp ( $si, "46007" ) == 0) {
				$sdk = "01";
				$op = "cm";
			} else if (strcmp ( $si, "46001" ) == 0 || strcmp ( $si, "46010" ) == 0) {
				$sdk = "03";
				$op = "cu";
				if (isset ( $sdks )) {
					$pos = strpos ( $sdks, "02" );
					if ($pos === false) {
						$sdk = "03";
					} else {
						$sdk = "02";
					}
				}
			} else if (strcmp ( $si, "46003" ) == 0) {
				$sdk = "03";
				if (isset ( $sdks )) {
					$pos = strpos ( $sdks, "04" );
					if ($pos === false) {
						$sdk = "03";
					} else {
						$sdk = "04";
					}
				}
				$op = "ct";
			} else {
				$sdk = "03";
				if ($curver > 10) {
					$sdk = "05";
				}
				$op = "cm";
			}
		} else {
			// 无imsi信息
			if (isset ( $sdks )) {
				// sdk='10' 代表联运SDK
				$pos = strpos ( $sdks, "10" );
				if ($pos === false) {
				} else {
					$sdk = "10";
				}
			}
		}
		// 判断payrule中是否有指定
		$prizeStr = $cache_redis->get ( "spayrule" );
		$prizeArr = json_decode ( $prizeStr );
		$temp_app_sdk = "";
		$temp_cp_sdk = "";
		if (! empty ( $prizeArr ) && sizeof ( $prizeArr ) > 0) {
			foreach ( $prizeArr as $g ) {
				if ($g->op == $op && $g->type_value == $appid && $g->type_id == 1) {
					$temp_app_sdk = $g->sdk;
				}
				if ($g->op == $op && $g->type_value == $cpid && $g->type_id == 0) {
					$temp_cp_sdk = $g->sdk;
				}
			}
			if ($temp_app_sdk != "") {
				$sdk = $temp_app_sdk;
			} else if ($temp_cp_sdk != "") {
				$sdk = $temp_cp_sdk;
			}
		}
		// 判断客户端的支付SDK代号中，是否包含找到的代码。
		if (isset ( $sdks )) {
			$arr = explode ( '.', $sdks );
			$pos = strpos ( $sdks, $sdk );
			if ($pos === false) {
				$sdk = $arr [0];
			}
		}
		/*
		 * 移动MM支付SDK [01] 联通支付SDK [02] 第三方短信支付SDK [03] 电信SDK [04] 支付宝SDK [05] 联运SDK [10]
		 */
		return $sdk;
	}
	
	/**
	 * 是否有未读信息
	 *
	 * @param unknown $cache_redis        	
	 * @param unknown $data_redis        	
	 * @param unknown $uid        	
	 * @return number
	 */
	public static function hasNoReadMes($cache_redis, $data_redis, $uid) {
		$noRead = 0;
		$prizeStr = $data_redis->get ( "pmess:{$uid}" );
		if ($prizeStr) {
			$prizeArr = json_decode ( $prizeStr );
			foreach ( $prizeArr as $key ) {
				if ($key->ir == 0) {
					$noReadP = 1;
					break;
				}
			}
		}		
		return $noRead;
	}
	/**
	 * 比较两个时间是否在同一天
	 *
	 * @param unknown $tA        	
	 * @param unknown $tB        	
	 * @return boolean
	 */
	public static function isSameDay($tA, $tB) {
		// echo date('Y-m-d', 1382013800);
		if ($tA == 0 || $tB == 0) {
			return false;
		}
		if (date ( 'Y-m-d', $tA ) != date ( 'Y-m-d', $tB )) { // 如果不在同一天
			return false;
		}
		return true;
	}
	/**
	 * 比较两个时间是否在同一月
	 *
	 * @param unknown $tA
	 * @param unknown $tB
	 * @return boolean
	 */
	public static function isSameMonth($tA, $tB) {
		// echo date('Y-m-d', 1382013800);
		if ($tA == 0 || $tB == 0) {
			return false;
		}
		if (date ( 'Y-m', $tA ) != date ( 'Y-m', $tB )) { // 如果不在同一月
			return false;
		}
		return true;
	}
	/**
	 * 比较两个时间相差几天
	 *
	 * @param unknown $tA        	
	 * @param unknown $tB        	
	 */
	public static function getDiffBetweenTwoDate($tA, $tB) {
		/*
		 * $startdate = strtotime(date('Y-m-d', $tA)); $enddate = strtotime(date('Y-m-d', $tB)); $days = abs(round(($enddate-$startdate)/3600/24));
		 */
		$days = abs ( round ( ($tB - $tA) / 3600 / 24 ) );
		return $days;
	}
	/**
	 * 礼物名称
	 * @param unknown $gid
	 * @return string
	 */
	public static function getGiftName($gid){
		if ($gid==2){
			return "砖头";
		}elseif ($gid==3){
			return "玫瑰";
		}elseif ($gid==4){
			return "蛋糕";
		}elseif ($gid==5){
			return "别墅";
		}else{
			return "香吻";
		}
	}
	
	/**
	 * 是否测试账号
	 *
	 * @param unknown $uid        	
	 */
	public static function isTestUser($uid) {
		$userArr = explode ( ",", Config::$testUser );
		foreach ( $userArr as $key ) {
			$tUid = ( int ) $key;
			if ($tUid == $uid) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 获得可领奖任务数量
	 * @param unknown $rows
	 * @param unknown $pt
	 * @param unknown $pInfo
	 * @return number
	 */
	public static function rewardNum($rows,$pt,$pInfo){
		$inc = 0;
		foreach ($rows as $r) {
			if($r['i']==0){
				continue;
			}
			$t = CommonTool::filter($r,$pt,$pInfo);
			if($t['g'] == 1){
// 				echo $t['i'].'<br/>';
				$inc++;
			}
		}
		return $inc;
	}
	
	public static function getShowInd($soc,$uid){
		$isGet = $soc->data_redis->hGet("hu:{$uid}",'total_board');
		if(!$isGet || $isGet<=0){
			return 3;
		}
		if(CommonTool::isActivityTime(Game::$noticeSwitch_activity_time) || Game::$notice_effect==1){
			return 2;
		}
		$num = $soc->data_redis->hGet ( "uSignin:{$uid}", "today_login_times");
		$signRewardNum = CommonTool::getSigninRewardNum($soc, $uid);
		if($num<=2 && $signRewardNum>0){	// 显示签到
			return 1;		
		}elseif ($num<=3){					// 显示公告
			return 2;
		}
		return 0;							// 都不显示
	}
	
	public static function isActivityTime($t){
		if($t==0){
			return false;
		}
		$timeArr = explode("~", $t);
		if(sizeof($timeArr)!=2){
			return false;
		}
		$now = time();
		if(strtotime($timeArr[0])<$now && strtotime($timeArr[1])>=$now){
			return true;
		}
		return false;
	}
	
	public static function getPSigninInfo($soc,$uid,$mDay,$now){
		$pSignin = $soc->data_redis->hGetAll("uSignin:{$uid}");
		$needUp = false;
		if(!$pSignin || !isset($pSignin['last_sign_time'])){
			// 			echo "init ps<br/>";
			$pSignin = array(
					'last_sign_time'=>0,
					'last_vip_time'=>0,
					'tot_sign'=>0,
					'has_sign'=>''
			);
			$needUp = true;
		}		
// 		var_dump($pSignin);
		$isSameMonth = CommonTool::isSameMonth ( $pSignin ['last_sign_time'],$now);
		if(!$isSameMonth){
			$pSignin['tot_sign'] = 0;
			$pSignin['has_sign'] = '';
			$needUp = true;
		}
		CommonTool::upHasSign($pSignin,$mDay,$needUp);
		if($needUp){
			$soc->data_redis->hMset("uSignin:{$uid}",$pSignin);
		}
		return $pSignin;
	}
	
	public static function getSigninRewardNum($soc,$uid){
		$now = time();
		$dateArr = getdate();
		$mDay = $dateArr['mday'];
		$pSignin = CommonTool::getPSigninInfo($soc,$uid,$mDay,$now);
		$pUinfo = $soc->data_redis->hMget ( "hu:{$uid}", array ("vipLevel","login_days"));
		$vlevel = (isset($pUinfo ['vipLevel']) && (int)$pUinfo['vipLevel']>0) ? (int)$pUinfo['vipLevel']: 0;
		$login_days = (int)$pUinfo ['login_days'];
		// 		echo 'isVIp:'.$isVip.'<br/>';
		$needUp = false;
		
		$data_cont = $soc->cache_redis->get ( "ssignin:cont" );
		$data_tot = $soc->cache_redis->get ( "ssignin:tot" );
		$data_vip = $soc->cache_redis->get ( "ssignin:vip" );
		$arr_cont = json_decode($data_cont);
		$arr_tot = json_decode($data_tot);
		$arr_vip = json_decode($data_vip);
		
		/*
		 tot_sign:本月累计签到次数
		last_sign_time:最后一次签到时间
		last_vip_time:最后一次领取VIP奖励的时间
		has_sign:本月已签到列表
		*/
		$diffSignDay = CommonTool::getDiffBetweenTwoDate ( $pSignin ['last_sign_time'], $now );
		$isSameVipDay = CommonTool::isSameDay ( $pSignin ['last_vip_time'], $now );
		
		$tot_item = CommonTool::getTot_item($pSignin,$arr_tot,$diffSignDay,$needUp);
		$cont_item = CommonTool::getCont_item($pSignin,$arr_cont,$diffSignDay,$login_days,$needUp);
		$vip_item = CommonTool::getVip_item($pSignin,$arr_vip,$vlevel,$isSameVipDay,$soc);
		if($needUp){
			$soc->data_redis->hMset("uSignin:{$uid}",$pSignin);
		}
		$inc = 0;
		foreach ($tot_item as $item){
			if($item->isget == 1){
				$inc += 1;
			}
		}
		foreach ($cont_item as $item){
			if($item->isget == 1){
				$inc += 1;
			}
		}
		foreach ($vip_item as $item){
			if($item->isget == 1){
				$inc += 1;
			}
		}
		return $inc;
	}

	public static function getVip_item($pSignin,$arr_vip,$vlevel,$isSameVipDay,$soc){
		$vipInfo = $soc->getVipInfo($vlevel);
		$ext_award = 0;
		if($vipInfo!=null && $vipInfo->ext_award>0){
			$ext_award = $vipInfo->ext_award;
		}
		$vipIsGet = 0;
		if(!$isSameVipDay){
			if($ext_award>0){
				$vipIsGet = 1;
			}
		}else {
			$vipIsGet = 2;
		}
		foreach ($arr_vip as $item){
			$item->isget = $vipIsGet;
			$item->vlevel = $vlevel;
			$item->award[0]->at = 0;
			$item->award[0]->an = $ext_award;
		}
		return $arr_vip;
	}
	
	public static function getCont_item(&$pSignin,$arr_cont,$diffSignDay,$login_days,&$needUp){
		$dev_days = $login_days%Game::$signin_continue_days_limit;
		$dev_days = $dev_days==0?Game::$signin_continue_days_limit:$dev_days;
		$rem_days = $login_days/Game::$signin_continue_days_limit;
		foreach ($arr_cont as $item){
			$key = 'c'.$item->amount;
			if(isset($pSignin[$key]) && $pSignin[$key]==2){
				if($dev_days>=$item->amount){
					if($rem_days>0 && $dev_days==1 && $diffSignDay>0){
						// 						echo "----<br/>";
						$item->isget = 1;
						$pSignin[$key]= 0;
						$needUp = true;
					}else{
						// 						echo "0000<br/>";
						$item->isget = 2;
					}
				}else{
					// 					echo "1111<br/>";
					$item->isget = 0;
					$pSignin[$key]= 0;
					$needUp = true;
				}
			}else{
				$diff = $dev_days-$item->amount;
				if($diff>=0 && $diff<=1){
					// 					echo "2222<br/>";
					$item->isget = 1;
				}elseif ($diff>1){
					// 					echo "3333<br/>";
					$item->isget = 2;
				}else{
					// 					echo "4444<br/>";
					$item->isget = 0;
				}
			}
		}
		return $arr_cont;
	}
	
	public static function getTot_item(&$pSignin,$arr_tot,$diffSignDay,&$needUp){
		$tot_sign = $pSignin['tot_sign']?$pSignin['tot_sign']:0;
		foreach ($arr_tot as $item){
			$key = 't'.$item->amount;
			if(isset($pSignin[$key]) && $pSignin[$key]==2){
				$item->isget = 2;
			}else{
				if($tot_sign>=$item->amount){
					$item->isget = 1;
				}else{
					$item->isget = 0;
				}
			}
		}
		if($tot_sign==0){
			$pSignin['tot_sign'] = 0;
			$needUp = true;
			foreach ($arr_tot as $item){
				$key = 't'.$item->amount;
				$item->isget = 0;
				$pSignin[$key]= 0;
			}
		}
		return $arr_tot;
	}
	
	public static function upHasSign(&$pSignin,$mDay,&$needUp){	
		$currLen = strlen($pSignin['has_sign']);
		if($currLen+1<$mDay){
			$diff = $mDay-$currLen-1;
			for ($i=0;$i<$diff;$i++){
				$pSignin['has_sign'] .= "0";
				$needUp = true;
			}
		}
	}
	
	public static function getTaskRewardNum($soc,$uid){
		$trn = array(0,0);
		$row = $soc->cache_redis->lRange("ltaska:ids", 0, -1);
		$res = CommonTool::dataArr($soc->cache_redis,$row,"htaska:");
		$pdtask = $soc->data_redis->hGetAll("hubta:{$uid}");
		$pInfo = CommonTool::getFormatPinfo($soc->data_redis,$uid);
		$res = CommonTool::pBindTask($res,$pdtask,$pInfo);
		$trn[0] = CommonTool::rewardNum($res,$pdtask,$pInfo);	// 可领奖条数		
		
		$row = $soc->cache_redis->lRange("ltaskd3:ids", 0, -1);
		$res = CommonTool::dataArr($soc->cache_redis,$row,"htaskd:");
		$now = time();
		$ldd = $soc->data_redis->hGetAll("hu:{$uid}");
		$isSameDay = (isset($ldd['lastDayTaskDate']) && CommonTool::isSameDay($ldd['lastDayTaskDate'], $now));
		if(!$isSameDay){
			$soc->data_redis->del("hubtd:{$uid}");
			$soc->data_redis->hSet("hu:{$uid}","lastDayTaskDate",$now);
		}
		$pdtask = $soc->data_redis->hGetAll("hubtd:{$uid}");
		$pInfo = CommonTool::getFormatPinfo($soc->data_redis,$uid);
		$res = CommonTool::pBindTask($res,$pdtask,$pInfo);
		$trn[1] = CommonTool::rewardNum($res,$pdtask,$pInfo);	// 可领奖条数

		return $trn;
	}
	
	/**
	 * 生成任务列表，已领奖的下沉到最后
	 * @param unknown $rows
	 * @param unknown $pt
	 * @param unknown $pInfo
	 * @return multitype:Ambigous <number, unknown>
	 */
	public static function pBindTask($rows,$pt,$pInfo){
		$aw = array();
		foreach ($rows as $r) {
			if($r['i']==0){
				continue;
			}
			if(CommonTool::isContain($r['f'],$aw)){
				continue;
			}
			if($r["f"]==206 && ($pInfo['iv']==0 || $pInfo['ver']==$pInfo['iv'] || $pInfo['ver']>$r['n'])){	// 版本升级,不对新用户显示
				continue;				
			}
			$t = CommonTool::filter($r,$pt,$pInfo);
			$aw[$t['f']] = $t;				
		}
		$at = array();	
		foreach ($aw as $r) {
			$at[] = $r;
		}					
		return $at;
	} 
	/**
	 * 是否已存在此类任务
	 * @param unknown $ctype
	 * @param unknown $aw
	 * @return boolean
	 */
	public static function isContain($ctype,$aw){
		foreach ($aw as $r) {
			if($r['f']==$ctype && $r['g']<=1){
				return true;
			}
		}
		return false;
	}
	/**
	 * 生成任务当前状态
	 * @param unknown $r
	 * @param unknown $pt
	 * @param unknown $pInfo
	 * @return Ambigous <number, unknown>
	 */
	public static function filter($r,$pt,$pInfo){
		$id = $r['i'];
		$t['i'] = $id;
		$t["n"] = $r["n"];			
		$t["a"] = $r["a"];
		$t["f"] = $r["f"];
		$t["m"] = $r["m"];		
		$t["t"] = $r["t"];		 
		$t["d"] = $r["d"];
		$t["l"] = $r["l"];
		$t["ln"] = $r["ln"];
		// 当前完成次数
		if(isset($pt['t'.$id])){
			$t['c'] = (int)$pt['t'.$id];
		}else{
			$t['c'] = 0;
		}
		// 任务状态:0,未完成；1，已完成可领奖；2，已完成已领奖
		if(isset($pt['g'.$id])){
			$t['g'] = (int)$pt['g'.$id];
		}else{
			$t['g'] = 0;
		}				
		if($t['g']==2){
			$t['c'] = $r['n'];
		}else{			
			// 如果是升级胜利购物则读状态标记进行处理
			if($r["f"]==201){		// 胜利局数
				$t['c'] = $pInfo['total_win'];
			}elseif($r["f"]==202){	// 购物金额
				$t['c'] = $pInfo['rmb'];
			}elseif($r["f"]==203){	// 玩家等级
				$t['c'] = $pInfo['level'];
			}elseif($r["f"]==206){	// 版本升级
				if($pInfo['iv']==0 || $pInfo['ver']==$pInfo['iv'] || $pInfo['ver']>$r['n']){
					$t['c'] = 0;
				}else{
					$t['c'] = $pInfo['ver'];
				}
			}elseif($r["f"]==106){	// t3玩牌
				$t['c'] = $pInfo['t3'];
			}elseif($r["f"]==107){	// t4玩牌
				$t['c'] = $pInfo['t4'];
			}elseif($r["f"]==108){	// t5玩牌
				$t['c'] = $pInfo['t5'];
			}
			// 如果当前次数超过完成条件，则当前次数置为条件最大值，领奖标记置为1
			if($t['c']>=$r['n']){
				$t['g'] = 1;
				$t['c'] = $r['n'];
			}
			if ($r['f']>=106 && $r['f']<=108){
				if ($r['ln']>=$r['l']){
					$t['g'] = 0;
				}
			}			
		}
		return $t;
	}
	
	/**
	 * 获得玩家任务相关信息
	 * @return number
	 */
	public static function getFormatPinfo($data_redis,$uid){
		$temp = $data_redis->hMget("hu:{$uid}",array("rmb","total_win","level","ver","initVer"));
		$ucTemp = $data_redis->hMget("uc:{$uid}",array("t3","t4","t5"));
		$t["rmb"] = isset($temp['rmb'])?(int)$temp["rmb"]:0;			
		$t["total_win"] = isset($temp['total_win'])?(int)$temp["total_win"]:0;		
		$t["level"] = isset($temp['level'])?(int)$temp["level"]:0;
		$t["ver"] = isset($temp['ver'])?(int)$temp["ver"]:0;
		$t["iv"] = isset($temp['initVer'])?(int)$temp["initVer"]:0;
		$t["t3"] = isset($ucTemp['t3'])?(int)$ucTemp["t3"]:0;
		$t["t4"] = isset($ucTemp['t4'])?(int)$ucTemp["t4"]:0;
		$t["t5"] = isset($ucTemp['t5'])?(int)$ucTemp["t5"]:0;
		return $t;
	}
	/**
	 * 返回任务基础数据
	 * @param unknown $keys
	 * @param unknown $pk
	 * @return multitype:unknown
	 */
	public static function dataArr($cache_redis,$keys,$pk){
		$awardes = array();
		$currlimit = $cache_redis->hGetAll('htasklimit');
		foreach ($keys as $key) {
			$award = $cache_redis->hMGet("{$pk}{$key}", array("id","finishtype",
					"finishnum", "awardtype","awardmount","title","desc","limitnum"));
			$t["i"] = (int)$award["id"];			// ID
			$t["n"] = (int)$award["finishnum"];		// 完成数量
			$t["f"] = (int)$award["finishtype"];	// 完成类型
			$t["a"] = (int)$award["awardtype"];		// 奖励类型
			$t["m"] = (int)$award["awardmount"];	// 奖励数额
			$t["t"] = $award["title"];				// 标题
			$t["l"] = $award["limitnum"];			// 获奖人数限制
			
			if(isset($currlimit[$t["i"]])){
				$t["ln"] = (int)$currlimit[$t["i"]];
			}else{
				$t["ln"] = 0;				
			}
			if ($t['f']>=106 && $t['f']<=108){
				$t["d"] = $award["desc"].($t["l"]-$t["ln"]);				// 描述
			}else {
				$t["d"] = $award["desc"];				// 描述
			}
			$awardes[] = $t;
		}			
		return $awardes;
	}
	/**
	 * 获得随机字符
	 * @param unknown $keys
	 * @param unknown $pk
	 * @return multitype:unknown
	 */
	public static function getRandomKeys($length, $bol = true) {
		$output = '';
		if ($bol) {
			for($a = 0; $a < $length; $a ++) {
				$output .= chr ( mt_rand ( 97, 122 ) ); // 小写字母
			}
		} else {
			for($a = 0; $a < $length; $a ++) {
				$output .= chr ( mt_rand ( 48, 57 ) ); // 数字
			}
		}
		return $output;
	}
	/**
	 * 
	 * @param unknown $url
	 * @param unknown $data
	 * @param string $optional_headers
	 * @throws Exception
	 * @return unknown
	 */
	public static function do_post_request($url, $data, $optional_headers = null)
	{		
		$params = array('http' => array(
				'method' => 'POST',
// 				'content' => @http_build_query ( $data, '', '&' ) 
				'content' => $data
		));
		if ($optional_headers !== null) {
			$params['http']['header'] = $optional_headers;
		}
		$ctx = stream_context_create($params);
		$fp = @fopen($url, 'rb', false, $ctx);
		if (!$fp) {
			throw new Exception("Problem with $url");
		}
		$response = @stream_get_contents($fp);
		if ($response === false) {
			throw new Exception("Problem reading data from $url");
		}
		return $response;
	}
	
	public static function curl_post_request($url, $data){
		/* foreach ( $data as $k => $v )
		{
			$o .= " $k = " . urlencode ( $v ) . " & " ;
		}
		$post_data = substr ( $o , 0 ,- 1 ) ; */
		$ch = curl_init () ;
		curl_setopt ( $ch , CURLOPT_POST , 1 ) ;
		curl_setopt ( $ch , CURLOPT_HEADER , 0 ) ;
		curl_setopt ( $ch , CURLOPT_URL , $url ) ;
		//为了支持cookie
		curl_setopt ( $ch , CURLOPT_COOKIEJAR , ' cookie.txt ' ) ;
		curl_setopt ( $ch , CURLOPT_POSTFIELDS , $data ) ;
		$result = curl_exec ( $ch ) ;
	}
	// 显示赛讯按钮
	public static function isFightDate(){
		$dateArr = explode("~", Game::$fight_game_show_day);
		if(sizeof($dateArr)!=2){
			return 0;
		}
		$now = time();
		$et = strtotime($dateArr[1])+86400;
		if(strtotime($dateArr[0])<=$now && $et>$now){
			return 1;
		}
		return 0;
	}
	
	public static function isFightTime(){
		if(CommonTool::isFightDate()==0){
			return 0;
		}
		$dateArr = explode(",", Game::$fight_game_show_time);
		if(sizeof($dateArr)<=0){
			return 0;
		}
		$now = time();
		foreach ( $dateArr as $g ){
			$timeArr = explode("~", $g);
			if(strtotime($timeArr[0])<=$now && strtotime($timeArr[1])>$now){
				return 1;
			}
		}
		return 0;
	}
	
	/**
	 * 获得运营商
	 * 1=移动
	 * 2=联通
	 * 3=电信
	 */
	public static function getOP($imsi) {		
		// 运营商标记, 默认为移动
		$op = 1;
		if (isset ( $imsi )) {
			$si = substr ( $imsi, 0, 5 );
			// 1:中国移动 46000 46002 46007
			// 2:中国联通 46001 46010
			// 3:中国电信 46003
			if (strcmp ( $si, "46000" ) == 0 || strcmp ( $si, "46002" ) == 0 || strcmp ( $si, "46007" ) == 0) {				
				$op = 1;
			} else if (strcmp ( $si, "46001" ) == 0 || strcmp ( $si, "46010" ) == 0) {				
				$op = 2;				
			} else if (strcmp ( $si, "46003" ) == 0) {				
				$op = 3;
			} else {				
				$op = 1;
			}
		}
		return $op;
	}

	public static function getResearch($soc, $uid) {
		if(!CommonTool::isActivityTime(Game::$research_time)){
			return "-1";
		}
		$hu = $soc->data_redis->hMget("hu:{$uid}",array('login_days','total_board','researchId'));
		if($hu['login_days']<Game::$research_need_loginDay ||
			$hu['total_board']<Game::$research_need_broad ){
			return "0";
		}
		if($hu['researchId']>=Game::$research_curr_id){
			return "1";
		}
		return Game::$research_url;
	}
}
?>