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

#include "bullfighting.h"
#include "log.h"
#include "game.h"
#include "proto.h"
#include "client.h"
#include "player.h"
#include "table.h"

extern Bullfighting landlord;
extern Log log;

Game::Game() :
		speaker_timer_s(10) {
	speaker_timer.data = this;
	ev_timer_init(&speaker_timer, Game::speaker_timer_cb, speaker_timer_s,
			speaker_timer_s);
	ev_timer_start(landlord.loop, &speaker_timer);
}

Game::~Game() {
	ev_timer_stop(landlord.loop, &speaker_timer);
}

void Game::speaker_timer_cb(struct ev_loop *loop, struct ev_timer *w,
		int revents) {
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

	for (unsigned int i = 0; i < val.size(); i++) {
		// TODO:just show some type
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
		//		log.debug("yy[%s][%s]\n",val["u"].asString().c_str(),val["m"].asString().c_str());
		for (std::map<int, Table*>::iterator it = g->playing_tables.begin();
				it != g->playing_tables.end(); it++) {
			//			log.debug("dy3[%d]\n",it->second->tid);
			it->second->send_speaker_bc();
		}

		for (std::map<int, Table*>::iterator it = g->waiting_tables.begin();
				it != g->waiting_tables.end(); it++) {
			//			log.debug("dy3[%d]\n",it->second->tid);
			it->second->send_speaker_bc();
		}
	}
}

int Game::start() {
	/* first init table */
	init_table();

	//初始化礼物
	init_gifts();

	init_conf();

	/* init socket for client*/
	init_accept();

	init_tasks_ach();

	init_tasks_day();

	return 0;
}

/* init table from config */
int Game::init_conf() {
	broke_money_limit = landlord.conf["game"]["broke_money_limit"].asInt();
	broke_give_num_max = landlord.conf["game"]["broke_give_num_max"].asInt();
	broke_give_to = landlord.conf["game"]["broke_give_to"].asInt();

	talk_need_money = landlord.conf["game"]["talk_need_money"].asInt();
	talk_time_diff = landlord.conf["game"]["talk_time_diff"].asInt();
	talk_str_len = landlord.conf["game"]["talk_str_len"].asInt();
	exp_lost = landlord.conf["game"]["exp_lost"].asInt();
	exp_win = landlord.conf["game"]["exp_win"].asInt();
	game_type = landlord.conf["game"]["game_type"].asInt();
	help_need_money = landlord.conf["game"]["help_need_money"].asInt();
	gift_money_flag = landlord.conf["game"]["gift_money_flag"].asInt();
	log.debug(
			"tables broke_money_limit[%d] broke_give_num_max[%d] broke_give_to[%d] talk_need_money[%d] talk_time_diff[%d] talk_str_len[%d]game_type[%d]\n",
			broke_money_limit, broke_give_num_max, broke_give_to,
			talk_need_money, talk_time_diff, talk_str_len,game_type);

	Json::Value val;
	Json::Reader reader;
	// VIP
	vipList.clear();
	int ret = landlord.cache_rc->command("get svips");
	if (ret < 0 || landlord.cache_rc->reply->str == NULL) {
		log.error("svips init error, cache error.\n");
		return -1;
	}
	if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
		log.error("svips parse error, date error.\n");
		return -1;
	}

//	log.debug("hello~~~~~~~~~~~here \n");

	for (unsigned int i = 0; i < val.size(); i++) {
		VipInfo v;
		v.min_recharge = val[i]["min_recharge"].asInt();
		v.ext_award = val[i]["ext_award"].asInt();
		v.min_exp = val[i]["min_exp"].asInt();
		v.level = val[i]["level"].asInt();
		vipList.push_back(v);
	}
	// Level
	levelList.clear();
	ret = landlord.cache_rc->command("get slevel");
	if (ret < 0 || landlord.cache_rc->reply->str == NULL) {
		log.error("slevel init error, cache error.\n");
		return -1;
	}
	if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
		log.error("slevel parse error, date error.\n");
		return -1;
	}
	for (unsigned int i = 0; i < val.size(); i++) {
		LevelInfo v;
		v.minExp = val[i]["minExp"].asInt();
		v.maxExp = val[i]["maxExp"].asInt();
		levelList[val[i]["level"].asInt()] = v;
	}
	// Title
	titleList.clear();
	ret = landlord.cache_rc->command("get stitle");
	if (ret < 0 || landlord.cache_rc->reply->str == NULL) {
		log.error("stitle init error, cache error.\n");
		return -1;
	}
	if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
		log.error("stitle parse error, date error.\n");
		return -1;
	}
	for (unsigned int i = 0; i < val.size(); i++) {
		TitleInfo v;
		v.maxMoney = val[i]["maxMoney"].asInt();
		v.minMoney = val[i]["minMoney"].asInt();
		v.title = val[i]["title"].asString();
		titleList.push_back(v);
	}
	// blackword
	blackwordList.clear();
	ret = landlord.cache_rc->command("get sblackword");
	if (ret < 0 || landlord.cache_rc->reply->str == NULL) {
		log.error("stitle blackwordList error, cache error.\n");
		return -1;
	}
	if (reader.parse(landlord.cache_rc->reply->str, val) < 0) {
		log.error("stitle blackwordList error, date error.\n");
		return -1;
	}
	for (unsigned int i = 0; i < val.size(); i++) {
//		log.error("%s\n",val[i]["word"].asString().c_str());
		blackwordList.push_back(val[i]["word"].asString());
	}
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

