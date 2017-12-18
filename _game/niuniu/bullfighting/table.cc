#include "table.h"

#include <hiredis/hiredis.h>
#include <json/value.h>
#include <json/writer.h>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <utility>

#include "bullfighting.h"
#include "client.h"
#include "game.h"
#include "gifts.h"
#include "jpacket.h"
#include "libddz/hole_cards.h"
#include "libddz/tasks_type.h"
#include "log.h"
#include "log_agent.h"
#include "proto.h"
#include "redis_client.h"

extern Bullfighting landlord;
extern Log log;

Table::Table() :
		preready_timer_stamp(12), rob_timer_stamp(18), bet_timer_stamp(13), fight_timer_stamp(
				25), noPerson_timer_stamp(2) {
	// next game timer
	preready_timer.data = this;
	ev_timer_init(&preready_timer, Table::preready_timer_cb,
			preready_timer_stamp, preready_timer_stamp);

	rob_timer.data = this;
	ev_timer_init(&rob_timer, Table::rob_timer_cb, rob_timer_stamp,
			rob_timer_stamp);

	bet_timer.data = this;
	ev_timer_init(&bet_timer, Table::bet_timer_cb, bet_timer_stamp,
			bet_timer_stamp);

	fight_timer.data = this;
	ev_timer_init(&fight_timer, Table::fight_timer_cb, fight_timer_stamp,
			fight_timer_stamp);

	noPerson_timer.data = this;
	ev_timer_init(&noPerson_timer, Table::noPerson_timer_cb,
			noPerson_timer_stamp, noPerson_timer_stamp);
}

Table::~Table() {
	ev_timer_stop(landlord.loop, &preready_timer);
	ev_timer_stop(landlord.loop, &fight_timer);
	ev_timer_stop(landlord.loop, &rob_timer);
	ev_timer_stop(landlord.loop, &bet_timer);
	ev_timer_stop(landlord.loop, &noPerson_timer);
}

int Table::init(int my_table_id, int my_vid, int my_zid, int my_min_money,
		int my_base_money,int my_niceCardRatio,int my_niceCardRatioRobot,int my_max_money) {
	// log.debug("begin to init table [%d]\n", table_id);
	tid = my_table_id;
	vid = my_vid;
	zid = my_zid;
	min_money = my_min_money;
	max_money = my_max_money;
	base_money = my_base_money;
	// log.debug("tables type[%d] table_type[%d] min_money[%d] base_money[%d]\n", type, table_type, min_money, base_money);

	wait_time = 20;
	ready_time = 20;
	cur_players = 0;
	players.clear();
	ready_players = 0;
	niceCardRatio = my_niceCardRatio;
	niceCardRatioRobot = my_niceCardRatioRobot;
	for (int i = 0; i < seatsNum; i++) {
		seats[i].seat_no = i;
		seats[i].occupied = false;
		seats[i].player = NULL;
	}
	if(landlord.game->game_type==2){
		roomerUid = 0;
	}
	state = S_READY;
	return 0;
}

void Table::up_priv_table_info(int ouid){
	roomerUid = ouid;
	if(cur_players == 1){
		landlord.cache_rc->command("hmset hpriVenue:%d tid %d pnum %d", ouid,tid,1);
	}else{
		landlord.cache_rc->command("hset hpriVenue:%d pnum %d", ouid,cur_players);
	}
}

int Table::add_player(Player *player) {
	if (players.find(player->uid) == players.end()) {
		players[player->uid] = player;
		player->tid = tid;

		player->seatid = sit_down(player);
		player->ready = 0;
		if (player->seatid < 0) {
			return -1;
		}
		unicast_join_table_succ(player);
		cur_players++;
		// player->incr_online(type);

		return 0;
	}
	return -1;
}

void Table::unicast_join_table_succ(Player *player) {
	Jpacket packet;
	packet.val["cmd"] = SERVER_JOIN_TABLE_SUCC_UC;
	packet.val["tid"] = player->tid;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["game_type"] = landlord.game->game_type;
	packet.val["base_money"] = base_money;
	packet.val["bet_limit"] = landlord.conf["tables"]["ratio_limit"].asInt();;
	packet.end();
	unicast(player, packet.tostring());
}

int Table::sit_down(Player *player) {
	for (int i = 0; i < seatsNum; i++) {
		if (!seats[i].occupied) {
			seats[i].occupied = true;
			seats[i].player = player;
			return i;
		}
	}

	return -1;
}

int Table::del_player(Player *player) {
	if (players.find(player->uid) == players.end()) {
		log.debug("player uid[%d] talbe del_player is error\n", player->uid);
		return -1;
	}
	if (player->ready == 1) {
		ready_players--;
	}
	player->stop_ready_timer();
	player->stop_offline_timer();
	// player->decr_online(type);
//	log.debug("uid[%d]del_player-s\n", player->uid);
	players.erase(player->uid);
//	log.debug("uid[%d]del_player-e\n", player->uid);
	stand_up(player);
	cur_players--;
	if(landlord.game->game_type == 2){
		up_priv_table(player);
	}
	//log.debug("uid[%d]cur_players[%d]\n", player->uid, cur_players);

	// safe
	// ev_timer_stop(landlord.loop, &preready_timer);
	ev_timer_stop(landlord.loop, &bet_timer);
	ev_timer_stop(landlord.loop, &fight_timer);
	ev_timer_stop(landlord.loop, &rob_timer);

	if (cur_players == 0 && ready_players == 0) {
//		log.debug("#########delp[%d][%d]########\n",ready_players,cur_players);
		ev_timer_stop(landlord.loop, &noPerson_timer);
	}
	return 0;
}

void Table::up_priv_table(Player *p){
	if(roomerUid == p->uid){
		Player *player;
		std::map<int, Player*> tmp = players;
		std::map<int, Player*>::iterator it;
		for (it = tmp.begin(); it != tmp.end(); it++) {
			player = it->second;
			if(player->uid == p->uid){
				continue;
			}
			player->logout_type = roomer_out;
			landlord.game->del_player(player);
		}
		landlord.cache_rc->command("del hpriVenue:%d", roomerUid);
	}else{
		landlord.cache_rc->command("hset hpriVenue:%d pnum %d", roomerUid,cur_players);
	}
}

void Table::stand_up(Player *player) {
	seats[player->seatid].occupied = false;
	seats[player->seatid].player = NULL;
}

void Table::del_all_players() {
	Player *player;
	std::map<int, Player*> tmp = players;
	std::map<int, Player*>::iterator it;
	for (it = tmp.begin(); it != tmp.end(); it++) {
		player = it->second;
		landlord.game->del_player(player);
	}
}

int Table::broadcast(Player *p, const std::string &packet) {
	Player *player;
	std::map<int, Player*>::iterator it;
	for (it = players.begin(); it != players.end(); it++) {
		player = it->second;
		if (player == p || player->client == NULL) {
			continue;
		}

		player->client->send(packet);
	}

	return 0;
}

int Table::unicast(Player *p, const std::string &packet) {
	if (p->client) {
		return p->client->send(packet);
	}
	return -1;
}

void Table::wait_join_robot(int uid) {
	if ((uid < landlord.conf["game"]["robotStart"].asInt()
			|| uid > landlord.conf["game"]["robotEnd"].asInt())
			&& landlord.conf["tables"]["need_rob"].asInt() == 1) {
		// no person join in,so robot in
		ev_timer_again(landlord.loop, &noPerson_timer);
	}
}

int Table::table_info_broadcast(Player *p, int type) {
	Jpacket packet;
	packet.val["cmd"] = SERVER_TABLE_INFO_BC;

	Player *player;
	std::map<int, Player*>::iterator it;
	int i = 0;
	for (it = players.begin(); it != players.end(); it++) {
		player = it->second;
		packet.val["players"][i]["uid"] = player->uid;
		packet.val["players"][i]["seatid"] = player->seatid;
		packet.val["players"][i]["name"] = player->name;
		packet.val["players"][i]["sex"] = player->sex;
		packet.val["players"][i]["money"] = player->money;
		packet.val["players"][i]["coin"] = player->coin;
		packet.val["players"][i]["total_board"] = player->total_board;
		packet.val["players"][i]["total_win"] = player->total_win;
		packet.val["players"][i]["ready"] = player->ready;
		packet.val["players"][i]["headtime"] = player->avatar;

		packet.val["players"][i]["exp"] = player->exp;
		packet.val["players"][i]["level"] = player->level;
		packet.val["players"][i]["title"] = player->title;
		packet.val["players"][i]["charm"] = player->charm;
		packet.val["players"][i]["vip"] = player->vipLevel;
		packet.val["players"][i]["sign"] = player->sign;
		packet.val["players"][i]["totalPoint"] = player->totalPoint;
		//player->get_my_gifts();
		std::map<int, int>::iterator it2;
		for (it2 = player->my_gifts.begin(); it2 != player->my_gifts.end();
				it2++) {
			packet.val["players"][i]["gift"].append(it2->second);
		}

		i++;
	}
	packet.val["state"] = state; // must be ready
	packet.end();
	if (type == 0) {
		broadcast(NULL, packet.tostring());
	} else if (type == 1) {
		packet.val["state"] = state;
		unicast(p, packet.tostring());
	}

	return 0;
}

