#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <errno.h>

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <ev.h>

#include "daemonize.h"
#include "landlord.h"
#include "game.h"
#include "manager.h"
#include "log.h"

static int parse_arg(int argc, char **argv);
static int init_conf();
static void dump_conf();
static int set_rlimit(int n);
static int init_redis();

Landlord landlord;
Log log;

int main(int argc, char **argv)
{
    int ret;
	
    ret = parse_arg(argc, argv);
    if (ret < 0) {
        log.fatal("File: %s Func: %s Line: %d => parse_arg.\n",
                            __FILE__, __FUNCTION__, __LINE__);
        exit(1);
    }
    ret = init_conf();
    if (ret < 0) {
        log.fatal("File: %s Func: %s Line: %d => init_conf.\n",
                            __FILE__, __FUNCTION__, __LINE__);
        exit(1);
    }
    
	dump_conf();
	
    if (landlord.is_daemonize == 1)
        daemonize();
    signal(SIGPIPE, SIG_IGN);
    
    ret = single_instance_running(
        landlord.conf.get("pid_file", "conf/landlord.pid").asString().c_str());
    if (ret < 0) {
        log.fatal("File: %s Func: %s Line: %d => single_instance_running.\n",
                            __FILE__, __FUNCTION__, __LINE__);
        exit(1);
    }

    log.start(landlord.conf["log"].get("log_file", "log/landlord.log").asString(),
				landlord.conf["log"].get("level", 1).asInt(),
				landlord.conf["log"].get("console", 0).asInt(),
				landlord.conf["log"].get("rotate", 0).asInt(),
				landlord.conf["log"].get("max_size", 1073741824).asInt(),
				landlord.conf["log"].get("max_file", 50).asInt());

	set_rlimit(10240);

    ret = init_redis();
    if (ret < 0) //connect redis
    {
        log.fatal("init redis failed\n");
		exit(1);
    }
    landlord.logAgent.init(landlord.conf["log-agent"]["host"].asString(),
        		 					landlord.conf["log-agent"]["port"].asInt(),
        		 					landlord.conf["log-agent"]["pass"].asString());

    struct ev_loop *loop = ev_default_loop(0);
    landlord.loop = loop;
    
    Game *game = new (std::nothrow) Game();
    landlord.game = game;
    landlord.game->start();
	/*
    Manager *manager = new (std::nothrow) Manager();
    landlord.manager = manager;
    landlord.manager->start();
	*/
    
    ev_loop(loop, 0);
    
    return 0;
}

static int parse_arg(int argc, char **argv)
{
    int flag = 0;
    int oc; /* option chacb. */
    char ic; /* invalid chacb. */
    
    landlord.is_daemonize = 0;
    while((oc = getopt(argc, argv, "Df:")) != -1) {
        switch(oc) {
            case 'D':
                landlord.is_daemonize = 1;
                break;
            case 'f':
                flag = 1;
                landlord.conf_file = string(optarg);
                break;
            case '?':
                ic = (char)optopt;
                printf("invalid \'%c\'\n", ic);
                break;
            case ':':
                printf("lack option arg\n");
                break;
        }
    }
    
    if (flag == 0)
        return -1;
        
    return 0;
}

static int init_conf()
{
    std::ifstream in(landlord.conf_file.c_str(), std::ifstream::binary); 
    if (!in) {
		std::cout << "init file no found." << endl;
		return -1;
	}
	
	Json::Reader reader;
	bool ret = reader.parse(in, landlord.conf);
	if (!ret) {
		in.close();
		std::cout << "init file parser." << endl;
		return -1;
	}
	
	in.close();
	return 0;
}

