#ifndef _HOLE_CARDS_H_
#define _HOLE_CARDS_H_

#include <map>
#include <vector>
#include <algorithm>

#include "card.h"
#include "tasks_type.h"

using namespace std;

class HoleCards
{
public:
	HoleCards();
	
	void add_card(Card c);
	void clear() { cards.clear(); };
	
	void copy_cards(std::vector<Card> *v);
	
	void copy_cards(std::vector<int> *v);
	
	int get_one_little_card();
	
	int robot(std::vector<int> &v);
	
	int robot(std::vector<Card> &v,int superFace,int ordDesc);

	void remove(std::vector<Card> &v);
	
	void remove(std::vector<int> &v);
	
	int size();
	
	void debug();

    int task_ach_hole_card();

	std::map<int, Card> cards;
};

#endif /* _HOLE_CARDS_H_ */
