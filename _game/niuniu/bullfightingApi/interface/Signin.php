<?php
/**
 * 签到
 */
class Signin extends APIBase {
	public $tag = "Signin";
	public $resMsg = "";
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	
	public function logic() {
		$now = time ();	
// 		$now = strtotime("2014-10-01 10:01:00");	
		$dateArr = getdate();
		$mDay = $dateArr['mday'];
		$pSignin = CommonTool::getPSigninInfo($this,$this->uid,$mDay,$now);
		$pUinfo = $this->data_redis->hMget ( "hu:{$this->uid}", array ("vipLevel","login_days"));
		$vlevel = (isset($pUinfo ['vipLevel']) && (int)$pUinfo['vipLevel']>0) ? (int)$pUinfo['vipLevel']: 0;
		$login_days = (int)$pUinfo ['login_days'];		
		$needUp = false;
		$resMsg = "";
		
		$data_cont = $this->cache_redis->get ( "ssignin:cont" );
		$data_tot = $this->cache_redis->get ( "ssignin:tot" );
		$data_vip = $this->cache_redis->get ( "ssignin:vip" );
		$arr_cont = json_decode($data_cont);
		$arr_tot = json_decode($data_tot);
		$arr_vip = json_decode($data_vip);		
		/*
			tot_sign:本月累计签到次数
			last_sign_time:最后一次签到时间
			last_vip_time:最后一次领取VIP奖励的时间
			has_sign:本月已签到列表
		*/
		$diffSignDay = CommonTool::getDiffBetweenTwoDate ( $pSignin ['last_sign_time'], $now );
		$isSameVipDay = CommonTool::isSameDay ( $pSignin ['last_vip_time'], $now );

		$tot_item = CommonTool::getTot_item($pSignin,$arr_tot,$diffSignDay,$needUp);
		$cont_item = CommonTool::getCont_item($pSignin,$arr_cont,$diffSignDay,$login_days,$needUp);
		$vip_item = CommonTool::getVip_item($pSignin,$arr_vip,$vlevel,$isSameVipDay,$this);
// 		var_dump($vip_item);
		if (isset ( $this->param ['id'])) {
			$id =  $this->param ['id'];
			$res = -1;
			if(strncmp($id, 't', 1)===0){
				$res = $this->awardItem($id,$tot_item,$pSignin);
				if($res==1){
					$this->hincrFunc("signinTot");
				}
			}elseif (strncmp($id, 'v', 1)===0){
				$res = $this->awardItem($id,$vip_item,$pSignin);
				if($res==1){
					$pSignin['last_vip_time'] = $now;
					$this->hincrFunc("signinVip");
				}
			}elseif (strncmp($id, 'c', 1)===0){
				$res = $this->awardItem($id,$cont_item,$pSignin);
				if($res==1){
					$pSignin['last_sign_time'] = $now;
					$pSignin['tot_sign'] += 1;
					$sType = $this->calSignType($id,$cont_item);
					$this->upHasSign($pSignin,$mDay,$sType);
					$tot_item = CommonTool::getTot_item($pSignin,$tot_item,$diffSignDay,$needUp);
					$this->hincrFunc("signinCont");
				}
			}			
			if($res==1){
// 				echo "get res 1<br/>";
				$needUp = true;
			}
		}
		if($needUp){
// 			echo "needUp data<br/>";
// 			var_dump($pSignin);
			$this->data_redis->hMset("uSignin:{$this->uid}",$pSignin);
		}
		$pInfo = $this->data_redis->hMget("hu:{$this->uid}",array('coin','money','level'));
//  		var_dump($tot_item);
// 		var_dump($cont_item);
// 		var_dump($vip_item);
		$retInfo = array(
			'date'=>date('Y-m-d', $now),
			'week'=>$dateArr['wday'],
			'money'=>(int)$pInfo['money'],
			'coin'=>(int)$pInfo['coin'],
			'level'=>(int)$pInfo['level'],
			'total_sign'=>(int)$pSignin['tot_sign'],
			'cont_login'=>$login_days,
			'has_sign'=>$pSignin['has_sign'],
			'cont_item'=>$cont_item,
			'vip_item'=>$vip_item[0],
			'tot_item'=>$tot_item
		);
// 		var_dump($retInfo);
		$this->returnData($retInfo,0,$this->resMsg);
	}
	
