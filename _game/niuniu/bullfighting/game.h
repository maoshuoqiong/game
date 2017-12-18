#ifndef _GAME_H_
#define _GAME_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ev++.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include "tasks.h"
#include "gifts.h"

#include <time.h>
#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <json/json.h>

class Client;
class Player;
class Table;

typedef struct {
	std::string title;
	int minMoney;
	int maxMoney;
} TitleInfo;

typedef struct {
	int level;
	int min_recharge;
	int min_exp;
	int ext_award;
} VipInfo;

typedef struct {
	int minExp;
	int maxExp;
} LevelInfo;

typedef struct {
	int task_id;
	int task_finish_type;
	int task_finish_num;  // 0:no finish,1:conform type,2:win and finish if need
	int task_award_type;	// 0:money,1:coin
	int task_award_amount;
} TasksInfo;

typedef struct {
	std::string type;
	std::string msg;
} SysMsgInfo;

class Game {
public:
	std::map<int, Table*> playing_tables;
	std::map<int, Table*> waiting_tables;
	std::map<int, Table*> zero_tables;
	std::map<int, Table*> all_tables;
	std::map<int, Client*> fd_client;
	std::map<int, Player*> offline_players;
	std::map<int, Player*> online_players;
	std::vector<TasksInfo> ach_tasks;
	std::vector<TasksInfo> day_tasks;
	time_t lastUp_day_time;
	ev_timer speaker_timer;
	ev_tstamp speaker_timer_s;
	vector<Gifts> vgifts;
	int broke_money_limit;      // 破产条件
	int broke_give_num_max;     // 破产次数
	int broke_give_to;    		// 破产赠送的金币
	int talk_need_money;        // 桌聊需要金币
	int talk_time_diff;         // 桌聊时间间隔
	unsigned int talk_str_len;    		// 桌聊字符长度限制

	std::vector<VipInfo> vipList;				 // vip基础信息列表
	std::vector<TitleInfo> titleList;            // 头衔基础信息列表
	std::vector<SysMsgInfo> broadcastList;       // 广播缓存列表
	std::map<int, LevelInfo> levelList;			 // 等级列表
	std::vector<string> blackwordList;			 // 敏感字
	int up_vip_min_exp;		// 当经验值超过N时才需要检测是否更新VIP
	int exp_lost;        	// 输牌获得的经验值
	int exp_win;        	// 赢牌牌获得的经验值
	int help_need_money;	// 提示功能是否需要消耗金币
	int gift_money_flag;	// 礼物是否可以交易
	int	game_type;			// 牌桌类型:0普通,1比赛,2私人场

private:
	ev_io _ev_accept;
	int _fd;
public:
	Game();
	virtual ~Game();
	int start();
	static void accept_cb(struct ev_loop *loop, struct ev_io *w, int revents);
	void del_client(Client *client);

	int dispatch(Client *client);
	int safe_check(Client *client, int cmd);
	int handler_join_table(Client *client);
	// 更新牌桌：0,删除玩家时；1,加入玩家时
	int update_table(int tid, int type);
	int send_error(Client *client, int cmd, int error_code);
	void dump_msg(std::string msg);
	void dump_game_info(char *tag);
	int check_skey(Client *client);
	int add_player(Client *client);
	int del_player(Player *player);
	int leave_curr_table(Player *player);
	int init_tasks_ach();
	int init_tasks_day();
	void check_tasks_day();
	static void speaker_timer_cb(struct ev_loop *loop, struct ev_timer *w,
			int revents);  /* 每10秒获取并推送一次系统消息 */

	int init_gifts();
	int init_conf();
	int isFightOpenTime();
	int handler_join_priv_table(Client *client,int tid,int ouid);
private:
	int init_table();
	int init_accept();

};

#endif
