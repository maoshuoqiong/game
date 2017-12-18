//#include "stdafx.h"
#include "card.h"
#include "card_type.h"
#include "card_analysis.h"
#include "card_statistics.h"
#include "card_find.h"

#include "../log.h"

extern Log log;

CardFind::CardFind()
{
	this->super_face = 0;
	this->type = CARD_TYPE_ERROR;
    this->cow_card_type = CARD_TYPE_COW_ERROR;
}
CardFind::CardFind(int type)
{
	this->type = type;
}

void CardFind::clear()
{
	results.clear();
	results_faces.clear();
    results_dcow.clear();
    this->cow_card_type = CARD_TYPE_COW_NO;
}

void CardFind::init(int type)
{
	this->type = type;
}

void CardFind::init(int type,int super_face)
{
	this->type = type;
	this->super_face = super_face;
}

int CardFind::find(CardAnalysis &card_ana, CardStatistics &card_stat,CardStatistics &target_card_stat,
		int last_is_partner,int last_hole_size,int cur_hole_size)
{
	clear();
	if (card_ana.type != CARD_TYPE_ERROR)
	{
		if (card_ana.type == CARD_TYPE_ROCKET)
		{
			return 0;
		}
		
		if (card_ana.type == CARD_TYPE_ONE)
		{
			find_one(card_ana, card_stat, target_card_stat);
			find_two(card_ana, card_stat, target_card_stat);
			find_three(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_TWO)
		{
			find_two(card_ana, card_stat, target_card_stat);
			find_three(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_THREE)
		{
			find_three(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_ONELINE)
		{
			find_one_ine(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_TWOLINE)
		{
			find_two_ine(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_THREELINE)
		{
			find_three_line(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_THREEWITHONE)
		{
			find_three_with_one(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_THREEWITHTWO)
		{
			find_three_with_two(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_PLANEWITHONE)
		{
			find_plane_with_one(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_PLANEWITHWING)
		{
			find_plane_with_wing(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_FOURWITHONE)
		{
			find_four_with_one(card_ana, card_stat, target_card_stat);
		}
		else if (card_ana.type == CARD_TYPE_FOURWITHTWO)
		{
			find_four_with_two(card_ana, card_stat, target_card_stat);
		}
		if(cur_hole_size<6 || (!last_is_partner && last_hole_size<6)){
//			fprintf(stdout, "^^^find_bomb[%d][%d][%d]\n",cur_hole_size,last_hole_size,last_is_partner);
			find_bomb(card_ana, card_stat, target_card_stat);
		}
		if(cur_hole_size<4 || (!last_is_partner && last_hole_size<6)){
//			fprintf(stdout, "^^^find_rocket[%d][%d][%d]\n",cur_hole_size,last_hole_size,last_is_partner);
			find_rocket(card_ana, card_stat, target_card_stat);
		}

	}
	
	return 0;
}

void CardFind::find_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (card_ana.type == CARD_TYPE_ONE) 
	{
		for (unsigned int i = 0; i < my_card_stat.card1.size(); i++)
		{
			if (my_card_stat.card1[i].face > card_ana.face)
			{
				if(my_card_stat.card1[i].face == 16 && my_card_stat.card1[my_card_stat.card1.size()-1].face == 17 &&
						(my_card_stat.len == 2 || (my_card_stat.len == 3 && my_card_stat.card1.size()==3) ||
								(my_card_stat.len == 4 && my_card_stat.card1.size()==2 && my_card_stat.card2.size()==2))){
					break;
				}
				vector<Card> cards;
				cards.push_back(my_card_stat.card1[i]);
				results.push_back(cards);
			}
		}
	}
}

void CardFind::find_two(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (card_ana.type == CARD_TYPE_ONE) 
	{
		for (unsigned int i = 0; i < my_card_stat.card2.size(); i += 2)
		{
			if (my_card_stat.card2[i].face > card_ana.face)
			{
				vector<Card> cards;
				cards.push_back(my_card_stat.card2[i]);
				results.push_back(cards);
			}
		}
	}
	else if (card_ana.type == CARD_TYPE_TWO) 
	{
		for (unsigned int i = 0; i < my_card_stat.card2.size(); i += 2)
		{
			if (my_card_stat.card2[i].face > card_ana.face)
			{
				vector<Card> cards;
				cards.push_back(my_card_stat.card2[i]);
				cards.push_back(my_card_stat.card2[i + 1]);
				results.push_back(cards);
			}
		}
	}
}

void CardFind::find_three(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (card_ana.type == CARD_TYPE_ONE) 
	{
		for (unsigned int i = 0; i < my_card_stat.card3.size(); i += 3)
		{
			if (my_card_stat.card3[i].face > card_ana.face)
			{
				vector<Card> cards;
				cards.push_back(my_card_stat.card3[i]);
				results.push_back(cards);
			}
		}
	}
	else if (card_ana.type == CARD_TYPE_TWO) 
	{
		for (unsigned int i = 0; i < my_card_stat.card3.size(); i += 3)
		{
			if (my_card_stat.card3[i].face > card_ana.face)
			{
				vector<Card> cards;
				cards.push_back(my_card_stat.card3[i]);
				cards.push_back(my_card_stat.card3[i + 1]);
				Card::dump_cards(cards);
				results.push_back(cards);
			}
		}
	}
	else if (card_ana.type == CARD_TYPE_THREE) 
	{
		for (unsigned int i = 0; i < my_card_stat.card3.size(); i += 3)
		{
			if (my_card_stat.card3[i].face > card_ana.face)
			{
				vector<Card> cards;
				cards.push_back(my_card_stat.card3[i]);
				cards.push_back(my_card_stat.card3[i + 1]);
				cards.push_back(my_card_stat.card3[i + 2]);
				results.push_back(cards);
			}
		}
	}
}

void CardFind::find_one_ine(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	int count = my_card_stat.line1.size() - card_stat.line1.size();
	for (int i = 0; i <= count; i++)
	{
		if (my_card_stat.line1[i].face > card_ana.face)
		{
			int end = i + card_ana.len;
			if (card_ana.check_arr_is_line(my_card_stat.line1, 1, i, end))
			{
				vector<Card> cards;
				for (int j = i; j < end; j++)
				{
					cards.push_back(my_card_stat.line1[j]);	
				}
				results.push_back(cards);
			}	
		}
	}
}

void CardFind::find_two_ine(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	int count = my_card_stat.line2.size() - card_stat.line2.size();
	for (int i = 0; i <= count; i += 2)
	{
		if (my_card_stat.line2[i].face > card_ana.face)
		{
			int end = i + card_ana.len;
			if (card_ana.check_arr_is_line(my_card_stat.line2, 2, i, end))
			{
				vector<Card> cards;
				for (int j = i; j < end; j++)
				{
					cards.push_back(my_card_stat.line2[j]);	
				}
				results.push_back(cards);
			}	
		}
	}
}

void CardFind::find_three_line(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	int count = my_card_stat.line3.size() - card_stat.line3.size();
	for (int i = 0; i <= count; i += 3)
	{
		if (my_card_stat.line3[i].face > card_ana.face)
		{
			int end = i + card_ana.len;
			if (card_ana.check_arr_is_line(my_card_stat.line3, 3, i, end))
			{
				vector<Card> cards;
				for (int j = i; j < end; j++)
				{
					cards.push_back(my_card_stat.line3[j]);	
				}
				results.push_back(cards);
			}	
		}
	}	
}

void CardFind::find_three_with_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (my_card_stat.len < 4)
	{
		return;
	}
	
	for (unsigned int i = 0; i < my_card_stat.card3.size(); i += 3)
	{
		if (my_card_stat.card3[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card3[i]);
			cards.push_back(my_card_stat.card3[i + 1]);
			cards.push_back(my_card_stat.card3[i + 2]);
			if (my_card_stat.card1.size() > 0)
			{
				cards.push_back(my_card_stat.card1[0]);
			}
			else
			{
				for (unsigned int j = 0; j < my_card_stat.line1.size(); j++)
				{
					if (my_card_stat.line1[j].face != cards[0].face) {
						cards.push_back(my_card_stat.line1[j]);
						break;
					}
				}
			}
			results.push_back(cards);
		}
	}
}

void CardFind::find_three_with_two(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (my_card_stat.len < 5)
	{
		return;
	}
	
	for (unsigned int i = 0; i < my_card_stat.card3.size(); i += 3)
	{
		if (my_card_stat.card3[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card3[i]);
			cards.push_back(my_card_stat.card3[i + 1]);
			cards.push_back(my_card_stat.card3[i + 2]);
			if (my_card_stat.card2.size() > 0)
			{
				cards.push_back(my_card_stat.card2[0]);
				cards.push_back(my_card_stat.card2[1]);
			}
			else
			{
				for (unsigned int j = 0; j < my_card_stat.line2.size(); j++)
				{
					if (my_card_stat.line2[j].face != cards[0].face) {
						cards.push_back(my_card_stat.line2[j]);
						cards.push_back(my_card_stat.line2[j + 1]);
						break;
					}
				}
			}
			results.push_back(cards);
		}
	}
}

void CardFind::find_plane_with_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{		
	int count = my_card_stat.line3.size() - card_stat.line3.size();
	for (int i = 0; i <= count; i += 3)
	{
		if (my_card_stat.line3[i].face > card_ana.face)
		{
			int end = i + card_stat.card3.size();
			if (card_ana.check_arr_is_line(my_card_stat.line3, 3, i, end))
			{
				vector<Card> cards;
				for (int j = i; j < end; j++)
				{
					cards.push_back(my_card_stat.line3[j]);
				}
				// printf("aaa1[%u][%u]\n", cards.size(), card_ana.len);
				for (unsigned int j = 0; j < my_card_stat.card1.size(); j++)
				{
					cards.push_back(my_card_stat.card1[j]);
					if (cards.size() == card_ana.len)
					{
						break;
					}
				}
					
				if (cards.size() == card_ana.len)
				{ 
					results.push_back(cards);
					continue;
				}
					
				int flag = 0;
				for (unsigned int j = 0; j < my_card_stat.line1.size(); j++)
				{
					flag = 0;
					for (unsigned int k = 0; k < cards.size(); k++)
					{
						if (cards[k].face == my_card_stat.line1[j].face)
						{
							flag = 1;
							break;
						}
					}
						
					if (flag == 1)
					{
						continue;
					}
						
					cards.push_back(my_card_stat.line1[j]);	
					if (cards.size() == card_ana.len)
					{
						break;
					}
				}
				
				if (cards.size() == card_ana.len)
				{
					results.push_back(cards);
					continue;
				}
			}
		}
	}
}

void CardFind::find_plane_with_wing(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	int count = my_card_stat.line3.size() - card_stat.line3.size();
	for (int i = 0; i <= count; i += 3)
	{
		if (my_card_stat.line3[i].face > card_ana.face)
		{
			int end = i + card_stat.card3.size();
			if (card_ana.check_arr_is_line(my_card_stat.line3, 3, i, end))
			{
				vector<Card> cards;
				for (int j = i; j < end; j++)
				{
					cards.push_back(my_card_stat.line3[j]);
				}
				// printf("aaa1[%u][%u]\n", cards.size(), card_ana.len);
				for (unsigned int j = 0; j < my_card_stat.card2.size(); j += 2)
				{
					cards.push_back(my_card_stat.card2[j]);
					cards.push_back(my_card_stat.card2[j + 1]);
					if (cards.size() == card_ana.len)
					{
						break;
					}
				}
					
				if (cards.size() == card_ana.len)
				{ 
					results.push_back(cards);
					continue;
				}
					
				int flag = 0;
				for (unsigned int j = 0; j < my_card_stat.line2.size(); j += 2)
				{
					flag = 0;
					for (unsigned int k = 0; k < cards.size(); k++)
					{
						if (cards[k].face == my_card_stat.line2[j].face)
						{
							flag = 1;
							break;
						}
					}
						
					if (flag == 1)
					{
						continue;
					}
						
					cards.push_back(my_card_stat.line2[j]);
					cards.push_back(my_card_stat.line2[j + 1]);
					if (cards.size() == card_ana.len)
					{
						break;
					}
				}
				
				if (cards.size() == card_ana.len)
				{
					results.push_back(cards);
					continue;
				}
			}
		}
	}	
}

void CardFind::find_four_with_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (my_card_stat.len < 6)
	{
		return;
	}
	
	for (unsigned int i = 0; i < my_card_stat.card4.size(); i += 4)
	{
		if (my_card_stat.card4[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card4[i]);
			cards.push_back(my_card_stat.card4[i + 1]);
			cards.push_back(my_card_stat.card4[i + 2]);
			cards.push_back(my_card_stat.card4[i + 3]);

			for (unsigned int j = 0; j < my_card_stat.card1.size(); j++)
			{
				cards.push_back(my_card_stat.card1[j]);
				if (cards.size() == card_ana.len)
				{
					break;
				}
			}
					
			if (cards.size() == card_ana.len)
			{ 
				results.push_back(cards);
				continue;
			}
					
			int flag = 0;
			for (unsigned int j = 0; j < my_card_stat.line1.size(); j++)
			{
				flag = 0;
				for (unsigned int k = 0; k < cards.size(); k++)
				{
					if (cards[k].face == my_card_stat.line1[j].face)
					{
						flag = 1;
						break;
					}
				}
						
				if (flag == 1)
				{
					continue;
				}
						
				cards.push_back(my_card_stat.line1[j]);	
				if (cards.size() == card_ana.len)
				{
					break;
				}
			}
				
			if (cards.size() == card_ana.len)
			{
				results.push_back(cards);
				continue;
			}
		}
	}
}

void CardFind::find_four_with_two(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (my_card_stat.len < 8)
	{
		return;
	}
	
	for (unsigned int i = 0; i < my_card_stat.card4.size(); i += 4)
	{
		if (my_card_stat.card4[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card4[i]);
			cards.push_back(my_card_stat.card4[i + 1]);
			cards.push_back(my_card_stat.card4[i + 2]);
			cards.push_back(my_card_stat.card4[i + 3]);

			for (unsigned int j = 0; j < my_card_stat.card2.size(); j += 2)
			{
				cards.push_back(my_card_stat.card2[j]);
				cards.push_back(my_card_stat.card2[j + 1]);
				if (cards.size() == card_ana.len)
				{
					break;
				}
			}
					
			if (cards.size() == card_ana.len)
			{ 
				results.push_back(cards);
				continue;
			}
					
			int flag = 0;
			for (unsigned int j = 0; j < my_card_stat.line2.size(); j += 2)
			{
				flag = 0;
				for (unsigned int k = 0; k < cards.size(); k++)
				{
					if (cards[k].face == my_card_stat.line2[j].face)
					{
						flag = 1;
						break;
					}
				}
						
				if (flag == 1)
				{
					continue;
				}
						
				cards.push_back(my_card_stat.line2[j]);
				cards.push_back(my_card_stat.line2[j + 1]);
				if (cards.size() == card_ana.len)
				{
					break;
				}
			}
				
			if (cards.size() == card_ana.len)
			{
				results.push_back(cards);
				continue;
			}
		}
	}	
}

void CardFind::find_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	if (card_ana.type == CARD_TYPE_BOMB)
	{
		for (unsigned int i = 0; i < my_card_stat.card4.size(); i += 4)
		{
			if (my_card_stat.card4[i].face > card_ana.face)
			{
				vector<Card> cards;
				cards.push_back(my_card_stat.card4[i]);
				cards.push_back(my_card_stat.card4[i + 1]);
				cards.push_back(my_card_stat.card4[i + 2]);
				cards.push_back(my_card_stat.card4[i + 3]);
				results.push_back(cards);
			}
		}
	}
	else
	{
		for (unsigned int i = 0; i < my_card_stat.card4.size(); i += 4)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card4[i]);
			cards.push_back(my_card_stat.card4[i + 1]);
			cards.push_back(my_card_stat.card4[i + 2]);
			cards.push_back(my_card_stat.card4[i + 3]);
			results.push_back(cards);
		}
	}	
}

void CardFind::find_rocket(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	int len = my_card_stat.card1.size();
	if (len >= 2)
	{
		if (my_card_stat.card1[len - 2].face == 16
			&& my_card_stat.card1[len - 1].face == 17)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card1[len - 2]);
			cards.push_back(my_card_stat.card1[len - 1]);
			results.push_back(cards);		
		}
	}	
}

int CardFind::find_straight(vector<int> &input, vector<int> &output)
{
    if (input.size() == 0)
    {
        return -1;
    }
    
	vector<Card> cards0;
	vector<Card> cards1;
	for (unsigned int i = 0; i < input.size(); i++)
	{
		Card card(input[i]);
		cards0.push_back(card);
	}
	
	CardStatistics card_stat;
	card_stat.statistics(cards0);
	CardFind::get_straight(card_stat, cards1);
	
	output.clear();
	
	for (unsigned int i = 0; i < cards1.size(); i++)
	{
		output.push_back(cards1[i].value);
	}
	
	return 0;
}

int CardFind::find_straight(vector<Card> &input, vector<Card> &output)
{
    if (input.size() == 0)
    {
        return -1;
    }
	output.clear();
	CardStatistics card_stat;
	card_stat.statistics(input);
	CardFind::get_straight(card_stat, output);
	
	return 0;
}

int CardFind::get_straight(CardStatistics &card_stat, vector<Card> &output)
{
	vector<Card> straight_one_longest;
	vector<Card> straight_two_longest;
	vector<Card> straight_three_longest;

	get_longest_straight(card_stat.line1, 1, straight_one_longest);
	get_longest_straight(card_stat.line2, 2, straight_two_longest);
	get_longest_straight(card_stat.line3, 3, straight_three_longest);
	
	Card::dump_cards(straight_one_longest, "One");
	Card::dump_cards(straight_two_longest, "Two");
	Card::dump_cards(straight_three_longest, "Three");
	
	output.clear();

	int cnt = get_max(straight_one_longest.size(), straight_two_longest.size(), straight_three_longest.size());
	if (cnt == 1)
	{
		output = straight_one_longest;
	}
	else if (cnt == 2)
	{
		output = straight_two_longest;
	}
	else if (cnt == 3)
	{
		output = straight_three_longest;
#if 1
		int one = straight_three_longest.size() / 3;
		int cnt = card_stat.card1.size();
		if (cnt >= one)
		{
			for (int i = 0; i < cnt; i++)
			{
				if (i == one)
                {
					return 0;
				}
                output.push_back(card_stat.card1[i]);
			}
		}
		
        cnt = card_stat.card2.size() / 2;
		if (cnt >= one)
		{
			for (int i = 0; i < cnt; i++)
			{
				if (i == one)
                {
					return 0;
				}
                output.push_back(card_stat.card2[i * 2]);
                output.push_back(card_stat.card2[i * 2 + 1]);
			}
		}
#endif
	}
	
	return 0;
}

int CardFind::get_max(unsigned int a, unsigned int b, unsigned int c)
{
	if (c >= a && c >= b && c >= 6)
	{
		return 3;
	}
	
	if (b >= a && b >= c && b >= 6)
	{
		return 2;
	}
	
	if (a >= b && a >= c && a >= 5)
	{
		return 1;
	}
	
	return 0;
}

void CardFind::get_longest_straight(vector<Card> &input, int type, vector<Card> &output)
{
	unsigned int cnt = 0;
	unsigned int last_cnt = 0;
	unsigned int index = 0;
	unsigned int i = 0;
	Card temp;
	int flag = 0;
	for (i = 0; i < input.size(); i += type)
	{
		if (input[i].face >= 15)
		{
			break;
		}
		// printf("[%d][%d][%d][%d][%d][%d]\n", type, input[i].face, temp.face, cnt,last_cnt, index);
		if ((input[i].face - temp.face) != 1)
		{
			if (cnt > last_cnt)
			{
				index = i;
				last_cnt = cnt;
			}
			flag = 1;
			cnt = 0;
		}
		else
		{
			flag = 0;
		}
		cnt += type;
		temp = input[i];
	}
	
	if (flag == 0)
	{
		if (cnt > last_cnt)
		{
			index = i;
			last_cnt = cnt;
		}
	}
	output.clear();
	// printf("copy[%d][%u][%u]\n", type, index - last_cnt, index);
	for (unsigned int i = (index - last_cnt); i < index; i++)
	{
		output.push_back(input[i]);
	}
}

int CardFind::find_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &target_card_stat)
{
	clear();

	if (type == CARD_TYPE_ERROR)
	{
		type = card_ana.type;
	}

	
	if (type != CARD_TYPE_ERROR)
	{

		if (0 == get_face_from_ana(card_ana,type))
		{
			return 0;
		}


	
		if (type == CARD_TYPE_ROCKET)
		{
			return 0;
		}
		
		if (type == CARD_TYPE_ONE)
		{
			find_one_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_TWO)
		{
			find_two_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_THREE)
		{
			find_three_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_ONELINE)
		{
			find_one_line_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_TWOLINE)
		{
			find_two_line_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_THREELINE)
		{
			find_three_line_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_THREEWITHONE)
		{
			find_three_with_one_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_THREEWITHTWO)
		{
			find_three_with_two_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_PLANEWITHONE)
		{
			find_plane_with_one_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_PLANEWITHWING)
		{
			find_plane_with_wing_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_FOURWITHONE)
		{
			find_four_with_one_super(card_ana, card_stat, target_card_stat);
		}
		else if (type == CARD_TYPE_FOURWITHTWO)
		{
			find_four_with_two_super(card_ana, card_stat, target_card_stat);
		}
		find_soft_bomb(card_ana, card_stat, target_card_stat);
		find_hard_bomb(card_ana, card_stat, target_card_stat);
		find_super_bomb(card_ana, card_stat, target_card_stat);		
		find_rocket(card_ana, card_stat, target_card_stat);
	}
	
	return 0;


}



int CardFind::find_soft_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int bomb_start_face = 0;

	if ( (card_ana.type == CARD_TYPE_ROCKET)
		|| (card_ana.type == CARD_TYPE_SUPERBOMB)
		|| (card_ana.type == CARD_TYPE_HARDBOMB)
		|| (card_ana.type == CARD_TYPE_BOMB)		
		)
	{
		return 0;
	}

	if (card_ana.type == CARD_TYPE_SOFTBOMB)
	{
		bomb_start_face = card_ana.face;
	}

	for (i = 0; i < my_card_stat.card3.size(); i=i+3)
	{
		if ((unsigned int)my_card_stat.card3[i].face <= bomb_start_face)
		{
			continue;
		}
	
		if (my_card_stat.cards_super.size() >= 1)		
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card3[i]);
			cards.push_back(my_card_stat.card3[i+1]);
			cards.push_back(my_card_stat.card3[i+2]);
			cards.push_back(my_card_stat.cards_super[0]);			
			results.push_back(cards);
		}
	}	

	for (i = 0; i < my_card_stat.card2.size(); i=i+2)
	{
		if ((unsigned int)my_card_stat.card2[i].face <= bomb_start_face)
		{
			continue;
		}
		
		if (my_card_stat.cards_super.size() >= 2)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card2[i]);
			cards.push_back(my_card_stat.card2[i+1]);
			cards.push_back(my_card_stat.cards_super[0]);
			cards.push_back(my_card_stat.cards_super[1]);				
			results.push_back(cards);
		}
	}	

	
	for (i = 0; i < my_card_stat.card1.size(); i++)
	{
		if ((unsigned int)my_card_stat.card1[i].face <= bomb_start_face)
		{
			continue;
		}

	
		if (my_card_stat.cards_super.size() >= 3)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card1[i]);
			cards.push_back(my_card_stat.cards_super[0]);
			cards.push_back(my_card_stat.cards_super[1]);
			cards.push_back(my_card_stat.cards_super[2]);			
			results.push_back(cards);
		}
	}

	return 1;
}

