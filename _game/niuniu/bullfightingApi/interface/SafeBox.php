<?php
	/**
	 * 保险箱
	 */
    class SafeBox extends APIBase {
		public $tag = "SafeBox";
		
		public function before() {
			$this->initMysql();
			return true;
		}
		public function logic() {
			$safeInfo = $this->data_redis->hMget("hu:{$this->uid}",array('money','safeboxflag','safeboxmoney'));
			// TODO
			/* if(!$safeInfo['safeboxflag']){				
				$this->returnError(301, '未开通保险箱');
				return;
			} */
			$currMoney = isset($safeInfo['money'])?(int)$safeInfo['money']:0;
			$safeMoney = isset($safeInfo['safeboxmoney'])?(int)$safeInfo['safeboxmoney']:0;
			if(isset($this->param['tobox']) && $this->param['tobox']>=0){
				$tobox = $this->param['tobox'];
				$bln = false;
				if($safeMoney>$tobox){
					$diff = $safeMoney - $tobox;
					$currMoney += $diff;
					$safeMoney = $tobox; 
					$bln = true;					
				}elseif ($safeMoney<$tobox){
					$diff = $tobox - $safeMoney;
					if($diff>$currMoney){
						$diff = $currMoney;
					}
					$currMoney -= $diff;
// 					$safeMoney += floor($diff*0.99);
					$safeMoney += $diff;
					$bln = true;
					/* $blog = array(
							'uid' => $this->uid,
							'tobox' => $diff,
							'currbox' => $safeMoney,
							'create_time' => date('Y-m-d H:i:s', time())
					);
					$this->mysql->insert("safeboxlog", $blog); */
				}	
				if($bln){
					$this->data_redis->hMset("hu:{$this->uid}",array('money'=>$currMoney,'safeboxmoney'=>$safeMoney));
				}			
			}			
			$this->returnData(array('currMoney'=>$currMoney,'safeMoney'=>$safeMoney));
		}
		
		public function after() {			
			$this->deinitMysql();
			$this->deinitDataRedis();
		}
    }
?>