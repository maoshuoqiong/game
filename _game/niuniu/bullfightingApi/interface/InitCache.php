<?php
class InitCache extends APIBase {
	public $tag = "InitCache";
	public $isLogin = false;
	public $RANK_TYPE_MONEY = 0;
	public $RANK_TYPE_LEVEL = 1;
	public $RANK_TYPE_EXP = 2;
	public function before() {
		$this->initMysql ();
		
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		if (! (isset ( $this->param ['pass'] ) && $this->param ['pass'] == Config::$cache_pass)) {
			$this->returnError ( 300, "password is error." );
		}
		
		$flag = false;
		if (isset ( $this->param ['all'] ) && $this->param ['all'] == 1) {
			$flag = true;
		}
		
		if ($flag || (isset ( $this->param ['gift'] ) && $this->param ['gift'] == 1)) {
			$this->loadGift ();
		}
		
		if ($flag || (isset ( $this->param ['venue'] ) && $this->param ['venue'] == 1)) {
			$this->loadVenue ();
		}
		if ($flag || (isset ( $this->param ['level'] ) && $this->param ['level'] == 1)) {
			$this->loadLevel ();
		}
		if ($flag || (isset ( $this->param ['title'] ) && $this->param ['title'] == 1)) {
			$this->loadTitle ();
		}
		/*
		 * if ($flag || (isset ( $this->param ['announcement'] ) && $this->param ['announcement'] == 1)) { $this->LoadAnnouncement (); $this->LoadMessage (); }
		 */
		
		if ($flag || (isset ( $this->param ['goods'] ) && $this->param ['goods'] == 1)) {
			$this->LoadGoods ();
		}
		
		if ($flag || (isset ( $this->param ['award'] ) && $this->param ['award'] == 1)) {
			$this->LoadAward ();
		}
		
		/*
		 * if ($flag || (isset ( $this->param ['rank'] ) && $this->param ['rank'] == 1)) { $this->LoadRank (); }
		 */
		if ($flag || (isset ( $this->param ['lottery'] ) && $this->param ['lottery'] == 1)) {
			$this->LoadLottery ();
			$this->LoadLuckdraw ();
		}
		if ($flag || (isset ( $this->param ['robot'] ) && $this->param ['robot'] == 1)) {
			$this->LoadRobot ();
		}
		if ($flag || (isset ( $this->param ['loginreward'] ) && $this->param ['loginreward'] == 1)) {
			$this->LoadLoginreward ();
		}
		if ($flag || (isset ( $this->param ['tasks'] ) && $this->param ['tasks'] == 1)) {
			$this->LoadTasks ();
		}
		if ($flag || (isset ( $this->param ['tasksday'] ) && $this->param ['tasksday'] == 1)) {
			$this->LoadTasksDay ();
		}
		if ($flag || (isset ( $this->param ['notice'] ) && $this->param ['notice'] == 1)) {
			$this->LoadNotice ();
		}
		if ($flag || (isset ( $this->param ['slot'] ) && $this->param ['slot'] == 1)) {
			$this->LoadSlot ();
		}
		if ($flag || (isset ( $this->param ['activity'] ) && $this->param ['activity'] == 1)) {
			$this->LoadActivity (); 
		} 
		/* if ($flag || (isset ( $this->param ['activityrank'] ) && $this->param ['activityrank'] == 1)) { $this->LoadActivityRank (); } if ($flag || (isset ( $this->param ['synRechargeRank'] ) && $this->param ['synRechargeRank'] == 1)) { $this->LoadRechargeRank (); }
 */		
		if ($flag || (isset ( $this->param ['apps'] ) && $this->param ['apps'] == 1)) {
			$this->LoadApps ();
		}
		if ($flag || (isset ( $this->param ['vips'] ) && $this->param ['vips'] == 1)) {
			$this->LoadVips ();
		}
		if ($flag || (isset ( $this->param ['marquee'] ) && $this->param ['marquee'] == 1)) {
			$this->LoadMarquee ();
		}
		
		/*
		 * if (isset ( $this->param ['resetpact'] ) && $this->param ['resetpact'] == 1) { $this->initDataRedis ( 1000 ); $keys = $this->data_redis->keys ( "hpe:*" ); $inc = 0; foreach ( $keys as $key ) { // $this->data_redis->hDel($key,"actWinMonDay","actWinMonTot","actWinMoney","actBoardWin","actRatio"); $this->data_redis->hDel ( $key, "actRatio" ); $inc ++; } echo $inc; } if (isset ( $this->param ['uplogindate'] ) && $this->param ['uplogindate'] == 1 && isset ( $this->param ['date'] ) && isset ( $this->param ['uid'] )) { $ts = strtotime ( date ( $this->param ['date'] ) ); $this->initDataRedis ( 1000 ); $this->data_redis->hSet ( "hu:{$this->param['uid']}", 'update_time', $ts - 600 ); echo $this->param ['date']; }
		 */
		/*
		 * if($flag || (isset($this->param['initver']) && $this->param['initver'] == 1)){ $row = $this->mysql->find("SELECT * FROM `playermark` where cur_ver=11"); $this->initDataRedis(1000); if (sizeof($row)>0) { foreach ($row as $g) { $hu = $this->data_redis->hMget("hpe:{$g['uid']}",array("cur_ver","11")); } echo "size:".sizeof($row); } } if ($flag || (isset($this->param['synpext']) && $this->param['synpext'] == 1)) { $this->LoadSynPExt(1,10000); } if (isset($this->param['rout']) && isset($this->param['id']) && $this->param['rout'] == 1) { $this->cache_redis->hSet("srout","id",$this->param['id']); $arr = $this->cache_redis->hGet("srout","id"); echo "round task id is:".$arr; }
		 */
		if ($flag || (isset ( $this->param ['paymsg'] ) && $this->param ['paymsg'] == 1)) {
			$this->LoadPaymsg ();
		}
		
		if ((isset ( $this->param ['initrobot'] ) && $this->param ['initrobot'] == 1 && isset ( $this->param ['etype'] ))) {
			$this->LoadInitRobot ( $this->param ['etype'] );
		}
		// 金币排行
		if ($flag || (isset ( $this->param ['topmoney'] ) && $this->param ['topmoney'] == 1)) {
			$this->LoadTopmoney ();
		}
		// 充值排行
		if ($flag || (isset ( $this->param ['topcz'] ) && $this->param ['topcz'] == 1)) {
			$this->LoadTopcz ();
		}
		// 更多游戏
		if ($flag || (isset ( $this->param ['moregame'] ) && $this->param ['moregame'] == 1)) {
			$this->LoadMoregame ();
		}
		// 开服活动
		if ($flag || (isset ( $this->param ['openact'] ) && $this->param ['openact'] == 1)) {
			// $this->LoadOpenAct ();
		}
		// 签到
		if ($flag || (isset ( $this->param ['signin'] ) && $this->param ['signin'] == 1)) {
			$this->LoadSignIn ();
		}
		// 新老虎机
		if ($flag || (isset ( $this->param ['flipcard'] ) && $this->param ['flipcard'] == 1)) {
			$this->LoadFlipcard ();
		}		
		// 签到测试
		/*if (isset ( $this->param ['upsignin'] ) && $this->param ['upsignin'] == 1) {
			$this->initDataRedis ( 1000 );
			$type = $this->param ['type'];
			$val = $this->param ['val'];
			$uid = $this->param ['uid'];
			
			if ($type == "lv") {
				$val = strtotime ( $val ) + 3600;
				$keys = $this->data_redis->hSet ( "uSignin:" . $uid, 'last_vip_time', $val );
				echo "最后一次VIP签到领奖时间已改为：" . date ( 'Y-m-d H:i:s', $val );
			} elseif ($type == "ls") {
				$val = strtotime ( $val ) + 3600;
				$keys = $this->data_redis->hSet ( "uSignin:" . $uid, 'last_sign_time', $val );
				echo "最后一次签到时间已改为：" . date ( 'Y-m-d H:i:s', $val );
			} elseif ($type == "ld") {
				echo "连续登陆天数已改为：" . $val;
				$keys = $this->data_redis->hSet ( "hu:" . $uid, 'login_days', $val );
			}
		}*/
		
		// 话费防刷黑名单
		if ($flag || (isset ( $this->param ['blackpay'] ) && $this->param ['blackpay'] == 1)) {
			$this->LoadBlackPay();
		}
		// 比赛场活动排行
		if (isset ( $this->param ['topfight'] ) && $this->param ['topfight'] == 1) {
			$this->LoadTopFight ();
		}	
		if (isset ( $this->param ['fightconfig'] ) && $this->param ['fightconfig'] == 1) {
			$this->LoadFightConfig ();
		}
		if (isset ( $this->param ['fightbc'] ) && $this->param ['fightbc'] == 1) {
			$this->LoadFightBroadcost ();
		}
		// MM支付参数
		if ( isset($this->param['paySpecialValue']) && $this->param['paySpecialValue'] == 1) {
			$this->LoadPaySpecialValue();
		}
		if ( isset($this->param['blackword']) && $this->param['blackword'] == 1) {
			$this->LoadBlackWord();
		}
		// 推送假广播
		if ( isset($this->param['pushbc']) && $this->param['pushbc'] == 1) {
			$this->LoadPushBc();
		}

		if ($flag || (isset ( $this->param ['platform'] ) && $this->param ['platform'] == 1)) {
			$this->LoadPlatform ();
		}
		if($flag || (isset ( $this->param ['broadcast'] ) && $this->param ['broadcast'] == 1)){
			$ran = rand(0, 100);
			if($ran>60){
				$this->LoadPushBc();
			}elseif($ran>40){
				if(Game::$table_marquee_switch == 1){
					$mSize = sizeof(Game::$marquee_info);
					$r = rand(0, $mSize);
					$r = $r>0?$r-1:0;
					if (isset(Game::$marquee_info[$r])) {
						$this->sendBroadcast(Game::$marquee_info[$r],'sys');
					}
				}
			}			
		}
		if ($flag || (isset ( $this->param ['provlimit'] ) && $this->param ['provlimit'] == 1)) {
			$this->LoadProvLimit ();
		}
	}
	
