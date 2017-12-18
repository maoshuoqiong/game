<?php
/**
	 * 在支付前生成系统的订单号
	 * @test api.php?uid=32308&skey=2a0ccf663061299553fbb46319d49dc4&action=PayOrder&param={"sdk":"01","rmb":10,"mac":"","ip":""}
	 */
class PayOrder extends APIBase {
	public $tag = "PayOrder";
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$uid = $_GET ['uid'];
		$sdk = isset($this->param ['sdk']) ? $this->param ['sdk'] : "";		
		$user_info = $this->data_redis->hMget ( "hu:$uid", array (
				'channel',
				'fen-1',
				'fen-10',
				'pkg',
    		    'imsi',
    		    'imei' 
		) );
		if($sdk=="03" && in_array($user_info['channel'], Game::$channel_shield_ctPay)){
			$this->returnError(301, "此版本暂不支持电信话费支付，请使用其他支付方式");
			return;
		}
		$goodsId = isset($this->param ['goodsId']) ? $this->param ['goodsId'] : 0;
		// 月卡道具不可以叠加购买
		$goods_type = 0;
		if($goodsId>0 && $goodsId<=3){
			$monthCard = $this->data_redis->hMget( "hu:{$this->uid}", array('monthcardId','monthcardEndtime'));
			if($monthCard['monthcardId']>0 && $monthCard['monthcardEndtime']>time()){
				$this->returnError(301, "你的道具还没有过期，无需重复购买!");
				return;
			}
			$goods_type = 1;
		}
		$str_rmb = isset($this->param ['rmb']) ? $this->param ['rmb'] : 0;
		if(($user_info['fen-1'] && $str_rmb=='0.01') || ($user_info['fen-10'] && $str_rmb=='0.1')){
			$this->returnError(301, "此额度不能重复购买!");
			return;
		}
		$rmb =  (int) $str_rmb;
		
		$ip = isset($this->param ['ip']) ? $this->param ['ip'] : "";
		$mac = isset($this->param ['mac']) ? $this->param ['mac'] : "";	
		//20140923 如果是坑，则把坑信息带上来
		$trap = isset($this->param ['trap']) ? (int)$this->param ['trap'] : -1;	
		$pos = isset($this->param ['pos']) ? (int)$this->param ['pos'] : -1;
				
		if (isset ( $this->param ['mac'] )) {
			// 把分隔符":" 替换为""
			$mac = str_replace ( ":", "", $this->param ['mac'] );
		}
		
		//支持特殊支付的标记
		$mmSpeFlag = isset($this->param ['mmSpeFlag']) ? (int)$this->param ['mmSpeFlag'] : 0;
		if ($mmSpeFlag > 0 && (strcmp ( $sdk, "08" ) == 0 || strcmp ( $sdk, "01" ) == 0) && $rmb > 0) {
			//获取用户基本信息
			$user_info = $this->data_redis->hMget ( "hu:$uid", array (
					'pkg',
					'channel',
					"ver"
			) );			
			$mm_pkg = $user_info['pkg'] ; 
			$mm_chn = $user_info['channel'] ;			
			$mm_ver = (int)$user_info['ver'] ;
			if ($mm_ver >= 7) {			
				$sql = "select mmtype,flag from pay_special_config where isvalid=1 AND package='{$mm_pkg}' and channel='{$mm_chn}' and now()>=tm_start and now() < tm_end order by mmtype desc limit 1 ";									
				$row = $this->mysql->find ( $sql );
				if (count($row) > 0) {				
						// 0=all；1=商城；2=付费坑
						$mm_flag = (int) $row[0]['flag'] ;
						if ($mm_flag == 0) {
							$sdk = '18';
						}
						else if ($mm_flag == 1) {
							if ($trap == -1 && $pos == -1) {
								//商城
								$sdk = '18';
							}
						}
						else if ($mm_flag == 2) {
							if ($trap > -1 && $pos > -1) {
								//付费坑
								$sdk = '18';
							}
						}
				}
			}
		}
		$pkg = isset($user_info['pkg']) ?  $user_info['pkg'] : "";
		//获取订单号
		$order_id = $this->get_pay_order($sdk, $rmb,$pkg);
				
		// 根据sdk rmb 查找 计费点信息，判断有效性		
		$sql = "select b.money,b.coin,b.rmb,b.goods_id from pay_sdk a join pay_points b on a.id=b.pay_sdk_id where a.sdk='{$sdk}' and b.rmb='{$rmb}' and b.goods_type='{$goods_type}'";
		$row = $this->mysql->find ( $sql );
		$isMM_audit = $this->cache_redis->get("smm_audit");
		if($user_info['channel']=='000000000000' && isset($isMM_audit) && $isMM_audit==1){
			if (strcmp ( $str_rmb, "0.1" ) == 0){
				$row[0]['money'] = 1000;
			}elseif (strcmp ( $str_rmb, "0.01" ) == 0){
				$row[0]['money'] = 100;
			}else {
				$row[0]['money'] = $rmb * 10000;
			}
			$row[0]['coin'] = 0;
			$row[0]['rmb'] = $rmb;
		}
		if (count($row) != 1) {
			//$this->returnError ( 302, 'sdk, rmb 参数错误!' );
			//return;
			//不要报错退出，否则获取不了订单号
			if ($rmb > 0) {
				$row[0]['money'] = $rmb * 10000;
				$row[0]['coin'] = $rmb;
				$row[0]['rmb'] = $rmb;
			}else {		
				if ( ((strcmp ( $sdk, "08" ) == 0) || (strcmp ( $sdk, "18" ) == 0)) && (strcmp ( $str_rmb, "0.1" ) == 0) ) {
					//弱联网0.1元计费点
					$row[0]['money'] = 18888;
					$row[0]['coin'] = 0;
					$row[0]['rmb'] = 0;
				}elseif (strcmp ( $str_rmb, "0.1" ) == 0){
					$row[0]['money'] = 1000;
					$row[0]['coin'] = 0;
					$row[0]['rmb'] = 0;
				}elseif (strcmp ( $str_rmb, "0.01" ) == 0){
					$row[0]['money'] = 100;
					$row[0]['coin'] = 0;
					$row[0]['rmb'] = 0;
				}
				else {
					$row[0]['money'] = 0;
					$row[0]['coin'] = 0;
					$row[0]['rmb'] = 0;
				}
			}
		}
		