int CardFind::find_super_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
//	unsigned int i = 0;
//	unsigned int bomb_start_face = 0;

	if (card_ana.type == CARD_TYPE_ROCKET)
	{
		return 0;
	}

	if ( my_card_stat.cards_super.size() == 4 )
	{
		vector<Card> cards;
		cards.push_back(my_card_stat.cards_super[0]);
		cards.push_back(my_card_stat.cards_super[1]);
		cards.push_back(my_card_stat.cards_super[2]);	
		cards.push_back(my_card_stat.cards_super[3]);			
		results.push_back(cards);
	}

	return 1;
}


int CardFind::find_hard_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int bomb_start_face = 0;

	if ( (card_ana.type == CARD_TYPE_ROCKET)
		|| (card_ana.type == CARD_TYPE_SUPERBOMB)
		)
	{
		return 0;
	}

	if ( (card_ana.type == CARD_TYPE_HARDBOMB)
		|| (card_ana.type == CARD_TYPE_BOMB)
		)
	{
		bomb_start_face = card_ana.face;
	}

	for (i = 0; i < my_card_stat.card4.size(); i=i+4)
	{
		if ((unsigned int)my_card_stat.card4[i].face <= bomb_start_face)
		{
			continue;
		}
		
		vector<Card> cards;
		cards.push_back(my_card_stat.card4[i]);
		cards.push_back(my_card_stat.card4[i+1]);
		cards.push_back(my_card_stat.card4[i+2]);
		cards.push_back(my_card_stat.card4[i+3]);		
		results.push_back(cards);
	}

	return 1;
}