	private function LoadProvLimit() {
		$this->clear ( array (
				"hProvLS:*"
		) );
		$prov = $this->mysql->find ( "select * from `core_prov`" );
		foreach ( $prov as $g ) {
		    $this->cache_redis->hMset ( "hProvLS:{$g['number']}", array('code'=>$g['code']));
		}	
		
		$row = $this->mysql->find ( "SELECT * FROM `qx_prov_switch`" );
		foreach ( $row as $g ) {		    
    		foreach ( $prov as $d ) {
    		    if($g['code'] == $d['code']){    		        
    		        $this->cache_redis->hMset ( "hProvLS:{$d['number']}", array('qxclose'=>$g['isclose']));
    		    }    		    
    		}
		}
		
		$row = $this->mysql->find ( "SELECT * FROM `mmcrack_prov_switch`" );
	    foreach ( $row as $g ) {
    		foreach ( $prov as $d ) {
    		    if($g['code'] == $d['code']){
    		        $this->cache_redis->hMset ( "hProvLS:{$d['number']}", array('mmclose'=>$g['isclose']));
    		    }    		    
    		}				
		}			

		$hkeys = count ( $this->cache_redis->keys ( "hProvLS:*" ) );
		echo "LoadProvLimit {lltp: {$hkeys}} data success...<br>";
	}
		
	private function LoadPlatform() {
		$row = $this->mysql->find ( "SELECT * FROM `platforminfo` where status>0 order by sortind" );
		// $resArr = array();
		foreach ( $row as $g ) {
			$goods ["appName"] = $g ["appName"];
			$goods ["packageName"] = $g ["packageName"];
			$goods ["iconUrl"] = $g ["iconUrl"];
			$goods ["apkUrl"] = $g ["apkUrl"];
			$goods ["apkMD5"] = $g ["apkMD5"];
			$goods ["hot"] = $g ["hot"];
			$goods ["new"] = $g ["new"];
			$goods ["isHost"] = $g ["isHost"];
			$resArr [] = $goods;
		}
		if (sizeof ( $resArr ) > 0) {
			$this->cache_redis->set ( "splatforminfo", json_encode ( $resArr ) );
		}
		$listkeys = $this->cache_redis->get ( "splatforminfo" );
		echo "LoadPlatform {lltp: {$listkeys}} data success...<br>";
		//		$this->i ( "LoadLuckdraw {lltp: {$listkeys}} data success..." );

		$this->clear ( array (
				"spfSwitch:*"
		) );
		$row = $this->mysql->find ( "SELECT * FROM `platformswitch`" );
		// $resArr = array();
		$inc = 0;
		foreach ( $row as $g ) {
			$this->cache_redis->hSet( "spfSwitch:".$g['channel'], 'flag',(int)$g['flag']);
			$inc++;
		}
		echo "LoadPlatformSwitch {lltp: {$inc}} data success...<br>";
	}
	private function LoadPushBc() {
		$ranV = rand(0, 100);
		$ilst = explode ( ",", Config::$robotList );
		$rid = rand($ilst[0]+1, $ilst[1]-1);
		$this->initDataRedis ( 1000 );
		$rname = $this->data_redis->hGet("hu:{$rid}","name");
		if(!$rname){
			echo 'robot err';
			return;
		}
		if($ranV>95){
			$ranV = rand(0, 100);
			if($ranV<50){
				$msg = "吊炸天了!".$rname."抽奖获得30元话费";
			}else{
				$msg = "吊爆啦!".$rname."抽奖获得10元话费";
			}
// 			echo $msg;
			$this->sendBroadcast($msg, "1");			
		}else if($ranV>70) {
			$win_money = 200000+rand(0,8)*100000;
			$msg = $rname."在老虎机里逆袭了,狂赚".$win_money."金币";
// 			echo $msg;
			$this->sendBroadcast($msg, "1");
		} elseif($ranV>40) {
			$venueName = array('牛比轰轰','牛气冲天','牛炸天','牛魔王','牛逼轰轰');
			$baseV = array(500,2000,5000,10000,500);
			$minV = array(50000,100000,200000,500000,50000);
			$ind = rand(0, 4);		
			$diff_money	 = $minV[$ind]+rand(0, 32)*$baseV[$ind];
			$msg = $rname."大杀四方,瞬间在".$venueName[$ind]."场赢得了".$diff_money."金币";
// 			echo $msg;
			$this->sendBroadcast($msg, "10");
		}		
	}
	private function LoadBlackWord() {
		$row = $this->mysql->find ( "SELECT * FROM `blackword`" );
		$this->clear ( array (
				"sblackword"
		));
		foreach ( $row as $g ) {
			$good['id'] = $g['id'];
			$good['word'] = $g['word'];
			$resArr [] = $good;
		}
// 		var_dump($resArr);
		$this->cache_redis->set ( "sblackword", json_encode ( $resArr ) );
		$listkeys1 = $this->cache_redis->get ( "sblackword" );
		echo "LoadBlackWord {llt: {".sizeof($resArr)."}} data success...<br>";	
	}
	
	private function LoadFightConfig() {
		$this->cache_redis->set ( "sfightAward:today", Game::$fight_today_award);
		$this->cache_redis->set ( "sfightAward:total", Game::$fight_total_award);

		$dateArr = explode("~", Game::$fight_game_open_day);
		if(sizeof($dateArr)!=2){
			return;
		}
		$st = strtotime($dateArr[0]);
		$et = strtotime($dateArr[1])+86400;
		$this->cache_redis->hMset("fightDate",array('st'=>$st,'et'=>$et));
		
		$listkeys0 = $this->cache_redis->get ( "sfightAward:today" );
		$listkeys1 = $this->cache_redis->get ( "sfightAward:total" );
		$listkeys2 = $this->cache_redis->hMget("fightDate",array('st','et'));
		echo "LoadFightConfig {llt: {$listkeys0}} data success...<br>";
		echo "LoadFightConfig {llt: {$listkeys1}} data success...<br>";
// 		var_dump($listkeys2);
// 		$this->i ( "LoadFightConfig {llt: {$listkeys0}} data success..." );
// 		$this->i ( "LoadFightConfig {llt: {$listkeys1}} data success..." );
	}
	
	private function LoadFightBroadcost() {
		if(isset($this->param ['fightType']) && $this->param ['fightType']== "total"){
			$row = $this->mysql->find ( "SELECT * FROM `fight_award_log` where topType=1 order by create_time desc,no limit 20" );	
			$dateStr = "上周";		
		}else{
			$row = $this->mysql->find ( "SELECT * FROM `fight_award_log` where topType=0 order by create_time desc,no limit 10" );
			$dateStr = "昨天";
		}
		$inc = 0;
		foreach ( $row as $g ) {
			$p = $this->getPlayerByDB($g['uid']);
			if($inc>=3){
				break;
			}
			if(isset($p['name'])){
				$msg = "恭喜".$p['name']."在".$dateStr."比赛场勇夺第".$g['no']."名,赢得了".$g['awardAmount']."元话费奖励";
				$this->sendBroadcast($msg, "1");
			}
			$inc++;
		}
		echo "sendFightBroadcost  data success...<br>";
// 		$this->i ( "sendFightBroadcost data success..." );
	}
		
