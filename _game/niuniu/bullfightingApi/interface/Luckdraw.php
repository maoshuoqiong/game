<?php
/**
 * 抽奖
 */
class Luckdraw extends APIBase {
	public $tag = "Luckdraw";
	public $LOTTERY_TYPE_MONEY = 0; 	// 金币
	public $LOTTERY_TYPE_COIN = 1; 		// 元宝
	public $LOTTERY_TYPE_GIFT = 2; 		// 礼物
	public $LOTTERY_TYPE_CHARM = 3; 	// 魅力值
	public $LOTTERY_TYPE_EXP = 4; 		// 经验
	public $LOTTERY_TYPE_CHANCE = 5; 	// 再来一次
	public $LOTTERY_TYPE_TELCHARGE = 6; // 话费
	public $LOTTERY_TYPE_DOUBLE = 7; 	// 奖励翻倍
	public $LOTTERY_TYPE_DIGITAL = 8; 	// 数码大奖
	
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$now = time ();
		
		if (Game::$lottery_isopen == 0) {
			$this->returnError ( 300, '抽奖已关闭' );
			return;
		}
		if (! isset ( $this->param ['actType'] )) {
			$this->returnError ( 302, '非法操作' );
			return;
		}
		
		$pExt = $this->getPextInfo();
		 /* echo "currPext<br/>";
		var_dump($pExt); */
		$pUinfo = $this->data_redis->hMget ( "hu:{$this->uid}", array ("vipLevel"));
		$pExt ['vipLevel'] = $pUinfo ['vipLevel'];

