<?php


class Game {
	public static $salt_password="123456"; // passwor的salt
	public static $appname = "土豪斗地主"; // 应用
	public static $init_money = 5000; // 初始金币
	public static $init_coin = 5; // 初始元宝
	public static $login_reward_money = array(800, 1200, 1800, 2400, 3000); // 连续登陆奖励金额
	public static $play_n_count = 10; // 玩N局
	public static $play_n_reward_money = array(300, 500, 500, 500, 500, 800); // 玩N局奖励，随机选择
	public static $broke_money = 2000; // 破产金额条件
	public static $broke_num_max = 1; // 每日破产次数
	public static $broke_give_money = 2000; // 破产每次赠送金币
	public static $marquee_info = array( // 跑马灯信息
	                	"在活动页面可领取每日任务、成就任务奖励",
				"单次充值金额越大，优惠越多",
				"元宝可以用来兑换话费",
				"完成每日任务可获得元宝",
				"绑定手机号可作为账户名登陆",
				"元宝兑换到账时间集中在每周3",
				"连续登陆天数越多免费抽奖次数越多",
				"成就任务完成后不要忘记去领取奖励哦"
	);
	public static $lottery_isopen = 1; // 抽奖开关
	public static $task_day_award_type = 1; // 抽奖开关
	public static $task_day_award_amount = 5; // 抽奖开关
	public static $lottery_activity_start = "2013-12-04"; 	// 有偿抽奖开始时间
	public static $lottery_activity_end = "2014-01-31"; 	// 有偿抽奖结束开关
	public static $lottery_activity_limit = 100000; 		// 有偿抽奖门槛
	public static $lottery_activity_pay = 10000; 			// 有偿抽奖每次消耗的金币
		public static $luckdraw_free_tot = 2;		// 乐透每日免费次数
	public static $luckdraw_pay_tot = 10;		// 乐透每日付费次数	
	public static $slot_isopen = 1; 				// 老虎机开关
	public static $slot_base = 10000; 				// 老虎机初始化抵住
	public static $slot_limit = 50000; 			// 老虎机门槛
	public static $slot_lost_ratio = 20; 			// 老虎机必输的几率
	public static $slot_rewardcoin_period = 200; 		// 老虎机奖励元宝的周期，每玩N次开奖
	public static $slot_rewardcoin_min = 2; 		// 老虎机奖励金币的最小值
	public static $slot_rewardcoin_max = 8; 		// 老虎机奖励金币的最大值
	public static $slot_black_lost_ratio = 30; 		// 老虎机黑名单必输的几率
	public static $slot_round_time = 10; 			// 老虎机每一回合的限制时间
	public static $slot_limit_client_ver = 11; 		// 老虎机最低版本要求	

	// 喊话需要扣除的元宝
	public static $speaker_cost_coin = 250;
	// 多次修改昵称需要的元宝
	public static $modify_cost_coin = 250;
		// 元宝喊话的队列长度
	public static $speaker_list_length = 5;
	// 活动赚金币统计的开关
        public static $act_money_status_open = 0;
	// 手动注册开关
	public static $manual_register_open = 0;
	// 联运默认密码
	public static $channel_default_password = 123456;
	// vip登陆额外奖励
	public static $vip_login_reward = 10000;
	// vip额外抽奖次数
	public static $vip_lottery_num = 1;
	// 头像上传路径
	public static $avatar_upload_path = "/data/web/api/Uploads/";
	// 头像下载路径
	public static $avatar_download_path = "/data/web/api/Uploads/";
		// 特殊化处理的渠道号
	public static $special_channel = "100zjhcheck000001";
	
	//首次充值翻倍功能开关 1=开, 0=关
	public static $firstPay_double_money = 0;	
	//首次充值翻倍上限
	public static $firstPay_double_limit = 500;
	// 新版本add 20150404
	// 连续签到最大天数
	public static $signin_continue_days_limit = 7;
	// 朋友圈分享下载地址
	public static $share_wx_apk_url = "http://t.cn/RA61Lfe";
	// 朋友圈分享图片
	public static $share_wx_image_url = "http://203.86.3.245:99/Public/moregame/share_ddz_logo.png";
	// QQ分享下载地址
	public static $share_qq_apk_url = "http://203.86.3.244:9090/ddz/20/landlord_v4.0_20150428_300008992838_3003996806.apk";
	// QQ分享图片
	public static $share_qq_image_url = "http://203.86.3.245:99/Public/moregame/share_ddz_logo.png";
	// 微博分享下载地址
	public static $share_wb_apk_url = "http://203.86.3.244:9090/ddz/20/landlord_v4.0_20150428_300008992838_3003996805.apk";
	// 微博分享图片
	public static $share_wb_image_url = "http://203.86.3.245:99/Public/moregame/share_ddz_logo.png";
	// 短信分享下载地址
	public static $share_sms_content = "自从玩了土豪斗地主,赢了好多话费,再也不用自己充话费了，亲们，别说我没有告诉你哦!http://t.cn/RAElsVK";
	// 分享奖励
	public static $share_award_money = 1000;
	// 分享标题
	public static $share_title = "赢话费斗土豪地主";
	// 分享内容
	public static $share_content = "自从玩了土豪斗地主,赢了好多话费,再也不用自己充话费了，亲们，别说我没有告诉你哦!";
	// 0点抢充额外奖励开关
	public static $recharge_rob_award_switch = 1;
	// 0点抢充的提示语
	public static $recharge_rob_award_msg = '当日充值前3位获得100%奖励，4-15位50%奖励，次日0时生效';
	// 活动时间:非活动时间为0，活动时间为时间区间
	public static $recharge_activity_time = '2014-11-11 00:00:00~2014-11-13 00:00:00';
	// 广播推送的周期
	public static $broadcast_time_interval = 10;
	// 广播队列的最大长度
	public static $broadcast_max_list = 5;
	//当有手机卡号imsi值的时候，允许最大的注册帐号数。
	public static $register_times = 5;
	//imsi白名单
	public static $white_imsi = array('460015507502791','460020180261420','460030872266047',
		'460028802467000','460012228602609','460001591367753','460003402243567','460079738402056');
	//平台大厅配置-资源包序列号ID
	public static $platformSeqId = "20150520-001";	
	//平台大厅开关-0：关闭，1：打开
	public static $platformSwitch = 1;	
	//软件更新域名地址
	public static $url_update_app = "http://203.86.3.244:9090/ddz/";
}

?>
