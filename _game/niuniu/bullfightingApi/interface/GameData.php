<?php
	/**
	 * 和用户相关的动态数据
	 */
    class GameData extends APIBase {

		public $tag = "GameData";

		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$hasNoRead = CommonTool::hasNoReadMes($this->cache_redis,$this->data_redis,$this->uid);
			$sdk = CommonTool::getSdk($this->cache_redis,$this->uid,$this->param['imsi'],
					strtolower($this->param['appId']),strtolower($this->param['cpId']),$this->param['sdks']);
			$num = (int)$this->cache_redis->get("sslotnum");
			$this->returnData(array('noread' => $hasNoRead,'slot_rc_cnum' => $num,'isGetGuide' => 0));
		}		
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>