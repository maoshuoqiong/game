<?php
class CommonTool{
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
	 * @param unknown $cache_redis
	 * @param unknown $data_redis
	 * @param unknown $uid
	 */	
	public static function getSdk($cache_redis,$uid,$imsi,$appid,$cpid,$sdks){
		$sdk = "01";
		$curver = 0;
		if (isset($appid)) {
			$arrTmp = explode(".", $appid);
			if (count($arrTmp) > 0) {
				$curver = (int) $arrTmp[count($arrTmp)-1];
			}
		}
		if ($curver>10) {
			$sdk = "05";
		}
		//运营商标记, 默认为移动
		$op = "cm";
		if (isset($imsi)) {
			$si = substr($imsi, 0, 5);
			//1:中国移动 46000 46002 46007
			//2:中国联通 46001 46010
			//3:中国电信 46003
			if (strcmp($si,"46000") == 0 || strcmp($si,"46002") == 0 || strcmp($si,"46007") == 0) {
				$sdk = "01";
				$op = "cm";
			}
			else if (strcmp($si,"46001") == 0 || strcmp($si,"46010") == 0) {
				$sdk = "03";
				$op = "cu";
				if (isset($sdks)) {
					$pos  =  strpos ( $sdks ,  "02" );
					if ($pos === false) {
						$sdk = "03";
					}
					else {
						$sdk = "02";
					}
				}
			}
			else if (strcmp($si,"46003") == 0) {
				$sdk = "03";
				if (isset($sdks)) {
					$pos  =  strpos ( $sdks ,  "04" );
					if ($pos === false) {
						$sdk = "03";
					}
					else {
						$sdk = "04";
					}
				}
				$op = "ct";
			}
			else {
				$sdk = "03";
				if ($curver>10) {
					$sdk = "05";
				}
				$op = "cm";
			}
		}
		else {
			//无imsi信息
			if (isset($sdks)) {
				//sdk='10' 代表联运SDK
				$pos  =  strpos ( $sdks ,  "10" );
				if ($pos === false) {
				}
				else {
					$sdk = "10";
				}
			}
		}
		//判断payrule中是否有指定
		$prizeStr = $cache_redis->get("spayrule");
		$prizeArr = json_decode($prizeStr);
		$temp_app_sdk = "";
		$temp_cp_sdk = "";
		if (!empty($prizeArr) && sizeof($prizeArr)>0) {
			foreach ($prizeArr as $g) {
				if($g->op==$op && $g->type_value==$appid && $g->type_id==1){
					$temp_app_sdk = $g->sdk;
				}
				if($g->op==$op && $g->type_value==$cpid && $g->type_id==0){
					$temp_cp_sdk = $g->sdk;
				}
			}
			if($temp_app_sdk!=""){
				$sdk = $temp_app_sdk;
			}else if ($temp_cp_sdk!="") {
				$sdk = $temp_cp_sdk;
			}
		}
		//判断客户端的支付SDK代号中，是否包含找到的代码。
		if (isset($sdks)) {
			$arr = explode('.',$sdks);
			$pos  =  strpos ( $sdks ,  $sdk );
			if ($pos === false) {
				$sdk = $arr[0];
			}
		}
		/*
		 移动MM支付SDK [01]
		联通支付SDK [02]
		第三方短信支付SDK [03]
		电信SDK [04]
		支付宝SDK [05]
		联运SDK [10]
		*/
		return $sdk;
	}
	
	/**
	 * vip剩余天数
	 * @param unknown $data_redis
	 * @param unknown $uid
	 * @return unknown
	 */
	public static function vipDays($data_redis,$uid){
		$vipendt = $data_redis->hGet("hpe:{$uid}", "vipenddate");
		$vip = 0;
		$now = time();
		if($vipendt>$now){
			$vip = ceil(($vipendt-$now)/3600/24);
		}
		return $vip;
	}
	