int CardFind::find_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	for (i = 0; i < my_card_stat.card1.size(); i++)
	{
		if (my_card_stat.card1[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card1[i]);
			results.push_back(cards);
		}
	}

	for (i = 0; i < my_card_stat.card2.size(); i++)
	{
		if (my_card_stat.card2[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card2[i]);
			results.push_back(cards);
		}
	}

	for (i = 0; i < my_card_stat.card3.size(); i++)
	{
		if (my_card_stat.card3[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card3[i]);
			results.push_back(cards);
		}
	}

	for (i = 0; i < my_card_stat.card4.size(); i++)
	{
		if (my_card_stat.card4[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card4[i]);
			results.push_back(cards);
		}
	}

	for (i = 0; i < my_card_stat.cards_super.size(); i++)
	{
		if (super_face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.cards_super[i]);
			results.push_back(cards);
		}
	}	

	return 1;
}

int CardFind::find_two_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	for (i = 0; i < my_card_stat.card2.size(); i=i+2)
	{
		if (my_card_stat.card2[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card2[i]);
			cards.push_back(my_card_stat.card2[i+1]);			
			results.push_back(cards);
		}
	}

	for (i = 0; i < my_card_stat.card3.size(); i=i+3)
	{
		if (my_card_stat.card3[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card3[i]);
			cards.push_back(my_card_stat.card3[i+1]);			
			results.push_back(cards);
		}
	}	

	for (i = 0; i < my_card_stat.card4.size(); i=i+4)
	{
		if (my_card_stat.card4[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card4[i]);
			cards.push_back(my_card_stat.card4[i+1]);			
			results.push_back(cards);
		}
	}	

	
	for (i = 0; i < my_card_stat.card1.size(); i++)
	{
		if ( (my_card_stat.card1[i].face > card_ana.face)
			&& (my_card_stat.cards_super.size() >= 1)
			)
		{
			if (my_card_stat.card1[i].face>=CARD_FACE_SMALL)
			{
				continue;
			}
			vector<Card> cards;
			cards.push_back(my_card_stat.card1[i]);
			cards.push_back(my_card_stat.cards_super[0]);			
			results.push_back(cards);
		}
	}

	if ( (super_face > card_ana.face) 
		&& (my_card_stat.cards_super.size()>=2)
		)
	{
		vector<Card> cards;
		cards.push_back(my_card_stat.cards_super[0]);
		cards.push_back(my_card_stat.cards_super[1]);		
		results.push_back(cards);
	}

	return 1;
}

int CardFind::find_three_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;


	for (i = 0; i < my_card_stat.card3.size(); i=i+3)
	{
		if (my_card_stat.card3[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card3[i]);
			cards.push_back(my_card_stat.card3[i+1]);
			cards.push_back(my_card_stat.card3[i+2]);			
			results.push_back(cards);
		}
	}	

	for (i = 0; i < my_card_stat.card4.size(); i=i+4)
	{
		if (my_card_stat.card4[i].face > card_ana.face)
		{
			vector<Card> cards;
			cards.push_back(my_card_stat.card4[i]);
			cards.push_back(my_card_stat.card4[i+1]);
			cards.push_back(my_card_stat.card4[i+2]);			
			results.push_back(cards);
		}
	}

	for (i = 0; i < my_card_stat.card2.size(); i=i+2)
	{
		if ( (my_card_stat.card2[i].face > card_ana.face)
			&& (my_card_stat.cards_super.size() >= 1)
			)
		{
			if (my_card_stat.card2[i].face>=CARD_FACE_SMALL)
			{
				continue;
			}

			vector<Card> cards;
			cards.push_back(my_card_stat.card2[i]);
			cards.push_back(my_card_stat.card2[i+1]);
			cards.push_back(my_card_stat.cards_super[0]);			
			results.push_back(cards);
		}
	}	

	
	for (i = 0; i < my_card_stat.card1.size(); i++)
	{
		if ( (my_card_stat.card1[i].face > card_ana.face)
			&& (my_card_stat.cards_super.size() >= 2)
			)
		{

			if (my_card_stat.card1[i].face>=CARD_FACE_SMALL)
			{
				continue;
			}
	
			vector<Card> cards;
			cards.push_back(my_card_stat.card1[i]);
			cards.push_back(my_card_stat.cards_super[0]);
			cards.push_back(my_card_stat.cards_super[1]);			
			results.push_back(cards);
		}
	}

	if ( (super_face > card_ana.face) 
		&& (my_card_stat.cards_super.size()>=3)
		)
	{
		vector<Card> cards;
		cards.push_back(my_card_stat.cards_super[0]);
		cards.push_back(my_card_stat.cards_super[1]);
		cards.push_back(my_card_stat.cards_super[2]);		
		results.push_back(cards);
	}

	return 1;
}



int CardFind::find_one_line_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;

	super_face = my_card_stat.super_face;

	if ( card_stat.len < 5 )
	{
		return 0;
	}	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}	

	unsigned int plane_len = card_stat.len;

	int total_match = 0;
	unsigned int temp_len = 0;	

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_ONELINE);

	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3+plane_len-1;i<=CARD_FACE_A;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}
		
			total_match = 0;
			temp_len = plane_len;
		
			do
			{
				total_match += ( (my_card_stat.facelist[i-temp_len+1]) >= 1 ) ? 1:(my_card_stat.facelist[i-temp_len+1]);		
				temp_len--;
			}while(temp_len > 0);

			if ( (total_match+use_super_num_limit) >= plane_len )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);
				vector<Card> cards_result;
				unsigned int super_num_used_first = plane_len - total_match;
