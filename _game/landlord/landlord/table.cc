#include "table.h"

//#include <assert.h>
//#include <curl/curl.h>
//#include <errno.h>
#include <ev.h>
//#include <fcntl.h>
#include <hiredis/hiredis.h>
#include <json/value.h>
//#include <stdarg.h>
#include <stddef.h>
//#include <stdio.h>
//#include <stdlib.h>
//#include <string.h>
//#include <sys/stat.h>
//#include <sys/types.h>
#include <time.h>
//#include <unistd.h>
//#include <algorithm>
#include <utility>
#include <algorithm>

//#include "card_find.h"
#include "client.h"
#include "game.h"
#include "landlord.h"
#include "libddz/card.h"
#include "libddz/card_analysis.h"
#include "libddz/card_type.h"
#include "libddz/community_cards.h"
#include "libddz/hole_cards.h"
#include "log.h"
#include "player.h"
#include "proto.h"
#include "redis_client.h"

extern Landlord landlord;
extern Log log;

Table::Table() :
preready_timer_stamp(9),
preplay_timer_stamp(20),
play_timer_stamp(22),
robot_timer_stamp(1.5),
rocket_timer_stamp(2),
noPerson_timer_stamp(4)
{
    preready_timer.data = this;
    ev_timer_init(&preready_timer, Table::preready_timer_cb, preready_timer_stamp,
                    preready_timer_stamp);
	
    preplay_timer.data = this;
    ev_timer_init(&preplay_timer, Table::preplay_timer_cb, preplay_timer_stamp,
                    preplay_timer_stamp);
	
    play_timer.data = this;
    ev_timer_init(&play_timer, Table::play_timer_cb, play_timer_stamp,
                    play_timer_stamp);

    robot_timer.data = this;
    ev_timer_init(&robot_timer, Table::robot_timer_cb, robot_timer_stamp,
                    robot_timer_stamp);

    rocket_timer.data = this;
    ev_timer_init(&rocket_timer, Table::rocket_timer_cb, rocket_timer_stamp,
                    rocket_timer_stamp);
    noPerson_timer.data = this;
    ev_timer_init(&noPerson_timer, Table::noPerson_timer_cb, noPerson_timer_stamp,
        			noPerson_timer_stamp);
}

Table::~Table()
{
	ev_timer_stop(landlord.loop, &preready_timer);
	ev_timer_stop(landlord.loop, &preplay_timer);
	ev_timer_stop(landlord.loop, &play_timer);
	ev_timer_stop(landlord.loop, &robot_timer);
	ev_timer_stop(landlord.loop, &rocket_timer);
	ev_timer_stop(landlord.loop, &noPerson_timer);
}

int Table::init(int my_table_id, int my_vid, int my_zid, int my_table_type, int my_min_money,
		int my_base_money)
{
	// log.debug("begin to init table [%d]\n", table_id);
	tid = my_table_id;
    vid = my_vid;
	zid = my_zid;
	table_type = my_table_type;
    min_money = my_min_money;
	base_money = my_base_money; 
	// log.debug("tables type[%d] table_type[%d] min_money[%d] base_money[%d]\n", type, table_type, min_money, base_money);
	level = 2;
	wait_time = 20;
	ready_time = 20;
    cur_players = 0;
	players.clear();
	ready_players = 0;
    for (int i = 0; i < 3; i++)
    {
        seats[i].seat_no = i;
		seats[i].occupied = false;
        seats[i].player = NULL;
    }
	
	landlord_seat = 3;
/*
	int ret;
	ret = landlord.main_rc->command("hset ro:%d online 0", type);
	if (ret < 0)
	{
		log.debug("init online error.\n");
	}
*/
	// log.debug("end to init table [%d]\n", table_id);
    return 0;
}

int Table::add_player(Player *player)
{
	if (players.find(player->uid) == players.end())
	{
		players[player->uid] = player;
		player->tid = tid;

		player->seatid = sit_down(player);
		player->ready = 0;
		if (player->seatid < 0)
		{
			return -1;
		}
		unicast_join_table_succ(player);
		cur_players++;
		// player->incr_online(type);
		
		return 0;
	}
	return -1;
}

void Table::unicast_join_table_succ(Player *player)
{
    Jpacket packet;
    packet.val["cmd"] = SERVER_JOIN_TABLE_SUCC_UC;
    packet.val["vid"] = player->vid;
    packet.val["zid"] = player->zid;
	packet.val["tid"] = player->tid;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
    packet.end();
	unicast(player, packet.tostring());
}

int Table::sit_down(Player *player)
{
    for (int i = 0; i < 3; i++)
    {
		if (!seats[i].occupied)
		{
			seats[i].occupied = true;
			seats[i].player = player;
			return i;
		}
    }
	
	return -1;
}

int Table::del_player(Player *player)
{
	if (players.find(player->uid) == players.end())
	{
		log.debug("player uid[%d] talbe del_player is error\n", player->uid);
		return -1;
	}
	if (player->ready == 1)
	{
		ready_players--;
	}
	player->stop_ready_timer();
	player->stop_offline_timer();
	// player->decr_online(type);
	players.erase(player->uid);
	stand_up(player);
	cur_players--;

	//log.debug("uid[%d]cur_players[%d]\n", player->uid, cur_players);
	
	// safe
	// ev_timer_stop(landlord.loop, &preready_timer);
	ev_timer_stop(landlord.loop, &preplay_timer);
	ev_timer_stop(landlord.loop, &play_timer);
	ev_timer_stop(landlord.loop, &robot_timer);
	ev_timer_stop(landlord.loop, &rocket_timer);

	if(cur_players==0 && ready_players==0){
//		log.debug("#########delp[%d][%d]########\n",ready_players,cur_players);
		ev_timer_stop(landlord.loop, &noPerson_timer);
	}
	return 0;
}

void Table::stand_up(Player *player)
{
	seats[player->seatid].occupied = false;
	seats[player->seatid].player = NULL;
}

void Table::del_all_players()
{
	Player *player;
	std::map<int, Player*> tmp = players;
	std::map<int, Player*>::iterator it;
	for (it = tmp.begin(); it != tmp.end(); it++)
	{
	    player = it->second;
		landlord.game->del_player(player);
	}	
}

int Table::broadcast(Player *p, const std::string &packet)
{
    Player *player;
    std::map<int, Player*>::iterator it;
    for (it = players.begin(); it != players.end(); it++)
    {
        player = it->second;
        if (player == p || player->client == NULL)
        {
            continue;
        }
        player->client->send(packet);
    }

    return 0;
}

int Table::unicast(Player *p, const std::string &packet)
{
    if (p->client)
    {
        return p->client->send(packet);
    }
    return -1;
}

void Table::wait_join_robot(int uid)
{
	if((uid<landlord.conf["game"]["robotStart"].asInt() ||
				uid>landlord.conf["game"]["robotEnd"].asInt()) &&
			landlord.conf["tables"]["need_rob"].asInt()==1){
			// no person join in,so robot in
		ev_timer_again(landlord.loop, &noPerson_timer);
	}
}

int Table::table_info_broadcast()
{
    Jpacket packet;
    packet.val["cmd"] = SERVER_TABLE_INFO_BC;
	
	Player *player;
    std::map<int, Player*>::iterator it;
	int i = 0;
    for (it = players.begin(); it != players.end(); it++)
    {
        player = it->second;
		packet.val["players"][i]["ready"] = player->ready;
	    packet.val["players"][i]["seatid"] = player->seatid;
		packet.val["players"][i]["uid"] = player->uid;
	    packet.val["players"][i]["name"] = player->name;
		packet.val["players"][i]["sex"] = player->sex;
		packet.val["players"][i]["level"] = player->level;
		packet.val["players"][i]["exp"] = player->exp;
		packet.val["players"][i]["vip"] = player->vip;
		packet.val["players"][i]["headtime"] = player->avatar;
		packet.val["players"][i]["money"] = player->money;
		packet.val["players"][i]["coin"] = player->coin;
		packet.val["players"][i]["total_board"] = player->total_board;
		packet.val["players"][i]["total_win"] = player->total_win;
		packet.val["players"][i]["charm"] = player->charm;
		packet.val["players"][i]["sign"] = player->sign;
		packet.val["players"][i]["point"] = player->point;
		std::map<int, int>::iterator it2;
		for (it2 = player->my_gifts.begin(); it2 != player->my_gifts.end();
				it2++) {
			packet.val["players"][i]["gift"].append(it2->second);
		}
		i++;
    }
	packet.val["state"] = state; // must be ready
    packet.end();
	broadcast(NULL, packet.tostring());
#if 0
	{
		state = READY;
		std::map<int, Player*>::iterator it;
		for (it = players.begin(); it != players.end(); it++)
		{
			Player *player = it->second;
			if (player->ready == 0)
			{
				player->start_ready_timer();
				player->start_offline_timer();
			}
		}
	}
#else
	{
		state = READY;
		std::map<int, Player*> temp;
		std::map<int, Player*>::iterator it;
		for (it = players.begin(); it != players.end(); it++)
		{
			Player *player = it->second;
			if (player->client)
			{
				// log.debug("uid[%d] money[%d] min_money[%d]\n", player->uid, player->money, min_money / 5);
				if (player->money < min_money)
				{
					log.debug("uid[%d] money[%d] min_money[%d] money too less.\n", player->uid, player->money, min_money);
					temp[player->uid] = player;
					player->logout_type = OUT_MONEY;
				}
				else
				{
					if (player->ready == 0)
					{
						// player->reset();
						player->start_ready_timer();
						player->start_offline_timer();
					}
				}
			}
			else // net err
			{
				temp[player->uid] = player;
				player->logout_type = OUT_NET;
			}
		}

		for (it = temp.begin(); it != temp.end(); it++)
		{
			Player *player = it->second;
			landlord.game->del_player(player);
		}
		
		ev_timer_stop(landlord.loop, &preready_timer);
	}
#endif
	// handler_game_preready();
	
	return 0;
}

void Table::preplay_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
    Table *table = (Table*)w->data;
	ev_timer_stop(landlord.loop, &table->preplay_timer);
	Player *player = table->seats[table->cur_seat].player;
	if (table->state == PREPLAY_ONE)
	{
		 table->handler_preplay_one(player, NO_CALL);
		 log.debug("preplay_timer_cb timeout PREPLAY_ONE no call\n");
	}
	else if (table->state == PREPLAY_TWO)
	{
		 table->handler_preplay_two(player, NO_CALL);
		 log.debug("preplay_timer_cb timeout PREPLAY_TWO no call\n");
	}
}

