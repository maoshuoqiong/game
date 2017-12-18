<?php
	/**
	 * 获取场馆列表(TEST)
	 */
    class VenueTestList extends APIBase {
		
		public $tag = "VenueTestList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("svetlist");
			$prizeArr = json_decode($prizeStr);
			foreach ($prizeArr as $g) {
				if ($g->vid == 1) {
					$g->olnum = mt_rand(1000, 3000);
				} elseif ($g->vid == 2) {
					$g->olnum = mt_rand(500, 1500);
				}  elseif ($g->vid == 3) {
					$g->olnum = mt_rand(200, 800);
				}  elseif ($g->vid == 4) {
					$g->olnum = mt_rand(50, 300);
				}  else {
					$g->olnum = mt_rand(500, 1000);
				}
			}
			$this->returnData(array('venues' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>