	private function LoadFlipcard() {
		$row = $this->mysql->find ( "SELECT * FROM `flipcard_control`" );
		$this->clear ( array (
				"sflipcontrol:pub","sflipcontrol:pri"
		));
		foreach ( $row as $g ) {
			$goods ["minMoney"] = (int)$g ["minMoney"];
			$goods ["maxMoney"] = (int)$g ["maxMoney"];
			$goods ["init"] = explode(',',$g ["initRatio"]);
			$goods ["cone"] = explode(',',$g ["oneChangeRatio"]);			
			$goods ["ctwo"] = explode(',',$g ["twoChangeRatio"]);
			$goods ["cthree"] = explode(',',$g ["threeChangeRatio"]);
			if($g ["type"]==0){
				$resPub [] = $goods;
			}else if ($g ["type"]==1){
				$resPri [] = $goods;
			}
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "sflipcontrol:pub", json_encode ( $resPub ) );
		$this->cache_redis->set ( "sflipcontrol:pri", json_encode ( $resPri ) );
	
		$listkeys0 = $this->cache_redis->get ( "sflipcontrol:pub" );
		$listkeys1 = $this->cache_redis->get ( "sflipcontrol:pri" );
		echo "LoadFlipcard {llt: {$listkeys0}} data success...<br>";
		echo "LoadFlipcard {llt: {$listkeys1}} data success...<br>";
// 		$this->i ( "LoadFlipcard {llt: {$listkeys0}} data success..." );
// 		$this->i ( "LoadFlipcard {llt: {$listkeys1}} data success..." );
		
	}
	private function LoadSignIn() {
		$row = $this->mysql->find ( "SELECT * FROM `signin`" );
		$this->clear ( array (
				"ssignin:cont",
				"ssignin:tot",
				"ssignin:vip" 
		) );
		foreach ( $row as $g ) {
			$goods ["amount"] = ( int ) $g ["signTotal"];
			$goods ["award"] = $this->getAwardItem ( $g ["awardItem"] );
			if ($g ["signType"] == 0) {
				$goods ["id"] = 'c' . $g ["signTotal"];
				$resCont [] = $goods;
			} else if ($g ["signType"] == 1) {
				$goods ["id"] = 't' . $g ["signTotal"];
				$resTot [] = $goods;
			} else if ($g ["signType"] == 2) {
				$goods ["id"] = 'v' . $g ["signTotal"];
				$resVip [] = $goods;
			} else {
				continue;
			}
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "ssignin:cont", json_encode ( $resCont ) );
		$this->cache_redis->set ( "ssignin:tot", json_encode ( $resTot ) );
		$this->cache_redis->set ( "ssignin:vip", json_encode ( $resVip ) );
		
		$listkeys0 = $this->cache_redis->get ( "ssignin:cont" );
		$listkeys1 = $this->cache_redis->get ( "ssignin:tot" );
		$listkeys2 = $this->cache_redis->get ( "ssignin:vip" );
		echo "LoadSignIn {llt: {$listkeys0}} data success...<br>";
		echo "LoadSignIn {llt: {$listkeys1}} data success...<br>";
		echo "LoadSignIn {llt: {$listkeys2}} data success...<br>";
// 		$this->i ( "LoadSignIn {llt: {$listkeys0}} data success..." );
// 		$this->i ( "LoadSignIn {llt: {$listkeys1}} data success..." );
// 		$this->i ( "LoadSignIn {llt: {$listkeys2}} data success..." );
	}
	private function getAwardItem($awardItem) {
		$awardArr = explode ( ',', $awardItem );
		$awardRes = array ();
		if (sizeof ( $awardArr ) > 0) {
			foreach ( $awardArr as $key ) {
				$tempArr = explode ( ':', $key );
				$awardRes [] = array (
						'at' => ( int ) $tempArr [0],
						'an' => ( int ) $tempArr [1] 
				);
			}
		}
		return $awardRes;
	}
	private function LoadOpenAct() {
		$row = $this->mysql->find ( "select * from open_act_log where create_time>'2014-08-15 00:00:00' and create_time<'2014-08-24 01:00:00' order by uid,create_time" );
		$lastUid = 0;
		$lastDay = 0;
		$incCoin = 0;
		$incDay = 0;
		$defCoin = 5;
		$tempUid = 0;
		$tempWinT = 0;
		$tempDay = 0;
		$totalWin = 0;
		$this->initDataRedis ( 1000 );
		$inc = 0;
		foreach ( $row as $g ) {
			if ($lastUid == 0) {
				$lastUid = ( int ) $g ["uid"];
				$totalWin = ( int ) $g ["winTime"];
				$lastDay = substr ( $g ["create_time"], 0, 10 );
				$incCoin = $totalWin > 10 ? $defCoin : 0;
				continue;
			}
			$tempUid = ( int ) $g ["uid"];
			$tempWinT = ( int ) $g ["winTime"];
			$tempDay = substr ( $g ["create_time"], 0, 10 );
			if ($lastUid != $tempUid) {
				if ($incDay == 10 && $totalWin >= 500) {
					$incCoin = $incCoin * 2;
				}
				if ($incCoin > 0) {
					$isExists = $this->data_redis->exists ( "hu:{$lastUid}" );
					if ($isExists) {
						$this->uid = $lastUid;
						$this->hincrCoin ( $incCoin, "openAct" );
					}
					$this->sendPersonMsg ( $lastUid, "sys", "恭喜您在'惊喜大回馈'活动中获得" . $incCoin . "元宝~" );
					$awardlog = array ();
					$awardlog ["uid"] = $lastUid;
					$awardlog ["awardcoin"] = $incCoin;
					$awardlog ["wintimes"] = $totalWin;
					$this->mysql->insert ( "open_act_award_log", $awardlog );
					$this->mysql->query ( "update player set coin=coin+" . $incCoin . " where id=" . $lastUid );
					echo 'uid:' . $lastUid . ',ic:' . $incCoin . ',tw:' . $totalWin . ',days:' . $incDay . '<br/>';
				}
				// 重置相关数据
				$lastUid = $tempUid;
				$lastDay = $tempDay;
				$totalWin = $tempWinT;
				$incDay = $totalWin > 10 ? 1 : 0;
				$incCoin = $totalWin > 10 ? $defCoin : 0;
				continue;
			}
			
			if ($tempWinT > 10) {
				if (CommonTool::getDiffBetweenTwoDate ( strtotime ( $lastDay ), strtotime ( $tempDay ) ) == 1) {
					$incDay ++;
				} else {
					$incDay = 1;
				}
				$incCoin += $defCoin * $incDay;
			} else {
				$incDay = 0;
			}
			$totalWin += $tempWinT;
			$lastDay = $tempDay;
		}
		echo $inc;
	}
	private function LoadMoregame() {
		$row = $this->mysql->find ( "SELECT * from moregame order by sortind" );
		$this->clear ( array (
				"sMoregame",
				"hMoregame:*",
				"scMoregame"	// 纯棋牌 
		) );
		foreach ( $row as $g ) {
			$goods ["id"] = ( int ) $g ["id"];
			$goods ["name"] = $g ["name"];
			$goods ["imagPath"] = $g ["imagPath"];
			$goods ["status"] = ( int ) $g ["status"];
			$goods ["size"] = $g ["size"];
			$goods ["ver"] = $g ["ver"];
			$goods ["star"] = ( int ) $g ["star"];
			$goods ["type"] = $g ["type"];
			$goods ["md5"] = $g ["md5"];
			$goods ["url"] = $g ["url"];
			$goods ["pname"] = $g ["packageName"];
			if($g ["status"]>0){
				$resArr [] = $goods;
			}
			if($g ["ischess"]==1){
				$chessArr [] = $goods;
			}
			$this->cache_redis->hMset ( "hMoregame:{$goods ["id"]}", $g );
		}
		if (isset ( $chessArr ) && count ( $chessArr ) > 0) {
			$this->cache_redis->set ( "scMoregame", json_encode ( $chessArr ) );
			$listkeys2 = $this->cache_redis->get ( "scMoregame" );
			echo "LoadMoregame chess {llt: {$listkeys2}} data success...<br/>";
			// 			$this->i ( "LoadMoregame {llt: {$listkeys2}} data success..." );
		}
		if (isset ( $resArr ) && count ( $resArr ) > 0) {
			$this->cache_redis->set ( "sMoregame", json_encode ( $resArr ) );
			$listkeys2 = $this->cache_redis->get ( "sMoregame" );
			echo "LoadMoregame {llt: {$listkeys2}} data success...<br/>";
// 			$this->i ( "LoadMoregame {llt: {$listkeys2}} data success..." );
		} else {
			echo "LoadMoregame no datas ...<br/>";
		}
	}
	
	// 充值排行
	private function LoadTopcz() {
		$row = $this->mysql->find ( "SELECT a.uid, sum(a.rmb) as rmbs , b.name, b.title FROM `payorder` a join player b on a.uid =b.id where a.success=1 and a.updated_at >=CURDATE() group by a.uid, b.name, b.title  ORDER BY rmbs desc limit 15" );
		$this->clear ( array (
				"sRechargeRank" 
		) );
		
		$no = 1;
		foreach ( $row as $g ) {
			// {"uid":125,"na":"name1","no":1,"amount ":25,"title": "孺子牛"}
			$goods ["uid"] = ( int ) $g ["uid"];
			$goods ["no"] = $no;
			$goods ["amount"] = ( int ) $g ["rmbs"];
			$goods ["title"] = isset ( $g ["title"] ) ? $g ["title"] : "";
			$goods ["na"] = isset ( $g ["name"] ) ? $g ["name"] : "";
			$resArr [] = $goods;
			$no = $no + 1;
		}
		
		if (isset ( $resArr ) && count ( $resArr ) > 0) {
			$this->cache_redis->set ( "sRechargeRank", json_encode ( $resArr ) );
			$listkeys2 = $this->cache_redis->get ( "sRechargeRank" );
			echo "LoadTopcz {llt: {$listkeys2}} data success...<br/>";
// 			$this->i ( "LoadTopcz {llt: {$listkeys2}} data success..." );
		} else {
			echo "LoadTopcz no datas ...<br/>";
		}
	}
	private function LoadTopFightTotal() {
		// 总榜
		$row = $this->mysql->find ( "SELECT * FROM `fight_top_temp` where totalpoint>0 order by totalpoint desc limit 15" );
		$no = 1;
		$tempOnePoint = 0;
		$tempFristRobotId = 0;
		$tempFristRobotUid = 0;
		$tempFristRobotPoint = 0;
		if(sizeof($row)>0){
			foreach ( $row as $g ) {
				$goods ["uid"] = ( int ) $g ["uid"];
				$p = $this->getPlayerByDB($goods ["uid"]);
				$goods ["name"] = isset($p['name'])?$p['name']:'匿名';
				$goods ["no"] = $no;
				$goods ["amount"] = ( int ) $g ["totalpoint"];
				$goods ["title"] = isset($p['title'])?$p['title']:'小萌牛';
				$resArr2 [] = $goods;
				
				if($this->isRobot($goods['uid']) && $tempFristRobotId==0){
					$tempFristRobotId =  $g ["id"];
					$tempFristRobotUid = $goods['uid'];
					$tempFristRobotPoint = $goods ["amount"];
				}else{
					if($no==1){
						$tempOnePoint = $goods ["amount"];
					}
				}
				$no = $no + 1;
			}
			// 机器人作假
			$diffVal = $tempOnePoint-$tempFristRobotPoint;
			$hours = date('H', time());
			if($diffVal>0 && $tempFristRobotId>0 && $hours>20){
				$diffVal += rand(500, 2000);
				$strr = "update fight_top_temp set totalpoint=totalpoint+".$diffVal.",todaypoint=todaypoint+".$diffVal." where id='".$tempFristRobotId."'";
				$this->mysql->query($strr);
				$this->initDataRedis ( 1000 );
				$this->data_redis->hIncrBy("hpe:{$tempFristRobotUid}",'dayPoint',$diffVal);
				$this->data_redis->hIncrBy("hpe:{$tempFristRobotUid}",'totalPoint',$diffVal);
				$this->LoadTopFightTotal();
				return;
			}
			// var_dump($resArr);
			$this->cache_redis->set ( "sFTotalRank", json_encode ( $resArr2 ) );
		}else{
			$this->cache_redis->set ( "sFTotalRank", "");
		}
		$listkeys2 = $this->cache_redis->get ( "sFTotalRank" );
		echo "LoadsFTotalRank {llt: {$listkeys2}} data success...<br/>";		
	}
	