void Table::handler_game_preready()
{
	if (state != END_GAME)
	{
		log.error("handler_game_preready state[%d]\n", state);
		return;
	}
	
	// rest ready players number to zero
	ready_players = 0;
	state = READY;
	
	std::map<int, Player*> temp;
	std::map<int, Player*>::iterator it;
	for (it = players.begin(); it != players.end(); it++)
	{
		Player *player = it->second;
		player->ready = 0;
		if (player->client)
		{
			// log.debug("uid[%d] money[%d] min_money[%d]\n", player->uid, player->money, min_money / 5);
			if (player->money < min_money)
			{
				log.debug("uid[%d] money[%d] min_money[%d] money too less.\n", player->uid, player->money, min_money);
				temp[player->uid] = player;
				player->logout_type = OUT_MONEY;
			}
			else
			{
				if (player->ready == 0)
				{
					// player->reset();
					player->start_ready_timer();
					player->start_offline_timer();
				}
			}
		}
		else // net err
		{
			temp[player->uid] = player;
			player->logout_type = OUT_NET;
		}
	}
	
	for (it = temp.begin(); it != temp.end(); it++)
	{
		Player *player = it->second;
		landlord.game->del_player(player);
	}
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_GAME_PREREADY_BC;
    packet.end();
    broadcast(NULL, packet.tostring());
}

int Table::handler_game_ready(Player *player)
{
	if (state != READY)
	{
		log.error("handler_game_ready state[%d]\n", state);
		return -1;
	}

	if (player->ready == 1)
	{
		//log.debug("handler_game_ready ready_players[%d]\n", ready_players);
		/*std::map<int, Player*>::iterator it;
		for (it = players.begin(); it != players.end(); it++)
		{
			Player *p = it->second;
			log.debug("handler_game_ready uid[%d] ready[%d]\n", p->uid, p->ready);
		}*/
		log.error("player[%d] have been seted for game ready\n", player->uid);
		return -1;
	}
	player->ready = 1;
	player->stop_ready_timer();
	ready_players++;
	
	{
//		log.debug("handler_game_ready ready_players[%d]\n", ready_players);
		int temp = 0;
		std::map<int, Player*>::iterator it;
		for (it = players.begin(); it != players.end(); it++)
		{
			Player *p = it->second;
			temp += p->ready;
//			log.debug("handler_game_ready uid[%d] ready[%d]\n", p->uid, p->ready);
		}

		if (temp != ready_players)
		{
			log.error("handler_game_ready[%d] temp[%d] ready_players[%d]\n", tid, temp, ready_players);
			ready_players = temp;
			exit(1);
		}
	}
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_GAME_READY_BC;
    packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
    packet.end();
    broadcast(NULL, packet.tostring());
	
//	log.debug("player[%d] be seted for game ready ready_players[%d]\n", player->uid, ready_players);
	if (ready_players == 3)
	{
		nocall_cnt = 0;
		ready_players = 0;
		ev_timer_stop(landlord.loop, &preready_timer);
		
		std::map<int, Player*>::iterator it;
		for (it = players.begin(); it != players.end(); it++)
		{
			Player *p = it->second;
			p->reset();
		}
		start_game();
	}
	return 0;
}

int Table::start_game()
{
	log.debug("tid[%d] start game[%d][%d][%d]\n", tid,seats[0].player->uid,seats[1].player->uid,seats[2].player->uid);
//	landlord.game->dump_msg("start_game");
//	landlord.game->dump_game_info("start_game");
	reset();

	start_seat = next_seat(landlord_seat);
	cur_seat = start_seat;

	if(landlord.conf["game"]["islocal"].asInt()==1 && landlord.conf["tables"]["vid"].asInt()==3){
		deck.filltmp();
		deck.get_hole_cards_bomb(seats[0].player->hole_cards,0);
		deck.get_hole_cards_bomb(seats[1].player->hole_cards,1);
		deck.get_hole_cards_bomb(seats[2].player->hole_cards,2);
	}else{
		int rand = random(0, 1000);
		if(rand<=landlord.conf["tables"]["bomb_rand"].asInt()){
			deck.fill(tid, landlord.conf["tables"]["bomb_0"].asInt(),
								landlord.conf["tables"]["bomb_1"].asInt(),landlord.conf["tables"]["bomb_2"].asInt());
		}else if(rand>landlord.conf["tables"]["bomb_rand"].asInt() &&
				rand<=(landlord.conf["tables"]["bomb_rand"].asInt()+landlord.conf["tables"]["bomb_must_1"].asInt())){
			deck.fill(tid, 0,1000,0);
		}else{
			deck.fill(tid, 0,0,1000);
		}

		deck.shuffle(tid);
		deck.get_hole_cards_bomb(seats[0].player->hole_cards);
		deck.get_hole_cards_bomb(seats[1].player->hole_cards);
		deck.get_hole_cards_bomb(seats[2].player->hole_cards);
	}


	deck.get_community_cards(community_cards);
	
	int taskId = 0;
	if(landlord.conf["tables"]["game_type"].asInt()==1){
		gen_random_task();
		taskId = tasks.task_id;
	}
	int ret = 0;
    for (int i = 0; i < 3; i++)
    {
	    Jpacket packet;
	    packet.val["cmd"] = SERVER_GAME_START_UC;
		map_to_json_array(seats[i].player->hole_cards.cards, packet, "holes");

		if(landlord.game->matchId>0){
			seats[i].player->match_round++;
			seats[i].player->match_status = M_PLAYING;
		}
	    packet.val["uid"] = seats[i].player->uid;
		packet.val["seatid"] = seats[i].seat_no;
		// push taskid
		packet.val["taskid"] = taskId;
	    packet.end();
		unicast(seats[i].player, packet.tostring());

		ret = seats[i].player->hole_cards.task_ach_hole_card();
		if(ret == TT_HOLE_LESS_K){
//			log.debug("##Start_LESS_K[%d]\n",seats[i].player->uid);
			tasks.ach_hole_less_k.push_back(seats[i].player->uid);
		}else if(ret == TT_HOLE_NO_7){
//			log.debug("##Start_NO_7[%d]\n",seats[i].player->uid);
			tasks.ach_hole_no_7.push_back(seats[i].player->uid);
		}else if(ret == TT_HOLE_ROCKET_BOMB_2){
//			log.debug("##Start_ROCKET_BOMB_2[%d]\n",seats[i].player->uid);
			tasks.ach_hole_rocket_bomb_2 = seats[i].player->uid;
		}
    }
	cur_action = ONE_RATIO;
	
	nocall.clear();
	out_cards.clear();
	
	start_preplay_one();
	
	return 0;
}

int Table::random(int start, int end)
{
	return start + rand() % (end - start + 1);
}

/*
void Table::gen_random_task()
{
	if (landlord.conf["random-task"]["enable"].asInt() == 0)
	{
		task_type = 0;
		task_id = 0;
		return;
	}
	
	int i = random(0, 3);
	if (i == 3)
	{
		task_type = 2;
		task_id = random(101, 111);
	}
	else
	{
		int j = random(0, 1);
		if (j == 0)
		{
			task_type = 1;
			task_id = random(1, 14);	
		}
		else
		{
			task_type = 3;
			task_id = random(1, 10);
		}
	}
	
	if (task_type == 3)
	{
		if (task_id == 1)
		{
			task_card_type = CARD_TYPE_THREEWITHTWO;
		}
		else if (task_id == 2)
		{
			task_card_type = CARD_TYPE_THREEWITHONE;
		}
		else if (task_id == 3)
		{
			task_card_type = CARD_TYPE_ROCKET;
		}
		else if (task_id == 4)
		{
			task_card_type = CARD_TYPE_FOURWITHONE;
		}
		else if (task_id == 5)
		{
			task_card_type = CARD_TYPE_FOURWITHTWO;
		}
		else if (task_id == 6)
		{
			task_card_type = CARD_TYPE_ONELINE;
		}
		else if (task_id == 7)
		{
			task_card_type = CARD_TYPE_THREE;
		}
		else if (task_id == 8)
		{
			task_card_type = CARD_TYPE_BOMB;
		}
		else if (task_id == 9)
		{
			task_card_type = CARD_TYPE_TWO;
		}
		else if (task_id == 10)
		{
			task_card_type = CARD_TYPE_TWOLINE;
		}
	}
	else
	{
		int tmp = task_id;
		if (task_id >= 100)
		{
			tmp = task_id - 100;
		}
	
		if (tmp == 1)
		{
			task_card_type = CARD_TYPE_TWOLINE;
		}
		else if (tmp == 2)
		{
			task_card_type = CARD_TYPE_THREEWITHONE;
		}
		else if (tmp == 3)
		{
			task_card_type = CARD_TYPE_THREEWITHTWO;
		}
		else if (tmp == 4)
		{
			task_card_type = CARD_TYPE_FOURWITHONE;
		}
		else if (tmp == 5)
		{
			task_card_type = CARD_TYPE_FOURWITHTWO;
		}
		else if (tmp == 6)
		{
			task_card_type = CARD_TYPE_ROCKET;
		}
		else if (tmp == 7)
		{
			task_card_type = CARD_TYPE_ONELINE;
		}
		else if (tmp == 8)
		{
			task_card_type = CARD_TYPE_THREE;
		}
		else if (tmp == 9)
		{
			task_card_type = CARD_TYPE_PLANEWITHONE;
		}
		else if (tmp == 10)
		{
			task_card_type = CARD_TYPE_PLANEWITHWING;
		}
		else if (tmp == 11)
		{
			task_card_type = CARD_TYPE_THREELINE;
		}
		else if (tmp == 12)
		{
			task_card_type = CARD_TYPE_TWO;
		}
		else if (tmp == 13)
		{
			task_card_type = CARD_TYPE_ONE;
		}
		else if (tmp == 14)
		{
			task_card_type = CARD_TYPE_BOMB;
		}	
	}
}
*/

