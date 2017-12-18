<?php
    class SyncRedis2Mysql extends APIBase {
		
		public $tag = "SyncRedis2Mysql";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!(isset($this->param['pass']) && $this->param['pass'] == Config::$cache_pass)) {
				$this->returnError(300, "password is error.");
			}			
			 
			if (isset($this->param['SyncRedis2Mysql']) && $this->param['SyncRedis2Mysql'] == 1) {
				$this->SyncUsers();
			}
			 
		} 
		
		private function SyncUsers() {
			//读取keys 为 hu:* 的所有用户信息
			$keys = $this->cache_redis->keys('hu:*');
			foreach ($keys as $key) {
				$uid=$this->cache_redis->hGet($key,'id');
				$money=$this->cache_redis->hGet($key,'money');
				$last_earn_money=$this->cache_redis->hGet($key,'last_earn_money');
				$coin=$this->cache_redis->hGet($key,'coin');				
				$rmb=$this->cache_redis->hGet($key,'rmb');
				$coin=$this->cache_redis->hGet($key,'coin');
				$skey=$this->cache_redis->hGet($key,'skey');
				$login_days=$this->cache_redis->hGet($key,'login_days');
				$is_get=$this->cache_redis->hGet($key,'is_get');
				$total_board=$this->cache_redis->hGet($key,'total_board');
				$total_win=$this->cache_redis->hGet($key,'total_win');
				$level=$this->cache_redis->hGet($key,'level');
				$exp=$this->cache_redis->hGet($key,'exp');
				$vid=$this->cache_redis->hGet($key,'vid');
				$heartbeat_at=$this->cache_redis->hGet($key,'heartbeat_at');
				$play_count=$this->cache_redis->hGet($key,'play_count');
				$give_money=$this->cache_redis->hGet($key,'give_money');
				$pay_count=$this->cache_redis->hGet($key,'pay_count');
				$pay_ok=$this->cache_redis->hGet($key,'pay_ok');
				$pay_ng=$this->cache_redis->hGet($key,'pay_ng');
				$broke_num=$this->cache_redis->hGet($key,'broke_num');
				$broke_time=$this->cache_redis->hGet($key,'broke_time');
				$vtime=$this->cache_redis->hGet($key,'vtime');
				$vlevel=$this->cache_redis->hGet($key,'vlevel');
				$rtime=$this->cache_redis->hGet($key,'rtime');
				$create_time=$this->cache_redis->hGet($key,'create_time');
				$update_time=$this->cache_redis->hGet($key,'update_time');
			    
				 
				//echo '$uid=', $uid ,' ;$rmb=',  $rmb ,' ; coin=', $coin ,"<p/>";
				
				//$row = $this->mysql->select("player", "COUNT(*) AS count", array('name' => $name), " AND `id` != {$this->uid}");
			  
				$arrData = array(
				'money' => $money, 
				'last_earn_money' => $last_earn_money,
				'rmb' => $rmb,
				'coin' => $coin,
				'skey' => $skey,
				'login_days' => $login_days,
				'is_get' => $is_get,
				'total_board' => $total_board,
				'total_win' => $total_win,
				'level' => $level,
				'exp' => $exp,
				'vid' => $vid,
				'heartbeat_at' => $heartbeat_at,
				'play_count' => $play_count,
				'give_money' => $give_money,
				'pay_count' => $pay_count,
				'pay_ok' => $pay_ok,
				'pay_ng' => $pay_ng,
				'broke_num' => $broke_num,
				'broke_time' => $broke_time,
				'vtime' => $vtime,
				'vlevel' => $vlevel,
				'rtime' => $rtime,
				'update_time' => $update_time				
				);
				
				$this->mysql->update("player", $arrData, array('id' =>$uid), " AND update_time < $update_time");
			         	
		     }
		}	
		
		/*
 

		 */
 		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>