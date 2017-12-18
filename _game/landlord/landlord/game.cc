#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <ev.h>

#include "landlord.h"
#include "log.h"
#include "game.h"
#include "proto.h"
#include "client.h"
#include "player.h"
#include "table.h"

extern Landlord landlord;
extern Log log;

void Game::dump_game_info(char *tag)
{
#if 1
	static char buf[102400];
	int i = 0;
	i += sprintf(buf, "begin===============%s===============begin\n", tag);
    std::map<int, Table*>::iterator table_it;
    std::map<int, Client*>::iterator client_it;
    std::map<int, Player*>::iterator player_it;
    i += sprintf(buf + i, "[three_tables][%lu]\n", landlord.game->three_tables.size());
    for (table_it = landlord.game->three_tables.begin(); table_it != landlord.game->three_tables.end(); table_it++)
    {
        Table *table = table_it->second;
		i += sprintf(buf + i, "Tid[%d]state[%d] ", table_it->first, table->state);
        for (player_it = table->players.begin(); player_it != table->players.end(); player_it++)
        {
            Player *player = player_it->second;
            if (player->client)
                i += sprintf(buf + i, "uid[%d]fd[%d] ", player->uid, player->client->fd);
            else
                i += sprintf(buf + i, "uid[%d] ", player->uid);
        }
        i += sprintf(buf + i, "\n");
    }

    i += sprintf(buf + i, "[two_tables][%lu]\n", landlord.game->two_tables.size());
    for (table_it = landlord.game->two_tables.begin(); table_it != landlord.game->two_tables.end(); table_it++)
    {
        Table *table = table_it->second;
		i += sprintf(buf + i, "Tid[%d]state[%d] ", table_it->first, table->state);
        for (player_it = table->players.begin(); player_it != table->players.end(); player_it++)
        {
            Player *player = player_it->second;
            if (player->client)
                i += sprintf(buf + i, "uid[%d]fd[%d] ", player->uid, player->client->fd);
            else
                i += sprintf(buf + i, "uid[%d] ", player->uid);
        }
        i += sprintf(buf + i, "\n");
    }

    i += sprintf(buf + i, "[one_tables][%lu]\n", landlord.game->one_tables.size());
    for (table_it = landlord.game->one_tables.begin(); table_it != landlord.game->one_tables.end(); table_it++)
    {
        Table *table = table_it->second;
		i += sprintf(buf + i, "Tid[%d]state[%d] ", table_it->first, table->state);
        for (player_it = table->players.begin(); player_it != table->players.end(); player_it++)
        {
            Player *player = player_it->second;
            if (player->client)
                i += sprintf(buf + i, "uid[%d]fd[%d] ", player->uid, player->client->fd);
            else
                i += sprintf(buf + i, "uid[%d] ", player->uid);
        }
        i += sprintf(buf + i, "\n");
    }

    i += sprintf(buf + i, "[fd_client][%lu]\n", landlord.game->fd_client.size());
    for (client_it = landlord.game->fd_client.begin(); client_it != landlord.game->fd_client.end(); client_it++)
    {
        i += sprintf(buf + i, "fd[%d] ", client_it->first);
    }
	i += sprintf(buf + i, "\n");

    i += sprintf(buf + i, "[offline_players][%lu]\n", landlord.game->offline_players.size());
    for (player_it = landlord.game->offline_players.begin(); player_it != landlord.game->offline_players.end(); player_it++)
    {
        i += sprintf(buf + i, "uid[%d] ", player_it->first);
    }
	i += sprintf(buf + i, "\n");

    i += sprintf(buf + i, "[online_players][%lu]\n", landlord.game->online_players.size());
    for (player_it = landlord.game->online_players.begin(); player_it != landlord.game->online_players.end(); player_it++)
    {
        i += sprintf(buf + i, "uid[%d] ", player_it->first);
    }
	i += sprintf(buf + i, "\n");
    i += sprintf(buf + i, "end===============%s===============end\n", tag);
    log.debug("\n%s", buf);
#endif
}

Game::Game():
speaker_timer_s(10),
init_match_timer_s(landlord.conf["game"]["matchPeriod"].asInt())
{
	speaker_timer.data = this;
    ev_timer_init(&speaker_timer, Game::speaker_timer_cb, speaker_timer_s,speaker_timer_s);
    ev_timer_start(landlord.loop, &speaker_timer);

    if(landlord.conf["game"]["matchId"].asInt()>0){
    	init_match_timer.data = this;
		ev_timer_init(&init_match_timer, Game::init_match_timer_cb, init_match_timer_s,init_match_timer_s);
		ev_timer_start(landlord.loop, &init_match_timer);
    }
}

Game::~Game()
{
	ev_timer_stop(landlord.loop, &speaker_timer);
}

