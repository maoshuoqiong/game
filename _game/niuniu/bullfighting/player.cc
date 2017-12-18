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

#include "bullfighting.h"
#include "log.h"
#include "proto.h"
#include "table.h"
#include "player.h"
#include "client.h"
#include "game.h"

extern Bullfighting landlord;
extern Log log;

Player::Player() :
		_offline_timeout(180), _ready_timeout(10) {
	_offline_timer.data = this;
	ev_timer_init(&_offline_timer, Player::offline_timeout, _offline_timeout,
			0);

	_ready_timer.data = this;
	ev_timer_init(&_ready_timer, Player::ready_timeout, _ready_timeout,
			_ready_timeout);
}

Player::~Player() {
	ev_timer_stop(landlord.loop, &_offline_timer);
	ev_timer_stop(landlord.loop, &_ready_timer);

	if (client)
		client->player = NULL;
}

void Player::set_client(Client *c) {
	client = c;
	uid = c->uid;
	index = uid % landlord.main_size;
	// maybe init by init_table in game.cc
	vid = c->vid;
	client->player = this;
	version = c->version;
}

int Player::init() {
	reset();
	int ret = landlord.main_rc[index]->command("hgetall hu:%d", uid);
	if (ret < 0) {
		log.debug("player init error, cache error.\n");
		return -1;
	}

	if (landlord.main_rc[index]->is_array_return_ok() < 0) {
		log.debug("player init error, data error.\n");
		return -1;
	}

	skey = landlord.main_rc[index]->get_value_as_string("skey");
	name = landlord.main_rc[index]->get_value_as_string("name");
	sex = landlord.main_rc[index]->get_value_as_int("sex");
	money = landlord.main_rc[index]->get_value_as_int("money");
	coin = landlord.main_rc[index]->get_value_as_int("coin");
	total_board = landlord.main_rc[index]->get_value_as_int("total_board");
	total_win = landlord.main_rc[index]->get_value_as_int("total_win");
	exp = landlord.main_rc[index]->get_value_as_int("exp");
	level = landlord.main_rc[index]->get_value_as_int("level");
	level = level <= 0 ? 1 : level;
	sign = landlord.main_rc[index]->get_value_as_string("sign");  //签名
	charm = landlord.main_rc[index]->get_value_as_int("charm");

	broke_time = landlord.main_rc[index]->get_value_as_int("broke_time");
	broke_num = landlord.main_rc[index]->get_value_as_int("broke_num");
	vipLevel = landlord.main_rc[index]->get_value_as_int("vipLevel");
	rmb = landlord.main_rc[index]->get_value_as_int("rmb");

	lastDayTaskDate = landlord.main_rc[index]->get_value_as_int(
			"lastDayTaskDate");
	avatar = landlord.main_rc[index]->get_value_as_int("headtime");

	if(landlord.game->game_type != 2){
		if (landlord.conf["tables"]["max_money"].asInt() == 0) {
			if (money < landlord.conf["tables"]["min_money"].asInt()) {
				log.debug("player[%d] money is not fit1.\n", uid);
				return -1;
			}
		} else {
			if (money < landlord.conf["tables"]["min_money"].asInt()
					|| money >= landlord.conf["tables"]["max_money"].asInt()) {
				log.debug("player[%d] money is not fit2.\n", uid);
				return -1;
			}
		}
	}
	//
	get_fight_point();
	//头衔
	getTitle();

	// 初始化礼物
	get_my_gifts();

	last_talk_time = 0;
	time_t t = time(NULL);
	tid = -1;
	ready = 0;

	return 0;
}

void Player::getTitle() {
	unsigned int tsize = landlord.game->titleList.size();
	for (unsigned int i = 0; i < tsize; i++) {
		if ((landlord.game->titleList[i].maxMoney > money
				|| landlord.game->titleList[i].maxMoney == 0)
				&& landlord.game->titleList[i].minMoney <= money) {
//			log.debug("######tit[%d][%d][%d][%s]\n",landlord.game->titleList[i].minMoney,landlord.game->titleList[i].maxMoney,money,title.c_str());
			title = landlord.game->titleList[i].title;
			break;
		}
	}
}

void Player::reset() {
//	log.debug("reset player[%d]\n",uid);
	ready_flag = 0;
	ready = 0;
	logout_type = def;
	isrob = -1;
	betnum = 0;
	hole_cards.clear();
	fight_cards.clear();
	cur_money = 0;
	cur_exp = 0;
	cur_coin = 0;
	cur_charm = 0;
	cardtype = 0;
	isWin = 0;
	isPreReady = 0;
	hasHelp = 0;
	stop_ready_timer();
	stop_offline_timer();
}