/* init table from config */

int Game::init_table() {
	int vid = landlord.conf["tables"]["vid"].asInt();
	int zid = landlord.conf["tables"]["zid"].asInt();
	int min_money = landlord.conf["tables"]["min_money"].asInt();
	int max_money = landlord.conf["tables"]["max_money"].asInt();
	int base_money = landlord.conf["tables"]["base_money"].asInt();
	int niceCardRatio = landlord.conf["tables"]["niceCardRatio"].asInt();
	int niceCardRatioRobot = landlord.conf["tables"]["niceCardRatioRobot"].asInt();
	log.debug(
			"tables vid[%d] zid[%d] min_money[%d] base_money[%d]\n",
			vid, zid, min_money, base_money);
	for (int i = landlord.conf["tables"]["begin"].asInt();
			i < landlord.conf["tables"]["end"].asInt(); i++) {
		Table *table = new Table();
		if (table->init(i, vid, zid, min_money, base_money,niceCardRatio,niceCardRatioRobot,max_money) < 0) {
			log.error("table[%d] init err\n", i);
			exit(1);
		}
		zero_tables[i] = table;
		all_tables[i] = table;
	}
	log.debug("total tables[%d]\n", zero_tables.size());

	return 0;
}

int Game::init_tasks_ach() {
	int ret = landlord.cache_rc->command("lrange ltaska:ids 0 -1");
	if (ret < 0) {
		log.error("tasks_ach ids init error, cache error.\n");
		return -1;
	}
	if (landlord.cache_rc->is_array_return_ok() < 0) {
		log.error("tasks_ach ids init error, data error.\n");
		return -1;
	}
	std::vector<int> lr;
	landlord.cache_rc->get_lrange(lr);
	if (lr.size() > 0) {
		for (unsigned int i = 0; i < lr.size(); i++) {
			ret = landlord.cache_rc->command("hgetall htaska:%d", lr[i]);
			if (ret < 0) {
				log.error("tasks_ach init error, cache error.\n");
				return -1;
			}
			if (landlord.cache_rc->is_array_return_ok() < 0) {
				log.error("tasks_ach init error, data error.\n");
				return -1;
			}
			TasksInfo t;
			t.task_id = landlord.cache_rc->get_value_as_int("id");
			t.task_finish_type = landlord.cache_rc->get_value_as_int(
					"finishtype");
			t.task_finish_num = landlord.cache_rc->get_value_as_int(
					"finishnum");
			t.task_award_type = landlord.cache_rc->get_value_as_int(
					"awardtype");
			t.task_award_amount = landlord.cache_rc->get_value_as_int(
					"awardmount");
			ach_tasks.push_back(t);
//			log.debug("##ach add[%d]\n",t->task_id);
		}
	}

	log.error("##achtask size[%d]\n", ach_tasks.size());
	return 0;
}

