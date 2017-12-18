<?php
    class InitCache extends APIBase {

		public $tag = "InitCache";
		public $isLogin = false;
		public $RANK_TYPE_MONEY = 0;
		public $RANK_TYPE_LEVEL = 1;
		public $RANK_TYPE_EXP = 2;

		public function before() {
			$this->initMysql();
			$this->initMysqlSlave();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!(isset($this->param['pass']) && $this->param['pass'] == Config::$cache_pass)) {
				$this->returnError(300, "password is error.");
			}

			$flag = false;
			if (isset($this->param['all']) && $this->param['all'] == 1) {
				$flag = true;
			}

			if ($flag || (isset($this->param['venue']) && $this->param['venue'] == 1)) {
				$this->loadVenue();
			}
			
			if ($flag || (isset($this->param['announcement']) && $this->param['announcement'] == 1)) {
				$row = $this->mysql->find("SELECT distinct channel FROM `announcement`");
				$this->clear(array("hannounc:*"));
				$this->clear(array("hmess:*","smesslist:*"));
				foreach ($row as $item){
					echo "chnnnn:".$item['channel']."<br/>";
					$this->LoadAnnouncement($item['channel']);
					$this->LoadMessage($item['channel']);
				}
			}

			if ($flag || (isset($this->param['goods']) && $this->param['goods'] == 1)) {
				$this->LoadGoods();
			}
			
			if ($flag || (isset($this->param['goodsInfo']) && $this->param['goodsInfo'] == 1)) {
				$this->LoadGoodsInfo();
			}
			
			if ($flag || (isset($this->param['award']) && $this->param['award'] == 1)) {
				$this->LoadAward();
			}

			if ($flag || (isset($this->param['rank']) && $this->param['rank'] == 1)) {
				$this->LoadRank();
			}
			if ($flag || (isset($this->param['lottery']) && $this->param['lottery'] == 1)) {
				$this->LoadLottery();
				$this->LoadLuckdraw ();
			}
			if ($flag || (isset($this->param['robot']) && $this->param['robot'] == 1)) {
				$this->LoadRobot();
			}
			if ($flag || (isset($this->param['loginreward']) && $this->param['loginreward'] == 1)) {
				$this->LoadLoginreward();
			}
			if ($flag || (isset($this->param['tasks']) && $this->param['tasks'] == 1)) {
				$this->LoadTasks();
			}
			if ($flag || (isset($this->param['tasksday']) && $this->param['tasksday'] == 1)) {
				$this->LoadTasksDay();
			}
			if ($flag || (isset($this->param['notice']) && $this->param['notice'] == 1)) {
				$this->LoadNotice();
			}
			if ($flag || (isset($this->param['slot']) && $this->param['slot'] == 1)) {
				$this->LoadSlot();
			}
			if ($flag || (isset($this->param['initrobot']) && $this->param['initrobot'] == 1)) {
				$this->LoadInitRobot();
			}
			if ($flag || (isset($this->param['activity']) && $this->param['activity'] == 1)) {
				$this->LoadActivity();
			}
			if ($flag || (isset($this->param['activityrank']) && $this->param['activityrank'] == 1)) {
				$this->LoadActivityRank();
			}
			if ($flag || (isset($this->param['synRechargeRank']) && $this->param['synRechargeRank'] == 1)) {
				$this->LoadRechargeRank();
			}
			if ($flag || (isset($this->param['payrule']) && $this->param['payrule'] == 1)) {
				$this->LoadPayrule();
			}
			if ($flag || (isset($this->param['apps']) && $this->param['apps'] == 1)) {
				$this->LoadApps();
			}
			if ($flag || (isset($this->param['vips']) && $this->param['vips'] == 1)) {
				$this->LoadVips();
			}
			if ($flag || (isset($this->param['resetpact']) && $this->param['resetpact'] == 1)) {
				$this->initDataRedis(1000);
				$keys = $this->data_redis->keys("hpe:*");
				$inc = 0;
				foreach ($keys as $key) {
//  					$this->data_redis->hDel($key,"actWinMonDay","actWinMonTot","actWinMoney","actBoardWin","actRatio");
					$this->data_redis->hDel($key,"actRatio");
					$inc++;
				}
				echo $inc;
			}
			if (isset($this->param['uplogindate']) && $this->param['uplogindate'] == 1 &&
				isset($this->param['date']) && isset($this->param['uid'])) {						
				$ts = strtotime(date($this->param['date']));
				$this->initDataRedis(1000);
				$this->data_redis->hSet("hu:{$this->param['uid']}", 'update_time',$ts-600);
				echo $this->param['date'];							
			}
			if (isset($this->param['upvipdate']) && $this->param['upvipdate'] == 1 &&
					isset($this->param['date']) && isset($this->param['uid'])) {
				$ts = strtotime(date($this->param['date']));
				$this->initDataRedis(1000);
				$this->data_redis->hSet("hpe:{$this->param['uid']}", 'vipenddate',$ts);
				echo $this->param['date'];
			}
/*			if($flag || (isset($this->param['initver']) && $this->param['initver'] == 1)){
				$row = $this->mysql->find("SELECT * FROM `playermark` where cur_ver=11");
				$this->initDataRedis(1000);
				if (sizeof($row)>0) {
					foreach ($row as $g) {
						$hu = $this->data_redis->hMget("hpe:{$g['uid']}",array("cur_ver","11"));
					}
					echo "size:".sizeof($row);
				}
				
			}
 			if ($flag || (isset($this->param['synpext']) && $this->param['synpext'] == 1)) {
				$this->LoadSynPExt(1,10000);				
			}
			if (isset($this->param['rout']) && isset($this->param['id']) && $this->param['rout'] == 1) {
				$this->cache_redis->hSet("srout","id",$this->param['id']);
				$arr = $this->cache_redis->hGet("srout","id");
				echo "round task id is:".$arr;
			} */
			// 签到
			if ($flag || (isset ( $this->param ['signin'] ) && $this->param ['signin'] == 1)) {
				$this->LoadSignIn ();
			}
			if ($flag || (isset ( $this->param ['gift'] ) && $this->param ['gift'] == 1)) {
				$this->loadGift ();
			}
			if ($flag || (isset ( $this->param ['marquee'] ) && $this->param ['marquee'] == 1)) {
				$this->LoadMarquee ();
			}// 更多游戏
			if ($flag || (isset ( $this->param ['moregame'] ) && $this->param ['moregame'] == 1)) {
				$this->LoadMoregame ();
			}
			if ($flag || (isset ( $this->param ['platform'] ) && $this->param ['platform'] == 1)) {
				$this->LoadPlatform ();
			}
			if ($flag || (isset($this->param['match']) && $this->param['match'] == 1)) {
				$this->loadMatchInfo();
			}
			if ($flag || (isset($this->param['cupoint']) && $this->param['cupoint'] == 1)) {
				$this->loadCuPointInfo();
			}
		}
		
		private function loadCuPointInfo() {
			$row = $this->mysql->find ( "SELECT * FROM `cu_points` " );
			$this->clear ( array (
					"cupoint:*"
			) );
			$inc = 0;
			foreach ( $row as $g ) {
				$this->cache_redis->set ( "cupoint:".$g['fee'], $g['point'] );
				$inc++;
			}
			echo "loadCuPointInfo {lltp: {$inc}} data success...<br>";
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
		private function LoadVips() {
			$row = $this->mysql->find("SELECT * FROM `vips` order by id");
			$this->clear(array("svips"));
			foreach ($row as $g) {
				$goods["id"] = (int)$g['id'];
				$goods["name"] = $g["name"];
				$goods["days"] = (int)$g["days"];
				$goods["rmb"] = (int)$g["rmb"];
				$goods["gid"] = (int)$g["gid"];
				$goods["money"] = (int)$g["give_money"];
				
				$goods["sdk"] = $g["sdk"];
				
				$resArr[] = $goods;
			}
			// 			var_dump($resArr);
			$this->cache_redis->set("svips",json_encode($resArr));
			$listkeys2 = $this->cache_redis->get("svips");
			echo "LoadVips {llt: {$listkeys2}} data success...<br>";
// 			$this->i("LoadVips {llt: {$listkeys2}} data success...");
		}
		
		private function LoadApps() {						
			$row = $this->mysql->find("SELECT * FROM `apps`");	
			$this->clear(array("sapps"));
			foreach ($row as $g) {
				$goods["id"] = (int)$g['id'];
				$goods["appName"] = $g["appName"];
				$goods["package"] = $g["package"];
				$goods["ver_last"] = (int)$g["ver_last"];
				$goods["ver"] = $g["ver"];
				$goods["memo"] = $g["memo"];
				$goods["award"] = $g["extmemo"];
				$resArr[] = $goods;
			}
			$this->cache_redis->set("sapps",json_encode($resArr));
			$listkeys2 = $this->cache_redis->get("sapps");
			echo "LoadApps {llt: {$listkeys2}} data success...<br>";
// 			$this->i("LoadApps {llt: {$listkeys2}} data success...");
			
			$row = $this->mysql->find("SELECT * FROM `app_modules`");
			$this->clear(array("sappmodules"));
			foreach ($row as $g) {
				$goods1["id"] = (int)$g['id'];
				$goods1["module_id"] = $g["module_id"];
				$goods1["type_id"] = (int)$g["type_id"];
				$goods1["type_value"] = $g["type_value"];
				$goods1["closed"] = (int)$g["closed"];
				// MM审核标记，还原计费点未正常值
				if($goods1 ["type_value"]=='000000000000' && $goods1 ["module_id"]=='shop'){
					$this->cache_redis->set ( "smm_audit", $goods1 ["closed"] );
				}
				$resArr1[] = $goods1;
			}
			$this->cache_redis->set("sappmodules",json_encode($resArr1));
			$listkeys1 = $this->cache_redis->get("sappmodules");
			echo "LoadAppmodules {llt: {$listkeys1}} data success...<br>";
// 			$this->i("LoadAppmodules {llt: {$listkeys1}} data success...");
		}
		
		private function LoadPayrule() {
			$row = $this->mysql->find("SELECT * FROM `payrule`");
			$this->clear(array("spayrule"));
			foreach ($row as $g) {
				$goods["id"] = (int)$g['id'];
				$goods["op"] = $g["op"];
				$goods["type_id"] = (int)$g["type_id"];
				$goods["type_value"] = $g["type_value"];
				$goods["sdk"] = $g["sdk"];
				$resArr[] = $goods;
			}
			$this->cache_redis->set("spayrule",json_encode($resArr));
			$listkeys2 = $this->cache_redis->get("spayrule");
			echo "LoadPayrule {llt: {$listkeys2}} data success...<br>";
// 			$this->i("LoadPayrule {llt: {$listkeys2}} data success...");
		}
		
		private  function clear($regex) {
			foreach ($regex as $re) {
				$keys = $this->cache_redis->keys($re);
				foreach ($keys as $key) {
					$this->cache_redis->del($key);
				}
			}
		}
		
		private function LoadRechargeRank() {
			$ss = strtotime(date("Y-m-d"));
			$this->initDataRedis(1000);
			$row = $this->mysql->find("select uid,sum(rmb) as rmb from goodslog where create_time>".$ss." group by uid order by rmb desc limit 15");
			$inc = 1;
			foreach ($row as $g) {
				$hu = $this->data_redis->hMget("hu:{$g['uid']}",array("name","sex"));
				if(!isset($hu['name']) || empty($hu['name'])){
					$tt = $this->mysql->find("SELECT name,sex FROM `player` where id=".$g['uid']);
					if(empty($tt) || sizeof($tt)<=0){
						continue;
					}
					$goods["na"] = $tt[0]['name'];
					$goods["s"] = (int)$tt[0]['sex'];
				}else{
					$goods["na"] = $hu['name'];
					$goods["s"] = (int)$hu['sex'];
				}
				$goods["no"] = $inc;
				$goods["u"] = (int)$g['uid'];
				$goods["am"] = (int)$g['rmb'];
				$resArr[] = $goods;
				$inc++;
			}
// 			var_dump($resArr);
			if(!empty($resArr) && sizeof($resArr)>0){
				$this->cache_redis->set("sRechargeRank",json_encode($resArr));
			}			
			echo "LoadRechargeRank {ct:{$ss},inc: {$inc}} data success...<br>";
// 			$this->i("LoadRechargeRank {ct:{$ss},inc: {$inc}} data success...");
		}
		
		private function LoadActivityRank() {			
			$this->initDataRedis(1000);
			$prizeStr = $this->cache_redis->get("activitylist");
			if(!$prizeStr){
				return;
			}
			$prizeArr = json_decode($prizeStr);
			foreach ($prizeArr as $g) {
				if($g->at==0){
					//日赚金币榜
					$row = $this->mysql->find("select * from `temp_rankactivity` order by monday desc limit 15");
					$this->initActivityRank($row,$g->id,"monday");
				}elseif ($g->at==1){
					//总赚金币榜
					$row = $this->mysql->find("select * from `temp_rankactivity` order by montot desc limit 15");
					$this->initActivityRank($row,$g->id,"montot");
				}elseif ($g->at==2){
					//日最高倍率榜
					$row = $this->mysql->find("select * from `temp_rankactivity` order by maxratio desc,boardwin desc limit 15");
					$this->initActivityRank($row,$g->id,"maxratio");
				}elseif ($g->at==3){
					//日最高赢局榜
					$row = $this->mysql->find("select * from `temp_rankactivity` order by boardwin desc limit 15");
					$this->initActivityRank($row,$g->id,"boardwin");
				}elseif ($g->at==4){
					//日单局赚金币榜
					$row = $this->mysql->find("select * from `temp_rankactivity` order by maxwinmoney desc,boardwin desc limit 15");
					$this->initActivityRank($row,$g->id,"maxwinmoney");
				}
			}			
		}
		
		private function initActivityRank($row,$aid,$akey){
			$inc = 1;
			$resArr = array();
			foreach ($row as $g) {
				$hu = $this->data_redis->hMget("hu:{$g['uid']}",array("name","sex"));
				if(!isset($hu['name']) || empty($hu['name'])){
					$row = $this->mysql->find("SELECT * FROM `player` where id=".$g['uid']);
					$goods["na"] = $row[0]['name'];
					$goods["s"] = (int)$row[0]['sex'];
				}else{
					$goods["na"] = $hu['name'];
					$goods["s"] = (int)$hu['sex'];
				}
				$goods["no"] = $inc;
				$goods["u"] = (int)$g['uid'];
				$goods["am"] = (int)$g[$akey];
				$resArr[] = $goods;
				$inc++;
			}
// 			var_dump($resArr);
			$this->cache_redis->set("activityrank:{$aid}",json_encode($resArr));
			echo "LoadActivityRank {activityID:$aid,inc: {$inc}} data success...<br>";
// 			$this->i("LoadActivityRank {activityID:$aid,inc: {$inc}} data success...");
		}
		
		private function LoadActivity() {
			$row = $this->mysql->find("SELECT * FROM `activityconf` order by id");			
			foreach ($row as $g) {
				$goods["id"] = (int)$g['id'];
				$goods["at"] = (int)$g['atype']; 
				$goods["ty"] = (int)$g['type'];/*
				$goods["tit"] = $g["title"];
				$goods["cont"] = $g["content"]; */
				$goods["st"] = (int)$g["start_time"];
				$goods["et"] = (int)$g["end_time"];
				$resArr[] = $goods;
			}
			$this->cache_redis->set("activitylist",json_encode($resArr));
			$listkeys = $this->cache_redis->get("activitylist");
			echo "LoadActivity {llt: {$listkeys}} data success...<br>";
// 			$this->i("LoadActivity {llt: {$listkeys}} data success...");
		}
		
		private function LoadSynPExt($start,$end) {
			$this->initDataRedis(1000);
			$inc = 0;
			for($i=$start;$i<$end;$i++) {
				$pe = $this->data_redis->hGetAll("hpe:{$i}");
				if(!empty($pe) && isset($pe['uid'])){
					$player_ext = array();
					$player_ext['uid'] = $pe['uid'];
					$player_ext['lastLotteryDate'] = isset($pe['lastLotteryDate'])?$pe['lastLotteryDate']:0;
					$player_ext['lastPrizeDate'] = isset($pe['lastPrizeDate'])?$pe['lastPrizeDate']:0;
					$player_ext['lastDayTaskDate'] = isset($pe['lastDayTaskDate'])?$pe['lastDayTaskDate']:0;
					$player_ext['currLotteryNum'] = isset($pe['currLotteryNum'])?$pe['currLotteryNum']:0;
					$player_ext['hasRecharge'] = isset($pe['hasRecharge'])?$pe['hasRecharge']:0;
					$player_ext['telCharge'] = isset($pe['telCharge'])?$pe['telCharge']:0;
					$player_ext['mob'] = isset($pe['mob'])?$pe['mob']:0;
					$player_ext['updatedate'] = date('Y-m-d H:i:s');
					$this->mysql->insert("playerext_copy", $player_ext);
					$inc++;
				}
			}
			echo "synpext {inc: {$inc}} data success...<br>";
// 			$this->i("synpext {inc: {$inc}} data success...");
		}
		
		private function LoadInitRobot() {
			$inc = 0;
			$this->initDataRedis(1000);
			$ilst = explode(",", Config::$robotList);
			for($i=$ilst[0];$i<=$ilst[1];$i++) {				
				$tot = rand(300, 2000);
				$offSet = round($tot/10);
				$diff = rand(10, $offSet);
				$win = round($tot/2+$diff);
				$exp = $win*2+$tot;
				$coin = rand(100, 2000);
				$this->data_redis->hMset("hu:{$i}", array("total_board" => $tot, "total_win" => $win, "exp" => $win,"coin" => $coin));
// 				echo $win."-".($tot-$win)."<br/>";
				$inc++;
			}
			echo "LoadInitRobot {inc: {$inc}} data success...<br>";
// 			$this->i("LoadInitRobot {inc: {$inc}} data success...");
		}
		
		private function LoadSlot() {
			$row = $this->mysql->find("SELECT * FROM `slot` order by id");
			$this->clear(array("sslot"));
			foreach ($row as $g) {
				$goods["id"] = (int)$g['id'];				
				$goods["tp"] = (int)$g["type"];
				$goods["od"] = (int)$g["odds"];
				$goods["pb"] = (int)$g["prob"];
				$goods["dc"] = $g["desc"];
				$resArr[] = $goods;	
			}
// 			var_dump($resArr);
			$this->cache_redis->set("sslot",json_encode($resArr));
			$listkeys2 = $this->cache_redis->get("sslot");
			echo "LoadSlot {llt: {$listkeys2}} data success...<br>";
// 			$this->i("LoadSlot {llt: {$listkeys2}} data success...");						
		}
		
		private function LoadNotice() {
			$row = $this->mysql->find("SELECT * FROM `notice` order by id");
			$this->clear(array("hnotice:*"));
			foreach ($row as $g) {
				$id = $g['id'];
				$this->cache_redis->hMset("hnotice:{$id}", $g);
			}
			$hkeys = count($this->cache_redis->keys("hnotice:*"));
			echo "LoadNotice {hlr: {$hkeys}} data success...<br>";
// 			$this->i("LoadNotice {hlr: {$hkeys}} data success...");
		}
		
		private function LoadTasksDay() {
			//日常任务每晚0点更新
			$this->cache_redis->del("ltaskd3:ids");
			$row = $this->cache_redis->lRange("ltaskd:ids", 0, -1);
			shuffle($row);
			for ($i=0;$i<3;$i++) {
				$this->cache_redis->rPush("ltaskd3:ids", $row[$i]);
			}
			$row = count($this->cache_redis->lRange("ltaskd3:ids", 0, -1));
			echo "LoadTasksDay {llr: {$row}} data success...<br>";
// 			var_dump($row);
		}
				
		private function LoadTasks() {
			//日常任务
			$row = $this->mysql->find("SELECT * FROM `tasksconf` Where `ttype`=0 order by id");
			$this->clear(array("htaskd:*", "ltaskd:ids"));
			foreach ($row as $g) {
				$id = $g['id'];
				$this->cache_redis->rPush("ltaskd:ids", $id);
				$this->cache_redis->hMset("htaskd:{$id}", $g);
			}
			$hkeys = count($this->cache_redis->keys("htaskd:*"));
			$listkeys = count($this->cache_redis->lRange("ltaskd:ids", 0, -1));
			echo "LoadTasks day {htaskd: {$hkeys}, ltaskd:ids: {$listkeys}} data success...<br>";
// 			$this->i("LoadTasks day {htaskd: {$hkeys}, ltaskd:ids: {$listkeys}} data success...");

			// 局内任务
			$row = $this->mysql->find("SELECT * FROM `tasksconf` Where `ttype`=1 order by id");
			$this->clear(array("htaskr:*", "staskr:ids"));
			foreach ($row as $g) {
				$id = $g['id'];
				$this->cache_redis->sAdd("staskr:ids", $id);
				$this->cache_redis->hMset("htaskr:{$id}", $g);
			}
			$hkeys = count($this->cache_redis->keys("htaskr:*"));
			$listkeys = $this->cache_redis->SCARD("staskr:ids");
			echo "LoadTasks Round {htaskr: {$hkeys}, staskr:ids: {$listkeys}} data success...<br>";
// 			$this->i("LoadTasks Round  {htaskr: {$hkeys}, staskr:ids: {$listkeys}} data success...");
				
			//成就任务
			$row = $this->mysql->find("SELECT * FROM `tasksconf` Where `ttype`=2 order by id");
			$this->clear(array("htaska:*", "ltaska:ids"));
			foreach ($row as $g) {
				$id = $g['id'];
				$this->cache_redis->rPush("ltaska:ids", $id);
				$this->cache_redis->hMset("htaska:{$id}", $g);
			}
			$hkeys = count($this->cache_redis->keys("htaska:*"));
			$listkeys = count($this->cache_redis->lRange("ltaska:ids", 0, -1));
			echo "LoadTasks achieve {htaska: {$hkeys}, ltaska:ids: {$listkeys}} data success...<br>";
// 			$this->i("LoadTasks achieve {htaska: {$hkeys}, ltaska:ids: {$listkeys}} data success...");
			// 更新标记
			$this->cache_redis->set("staskup",time());
		}
		
		private function LoadRobot() {
			$ilst = explode(",", Config::$robotList);
			$this->clear(array("lrob:ids"));
			$now = time();
			$skey = md5($now . Game::$salt_password);
			for ($g=$ilst[0];$g<=$ilst[1];$g++) {
				$row = $this->mysql->select("player", "*", array('id' => $g));
				$this->initDataRedis($g);
				$isExists = $this->data_redis->exists("hu:{$g}");
				if (!$isExists) {
					$this->data_redis->hMset("hu:{$g}", $row[0]);
				}				
				
				$this->data_redis->hMset("hu:$g", array("update_time" => $now, "heartbeat_at" => $now, "skey" => $skey));
				$this->cache_redis->rPush("lrob:ids",$g);
			}
			$this->cache_redis->set("srob:skey",$skey);
			$listkeys = count($this->cache_redis->lRange("lrob:ids", 0, -1));
			echo "LoadRobot {{$listkeys}} data success...<br>";
// 			$this->i("LoadRobot {{$listkeys}} data success..."); 
		}
		
   		private function LoadLottery() {
			$row = $this->mysql->find("SELECT * FROM `lottery` Where `status`>0 order by id");
			$this->clear(array("hlt:*", "llt:ids"));
			$resArr = array('','','','','','','','','','');
			foreach ($row as $g) {
				$id = $g['id'];
				$st = $g['status'];
				if($st==1){
					$this->cache_redis->rPush("llt:ids", $id);
				}else{					
					$goods["awardType"] = (int)$g["awardType"];
					$goods["amount"] = (int)$g["amount"];
					$goods["userTypeProb"] = (int)$g["userTypeProb"];
					$goods["sortInd"] = (int)$g["sortInd"];
					$goods["noticeId"] = (int)$g["noticeId"];
					$goods["desp"] = $g["desp"];
					$resArr[$goods["sortInd"]] = $goods;					
				}
				$this->cache_redis->hMset("hlt:{$id}", $g);
			}
			if(sizeof($resArr)>0){
				$this->cache_redis->set("sltpay",json_encode($resArr));
			}
			
			$hkeys = count($this->cache_redis->keys("hlt:*"));
			$listkeys = count($this->cache_redis->lRange("llt:ids", 0, -1));
			$listkeys2 = $this->cache_redis->get("sltpay");
			echo "LoadLottery {llt: {$listkeys},hlt: {$hkeys}, lltp: {$listkeys2}} data success...<br>";
// 			$this->i("LoadLottery {llt: {$listkeys}, hlt: {$hkeys}, lltp: {$listkeys2}} data success...");
		}
		
		private function LoadLoginreward() {
			$row = $this->mysql->find("SELECT * FROM `loginreward` order by id");
			$this->clear(array("hlr:*", "llr:ids"));
			foreach ($row as $g) {
				$id = $g['id'];
				$this->cache_redis->rPush("llr:ids", $id);
				$this->cache_redis->hMset("hlr:{$id}", $g);
			}
			$hkeys = count($this->cache_redis->keys("hlr:*"));
			$listkeys = count($this->cache_redis->lRange("llr:ids", 0, -1));
			echo "LoadLoginreward {llr: {$hkeys}, hlr: {$listkeys}} data success...<br>";
// 			$this->i("LoadLoginreward {llr: {$hkeys}, hlr: {$listkeys}} data success...");
		}
		
		private function loadVenue() {			
			$row = $this->mysql->find("SELECT * FROM `venue`");
			$this->clear(array("svelist", "svetlist","hv:*"));
			$awardes = array();
			$awardes1 = array();
			$inc = 0;
			foreach ($row as $g) {
				$venue['vid'] = (int) $g['id'];
				$venue['ip'] = $g['ip'];
				$venue['base_money'] = (int) $g['base_money'];
				$venue['money'] = array();
				$venue['money'][0] = (int) $g['min_money'];
				$venue['money'][1] = (int) $g['max_money'];
				$venue['port'] = (int) $g['port'];
				$venue['gt'] = (int) $g['game_type'];
				$venue['vt'] = (int) $g['vtype'];
				$venue['pcheat'] = (int) $g['is_pcheat'];
				$venue['desp'] = $g['desp'];
				$st = (int) $g['status'];
				if($st==1){
					$this->cache_redis->rPush("lv:ids", $venue['vid']);
					$awardes[] = $venue;
				}elseif ($st==2){
					$this->cache_redis->rPush("lvt:ids", $venue['vid']);
					$awardes1[] = $venue;
				}
				$this->cache_redis->hMset("hv:{$g['id']}", $g);
				$inc ++;			
			}
				
			$this->cache_redis->set("svelist",json_encode($awardes));
			$this->cache_redis->set("svetlist",json_encode($awardes1));
			
			$listkeys = $this->cache_redis->get("svelist");
			$listkeys1 = $this->cache_redis->get("svetlist");
				
			echo "loadVenue {count: {$inc},sg: {$listkeys},sgn: {$listkeys1}} data success...<br>";
// 			$this->i("loadVenue {count: {$inc},sg: {$listkeys},sgn: {$listkeys1}} data success...");
		}

		private function LoadMessage($channel) {
			$row = $this->mysql->find("SELECT * FROM `announcement` WHERE `status`=1 and `channel`='".$channel."' ORDER BY `create_time` DESC LIMIT 0, 5");
		
			foreach ($row as $g) {
				$id = $g['id'];
				$message['mid'] = (int) $g['id'];
				$message['date'] = (int) $g['create_time'];
				$message['title'] = $g['title'];
				$message['content'] = $g['content'];
				$resArr[] = $message;
				$this->cache_redis->hMset("hmess:{$id}", $g);
			}
			$this->cache_redis->set("smesslist:".$channel,json_encode($resArr));
			$listkeys2 = $this->cache_redis->get("smesslist:".$channel);
			$keys = count($this->cache_redis->keys("hmess:*"));
			echo "LoadMessage {ha: {$keys},llt: {$listkeys2}} data success...<br>";
// 			$this->i("LoadMessage {ha: {$keys},llt: {$listkeys2}} data success...");
		}
		
		private function LoadAnnouncement($channel) {
			$row = $this->mysql->find("SELECT * FROM `announcement` WHERE `status`=1 and `type`=0 and `channel`='".$channel."' ORDER BY `id` DESC LIMIT 0, 1");
// 			var_dump($row);
			$this->cache_redis->hMset("hannounc:".$channel, $row[0]);			
			$keys = $this->cache_redis->hGet("hannounc:".$channel,'id');
			echo "LoadAnnouncement {ha: {$keys}} data success...<br>";
// 			$this->i("LoadAnnouncement {ha: {$keys}} data success...");
		}

		private function LoadGoods() {
			$row = $this->mysql->find("SELECT * FROM `goods` Where `status`>0");
			$this->clear(array("hg:*", "sglist", "sgflist", "sgnlist", "sgfnlist","sglist_channel:*"));
			
			$awardes = array();
			$awardes1 = array();
			$awardes2 = array();
			$awardes3 = array();
			foreach ($row as $g) {
				$id = $g['id'];
				$st = $g['status'];
				
				$goods["id"] = (int)$g["id"];
				$goods["rmb"] = (int)$g["rmb"];
				$goods["money"] = (int)$g["money"];
				$goods["give_money"] = (int)$g["give_money"];
				$goods["give_coin"] = (int)$g["give_coin"];
				
				if($st==1 || $st==3){
					$awardes1[] = $goods;
				}elseif ($st==2 ||$st==4){
					$awardes3[] = $goods;				
				}
				elseif ($st==5){
					//mdo 短信指令 对应的商品					
					$awardes5[] = $goods;
				}
				elseif ($st==6){
					//和游戏 短信指令 对应的商品
					$awardes6[] = $goods;
				}
				$this->cache_redis->hMset("hg:{$id}", $g);
			}
			$hkeys = count($this->cache_redis->keys("hg:*"));
			
			$this->cache_redis->set("sgnlist",json_encode($awardes1));
			$this->cache_redis->set("sgfnlist",json_encode($awardes3));
			//$this->cache_redis->set("sgmdolist",json_encode($awardes5));
			
			if (isset($awardes5) && !empty($awardes5)) {				
				$this->cache_redis->set("sglist_channel:mdo",json_encode($awardes5));
			}
			if (isset($awardes6) && !empty($awardes6)) {
				$this->cache_redis->set("sglist_channel:cmgame",json_encode($awardes6));
			}
			
			$listkeys1 = $this->cache_redis->get("sgnlist");
			$listkeys3 = $this->cache_redis->get("sgfnlist");
			$listkeys5 = $this->cache_redis->get("sgmdolist");
			
			echo "LoadGoods {hkeys: {$hkeys},sgn: {$listkeys1},sfgn: {$listkeys3},sgmdo: {$listkeys5}} data success...<br>";
// 			$this->i("LoadGoods {hkeys: {$hkeys},sgn: {$listkeys1},sfgn: {$listkeys3}} data success...");
		}
		
		private function LoadGoodsInfo() {
			/*
			 * [{"tp":1,"pt":[ {"rmb":2,"mon":20000,"coin":2},{"rmb":5,"mon":50000,"coin":5},{"rmb":10,"mon":100000,"coin":10},{"rmb":20,"mon":200000,"coin":20},{"rmb":30,"mon":300000,"coin":30}]}, {"tp":2,"pt":[ {"rmb":2,"mon":20000,"coin":2},{"rmb":5,"mon":50000,"coin":5},{"rmb":10,"mon":100000,"coin":10},{"rmb":20,"mon":200000,"coin":20},{"rmb":30,"mon":300000,"coin":30}]}, {"tp":3,"pt":[ {"rmb":2,"mon":20000,"coin":2},{"rmb":5,"mon":50000,"coin":5},{"rmb":10,"mon":100000,"coin":10},{"rmb":20,"mon":200000,"coin":20},{"rmb":30,"mon":300000,"coin":30}]} ]
			*/
			$tp_max = 0;
			$r0 = $this->mysql->find ( "select max(pay_type) as pay_type from pay_sdk" );
			foreach ( $r0 as $g ) {
				$tp_max = ( int ) $g ['pay_type'];
			}
		
			$sql = "select a.hot,a.pay_type, b.rmb, b.money,b.coin,b.a, b.b from pay_sdk a join pay_points b on a.id=b.pay_sdk_id group by a.pay_type, b.rmb,b.money,b.coin,b.a,b.b order by a.pay_type, b.rmb";
			$row = $this->mysql->find ( $sql );
			$this->clear ( array (
					"hsg:*",
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
						$this->cache_redis->hMset ( "hsg:{$pt}{$rmb}", $g );
							
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
			$hkeys = count ( $this->cache_redis->keys ( "hsg:*" ) );
			$listkeys = $this->cache_redis->get ( "sgoods" );
			echo "LoadGoods {hkeys: {$hkeys},sgoods: {$listkeys} data success...<br>";
			//		$this->i ( "LoadGoods {hkeys: {$hkeys},sgoods: {$listkeys} data success..." );
			$this->LoadChannelPayInfo ();
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
			$row = $this->mysql->find("SELECT * FROM `award` Where `status`=1 order by sortId desc");
			$this->clear(array("haw:*", "lawn:ids"));
			foreach ($row as $aw) {
				$id = $aw['id'];
				$this->cache_redis->rPush("lawn:ids", $id);
				$this->cache_redis->hMset("haw:{$id}", $aw);
			}
			$hkeys = count($this->cache_redis->keys("haw:*"));
			$listkeys = count($this->cache_redis->lRange("lawn:ids", 0, -1));
			echo "LoadAward {law: {$hkeys}, haw: {$listkeys}, data success...<br>";
// 			$this->i("LoadAward {law: {$hkeys}, haw: {$listkeys}, data success...");
			
		}

		private function LoadRank() {
			$row = $this->mysql->find("SELECT * FROM `rank` ORDER BY `type`,`no`");
			$this->clear(array("hr:*", "lr:ids"));
			foreach ($row as $r) {
				$id = $r['id'];
				$this->cache_redis->rPush("lr:ids", $id);
				$this->cache_redis->hMset("hr:{$id}", $r);
			}
			$hkeys = count($this->cache_redis->keys("hr:*"));
			$listkeys = count($this->cache_redis->lRange("lr:ids", 0, -1));
			echo "LoadRank {lr: {$hkeys}, hr: {$listkeys}} data success...<br>";
// 			$this->i("LoadRank {lr: {$hkeys}, hr: {$listkeys}} data success...");
		}

		private function loadMatchInfo() {
			$row = $this->mysql->find("SELECT * FROM `matchinfo`");		
			foreach ($row as $g) {
				$message['id'] = (int) $g['id'];
				$message['vid'] = (int) $g['vid'];
				$message['playerlimit'] = (int)$g['playerlimit'];
				$message['paytype'] = (int)$g['paytype'];
				$message['paymoney'] = (int)$g['paymoney'];
				$message['awardinfo'] = $g['awardinfo'];
				$message['matchdetail'] = $g['matchdetail'];
				$message['matchtime'] = $g['matchtime'];
				$this->cache_redis->hMset("hmatch:{$g['id']}", $message);
				$resArr[] = $message;
			}
			$this->cache_redis->set("smatchInfo",json_encode($resArr));
			$listkeys2 = $this->cache_redis->get("smatchInfo");
			echo "loadMatchInfo llt: {$listkeys2} data success...<br>";
// 			$this->i("loadMatchInfo llt: {$listkeys2} data success...");
			
			$row = $this->mysql->find("SELECT * FROM `matchaward`");
			foreach ($row as $g) {
				$mes['mid'] = (int) $g['mid'];
				$mes['rank'] = (int) $g['rank'];
				$mes['awardType'] = (int)$g['awardType'];
				$mes['awardNum'] = (int)$g['awardNum'];
				$this->cache_redis->hMset("hmatch:{$g['id']}", $mes);
				$resArr1[] = $mes;
			}
			$this->cache_redis->set("smatchAward",json_encode($resArr1));
			$listkeys2 = $this->cache_redis->get("smatchAward");
			echo "loadsmatchAward llt: {$listkeys2} data success...<br>";
// 			$this->i("loadsmatchAward llt: {$listkeys2} data success...");
		}
				
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>