void Game::init_match_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
	Json::Value val;
	Json::Reader reader;

	Game *g = (Game*) w->data;

	int ret = landlord.cache_rc->command("get matchJoin:%d",g->matchId);
	if (ret < 0) {
		log.error("matchJoin init error, cache error.\n");
		return;
	}

	if (landlord.cache_rc->reply->str == NULL || strlen(landlord.cache_rc->reply->str)<=0) {
		return;
	}

	if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
		log.error("matchJoin parse error, date error.\n");
		return;
	}
	timeval tv;
	gettimeofday(&tv, NULL);
	static char buf[50];
	sprintf(buf,"%d-%d",g->matchId,tv.tv_sec);
	int ind = 0;
	int v = 0;
	string snull = "";
	MatchInfo *match = new (std::nothrow) MatchInfo();
	std::vector<Player*> joinPlayers;
	int initPoint = landlord.conf["game"]["matchInitPoint"].asInt();
	for (unsigned int i = 0; i < val.size(); i++) {
		sscanf(val[i].asCString(),"%d",&v);
		if (g->online_players.find(v) == g->online_players.end()){
//			log.debug("match player offline[%d]\n",v);
			continue;
		}
		if (g->online_players[v]->client->position == POSITION_TABLE)
		{
			log.debug("match player has in table[%d]\n",v);
			continue;
		}
		g->online_players[v]->point = initPoint;
		joinPlayers.push_back(g->online_players[v]);
		ind = v % landlord.main_size;
		landlord.main_rc[ind]->command("hmset hu:%d point %d matchKey %s",v,initPoint, buf);
		//landlord.conf["game"]["matchPlayerLimit"].asInt()
	}

	landlord.cache_rc->command("set matchJoin:%d %s",g->matchId,snull.c_str());
	if(joinPlayers.size()<=0){
		log.debug("join p is null \n");
		return;
	}
	char* ch[10];

	g->dump_game_info("ddd");
	log.debug("match start[%s][%d]\n",buf,joinPlayers.size());
	match->init(buf,joinPlayers,tv.tv_sec,landlord.conf["game"]["matchBasePoint"].asInt(),0);
	g->intellent_init_table(match);
	g->match_list[buf] = match;
}

void Game::end_match(MatchInfo *mInfo){
	mInfo->del_match_player(mInfo->joinPlayers,0);
	log.debug("match end[%s]\n",mInfo->matchKey.c_str());
}

void Game::intellent_init_table(MatchInfo *mInfo)
{
//	log.debug("vv[%s][%d][%d]\n",mInfo->matchKey.c_str(),mInfo->upTime,mInfo->joinPlayers.size());
	// TODO:check players if exist
	int pSize = mInfo->joinPlayers.size();
	if (zero_tables.size() > 0)
	{
		std::vector<int> temp;
		map<int, Table*>::iterator zero_it;
		int inc = 0;
		bool bln = false;

		for (zero_it = zero_tables.begin(); zero_it != zero_tables.end(); zero_it++)
		{
			Table *table = (*zero_it).second;
			if (table->state == END_GAME)
			{
				continue;
			}

			int tmpPoint = 0;
			for (int i = inc; i < pSize; i++)
			{
				if(mInfo->joinPlayers[i]->match_status == M_PLAYING){
					continue;
				}
//				log.debug("### [%d] [%d]\n",mInfo->joinPlayers[i]->uid,mInfo->joinPlayers[i]->match_status);
				mInfo->joinPlayers[i]->client->set_positon(POSITION_TABLE);
				mInfo->joinPlayers[i]->match_round = 0;
				mInfo->joinPlayers[i]->matchKey = mInfo->matchKey;
				mInfo->joinPlayers[i]->match_status = M_PLAYING;
				table->add_player(mInfo->joinPlayers[i]);
				tmpPoint = mInfo->cal_match_point(tmpPoint,mInfo->joinPlayers[i]->match_base_point);
				if(table->players.size()==3){
//					zero_tables.erase(zero_it);
					temp.push_back(table->tid);
					three_tables[table->tid] = table;
					table->table_info_broadcast();
					mInfo->curr_base_point = tmpPoint;
//					log.debug("curr base point[%d]..\n",tmpPoint);
					table->set_match_point(mInfo->curr_base_point);
//					log.debug("table full tid [%d]\n",table->tid);
				}
				if (inc == pSize-1) {
					if(table->players.size()!=3){
						temp.push_back(table->tid);
						if(table->players.size()==1){
							one_tables[table->tid] = table;
						}else if (table->players.size()==2) {
							two_tables[table->tid] = table;
						}
						log.debug("table nofull tid [%d]\n",table->tid);
						table->table_info_broadcast();
						table->wait_join_robot(mInfo->joinPlayers[i]->uid);
					}
					bln = true;
					break;
				}
				inc++;
				if(inc%3==0){
//					log.debug("brk [%d]\n",inc);
					break;
				}
			}
			if(bln){
				break;
			}
		}
		// erase has seat table
//		log.debug("temp[%d]~~~~~~~~\n",temp.size());
		pSize = temp.size();
		for (int i = 0; i < pSize; i++)
		{
			if(zero_tables.find(temp[i])!=zero_tables.end()){
				zero_it = zero_tables.find(temp[i]);
				zero_tables.erase(zero_it);
			}
		}
	}
}

