<?php


class Game {
	public static $salt_password="123456"; // passwor的salt
	public static $appname = "土豪牛牛"; // 应用
	public static $init_money = 2000; // 初始金币
	public static $init_coin = 5; // 初始元宝
	public static $login_reward_money = array(500,800, 1200, 1500,1800, 2500, 5000); // 连续登陆奖励金额
	public static $play_n_count = 10; // 玩N局
	public static $play_n_reward_money = array(300, 500, 500, 500, 500, 800); // 玩N局奖励，随机选择
	public static $broke_money = 300; // 破产金额条件
	public static $broke_num_max = 3; // 每日破产次数
	public static $broke_give_money = 1000; // 破产每次赠送金币
	public static $marquee_info = array( // 跑马灯信息
				"系统:请勿上传色情头像,一经发现立即封号!",
				"大厅左下角,点击自己头像,可修改资料",
				"系统:禁止利用金币赌博,否则后果自负!",
				"禁止私下买卖金币,若经发现,买卖双方永久封号,决不姑息!",
				"在大厅,左右滑动手机屏幕可找到更多房间",
				"温馨提示:适度游戏益脑,沉迷游戏伤身!",
				"温馨提示:请注意修改密码,保障帐号安全!",
				"游戏中100%真人对局,公平竞技!",
				"祝您在游戏中玩得痛快,赢得精彩!"
	);
	public static $lottery_isopen = 1; // 抽奖开关
	public static $task_day_award_type = 1; // 开关
	public static $task_day_award_amount = 5; // 抽奖开关
	public static $lottery_activity_start = "2013-12-04"; 	// 有偿抽奖开始时间
	public static $lottery_activity_end = "2014-01-31"; 	// 有偿抽奖结束开关
	public static $lottery_activity_limit = 20000; 		// 有偿抽奖门槛
	public static $lottery_activity_pay = 20000; 			// 有偿抽奖每次消耗的金币
	public static $luckdraw_free_tot = 2;		// 乐透每日免费次数
	public static $luckdraw_pay_tot = 10;		// 乐透每日付费次数
	
	public static $slot_isopen = 1; 				// 老虎机开关
	public static $slot_base = 10000; 				// 老虎机初始化抵住
	public static $slot_limit = 50000; 				// 老虎机门槛
	public static $slot_lost_ratio = 40; 			// 老虎机必输的几率
	public static $slot_rewardcoin_period = 5; 	// 老虎机奖励元宝的周期，每玩N次开奖
	public static $slot_rewardcoin_min = 10; 		// 老虎机奖励金币的最小值
	public static $slot_rewardcoin_max = 50; 		// 老虎机奖励金币的最大值
	public static $slot_black_lost_ratio = 60; 		// 老虎机黑名单必输的几率
	public static $slot_round_time = 10; 			// 老虎机每一回合的限制时间
	public static $slot_limit_client_ver = 0; 		// 老虎机最低版本要求
	
	// 喊话需要扣除的元宝
	public static $cry_cost_money = 1000;
	// 喊话的时间间隔
	public static $cry_time_interval = 6;
	// 广播推送的周期
	public static $broadcast_time_interval = 10;
	// 客户端请求广播接口的时间周期
	public static $broadcast_time_client = 10;
	// 广播队列的最大长度
	public static $broadcast_max_list = 5;
	// 元宝喊话的队列长度
	public static $speaker_list_length = 10;
	// 多次修改昵称需要的元宝
	public static $modify_cost_coin = 250;
	// 活动赚金币统计的开关
	public static $act_money_status_open = 0;
	// 手动注册开关
	public static $manual_register_open = 1;
	// 联运默认密码
	public static $channel_default_password = 123456;
	// 头像上传的消费金币
	public static $upload_head_img_money = 500;
	// 头像上传路径
	public static $avatar_upload_path = "./Uploads/";
	// 头像下载路径
	public static $avatar_download_path = "./Uploads/";
	// 每充值1元增加N魅力
	public static $recharge_add_charm = 10;	
	// 系统任务：修改昵称签名
	public static $tasksId_edit_info = 1;
	// 系统任务：上传头像
	public static $tasksId_up_avatar = 2;
	