int Game::init_tasks_day() {
	int ret = landlord.cache_rc->command("lrange ltaskd3:ids 0 -1");
	if (ret < 0) {
		log.error("tasks_day ids init error, cache error.\n");
		return -1;
	}
	if (landlord.cache_rc->is_array_return_ok() < 0) {
		log.error("tasks_day ids init error, data error.\n");
		return -1;
	}
	vector<int> lr;
	landlord.cache_rc->get_lrange(lr);
	day_tasks.clear();
	if (lr.size() > 0) {
		for (unsigned int i = 0; i < lr.size(); i++) {
			ret = landlord.cache_rc->command("hgetall htaskd:%d", lr[i]);
			if (ret < 0) {
				log.error("tasks_day init error, cache error.\n");
				return -1;
			}
			if (landlord.cache_rc->is_array_return_ok() < 0) {
				log.error("tasks_day init error, data error.\n");
				return -1;
			}
			TasksInfo t;
			t.task_id = landlord.cache_rc->get_value_as_int("id");
			t.task_finish_type = landlord.cache_rc->get_value_as_int(
					"finishtype");
			t.task_finish_num = landlord.cache_rc->get_value_as_int(
					"finishnum");
			t.task_award_type = landlord.cache_rc->get_value_as_int(
					"awardtype");
			t.task_award_amount = landlord.cache_rc->get_value_as_int(
					"awardmount");
			day_tasks.push_back(t);
		}
	}
	lastUp_day_time = time(NULL);

	log.error("##daytask size[%d]\n", day_tasks.size());
//	lastUp_day_time = 1372542804;
//	log.debug("##lastUp_day_time[%d]\n",lastUp_day_time);
	return 0;
}

void Game::check_tasks_day() {
	time_t t = time(NULL);
	tm currentTime = { 0 };
	localtime_r(&t, &currentTime);
	tm lastTime = { 0 };
	localtime_r(&lastUp_day_time, &lastTime);

//	log.debug("####is_same_day[%d %d %d][%d %d %d]\n",t,currentTime.tm_mon,currentTime.tm_mday,lastUp_day_time,lastTime.tm_mon,lastTime.tm_mday);
	if (currentTime.tm_year == lastTime.tm_year
			&& currentTime.tm_mon == lastTime.tm_mon
			&& currentTime.tm_mday == lastTime.tm_mday) {
		return;
	}
	init_tasks_day();
	return;
}

int Game::init_accept() {
	log.debug("Listening on %s:%d\n",
			landlord.conf["game"]["host"].asString().c_str(),
			landlord.conf["game"]["port"].asInt());

	struct sockaddr_in addr;

	_fd = socket(PF_INET, SOCK_STREAM, 0);
	if (_fd < 0) {
		log.error("File[%s] Line[%d]: socket failed: %s\n",
		__FILE__, __LINE__, strerror(errno));
	}

	addr.sin_family = AF_INET;
	addr.sin_port = htons(landlord.conf["game"]["port"].asInt());
	addr.sin_addr.s_addr = inet_addr(
			landlord.conf["game"]["host"].asString().c_str());
	if (addr.sin_addr.s_addr == INADDR_NONE) {
		log.error("game::init_accept Incorrect ip address!");
		close(_fd);
		_fd = -1;
		exit(1);
	}

	int on = 1;
	if (setsockopt(_fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) < 0) {
		log.error("File[%s] Line[%d]: setsockopt failed: %s\n",
		__FILE__, __LINE__, strerror(errno));
		close(_fd);
		return -1;
	}

	if (bind(_fd, (struct sockaddr *) &addr, sizeof(addr)) < 0) {
		log.error("File[%s] Line[%d]: bind failed: %s\n",
		__FILE__, __LINE__, strerror(errno));
		close(_fd);
		return -1;
	}

	fcntl(_fd, F_SETFL, fcntl(_fd, F_GETFL, 0) | O_NONBLOCK);

	listen(_fd, 10000);

	_ev_accept.data = this;
	// init ev_io,when client connect,callback function accept_cb to deal with
	ev_io_init(&_ev_accept, Game::accept_cb, _fd, EV_READ);
	ev_io_start(landlord.loop, &_ev_accept);

	log.debug("listen ok\n");

	return 0;
}

void Game::accept_cb(struct ev_loop *loop, struct ev_io *w, int revents) {
	if (EV_ERROR & revents) {
		log.error("got invalid event\n");
		return;
	}

	struct sockaddr_in client_addr;
	socklen_t client_len = sizeof(client_addr);

	int fd = accept(w->fd, (struct sockaddr *) &client_addr, &client_len);
	if (fd < 0) {
		log.error("accept error[%s]\n", strerror(errno));
		return;
	}

	fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) | O_NONBLOCK);

	Client *client = new (std::nothrow) Client(fd);
	Game *game = (Game*) (w->data);
	if (client) {
		game->fd_client[fd] = client;
	} else
		close(fd);
}

