#include "card.h"

static char face_symbols[] = {
	 'A', '2', '3', '4', '5', '6', '7', '8', '9',
	'T', 'J', 'Q', 'K'
};

static char suit_symbols[] = {
	'd', 'c', 'h', 's', 'u'
};

Card::Card()
{
	face = suit = value = 0;
}

Card::Card(int val)
{
	value = val;
	
	face = value & 0xF;
	suit = value >> 4;
//	if (face < 3)
//		face += 13;
//	else if (face > 13)
//		face += 2;		// 16是小王  17是大王
	// printf("Face[%d] Suit[%d]\n", face, suit);
}

Card::Card(int face,int suit)
{
	this->face = face;
	this->suit = suit;
	
//	if ( (face == 14) || (face == 15) )
//	{
//		value = (face-13) + (suit << 4);	
//	}
//	else if ( (face == 16) || (face == 17) )
//	{
//		value = (face-2) + (suit << 4);	
//	}
//	else
	{
		value = face + (suit << 4);	
	}

}

void Card::set_val(int face,int suit)
{
	this->face = face;
	this->suit = suit;
//	if ( (face == 14) || (face == 15) )
//	{
//		value = (face-13) + (suit << 4);	
//	}
//	else if ( (face == 16) || (face == 17) )
//	{
//		value = (face-2) + (suit << 4);	
//	}
//	else
	{
		value = face + (suit << 4);	
	}
}

string Card::get_card()
{
	string card;
	
	/*
	char buf[32];
	snprintf(buf, sizeof(buf), "%d-%d", face, suit);
	card.append(buf);
	*/
	
	card.append(1, face_symbols[face - 3]);
	card.append(1, suit_symbols[suit]);
	
	return card;
}