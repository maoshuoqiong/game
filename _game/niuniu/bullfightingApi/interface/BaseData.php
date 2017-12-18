<?php
	/**
	 * 获取基础数据列表
	 */
    class BaseData extends APIBase {
		
		public $tag = "BaseData";
		public $isLogin = false;
		public function before() {
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['seqId']) || !isset($this->param['pkg'])
				 || !isset($this->param['channel'])) {
				$this->returnError(301, '参数错误');
				return;
			}
			$seqId = $this->param['seqId'];
			$pkg = $this->param['pkg'];
			$channel = $this->param['channel'];
			$isMM_audit = $this->cache_redis->get("smm_audit");	
			// 商城信息，是否审核状态,如果是MM审核阶段，则使用无赠送的计费点
			if (isset($isMM_audit) && $isMM_audit==1 && $channel === '000000000000') {
				$prizeStr = $this->cache_redis->get("sgoods_pkg:".$channel);
				$prizeArr = json_decode($prizeStr);
				$currSeqId = 'at-'.time();
			}else{
				$currSeqId = $this->cache_redis->get("data_seqId");
				if($seqId == $currSeqId){
					$this->returnError(302, '已经是最新内容');
					return;
				}
				$prizeStr = $this->cache_redis->get("sgoods_pkg:".$pkg);
				if(!$prizeStr){
					$prizeStr = $this->cache_redis->get("sgoods_pkg:def");
				}
				$prizeArr = json_decode($prizeStr);
			}
			// 普通场
			$venueStr = $this->cache_redis->get("svelist");
			$venueArr = json_decode($venueStr);
			// 百人场
			$multStr = $this->cache_redis->get("sveMultlist");
			$multArr = json_decode($multStr);
			// 私人场
			$privStr = $this->cache_redis->get("svePrivatelist");
			$privArr = json_decode($privStr);
			// TODO:
			$this->returnData(array(
					'shop' => $prizeArr,
					'venues' => $venueArr,
					'config' => array(
						'betlimit' => Game::$bullmult_config['betlimit'],
						'bankerlimit' => Game::$bullmult_config['bankerlimit']
					),
					'mult' => $multArr,
					'priv' => $privArr,
			        'mmcrack_url' => Config::$mmcrack_url,
					'seqId'=> $currSeqId));
		}
		
    	public function after() {
			$this->deinitCacheRedis();
// 			$this->deinitDataRedis();
		}
    }
?>