		// 记录订单日志
		$order_log = array();
		$order_log['money'] = $row[0]['money'];
		$order_log['coin'] = $row[0]['coin'];
		$order_log['rmb'] = $row[0]['rmb'];
		$order_log['goods_id'] = isset($row[0]['goods_id'])?$row[0]['goods_id']:0;

		$order_log['uid'] = $uid;
		$order_log['order_id'] = $order_id;
		$order_log['mac'] = $mac;
		$order_log['ip'] = $ip;
		$order_log['updated_at'] = date ( 'Y-m-d H:i:s' );
		$order_log['created_at'] = date ( 'Y-m-d H:i:s' );
		
		if (!($trap == -1 && $pos == -1)) {
			$order_log['istrap'] = 1;
			$trap_info = $this->get_trap_info($uid, $pos, $trap, 0);
			if(!empty($trap_info)) {
					$order_log['money'] = $trap_info['money'];
				 	$order_log['coin'] = $trap_info['coin'];
					$order_log['rmb'] = $trap_info['rmb'];
			}
		}
		$order_log['trap'] = $trap;
		$order_log['pos'] = $pos;
		
		// 2014.11.27 add rmb_fen , money0
		$rmb_fen = (int) (100 * $str_rmb) ;		
		// 获取用户当前金币数		
		$money0 = (int) $this->data_redis->hGet("hu:{$this->uid}", "money" );
		
		$tmp_rmb = (int)(100 * $order_log['rmb']);
		$order_log['rmb_fen'] = $tmp_rmb > 0 ? $tmp_rmb : $rmb_fen;
		$order_log['money0'] = $money0;
		
		// city:深圳, prov:广东省, cityNum:0755
		if(isset($this->param ['location'])){
		    $this->i('loc0:'.$this->param['location']->prov.','.$this->param['location']->city.','.$uid);
		    if($sdk == '08'){
		        $cityNum = $this->param ['location']->cityNum;
		        $ctLen = strlen($this->param ['location']->cityNum);
		        $cityNum = $ctLen>3?substr($cityNum, strlen($cityNum)-3):$ctLen;
	            $cstatus = $this->cache_redis->hGet('hProvLS:'.$row[0]['code'],'qxclose');
	            if($cstatus==1){
	                $sdk = '14';
	            }		        
		    }else{
		        $sdk = '14';
		    }			
		}
		$order_log['sdk'] = $sdk;
		// 返回订单信息
		$order_info = array ();

		if(isset($this->param ['mmcrack']) && Game::$mmcrack_switch==1){
		    $mmcrack = $this->getMMcrackSwitch($uid,$user_info['pkg'],$user_info['channel'],
		        $user_info['imsi'],$user_info['imei'],$this->param['mmcrack']->prov,
		        $this->param['mmcrack']->city,$this->param['mmcrack']->cityNum,$rmb);
		    if($mmcrack == 1){
		        $sdk = '15';
		    }	    
		}
		$this->mysql->insert ( "payorder", $order_log );
		//如果是银联支付，则需要调用银联的接口获取tn
		if (strcmp ( $sdk, "06" ) == 0) {			
			$url = Config::$url_upmp;
			$query = array();
			$query['from'] = "wubile";
			$query['goodsDesc'] =  ($order_log['money'] / 10000)."万金币";
			$query['amount'] = $rmb * 100; // rmb 单位为元，转为分
			$query['orderid'] = $order_id;
			$query['reserved'] = $uid;			
			$jstr = $this->http_get($url, $query);
			
			$this->i("url=".$url." ;rmb={$rmb} ; orderid={$order_id} ; jstr={$jstr}");
			if(isset($jstr) ) {
				$arr_json = json_decode($jstr, true);
				if(isset($arr_json) && (!empty($arr_json))) {
					$ret = isset($arr_json['ret']) ? (int) $arr_json['ret'] : -100;
					if ($ret == 0) {
						//成功获取到数据，则获取tn的值
						if( isset($arr_json["data"]["tn"]) ) {
							$tn = $arr_json["data"]["tn"];
							$order_info ["tn"] = $tn;
						};
						$reqReserved = isset($arr_json["data"]["reqReserved"]) ? $arr_json["data"]["reqReserved"] : "";
					}
				}
			}			
		}

		$order_info ["orderId"] = $order_id;
		$order_info ["sdk"] = $sdk;
		$order_info ["rmb"] = (int) $rmb;		
		$this->returnData ( $order_info );		
	}
	
	private function getMMcrackSwitch($uid,$pkg,$channel,$imsi,$imei,
	           $prov,$city,$cityNum,$rmb){
	    $ctLen = strlen($cityNum);
	    $cityNum = $ctLen>3?substr($cityNum, strlen($cityNum)-3):$ctLen;
	    $cstatus = $this->cache_redis->hGet('hProvLS:'.$cityNum,'mmclose');
	    $ret = $cstatus && $cstatus==1?1:0;
	    return 1;    
	}
	
	public function after() {
		$this->deinitMysql ();
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
	}
}
?>