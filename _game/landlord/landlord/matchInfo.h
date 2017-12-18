#ifndef __MATCHINFO_H__
#define __MATCHINFO_H__

#include <vector>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <string>
#include <algorithm>
#include <iostream>
#include "player.h"

using namespace std;

class Player;

typedef enum
{
	PRELIMINARY = 0,
	KNOCKOUT,
} match_level;

typedef struct
{
    int awardType;	// 0,money;1,coin
    int awardNum;
} AwardInfo;

class MatchInfo
{
public:
	MatchInfo();
    virtual ~MatchInfo();

    std::string				matchKey;
    std::vector<Player*>	joinPlayers;
    int						upTime;
    int						curr_level;			// 0:preliminary match,1:knockout match
    int						curr_base_point;	//

public:
    void init(std::string _matchKey,std::vector<Player*> _joinPlayers,
    		int _upTime,int _curr_base_point,int _curr_level);
    void upRank();
    void deadline_cut_off(int riseLimit);
    int cal_match_point(int tmpPoint,int p_base_point);
    void rise_next_level();
    void pop_player();
    static bool sortByPoint(Player *p1,Player *p2){
    	return p1->point > p2->point;
//    	return false;
    }
    static bool sortByInc(const int p1,const int p2){
    	return p1 > p2;
    }
    void send_result_msg(Player *p1);
    void del_match_player(std::vector<Player*> delPlayer,int isRiseLevel);
};

#endif