	private function LoadTopFightToday() {		
		// 日榜
		$row = $this->mysql->find ( "SELECT * FROM `fight_top_temp` where todaypoint>0 order by todaypoint desc limit 15" );		
		$no = 1;
		if(sizeof($row)>0){
			foreach ( $row as $g ) {
				// {"uid":125,"name":"nick1","no":1,"amount":50000000,"title":"利木赞牛"}
				$goods ["uid"] = ( int ) $g ["uid"];
				$p = $this->getPlayerByDB($goods ["uid"]);
				$goods ["name"] = isset($p['name'])?$p['name']:'匿名';
				$goods ["no"] = $no;
				$goods ["amount"] = ( int ) $g ["todaypoint"];
				$goods ["title"] = isset($p['title'])?$p['title']:'小萌牛';
				$resArr [] = $goods;			
				$no = $no + 1;
			}
			$this->cache_redis->set ( "sFTodayRank", json_encode ( $resArr ) );
		}else{
			$this->cache_redis->set ( "sFTodayRank", "");
		}		
		// var_dump($resArr);		
		$listkeys2 = $this->cache_redis->get ( "sFTodayRank" );
		echo "LoadsFTodayRank {llt: {$listkeys2}} data success...<br/>";
	
	}
	
	// 比赛积分排行
	private function LoadTopFight() {
		$this->clear ( array (
				"sFTodayRank","sFTotalRank"
		) );
		$this->LoadTopFightTotal();
		$this->LoadTopFightToday();
// 		$this->i ( "LoadsFTodayRank {llt: {$listkeys2}} data success..." );

// 		$this->i ( "LoadsFTotalRank {llt: {$listkeys2}} data success..." );
	}
	
	private function isRobot($uid){
		$ilst = explode ( ",", Config::$robotList );		
		if($uid>=$ilst[0] && $uid<=$ilst[1]){
			return true;
		}
		return false;
	}
	
	private function getPlayerByDB($uid) {
		$row = $this->mysql->find ( "SELECT * FROM `player` where id=".$uid );
		if(sizeof($row)>0){
			return $row[0];
		}
		return null;
	}
	// 金币排行
	private function LoadTopmoney() {
		$row = $this->mysql->find ( "SELECT * FROM `player` where status=1 order by money desc limit 15" );
		$this->clear ( array (
				"sMoneyRank" 
		) );
		
		$no = 1;
		foreach ( $row as $g ) {
			// {"uid":125,"name":"nick1","no":1,"amount":50000000,"title":"利木赞牛"}
			$goods ["uid"] = ( int ) $g ["id"];
			$goods ["name"] = $g ["name"];
			$goods ["no"] = $no;
			$goods ["amount"] = ( int ) $g ["money"];
			
			$title = $g ["title"];
			if (! isset ( $title )) {
				$title = $this->getTitleInfo ( ( int ) $g ["money"] );
			}
			$goods ["title"] = isset ( $title ) ? $title : "";
			$resArr [] = $goods;
			
			$no = $no + 1;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "sMoneyRank", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "sMoneyRank" );
		echo "LoadTopmoney {llt: {$listkeys2}} data success...<br/>";
// 		$this->i ( "LoadTopmoney {llt: {$listkeys2}} data success..." );
	}
	private function LoadPaymsg() {
		$row = $this->mysql->find ( "SELECT * FROM `pay_msg`" );
		$this->clear ( array (
				"spaymsg" 
		) );
		
		foreach ( $row as $g ) {
			$goods ["rmbs"] = $g ["rmbs"];
			$goods ["msg"] = $g ["msg"];
			$resArr [] = $goods;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "spaymsg", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "spaymsg" );
		echo "LoadPaymsg {llt: {$listkeys2}} data success...<br>";
// 		$this->i ( "LoadPaymsg {llt: {$listkeys2}} data success..." );
	}
	private function LoadMarquee() {
		foreach ( Game::$marquee_info as $g ) {
			$msg ['type'] = "1";
			$msg ['msg'] = $g;
			$msg ['time'] = 0;
			$resArr [] = $msg;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "marqueeList", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "marqueeList" );
		echo "LoadMarquee {llt: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadMarquee {llt: {$listkeys2}} data success..." );
	}
	private function LoadLevel() {
		$row = $this->mysql->find ( "SELECT * FROM `level_info` order by id desc" );
		$this->clear ( array (
				"slevel" 
		) );
		foreach ( $row as $g ) {
			$goods ["id"] = ( int ) $g ['id'];
			$goods ["level"] = ( int ) $g ["level"];
			$goods ["minExp"] = ( int ) $g ["minExp"];
			$goods ["maxExp"] = ( int ) $g ["maxExp"];
			$resArr [] = $goods;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "slevel", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "slevel" );
		echo "LoadLevel {llt: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadLevel {llt: {$listkeys2}} data success..." );
	}
	private function LoadTitle() {
		$row = $this->mysql->find ( "SELECT * FROM `title_info` order by id desc" );
		$this->clear ( array (
				"stitle" 
		) );
		foreach ( $row as $g ) {
			$goods ["id"] = ( int ) $g ['id'];
			$goods ["title"] = $g ["title"];
			$goods ["minMoney"] = ( int ) $g ["minMoney"];
			$goods ["maxMoney"] = ( int ) $g ["maxMoney"];
			$resArr [] = $goods;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "stitle", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "stitle" );
		echo "LoadTitle {llt: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadTitle {llt: {$listkeys2}} data success..." );
	}
	private function LoadVips() {
		$row = $this->mysql->find ( "SELECT * FROM `vips` order by level desc" );
		$this->clear ( array (
				"svips" 
		) );
		foreach ( $row as $g ) {
			$goods ["id"] = ( int ) $g ['id'];
			$goods ["level"] = ( int ) $g ["level"];
			$goods ["min_recharge"] = ( int ) $g ["min_recharge"];
			$goods ["min_exp"] = ( int ) $g ["min_exp"];
			$goods ["ext_award"] = ( int ) $g ["ext_award"];
			$resArr [] = $goods;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "svips", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "svips" );
		echo "LoadVips {llt: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadVips {llt: {$listkeys2}} data success..." );
	}
	private function LoadApps() {
		$row = $this->mysql->find ( "SELECT * FROM `apps`" );
		$this->clear ( array (
				"sapps" 
		) );
		foreach ( $row as $g ) {
			$goods ["id"] = ( int ) $g ['id'];
			$goods ["appName"] = $g ["appName"];
			$goods ["package"] = $g ["package"];
			$goods ["ver_last"] = ( int ) $g ["ver_last"];
			$goods ["ver"] = $g ["ver"];
			$goods ["isforce"] = ( int )$g ["isforce"];
			$goods ["memo"] = $g ["memo"];
			$resArr [] = $goods;
		}
		$this->cache_redis->set ( "sapps", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "sapps" );
		echo "LoadApps {llt: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadApps {llt: {$listkeys2}} data success..." );
		
		$row = $this->mysql->find ( "SELECT * FROM `app_modules`" );
		$this->clear ( array (
				"sappmodules" 
		) );
		foreach ( $row as $g ) {
			$goods1 ["id"] = ( int ) $g ['id'];
			$goods1 ["module_id"] = $g ["module_id"];
			$goods1 ["type_id"] = ( int ) $g ["type_id"];
			$goods1 ["type_value"] = $g ["type_value"];
			$goods1 ["closed"] = ( int ) $g ["closed"];
			$resArr1 [] = $goods1;
			// MM审核标记，还原计费点未正常值
			if($goods1 ["type_value"]=='000000000000' && $goods1 ["module_id"]=='shop'){
				$this->cache_redis->set ( "smm_audit", $goods1 ["closed"] );
			}
		}
		$this->cache_redis->set ( "sappmodules", json_encode ( $resArr1 ) );
		$listkeys1 = $this->cache_redis->get ( "sappmodules" );
		echo "LoadAppmodules {llt: {$listkeys1}} data success...<br>";
		
		// app control 
		$row = $this->mysql->find ( "SELECT * FROM `app_up_control` where `endTime`>".time());
		$this->clear ( array (
				"sappupcontrol"
		) );
		foreach ( $row as $g ) {
			$goods2 ["channel"] = $g ["channel"];
			$goods2 ["package"] = $g ["package"];
			$goods2 ["startTime"] = ( int )$g ["startTime"];
			$goods2 ["endTime"] = ( int ) $g ["endTime"];
			$goods2 ["ver_last"] = ( int ) $g ["ver_last"];
			$goods2 ["ver"] = $g ["ver"];
			$goods2 ["isforce"] = ( int )$g ["isforce"];
			$resArr2 [] = $goods2;
		}
		if(isset($resArr2) && sizeof($resArr2)>0){
			$this->cache_redis->set ( "sappupcontrol", json_encode ( $resArr2 ) );
			$listkeys1 = $this->cache_redis->get ( "sappupcontrol" );
			echo "LoadAppupcontrol {llt: {$listkeys1}} data success...<br>";
		}		