int Table::check_player_status(Player *player) {
	int needDel = 0;
	if (player->client) {
		if (player->money < min_money) {
			log.debug("uid[%d] money[%d] min_money[%d] money too less.\n",
					player->uid, player->money, min_money);
			player->logout_type = money_less;
			needDel = 1;
		}else if(max_money>0 && player->money>max_money){
			log.debug("uid[%d] money[%d] max_money[%d] money too over.\n",
								player->uid, player->money, max_money);
			player->logout_type = money_over;
			needDel = 1;
		} else {
			if (player->ready == 0) {
				player->start_ready_timer();
				player->start_offline_timer();
			}
		}
	} else // net err
	{
		log.debug("uid[%d] net err.\n", player->uid);
		player->logout_type = net_err;
		needDel = 1;
	}
	return needDel;
}
void Table::handler_game_preready() {
	if (state != S_READY) {
		log.error("handler_game_preready state0[%d]\n", state);
		return;
	}
	std::map<int, Player*> temp;
	std::map<int, Player*>::iterator it;
	for (it = players.begin(); it != players.end(); it++) {
		Player *player = it->second;
		if (player->isPreReady == 1) {
			continue;
		}

		if (handler_next_game(player, 0) == 1) {
			//player->logout_type = def;
			temp[player->uid] = player;
		}
	}
	for (it = temp.begin(); it != temp.end(); it++) {
		Player *player = it->second;
		landlord.game->del_player(player);
	}
}

int Table::handler_next_game(Player *player, int type) {
	if (state != S_READY) {
		log.error("handler_game_preready state1[%d]\n", state);
		return 1;
	}

	if(landlord.game->game_type==1 && landlord.game->isFightOpenTime()==0){
		log.debug("no fight open time to cont.\n");
		player->logout_type = no_open;
		return 1;
	}
	int needDel = check_player_status(player);
	log.debug("tid[%d]handler_game_preready[%d][%d].\n", tid,player->uid, needDel);
	if (needDel != 1) {
		player->isPreReady = 1;
		//table_info_broadcast(player, 1);
		if (type == 1) {
			Json::Value &val = player->client->packet.tojson();
			int isReady = val["type"].asInt();
//			log.debug("handler_next_game[%d] isReady[%d].\n", player->uid, isReady);
			if (isReady == 1) {
				handler_game_ready(player);
			}
			else {
				table_info_broadcast(player, 1);
			}
		}
		else {
			table_info_broadcast(player, 1);
		}
	}
	return needDel;
}

int Table::handler_game_ready(Player *player) {
	if (state != S_READY) {
		log.error("handler_game_ready state[%d]\n", state);
		return -1;
	}

	if (player->ready == 1) {
		log.error("player[%d] have been seted for game ready\n", player->uid);
		return -1;
	}
	if (player->money < min_money) {
		log.debug("uid[%d] money[%d] min_money[%d] money too less.\n",
				player->uid, player->money, min_money);
		player->logout_type = money_less;
		landlord.game->del_player(player);
		return -1;
	}else if(max_money>0 && player->money>max_money){
		log.debug("uid[%d] money[%d] max_money[%d] money too over.\n",
				player->uid, player->money, max_money);
		player->logout_type = money_over;
		landlord.game->del_player(player);
		return -1;
	}
	player->ready = 1;
	ready_players++;
	player->stop_ready_timer();

	{
//		log.debug("handler_game_ready ready_players[%d]\n", ready_players);
		int temp = 0;
		std::map<int, Player*>::iterator it;
		for (it = players.begin(); it != players.end(); it++) {
			Player *p = it->second;
			temp += p->ready;
//			log.debug("handler_game_ready uid[%d] ready[%d]\n", p->uid, p->ready);
		}

		if (temp != ready_players) {
			log.error("handler_game_ready temp[%d] ready_players[%d]\n", temp,
					ready_players);
			ready_players = temp;
		}
	}

	Jpacket packet;
	packet.val["cmd"] = SERVER_GAME_READY_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.end();
	broadcast(NULL, packet.tostring());

	log.debug("tid[%d]player ready[%d] seat[%d] rp[%d] cp[%d]\n",tid, player->uid,
			player->seatid, ready_players, cur_players);
	check_start_game();
	return 0;
}
void Table::check_start_game() {
	// 牌桌满2人，且全部已准备则开始
	if (ready_players == cur_players) {
		if (ready_players >= 2) {
			ready_players = 0;
			ev_timer_stop(landlord.loop, &preready_timer);

			std::map<int, Player*>::iterator it;
			for (it = players.begin(); it != players.end(); it++) {
				Player *p = it->second;
				p->reset();
			}
			// check day tasks is need reflash
			landlord.game->check_tasks_day();
			log.debug("tid[%d]start game [%d] [%d] [%d] [%d] [%d]~~~~~~~~\n",tid,
					seats[0].occupied ? seats[0].player->uid : 0,
					seats[1].occupied ? seats[1].player->uid : 0,
					seats[2].occupied ? seats[2].player->uid : 0,
					seats[3].occupied ? seats[3].player->uid : 0,
					seats[4].occupied ? seats[4].player->uid : 0);
			start_rob();
			landlord.game->update_table(tid, 1);
		} else if (ready_players == 1 && landlord.game->game_type<2) {
			std::map<int, Player*>::iterator it;
			for (it = players.begin(); it != players.end(); it++) {
				Player *p = it->second;
				wait_join_robot(p->uid);
				break;
			}
		}
	}
}
int Table::random(int start, int end) {
	return start + rand() % (end - start + 1);
}

void Table::reset() {
//	log.debug("reset table~~\n");
	ready_players = 0;
	bet_players = 0;
	rob_players = 0;
	fight_players = 0;
	keeper_seat = 0;
	state = S_READY;

	std::map<int, Player*> temp;
	std::map<int, Player*>::iterator it;
	for (it = players.begin(); it != players.end(); it++) {
		Player *player = it->second;
		if (!player->client) {
			player->logout_type = net_err;
			temp[player->uid] = player;
		}
	}
	for (it = temp.begin(); it != temp.end(); it++) {
		Player *player = it->second;
		landlord.game->del_player(player);
		log.debug("tid[%d]reset table del net err player[%d]~~~~~~~~\n", tid,player->uid);
	}
}

void Table::vector_to_json_array(std::vector<Card> &cards, Jpacket &packet,
		string key) {
	for (unsigned int i = 0; i < cards.size(); i++) {
//		printf("abcxxx:%d\n", cards[i].value);
		packet.val[key].append(cards[i].value);
	}

	if (cards.size() == 0) {
		packet.val[key].append(0);
	}
}

void Table::map_to_json_array(std::map<int, Card> &cards, Jpacket &packet,
		string key) {
	std::map<int, Card>::iterator it;
	for (it = cards.begin(); it != cards.end(); it++) {
		Card &card = it->second;
		packet.val[key].append(card.value);
	}
}

void Table::json_array_to_vector(std::vector<Card> &cards, Jpacket &packet,
		string key) {
	Json::Value &val = packet.tojson();

	for (unsigned int i = 0; i < val[key].size(); i++) {
		Card card(val[key][i].asInt());

		cards.push_back(card);
	}
}

int Table::cal_bet_range_base(Seat &keeper, Seat &curr, int ratio_limit) {
	int lessOneMoney =
			keeper.player->money > curr.player->money ?
					curr.player->money : keeper.player->money;
	int n = lessOneMoney / base_money / 3;
	if (n > ratio_limit) {
		n = ratio_limit;
	}
	if (n < 5) {
		n = 5;
	}
	return n;
}

void Table::get_bet_range(Jpacket &packet, string key, Seat &keeper, Seat &curr,
		int ratio_limit) {
	int n = cal_bet_range_base(keeper, curr, ratio_limit);
	packet.val[key].append(n / 4);
	packet.val[key].append(n / 2);
	packet.val[key].append(3*n / 4);
	packet.val[key].append(n);
}