//				unsigned int super_num_left = use_super_num_limit-super_num_used_first;
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if(my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if ( (my_card_stat.cards[j].face <= get_face) 
						&& (my_card_stat.cards[j].face >= (get_face-(int)plane_len+1) )
						)
					{

						if ( j >= 1 )
						{
							if(my_card_stat.cards[j].face != my_card_stat.cards[j-1].face)
							{
								cards_result.push_back(my_card_stat.cards[j]);
							}
						}
						else
						{
							cards_result.push_back(my_card_stat.cards[j]);
						}
					}
				}

				for(k=0;k<super_num_used_first;k++)
				{
					cards_result.push_back(cards_super_temp.back());
					cards_super_temp.pop_back();
				}
				add_result_element(cards_result);

			}
			else
			{
				continue;
			}

		}
		
	}

	return 0;

}


int CardFind::find_two_line_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;

	super_face = my_card_stat.super_face;

	if ( card_stat.len < 6 )
	{
		return 0;
	}	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}	

	unsigned int plane_len = (card_stat.len)/2;

	int total_match = 0;
	unsigned int temp_len = 0;

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_TWOLINE);


	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3+plane_len-1;i<=CARD_FACE_A;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}

		
			total_match = 0;
			temp_len = plane_len;
		
			do
			{
				total_match += ( (my_card_stat.facelist[i-temp_len+1]) >= 2 ) ? 2:(my_card_stat.facelist[i-temp_len+1]);		
				temp_len--;
			}while(temp_len > 0);

			if ( (total_match+use_super_num_limit) >= 2*plane_len )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);
				vector<Card> cards_result;
				unsigned int super_num_used_first = 2*plane_len - total_match;
//				unsigned int super_num_left = use_super_num_limit-super_num_used_first;
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if(my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if ( (my_card_stat.cards[j].face <= get_face) 
						&& (my_card_stat.cards[j].face >= (get_face-(int)plane_len+1) )
						)
					{

						if ( j >= 2 )
						{
							if(my_card_stat.cards[j].face != my_card_stat.cards[j-2].face)
							{
								cards_result.push_back(my_card_stat.cards[j]);
							}
						}
						else
						{
							cards_result.push_back(my_card_stat.cards[j]);
						}
					}
				}

				for(k=0;k<super_num_used_first;k++)
				{
					cards_result.push_back(cards_super_temp.back());
					cards_super_temp.pop_back();
				}
				
				add_result_element(cards_result);
			}
			else
			{
				continue;
			}

		}
		
	}

	return 0;

}


int CardFind::find_three_line_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;

	super_face = my_card_stat.super_face;

	if ( card_stat.len < 6 )
	{
		return 0;
	}	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}	

	unsigned int plane_len = (card_stat.len)/3;

	int total_match = 0;
	unsigned int temp_len = 0;	
	
	int last_face = get_face_from_ana(card_ana,CARD_TYPE_THREELINE);

	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3+plane_len-1;i<=CARD_FACE_A;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}

		
			total_match = 0;
			temp_len = plane_len;
		
			do
			{
				total_match += ( (my_card_stat.facelist[i-temp_len+1]) >= 3 ) ? 3:(my_card_stat.facelist[i-temp_len+1]);		
				temp_len--;
			}while(temp_len > 0);

			// already find  33 333 333 or 3333
			if ( (total_match+use_super_num_limit) >= 3*plane_len )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);
				vector<Card> cards_result;
				unsigned int super_num_used_first = 3*plane_len - total_match;
//				unsigned int super_num_left = use_super_num_limit-super_num_used_first;
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if(my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if ( (my_card_stat.cards[j].face <= get_face) 
						&& (my_card_stat.cards[j].face >= (get_face-(int)plane_len+1) )
						)
					{

						if ( j >= 3 )
						{
							if(my_card_stat.cards[j].face != my_card_stat.cards[j-3].face)
							{
								cards_result.push_back(my_card_stat.cards[j]);
							}
						}
						else
						{
							cards_result.push_back(my_card_stat.cards[j]);
						}
					}
				}

				for(k=0;k<super_num_used_first;k++)
				{
					cards_result.push_back(cards_super_temp.back());
					cards_super_temp.pop_back();
				}

				add_result_element(cards_result);			

			}
			else
			{
				continue;
			}

		}
		
	}

	return 0;

}


int CardFind::find_three_with_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;

	super_face = my_card_stat.super_face;	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}

	unsigned int with_len = 1;	

	int total_match = 0;

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_THREEWITHONE);


	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3;i<=CARD_FACE_2_15;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}		

			total_match = (my_card_stat.facelist[i]>=3)?3:my_card_stat.facelist[i];
		
			if ( (total_match+use_super_num_limit) >= 3 )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);
			
				unsigned int super_num_used_first = 3 - total_match;
				unsigned int super_num_left = use_super_num_limit-super_num_used_first;				
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if (my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if (my_card_stat.cards[j].face == get_face) 
					{
						cards_result1.push_back(my_card_stat.cards[j]);
					}
					else
					{
						cards_left.push_back(my_card_stat.cards[j]);
					}
				}

				printf("####card_stat_left = ####\n");
				CardStatistics card_stat_left = CardStatistics(super_face);
				card_stat_left.statistics(cards_left);

				find_with_one(card_stat_left, 1, cards_super_temp, super_num_left);
				
				if (cards_result2.size() == with_len)
				{
					for(k=0;k<super_num_used_first;k++)
					{
						cards_result3.push_back(cards_super_temp.back());
						cards_super_temp.pop_back();		
					}
					add_result_element(cards_result1,cards_result2,cards_result3);
				}
				else
				{
					continue;
				}

			}
			else
			{
				continue;
			}

		}
	
	}

	return 0;

}



int CardFind::find_three_with_two_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;

	super_face = my_card_stat.super_face;	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}

	unsigned with_len = 2;	

	int total_match = 0;

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_THREEWITHTWO);


	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3;i<=CARD_FACE_2_15;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}		

			total_match = (my_card_stat.facelist[i]>=3)?3:my_card_stat.facelist[i];
			
			if ( (total_match+use_super_num_limit) >= 3 )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);

				for(j = 0;j < my_card_stat.cards_super.size();j++)
				{
					cards_super_temp.push_back(my_card_stat.cards_super[j]);
				}

				unsigned int super_num_used_first = 3 - total_match;
				unsigned int super_num_left = use_super_num_limit-super_num_used_first;				
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if (my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if (my_card_stat.cards[j].face == get_face) 
					{
						cards_result1.push_back(my_card_stat.cards[j]);
					}
					else
					{
						cards_left.push_back(my_card_stat.cards[j]);
					}
				}

				printf("####card_stat_left = ####\n");
				CardStatistics card_stat_left = CardStatistics(super_face);
				card_stat_left.statistics(cards_left);

				find_with_two(card_stat_left, with_len, cards_super_temp, super_num_left);			
				
				if (cards_result2.size() == with_len)
				{
					for(k=0;k<super_num_used_first;k++)
					{
						cards_result3.push_back(cards_super_temp.back());
						cards_super_temp.pop_back();		
					}
					add_result_element(cards_result1,cards_result2,cards_result3);
				}
				else
				{
					continue;
				}
			}
			else
			{
				continue;
			}

		}
	
	}

	return 0;

}



int CardFind::find_plane_with_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0; 
	int get_face = 0;
	unsigned int use_super_num_limit = 0;

	super_face = my_card_stat.super_face;	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}	

	unsigned int plane_len = (card_stat.len)/4;
	unsigned int with_len = plane_len;

	int total_match = 0;
	unsigned int temp_len = 0;	

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_PLANEWITHONE);


	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3+plane_len-1;i<=CARD_FACE_A;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}

			total_match = 0;
			temp_len = plane_len;
		
			do
			{
				total_match += ( (my_card_stat.facelist[i-temp_len+1]) >= 3 ) ? 3:(my_card_stat.facelist[i-temp_len+1]);		
				temp_len--;
			}while(temp_len > 0);

			// already find  33 333 333 or 3333
			if ( (total_match+use_super_num_limit) >= 3*plane_len )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);

				unsigned int super_num_used_first = 3*plane_len - total_match;
				unsigned int super_num_left = use_super_num_limit-super_num_used_first; 			
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if(my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if ( (my_card_stat.cards[j].face <= get_face) 
						&& (my_card_stat.cards[j].face >= (get_face-(int)plane_len+1) )
						)
					{

						if ( j >= 3 )
						{
							if(my_card_stat.cards[j].face == my_card_stat.cards[j-3].face)
							{
								cards_left.push_back(my_card_stat.cards[j]);				
							}
							else
							{
								cards_result1.push_back(my_card_stat.cards[j]);
							}
						}
						else
						{
							cards_result1.push_back(my_card_stat.cards[j]);
						}
					}
					else
					{
						cards_left.push_back(my_card_stat.cards[j]);
					}
				}

				printf("####card_stat_left = ####\n");
				CardStatistics card_stat_left = CardStatistics(super_face);
				card_stat_left.statistics(cards_left);

				find_with_one(card_stat_left, with_len, cards_super_temp, super_num_left);			
				
				if (cards_result2.size() == with_len)
				{
					for(k=0;k<super_num_used_first;k++)
					{
						cards_result3.push_back(cards_super_temp.back());
						cards_super_temp.pop_back();		
					}
					add_result_element(cards_result1,cards_result2,cards_result3);
				}
				else
				{
					continue;
				}			
			}
			else
			{
				continue;
			}

		}
		
	}

	return 0;
}




