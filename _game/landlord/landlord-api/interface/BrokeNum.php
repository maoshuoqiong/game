<?php
	/**
	 * 当天剩余破产次数
	 */
    class BrokeNum extends APIBase {
		public $tag = "BrokeNum";
		
		public function logic() {
			$player =  $this->data_redis->hMGet("hu:{$this->uid}", array('broke_num', 'broke_time'));
			$broke_num = (int)$player['broke_num'];
			$broke_time = (int)$player['broke_time'];
			
			$timestamp = strtotime(date("Y-m-d"));
			$broke_info = array();
			if ($broke_time < $timestamp) {
				$broke_info['num'] = Game::$broke_num_max-1;
			} else {
				$broke_info['num'] = Game::$broke_num_max - 1 - $broke_num;
			}
			$broke_info['bn'] = $broke_info['num']+1;
			if($broke_info['num']<0){
				$broke_info['num'] = 0;
			}
			
			$broke_info['total'] = Game::$broke_num_max;
			$broke_info['money'] = Game::$broke_give_money;
			$this->returnData($broke_info);
		}
		
		public function after() {
    		$this->deinitDataRedis();
		}
    }
?>