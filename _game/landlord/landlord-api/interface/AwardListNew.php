<?php
	/**
	 * 获取award列表
	 */
    class AwardListNew extends APIBase {
		
		public $tag = "AwardListNew";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$keys = $this->cache_redis->lRange("lawn:ids", 0, -1);
			$awardes = array();
			foreach ($keys as $key) {
				$award = $this->cache_redis->hMGet("haw:{$key}", array("id","type",
						 "coin", "name","imag","num","desc","start_time","end_time"));
				$aw["i"] = (int)$award["id"];
				$aw["t"] = (int)$award["type"];
				$aw["c"] = (int)$award["coin"];
				$aw["na"] = $award["name"];
				$aw["im"] = $award["imag"];
				$aw["nu"] = (int)$award["num"];
				$aw["dc"] = $award["desc"];
				$aw["st"] = (int)$award["start_time"];
				$aw["et"] = (int)$award["end_time"];
				$awardes[] = $aw;
			}
			$this->returnData(array('res' => $awardes));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>