//#include "stdafx.h"
#include "card.h"
#include "card_statistics.h"


CardStatistics::CardStatistics()
{
	super_face = 0;
	super_num = 0;
}

CardStatistics::CardStatistics(int input_super_face)
{
	super_face = input_super_face;
	super_num = 0;
}

void CardStatistics::clear()
{
	card1.clear();
	card2.clear();
	card3.clear();
	card4.clear();
	
	line1.clear();
	line2.clear();
	line3.clear();
}

int CardStatistics::statistics(std::vector<Card> &cards)
{
	clear();

	len = cards.size();
	
	Card::sort_by_ascending(cards);
	// Card::sort_by_descending(cards);
	int j = 0;
	unsigned int i = 0;
	Card temp = cards[0];
	for (i = 1; i < cards.size(); i++)
	{
		if (cards[i - 1].face == this->super_face)
		{
			cards_super.push_back(cards[i - 1]);
		}

		if (temp == cards[i])
		{
			j++;
		}
		else
		{
			if (cards[i - 1].face == this->super_face)
			{
				this->super_num = j+1;
			}
			else
			{
				if (j == 0)
				{
					card1.push_back(cards[i - 1]);
					line1.push_back(cards[i - 1]);
				}
				else if (j == 1)
				{
					card2.push_back(cards[i - 2]);
					card2.push_back(cards[i - 1]);
					line1.push_back(cards[i - 2]);
					line2.push_back(cards[i - 2]);
					line2.push_back(cards[i - 1]);

				}
				else if (j == 2)
				{
					card3.push_back(cards[i - 3]);
					card3.push_back(cards[i - 2]);
					card3.push_back(cards[i - 1]);
					line1.push_back(cards[i - 3]);
					line2.push_back(cards[i - 3]);
					line2.push_back(cards[i - 2]);
					line3.push_back(cards[i - 3]);
					line3.push_back(cards[i - 2]);
					line3.push_back(cards[i - 1]);
				}
				else if (j == 3)
				{
					card4.push_back(cards[i - 4]);
					card4.push_back(cards[i - 3]);
					card4.push_back(cards[i - 2]);
					card4.push_back(cards[i - 1]);
					line1.push_back(cards[i - 4]);
					line2.push_back(cards[i - 4]);
					line2.push_back(cards[i - 3]);
					line3.push_back(cards[i - 4]);
					line3.push_back(cards[i - 3]);
					line3.push_back(cards[i - 2]);
				}
			}

			j = 0;
		}
		temp = cards[i];
	}

	if (cards[i - 1].face == this->super_face)
	{
		cards_super.push_back(cards[i - 1]);
	}

	if (cards[i - 1].face == this->super_face)
	{
		this->super_num = j+1;
	}
	else
	{

		if (j == 0)
		{
			card1.push_back(cards[i - 1]);
			line1.push_back(cards[i - 1]);
		}
		else if (j == 1)
		{
			card2.push_back(cards[i - 2]);
			card2.push_back(cards[i - 1]);
			line1.push_back(cards[i - 2]);
			line2.push_back(cards[i - 2]);
			line2.push_back(cards[i - 1]);

		}
		else if (j == 2)
		{
			card3.push_back(cards[i - 3]);
			card3.push_back(cards[i - 2]);
			card3.push_back(cards[i - 1]);
			line1.push_back(cards[i - 3]);
			line2.push_back(cards[i - 3]);
			line2.push_back(cards[i - 2]);
			line3.push_back(cards[i - 3]);
			line3.push_back(cards[i - 2]);
			line3.push_back(cards[i - 1]);
		}
		else if (j == 3)
		{
			card4.push_back(cards[i - 4]);
			card4.push_back(cards[i - 3]);
			card4.push_back(cards[i - 2]);
			card4.push_back(cards[i - 1]);
			line1.push_back(cards[i - 4]);
			line2.push_back(cards[i - 4]);
			line2.push_back(cards[i - 3]);
			line3.push_back(cards[i - 4]);
			line3.push_back(cards[i - 3]);
			line3.push_back(cards[i - 2]);

		}
	}


	int cardface = 0;
//	int val = 0;

	for( i = 3 ; i <= 17 ; i++ )
	{
		facelist[i] = 0;
	}
	for (i = 1; i <= cards.size(); i++)
	{
		if(cards[i - 1].face == this->super_face)
		{
			; // it is super do nothing for facelist
		}
		else if(cardface == 0)
		{
			cardface = cards[i-1].face;
			facelist[cardface] = 1;
		}
		else if(cardface != cards[i-1].face)
		{
			cardface = cards[i-1].face;
			facelist[cardface] = 1;
		}
		else
		{
			facelist[cardface] += 1;
		}

		this->cards.push_back(cards[i-1]);
	}


	debug();

	return 0;
}

void CardStatistics::debug()
{
	Card::dump_cards(card1, "card1");
	Card::dump_cards(card2, "card2");
	Card::dump_cards(card3, "card3");
	Card::dump_cards(card4, "card4");
	
	Card::dump_cards(line1, "line1");
	Card::dump_cards(line2, "line2");
	Card::dump_cards(line3, "line3");
	Card::dump_cards(cards_super, "cards_super");
}
