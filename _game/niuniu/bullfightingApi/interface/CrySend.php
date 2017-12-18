<?php
include_once 'ValidateService.php';
	/**
	 * 喊话
	 */
    class CrySend extends APIBase {
		public $tag = "CrySend";
		public function before() {
			$this->initCacheRedis();
			$this->initMysql ();
			return true;
		}
		
		public function logic() {
			if (!isset($this->param['msg']) || empty($this->param['msg'])) {
				$this->returnError(301, '内容不能为空');
				return;
			}
			$msg = $this->param['msg'];
			if (strlen($msg) < 1) {
				$this->returnError(301, '内容不能为空');
				return;
			}
			$lastTime = $this->data_redis->hGet("hpe:{$this->uid}","lastCryTime");
			$now = time();
			if($lastTime>0 && (time()-$lastTime)<Game::$cry_time_interval){
				$this->returnError(301, '亲!发送过快,请歇会再试!');
				return;
			}
			
			$ret = ValidateService::validate_blackword ( $msg, $this->mysql );
			if ($ret > 0) {
				$this->returnError(301, '含有敏感字符，请重新输入。');
				return;				
			}
			
			if(strlen($msg)>150){
				$msg = substr($msg, 0,150);
			}			
			$mon = $this->data_redis->hMget("hu:{$this->uid}",array("money","name"));
			if((int)$mon['money']<Game::$cry_cost_money){
				$this->returnError(301, '金币不足'.Game::$cry_cost_money.',发送失败');
				return;
			}
			$curr_money = $this->hincrMoney(0 - Game::$cry_cost_money,"cry");

			if(!$mon['name']){
				$this->initMysql();
				$name = $this->mysql->select("player", "name", array('id' => $this->uid));
				$mon['name'] = $name[0]['name'];
				$this->deinitMysql();
			}			
			// 放进喊话列表里
			$prizeStr = $this->cache_redis->get("sSpeakerList");
			$var['user'] = $mon['name'];
			$var['msg'] = $msg;
			if ($prizeStr) {
				$prizeArr = json_decode($prizeStr);
				if(sizeof($prizeArr)>=Game::$speaker_list_length){
					array_pop($prizeArr);
				}
			}else{
				$prizeArr = array();
			}
			array_unshift($prizeArr, $var);
			$this->cache_redis->set("sSpeakerList",json_encode($prizeArr));			

			// 喊话是否塞进广播里
			$msg = $mon['name'].":".$msg;
			$this->sendBroadcast($msg, "1");
			$this->data_redis->hSet("hpe:{$this->uid}","lastCryTime",$now);
			$this->returnData(array("money"=>$curr_money));
		}
		
		public function after() {
			$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql ();
		}
    }
?>