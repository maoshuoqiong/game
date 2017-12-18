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
#include "game.h"
#include "table.h"
#include "proto.h"
#include "client.h"
#include "player.h"
#include "manager.h"

extern Bullfighting landlord;
extern Log log;

Manager::Manager()
{
}

Manager::~Manager()
{
}

int Manager::start()
{
    init_accept();

    return 0;
}

int Manager::init_accept()
{
    log.debug("Listening on %s:%d\n", 
            landlord.conf["manager"]["host"].asString().c_str(),
            landlord.conf["manager"]["port"].asInt());

    struct sockaddr_in addr;

    _fd = socket(PF_INET, SOCK_STREAM, 0);
    if (_fd < 0)
    {
    	log.error("File[%s] Line[%d]: socket failed: %s\n",
                    __FILE__, __LINE__, strerror(errno));
    }

    addr.sin_family      = AF_INET;
    addr.sin_port        = htons(landlord.conf["manager"]["port"].asInt());
    addr.sin_addr.s_addr = inet_addr(landlord.conf["manager"]["host"].asString().c_str());
	if (addr.sin_addr.s_addr == INADDR_NONE)
    {
		log.error("Manager::init_accept Incorrect ip address!");
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
	ev_io_init(&_ev_accept, Manager::accept_cb, _fd, EV_READ);
	ev_io_start(landlord.loop, &_ev_accept);

    log.debug("listen ok\n");

    return 0;
}

void Manager::accept_cb(struct ev_loop *loop, struct ev_io *w, int revents)
{
	if (EV_ERROR & revents)
	{
        log.error("got invalid event\n");
		return;
	}

    Manager *self = (Manager*)w->data;
	
	struct sockaddr_in client_addr;
	socklen_t client_len = sizeof(client_addr);

	int fd = accept(w->fd, (struct sockaddr *)&client_addr, &client_len);
	if (fd < 0)
	{
        log.error("accept error[%s]\n", strerror(errno));
		return;
	}
	
	self->process(fd);
}

void Manager::process(int fd)
{
    /*
    std::map<int, Table*>       three_tables;
    std::map<int, Table*>       two_tables;
    std::map<int, Table*>       one_tables;
    std::map<int, Table*>       zero_tables;
    std::map<int, Table*>       all_tables;
    std::map<int, Client*>      fd_client;
    std::map<int, Player*>      offline_players;
    std::map<int, Player*>      online_players;
    */
    std::map<int, Table*>::iterator table_it;
    std::map<int, Client*>::iterator client_it;
    std::map<int, Player*>::iterator player_it;
    printf("three_tables\n");
    for (table_it = landlord.game->playing_tables.begin(); table_it != landlord.game->playing_tables.end(); table_it++)
    {
        printf("Tid[%d] ", table_it->first);
        Table *table = table_it->second;
        for (player_it = table->players.begin(); player_it != table->players.end(); player_it++)
        {
            Player *player = player_it->second;
            if (player->client)
                printf("uid[%d] fd[%d] ", player->uid, player->client->fd);
            else
                printf("uid[%d] ", player->uid);
        }
        printf("\n");
    }

    printf("two_tables\n");
    for (table_it = landlord.game->waiting_tables.begin(); table_it != landlord.game->waiting_tables.end(); table_it++)
    {
        printf("Tid[%d] ", table_it->first);
        Table *table = table_it->second;
        for (player_it = table->players.begin(); player_it != table->players.end(); player_it++)
        {
            Player *player = player_it->second;
            if (player->client)
                printf("uid[%d] fd[%d] ", player->uid, player->client->fd);
            else
                printf("uid[%d] ", player->uid);
        }
        printf("\n");
    }

    printf("fd_client\n");
    for (client_it = landlord.game->fd_client.begin(); client_it != landlord.game->fd_client.end(); client_it++)
    {
        printf("fd[%d] ", client_it->first);
        printf("\n");
    }

    printf("offline_players\n");
    for (player_it = landlord.game->offline_players.begin(); player_it != landlord.game->offline_players.end(); player_it++)
    {
        printf("uid[%d] ", player_it->first);
        printf("\n");
    }

    printf("fd_client\n");
    for (player_it = landlord.game->online_players.begin(); player_it != landlord.game->online_players.end(); player_it++)
    {
        printf("uid[%d] ", player_it->first);
        printf("\n");
    }

/*
<!Doctype html>
<html xmlns=http://www.w3.org/1999/xhtml>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8">
    <meta http-equiv=X-UA-Compatible content=IE=EmulateIE7>
    <title>百度一下，你就知道 </title>
</head>
<body>
    <p>xxx</p>
</body>
</html>
*/
	close(fd);
}

