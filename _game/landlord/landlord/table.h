#ifndef _TABLE_H_
#define _TABLE_H_

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
#include <vector>

#include <json/json.h>

#include <map>
#include <set>

#include "deck.h"
#include "card_find.h"
#include "jpacket.h"
#include "tasks.h"
#include "tasks_type.h"

class Player;
class Client;

typedef struct
{
    unsigned int seat_no;
	bool occupied;
    Player *player;
	
    void clear(void)
    {
        seat_no = 0;
		occupied = false;
        player = NULL;
    }
} Seat;

typedef enum
{
	ONE_RATIO = 1,
	TWO_RATIO,
	THREE_RATIO,
	ROB_LANDLORD,
	NO_CALL,
} Preplay_Action;
	
typedef enum
{
	NEW_CARD = 0,
	FOLLOW_CARD,
} Playing_Action;

typedef enum
{
    READY = 0,
    PREPLAY_ONE,
    PREPLAY_TWO,
	PLAYING,
    END_GAME,
} State;

typedef enum
{
    AF_MONEY = 0,    	// 金币
    AF_COIN,			// 金叶子
} Agent_FLAG;

class Table
{
public:
    int							tid;
    int							level;
    int             			vid;
	int							zid;
    int             			min_money;
	int							base_money;
	int							table_type;
	int							wait_time;
	int							ready_time;
    int             			cur_players;
	std::map<int, Player*>		players;
	int							ready_players;
	Seat                        seats[3];

	Deck 						deck;
	CommunityCards 				community_cards;

	//
	State						state;
	int							nocall_cnt;
	int							landlord_seat; // seat id
	int							landlord_seat_ori;
	std::set<int>				nocall;
	int							start_seat; // preplay and play state
	int							cur_seat; // preplay and play state
	int							cur_action;
	int							ratio;
	
	int							one_line;
	int							two_line;
	int							three_line;
	int							plane;
	int							bomb;
	int							rocket;
	int							spring;
	int							landlord_cnt;
	int							superFace;
	
	int							cur_card_type;
/*	int							task_type;
	int							task_id;
	int							task_card_type;
	int 						task_finish;*/  // 0:no finish,1:conform type,2:win and finish if need
	Tasks						tasks;

	vector<Card>				last_cards;
	int							last_playerId;
	vector<Card>				out_cards;
	int 						card_nums;
	CardFind 					card_find;
	
    ev_timer                    preready_timer;
    ev_tstamp                   preready_timer_stamp;	

	// int							cur_player;
    ev_timer                    preplay_timer;
    ev_tstamp                   preplay_timer_stamp;
	
    ev_timer                    play_timer;
    ev_tstamp                   play_timer_stamp;

    ev_timer                    robot_timer;
    ev_tstamp                   robot_timer_stamp;

    ev_timer                    rocket_timer;
    ev_tstamp                   rocket_timer_stamp;	
	
    ev_timer                    noPerson_timer;
    ev_tstamp                   noPerson_timer_stamp;
    int							base_point;
public:
    Table();
    virtual ~Table();
	int init(int my_table_id, int my_vid, int my_zid, int my_table_type, int my_min_money, int my_base_money);
	int add_player(Player *player);
	void unicast_join_table_succ(Player *player);
	int sit_down(Player *player);
	int del_player(Player *player);
	void stand_up(Player *player);
	void del_all_players();
    int broadcast(Player *player, const std::string &packet);
    int unicast(Player *player, const std::string &packet);
	int table_info_broadcast();
	static void preplay_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	void handler_game_preready();
	int handler_game_ready(Player *player);
	int start_game();
	int random(int start, int end);
	void gen_random_task();
	void reset();
	void vector_to_json_array(std::vector<Card> &cards, Jpacket &packet, string key);
	void map_to_json_array(std::map<int, Card> &cards, Jpacket &packet, string key);
	void json_array_to_vector(std::vector<Card> &cards, Jpacket &packet, string key);
	int next_seat(int pos);
	int next_seat_spec(int pos);
	int handler_preplay(Player *player);
	int handler_preplay_one(Player *player, int action);
	int	handler_preplay_two(Player *player, int action);
	int start_preplay_one();
	int start_preplay_two();
	int start_play();
	void setLandlord();
	static void play_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	static void robot_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	static void rocket_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	static void noPerson_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	int handler_play_card(Player *player);
	int handler_play_card_exec(Player *player, int card_type, int flag);
	void card_type_count(Player *player, int card_type);
	int start_next_player();
	int game_end();
	void count_money(Player *player);
	void map_to_json_array_spec(std::map<int, Card> &cards, Jpacket &packet, int index);
	static void preready_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	int handler_chat(Player *player);
	int handler_face(Player *player);
	int handler_logout(Player *player);
	int handler_rebind(Player *player);
	int handler_robot(Player *player);
	int incr_day_total_board(int ts, int uid);
	int incr_day_win_board(int ts, int uid);
	void wait_join_robot(int uid);
	void cal_task_award(Player *p,int winOrlose);
	void cal_task_condition(Player *player,map<string, int> &packet);
	int check_task_reach(Tasks *t,Player *p,int winOrlose);
	//send gifts
	int handler_send_gifts(Player *player);
	int send_gift_error(Player *player, int giftid, std::string msg);
	/**
	 * ts:time
	 * uid:user id
	 * flag:0-money,1-coin...
	 * action:0-ADD,1-SUB
	 * type:0-game,1-gift...
	 * curr_val:current value
	 * diff_val:change value
	 */
	int inset_flow_log(int ts, int uid, int flag, int action,string type, int curr_val, int diff_val);
	bool isRobot(int uid);
	void send_speaker_bc();
	void set_match_point(int curr_point);
	void check_free_give(Player *player);
private:
//	void getUrl(string user);
//	std::vector<std::string> split(std::string str,std::string pattern);
};

#endif
