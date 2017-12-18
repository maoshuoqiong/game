<?php
	/**
	 * 获取Rank列表
	 */
    class RankListNew extends APIBase {
		
		public $tag = "RankListNew";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$keys = $this->cache_redis->lRange("lr:ids", 0, -1);
			$ranks = array();
			$uid = 0;
			$type = 0;
			$no = 0;
			$am = 0;
			if(isset($this->param['uid'])){
				$uid = $this->param['uid'];
			}
			if(isset($this->param['type'])){
				$type = $this->param['type'];
			}
			foreach ($keys as $key) {
				$rank = $this->cache_redis->hMGet("hr:{$key}", array("id", "type", "uid", "name", "sex", "no", "amount"));
				if($type!=$rank["type"]){
					continue;
				}
				$rank["id"] = (int)$rank["id"];
				$rank["type"] = (int)$rank["type"];				
				$rank["uid"] = (int)$rank["uid"];
				$rank["sex"] = (int)$rank["sex"];
				$rank["no"] = (int)$rank["no"];
				$rank["amount"] = (int)$rank["amount"];
				if($uid==$rank["uid"]){
					$am = $rank["amount"];
					$no = $rank["no"];
				}
				$ranks[] = $rank;
			}
			
			$this->returnData(array('no' => $no,'am' => $am,'ranks' => $ranks));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>