<?php
/**
	 * 配置信息
	 */
class ConfigInfo extends APIBase {
	public $tag = "ConfigInfo";
	public $isLogin = false;
	public function before() {
		// $this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		$g1 = $this->cache_redis->hGet ( "hgift:1", "money" );
		$g2 = $this->cache_redis->hGet ( "hgift:2", "money" );
		$g3 = $this->cache_redis->hGet ( "hgift:3", "money" );
		$g4 = $this->cache_redis->hGet ( "hgift:4", "money" );
		$g5 = $this->cache_redis->hGet ( "hgift:5", "money" );
		$g1 = isset ( $g1 ) ? ( int ) $g1 : 0;
		$g2 = isset ( $g2 ) ? ( int ) $g2 : 0;
		$g3 = isset ( $g3 ) ? ( int ) $g3 : 0;
		$g4 = isset ( $g4 ) ? ( int ) $g4 : 0;
		$g5 = isset ( $g5 ) ? ( int ) $g5 : 0;
		$gift_money = array (
				$g1,
				$g2,
				$g3,
				$g4,
				$g5 
		);
		
		$this->returnData ( array (
				'reg_open' => Game::$manual_register_open,
				'slot_lt' => Game::$slot_limit,
				'slot_rt' => Game::$slot_round_time,
				'slot_ba' => Game::$slot_base,
				'speak_coin' => Game::$cry_cost_money,
				'slot_rc_period' => Game::$slot_rewardcoin_period,
				'gift_money' => $gift_money,
				'img_money' => Game::$upload_head_img_money,
				'bc_time' => Game::$broadcast_time_client,
				'guide_money' => Game::$guide_money,
				'share_wb_url' => Game::$share_wb_apk_url,
				'share_wb_logo' => Game::$share_wb_image_url,
				'share_qq_url' => Game::$share_qq_apk_url,
				'share_qq_logo' => Game::$share_qq_image_url,
				'share_wx_url' => Game::$share_wx_apk_url,
				'share_wx_logo' => Game::$share_wx_image_url,
				'rra_switch' => Game::$recharge_rob_award_switch,
				'rra_msg' => Game::$recharge_rob_award_msg,
				'share_money' => Game::$share_award_money,
				'share_sms_content' => Game::$share_sms_content,
				'share_title' => Game::$share_title,
				'share_content' => Game::$share_content,
				'tiger_limit'=>Game::$flipcard_limit,
				'tiger_change_times'=>Game::$flipcard_change_times,
				'tiger_bet_min'=>Game::$flipcard_bet_min,
				'tiger_bet_max'=>Game::$flipcard_bet_max,
				'notice_url'=>Game::$notice_url,
				'temp_switch'=>Game::$temp_switch,
				'init_coin'=>Game::$init_coin,
				'init_money'=>Game::$init_money,
				'act_url' => Game::$activity_url,
				'act_flag' => Game::$activity_switch,
				'safebox_notice' => Game::$safebox_notice
		) );
	}
	
	// 从Cache redis获取5个礼物的金币数
	public function after() {
		$this->deinitCacheRedis ();
		// $this->deinitMysql ();
	}
}
?>