void Game::intellent_next_table(std::map<int, Player*> players)
{
	map<int, Player*>::iterator pit = players.begin();
	Player *tempP = pit->second;

//	log.debug("aaaa[%s]~~~~~\n",tempP->matchKey.c_str());
	int matchStatus = 0;
	if(match_list.find(tempP->matchKey)!=match_list.end()){
		MatchInfo* currMatch = match_list.at(tempP->matchKey);

		// update ranklist
		currMatch->upRank();

		map<int, Player*>::iterator pit;
		Player *player = NULL;
		if(currMatch->curr_level == KNOCKOUT){
			if((currMatch->joinPlayers.size()==3 && tempP->match_round<3) ||
					(currMatch->joinPlayers.size()>3 && tempP->match_round<2)){
				log.debug("ccca~~~~~\n");
				for (pit = players.begin(); pit != players.end(); pit++)
				{
					player = pit->second;
//					log.debug("ccc[%d]~~~~~\n",player->uid);
				}
				if(three_tables.find(tempP->tid)!=three_tables.end()){
					three_tables[tempP->tid]->start_game();
//					log.debug("cccb~~~~~\n");
				}
				return;
			}
		}
		timeval tv;
		gettimeofday(&tv, NULL);
		currMatch->upTime = tv.tv_sec;

		int i = 0;
		std::vector<Player*>::iterator it;
		int currPsize = currMatch->joinPlayers.size();

		int inc = 0;
//		log.debug("dddd~~~~~\n");
		if(currPsize<landlord.conf["game"]["matchDeadLine"].asInt()){			// less than deadline,just get rise rank to next level
			// all has waiting?
//			log.debug("eeee~~~~~\n");
			for (it = currMatch->joinPlayers.begin(); it != currMatch->joinPlayers.end(); it++)
			{
				player = *it;
				if(player->match_status == M_PLAYING){
					inc++;
				}
			}
			if(inc>=3){
				log.debug("hhhhh~[%d]~~~~\n",inc);
				matchStatus = 1;
				for (it = currMatch->joinPlayers.begin(); it != currMatch->joinPlayers.end(); it++)
				{
					player = *it;
					if(!player->client || player->match_status == M_PLAYING){
						continue;
					}
					Jpacket packet;
					packet.val["cmd"] = SERVER_MATCH_WAITING_UC;
					packet.val["uid"] = player->uid;
					packet.val["point"] = player->point;
					packet.val["rank"] = player->match_total_rank;
					packet.val["currPsize"] = currPsize;
					packet.end();
					player->client->send(packet.tostring());
				}
			}else{
				if(currMatch->curr_level == PRELIMINARY){
					matchStatus = 2;
					log.debug("iiii~~~~~\n");
					currMatch->deadline_cut_off(landlord.game->matchRiseLevel[0]);
					currMatch->curr_level = KNOCKOUT;
					intellent_init_table(currMatch);
				}else{
					if(currPsize>3){
						matchStatus = 3;
						log.debug("jjjj~~~~~\n");
						currMatch->rise_next_level();
						intellent_init_table(currMatch);
					}else{
						matchStatus = -1;
						log.debug("mmmm~~~~~\n");
						end_match(currMatch);
					}
				}
			}
		}else{
			// del less point player
			// when someone point less than 0,been del
			std::vector<Player*> delPlayer;
			std::map<int, Player*> keepPlayer;
			map<int, Player*>::iterator pit;
			for (pit = players.begin(); pit != players.end(); pit++)
			{
				player = pit->second;
				if(player->money<0 || player->point<0){
					delPlayer.push_back(player);
				}else{
					keepPlayer[player->uid] = player;
				}
			}
			currMatch->del_match_player(delPlayer,0);
			for (pit = keepPlayer.begin(); pit != keepPlayer.end(); pit++)
			{
				player = pit->second;
				// leave curr table
				all_tables[tempP->tid]->del_player(player);
			}
			update_table(tempP->tid);

			for (int i = 0; i < currPsize; i++)
			{
				if(currMatch->joinPlayers[i]->match_status == M_WAITING){
					inc++;
				}
			}
//			log.debug("ffff[%d]~~~~~\n",inc);
			if(inc<=3){
				log.debug("kkkk~~~~~\n");
				// wait next game
				matchStatus = 4;
				for (pit = keepPlayer.begin(); pit != keepPlayer.end(); pit++)
				{
					player = pit->second;
					if(!player->client){
						continue;
					}
					Jpacket packet;
					packet.val["cmd"] = SERVER_MATCH_WAITING_UC;
					packet.val["uid"] = player->uid;
					packet.val["point"] = player->point;
					packet.val["rank"] = player->match_total_rank;
					packet.val["currPsize"] = currPsize;
					packet.end();
					player->client->send(packet.tostring());
				}
			}else{
				log.debug("llll~~~~~\n");
				matchStatus = 5;
				start_next_match(currMatch);
			}
		}
		log.debug("matchStatus[%d][%d][%d]~~\n",matchStatus,currMatch->joinPlayers.size(),currMatch->curr_base_point);
	}

}

void Game::start_next_match(MatchInfo *mInfo)
{
//	log.debug("next match[%s][%d][%d]\n",mInfo->matchKey.c_str(),mInfo->upTime,mInfo->joinPlayers.size());
	std::vector<Player*> waitP;
	int pSize = mInfo->joinPlayers.size();
	for (int i = 0; i < pSize; i++)
	{
		if(mInfo->joinPlayers[i]->match_status == M_WAITING){
			waitP.push_back(mInfo->joinPlayers[i]);
		}
	}
//	log.debug("wait p[%d]\n",waitP.size());
	int diff = waitP.size()%3;
	for (int i = 0; i < diff; i++)
	{
		waitP.pop_back();
	}
	pSize = waitP.size();
	if (zero_tables.size() > 0)
	{
		std::vector<int> temp;
		map<int, Table*>::iterator zero_it;
		int inc = 0;
		bool bln = false;

		for (zero_it = zero_tables.begin(); zero_it != zero_tables.end(); zero_it++)
		{
			Table *table = (*zero_it).second;
			if (table->state == END_GAME)
			{
				continue;
			}

			int tmpPoint = 0;
			for (int i = inc; i < pSize; i++)
			{
//				log.debug("### [%d] [%d]\n",waitP[i]->uid,waitP[i]->match_status);
				waitP[i]->client->set_positon(POSITION_TABLE);
				waitP[i]->match_round = 0;
				waitP[i]->match_status = M_PLAYING;
				table->add_player(waitP[i]);
				tmpPoint = mInfo->cal_match_point(tmpPoint,waitP[i]->match_base_point);
				if(table->players.size()==3){
//					zero_tables.erase(zero_it);
					temp.push_back(table->tid);
					three_tables[table->tid] = table;
					table->table_info_broadcast();
					mInfo->curr_base_point = tmpPoint;
//					log.debug("curr base point[%d]..\n",tmpPoint);
					table->set_match_point(mInfo->curr_base_point);
					log.debug("table full tid [%d]\n",table->tid);
				}
				if (inc == pSize-1) {
					bln = true;
					break;
				}
				inc++;
				if(inc%3==0){
//					log.debug("brk [%d]\n",inc);
					break;
				}
			}
			if(bln){
				break;
			}
		}
		// erase has seat table
//		log.debug("temp[%d]~~~~~~~~\n",temp.size());
		pSize = temp.size();
		for (int i = 0; i < pSize; i++)
		{
			if(zero_tables.find(temp[i])!=zero_tables.end()){
				zero_it = zero_tables.find(temp[i]);
				zero_tables.erase(zero_it);
			}
		}
	}
}

