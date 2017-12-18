<?php
	/**
	 * 获取award列表V20
	 */
    class AwardList extends APIBase {
		
		public $tag = "AwardList";
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
			if($seqId == Game::$awardSeqId){
				$this->returnError(302, '已经是最新内容');
				return;
			}
			$prizeStr = $this->cache_redis->get("sAwardV20");
			$prizeArr = json_decode($prizeStr);
			$this->returnData(array('res' => $prizeArr,'seqId' => Game::$awardSeqId));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>