int Table::handler_main_action(Player *player, State s) {
	Json::Value &val = player->client->packet.tojson();

	if (state != s) {
		log.error("current state is [%d], request cmd is [%d]\n", state, s);
		return -1;
	}

	if (state == S_ROB) {
		int action = val["action"].asInt();
		handler_rob(player, action);
	} else if (state == S_BET) {
		int betnum = val["betnum"].asInt();
		handler_bet(player, betnum);
	} else if (state == S_FIGHTING) {
		handler_fight(player, 0);
	} else {
		log.error("cmd is error\n");
		return -1;
	}

	return 0;
}

int Table::handler_rob(Player *player, int action) {
	if (state != S_ROB) {
		log.error("action handler_rob is low .\n");
		return -1;
	}
	if (player->isrob >= 0) {
		log.error("player has rob[%d].\n", player->uid);
		return -1;
	}

	log.debug("tid[%d]handler_rob uid[%d] action[%d] rp[%d] cp[%d]\n", tid,player->uid,
			action, rob_players, cur_players);
	player->isrob = action;
	rob_players++;
	Jpacket packet;
	packet.val["cmd"] = SERVER_ROB_SUCC_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["action"] = action;
	packet.end();
	broadcast(NULL, packet.tostring());
	if (rob_players == cur_players) {
		int robtype = set_keeper();
		log.debug("tid[%d]setKeeper[%d]seat[%d]robtype[%d]\n",tid,
				seats[keeper_seat].player->uid, keeper_seat, robtype);
		start_bet(robtype);
	}

	return 0;
}

int Table::handler_bet(Player *player, int betnum) {
	if (state != S_BET) {
		log.error("action handler_bet is low[%d].\n", player->uid);
		return -1;
	}
	if (player->betnum > 0) {
		log.error("player has bet[%d].\n", player->uid);
		return -1;
	}
	if (player->seatid == keeper_seat) {
		log.error("keeper donot need bet[%d].\n", player->uid);
		return -1;
	}
	log.debug("tid[%d]handler_bet uid[%d]betnum[%d]\n", tid,player->uid, betnum);
	player->betnum = betnum;
	bet_players++;
	Jpacket packet;
	packet.val["cmd"] = SERVER_BET_SUCC_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["betnum"] = betnum;
	packet.end();
	broadcast(NULL, packet.tostring());
	// 庄家不需要下注
	if (bet_players + 1 == cur_players) {
		start_fight();
	}
	return 0;
}

int Table::handler_fight(Player *player, int action) {

	if (state != S_FIGHTING) {
		log.error("handler_fight state error\n");
		return -1;
	}
	if (!player->fight_cards.cards.empty()) {
		log.error("has fight cards error\n");
		return -1;
	}
	fight_players++;
	std::vector<Card> cur_cards;

	CardFind cardFind;
	if (action == 0) {
		//client request to show cards
		Json::Value &val = player->client->packet.tojson();
		json_array_to_vector(cur_cards, player->client->packet, "cards");
		player->cardtype = val["card_type"].asInt();

		//亮牌对象fight_cards 赋值
		for (unsigned int i = 0; i < cur_cards.size(); i++) {
			player->fight_cards.add_card(cur_cards[i]);
		}

		// 判断是否机器人
		if (isRobot(player->uid)) {
			//查找最大牌型
			cardFind.tip_dcow(player->hole_cards.game_cards);
			int robot_cardtype = cardFind.cow_card_type;
			player->cardtype = robot_cardtype;

			//log.debug("robot cards:\n");
			cur_cards.clear();
			player->fight_cards.clear();
			for (unsigned int i = 0; i < cardFind.results_dcow.size(); i++) {
				cur_cards.push_back(cardFind.results_dcow[i]);
				//重新保存亮牌顺序
				player->fight_cards.add_card(cardFind.results_dcow[i]);
				//log.debug(" %d " , cardFind.results_dcow[i].value );
			}
		} else {
			// 1 ~ 14
			if (player->cardtype > 0 && player->cardtype < 15) {
				// 对客户端的亮牌是否合法的校验
				std::vector<Card> s_cards(player->hole_cards.game_cards);
				std::vector<Card> c_cards(cur_cards);

				int ret = cardFind.valid_cards(cur_cards, c_cards, s_cards,
						player->cardtype);
				if (ret == -1) {
					log.debug("tid[%d]valid cards result is [%d]\n",tid, ret);
					//校验失败，client 与 server 不一致
					//强制把player 设置为 loser?
					player->cardtype = 1; //  没牛
					player->isWin = -1;
				}
			} else {
				// 类型错误，当没牛处理？
				player->isWin = -1;
			}
		}
	}  // end action = 0
	else {
		//action = 1 , time out, server 主动亮牌
		//是否因网络原因而超时？（ 对心跳时间进行检测，如果是断网，帮用户算牌型？如果是用户不亮牌，则做没牛处理)？

		player->cardtype = 1; //没牛
		player->fight_cards = player->hole_cards;
		// 无牛，重新按牌大小排序
		//if (player->cardtype == 1) {
		//查找最大牌型
		cardFind.tip_dcow(player->fight_cards.game_cards);
		cur_cards.clear();
		player->fight_cards.clear();
		for (unsigned int i = 0; i < cardFind.results_dcow.size(); i++) {
			cur_cards.push_back(cardFind.results_dcow[i]);
			//重新保存亮牌顺序
			player->fight_cards.add_card(cardFind.results_dcow[i]);
		}
		//}
	}

	Jpacket packet;
	packet.val["cmd"] = SERVER_FIGHT_SUCC_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	vector_to_json_array(cur_cards, packet, "cards");
	packet.val["card_type"] = player->cardtype;
	packet.end();

	broadcast(NULL, packet.tostring());

	//log.debug(" handler_fight uid[%d] cType[%d] cards[%s]\n", player->uid,player->cardtype, packet.val["cards"].toStyledString().c_str());
	string s;
	for (unsigned int i = 0; i < cur_cards.size(); i++) {
		char tmp[10];
		sprintf(tmp, "%d,%d", cur_cards[i].face, cur_cards[i].suit);
		string a(tmp);
		s = s + "@ " + a;
	}
	log.debug("tid[%d]handler_fight uid[%d] cType[%d] cards[%s]\n",tid, player->uid,
			player->cardtype, s.c_str());

//	log.debug("00000000[%d][%d]\n",fight_players,cur_players);
	if (fight_players == cur_players) {
		judge_winner();
		game_end();
	}
	return 0;
}

int Table::start_rob() {
	int niceNum = 0;
	// 谁会拿到好牌,预留后期会与VIP 或特殊道具挂钩
	int tempNice = niceCardRatio;
	for (int i = 0; i < seatsNum; i++) {
		if (!seats[i].occupied) {
			continue;
		}
		int ran = random(0,100);
//		log.debug("##nice ran[%d][%d][%d]\n",seats[i].player->uid,ran,niceCardRatio);
		if(isRobot(seats[i].player->uid)){
			tempNice = niceCardRatioRobot;
		}else{
			tempNice = niceCardRatio;
		}
		if(ran<tempNice){
			niceNum++;
			seats[i].player->isNiceCard = 1;
		}else{
			seats[i].player->isNiceCard = 0;
		}
	}
	// 洗牌
//	deck.filltmp();
//	deck.shuffle(tid);
//	log.debug("@@@ niceCard Num:[%d]\n",niceNum);
	deck.fillBullfight(niceNum,tid);
	for (int i = 0; i < seatsNum; i++) {
		if (!seats[i].occupied) {
			continue;
		}
//		deck.get_hole_cards_bomb(seats[i].player->hole_cards);
		deck.get_hotpot_cards(seats[i].player->hole_cards,seats[i].player->isNiceCard);
		log.debug("tid[%d]cards:[%d][%d][%d][%d][%d]\n",tid,seats[i].player->hole_cards.game_cards[0].face,
				seats[i].player->hole_cards.game_cards[1].face,seats[i].player->hole_cards.game_cards[2].face,
				seats[i].player->hole_cards.game_cards[3].face,seats[i].player->hole_cards.game_cards[4].face);
		Jpacket packet;
		packet.val["cmd"] = SERVER_GAME_START_UC;
		// 发牌
		//map_to_json_array(seats[i].player->hole_cards.cards, packet, "cards");
		vector_to_json_array(seats[i].player->hole_cards.game_cards, packet,
				"cards");
		if(isRobot(seats[i].player->uid)){
			CardFind cardFind;
			//查找最大牌型
			cardFind.tip_dcow(seats[i].player->hole_cards.game_cards);
			packet.val["cardtype"] = cardFind.cow_card_type;
		}else{
			packet.val["cardtype"] = CARD_TYPE_COW_NO;
		}
		packet.val["uid"] = seats[i].player->uid;
		packet.val["seatid"] = seats[i].seat_no;
		packet.val["taskid"] = 0;
		packet.end();
		unicast(seats[i].player, packet.tostring());
	}
	log.debug("tid[%d]start_rob~~~~~~~~\n",tid);
	state = S_ROB;
	rob_players = 0;
	// 打开抢庄定时器
	ev_timer_again(landlord.loop, &rob_timer);
	return 0;
}