void Game::speaker_timer_cb(struct ev_loop *loop, struct ev_timer *w, int revents)
{
	Json::Value val;
	Json::Reader reader;
	int ret = landlord.cache_rc->command("get sysmess");
	if (ret < 0) {
		log.error("speaker init error, cache error.\n");
		return;
	}
	if (landlord.cache_rc->reply->str == NULL) {
		return;
	}
//	log.debug("BB222[%s]\n",landlord.cache_rc->reply->str);
	if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
		log.error("speaker parse error, date error.\n");
		return;
	}
	Game *g = (Game*) w->data;
	g->broadcastList.clear();
	timeval tv;
	gettimeofday(&tv, NULL);
//	log.debug("TT[%d]\n",val.size());
	for (unsigned int i = 0; i < val.size(); i++) {
//		log.debug("dd[%d]\n",val[i]["time"].asInt());
		if (val[i]["time"].asInt() + 10 > tv.tv_sec) {
			SysMsgInfo vsm;
			vsm.msg = val[i]["msg"].asString();
			vsm.type = val[i]["type"].asString();
			g->broadcastList.push_back(vsm);
		}
	}
//	log.debug("BB:[%d][%d]\n",tv.tv_sec,g->broadcastList.size());
	if (g->broadcastList.size() > 0) {
//		log.debug("bb[%d][%d][%d]\n",g->three_tables.size(),g->two_tables.size(),g->one_tables.size());
		for (std::map<int, Table*>::iterator it = g->three_tables.begin();
				it != g->three_tables.end(); it++) {
			//			log.debug("dy3[%d]\n",it->second->tid);
			it->second->send_speaker_bc();
		}

		for (std::map<int, Table*>::iterator it = g->two_tables.begin();
				it != g->two_tables.end(); it++) {
			//			log.debug("dy3[%d]\n",it->second->tid);
			it->second->send_speaker_bc();
		}
		for (std::map<int, Table*>::iterator it = g->one_tables.begin();
				it != g->one_tables.end(); it++) {
			//			log.debug("dy3[%d]\n",it->second->tid);
			it->second->send_speaker_bc();
		}
	}
}

int Game::start()
{
    /* first init table */
    init_config();
	init_table();
    init_accept();
    init_tasks_ach();
    init_tasks_day();
    init_gifts();
    return 0;
}

void Game::splitString(const std::string& s, std::vector<int>& v, const std::string& c){
	  std::string::size_type pos1, pos2;
	  pos2 = s.find(c);
	  pos1 = 0;
	  while(std::string::npos != pos2)
	  {
		  v.push_back(atoi(s.substr(pos1, pos2-pos1).c_str()));

		  pos1 = pos2 + c.size();
		  pos2 = s.find(c, pos1);
	  }
	  if(pos1 != s.length()){
		  v.push_back(atoi(s.substr(pos1).c_str()));
	  }
}

void Game::init_config()
{
	matchId = landlord.conf["game"]["matchId"].asInt();
	splitString(landlord.conf["game"]["matchRiseLimit"].asString(),matchRiseLevel,",");
	broke_money_limit = landlord.conf["game"]["broke_money_limit"].asInt();
	broke_give_num_max = landlord.conf["game"]["broke_give_num_max"].asInt();
	broke_give_to = landlord.conf["game"]["broke_give_to"].asInt();

	Json::Value val;
	Json::Reader reader;
	int ret = landlord.cache_rc->command("get smatchAward");
	if (ret < 0) {
		log.error("smatchAward init error, cache error.\n");
		return;
	}

	if (landlord.cache_rc->reply->str == NULL || strlen(landlord.cache_rc->reply->str)<=0) {
		log.error("smatchAward init error, date error.\n");
		return;
	}

	if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
		log.error("smatchAward parse error, str error.\n");
		return;
	}
	int size = val.size();
	for (unsigned int i = 0; i < size; i++) {
		if(matchId == val[i]["mid"].asInt()){
			AwardInfo awi;
			awi.awardType = val[i]["awardType"].asInt();
			awi.awardNum = val[i]["awardNum"].asInt();
			match_award[val[i]["rank"].asInt()] = awi;
//			log.debug("smatchAward [%d][%d][%d].\n",val[i]["rank"].asInt(),awi.awardType,awi.awardNum);
		}
	}

}

/* init table from config
 *  */
int Game::init_table()
{
	int vid = landlord.conf["tables"]["vid"].asInt();
	int zid = landlord.conf["tables"]["zid"].asInt();
	int table_type = landlord.conf["tables"]["table_type"].asInt();
	int min_money = landlord.conf["tables"]["min_money"].asInt();
	int base_money = landlord.conf["tables"]["base_money"].asInt();
	log.debug("tables vid[%d] zid[%d] table_type[%d] min_money[%d] base_money[%d]\n", 
				vid, zid, table_type, min_money, base_money);
    for (int i = landlord.conf["tables"]["begin"].asInt(); i < landlord.conf["tables"]["end"].asInt(); i++)
    {
        Table *table = new Table();
        if (table->init(i, vid, zid, table_type, min_money, base_money) < 0)
        {
            log.error("table[%d] init err\n", i);
            exit(1);
        }
        zero_tables[i] = table;
		all_tables[i] = table;
	}
    log.debug("total tables[%d]\n", zero_tables.size());
	
	return 0;
}