//		$this->i ( "LoadAppmodules {llt: {$listkeys1}} data success..." );

		// app channel up info
		$inc = 0;
		$row = $this->mysql->find ( "SELECT * FROM `app_channel_up`");
		$this->clear ( array (
				"pkgMd5:*"
		) );
		foreach ( $row as $g ) {
			$this->cache_redis->set ( "pkgMd5:".$g ["channel"], $g ["pkgMd5"]);
			$inc++;
		}
		echo "LoadAppChannelUp {llt: {$inc}} data success...<br>";
	}
	
	private function clear($regex) {
		foreach ( $regex as $re ) {
			$keys = $this->cache_redis->keys ( $re );
			foreach ( $keys as $key ) {
				$this->cache_redis->del ( $key );
			}
		}
	}
	private function LoadRechargeRank() {
		$ss = strtotime ( date ( "Y-m-d" ) );
		$this->initDataRedis ( 1000 );
		$row = $this->mysql->find ( "select uid,sum(rmb) as rmb from goodslog where create_time>" . $ss . " group by uid order by rmb desc limit 15" );
		$inc = 1;
		foreach ( $row as $g ) {
			$hu = $this->data_redis->hMget ( "hu:{$g['uid']}", array (
					"name",
					"sex" 
			) );
			if (! isset ( $hu ['name'] ) || empty ( $hu ['name'] )) {
				$tt = $this->mysql->find ( "SELECT name,sex FROM `player` where id=" . $g ['uid'] );
				if (empty ( $tt ) || sizeof ( $tt ) <= 0) {
					continue;
				}
				$goods ["na"] = $tt [0] ['name'];
				$goods ["s"] = ( int ) $tt [0] ['sex'];
			} else {
				$goods ["na"] = $hu ['name'];
				$goods ["s"] = ( int ) $hu ['sex'];
			}
			$goods ["no"] = $inc;
			$goods ["u"] = ( int ) $g ['uid'];
			$goods ["am"] = ( int ) $g ['rmb'];
			$resArr [] = $goods;
			$inc ++;
		}
		// var_dump($resArr);
		if (! empty ( $resArr ) && sizeof ( $resArr ) > 0) {
			$this->cache_redis->set ( "sRechargeRank", json_encode ( $resArr ) );
		}
		echo "LoadRechargeRank {ct:{$ss},inc: {$inc}} data success...<br>";
//		$this->i ( "LoadRechargeRank {ct:{$ss},inc: {$inc}} data success..." );
	}
	private function LoadActivityRank() {
		$this->initDataRedis ( 1000 );
		$prizeStr = $this->cache_redis->get ( "activitylist" );
		if (! $prizeStr) {
			return;
		}
		$prizeArr = json_decode ( $prizeStr );
		foreach ( $prizeArr as $g ) {
			if ($g->at == 0) {
				// 日赚金币榜
				$row = $this->mysql->find ( "select * from `temp_rankactivity` order by monday desc limit 15" );
				$this->initActivityRank ( $row, $g->id, "monday" );
			} elseif ($g->at == 1) {
				// 总赚金币榜
				$row = $this->mysql->find ( "select * from `temp_rankactivity` order by montot desc limit 15" );
				$this->initActivityRank ( $row, $g->id, "montot" );
			} elseif ($g->at == 2) {
				// 日最高倍率榜
				$row = $this->mysql->find ( "select * from `temp_rankactivity` order by maxratio desc,boardwin desc limit 15" );
				$this->initActivityRank ( $row, $g->id, "maxratio" );
			} elseif ($g->at == 3) {
				// 日最高赢局榜
				$row = $this->mysql->find ( "select * from `temp_rankactivity` order by boardwin desc limit 15" );
				$this->initActivityRank ( $row, $g->id, "boardwin" );
			} elseif ($g->at == 4) {
				// 日单局赚金币榜
				$row = $this->mysql->find ( "select * from `temp_rankactivity` order by maxwinmoney desc,boardwin desc limit 15" );
				$this->initActivityRank ( $row, $g->id, "maxwinmoney" );
			}
		}
	}
	private function initActivityRank($row, $aid, $akey) {
		$inc = 1;
		$resArr = array ();
		foreach ( $row as $g ) {
			$hu = $this->data_redis->hMget ( "hu:{$g['uid']}", array (
					"name",
					"sex" 
			) );
			if (! isset ( $hu ['name'] ) || empty ( $hu ['name'] )) {
				$row = $this->mysql->find ( "SELECT * FROM `player` where id=" . $g ['uid'] );
				$goods ["na"] = $row [0] ['name'];
				$goods ["s"] = ( int ) $row [0] ['sex'];
			} else {
				$goods ["na"] = $hu ['name'];
				$goods ["s"] = ( int ) $hu ['sex'];
			}
			$goods ["no"] = $inc;
			$goods ["u"] = ( int ) $g ['uid'];
			$goods ["am"] = ( int ) $g [$akey];
			$resArr [] = $goods;
			$inc ++;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "activityrank:{$aid}", json_encode ( $resArr ) );
		echo "LoadActivityRank {activityID:$aid,inc: {$inc}} data success...<br>";
//		$this->i ( "LoadActivityRank {activityID:$aid,inc: {$inc}} data success..." );
	}
	private function LoadActivity() {
		$all = $this->mysql->find ( "SELECT distinct channel FROM `activityconf`" );
		$this->clear ( array (
				"activitylist:*",
				"activity:*"
		) );
		foreach ( $all as $it ) {
			$row = $this->mysql->find ( "SELECT * FROM `activityconf` where channel='".$it['channel']."' order by id" );
			$resArr = array();
			foreach ( $row as $g ) {
				$goods ["id"] = ( int ) $g ['id'];
				$goods ["atype"] = ( int ) $g ['atype'];
				$goods ["type"] = ( int ) $g ['type'];
				$goods ["title"] = $g ["title"];
				$goods ["content"] = $g ["content"];
				$goods ["start_time"] = ( int ) $g ["start_time"];
				$goods ["end_time"] = ( int ) $g ["end_time"];
				$goods ["imag"] = $g ["imag"];
				$goods ["msgImag"] = $g ["msgImag"];
				$goods ["award_limit"] = $g ["award_limit"];
				$goods ["channel"] = $g ["channel"];
				$goods ["award_item"] = $g ["award_item"];
				$this->cache_redis->hMset("activity:{$goods ["id"]}", $goods );
				$resArr [] = $goods;
			}
			$this->cache_redis->set ( "activitylist:{$it['channel']}", json_encode ( $resArr ) );
			$listkeys = $this->cache_redis->get ( "activitylist:{$it['channel']}" );
			echo "LoadActivity:{$it['channel']} {llt: {$listkeys}} ...<br>";
		}		
//		$this->i ( "LoadActivity {llt: {$listkeys}} data success..." );
	}
	private function LoadSynPExt($start, $end) {
		$this->initDataRedis ( 1000 );
		$inc = 0;
		for($i = $start; $i < $end; $i ++) {
			$pe = $this->data_redis->hGetAll ( "hpe:{$i}" );
			if (! empty ( $pe ) && isset ( $pe ['uid'] )) {
				$player_ext = array ();
				$player_ext ['uid'] = $pe ['uid'];
				$player_ext ['lastLotteryDate'] = isset ( $pe ['lastLotteryDate'] ) ? $pe ['lastLotteryDate'] : 0;
				$player_ext ['lastPrizeDate'] = isset ( $pe ['lastPrizeDate'] ) ? $pe ['lastPrizeDate'] : 0;
				$player_ext ['lastDayTaskDate'] = isset ( $pe ['lastDayTaskDate'] ) ? $pe ['lastDayTaskDate'] : 0;
				$player_ext ['currLotteryNum'] = isset ( $pe ['currLotteryNum'] ) ? $pe ['currLotteryNum'] : 0;
				$player_ext ['hasRecharge'] = isset ( $pe ['hasRecharge'] ) ? $pe ['hasRecharge'] : 0;
				$player_ext ['telCharge'] = isset ( $pe ['telCharge'] ) ? $pe ['telCharge'] : 0;
				$player_ext ['mob'] = isset ( $pe ['mob'] ) ? $pe ['mob'] : 0;
				$player_ext ['updatedate'] = date ( 'Y-m-d H:i:s' );
				$this->mysql->insert ( "playerext_copy", $player_ext );
				$inc ++;
			}
		}
		echo "synpext {inc: {$inc}} data success...<br>";
//		$this->i ( "synpext {inc: {$inc}} data success..." );
	}
	private function getRandomKeys($length, $bol = true) {
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
	private function LoadInitRobot($etype) {
		$inc = 0;
		$this->initDataRedis ( 1000 );
		$ilst = explode ( ",", Config::$robotList );
		$rbRow = $this->mysql->select ( "player", "*", "","where id>=".$ilst [0]." and id<=".$ilst [1]);
		
		if ($etype == "diyinfo") {
			$rowName = $this->mysql->find ( "SELECT * FROM `robot_name`" );
			shuffle ( $rowName );
			$rowSize = sizeof ( $rowName );
			$j = 0;
			$now = time ();
			foreach ( $rbRow as $row ) {
			    if($row['id']==Config::$robotBanker){
			        continue;
			    }
				// 随机昵称
				if (rand ( 0, 10 ) > 4) {
					$n = $this->getRandomKeys ( 4 ) . $this->getRandomKeys ( 6, false );
				} else { // 自定义昵称
					if ($j >= $rowSize) {
						$j = 0;
					}
					$n = $rowName [$j] ['name'];
					$j ++;
				}
				$ht = rand ( 0, 10 ) > 2 ? 0 : $now; // 有没有头像;
				$s = rand ( 0, 1 );
				$this->mysql->update ( "player", array (
						'name' => $n,
						'sex' => $s 
				), array (
						'id' => $row['id'] 
				) );
				$this->data_redis->hMset ( "hu:{$row['id']}", array (
						'name' => $n,
						'sex' => $s,
						'headtime' => $ht 
				) );
				$inc ++;
			}
		} else {
			foreach ( $rbRow as $row ) {
			    if($row['id']==Config::$robotBanker){
			        continue;
			    }
				$tot = rand ( 300, 2000 );
				$offSet = round ( $tot / 10 );
				$diff = rand ( 10, $offSet );
				$win = round ( $tot / 2 + $diff );
				$exp = $win * 2 + $tot;
				$coin = rand ( 10, 200 );
				$vlevel = rand (1, 4);
				$mon = $this->data_redis->hGet("hu:{$row['id']}", "money");
				if ($mon>3000000) {
					$cum = $mon - ($mon-4000000);
					$this->data_redis->hSet ( "hu:{$row['id']}", "money",$cum);
				}
				$this->data_redis->hMset ( "hu:{$row['id']}", array (
						"total_board" => $tot,
						"total_win" => $win,
						"exp" => $win,
						"coin" => $coin,
						"vipLevel" => $vlevel
				) );
				$inc ++;
			}
		}
		echo "LoadInitRobot {etype:$etype,inc: {$inc}} data success...<br>";
//		$this->i ( "LoadInitRobot {etype:{$etype},inc: {$inc}} data success..." );
	}
	private function LoadSlot() {
		$row = $this->mysql->find ( "SELECT * FROM `slot` order by id" );
		$this->clear ( array (
				"sslot" 
		) );
		foreach ( $row as $g ) {
			$goods ["id"] = ( int ) $g ['id'];
			$goods ["tp"] = ( int ) $g ["type"];
			$goods ["od"] = ( int ) $g ["odds"];
			$goods ["pb"] = ( int ) $g ["prob"];
			$goods ["dc"] = $g ["desc"];
			$resArr [] = $goods;
		}
		// var_dump($resArr);
		$this->cache_redis->set ( "sslot", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "sslot" );
		echo "LoadSlot {llt: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadSlot {llt: {$listkeys2}} data success..." );
	}
	private function LoadNotice() {
		$row = $this->mysql->find ( "SELECT * FROM `notice` order by id" );
		$this->clear ( array (
				"hnotice:*" 
		) );
		foreach ( $row as $g ) {
			$id = $g ['id'];
			$this->cache_redis->hMset ( "hnotice:{$id}", $g );
		}
		$hkeys = count ( $this->cache_redis->keys ( "hnotice:*" ) );
		echo "LoadNotice {hlr: {$hkeys}} data success...<br>";
//		$this->i ( "LoadNotice {hlr: {$hkeys}} data success..." );
	}
	private function LoadTasksDay() {
		// 日常任务每晚0点更新
		$this->cache_redis->del ( "ltaskd3:ids" );
		$this->clear ( array (
				"ltaskd3:ids",
				"htasklimit" //活动任务的Key
		) );
		$row = $this->cache_redis->lRange ( "ltaskd:ids", 0, - 1 );
// 		shuffle ( $row );
		$size = sizeof($row);
		for($i = 0; $i < $size; $i ++) {
			$this->cache_redis->rPush ( "ltaskd3:ids", $row [$i] );
		}
		$row = count ( $this->cache_redis->lRange ( "ltaskd3:ids", 0, - 1 ) );
		echo "LoadTasksDay {llr: {$row}} data success...<br>";
		// var_dump($row);
	}
	private function LoadTasks() {
		// 日常任务
		$row = $this->mysql->find ( "SELECT * FROM `tasksconf` Where `ttype`=0 order by id" );
		$this->clear ( array (
				"htaskd:*",
				"ltaskd:ids" 
		) );
		foreach ( $row as $g ) {
			$id = $g ['id'];
			$this->cache_redis->rPush ( "ltaskd:ids", $id );
			$this->cache_redis->hMset ( "htaskd:{$id}", $g );
		}
		$hkeys = count ( $this->cache_redis->keys ( "htaskd:*" ) );
		$listkeys = count ( $this->cache_redis->lRange ( "ltaskd:ids", 0, - 1 ) );
		echo "LoadTasks day {htaskd: {$hkeys}, ltaskd:ids: {$listkeys}} data success...<br>";
//		$this->i ( "LoadTasks day {htaskd: {$hkeys}, ltaskd:ids: {$listkeys}} data success..." );
		
		// 成就任务
		$row = $this->mysql->find ( "SELECT * FROM `tasksconf` Where `ttype`=1 order by id" );
		$this->clear ( array (
				"htaska:*",
				"ltaska:ids" 
		) );
		foreach ( $row as $g ) {
			$id = $g ['id'];
			$this->cache_redis->rPush ( "ltaska:ids", $id );
			$this->cache_redis->hMset ( "htaska:{$id}", $g );
		}
		$hkeys = count ( $this->cache_redis->keys ( "htaska:*" ) );
		$listkeys = count ( $this->cache_redis->lRange ( "ltaska:ids", 0, - 1 ) );
		echo "LoadTasks achieve {htaska: {$hkeys}, ltaska:ids: {$listkeys}} data success...<br>";
//		$this->i ( "LoadTasks achieve {htaska: {$hkeys}, ltaska:ids: {$listkeys}} data success..." );
		// 更新标记
		$this->cache_redis->set ( "staskup", time () );
	}
	private function LoadRobot() {
		$ilst = explode ( ",", Config::$robotList );
		$this->clear ( array (
				"lrob:ids" 
		) );
		$now = time ();
		$skey = md5 ( $now . Game::$salt_password );
		$this->initDataRedis ( 1000 );
		$rbRow = $this->mysql->select ( "player", "*", "","where id>=".$ilst [0]." and id<=".$ilst [1]);
		array_shift($rbRow);
		foreach ( $rbRow as $row ) {
			$row['update_time'] = $now;
			$row['heartbeat_at'] = $now;
			$row['skey'] = $skey;
			$this->data_redis->hMset ( "hu:{$row['id']}", $row);
			if($row['id']!=Config::$robotBanker){
				$this->cache_redis->rPush ( "lrob:ids", $row['id'] );
			}			
		}
		$this->cache_redis->set ( "srob:skey", $skey );
		$listkeys = count ( $this->cache_redis->lRange ( "lrob:ids", 0, - 1 ) );
		echo "LoadRobot {{$listkeys}} data success...<br>";
//		$this->i ( "LoadRobot {{$listkeys}} data success..." );
	}
	private function LoadLottery() {
		$row = $this->mysql->find ( "SELECT * FROM `lottery` Where `status`>0 order by id" );
		$this->clear ( array (
				"hlt:*",
				"llt:ids" 
		) );
		$resArr = array (
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'' 
		);
		foreach ( $row as $g ) {
			$id = $g ['id'];
			$st = $g ['status'];
			if ($st == 1) {
				$this->cache_redis->rPush ( "llt:ids", $id );
			} else {
				$goods ["awardType"] = ( int ) $g ["awardType"];
				$goods ["amount"] = ( int ) $g ["amount"];
				$goods ["userTypeProb"] = $g ["userTypeProb"];
				$goods ["sortInd"] = ( int ) $g ["sortInd"];
				$goods ["noticeId"] = ( int ) $g ["noticeId"];
				$goods ["desp"] = $g ["desp"];
				$resArr [$goods ["sortInd"]] = $goods;
			}
			$this->cache_redis->hMset ( "hlt:{$id}", $g );
		}
		if (sizeof ( $resArr ) > 0) {
			$this->cache_redis->set ( "sltpay", json_encode ( $resArr ) );
		}
		
		$hkeys = count ( $this->cache_redis->keys ( "hlt:*" ) );
		$listkeys = count ( $this->cache_redis->lRange ( "llt:ids", 0, - 1 ) );
		$listkeys2 = $this->cache_redis->get ( "sltpay" );
		echo "LoadLottery {llt: {$listkeys},hlt: {$hkeys}, lltp: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadLottery {llt: {$listkeys}, hlt: {$hkeys}, lltp: {$listkeys2}} data success..." );
	}
	private function LoadLuckdraw() {
		$row = $this->mysql->find ( "SELECT * FROM `luckdraw` Where `status`>0 order by sortInd" );
		// $resArr = array();
		foreach ( $row as $g ) {
			$goods ["awardType"] = ( int ) $g ["awardType"];
			$goods ["amount"] = ( int ) $this->randAmount ( $g ["amount"] );
			$goods ["userTypeProb"] = $g ["userTypeProb"];
			$goods ["sortInd"] = ( int ) $g ["sortInd"];
			$goods ["desp"] = $g ["desp"];
			$goods ["extId"] = $g ["extId"];
			$goods ["noticeMsg"] = $g ["noticeMsg"];
			$resArr [] = $goods;
		}
		if (sizeof ( $resArr ) > 0) {
			$this->cache_redis->set ( "sluckdraw", json_encode ( $resArr ) );
		}
		$listkeys = $this->cache_redis->get ( "sluckdraw" );
		echo "LoadLuckdraw {lltp: {$listkeys}} data success...<br>";
//		$this->i ( "LoadLuckdraw {lltp: {$listkeys}} data success..." );
	}
	private function randAmount($amountArr) {
		$amoutArr = explode ( ",", $amountArr );
		$arrLen = sizeof ( $amoutArr );
		if ($arrLen == 1) {
			return $amoutArr [0];
		}
		$rand = mt_rand ( 0, $arrLen - 1 );
		return $amoutArr [$rand];
	}
	private function LoadLoginreward() {
		$row = $this->mysql->find ( "SELECT * FROM `loginreward` order by id" );
		$this->clear ( array (
				"hlr:*",
				"llr:ids" 
		) );
		foreach ( $row as $g ) {
			$id = $g ['id'];
			$this->cache_redis->rPush ( "llr:ids", $id );
			$this->cache_redis->hMset ( "hlr:{$id}", $g );
		}
		$hkeys = count ( $this->cache_redis->keys ( "hlr:*" ) );
		$listkeys = count ( $this->cache_redis->lRange ( "llr:ids", 0, - 1 ) );
		echo "LoadLoginreward {llr: {$hkeys}, hlr: {$listkeys}} data success...<br>";
//		$this->i ( "LoadLoginreward {llr: {$hkeys}, hlr: {$listkeys}} data success..." );
	}
	
	private function LoadMessage() {
		$row = $this->mysql->find ( "SELECT * FROM `announcement` WHERE `status`=1 ORDER BY `create_time` DESC LIMIT 0, 5" );
		$this->clear ( array (
				"hmess:*",
				"smesslist" 
		) );
		
		foreach ( $row as $g ) {
			$id = $g ['id'];
			$message ['mid'] = ( int ) $g ['id'];
			$message ['date'] = ( int ) $g ['create_time'];
			$message ['title'] = $g ['title'];
			$message ['content'] = $g ['content'];
			$resArr [] = $message;
			$this->cache_redis->hMset ( "hmess:{$id}", $g );
		}
		$this->cache_redis->set ( "smesslist", json_encode ( $resArr ) );
		$listkeys2 = $this->cache_redis->get ( "smesslist" );
		$keys = count ( $this->cache_redis->keys ( "hmess:*" ) );
		echo "LoadMessage {ha: {$keys},llt: {$listkeys2}} data success...<br>";
//		$this->i ( "LoadMessage {ha: {$keys},llt: {$listkeys2}} data success..." );
	}
	private function LoadAnnouncement() {
		$row = $this->mysql->find ( "SELECT * FROM `announcement` WHERE `status`=1 and `type`=0 ORDER BY `id` DESC LIMIT 0, 1" );
		$this->clear ( array (
				"hannounc" 
		) );
		// var_dump($row);
		$this->cache_redis->hMset ( "hannounc", $row [0] );
		$keys = count ( $this->cache_redis->keys ( "hannounc" ) );
		echo "LoadAnnouncement {ha: {$keys}} data success...<br>";
//		$this->i ( "LoadAnnouncement {ha: {$keys}} data success..." );
	}
	private function LoadGoods() {
		/*
		 * [{"tp":1,"pt":[ {"rmb":2,"mon":20000,"coin":2},{"rmb":5,"mon":50000,"coin":5},{"rmb":10,"mon":100000,"coin":10},{"rmb":20,"mon":200000,"coin":20},{"rmb":30,"mon":300000,"coin":30}]}, {"tp":2,"pt":[ {"rmb":2,"mon":20000,"coin":2},{"rmb":5,"mon":50000,"coin":5},{"rmb":10,"mon":100000,"coin":10},{"rmb":20,"mon":200000,"coin":20},{"rmb":30,"mon":300000,"coin":30}]}, {"tp":3,"pt":[ {"rmb":2,"mon":20000,"coin":2},{"rmb":5,"mon":50000,"coin":5},{"rmb":10,"mon":100000,"coin":10},{"rmb":20,"mon":200000,"coin":20},{"rmb":30,"mon":300000,"coin":30}]} ]
		 */
		$tp_max = 0;
		$r0 = $this->mysql->find ( "select max(pay_type) as pay_type from pay_sdk" );
		foreach ( $r0 as $g ) {
			$tp_max = ( int ) $g ['pay_type'];
		}
		
		$sql = "select a.hot,a.pay_type, b.rmb, b.money,b.coin,b.a, b.b from pay_sdk a join pay_points b on a.id=b.pay_sdk_id where b.goods_type=0 group by a.pay_type, b.rmb,b.money,b.coin,b.a,b.b order by a.pay_type, b.rmb";
		$row = $this->mysql->find ( $sql );
		$this->clear ( array (
				"hg:*",
				"sgoods" 
		) );		
		$pay = array ();
		for($tp = 1; $tp <= $tp_max; $tp ++) {
			$hot = 0;
			$pay [$tp - 1] ["tp"] = $tp;
			$arr = array ();
			$i = 0;
			foreach ( $row as $g ) {
				$pt = ( int ) $g ['pay_type'];
				if ($tp == $pt) {
					if (( int ) $g ['hot'] > 0) {
						$hot = ( int ) $g ['hot'];
					}
					
					$rmb = ( int ) $g ['rmb'];
					$mon = ( int ) $g ['money'];
					$coin = ( int ) $g ['coin'];
					// $sdk = ( int ) $g ['sdk'];
					$goods = array ();
					$goods ["rmb"] = $rmb;
					$goods ["mon"] = $mon;
					$goods ["coin"] = $coin;
					$goods ["a"] = ( int ) $g ['a'];
					$goods ["b"] = ( int ) $g ['b'];
					
					$arr [$i] = $goods;					
					$this->cache_redis->hMset ( "hg:{$pt}{$rmb}", $g );
					
					$i ++;
				}
			}
			if (count ( $arr ) > 0) {
				$pay [$tp - 1] ["pt"] = $arr;
			}
			$pay [$tp - 1] ["hot"] = $hot;
		}
		
		$json_str = json_encode ( $pay );
		
		$this->cache_redis->set ( "sgoods", $json_str );
		$hkeys = count ( $this->cache_redis->keys ( "hg:*" ) );
		$listkeys = $this->cache_redis->get ( "sgoods" );
// 		echo "LoadGoods {hkeys: {$hkeys},sgoods: {$listkeys} data success...<br>";
//		$this->i ( "LoadGoods {hkeys: {$hkeys},sgoods: {$listkeys} data success..." );
		$this->LoadChannelPayInfo ();
		// 20150620新版商城
		$this->LoadPayItem ();
	}
	
	private function LoadPropItem() {
		$sql = "select * from prop_info";
		$row = $this->mysql->find ( $sql );
		$this->clear ( array (
				"buyGoods:*"
		) );

		$pay = array ();
		if (sizeof ( $row ) > 0) {
			foreach ( $row as $d ) {
				$item = array();				
				$item['buyType'] = 0;	// 0：金币购买，1：rmb购买
				$item['cNum'] = (int)$d['buymoney'];
				$item['gName'] = $d['name'];
				$item['gDesc'] = isset($d['desc'])?$d['desc']:'';
				$item['gMoney'] = 0;
				$item['gType'] = 1;		// 0：金币商品，1：道具商品
				$item['gId'] = (int)$d['id'];
				$item['gCoin'] = 0;
				$item['isHot'] = (int)$d['ishot']; // 是否热销:0,NO;1，热销；2，超值
				$item['pt'] = '';
				$pay[] = $item;
				$this->cache_redis->hMset ( "buyGoods:{$d['id']}", $d );
			}			
		}
		return $pay;			
	}
	
	private function LoadPayItem() {
		$sqlbaseinfo = "select a.pay_type, b.rmb, b.money,b.coin,b.a, b.b,b.goods_type,b.goods_id,b.point_name,b.desp from pay_sdk a join pay_points b on a.id=b.pay_sdk_id group by a.pay_type, b.rmb,b.money,b.coin,b.a,b.b order by b.rmb, b.money";
		$rowBase = $this->mysql->find ( $sqlbaseinfo );		
		
		$sql = "select * from pay_sdk_channel";
		$row = $this->mysql->find ( $sql );
		$this->clear ( array (
				"sgoods_pkg:*"
		) );
// 		var_dump($rowBase);
		// 金币购买道具类商品
		$propArr = $this->LoadPropItem ();
		if (sizeof ( $row ) > 0) {
			$inc = 0;
			foreach ( $row as $g ) {
				$payMoney = array ();
				$payProp = array ();
				$itemMoney = array ();
				$itemProp = array();
				$tempProp = array();
				$pt = array ();
				$pkg = $g ['pkg'];
				$pt_list = $g ['pt_list'];
				$pt_arr = explode ( ",", $pt_list );
				
				if (sizeof ( $pt_arr ) > 0) {
					foreach ( $rowBase as $d ) {
						if (in_array ( $d['pay_type'], $pt_arr )) {
							if($d['goods_type']==0){		// RMB购买金币类商品
								$this->getPayItem($payMoney,$itemMoney,$d);
							}elseif ($d['goods_type']==1){	// 	RMB购买道具类商品
								$this->getPayItem($payProp,$itemProp,$d);
							}
						}
					}
				}
				if(sizeof($itemMoney)>0){
				    $payMoney[] = $itemMoney;
				}
				if(sizeof($itemProp)>0){
				    $payProp[] = $itemProp;
				}	
				if(!(sizeof($payProp)<=0 && sizeof($propArr)<=0)){
				    $tempProp = array_merge($payProp,$propArr);
				}
				
 				$pay ['money'] = $payMoney;
 				$pay ['prop'] = $tempProp; 				
				$json_str = json_encode ( $pay );
				$this->cache_redis->set ( "sgoods_pkg:" . $pkg, $json_str );
				echo "pkg:" . $pkg . "," . $json_str . "<br/>"; 
			}
		}
		$this->cache_redis->set ( "data_seqId" , time() );
	}
	
	private function getPayItem(&$pay,&$item,$d){
		// 	echo 'bbb:'.$d['pay_type'].':'.$d['rmb'].'<br/>';
		if($this->has_item($item,$d['rmb'])){
			$pt['tp'] = (int)$d['pay_type'];
// 			$pt['gMoney'] = (int)$d['money'];
			$pt['ratio'] = ceil(($d['money']-$item['gMoney'])*100/$item['gMoney']);
			$item['pt'][] = $pt;
		}else{
			if(sizeof($item)>0){
				$pay [] = $item;
			}
			// 	var_dump($item);
			$item = array();
			$item['buyType'] = 1;
			$item['cNum'] = (int)$d['rmb'];
			$item['gMoney'] = (int)$d['money'];
// 			$item['gType'] = (int)$d['goods_type'];
			$item['gId'] = (int)$d['goods_id'];
			$item['gCoin'] = (int)$d['coin'];
			$item['gName'] = $d['point_name'];
			$item['gDesc'] = isset($d['desp'])?$d['desp']:'';;
			
			// 是否热销:0,NO;1，热销；2，超值
			if($d['a']==1){
				$item['isHot'] = 2;
			}elseif ($d['b']==1){
				$item['isHot'] = 1;
			}else{
				$item['isHot'] = 0;
			}
			$pt['tp'] = (int)$d['pay_type'];
			$pt['ratio'] = 0;
			$item['pt'][] = $pt;
		}
	}
	private function has_item($item,$currRmb){
		if(sizeof($item)<=0){
			return false;
		}
		if($item['cNum']==$currRmb){
			return true;
		}
		return false;
	}
	
	private function LoadChannelPayInfo() {
		$sql = "select * from pay_sdk_channel";
		$row = $this->mysql->find ( $sql );
		$this->clear ( array (
				"sgoods_channel:*" 
		) );
		
		$listkeys = $this->cache_redis->get ( "sgoods" );
		$arr = json_decode ( $listkeys );
		
		if (sizeof ( $row ) > 0) {
			foreach ( $row as $g ) {
				$pay = array ();
				$pkg = $g ['pkg'];
				$pt_list = $g ['pt_list'];
				$pt_arr = explode ( ",", $pt_list );
				if (sizeof ( $pt_arr ) > 0) {
					foreach ( $arr as $d ) {
						if (in_array ( $d->tp, $pt_arr )) {
							$pay [] = $d;
						}
					}
				}
				$json_str = json_encode ( $pay );
				$this->cache_redis->set ( "sgoods_channel:" . $pkg, $json_str );
				echo "pkg:" . $pkg . "," . $json_str . "<br/>";
			}
		}
	}
	private function LoadAward() {
		$row = $this->mysql->find ( "SELECT * FROM `award` order by sortId desc" );
		$this->clear ( array (
				"haw:*",
				"sAwardV18", 	// 版本18之前的数据
				"sAwardV19",	// 版本19的数据
				"sAwardV20" 	// 版本20之后的数据
		) );
		$awardesV18 = array ();
		$awardesV19 = array ();
		$awardesV20 = array ();
		foreach ( $row as $item ) {
			$aw["i"] = (int)$item["id"];
			$aw["ss"] = (int)$item["status"];
			$aw["t"] = (int)$item["type"];
			$aw["c"] = (int)$item["coin"];
			$aw["na"] = $item["name"];
			$aw["im"] = $item["imag"];
			$aw["nu"] = (int)$item["num"];
			$aw["dc"] = $item["desc"];
			$aw["st"] = (int)$item["start_time"];
			$aw["et"] = (int)$item["end_time"];
			$aw["ad"] = (int)$item["awardnum"];
			
			if ($aw ['ss'] == 0) {
				$awardesV18[] = $aw;
			} elseif ($aw ['ss'] == 1) {
				$awardesV19[] = $aw;
			}
			if($aw ['ss'] > 0){
				$awardesV20[] = $aw;
			}
			$this->cache_redis->hMset ( "haw:{$aw ['i']}", $aw );
		}
		$this->cache_redis->set ( "sAwardV18", json_encode ( $awardesV18 ) );
		$this->cache_redis->set ( "sAwardV19", json_encode ( $awardesV19 ) );
		$this->cache_redis->set ( "sAwardV20", json_encode ( $awardesV20 ) );
		
		$hkeys = count ( $this->cache_redis->keys ( "haw:*" ) );
		$listkeys = $this->cache_redis->get ( "sAwardV18");
		$listkeys0 = $this->cache_redis->get ( "sAwardV19");
		$listkeys1 = $this->cache_redis->get ( "sAwardV20");
		echo "LoadAward {all: {$hkeys}, V18: {$listkeys}, V19: {$listkeys0}}, V20: {$listkeys1}} data success...<br>";
//		$this->i ( "LoadAward {all: {$hkeys}, old: {$listkeys}, coin: {$listkeys1}} data success..." );
	}
	
	private function LoadRank() {
		$row = $this->mysql->find ( "SELECT * FROM `rank` ORDER BY `type`,`no`" );
		$this->clear ( array (
				"hr:*",
				"lr:ids" 
		) );
		foreach ( $row as $r ) {
			$id = $r ['id'];
			$this->cache_redis->rPush ( "lr:ids", $id );
			$this->cache_redis->hMset ( "hr:{$id}", $r );
		}
		$hkeys = count ( $this->cache_redis->keys ( "hr:*" ) );
		$listkeys = count ( $this->cache_redis->lRange ( "lr:ids", 0, - 1 ) );
		echo "LoadRank {lr: {$hkeys}, hr: {$listkeys}} data success...<br>";
//		$this->i ( "LoadRank {lr: {$hkeys}, hr: {$listkeys}} data success..." );
	}
	private function loadGift() {
		$row = $this->mysql->find ( "SELECT * FROM `gifts`" );
		$this->clear ( array (
				"hgift:*" 
		) );
		foreach ( $row as $r ) {
			$id = $r ['gift_id'];
			$this->cache_redis->hMset ( "hgift:{$id}", $r );
		}
		$hkeys = count ( $this->cache_redis->keys ( "hgift:*" ) );
		
		$tmp = "loadGift {count: {$hkeys}} data success...<br>";
		echo $tmp;
//		$this->i ( $tmp );
	}
	
	/**
	 * 话费防刷的用户黑名单数据
	 */
	private function LoadBlackPay() {
		
		// 清除过期key		
		$all_keys = $this->cache_redis->keys('blackpay:*');
		foreach($all_keys as $tmp) {
			$arrtm = $this->cache_redis->hMget ($tmp , array("tm","lastm"));
			if ($arrtm['tm']) {
				$tm = strtotime ( $arrtm['tm'] ) ;
				$lastm = isset($arrtm['lastm']) ? strtotime($arrtm['lastm']) : 0;				
				if ($tm < strtotime("-2 month")) {
					$this->cache_redis->del ( $tmp );
				}
				else if ($tm < strtotime("-1 month") && $lastm == 0) {
					$this->cache_redis->del ( $tmp );
				}
			}
			else {
				$this->cache_redis->del ( $tmp );
			}
		}
		
		$sql = "SELECT limit_key,limit_value,day_rmb,month_rmb FROM pay_limit WHERE create_time > CURDATE()";
		$row = $this->mysql->find ( $sql );	
		$arr = array ();
		foreach ( $row as $r ) {
			$arr ["day_rmb"] = $r ['day_rmb'];
			$arr ["month_rmb"] = $r ['month_rmb'];
			$arr ["dsum"] = 0;
			$arr ["msum"] = 0;
			$arr ["tm"] = date ( "Y-m-d H:i:s", time () );
			$key = "blackpay:{$r ['limit_key']}:{$r ['limit_value']}";
			$this->cache_redis->hMset ($key , $arr );
		}
		
		$str = json_encode($arr);
		echo $str;
		 
//		$this->i ( "LoadBlackListPay {$str} data success..." );
	}
	private function loadVenue() {
		$row = $this->mysql->find ( "SELECT * FROM `venue` WHERE status > 0 " );
		$this->clear ( array (
				"svelist",			// 旧的场馆列表
				"sveFightlist",		// 加入了比赛场的列表
				"sveMultlist",		// 百人场
				"svePrivatelist"	// 私人场
		) );
		$awardes = array ();
		$awardes1 = array ();
		$inc = 0;
		foreach ( $row as $g ) {
			$venue = array();
			$venue ['vid'] = ( int ) $g ['vid'];
			$venue ['ip'] = $g ['ip'];
			$venue ['port'] = ( int ) $g ['port'];
			$venue ['base_money'] = ( int ) $g ['base_money'];
			$venue ['money'] = array ();
			$venue ['money'] [0] = ( int ) $g ['min_money'];
			$venue ['money'] [1] = ( int ) $g ['max_money'];
				
			/* $venue ['gt'] = ( int ) $g ['game_type'];
			$venue ['vt'] = ( int ) $g ['vtype'];
			$venue ['pcheat'] = ( int ) $g ['is_pcheat'];
				
			$venue ['vip'] = ( int ) $g ['vip_limit']; */
				
			$venue ['maxbet'] = ( int ) $g ['ratio_max'];
			// 8 为五小牛的牌型倍数
			$venue ['maxget'] = ( int ) $g ['ratio_max'] * ( int ) $g ['base_money'] * 8;
				
			/* $venue ['online'] = array ();
			$venue ['online'] [0] = ( int ) $g ['online_lower'];
			$venue ['online'] [1] = ( int ) $g ['online_upper']; */
				
			$st = ( int ) $g ['status'];
			if ($st == 1) {
				$awardes [] = $venue;
			} elseif ($st == 2) {
				$venue ['rpvid'] = ( int ) $g ['rpid'];
				$awardes1 [] = $venue;
			} elseif ($st == 3) {
				$awardes2 = $venue;
			}elseif ($st == 4) {
			    $venue['baseList'] = Game::$priv_config;
				$awardes3 = $venue;
			}
			$this->cache_redis->hMset ( "hv:{$g['vid']}", $g );
			$inc ++;
		}
	
		$this->cache_redis->set ( "svelist", json_encode ( $awardes ) );
		$this->cache_redis->set ( "sveFightlist", json_encode ( $awardes1 ) );
		if(isset($awardes2)){
			$this->cache_redis->set ( "sveMultlist", json_encode ( $awardes2 ) );
		}
		if(isset($awardes3)){
			$this->cache_redis->set ( "svePrivatelist", json_encode ( $awardes3 ) );
		}		
		$listkeys = $this->cache_redis->get ( "svelist" );
		$listkeys1 = $this->cache_redis->get ( "sveFightlist" );
		$listkeys2 = $this->cache_redis->get ( "sveMultlist" );
		$listkeys3 = $this->cache_redis->get ( "svePrivatelist" );
		echo "loadVenue {count: {$inc},sg: {$listkeys},sgn: {$listkeys1}},mult: {$listkeys2}},mult: {$listkeys3}} data success...<br>";
//		$this->i ( "loadVenue {count: {$inc},sg: {$listkeys},sgn: {$listkeys1}} data success..." );
	}
	
	/**
	 * 缓存MM支付参数 pay_special_value
	 */
	private function LoadPaySpecialValue() {
		$row = $this->mysql->find("SELECT * FROM pay_special_value ");
		$this->clear(array("smmparams"));
		foreach ($row as $g) {
			$goods["id"] = (int)$g['id'];
			$goods["channel"] = empty($g["channel"]) ? "" : $g["channel"]  ;
			$goods["sh"] = empty($g["sh"]) ? "" : $g["sh"]  ;
			$goods["s5"] = empty($g["s5"]) ? "" : $g["s5"]  ;
			$goods["pdi"] = empty($g["pdi"]) ? "" : $g["pdi"]  ;
			$goods["sg"] = empty($g["sg"]) ? "" : $g["sg"]  ;
			$goods["aey"] = empty($g["aey"]) ? "" : $g["aey"]  ;
			$goods["spcode"] = empty($g["spcode"]) ? "" : $g["spcode"]  ;
			$goods["tag"] = empty($g["tag"]) ? "" : $g["tag"]  ; 
			
			$resArr[] = $goods;
		}
		$this->cache_redis->set("smmparams",json_encode($resArr));
		$listkeys2 = $this->cache_redis->get("smmparams");
		echo "LoadPaySpecialValue {llt: {$listkeys2}} data success...<br>";
		$this->i("LoadPaySpecialValue {llt: {$listkeys2}} data success...");
	}
	
	public function after() {
		$this->deinitCacheRedis ();
		$this->deinitMysql ();
	}
}
?>