#include "card.h"
#include "hole_cards.h"
#include "community_cards.h"
#include "card_statistics.h"
#include "card_analysis.h"
#include "card_find.h"


HoleCards::HoleCards()
{

}

void HoleCards::add_card(Card card)
{
	cards[card.value] = card;
}

void HoleCards::copy_cards(std::vector<Card> *v)
{
	std::map<int, Card>::iterator it;
	for (it = cards.begin(); it != cards.end(); it++)
	{
		v->push_back(it->second);
	}
}

int HoleCards::task_ach_hole_card()
{
	std::map<int, Card>::iterator it;
	int maxCard = 0;
	int no7 = 1;
	vector<int> rocketAndBomb2;
	for (it = cards.begin(); it != cards.end(); it++)
	{
		Card &card = it->second;
		if(card.face == 7){
			no7 = 0;
		}
		if(card.face>maxCard){
			maxCard = card.face;
		}
		if(card.face>14){
			rocketAndBomb2.push_back(card.face);
		}
//		fprintf(stdout, "htd[%d][%d]\n",card.face,card.value);
	}
	if(no7 == 1){
		return TT_HOLE_NO_7;
	}
	if(maxCard <= 13){
		return TT_HOLE_LESS_K;
	}
	if(rocketAndBomb2.size()==6){
		return TT_HOLE_ROCKET_BOMB_2;
	}
	return 0;
}

void HoleCards::copy_cards(std::vector<int> *v)
{
	std::map<int, Card>::iterator it;
	for (it = cards.begin(); it != cards.end(); it++)
	{
		Card &card = it->second;
		v->push_back(card.value);
	}
}

int HoleCards::get_one_little_card()
{
	std::vector<Card> v;
	
	std::map<int, Card>::iterator it;
	for (it = cards.begin(); it != cards.end(); it++)
	{
		v.push_back(it->second);
	}
	
	Card::sort_by_descending(v);
	
	Card card = v.back();
	
	cards.erase(card.value);
	
	return card.value;
}

int HoleCards::robot(std::vector<int> &v)
{
	std::vector<int> cards_int;
	copy_cards(&cards_int);
	
	// to find straight
	CardFind::find_straight(cards_int, v);
	if (v.size() > 0)
	{
		remove(v);
		return 0;
	}
	
	vector<Card> cards_obj;
	copy_cards(&cards_obj);
	CardStatistics card_stat;
	card_stat.statistics(cards_obj);
	// to find three or with one or with two
	if (card_stat.card3.size() > 0)
	{
		v.push_back(card_stat.card3[0].value);
		v.push_back(card_stat.card3[1].value);
		v.push_back(card_stat.card3[2].value);
		
		if (card_stat.card1.size() > 0)
		{
			if (card_stat.card1[0].face != 16 && card_stat.card1[0].face != 17)
            {
				v.push_back(card_stat.card1[0].value);
				remove(v);
            	return 0;
            }
		}
		
		if (card_stat.card2.size() > 0)
		{
			v.push_back(card_stat.card2[0].value);
			v.push_back(card_stat.card2[1].value);
			remove(v);
			return 0;
		}
		remove(v);
		return 0;
	}
	
	// is rocket
	if (card_stat.card1.size() == 2)
	{
		if (card_stat.card1[0].face == 16 &&
			card_stat.card1[1].face == 17)
		v.push_back(card_stat.card1[0].value);
		v.push_back(card_stat.card1[1].value);
		remove(v);
		return 0;
	}
	
	if (card_stat.card1.size() > 0)
	{
		v.push_back(card_stat.card1[0].value);
		remove(v);
		return 0;
	}
	
	if (card_stat.card4.size() > 0)
	{
		v.push_back(card_stat.card4[0].value);
		v.push_back(card_stat.card4[1].value);
		v.push_back(card_stat.card4[2].value);
		v.push_back(card_stat.card4[3].value);
		remove(v);
		return 0;
	}
    
	return -1;
}

int HoleCards::robot(std::vector<Card> &v,int superFace,int ordDesc)
{
	std::vector<Card> cards_int;
	copy_cards(&cards_int);

	// to find straight
	CardFind::find_straight(cards_int, v);
	if (v.size() > 0)
	{
		remove(v);
		return 0;
	}

	vector<Card> cards_obj;
	copy_cards(&cards_obj);
	CardStatistics card_stat;
	card_stat.statistics(cards_obj);
	// to find three or with one or with two
	if (card_stat.card3.size() > 0)
	{
		if(card_stat.card3[0].face>13 && cards_obj.size()>5){
			if(card_stat.card2.size()>0 && card_stat.card2[0].face <14){
				v.push_back(card_stat.card2[0]);
				v.push_back(card_stat.card2[1]);
				remove(v);
				return 0;
			}
			if(card_stat.card1.size()>0 && card_stat.card1[0].face <16){
				if(ordDesc==0){
					v.push_back(card_stat.card1[0]);
				}else{
					v.push_back(card_stat.card1[card_stat.card1.size()-1]);
				}
				remove(v);
				return 0;
			}
		}
		v.push_back(card_stat.card3[0]);
		v.push_back(card_stat.card3[1]);
		v.push_back(card_stat.card3[2]);

		if (card_stat.card1.size() > 0)
		{
			if (card_stat.card1[0].face != 16 && card_stat.card1[0].face != 17)
            {
				v.push_back(card_stat.card1[0]);
				remove(v);
            	return 0;
            }
		}

		if (card_stat.card2.size() > 0)
		{
			v.push_back(card_stat.card2[0]);
			v.push_back(card_stat.card2[1]);
			remove(v);
			return 0;
		}
		remove(v);
		return 0;
	}

	if (card_stat.card2.size() > 0)
	{
		if(card_stat.card2[0].face>13 && card_stat.card1.size()>1 && card_stat.card1[0].face <14){
			if(ordDesc==0){
				v.push_back(card_stat.card1[0]);
			}else{
				v.push_back(card_stat.card1[card_stat.card1.size()-1]);
			}
			remove(v);
			return 0;
		}
		v.push_back(card_stat.card2[0]);
		v.push_back(card_stat.card2[1]);
		remove(v);
		return 0;
	}
	// is rocket
	if (card_stat.card1.size() == 2)
	{
		if (card_stat.card1[0].face == 16 &&
			card_stat.card1[1].face == 17)
		v.push_back(card_stat.card1[0]);
		v.push_back(card_stat.card1[1]);
		remove(v);
		return 0;
	}
	if (card_stat.card1.size() > 0)
	{
		if(ordDesc==0){
			v.push_back(card_stat.card1[0]);
		}else{
			v.push_back(card_stat.card1[card_stat.card1.size()-1]);
		}
		remove(v);
		return 0;
	}

	if (card_stat.card4.size() > 0)
	{
		v.push_back(card_stat.card4[0]);
		v.push_back(card_stat.card4[1]);
		v.push_back(card_stat.card4[2]);
		v.push_back(card_stat.card4[3]);
		remove(v);
		return 0;
	}
	return -1;
}

void HoleCards::remove(std::vector<Card> &v)
{
	for (unsigned int i = 0; i < v.size(); i++)
	{
		cards.erase(v[i].value);
	}
}

void HoleCards::remove(std::vector<int> &v)
{
	for (unsigned int i = 0; i < v.size(); i++)
	{
		cards.erase(v[i]);
	}
}

int HoleCards::size()
{
	return (int)(cards.size());
}

void HoleCards::debug()
{
	std::vector<Card> temp;
	copy_cards(&temp);
	Card::sort_by_descending(temp);
	Card::dump_cards(temp);
}