int Game::init_tasks_ach()
{
	int ret = landlord.cache_rc->command("lrange ltaska:ids 0 -1");
	if (ret < 0)
	{
		log.error("tasks_ach ids init error, cache error.\n");
		return -1;
	}
	if (landlord.cache_rc->is_array_return_ok() < 0)
	{
		log.error("tasks_ach ids init error, data error.\n");
		return -1;
	}
	std::vector<int> lr;
	landlord.cache_rc->get_lrange(lr);
	if(lr.size()>0){
		for (unsigned int i = 0; i < lr.size(); i++)
		{
			ret = landlord.cache_rc->command("hgetall htaska:%d",lr[i]);
			if (ret < 0)
			{
				log.error("tasks_ach init error, cache error.\n");
				return -1;
			}
			if (landlord.cache_rc->is_array_return_ok() < 0)
			{
				log.error("tasks_ach init error, data error.\n");
				return -1;
			}
			Tasks *t = new Tasks;
			t->init(landlord.cache_rc->get_value_as_int("id"),landlord.cache_rc->get_value_as_int("finishtype"),
					landlord.cache_rc->get_value_as_int("finishnum"),landlord.cache_rc->get_value_as_int("awardtype"),
					landlord.cache_rc->get_value_as_int("awardmount"));
			ach_tasks.insert(make_pair(t->task_id,t));
//			log.debug("##ach add[%d]\n",t->task_id);
		}
	}
	return 0;
}

int Game::init_tasks_day()
{
	int ret = landlord.cache_rc->command("lrange ltaskd3:ids 0 -1");
	if (ret < 0)
	{
		log.error("tasks_ach ids init error, cache error.\n");
		return -1;
	}
	if (landlord.cache_rc->is_array_return_ok() < 0)
	{
		log.error("tasks_ach ids init error, data error.\n");
		return -1;
	}
	vector<int> lr;
	landlord.cache_rc->get_lrange(lr);
	day_tasks.clear();
	if(lr.size()>0){
		for (unsigned int i = 0; i < lr.size(); i++)
		{
			ret = landlord.cache_rc->command("hgetall htaskd:%d",lr[i]);
			if (ret < 0)
			{
				log.error("tasks_day init error, cache error.\n");
				return -1;
			}
			if (landlord.cache_rc->is_array_return_ok() < 0)
			{
				log.error("tasks_day init error, data error.\n");
				return -1;
			}
			Tasks *t = new Tasks;
			t->init(landlord.cache_rc->get_value_as_int("id"),landlord.cache_rc->get_value_as_int("finishtype"),
					landlord.cache_rc->get_value_as_int("finishnum"),landlord.cache_rc->get_value_as_int("awardtype"),
					landlord.cache_rc->get_value_as_int("awardmount"));
			day_tasks.insert(make_pair(t->task_id,t));
//			log.error("##day add[%d]\n",t->task_id);
		}
	}
	lastUp_day_time = time(NULL);
//	lastUp_day_time = 1372542804;
	log.debug("##lastUp_day_time[%d]\n",lastUp_day_time);
	return 0;
}

void Game::check_tasks_day()
{
	time_t t = time(NULL);
	tm currentTime = {0};
	localtime_r(&t,&currentTime);
	tm lastTime = {0};
	localtime_r(&lastUp_day_time,&lastTime);

//	log.debug("####is_same_day[%d %d %d][%d %d %d]\n",t,currentTime.tm_mon,currentTime.tm_mday,lastUp_day_time,lastTime.tm_mon,lastTime.tm_mday);
	if(currentTime.tm_year == lastTime.tm_year && currentTime.tm_mon == lastTime.tm_mon
			&& currentTime.tm_mday == lastTime.tm_mday){
		return;
	}
	init_tasks_day();
	return;
}

int Game::init_accept()
{
    log.debug("Listening on %s:%d\n", 
            landlord.conf["game"]["host"].asString().c_str(),
            landlord.conf["game"]["port"].asInt());

    struct sockaddr_in addr;

    _fd = socket(PF_INET, SOCK_STREAM, 0);
    if (_fd < 0)
    {
    	log.error("File[%s] Line[%d]: socket failed: %s\n",
                    __FILE__, __LINE__, strerror(errno));
    }

    addr.sin_family      = AF_INET;
    addr.sin_port        = htons(landlord.conf["game"]["port"].asInt());
    addr.sin_addr.s_addr = inet_addr(landlord.conf["game"]["host"].asString().c_str());
	if (addr.sin_addr.s_addr == INADDR_NONE)
    {
		log.error("game::init_accept Incorrect ip address!");
        close(_fd);
		_fd = -1;
        exit(1);
    }

    int on = 1;
    if (setsockopt(_fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) < 0)
    {
    	log.error("File[%s] Line[%d]: setsockopt failed: %s\n",
    					__FILE__, __LINE__, strerror(errno));
        close(_fd);
        return -1;
    }

    if (bind(_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
    	log.error("File[%s] Line[%d]: bind failed: %s\n",
    					__FILE__, __LINE__, strerror(errno));
        close(_fd);
        return -1;
    }

    fcntl(_fd, F_SETFL, fcntl(_fd, F_GETFL, 0) | O_NONBLOCK);
	
    listen(_fd, 10000);

    _ev_accept.data = this;
	ev_io_init(&_ev_accept, Game::accept_cb, _fd, EV_READ);
	ev_io_start(landlord.loop, &_ev_accept);

    log.debug("listen ok\n");

    return 0;
}

void Game::accept_cb(struct ev_loop *loop, struct ev_io *w, int revents)
{
	if (EV_ERROR & revents)
	{
        log.error("got invalid event\n");
		return;
	}
	
	struct sockaddr_in client_addr;
	socklen_t client_len = sizeof(client_addr);

	int fd = accept(w->fd, (struct sockaddr *)&client_addr, &client_len);
	if (fd < 0)
	{
        log.error("accept error[%s]\n", strerror(errno));
		return;
	}
	
	fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) | O_NONBLOCK);
	
	Client *client = new (std::nothrow) Client(fd);
    Game *game = (Game*)(w->data);
    if (client)
    {
        game->fd_client[fd] = client;
    }
    else close(fd);
}

