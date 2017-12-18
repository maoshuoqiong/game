<?php
/**
	 * 获取付费坑信息
	 * @test  http://203.86.3.245:88/api.php?uid=1510&skey=f95d87d0412fb03a182cd464e58bea6e&action=PayTrap&param={%22pos%22:%220%22,%20%22trap%22:%220%22,%20%22mac%22:%22%22,%20%22ip%22:%22%22,%20%22sdk%22:%2201%22}
	 * 
	 */
class PayTrap extends APIBase {
	public $tag = "PayTrap";
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis();
		return true;
	}
	public function logic() {
		$uid = $_GET ['uid'];
		$pos = isset($this->param ['pos']) ? (int) $this->param ['pos'] : -1;
		$pos = $pos>100 ? 1 : $pos;
		$trap = isset($this->param ['trap']) ? (int) $this->param ['trap'] : -1;
		
		$isMM_audit = $this->cache_redis->get("smm_audit");
		if (isset($isMM_audit) && $isMM_audit==1) {
			$user_info = $this->data_redis->hMget("hu:{$this->uid}",array("channel"));
			// 如果是MM审核阶段，则没有坑
			if($user_info['channel']=='000000000000'){
				$this->returnError(301, "no data");
				return;
			}
		}
		$trap_info = $this->get_trap_info($uid, $pos, $trap, 1) ;
		//取到坑数据
		if(!empty($trap_info)) {	
			//返回坑信息			
			$this->returnData ( $trap_info );			
		}
		else {
			$this->returnError(301, "no data");
		}
		
	}
	
	public function after() {
		$this->deinitMysql ();
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
	}
}
?>