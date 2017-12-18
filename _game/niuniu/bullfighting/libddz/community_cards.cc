#include "community_cards.h"
#include "tasks_type.h"

CommunityCards::CommunityCards()
{

}

void CommunityCards::add_card(Card card)
{
	cards.push_back(card);
}

void CommunityCards::copy_cards(std::vector<Card> *v)
{
	for (unsigned int i = 0; i < cards.size(); i++)
	{
		v->push_back(cards[i]);
	}
}

void CommunityCards::copy_to_hole_cards(HoleCards &holecards)
{
	for (unsigned int i = 0; i < cards.size(); i++)
	{
		holecards.add_card(cards[i]);
	}
}

int CommunityCards::get_card_type(int ft,int fn)
{
	if(ft==0){
		return 0;
	}
	
	return 0;
}

void CommunityCards::debug()
{
	Card::sort_by_descending(cards);
	Card::dump_cards(cards);
//	printf("[%d]\n", get_card_type());
}