void Game::del_client(Client *client)
{
    if (fd_client.find(client->fd) == fd_client.end())
    {
        log.error("free client err[miss]\n");
        return;
    }

//	dump_msg("del_client begin");
//    log.debug("@@@delete client aaa[%d]\n",client->uid);
    fd_client.erase(client->fd);

	if (client->player)
	{
		Player *player = client->player;

		// if in match
		if(player->logout_type == OUT_SELF && player->matchKey.length()>0){
			if(match_list.find(player->matchKey)!=match_list.end()){
				MatchInfo* currMatch = match_list.at(player->matchKey);
				int diff = currMatch->joinPlayers.size();
				std::vector<Player*> tempPl;
				bool bln = false;
				for(int i=0;i<diff;i++){
					if(currMatch->joinPlayers[i]->uid == player->uid){
						log.debug("###self logout[%d].\n",currMatch->joinPlayers[i]->uid);
						bln = true;
					}else{
						tempPl.push_back(currMatch->joinPlayers[i]);
					}
				}
				if(bln){
					currMatch->joinPlayers = tempPl;
				}
			}
		}
		if (client->position == POSITION_WAIT)
		{
//			log.debug("@@@delete client1111[%d][%d]\n", player->uid,player->logout_type);
			if (offline_players.find(player->uid) != offline_players.end())
		    {
		        offline_players.erase(player->uid);
//		        log.debug("delete player[%d] offline\n", player->uid);
		    }
	
			if (online_players.find(player->uid) != online_players.end())
		    {
		        online_players.erase(player->uid);
//		        log.debug("delete player[%d] online\n", player->uid);
		    }
			
			delete player;
		}
		else if (client->position == POSITION_TABLE)
		{
//			log.debug("@@@delete client2222[%d][%d]\n", player->uid,player->logout_type);
			if (online_players.find(player->uid) != online_players.end())
		    {
		        online_players.erase(player->uid);
				offline_players[player->uid] = client->player;
				// player->start_offline_timer();
				player->client = NULL;
//		        log.debug("delete player[%d] online and add this uid to offline\n", player->uid);
		    }
			client->player->client = NULL;
		}
	}
	delete client;
//	dump_game_info("del client end");
//	dump_msg("del_client end");
}

int Game::dispatch(Client *client)
{
	client->cmd_type = 0;
    int cmd = client->packet.test();
//    log.debug("comd %d\n", cmd);
	if (cmd < 0)
	{
		log.error("the cmd format is error.\n");
		return -1;
	}

    if (cmd == SYS_ECHO)
    {
        Jpacket packet;
        packet.val = client->packet.val;
        packet.end();
        return client->send(packet.tostring());
    }

    if (cmd == SYS_ONLINE)
    {
    	client->cmd_type = 1;
        Jpacket packet;
        packet.val["cmd"] = SYS_ONLINE;
        packet.val["online"] = (int)(online_players.size() + offline_players.size());
        packet.end();
        return client->send(packet.tostring());
    }
	
	if (cmd == CLIENT_HEART_BEAT)
	{
		return 0;
	}
	
	if (cmd == CLIENT_JOIN_TABLE_REQ)
	{
		if (client->player == NULL)
		{
			int ret = add_player(client);
			if (ret == -1)
			{
				return -1;
			} else if (ret == 1) {
				return 0;
			} else if (ret == 2) {
				return 0;
			}else if (ret == -2) {
				Jpacket packet;
				packet.val["cmd"] = SERVER_JOIN_TABLE_ERR_UC;
				packet.val["code"] = 3;
				packet.val["msg"] = "need update";
				packet.end();
				client->send(packet.tostring());
				return -1;
			}
			return handler_join_table(client);
		}
		log.error("CLIENT_JOIN_TABLE_REQ player must be NULL.\n");
		return -1;
	}
		
	if (safe_check(client, cmd) < 0)
	{
		return -1;
	}
	
    Player *player = client->player;

    /* dispatch */
    switch (cmd)
    {
    case CLIENT_GAME_READY_REQ:
        all_tables[player->tid]->handler_game_ready(player);
        break;
	case CLIENT_PREPLAY_ONE_REQ:
		all_tables[player->tid]->handler_preplay(player);
		break;
	case CLIENT_PREPLAY_TWO_REQ:
		all_tables[player->tid]->handler_preplay(player);
		break;
	case CLIENT_PLAY_CARD_REQ:
		all_tables[player->tid]->handler_play_card(player);
		break;
	case CLIENT_CHAT_REQ:
		all_tables[player->tid]->handler_chat(player);
		break;
	case CLIENT_FACE_REQ:
		all_tables[player->tid]->handler_face(player);
		break;
	case CLIENT_LOGOUT_REQ:
		player->logout_type = OUT_SELF;
		del_player(player);
		break;
	case CLIENT_ROBOT_REQ:
		all_tables[player->tid]->handler_robot(player);
		break;
	case CLIENT_PLAYER_GIVE_GIFT_REQ:	// 牌桌中送礼
		all_tables[player->tid]->handler_send_gifts(player);
		break;
    default:
        log.error("invalid command[%d]\n", cmd);
        return -1;
    }
	
    // log.debug("dispatch succ\n");
    return 0;
}

