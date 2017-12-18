#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <errno.h>

#include "landlord.h"
#include "log.h"
#include "proto.h"
#include "table.h"
#include "player.h"
#include "client.h"
#include "game.h"

extern Landlord landlord;
extern Log log;

Player::Player() :
_offline_timeout(180),
_ready_timeout(20)
{
    _offline_timer.data = this;
    ev_timer_init(&_offline_timer, Player::offline_timeout,
                    _offline_timeout, 0);
	
    _ready_timer.data = this;
    ev_timer_init(&_ready_timer, Player::ready_timeout,
                    _ready_timeout, _ready_timeout);
}

Player::~Player()
{
    ev_timer_stop(landlord.loop, &_offline_timer);
	ev_timer_stop(landlord.loop, &_ready_timer);

    if (client) client->player = NULL;
}

void Player::set_client(Client *c)
{
    client = c;
	uid = c->uid;
	index = uid % landlord.main_size;
	// maybe init by init_table in game.cc
	vid = c->vid;
	zid = c->zid;
    client->player = this;
    version = c->version;
}

int Player::init()
{
	// player information
	reset();
	int ret = landlord.main_rc[index]->command("hgetall hu:%d", uid);
	if (ret < 0)
	{
		log.debug("player init error, cache error.\n");
		return -1;
	}
	
	if (landlord.main_rc[index]->is_array_return_ok() < 0)
	{
		log.debug("player init error, data error.\n");
		return -1;
	}
	
	skey = landlord.main_rc[index]->get_value_as_string("skey");
	name = landlord.main_rc[index]->get_value_as_string("name");
	sex = landlord.main_rc[index]->get_value_as_int("sex");
	level = landlord.main_rc[index]->get_value_as_int("level");
	exp = landlord.main_rc[index]->get_value_as_int("exp");
	money = landlord.main_rc[index]->get_value_as_int("money");
	coin = landlord.main_rc[index]->get_value_as_int("coin");
	total_board = landlord.main_rc[index]->get_value_as_int("total_board");
	total_win = landlord.main_rc[index]->get_value_as_int("total_win");
	sign = landlord.main_rc[index]->get_value_as_string("sign");  //签名
	charm = landlord.main_rc[index]->get_value_as_int("charm");
	broke_time = landlord.main_rc[index]->get_value_as_int("broke_time");
	broke_num = landlord.main_rc[index]->get_value_as_int("broke_num");

//	point = landlord.main_rc[index]->get_value_as_int("point");
	point = 0;
	matchKey = landlord.main_rc[index]->get_value_as_string("matchKey");
	match_base_point = 0;
	if (landlord.conf["tables"]["max_money"].asInt() == 0)
	{
		if (money < landlord.conf["tables"]["min_money"].asInt())
		{
			log.debug("player[%d] money is not fit1.\n", uid);
			return -1;
		}
	}
	else
	{
		if (money < landlord.conf["tables"]["min_money"].asInt() ||
				money >= landlord.conf["tables"]["max_money"].asInt())
		{
			log.debug("player[%d] money is not fit2.\n", uid);
			return -1;
		}
	}
	// 初始化礼物
	get_my_gifts();
	// PEXT
	ret = landlord.main_rc[index]->command("hgetall hpe:%d", uid);
	lastDayTaskDate = landlord.main_rc[index]->get_value_as_int("lastDayTaskDate");
	int viped = landlord.main_rc[index]->get_value_as_int("vipenddate");
	avatar = landlord.main_rc[index]->get_value_as_int("avatar");

	vip = 0;
	time_t t = time(NULL);
	if(viped>t){
		vip = 1;
	}
//	log.debug("######lastDTD[%d][%d]\n",viped,vip);
	// table info
	tid = -1;
	ready = 0;
	
	return 0;
}

int Player::check_daytask()
{
	if(lastDayTaskDate==0){
		return 0;
	}
	time_t t = time(NULL);
	tm currentTime = {0};
	localtime_r(&t,&currentTime);
	tm lastTime = {0};
	localtime_r(&lastDayTaskDate,&lastTime);

//	log.debug("####check_daytask[%d %d %d][%d %d %d]\n",t,currentTime.tm_mon,currentTime.tm_mday,lastDayTaskDate,lastTime.tm_mon,lastTime.tm_mday);
	if(currentTime.tm_year == lastTime.tm_year && currentTime.tm_mon == lastTime.tm_mon
			&& currentTime.tm_mday == lastTime.tm_mday){
		return 1;
	}
	return 0;
}

