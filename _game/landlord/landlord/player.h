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
	FARMER = 0,
	LANDLORD,
} Player_Role;
	
typedef enum
{
	ADD = 0,
	SUB,	
} update_action;

typedef enum
{
	M_WAITING = 0,
	M_PLAYING,
} match_status;

typedef enum
{
	OUT_DEF = 0,
	OUT_MONEY,
	OUT_SELF,
	OUT_NET,
    OUT_MATCH,
} logout_type;

class Player
{		
public:
	int 				index;
	// table router information
	int					vid;
	int					zid;
    int					tid;
	int					seatid;
	std::string			version;
	// player information
    int                 uid;
	std::string			skey;
	std::string			name;
	int					sex;
	int					vip;
	int					avatar;
	int					level;
	int					exp;
	int					money;
	int					coin;
	int					total_board;
	int					total_win;
	// connect to client
	Client              *client;
	
	// table info
	int 				ready_flag;
	int					ready;
	int					role; // 1 landlord 0 farmer
	HoleCards			hole_cards;
	int					cur_money;
	int					cur_exp;
	int					cur_coin;
	int 				logout_type;
	int					time_cnt;
	int					robot;
	
	int					one_line;
	int					two_line;
	int					three_line;
	int					plane;
	int					bomb;
	int					rocket;
	
	time_t 				lastDayTaskDate; // last up day tasks time
	std::map<int, int>		my_gifts; // key=gift_id, value=gift number
	int 				charm;			// 魅力值
	std::string			sign;			// 个人签名
	int					point;
//	int					cur_point;
	std::string			matchKey;
	int					match_table_rank;	// 当前桌排名1/2/3
	int					match_total_rank;	// 比赛排名
	int					match_base_point;	// 当前比赛底分
	int					match_status;		// 比赛状态0等待，1打牌中
	int					match_round;		// 淘汰赛每轮的场次，一轮2场
	int					broke_num;		// 当日累计破产次数
	time_t 				broke_time;		// 最后一次破产时间
/*	std::map<int, int>		p_bind_ach_tasks;
	std::map<int, int>		p_bind_day_tasks;*/
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
	int incr_money(int type);
	int incr_coin();
	int incr_expr(int value);
	int incr_total_board(int vid, int value);
	int incr_total_win(int vid, int value);
	int check_daytask();
    void start_offline_timer();
	void stop_offline_timer();
    static void offline_timeout(struct ev_loop *loop, ev_timer *w, int revents);
	void start_ready_timer();
	void stop_ready_timer();
	static void ready_timeout(struct ev_loop *loop, ev_timer *w, int revents);
	int up_activity_status(int ratio);

	int incr_gifts(int gift_id); //收礼者保存礼物

	int get_my_gifts(); // 对 my_gifts 进行赋值
	int curr_time();
	int incr_charm(int value);
	int check_last_time(time_t lt);
//	void incr_point();
	void up_broke_time();
	int incr_broke_num();
private:

};

#endif