int Table::start_bet(int robType) {
	// 关闭抢庄超时定时器
	ev_timer_stop(landlord.loop, &rob_timer);
	state = S_BET;
	bet_players = 0;
	Player *player = seats[keeper_seat].player;

	log.debug("tid[%d]start_bet~~~~~~~~\n",tid);
	Jpacket packet;
	packet.val["cmd"] = SERVER_KEEPER_BC;
	packet.val["uid"] = player->uid;
	packet.val["dealer"] = keeper_seat;
	packet.val["type"] = robType;
	packet.end();
	broadcast(NULL, packet.tostring());
	int ratio_limit = landlord.conf["tables"]["ratio_limit"].asInt();
	for (int i = 0; i < seatsNum; i++) {
		// 庄家不需要下注
		if (!seats[i].occupied) {
			continue;
		}
		Jpacket packet;
		packet.val["cmd"] = SERVER_BET_BC;
		if (keeper_seat == i) {
			packet.val["betrange"] = 0;
		} else {
			get_bet_range(packet, "betrange", seats[keeper_seat], seats[i],
					ratio_limit);
		}
		packet.val["uid"] = seats[i].player->uid;
		packet.val["seatid"] = seats[i].seat_no;
		packet.end();
		unicast(seats[i].player, packet.tostring());
	}
	ev_timer_again(landlord.loop, &bet_timer);
	return 0;
}

int Table::start_fight() {
	ev_timer_stop(landlord.loop, &bet_timer);
	state = S_FIGHTING;
	fight_players = 0;
	Jpacket packet;
	packet.val["cmd"] = SERVER_FIGHT_BC;
	packet.val["tt"] = SERVER_FIGHT_BC;
	packet.end();
	broadcast(NULL, packet.tostring());
	log.debug("tid[%d]start_fight~~~~~~~~\n",tid);
	ev_timer_again(landlord.loop, &fight_timer);
	return 0;
}

int Table::set_keeper() {
	vector<Seat> robList;
	for (int i = 0; i < seatsNum; i++) {
		if (!seats[i].occupied) {
			continue;
		}
		if (seats[i].player->isrob == KEEPER) {
			robList.push_back(seats[i]);
		}
	}
	// choose rice one to be Keeper
	//long topMoney = 0;
	if (robList.empty() || robList.size() <= 0) {
		vector<Seat> vrob;
		for (int i = 0; i < seatsNum; i++) {
			if (!seats[i].occupied) {
				continue;
			}
			vrob.push_back(seats[i]);
		}
		int rk, rsize;
		rsize = vrob.size() > 0 ? vrob.size() : 1;
		srand((unsigned) time(NULL));
		// 产生 1 ~ rsize - 1  的随机数
		rk = rand() % rsize;
		keeper_seat = vrob[rk].player->seatid;

		/*
		 for (int i = 0; i < seatsNum; i++) {
		 if (!seats[i].occupied) {
		 continue;
		 }
		 if (seats[i].player->money > topMoney) {
		 keeper_seat = seats[i].player->seatid;
		 topMoney = seats[i].player->money;
		 }
		 }
		 */
		return no_rob;
	} else if (robList.size() == 1) {
		keeper_seat = robList[0].player->seatid;
		return one_rob;
	} else {
		int rk, rsize;
		rsize = robList.size();
		srand((unsigned) time(NULL));
		// 产生 1 ~ rsize - 1  的随机数
		rk = rand() % rsize;
		keeper_seat = robList[rk].player->seatid;
		/*
		 int robSize = robList.size();
		 for (int i = 0; i < robSize; i++) {
		 if (robList[i].player->money > topMoney) {
		 keeper_seat = robList[i].player->seatid;
		 topMoney = robList[i].player->money;
		 }
		 }
		 */
		return more_rob;
	}
}

void Table::fight_timer_cb(struct ev_loop *loop, struct ev_timer *w,
		int revents) {
	Table *table = (Table*) w->data;

	ev_timer_stop(landlord.loop, &table->fight_timer);

	for (int i = 0; i < table->seatsNum; i++) {
		if (!table->seats[i].occupied
				|| !table->seats[i].player->fight_cards.cards.empty()
				|| table->state != S_FIGHTING) {
			continue;
		}
		table->handler_fight(table->seats[i].player, 1);
	}
}

void Table::bet_timer_cb(struct ev_loop *loop, struct ev_timer *w,
		int revents) {
	Table *table = (Table*) w->data;
	log.debug("tid[%d]bet_timer_cb~~~~~~~~\n",table->tid);
	ev_timer_stop(landlord.loop, &table->bet_timer);
	int ratio_limit = landlord.conf["tables"]["ratio_limit"].asInt();

	for (int i = 0; i < table->seatsNum; i++) {
		if (!table->seats[i].occupied || table->seats[i].player->betnum > 0
				|| table->keeper_seat == i || table->state != S_BET) {
			continue;
		}
		// get less betnum by cal
		int n = table->cal_bet_range_base(table->seats[table->keeper_seat],
				table->seats[i], ratio_limit);
		int minBet = 2*n / 5;
		if(table->vid>2){
			minBet = n / 2;
		}
		table->handler_bet(table->seats[i].player, minBet);
	}
}

void Table::rob_timer_cb(struct ev_loop *loop, struct ev_timer *w,
		int revents) {
	Table *table = (Table*) w->data;
	log.debug("tid[%d]rob_timer_cb~~~~~~~~\n",table->tid);
	ev_timer_stop(landlord.loop, &table->rob_timer);
	for (int i = 0; i < table->seatsNum; i++) {
		if (!table->seats[i].occupied || table->seats[i].player->isrob >= 0
				|| table->state != S_ROB) {
			continue;
		}
		table->handler_rob(table->seats[i].player, 0);
	}
}

void Table::preready_timer_cb(struct ev_loop *loop, struct ev_timer *w,
		int revents) {
	Table *table = (Table*) w->data;
	log.debug("tid[%d]preready_timer_cb~~~~~~~~\n",table->tid);
	ev_timer_stop(landlord.loop, &table->preready_timer);
	table->handler_game_preready();
}

void Table::noPerson_timer_cb(struct ev_loop *loop, struct ev_timer *w,
		int revents) {
	Table *table = (Table*) w->data;
	if (table->state != S_READY) {
		ev_timer_stop(landlord.loop, &table->noPerson_timer);
		return;
	}
	if (table->cur_players >= seatsNum) {
		return;
	}
	// 人不够加到满
	int diff = seatsNum - table->cur_players;
	diff = table->random(1,diff);
	int ret = landlord.cache_rc->command("hgetall hrob:need");
	int currNum = 0;
	if (ret >= 0 && landlord.cache_rc->is_array_return_ok() >= 0) {
		char kStr[10];
		sprintf(kStr, "%d", table->vid);
		currNum = landlord.cache_rc->get_value_as_int(kStr);
		if (currNum < 0) {
			currNum = 0;
		}
	}
	log.debug("#########join robot[%d][%d]########\n", currNum, diff);
	currNum += diff;
	ret = landlord.cache_rc->command("hset hrob:need %d %d", table->vid,
			currNum);
	ev_timer_stop(landlord.loop, &table->noPerson_timer);
}

int Table::judge_winner() {
	Player *player = NULL;
	vector<Card> keeper_cards;
	vector<Card> leisure_cards;
	int cardtype_keeper;
	int cardtype_leisure;

	std::map<int, Player*>::iterator it;

	//找到庄家
	for (it = players.begin(); it != players.end(); it++) {
		player = it->second;
		if (player->seatid == keeper_seat) {
			keeper_cards = player->fight_cards.game_cards;
			cardtype_keeper = player->cardtype;
			break;
		}
	}

	//闲家与庄家的比牌
	for (it = players.begin(); it != players.end(); it++) {
		player = it->second;
		if (player->seatid == keeper_seat) {
			continue;
		}

		leisure_cards = player->fight_cards.game_cards;
		cardtype_leisure = player->cardtype;
		if (player->isWin == -1) {
			//客户端牌型与服务端牌型不一样，则判输
			player->isWin = 0;
		} else {
			int ret = CardFind::get_winner(keeper_cards, cardtype_keeper,
					leisure_cards, cardtype_leisure);
			player->isWin = ret;
			log.debug("tid[%d]player(leisure) [uid=%d] get_winner[%d]\n",tid, player->uid,
					ret);
		}
	}
	return 0;
}

