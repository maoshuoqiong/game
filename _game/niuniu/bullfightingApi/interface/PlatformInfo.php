<?php
	/**
	 * 平台配置
	 */
    class PlatformInfo extends APIBase {
		
		public $tag = "PlatformInfo";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['seqId'])) {
				$this->returnError(301, '参数错误');
				return;
			}
			$seqId = $this->param['seqId'];
			if($seqId == Game::$platformSeqId){
				$this->returnError(302, '已经是最新内容');
				return;
			}			
			$prizeStr = $this->cache_redis->get("splatforminfo");
			$prizeArr = json_decode($prizeStr);
			if (isset($this->param['pkg'])) {
				foreach ( $prizeArr as $g ) {
					if($g->isHost==1 && $this->param['pkg']!= $g->packageName){
						$g->packageName = $this->param['pkg'];
					}
				}
			}
			$this->returnData(array('seqId' => Game::$platformSeqId,'items' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>