void Game::del_client(Client *client) {
	if (fd_client.find(client->fd) == fd_client.end()) {
		log.error("free client err[miss]\n");
		return;
	}

//	dump_msg("del_client begin");

	fd_client.erase(client->fd);

	if (client->player) {
		Player *player = client->player;
		if (client->position == POSITION_WAIT) {
			if (offline_players.find(player->uid) != offline_players.end()) {
				offline_players.erase(player->uid);
//		        log.debug("delete player[%d] offline\n", player->uid);
			}

			if (online_players.find(player->uid) != online_players.end()) {
				online_players.erase(player->uid);
//		        log.debug("delete player[%d] online\n", player->uid);
			}

			delete player;
		} else if (client->position == POSITION_TABLE) {
			if (online_players.find(player->uid) != online_players.end()) {
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

int Game::dispatch(Client *client) {
	client->cmd_type = 0;
	int cmd = client->packet.test();
	if (cmd < 0) {
		log.error("the cmd format is error.\n");
		return -1;
	}
	if (cmd == SYS_ECHO) {
		Jpacket packet;
		packet.val = client->packet.val;
		packet.end();
		return client->send(packet.tostring());
	}

	if (cmd == SYS_ONLINE) {
		client->cmd_type = 1;
		Jpacket packet;
		packet.val["cmd"] = SYS_ONLINE;
		packet.val["online"] = (int) (online_players.size()
				+ offline_players.size());
		packet.end();
		return client->send(packet.tostring());
	}

	if (cmd == CLIENT_HEART_BEAT) {
		//当前时间戳
		time_t nt;
		time(&nt);
		//更新用户的心跳时间
		int i = client->uid % landlord.main_size;
		int ret = landlord.main_rc[i]->command("hset hu:%d heartbeat_at %ld",
				client->uid, &nt);
		return 0;
	}
//	log.debug("cmd start0:[%d]\n",cmd);
	// 1.加入牌桌
	if (cmd == CLIENT_JOIN_TABLE_REQ) {
		if (client->player == NULL) {
			// 初始化玩家信息
			int ret = add_player(client);
			if (ret == -1) {
				Jpacket packet;
				packet.val["cmd"] = SERVER_JOIN_TABLE_ERR_UC;
				packet.val["code"] = 5;
				packet.val["msg"] = "skey err";
				packet.end();
				client->send(packet.tostring());
				return -1;
			} else if (ret == 1) {
				return 0;
			} else if (ret == 2) {
				return 0;
			} else if (ret == -2) {
				Jpacket packet;
				packet.val["cmd"] = SERVER_JOIN_TABLE_ERR_UC;
				packet.val["code"] = 3;
				packet.val["msg"] = "need update";
				packet.end();
				client->send(packet.tostring());
				return -1;
			}
			if(game_type==1 && isFightOpenTime()==0){
//				log.debug("no fight open time to cont.\n");
				Jpacket packet;
				packet.val["cmd"] = SERVER_JOIN_TABLE_ERR_UC;
				packet.val["code"] = 4;
				packet.val["msg"] = "非比赛时间";
				packet.end();
				client->send(packet.tostring());
				return -1;
			}
			return handler_join_table(client);
		}
		log.error("CLIENT_JOIN_TABLE_REQ player must be NULL.\n");
		return -1;
	}

	if (safe_check(client, cmd) < 0) {
		return -1;
	}
	Player *player = client->player;
//	log.debug("cmd start:[%d][%d]\n",cmd,player->uid);
	/* dispatch */
	switch (cmd) {
	case CLIENT_GAME_READY_REQ:		// 2.准备
		all_tables[player->tid]->handler_game_ready(player);
		break;
	case CLIENT_ROB_REQ:			// 3.抢庄
		all_tables[player->tid]->handler_main_action(player, S_ROB);
		break;
	case CLIENT_BET_REQ:			// 4.下注
		all_tables[player->tid]->handler_main_action(player, S_BET);
		break;
	case CLIENT_FIGHT_REQ:			// 5.亮牌
		all_tables[player->tid]->handler_main_action(player, S_FIGHTING);
		break;
	case CLIENT_CHAT_REQ:			// 6.文字聊天
		all_tables[player->tid]->handler_chat(player);
		break;
	case CLIENT_FACE_REQ:			// 7.表情聊天
		all_tables[player->tid]->handler_face(player);
		break;
	case CLIENT_TALK_LIST_REQ:		// 7.聊天列表
		all_tables[player->tid]->handler_talk_list(player);
		break;
	case CLIENT_LOGOUT_REQ:			// 8.登出
		player->logout_type = self_logout;
		del_player(player);
		break;
	case CLIENT_NEXT_GAME_REQ:		// 9.再来一局
		if(all_tables[player->tid]->handler_next_game(player, 1)==1){
			log.debug("ddddd player\n");
			del_player(player);
		}
		break;
	case CLIENT_CHANGE_TABLE_REQ:	// 10.换桌
		leave_curr_table(player);
		return handler_join_table(client);
	case CLIENT_PLAYER_GIVE_GIFT_REQ:	// 牌桌中送礼
		all_tables[player->tid]->handler_send_gifts(player);
		break;
	case CLIENT_HELP_REQ:	// 牌桌提示
		all_tables[player->tid]->handler_help(player);
		break;
	default:
		log.error("invalid command[%d]\n", cmd);
		return -1;
	}
//	log.debug("cmd end:[%d][%d]\n",cmd,player->uid);
	return 0;
}

int Game::safe_check(Client *client, int cmd) {
	if (online_players.find(client->uid) == online_players.end()) {
		log.error("player[%d] must be online player.\n", client->uid);
		return -1;
	}
	if(client->player == NULL){
		log.debug("@@@@ client player is NUll\n");
		return -1;
	}
	Player *player = client->player;
	if (all_tables.find(player->tid) == all_tables.end()) {
		log.error("safe_check uid[%d] is not in table[%d]\n", player->uid,
				player->tid);
		return -1;
	}

	return 0;
}

int Game::handler_join_table(Client *client) {
//	dump_game_info("handler_join_table");
//	dump_msg("handler_join_table");
	Player *player = client->player;
	Json::Value &val = player->client->packet.tojson();
	int tid = val["tid"].asInt();
	if (client->position == POSITION_TABLE) {
		log.debug("handler_join_table uid[%d] have been in table\n",
				player->uid);
		return -1;
	}
	// 私人场
	if(game_type==2){
		int ouid = val["ouid"].asInt();
		return handler_join_priv_table(client,tid,ouid);
	}
	// 优先加入有玩家等待但未开始到牌桌
	if (waiting_tables.size() > 0) {
//		log.debug("one_tables.size() > 0 && wait_queue.size() > 0\n");

		map<int, Table*>::iterator one_it;
		for (one_it = waiting_tables.begin(); one_it != waiting_tables.end();
				one_it++) {
			Table *table = (*one_it).second;
			// 换桌限制不能换到上一桌
//			log.debug("curr tid[%d]last tid[%d]\n", table->tid,tid);
			if (table->state != S_READY || table->cur_players >= table->seatsNum
					|| table->tid == tid) {
				continue;
			}
			if (table->players.find(player->uid) != table->players.end()) {
				log.debug("handler_join_table uid[%d] is in table[%d]\n",
						player->uid, table->tid);
				return -1;
			}
			if (table->check_player_status(player) == 1) {
				return -1;
			}
			log.debug("tid[%d]join_table waiting table uid[%d]\n",
					table->tid,player->uid);
			client->set_positon(POSITION_TABLE);
			table->add_player(client->player);
			table->table_info_broadcast(NULL, 0);
			table->wait_join_robot(client->player->uid);
//			dump_msg("handler_join_table end");
//			dump_game_info("handler_join_table end");
			return 0;
		}
	}
	// 加入新牌桌
	if (zero_tables.size() > 0) {
		map<int, Table*>::iterator zero_it;
		for (zero_it = zero_tables.begin(); zero_it != zero_tables.end();
				zero_it++) {
			Table *table = (*zero_it).second;
			if (table->state != S_READY) {
				continue;
			}
			if (table->players.find(player->uid) != table->players.end()) {
				log.debug("handler_join_table uid[%d] is in table[%d]\n",
						player->uid, table->tid);
				return -1;
			}
			if (table->check_player_status(player) == 1) {
				return -1;
			}
//			log.debug("tid[%d]join_table zero_tables uid[%d]1\n", table->tid,player->uid);
			zero_tables.erase(zero_it);
//			log.debug("tid[%d]join_table zero_tables uid[%d]2\n", table->tid,player->uid);
			waiting_tables[table->tid] = table;

			client->set_positon(POSITION_TABLE);
			table->add_player(client->player);
			table->table_info_broadcast(NULL, 0);
			table->wait_join_robot(client->player->uid);
			return 0;
		}
	}

	log.error("no seat\n");
	return -1;
}

int Game::handler_join_priv_table(Client *client,int tid,int ouid) {
	Player *player = client->player;
	if(tid>0){
		if (waiting_tables.size() > 0) {
			map<int, Table*>::iterator one_it;
			for (one_it = waiting_tables.begin(); one_it != waiting_tables.end();
					one_it++) {
				Table *table = (*one_it).second;
				// 换桌限制不能换到上一桌
	//			log.debug("curr tid[%d]last tid[%d]\n", table->tid,tid);
				if (table->state != S_READY || table->cur_players >= table->seatsNum
						|| table->tid != tid) {
					continue;
				}
				if (table->players.find(player->uid) != table->players.end()) {
					log.debug("handler_join_table uid[%d] is in table[%d]\n",
							player->uid, table->tid);
					return -1;
				}
				if (table->check_player_status(player) == 1) {
					return -1;
				}
				log.debug("tid[%d]join_table waiting table uid[%d]\n",
						table->tid,player->uid);
				client->set_positon(POSITION_TABLE);
				table->add_player(client->player);
				table->up_priv_table_info(ouid);
				table->table_info_broadcast(NULL, 0);
				return 0;
			}
		}
	}else{
		// 加入新牌桌
		if (zero_tables.size() > 0) {
			map<int, Table*>::iterator zero_it;
			for (zero_it = zero_tables.begin(); zero_it != zero_tables.end();
					zero_it++) {
				Table *table = (*zero_it).second;
				if (table->state != S_READY) {
					continue;
				}
				if (table->players.find(player->uid) != table->players.end()) {
					log.debug("handler_join_table uid[%d] is in table[%d]\n",
							player->uid, table->tid);
					return -1;
				}

				int ret = landlord.cache_rc->command("hgetall hpriVenue:%d", ouid);
				if (ret < 0) {
					log.error("priv_table init error, cache error.\n");
					return -1;
				}
				if (landlord.cache_rc->is_array_return_ok() < 0) {
					log.error("priv_table init error, data error.\n");
					return -1;
				}
				table->base_money = landlord.cache_rc->get_value_as_int("base");
				table->min_money = landlord.cache_rc->get_value_as_int("limit");

				if (table->check_player_status(player) == 1) {
					return -1;
				}
				zero_tables.erase(zero_it);
				waiting_tables[table->tid] = table;

				client->set_positon(POSITION_TABLE);
				table->add_player(client->player);
				table->up_priv_table_info(ouid);
				table->table_info_broadcast(NULL, 0);
				return 0;
			}
		}
	}
	return -1;
}

int Game::isFightOpenTime(){
	int ret = landlord.cache_rc->command("hgetall fightDate");
	if (ret < 0) {
		log.error("isFightOpenTime init error, cache error.\n");
		return 0;
	}
	if (landlord.cache_rc->is_array_return_ok() < 0) {
		log.error("isFightOpenTime init error, data error.\n");
		return 0;
	}
	timeval tv;
	gettimeofday(&tv, NULL);
	int sec = tv.tv_sec;
	int isOpenTime = landlord.cache_rc->get_value_as_int("isOpenTime");
	int st = landlord.cache_rc->get_value_as_int("st");
	int et = landlord.cache_rc->get_value_as_int("et");
	log.debug("fd:[%d][%d][%d]\n",st,et,isOpenTime);
	if(st<=sec && et>sec && isOpenTime==1){
		return 1;
	}
	return 0;
}
int Game::update_table(int tid, int type) {
//	dump_game_info("update table 0");
	map<int, Table*>::iterator it;
	it = all_tables.find(tid);
	if (it == all_tables.end()) {
		return -1;
	}
	Table *table = (*it).second;

	it = playing_tables.find(tid);
	if (type == 0) {
		if (it != playing_tables.end()) {
//			log.debug("tid[%d]up play table-s\n",tid);
			playing_tables.erase(it);
//			log.debug("tid[%d]up play table-e\n",tid);
			waiting_tables[tid] = table;
			//		dump_msg("update table 2");
			//		dump_game_info("update table 2");
			return 0;
		}

		it = waiting_tables.find(tid);
		if (it != waiting_tables.end() && table->cur_players <= 0) {
//			log.debug("tid[%d]up zero table-s\n",tid);
			waiting_tables.erase(it);
//			log.debug("tid[%d]up zero table-e\n",tid);
			zero_tables[tid] = table;
			//		dump_msg("update table 3");
			//		dump_game_info("update table 3");
			return 0;
		}
	} else if (type == 1) {
		it = waiting_tables.find(tid);
		if (it != waiting_tables.end()) {
//			log.debug("tid[%d]up wait table-s\n",tid);
			waiting_tables.erase(it);
//			log.debug("tid[%d]up wait table-e\n",tid);
			playing_tables[tid] = table;
			//		dump_msg("update table 3");
			//		dump_game_info("update table 3");
			return 0;
		}
	}

	return 0;
}

int Game::send_error(Client *client, int cmd, int error_code) {
	Jpacket error;
	error.val["cmd"] = cmd;
	error.val["err"] = error_code;
	error.end();
	return client->send(error.tostring());
}

void Game::dump_msg(string msg) {
	log.debug(
			"%s zero[%d] wait[%d] play[%d] fd_client[%d] offline[%d] online[%d]\n",
			msg.c_str(), zero_tables.size(), waiting_tables.size(),
			playing_tables.size(), fd_client.size(), offline_players.size(),
			online_players.size());
}

int Game::check_skey(Client *client) {
	if (client->uid < 5000) {
		return 0;
	}
	int i = client->uid % landlord.main_size;
	int ret = landlord.main_rc[i]->command(" hget hu:%d skey", client->uid);
	if (ret < 0) {
		log.debug("player init error, because get player infomation error.\n");
		return -1;
	}
#if 1
//	log.debug("skey1 [%d] [%s] [%s]\n", client->uid,client->skey.c_str(), landlord.main_rc[i]->reply->str);
	if (landlord.main_rc[i]->reply->str
			&& client->skey.compare(landlord.main_rc[i]->reply->str) != 0) {
		log.error("skey2 [%d] [%s] [%s]\n", client->uid, client->skey.c_str(),
				landlord.main_rc[i]->reply->str);
		return -1;
	}
#endif	
	return 0;
}

int Game::add_player(Client *client) {
	Json::Value &val = client->packet.tojson();
	int uid = val["uid"].asInt();
	client->uid = uid;
	client->skey = val["skey"].asString();
	client->vid = val["vid"].asInt();
	client->version = val["ver"].asString();
	client->tid = val["tid"].asInt();

	// check version
	if (uid < landlord.conf["game"]["robotStart"].asInt()
			|| uid > landlord.conf["game"]["robotEnd"].asInt()) {
		if (check_skey(client) < 0) {
			return -1;
		}
		string minV = landlord.conf["tables"]["min_version"].asString();
		double dMinv = atof(minV.c_str());
		double dCv = atof(client->version.c_str());
//		log.debug("ct:[%g][%g][%d]\n",dMinv,dCv,strlen(client->version.c_str()));
		if (dMinv != 0
				&& (strlen(client->version.c_str()) == 0 || dMinv > dCv)) {
			return -2;
		}
	}

	//需要 获取table状态，对该用户进行广播table信息

	/* rebind by online */
	if (online_players.find(uid) != online_players.end()) {
#if 1
		log.debug("player[%d] rebind by online get info ok\n", uid);
		Player *player = online_players[uid];
		if (all_tables.find(player->tid) == all_tables.end()) {
			log.error("rebind by online uid[%d] is not in table[%d]\n",
					player->uid, player->tid);
			return -1;
		}
		Client *oldClient = player->client;
		player->set_client(client);
		client->set_positon(POSITION_TABLE);
		all_tables[player->tid]->handler_rebind(player);
		fd_client.erase(oldClient->fd);
		delete oldClient;

//		log.debug("rebind by online ! ~~~~~~~~~ success !");
		//dump_game_info("rebind by online");

		return 2;
#endif
		// return -1;
	}

	/* rebind by offline */
	if (offline_players.find(uid) != offline_players.end()) {
		log.debug("player[%d] rebind by offline get info ok\n", uid);

		Player *player = offline_players[uid];
		if (all_tables.find(player->tid) == all_tables.end()) {
			log.error("rebind by offline uid[%d] is not in table[%d]\n",
					player->uid, player->tid);
			return -1;
		}
		offline_players.erase(uid);
		online_players[uid] = player;

		player->set_client(client);
		client->set_positon(POSITION_TABLE);
		all_tables[player->tid]->handler_rebind(player);

//		log.debug("rebind by online ! ~~~~~~~~~ success !");
//		dump_game_info("rebind by offline");
		return 1;
	}

	/* set player info */
	Player *player = new (std::nothrow) Player();
	if (player == NULL) {
		log.error("new player err");
		return -1;
	}

	player->set_client(client);
	int ret = player->init();
	if (ret < 0)
		return -1;
	online_players[uid] = player;
//    log.debug("player[%d] login success on game.cc\n", uid);

	return 0;
}

int Game::leave_curr_table(Player *player) {
	int ret;
	player->logout_type = change_table;
	ret = all_tables[player->tid]->handler_logout(player);
	if (ret < 0) {
		log.debug("leave_curr_table handler_logout\n");
		return -1;
	}

	ret = all_tables[player->tid]->del_player(player);
	if (ret < 0) {
		log.debug("leave_curr_table del_player\n");
		return -1;
	}
	all_tables[player->tid]->check_start_game();
	ret = update_table(player->tid, 0);
	if (ret < 0) {
		log.debug("leave_curr_table update_table\n");
		return -1;
	}
	player->reset();
	if (player->client) {
		player->client->position = POSITION_WAIT;
		return 0;
	}

//	dump_msg("del_player end");
//	dump_game_info("del_player");
	return -1;
}

int Game::del_player(Player *player) {
	int ret;

	ret = all_tables[player->tid]->handler_logout(player);
	if (ret < 0) {
		log.debug("del_player handler_logout\n");
		return -1;
	}

	ret = all_tables[player->tid]->del_player(player);
	if (ret < 0) {
		log.debug("del_player del_player\n");
		return -1;
	}
	all_tables[player->tid]->check_start_game();
	ret = update_table(player->tid, 0);
	if (ret < 0) {
		log.debug("del_player update_table\n");
		return -1;
	}
	if (offline_players.find(player->uid) != offline_players.end()) {
		offline_players.erase(player->uid);
		log.debug("delete player[%d] offline\n", player->uid);
	}

	if (online_players.find(player->uid) != online_players.end()) {
		online_players.erase(player->uid);
		log.debug("delete player[%d] online\n", player->uid);
	}
	if (player->client) {
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

void Game::dump_game_info(char *tag) {
#if 1
	static char buf[102400];
	int i = 0;
	i += sprintf(buf, "begin===============%s===============begin\n", tag);
	std::map<int, Table*>::iterator table_it;
	std::map<int, Client*>::iterator client_it;
	std::map<int, Player*>::iterator player_it;
	i += sprintf(buf + i, "[three_tables][%lu]\n",
			landlord.game->playing_tables.size());
	for (table_it = landlord.game->playing_tables.begin();
			table_it != landlord.game->playing_tables.end(); table_it++) {
		Table *table = table_it->second;
		i += sprintf(buf + i, "Tid[%d]state[%d] ", table_it->first,
				table->state);
		for (player_it = table->players.begin();
				player_it != table->players.end(); player_it++) {
			Player *player = player_it->second;
			if (player->client)
				i += sprintf(buf + i, "uid[%d]fd[%d] ", player->uid,
						player->client->fd);
			else
				i += sprintf(buf + i, "uid[%d] ", player->uid);
		}
		i += sprintf(buf + i, "\n");
	}

	i += sprintf(buf + i, "[two_tables][%lu]\n",
			landlord.game->waiting_tables.size());
	for (table_it = landlord.game->waiting_tables.begin();
			table_it != landlord.game->waiting_tables.end(); table_it++) {
		Table *table = table_it->second;
		i += sprintf(buf + i, "Tid[%d]state[%d] ", table_it->first,
				table->state);
		for (player_it = table->players.begin();
				player_it != table->players.end(); player_it++) {
			Player *player = player_it->second;
			if (player->client)
				i += sprintf(buf + i, "uid[%d]fd[%d] ", player->uid,
						player->client->fd);
			else
				i += sprintf(buf + i, "uid[%d] ", player->uid);
		}
		i += sprintf(buf + i, "\n");
	}

	i += sprintf(buf + i, "[fd_client][%lu]\n",
			landlord.game->fd_client.size());
	for (client_it = landlord.game->fd_client.begin();
			client_it != landlord.game->fd_client.end(); client_it++) {
		i += sprintf(buf + i, "fd[%d] ", client_it->first);
	}
	i += sprintf(buf + i, "\n");

	i += sprintf(buf + i, "[offline_players][%lu]\n",
			landlord.game->offline_players.size());
	for (player_it = landlord.game->offline_players.begin();
			player_it != landlord.game->offline_players.end(); player_it++) {
		i += sprintf(buf + i, "uid[%d] ", player_it->first);
	}
	i += sprintf(buf + i, "\n");

	i += sprintf(buf + i, "[online_players][%lu]\n",
			landlord.game->online_players.size());
	for (player_it = landlord.game->online_players.begin();
			player_it != landlord.game->online_players.end(); player_it++) {
		i += sprintf(buf + i, "uid[%d] ", player_it->first);
	}
	i += sprintf(buf + i, "\n");
	i += sprintf(buf + i, "end===============%s===============end\n", tag);
	log.debug("\n%s", buf);
#endif
}
