<?php
	/**
	 * 抽奖信息
	 */
    class lotteryInfo extends APIBase {
		
		public $tag = "lotteryInfo";
		public $isLogin = false;
		
		public function before() {
			return true;
		}

		public function logic() {
			$info = array();
			$info["lottery_isopen"] = Game::$lottery_isopen;
			$info["lottery_money"] = Game::$lottery_money;
			$this->returnData($info);
		}
		
    	public function after() {
		}
    }
?>