<?php
	/**
	 * RMB换金币
	 */
    class ExchangeMoney extends APIBase {
		
		public $tag = "ExchangeMoney";
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			if (!isset($this->param['goods_id'])) {
				$this->returnError(300, 'goods_id is needed');
			}
			//充值记录 即充即兑换
			$goods = $this->cache_redis->hGetAll("hg:{$this->param['goods_id']}");
			if (!$goods) {
				$this->returnError(321, 'goods_id is wrong');
			}
			$this->payrecord($goods['rmb']);	
					
			$this->hincrMoney($goods['money'] + $goods['give_money'],"exchangeMoney");
			$this->hincrCoin($goods['give_coin'],"exchangeMoney");
			
			$this->addGoodsLog($this->uid, $this->param['goods_id'], $goods['rmb'],
					 $goods['money'], $goods['give_money'], $goods['give_coin']);
			
			$money = $this->data_redis->hMGet("hu:{$this->uid}", array("money", "rmb", "coin"));
			$this->data_redis->hSet("hpe:{$this->uid}", "hasRecharge",1);			
			$money['money'] = (int)$money['money'];
			$money['rmb'] = (int)$money['rmb'];
			$money['coin'] = (int)$money['coin'];
			$money['hasrc'] = 1;
			$this->returnData($money);
		}
		
		public function payrecord($rmb) {
			$payrecord['uid'] = $this->uid;
			$payrecord['rmb'] = $rmb;
			$payrecord['create_time'] = time();
			$id = $this->mysql->insert("payrecord", $payrecord);
			if ($id == 0) {
				$this->e("insert payrecord error");
				$this->returnError(500, "server is error");
			}
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