int Table::game_end() {
//	landlord.game->dump_msg("game_end");
//	landlord.game->dump_game_info("game_end");
	ev_timer_stop(landlord.loop, &fight_timer);

	Player *player = NULL;

	Jpacket packet;
	packet.val["cmd"] = SERVER_GAME_END_BC;

	count_money();
	std::map<int, Player*>::iterator it;
	int i = 0;
	for (it = players.begin(); it != players.end(); it++) {
		player = it->second;
		cal_task_award(player, player->isWin);
		packet.val["players"][i]["seatid"] = player->seatid;
		packet.val["players"][i]["uid"] = player->uid;
		packet.val["players"][i]["name"] = player->name;
		packet.val["players"][i]["sex"] = player->sex;
		packet.val["players"][i]["money"] = player->money;
		packet.val["players"][i]["coin"] = player->coin;
		//packet.val["players"][i]["vip"] = player->vip;
		packet.val["players"][i]["cur_money"] = player->cur_money;
		packet.val["players"][i]["cur_coin"] = player->cur_coin;
		//packet.val["players"][i]["headtime"] = player->avatar;
		//packet.val["players"][i]["total_board"] = player->total_board;
		//packet.val["players"][i]["total_win"] = player->total_win;
		packet.val["players"][i]["card_type"] = player->cardtype;
		packet.val["players"][i]["is_win"] = player->isWin;
		int exp = player->isWin == 0 ? landlord.game->exp_lost : landlord.game->exp_win;
		packet.val["players"][i]["exp"] = exp;
		packet.val["players"][i]["totalPoint"] = player->totalPoint;
		packet.val["players"][i]["currPoint"] = player->currPoint;
		i++;
//		log.debug("player[%d] role[%d] cur_money[%d]\n", player->uid, player->role, player->cur_money);
	}
	packet.end();
	broadcast(NULL, packet.tostring());
	log.debug("tid[%d]game end\n",tid);
	// reset table info and player info
	reset();
	for (it = players.begin(); it != players.end(); it++) {
		Player *p = it->second;
		p->reset();
		//检查是否破产   破产赠送
		check_free_give(p);
	}
	ev_timer_again(landlord.loop, &preready_timer);

	return 0;
}

const map<int, int> Table::typeRatio = Table::create_map();

void Table::count_money() {
	int isWin = 0;
	int keeperCardType = seats[keeper_seat].player->cardtype;
	int fighterCardType = 0;
	long keeperMoney = 0;
	long fighterMoney = 0;
	time_t cur_time = 0;
	time(&cur_time);

	double tax = landlord.conf["tables"]["tax"].asDouble();
	//闲家输
	for (int i = 0; i < seatsNum; i++) {
		if (!seats[i].occupied || keeper_seat == i) {
			continue;
		}
		isWin = seats[i].player->isWin;
		fighterCardType = seats[i].player->cardtype;
		if (fighterCardType <= 0 || fighterCardType > 14) {
			fighterCardType = 1;
		}
		// 失败玩家的金币消耗：X*N
		// 胜利玩家的金币奖励：X*N*（1-A）
		// X=游戏底注*下注倍数,N=牌型积分,A=系统抽税比率
		if (isWin == 0) {		// 庄家胜
			fighterMoney = base_money * seats[i].player->betnum * typeRatio.at(keeperCardType);

			fighterMoney =
					fighterMoney > seats[i].player->money ?
							seats[i].player->money : fighterMoney;

			seats[i].player->cur_money = fighterMoney;
			keeperMoney += fighterMoney	* (1 - tax);	// + 1;
			seats[i].player->incr_money(SUB, fighterMoney);
			if(landlord.game->game_type==1){
				seats[i].player->incr_fight_point(SUB, fighterMoney,base_money);
			}
			seats[i].player->incr_expr(1);
			//seats[i].player->incr_total_win(vid, 1);
			seats[i].player->incr_coin();
			seats[i].player->incr_total_board(vid, 1);

			log.debug("tid[%d]res fighter:uid[%d]iswin[%d]betnum[%d]cardT[%d]cardRation[%d]currM[%d]winM[%d]\n",tid,
					seats[i].player->uid, isWin, seats[i].player->betnum,
					keeperCardType, typeRatio.at(keeperCardType), seats[i].player->money,fighterMoney);

			inset_flow_log(cur_time, seats[i].player->uid, AF_MONEY, SUB,"game", seats[i].player->money,
					fighterMoney);
		}
	}

	//闲家赢
	// step1  计算每个闲家的赢钱金额
	// step2 赢钱的总额 与 庄家的金币相比，
	//if  庄家 money >= 闲家的赢钱总额， then 逐个赢家结算 :  当前赢家的赢钱数*系统抽税比率  ；
	//if  庄家 money < 闲家的赢钱总额， then 给每个赢家的结算为:　庄家 money　*　 当前赢家的赢钱数/所有闲家的赢钱总额 *系统抽税比率  ；
	leisureWin.clear();
	int win_total_money = 0;
	for (int i = 0; i < seatsNum; i++) {
		if (!seats[i].occupied || keeper_seat == i) {
			continue;
		}
		isWin = seats[i].player->isWin;
		// 失败玩家的金币消耗：X*N
		// 胜利玩家的金币奖励：X*N*（1-A）
		// X=游戏底注*下注倍数,N=牌型积分,A=系统抽税比率
		if (isWin == 1) {
			fighterCardType = seats[i].player->cardtype;
			if (fighterCardType <= 0 || fighterCardType > 14) {
				fighterCardType = 1;
			}
			LeisureWin lwin;
			lwin.clear();
			lwin.player = seats[i].player;
			lwin.win_money = base_money * seats[i].player->betnum * typeRatio.at(fighterCardType);
			win_total_money += lwin.win_money;
			leisureWin.push_back(lwin);
		}
	}

	//if  庄家 money >= 闲家的赢钱总额， then 逐个赢家结算 :  当前赢家的赢钱数*系统抽税比率  ；
	int keeper_total_money = keeperMoney + seats[keeper_seat].player->money;
	log.debug("tid[%d]keeper:uid[%d] keeper_total_money[%d] win_total_money[%d] \n",tid,
			seats[keeper_seat].player->uid, keeper_total_money,
			win_total_money);
	if (keeper_total_money >= win_total_money) {
		for (unsigned int i = 0; i < leisureWin.size(); i++) {
			fighterCardType = leisureWin[i].player->cardtype;
			if (fighterCardType <= 0 || fighterCardType > 14) {
				fighterCardType = 1;
			}
			fighterMoney = leisureWin[i].win_money;
			leisureWin[i].player->cur_money = fighterMoney	* (1 - tax);	// + 1;
			keeperMoney -= fighterMoney;

			leisureWin[i].player->incr_money(ADD,
					leisureWin[i].player->cur_money);
			leisureWin[i].player->incr_expr(2);
			leisureWin[i].player->incr_total_win(vid, 1);
			leisureWin[i].player->incr_coin();
			leisureWin[i].player->incr_total_board(vid, 1);
			if(landlord.game->game_type==1){
				leisureWin[i].player->incr_fight_point(ADD,
						leisureWin[i].player->cur_money,base_money);
			}
			log.debug("tid[%d]leisureWin[i].player->cur_money = %d ; fighterMoney=%d\n",tid,
					leisureWin[i].player->cur_money, fighterMoney);

			log.debug("tid[%d]res 1 fighter:uid[%d]iswin[%d]betnum[%d]cardT[%d]cardRation[%d]currM[%d]winM[%d]\n",
					tid,leisureWin[i].player->uid, leisureWin[i].player->isWin,
					leisureWin[i].player->betnum, fighterCardType,
					typeRatio.at(fighterCardType), leisureWin[i].player->money,leisureWin[i].player->cur_money);
			inset_flow_log(cur_time, leisureWin[i].player->uid, AF_MONEY, ADD,
					"game", leisureWin[i].player->money, leisureWin[i].player->cur_money);
		}
	} else {
		//if  庄家 money < 闲家的赢钱总额， then 给每个赢家的结算为:　庄家 money　*　 当前赢家的赢钱数/所有闲家的赢钱总额 *系统抽税比率  ；
		for (unsigned int i = 0; i < leisureWin.size(); i++) {
			fighterCardType = leisureWin[i].player->cardtype;
			if (fighterCardType <= 0 || fighterCardType > 14) {
				fighterCardType = 1;
			}
			fighterMoney = leisureWin[i].win_money;
			double dnum = 1.0 * keeper_total_money
					* ((1.0 * fighterMoney) / (1.0 * win_total_money))
					* (1 - tax);
			leisureWin[i].player->cur_money = static_cast<int>(dnum);
			//keeperMoney -= fighterMoney;
			keeperMoney -= static_cast<int>(1.0 * keeper_total_money
					* ((1.0 * fighterMoney) / (1.0 * win_total_money)));

			leisureWin[i].player->incr_money(ADD,
					leisureWin[i].player->cur_money);
			leisureWin[i].player->incr_expr(2);
			leisureWin[i].player->incr_total_win(vid, 1);
			leisureWin[i].player->incr_coin();
			leisureWin[i].player->incr_total_board(vid, 1);
			if(landlord.game->game_type==1){
				leisureWin[i].player->incr_fight_point(ADD,
						leisureWin[i].player->cur_money,base_money);
			}
			log.debug("tid[%d]leisureWin[i].player->cur_money = %d ; fighterMoney=%d\n",
					tid,leisureWin[i].player->cur_money, fighterMoney);

			log.debug("tid[%d]res 2 fighter:uid[%d]iswin[%d]betnum[%d]cardT[%d]cardRation[%d]currM[%d]winM[%d]\n",
					tid,leisureWin[i].player->uid, leisureWin[i].player->isWin,
					leisureWin[i].player->betnum, fighterCardType,
					typeRatio.at(fighterCardType), leisureWin[i].player->money,leisureWin[i].player->cur_money);
			inset_flow_log(cur_time, leisureWin[i].player->uid, AF_MONEY, ADD,
								"game", leisureWin[i].player->money, leisureWin[i].player->cur_money);
		}
		keeperMoney =
				keeperMoney < keeper_total_money ?
						(0 - keeper_total_money) : keeperMoney;
	}

	if (keeperMoney >= 0) {
		//庄家最终赢
		seats[keeper_seat].player->cur_money = keeperMoney;
		seats[keeper_seat].player->isWin = 1;
		seats[keeper_seat].player->incr_money(ADD, keeperMoney);
		seats[keeper_seat].player->incr_total_win(vid, 1);

		seats[keeper_seat].player->incr_coin();
		seats[keeper_seat].player->incr_expr(2);
		seats[keeper_seat].player->incr_total_board(vid, 1);
		if(landlord.game->game_type==1){
			seats[keeper_seat].player->incr_fight_point(ADD, keeperMoney,base_money);
		}
		inset_flow_log(cur_time, seats[keeper_seat].player->uid, AF_MONEY, ADD,
							"game", seats[keeper_seat].player->money, keeperMoney);
	} else {
		//庄家最终输
		seats[keeper_seat].player->cur_money = 0 - keeperMoney;
		seats[keeper_seat].player->isWin = 0;
		seats[keeper_seat].player->incr_money(SUB, 0 - keeperMoney);

		seats[keeper_seat].player->incr_coin();
		seats[keeper_seat].player->incr_expr(1);
		seats[keeper_seat].player->incr_total_board(vid, 1);
		if(landlord.game->game_type==1){
			seats[keeper_seat].player->incr_fight_point(SUB, keeperMoney,base_money);
		}
		inset_flow_log(cur_time, seats[keeper_seat].player->uid, AF_MONEY, SUB,
				"game", seats[keeper_seat].player->money, 0-keeperMoney);
	}

	log.debug("tid[%d]res keeper:uid[%d]iswin[%d]cardT[%d]cardRation[%d]currM[%d]winM[%d]\n",
			tid,seats[keeper_seat].player->uid, seats[keeper_seat].player->isWin,
			keeperCardType, typeRatio.at(keeperCardType),seats[keeper_seat].player->money,
			seats[keeper_seat].player->cur_money);
	// 私人场需要额外扣除台费
	if(landlord.game->game_type == 2){
		int tablefree = base_money*landlord.conf["tables"]["tableFreeRatio"].asInt();
		for (int i = 0; i < seatsNum; i++) {
			if (!seats[i].occupied) {
				continue;
			}
			if(seats[i].player->vipLevel>0){
				tablefree = tablefree * 0.9;
			}
			seats[i].player->incr_money(SUB, tablefree);
			log.debug("tid[%d]table free[%d][%d]\n",tid,seats[i].player->uid,tablefree);
		}
	}

}

