<?php
	/**
	 * 连续登录奖励
	 */
    class ShareReward extends APIBase {
		
		public $tag = "ShareReward";
		
    	public function before() {
    		$this->initCacheRedis();
    		$this->initMysql();
			return true;
		}
		
		public function logic() {			
			$now = time();
			if (!isset($this->param ['shareType'])) {
				$this->returnError(301, "分享成功~" );
				return;
			}
			$st = $this->param ['shareType'];
			if($st=='qq'){
				$shareKey = 'lastQQst';
			}elseif ($st=='wx'){
				$shareKey = 'lastWXst';
			}elseif ($st=='wb'){
				$shareKey = 'lastWBst';
			}elseif ($st=='sms'){
				$shareKey = 'lastSMSst';
			}else {
				$this->returnError(301, "分享成功！" );
				return;
			}			
			$lastShareTime = $this->data_redis->hGet("hpe:{$this->uid}",$shareKey);
			$share_log = array(
					'uid'=>$this->uid,
					'shareType'=>$st,
					'create_time'=>date('Y-m-d H:i:s', $now)
			);
			if($lastShareTime && CommonTool::isSameDay($lastShareTime, $now)){
				$share_log['isReward'] = 0;
				$this->mysql->insert('share_log', $share_log);
				$this->returnError(301, "分享成功！今天的分享奖励已领取" );
				return;
			}
			$this->data_redis->hSet("hpe:{$this->uid}",$shareKey,$now);
			$share_log['isReward'] = 1;
			$this->mysql->insert('share_log', $share_log);
			$money = $this->hincrMoney(Game::$share_award_money, 'shareAward');
			$this->returnData(array('curr_money'=>$money));		
		}
		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
			$this->deinitMysql();
		}
    }
?>