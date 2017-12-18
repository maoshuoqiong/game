<?php
	/**
	 * 活动排行榜
	 */
    class ActivityRank extends APIBase {
		
		public $tag = "ActivityRank";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['id'])) {
				$this->returnError(301, '榜单不存在');
				return;
			}
			$prizeStr = $this->cache_redis->get("activityrank:{$this->param['id']}");
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
			
			if($mno==-1){
				$mon = $this->data_redis->hMget("hactivity:{$this->uid}",array("actWinMonDay",
						"actWinMonTot","actRatio","actWinMoney","actBoardWin"));
				$prizeStr2 = $this->cache_redis->get("activitylist");
				if(!$prizeStr2){
					$this->returnError(301, '榜单不存在');
					return;
				}
				$prizeArr2 = json_decode($prizeStr2);
// 				var_dump($prizeArr2);
				foreach ($prizeArr2 as $g) {
					if($this->param['id']==$g->id){
						if($g->at==0){
							//日赚金币榜
							$mam = isset($mon['actWinMonDay'])?(int)$mon['actWinMonDay']:0;
						}elseif ($g->at==1){
							//总赚金币榜
							$mam = isset($mon['actWinMonTot'])?(int)$mon['actWinMonTot']:0;
						}elseif ($g->at==2){
							//日最高倍率榜
							$mam = isset($mon['actRatio'])?(int)$mon['actRatio']:0;
						}elseif ($g->at==3){
							//日最高赢局榜
							$mam = isset($mon['actBoardWin'])?(int)$mon['actBoardWin']:0;
						}elseif ($g->at==4){
							//日单局赚金币榜
							$mam = isset($mon['actWinMoney'])?(int)$mon['actWinMoney']:0;
						}
					}					
				}
			}
// 			var_dump($prizeArr);
			$this->returnData(array('mno' => $mno,'mam' => $mam,'res' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
		}
    }
?>