void Table::gen_random_task()
{
/*	landlord.cache_rc->command("hgetall srout");
	int task_id = landlord.cache_rc->get_value_as_int("id");
	int ind = -1;*/
	// END test

	landlord.cache_rc->command("smembers staskr:ids");
	size_t len = landlord.cache_rc->reply->elements;
	if(len<=0){
		return;
	}
	int ind = random(0,len-1);
	int task_id = ::atoi(landlord.cache_rc->reply->element[ind]->str);

	int ret = landlord.cache_rc->command("hgetall htaskr:%d", task_id);
	if (ret < 0)
	{
		log.error("gen_random_task init error, cache error.\n");
		return;
	}

	if (landlord.cache_rc->is_array_return_ok() < 0)
	{
		log.error("gen_random_task init error, data error.\n");
		return;
	}

	tasks.task_id = task_id;
//	tasks.task_type = landlord.cache_rc->get_value_as_int("ttype");
	tasks.task_finish_num = landlord.cache_rc->get_value_as_int("finishnum");
	tasks.task_award_type = landlord.cache_rc->get_value_as_int("awardtype");
	tasks.task_award_amount = landlord.cache_rc->get_value_as_int("awardmount");
	tasks.task_finish_type = landlord.cache_rc->get_value_as_int("finishtype");
	log.debug("random_task[%d][%d][%d]\n",task_id,tasks.task_finish_type,tasks.task_finish_num);
//	landlord.cache_rc->dump_elements();
}

void Table::reset()
{
	nocall.clear();
	start_seat = 0;
	cur_seat = 0;
	cur_action = 0;
	ratio = 0;
	
	one_line = 0;
	two_line = 0;
	three_line = 0;
	plane = 0;
	bomb = 0;
	rocket = 0;
	spring = 0;
	landlord_cnt = 0;
	superFace = 0;

	last_cards.clear();
	card_nums = 54;
	tasks.task_finish_players.clear();
	tasks.ach_play_once = 0;
	tasks.ach_hole_less_k.clear();
	tasks.ach_hole_no_7.clear();
	tasks.ach_hole_rocket_bomb_2 = 0;
}

void Table::vector_to_json_array(std::vector<Card> &cards, Jpacket &packet, string key)
{
	for (unsigned int i = 0; i < cards.size(); i++)
	{
//		printf("abcxxx:%d\n", cards[i].value);
		packet.val[key].append(cards[i].value);
	}

	if (cards.size() == 0)
	{
		packet.val[key].append(0);
	}
}

void Table::map_to_json_array(std::map<int, Card> &cards, Jpacket &packet, string key)
{
	std::map<int, Card>::iterator it;
	for (it = cards.begin(); it != cards.end(); it++)
	{
		Card &card = it->second;
		packet.val[key].append(card.value);
	}
}

void Table::json_array_to_vector(std::vector<Card> &cards, Jpacket &packet, string key)
{
	Json::Value &val = packet.tojson();
	
	for (unsigned int i = 0; i < val[key].size(); i++)
	{
//		printf("abcyyy:%d\n", val[key][i].asInt());
		Card card(val[key][i].asInt());
		
		cards.push_back(card);
	}
}

int Table::next_seat(int pos)
{
    for (int i = 0; i < 3; i++)
    {
        pos++;
        if (pos >= 3)
			pos = 0;
		return pos;
    }

    return -1;
}

int Table::next_seat_spec(int pos)
{
	std::set<int>::iterator it;
	
    for (int i = 0; i < 3; i++)
    {
        pos++;
        if (pos >= 3)
			pos = 0;
		
		if (nocall.find(pos) != nocall.end())
		{
			continue;
		}
		
		return pos;
    }

    return -1;
}

int Table::handler_preplay(Player *player)
{
	Json::Value &val = player->client->packet.tojson();
	int cmd = val["cmd"].asInt();
	int action = val["action"].asInt();

	if (cmd == CLIENT_PREPLAY_ONE_REQ)
	{
		if (state != PREPLAY_ONE)
		{
			log.error("current state is [%d], request cmd is CLIENT_PREPLAY_ONE_REQ\n", state);
			return -1;
		}
	}
	
	if (cmd == CLIENT_PREPLAY_TWO_REQ)
	{
		if (state != PREPLAY_TWO)
		{
			log.error("current state is [%d], request cmd is CLIENT_PREPLAY_TWO_REQ\n", state);
			return -1;
		}
	}

	Player *p = seats[cur_seat].player;
	if (p != player)
	{
		log.error("current state is [%d], cur_seat id is [%d]\n", state, cur_seat);
		if (p)
		{
			log.error("current player is [%d], Abut sumbit data is [%d]\n", p->uid, player->uid);
		}
		
		return -1;
	}
	
	if (state == PREPLAY_ONE)
	{
		handler_preplay_one(player, action);
	}
	else if (state == PREPLAY_TWO)
	{
		handler_preplay_two(player, action);
	}
	
	return 0;
}

int Table::handler_preplay_one(Player *player, int action)
{
	if (action < cur_action)
	{
		log.error("action value is low.\n");
		return -1;
	}
			
//	log.debug("PREPLAY_ONE uid[%d] action[%d] cur_action[%d]\n", player->uid, action, cur_action);
		
	if (action == ONE_RATIO)
	{
		ratio = ONE_RATIO;
		landlord_seat = cur_seat;
		cur_action = ONE_RATIO + 1;
	}
	else if (action == TWO_RATIO)
	{
		ratio = TWO_RATIO;
		landlord_seat = cur_seat;
		cur_action = TWO_RATIO + 1;
	}
	else if (action == THREE_RATIO)
	{
		ratio = THREE_RATIO;
		landlord_seat = cur_seat;
		
	    Jpacket packet;
	    packet.val["cmd"] = SERVER_PREPLAY_ONE_SUCC_BC;
	    packet.val["uid"] = player->uid;
		packet.val["seatid"] = cur_seat;
		packet.val["table_type"] = table_type;
		packet.val["action"] = action;
		packet.val["ratio"] = ratio;
		packet.val["landlord"] = landlord_seat;
	    packet.end();
	    broadcast(NULL, packet.tostring());
		
		// nobody call to restart game.
		if (ratio == 0)
		{
			nocall_cnt++;
			if (nocall_cnt > 2)
			{
				state = READY;
				del_all_players();
			}
			else
			{
				start_game();	
			}
			return 0;
		}
		nocall_cnt = 0;
		
		if (table_type == 0)
		{
			cur_action = PLAYING;
			cur_seat = start_seat = landlord_seat;
			start_play();
			return 0;
		}
		else
		{
			// 2 person no call landlord
			if (nocall.size() == 2)
			{
				cur_action = PLAYING;
				cur_seat = start_seat = landlord_seat;
				start_play();
				return 0;
			}
			
			cur_action = ROB_LANDLORD;
			landlord_seat_ori = landlord_seat;
			start_seat = next_seat(landlord_seat);
			cur_seat = start_seat;
			start_preplay_two();
			return 0;
		}
	}
	else
	{
		if (table_type == 1)
		{
			nocall.insert(player->seatid);
		}
	}
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_PREPLAY_ONE_SUCC_BC;
    packet.val["uid"] = player->uid;
	packet.val["seatid"] = cur_seat;
	packet.val["table_type"] = table_type;
	packet.val["action"] = action;
	packet.val["ratio"] = ratio;
	packet.val["landlord"] = landlord_seat;
    packet.end();
    broadcast(NULL, packet.tostring());
				
	cur_seat = next_seat(cur_seat);
	if (cur_seat == start_seat)
	{
		// nobody call to restart game.
		if (ratio == 0)
		{
			nocall_cnt++;
			if (nocall_cnt > 2)
			{
				state = READY;
				del_all_players();
			}
			else
			{
				start_game();	
			}
			return 0;
		}
		nocall_cnt = 0;
		
		if (table_type == 0)
		{
			cur_action = PLAYING;
			cur_seat = start_seat = landlord_seat;
			start_play();
			return 0;
		}
		else
		{
			// 2 person no call landlord
			if (nocall.size() == 2)
			{
				cur_action = PLAYING;
				cur_seat = start_seat = landlord_seat;
				start_play();
				return 0;
			}
			
			cur_action = ROB_LANDLORD;
			landlord_seat_ori = landlord_seat;
			start_seat = next_seat(landlord_seat);
			cur_seat = start_seat;
			start_preplay_two();
			return 0;
		}
	}
		
	start_preplay_one();
	
	return 0;
}

int Table::handler_preplay_two(Player *player, int action)
{
	if (action < cur_action)
	{
		log.error("action value is low.\n");
		return -1;
	}
		
//	log.debug("PREPLAY_TWO uid[%d] action[%d] cur_action[%d]\n", player->uid, action, cur_action);
		
	if (action == ROB_LANDLORD)
	{
		ratio *= 2;
		landlord_seat = cur_seat;
		cur_action = ROB_LANDLORD;
	}
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_PREPLAY_TWO_SUCC_BC;
    packet.val["uid"] = player->uid;
	packet.val["seatid"] = cur_seat;
	packet.val["action"] = action;
	packet.val["ratio"] = ratio;
	packet.val["landlord"] = landlord_seat;
    packet.end();
    broadcast(NULL, packet.tostring());
	
	cur_seat = next_seat_spec(cur_seat);
	if (cur_seat == start_seat || cur_seat == -1)
	{
		cur_action = PLAYING;
		cur_seat = start_seat = landlord_seat;
		start_play();
		
		return 0;
	}
	
	if (landlord_seat_ori == cur_seat)
	{
		if (landlord_seat == landlord_seat_ori)
		{
			cur_action = PLAYING;
			cur_seat = start_seat = landlord_seat;
			start_play();
		
			return 0;
		}
	}
	
	start_preplay_two();
	
	return 0;
}

int Table::start_preplay_one()
{
	state = PREPLAY_ONE;
	
	Player *player = seats[cur_seat].player;
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_PREPLAY_ONE_BC;
    packet.val["uid"] = player->uid;
	packet.val["seatid"] = cur_seat;
	packet.val["table_type"] = table_type;
	packet.val["action"] = cur_action;
    packet.end();
    broadcast(NULL, packet.tostring());
	
//	log.debug("xxxxx[%d][%d]\n", cur_seat, cur_action);
	
	ev_timer_again(landlord.loop, &preplay_timer);
	
	return 0;
}

