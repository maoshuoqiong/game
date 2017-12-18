<?php
/**
 * 获取goods列表

01:移动mm
02:联通
03:微派
04:电信 
05:支付宝
06:银联
07:神州付
08:移动弱

http://203.86.3.249:88/api.php?action=GoodsInfo&param={"pkg":""}
 *
 */
    class GoodsInfo extends APIBase {
		
		public $tag = "GoodsInfo";
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
				if($user_info['channel']=='000000000000'){
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
					$prizeStr = $this->cache_redis->get("sgoods");
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