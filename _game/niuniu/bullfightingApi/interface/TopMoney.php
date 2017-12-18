<?php
	/**
	 * 金币排行列表
	 */
    class TopMoney extends APIBase {
		
		public $tag = "TopMoney";
				
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
								
			$prizeStr = $this->cache_redis->get ( "sMoneyRank" );
			if (! $prizeStr) {
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
			
			if ($mam == 0) {
				$mam = (int ) $this->data_redis->hget("hu:{$this->uid}", "money");
			}
			// var_dump($prizeArr);
			$this->returnData ( array (
					'mno' => $mno,
					'mam' => $mam,
					'ranks' => $prizeArr
			) );
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>