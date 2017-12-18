#ifndef __GIFTS_H__
#define __GIFTS_H__

#include <vector>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

//using namespace std;

class Gifts
{
public:
	Gifts();
    virtual ~Gifts();

    int				gift_id;
    int				money;
    int 			charm;
   // std::string     gift_name;
public:
    void init(int gift_id,int money,int charm);
};

#endif
