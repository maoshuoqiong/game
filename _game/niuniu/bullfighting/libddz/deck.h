#ifndef _DECK_H_
#define _DECK_H_

#include <vector>
#include <set>

#include "card.h"
#include "hole_cards.h"
#include "community_cards.h"


using namespace std;

class Deck
{
public:
	int random(int start, int end);
	void fill(int seed, int bomb_0, int bomb_1, int bomb_2);
	void fill();
	void filltmp();
	void empty();
	int count() const;
	
	bool push(Card card);
	bool pop(Card &card);
	bool shuffle(int seed);
	/**
	 * 洗牌
	 * niceSize 拿好牌到人数
	 */
	void fillBullfight(int niceSize,int seed);
	void get_hole_cards(HoleCards &holecards);
	void get_hole_cards_bomb(HoleCards &holecards);
	void get_hole_cards_bomb(HoleCards &holecards,int i);
	void get_community_cards(CommunityCards &communitycards);
	
	void debug();
	int cal_bomb_num(int rand,int bomb_0, int bomb_1, int bomb_2);
	int isNiceCard(int val);
	// 获得手牌
	void get_hotpot_cards(HoleCards &holecards,int i);
public:
	vector<Card> cards;
	vector<Card> niceCards;		//特殊牌：五花牛，五小牛，四炸
	vector<Card> smallCards;	//小于等于5到牌
	vector<Card> bigCards;		//大于等于J到牌
	vector<Card> normalCards;	//6~10牌
	set<int> 	bombIndList;	//四炸的值列表

	int cur;
	int sum;
	int pc[3];
	vector<int> pv[3]; 
};

#endif /* _DECK_H_ */