void Table::map_to_json_array_spec(std::map<int, Card> &cards, Jpacket &packet,
		int index) {
	std::map<int, Card>::iterator it;
	for (it = cards.begin(); it != cards.end(); it++) {
		Card &card = it->second;
		packet.val["players"][index]["holes"].append(card.value);
	}
}

void Table::add_talk(std::string name, std::string msg, int curr_t) {
	Talk t;
	t.msg = msg;
	t.playerName = name;
	t.createtime = curr_t;
	int tSize = talkList.size();
	int diff = tSize - 20;
	if (diff > 0) {
		for (int i = 0; i <= diff; i++) {
			talkList.pop_back();
		}
	}
	talkList.insert(talkList.begin(), t);
	/*	for(int j=0; j<tSize;j++){
	 log.debug("###talk[%s][%s]\n",talkList[j].playerName.c_str(),talkList[j].msg.c_str());
	 }*/
}

int Table::handler_talk_list(Player *player) {
	Jpacket packet;
	packet.val["cmd"] = SERVER_TALK_LIST_SUCC_UC;
//	log.debug("@@@talk size[%d]\n", talkList.size());
	packet.val["uid"] = player->uid;
	if (talkList.size() == 0) {
		packet.val["talk"].append(0);
	} else {
		unsigned int size = talkList.size();
		for (unsigned int i = 0; i < size; i++) {
			packet.val["talk"].append(
					talkList[i].playerName + ":" + talkList[i].msg);
		}
	}
	packet.end();
	unicast(player, packet.tostring());
	return 0;
}

void Table::send_speaker_bc() {
	Jpacket packet;
	packet.val["cmd"] = SERVER_SPEAKER_BC;
	for (unsigned int i = 0; i < landlord.game->broadcastList.size(); i++) {
		packet.val["msgs"][i]["type"] = landlord.game->broadcastList[i].type;
		packet.val["msgs"][i]["msg"] = landlord.game->broadcastList[i].msg;
	}
	packet.end();
	broadcast(NULL, packet.tostring());
}

void Table::rep_blackword(std::string instr,std::string &outstr){
	int pos = 0;
	if((pos=outstr.find(instr))!=-1){
		outstr.replace(pos,instr.length(),"*");
		rep_blackword(instr,outstr);
	}
}

int Table::handler_chat(Player *player) {
//	log.debug("h_c 0\n");
	Json::Value &val = player->client->packet.tojson();
	int tag = val["tag"].asInt();
	Jpacket packet;
	std::string outstr(val["str"].asString().c_str());
	if(tag==-1){
/*		struct timeval tv;
		gettimeofday(&tv, NULL);
		long ot = tv.tv_sec*1000+tv.tv_usec/1000;*/
		int bsize = landlord.game->blackwordList.size();
		for(int i=0;i<bsize;i++){
			rep_blackword(landlord.game->blackwordList.at(i),outstr);
		}
/*		gettimeofday(&tv, NULL);
		long ct = tv.tv_sec*1000+tv.tv_usec/1000;
		log.debug("talk str[%s]t[%d][%d][%d]\n",outstr.c_str(),ot,ct,ct-ot);*/
	}
	/*std::string instr(val["str"].asString().c_str());
	std::string outstr;
	int ret = player->check_talk_str(instr, outstr, tag);
	if (ret != 0) {
		packet.val["cmd"] = SERVER_TALK_ERR_UC;
		packet.val["uid"] = player->uid;
		packet.val["ecode"] = ret;
		packet.end();
		unicast(player, packet.tostring());
		return 0;
	}
	if (tag == -1) {
		add_talk(player->name, outstr, player->curr_time());
	}*/
	packet.val["cmd"] = SERVER_CHAT_BC;
	packet.val["str"] = outstr;
	packet.val["tag"] = tag;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.end();
	broadcast(NULL, packet.tostring());
	return 0;
}

int Table::handler_face(Player *player) {
	Json::Value &val = player->client->packet.tojson();

	Jpacket packet;
	packet.val["cmd"] = SERVER_FACE_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["faceid"] = val["faceid"];
	packet.end();
	broadcast(NULL, packet.tostring());

	return 0;
}

