#ifndef _LANDLORD_H_
#define _LANDLORD_H_

#include <stdio.h>
#include <stdint.h>
#include <iostream>
#include <fstream>
#include <string>
#include <json/json.h>
#include "redis_client.h"
#include "log_agent.h"

class Game;
class Manager;

class Landlord
{
public:
    std::string         conf_file;
    int                 is_daemonize;
    Json::Value         conf;
    Game                *game;
	Manager				*manager;
    struct ev_loop      *loop;
	RedisClient			*main_rc[20];
	RedisClient			*cache_rc;
	int					main_size;
	RedisClient			*log_rc;
	LogAgent			logAgent;

private:
};

#endif    /* _LANDLORD_H_ */
