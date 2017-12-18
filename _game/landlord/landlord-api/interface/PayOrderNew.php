<?php
/**
	 * 在支付前生成系统的订单号
	 * @test api.php?uid=32308&skey=2a0ccf663061299553fbb46319d49dc4&action=PayOrder&param={"sdk":"01","rmb":10,"mac":"","ip":""}
	 */
class PayOrderNew extends APIBase {
	public $tag = "PayOrderNew";
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$uid = $_GET ['uid'];
		$sdk = isset($this->param ['sdk']) ? $this->param ['sdk'] : "";		
		
		$str_rmb = isset($this->param ['rmb']) ? $this->param ['rmb'] : 0;
		$rmb =  (int) $str_rmb;
		
		$ip = isset($this->param ['ip']) ? $this->param ['ip'] : "";
		$mac = isset($this->param ['mac']) ? $this->param ['mac'] : "";	
		//20140923 如果是坑，则把坑信息带上来
		$trap = isset($this->param ['trap']) ? (int)$this->param ['trap'] : -1;	
		$pos = isset($this->param ['pos']) ? (int)$this->param ['pos'] : -1;
		$pos = $pos>100 ? 1 : $pos;
		if (isset ( $this->param ['mac'] )) {
			// 把分隔符":" 替换为""
			$mac = str_replace ( ":", "", $this->param ['mac'] );
		}
		
		//vip购买
		$vid = 0;
		if (isset($this->param['vid'])) {
			$vid = (int) $this->param['vid'];			
		}
		$user_info = $this->data_redis->hMget ( "hu:$uid", array (
				'channel',
				'fen-1',
				'fen-10',
				'pkg',
				'ver'
		) );
		if(($user_info['fen-1'] && $str_rmb=='0.01') || ($user_info['fen-10'] && $str_rmb=='0.1')){
			$this->returnError(301, "此额度不能重复购买!");
			return;
		}
		//支持特殊支付的标记
		$mmSpeFlag = isset($this->param ['mmSpeFlag']) ? (int)$this->param ['mmSpeFlag'] : 0;
		if ($mmSpeFlag > 0 && (strcmp ( $sdk, "08" ) == 0 || strcmp ( $sdk, "01" ) == 0) && $rmb > 0) {
			//获取用户基本信息			
			$mm_pkg = $user_info['pkg'] ; 
			$mm_chn = $user_info['channel'] ;			
			$mm_ver = (int)$user_info['ver'] ;
			 	
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
				
		//获取订单号
		$order_id = $this->get_pay_order($sdk, $rmb);
				
		// 根据sdk rmb 查找 计费点信息，判断有效性		
		$sql = "select b.money,b.coin,b.rmb,a.app_key from pay_sdk a join pay_points b on a.id=b.pay_sdk_id where a.sdk='{$sdk}' and b.rmb='{$rmb}'";
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
			$row[0]['coin'] = $rmb;
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
		$order_log['sdk'] = $sdk;
		$order_log['uid'] = $uid;
		$order_log['order_id'] = $order_id;
		$order_log['mac'] = $mac;
		$order_log['ip'] = $ip;
		$order_log['updated_at'] = date ( 'Y-m-d H:i:s' );
		$order_log['created_at'] = date ( 'Y-m-d H:i:s' );
		
		$order_log['vid'] = $vid;
		
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
		// 如果是联通计费，需要app_key和计费点key
		if (strcmp ( $sdk, "02" ) == 0) {
			$cuPoint = $this->cache_redis->get('cupoint:'.$order_log['rmb_fen']);
			$order_log['appkey'] = $row[0]['app_key'];
			$order_log['point'] = $cuPoint;
		}
		$this->mysql->insert ( "payorder", $order_log );

		// 返回订单信息
		$order_info = array ();
		
		//如果是银联支付，则需要调用银联的接口获取tn
		if (strcmp ( $sdk, "06" ) == 0) {			
			//$url = Config::$url_upmp;
			//$url = "http://203.86.3.244:8888/payorder/upmpOrder";
			$url = "http://203.86.3.244:8888/unionpayddz/order";
			
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
		
	public function after() {
		$this->deinitMysql ();
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
	}
}
?>