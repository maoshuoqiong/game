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
			$total_board = isset($user['total_board']) ? (int)$user['total_board'] : 0;
			$total_win = isset($user['total_win']) ? (int)$user['total_win'] : 0;
			$total_lose = $total_board - $total_win;
			
			/*
			$hasRcRes = 0;
			$hasRc = $this->data_redis->hMget("hpe:{$this->uid}", array("hasRecharge", "lastNoticeT" ));	
			$lastNotice = $this->cache_redis->hMget("hnoticeall",array("lasttime","msg"));
			$lastNt = isset($hasRc['lastNoticeT']) ? (int) $hasRc['lastNoticeT'] : 0;
			$not = "";
			if(isset($lastNotice['lasttime']) && isset($lastNotice['msg'])
				&& ($lastNotice['lasttime']!=$lastNt || $lastNt==0)){
				$not = $lastNotice['msg'];
				$this->data_redis->hSet("hpe:{$this->uid}", "lastNoticeT",$lastNotice['lasttime']);
			}	
			*/
			
			//用户礼物
			$gifts = $this->data_redis->hGetAll("ugift:{$this->uid}");
			$g1 = isset($gifts['1']) ? (int)$gifts['1'] : 0;
			$g2 = isset($gifts['2']) ? (int)$gifts['2'] : 0;
			$g3 = isset($gifts['3']) ? (int)$gifts['3'] : 0;
			$g4 = isset($gifts['4']) ? (int)$gifts['4'] : 0;
			$g5 = isset($gifts['5']) ? (int)$gifts['5'] : 0;
			$now = time();
			$user_info = array(
					'uid' => (int) $this->uid,
					'user' =>$user['user'],
					'name' => $user['name'],
					'sex' => (int) $user['sex'],
					'money' => (int) $user['money'],
					//'rmb' => isset( $user['rmb']) ? (int) $user['rmb'] : 0,
					'coin' => (int) $user['coin'],					
					'history' => array((int) $total_win, (int) $total_lose),					
					//'exp' =>  isset($user['exp']) ? (int)$user['exp'] : 0,
					'skey' => $user['skey'],
					//'hasrc' =>  isset($hasRc['hasRecharge']) ? (int)$hasRc['hasRecharge'] : 0,
					'telCharge' => isset($user['telCharge']) ? (int)$user['telCharge'] : 0,
					'mob' => isset($user['mobile']) && strlen($user['mobile'])>0 ? $user['mobile'] : "0",
					//'notice' => $not,
					'vip' =>isset($user['vipLevel']) ? (int) $user['vipLevel'] : 0,
					'userChange' =>isset($user['isauto']) ? (int) $user['isauto'] : 1,
					'sign' => isset($user['sign']) ? $user['sign'] : "",
					'charm' => isset($user['charm']) ? (int)$user['charm'] : 0,
					'level' => isset ( $user ['level'] ) ? ( int ) $user ['level'] : 1  ,
					'title' => $this->getTitleInfo((int)$user ['money']),
					'gift' => array($g1, $g2, $g3, $g4, $g5)//玩家获得的各种礼物数量 按礼物id 从小到大( 1 ~ 5)排序 
			);
			$this->returnData($user_info);
		}
		
       	public function after() {
       		$this->deinitCacheRedis();
    		$this->deinitDataRedis();
		}
    }
?>