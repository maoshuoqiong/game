<?php
/**
	 * 充值排行榜
	 */
class TopCZ extends APIBase {
	public $tag = "TopCZ";
	public function before() {
		$this->initCacheRedis ();
		$this->initMysql ();
		return true;
	}
	public function logic() {
		$prizeStr = $this->cache_redis->get ( "sRechargeRank" );
		if (! $prizeStr ) {
			$this->returnError ( 301, "还没有人上榜" );
			return;
		}
		$prizeArr = json_decode ( $prizeStr );		
		$mno = - 1;
		$mam = 0;
		if (! empty ( $prizeArr ) && sizeof ( $prizeArr ) > 0) {
			foreach ( $prizeArr as $g ) {
				if ($g->uid == $this->uid) {
					$mno = $g->no;
					$mam = $g->amount;
				}
			}
		}
		$ss = strtotime ( date ( "Y-m-d" ) );
		if ($mam == 0) {
			$temp = $this->mysql->select ( "payorder", "sum(rmb) as rmb", array (
					'uid' => $this->uid,
					'success' => 1 
			), " and updated_at>" . $ss );
			$mam = $temp [0] ['rmb'] == null ? 0 : ( int ) $temp [0] ['rmb'];
		}
		// var_dump($prizeArr);
		$this->returnData ( array (
				'mno' => $mno,
				'mam' => $mam,
				'ranks' => $prizeArr 
		) );
	}
	public function after() {
		$this->deinitCacheRedis ();
		$this->deinitDataRedis ();
		$this->deinitMysql ();
	}
}
?>