int Game::safe_check(Client *client, int cmd)
{
	if (online_players.find(client->uid) == online_players.end())
	{
		log.error("player[%d] must be online player.\n", client->uid);
		return -1;
	}
	
	Player *player = client->player;
	if (all_tables.find(player->tid) == all_tables.end())
	{
		log.error("safe_check uid[%d] is not in table[%d]\n", player->uid, player->tid);
		return -1;
	}
	
	return 0;
}

int Game::handler_join_table(Client *client)
{
//	dump_game_info("handler_join_table");
//	dump_msg("handler_join_table");
	if(matchId>0){
//		log.debug("curr online match player %d %d \n",matchId,online_players.size());
		return 0;
	}

	Player *player = client->player;

    if (client->position == POSITION_TABLE)
    {
    	log.debug("handler_join_table uid[%d] have been in table\n", player->uid);
        return -1;
    }

	if (two_tables.size() > 0)
	{
		map<int, Table*>::iterator two_it;
		for (two_it = two_tables.begin(); two_it != two_tables.end(); two_it++)
		{
			// two_it = two_tables.begin();
			Table *table = (*two_it).second;
			if (table->state == END_GAME)
			{
				continue;
			}
			if (table->players.find(player->uid) != table->players.end())
			{
				log.debug("handler_join_table uid[%d] is in table[%d]\n", player->uid, table->tid);
				return -1;
			}
			two_tables.erase(two_it);
			three_tables[table->tid] = table;
			
			client->set_positon(POSITION_TABLE);
			table->add_player(client->player);
			
			table->table_info_broadcast();
			table->wait_join_robot(client->player->uid);
//			dump_msg("handler_join_table end");
//			dump_game_info("handler_join_table end");
			return 0;
		}
	}
	
	if (one_tables.size() > 0)
	{
//		log.debug("one_tables.size() > 0 && wait_queue.size() > 0\n");

		map<int, Table*>::iterator one_it;
		for (one_it = one_tables.begin(); one_it != one_tables.end(); one_it++)
		{
			Table *table = (*one_it).second;
			if (table->state == END_GAME)
			{
				continue;
			}
			if (table->players.find(player->uid) != table->players.end())
			{
				log.debug("handler_join_table uid[%d] is in table[%d]\n", player->uid, table->tid);
				return -1;
			}
			one_tables.erase(one_it);
			two_tables[table->tid] = table;
			
			client->set_positon(POSITION_TABLE);
			table->add_player(client->player);
			
			table->table_info_broadcast();
			table->wait_join_robot(client->player->uid);
//			dump_msg("handler_join_table end");
//			dump_game_info("handler_join_table end");
			return 0;
		}
	}
	
	if (zero_tables.size() > 0)
	{
//		log.debug("zero_tables.size() > 0 && wait_queue.size() > 1\n");
			
		map<int, Table*>::iterator zero_it;
		for (zero_it = zero_tables.begin(); zero_it != zero_tables.end(); zero_it++)
		{
			Table *table = (*zero_it).second;
			if (table->state == END_GAME)
			{
				continue;
			}
			if (table->players.find(player->uid) != table->players.end())
			{
				log.debug("handler_join_table uid[%d] is in table[%d]\n", player->uid, table->tid);
				return -1;
			}
			zero_tables.erase(zero_it);
			one_tables[table->tid] = table;
			
			client->set_positon(POSITION_TABLE);
			table->add_player(client->player);
			
			table->table_info_broadcast();

//			dump_msg("handler_join_table end");
//			dump_game_info("handler_join_table end");
			table->wait_join_robot(client->player->uid);
			return 0;
		}
	}
	

	log.error("no seat\n");
	return -1;
}

int Game::update_table(int tid)
{
//	dump_game_info("update table 0");
	map<int, Table*>::iterator it;
	it = all_tables.find(tid);
	if (it == all_tables.end())
	{
		return -1;
	}
	Table *table = (*it).second;
	
	it = three_tables.find(tid);
	if (it != three_tables.end())
	{
		three_tables.erase(it);
		two_tables[tid] = table;
//		dump_msg("update table 1");
//		dump_game_info("update table 1");
		return 0;
	}
	
	it = two_tables.find(tid);
	if (it != two_tables.end())
	{
		two_tables.erase(it);
		one_tables[tid] = table;
//		dump_msg("update table 2");
//		dump_game_info("update table 2");
		return 0;
	}
	
	it = one_tables.find(tid);
	if (it != one_tables.end())
	{
		one_tables.erase(it);
		zero_tables[tid] = table;
//		dump_msg("update table 3");
//		dump_game_info("update table 3");
		return 0;
	}
	
	return -1;
}

int Game::send_error(Client *client, int cmd, int error_code)
{
    Jpacket error;
    error.val["cmd"] = cmd;
    error.val["err"] = error_code;
    error.end();
    return client->send(error.tostring());
}

void Game::dump_msg(string msg)
{
	log.debug("%s zero[%d] one[%d] two[%d] three[%d] fd_client[%d] offline[%d] online[%d]\n",
			msg.c_str(), zero_tables.size(), one_tables.size(), two_tables.size(), three_tables.size(),
			fd_client.size(), offline_players.size(), online_players.size());	
}