int Table::start_preplay_two()
{
	state = PREPLAY_TWO;
	
	Player *player = seats[cur_seat].player;
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_PREPLAY_TWO_BC;
    packet.val["uid"] = player->uid;
	packet.val["seatid"] = cur_seat;
	packet.val["action"] = cur_action;
    packet.end();
    broadcast(NULL, packet.tostring());
	
    ev_timer_again(landlord.loop, &preplay_timer);
	
	return 0;
}

int Table::start_play()
{
	state = PLAYING;
	
	ev_timer_stop(landlord.loop, &preplay_timer);
	
	Player *player = seats[landlord_seat].player;
	community_cards.copy_to_hole_cards(player->hole_cards);
	
	setLandlord();
	
	time_t cur_time = 0;
	time(&cur_time);
	
	if(landlord.conf["tables"]["game_type"].asInt()==2){
		superFace = random(3,13);
	}
	int res = community_cards.get_card_type(tasks.task_finish_type,tasks.task_finish_num);
	int coin = 0;
    Jpacket packet;
    packet.val["cmd"] = SERVER_LANDLORD_BC;
	packet.val["landlord"] = landlord_seat;
	packet.val["ratio"] = ratio;
	packet.val["coin"] = player->coin;
	packet.val["cur_coin"] = coin;
	packet.val["superFace"] = superFace;
	vector_to_json_array(community_cards.cards, packet, "comms");
    packet.end();
    broadcast(NULL, packet.tostring());
	
	cur_seat = landlord_seat;
	cur_action = NEW_CARD;

	if(res>0){
		tasks.task_finish_players.push_back(player->uid);
//		log.debug("##end card[%d][%d]\n",tasks.task_finish_type,tasks.task_finish_players.size());
		Jpacket packet;
		packet.val["cmd"] = SERVER_TASK_FINISH_BC;
		packet.val["taskid"] = tasks.task_id;
		packet.val["fplayer"] = player->uid;
		packet.val["seatid"] = player->seatid;
		packet.end();
		broadcast(NULL, packet.tostring());
	}
	start_next_player();
	
	return 0;
}

void Table::setLandlord()
{
	if (landlord_seat == 0)
	{
		seats[0].player->role = LANDLORD;
		seats[1].player->role = FARMER;
		seats[2].player->role = FARMER;
	} 
	else if (landlord_seat == 1)
	{
		seats[0].player->role = FARMER;
		seats[1].player->role = LANDLORD;
		seats[2].player->role = FARMER;
	} 
	else if (landlord_seat == 2)
	{
		seats[0].player->role = FARMER;
		seats[1].player->role = FARMER;
		seats[2].player->role = LANDLORD;
	}
}

void Table::play_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
    Table *table = (Table*)w->data;
	ev_timer_stop(landlord.loop, &table->play_timer);
	Player *player = table->seats[table->cur_seat].player;
	if (table->state == PLAYING)
	{
		player->time_cnt++;
		table->handler_play_card_exec(player, 0, 0);
		log.debug("play_timer_cb timeout PLAYING no call\n");
	}
}

void Table::robot_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
    Table *table = (Table*)w->data;
	ev_timer_stop(landlord.loop, &table->robot_timer);
	Player *player = table->seats[table->cur_seat].player;
	if (table->state == PLAYING)
	{
		//int st = table->random(1,4);
		//sleep(st);
		table->handler_play_card_exec(player, 0, 1);
	}
}

void Table::noPerson_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
    Table *table = (Table*)w->data;
	if(table->state == PREPLAY_ONE){
		ev_timer_stop(landlord.loop, &table->noPerson_timer);
		return;
	}
	if(table->cur_players==3){
		return;
	}
	int diff = 3-table->cur_players;

	int ret = landlord.cache_rc->command("hgetall hrob:need");
	int currNum = 0;
	if (ret >= 0 && landlord.cache_rc->is_array_return_ok() >=0)
	{
		char kStr[10];
		sprintf(kStr,"%d",table->vid);
		currNum = landlord.cache_rc->get_value_as_int(kStr);
		if(currNum<0){
			currNum = 0;
		}
	}
	log.debug("#########join robot[%d][%d]########\n",currNum,diff);
	currNum += diff;
	ret = landlord.cache_rc->command("hset hrob:need %d %d",table->vid,currNum);
	ev_timer_stop(landlord.loop, &table->noPerson_timer);
}

//字符串分割函数
/*std::vector<std::string> Table::split(std::string str,std::string pattern)
{
    std::string::size_type pos;
    std::vector<std::string> result;
    str+=pattern;//扩展字符串以方便操作
    int size=str.size();

    for(int i=0; i<size; i++)
    {
        pos=str.find(pattern,i);
        if(pos<size)
        {
            std::string s=str.substr(i,pos-i);
            result.push_back(s);
            i=pos+pattern.size()-1;
        }
    }
    return result;
}

void Table::getUrl(string user)
{
	int ind = time(NULL)%4;
	string islandlord = "5";
	string isrob = "5";
	if(ind==0){
		islandlord = "3";
		isrob = "5";
	}else if(ind==1){
		islandlord = "3";
		isrob = "4";
	}else{}

	string cmd = landlord.conf["robotCmd"].asString()+"user="+
			user+"&passwd=123456&islandlord="+islandlord+"&isrob="+isrob;

    CURL *curl;
    CURLcode res;
    FILE *fp;
    if ((fp = fopen(landlord.conf["robotLog"].asString().c_str(), "w")) == NULL)  // 返回结果用文件存储
        return;
    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Accept: Agent-007");
    curl = curl_easy_init();    // 初始化

    if (curl)
    {
        //curl_easy_setopt(curl, CURLOPT_PROXY, "10.99.60.201:8080");// 代理
    	log.debug("#########111111########\n");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);// 改协议头
        curl_easy_setopt(curl, CURLOPT_URL,cmd.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp); //将返回的http头输出到fp指向的文件
        curl_easy_setopt(curl, CURLOPT_HEADERDATA, fp); //将返回的html主体数据输出到fp指向的文件
        res = curl_easy_perform(curl);   // 执行
        log.debug("#########2222222########\n");
        if (res != 0) {
        	log.debug("#########333333########\n");
            curl_slist_free_all(headers);
            curl_easy_cleanup(curl);
        }
        fclose(fp);
		log.debug("#########robot is [%s]########\n",cmd.c_str());
    }
}*/

void Table::rocket_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
    Table *table = (Table*)w->data;
	ev_timer_stop(landlord.loop, &table->rocket_timer);
	// Player *player = table->seats[table->cur_seat].player;
	if (table->state == PLAYING)
	{
		table->start_next_player();
//		log.debug("rocket_timer_cb\n");
	}
}

int Table::handler_play_card(Player *player)
{
	if (state != PLAYING)
	{
		log.error("handler_play_card state error\n");
		return -1;
	}
	
	Player *p = seats[cur_seat].player;
	if (p != player)
	{
		log.error("current player is [%d], Bbut sumbit data is [%d]\n", p->uid, player->uid);
		return 0;
	}
	
	Json::Value &val = player->client->packet.tojson();
	
	int action = val["action"].asInt();
	int card_type = val["card_type"].asInt();
	
	if (action != cur_action)
	{
		log.error("handler_play_card current action is error\n");
		return -1;
	}
	
	if (card_type == 0 && cur_action == NEW_CARD)
	{
		log.error("handler_play_card current card_type is error\n");
		return -1;
	}
	
	handler_play_card_exec(player, card_type, 0);
	
	return 0;
}

