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
	Card::sort_by_descending(cards);
	if (cards[0].face == cards[1].face && cards[1].face == cards[2].face
			&& (ft == TT_BCARDS_THREE || ft == TT_BCARDS_DOUB))
	{
		if(fn>0 && fn!=cards[0].face){
			return 0;
		}
		return 1;	//BCARDS_THREE and TT_BCARDS_DOUB
	}
	if (cards[0].face == 17 && cards[1].face == 16 &&
			(ft == TT_BCARDS_ROCKET || ft == TT_BCARDS_KING))
	{
		return 1;
	}
	if (cards[0].face >15 && ft == TT_BCARDS_KING)
	{
		return 1;	//BCARDS_KING
	}

	if ((cards[0].face == cards[1].face || cards[1].face == cards[2].face)
			&& ft == TT_BCARDS_DOUB)
	{
		if(fn>0 && fn!=cards[1].face){
			return 0;
		}
		return 1;  //BCARDS_DOUB;
	}
	
	if (cards[0].suit == cards[1].suit && cards[1].suit == cards[2].suit
		&& cards[0].face < 16 && cards[1].face < 16 && cards[2].face < 16)
	{
		if ((cards[0].face - cards[1].face) == 1 
			&& (cards[1].face - cards[2].face) == 1)
		{
			if (cards[0].face <= 14 && ft == TT_BCARDS_FLOWER_JUNKO)
			{
				return 1;	//BCARDS_FLOWER_JUNKO
			}
		}else if(ft == TT_BCARDS_FLOWER){
			return 1;	//BCARDS_FLOWER
		}
	}
	
	if (ft == TT_BCARDS_JUNKO && (cards[0].face - cards[1].face) == 1
		&& (cards[1].face - cards[2].face) == 1)
	{
		if (cards[0].face <= 14)
		{
			return 1;	//BCARDS_JUNKO
		}
	}
	return 0;
}

void CommunityCards::debug()
{
	Card::sort_by_descending(cards);
	Card::dump_cards(cards);
//	printf("[%d]\n", get_card_type());
}