	//当有手机卡号imsi值的时候，允许最大的注册帐号数。
	public static $register_times = 5;
    
	//首次充值翻倍功能开关
	public static $firstPay_double_money = 0;
	
	//首次充值翻倍上限
	public static $firstPay_double_limit = 500;	
	
	// 连续签到最大天数
	public static $signin_continue_days_limit = 7;

	// 新手指引奖励
	public static $guide_money = 2439;
	// 水果机相关配置
	public static $flipcard_switch = 1;						//水果机开关
	public static $flipcard_limit = 20000;					//水果机准入
	//结算赔率,依次是五小牛、五花牛、四炸、牛牛、牛8~9、牛1~7、无牛
	public static $flipcard_res_odds = array(25,16,8,5,3,1,0.5);						
	public static $flipcard_change_times = 3;				//换牌次数
	public static $flipcard_change_cost = array(1.5,1,0.5);	//换牌额外消耗的金币(基于押注的倍数)
	public static $flipcard_bet_min = 2000;					//押注下限
	public static $flipcard_bet_max = 200000;				//押注上限
	public static $flipcard_pushmsg_money_limit = 20000;	//押注超过N，则推送广播
	public static $flipcard_pushmsg_cardtype_limit = 9;		//开中什么牌型以上，则推送广播	
	public static $flipcard_card_type = array(				//结算赔率
			'ERROR'=>0,			//错误类型
			'cow_no'=>1,		//牛0
			'cow_one'=>2,		//牛1
			'cow_two'=>3,		//牛2
			'cow_three'=>4,		//牛3
			'cow_four'=>5,		//牛4
			'cow_five'=>6,		//牛5
			'cow_six'=>7,		//牛6
			'cow_seven'=>8,		//牛7
			'cow_eight'=>9,		//牛8
			'cow_night'=>10,	//牛9
			'cow_ten'=>11,		//牛牛
			'cow_bomb'=>12,		//四炸
			'cow_whn'=>13,		//五花牛
			'cow_wxn'=>14		//五小牛
	);
	// 干预策略：0->不干预,1->全盘干预，2->个人盘干预
	public static $flipcard_control_level = 1;
	// 朋友圈分享下载地址
	public static $share_wx_apk_url = "http://203.86.3.244:9090/bull/3/3003918543.3.apk";
	// 朋友圈分享图片
	public static $share_wx_image_url = "http://203.86.3.245:99/Public/moregame/share_logo.jpg";
	// QQ分享下载地址
	public static $share_qq_apk_url = "http://203.86.3.244:9090/bull/3/3003918543.3.apk";
	// QQ分享图片
	public static $share_qq_image_url = "http://203.86.3.245:99/Public/moregame/share_logo.jpg";
	// 微博分享下载地址
	public static $share_wb_apk_url = "http://203.86.3.244:9090/bull/3/3003918543.3.apk";
	// 微博分享图片
	public static $share_wb_image_url = "http://203.86.3.245:99/Public/moregame/share_logo.jpg";
	// 短信分享下载地址
	public static $share_sms_content = "《土豪牛牛》游戏真心不错,最近玩它赢了不少话费,快来一起爽:http://t.cn/R7UxpRK";
	// 分享奖励
	public static $share_award_money = 1000;
	// 分享标题
	public static $share_title = "一起来玩土豪牛牛";
	// 分享内容
	public static $share_content = "自从玩起了土豪牛牛,我每个月都赢到了手机话费,安卓手机的小伙伴闲了来约战啊!";
	// 0点抢充额外奖励开关
	public static $recharge_rob_award_switch = 1;
	// 0点抢充的提示语
	public static $recharge_rob_award_msg = '当日充值前3位获得100%奖励，4-15位50%奖励，次日0时生效';
	// 比赛场开赛日期
	public static $fight_game_open_day = '2014-11-12~2014-11-17';
	// 比赛场开赛时间
	public static $fight_game_open_time = '12:00~14:00,18:00~20:00';
	// 比赛场显示日期
	public static $fight_game_show_day = '2014-11-11~2014-11-18';
	// 比赛场显示时间
	public static $fight_game_show_time = '11:30~14:00,17:30~20:00';
	// 日奖励明细1:1:10(奖励类型0金币1元宝2话费:奖励人数:奖励额度)
	public static $fight_today_award = '1:2:200,2:2:100,3:2:50';
	// 周奖励明细1:1:10(奖励人数:奖励类型0金币1元宝2话费:奖励额度)
	public static $fight_total_award = '1:2:500,3:2:200,10:2:100';
	// 奖励描述
	public static $fight_award_msg = '每天冠亚季军各1/2/3人,分别奖200/100/50元手机话费,每周冠亚季军各1/3/10人,分别奖500/200/100元手机话费';
	// 金币准入
	public static $fight_game_money_limit = 30000;
	// 活动时间:非活动时间为0，活动时间为时间区间
	public static $recharge_activity_time = '2014-11-11 00:00:00~2014-11-13 00:00:00';
	// 活动时间:活动期间每次登陆都显示公告，活动时间为时间区间
	public static $noticeSwitch_activity_time = '2015-01-01 00:00:00~2015-01-04 00:00:00';
	// 游戏标识
	public static $game_type = "bull";
	// 参与调研用户条件-连续登陆天数
	public static $research_need_loginDay = 7;
	// 参与调研用户条件-玩牌次数
	public static $research_need_broad = 100;
	// 参与调研用户条件-调研周期
	public static $research_time = '2014-11-11 00:00:00~2015-11-13 00:00:00';
	// 参与调研用户条件-调研周期-最后需要追加用户ID
	public static $research_url = 'http://203.86.3.245:99/App/Research/index/gtype/bullfighting/uid/';
	// 当前调研项目ID
	public static $research_curr_id = 1;
	// 公告URL-最后需要追加渠道号
	public static $notice_url = 'http://203.86.3.245:99/App/BullfightAnn/index/channel/';
	// 公告是否活跃状态
	public static $notice_effect = 0;
	// 一些临时的开关标记
	public static $temp_switch = 0;
	//平台大厅配置-资源包序列号ID
	public static $platformSeqId = "20150413-001";
	//兑换基础数据-资源包序列号ID
	public static $awardSeqId = "20150413-001";
	//特定商务渠道需要屏蔽电信计费
	public static $channel_shield_ctPay = array("100suspend000001","100suspend000002");
	//平台大厅开关-1：打开，0：关闭
	public static $platformSwitch = 1;
	// 公告URL-最后需要追加UID和skey
	public static $activity_url = 'http://203.86.3.245:99/App/BullAct/index/uid/{uid}/skey/{skey}';
	//平台大厅开关-1：打开，0：关闭
	public static $activity_switch = 1;
	//开通保险箱的描述
	public static $safebox_notice = "存储金币,调整携带数量,即可任意选场.储存的金币还不会被输掉,开通仅需10元";
	//牌桌推送跑马灯的开关-1：打开，0：关闭
	public static $table_marquee_switch = 1;
	// 月卡每日赠送的金币数
	public static $monthcard_give_money = array('1'=>5000,'2'=>20000,'3'=>80000);
	// 防刷解禁包名
	public static $pay_ban_pkg_list = array('com.hanwei.dcow');
	// 百人牛牛受限配置
	public static $bullmult_config = array(
			'betlimit'=>10000,
			'bankerlimit'=>1000000
	);
	public static $priv_config = array(
	    array(100,5000),
	    array(500,20000),
	    array(2000,100000),
	    array(10000,1000000)
	);
	// 钱学包签名
	public static $qx_package_sign = array('-656809921');
	// 钱学回调地址
	public static $qx_callback_url = 'http://127.0.0.1/bullfightingApi/phpinfo.php';
	// 破解开关
	public static $mmcrack_switch = 1;
}

?>