int Table::handler_play_card_exec(Player *player, int card_type, int flag)
{
	ev_timer_stop(landlord.loop, &play_timer);
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_PLAY_CARD_SUCC_BC;
    packet.val["uid"] = player->uid;
	packet.val["seatid"] = cur_seat;
	packet.val["action"] = cur_action;
	Json::Value::ArrayIndex i = 0;
	map<string, int> card_ana_for_task;

//	log.debug("#card_exec[%d][%d]#\n",card_type,cur_action);
	// server ai
	if (card_type == 0)
	{
		packet.val["action"] = cur_action;

		if (flag == 0)
		{
			if (cur_action == NEW_CARD)
			{
#if 1
				// search a fit card to play
				start_seat = cur_seat;
				last_cards.clear();
				// if next seat is enemy and hole_card is one,out max card
				int next_s = next_seat(cur_seat);
				int ordDesc = 0;
				if(!player->role == seats[next_s].player->role &&
						seats[next_s].player->hole_cards.size() == 1){
					ordDesc = 1;
				}
				player->hole_cards.robot(last_cards,superFace,ordDesc);

				last_playerId = player->uid;
				card_type = CardAnalysis::get_card_type(last_cards,superFace,card_ana_for_task);
				out_cards.insert(out_cards.end(), last_cards.begin(), last_cards.end());
				vector_to_json_array(last_cards, packet, "cards");
				packet.val["card_nums"] = player->hole_cards.size();
				packet.val["card_type"] = card_type;
				card_nums -= last_cards.size();
#else
				card_type = 1;
				start_seat = cur_seat;
				int value = player->hole_cards.get_one_little_card();
				Card card(value);
				last_cards.clear();
				last_cards.push_back(card);
				out_cards.insert(out_cards.end(), last_cards.begin(), last_cards.end());

				packet.val["cards"][i] = value;
				packet.val["card_nums"] = player->hole_cards.size();
				packet.val["card_type"] = card_type;
				card_nums--;
#endif
			}
			else
			{
				card_type = 0;
				packet.val["cards"][i] = 0;
				packet.val["card_nums"] = player->hole_cards.size();
				packet.val["card_type"] = card_type;
			}
		}
		else
		{
			if (cur_action == NEW_CARD)
			{
				// search a fit card to play
				start_seat = cur_seat;
				last_cards.clear();
				// if next seat is enemy and hole_card is one,out max card
				int next_s = next_seat(cur_seat);
				int ordDesc = 0;
				if(!player->role == seats[next_s].player->role &&
						seats[next_s].player->hole_cards.size() == 1){
					ordDesc = 1;
				}
				player->hole_cards.robot(last_cards,superFace,ordDesc);
				last_playerId = player->uid;
				card_type = CardAnalysis::get_card_type(last_cards,superFace,card_ana_for_task);
				out_cards.insert(out_cards.end(), last_cards.begin(), last_cards.end());
				vector_to_json_array(last_cards, packet, "cards");
				packet.val["card_nums"] = player->hole_cards.size();
				packet.val["card_type"] = card_type;
				card_nums -= last_cards.size();
			}
			else
			{
				if (player->hole_cards.size() > 20 || player->robot==3)
				{
					card_type = 0;
					packet.val["cards"][i] = 0;
					packet.val["card_nums"] = player->hole_cards.size();
					packet.val["card_type"] = card_type;
				}
				else
				{
					std::vector<Card> cur_cards;
					player->hole_cards.copy_cards(&cur_cards);
					int last_is_partner = player->role == players.at(last_playerId)->role?1:0;
//					int ret = card_find.tip(last_cards, cur_cards,players.at(last_playerId)->hole_cards.size(),last_is_partner);

					int ret = card_find.tip_super(last_cards, cur_cards,cur_card_type,superFace,players.at(last_playerId)->hole_cards.size(),last_is_partner);
					if (ret == 0)
					{
						if (card_find.results.size() > 0)
						{
							start_seat = cur_seat;
							last_cards.clear();
							last_cards = card_find.results[0];
							last_playerId = player->uid;
							card_type = CardAnalysis::get_card_type(last_cards,superFace,card_ana_for_task);
							out_cards.insert(out_cards.end(), last_cards.begin(), last_cards.end());
							player->hole_cards.remove(last_cards);
							vector_to_json_array(last_cards, packet, "cards");
							packet.val["card_nums"] = player->hole_cards.size();
							packet.val["card_type"] = card_type;
							card_nums -= last_cards.size();
						}
						else
						{
							card_type = 0;
							packet.val["cards"][i] = 0;
							packet.val["card_nums"] = player->hole_cards.size();
							packet.val["card_type"] = card_type;
						}
					}
					else
					{
						card_type = 0;
						packet.val["cards"][i] = 0;
						packet.val["card_nums"] = player->hole_cards.size();
						packet.val["card_type"] = card_type;
					}
				}
			}
		}
	}
	else
	{
		// analyse new.
		// compare analyse new and old.
		// old = new.
		player->time_cnt = 0;
		std::vector<Card> cur_cards;
		json_array_to_vector(cur_cards, player->client->packet, "cards");
		int ret = 0;
		if (cur_action == NEW_CARD)
		{
			ret = CardAnalysis::get_card_type(cur_cards,superFace,card_ana_for_task);
//			log.debug("###ret1:[%d]\n",ret);
		}
		else
		{
			ret = CardAnalysis::isGreater_super(last_cards, cur_cards,cur_card_type,superFace,card_ana_for_task);
//			log.debug("###ret2:[%d]\n",ret);
		}
		
		card_type = card_ana_for_task["type"];

		if (ret > 0)
		{
			start_seat = cur_seat;
			packet.val["action"] = cur_action;
			player->hole_cards.remove(cur_cards);

			vector_to_json_array(cur_cards, packet, "cards");
/*			if(player->uid==271){
				log.debug("sendDataStyled: [%s]\n", packet.val.toStyledString().c_str());
			}*/
			packet.val["card_nums"] = player->hole_cards.size();
			packet.val["card_type"] = card_type;
			
			last_cards.clear();
			last_cards = cur_cards;
			last_playerId = player->uid;
			out_cards.insert(out_cards.end(), last_cards.begin(), last_cards.end());
			card_nums -= cur_cards.size();
		}
		else // card err as pass
		{
			if (cur_action == NEW_CARD)
			{
				card_type = 1;
				start_seat = cur_seat;
				int value = player->hole_cards.get_one_little_card();
				Card card(value);
				last_cards.clear();
				last_cards.push_back(card);
				last_playerId = player->uid;
				out_cards.insert(out_cards.end(), last_cards.begin(), last_cards.end());
				packet.val["cards"][i] = value;
				packet.val["card_nums"] = player->hole_cards.size();
				packet.val["card_type"] = card_type;
				card_nums--;	
			}
			else
			{
				card_type = 0;
				packet.val["cards"][i] = 0;
				packet.val["card_nums"] = player->hole_cards.size();
				packet.val["card_type"] = card_type;
			}
		}
	}
	card_type_count(player, card_type);
	packet.val["ratio"] = ratio; // cur ratio
    packet.end();
    broadcast(NULL, packet.tostring());

//    log.debug("####lastType[%d][%d]\n",cur_card_type,card_type);
    if(card_type!=0){
    	cur_card_type = card_type;
    }


	if(landlord.conf["tables"]["game_type"].asInt()==1){
		cal_task_condition(player,card_ana_for_task);
	}
	// to count landlord to get spring
	if (cur_seat == landlord_seat)
	{
		if (card_type > 0)
		{
			landlord_cnt++;
		}
	}
	
	// if card nums is zero that game over.
	if (player->hole_cards.size() == 0)
	{
		game_end();
		return 0;
	}
	
	// robot
	if (card_type == CARD_TYPE_ROCKET)
	{
		cur_action = NEW_CARD;
		
		// start_next_player();
		ev_timer_again(landlord.loop, &rocket_timer);
	
		return 0;
	}
	
	if (player->time_cnt >= 2)
	{
//		log.debug("server robot [%d]\n", player->uid);
		player->time_cnt = 0;
		player->robot = 3;
		Jpacket packet;
		packet.val["cmd"] = SERVER_ROBOT_BC;
		packet.val["uid"] = player->uid;
		packet.val["seatid"] = player->seatid;
		packet.val["robot"] = player->robot;
		packet.end();
		broadcast(NULL, packet.tostring());
	}
	
	cur_seat = next_seat(cur_seat);
	if (cur_seat == start_seat)
	{
		// new card
		cur_action = NEW_CARD;
	}
	else
	{
		// follow card
		cur_action = FOLLOW_CARD;
	}
	start_next_player();
	return 0;
}

void Table::card_type_count(Player *player, int card_type)
{
	if (card_type == CARD_TYPE_ONELINE)
	{
		one_line++;
		player->one_line++;
	}
	else if (card_type == CARD_TYPE_TWOLINE)
	{
		two_line++;
		player->two_line++;
	}
	else if (card_type == CARD_TYPE_THREELINE)
	{
		three_line++;
		player->three_line++;
	}
	else if (card_type == CARD_TYPE_PLANEWITHONE)
	{
		plane++;
		player->plane++;
	}
	else if (card_type == CARD_TYPE_PLANEWITHWING)
	{
		plane++;
		player->plane++;
	}
	else if (card_type == CARD_TYPE_BOMB || card_type == CARD_TYPE_SUPERBOMB)
	{
		bomb++;
		player->bomb++;
		if(landlord.conf["tables"]["game_type"].asInt()==2){
			ratio *= 4;
		}else{
			ratio *= 2;
		}
	}
	else if (card_type == CARD_TYPE_SOFTBOMB)
	{
		bomb++;
		player->bomb++;
		if(landlord.conf["tables"]["game_type"].asInt()==2){
			ratio *= 2;
		}
	}
	else if (card_type == CARD_TYPE_ROCKET)
	{
		rocket++;
		player->rocket++;
		if(landlord.conf["tables"]["game_type"].asInt()==2){
			ratio *= 4;
		}else{
			ratio *= 2;
		}
	}
}

int Table::start_next_player()
{
	Player *player = seats[cur_seat].player;
	
	if (player->robot >= 1)
	{
//		log.debug("server robot [%d]\n", player->uid);
		player->time_cnt = 0;
//		player->robot = 1;
		//handler_play_card_exec(player, 0, 1);
		ev_timer_again(landlord.loop, &robot_timer);
		return 0;
	}
    Jpacket packet;
    packet.val["cmd"] = SERVER_PLAY_CARD_BC;
    packet.val["uid"] = player->uid;
	packet.val["seatid"] = cur_seat;
	packet.val["action"] = cur_action;
    packet.end();
    broadcast(NULL, packet.tostring());
	
	ev_timer_again(landlord.loop, &play_timer);
	
	return 0;
}