int CardFind::find_plane_with_wing_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;

	super_face = my_card_stat.super_face;	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}	

	unsigned int plane_len = (card_stat.len)/5;
	unsigned int with_len = plane_len*2;

	int total_match = 0;
	unsigned int temp_len = 0;	

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_PLANEWITHWING);


	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3+plane_len-1;i<=CARD_FACE_A;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}

			total_match = 0;
			temp_len = plane_len;
		
			do
			{
				total_match += ( (my_card_stat.facelist[i-temp_len+1]) >= 3 ) ? 3:(my_card_stat.facelist[i-temp_len+1]);		
				temp_len--;
			}while(temp_len > 0);

			// already find  33 333 333 or 3333
			if ( (total_match+use_super_num_limit) >= 3*plane_len )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);

				unsigned int super_num_used_first = 3*plane_len - total_match;
				unsigned int super_num_left = use_super_num_limit-super_num_used_first;				
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if(my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if ( (my_card_stat.cards[j].face <= get_face) 
						&& (my_card_stat.cards[j].face >= (get_face-(int)plane_len+1) )
						)
					{

						if ( j >= 3 )
						{
							if(my_card_stat.cards[j].face == my_card_stat.cards[j-3].face)
							{
								cards_left.push_back(my_card_stat.cards[j]);				
							}
							else
							{
								cards_result1.push_back(my_card_stat.cards[j]);
							}
						}
						else
						{
							cards_result1.push_back(my_card_stat.cards[j]);
						}
					}
					else
					{
						cards_left.push_back(my_card_stat.cards[j]);
					}
				}

				printf("####card_stat_left = ####\n");
				CardStatistics card_stat_left = CardStatistics(super_face);
				card_stat_left.statistics(cards_left);

				find_with_two(card_stat_left, with_len, cards_super_temp, super_num_left);			
				
				if (cards_result2.size() == with_len)
				{

					for(k=0;k<super_num_used_first;k++)
					{
						cards_result3.push_back(cards_super_temp.back());
						cards_super_temp.pop_back();		
					}
					add_result_element(cards_result1,cards_result2,cards_result3);
				}
				else
				{
					continue;
				}			
			}
			else
			{
				continue;
			}

		}
	
	}

	return 0;
	
}



int CardFind::find_four_with_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;	

	super_face = my_card_stat.super_face;

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}

	int total_match = 0;
	unsigned with_len = 2;

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_FOURWITHONE);


	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3;i<=CARD_FACE_2_15;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}		

			total_match = my_card_stat.facelist[i];
			
			if ( (total_match+use_super_num_limit) >= 4 )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);			

				unsigned int super_num_used_first = 4 - total_match;
				unsigned int super_num_left = use_super_num_limit-super_num_used_first;				
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if (my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}
			
					if (my_card_stat.cards[j].face == get_face) 
					{
						cards_result1.push_back(my_card_stat.cards[j]);
					}
					else
					{
						cards_left.push_back(my_card_stat.cards[j]);
					}
				}

				printf("####card_stat_left = ####\n");
				CardStatistics card_stat_left = CardStatistics(super_face);
				card_stat_left.statistics(cards_left);

				find_with_one(card_stat_left, with_len, cards_super_temp, super_num_left);		
				
				if (cards_result2.size() == with_len)
				{

					for(k=0;k<super_num_used_first;k++)
					{
						cards_result3.push_back(cards_super_temp.back());
						cards_super_temp.pop_back();		
					}
					add_result_element(cards_result1,cards_result2,cards_result3);
				}
				else
				{
					continue;
				}
			}
			else
			{

				continue;
			}


		}

		
	}


	return 0;

}


int CardFind::find_four_with_two_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;	
	int get_face = 0;
	unsigned int use_super_num_limit = 0;	

	super_face = my_card_stat.super_face;	

	if ( my_card_stat.len < card_stat.len )
	{
		return 0;
	}

	int total_match = 0;
	unsigned int with_len = 4;	

	int last_face = get_face_from_ana(card_ana,CARD_TYPE_FOURWITHTWO);

	for(use_super_num_limit = 0;use_super_num_limit <= my_card_stat.super_num;use_super_num_limit++)
	{

		for(i=CARD_FACE_3;i<=CARD_FACE_2_15;i++)
		{
			if ( i <= (unsigned int)last_face )
			{
				continue;
			}		

			total_match = my_card_stat.facelist[i];
			
			if ( (total_match+use_super_num_limit) >= 4 )
			{
				clear_temp_result();
				init_cards_super_temp(my_card_stat);

				unsigned int super_num_used_first = 4 - total_match;
				unsigned int super_num_left = use_super_num_limit-super_num_used_first;				
				get_face = i;

				for(j = 0; j < my_card_stat.len;j++)
				{
					if (my_card_stat.cards[j].face == super_face)
					{	
						continue;
					}

					if (my_card_stat.cards[j].face == get_face) 
					{
						cards_result1.push_back(my_card_stat.cards[j]);
					}
					else
					{
						cards_left.push_back(my_card_stat.cards[j]);
					}
				}

				printf("####card_stat_left = ####\n");
				CardStatistics card_stat_left = CardStatistics(super_face);
				card_stat_left.statistics(cards_left);

				find_with_two(card_stat_left, with_len, cards_super_temp, super_num_left);			
				
				if (cards_result2.size() == with_len)
				{
					for(k=0;k<super_num_used_first;k++)
					{
						cards_result3.push_back(cards_super_temp.back());
						cards_super_temp.pop_back();		
					}
					add_result_element(cards_result1,cards_result2,cards_result3);
				}
				else
				{
					continue;
				}				

			}
			else
			{

				continue;
			}


		}

		
	}


	return 0;

}

void CardFind::find_with_two(CardStatistics &card_stat,int with_len,vector<Card> &cards_super_temp,unsigned int super_num_left)
{
	unsigned int j = 0;
	unsigned int use_super_num_left = super_num_left;

	for(j=0;j<card_stat.card2.size();j=j+2)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}				
		cards_result2.push_back(card_stat.card2[j]);
		cards_result2.push_back(card_stat.card2[j+1]);
	}

	for(j=0;j<card_stat.card3.size();j=j+3)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}
		cards_result2.push_back(card_stat.card3[j]);
		cards_result2.push_back(card_stat.card3[j+1]);
	}

	for(j=0;j<card_stat.card1.size();j++)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}
		
		if (card_stat.card1[j].face <= CARD_FACE_2_15)
		{
			if (use_super_num_left > 0)
			{
				use_super_num_left--;
			}
			else
			{
				break;
			}

			cards_result2.push_back(card_stat.card1[j]);
			cards_result2.push_back(cards_super_temp.back());
			cards_super_temp.pop_back();
		}
	}

	for(j=0;j<card_stat.card3.size();j=j+3)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}	

		if (use_super_num_left > 0)
		{
			use_super_num_left--;
		}
		else
		{
			break;
		}

		cards_result2.push_back(card_stat.card3[j+2]);
		cards_result2.push_back(cards_super_temp.back());
		cards_super_temp.pop_back();

	}	


}

void CardFind::find_with_one(CardStatistics &card_stat,int with_len,vector<Card> &cards_super_temp,unsigned int super_num_left)
{
	unsigned int j = 0;

	for(j=0;j<card_stat.card1.size();j++)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}
		cards_result2.push_back(card_stat.card1[j]);

	}				

	for(j=0;j<card_stat.card2.size();j++)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}				
		cards_result2.push_back(card_stat.card2[j]);
	}

	for(j=0;j<card_stat.card3.size();j++)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}
		cards_result2.push_back(card_stat.card3[j]);
	}

	for(j=0;j<super_num_left;j++)
	{
		if (cards_result2.size() == with_len)
		{
			break;
		}
		cards_result2.push_back(cards_super_temp.back());
		cards_super_temp.pop_back();
	}


}

void CardFind::clear_temp_result(void)
{
	cards_result1.clear();
	cards_result2.clear();
	cards_result3.clear();
	cards_left.clear();
	cards_super_temp.clear();
}

void CardFind::init_cards_super_temp(CardStatistics &card_stat)
{
	cards_super_temp.clear();

	for(unsigned int j = 0;j < card_stat.cards_super.size();j++)
	{
		cards_super_temp.push_back(card_stat.cards_super[j]);
	}

}

void CardFind::add_result_element(vector<Card> cards_result1)
{
	unsigned int i = 0;
	CardStatistics card_stat0 =  CardStatistics(this->super_face);
	CardAnalysis card_ana0;

	unsigned int get_face = 0; 
	unsigned int face_is_exist = 0;

	card_stat0.statistics(cards_result1);
	card_ana0.analysis(card_stat0); 

	get_face = get_face_from_ana(card_ana0, this->type);

	if (get_face == 0)
	{
		return;
	}

	for(i = 0;i < results_faces.size();i++)
	{
		if ( get_face == results_faces[i] )
		{
			face_is_exist = 1;
		}
	}

	if (face_is_exist == 0)
	{
		results_faces.push_back(get_face);
		results.push_back(cards_result1);		
	}

	return;



}


void CardFind::add_result_element(vector<Card> cards_result1,vector<Card> cards_result2,vector<Card> cards_result3)
{
	unsigned int i = 0;
	vector<Card> cards;
	CardStatistics card_stat0 =  CardStatistics(this->super_face);
	CardAnalysis card_ana0;

	unsigned int get_face = 0; 
	unsigned int face_is_exist = 0;

	for(i = 0;i < cards_result1.size();i++)
	{
		cards.push_back(cards_result1[i]);
	}

	for(i = 0;i < cards_result2.size();i++)
	{
		cards.push_back(cards_result2[i]);
	}

	for(i = 0;i < cards_result3.size();i++)
	{
		cards.push_back(cards_result3[i]);
	}

	card_stat0.statistics(cards);
	card_ana0.analysis(card_stat0);	

	get_face = get_face_from_ana(card_ana0, this->type);

	if (get_face == 0)
	{
		return;
	}

	for(i = 0;i < results_faces.size();i++)
	{
		if ( get_face == results_faces[i] )
		{
			face_is_exist = 1;
		}
	}

	if (face_is_exist == 0)
	{
		results_faces.push_back(get_face);
		results.push_back(cards);		
	}

	return;
}

int CardFind::get_face_from_ana(CardAnalysis &card_ana,int type)
{
	if (card_ana.type == type)
	{
		return card_ana.face;
	}

	if (card_ana.type_other[0] == type)
	{
		return card_ana.face_other[0];
	}

	if (card_ana.type_other[1] == type)
	{
		return card_ana.face_other[1];
	}

	if (card_ana.type_other[2] == type)
	{
		return card_ana.face_other[2];
	}

	return 0;
}




void CardFind::debug()
{
	for (unsigned int i = 0; i < results.size(); i++)
	{
		Card::dump_cards(results[i], "tip");
	}
}


