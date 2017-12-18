<?php
	/**
	 * 获取用户信息
	 */
    class UserInfo extends APIBase {
		
		public $tag = "UserInfo";
		
        public function before() {
        	$this->initCacheRedis();
    		return true;
		}
		
		public function logic() {
			$user = $this->data_redis->hGetAll("hu:{$this->uid}");
			$total_board = isset($user['total_board']) ? $user['total_board'] : 0;
			$total_win = isset($user['total_win']) ? $user['total_win'] : 0;
			$total_lose = $total_board - $total_win;
			$hasRcRes = 0;
			$hasRc = $this->data_redis->hMget("hpe:{$this->uid}", array("hasRecharge","telCharge","mob"));
			$not = "";	

			$vip = CommonTool::vipDays($this->data_redis,$this->uid);
			//用户礼物
			$gifts = $this->data_redis->hGetAll("ugift:{$this->uid}");
			$g1 = isset($gifts['1']) ? (int)$gifts['1'] : 0;
			$g2 = isset($gifts['2']) ? (int)$gifts['2'] : 0;
			$g3 = isset($gifts['3']) ? (int)$gifts['3'] : 0;
			$g4 = isset($gifts['4']) ? (int)$gifts['4'] : 0;
			$g5 = isset($gifts['5']) ? (int)$gifts['5'] : 0;
			
			$user_info = array(
					'uid' => (int) $this->uid,
					'user' =>$user['user'],
					'name' => $user['name'],
					'sex' => (int) $user['sex'],
					'money' => (int) $user['money'],
					'rmb' => (int) $user['rmb'],
					'coin' => (int) $user['coin'],
					'history' => array((int) $total_win, (int) $total_lose),
					'total_board' => (int)$total_board,
					'total_win' => (int)$total_win,
					'exp' =>  isset($user['exp']) ? (int)$user['exp'] : 0,
					'skey' => $user['skey'],
					'hasrc' =>  isset($hasRc['hasRecharge']) ? (int)$hasRc['hasRecharge'] : 0,
					'telCharge' => isset($hasRc['telCharge']) ? (int)$hasRc['telCharge'] : 0,
					'mob' => isset($hasRc['mob']) && strlen($hasRc['mob'])>0 ? $hasRc['mob'] : "0",
					'notice' => $not,
					'vip' =>$vip,
					'userChange' =>isset($user['isauto']) ? (int) $user['isauto'] : 1,
					'sign' => isset($user['sign']) ? $user['sign'] : "",
					'charm' => isset($user['charm']) ? (int)$user['charm'] : 0,
					'gift' => array($g1, $g2, $g3, $g4, $g5) //玩家获得的各种礼物数量 按礼物id 从小到大( 1 ~ 5)排序
			);
			$this->returnData($user_info);
		}
		
       	public function after() {
       		$this->deinitCacheRedis();
    		$this->deinitDataRedis();
		}
    }
?>