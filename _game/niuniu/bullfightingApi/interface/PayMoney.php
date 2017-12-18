<?php
/**
 * RMB换金币
 */
include_once './lib/ThriftProxy.php';
// http://203.86.3.245:88/api.php?uid=298&skey=52f04e8f0595198f7070d455f1a4a860&action=PayMoney&param={%22orderId%22:%22140412282400000264406642%22,%22req%22:%22server%22}
class PayMoney extends APIBase {
	public $tag = "PayMoney";
	public function before() {
		$this->initMysql ();	
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$orderId = isset($this->param ['orderId']) ? $this->param ['orderId'] : "";
		
		if (! isset ( $orderId )) {
			$this->returnError ( 300, 'orderId is needed' );
		}
		
		$req = isset($this->param ['req']) ? $this->param ['req'] : "" ;
		
		// 如果请求来自客户端，则只插入日志不进行充值校验和加金币操作
		if (! isset ( $req ) || !($req == "server" || $req == "server2" || $req == "tencent")) {
			$this->currMoney ();
			return;
		}
		// 仅用于腾讯，通过对比余额
		if($req == "tencent" && !$this->get_balance_qq()){
			$this->currMoney ();
			return;
		}
		
		$price_fen = isset($this->param ['price_fen']) ? (int)$this->param ['price_fen'] : 0 ;
		$success_tag = 1;
		if ($price_fen == -555555) {
			$success_tag = 5;
			$price_fen = 0;
		}
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
		$row = $this->mysql->select ( "payorder", "sdk, money, coin, rmb, istrap, trap, pos,rmb_fen,goods_id", array (
				'order_id' => $orderId,
				'uid' => $this->uid,
				'success' => 0 
		) );
		//$this->i("orderid=${orderId} ; row=".count ( $row ));	
		$sdk = "";
		if (count ( $row ) == 1) {
								
			$r_rmb = ( int ) $row [0] ['rmb'];
			$r_money = ( int ) $row [0] ['money'];
			$r_coin = ( int ) $row [0] ['coin'] ;
			$istrap = ( int ) $row [0] ['istrap'] ;
			$tp_trap =  ( int ) $row [0] ['trap'] ;
			$tp_pos =  ( int ) $row [0] ['pos'] ;
			$goods_id = ( int ) $row [0] ['goods_id'] ;
			$sdk = $row [0] ['sdk'] ;
			$r_rmb_fen = (int) $row [0] ['rmb_fen'];
			
			//20150326 从服务器端修复客户端的bug：订单号的金额与实际付费金额不一致(client订单号被替换了)			
			if ($price_fen > 10 && $price_fen != $r_rmb_fen ) {
				//sdk 08 01 
				$sql3 ="SELECT a.fee,a.rmb,a.money,a.coin FROM pay_points a JOIN pay_sdk b ON (a.pay_sdk_id=b.id) WHERE b.sdk='".$sdk."' AND a.fee='".$price_fen."'";				
				$row3 = $this->mysql->find ($sql3);
				if (count($row3) > 0) {
					$r_rmb = (int) $row3[0]['rmb'] ;
					$r_money = ( int ) $row3[0]['money'];
					$r_coin = ( int ) $row3[0] ['coin'] ;
					$r_rmb_fen = ( int ) $row3[0] ['fee'] ;					
				}
				$this->i ($orderId."   ".$sql3 );
			}
						
			// 1) 更新用户的充值人民币数量
			$rmb = $this->data_redis->hincrBy ( "hu:{$this->uid}", "rmb", $r_rmb );
			$first = 0;
			$firstPay_double_money = isset(Game::$firstPay_double_money) ? Game::$firstPay_double_money : 0;
			
			
			//20151030
			if ($price_fen <= 10 && $price_fen > 0 && $price_fen != $r_rmb_fen ) {
				if ($price_fen == 1) {
					$r_rmb = 0 ;
					$r_money = 100;
					$r_coin = 0 ;
					$r_rmb_fen = 1 ;
				}
				else {
					$r_rmb = 0 ;
					$r_money = 1000;
					$r_coin = 0 ;
					$r_rmb_fen = 10 ;
				}
			}
			
			// 各类活动额外赠送的金币和元宝
			$ext_money = 0;
			$ext_coin = 0;
			// 首次充值 , 金币、元宝翻倍
			//if (($rmb == $r_rmb) && ($firstPay_double_money == 1) && ($istrap == 0))  {
			if (($r_rmb_fen != 10) && ($rmb == $r_rmb) && ($firstPay_double_money == 1) && !($tp_trap == 0 && $tp_pos == 0))  {
				if($r_rmb <= Game::$firstPay_double_limit){
					$ext_money += $r_money;
					$ext_coin += $r_coin;
				}else{
					$ext_money += 6000000;
					$ext_coin += 600;
				}								
				$first = 1;
			}
			// 活动
			if($this->isActivityTime() && !($tp_trap == 0 && $tp_pos == 0) && ($first==0) && ($r_rmb_fen != 10)){
				if ($r_rmb>=100 && $r_rmb<=299){
					$ext_money += floor($r_money*3/10);
				}elseif ($r_rmb>=300 && $r_rmb<=499){
					$ext_money += floor($r_money*6/10);
				}elseif ($r_rmb>=500){
					$ext_money += $r_money;
				}				
			}
			$r_money += $ext_money;
			$r_coin += $ext_coin;
			
			// 2)加金币元宝
			$money = $this->hincrMoney ( $r_money, "exchangeMoney" );
			$this->hincrCoin ( $r_coin, "exchangeMoney" );
			
			// 更新订单数据库
			$this->mysql->update ( "payorder", array (
					'success' => $success_tag,
					'ccd' => $ccd,
					'money1'=> $money,
					'updated_at' => date ( 'Y-m-d H:i:s' ),
					'rmb' => $r_rmb
			), array (
					'order_id' => $orderId,
					'uid' => $this->uid
			) );
			
			// 3)增加魅力值，1元加100
			$this->data_redis->hIncrBy ( "hu:{$this->uid}", "charm", $r_rmb * Game::$recharge_add_charm );
			// 4)更新VIP等级
			$this->upVipLevel ();
			// 5)更新头衔
			$this->data_redis->hSet ( "hu:{$this->uid}", 'title', $this->getTitleInfo ( $money ) );
			// 6)更新个人当日充值总和
// 			$this->priTodayRechargeInfo ($r_rmb);
			// 7)更新保险箱
			if($tp_pos==0 && $tp_trap==8){
				$this->data_redis->hSet ( "hu:{$this->uid}", 'safeboxflag', '1' );
				// 更新订单数据库
				$this->mysql->update ( "player", array (
						'safeboxflag' => 1
				), array (
						'id' => $this->uid
				) );
			}
			if($goods_id>0){
				$endTime = time()+86400;
				$this->data_redis->hMset( "hu:{$this->uid}", array('monthcardId'=>$goods_id,'monthcardEndtime'=>$endTime) );
				// 更新订单数据库
				$this->mysql->update ( "player", array (
						'monthcardId' => $goods_id,
						'monthcardEndtime' => $endTime
				), array (
						'id' => $this->uid
				) );
			}
			//$msg = $this->getPlayerName()."充值".($r_rmb_fen/100)."元获得了".$r_money."金币~";
			//获取消息			
			$msg = $this->getPayMsg( $this->getPlayerName(), $r_rmb_fen/100 , $r_money, $r_coin, $first,$goods_id);
			$this->i("orderid=${orderId} ; msg=${msg}");
			if($r_rmb_fen/100>5){
				$this->sendPersonMsg($this->uid,"sys", $msg);
				$this->sendBroadcast($msg, "2");
			}			
			//判断是否特惠坑充值,如果是，则记录特惠坑的周期，在该时间段内，不再有
			if ($istrap == 1) {
				// $sql = "select * from trap_order where order_id='".
				$row = $this->mysql->select ( "trap_order", "trap_pos, trap_id", array (
						'order_id' => $orderId,
						'trap_pos' => 0,
						'trap_id' => 0,
						'uid' => $this->uid
				) );												
				if ((count ( $row ) == 1) || ($tp_pos == 0 && $tp_trap == 0)) {
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
			//防刷用户检查及数据更新
			$this->is_black_pay_set($this->uid, $sdk, $r_rmb);
			if($req == "tencent"){
				$this->currMoney ();
				return;
			}
		} else {
			$this->sendPersonMsg($this->uid,"sys", "系统:抱歉,话费购买失败,未获得金币！");
			$this->returnError ( 301, '您没有需要充值的订单。' );
		}
	}
	
	private function isActivityTime(){
		if(Game::$recharge_activity_time==0){
			return false;
		}
		$timeArr = explode("~", Game::$recharge_activity_time);
		if(sizeof($timeArr)!=2){
			return false;
		}
		$now = time();
		if(strtotime($timeArr[0])<$now && strtotime($timeArr[1])>=$now){
			return true;
		}
		return false;
	}
	
	private function get_balance_qq(){
		if (!isset($this->param['uOpenID']) || !isset($this->param['uOpenKey'])
				|| !isset($this->param['uPayToken']) || !isset($this->param['uPf'])
				|| !isset($this->param['uPfKey']) || !isset($this->param['uType'])){
			$this->i("@@@tencent pay param error,uid:",$this->uid);
			return false;
		}
		
		$openID = $this->param['uOpenID'];
		$openKey = $this->param['uOpenKey'];
		$payToken = $this->param['uPayToken'];
		$pf = $this->param['uPf'];
		$pfKey = $this->param['uPfKey'];
		$uType = $this->param['uType'];
// 		$this->d('tc pay uid:'.$this->uid.",".$openID.":".$openKey.":".$payToken.":".$pf.":".$pfKey.":".$uType);
		// 手Q:6，微信:7
		$accountType = 0;
		if($uType=="qq"){
			$accountType = 6;
		}else if($uType=="wx"){
			$accountType = 7;
// 			$payToken = "";
		}
		$param = array(
				'openID'=>$openID,
				'openKey'=>$openKey,
				'payToken'=>$payToken,
				'pf'=>$pf,
				'pfKey'=>$pfKey,
				'accountType'=>$accountType
		);
		$tp = new ThriftProxy();
		$res = $tp->query_game_coins($param); 
// 		$this->d("param:".$openID.','.$openKey.','.$payToken.','.$pf.','.$pfKey.','.$accountType);
		if(!isset($res->errorCode)){
			$this->d("@@@tencent pay res null:".$this->uid);
			return true;
		}
		if($res->errorCode!=0){	
			$this->d("@@@tencent pay err uid:".$this->uid.',ec:'.$res->errorCode);
			return false;
		}		
		$currRmb = $this->data_redis->hget ( "hu:{$this->uid}", "qqRmb");
		$currRmb = $currRmb?$currRmb:0;		
		$this->d("tencent pay ret:".$this->uid.','.$res->errorCode.',gc:'.$res->gameCoins.',rmb:'.$res->totalConsume.',curmb:'.$currRmb);
		if($currRmb>=$res->totalConsume){
			$this->d("@@@tencent pay error,old:".$currRmb.',new:'.$res->totalConsume.',uid:'.$this->uid);
			return false;
		}
		$this->data_redis->hset ( "hu:{$this->uid}", "qqRmb",$res->totalConsume);
		return true;
	}
	
	private function getPayMsg($name, $r_rmb, $money, $coin, $first,$goods_id) {
		if($goods_id>0){
			$propInfo = $this->cache_redis->hMget ( "buyGoods:{$goods_id}", array('name'));
			$msg = $name."花费".$r_rmb."元获得".$propInfo['name'];
			return $msg;
		}
		if($money == 0){
			$msg = $name."充值".$r_rmb."元开启了保险箱，金币可以安全保管了~";
			return $msg;
		}
		$msg = "";
		$rmb = ",".$r_rmb.",";		
		$prizeStr = $this->cache_redis->get ( "spaymsg" );
		$prizeArr = json_decode ( $prizeStr );
		foreach ( $prizeArr as $g ) {
			$rmbs = $g->rmbs;			 	
			if ( strpos($rmbs, $rmb) === FALSE ) {
				$msg = $name."充值".$r_rmb."元获得了".$money."金币~";			
			}
			else {
				//$p1充值$p2元获得了$p3金币,好惬意~
				$ch = array('$p1' => $name, '$p2' => $r_rmb, '$p3' => $money);
				$msg = strtr($g->msg, $ch);
				break;
			}
		}
		if ($first == 1) {
			//首次充值
		}	
		return $msg;
	}
	
	
	private function getPayPoint($sdk, $rmb) {
		$sql = "select a.pay_type, a.sdk,a.app_key,a.app_name,a.cpkey,a.cpid, b.point,b.fee,b.rmb,b.money,b.coin" . " from pay_sdk a join pay_points b on a.id=b.pay_sdk_id" . " where a.sdk='{$sdk}' and b.rmb='{$rmb}'";
		$row = $this->mysql->find ( $sql );
		return count ( $row );
	}
	private function currMoney() {
		$money = $this->data_redis->hMGet ( "hu:{$this->uid}", array (
				"money",
				"rmb",
				"coin" 
		) );
		$money ['money'] = ( int ) $money ['money'];
		$money ['rmb'] = ( int ) $money ['rmb'];
		$money ['coin'] = ( int ) $money ['coin'];
		$money ['desp'] = "充值请求已受理，如充值成功，30秒内会自动到账，请留意。";
		
		$this->returnData ( $money );
	}
	public function payrecord($rmb, $orderId, $sdkId) {
		$payrecord ['uid'] = $this->uid;
		$payrecord ['rmb'] = $rmb;
		$payrecord ['orderId'] = $orderId;
		$payrecord ['sdkId'] = $sdkId;
		$payrecord ['create_time'] = time ();
		$id = $this->mysql->insert ( "payrecord", $payrecord );
		if ($id == 0) {
			$this->e ( "insert payrecord error" );
			$this->returnError ( 500, "server is error" );
		}
	}
	public function addVipsLog($uid, $vipid, $rmb) {
		$now = time ();
		$goodslog = array (
				'uid' => $uid,
				'vid' => $vipid,
				'rmb' => $rmb,
				'create_time' => $now 
		);
		
		$this->mysql->insert ( "vipslog", $goodslog );
	}
	public function addGoodsLog($uid, $goods_id, $rmb, $money, $give_money, $give_coin) {
		$now = time ();
		$goodslog = array (
				'uid' => $uid,
				'goods_id' => $goods_id,
				'rmb' => $rmb,
				'money' => $money,
				'give_money' => $give_money,
				'give_coin' => $give_coin,
				'create_time' => $now,
				'update_time' => $now 
		);
		
		$this->mysql->insert ( "goodslog", $goodslog );
	}
	public function after() {
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
		$this->deinitMysql ();
	}
}
?>