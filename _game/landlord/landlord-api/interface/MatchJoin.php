<?php
	/**
	 * 报名比赛
	 */
    class MatchJoin extends APIBase {		
		public $tag = "MatchJoin";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param ['id'] ) || !isset($this->param ['act'] )) {
				$this->returnError ( 301, '1参数错误，比赛不存在');
				return;
			}
			$id = $this->param ['id'];		// 比赛场馆ID
			$act = $this->param ['act'];	// cancle退赛，join参赛
			
			$tt = $this->cache_redis->hGetAll('hMatchStatus');
			var_dump($tt);
					
			$key = "matchJoin:".$id;
			$mj = $this->cache_redis->get($key);
			var_dump($mj);
			$mjArr = json_decode($mj);
			$currJoiner = sizeof($mjArr);
			$tb = $this->cache_redis->hGetAll("hmatch:".$id);
			if($tb==null){
				$this->returnError ( 301, '2比赛不存在,请重试');
				return;
			}
			$pMatch = $this->data_redis->hGet("hu:{$this->uid}", 'matchId');
			var_dump($pMatch);
			// 处在比赛中
			if($pMatch){
				$this->returnError ( 301, '3已经在比赛中了');
				return;
			}
			
			if($act=='cancle'){
				if(sizeof($mjArr)>0 && in_array($this->uid, $mjArr)){
					$this->cancleMatch($key,$tb,$mjArr);
				}else{
					$this->returnError ( 301, '6退赛失败，未报名');
					return;
				}
			}elseif($act=='join') {
				if(sizeof($mjArr)<=0 || !in_array($this->uid, $mjArr)){
					$res = $this->joinMatch($key,$tb,$mjArr);	
					if($res==-1){
						$this->returnError ( 301, '4报名失败，金币不足');
						return;
					}elseif($res==-2){
						$this->returnError ( 301, '5报名失败，元宝不足');
						return;
					}
				}else{
					$this->returnError ( 301, '7参赛失败，已报名');
					return;
				}
			}else{
				$this->returnError ( 301, '8非法操作');
				return;
			}	
			$pu = $this->data_redis->hMget("hu:{$this->uid}", array('money', 'coin'));
			$this->returnData(array('res' => 0,'money' => $pu['money'],'coin' => $pu['coin']));
		}		
		
		private function cancleMatch($key,$tb,$mjArr){
			$mjTemp = array();
			foreach ($mjArr as $val){
				if($val!=$this->uid){
					$mjTemp[] = $val;
				}
			}
			// 取消报名退费
			/* if($tb['paymoney']!=0){
				if($tb['paytype']==0){
					$this->data_redis->hIncrBy("hu:{$this->uid}",'money',floor($tb['paymoney']*0.9));					
				}else{					
					$this->data_redis->hIncrBy("hu:{$this->uid}",'coin',floor($tb['paymoney']*0.9));					
				}
			} */
			var_dump($mjTemp);
			$this->cache_redis->set($key,json_encode($mjTemp));
		}
		
		private function joinMatch($key,$tb,$mjArr){
			$pu = $this->data_redis->hMget("hu:{$this->uid}", array('money', 'coin'));
			if($tb['paymoney']!=0){
				if($tb['paytype']==1){					
					if($pu['money']<$tb['paymoney']){						
						return -1;
					}
					$this->data_redis->hIncrBy("hu:{$this->uid}",'money',0-$tb['paymoney']);					
				}elseif($tb['paytype']==2){				
					if($pu['coin']<$tb['paymoney']){						
						return -2;
					}
					$this->data_redis->hIncrBy("hu:{$this->uid}",'coin',0-$tb['paymoney']);					
				}
			}
			$mjArr[] = $this->uid;	
			var_dump($mjArr);
			$this->cache_redis->set($key,json_encode($mjArr));
			return 1;
		}
		
    	public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
		}
    }
?>