int Table::handler_logout(Player *player) {
	if (state != S_READY) {
		log.error("handler_logout state[%d]\n", state);
		return -1;
	}

	Jpacket packet;
	packet.val["cmd"] = SERVER_LOGOUT_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["type"] = player->logout_type;
	packet.val["money"] = player->money;
	packet.end();
	log.debug("tid[%d]handler_logout uid[%d]\n", tid,player->uid);
	broadcast(NULL, packet.tostring());

	return 0;
}

int Table::handler_rebind(Player *player) {

	/*

	 1,remain_time  每次阶段的倒计时
	 2,isShowCard   亮牌玩家是否已经亮牌
	 3,betrange     自己下注数档

	 */
	player->stop_offline_timer();
	unicast_join_table_succ(player);

	Jpacket packet;
	packet.val["cmd"] = SERVER_REBIND_UC;
	log.debug("handler_rebind: uid[%d]state[%d] ready_players[%d]\n", player->uid,state,
			ready_players);
	Player *p;
	std::map<int, Player*>::iterator it;
	int i = 0;
	for (it = players.begin(); it != players.end(); it++) {
		p = it->second;
		packet.val["players"][i]["seatid"] = p->seatid;
		packet.val["players"][i]["uid"] = p->uid;
		packet.val["players"][i]["ready"] = p->ready;
		packet.val["players"][i]["name"] = p->name;
		packet.val["players"][i]["sex"] = p->sex;
		packet.val["players"][i]["level"] = p->level;
		packet.val["players"][i]["exp"] = p->exp;
//		packet.val["players"][i]["vip"] = p->vip;
		packet.val["players"][i]["headtime"] = p->avatar;
		packet.val["players"][i]["money"] = p->money;
		packet.val["players"][i]["coin"] = p->coin;
		packet.val["players"][i]["total_board"] = p->total_board;
		packet.val["players"][i]["total_win"] = p->total_win;
		packet.val["players"][i]["isrob"] = p->isrob;
		packet.val["players"][i]["betnum"] = p->betnum;
		packet.val["players"][i]["card_type"] = p->cardtype;
		packet.val["players"][i]["totalPoint"] = p->totalPoint;

		// 亮牌状态
		int isShowCard = 0;
		if (state == 3) {
			if (p->fight_cards.game_cards.size() > 0) {
				isShowCard = 1;
			}
			packet.val["players"][i]["isShowCard"] = isShowCard;
		}

		if (p->hole_cards.game_cards.size() == 0) {
			packet.val["players"][i]["cards"].append(0);
		} else {
			if (isShowCard == 0) {
				for (unsigned int j = 0; j < p->hole_cards.game_cards.size();
						j++) {
					packet.val["players"][i]["cards"].append(
							p->hole_cards.game_cards[j].value);
				}
			} else {
				for (unsigned int j = 0; j < p->fight_cards.game_cards.size();
						j++) {
					packet.val["players"][i]["cards"].append(
							p->fight_cards.game_cards[j].value);
				}
			}
		}
		//vector_to_json_array(seats[i].player->hole_cards.game_cards, packet, "cards");
		i++;
	}
	packet.val["vid"] = player->vid;
	packet.val["tid"] = player->tid;
	packet.val["uid"] = player->uid;
	packet.val["state"] = state;
	packet.val["dealer"] = keeper_seat; // who is keeper
	packet.val["cur_seatid"] = player->seatid;
	//S_READY = 0,
	//S_ROB,
	//S_BET,
	//S_FIGHTING,
	//S_END_GAME,
	ev_tstamp stamp = 0;

	if (state == 0) {
		stamp = ev_timer_remaining(landlord.loop, &preready_timer);
	} else if (state == 1) {
		stamp = ev_timer_remaining(landlord.loop, &rob_timer);
	} else if (state == 2) {
		stamp = ev_timer_remaining(landlord.loop, &bet_timer);
	} else if (state == 3) {
		stamp = ev_timer_remaining(landlord.loop, &fight_timer);
	} else if (state == 4) {
		//stamp = ev_timer_remaining(landlord.loop, &noPerson_timer);
		stamp = 0;
	}
	packet.val["remain_time"] = (int) stamp;
	// 下注时，下注的倍数
	if (state == 2) {
		int ratio_limit = landlord.conf["tables"]["ratio_limit"].asInt();
		get_bet_range(packet, "betrange", seats[keeper_seat],
				seats[player->seatid], ratio_limit);
	}

//	log.debug("remain_time=%d \n", (int) stamp);

	/*string out = packet.val.toStyledString().c_str();
	 log.debug("sendDataStyled: [%s]\n", out.c_str());*/
	packet.end();
	unicast(player, packet.tostring());

	return 0;
}

int Table::handler_help(Player *p) {
	if(landlord.game->help_need_money==0 || p->hasHelp ==1){
		return 0;
	}
	int useMon = base_money/2;
	p->incr_money(SUB, useMon);
	Jpacket packet;
	packet.val["cmd"] = SERVER_HELP_SUCC_UC;
	packet.val["uid"] = p->uid;
	packet.val["seatid"] = p->seatid;
	packet.val["money"] = p->money;
	packet.val["usemoney"] = useMon;
	p->hasHelp = 1;
//	log.debug("tid[%d]needhelp[%d].\n", tid,p->uid);
	packet.end();
	unicast(p, packet.tostring());
	return 0;
}

// send gifts
int Table::handler_send_gifts(Player *player) {
	int err = 0;
	std::string msg = "";

	Json::Value &val = player->client->packet.tojson();
	int uid = player->uid;
	int giftid = val["giftid"].asInt();

	//log.debug("handler_send_gifts() uid[%d] -- giftid[%d] ....", uid, giftid);

	//礼物id 1 ~ 5
	if (giftid < 1 || giftid > 5) {
		log.error("gift id[%d] error\n", giftid);
		return -1;
	}

	// 收礼座位id
	int seatid_acc = val["seatid"].asInt();
	if (seatid_acc < 0 || seatid_acc > 4) {
		log.error("receive seatid[%d] is error\n", seatid_acc);
		return -1;
	}

	//查找收礼人
	if (!seats[seatid_acc].occupied) {
		log.error("receive seatid[%d] is nobody\n", seatid_acc);
		msg = "送礼失败，收礼人已经离开。";
		send_gift_error(player, giftid, msg);
		return -1;
	}
	//收礼者id
	int uid_acc = seats[seatid_acc].player->uid;

	//查找收礼人
	if (uid_acc == uid) {
		log.error("can not give gift to self! \n", seatid_acc);
		return -1;
	}

	//查找礼物对应的金币值 、魅力值
	if (landlord.game->vgifts.size() <= 0) {
		log.error("server has no gifts data, check game init()");
		return -1;
	}

	int money = -1;
	int charm = 0;
	for (unsigned int i = 0; i < landlord.game->vgifts.size(); i++) {
		if (landlord.game->vgifts[i].gift_id == giftid) {
			money = landlord.game->vgifts[i].money;
			charm = landlord.game->vgifts[i].charm;
			break;
		}
	}

	//S_READY = 0,
	//S_ROB,
	//S_BET,
	//S_FIGHTING,
	//S_END_GAME,
	if (state == S_BET) {
		msg = "抱歉,下注期间不能送礼^^";
		err = 1;
		log.error("gift id[%d] error:state=S_BET\n", giftid);
		send_gift_error(player, giftid, msg);
		return -1;
	}
	//金币不足
	if(player->money<min_money+money){
		send_gift_error(player, giftid, "抱歉,金币不能低于准入要求,请先充值^^");
		return -1;
	}
	if ((state == S_FIGHTING) && (fight_players < cur_players)) {
		//4、凑牛~结算前夕：可送礼，但限拿下注额3倍以外的金币来送
		//int keep_money = base_money * player->betnum * typeRatio.at(keeperCardType);
		int keep_money = base_money	* player->betnum * 3;
		if (player->seatid == keeper_seat) {
			//如果是庄家送礼
			keep_money = 0;
			vector<Seat> leisureList;
			for (int i = 0; i < seatsNum; i++) {
				if (!seats[i].occupied
						|| seats[i].player->seatid == keeper_seat) {
					continue;
				}
				keep_money += base_money * seats[i].player->betnum * 3;
			}
		}

		if (player->money <= (keep_money + money)) {
			msg = "送礼后金币不够牌局结算,请先充值~";
			log.error("giftid[%d] money=%d > player.money=%d; betnum=%d\n",
					giftid, money, player->money, player->betnum);
			send_gift_error(player, giftid, msg);
			return -1;
		}
	}

	if (money >= 0) {
		//扣除送礼者的金币
		player->cur_money = money;
		player->incr_money(SUB, money);
		time_t cur_time = 0;
		time(&cur_time);
		inset_flow_log(cur_time, player->uid, AF_MONEY, SUB,"gift", player->money,
				money);
		//升级 魅力
		seats[seatid_acc].player->incr_charm(charm);

		log.debug( "acc gift: [%d][%d][%d][%d][%d]  ....\n", landlord.game->gift_money_flag,player->level,seats[seatid_acc].player->level,player->vipLevel,seats[seatid_acc].player->vipLevel);
		// acc money
		if(landlord.game->gift_money_flag == 1 && player->level>10 && seats[seatid_acc].player->level>10 &&
				player->vipLevel>0 && seats[seatid_acc].player->vipLevel>0){
			int acc_money = money * 0.9;
			seats[seatid_acc].player->incr_money(ADD, acc_money);
		}

		//log.debug( "finish charm: [%d]  ....\n", charm);

		//保存礼物	, 返回当前giftid的礼物数量
		seats[seatid_acc].player->incr_gifts(giftid);

//		log.debug("finish save gift: [%d]  ....\n", giftid);

		Jpacket packet;
		packet.val["cmd"] = SERVER_PLAYER_GIVE_GIFT_BC;
		packet.val["uid"] = player->uid;
		packet.val["giftid"] = giftid;
		packet.val["give"]["seatid"] = player->seatid;
		packet.val["give"]["money"] = player->money;
		packet.val["acc"]["seatid"] = seatid_acc;
		packet.val["acc"]["charm"] = seats[seatid_acc].player->charm;
		packet.val["acc"]["money"] = seats[seatid_acc].player->money;
		//packet.val["give"].append(0)
		packet.end();
		broadcast(NULL, packet.tostring());

	} else {
		log.error("server has no gifts data, check game init()");
		return -1;
	}
	return 0;
}

