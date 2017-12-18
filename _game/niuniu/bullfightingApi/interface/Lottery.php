<?php
/**
	 * 抽奖
	 */
class Lottery extends APIBase {
	public $tag = "Lottery";
	public $LOTTERY_TYPE_MONEY = 0; // 金币
	public $LOTTERY_TYPE_COIN = 1; // 元宝
	public $LOTTERY_TYPE_TELCHARGE = 2; // 话费券
	public $LOTTERY_TYPE_DIGITAL_PROD = 3; // 数码大奖
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$now = time ();
		$limitMax = Config::$lotteryMaxTime;
		
		if (Game::$lottery_isopen == 0) {
			$this->returnError ( 300, '抽奖已关闭' );
			return;
		}
		if (! isset ( $this->param ['actType'] )) {
			$this->returnError ( 302, '非法操作' );
			return;
		}
		
		$pExt = $this->data_redis->hMGet ( "hpe:{$this->uid}", array (
				"lastLotteryDate",
				"lastPrizeDate",
				"currLotteryNum" 
		) );
		$pUinfo = $this->data_redis->hMget ( "hu:{$this->uid}", array (
				"login_days",
				"telCharge",
				"vipLevel" 
		) );
		$login_days = $pUinfo ['login_days'];
		$pExt ['telCharge'] = $pUinfo ['telCharge'];
		$pExt ['vipLevel'] = $pUinfo ['vipLevel'];
		// echo $login_days;
		/*
		 * echo "###111##<br/>"; echo $pExt['continueLoginDays']."<br/>"; echo $pExt['currLotteryNum']."<br/>"; echo "###111##<br/>";
		 */
		$actType = $this->param ['actType'];
		$pExt ['lastLotteryDate'] = $pExt ['lastLotteryDate']?$pExt ['lastLotteryDate']:0;
		$pExt ['lastPrizeDate'] = $pExt ['lastPrizeDate']?$pExt ['lastPrizeDate']:0;
		$pExt ['currLotteryNum'] = $pExt ['currLotteryNum']?$pExt ['currLotteryNum']:0;
		
		$isSameLotteryDay = CommonTool::isSameDay ( $pExt ['lastLotteryDate'], $now );
		$isSamePrizeDay = CommonTool::isSameDay ( $pExt ['lastPrizeDate'], $now );
		$remTime = $this->getRemainTime ( $pExt, $isSameLotteryDay, $now, $login_days );
		$pExt ['lastLotteryDate'] = $now;
		if (isset ( $this->param ['ispay'] ) && $this->param ['ispay'] == 1) {
			$this->payLottery ( $actType, $pExt, $remTime );
			return;
		}
		$lotteryPrize = $this->getLotteryPrize ( $pExt, $isSamePrizeDay );
		/*
		 * echo "###000##<br/>"; print_r($lotteryPrize); echo "###000##<br/>";
		 */
		
