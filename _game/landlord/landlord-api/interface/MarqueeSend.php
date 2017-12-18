<?php
	/**
	 * 牌桌喊话
	 */
    class MarqueeSend extends APIBase {
		public $tag = "MarqueeSend";
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			if (!isset($this->param['msg']) || empty($this->param['msg'])) {
				$this->returnError(301, '内容不能为空');
				return;
			}
			$msg = $this->param['msg'];
			if (strlen($msg) > 150 or strlen($msg) < 1) {
				$this->returnError(301, '1至50个汉字');
				return;
			}
			$coin = $this->data_redis->hMget("hu:{$this->uid}",array("coin","name"));
			if((int)$coin['coin']<Game::$speaker_cost_coin){
				$this->returnError(301, '元宝不足，需要'.Game::$speaker_cost_coin.'元宝');
				return;
			}
			$curr_coin = $this->hincrCoin(0 - Game::$speaker_cost_coin,"marquee");
			if(!$coin['name']){
				$this->initMysql();
				$name = $this->mysql->select("player", "name", array('id' => $this->uid));
				$coin['name'] = $name[0]['name'];
				$this->deinitMysql();
			}
			$prizeStr = $this->cache_redis->get("sSpeakerList");
			$var['u'] = $coin['name'];
			$var['m'] = $msg;
			if ($prizeStr) {
				$prizeArr = json_decode($prizeStr);
				if(sizeof($prizeArr)>=Game::$speaker_list_length){
					array_pop($prizeArr);
				}
			}else{
				$prizeArr = array();
			}
			array_unshift($prizeArr, $var);			
// 			var_dump($prizeArr);
			$this->cache_redis->set("sSpeakerList",json_encode($prizeArr));
			// 喊话是否塞进广播里
			$msg = $var['u'].":".$var['m'];
			$this->sendBroadcast($msg, "cry");
			$this->data_redis->hSet("hpe:{$this->uid}","lastCryTime",time());			
			$this->returnData(array("coin"=>$curr_coin));
		}
		
		public function after() {
			$this->deinitDataRedis();
			$this->deinitCacheRedis();
		}
    }
?>