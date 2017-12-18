<?php
/**
	 * 兑换奖品
	 */
class ExchangeAward extends APIBase {
	public $tag = "ExchangeAward";
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		if (! isset ( $this->param ['award_id'] )) {
			$this->returnError ( 300, '兑换物品不存在' );
			return;
		}

		$award = $this->cache_redis->hGetAll ( "haw:{$this->param['award_id']}" );
		if (! $award) {
			$this->returnError ( 300, '兑换物品非法' );
			return;
		}
		$mob = 0;
		if ($award ['type'] != 3) {
			$hpe = $this->data_redis->hMget ( "hpe:{$this->uid}", array ("mob"));
			if (! isset ( $hpe ["mob"] ) || strlen ( $hpe ["mob"] ) != 11) {
				$this->returnError ( 302, '请先绑定手机号' );
				return;
			}
			$mob = $hpe ["mob"];
		}		
		$now = time ();
		if ($award ['start_time'] != 0 && $award ['end_time'] != 0) {
			if ($award ['start_time'] > $now) {
				$this->returnError ( 301, '兑换失败,活动还未开始!' );
				return;
			}
			if ($award ['end_time'] < $now) {
				$this->returnError ( 301, '兑换失败,活动已经结束!' );
				return;
			}
		}
		$msg = "兑换".$award ['name']."成功,系统会在三个工作日内处理完毕!";
		
		if ($award ['num'] == 0) {
			$this->returnError ( 301, '已经有人捷足先登了,下次记得手要快哦!' );
			return;
		}
		
		$money = $this->data_redis->hMGet ( "hu:{$this->uid}", array (
				"coin","money" 
		) );
		$curr_coin = $money ['coin'];
		$curr_money = $money ['money'];
		if ($curr_coin < $award ['coin']) {
			$this->returnError ( 301, '元宝不足,请先充值或做任务获取' );
			return;
		}
		$curr_coin = $this->hincrCoin ( 0 - $award ['coin'], "exchangeAward" );
		$status = 0;
		if ($award ['type'] == 3) {
			$status = 2;
			$msg = "兑换".$award ['name']."成功!";
			$curr_money = $this->hincrMoney($award ['awardnum'], "exchangeAward");
		}
		
		$curr_num = $award ['num'];
		if ($award ['num'] > 0) {
			$curr_num = $this->cache_redis->hincrBY ( "haw:{$this->param['award_id']}", "num", 0 - 1 );
		}
		$this->addAwardLog ( $this->uid, $this->param ['award_id'], $award ['coin'],
				 $mob, 0, $award ['type'], $award ['name'],$status);
		$this->returnData ( array (
				'curr_coin' => ( int ) $curr_coin,
				'curr_num' => ( int ) $curr_num,
				'curr_money' => ( int ) $curr_money,
				'curr_tel' => 0 
		), 0, $msg );
	}
	
	public function addAwardLog($uid, $award_id, $coin, $mobile, $qq, $type, $desc,$status) {
		$now = time ();
		$awardlog = array (
				'uid' => $uid,
				'status' => $status,
				'type' => $type,
				'coin' => $coin,
				'award_id' => $award_id,
				'mobile' => $mobile,
				'qq' => $qq,
				'user_id' => 0,
				'desc' => $desc,
				'create_time' => $now,
				'update_time' => $now 
		);		
		$this->mysql->insert ( "awardlog", $awardlog );
	}
	
	public function after() {
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
		$this->deinitMysql ();
	}
	
}
?>