<?php
/**
	 * 喊话列表
	 */
class BroadcastList extends APIBase {
	public $tag = "BroadcastList";
	public function before() {
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$awardes = array ();
		$now = time ();
		$min = date ( 'i', $now ) % 5;
		$sec = date ( 's', $now );
		if ($min == 0 && $sec <= 10) {
			$prizeStr = $this->cache_redis->get ( "marqueeList" );
			if ($prizeStr) {
				$prizeArr = json_decode ( $prizeStr );
				$awardes = $prizeArr;
				shuffle($awardes);
			}
		} else {	
			$prizeStr = $this->cache_redis->get ( "sysmess" );
			if (! $prizeStr) {
				$this->returnError ( 301, "no broadcast" );
				return;
			}		
			$prizeArr = json_decode ( $prizeStr );
			$ind = 0;
			foreach ( $prizeArr as $award ) {
				if (($now - $award->time) > Game::$broadcast_time_interval || $ind >= Game::$broadcast_max_list) {
					break;
				}
				$awardes [] = $award;
				$ind ++;
			}
		}
		if (sizeof ( $awardes ) <= 0) {
			$this->returnError ( 302, "no broadcast" );
			return;
		}
		$this->returnData ( array (
				'mes' => $awardes 
		) );
	}
	public function after() {
		$this->deinitCacheRedis ();
	}
}
?>