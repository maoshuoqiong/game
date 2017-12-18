#ifndef _PLAYER_H_
#define _PLAYER_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ev++.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <errno.h>
#include <iostream>
#include <fstream>
#include <string>
#include <time.h>
#include <json/json.h>
#include <ev.h>

#include "hole_cards.h"

class Client;

typedef enum
{
	FIGHTER = 0,
	KEEPER,
} Player_Role;
	
typedef enum
{
	ADD = 0,
	SUB,	
} update_action;

class Player
{		
public:
	int 				index;
	// table router information
	int					vid;
    int					tid;
	int					seatid;		// 座位ID
	std::string			version;
	// player information
    int                 uid;
	std::string			skey;
	std::string			name;
	int					sex;
	int					avatar;		// 头像ss
	int					exp;		// 经验
	int					money;
	int					coin;
	int					totalPoint;		// total比赛积分
	int					currPoint;		// curr比赛积分
	int					total_board;	// 总局数
	int					total_win;		// 获胜局数
	int					level;			// 等级
	std::string			title;			// 头衔
	int					vipLevel;		// vip等级
	int 				charm;			// 魅力值
	std::string			sign;			// 个人签名
	int					rmb;	// 充值累计

	// connect to client
	Client              *client;
	
	// table info
	int 				ready_flag;
	int					ready;
	HoleCards			hole_cards;
	HoleCards			fight_cards;
	int					cur_money;
	int					cur_exp;
	int					cur_coin;
	int					cur_charm;
	int 				logout_type;
	int					cardtype;
	int					betnum;
	int					isrob;
	int					isWin;			// 胜负:0，输；1，胜
	int					isPreReady;
	time_t 				lastDayTaskDate; // last up day tasks time
/*	std::map<int, int>		p_bind_ach_tasks;
	std::map<int, int>		p_bind_day_tasks;*/
	std::map<int, int>		my_gifts; // key=gift_id, value=gift number

	int					broke_num;		// 当日累计破产次数
	time_t 				broke_time;		// 最后一次破产时间
	time_t 				last_talk_time; // last talk time
	int 				isNiceCard;
	int					hasHelp;		// 本局是否已经使用过提示
private:
    ev_timer                    _offline_timer;
    ev_tstamp                   _offline_timeout;
	
    ev_timer                    _ready_timer;
    ev_tstamp                   _ready_timeout;

public:
    Player();
    virtual ~Player();
    void set_client(Client *c);
	int init();
	void reset();
	int decr_online(int my_vid);
	int incr_online(int my_vid);
	int get_info();
	int incr_money(int type,int diff_money);
	int incr_coin();
	int incr_expr(int value);
	int incr_charm(int value);
	int incr_total_board(int vid, int value);
	int incr_total_win(int vid, int value);
    void start_offline_timer();
	void stop_offline_timer();
    static void offline_timeout(struct ev_loop *loop, ev_timer *w, int revents);
	void start_ready_timer();
	void stop_ready_timer();
	static void ready_timeout(struct ev_loop *loop, ev_timer *w, int revents);
	int up_activity_status(int ratio);

	int log_gift(int uid_give,int uid_received, int gift_id, int money, int charm);
	int incr_gifts(int gift_id); //收礼者保存礼物

	int get_my_gifts(); // 对 my_gifts 进行赋值

	int check_last_time(time_t lt);
	void up_broke_time();
	int check_talk_str(std::string instr,std::string &outstr,int type);
	int curr_time();

	// 获得头衔
	void getTitle();
	// 更新vip等级
	void up_vipLevel();
	// 更新玩家等级
	void up_playerLevel();
	int incr_broke_num();
	int incr_fight_point(int type, int diff_point,int base_money);
	void get_fight_point();
	void sendBroadCast(std::string msg);
private:

};

#endif
