#ifndef _DECK_H_
#define _DECK_H_

#include <vector>

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
	
	void get_hole_cards(HoleCards &holecards);
	void get_hole_cards_bomb(HoleCards &holecards);
	void get_hole_cards_bomb(HoleCards &holecards,int i);
	void get_community_cards(CommunityCards &communitycards);
	
	void debug();
	int cal_bomb_num(int rand,int bomb_0, int bomb_1, int bomb_2);
public:
	vector<Card> cards;
	int cur;
	int sum;
	int pc[3];
	vector<int> pv[3]; 
};

#endif /* _DECK_H_ */
