<?php
	/**
	 * 连续登录奖励
	 */
    class LoginReward extends APIBase {
		
		public $tag = "LoginReward";
		
    	public function before() {
    		$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$flag = "rlist";
			if (isset($this->param['actType'])) {
				$flag = strtolower($this->param['actType']);
			}
			if($flag == "rres"){
				$login_info = $this->data_redis->hmGet("hu:{$this->uid}", array('login_days', 'is_get', 'vipLevel'));
				
				if($login_info !=null && sizeof($login_info)>0){
					$is_get = (int)$login_info['is_get'];
					if ($is_get == 0) {
						$index = (int) $login_info['login_days'];
						if ($index > 0) {
							$diff = $index%7;
							$diff = $diff==0?7:$diff;
							$award = $this->cache_redis->hMGet("hlr:{$diff}", array("contday","awardtype", "amount"));
							$this->data_redis->hSet("hu:{$this->uid}", "is_get", 1);
							$vipInfo = $this->getVipInfo($login_info['vipLevel']);
							if($vipInfo!=null && $vipInfo->ext_award>0){
// 								echo 2222222;
								$this->hincrMoney($vipInfo->ext_award,"viploginReward");
							}
							if((int)$award["awardtype"]==0){
								$money = $this->hincrMoney((int)$award["amount"],"loginReward");								
								$this->returnData(array('atype' => 0,'amount' => $money));
							}else if((int)$award["awardtype"]==1){
								$money = $this->hincrCoin((int)$award["amount"],"loginReward");
								$this->returnData(array('atype' => 1,'amount' => $money));
							}
							$this->hincrFunc ( "loginReward" );
						}
					}else{
						$this->returnError(321, '今天已领奖,明天再来吧');
					}
				}				
			}else{
				$keys = $this->cache_redis->lRange("llr:ids", 0, -1);
				$awardes = array();
				foreach ($keys as $key) {
					$award = $this->cache_redis->hMGet("hlr:{$key}", array("contday","awardtype", "amount"));
					$award["contday"] = (int)$award["contday"];
					$award["awardtype"] = (int)$award["awardtype"];
					$award["amount"] = (int)$award["amount"];
					$awardes[] = $award;
				}
				$this->returnData(array('res' => $awardes));
			}			
		}
		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
		}
    }
?>