void Player::reset()
{
	ready_flag = 0;
	ready = 0;
	role = 0;
	logout_type = OUT_DEF;
	time_cnt = 0;
	robot = 0;
	
	one_line = 0;
	two_line = 0;
	three_line = 0;
	plane = 0;
	bomb = 0;
	rocket = 0;

	stop_ready_timer();
	stop_offline_timer();
}

int Player::decr_online(int my_vid)
{
	int ret;
	ret = landlord.main_rc[index]->command("hincrby ro:%d online -1", my_vid);
	if (ret < 0)
	{
		log.debug("decr_online error.\n");
		return -1;
	}
	
	ret = landlord.main_rc[index]->command("hset hu:%d pos %d", uid, 0);
	if (ret < 0)
	{
		log.debug("decr_online error2.\n");
		return -1;
	}
	
	return 0;	
}

int Player::incr_online(int my_vid)
{
	int ret;
	ret = landlord.main_rc[index]->command("hincrby ro:%d online 1", my_vid);
	if (ret < 0)
	{
		log.debug("decr_online error1.\n");
		return -1;
	}
	
	ret = landlord.main_rc[index]->command("hset hu:%d pos %d", uid, my_vid);
	if (ret < 0)
	{
		log.debug("decr_online error2.\n");
		return -1;
	}
	
	return 0;	
}

int Player::get_info()
{
	int ret = landlord.main_rc[index]->command("hgetall hu:%d", uid);
	if (ret < 0)
	{
		log.debug("player init error2, cache error.\n");
		return -1;
	}
	
	if (landlord.main_rc[index]->is_array_return_ok() < 0)
	{
		log.debug("player init error2, data error.\n");
		return -1;
	}
	
	exp = landlord.main_rc[index]->get_value_as_int("exp");
	money = landlord.main_rc[index]->get_value_as_int("money");
	coin = landlord.main_rc[index]->get_value_as_int("coin");
	point = landlord.main_rc[index]->get_value_as_int("point");
	total_board = landlord.main_rc[index]->get_value_as_int("total_board");
	total_win = landlord.main_rc[index]->get_value_as_int("total_win");
//	log.debug("get_money player[%d] money[%d]\n", uid, money);
	return 0;
}

int Player::incr_money(int type)
{
	int ret;
	if (type == 0)
	{
		landlord.main_rc[index]->command("hincrby hactivity:%d actWinMonDay %d", uid, cur_money);
		landlord.main_rc[index]->command("hincrby hactivity:%d actWinMonTot %d", uid, cur_money);
		ret = landlord.main_rc[index]->command("hincrby hu:%d money %d", uid, cur_money);
	}
	else
	{
		landlord.main_rc[index]->command("hincrby hactivity:%d actWinMonDay -%d", uid, cur_money);
		landlord.main_rc[index]->command("hincrby hactivity:%d actWinMonTot -%d", uid, cur_money);
		ret = landlord.main_rc[index]->command("hincrby hu:%d money -%d", uid, cur_money);
	}
	
	if (ret < 0)
	{
		log.debug("incr_money error.\n");
		return -1;
	}
	
	money = landlord.main_rc[index]->reply->integer; //update the money.
	
	return 0;
}

int Player::incr_coin()
{
	if (cur_coin == 0)
	{
		return 0;
	}
	
	int ret = landlord.main_rc[index]->command("hincrby hu:%d coin %d", uid, cur_coin);
	if (ret < 0)
	{
		log.debug("incr_coin error.\n");
		return -1;
	}
	
	coin = landlord.main_rc[index]->reply->integer; //update the coin.
	
	return 0;
}

/*void Player::incr_point()
{
	if (cur_point == 0)
	{
		return;
	}

	int ret = landlord.main_rc[index]->command("hincrby hu:%d point %d", uid, cur_point);
	if (ret < 0)
	{
		log.debug("incr_point error.\n");
		return;
	}
	point = landlord.main_rc[index]->reply->integer; //update the coin.
	return;
}*/

int Player::incr_expr(int value)
{
	int ret;
	ret = landlord.main_rc[index]->command("hincrby hu:%d exp %d", uid, value);
	if (ret < 0)
	{
		log.debug("incr_expr error.\n");
		return -1;
	}
	cur_exp = value;
	exp = landlord.main_rc[index]->reply->integer; //update the expr.
	
	return 0;
}