int CardFind::tip(vector<int> &last, vector<int> &cur)
{
    if (last.size() == 0)
    {
        return -1;
    }
    
    if (cur.size() == 0)
    {
        return -2;
    }
    
    clear();
    
	vector<Card> cards0;
	for (unsigned int i = 0; i < last.size(); i++)
	{
		Card card(last[i]);
		cards0.push_back(card);
	}
	CardStatistics card_stat0;
	card_stat0.statistics(cards0);
	CardAnalysis card_ana0;
	card_ana0.analysis(card_stat0);
    if (card_ana0.type == 0)
    {
        return -1;
    }
	
    vector<Card> cards1;
	for (unsigned int i = 0; i < cur.size(); i++)
	{
		Card card(cur[i]);
		cards1.push_back(card);
	}
	CardStatistics card_stat1;
	card_stat1.statistics(cards1);
    find(card_ana0, card_stat0, card_stat1,0,0,0);
    
    return 0;
}

int CardFind::tip_super(vector<int> &last, vector<int> &cur,int type,int super_face)
{
    if (last.size() == 0)
    {
        return -1;
    }
    
    if (cur.size() == 0)
    {
        return -2;
    }

	if (super_face == 0)
	{
//		fprintf(stdout, "####111isNSuper");
		return tip(last,cur);
	}
	clear();
	init(type,super_face);

	vector<Card> cards0;
	for (unsigned int i = 0; i < last.size(); i++)
	{
		Card card(last[i]);
		cards0.push_back(card);
	}
	CardStatistics card_stat0 = CardStatistics(super_face);
	card_stat0.statistics(cards0);
	CardAnalysis card_ana0;
	card_ana0.analysis(card_stat0);
	if (card_ana0.type == 0)
	{
		return -1;
	}

	vector<Card> cards1;
	for (unsigned int i = 0; i < cur.size(); i++)
	{
		Card card(cur[i]);
		cards1.push_back(card);
	}
	CardStatistics card_stat1 = CardStatistics(super_face);;
	card_stat1.statistics(cards1);

	find_super(card_ana0, card_stat0, card_stat1);

	/*for(unsigned int i=0;i<results.size();i++)
	{
		Card::dump_cards(results[i], "result:");
	}*/

	return 0;
}

int CardFind::tip_super(vector<Card> &last, vector<Card> &cur,int type,int super_face,int last_hole_size,int last_is_partner)
{
    if (last.size() == 0)
    {
        return -1;
    }

    if (cur.size() == 0)
    {
        return -2;
    }

	if (super_face == 0)
	{
//		fprintf(stdout, "####111isNSuper");
		return tip(last,cur,last_hole_size,last_is_partner);
	}
    clear();
	init(type,super_face);
	CardStatistics card_stat0 = CardStatistics(super_face);
	card_stat0.statistics(last);
	CardAnalysis card_ana0;
	card_ana0.analysis(card_stat0);
    if (card_ana0.type == 0)
    {
        return -1;
    }

	CardStatistics card_stat1 = CardStatistics(super_face);;
	card_stat1.statistics(cur);

    find_super(card_ana0, card_stat0, card_stat1);

/*	for(unsigned int i=0;i<results.size();i++)
	{
		Card::dump_cards(results[i], "result:");
	}*/

	return is_hit_partner(last_is_partner,card_ana0.type,card_ana0.face,cur.size());
}

int CardFind::is_hit_partner(int last_is_partner,int cardType,int cardFace,int curSize)
{
	if(last_is_partner){
		if(((cardType == CARD_TYPE_ONE || cardType == CARD_TYPE_TWO)
				&& cardFace<Card::Ace) || (results.size() > 0 && results[0].size() == curSize)){
			return 0;
		}
		return -1;
	}
	return 0;
}

int CardFind::tip(vector<Card> &last, vector<Card> &cur,int last_hole_size,int last_is_partner)
{
    if (last.size() == 0)
    {
        return -1;
    }
    
    if (cur.size() == 0)
    {
        return -2;
    }
    
    clear();
    
	CardStatistics card_stat0;
	card_stat0.statistics(last);
	CardAnalysis card_ana0;
	card_ana0.analysis(card_stat0);

/*	fprintf(stdout, "@@@@Start###\n");
	card_stat0.debug();
	fprintf(stdout, "@@@@End[%d][%d][%d]###\n",last_is_partner,card_ana0.type,card_ana0.face);*/

    if (card_ana0.type == 0)
    {
        return -1;
    }

    CardStatistics card_stat1;
	card_stat1.statistics(cur);
/*	fprintf(stdout, "####Start1###\n");
	card_stat1.debug();
	fprintf(stdout, "####End1###\n");*/
	find(card_ana0, card_stat0, card_stat1, last_is_partner,last_hole_size,cur.size());
	/*fprintf(stdout, "####Start2###\n");
	debug();
	fprintf(stdout, "####End2###\n");*/

	return is_hit_partner(last_is_partner,card_ana0.type,card_ana0.face,cur.size());
}

void CardFind::test(int input0[], int len0, int input1[], int len1)
{
	vector<Card> cards0;
	for (int i = 0; i < len0; i++)
	{
		Card card(input0[i]);
		cards0.push_back(card);
	}
	CardStatistics card_stat0;
	card_stat0.statistics(cards0);
	CardAnalysis card_ana0;
	card_ana0.analysis(card_stat0);
	Card::dump_cards(cards0);
	card_ana0.debug();
	
	vector<Card> cards1;
	for (int i = 0; i < len1; i++)
	{
		Card card(input1[i]);
		cards1.push_back(card);
	}
	CardStatistics card_stat1;
	card_stat1.statistics(cards1);
	
	CardFind card_find;
	card_find.find(card_ana0, card_stat0, card_stat1,10,0,0);
	card_find.debug();
	
}

void CardFind::test(int input[], int len)
{
	vector<Card> cards;
	for (int i = 0; i < len; i++)
	{
		Card card(input[i]);
		cards.push_back(card);	
	}
	CardStatistics card_stat;
	card_stat.statistics(cards);
	CardFind::get_straight(card_stat, cards);
	Card::dump_cards(cards, "Longest");
}


//dcow
//提示牌型，计算牌型
int CardFind::tip_dcow(vector<Card> &card_ana)
{
    vector<Card> cards0;//用于存储10,J,Q,K的花牌
    vector<Card> cards1;//用于存储非花的牌
    
    if (card_ana.size() == 0)
    {
        return -1;
    }
    
    clear();
    
    //是否为五小牛
    if (find_card_type_is_wxn(card_ana)) {
        add_cards_results_type_is_wxn(card_ana);
        
        return 0;
    }
    //是否为四炸
    if (find_card_type_is_bomb(card_ana)) {
        add_cards_results_type_is_bomb(card_ana);
        
        return 0;
    }
    //是否为五花牛
    if (find_card_type_is_whn(card_ana)) {
        add_cards_results_type_is_whn(card_ana);
        
        return 0;
    }
    
    //分组：3 + 2
    for (unsigned int i = 0; i < card_ana.size(); i++)
    {
        if (card_ana[i].face>=1 && card_ana[i].face<=9) {
            cards1.push_back(card_ana[i]);
        }else{
            cards0.push_back(card_ana[i]);
        }
    }
    
    switch(cards1.size())
    {
        case 0 :  //五张都是 >=10
            add_cards_results_face_type_is_five_greater_or_equal_ten(cards0);
            break;
        case 1 :  //四张是 >=10
        case 2 :  //三张是 >=10
            add_cards_results_face_type_is_four_three_greater_or_equal_ten(cards0,cards1);
            break;
        case 3 :  //两张是 >=10
            add_cards_results_face_type_is_two_greater_or_equal_ten(cards0,cards1);
            break;
        case 4 :  //一张是 >=10
            add_cards_results_face_type_is_one_greater_or_equal_ten(cards0,cards1);
            break;
        case 5 :  //五张都 <10
            add_cards_results_face_type_is_five_less_ten(cards1);
            break;
    }
    
    
    return 0;
}

//五张非花牌，分组凑点数
int cardGroupFive[10][CARDS_MAX]={
    {0,1,2,3,4},
    {0,1,3,2,4},
    {0,1,4,2,3},
    {0,2,3,1,4},
    {0,2,4,1,3},
    {0,3,4,1,2},
    {1,2,3,0,4},
    {1,2,4,0,3},
    {1,3,4,0,2},
    {2,3,4,1,2},
};

//是否为五小牛
bool CardFind::find_card_type_is_wxn(vector<Card> &card_ana)
{
    int faceTotal = card_ana[0].face + card_ana[1].face + card_ana[2].face + card_ana[3].face + card_ana[4].face;
    if ((card_ana[0].face>=CARD_FACE_A && card_ana[0].face<=CARD_FACE_5)
        && (card_ana[1].face>=CARD_FACE_A && card_ana[1].face<=CARD_FACE_5)
        && (card_ana[2].face>=CARD_FACE_A && card_ana[2].face<=CARD_FACE_5)
        && (card_ana[3].face>=CARD_FACE_A && card_ana[3].face<=CARD_FACE_5)
        && (card_ana[4].face>=CARD_FACE_A && card_ana[4].face<=CARD_FACE_5)
        && (faceTotal<=CARD_FACE_10)) {
        
        return true;
    }
    
    return false;
}

//是否为四炸
bool CardFind::find_card_type_is_bomb(vector<Card> &card_ana)
{
    int i = 0;
    int num = 0;
    for (i=0; i<CARDS_MAX; i++) {
        num = 0;
        for (int j=0; j<CARDS_MAX; j++) {
            if (card_ana[j].face == card_ana[i].face) {
                num ++;
            }
        }
        if (num == 4) {
            break;
        }
    }
    
    if ((i < CARDS_MAX) && num == 4) {
        return true;
    }
    return false;
}

//是否为五花牛
bool CardFind::find_card_type_is_whn(vector<Card> &card_ana)
{
    if ((card_ana[0].face>=CARD_FACE_J && card_ana[0].face<=CARD_FACE_K)
        && (card_ana[1].face>=CARD_FACE_J && card_ana[1].face<=CARD_FACE_K)
        && (card_ana[2].face>=CARD_FACE_J && card_ana[2].face<=CARD_FACE_K)
        && (card_ana[3].face>=CARD_FACE_J && card_ana[3].face<=CARD_FACE_K)
        && (card_ana[4].face>=CARD_FACE_J && card_ana[4].face<=CARD_FACE_K)){
        
        return true;
    }
    
    return false;
}

