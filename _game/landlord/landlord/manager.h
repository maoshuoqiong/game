#ifndef _MANAGER_H_
#define _MANAGER_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ev++.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>

#include <iostream>
#include <fstream>
#include <string>
#include <map>

class Manager
{
public:

private:
    ev_io _ev_accept;
	int _fd;

public:
    Manager();
    virtual ~Manager();	
	int start();
	static void accept_cb(struct ev_loop *loop, struct ev_io *w, int revents);
	void 	process(int fd);
	int     init_table();
    int     init_accept();

};

#endif