int Player::incr_total_board(int vid, int value)
{
	int ret;
	ret = landlord.main_rc[index]->command("hincrby hu:%d total_board %d", uid, value);
	if (ret < 0)
	{
		log.debug("u incr_total_board error.\n");
		return -1;
	}
	
	total_board = landlord.main_rc[index]->reply->integer; //update the total_board.
	
	ret = landlord.main_rc[index]->command("hincrby uc:%d t%d %d", uid, vid, value);
	if (ret < 0)
	{
		log.debug("uc incr_total_board error.\n");
		return -1;
	}
	
	return 0;
}

int Player::incr_total_win(int vid, int value)
{
	int ret;
	ret = landlord.main_rc[index]->command("hincrby hu:%d total_win %d", uid, value);
	if (ret < 0)
	{
		log.debug("u incr_total_win error.\n");
		return -1;
	}
	
	total_win = landlord.main_rc[index]->reply->integer; //update the total_win.
	
	ret = landlord.main_rc[index]->command("hincrby uc:%d w%d %d", uid, vid, value);
	if (ret < 0)
	{
		log.debug("uc incr_total_win error.\n");
		return -1;
	}
	
	return 0;
}

int Player::up_activity_status(int ratio)
{
	int ret = landlord.main_rc[index]->command("hgetall hactivity:%d", uid);
	if (ret < 0)
	{
		log.debug("player ext init error, cache error.\n");
		return -1;
	}

	if (landlord.main_rc[index]->is_array_return_ok() < 0)
	{
		log.debug("player ext init error, data error.\n");
		return -1;
	}

	int actBoardWin = landlord.main_rc[index]->get_value_as_int("actBoardWin");
	int actRatio = landlord.main_rc[index]->get_value_as_int("actRatio");
	int actWinMoney = landlord.main_rc[index]->get_value_as_int("actWinMoney");

	actBoardWin += 1;
	actRatio = ratio>actRatio?ratio:actRatio;
	actWinMoney = cur_money>actWinMoney?cur_money:actWinMoney;
	landlord.main_rc[index]->command("hmset hactivity:%d actRatio %d actBoardWin %d actWinMoney %d", uid,actRatio,actBoardWin,actWinMoney);
	return 0;
}

void Player::start_offline_timer()
{
    ev_timer_start(landlord.loop, &_offline_timer);
}

void Player::stop_offline_timer()
{
    ev_timer_stop(landlord.loop, &_offline_timer);
}

void Player::offline_timeout(struct ev_loop *loop, ev_timer *w, int revents)
{
    /* player logout
     * remove from offline table */
	Player* self = (Player*)w->data;
    landlord.game->del_player(self);
}

void Player::start_ready_timer()
{
//	log.debug("uid[%d] ready_flag[%d]\n", uid, ready_flag);
	if (ready_flag == 1)
	{
		return;
	}
	ready_flag = 1;
	ev_timer_again(landlord.loop, &_ready_timer);
}

void Player::stop_ready_timer()
{
	ready_flag = 0;
	ev_timer_stop(landlord.loop, &_ready_timer);
}

void Player::ready_timeout(struct ev_loop *loop, ev_timer *w, int revents)
{
	Player* self = (Player*)w->data;
	self->ready_flag = 1;
	ev_timer_stop(landlord.loop, &self->_ready_timer);
	landlord.game->del_player(self);
}

int Player::curr_time() {
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return tv.tv_sec;
}

int Player::incr_gifts(int gift_id) {
	int ret;
	ret = landlord.main_rc[index]->command("hincrby ugift:%d %d 1", uid,
			gift_id);
	if (ret < 0) {
		log.debug("incr_gifts uid[%d] , gift_id[%d] error.\n", uid, gift_id);
		return -1;
	}

	//log.debug( "incr_gifts: [%d]  ....\n", gift_id);

	int gnum = landlord.main_rc[index]->reply->integer;

	map<int, int>::iterator it;
	for (it = my_gifts.begin(); it != my_gifts.end(); it++) {
		int key_gid = (*it).first;
		//int num  = (*it).second;
		if (key_gid == gift_id) {
			my_gifts[key_gid] = gnum; //更新当前礼物的数量
			break;
		}
	}

	return 0;
}