		if ($actType == "lPrize") {
			$this->updateLotteryDate ( $isSamePrizeDay, $now );
			$lotteryPrize = $this->fitlerLotteryPrize ( $lotteryPrize );
			return $this->returnData ( array (
					'rem_num' => $remTime,
					'telCharge' => ( int ) $pUinfo ['telCharge'],
					'res' => $lotteryPrize 
			) );
		} else if ($actType == "lRes") {
			$remTime -= 1;
			if ($remTime < 0) {
				// $isSameDay && ($pExt['currLotteryNum']>=$limitMax ||$pExt['continueLoginDays'] == $pExt['currLotteryNum'])
				$this->returnError ( 301, '当日抽奖次数已用完' );
				return;
			}
			/*
			 * echo "###222##<br/>"; echo $pExt['continueLoginDays']."<br/>"; echo $pExt['currLotteryNum']."<br/>"; echo $remTime."<br/>"; echo "###222##<br/>";
			 */
			
			$lotteryRes = $this->calLotteryRes ( $pExt, $lotteryPrize );
			$this->syncLotteryToPlayer ( $lotteryRes, $pExt, $lotteryPrize );
			$mon = $this->data_redis->hMget ( "hu:{$this->uid}", array (
					'money',
					'coin' 
			) );
			$this->hincrFunc ( "freeLottery" );
			return $this->returnData ( array (
					'rem_num' => $remTime,
					'telCharge' => ( int ) $pUinfo ['telCharge'],
					'curr_money' => ( int ) $mon ['money'],
					'curr_coin' => ( int ) $mon ['coin'],
					'res_ind' => $lotteryRes 
			) );
		} else {
			$this->returnError ( 302, '非法操作' );
			return;
		}
	}
	public function fitlerLotteryPrize($lotteryPrize) {
		$resArr = array ();
		foreach ( $lotteryPrize as $key ) {
			$goods ["awardType"] = $key ["awardType"];
			$goods ["amount"] = $key ["amount"];
			$resArr [$key ["sortInd"]] = $goods;
		}
		// var_dump($resArr);
		return $resArr;
	}
	public function payLottery($actType, $pExt, $remTime) {
		$prizeStr = $this->cache_redis->get ( "sltpay" );
		$lotteryPrize = array ();
		$prizeArr = json_decode ( $prizeStr );
		// cal res
		$rand = mt_rand ( 1, 10000 );
		$cal = 0;
		$lotteryRes = - 1;
		$identity = (isset ( $pExt ['vipLevel'] ) && ( int ) $pExt ['vipLevel'] > 0) ? 1 : 0;	
		
		$now = time ();
		/*
		 * echo "###111##<br/>"; print_r($lotteryPrize); echo "###111##<br/>";
		 */
		if ($actType == "lPrize") {
			if (strtotime ( Game::$lottery_activity_start ) > $now || strtotime ( Game::$lottery_activity_end ) < $now) {
				return $this->returnData ( array (
						'start_t' => strtotime ( Game::$lottery_activity_start ),
						'end_t' => strtotime ( Game::$lottery_activity_end ),
						'telCharge' => ( int ) $pExt ['telCharge'] 
				) );
			}
			foreach ( $prizeArr as $key ) {
				$goods ["awardType"] = ( int ) $key->awardType;
				$goods ["amount"] = ( int ) $key->amount;
				$goods ["desp"] = $key->desp;
				$lotteryPrize [] = $goods;
			}
			return $this->returnData ( array (
					'start_t' => strtotime ( Game::$lottery_activity_start ),
					'end_t' => strtotime ( Game::$lottery_activity_end ),
					'telCharge' => ( int ) $pExt ['telCharge'],
					'res' => $lotteryPrize 
			) );
		} else if ($actType == "lRes") {
			foreach ( $prizeArr as $key ) {
				$probArr = explode ( ",", $key->userTypeProb );
				$prob = $probArr [$identity];
				$cal += $prob;
				if ($cal >= $rand && $lotteryRes == - 1) {
					$lotteryRes = ( int ) $key->sortInd;
				}
				$goods ["awardType"] = ( int ) $key->awardType;
				$goods ["amount"] = ( int ) $key->amount;
				$goods ["noticeId"] = ( int ) $key->noticeId;
				$goods ["desp"] = $key->desp;
				$lotteryPrize [] = $goods;
			}
			if ($remTime > 0) {
				$this->returnError ( 306, '免费抽奖未完成' );
				return;
			}
			$mon = $this->data_redis->hMget ( "hu:{$this->uid}", array (
					'money' 
			) );
			if (! isset ( $mon ['money'] )) {
				$this->returnError ( 302, '非法操作' );
				return;
			}
			if (strtotime ( Game::$lottery_activity_start ) > $now || strtotime ( Game::$lottery_activity_end ) < $now) {
				$this->returnError ( 304, '非活动期' );
				return;
			}
			$currM = $mon ['money'];
			if ($currM < Game::$lottery_activity_limit) {
				$this->returnError ( 305, '金币不足' );
				return;
			}
			$this->hincrMoney ( 0 - Game::$lottery_activity_pay, "lotteryPay" );
			$pExt ['currLotteryNum'] -= 1;
			$this->syncLotteryToPlayer ( $lotteryRes, $pExt, $lotteryPrize );
			$mon = $this->data_redis->hMget ( "hu:{$this->uid}", array (
					'money',
					'coin' 
			) );
			$this->hincrFunc ( "payLottery" );
			return $this->returnData ( array (
					'rem_num' => 0,
					'telCharge' => ( int ) $pExt ['telCharge'],
					'curr_money' => ( int ) $mon ['money'],
					'curr_coin' => ( int ) $mon ['coin'],
					'res_ind' => $lotteryRes 
			) );
		} else {
			$this->returnError ( 302, '非法操作' );
			return;
		}
	}
	public function updateLotteryDate($isSameDay, $now) {
		if (! $isSameDay) {
			$this->data_redis->hMset ( "hpe:{$this->uid}", array (
					"lastPrizeDate" => $now 
			) );
		}
	}
	public function syncLotteryToPlayer($lotteryRes, &$pExt, $lotteryPrize) {
		if ($lotteryRes > sizeof ( $lotteryPrize )) {
			$this->returnError ( 303, '内部错误' );
			return;
		}
		$lotteryItem = $lotteryPrize [$lotteryRes];
		// echo "###333##<br/>";
		// print_r($lotteryItem);
		// echo "###333##<br/>";$lottLog = array();
		$lottLog ['uid'] = $this->uid;
		$lottLog ['awardType'] = $lotteryItem ['awardType'];
		$lottLog ['amount'] = $lotteryItem ['amount'];
		$lottLog ['hasGet'] = 1;
		$lottLog ['createdate'] = date ( 'Y-m-d H:i:s' );
		
		if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_TELCHARGE) {
			$pExt ['telCharge'] += $lotteryItem ['amount'];
			$this->mysql->update ( "player", array (
					'telCharge' => $pExt ['telCharge'] 
			), array (
					'uid' => $this->uid 
			) );
			$this->data_redis->hMset ( "hu:{$this->uid}", "telCharge", $pExt ['telCharge'] );
		} else if ($lotteryItem ['awardType'] >= $this->LOTTERY_TYPE_DIGITAL_PROD) {
			$lottLog ['hasGet'] = 0;
		}
		// echo date('Y-m-d H:i:s');
		if ($lotteryItem ['awardType'] >= 0) {
			$this->mysql->insert ( "lotterylog", $lottLog );
		}
		// echo "insert lottery log.$ret";
		
		// 更新玩家基础信息
		if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_MONEY) {
			$this->hincrMoney ( $lotteryItem ['amount'], "lottery" );
		} else if ($lotteryItem ['awardType'] == $this->LOTTERY_TYPE_COIN) {
			$this->hincrCoin ( $lotteryItem ['amount'], "lottery" );
		}
		
		// 更新玩家扩展信息
		$this->data_redis->hMset ( "hpe:{$this->uid}", array (
				"lastLotteryDate" => $pExt ['lastLotteryDate'],
				"currLotteryNum" => $pExt ['currLotteryNum'] 
		) );
		
		// 发送个人通知
		if (isset ( $lotteryItem ['noticeId'] ) && isset ( $lotteryItem ['desp'] ) && $lotteryItem ['noticeId'] > 0) {
			$notice = $this->cache_redis->hMget ( "hnotice:{$lotteryItem['noticeId']}", array (
					'type',
					'desc' 
			) );
			$name = $this->data_redis->hMget ( "hu:{$this->uid}", array (
					"name" 
			) );
			if (! isset ( $name ['name'] )) {
				return;
			}
			$msg = $notice ['desc'];
			$old = array (
					"{user}",
					"{desp}" 
			);
			$now = array (
					$name ['name'],
					$lotteryItem ['amount'] . $lotteryItem ['desp'] 
			);
			$msg = str_replace ( $old, $now, $msg );
			$this->sendBroadcast ( $msg, "4" );
		}
		
		// var_dump($lotteryItem);
	}
	public function getLotteryPrize($pExt, $isSameDay) {
		$goods = array ();
		if ($isSameDay) {
			// echo "AAA<br/>";
			$resArr = array ();
			$prizeStr = $this->cache_redis->get ( "hltp:{$this->uid}" );
			$prizeArr = json_decode ( $prizeStr );
			$i = 0;
			foreach ( $prizeArr as $key ) {
				$goods ["awardType"] = ( int ) $key->awardType;
				$goods ["amount"] = ( int ) $key->amount;
				$goods ["noticeId"] = isset ( $key->noticeId ) ? ( int ) $key->noticeId : 0;
				$goods ["userTypeProb"] = isset ( $key->userTypeProb ) ? $key->userTypeProb : "0,0";
				$goods ["desp"] = isset ( $key->desp ) ? $key->desp : "";
				if (isset ( $key->sortInd )) {
					$goods ["sortInd"] = ( int ) $key->sortInd;
				} else {
					$goods ["sortInd"] = $i;
					$i ++;
				}
				$resArr [] = $goods;
			}
		} else {
			// echo "BBB<br/>";
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
			$identity = (isset ( $pExt ['vipLevel'] ) && ( int ) $pExt ['vipLevel'] > 0) ? 1 : 0;
			$keys = $this->cache_redis->lRange ( "llt:ids", 0, - 1 );
			foreach ( $keys as $key ) {
				$temp = $this->cache_redis->hMGet ( "hlt:{$key}", array (
						"awardType",
						"amount",
						"sortInd",
						"noticeId",
						"userTypeProb",
						"desp" 
				) );
				$goods ["awardType"] = ( int ) $temp ["awardType"];
				$goods ["amount"] = ( int ) $this->randAmount ( $temp ["amount"] );
				$goods ["noticeId"] = ( int ) $temp ["noticeId"];
				$goods ["sortInd"] = ( int ) $temp ["sortInd"];
				$goods ["userTypeProb"] = $temp ["userTypeProb"];
				$goods ["desp"] = $temp ["desp"];
				$resArr [$goods ["sortInd"]] = $goods;
			}
			$this->cache_redis->set ( "hltp:{$this->uid}", json_encode ( $resArr ) );
		}
		return $resArr;
	}
	public function getRemainTime(&$pExt, $isSameDay, $now, $login_days) {
		// vip用户抽奖次数 + 1
		$isvip = (isset ( $pExt ['vipLevel'] ) && ( int ) $pExt ['vipLevel'] > 0) ? 1 : 0;		
		if ($pExt ['currLotteryNum'] == 0 && $login_days <= 1) {
			$pExt ['currLotteryNum'] = 1;
			return 1 + $isvip;
		}
		if ($isSameDay) {
			$pExt ['currLotteryNum'] += 1;
		} else {
			$pExt ['currLotteryNum'] = 1;
		}
		
		//$limitMax = ($isvip == 1) ? Config::$lotteryMaxTime + 1 : Config::$lotteryMaxTime;
		$limitMax = Config::$lotteryMaxTime;		
		$limitMax = $login_days > $limitMax ? $limitMax : $login_days;
		/*
		 * echo "###111##<br/>"; echo $pExt['continueLoginDays']."<br/>"; echo $pExt['currLotteryNum']."<br/>"; echo "###111##<br/>";
		 */
		return ($limitMax - $pExt ['currLotteryNum'] + 1) + $isvip;
	}
	public function calLotteryRes($pExt, $lotteryPrize) {
		$identity = (isset ( $pExt ['vipLevel'] ) && ( int ) $pExt ['vipLevel'] > 0) ? 1 : 0;
		$rand = mt_rand ( 1, 10000 );
		$cal = 0;
		// echo "@@rand:$rand";
		foreach ( $lotteryPrize as $key ) {
			if (! isset ( $key ["userTypeProb"] )) {
				return 0;
			}
// 			echo $key ["userTypeProb"].'</br>';
			$probArr = explode ( ",", $key ["userTypeProb"] );
			$prob = $probArr [$identity];
			$cal += $prob;
			if ($cal >= $rand) {
				return ( int ) $key ["sortInd"];
			}
		}
		return 0;
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