void Table::check_free_give(Player *p) {
	if (p->money < landlord.game->broke_money_limit) {
		// 玩家等级<15则补3次，>=15只补一次
		int	maxNum = p->level < 15 ? landlord.game->broke_give_num_max : 1;
		if (p->check_last_time(p->broke_time) == 1) {
			if (p->broke_num >= maxNum) {
				return;
			}
		} else {
			p->broke_num = 0;
		}
		p->up_broke_time();
		int diff = landlord.game->broke_give_to - p->money;
		diff = diff > 0 ? diff : landlord.game->broke_give_to;
		p->incr_money(ADD, diff);
		p->incr_broke_num();
		time_t cur_time = 0;
		time(&cur_time);
		inset_flow_log(cur_time, p->uid, AF_MONEY, ADD,"freeGive", p->money,
				diff);
		Jpacket packet;
		packet.val["cmd"] = SERVER_FREE_GIVE_UC;
		packet.val["uid"] = p->uid;
		packet.val["seatid"] = p->seatid;
		packet.val["currnum"] = p->broke_num;
		packet.val["maxnum"] = maxNum;
		packet.val["money"] = p->money;

		log.debug("tid[%d]broke_free_give[%d][%d].\n", tid,p->uid, diff);
		packet.end();
		unicast(p, packet.tostring());
	}
}

bool Table::isRobot(int uid) {
	if (landlord.conf["tables"]["need_rob"].asInt() == 1) {
		if (uid < landlord.conf["game"]["robotStart"].asInt()
				|| uid > landlord.conf["game"]["robotEnd"].asInt()) {
			return false;
		} else {
			return true;
		}
	} else {
		return false;
	}
}

// flag = 1 is money flag = 2 is coin
int Table::inset_flow_log(int ts, int uid, int flag, int action,string type, int curr_val, int diff_val)
{
	if(isRobot(uid)){
		return 0;
	}
	Json::Value root;
	root["uid"] = uid;
	root["tid"] = tid;
	root["vid"] = vid;
	root["ts"] = ts;
	root["type"] = type;
	root["flag"] = flag;
	root["action"] = action;
	root["cur_val"] = curr_val;
	root["diff_val"] = diff_val;

	Json::FastWriter writer;
	std::string data = landlord.logAgent.passwd + writer.write(root);
	landlord.logAgent.sendData(data);
	return 0;
}

void Table::cal_task_award(Player *p, int wOrl) {
	int is_same_day = p->check_last_time(p->lastDayTaskDate);
	if (is_same_day == 0) {
//		log.debug("$$$init taskDay time[%d][%d]~~~\n",time(NULL),p->lastDayTaskDate);
		int t = time(NULL);
		landlord.main_rc[p->index]->command("hset hu:%d lastDayTaskDate %d",
				p->uid, t);
		landlord.main_rc[p->index]->command("del hubtd:%d", p->uid);
		p->lastDayTaskDate = t;
	}
	int ret = 0;
	unsigned int tsize = landlord.game->day_tasks.size();
	if (tsize > 0) {
		for (unsigned int i = 0; i < tsize; i++) {
			ret = check_task_reach(landlord.game->day_tasks[i].task_finish_type,
					p, wOrl);
			if (ret == 1) {
				landlord.main_rc[p->index]->command("hincrby hubtd:%d t%d %d",
						p->uid, landlord.game->day_tasks[i].task_id, 1);
				/*log.debug("## day[%d][%d][%d]\n",
						landlord.game->day_tasks[i].task_id, p->uid,
						landlord.main_rc[p->index]->reply->integer);*/
			}
		}
	}

	static char buf[50];
	int bufAdd = 0;
	bufAdd += sprintf(buf, "hmset hubta:%d", p->uid);
	char kStr[20];
	landlord.main_rc[p->index]->command("hgetall hubta:%d", p->uid);
	bool bln = false;
//	landlord.main_rc[p->index]->dump_elements();
	int currVal = 0;
	tsize = landlord.game->ach_tasks.size();
	if (tsize > 0) {
		for (unsigned int i = 0; i < tsize; i++) {
			ret = check_task_reach(landlord.game->ach_tasks[i].task_finish_type,
					p, wOrl);
			if (ret == 1) {
//				log.debug("## ach[%d][%d]\n",landlord.game->ach_tasks[i].task_id,p->uid);
				sprintf(kStr, "t%d", landlord.game->ach_tasks[i].task_id);
				currVal = landlord.main_rc[p->index]->get_value_as_int(kStr);
				if (currVal < landlord.game->ach_tasks[i].task_finish_num) {
					bufAdd += sprintf(buf + bufAdd, " t%d %d",
							landlord.game->ach_tasks[i].task_id, currVal + 1);
					bln = true;
				}
			}
		}
	}
	if (bln) {
//		log.debug("&&&&buf1[%s]\n", buf);
		landlord.main_rc[p->index]->command(buf);
	}
}

int Table::check_task_reach(int taskType, Player *p, int wOrl) {
	// 任务可能会扩充，例如拿五花牛胜利的次数，五小牛胜利的次数，通杀胜利到次数....
	if (wOrl == 1) {
		if (taskType == TT_GREAT_WIN_TIMES && vid >= 3) {
			return 1;
		}else if(taskType == TT_WIN_TIMES){
			return 1;
		}else if(taskType == TT_COW_TEN && p->cardtype == CARD_TYPE_COW_TEN){
			return 1;
		}
	}
	if (taskType == TT_PLAY_TIMES) {
		return 1;
	}else if(taskType == TT_KEEPER && p->seatid == keeper_seat){
		return 1;
	}
	return 0;
}

int Table::send_gift_error(Player *player, int giftid, std::string msg) {
	Jpacket packet;
	packet.val["cmd"] = SERVER_PLAYER_GIVE_GIFT_ERR;
	packet.val["uid"] = player->uid;
	packet.val["giftid"] = giftid;
	packet.val["seatid"] = player->seatid;
	packet.val["str"] = msg;
	packet.end();
	unicast(player, packet.tostring());
	return 0;
}

int Table::incr_day_total_board(int ts, int uid) {
#if 0
	int ret;
	ret = landlord.log_rc->command("hincrby b:%d:%d total %d", ts, uid, 1);
	if (ret < 0)
	{
		log.debug("incr_day_board error.\n");
		return -1;
	}
#endif	
	return 0;
}

int Table::incr_day_win_board(int ts, int uid) {
#if 0
	int ret;
	ret = landlord.log_rc->command("hincrby b:%d:%d win %d", ts, uid, 1);
	if (ret < 0)
	{
		log.debug("incr_day_board error.\n");
		return -1;
	}
#endif	
	return 0;

}

/*
 key ts tid uid type action value

 f:ts:tid:uid


 key ts uid total win

 b:ts:uid
 */