static void dump_conf()
{
	std::cout << "pid_file: "
        << landlord.conf.get("pid_file", "conf/landlord.pid").asString() << endl;
	
	std::cout << "log:log_file: "
        << landlord.conf["log"].get("log_file", "log/landlord.log").asString()
        << endl;
	std::cout << "log:level: "
        << landlord.conf["log"].get("level", 4).asInt() << endl;
	std::cout << "log:console: "
        << landlord.conf["log"].get("console", 0).asInt() << endl;
	std::cout << "log:rotate: "
        << landlord.conf["log"].get("rotate", 1).asInt() << endl;
	std::cout << "log:max_size: "
        << landlord.conf["log"].get("max_size", 1073741824).asInt() << endl;
	std::cout << "log:max_file: "
        << landlord.conf["log"].get("max_file", 50).asInt() << endl;

	std::cout << "game:host: "
        << landlord.conf["game"]["host"].asString() << endl;
	std::cout << "game:port: "
        << landlord.conf["game"]["port"].asInt() << endl;
	/*
	std::cout << "manager:host: "
        << landlord.conf["manager"]["host"].asString() << endl;
	std::cout << "manager:port: "
        << landlord.conf["manager"]["port"].asInt() << endl;
	*/
	std::cout << "log-agent:host: "
        << landlord.conf["log-agent"]["host"].asString() << endl;
	std::cout << "log-agent:port: "
        << landlord.conf["log-agent"]["port"].asInt() << endl;

	landlord.main_size = landlord.conf["main-db"].size();
	for (int i = 0; i < landlord.main_size; i++)
	{
		std::cout << "[" << i << "]main-db:host: "
	        << landlord.conf["main-db"][i]["host"].asString() << endl;
		std::cout << "[" << i << "]main-db:port: "
	        << landlord.conf["main-db"][i]["port"].asInt() << endl;
		std::cout << "[" << i << "]main-db:pass: "
	        << landlord.conf["main-db"][i]["pass"].asString() << endl;	
	}
	
	/*
	std::cout << "log-db:host: "
        << landlord.conf["log-db"]["host"].asString() << endl;
	std::cout << "log-db:port: "
        << landlord.conf["log-db"]["port"].asInt() << endl;
	std::cout << "log-db:pass: "
        << landlord.conf["log-db"]["pass"].asString() << endl;
	*/			
	std::cout << "tables:begin: "
        << landlord.conf["tables"]["begin"].asInt() << endl;
	std::cout << "tables:end: "
        << landlord.conf["tables"]["end"].asInt() << endl;
	std::cout << "tables:min_money: "
        << landlord.conf["tables"]["min_money"].asInt() << endl;
	std::cout << "tables:max_money: "
        << landlord.conf["tables"]["max_money"].asInt() << endl;
	std::cout << "tables:base_money: "
        << landlord.conf["tables"]["base_money"].asInt() << endl;
	std::cout << "tables:vid: "
        << landlord.conf["tables"]["vid"].asInt() << endl;
	std::cout << "tables:zid: "
        << landlord.conf["tables"]["zid"].asInt() << endl;
	std::cout << "tables:table_type: "
        << landlord.conf["tables"]["table_type"].asInt() << endl;
}

static int set_rlimit(int n)
{
    struct rlimit rt;
  
    rt.rlim_max = rt.rlim_cur = n;
    if (setrlimit(RLIMIT_NOFILE, &rt) == -1) {
        log.error("File: %s Func: %s Line: %d => setrlimit %s.\n",
                            __FILE__, __FUNCTION__, __LINE__, strerror(errno));
        return -1;   
    }
    
    return 0;
}

static int init_redis()
{
	int ret;
	// init main db
    landlord.main_size = landlord.conf["main-db"].size();
    for (int i = 0; i < landlord.main_size; i++)
    {
        landlord.main_rc[i] = new RedisClient();
        ret = landlord.main_rc[i]->init(landlord.conf["main-db"][i]["host"].asString()
                    , landlord.conf["main-db"][i]["port"].asInt(), 1000, landlord.conf["main-db"][i]["pass"].asString());
        if (ret < 0)
        {
            log.debug("main db redis error\n");
            return -1;      
        }
    }
       // init cache db
    landlord.cache_rc = new (std::nothrow) RedisClient();
	ret = landlord.cache_rc->init(landlord.conf["cache-db"]["host"].asString()
				, landlord.conf["cache-db"]["port"].asInt(), 1000, landlord.conf["cache-db"]["pass"].asString());

	if (ret < 0)
	{
		log.debug("cache db redis error");
		return -1;
	}
    return 0;
}
// hmset u:4 user lcl name lcl password 123456 salt 123456 sex 1 money 10000 cooldou 11000 coin 10 avater 1 level 10 expr 2300 skey abc ondays 5 rewarded 1 total_board 1000 total_win 200 create_at 1234567891 login_at 1223333333
