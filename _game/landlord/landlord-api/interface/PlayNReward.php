<?php
	/**
	 * 玩N局奖励
	 */
    class PlayNReward extends APIBase {
		
		public $tag = "PlayNReward";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$now = time();
			$uid = $this->uid;
			$play_n_count = Game::$play_n_count;
			$lua_stat = <<<"EOT"
local i = redis.call('HGET', 'hu:$uid', 'play_count') + 0
if i >= $play_n_count then
	redis.call('HSET', 'hu:$uid', 'play_count', 0)
end
return i
EOT;
			$n = $this->data_redis->eval($lua_stat);
			if ($n >= Game::$play_n_count) {
				$reward = $this->get_play_n_money();
				$money = $this->hincrMoney($reward,"playNReward");
				$this->returnData(array('money' => $money, 'reward' => $reward));
			} else {
				$this->returnError(1, 'more ' . (Game::$play_n_count - $n));
			}
		}
		
		private function get_play_n_money() {
			$i = count(Game::$play_n_reward_money) - 1;
			$i = mt_rand(0, $i);
			$money = Game::$play_n_reward_money[$i];
			return $money;
		}
    		
        public function after() {
			$this->deinitDataRedis();
		}
    }
?>