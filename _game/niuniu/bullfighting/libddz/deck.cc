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

void Deck::get_hotpot_cards(HoleCards &holecards,int isNiceCard)
{
	Card card;
	holecards.clear();
	if(isNiceCard == 1 && niceCards.size()>0 && niceCards.size()%5 == 0){	// 取好牌
		for (int i = 0; i < 5; i++)
		{
			card = niceCards.back();
			holecards.add_card(card);
			niceCards.pop_back();
		}
	}else{	// 取普通牌
		for (int i = 0; i < 5; i++)
		{
			card = normalCards.back();
			holecards.add_card(card);
			normalCards.pop_back();
		}
	}
}

void Deck::fillBullfight(int niceSize,int seed)
{
	srand(time(NULL) + seed);
	if(niceSize<=0){		// 无需生成好牌
		normalCards.clear();
		for (int i = 0; i < 52; i++)
		{
			int face = card_arr[i] & 0xF;
			// Exclude bigKing smallKing
			if (face == 14 || face == 15)
			{
				continue;
			}
			Card c(card_arr[i]);
			normalCards.push_back(c);
		}
		random_shuffle(normalCards.begin(), normalCards.end());
	}else{					// 需要生成好牌
		smallCards.clear();
		bigCards.clear();
		niceCards.clear();
		normalCards.clear();
		bombIndList.clear();

		for (int i = 0; i < 52; i++)
		{
			int face = card_arr[i] & 0xF;
			if (face == 14 || face == 15)
			{
				continue;
			}
			Card c(card_arr[i]);
			if (face <= 4)
			{
				smallCards.push_back(c);
				continue;
			}
			if (face >= 11)
			{
				bigCards.push_back(c);
				continue;
			}
		}
		random_shuffle(smallCards.begin(), smallCards.end());
		random_shuffle(bigCards.begin(), bigCards.end());
		Card card;
		for (unsigned int i = 1; i <= niceSize; i++)
		{
			int ran = random(1,100);
			if(ran>0 && ran<=40 && smallCards.size()>=5){			// 可能出五小牛
				for(int j = 1; j<= 5; j++){
					card = smallCards.back();
					smallCards.pop_back();
					if (card.face >=4 ) {
						j--;
						continue;
					}
					niceCards.push_back(card);
				}
			}else if(ran>40 && ran<=80 && bigCards.size()>=5){   	// 必出五花牛
				for(int j = 1; j<= 5; j++){
					card = bigCards.back();
					niceCards.push_back(card);
					bigCards.pop_back();
				}
			}else{													// 四炸
				int bombInd = random(6,10);
				bombIndList.insert(bombInd);
			}
		}
		int bsize = bombIndList.size();
		// 过滤掉好牌，生成普通牌
		for (int i = 0; i < 52; i++)
		{
			int face = card_arr[i] & 0xF;
			if (bsize>0 && bombIndList.find(face) != bombIndList.end())
			{
				continue;
			}
			if(niceCards.size()>0 && isNiceCard(card_arr[i]) == 1){
				continue;
			}
			Card c(card_arr[i]);
			normalCards.push_back(c);
		}
		random_shuffle(normalCards.begin(), normalCards.end());

		// 产生4炸牌
		if(bsize>0){
			set<int>::iterator bomb_it;
			for (bomb_it = bombIndList.begin(); bomb_it != bombIndList.end(); bomb_it++)
			{
				int bomb_ind = *bomb_it;
				for (int j = 0; j < 4; j++)
				{
					int face = bomb_ind;
					int suit = j << 4;
					int value = face | suit;

					Card c(value);
					niceCards.push_back(c);
				}
				card = normalCards.back();
				niceCards.push_back(card);
				normalCards.pop_back();
			}
		}
	}
}

int Deck::isNiceCard(int val)
{
	int size = niceCards.size();
	for(int i=0 ; i<size ;i++){
		if(niceCards[i].value == val){
			return 1;
		}
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
		// Exclude bigKing smallKing
		if (face == 14 || face == 15)
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
	
	for (int i = 0; i < 5; i++)
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
