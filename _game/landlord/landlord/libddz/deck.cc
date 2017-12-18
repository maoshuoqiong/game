#include <set>
#include <algorithm>
#include "deck.h"

static int card_arr[] = {
0x01, 0x11, 0x21, 0x31,		//A 14 
0x02, 0x12, 0x22, 0x32,		//2 15
0x03, 0x13, 0x23, 0x33,		//3 3
0x04, 0x14, 0x24, 0x34,		//4 4
0x05, 0x15, 0x25, 0x35,		//5 5
0x06, 0x16, 0x26, 0x36,		//6 6
0x07, 0x17, 0x27, 0x37,		//7 7
0x08, 0x18, 0x28, 0x38,		//8 8
0x09, 0x19, 0x29, 0x39,		//9 9
0x0A, 0x1A, 0x2A, 0x3A,		//10 10
0x0B, 0x1B, 0x2B, 0x3B,		//J 11
0x0C, 0x1C, 0x2C, 0x3C,		//Q 12
0x0D, 0x1D, 0x2D, 0x3D,		//K 13
0x0E, 0x0F};

int Deck::random(int start, int end)
{
	return start + rand() % (end - start + 1);
}

int Deck::cal_bomb_num(int rand, int bomb_0, int bomb_1, int bomb_2){
//	fprintf(stdout,"$$rand[%d]\n",rand);
	if(rand<=bomb_0){
		return 0;
	}
	bomb_0 += bomb_1;
	if(rand<=bomb_0){
		return 1;
	}
	bomb_0 += bomb_2;
	if(rand<=bomb_0){
		return 2;
	}
	return 0;
}

void Deck::fill(int seed, int bomb_0, int bomb_1, int bomb_2)
{
	cur = 0;
	vector<int> card_index;
    srand(time(NULL) + seed);
	for (unsigned int i = 1; i <= 13; i++)
	{
		card_index.push_back(i);
	}
	random_shuffle(card_index.begin(), card_index.end());
	
	pc[0] = cal_bomb_num(random(0, 1000),bomb_0,bomb_1,bomb_2);
	pc[1] = cal_bomb_num(random(0, 1000),bomb_0,bomb_1,bomb_2);
	pc[2] = cal_bomb_num(random(0, 1000),bomb_0,bomb_1,bomb_2);
//	fprintf(stdout,"$$bm[%d][%d][%d]\n",pc[0],pc[1],pc[2]);
	pv[0].clear();
	pv[1].clear();
	pv[2].clear();

	set<int> bomb;
	int value;
	for (int i = 0; i < pc[0]; i++)
	{
		value = card_index.back();
		pv[0].push_back(value);
		card_index.pop_back();
		bomb.insert(value);
	}
	
	for (int i = 0; i < pc[1]; i++)
	{
		value = card_index.back();
		pv[1].push_back(value);
		card_index.pop_back();
		bomb.insert(value);
	}
	
	for (int i = 0; i < pc[2]; i++)
	{
		value = card_index.back();
		pv[2].push_back(value);
		card_index.pop_back();
		bomb.insert(value);
	}
	
	cards.clear();
	for (int i = 0; i < 54; i++)
	{
		int face = card_arr[i] & 0xF;
		if (bomb.find(face) != bomb.end())
		{
			// printf("[0x%0x]\n", card_arr[i]);
			continue;
		}
		Card c(card_arr[i]);
		push(c);
	}
}

void Deck::filltmp()
{
	cards.clear();
	for (int i = 0; i < 54; i++)
	{
		int face = card_arr[i] & 0xF;
		if (face == 9)
		{
			// printf("[0x%0x]\n", card_arr[i]);
			continue;
		}
		Card c(card_arr[i]);
		push(c);
	}
}

void Deck::fill()
{
	cards.clear();
	
	for (int i = 0; i < 54; i++)
	{
		Card c(card_arr[i]);
		push(c);
	}
}

void Deck::empty()
{
	cards.clear();
}

int Deck::count() const
{
	return cards.size();
}

bool Deck::push(Card card)
{
	cards.push_back(card);
	return true;
}

bool Deck::pop(Card &card)
{
	if (!count())
		return false;
	
	card = cards.back();
	cards.pop_back();
	return true;
}

bool Deck::shuffle(int seed)
{
    srand(time(NULL) + seed);
	random_shuffle(cards.begin(), cards.end());
	return true;
}

void Deck::get_hole_cards(HoleCards &holecards)
{
	Card card;
	
	holecards.clear();
	for (int i = 0; i < 17; i++)
	{
		pop(card);
		holecards.add_card(card);
	}
}

void Deck::get_hole_cards_bomb(HoleCards &holecards)
{
	Card card;
	
	holecards.clear();
	printf("[[[[%d]]]]", pc[cur]);
	for (int i = 0; i < pc[cur]; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			int face = pv[cur][i];
			int suit = j << 4;
			int value = face | suit;
		
			Card c(value);
			holecards.add_card(c);	
		}
		printf("[%d]", pv[cur][i]);
	}
	printf("\n");
	
	for (int i = 0; i < (17 - (pc[cur] * 4)); i++)
	{
		pop(card);
		holecards.add_card(card);
	}
	cur++;
}
void Deck::get_hole_cards_bomb(HoleCards &holecards,int n)
{
	Card card;

	holecards.clear();
	int z =0;
	for (int j = 0; j < 4; j++)
	{
		int face = 9;
		int suit = j << 4;
		int value = face | suit;

		Card c(value);
		if((n==0 && j<2) || (n==1 && j>=2) ){
			holecards.add_card(c);
			z = 2;
		}
	}

	for (int i = 0; i < (17 - z); i++)
	{
		pop(card);
		holecards.add_card(card);
	}
	cur++;
}
void Deck::get_community_cards(CommunityCards &communitycards)
{
	Card card;
	communitycards.clear();
	for (int i = 0; i < 3; i++)
	{
		pop(card);
		communitycards.add_card(card);
	}
}

void Deck::debug()
{
	Card::dump_cards(cards);
}