	/**
	 * 是否有未读信息
	 * @param unknown $cache_redis
	 * @param unknown $data_redis
	 * @param unknown $uid
	 * @return number
	 */
	public static function hasNoReadMes($cache_redis,$data_redis,$uid){
		$prizeStr = $cache_redis->get("smesslist:def");
		$noReadS = 0;
		$noReadP = 0;
		$noRead = 0;
		if($prizeStr){
			$ct = $data_redis->hGet("hu:{$uid}","create_time");
			$prizeArr = json_decode($prizeStr);
			$readStatus = $data_redis->hGetAll("hpmess:{$uid}");
			if(sizeof($readStatus)>0){
				foreach ($prizeArr as $award) {
					if($ct>0 && $award->date<$ct){
						continue;
					}
					if(!array_key_exists("m".$award->mid,$readStatus)){
						$noReadS = 1;
						break;
					}
				}
			}else {
				$noReadS = 1;
			}				
		}
		
		if($noRead == 0){
			$prizeStr = $data_redis->get("pmess:{$uid}");
			if($prizeStr){
				$prizeArr = json_decode($prizeStr);
				foreach ($prizeArr as $key) {
					if($key->ir==0){
						$noReadP = 1;
						break;
					}
				}
			}				
		}
		if($noReadP ==1 && $noReadS==1){
			$noRead = 1;
		}else if ($noReadP ==0 && $noReadS==1) {
			$noRead = 2;
		}else if ($noReadP ==1 && $noReadS==0) {
			$noRead = 3;
		}else {
			$noRead = 0;
		}
		return $noRead;
	}
	/**
	 * 比较两个时间是否在同一天
	 * @param unknown $tA
	 * @param unknown $tB
	 * @return boolean
	 */
	public static function isSameDay($tA,$tB){
//  		echo date('Y-m-d', 1382013800);
		if($tA==0 || $tB==0){
			return false;
		}
		if (date('Y-m-d', $tA) != date('Y-m-d', $tB)) {//如果不在同一天
			return false;
		}
		return true;
	}	
	/**
	 * 比较两个时间相差几天
	 * @param unknown $tA
	 * @param unknown $tB
	 */
	public static function getDiffBetweenTwoDate($tA,$tB){
		/* $startdate = strtotime(date('Y-m-d', $tA));
		$enddate = strtotime(date('Y-m-d', $tB));     
		$days = abs(round(($enddate-$startdate)/3600/24));*/
		$days = abs(round(($tB-$tA)/3600/24));
		return $days;
	}
	/**
	 * 玩家VIP身份
	 * @param unknown $uid
	 * @return int
	 * 		0:普通玩家
	 * 		1:初级VIP
	 * 		2:中级VIP
	 * 		...
	 */
	public static function isVip($soc,$uid){
		$vd = $soc->hGet("hpe:{$uid}", 'vipenddate');
		if($vd && $vd>time()){
			return 1;
		}
		return 0;
	}

	/**
	 * 是否测试账号
	 * @param unknown $uid
	 */
	public static function isTestUser($uid){
		$userArr = explode(",", Config::$testUser);
		foreach ($userArr as $key) {
			$tUid = (int)$key;
			if($tUid==$uid){
				return true;
			}
		}
		return false;
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
		$pUinfo = $soc->data_redis->hMget ( "hu:{$uid}", array ("login_days"));
		$vlevel = CommonTool::isVip($soc->data_redis, $uid);
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
		$ext_award = 0;
		if($vlevel>=0){
			$ext_award = Game::$vip_login_reward;
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
	public static function getShowInd($soc,$uid){
		$num = $soc->data_redis->hGet ( "uSignin:{$uid}", "today_login_times");
		$signRewardNum = CommonTool::getSigninRewardNum($soc, $uid);
		if($num<=2 && $signRewardNum>0){
			//return 1;
		}elseif ($num<=3){
			//return 2;
		}
		return 0;
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
		$ldd = $soc->data_redis->hGetAll("hpe:{$uid}");
		$isSameDay = (isset($ldd['lastDayTaskDate']) && CommonTool::isSameDay($ldd['lastDayTaskDate'], $now));
		if(!$isSameDay){
			$soc->data_redis->del("hubtd:{$uid}");
			$soc->data_redis->hSet("hpe:{$uid}","lastDayTaskDate",$now);
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
		
		if($pt==null){
			$t['c'] = 0;
			$t['g'] = 0;
		}else{
			if(isset($pt['t'.$id])){
				$t['c'] = (int)$pt['t'.$id];
			}else{
				$t['c'] = 0;
			}
			if(isset($pt['g'.$id])){
				$t['g'] = (int)$pt['g'.$id];
			}else{
				$t['g'] = 0;
			}
			if($t['g']==2){
				$t['c'] = $r['n'];
			}else{
				if($r["f"]==113){	// 购物金额
					$t['c'] = $pInfo['rmb'];
				}
				if($t['c']>=$r['n']){
					$t['g'] = 1;
				}
				$t['c'] = $t['c']>=$r['n']?$r['n']:$t['c'];
			}			
		}
		return $t;
	}
	
	/**
	 * 获得玩家任务相关信息
	 * @return number
	 */
	public static function getFormatPinfo($data_redis,$uid){
		$temp = $data_redis->hMget("hu:{$uid}",array("rmb","total_win","ver","initVer"));
		$t["rmb"] = isset($temp['rmb'])?(int)$temp["rmb"]:0;
		$t["total_win"] = isset($temp['total_win'])?(int)$temp["total_win"]:0;
		$t["ver"] = isset($temp['ver'])?(int)$temp["ver"]:0;
		$t["iv"] = isset($temp['initVer'])?(int)$temp["initVer"]:0;
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
		foreach ($keys as $key) {
			$award = $cache_redis->hMGet("{$pk}{$key}", array("id","finishtype",
					"finishnum", "awardtype","awardmount","title","desc","limitnum"));
			$t["i"] = (int)$award["id"];			// ID
			$t["n"] = (int)$award["finishnum"];		// 完成数量
			$t["f"] = (int)$award["finishtype"];	// 完成类型
			$t["a"] = (int)$award["awardtype"];		// 奖励类型
			$t["m"] = (int)$award["awardmount"];	// 奖励数额
			$t["t"] = $award["title"];				// 标题
			$t["d"] = $award["desc"];				// 描述			
			$awardes[] = $t;
		}
		return $awardes;
	}
}	
?>