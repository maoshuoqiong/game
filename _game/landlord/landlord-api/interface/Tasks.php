<?php
	/**
	 * 任务
	 */
    class Tasks extends APIBase {

		public $tag = "Tasks";
		public $TYPE_ACH_LIST = "ach";			// 成就任务
		public $TYPE_DAY_LIST = "day";			// 日常任务
		public $TYPE_ROU_LIST = "rou";			// 牌局任务
		
		public function before() {
			$this->initCacheRedis();
			$this->initMysql();
			return true;
		}

		public function logic() {
			if (!isset($this->param['ttype'])) {
				$this->returnError(301, '非法操作');
				return;
			}
			$ttype = $this->param['ttype'];
			if($ttype == $this->TYPE_DAY_LIST){
				return $this->resDay();
			}else if($ttype == $this->TYPE_ACH_LIST){
				return $this->resAch();
			}else{
				return $this->resRou();
			}
		}		
		
		private function resRou(){
			$row = $this->cache_redis->sMembers("staskr:ids");
			$res = CommonTool::dataArr($this->cache_redis,$row,"htaskr:");
			return $this->returnData(array('sub' => $res));			
		}
		
		private function getItem($res,$id){
			foreach ($res as $r) {
				if ($r['i']==$id) {
					return $r;
				}
			}
			return null;
		}
		
		private function resAch(){	
			$row = $this->cache_redis->lRange("ltaska:ids", 0, -1);
			$res = CommonTool::dataArr($this->cache_redis,$row,"htaska:");
			$pdtask = $this->data_redis->hGetAll("hubta:{$this->uid}");
			$pInfo = CommonTool::getFormatPinfo($this->data_redis,$this->uid);
			if(isset($this->param['id']) && $this->param['id']>0){
				$item = $this->getItem($res,$this->param['id']);
				if ($item==null) {
					$this->returnError(305, '任务类型不符');
					return;
				}
				$flag = $this->awardTask($item,$pdtask,"hubta:{$this->uid}",$pInfo);
				if($flag==0){
					$this->returnError(303, '未达到领奖条件');
				}elseif ($flag==1){
					$pdtask['g'.$this->param['id']] = 2;
				}elseif ($flag==2){
					$this->returnError(304, '已经领过奖了');
				}elseif ($flag==3){
					$this->returnError(304, '下手慢了，已被抢光');
				}
			}				
			$res = CommonTool::pBindTask($res,$pdtask,$pInfo);
			$hasRewardNum = CommonTool::rewardNum($res,$pdtask,$pInfo);	// 可领奖条数
// 			var_dump($res);
			$mon = $this->data_redis->hMget("hu:{$this->uid}",array("money","coin"));
			return $this->returnData(array('mon' => (int)$mon['money'],'coin' => (int)$mon['coin'],'gettask' => (int)$hasRewardNum,'sub' => $res));
		}	
		
		private function resDay(){	
			$row = $this->cache_redis->lRange("ltaskd3:ids", 0, -1);
			$res = CommonTool::dataArr($this->cache_redis,$row,"htaskd:");
			$now = time();
			$ldd = $this->data_redis->hGetAll("hpe:{$this->uid}");
			$isSameDay = (isset($ldd['lastDayTaskDate']) && CommonTool::isSameDay($ldd['lastDayTaskDate'], $now));
			if(!$isSameDay){
				$this->data_redis->del("hubtd:{$this->uid}");
				$this->data_redis->hSet("hpe:{$this->uid}","lastDayTaskDate",$now);
			}
			$pdtask = $this->data_redis->hGetAll("hubtd:{$this->uid}");
			$pInfo = CommonTool::getFormatPinfo($this->data_redis,$this->uid);
			if(isset($this->param['id']) && $this->param['id']>=0){
				$flag = 0;
				$item = $this->getItem($res,$this->param['id']);
				if ($item==null) {
					$this->returnError(305, '任务类型不符');
					return;
				}
				$flag = $this->awardTask($item,$pdtask,"hubtd:{$this->uid}",$pInfo);								
				if($flag==0){
					$this->returnError(303, '未达到领奖条件');
				}elseif ($flag==1){
					if($this->param['id']==0){
						$this->hincrFunc("dayTasks");
					}
					$pdtask['g'.$this->param['id']] = 2;
				}elseif ($flag==2){
					$this->returnError(304, '已经领过奖了');
				}elseif ($flag==3){
					$this->returnError(304, '下手慢了，已被抢光');
				}		
			}					
			$res = CommonTool::pBindTask($res,$pdtask,$pInfo);		
			$hasRewardNum = CommonTool::rewardNum($res,$pdtask,$pInfo);	// 可领奖条数
// 			var_dump($res);
			$mon = $this->data_redis->hMget("hu:{$this->uid}",array("money","coin"));
			return $this->returnData(array('mon' => (int)$mon['money'],'coin' => (int)$mon['coin'],'gettask' => (int)$hasRewardNum,'sub' => $res));
		}	
		
		private function awardTask($res,$pt,$k,$pInfo){
			$t = CommonTool::filter($res,$pt,$pInfo);
			if($t['g']==0){
				return 0;
			}elseif($t['g']==2){
				return 2;
			}			
			if($res['a']==0){
				$this->hincrMoney($res['m'],"tasks");
			}elseif ($res['a']==1){
				$this->hincrCoin($res['m'],"tasks");
			}
			$this->data_redis->hSet($k,"g{$t['i']}",2);
			$awardlog = array(
					'uid'=> $this->uid,
					'taskid' => $t['i'],
					'awardtype'=> $res['a'],
					'awardamount'=> $res['m'],
					'create_time'=> time()
			);		
			if($res['a']==1 || $res['m']>2000){
				$this->sendBroadcast("恭喜".$this->getPlayerName()."完成了任务".$res['t'].",领取了".$res['m'].$this->getMoneyUnit($res['a'])."奖励", "2");
			}			
			$this->mysql->insert("tasksawardlog", $awardlog);
			return 1;			
		}		
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>