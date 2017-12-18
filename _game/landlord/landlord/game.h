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
#include "matchInfo.h"
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
	std::string type;
	std::string msg;
} SysMsgInfo;

class Game
{
public:
	std::map<int, Table*>       three_tables;
	std::map<int, Table*>       two_tables;
	std::map<int, Table*>       one_tables;
	std::map<int, Table*>       zero_tables;
	std::map<int, Table*>       all_tables;
    std::map<int, Client*> 		fd_client;
	std::map<int, Player*>      offline_players;
	std::map<int, Player*>      online_players;
	std::map<int, Tasks*>		ach_tasks;
	std::map<int, Tasks*>		day_tasks;
	time_t 						lastUp_day_time;
    ev_timer                    speaker_timer;
    ev_tstamp                   speaker_timer_s;
	vector<Gifts> 				vgifts;
	std::vector<SysMsgInfo> 	broadcastList;      // 广播缓存列表
	int 						matchId;
	vector<int>					matchRiseLevel;	 	// 淘汰赛每阶段进阶人数
	ev_timer                    init_match_timer;
	ev_tstamp                   init_match_timer_s;
	std::map<std::string, MatchInfo*>	match_list;
	std::map<int, AwardInfo>	match_award;
	int broke_money_limit;      // 破产条件
	int broke_give_num_max;     // 破产次数
	int broke_give_to;    		// 破产赠送的金币

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
	
	int update_table(int tid);
	int send_error(Client *client, int cmd, int error_code);
	void dump_msg(std::string msg);
	void dump_game_info(char *tag);
	int check_skey(Client *client);
    int add_player(Client *client);
    int del_player(Player *player);
    int init_tasks_ach();
    int init_tasks_day();
    void check_tasks_day();
    static void speaker_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
    static void init_match_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	int init_gifts();
	void intellent_init_table(MatchInfo *mInfo);
	void intellent_next_table(std::map<int, Player*> players);
	void splitString(const std::string& s, std::vector<int>& v, const std::string& c);
	void start_next_match(MatchInfo *mInfo);
	void end_match(MatchInfo *mInfo);
private:
	int     init_table();
    int     init_accept();
	void 	init_config();
};

#endif
