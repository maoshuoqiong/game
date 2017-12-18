<?php
	/**
	 * 获取在玩人数
	 */
    class OnPlayInfo extends APIBase {
		
		public $tag = "OnPlayInfo";
		public $isLogin = false;
		
    	public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$venueids = $this->cache_redis->lRange("lv:ids", 0, -1);
			$venues = array();
			$total_count = 0;
			$count = 0;
			foreach ($venueids as $vid) {
				if ($vid == 1) {
					$count = mt_rand(1000, 3000);
				} elseif ($vid == 2) {
					$count = mt_rand(500, 2000);
				}  elseif ($vid == 3) {
					$count = mt_rand(200, 800);
				}  elseif ($vid == 4) {
					$count = mt_rand(50, 300);
				}  else {
					$count = mt_rand(500, 1000);
				}				
				$total_count += $count;
				$venues[$vid] = $count;
			} 
			
			return $this->returnData(array('total_count' => $total_count, 'venues' => $venues));
		}
		
		public function after() {
			$this->deinitCacheRedis();
		}
    }
?>