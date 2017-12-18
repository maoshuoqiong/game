<?php
	/**
	 * 道具交易
	 */
    class PropsTrade extends APIBase {
		public $tag = "PropsTrade";
		public function before() {
			$this->initCacheRedis();
			$this->initMysql();
			return true;
		}
		public function logic() {
			if (!isset($this->param['type'])) {
				$this->returnError(301, '购买失败,非法操作');
				return;
			}
			$type = $this->param['type'];
			if ($type == 'log'){
				$this->propLog();
				return;
			}			
			if (!isset($this->param['gid'])) {
				$this->returnError(301, '购买失败,参数错误');
				return;
			}
			$gid = $this->param['gid'];
			$goods = $this->cache_redis->hGetAll("buyGoods:{$gid}");
			if(!isset($goods['buymoney']) || $goods['buymoney']<=0){
				$this->returnError(301, '购买失败,商品不存在');
				return;
			}
			if($type == 'buy'){
				$this->buyProp($goods);
			}elseif ($type == 'sell'){
				$this->sellProp($goods);
			}elseif ($type == 'give'){
				$this->giveProp($goods);
			}elseif ($type == 'myprop'){
				$this->myProp($goods);
			}else{
				$this->returnError(301, '非法操作');
				return;
			}
		}
		
		public function myProp($goods){
			$propArr = $this->data_redis->hGetAll("uprop:{$this->uid}");
			foreach ($propArr as $k=>$v){
				$propArr[$k] = (int)$v;
			}
			$user = $this->data_redis->hMget("hu:{$this->uid}",array('monthcardId','monthcardEndtime'));
			$monthcard = array();
			$now = time();
			$monthcardId = isset ( $user ['monthcardId'] ) ? ( int ) $user ['monthcardId'] : 0;
			$monthcardRemainDay = isset ( $user ['monthcardEndtime'] ) && $user ['monthcardEndtime']>$now? ($user ['monthcardEndtime']-$now)/86400+1 : 0;
			$monthcardRemainDay = ceil($monthcardRemainDay);
			if($monthcardId>0){
				$monthcard[$monthcardId] = $monthcardRemainDay;
			}			
			$this->returnData(array('propTarde'=>$propArr,'monthCard'=>$monthcard));
		}
		
		public function buyProp($goods){
			$res = array();
			$p = $this->data_redis->hMGet("hu:{$this->uid}", array('money'));
			if($p['money']<$goods['buymoney']){
				$this->returnError(301, '购买失败,金币不足');
				return;
			}
			$mon = $this->hincrMoney(0-$goods['buymoney'], 'buyProps');
			$resArr = array(
					'propid'=>$goods['id'],
					'money'=>$goods['buymoney'],
					'type'=>0,
					'ouid'=>$this->uid,
					'tuid'=>0,
					'num'=>$goods['num'],
					'create_time'=>date('Y-m-d H:i:s', time())
			);
			$this->mysql->insert('prop_trade_log', $resArr);
			// 更新玩家扩展信息
			$currNum = $this->data_redis->hIncrBy("uprop:{$this->uid}",$goods['fatherId'],$goods['num']);
			/* $propArr = $this->data_redis->hGetAll("uprop:{$this->uid}");
			foreach ($propArr as $k=>$v){
				$propArr[$k] = (int)$v;
			} */
			$msg = '您花费'.$goods['buymoney'].'金币获得'.$goods['name'].','.date('Y-m-d H:i:s', time());
			$this->upLog($this->uid,$msg);
			$this->returnData(array('money'=>$mon,'props'=>array($goods['fatherId']=>$currNum)));
		}
		// 卖回给系统
		public function sellProp($goods){
			$propNum = $this->data_redis->hGet("uprop:{$this->uid}",$goods['id']);
			if($propNum<=0){
				$this->returnError(301, '出售失败,你没有此道具');
				return;
			}
			$num = 1;
			if (isset($this->param['num'])) {
				$num = $this->param['num'];
			}
			if($num<=0){
				$this->returnError(301, '出售失败,非法操作');
				return;
			}
			$num = $num>$propNum?$propNum:$num;
			$sellmoney = $goods['sellmoney']*$num;
			$resArr = array(
					'propid'=>$goods['id'],
					'money'=>$sellmoney,
					'type'=>1, 				// 0,buy;1,sell;2,trade
					'ouid'=>$this->uid,		
					'tuid'=>0,
					'num'=>$num,
					'create_time'=>date('Y-m-d H:i:s', time())
			);
			$this->mysql->insert('prop_trade_log', $resArr);
			$mon = $this->hincrMoney($sellmoney, 'sellProps');
			// 更新玩家扩展信息
			$currNum = $this->data_redis->hIncrBy("uprop:{$this->uid}",$goods['id'],0-$num);
			/* $propArr = $this->data_redis->hGetAll("uprop:{$this->uid}");
			foreach ($propArr as $k=>$v){
				$propArr[$k] = (int)$v;
			} */
			$msg = '您卖出'.$num.'个'.$goods['name'].',获得'.$sellmoney.'金币,'.date('Y-m-d H:i:s', time());
			$this->upLog($this->uid,$msg);
			$this->returnData(array('money'=>$mon,'props'=>array($goods['id']=>$currNum)));
		}
		// 赠送
		public function giveProp($goods){
			$propNum = $this->data_redis->hGet("uprop:{$this->uid}",$goods['id']);
			if($propNum<=0){
				$this->returnError(301, '赠送失败,你没有此道具');
				return;
			}
			$num = 1;
			if (isset($this->param['num'])) {
				$num = $this->param['num'];
			}
			if($num<=0){
				$this->returnError(301, '赠送失败,非法操作');
				return;
			}
			$num = $num>$propNum?$propNum:$num;
			if (!isset($this->param['tuid']) || $this->param['tuid']<=0) {
				$this->returnError(301, '赠送失败,请输入对方ID');
				return;
			}
			$tuid = $this->param['tuid'];
			// 级别不足15级或者VIP级别不满3级,无法赠送
			$minfo = $this->data_redis->hMGet("hu:{$this->uid}", array('vipLevel','level','name','money'));
			if(!$this->data_redis->exists("hu:{$tuid}")){
				$this->returnError(301, '赠送失败,对方长期未在线');
				return;
			}
			if($tuid == $this->uid){
				$this->returnError(301, '赠送失败,不能送给自己');
				return;
			}
			$tinfo = $this->data_redis->hMGet("hu:{$tuid}", array('name'));
			if($minfo['vipLevel']<3){
				$this->returnError(301, '赠送失败,您的VIP等级不满3级');
				return;
			}
			if($minfo['level']<15){
				$this->returnError(301, '赠送失败,您的等级不满15级');
				return;
			}
			/* if($tinfo['vipLevel']<3){
				$this->returnError(301, '赠送失败,对方的VIP等级不满3级');
				return;
			}
			if($tinfo['level']<15){
				$this->returnError(301, '赠送失败,对方的等级不满15级');
				return;
			} */
			$resArr = array(
					'propid'=>$goods['id'],
					'money'=>0,
					'type'=>2, 				// 0,buy;1,sell;2,trade
					'ouid'=>$this->uid,
					'tuid'=>$tuid,
					'num'=>$num,
					'create_time'=>date('Y-m-d H:i:s', time())
			);
			$this->mysql->insert('prop_trade_log', $resArr);
			// 更新玩家扩展信息
			$currNum = $this->data_redis->hIncrBy("uprop:{$this->uid}",$goods['id'],0-$num);
			$this->data_redis->hIncrBy("uprop:{$tuid}",$goods['id'],$num);
			/* $propArr = $this->data_redis->hGetAll("uprop:{$this->uid}");
			foreach ($propArr as $k=>$v){
				$propArr[$k] = (int)$v;
			} */
			$msg = '您赠送'.$num.'个'.$goods['name'].'给玩家'.$tinfo['name'].'(ID:'.$tuid.'),'.date('Y-m-d H:i:s', time());
			$this->upLog($this->uid,$msg);
			$msg = '您收到玩家'.$minfo['name'].'(ID:'.$tuid.')赠送的'.$num.'个'.$goods['name'].date('Y-m-d H:i:s', time());
			$this->upLog($tuid,$msg);
			$this->returnData(array('money'=>$minfo['money'],'props'=>array($goods['id']=>$currNum)));
		}
		
    	public function upLog($uid,$msg){    		
	    	$prizeStr = $this->data_redis->get("upropLog:".$this->uid);
			$prizeArr = json_decode($prizeStr);
			$pArr = array();
			$pArr[] = $msg;		
			$size = sizeof($prizeArr);
			for ($i = 0;$i<$size;$i++) {
				if($i>9){
					break;
				}
				$pArr[] = $prizeArr[$i];				
			}
			$jstr = json_encode($pArr);
			$this->data_redis->set("upropLog:{$uid}",$jstr);
		} 
		
		// 交易日志
		public function propLog(){
			$prizeStr = $this->data_redis->get("upropLog:".$this->uid);
			$prizeArr = json_decode($prizeStr);
			$this->returnData(array('res' => $prizeArr));
		}
		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
			$this->deinitMysql();
		}
    }
?>