int Player::decr_online(int my_vid) {
	int ret;
	ret = landlord.main_rc[index]->command("hincrby ro:%d online -1", my_vid);
	if (ret < 0) {
		log.debug("decr_online error.\n");
		return -1;
	}

	ret = landlord.main_rc[index]->command("hset hu:%d pos %d", uid, 0);
	if (ret < 0) {
		log.debug("decr_online error2.\n");
		return -1;
	}

	return 0;
}

int Player::incr_online(int my_vid) {
	int ret;
	ret = landlord.main_rc[index]->command("hincrby ro:%d online 1", my_vid);
	if (ret < 0) {
		log.debug("decr_online error1.\n");
		return -1;
	}

	ret = landlord.main_rc[index]->command("hset hu:%d pos %d", uid, my_vid);
	if (ret < 0) {
		log.debug("decr_online error2.\n");
		return -1;
	}

	return 0;
}

int Player::get_info() {
	int ret = landlord.main_rc[index]->command("hgetall hu:%d", uid);
	if (ret < 0) {
		log.debug("player init error2, cache error.\n");
		return -1;
	}

	if (landlord.main_rc[index]->is_array_return_ok() < 0) {
		log.debug("player init error2, data error.\n");
		return -1;
	}

	exp = landlord.main_rc[index]->get_value_as_int("exp");
//	cooldou = landlord.main_rc[index]->get_value_as_int("cooldou");
	money = landlord.main_rc[index]->get_value_as_int("money");
	coin = landlord.main_rc[index]->get_value_as_int("coin");
	total_board = landlord.main_rc[index]->get_value_as_int("total_board");
	total_win = landlord.main_rc[index]->get_value_as_int("total_win");
//	log.debug("get_money player[%d] money[%d]\n", uid, money);
	return 0;
}

int Player::incr_money(int type, int diff_money) {
	int ret;
	if (type == 0) {
		ret = landlord.main_rc[index]->command("hincrby hu:%d money %d", uid,
				diff_money);
	} else {
		ret = landlord.main_rc[index]->command("hincrby hu:%d money -%d", uid,
				diff_money);
	}

	if(diff_money > 500000 && type == 0){
		char moneyStr[20];
		sprintf(moneyStr, "%d", diff_money);
		string venueName = "牛比轰轰";
		if(tid == 4){
			venueName = "牛气冲天";
		}else if(tid == 5){
			venueName = "牛炸天";
		}else if(tid == 6){
			venueName = "牛魔王";
		}
		string msg = name+"大杀四方,瞬间在"+venueName+"场赢得了"+moneyStr+"金币";
		sendBroadCast(msg);
	}
	if (ret < 0) {
		log.debug("incr_money error.\n");
		return -1;
	}

	money = landlord.main_rc[index]->reply->integer; //update the money.
	if (money < 0) {
		ret = landlord.main_rc[index]->command("hset hu:%d money %d", uid, 0);
		money = 0;
	}
	//头衔
	getTitle();
	landlord.main_rc[index]->command("hset hu:%d title %s", uid, title.c_str());

	return 0;
}

int Player::incr_coin() {
	if (cur_coin == 0) {
		return 0;
	}

	int ret = landlord.main_rc[index]->command("hincrby hu:%d coin %d", uid,
			cur_coin);
	if (ret < 0) {
		log.debug("incr_coin error.\n");
		return -1;
	}

	coin = landlord.main_rc[index]->reply->integer; //update the coin.

	return 0;
}
void Player::sendBroadCast(std::string msg) {
	Json::Value m,r;
	m["type"] = "1";
	timeval tv;
	gettimeofday(&tv, NULL);
	int sec = tv.tv_sec;
	m["time"] = sec;
	m["msg"] = msg;
//	log.debug("BB000[%s]\n",m.toStyledString().c_str());
	Json::Value val;
	Json::Reader reader;
	int ret = landlord.cache_rc->command("get sysmess");
	if (ret < 0) {
		log.error("speaker init error, cache error.\n");
		return;
	}
	r.append(m);
	if (landlord.cache_rc->reply->str != NULL) {
//		log.debug("BB111[%s]\n",landlord.cache_rc->reply->str);
		if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
			log.error("speaker parse error, date error.\n");
			return;
		}
		int vs = val.size();
		if(vs>0){
			for (unsigned int i = 0; i < vs; i++) {
				if(i>=10){
					break;
				}
				r.append(val[i]);
			}
		}
	}

//	log.debug("BB222[%s]\n",r.toStyledString().c_str());
	landlord.cache_rc->command("set sysmess %s",r.toStyledString().c_str());
//	log.debug("BB333\n");
}

