<?php
	/**
	 * RMB换金币
	 */
    class ExchangeMoneyNew extends APIBase {
		
		public $tag = "ExchangeMoneyNew";
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			
			if (!isset($this->param['orderId']) ) {
				$this->returnError(300, ' orderId is needed');
			}
			
			$orderId = $this->param ['orderId'] ;
			$req = isset($this->param ['req']) ? $this->param ['req'] : "" ;
			if (empty($req) && isset($_GET['req'])) {
				$req = isset($_GET['req'])  ;
			}

			// 各类活动额外赠送的金币和元宝
			$ext_money = 0;
			$ext_coin = 0;
				
			$r_money = 0;
			$r_coin = 0;			
			$r_rmb = 0;
			
			$goosOrVip = "";
		 	if(isset($this->param['vid']) && $this->param['vid']>0){				// 购买VIP
				$goosOrVip = "vip";
				$prizeStr = $this->cache_redis->get("svips");
				$prizeArr = json_decode($prizeStr);
				foreach ($prizeArr as $g) {
					if($g->id==$this->param['vid']){
						$goods = $g;
						break;
					}
				}
				if (!$goods) {
					$this->returnError(321, 'vipid is wrong');
				}
				$r_rmb = $goods->rmb;
				$r_money = $goods->money;
				$r_coin = 0;
				
			}else if(isset($this->param['goods_id']) && $this->param['goods_id']>0){ // 充值换金币
				$goosOrVip = "goods";
				//充值记录 即充即兑换
				$goods = $this->cache_redis->hGetAll("hg:{$this->param['goods_id']}");
				if (!$goods) {
					$this->returnError(321, 'goods_id is wrong');
				}
								
				$r_rmb = $goods['rmb'];
				$r_money = $goods['money'] + $goods['give_money'] ;
				$r_coin = $goods['give_coin'];
								
			}
			
			// 如果请求来自客户端，则只插入日志不进行充值校验和加金币操作
			if (! isset ( $req ) || !($req == "server" || $req == "server2" )) {
				if ($goosOrVip == "vip") {
					$this->addVipsLog($this->uid, $this->param['vid'], $r_rmb);
				}
				else if ($goosOrVip == "goods") {
					$this->addGoodsLog($this->uid, $this->param['goods_id'], $goods['rmb'],
							$goods['money'], $goods['give_money'], $goods['give_coin']);
				}
				$this->currMoney($goosOrVip);
				
				return;
			}
			
			$isHas = $this->mysql->select("payrecord", "id", array('uid'=>$this->uid,'orderId'=>$orderId));
			if (!empty($isHas) && sizeof($isHas)>0) {
				return $this->currMoney($goosOrVip);
			}
			/*
			if (isset($this->param['orderNo'])) {
				$isHasN = $this->mysql->select("payorder","id",array('order_id' => $this->param['orderNo'],'uid' => $this->uid,'success' => 1));
				if (!empty($isHasN) && sizeof($isHasN)>0) {
					return $this->currMoney($goosOrVip);
				}
			}
			*/
			//判断是由客户端校验还是由服务器端校验
			// server=客户端 ；server2=服务端  2014.11.27
			$ccd = 0;
			if ($req == "server") {
				//客户端校验
				$ccd = 1;
			}
			
			//该订单是否为付费坑
			$istrap = 0;
			$tp_trap = -1;
			$tp_pos = -1;
			
			// 通过订单号获取订单信息
			$row = $this->mysql->select ( "payorder", "sdk, money, coin, rmb, istrap, trap, pos,rmb_fen,vid", array (
					'order_id' => $orderId,
					'uid' => $this->uid,
					'success' => 0
			) );
			//$this->i("orderid=${orderId} ; row=".count ( $row ));			
			$sdk = "";
			$order_flag = 0;
			$order_vid = 0;
			if (count ( $row ) == 1) {
				$order_flag = 1;/* 
				if ($goosOrVip != "goods") {
					$r_rmb = ( int ) $row [0] ['rmb'];
					$r_money = ( int ) $row [0] ['money'];
					$r_coin = ( int ) $row [0] ['coin'] ;
				} */
							
				$istrap = ( int ) $row [0] ['istrap'] ;
				$tp_trap =  ( int ) $row [0] ['trap'] ;
				$tp_pos =  ( int ) $row [0] ['pos'] ;

				$order_vid = ( int )$row [0] ['vid'] ;
				if ($order_vid > 0) {
					$prizeStr = $this->cache_redis->get("svips");
					$prizeArr = json_decode($prizeStr);
					foreach ($prizeArr as $g) {
						if($g->id==$order_vid){
							$goods = $g;
							if ($goods) {
								$goosOrVip = "vip";
								$r_rmb = $goods->rmb;
								$r_money = $goods->money;
								$r_coin = 0;
							}							
							break;
						}
					}
				}else{
					$r_rmb = ( int ) $row [0] ['rmb'];
					$r_money = ( int ) $row [0] ['money'];
					$r_coin = ( int ) $row [0] ['coin'] ;
				}
				
				$sdk = $row [0] ['sdk'] ; 			
				$r_rmb_fen = (int) $row [0] ['rmb_fen'];
								
				//判断是否特惠坑充值,如果是，则记录特惠坑的周期，在该时间段内，不再有
				if ($istrap == 1) {
					if (($tp_pos == 0 && $tp_trap == 0)) {
						//是特惠坑
						$arrRet=$this->getWeekRangeStamp(date('Y-m-d'));
						$this->data_redis->hMset ( "htrap:{$this->uid}", $arrRet);
					}
				}
				if ($r_rmb_fen == 1) {
					//0.01元充值
					$this->data_redis->hSet ( "hu:{$this->uid}", 'fen-1', '1' );
				} elseif ($r_rmb_fen == 10) {
					//0.1元充值
					$this->data_redis->hSet ( "hu:{$this->uid}", 'fen-10', '1' );
				}
				
			}
			
			// 判断首充翻倍
			// 1) 更新用户的充值人民币数量
			$rmb = $this->data_redis->hincrBy ( "hu:{$this->uid}", "rmb", $r_rmb );
			$first = 0;
			$firstPay_double_money = isset(Game::$firstPay_double_money) ? Game::$firstPay_double_money : 0;
				
			// 各类活动额外赠送的金币和元宝
			$ext_money = $r_money;
			$ext_coin = $r_coin;
			// 首次充值 , 金币、元宝翻倍
			//if (($rmb == $r_rmb) && ($firstPay_double_money == 1) && ($istrap == 0))  {
			if (($r_rmb_fen != 10) && ($rmb == $r_rmb) && ($firstPay_double_money == 1)
				 && !($tp_trap == 0 && $tp_pos == 0) && $goosOrVip == "goods")  {
				if($r_rmb <= Game::$firstPay_double_limit){
					$ext_money += $r_money;
					$ext_coin += $r_coin;
				}else{
					$ext_money += 6000000;
					$ext_coin += 600;
				}
				$first = 1;
			}
			
			// 2)加金币元宝
			$money = $this->hincrMoney ( $ext_money, "exchangeMoney" );
			$this->hincrCoin ( $ext_coin, "exchangeMoney" );
			if ($order_flag == 1) {
				// 更新订单数据库
				$this->mysql->update ( "payorder", array (
						'success' => 1,
						'ccd' => $ccd,
						'money1'=> $money,
						'updated_at' => date ( 'Y-m-d H:i:s' )
				), array (
						'order_id' => $orderId,
						'uid' => $this->uid
				) );
			}
			
			if (isset($this->param['sdkId'])) {
				$sdk = $this->param['sdkId'];
			}
			
			//记录日志
			$this->payrecord($r_rmb,$orderId,$sdk); 
			
			$this->i("orderid=".$orderId.";uid=".$this->uid."; rmb=".$r_rmb."; sdk=".$sdk);
			
			if($goosOrVip == "vip"){
				$pe = $this->mysql->select("playerext","*",array('uid' => $this->uid));
				$vd = $pe[0]['vipenddate'];
				$now = time();
				
				if($vd>$now){
					$vd = $vd+3600*24*$goods->days;
				}else{
					$vd = $now+3600*24*$goods->days;
				}
				$this->mysql->update("playerext",array('vipenddate' => $vd), array('uid' => $this->uid));
				$this->data_redis->hSet("hpe:{$this->uid}", "vipenddate",$vd);
			}
			else {
				$hasRec = $this->data_redis->hGet("hpe:{$this->uid}", "hasRecharge");
				if($hasRec!=1){
					$this->mysql->update("playerext",array('hasRecharge' => 1), array('uid' => $this->uid));
					$this->data_redis->hSet("hpe:{$this->uid}", "hasRecharge",1);
				}				
			}				
					
			$this->currMoney($goosOrVip);
		}
		
		private function currMoney($goosOrVip){
			$money = $this->data_redis->hMGet("hu:{$this->uid}", array("money", "rmb", "coin"));
			$money['money'] = (int)$money['money'];
			$money['rmb'] = (int)$money['rmb'];
			$money['coin'] = (int)$money['coin'];
			$money['desp'] = "充值请求已受理，如充值成功，20秒内会自动到账，请留意。";
			if($goosOrVip=="vip"){
				$money['desp'] = "VIP购买请求已提交，支付成功后，可获得众多VIP特权";
			}
			$money['hasrc'] = 1;
			$this->returnData($money);
		}
		
		public function payrecord($rmb,$orderId,$sdkId) {
			$payrecord['uid'] = $this->uid;
			$payrecord['rmb'] = $rmb;
			$payrecord['orderId'] = $orderId;
			$payrecord['sdkId'] = $sdkId;
			$payrecord['create_time'] = time();
			$id = $this->mysql->insert("payrecord", $payrecord);
			if ($id == 0) {
				$this->e("insert payrecord error");
				$this->returnError(500, "server is error");
			}
		}

		public function addVipsLog($uid, $vipid, $rmb) {
			$now = time();
			$goodslog = array(
					'uid'=> $uid,
					'vid'=> $vipid,
					'rmb'=> $rmb,
					'create_time' => $now
			);
		
			$this->mysql->insert("vipslog", $goodslog);
		}
		
		public function addGoodsLog($uid, $goods_id, $rmb, $money, $give_money,$give_coin) {
			$now = time();
			$goodslog = array(
					'uid'=> $uid,
					'goods_id'=> $goods_id,
					'rmb'=> $rmb,
					'money' => $money,
					'give_money' => $give_money,
					'give_coin' => $give_coin,
					'create_time' => $now,
					'update_time' => $now
			);
				
			$this->mysql->insert("goodslog", $goodslog);
		}
		
        public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>