//添加五小牛牌型结果
void CardFind::add_cards_results_type_is_wxn(vector<Card> &card_ana)
{
    for (int i=0; i<card_ana.size(); i++) {
        results_dcow.push_back(card_ana[i]);
    }
    Card::sort_by_descending(results_dcow);
    cow_card_type = CARD_TYPE_COW_WXN;
    
}

//添加四炸牌型结果
void CardFind::add_cards_results_type_is_bomb(vector<Card> &card_ana)
{
    int i = 0;
    int num = 0;
    int leftIndex = 0;
    for (i=0; i<CARDS_MAX; i++) {
        num = 0;
        for (int j=0; j<CARDS_MAX; j++) {
            if (card_ana[j].face == card_ana[i].face) {
                num ++;
            }
        }
        if (num == 4) {
            break;
        }
    }
    
    if ((i < CARDS_MAX) && num == 4) {
        for (int k=0; k<CARDS_MAX; k++) {
            if (card_ana[k] == card_ana[i]) {
                results_dcow.push_back(card_ana[k]);
            }else{
                leftIndex = k;
            }
        }
    }
    
    Card::sort_by_descending(results_dcow);
    results_dcow.push_back(card_ana[leftIndex]);
    
    cow_card_type = CARD_TYPE_COW_BOMB;
    
}

//添加五花牛牌型结果
void CardFind::add_cards_results_type_is_whn(vector<Card> &card_ana)
{
    for (int i=0; i<card_ana.size(); i++) {
        results_dcow.push_back(card_ana[i]);
    }
    Card::sort_by_descending(results_dcow);
    cow_card_type = CARD_TYPE_COW_WHN;
    
}


//添加五张都 >=10，牛牛
void CardFind::add_cards_results_face_type_is_five_greater_or_equal_ten(vector<Card> &card_ana)
{
    Card::sort_by_descending(card_ana);
    for (int i=0; i<card_ana.size(); i++) {
        results_dcow.push_back(card_ana[i]);
    }
    cow_card_type = CARD_TYPE_COW_TEN;
}


//添加 四张/三张 都 >=10, 只需根据 <10 的牌之和来判断点数
void CardFind::add_cards_results_face_type_is_four_three_greater_or_equal_ten(vector<Card> &card_ana0,vector<Card> &card_ana1)
{
    vector<Card> cardsLocal;
    Card::sort_by_descending(card_ana0);
    for (int i=0; i<card_ana0.size(); i++) {
        results_dcow.push_back(card_ana0[i]);
    }
    for (int i=0; i<card_ana1.size(); i++) {
        results_dcow.push_back(card_ana1[i]);
        cardsLocal.push_back(card_ana1[i]);
    }
    
    cow_card_type = get_type_from_cow_card_type(cardsLocal);
}


//添加 两张 >=10,
//判断规则：
//1 三张非花牌和为十的倍数时，牌型为牛牛；2 三张非花牌中任意2张和为十；3 没牛
void CardFind::add_cards_results_face_type_is_two_greater_or_equal_ten(vector<Card> &card_ana0,vector<Card> &card_ana1)
{
    vector<Card> cardsLocal;
    vector<Card> cardsLocal1;
    int cardFaceNum = 0;
    for (int i=0; i<card_ana1.size(); i++) {
        cardFaceNum += card_ana1[i].face;
    }
    
    if (cardFaceNum%10==0) { //三张非花牌和为十的倍数时
        cow_card_type = CARD_TYPE_COW_TEN;//牛牛
        Card::sort_by_descending(card_ana1);
        for (int i=0; i<card_ana1.size(); i++) {
            results_dcow.push_back(card_ana1[i]);
        }
        for (int i=0; i<card_ana0.size(); i++) {
            results_dcow.push_back(card_ana0[i]);
        }
        
    }else if((card_ana1[0].face+card_ana1[1].face)%10 == 0
             || (card_ana1[0].face+card_ana1[2].face)%10 == 0
             || (card_ana1[1].face+card_ana1[2].face)%10 == 0){ //以下是有两张牌和为10时
        
        int leftIndex = 0;
        Card::sort_by_descending(card_ana0);
        results_dcow.push_back(card_ana0[0]);
        if ((card_ana1[0].face+card_ana1[1].face)%10 == 0){
            cardsLocal.push_back(card_ana1[0]);
            cardsLocal.push_back(card_ana1[1]);
            leftIndex = 2;
        }else if ((card_ana1[0].face+card_ana1[2].face)%10 == 0){
            cardsLocal.push_back(card_ana1[0]);
            cardsLocal.push_back(card_ana1[2]);
            leftIndex = 1;
        }else if ((card_ana1[1].face+card_ana1[2].face)%10 == 0){
            cardsLocal.push_back(card_ana1[1]);
            cardsLocal.push_back(card_ana1[2]);
            leftIndex = 0;
        }
        
        Card::sort_by_descending(cardsLocal);
        for (int i=0; i<cardsLocal.size(); i++) {
            results_dcow.push_back(cardsLocal[i]);
        }
        
        results_dcow.push_back(card_ana0[1]);
        results_dcow.push_back(card_ana1[leftIndex]);
        
        cardsLocal1.push_back(card_ana0[1]);
        cardsLocal1.push_back(card_ana1[leftIndex]);
        
        cow_card_type = get_type_from_cow_card_type(cardsLocal1);
        
    }else{ //没牛
        Card::sort_by_descending(card_ana0);
        for (int i=0; i<card_ana0.size(); i++) {
            results_dcow.push_back(card_ana0[i]);
        }
        Card::sort_by_descending(card_ana1);
        for (unsigned int i=0; i<card_ana1.size(); i++) {
            results_dcow.push_back(card_ana1[i]);
        }
        
        cow_card_type = CARD_TYPE_COW_NO;
    }
    
}


//添加 只有一张 >=10,
//判断规则：
//1 其中有三张非花牌和为十的倍数时 ；2 其中有两张非花牌中任意2张和为十；3 //其中有两张非花牌和为十的倍数时; 4 没牛
void CardFind::add_cards_results_face_type_is_one_greater_or_equal_ten(vector<Card> &card_ana0,vector<Card> &card_ana1)
{
    vector<Card> cardsLocal0;
    vector<Card> cardsLocal1;
    
   if((card_ana1[0].face+card_ana1[1].face)%10 == 0
             || (card_ana1[0].face+card_ana1[2].face)%10 == 0
             || (card_ana1[0].face+card_ana1[3].face)%10 == 0
             || (card_ana1[1].face+card_ana1[2].face)%10 == 0
             || (card_ana1[1].face+card_ana1[3].face)%10 == 0
             || (card_ana1[2].face+card_ana1[3].face)%10 == 0){//其中有两张非花牌和为十的倍数时
    
        int leftTwoIndex[2];
        
        if ((card_ana1[0].face+card_ana1[1].face)%10 == 0) {
            cardsLocal0.push_back(card_ana1[0]);
            cardsLocal0.push_back(card_ana1[1]);
            
            leftTwoIndex[0]=2;
            leftTwoIndex[1]=3;
        }else if ((card_ana1[0].face+card_ana1[2].face)%10 == 0){
            cardsLocal0.push_back(card_ana1[0]);
            cardsLocal0.push_back(card_ana1[2]);
            
            leftTwoIndex[0]=1;
            leftTwoIndex[1]=3;
        }else if ((card_ana1[0].face+card_ana1[3].face)%10 == 0){
            cardsLocal0.push_back(card_ana1[0]);
            cardsLocal0.push_back(card_ana1[3]);
            
            leftTwoIndex[0]=1;
            leftTwoIndex[1]=2;
        }else if ((card_ana1[1].face+card_ana1[2].face)%10 == 0){
            cardsLocal0.push_back(card_ana1[1]);
            cardsLocal0.push_back(card_ana1[2]);
            
            leftTwoIndex[0]=0;
            leftTwoIndex[1]=3;
        }else if ((card_ana1[1].face+card_ana1[3].face)%10 == 0){
            cardsLocal0.push_back(card_ana1[1]);
            cardsLocal0.push_back(card_ana1[3]);
            
            leftTwoIndex[0]=0;
            leftTwoIndex[1]=2;
        }else if ((card_ana1[2].face+card_ana1[3].face)%10 == 0){
            cardsLocal0.push_back(card_ana1[2]);
            cardsLocal0.push_back(card_ana1[3]);
            
            leftTwoIndex[0]=0;
            leftTwoIndex[1]=1;
        }
        
        results_dcow.push_back(card_ana0[0]);
        Card::sort_by_descending(cardsLocal0);
        for (int i=0; i<cardsLocal0.size(); i++) {
            results_dcow.push_back(cardsLocal0[i]);
        }
        
        cardsLocal1.push_back(card_ana1[leftTwoIndex[0]]);
        cardsLocal1.push_back(card_ana1[leftTwoIndex[1]]);
        Card::sort_by_descending(cardsLocal1);
        
        for (int i=0; i<cardsLocal1.size(); i++) {
            results_dcow.push_back(cardsLocal1[i]);
        }
        
        cow_card_type = get_type_from_cow_card_type(cardsLocal1);

   }else  if((card_ana1[0].face+card_ana1[1].face+card_ana1[2].face)%10 == 0
             || (card_ana1[0].face+card_ana1[1].face+card_ana1[3].face)%10 == 0
             || (card_ana1[0].face+card_ana1[2].face+card_ana1[3].face)%10 == 0
             || (card_ana1[1].face+card_ana1[2].face+card_ana1[3].face)%10 == 0){//其中有三张非花牌和为十的倍数时
       
       int leftOneIndex;
       
       if ((card_ana1[0].face+card_ana1[1].face+card_ana1[2].face)%10 == 0) {
           cardsLocal0.push_back(card_ana1[0]);
           cardsLocal0.push_back(card_ana1[1]);
           cardsLocal0.push_back(card_ana1[2]);
           
           leftOneIndex = 3;
           
       }else if ((card_ana1[0].face+card_ana1[1].face+card_ana1[3].face)%10 == 0){
           cardsLocal0.push_back(card_ana1[0]);
           cardsLocal0.push_back(card_ana1[1]);
           cardsLocal0.push_back(card_ana1[3]);
           
           leftOneIndex = 2;
       }else if ((card_ana1[0].face+card_ana1[2].face+card_ana1[3].face)%10 == 0){
           cardsLocal0.push_back(card_ana1[0]);
           cardsLocal0.push_back(card_ana1[2]);
           cardsLocal0.push_back(card_ana1[3]);
           
           leftOneIndex = 1;
       }else if ((card_ana1[1].face+card_ana1[2].face+card_ana1[3].face)%10 == 0){
           cardsLocal0.push_back(card_ana1[1]);
           cardsLocal0.push_back(card_ana1[2]);
           cardsLocal0.push_back(card_ana1[3]);
           
           leftOneIndex = 0;
       }
       
       Card::sort_by_descending(cardsLocal0);
       for (int i=0; i<cardsLocal0.size(); i++) {
           results_dcow.push_back(cardsLocal0[i]);
       }
       results_dcow.push_back(card_ana0[0]);
       results_dcow.push_back(card_ana1[leftOneIndex]);
       
       cardsLocal1.push_back(card_ana0[0]);
       cardsLocal1.push_back(card_ana1[leftOneIndex]);
       
       cow_card_type = get_type_from_cow_card_type(cardsLocal1);
       
   }else{ //没牛
        Card::sort_by_descending(card_ana0);
        for (int i=0; i<card_ana0.size(); i++) {
            results_dcow.push_back(card_ana0[i]);
        }
        Card::sort_by_descending(card_ana1);
        for (int i=0; i<card_ana1.size(); i++) {
            results_dcow.push_back(card_ana1[i]);
        }
        
        cow_card_type = CARD_TYPE_COW_NO;
    }
    
}


