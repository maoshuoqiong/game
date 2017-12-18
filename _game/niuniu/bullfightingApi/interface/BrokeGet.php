<?php
	/**
	 * 破产处理
	 */
    class BrokeGet extends APIBase {
		public $tag = "BrokeGet";
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		public function logic() {
			$player = $this->data_redis->hMGet("hu:{$this->uid}", array('money', 'broke_num', 'broke_time'));
			$broke_num = (int)$player['broke_num'];
			$broke_time = (int)$player['broke_time'];
			$broke_give_money = Game::$broke_give_money;	

			if ($player['money'] >= Game::$broke_money) {
				$this->returnError(301, '未达到破产条件');
			}
			
			$timestamp = strtotime(date("Y-m-d"));
			if ($broke_time < $timestamp or $broke_num < Game::$broke_num_max) {
				$money = $this->hincrMoney($broke_give_money,"brokeGet"); 
				if ($broke_time < $timestamp) {
					$this->data_redis->hset("hu:{$this->uid}", "broke_num", 1);
				} else {
					$this->data_redis->hincrBy("hu:{$this->uid}", "broke_num", 1);
				}
				$this->data_redis->hset("hu:{$this->uid}", "broke_time", time());
				
				$broke_info = array();
				$broke_info['money'] = $money;
				$broke_info['broke_give_money'] = $broke_give_money;
				
				$this->returnData($broke_info); 
			} else {
				$this->returnError(302, '当日破产超限');
			}
		}
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
		}
    }
?>