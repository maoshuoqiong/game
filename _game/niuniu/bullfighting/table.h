#ifndef _TABLE_H_
#define _TABLE_H_

//#include <errno.h>

#include <ev.h>
#include <map>
#include <string>
#include <vector>

#include "libddz/card.h"
#include "libddz/card_find.h"
//#include "libddz/community_cards.h"
#include "libddz/deck.h"
#include "player.h"
#include "tasks.h"

//#include "tasks_type.h"


class Jpacket;

class Player;
class Client;

//闲家赢钱数据结构
typedef struct
{
    unsigned int win_money;
    Player *player;
    void clear(void)
    {
    	win_money = 0;
        player = NULL;
    }
} LeisureWin;

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
	no_rob = 0,
	one_rob,
	more_rob,
} Rob_Type;

typedef enum
{
	def = 0,	// 超时未准备
	net_err,
	money_less,
	change_table,
	self_logout,
	money_over,
	no_open,
	table_full,
	roomer_out
} Logout_Type;

typedef enum
{
	NEW_CARD = 0,
	FOLLOW_CARD,
} Playing_Action;

typedef enum
{
    S_READY = 0,
    S_ROB,
    S_BET,
	S_FIGHTING,
    S_END_GAME,
} State;


typedef struct
{
    std::string playerName;
	std::string msg;
	time_t createtime;
} Talk;

typedef enum
{
    AF_MONEY = 0,    	// 金币
    AF_COIN,			// 金叶子
} Agent_FLAG;

class Table
{
public:
    int							tid;			// table id
    int             			vid;
	int							zid;
    int             			min_money;		// enter table min money
    int             			max_money;		// enter table max money
	int							base_money;
	int							wait_time;
	int							ready_time;
    int             			cur_players;	// current table player num
	std::map<int, Player*>		players;		// current players map
	int							ready_players;	// 已准备人数
	int							bet_players;	// 已下注人数
	int							rob_players;	// 已抢庄人数
	int							fight_players;	// 已亮牌人数
	const static int			seatsNum = 5;
	Seat                        seats[seatsNum];
	int 						niceCardRatio;
	int 						niceCardRatioRobot;
	Deck 						deck;

	//
	State						state;
	int							keeper_seat; 	// 庄家seatid

	int							cur_card_type;
	Tasks						tasks;

    ev_timer                    preready_timer;	// 续桌Timer
    ev_tstamp                   preready_timer_stamp;	

	// int							cur_player;
    ev_timer                    rob_timer;
    ev_tstamp                   rob_timer_stamp;
	
    ev_timer                    bet_timer;
    ev_tstamp                   bet_timer_stamp;
	
    ev_timer                    fight_timer;
    ev_tstamp                   fight_timer_stamp;
	
    ev_timer                    noPerson_timer;	// 机器人加入Timer
    ev_tstamp                   noPerson_timer_stamp;

    std::vector<Talk>			talkList;
    std::vector<LeisureWin>     leisureWin;
    int 						roomerUid;			// 包房主人
public:
    Table();
    virtual ~Table();
	int init(int my_table_id, int my_vid, int my_zid, int my_min_money,
			int my_base_money,int my_niceCardRatio,int my_niceCardRatioRobot,int my_max_money);
	int add_player(Player *player);
	void unicast_join_table_succ(Player *player);
	int sit_down(Player *player);
	int del_player(Player *player);
	void stand_up(Player *player);
	void del_all_players();
	// 对牌桌内到所有人广播指令
    int broadcast(Player *player, const std::string &packet);
    // 对个人发送指令
    int unicast(Player *player, const std::string &packet);
    // 发送牌桌信息：0,广播;1,私发
	int table_info_broadcast(Player *player,int type);
	// 再来一局
	void handler_game_preready();
	int handler_game_ready(Player *player);
	// include end
	int random(int start, int end);
	void reset();
	void vector_to_json_array(std::vector<Card> &cards, Jpacket &packet, string key);
	void map_to_json_array(std::map<int, Card> &cards, Jpacket &packet, string key);
	void json_array_to_vector(std::vector<Card> &cards, Jpacket &packet, string key);
	int handler_main_action(Player *player,State s);
	// 处理玩家抢庄
	int handler_rob(Player *player, int action);
	// 处理玩家下注
	int	handler_bet(Player *player, int action);
	// 处理玩家亮牌
	int	handler_fight(Player *player, int action);
	// 通知进入抢庄环节
	int start_rob();
	// 通知进入下注环节
	int start_bet(int robType);
	// 通知进入亮牌环节
	int start_fight();
	// 确定庄家,返回抢庄类型：0，无人抢；1，一人抢；2，多人抢
	int set_keeper();
	// 计算下注范围
	void get_bet_range(Jpacket &packet, string key, Seat &keeper, Seat &curr,int ratio_limit);
	int cal_bet_range_base(Seat &keeper, Seat &curr,int ratio_limit);
	// 抢庄超时处理
	static void rob_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	// 下注超时处理
	static void bet_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	// 亮牌超时处理
	static void fight_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	// 超时无人入桌，唤醒机器人
	static void noPerson_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);
	// 超时未手动进入下一局
	static void preready_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents);

	int judge_winner();

	int game_end();
	void count_money();
	void map_to_json_array_spec(std::map<int, Card> &cards, Jpacket &packet, int index);
	int handler_chat(Player *player);
	int handler_face(Player *player);
	int handler_logout(Player *player);
	// 再来一局:0,wait;1,ready
	int handler_next_game(Player *player,int type);
	// 重连
	int handler_rebind(Player *player);
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

	int incr_day_total_board(int ts, int uid);
	int incr_day_win_board(int ts, int uid);
	// 等待机器人进入
	void wait_join_robot(int uid);
	void send_speaker_bc();
	// 检查是否可以开始
	void check_start_game();
	int check_player_status(Player *player);

	//send gifts
	int handler_send_gifts(Player *player);
	int send_gift_error(Player *player, int giftid, std::string msg);

	void check_free_give(Player *player);
	int handler_talk_list(Player *player);
	void add_talk(std::string name,std::string msg,int curr_t);

	void cal_task_award(Player *p,int winOrlose);
	int check_task_reach(int taskType,Player *p,int winOrlose);
	bool isRobot(int uid);
	void rep_blackword(std::string instr,std::string &outstr);
	int handler_help(Player *player);
	void up_priv_table_info(int ouid);
	void up_priv_table(Player *p);
private:
	static map<int,int> create_map()
	{
	  map<int,int> m;
	  m[CARD_TYPE_COW_ERROR] = 1;
	  m[CARD_TYPE_COW_NO] = 1;
	  m[CARD_TYPE_COW_ONE] = 1;
	  m[CARD_TYPE_COW_TWO] = 1;
	  m[CARD_TYPE_COW_THREE] = 1;
	  m[CARD_TYPE_COW_FOUR] = 1;
	  m[CARD_TYPE_COW_FIVE] = 1;
	  m[CARD_TYPE_COW_SIX] = 1;
	  m[CARD_TYPE_COW_SEVEN] = 1;
	  m[CARD_TYPE_COW_EIGHT] = 2;
	  m[CARD_TYPE_COW_NIGHT] = 2;
	  m[CARD_TYPE_COW_TEN] = 3;
	  m[CARD_TYPE_COW_WHN] = 4;
	  m[CARD_TYPE_COW_BOMB] = 5;
	  m[CARD_TYPE_COW_WXN] = 8;
	  return m;
	}
	static const map<int,int> typeRatio;

};


#endif
