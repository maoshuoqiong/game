<?php
	/**
	 * 抽奖
	 */
    class Slot extends APIBase {

		public $tag = "Slot";
		public $SLOT_BIRD = -1;			// 飞禽
		public $SLOT_WILD = 0;			// 走兽
		public $SLOT_SILVER = 1;		// 银鲨
		public $SLOT_GLOD = 2;			// 金鲨

		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (Game::$slot_isopen == 0) {
				$this->returnError(300, '老虎机已关闭');
				return;
			}
			if (!isset($this->param['at'])) {
				$this->returnError(301, '参数错误');
				return;
			}
			$cv = $this->data_redis->hget("hpe:{$this->uid}", 'cur_ver');
			if(!$cv || (int)$cv<Game::$slot_limit_client_ver){
				$this->returnError(300, '请先更新游戏版本');
				return;
			}
			$prizeStr = $this->cache_redis->get("sslot");
			$lotteryPrize = array();
			$prizeArr = json_decode($prizeStr);
			$mon = $this->data_redis->hget("hu:{$this->uid}", 'money');
// 			var_dump($prizeArr);
			if($this->param['at']=="list"){	
				foreach ($prizeArr as $key) {
					$t["id"] = $key->id;
					$t["od"] = $key->od;
					$awardes[] = $t;
				}
				return $this->returnData(array('mon' => (int)$mon,'ba' => Game::$slot_base,'bl' => Game::$slot_limit, 'res' => $awardes));
			}else if($this->param['at']=="bl"){	
				return $this->returnData(array('bl' => Game::$slot_limit,'rt' => Game::$slot_round_time));
			}else if($this->param['at']=="bet"){
				$ba = Game::$slot_base;
				if(isset($this->param['ba'])){
					$ba = abs($this->param['ba']);
				}
				if(!isset($this->param['zhu'])){
					$this->returnError(302, '没有押注');
					return;
				}	
				$zhu = (array)json_decode($this->param['zhu']);
				if(sizeof($zhu)<=0){
					$this->returnError(302, '没有押注');
					return;
				}
				// cal res
				$inc = 0;
				$item = null;
				foreach ($zhu as $key => $val) {
					$inc += $val;
				}
				$mustloseRand = mt_rand(1, 100);
// 				echo "loseRand:".$mustloseRand."\n";
				$lost_ratio = Game::$slot_lost_ratio;
				if($mon>10000000){
					$lost_ratio = Game::$slot_black_lost_ratio;
				}
				// must lose
				if($mustloseRand<$lost_ratio){
// 					echo "mustloseRes\n";
					$birds = isset($zhu['i-1'])?1:0;
					$beast = isset($zhu['i0'])?1:0;
					$temp = array();
					foreach ($prizeArr as $key) {
						if(!isset($zhu['i'.$key->id])){
							$temp[] = $key;
						}
					}
					$item = $this->calItem($prizeArr,$temp,$birds,$beast);
				}
				if($item==null){ // rand lose
// 					echo "RandRes\n";
					$rand = mt_rand(1, 10000);
					$cal = 0;
					$id = 0;
					foreach ($prizeArr as $key) {
						$cal += $key->pb;
						$id = $key->id;
						if($cal>=$rand && $item==null){
							$item = $key;
						}
					}
				}
				$awd = 0;
				if(isset($zhu['i0'])){
					if($item->tp==0){
						$awd += $zhu['i0']*19*$ba/10;
					}					
				}
				if(isset($zhu['i-1'])){
					if($item->tp==-1){
						$awd += $zhu['i-1']*19*$ba/10;
					}
				}
				 
				$needM = $inc*$ba;
				if($mon<$needM){
					$this->returnError(302, '金币不足');
					return;
				}
				// 加金币派奖
				if($item->id>0 && isset($zhu['i'.$item->id])){
					$awd += $zhu['i'.$item->id]*$item->od*$ba;
				}
				$res = $awd - $needM;
				/* echo "id:".$item->id."\n";
 				echo "needM:".$needM."\n";
				echo "awd:".$awd."\n"; 
				echo "res:".$res."\n"; */
				if($res!=0){
					$this->hincrMoney($res,"slot");
					$mon = $this->data_redis->hGet("hu:{$this->uid}", 'money');
				}
				if($item->tp>0 && $awd>0){
					// 发送个人通知
					$name = $this->data_redis->hGet("hu:{$this->uid}", 'name');
					$msg = "天降福星!".$name."在老虎机中押中".$item->dc.",获得".$awd."金币！";
					$this->sendBroadcast($msg,"slot");					
				}
				$this->hincrFunc("slot");
// 				return $this->returnData(array('mon' => (int)$mon,'wmon' => $awd,'res' => $item->id));
				$coinStatus = $this->awardCoin();
 				return $this->returnData(array('mon' => (int)$mon,'wmon' => $awd,'res' => $item->id,
						'currn' => (int)$coinStatus['currn'],'wcoin' => (int)$coinStatus['wcoin'])); 
			}else{
				$this->returnError(303, '非法请求');
				return;
			}
		}
		
		private function awardCoin(){
			$coinStatus['wcoin'] = 0;
			$coinStatus['currn'] = 0;
			if(Game::$slot_rewardcoin_period==0){
				return $coinStatus;
			}
			$num = (int)$this->cache_redis->get("sslotnum");
			if($num>=Game::$slot_rewardcoin_period-1){
				$num = 0;
				$randNum = rand(Game::$slot_rewardcoin_min, Game::$slot_rewardcoin_max);
				$this->hincrCoin($randNum, "slotCoin");				
				$coinStatus['wcoin'] = $randNum;

				$name = $this->data_redis->hGet("hu:{$this->uid}", 'name');
				$msg = "鸿运当头！".$name."在老虎机中获得".$randNum."元宝！";
				$this->sendBroadcast($msg,"slotCoin");
			}else {
				$num++;
			}
			$this->cache_redis->set("sslotnum",$num);
			$coinStatus['currn'] = $num;
			return $coinStatus;
		}
		
		private function calItem($prizeArr,$temp,$birds,$beast){
// 			var_dump($temp);
			if($birds==$beast){
				if(!empty($temp) && sizeof($temp)>0){
					shuffle($temp);
					return $temp[0];
				}
			}else if($beast==0){
				if(!empty($temp) && sizeof($temp)>0){
					shuffle($temp);
					foreach ($temp as $key) {
						if($key->id>4){
							return $key;
						}
					}
					return $temp[0];
				}
			}else if($birds==0){
				if(!empty($temp) && sizeof($temp)>0){
					shuffle($temp);
					foreach ($temp as $key) {
						if($key->id>8 || $key->id<5){
							return $key;
						}
					}
					return $temp[0];
				}
			}
			return null;
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>