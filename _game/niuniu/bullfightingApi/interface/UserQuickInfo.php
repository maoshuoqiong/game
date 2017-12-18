<?php
/**
	 * 获取用户信息
	 */
class UserQuickInfo extends APIBase {
	public $tag = "UserQuickInfo";
	public function before() {
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$user = $this->data_redis->hMget ( "hu:{$this->uid}", array (
				"money",
				"coin",
				"telCharge",
				"vipLevel",
				"exp",
				"total_board",
				"total_win",
				"charm",
				"level",
				"title",
				"rmb",
				"safeboxflag"	 
		) );
		//$hasRcRes = 0;		
		//$hasRc = $this->data_redis->hget ( "hpe:{$this->uid}", "hasRecharge" );
		
		$total_board = isset($user ['total_board']) ? ( int ) $user ['total_board'] : 0;
		$total_win = isset($user ['total_win']) ? ( int ) $user ['total_win'] : 0;		
		$total_lost = $total_board - $total_win;
			
		$user_gift = $this->data_redis->hMget ( "ugift:{$this->uid}", array (
				"1",
				"2",
				"3",
				"4",
				"5"
		) );
		
		$arr_gift = array(
			isset($user_gift["1"]) ? (int) $user_gift["1"] : 0,
			isset($user_gift["2"]) ? (int) $user_gift["2"] : 0,
			isset($user_gift["3"]) ? (int) $user_gift["3"] : 0,
			isset($user_gift["4"]) ? (int) $user_gift["4"] : 0,
			isset($user_gift["5"]) ? (int) $user_gift["5"] : 0,
		);
		
		// $vip = CommonTool::vip($this->data_redis,$this->uid);		
		$user_info = array (
				//'exp' => (int) $user ['exp'],
				'charm' => ( int ) $user ['charm'],
				'money' => ( int ) $user ['money'],				
				'hasrc' => isset( $user['rmb']) && (int) $user['rmb']>0? 1 : 0,
				'coin' => ( int ) $user ['coin'],
				'history' => array($total_win, $total_lost),
				//'hasrc' => isset ( $hasRc ) ? ( int ) $hasRc : 0,
				'telCharge' => isset ( $user ['telCharge'] ) ? ( int ) $user ['telCharge'] : 0,
				'vip' => isset ( $user ['vipLevel'] ) ? ( int ) $user ['vipLevel'] : 0 ,
				'level' => isset ( $user ['level'] ) ? ( int ) $user ['level'] : 1  ,
				'title' => $this->getTitleInfo((int)$user ['money']),
				// 获得任务可领奖数
				'gettask' => CommonTool::getTaskRewardNum($this,$this->uid),
				'gift' => $arr_gift,
				'isFightDate' => CommonTool::isFightDate(),
				'isFightTime' => CommonTool::isFightTime(),
				// 用户调研开关
				'research' => CommonTool::getResearch($this,$this->uid),
				'safebox' => isset($user['safeboxflag']) ? ( int ) $user ['safeboxflag'] : 0
		);
		$this->returnData ( $user_info );
	}	
	
	public function after() {
		$this->deinitCacheRedis();
		$this->deinitDataRedis ();
	}
}
?>