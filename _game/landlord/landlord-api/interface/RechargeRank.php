<?php
	/**
	 * 充值排行榜
	 */
    class RechargeRank extends APIBase {
		
		public $tag = "RechargeRank";
		
		public function before() {
			$this->initCacheRedis();
			$this->initMysql();
			return true;
		}

		public function logic() {
			$prizeStr = $this->cache_redis->get("sRechargeRank");
			if(!$prizeStr){
				$this->returnError(301, "还没有人上榜");
				return;
			}
			$prizeArr = json_decode($prizeStr);
			$mno = -1;
			$mam = 0;
			if(!empty($prizeArr) && sizeof($prizeArr)>0){
				foreach ($prizeArr as $g) {
					if($g->u==$this->uid){
						$mno = $g->no;
						$mam = $g->am;
					}
				}
			} 
			$ss = strtotime(date("Y-m-d"));
			if($mam==0){
				$temp = $this->mysql->select("payrecord", "sum(rmb) as rmb", array('uid' => $this->uid)," and create_time>".$ss);
				$mam = $temp[0]['rmb']==null?0:(int)$temp[0]['rmb'];
			}
// 			var_dump($prizeArr);
			$this->returnData(array('mno' => $mno,'mam' => $mam,'res' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
			$this->deinitMysql();
		}
    }
?>