int Player::incr_fight_point(int type, int diff_point,int base_money) {
	int addPoint = 2;
	if(type==ADD){
		addPoint = diff_point/1000+3;
		char moneyStr[20];
		sprintf(moneyStr, "%d", diff_point);
		if(diff_point>=300000 && diff_point<400000){
			string msg = name+"人品爆棚,瞬间在比赛场赢得了"+moneyStr+"金币";
			sendBroadCast(msg);
		}else if(diff_point>=400000 && diff_point<600000){
			string msg = name+"大杀四方,瞬间在比赛场赢得了"+moneyStr+"金币";
			sendBroadCast(msg);
		}else if(diff_point>=600000){
			string msg = name+"技艺超群,瞬间在比赛场赢得了"+moneyStr+"金币";
			sendBroadCast(msg);
		}
	}
	int ret = landlord.main_rc[index]->command("hincrby hpe:%d dayPoint %d", uid,addPoint);
	if (ret < 0) {
		log.debug("incr_coin error.\n");
		return -1;
	}

	ret = landlord.main_rc[index]->command("hincrby hpe:%d totalPoint %d", uid,addPoint);
	if (ret < 0) {
		log.debug("incr_coin error.\n");
		return -1;
	}

	totalPoint = landlord.main_rc[index]->reply->integer; //update the coin.
	currPoint = addPoint;
	log.debug("incr_fight_point[%d][%d].\n",totalPoint,currPoint);
	return 0;
}

int Player::incr_expr(int value) {
	int ret;
	ret = landlord.main_rc[index]->command("hincrby hu:%d exp %d", uid, value);
	if (ret < 0) {
		log.debug("incr_expr error.\n");
		return -1;
	}
	cur_exp = value;
	exp = landlord.main_rc[index]->reply->integer; //update the expr.
	if (exp > landlord.game->up_vip_min_exp) {
		up_vipLevel();
	}
	up_playerLevel();
	return 0;
}

void Player::up_playerLevel() {
	if (exp >= landlord.game->levelList[level].minExp
			&& (exp <= landlord.game->levelList[level].maxExp
					|| landlord.game->levelList[level].maxExp == 0)) {
/*		log.debug("\nzzzaaa[%d]levle0[%d][%d][%d][%d]\n", uid, level, exp,
				landlord.game->levelList[level].minExp,
				landlord.game->levelList[level].maxExp);*/
		return;
	}
	int size = landlord.game->levelList.size();
	int diff = 1;
	if (exp < landlord.game->levelList[level].minExp) {
		diff = -1;
	}
	int tmpLevel = level + diff;

	//log.debug("\nzzzcccccc[%d]levle1[%d][%d][%d]\n", uid, level, tmpLevel, exp);

	for (int i = 0; i < size; i++) {
		if (tmpLevel < 1) {
			return;
		}
		if (tmpLevel <= size && exp >= landlord.game->levelList[tmpLevel].minExp
				&& (exp <= landlord.game->levelList[tmpLevel].maxExp
						|| landlord.game->levelList[tmpLevel].maxExp == 0)) {

			landlord.main_rc[index]->command("hset hu:%d level %d", uid,
					tmpLevel);
			level = tmpLevel;
			//log.debug("\nuplevle[%d][%d][%d]\n", uid, exp,level);
			return;
		}
		tmpLevel += diff;
	}
}

