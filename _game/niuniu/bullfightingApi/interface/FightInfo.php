<?php
	/**
	 * 比赛信息
	 */
    class FightInfo extends APIBase {

		public $tag = "FightInfo";
		
		public function before() {
			$this->initCacheRedis();
			$this->initMysql();
			return true;
		}

		public function logic() {	
			$myPoint = $this->data_redis->hmget("hpe:{$this->uid}", array('dayPoint', 'totalPoint'));
			$dayPoint = $myPoint['dayPoint']?(int)$myPoint['dayPoint']:0;
			$totalPoint = $myPoint['totalPoint']?(int)$myPoint['totalPoint']:0;
			$this->returnData(array(
				'money_limit' => Game::$fight_game_money_limit,
				'open_date' => Game::$fight_game_open_day,
				'open_time' => Game::$fight_game_open_time,
				'award_item' => $this->awardItemStr(), 
				'top_today' => $this->getRankList('sFTodayRank',$dayPoint),
				'top_week' => $this->getRankList('sFTotalRank',$totalPoint)
			));
		}		
		
		private function getRankList($topKey,$myAmout){
			$prizeStr = $this->cache_redis->get($topKey);
			if (! $prizeStr) {			
				return array (
					'mno' => -1,
					'mam' => 0,
					'ranks' => null
			);
			}
			$prizeArr = json_decode ( $prizeStr );
			$mno = - 1;
			$mam = 0;
			if (! empty ( $prizeArr ) && sizeof ( $prizeArr ) > 0) {
				foreach ( $prizeArr as $g ) {
					if ($g->uid == $this->uid) {
						$mno = $g->no;
						$mam = $g->amount;
					}
				}
			}	
			if ($mam == 0) {
				$mam = $myAmout;
			}
			return array (
					'mno' => $mno,
					'mam' => $mam,
					'ranks' => $prizeArr
			);
		}
		
		private function awardItemStr(){
			return Game::$fight_award_msg;
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>