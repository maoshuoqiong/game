<?php
class Cmd {
	public static $cmd_array = array(
		'00' => "InitCache", 		// 0、配置初始化
		'01' => "Register", 		// 1、注册
		'02' => "Login", 			// 2、登陆
		'03' => "Announcement", 	// 3、公告 
		'04' => "VenueList", 		// 4、场馆配置 
		'05' => "OnPlayInfo", 		// 5、在玩人数 
		'06' => "UserInfo", 		// 6、用户本人用户信息
		'07' => "ExchangeMoney", 	// 7、RMB换金币
		'08' => "ExchangeAward", 	// 8、元宝换物品
		'09' => "PayRecord", 		// 9、充值记录
		'10' => "MessageList", 		// 10、消息
		'11' => "RankList", 		// 11、排行
		'12' => "Feedback", 		// 12、反馈
		'13' => "LoginReward", 		// 13、连续登陆奖励
		'14' => "HeartBeat", 		// 14、心跳
		'15' => "PlayNReward", 		// 15、玩N局奖励 
		'16' => "Marquee", 			// 16、跑马灯
		'17' => "BrokeNum", 		// 17、当天破产次数
		'18' => "BrokeGet", 		// 18、领取破产奖励
		'19' => "GoodsList", 		// 19、商品列表
		'20' => "AwardList", 		// 20、奖品列表
		'21' => "AutoRegister", 		// 21、自动注册登陆
                '22' => "PayRule"              // 22、计费规则  
	
	);
}
?>
