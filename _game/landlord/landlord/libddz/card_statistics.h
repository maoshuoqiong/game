#ifndef _CARD_STATISTICS_H_
#define _CARD_STATISTICS_H_

#include <vector>
#include <string>

using namespace std;

class CardStatistics
{
public:
	vector<Card> card1;
	vector<Card> card2;
	vector<Card> card3;
	vector<Card> card4;
	
	vector<Card> line1;
	vector<Card> line2;
	vector<Card> line3;
	
	unsigned int len;

	vector<Card> cards_super;
	vector<Card> cards;
	std::map<int, Card> cards_map;
	std::map<int, int> 	facelist;
	int super_face;
	unsigned int super_num;
	
	CardStatistics();
	CardStatistics(int input_super_face);	
	
	void clear();
	int statistics(std::vector<Card> &cards);
	
	void debug();
};


#endif /* _CARD_STATISTICS_H_ */
