<?php
	/**
	 * 新手引导
	 */
    class GuideAward extends APIBase {

		public $tag = "GuideAward";

		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$isGet = $this->data_redis->hGet("hpe:{$this->uid}",'isGetGuideAward');
			if($isGet && $isGet==1){
				$this->returnError(301, "已领新手奖励" );
				return;
			}
			$awardMoney = Game::$guide_money;
			$this->data_redis->hSet("hpe:{$this->uid}",'isGetGuideAward',1);
			$money = $this->hincrMoney($awardMoney, 'guideAward');
			$this->returnData(array('curr_money'=>$money));			
		}		
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>