		$actType = $this->param ['actType'];
		$isSameLotteryDay = CommonTool::isSameDay ( $pExt ['lastLotteryDate'], $now );
// 		$isSameLotteryDay = false;
		if(!$isSameLotteryDay){
			$pExt['currLotteryNum'] = 0;
			$pExt['doubAward'] = 0;
			$pExt['moreOne'] = 0;
		}
		$isRes = $actType=="lPrize"?0:1;
		$remTime = $this->getRemainTime ( $pExt, $isSameLotteryDay, $now ,$isRes);
		$pExt ['lastLotteryDate'] = $now;
		$lotteryPrize = $this->getLotteryPrize ();

// 		echo "remTime<br/>";
// 		var_dump($remTime);
		if ($actType == "lPrize") {
			$lotteryPrize = $this->fitlerLotteryPrize ( $lotteryPrize );
			return $this->returnData ( array (
					'free_tot_num' => $remTime[2],
					'left_free_num' => $remTime[0],
					'pay_tot_num' => Game::$luckdraw_pay_tot,
					'left_pay_num' => $remTime[1],
					'pay_money' => Game::$lottery_activity_pay,
					'res' => $lotteryPrize 
			) );
		} else if ($actType == "lRes") {
			if ($remTime[0] <= 0 && $remTime[1]<Game::$luckdraw_pay_tot) {
				if($remTime[1] < 0){
					$this->returnError ( 301, '请明日再来吧^^' );
					return;
				}
				// 有偿抽奖需要减金币，再来一次除外
				if($pExt['moreOne']<=0){
					$mon = $this->data_redis->hGet ( "hu:{$this->uid}", 'money');
					if($mon>=Game::$lottery_activity_pay){
						$this->hincrMoney (0-Game::$lottery_activity_pay, "luckdrawPay" );
					}else{
						$this->returnError ( 301, '金币不足,请先充值吧' );
						return;
					}
				}				
			}	
			// 抽奖结果		
			$lotteryRes = $this->calLotteryRes ( $this->uid, $lotteryPrize,$remTime[0]+ $remTime[1]);
			$resMsg = $this->syncLotteryToPlayer ( $lotteryRes, $pExt, $lotteryPrize );
			$mon = $this->data_redis->hMget ( "hu:{$this->uid}", array (
					'money',
					'coin' 
			) );
			$this->hincrFunc ( "luckdraw" );
			if($pExt['moreOne']>0){
				$remTime[0] += $pExt['moreOne'];
			}
			return $this->returnData ( array (
					'left_free_num' => $remTime[0],
					'left_pay_num' => $remTime[1],
					'curr_money' => ( int ) $mon ['money'],
					'curr_coin' => ( int ) $mon ['coin'],
					'res_ind' => $lotteryRes 
			),0,$resMsg);
		} else {
			$this->returnError ( 302, '非法操作' );
			return;
		}
	}
	
	private function getPextInfo(){
		// lastLotteryDate:最后一次抽奖时间；currLotteryNum：当前抽奖次数；doubAward：是否奖励翻倍；moreOne：免费再来一次次数；
		$pExt = $this->data_redis->hMGet ( "hpe:{$this->uid}", array (
				"lastLotteryDate",
				"currLotteryNum",
				"doubAward",
				"moreOne"
		) );
		if(!$pExt ['lastLotteryDate']){
			$pExt ['lastLotteryDate'] = 0;
		}
		if(!$pExt ['currLotteryNum']){
			$pExt ['currLotteryNum'] = 0;
		}
		if(!$pExt ['doubAward']){
			$pExt ['doubAward'] = 0;
		}
		if(!$pExt ['moreOne']){
			$pExt ['moreOne'] = 0;
		}
		return $pExt;
	}
	/**
	 * 获得抽奖奖项列表
	 * @return number
	 */
	public function getLotteryPrize() {
		$prizeStr = $this->cache_redis->get("sluckdraw");
		$prizeArr = json_decode($prizeStr);
		foreach ( $prizeArr as $key ) {
			$goods ["awardType"] = ( int ) $key->awardType;
			$goods ["amount"] = ( int ) $key->amount;
			$goods ["noticeMsg"] = isset ( $key->noticeMsg ) ? $key->noticeMsg : "";
			$goods ["userTypeProb"] = isset ( $key->userTypeProb ) ? $key->userTypeProb : "0";
			$goods ["desp"] = isset ( $key->desp ) ? $key->desp : "";
			$goods ["extId"] = isset ( $key->extId ) ? $key->extId : "";
			$goods ["sortInd"] = ( int ) $key->sortInd;
			$resArr [] = $goods;
		}
		return $resArr;
	}
	
	public function fitlerLotteryPrize($lotteryPrize) {
		$resArr = array ();
		foreach ( $lotteryPrize as $key ) {
			$goods ["awardType"] = $key ["awardType"];
			$goods ["amount"] = $key ["amount"];
			$resArr [] = $goods;
		}
// 		var_dump($resArr);
		return $resArr;
	}
	/**
	 * 更新抽奖信息
	 * @param unknown $lotteryRes
	 * @param unknown $pExt
	 * @param unknown $lotteryPrize
	 * @return void|string
	 */
	public function syncLotteryToPlayer($lotteryRes, &$pExt, $lotteryPrize) {
		if ($lotteryRes > sizeof ( $lotteryPrize )) {
			$this->returnError ( 303, '内部错误' );
			return;
		}
 		/* $pu = $this->data_redis->hMget("hu:{$this->uid}",array('money','coin','exp','charm'));
		$pg = $this->data_redis->hGetAll("ugift:{$this->uid}");
		var_dump($pu);
		var_dump($pg); */
		$lotteryItem = $lotteryPrize [$lotteryRes];
		$lottLog ['uid'] = $this->uid;
		$lottLog ['awardType'] = $lotteryItem ['awardType'];
		$lottLog ['amount'] = $lotteryItem ['amount'];
		$lottLog ['hasGet'] = 1;
		$lottLog ['createdate'] = date ( 'Y-m-d H:i:s' );

		// echo date('Y-m-d H:i:s');
		if ($lotteryItem ['awardType'] >= 0) {
			$this->mysql->insert ( "lotterylog", $lottLog );
		}
		// echo "insert lottery log.$ret";
		// 奖励翻倍
		if($pExt['doubAward']==1 && $lotteryItem ['awardType'] != $this->LOTTERY_TYPE_CHANCE){
			$lotteryItem ['amount'] = $lotteryItem ['amount']*2;
			$pExt['doubAward'] = 0;
		}
		// 再来一次
		if($pExt['moreOne']>0){
			$pExt['moreOne'] -= 1;
			$pExt['currLotteryNum'] -= 1;
		}
		// 更新玩家基础信息
		$prob = 1; // 礼物索引
		if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_MONEY) {
			$this->hincrMoney ( $lotteryItem ['amount'], "luckdraw" );
		} else if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_COIN) {
			$this->hincrCoin ( $lotteryItem ['amount'], "luckdraw" );
		}  else if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_GIFT) {			
			$probArr = explode ( ",", $lotteryItem ["extId"] );
			$mt_ind = mt_rand ( 0, sizeof($probArr)-1);
			$prob = $probArr [$mt_ind];
			$this->data_redis->hIncrBy("ugift:{$this->uid}",$prob,$lotteryItem ['amount']);
			$this->data_redis->hSet("ugift:{$this->uid}",'tm',time());
		}  else if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_CHANCE) {
			$pExt ['moreOne'] += $lotteryItem ['amount'];
		}  else if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_DOUBLE) {
			$pExt ['doubAward'] = 1;
		}  else if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_CHARM) {
			$this->data_redis->hIncrBy("hu:{$this->uid}", "charm", $lotteryItem ['amount']);
		} else if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_EXP) {
			$this->hincrExp($lotteryItem ['amount']);
		}
		/* $pu = $this->data_redis->hMget("hu:{$this->uid}",array('money','coin','exp','charm'));
		$pg = $this->data_redis->hGetAll("ugift:{$this->uid}");
		var_dump($pu);
		var_dump($pg); */
		// 更新玩家扩展信息
		$this->data_redis->hMset ( "hpe:{$this->uid}", array (
				"lastLotteryDate" => $pExt ['lastLotteryDate'],
				"currLotteryNum" => $pExt ['currLotteryNum']+1,
				"doubAward" => $pExt ['doubAward'],
				"moreOne" => $pExt ['moreOne']
		) );
		
		// 发送个人通知
		if (isset ( $lotteryItem ['noticeMsg'] ) && $lotteryItem ['noticeMsg'] !="") {			
			$name = $this->data_redis->hMget ( "hu:{$this->uid}", array (
					"name" 
			) );
			if (! isset ( $name ['name'] )) {
				return;
			}
			$msg = $lotteryItem ['noticeMsg'];
			$old = array (
					"{user}",
					"{amount}" 
			);
			
			$now = array (
					$name ['name'],$lotteryItem ['amount'] 
			);
			if($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_GIFT){
				$now[1] = CommonTool::getGiftName($prob);
			}
			$msg = str_replace ( $old, $now, $msg );
			$this->sendBroadcast ( $msg, "4" );
			// 模拟假的获奖广播
			$rand = rand(0, 1000);
			if($rand>950){
				$ilst = explode ( ",", Config::$robotList);
				$rand = rand($ilst[0], $ilst[1]);
				$name = $this->data_redis->hMget ( "hu:{$rand}", array (
						"name"
				) );
				if (!isset ( $name ['name'] )) {
					return;
				}
				$rand = rand(0, 100);
				$msg = '天降奇财!'.$name.'在抽奖中获得40000金币';
				if($rand<40){
					$msg = '吊爆啦,'.$name.'抽奖获得10元话费';
				}elseif ($rand>80){
					$msg = '吊炸天了,'.$name.'抽奖获得50元话费';
				}
				$this->sendBroadcast ( $msg, "4" );
			}
		}
		if($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_DOUBLE){
			return "下次奖励翻倍,愿再接再厉哦!";
		}elseif ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_GIFT){
			return "恭喜,获得".$lotteryItem ['desp'].CommonTool::getGiftName($prob)."x".$lotteryItem ['amount'];
		}else{
			return "恭喜,获得".$lotteryItem ['amount'].$lotteryItem ['desp'];
		}
	}
	
	/**
	 * 剩余抽奖次数
	 * @param unknown $pExt
	 * @param unknown $isSameDay
	 * @param unknown $now
	 * @param unknown $isRes
	 * @return multitype:number
	 */
	public function getRemainTime($pExt, $isSameDay, $now ,$isRes) {
		// vip用户抽奖次数 + 1
		$isvip = (isset ( $pExt ['vipLevel'] ) && ( int ) $pExt ['vipLevel'] > 0) ? 1 : 0;	
		$isMore = $pExt['moreOne']>0?1:0;
// 		echo "isVip:".$isvip."<br/>";
		$rt = array(Game::$luckdraw_free_tot+$isvip+$pExt['moreOne'],Game::$luckdraw_pay_tot,Game::$luckdraw_free_tot+$isvip);

		$rt[0] = $pExt ['currLotteryNum']>$rt[0]?0:Game::$luckdraw_free_tot - $pExt ['currLotteryNum']+$isvip+$isMore;
		$rt[1] = Game::$luckdraw_free_tot+Game::$luckdraw_pay_tot - $pExt ['currLotteryNum']+$isvip+$isMore;
		$rt[1] = $rt[1]>Game::$luckdraw_pay_tot?Game::$luckdraw_pay_tot:$rt[1];
		if($isRes>0){ // 抽奖时剩余次数减1，如果有免费再来一次则，有偿抽奖不变化
			$rt[1] = $rt[0]>0?$rt[1]:$rt[1]-1;
			$rt[0] = $rt[0]>0?$rt[0]-1:0;
		}
		return $rt;
	}
	
	public function calLotteryRes($uid, $lotteryPrize,$remainTime) {
		$identity = 0;
		if($remainTime<=8){
			$identity = 1;
		}elseif ($remainTime<=3){
			$identity = 2;
		}
		$rand = mt_rand ( 1, 1000 );
		$cal = 0;
// 		echo "@@rand:$rand";
		foreach ( $lotteryPrize as $key ) {
			if (! isset ( $key ["userTypeProb"] )) {
				return 12;
			}
			$probArr = explode ( ",", $key ["userTypeProb"] );
			$prob = $probArr [$identity];
			$cal += $prob;
			if ($cal >= $rand) {
				return ( int ) $key ["sortInd"];
			}
		}
		return 12;
	}
	public function randAmount($amountArr) {
		$amoutArr = explode ( ",", $amountArr );
		$arrLen = sizeof ( $amoutArr );
		if ($arrLen == 1) {
			return $amoutArr [0];
		}
		$rand = mt_rand ( 0, $arrLen - 1 );
		return $amoutArr [$rand];
	}
	public function after() {
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
		$this->deinitMysql ();
	}
}
?>