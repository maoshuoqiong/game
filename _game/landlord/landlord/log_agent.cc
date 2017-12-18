#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <time.h>
#include <errno.h>

#include "landlord.h"
#include "log.h"
#include "log_agent.h"

extern Landlord landlord;
extern Log log;

LogAgent::LogAgent()
{

}

LogAgent::~LogAgent()
{

}

int LogAgent::init(string host, int port, string pass)
{
	fd = socket(AF_INET, SOCK_DGRAM,0);
	if (fd < 0)
	{
		log.error("LogAgent socket error [%d]", errno);
		return -1;
	}
	
	int on=1;
	int ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR | SO_BROADCAST, &on, sizeof(on));
	if (ret < 0)
	{
		log.error("LogAgent setsockopt error [%d]", errno);
	}
	
    bzero(&addr,sizeof(addr));
    addr.sin_family      = AF_INET;
    addr.sin_port        = htons(port);
    addr.sin_addr.s_addr = inet_addr(host.c_str());
	if (addr.sin_addr.s_addr == INADDR_NONE)
    {
		log.error("LogAgent Incorrect ip address!");
        close(fd);
		fd = -1;
        exit(1);
    }

	passwd = pass;
	log.debug("LogAgent init succ[%s][%d]\n", host.c_str(),port);
	return 0;
}

void LogAgent::sendData(std::string &data)
{
	int ret = sendto(fd, data.c_str(), data.length(), 0, (struct sockaddr *)&addr, sizeof(addr));
//	log.debug("LogAgent ret [%d][%s]\n", ret,data.c_str());
	if (ret < 0)
	{
		log.error("LogAgent send error [%d]\n", errno);
	}
}

void LogAgent::deinit()
{
	if (fd > 0)
	{
		close(fd);
		fd = -1;
	}
}
