<?php
	/**
	 * 抽奖
	 */
    class FlipCard extends APIBase {

		public $tag = "FlipCard";
		public $control_card = 0;
		 
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (Game::$slot_isopen == 0) {
				$this->returnError(300, "功能已关闭");
				
			}
			if (!isset($this->param ['type'])) {
				$this->returnError(301, "非法操作" );
				return;
			}
			$type = $this->param ['type'];
			$money = $this->data_redis->hGet("hu:{$this->uid}","money");
			if($type=='start' && $money<Game::$flipcard_limit){
				$this->returnError(302, "金币不足，请先充值" );
				return;
			}			
			if ($type=='start'){	// 发牌
				$this->initPFlipInfo();
				if (!isset($this->param ['betnum'])) {
					$this->returnError(301, "参数非法" );
					return;
				}
				$res = $this->getInitCard($this->param ['betnum'],$money);				
			}elseif ($type=='change'){	// 换牌
				if (!isset($this->param ['ind'])) {
					$this->returnError(301, "参数非法" );
					return;
				}
				$res = $this->changeCard($this->param ['ind'],$money);
			}elseif ($type=='end'){		// 结算
				$res = $this->getRes();
			}
// 			var_dump($res);
			$this->returnData($res);			
		}
		private function initPFlipInfo(){
			if(!$this->data_redis->exists("huFlipC:{$this->uid}")){
				$this->data_redis->hMset("huFlipC:{$this->uid}",array(
						'betnum'=>0,		// 押注
						'change_cost'=>0,	// 换牌消耗
						'change_num'=>0,	// 换牌次数
						'todayCost'=>0,		// 当天消耗
						'lastFlipTime'=>0,	// 最后一次结算时间
						'cards'=>0			// 手牌
				));
			}else{
				$this->data_redis->hMset("huFlipC:{$this->uid}",array(
						'betnum'=>0,
						'change_cost'=>0,
						'change_num'=>0,
						'cards'=>0
				));
			}
		}
		
		private function getRes(){
			$pf = $this->getPFlipInfo();
			$card_type = $this->getCardType(json_decode($pf['cards']));
			$win_money = $this->calWinMoney($pf['betnum'],$card_type);
			$curr_money = $this->hincrMoney($win_money, "flipcard-2");
			$change_cost = $pf['change_cost'];
			$consume_money = $win_money-$pf['betnum']-$change_cost;
			$this->mysql->insert("flipcard_log", array(
					'uid'=>$this->uid,
					'cardType'=>$card_type,
					'betNum'=>$pf['betnum'],
					'changeNum'=>$pf['change_num'],
					'changeMoney'=>$change_cost,
					'consumeMoney'=>$consume_money,
					'create_time'=>date('Y-m-d H:i:s', time())
			));
// 			echo "currCost:".$consume_money."</br>";
			// 更新个人当天消耗
			$this->upPriCost($consume_money,$pf);
			// 更新大盘当天消耗
			$this->upPubCost($consume_money);
			
			if($win_money>=Game::$flipcard_pushmsg_money_limit){
				$name = $this->data_redis->hGet("hu:{$this->uid}","name");
				$this->sendBroadcast($name."在老虎机里逆袭了,狂赚".$win_money."金币",'sys');
			}
			return array(
					'card_type'=>$card_type,
					'win_money'=>$win_money,
					'curr_money'=>$curr_money
			);
		}
		
		private function upPriCost($consume_money,$pf){
			$now = time();
			$todayCost = $consume_money;
			if(CommonTool::isSameDay($pf['lastFlipTime'], $now)){
				$todayCost = $pf['todayCost']+ $consume_money;
			}
// 			echo 'priCost:'.$todayCost.'</br>';
			$this->data_redis->hMset("huFlipC:{$this->uid}",array(
					'betnum'=>0,
					'change_cost'=>0,
					'change_num'=>0,
					'todayCost'=>$todayCost,
					'lastFlipTime'=>$now,
					'cards'=>0
			));
		}
		
		private function upPubCost($consume_money){
			$item = $this->cache_redis->hMget("hFlipCardStatus",array('todayCost','lastTime'));
			$now = time();
			if(!$item['todayCost'] || !$item['lastTime'] || !CommonTool::isSameDay($item['lastTime'], $now)){
				$item['todayCost'] = $consume_money;
			}else{
				if($item['todayCost']<1000000000 && $item['todayCost']>-1000000000){
					$item['todayCost'] -= $consume_money;
				}
			}
// 			echo 'pubCost:'.$todayCost.'</br>';
			$this->cache_redis->hMset("hFlipCardStatus",array(
					'todayCost'=>$item['todayCost'],
					'lastTime'=>$now
			));
		}
		
		private function calWinMoney($betnum,$card_type){
			$ratio = 0;
			if($card_type<=1){
				$ratio = Game::$flipcard_res_odds[6];
			}elseif ($card_type<=8){
				$ratio = Game::$flipcard_res_odds[5];
			}elseif ($card_type<=10){
				$ratio = Game::$flipcard_res_odds[4];
			}elseif ($card_type==11){
				$ratio = Game::$flipcard_res_odds[3];
			}elseif ($card_type==12){
				$ratio = Game::$flipcard_res_odds[2];
			}elseif ($card_type==13){
				$ratio = Game::$flipcard_res_odds[1];
			}elseif ($card_type==14){
				$ratio = Game::$flipcard_res_odds[0];
			}
			return $betnum*$ratio;
		}	
			
		private function changeCard($ind,$money){
			$pf = $this->getPFlipInfo();
// 			var_dump($pf);
			$curr_change_num = 0;
			if(isset($pf['change_num'])) {
				$curr_change_num = $pf['change_num'];
				if($curr_change_num>=Game::$flipcard_change_times){
					$this->returnError(301, "不能再换牌了" );
					return;
				}
			}
			if($ind<0 || $ind>4){
				$this->returnError(301, "换牌错误，非法参数" );
				return;
			}
			$cards = json_decode($pf['cards']);
// 			var_dump($cards);
			if(sizeof($cards)!=5){
				$this->returnError(301, "换牌失败，数据错误" );
				return;
			}
			$change_cost = 0;
			if(isset($pf['change_cost'])){
				$change_cost = $pf['change_cost'];
			}
			$changeMoney = $pf['betnum']*Game::$flipcard_change_cost[$curr_change_num];
			if($changeMoney>$money){
				$this->returnError(302,"金币不足");
				return;
			}
			$curr_money = $this->hincrMoney(0-$changeMoney, "flipcard-1");
			$change_cost += $changeMoney;
			
			$cType = "cone";
			if($curr_change_num==1){
				$cType = "ctwo";
			}elseif ($curr_change_num==2){
				$cType = "cthree";
			}	
			$card = $this->getChangeCard($cards);
			$cards[$ind] = $card;			
			$card_type = $this->getCardType($cards);
// 			echo "ct:".$card_type."<br/>";
// 			$needChangeCard = $cards[$ind];
			$needControl = $this->control_intervene($cType,$cards,$card_type);
			if($needControl){
// 				echo "need control<br/>";
				$oldCt = $card_type;
				for ($i=0;$i<2;$i++){
					$card = $this->getChangeCard($cards);
					$cards[$ind] = $card;
					$card_type = $this->getCardType($cards);
					if($card_type<$oldCt){
// 						echo "nt:".$card_type."<br/>";
						break;
					}
				}
			}			
// 			var_dump($cards);
			$curr_change_num++;
			$this->data_redis->hMset("huFlipC:{$this->uid}",array('cards'=>json_encode($cards),
					'change_num'=>$curr_change_num,'change_cost'=>$change_cost));
			
			return array(
					'ind'=>$ind,
					'card'=>$card,
					'card_type'=>$card_type,
					'change_num'=>$curr_change_num,
					'curr_money'=>$curr_money,
					'curr_bet'=>$changeMoney
			);
		}
		
		private function getChangeCard($cards){
			$subArr = array_diff($this->card_arr, $cards);
			shuffle($subArr);
			return $subArr[0];
		}
		
		private function getInitCard($betnum,$money){
			$betnum = $this->param ['betnum'];
			if($betnum<Game::$flipcard_bet_min){
				$betnum = Game::$flipcard_bet_min;
			}
			if ($betnum>Game::$flipcard_bet_max) {
				$betnum = Game::$flipcard_bet_max;
			}
			if($betnum>$money){
				$this->returnError(302,"金币不足");
				return; 
			}
			$curr_money = $this->hincrMoney(0-$betnum, "flipcard-0");
			shuffle($this->card_arr);
// 			var_dump($this->card_arr);
			$cards = array_slice($this->card_arr,0,5);
			// TEST START
			/* $randind = rand(0, 10);
			if($randind<4){
				$cards = array(0x01, 0x11, 0x21, 0x02,0x03);	// 小牛
			}elseif ($randind<7){
				$cards = array(0x0B, 0x1B, 0x0C, 0x0D,0x2D);	// 花牛
			}else{
				$cards = array(0x06, 0x16, 0x26, 0x36,0x03);	// 四炸
			} */
			// TEST END

// 			echo "ot:".$this->getCardType($cards)."<br/>";
			$card_type = $this->getCardType($cards);
// 			$needControl = $this->control_intervene("init",$cards,$card_type);
			if($card_type>Game::$flipcard_card_type['cow_seven']){
				$changeCard = $this->getChangeCard($cards);
				/* $cs = sizeof($cards);				
				for ($i=0;$i<$cs;$i++){
					if($cards[$i]==$this->control_card){
						$cards[$i] = $changeCard;
					}
				} */
				$ranInd = rand(0, 4);
				$cards[$ranInd] = $changeCard;
				$card_type = $this->getCardType($cards);
// 				echo "init need ct:".$this->getCardType($cards)."<br/>";
			}
// 			$this->getCardsList($cards);
			$this->data_redis->hMset("huFlipC:{$this->uid}",array('cards'=>json_encode($cards),'betnum'=>$betnum));
			
			return array(
					'cards'=>$cards,
					'card_type'=>$card_type,
					'curr_money'=>$curr_money
			);
		}
		
		private function control_intervene($type,$card,$card_type){
			// {"minMoney":3000000,"maxMoney":0,"init":["100","100","100"],"cone":["100","100","100"],"ctwo":["60","60","60"],"cthree":["20","20","20"]}
			if($type=="init" && $this->control_card==0){
				return false;
			}
			if(Game::$flipcard_control_level==0){
				return false;
			}elseif (Game::$flipcard_control_level==1){
				$conStr = $this->cache_redis->get ( "sflipcontrol:pub" );
				$costMoney = (int)$this->cache_redis->hGet("hFlipCardStatus",'todayCost');
			}else {
				$conStr = $this->cache_redis->get ( "sflipcontrol:pri" );
				$costMoney = (int)$this->data_redis->hGet("huFlipC:{$this->uid}",'todayCost');
			}
			if($card_type<=Game::$flipcard_card_type['cow_night']){
				return false;
			}/* elseif ($card_type>=Game::$flipcard_card_type['cow_bomb']){
				return true;
			} *//* else{
				return true;
			} */
			$conArr = json_decode($conStr);
			$conItem = "";
			foreach ($conArr as $item){
				if(($item->minMoney == 0 || $costMoney>$item->minMoney) && 
						($item->maxMoney == 0 || $costMoney<=$item->maxMoney)){
					if($type=="init"){
						$conItem = $item->init;
					}elseif ($type=="cone"){
						$conItem = $item->cone;
					}elseif ($type=="ctwo"){
						$conItem = $item->ctwo;
					}else{
						$conItem = $item->cthree;
					}					
					break;
				}
			}
			if($conItem=="" || sizeof($conItem)!=3){
				return false;
			}
// 			var_dump($conItem);
			if($card_type>=Game::$flipcard_card_type['cow_bomb']){
				$ratio = $conItem[0];
			}elseif ($card_type>=Game::$flipcard_card_type['cow_eight']){
				$ratio = $conItem[1];
			}elseif ($card_type>=Game::$flipcard_card_type['cow_one']){
				$ratio = $conItem[2];
			}else {
				$ratio = $conItem[0];
			}
// 			echo 'ct:'.$card_type.",ratio:".$ratio."</br>";
			$randind = rand(0, 100);

// 			echo $ratio.":".$randind.':'.$this->control_card."</br>";
			if($ratio>=$randind){
				return true;
			}
// 			var_dump($card);
// 			$card_type = $this->getCardType($card);
// 			echo 'ct:'.$card_type.'</br>';
			return false;
		}
		
		/**
		 * 16进制牌值
		 * @var unknown
		 */
		public $card_arr = array(
			0x01, 0x11, 0x21, 0x31,         //A 14
			0x02, 0x12, 0x22, 0x32,         //2 15
			0x03, 0x13, 0x23, 0x33,         //3 3
			0x04, 0x14, 0x24, 0x34,         //4 4
			0x05, 0x15, 0x25, 0x35,         //5 5
			0x06, 0x16, 0x26, 0x36,         //6 6
			0x07, 0x17, 0x27, 0x37,         //7 7
			0x08, 0x18, 0x28, 0x38,         //8 8
			0x09, 0x19, 0x29, 0x39,         //9 9
			0x0A, 0x1A, 0x2A, 0x3A,         //10 10
			0x0B, 0x1B, 0x2B, 0x3B,         //J 11
			0x0C, 0x1C, 0x2C, 0x3C,         //Q 12
			0x0D, 0x1D, 0x2D, 0x3D,         //K 13
// 			0x0E, 0x0F						//Small King,big King
		);
		
		private function getCardsList($cards){
			$cardsList = array();
			foreach ($cards as $val){
				$cardsList[] = $this->getCard($val);
			}
			return $cardsList;
		}
		
		private function getCard($val){		
			$card['face'] = $val & 0xF;		// 牌面大小
			$card['suit'] = $val >> 4;		// 花色
			$card['val'] = $val;
// 			var_dump($card);
			return $card;
		}
		
		private function getPFlipInfo(){
			$pf = $this->data_redis->hGetAll("huFlipC:{$this->uid}");	
// 			var_dump($pf);
			if(strlen($pf['cards'])==1 || $pf['betnum']==0){
				$this->returnError(301, "非法操作" );
				return;
			}
			return $pf;
		}

		private function getCardType($cards){
			//五小牛、五花牛、四炸、牛牛、牛8~9、牛1~7、无牛
			$csl = $this->getCardsList($cards); 
// 			echo '['.$csl[0]['face'].','.$csl[1]['face'].','.$csl[2]['face'].','.$csl[3]['face'].','.$csl[4]['face'].']</br>';
			// 牌型错误
			if(sizeof($csl)!=5){
				return 0;
			}	
			// 五小牛
			$totFace = $csl[0]['face']+$csl[1]['face']+$csl[2]['face']+$csl[3]['face']+$csl[4]['face'];
			if($totFace<=10 && $csl[0]['face']<=5 && $csl[1]['face']<=5 && $csl[2]['face']<=5 
				&& $csl[3]['face']<=5 && $csl[4]['face']<=5){
				$this->control_card = $csl[0]['val'];
				return Game::$flipcard_card_type['cow_wxn'];
			}
			// 五花牛
			if($csl[0]['face']>10 && $csl[1]['face']>10 && $csl[2]['face']>10 
				&& $csl[3]['face']>10 && $csl[4]['face']>10){
				$this->control_card = $csl[0]['val'];
				return Game::$flipcard_card_type['cow_whn'];
			}
			// 四炸
			foreach ($csl as $c){
				$bombInc = 0;
				$bombVal = 0;
				foreach ($csl as $k){
					if($c['face'] == $k['face']){
						$bombInc++;
						$bombVal = $c['val'];
					}	
				}
				if($bombInc==4){
					$this->control_card = $bombVal;
					return Game::$flipcard_card_type['cow_bomb'];
				}
			}
			// 其他牌型分组
			$bigCards = array();			// 大于等于10的牌
			$smallCards = array();			// 小于10的牌
			foreach ($csl as $c){
				if($c['face']>=1 && $c['face']<=9){
					$smallCards[] = $c;
				}elseif($c['face']>=10 && $c['face']<=13){
					$bigCards[] = $c;
					$this->control_card = $c['val'];
				}
			}
			$smallSize = sizeof($smallCards);
			$cardType = Game::$flipcard_card_type['ERROR'];
			switch ($smallSize) {
				case 0:
					$cardType = Game::$flipcard_card_type['cow_ten'];
					break;
				case 1:
				case 2:
					$cardType = $this->cardType_onetwo_small($smallCards);
					break;
				case 3:
				case 4:
					$cardType = $this->cardType_threefour_small($smallCards);
					break;
				case 5:
					$cardType = $this->cardType_five_small($smallCards);
					break;
				default:
					$cardType = Game::$flipcard_card_type['ERROR'];
					break;
			}			
			return $cardType;
		}
		
		private function cardType_onetwo_small($smallCards){
			if(sizeof($smallCards)==1){
				return $smallCards[0]['face']+1;
			}elseif (sizeof($smallCards)==2){
				if($smallCards[0]['face']+$smallCards[1]['face']==10){
					$this->control_card = $smallCards[0]['val'];
					return Game::$flipcard_card_type['cow_ten'];
				}else {
					return ($smallCards[0]['face']+$smallCards[1]['face'])%10+1;
				}
			}
		}
		
		private function cardType_threefour_small($smallCards){
			$size = sizeof($smallCards);
			for ($i=0;$i<$size-1;$i++){
				for ($j=$i+1;$j<$size;$j++){
					if(($smallCards[$i]['face']+$smallCards[$j]['face'])%10==0){
						$this->control_card = $smallCards[$i]['val'];
						$inc = 0;
						for ($k=0;$k<$size;$k++){
							if($k!=$i && $k!=$j){
								$inc += $smallCards[$k]['face']>10?10:$smallCards[$k]['face'];
							}
						}
						if($inc%10==0){
							return Game::$flipcard_card_type['cow_ten'];
						}else {
							return $inc%10+1;
						}
					}
				}
			}
			return $this->cardType_five_small($smallCards);
		}
		
		private function cardType_five_small($smallCards){
			$size = sizeof($smallCards);
			for ($i=0;$i<$size-2;$i++){
				for ($j=$i+1;$j<$size-1;$j++){
					for ($h=$j+1;$h<$size;$h++){
						if(($smallCards[$i]['face']+$smallCards[$j]['face']+$smallCards[$h]['face'])%10==0){
							$this->control_card = $smallCards[$i]['val'];
							$inc = 0;
							for ($k=0;$k<$size;$k++){
								if($k!=$i && $k!=$j && $k!=$h){
									$inc += $smallCards[$k]['face']>10?10:$smallCards[$k]['face'];
								}
							}
							if($inc%10==0){
								return Game::$flipcard_card_type['cow_ten'];
							}else {
								return $inc%10+1;
							}
						}
					}					
				}
			}
			return Game::$flipcard_card_type['cow_no'];
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>