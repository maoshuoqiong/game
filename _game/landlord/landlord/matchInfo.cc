#include "matchInfo.h"
#include "log.h"
#include "landlord.h"
#include "game.h"
#include "log.h"
#include "player.h"

#include "proto.h"
#include "client.h"
#include "jpacket.h"
extern Landlord landlord;
extern Log log;

MatchInfo::MatchInfo()
{
}

MatchInfo::~MatchInfo()
{
}

void MatchInfo::init(std::string _matchKey,std::vector<Player*> _joinPlayers,
		int _upTime,int _curr_base_point,int _curr_level){
	matchKey = _matchKey;
	joinPlayers = _joinPlayers;
	upTime = _upTime;
	curr_base_point = _curr_base_point;
	curr_level = _curr_level;
}

void MatchInfo::upRank(){
	sort(joinPlayers.begin(),joinPlayers.end(),MatchInfo::sortByPoint);
	int diff = joinPlayers.size();

	for(int i=0;i<diff;i++){
		joinPlayers[i]->match_total_rank = i+1;
//		log.debug("sort[%d][%d][%d]..\n",joinPlayers[i]->uid,joinPlayers[i]->match_total_rank,joinPlayers[i]->point);
	}
}

void MatchInfo::deadline_cut_off(int riseLimit){
	// point/100
	std::vector<Player*> delPlayer;
	int diff = joinPlayers.size();
	log.debug("deadline bef[%d][%d]..\n",riseLimit,diff);
	for(int i=riseLimit;i<diff;i++){
		delPlayer.push_back(joinPlayers[i]);
	}
	log.debug("deadline AAA[%d]..\n",delPlayer.size());
	del_match_player(delPlayer,0);
	log.debug("deadline BBB..\n");
	diff = joinPlayers.size();
	for(int i=0;i<diff;i++){
		joinPlayers[i]->point = joinPlayers[i]->point/100;
	}
	log.debug("deadline aft[%d]..\n",joinPlayers.size());
}

void MatchInfo::del_match_player(std::vector<Player*> players,int isRiseLevel){
	int psize = players.size();
	for (int i=0;i<psize;i++)
	{
		send_result_msg(players[i]);
		if(isRiseLevel==0){
			joinPlayers.pop_back();
		}
		players[i]->logout_type = OUT_MATCH;
		landlord.game->del_player(players[i]);
	}
}

void MatchInfo::rise_next_level(){
	vector<Player*> firstP;
	vector<Player*> secondP;
	vector<Player*> thirdP;
	int diff = joinPlayers.size();
	log.debug("riselevel bef[%d]..\n",joinPlayers.size());
	for(int i=0;i<diff;i++){
		if(joinPlayers[i]->match_table_rank == 1){
			firstP.push_back(joinPlayers[i]);
		}else if(joinPlayers[i]->match_table_rank == 2){
			secondP.push_back(joinPlayers[i]);
		}else{
			thirdP.push_back(joinPlayers[i]);
		}
	}
	// get next level limit
	int fs = firstP.size();
	int ls = landlord.game->matchRiseLevel.size();
	int riseNum = 0;
	for(int i=0;i<ls-1;i++){
		if(landlord.game->matchRiseLevel[i]>fs &&
			landlord.game->matchRiseLevel[i+1]<fs){
			riseNum = landlord.game->matchRiseLevel[i];
			break;
		}
	}
	diff = riseNum - fs;
	sort(secondP.begin(),secondP.end(),MatchInfo::sortByPoint);
	int ss = secondP.size();
	for(int i=0;i<ss;i++){
		if(i<diff){
			firstP.push_back(secondP[i]);
		}else{
			thirdP.push_back(secondP[i]);
		}
	}
	joinPlayers = firstP;
	log.debug("riselevel aft[%d]..\n",joinPlayers.size());
	// point/2
	diff = joinPlayers.size();
	for(int i=0;i<diff;i++){
		joinPlayers[i]->point = joinPlayers[i]->point/2;
	}
	sort(thirdP.begin(),thirdP.end(),MatchInfo::sortByPoint);
	int dpSize = thirdP.size();
	// reset rank val
	for(int i=0;i<dpSize;i++){
		thirdP[i]->match_total_rank = dpSize+i+1;
//		log.debug("sort[%d][%d][%d]..\n",joinPlayers[i]->uid,joinPlayers[i]->match_total_rank,joinPlayers[i]->point);
	}
	// knock out loser
	del_match_player(thirdP,1);

}

int MatchInfo::cal_match_point(int tmpPoint,int p_base_point){
	// knockout level always 100
	if(curr_level == KNOCKOUT){
		return 100;
	}
	if(p_base_point == 0){
		return curr_base_point;
	}
	int pp  = curr_base_point>p_base_point?curr_base_point:p_base_point;
	if(tmpPoint == pp){
		tmpPoint += landlord.conf["game"]["matchBaseInc"].asInt();
	}else if(tmpPoint < pp){
		tmpPoint = pp;
	}
	return tmpPoint;
}

void MatchInfo::send_result_msg(Player *p){
	Jpacket packet;
	packet.val["cmd"] = SERVER_MATCH_END_UC;
	packet.val["uid"] = p->uid;
	packet.val["rank"] = p->match_total_rank;
	int awardType = 0;
	int awardNum = 0;

	if(p->match_total_rank <= landlord.game->match_award.size() && joinPlayers.size() <= landlord.game->match_award.size()
			&& landlord.game->match_award.find(p->match_total_rank)!=landlord.game->match_award.end()){
		AwardInfo awi = landlord.game->match_award.at(p->match_total_rank);
		awardType = awi.awardType;
		awardNum = awi.awardNum;
		if(awardType==0){
			p->cur_coin = awardNum;
			p->incr_coin();
		}else{
			p->cur_money = awardNum;
			p->incr_money(ADD);
		}
		log.debug("award[%d][%d][%d][%d][%d]..\n",p->uid,p->match_total_rank,awardType,awardNum,p->point);
	}

	packet.val["awardType"] = awardType;
	packet.val["awardNum"] = awardNum;
	packet.end();
	p->client->send(packet.tostring());

}

void MatchInfo::pop_player(){
	joinPlayers.pop_back();
}
