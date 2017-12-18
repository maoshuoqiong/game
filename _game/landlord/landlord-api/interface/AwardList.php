<?php
	/**
	 * 获取award列表
	 */
    class AwardList extends APIBase {
		
		public $tag = "AwardList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$keys = $this->cache_redis->lRange("law:ids", 0, -1);
			$awardes = array();
			foreach ($keys as $key) {
				$award = $this->cache_redis->hMGet("haw:{$key}", array("id","type",
						 "coin", "name","imag","num","desc","start_time","end_time"));
				$award["id"] = (int)$award["id"];
				$award["type"] = (int)$award["type"];
				$award["coin"] = (int)$award["coin"];
				$award["name"] = $award["name"];
				$award["imag"] = $award["imag"];
				$award["num"] = (int)$award["num"];
				$award["desc"] = $award["desc"];
				$award["start_time"] = (int)$award["start_time"];
				$award["end_time"] = (int)$award["end_time"];
				$awardes[] = $award;
			}
			$this->returnData(array('res' => $awardes));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>