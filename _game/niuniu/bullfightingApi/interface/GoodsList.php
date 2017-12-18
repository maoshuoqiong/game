<?php
	/**
	 * 获取goods列表
	 */
    class GoodsList extends APIBase {
		
		public $tag = "GoodsList";
		public $isLogin = false;
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$isMM_audit = $this->cache_redis->get("smm_audit");			
			if (isset($this->param['uid']) && isset($isMM_audit) && $isMM_audit==1) {
				$uflag = $this->param['uid'];
				$this->initDataRedis($uflag);
				$user_info = $this->data_redis->hMget("hu:{$uflag}",array("channel"));
				$bln = false;
				// 如果是MM审核阶段，则使用无赠送的计费点
				if($user_info['channel']==='000000000000'){
					$prizeStr = $this->cache_redis->get("sgoods_channel:000000000000");
					$prizeArr = json_decode($prizeStr);
					$this->returnData(array('goods' => $prizeArr));
					$bln = true;
				}				
				$this->deinitDataRedis();
				if($bln){
					return;
				}
			}			
			if (!isset($this->param['pkg'])) {
				$prizeStr = $this->cache_redis->get("sgoods_channel:def");
			}else{
				$pkg = $this->param ['pkg'];
				$prizeStr = $this->cache_redis->get("sgoods_channel:".$pkg);
				if(!$prizeStr){
					$prizeStr = $this->cache_redis->get("sgoods_channel:def");
				}
			}
						
			$prizeArr = json_decode($prizeStr);
// 			var_dump($prizeArr);
			$this->returnData(array('goods' => $prizeArr));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
		}
    }
?>