int Game::check_skey(Client *client)
{
	if (client->uid < 5000)
	{
		return 0;
	}
	int i = client->uid % landlord.main_size;
	int ret = landlord.main_rc[i]->command(" hget hu:%d skey", client->uid);
	if (ret < 0)
	{
		log.debug("player init error, because get player infomation error.\n");
		return -1;
	}
#if 1
//	log.debug("skey1 [%d] [%s] [%s]\n", client->uid,client->skey.c_str(), landlord.main_rc[i]->reply->str);
	if (landlord.main_rc[i]->reply->str && client->skey.compare(landlord.main_rc[i]->reply->str) != 0)
	{
		log.error("skey2 [%d] [%s] [%s]\n", client->uid,client->skey.c_str(), landlord.main_rc[i]->reply->str);
		return -1;
	}
#endif	
	return 0;
}

int Game::add_player(Client *client)
{
    Json::Value &val = client->packet.tojson();
    int uid = val["uid"].asInt();
	client->uid = uid;
	client->skey = val["skey"].asString();
	client->vid = val["vid"].asInt();
	client->zid = val["zid"].asInt();
	client->version = val["ver"].asString();

	if(uid<landlord.conf["game"]["robotStart"].asInt() ||
					uid>landlord.conf["game"]["robotEnd"].asInt()){
		if (check_skey(client) < 0)
		{
			return -1;
		}
		string minV = landlord.conf["tables"]["min_version"].asString();
		double dMinv = atof(minV.c_str());
		double dCv = atof(client->version.c_str());
//		log.debug("ct:[%g][%g][%d]\n",dMinv,dCv,strlen(client->version.c_str()));
		if(dMinv!=0 && (strlen(client->version.c_str())==0 || dMinv>dCv)){
			return -2;
		}
	}

	/* rebind by online */
    if (online_players.find(uid) != online_players.end())
    {
#if 1
        log.debug("player[%d] rebind by online get info ok\n", uid);
		Player *player = online_players[uid];
		if (all_tables.find(player->tid) == all_tables.end())
		{
			log.error("rebind by online uid[%d] is not in table[%d]\n", player->uid, player->tid);
			return -1;
		}
		Client *oldClient = player->client;
        player->set_client(client);
		client->set_positon(POSITION_TABLE);
		all_tables[player->tid]->handler_rebind(player);
	    fd_client.erase(oldClient->fd);
		delete oldClient;
//		dump_game_info("rebind by online");

        return 2;
#endif
        // return -1;
    }
	
    /* rebind by offline */
    if (offline_players.find(uid) != offline_players.end())
    {
        log.debug("player[%d] rebind by offline get info ok\n", uid);
		
		Player *player = offline_players[uid];
		if (all_tables.find(player->tid) == all_tables.end())
		{
			log.error("rebind by offline uid[%d] is not in table[%d]\n", player->uid, player->tid);
			return -1;
		}
        offline_players.erase(uid);
        online_players[uid] = player;
		
        player->set_client(client);
		client->set_positon(POSITION_TABLE);
		all_tables[player->tid]->handler_rebind(player);
//		dump_game_info("rebind by offline");
        return 1;
    }

    /* set player info */
    Player *player = new (std::nothrow) Player();
    if (player == NULL)
    {
        log.error("new player err");
        return -1;
    }
	
    player->set_client(client);
	int ret = player->init();
	if (ret < 0)
		return -1;
    online_players[uid] = player;
    log.debug("player[%d] login success on game.cc\n", uid);

    return 0;
}

int Game::del_player(Player *player)
{
	int ret;
	
	ret = all_tables[player->tid]->handler_logout(player);
	if (ret < 0)
	{
		log.debug("del_player handler_logout\n");
		return -1;	
	}
	
	ret = all_tables[player->tid]->del_player(player);
	if (ret < 0)
	{
		log.debug("del_player del_player\n");
		return -1;	
	}
	
	ret = update_table(player->tid);
	if (ret < 0)
	{
		log.debug("del_player update_table\n");
		return -1;	
	}

	if (offline_players.find(player->uid) != offline_players.end())
    {
        offline_players.erase(player->uid);
//        log.debug("delete player[%d] offline\n", player->uid);
    }
	
	if (online_players.find(player->uid) != online_players.end())
    {
        online_players.erase(player->uid);
//        log.debug("delete player[%d] online\n", player->uid);
    }
	
	if (player->client)
	{
		Client *client = player->client;
		client->position = POSITION_WAIT;
		Client::pre_destroy(client);
		client->player = NULL;
		delete player;
		return 0;
	}
	
    delete player;
//	dump_msg("del_player end");
//	dump_game_info("del_player");
    return 0;
}

/* init vgifts */
int Game::init_gifts() {
	vgifts.clear();
	//5 个礼物
	for (unsigned int i = 1; i <= 5; i++) {
		int ret = landlord.cache_rc->command("hgetall hgift:%d", i);
		if (ret < 0) {
			log.error("gifts init error, cache error.\n");
			return -1;
		}
		if (landlord.cache_rc->is_array_return_ok() < 0) {
			log.error("gifts init error, data error.\n");
			return -1;
		}

		Gifts gi;
		gi.init(landlord.cache_rc->get_value_as_int("gift_id"),
				landlord.cache_rc->get_value_as_int("money"),
				landlord.cache_rc->get_value_as_int("charm"));

		vgifts.push_back(gi);

		log.debug("gift_id[%d],money[%d],charm[%d] \n",
				landlord.cache_rc->get_value_as_int("gift_id"),
				landlord.cache_rc->get_value_as_int("money"),
				landlord.cache_rc->get_value_as_int("charm"));
	}

	//log.debug("total gifts[%d]\n", vgifts.size());

	return 0;
}