int Table::game_end()
{
//	landlord.game->dump_msg("game_end");
//	landlord.game->dump_game_info("game_end");
	ev_timer_stop(landlord.loop, &play_timer);
	
	Player *player = NULL;
	
	player = seats[cur_seat].player;
	
	if (player->role == 0)
	{
		if (landlord_cnt == 1)
		{
			spring++;
			ratio *= 2;
		}
	}
	else
	{
		if (card_nums == 34)
		{
			spring++;
			ratio *= 2;
		}
	}

	count_money(player);

	Jpacket packet;
	packet.val["cmd"] = SERVER_GAME_END_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["win_type"] = player->role; // 0 is farmer 1 is landlord
	packet.val["ratio"] = ratio;
	packet.val["plane"] = plane;
	packet.val["bomb"] = bomb;
	packet.val["rocket"] = rocket;
	packet.val["spring"] = spring;

	std::map<int, Player*>::iterator it;
	int i = 0;
	for (it = players.begin(); it != players.end(); it++)
	{
		player = it->second;
		packet.val["players"][i]["seatid"] = player->seatid;
		packet.val["players"][i]["uid"] = player->uid;
		packet.val["players"][i]["level"] = player->level;
		packet.val["players"][i]["exp"] = player->exp;
		packet.val["players"][i]["money"] = player->money;
		packet.val["players"][i]["coin"] = player->coin;
		packet.val["players"][i]["vip"] = player->vip;
		packet.val["players"][i]["cur_money"] = player->cur_money;
		packet.val["players"][i]["cur_coin"] = player->cur_coin;
		packet.val["players"][i]["cur_exp"] = player->cur_exp;
		packet.val["players"][i]["total_board"] = player->total_board;
		packet.val["players"][i]["total_win"] = player->total_win;
		packet.val["players"][i]["role"] = player->role;
		packet.val["players"][i]["point"] = player->point;
		player->match_status = M_WAITING;
		map_to_json_array_spec(player->hole_cards.cards, packet, i);
		i++;
	}
	packet.end();
	broadcast(NULL, packet.tostring());

	for (it = players.begin(); it != players.end(); it++) {
		Player *p = it->second;
		p->reset();
		//检查是否破产   破产赠送
		check_free_give(p);
	}

	state = END_GAME;
	if(landlord.game->matchId > 0){
		landlord.game->intellent_next_table(players);
	}else{
		landlord.game->check_tasks_day();
		ev_timer_again(landlord.loop, &preready_timer);
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
		p->cur_money = diff;
		p->incr_money(ADD);
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

void Table::cal_task_award(Player *p,int wOrl)
{
	if(landlord.conf["tables"]["game_type"].asInt()==1){
		// ratio
		if(wOrl == 1){
			if(tasks.task_finish_type == TT_WIN_MULT && ratio>tasks.task_finish_num){
//				log.debug("## push1 task player[%d]\n",p->uid);
				tasks.task_finish_players.push_back(p->uid);
			}
			// spring
			if(p->role==LANDLORD && tasks.task_finish_type == TT_LAND_SPRING && spring>0){
//				log.debug("## push2 task player[%d]\n",p->uid);
				tasks.task_finish_players.push_back(p->uid);
			}
			if(p->role==FARMER && tasks.task_finish_type == TT_FARMER_SPRING && spring>0){
//				log.debug("## pus3 task player[%d]\n",p->uid);
				tasks.task_finish_players.push_back(p->uid);
			}
			// win time or money
			if(tasks.task_finish_type == TT_WIN_TIME){
//				log.debug("## push4 task player[%d]\n",p->uid);
				tasks.task_finish_players.push_back(p->uid);
			}
			/*if(tasks.task_finish_type == TT_WIN_MONEY && p->cur_money>tasks.task_finish_num){
				log.debug("## push5 task player[%d]\n",p->uid);
				tasks.task_finish_players.push_back(p->uid);
			}*/
		}
		int pid = 0;
//		log.debug("## finish size[%d]\n",tasks.task_finish_players.size());
		// cal round task
		if(!tasks.task_finish_players.empty()){
			for (unsigned int i = 0; i < tasks.task_finish_players.size(); i++)
			{
				pid = tasks.task_finish_players.at(i);
				if(pid == p->uid){
					if((tasks.task_finish_type<200 || tasks.task_finish_type>300) && wOrl == 0){
						continue;
					}
					log.debug("finish round task p[%d]\n",pid);
					if(tasks.task_award_type == 0){
						players.at(pid)->cur_money += tasks.task_award_amount;
					}else if(tasks.task_award_type == 1){
						players.at(pid)->cur_coin += tasks.task_award_amount;
					}
					if(tasks.task_finish_type>200 && tasks.task_finish_type<300){
						continue;
					}
					Jpacket packet;
					packet.val["cmd"] = SERVER_TASK_FINISH_BC;
					packet.val["taskid"] = tasks.task_id;
					packet.val["fplayer"] = pid;
					packet.val["seatid"] = p->seatid;
					packet.end();
					broadcast(NULL, packet.tostring());
				}
			}
		}
	}
	// not same day cal day and ach tasks
	int is_same_day = p->check_daytask();
	if(is_same_day==0){
		landlord.main_rc[p->index]->command("hset hpe:%d lastDayTaskDate %d", p->uid, time(NULL));
		landlord.main_rc[p->index]->command("del hubtd:%d", p->uid);
	}
	int ret = 0;

	if(landlord.game->day_tasks.size()>0){
		Tasks *dt = NULL;
		std::map<int, Tasks*>::iterator it;
		for (it = landlord.game->day_tasks.begin(); it != landlord.game->day_tasks.end(); it++)
		{
			dt = it->second;
			ret = check_task_reach(dt,p,wOrl);
			if(ret==1){
//				log.debug("## day[%d][%d][%d][%d]\n",dt->task_id,p->uid,wOrl,spring);
				landlord.main_rc[p->index]->command("hincrby hubtd:%d t%d %d", p->uid, dt->task_id,1);
			}
		}
	}

	static char buf[50];
	int i = 0;
	i += sprintf(buf,"hmset hubta:%d",p->uid);

	char kStr[20];
	landlord.main_rc[p->index]->command("hgetall hubta:%d", p->uid);
	bool bln = false;
//	landlord.main_rc[p->index]->dump_elements();
	int currVal = 0;
	if(landlord.game->ach_tasks.size()>0){
		Tasks *dt = NULL;
		std::map<int, Tasks*>::iterator it;
		for (it = landlord.game->ach_tasks.begin(); it != landlord.game->ach_tasks.end(); it++)
		{
			dt = it->second;
			if(dt->task_finish_type == TT_WIN_CONT_TIME){
				sprintf(kStr,"t%d",dt->task_id);
				currVal = landlord.main_rc[p->index]->get_value_as_int(kStr);
				if(wOrl && currVal<dt->task_finish_num){
//					log.debug("NRRRR[%s][%d][%d]\n",kStr,dt->task_finish_num,currVal);
					i += sprintf(buf+i," t%d %d",dt->task_id,currVal+1);
					bln = true;
				}else if(!wOrl && currVal>0){
					i += sprintf(buf+i," t%d %d",dt->task_id,0);
					bln = true;
				}
				continue;
			}
			ret = check_task_reach(dt,p,wOrl);
			if(ret==1){
//				log.debug("## ach[%d][%d][%d][%d]\n",dt->task_id,p->uid,wOrl,spring);
//				landlord.main_rc[p->index]->command("hincrby hubta:%d t%d %d", p->uid, dt->task_id,1);
				sprintf(kStr,"t%d",dt->task_id);
				currVal = landlord.main_rc[p->index]->get_value_as_int(kStr);
				if(currVal<dt->task_finish_num){
					i += sprintf(buf+i," t%d %d",dt->task_id,currVal+1);
					bln = true;
				}
			}
		}
	}
	if(bln){
		landlord.main_rc[p->index]->command(buf);
	}
//	log.debug("&&&&buf[%s]\n",buf);
}

int Table::check_task_reach(Tasks *t,Player *p,int wOrl)
{
	if(wOrl == 1){
		if(t->task_finish_type == TT_FARMER_WIN_TIME && p->role == FARMER){
			return 1;
		}else if(t->task_finish_type == TT_LAND_WIN_TIME && p->role == LANDLORD){
			return 1;
		}else if(t->task_finish_type == TT_WIN_MONEY && (p->cur_money+p->money)>t->task_finish_num){
			return 1;
		}else if(t->task_finish_type == TT_WIN_TIME){
			return 1;
		}else if(t->task_finish_type == TT_LAND_SPRING && p->role == LANDLORD && spring > 0){
			return 1;
		}else if(t->task_finish_type == TT_FARMER_SPRING && p->role == FARMER && spring > 0){
			return 1;
		}else if(t->task_finish_type == TT_PLAY_ONCE && tasks.ach_play_once == p->uid){
			return 1;
		}
	}
	if(t->task_finish_type == TT_PLAY_TIME){
		return 1;
	}
	if(t->task_finish_type == TT_HOLE_ROCKET_BOMB_2 && tasks.ach_hole_rocket_bomb_2 == p->uid){
//		log.debug("##end_ROCKET_BOMB_2[%d]\n",p->uid);
		return 1;
	}
	if(t->task_finish_type == TT_HOLE_LESS_K && tasks.ach_hole_less_k.size()>0){
		std::vector<int>::iterator iter=std::find(tasks.ach_hole_less_k.begin(),
						tasks.ach_hole_less_k.end(),p->uid);
		if(iter!=tasks.ach_hole_less_k.end()){
//			log.debug("##end_HOLE_LESS_K[%d]\n",p->uid);
			return 1;
		}
	}
	if(t->task_finish_type == TT_HOLE_NO_7 && tasks.ach_hole_no_7.size()>0){
		std::vector<int>::iterator iter=std::find(tasks.ach_hole_no_7.begin(),
						tasks.ach_hole_no_7.end(),p->uid);
		if(iter!=tasks.ach_hole_no_7.end()){
//			log.debug("##end_HOLE_NO_7[%d]\n",p->uid);
			return 1;
		}
	}
	return 0;
}

void Table::cal_task_condition(Player *player,map<string, int> &card_ana_for_task)
{
	bool bln = false;
	if(tasks.task_finish_type == TT_PLAY_PLANE && (card_ana_for_task["type"] == CARD_TYPE_PLANEWITHONE
			|| card_ana_for_task["type"] == CARD_TYPE_PLANEWITHWING)){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_BOMB_GREAT && card_ana_for_task["type"] == CARD_TYPE_BOMB
			&& card_ana_for_task["face"]>tasks.task_finish_num){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_BOMB && card_ana_for_task["type"] == CARD_TYPE_BOMB &&
			(tasks.task_finish_num == 0 || card_ana_for_task["face"]==tasks.task_finish_num)){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_ROCKET && card_ana_for_task["type"] == CARD_TYPE_ROCKET){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_DOUB && card_ana_for_task["type"] == CARD_TYPE_TWO){
		bln = true;
	}else if(tasks.task_finish_type == TT_END_DOUB && player->hole_cards.size()==0
			 && card_ana_for_task["type"] == CARD_TYPE_TWO){
		bln = true;
	}else if(tasks.task_finish_type == TT_END_THREEBY_TWO && player->hole_cards.size()==0
			 && card_ana_for_task["type"] == CARD_TYPE_THREEWITHTWO){
		bln = true;
	}else if(tasks.task_finish_type == TT_END_THREEBY_ONE && player->hole_cards.size()==0
			 && card_ana_for_task["type"] == CARD_TYPE_THREEWITHONE){
		bln = true;
	}else if(tasks.task_finish_type == TT_END_JUNKO && player->hole_cards.size()==0
			 && card_ana_for_task["type"] == CARD_TYPE_ONELINE){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_FOURBY_TWO &&
			(card_ana_for_task["type"] == CARD_TYPE_FOURWITHTWO || card_ana_for_task["type"] == CARD_TYPE_FOURWITHONE)){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_CONT_DOUB && card_ana_for_task["type"] == CARD_TYPE_TWOLINE &&
			card_ana_for_task["len"] == tasks.task_finish_num*2){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_JUNKO_BY && card_ana_for_task["type"] == CARD_TYPE_ONELINE
			&& (card_ana_for_task["face"]+card_ana_for_task["len"] > tasks.task_finish_num)
			&& card_ana_for_task["face"] <= tasks.task_finish_num){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_JUNKO_NUM && card_ana_for_task["type"] == CARD_TYPE_ONELINE
			&& card_ana_for_task["len"] == tasks.task_finish_num){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_JUNKO_NUM_G && card_ana_for_task["type"] == CARD_TYPE_ONELINE
			&& card_ana_for_task["len"] > tasks.task_finish_num){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_KING && card_ana_for_task["mv"] >= 16){
		bln = true;
	}else if(tasks.task_finish_type == TT_PLAY_ONCE && card_ana_for_task["len"] == 20){
		tasks.ach_play_once = player->uid;
	}
/*	log.debug("##cal_task[%d][%d][%d][%d][%d][%d]##\n",card_ana_for_task["mv"],card_ana_for_task["face"],card_ana_for_task["len"],card_ana_for_task["type"],
				tasks.task_id,tasks.task_finish_type);*/
	if(bln){
		std::vector<int>::iterator iter=std::find(tasks.task_finish_players.begin(),
				tasks.task_finish_players.end(),player->uid);//返回的是一个迭代器指针
		if(iter==tasks.task_finish_players.end()){
			tasks.task_finish_players.push_back(player->uid);
//			log.debug("## push task player[%d]\n",player->uid);
		}
	}
}

void Table::count_money(Player *player)
{
	Player *landlord_player = NULL;
	Player *farmer_player[2];
	time_t cur_time = 0;
	time(&cur_time);
//	time_t ts = ((cur_time + 28800) / 86400) * 86400 - 28800;
	int coin = 0;
    
	int i = 0;
	Player *p = NULL;
	std::map<int, Player*>::iterator it;
    for (it = players.begin(); it != players.end(); it++)
    {
        p = it->second;
		if (p->role == LANDLORD) // landlord
		{
			landlord_player = p;
		}
		else
		{
			farmer_player[i] = p;
			i++;
		}
		p->get_info();
    }
	
	// to count money
	if (player->role == FARMER) // farmer win
	{
		int total_bet = ratio * base_money * 2;
		int bet = total_bet / 2;
		if (landlord_player->money < total_bet)
		{
			bet = landlord_player->money / 2;
			//log.debug("f2total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		
		total_bet = 0;
		if (farmer_player[0]->money < bet)
		{
			farmer_player[0]->cur_money = farmer_player[0]->money * 0.9; // all the money
			total_bet += farmer_player[0]->money;
			//log.debug("f3total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		else
		{
			farmer_player[0]->cur_money = bet * landlord.conf["tables"]["tax"].asDouble();
			total_bet += bet;
			//log.debug("f4total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		
		if (farmer_player[1]->money < bet)
		{
			farmer_player[1]->cur_money = farmer_player[1]->money * 0.9; // all the money
			total_bet += farmer_player[1]->money;
			//log.debug("f5total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		else
		{
			farmer_player[1]->cur_money = bet * landlord.conf["tables"]["tax"].asDouble();
			total_bet += bet;
			//log.debug("f6total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		
		inset_flow_log(cur_time, 0, AF_MONEY, ADD, "game", 0,(int)(total_bet * (1-landlord.conf["tables"]["tax"].asDouble())));
		landlord_player->cur_money = total_bet;
		
		landlord_player->cur_coin = 0;
		farmer_player[0]->cur_coin = coin;
		farmer_player[1]->cur_coin = coin;

		cal_task_award(landlord_player,0);
		cal_task_award(farmer_player[0],1);
		cal_task_award(farmer_player[1],1);

		landlord_player->incr_money(SUB);
		landlord_player->incr_coin();
		landlord_player->incr_expr(1);
		landlord_player->incr_total_board(vid, 1);
//		landlord_player->incr_pcount(1);
		inset_flow_log(cur_time, landlord_player->uid, AF_MONEY, SUB,"game", landlord_player->money, landlord_player->cur_money);
//		incr_day_total_board(ts, landlord_player->uid);
		
		farmer_player[0]->incr_money(ADD);
		farmer_player[0]->incr_coin();
		farmer_player[0]->incr_expr(3);
		farmer_player[0]->incr_total_board(vid, 1);
		farmer_player[0]->incr_total_win(vid, 1);
		farmer_player[0]->up_activity_status(ratio);
		inset_flow_log(cur_time, farmer_player[0]->uid, AF_MONEY, ADD,"game", farmer_player[0]->money,farmer_player[0]->cur_money);
//		incr_day_total_board(ts, farmer_player[0]->uid);
//		incr_day_win_board(ts, farmer_player[0]->uid);
		
		farmer_player[1]->incr_money(ADD);
		farmer_player[1]->incr_coin();
		farmer_player[1]->incr_expr(3);
		farmer_player[1]->incr_total_board(vid, 1);
		farmer_player[1]->incr_total_win(vid, 1);
		farmer_player[1]->up_activity_status(ratio);
		inset_flow_log(cur_time, farmer_player[1]->uid, AF_MONEY, ADD,"game", farmer_player[1]->money, farmer_player[1]->cur_money);
//		incr_day_total_board(ts, farmer_player[1]->uid);
//		incr_day_win_board(ts, farmer_player[1]->uid);
		
		inset_flow_log(cur_time, landlord_player->uid, AF_COIN, ADD,"game", landlord_player->coin, landlord_player->cur_coin);
		inset_flow_log(cur_time, farmer_player[0]->uid, AF_COIN, ADD,"game", farmer_player[0]->coin, farmer_player[0]->cur_coin);
		inset_flow_log(cur_time, farmer_player[1]->uid, AF_COIN, ADD,"game", farmer_player[1]->coin, farmer_player[1]->cur_coin);
		if(landlord.game->matchId>0){
			int bet = ratio * base_point;
			landlord_player->point -= bet*2;
			farmer_player[0]->point += bet;
			farmer_player[1]->point += bet;
		}
		log.debug("fwin_landlord M[%d][%d][%d] P [%d]\n",landlord_player->uid, landlord_player->money,
				landlord_player->cur_money, landlord_player->point);
		log.debug("fwin_farmer0 M[%d][%d][%d] P [%d]\n",farmer_player[0]->uid, farmer_player[0]->money,
				farmer_player[0]->cur_money, farmer_player[0]->point);
		log.debug("fwin_farmer1 M[%d][%d][%d] P [%d]\n", farmer_player[1]->uid,farmer_player[1]->money,
				farmer_player[1]->cur_money,farmer_player[1]->point);
	}
	else // landlord win
	{
		int total_bet = ratio * base_money * 2;
		int bet = total_bet / 2;
		if (landlord_player->money < total_bet)
		{
			bet = landlord_player->money / 2;
			//log.debug("l2total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		
		total_bet = 0;
		if (farmer_player[0]->money < bet)
		{
			farmer_player[0]->cur_money = farmer_player[0]->money; // all the money
			total_bet += farmer_player[0]->money;
			//log.debug("l3total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		else
		{
			farmer_player[0]->cur_money = bet;
			total_bet += bet;
			//log.debug("l4total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		
		if (farmer_player[1]->money < bet)
		{
			farmer_player[1]->cur_money = farmer_player[1]->money; // all the money
			total_bet += farmer_player[1]->money;
			//log.debug("l5total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		else
		{
			farmer_player[1]->cur_money = bet;
			total_bet += bet;
			//log.debug("l6total_bet[%d] bet[%d]\n", total_bet, bet);
		}
		
		inset_flow_log(cur_time, 0, AF_MONEY, ADD, "game",0,(int)(total_bet * (1-landlord.conf["tables"]["tax"].asDouble())));
		landlord_player->cur_money = (int)(total_bet * landlord.conf["tables"]["tax"].asDouble());
		
		landlord_player->cur_coin = coin;
		farmer_player[0]->cur_coin = 0;
		farmer_player[1]->cur_coin = 0;
		
		cal_task_award(landlord_player,1);
		cal_task_award(farmer_player[0],0);
		cal_task_award(farmer_player[1],0);

		landlord_player->incr_money(ADD);
		landlord_player->incr_coin();
		landlord_player->incr_expr(3);
		landlord_player->incr_total_board(vid, 1);
		landlord_player->incr_total_win(vid, 1);
		landlord_player->up_activity_status(ratio);
		inset_flow_log(cur_time, landlord_player->uid, AF_MONEY, ADD,  "game",landlord_player->money, landlord_player->cur_money);
//		incr_day_total_board(ts, landlord_player->uid);
//		incr_day_win_board(ts, landlord_player->uid);
		
		farmer_player[0]->incr_money(SUB);
		farmer_player[0]->incr_coin();
		farmer_player[0]->incr_expr(1);
		farmer_player[0]->incr_total_board(vid, 1);
//		farmer_player[0]->incr_pcount(1);
		inset_flow_log(cur_time, farmer_player[0]->uid, AF_MONEY, SUB, "game", farmer_player[0]->money, farmer_player[0]->cur_money);
//		incr_day_total_board(ts, farmer_player[0]->uid);
		
		farmer_player[1]->incr_money(SUB);
		farmer_player[1]->incr_coin();
		farmer_player[1]->incr_expr(1);
		farmer_player[1]->incr_total_board(vid, 1);
//		farmer_player[1]->incr_pcount(1);
		inset_flow_log(cur_time, farmer_player[1]->uid, AF_MONEY, SUB, "game", farmer_player[1]->money, farmer_player[1]->cur_money);
//		incr_day_total_board(ts, farmer_player[1]->uid);
		
		inset_flow_log(cur_time, landlord_player->uid, AF_COIN, ADD, "game", landlord_player->coin, landlord_player->cur_coin);
		inset_flow_log(cur_time, farmer_player[0]->uid, AF_COIN, ADD, "game", farmer_player[0]->coin, farmer_player[0]->cur_coin);
		inset_flow_log(cur_time, farmer_player[1]->uid, AF_COIN, ADD, "game", farmer_player[1]->coin, farmer_player[1]->cur_coin);
		if(landlord.game->matchId>0){
			int bet = ratio * base_point;
			landlord_player->point += bet*2;
			farmer_player[0]->point -= bet;
			farmer_player[1]->point -= bet;
		}

		log.debug("lwin_landlord M[%d] [%d] [%d] P [%d]\n",landlord_player->uid, landlord_player->money,
				landlord_player->cur_money, landlord_player->point);
		log.debug("lwin_farmer M[%d] [%d] [%d] P [%d]\n",farmer_player[0]->uid, farmer_player[0]->money,
				farmer_player[0]->cur_money, farmer_player[0]->point);
		log.debug("lwin_farmer M[%d] [%d] [%d] P [%d]\n", farmer_player[1]->uid,farmer_player[1]->money,
				farmer_player[1]->cur_money,farmer_player[1]->point);
	}

	// cal table rank
	if(landlord.game->matchId>0){
		if(landlord_player->point>farmer_player[0]->point &&
				landlord_player->point>farmer_player[1]->point){
			landlord_player->match_table_rank = 1;
			if(farmer_player[0]->point>farmer_player[1]->point){
				farmer_player[0]->match_table_rank = 2;
				farmer_player[1]->match_table_rank = 3;
			}else{
				farmer_player[1]->match_table_rank = 2;
				farmer_player[0]->match_table_rank = 3;
			}
		}else if(farmer_player[0]->point>landlord_player->point &&
				farmer_player[0]->point>farmer_player[1]->point){
			farmer_player[0]->match_table_rank = 1;
			if(farmer_player[1]->point>landlord_player->point){
				farmer_player[1]->match_table_rank = 2;
				landlord_player->match_table_rank = 3;
			}else{
				landlord_player->match_table_rank = 2;
				farmer_player[1]->match_table_rank = 3;
			}
		}else{
			farmer_player[1]->match_table_rank = 1;
			if(farmer_player[0]->point>landlord_player->point){
				farmer_player[0]->match_table_rank = 2;
				landlord_player->match_table_rank = 3;
			}else{
				landlord_player->match_table_rank = 2;
				farmer_player[0]->match_table_rank = 3;
			}
		}
		log.debug("end_game base[%d] ratio[%d],[%d][%d][%d]\n", base_point, ratio,landlord_player->uid,farmer_player[0]->uid,farmer_player[1]->uid);
	}else{
		log.debug("end_game base[%d] ratio[%d],[%d][%d][%d]\n", base_money, ratio,landlord_player->uid,farmer_player[0]->uid,farmer_player[1]->uid);
	}

}

void Table::map_to_json_array_spec(std::map<int, Card> &cards, Jpacket &packet, int index)
{
	std::map<int, Card>::iterator it;
	for (it = cards.begin(); it != cards.end(); it++)
	{
		Card &card = it->second;
		packet.val["players"][index]["holes"].append(card.value);
	}
}

void Table::preready_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
    Table *table = (Table*)w->data;
	ev_timer_stop(landlord.loop, &table->preready_timer);
	table->handler_game_preready();
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

int Table::handler_chat(Player *player)
{
    Json::Value &val = player->client->packet.tojson();
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_CHAT_BC;
    packet.val["uid"] = player->uid;
    packet.val["seatid"] = player->seatid;
    packet.val["str"] = val["str"];
	packet.val["tag"] = val["tag"];
    packet.end();
    broadcast(NULL, packet.tostring());
		
	return 0;
}

int Table::handler_face(Player *player)
{
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

int Table::handler_logout(Player *player)
{	
	if (state != READY && state != END_GAME)
	{
		log.error("handler_logout state[%d]\n", state);
		return -1;	
	}
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_LOGOUT_BC;
    packet.val["uid"] = player->uid;
    packet.val["seatid"] = player->seatid;
    packet.val["type"] = player->logout_type;
    packet.end();
    broadcast(NULL, packet.tostring());
		
	return 0;
}

int Table::handler_rebind(Player *player)
{
	player->stop_offline_timer();
	unicast_join_table_succ(player);
	
	player->time_cnt = 0;
	player->robot = 0;
	
    Jpacket packet;
    packet.val["cmd"] = SERVER_REBIND_UC;
	log.debug("handler_rebind: state[%d] ready_players[%d]\n", state, ready_players);
	Player *p;
    std::map<int, Player*>::iterator it;
	int i = 0;
    for (it = players.begin(); it != players.end(); it++)
    {
        p = it->second;
		packet.val["players"][i]["ready"] = p->ready;
	    packet.val["players"][i]["seatid"] = p->seatid;
		packet.val["players"][i]["uid"] = p->uid;
	    packet.val["players"][i]["name"] = p->name;
		packet.val["players"][i]["sex"] = p->sex;
		packet.val["players"][i]["level"] = p->level;
		packet.val["players"][i]["exp"] = p->exp;
//		packet.val["players"][i]["cooldou"] = p->cooldou;
		packet.val["players"][i]["money"] = p->money;
		packet.val["players"][i]["coin"] = p->coin;
		packet.val["players"][i]["vip"] = p->vip;
		packet.val["players"][i]["headtime"] = p->avatar;
		packet.val["players"][i]["total_board"] = p->total_board;
		packet.val["players"][i]["total_win"] = p->total_win;
		packet.val["players"][i]["role"] = p->role;
		packet.val["players"][i]["card_nums"] = p->hole_cards.size();
		packet.val["players"][i]["robot"] = p->robot;
		packet.val["players"][i]["charm"] = p->charm;
		packet.val["players"][i]["sign"] = p->sign;
		std::map<int, int>::iterator it2;
		for (it2 = p->my_gifts.begin(); it2 != p->my_gifts.end();
				it2++) {
			packet.val["players"][i]["gift"].append(it2->second);
		}
		i++;
    }
	
    packet.val["vid"] = player->vid;
    packet.val["zid"] = player->zid;
	packet.val["tid"] = player->tid;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["state"] = state; // must be ready
	packet.val["landlord"] = landlord_seat; // who is landlord
	packet.val["ratio"] = ratio; // cur ratio

	int taskId = 0;
	if(landlord.conf["tables"]["game_type"].asInt()==1){
//		log.debug("$$$tt[%d][%d][%d]\n",tasks.task_id,tasks.task_finish_type,tasks.task_finish_num);
		taskId = tasks.task_id;
	}
	int sFace = 0;
	if(landlord.conf["tables"]["game_type"].asInt()==2){
//		log.debug("$$$tt[%d][%d][%d]\n",tasks.task_id,tasks.task_finish_type,tasks.task_finish_num);
		sFace = superFace;
	}
	if (state == READY)
	{
		player->start_offline_timer();
		log.debug("handler_rebind READY: %d\n", state);
	}
	else if (state == PREPLAY_ONE)
	{
		log.debug("handler_rebind PREPLAY_ONE: %d\n", state);
		packet.val["table_type"] = table_type;
		packet.val["cur_seat"] = cur_seat;
		packet.val["action"] = cur_action;
		packet.val["taskid"] = taskId;
		packet.val["superFace"] = sFace;
		map_to_json_array(player->hole_cards.cards, packet, "holes");
	}
	else if (state == PREPLAY_TWO)
	{
		log.debug("handler_rebind PREPLAY_TWO: %d\n", state);
		packet.val["cur_seat"] = cur_seat;
		packet.val["action"] = cur_action;
		packet.val["taskid"] = taskId;
		packet.val["superFace"] = sFace;
		map_to_json_array(player->hole_cards.cards, packet, "holes");
	}
	else if (state == PLAYING)
	{
		log.debug("handler_rebind PLAYING: %d\n", state);
		packet.val["cur_seat"] = cur_seat;
		packet.val["action"] = cur_action;
		packet.val["taskid"] = taskId;
		packet.val["superFace"] = sFace;
		map_to_json_array(player->hole_cards.cards, packet, "holes");
		vector_to_json_array(community_cards.cards, packet, "comms");
		vector_to_json_array(out_cards, packet, "out_cards");
		if (cur_action == FOLLOW_CARD)
		{
			vector_to_json_array(last_cards, packet, "last_cards");	
		}
	}
	else if (state == END_GAME)
	{
		log.debug("handler_rebind END_GAME: %d\n", state);
	}
	/*string out = packet.val.toStyledString().c_str();
	log.debug("sendDataStyled: [%s]\n", out.c_str());*/
    packet.end();
	unicast(player, packet.tostring());
	
	return 0;
}

int Table::handler_robot(Player *player)
{
	if (state != PLAYING)
	{
		log.debug("handler_robot state[%d]\n", state);
		return -1;
	}
	
	Json::Value &val = player->client->packet.tojson();
	player->robot = val["robot"].asInt();
/*	if (player->robot != 0)
	{
		player->robot = 1;
	}*/
	player->time_cnt = 0;
	
	Jpacket packet;
	packet.val["cmd"] = SERVER_ROBOT_BC;
	packet.val["uid"] = player->uid;
	packet.val["seatid"] = player->seatid;
	packet.val["robot"] = player->robot;
	packet.end();
	broadcast(NULL, packet.tostring());
	
	if (player->robot >= 1 && cur_seat == player->seatid)
	{
		handler_play_card_exec(player, 0, 1);
	}
	
	return 0;
}

/**
 * ts:time
 * uid:user id
 * flag:0-money,1-coin...
 * action:0-ADD,1-SUB
 * type:0-game,1-gift...
 * curr_val:current value
 * diff_val:change value
 */
int Table::inset_flow_log(int ts, int uid, int flag, int action,string type, int curr_val, int diff_val)
{
	if(uid==0){
		landlord.cache_rc->command("hincrby moneystat pump %d",diff_val);
	}
	if(flag==AF_COIN && diff_val>0){
		landlord.cache_rc->command("hincrby coinstat taskRou %d",diff_val);
	}
	
	if(isRobot(uid) || diff_val==0){
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

int Table::incr_day_total_board(int ts, int uid)
{
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

int Table::incr_day_win_board(int ts, int uid)
{
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

int Table::handler_send_gifts(Player *player) {
	int err = 0;
	std::string msg = "";

	Json::Value &val = player->client->packet.tojson();
	int uid = player->uid;
	int giftid = val["giftid"].asInt();

//	log.debug("handler_send_gifts() uid[%d] -- giftid[%d] ....\n", uid, giftid);

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

	//金币不足
	if(player->money<min_money+money){
		send_gift_error(player, giftid, "抱歉,金币不能低于准入要求,请先充值^^");
		return -1;
	}

	if (money >= 0) {
		//扣除送礼者的金币
		player->cur_money = money;
		player->incr_money(SUB);
		time_t cur_time = 0;
		time(&cur_time);
		inset_flow_log(cur_time, player->uid, AF_MONEY, SUB,"gift", player->money,money);
		//升级 魅力
		seats[seatid_acc].player->incr_charm(charm);

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

		//packet.val["give"].append(0)
		packet.end();
		broadcast(NULL, packet.tostring());

	} else {
		log.error("server has no gifts data, check game init()");
		return -1;
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

void Table::set_match_point(int curr_point){
	Player *p;
	std::map<int, Player*>::iterator it;
	int i = 0;
	for (it = players.begin(); it != players.end(); it++)
	{
		p = it->second;
		p->match_base_point = curr_point;
	}
	base_point = curr_point;
}

