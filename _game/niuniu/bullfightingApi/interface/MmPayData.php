<?php
/**
	 * 获取移动MM的支付参数,无提示版
	 * 
	 */
class MmPayData extends APIBase {
	public $tag = "MmPayData";
	public function before() {
		// $this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$uid = $_GET ['uid'];
		// 获取用户设备标识
		$user_info = $this->data_redis->hMget ( "hu:$uid", array (
				'imsi',
				'imei',
				'pkg',
				'channel' 
		) );
		
		// 判断是否移动用户
		$imsi = empty ( $user_info ['imsi'] ) ? "" : $user_info ['imsi'];
		$op = CommonTool::getOP ( $imsi );
		
		if ($op == 1) {
			$channel = empty ( $user_info ['channel'] ) ? "" : $user_info ['channel'];
			
			// 获取历史支付渠道
			$old_chn = $this->cache_redis->hget ( "hmmpay:$uid", 'channel' );
			
			$prizeStr = $this->cache_redis->get ( "smmparams" );
			$prizeArr = json_decode ( $prizeStr );
			$num = count ( $prizeArr );
			$arr1 = array ();
			$arr2 = array ();
			$arr3 = array ();
			$equal = 0;
			$old_chn_flag = 0;
			// srand((double)microtime()*1000000);
			$n = 0;
			$rand_i = rand ( 1, $num );
			if ($num > 0) {
				foreach ( $prizeArr as $pt ) {
					++ $n;
					
					$chn = $pt->channel;
					$sh = $pt->sh;
					$s5 = $pt->s5;
					$pdi = $pt->pdi;
					$sg = $pt->sg;
					$aey = $pt->aey;
					$spcode = $pt->spcode;
					if ($rand_i == $n) {
						$arr1 ["channel"] = $chn;
						$arr1 ["sh"] = $sh;
						$arr1 ["s5"] = $s5;
						$arr1 ["pdi"] = $pdi;
						$arr1 ["sg"] = $sg;
						$arr1 ["aey"] = $aey;
						$arr1 ["spcode"] = $spcode;
					}
					if ($chn == $old_chn) {
						$arr3 ["channel"] = $chn;
						$arr3 ["sh"] = $sh;
						$arr3 ["s5"] = $s5;
						$arr3 ["pdi"] = $pdi;
						$arr3 ["sg"] = $sg;
						$arr3 ["aey"] = $aey;
						$arr3 ["spcode"] = $spcode;
						$old_chn_flag = 1;
					}
					if ($channel == $chn) {
						$arr2 ["channel"] = $chn;
						$arr2 ["sh"] = $sh;
						$arr2 ["s5"] = $s5;
						$arr2 ["pdi"] = $pdi;
						$arr2 ["sg"] = $sg;
						$arr2 ["aey"] = $aey;
						$arr2 ["spcode"] = $spcode;
						
						$equal = 1;
						break;
					}
				}
			}
			
			if ($equal == 1) {
				$this->returnData ( $arr2 );
			} else {
				if ($old_chn_flag == 1) {
					$this->returnData ( $arr3 );
				} else if (count ( $arr1 ) > 0) {
					$this->returnData ( $arr1 );
					$this->cache_redis->hset ( "hmmpay:$uid", 'channel', $arr1 ["channel"] );
				} else {
					$this->returnError ( 300, "获取数据失败。" );
				}
			}
		} else {
			$this->returnError ( 300, "获取数据失败。" );
		}
		
		// echo "num=".$num."&n=".$n."&rand_i=".$rand_i;
		// echo "<br/>arr1=".implode($arr1);
		// echo "<br/>arr2=".implode($arr2);
	}
	public function after() {
		// $this->deinitMysql ();
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
	}
}
?>