void Player::up_vipLevel() {
	/*unsigned int tsize = landlord.game->vipList.size();
	for (unsigned int i = 0; i < tsize; i++) {
		if (exp >= landlord.game->vipList[i].min_exp
				&& rmb > landlord.game->vipList[i].min_recharge) {
			if (vipLevel != landlord.game->vipList[i].level) {
				landlord.main_rc[index]->command("hset hu:%d vipLevel %d", uid,
						landlord.game->vipList[i].level);
				vipLevel = landlord.game->vipList[i].level;
			}
			return;
		}
	}*/
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
	cur_charm = value;
	charm = landlord.main_rc[index]->reply->integer; //update the charm.

	landlord.main_rc[index]->command("hincrby ugift:%d charm %d", uid, value);
	landlord.main_rc[index]->command("hset ugift:%d tm %d", uid, time(NULL));
	return 0;
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

void Player::get_fight_point() {
	int ret = landlord.main_rc[index]->command("hgetall hpe:%d", uid);
	totalPoint = 0;
	if (ret < 0) {
		log.debug("get_fight_point init error, cache error.\n");
		return;
	}

	if (landlord.main_rc[index]->is_array_return_ok() < 0) {
		log.debug("get_fight_point init error, data error.\n");
		return;
	}
//	landlord.main_rc[index]->dump_elements();
	totalPoint = landlord.main_rc[index]->get_value_as_int("totalPoint");
	currPoint = 0;
	log.debug("get_fight_point[%d][%d].\n",totalPoint,currPoint);
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

int Player::log_gift(int uid_give, int uid_received, int gift_id, int money,
		int charm) {

	//landlord.main_rc[index]->command("hmset hloggift:%d uid_give %d uid_received %d gift_id %d money %d charm %d", uid_give, uid_received, actRatio,actBoardWin,actWinMoney);

	return 0;
}

int Player::incr_total_board(int vid, int value) {
	int ret;
	ret = landlord.main_rc[index]->command("hincrby hu:%d total_board %d", uid,
			value);
	if (ret < 0) {
		log.debug("u incr_total_board error.\n");
		return -1;
	}

	total_board = landlord.main_rc[index]->reply->integer; //update the total_board.

	ret = landlord.main_rc[index]->command("hincrby uc:%d t%d %d", uid, vid,
			value);
	if (ret < 0) {
		log.debug("uc incr_total_board error.\n");
		return -1;
	}

	return 0;
}

int Player::incr_broke_num() {
	if (landlord.main_rc[index]->command("hincrby uc:%d brokeGet %d", uid, 1) < 0) {
		log.debug("uc incr_broke_num error.\n");
		return -1;
	}
	return 0;
}

int Player::incr_total_win(int vid, int value) {
	int ret;
	ret = landlord.main_rc[index]->command("hincrby hu:%d total_win %d", uid,
			value);
	if (ret < 0) {
		log.debug("u incr_total_win error.\n");
		return -1;
	}

	total_win = landlord.main_rc[index]->reply->integer; //update the total_win.

	ret = landlord.main_rc[index]->command("hincrby uc:%d w%d %d", uid, vid,
			value);
	if (ret < 0) {
		log.debug("uc incr_total_win error.\n");
		return -1;
	}

	return 0;
}

int Player::up_activity_status(int ratio) {
	int ret = landlord.main_rc[index]->command("hgetall hactivity:%d", uid);
	if (ret < 0) {
		log.debug("player ext init error, cache error.\n");
		return -1;
	}

	if (landlord.main_rc[index]->is_array_return_ok() < 0) {
		log.debug("player ext init error, data error.\n");
		return -1;
	}

	int actBoardWin = landlord.main_rc[index]->get_value_as_int("actBoardWin");
	int actRatio = landlord.main_rc[index]->get_value_as_int("actRatio");
	int actWinMoney = landlord.main_rc[index]->get_value_as_int("actWinMoney");

	actBoardWin += 1;
	actRatio = ratio > actRatio ? ratio : actRatio;
	actWinMoney = cur_money > actWinMoney ? cur_money : actWinMoney;
	landlord.main_rc[index]->command(
			"hmset hactivity:%d actRatio %d actBoardWin %d actWinMoney %d", uid,
			actRatio, actBoardWin, actWinMoney);
	return 0;
}

void Player::start_offline_timer() {
	ev_timer_start(landlord.loop, &_offline_timer);
}

void Player::stop_offline_timer() {
	ev_timer_stop(landlord.loop, &_offline_timer);
}

void Player::offline_timeout(struct ev_loop *loop, ev_timer *w, int revents) {
	/* player logout
	 * remove from offline table */
	Player* self = (Player*) w->data;
	self->logout_type = def;
	landlord.game->del_player(self);
}

void Player::start_ready_timer() {
//	log.debug("uid[%d] ready_flag[%d]\n", uid, ready_flag);
	if (ready_flag == 1) {
		return;
	}
	ready_flag = 1;
	ev_timer_again(landlord.loop, &_ready_timer);
}

void Player::stop_ready_timer() {
	ready_flag = 0;
	ev_timer_stop(landlord.loop, &_ready_timer);
}

void Player::ready_timeout(struct ev_loop *loop, ev_timer *w, int revents) {
	Player* self = (Player*) w->data;
	self->ready_flag = 1;
	ev_timer_stop(landlord.loop, &self->_ready_timer);
	self->logout_type = def;
	landlord.game->del_player(self);
}

void Player::up_broke_time() {
	broke_time = curr_time();
	broke_num++;
//	log.debug("up_broke_time[%d][%d]\n",broke_num,broke_time);
	landlord.main_rc[index]->command("hmset hu:%d broke_num %d broke_time %d",
			uid, broke_num, broke_time);
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

int Player::curr_time() {
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return tv.tv_sec;
}

int Player::check_talk_str(std::string instr, std::string &outstr, int type) {
/*	if (money < landlord.game->talk_need_money) {
		return -1;
	}*/
	int sec = curr_time();
	if (type == -1 && last_talk_time > 0
			&& (sec - last_talk_time) < landlord.game->talk_time_diff) {
		return -2;
	}
/*	if (landlord.game->talk_need_money > 0) {
		incr_money(SUB, landlord.game->talk_need_money);
	}*/
//	if (instr.length() > landlord.game->talk_str_len && type == -1) {
//		outstr = instr.substr(0, landlord.game->talk_str_len);
//	} else {
		outstr = instr;
//	}
	last_talk_time = sec;
	return 0;
}
