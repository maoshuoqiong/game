<?php
	/**
	 * 获取Rank列表
	 */
    class RankList extends APIBase {
		
		public $tag = "RankList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$keys = $this->cache_redis->lRange("lr:ids", 0, -1);
			$ranks = array();
			$uid = 0;
			$mno = -1;
			$mam = 0;
			$rno = -1;
			$ram = 0;
			if(isset($_GET['uid'])){
				$uid = $_GET['uid'];
			}
			foreach ($keys as $key) {
				$rank = $this->cache_redis->hMGet("hr:{$key}", array("id", "type", "uid", "name", "sex", "no", "amount"));
				$rank["id"] = (int)$rank["id"];
				$rank["type"] = (int)$rank["type"];				
				$rank["uid"] = (int)$rank["uid"];
				$rank["sex"] = (int)$rank["sex"];
				$rank["no"] = (int)$rank["no"];
				$rank["amount"] = (int)$rank["amount"];
				if($uid==$rank["uid"]){
					if($rank["type"]==0){
						$mam = $rank["amount"];
						$mno = $rank["no"];
					}elseif ($rank["type"]==1){
						$ram = $rank["amount"];
						$rno = $rank["no"];
					}
					
				}
				$ranks[] = $rank;
			}
			
			$this->returnData(array('mno' => $mno,'mam' => $mam,'rno' => $rno,'ram' => $ram,'ranks' => $ranks));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>