int Player::get_my_gifts() {
	if (my_gifts.size() <= 0) {
		for (unsigned int i = 0; i < landlord.game->vgifts.size(); i++) {
			my_gifts[landlord.game->vgifts[i].gift_id] = 0;
		}
	}

	//获取用户礼物
	int ret = landlord.main_rc[index]->command("hgetall ugift:%d", uid);
	if (ret < 0) {
		log.debug("ugift:%d has no gifts\n", uid);
	} else {
		int retarr = landlord.main_rc[index]->is_array_return_ok();
		if (retarr >= 0) {
			//有效
			my_gifts[1] = landlord.main_rc[index]->get_value_as_int("1");
			my_gifts[2] = landlord.main_rc[index]->get_value_as_int("2");
			my_gifts[3] = landlord.main_rc[index]->get_value_as_int("3");
			my_gifts[4] = landlord.main_rc[index]->get_value_as_int("4");
			my_gifts[5] = landlord.main_rc[index]->get_value_as_int("5");

			//log.debug("get_my_gifts[%d],my_gifts[1]=%d \n", uid, my_gifts[1]);
		}
		//log.debug("get_my_gifts[%d],is_array_return_ok=%d \n", uid, retarr);
	}

	//log.debug("get_my_gifts[%d]=[%d %d %d %d %d]\n", uid, my_gifts[1],my_gifts[2],my_gifts[3],my_gifts[4],my_gifts[5]);

	return 0;
}


int Player::incr_charm(int value) {
	int max_charm = 10000;
	int today_charm = 0;
	int result = landlord.main_rc[index]->command(" hget ugift:%d tm" , uid);

	if (result >= 0 ) {
		int theday = 0;
		if (landlord.main_rc[index]->reply->str ) {
			std::string tm = landlord.main_rc[index]->reply->str;
			theday = atoi(tm.c_str()) ;
		}
		int day = check_last_time(theday);
		//log.debug("charm:   day=%d ; theday=%d  \n", day, theday);
		if (day == 1) {
			//是今天
			int rt = landlord.main_rc[index]->command("hget ugift:%d charm", uid);
			if (rt >=0 ) {
				if (landlord.main_rc[index]->reply->str ) {
					std::string tc = landlord.main_rc[index]->reply->str;
					today_charm = atoi(tc.c_str()) ;
				}
				if (today_charm >= max_charm) {
					value = 0;
				}
				else {
					if (today_charm + value > max_charm) {
						value = max_charm - today_charm;
					}
				}
				//log.debug("charm: todaycharm=%d  ; value=%d  \n", today_charm, value);
			}
		}
		else {
			landlord.main_rc[index]->command("hset ugift:%d charm %d", uid, 0);
		}
	}
	else {
		landlord.main_rc[index]->command("hset ugift:%d charm %d", uid, 0);
	}

	if (value <= 0) {
		return -1;
	}

	int ret = landlord.main_rc[index]->command("hincrby hu:%d charm %d", uid, value);
	if (ret < 0) {
		log.debug("incr_charm error.\n");
		return -1;
	}
	charm = landlord.main_rc[index]->reply->integer; //update the charm.

	landlord.main_rc[index]->command("hincrby ugift:%d charm %d", uid, value);
	landlord.main_rc[index]->command("hset ugift:%d tm %d", uid, time(NULL));
	return 0;
}

void Player::up_broke_time() {
	broke_time = curr_time();
	broke_num++;
//	log.debug("up_broke_time[%d][%d]\n",broke_num,broke_time);
	landlord.main_rc[index]->command("hmset hu:%d broke_num %d broke_time %d",
			uid, broke_num, broke_time);
}

int Player::incr_broke_num() {
	if (landlord.main_rc[index]->command("hincrby uc:%d brokeGet %d", uid, 1) < 0) {
		log.debug("uc incr_broke_num error.\n");
		return -1;
	}
	return 0;
}

int Player::check_last_time(time_t lt) {
	if (lt <= 0) {
		return 0;
	}
	time_t t = time(NULL);
	tm currentTime = { 0 };
	localtime_r(&t, &currentTime);
	tm lastTime = { 0 };
	localtime_r(&lt, &lastTime);

//	log.debug("####check_last_time[%d %d %d][%d %d %d]\n",t,currentTime.tm_mon,currentTime.tm_mday,lt,lastTime.tm_mon,lastTime.tm_mday);
	if (currentTime.tm_year == lastTime.tm_year
			&& currentTime.tm_mon == lastTime.tm_mon
			&& currentTime.tm_mday == lastTime.tm_mday) {
		return 1;
	}
	return 0;
}