//添加 五张都 <10,
//必须用三张牌来凑点数,否则没牛
void CardFind::add_cards_results_face_type_is_five_less_ten(vector<Card> &card_ana)
{
    vector<Card> cardsLocal;
    int groupIndex = -1;
    
    if ((card_ana[0].face+card_ana[1].face+card_ana[2].face)%10 == 0) {
        groupIndex = 0;
    }else if ((card_ana[0].face+card_ana[1].face+card_ana[3].face)%10 == 0) {
        groupIndex = 1;
    }else if ((card_ana[0].face+card_ana[1].face+card_ana[4].face)%10 == 0) {
        groupIndex = 2;
    }else if ((card_ana[0].face+card_ana[2].face+card_ana[3].face)%10 == 0) {
        groupIndex = 3;
    }else if ((card_ana[0].face+card_ana[2].face+card_ana[4].face)%10 == 0) {
        groupIndex = 4;
    }else if ((card_ana[0].face+card_ana[3].face+card_ana[4].face)%10 == 0) {
        groupIndex = 5;
    }else if ((card_ana[1].face+card_ana[2].face+card_ana[3].face)%10 == 0) {
        groupIndex = 6;
    }else if ((card_ana[1].face+card_ana[2].face+card_ana[4].face)%10 == 0) {
        groupIndex = 7;
    }else if ((card_ana[1].face+card_ana[3].face+card_ana[4].face)%10 == 0) {
        groupIndex = 8;
    }else if ((card_ana[2].face+card_ana[3].face+card_ana[4].face)%10 == 0) {
        groupIndex = 9;
    }else { //没牛
        Card::sort_by_descending(card_ana);
        for (int i=0; i<CARDS_MAX; i++) {
            results_dcow.push_back(card_ana[i]);
        }
        
        cow_card_type = CARD_TYPE_COW_NO;
    }
    
    if (groupIndex >= 0) {
        for (int i=0; i<3; i++) {
            results_dcow.push_back(card_ana[cardGroupFive[groupIndex][i]]);
        }
        Card::sort_by_descending(results_dcow);
        for (int i=3; i<CARDS_MAX; i++) {
            cardsLocal.push_back(card_ana[cardGroupFive[groupIndex][i]]);
        }
        
        Card::sort_by_descending(cardsLocal);
        for (int i=0; i<2; i++) {
            results_dcow.push_back(cardsLocal[i]);
        }
        
        cow_card_type = get_type_from_cow_card_type(cardsLocal);
    }
}

//默认没牛牌型
void CardFind::add_cards_results_default_type_is_no(vector<Card> &card_ana)
{
    Card::sort_by_descending(card_ana);
    for (int i=0; i<CARDS_MAX; i++) {
        results_dcow.push_back(card_ana[i]);
    }
    
    cow_card_type = CARD_TYPE_COW_NO;
}

//返回牛型
int CardFind::get_type_from_cow_card_type(vector<Card> card_ana)
{
    int cardsNum=0;
    int card_type = 0;
    for (unsigned int i=0; i<card_ana.size(); i++) {
        int face = 0;
        face = get_cards_change_face(card_ana[i].face);
        cardsNum += face;
    }
    
    if (cardsNum%10==0) {
        card_type = CARD_TYPE_COW_TEN;
    }else{
        card_type = 1 + cardsNum%10;
    }
    
    return card_type;
}



//选中2张以内牌的点数和
int CardFind::get_cards_select_total_num(vector<int> &card_input)
{
    int cardsTotalNum = 0;
    if (card_input.size() == 0)
    {
        return 0;
    }
    
	vector<Card> cards;
	for (unsigned int i = 0; i < card_input.size(); i++)
	{
		Card card(card_input[i]);
		cards.push_back(card);
        
        int face = 0;
        face = get_cards_change_face(cards[i].face);
        cardsTotalNum += face;
	}
    
    return cardsTotalNum;
}

//选中3张牌的点数和，牌型
int CardFind::get_cards_select_type(vector<int> &card_input, vector<Card> &card_left)
{
    int cardsTotalNum = 0;
    int cardType = -1;
    if (card_input.size() == 0 || card_left.size() == 0)
    {
        return -1;
    }
    
	vector<Card> cards;
	for (unsigned int i = 0; i < card_input.size(); i++)
	{
		Card card(card_input[i]);
		cards.push_back(card);
        
        int face = 0;
        face = get_cards_change_face(cards[i].face);
        cardsTotalNum += face;
	}
    
    if (cardsTotalNum%10 == 0) {
        cardType = get_type_from_cow_card_type(card_left);
    }else{
        cardType = CARD_TYPE_COW_NO;
    }
    
    return cardType;
}

//返回是否为五小牛/四炸/五花牛
int CardFind::find_card_type_is_need_to_show(vector<Card> &card_ana){

    clear();
    
    int type = CARD_TYPE_COW_ERROR;
    
    if (find_card_type_is_wxn(card_ana)) {
        add_cards_results_type_is_wxn(card_ana);
        type = CARD_TYPE_COW_WXN;
    }else if (find_card_type_is_bomb(card_ana)){
        add_cards_results_type_is_bomb(card_ana);
        type = CARD_TYPE_COW_BOMB;
    }else if (find_card_type_is_whn(card_ana)){
        add_cards_results_type_is_whn(card_ana);
        type = CARD_TYPE_COW_WHN;
    }

    return type;
}

//face>=10 为10
int CardFind::get_cards_change_face(int face){
    if (face >=10) {
        return 10;
    }else{
        return face;
    }
}

// return: 1=闲家赢 , 0=闲家输
int CardFind::get_winner(vector<Card> &keeper_cards, int keeper_cardtype, vector<Card> &leisure_cards, int leisure_cardtype) {


//	log.debug("get_winner(keeper=%d, leisure=%d)\n", keeper_cardtype, leisure_cardtype);

	if(keeper_cardtype > leisure_cardtype) {
		return 0;
	}
	else if (keeper_cardtype < leisure_cardtype) {
		return 1;
	}
	else {
		//牌型一样，则比较第一张牌的牌面
		Card card_keeper;
		Card card_leisure;

		if (keeper_cards.size() == 5 && leisure_cards.size() == 5) {
			//找第一张牌
			card_keeper = keeper_cards[0];
			card_leisure = leisure_cards[0];

//			log.debug("card_leisure.card[%d, %d] , card_keeper.card[%d,%d]\n",card_leisure.face,card_leisure.suit, card_keeper.face,card_keeper.suit);

			int ret = Card::compare(card_leisure, card_keeper );
			if (ret == 1) {
				return 1;
			}
			else if (ret == -1) {
				return 0;
			}
		}
		else {
			return 0;
		}
	}

	return 0;
}


int CardFind::valid_cards(vector<Card> &ori_cards, vector<Card> &c_cards, vector<Card> &s_cards, int c_cardtype){

	Card::sort_by_ascending(s_cards);
	Card::sort_by_ascending(c_cards);
	int s = s_cards.size();
	int c = c_cards.size();

	//5张牌
	if (s == c && c == 5) {
		for (unsigned int i = 0; i < 5; i++) {
			Card c = c_cards[i];
			Card s = s_cards[i];
			if (c.value == s.value ) {
				continue;
			}
			else {
				//牌不一致
				return -1;
			}
		}
	}
	else {
		//牌不一致
		return -1;
	}

	if (ori_cards.size() != 5) {
		return -1;
	}

	//校验牌型，没牛则不做校验
	if (c_cardtype > 1 && c_cardtype <= CARD_TYPE_COW_TEN) {
		vector<Card> lastSecondCards;
		vector<int> threeCards;
		for (unsigned int i = 0; i < 3; i++) {
			threeCards.push_back(ori_cards[i].value);
		}
		for (unsigned int i = 3 ; i < 5; i++) {
			lastSecondCards.push_back(ori_cards[i]);
		}
		//选中3张牌的点数和，牌型
		int tmp_card_type =  CardFind::get_cards_select_type(threeCards, lastSecondCards);
		if (tmp_card_type == c_cardtype) {
			return 0;
		}
		else {
			return -1;
		}
	}
	else if( c_cardtype > CARD_TYPE_COW_TEN) {
		int ret = 0;
		switch(c_cardtype){
		case 12:  // 五花牛
			if(!find_card_type_is_whn(ori_cards)){
				ret = -1;
			}
			break;
		case 13: // 四炸
			if(!find_card_type_is_bomb(ori_cards)){
				ret = -1;
			}
			break;
		case 14: // 五小牛
			if(!find_card_type_is_wxn(ori_cards)){
				ret = -1;
			}
			break;
		default:
			ret = -1;
			break;
		}
		return ret;
	}

	return 0;
}