	private function calSignType($id,$cont_item){
		$type = 1;
		$maxAmount = 0;
		$currAmount = 0;
		foreach ($cont_item as $item){
			if($item->isget>0 && $item->amount>$maxAmount){
				$maxAmount = $item->amount;
			}
			if($id == $item->id){
				$currAmount = $item->amount;
			}
		}
		if($maxAmount>$currAmount){
			$type = 2;
		}
// 		echo $maxAmount.":".$currAmount.":".$type;
		return $type;
	}
	
	/**
	 * 更新已签列表
	 * @param unknown $pSignin
	 * @param unknown $mDay
	 * @param unknown $sType：1，当日签到；2，补签
	 */
	private function upHasSign(&$pSignin,$mDay,$sType){
		$currLen = strlen($pSignin['has_sign']);
		$diff = $mDay - $currLen;
		if($diff>0){
			if($sType==1){
				$pSignin['has_sign'] .= "1";
			}elseif ($sType==2){
				$pSignin['has_sign'] = substr($pSignin['has_sign'], 0,$currLen-1).'1';
			}
		}else{
			if ($sType==2){
				$pSignin['has_sign'] = substr($pSignin['has_sign'], 0,$currLen-2).'11';
			}
		}
	}
	
	private function awardItem($id,&$items,&$pSignin){
		$res = -1;
// 		echo '###id:'.$id.'<br/>';
		foreach ($items as $item){
			if($item->id == $id){
				$res = $item->isget;
				if ($item->isget==1){
// 					echo '***isget:'.$item->isget.'<br/>';
					$item->isget = 2;
					$pSignin[$id] = 2;
					$this->awardSignin($item);	
				}
				break;					
			}
		}
		if($res==-1){
			$this->resMsg = "领奖失败,非法操作!";
		}elseif ($res==0){
			$this->resMsg = "领奖失败,未达到条件";
		}elseif ($res==2){
			$this->resMsg = "领奖失败,已领过奖";
		}
		return $res;
	}
	
	private function awardSignin($awardItem){
		// 0：金币,1：元宝,2：礼物,3：魅力值,4：经验值
		$awards = $awardItem->award;
		$temp = "获得 ";
		$amoney = 0;
		$acoin = 0;
		$aexp = 0;
		$atype = 0;
		$atotal = substr($awardItem->id, 1);
		if(strncmp($awardItem->id, 'v', 1)===0){
			$atype = 1;
		}else if(strncmp($awardItem->id, 't', 1)===0){
			$atype = 2;
		}
		foreach ($awards as $item){
			if($item->at == 0){
				$this->hincrMoney($item->an, 'signin');
				$amoney = $item->an;
				$temp .= $item->an."金币,";
			}elseif ($item->at == 1){
				$this->hincrCoin($item->an, 'signin');
				$acoin = $item->an;
				$temp .= $item->an."元宝,";
			}elseif ($item->at == 2){
				$this->data_redis->hIncrBy("ugift:{$this->uid}",$item->an,1);
				$this->data_redis->hSet("ugift:{$this->uid}",'tm',time());
				$temp .= CommonTool::getGiftName($item->an).'X'.$item->an.',';
			}elseif ($item->at == 3){
				$this->data_redis->hIncrBy("hu:{$this->uid}","charm",$item->an);
				$temp .= $item->an."魅力值,";
			}elseif ($item->at == 4){
				$this->hincrExp($item->an);
				$aexp = $item->an;
				$temp .= $item->an."经验值,";
			}		
		}
		$slog = array(
			'uid' => $this->uid,
			'awardmoney' => $amoney,
			'signintype' => $atype,
			'signintotal' => $atotal,
			'awardcoin' => $acoin,
			'awardexp' => $aexp,
			'create_time' => date('Y-m-d H:i:s', time()) 
		);
		$this->mysql->insert("signin_log", $slog);
		$this->resMsg = substr($temp, 0,strlen($temp)-1);
	}
	 
	public function after() {
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
		$this->deinitMysql ();
	}
}
?>