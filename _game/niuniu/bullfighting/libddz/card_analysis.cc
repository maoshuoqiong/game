//#include "stdafx.h"
#include "card.h"
#include "card_type.h"
#include "card_statistics.h"
#include "card_analysis.h"

static char *card_type_str[] = 
{
	(char*)"CARD_TYPE_ERROR", 
	(char*)"CARD_TYPE_ONE",
	(char*)"CARD_TYPE_ONELINE",
	(char*)"CARD_TYPE_TWO",
	(char*)"CARD_TYPE_TWOLINE",
	(char*)"CARD_TYPE_THREE",
	(char*)"CARD_TYPE_THREELINE",
	(char*)"CARD_TYPE_THREEWITHONE",
	(char*)"CARD_TYPE_THREEWITHTWO",
	(char*)"CARD_TYPE_PLANEWITHONE",
	(char*)"CARD_TYPE_PLANEWITHWING",
	(char*)"CARD_TYPE_FOURWITHONE",
	(char*)"CARD_TYPE_FOURWITHTWO",
	(char*)"CARD_TYPE_BOMB",
	(char*)"CARD_TYPE_ROCKET",
	(char*)"CARD_TYPE_SUPERBOMB",
	(char*)"CARD_TYPE_HARDBOMB",
	(char*)"CARD_TYPE_SOFTBOMB"	
};

CardAnalysis::CardAnalysis()
{	
	super_face = 0;
	type = 0;
	face = 0;
	type_other[0] = 0;
	face_other[0] = 0;
	type_other[1] = 0;
	face_other[1] = 0;
	type_other[2] = 0;
	face_other[2] = 0;
}

int CardAnalysis::analysis(CardStatistics &card_stat)
{
	type = CARD_TYPE_ERROR;
	
	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;
//	fprintf(stdout, "####superFaceNum[%d][%d]\n",super_face,super_num);

	if (super_face > 0)
	{
		type = analysis_super(card_stat);
//		fprintf(stdout, "####222isSuper[%d]\n",type);
		return type;
	}
//	fprintf(stdout, "####222NOSuper\n");
	switch(super_face)
	{

/******************************************************************/
/*************************no super**********************************/
/**************************************  ***************************/	
		case 0: 
			if (len == 0)
			{
				return type;
			}
			
			if (len == 1)
			{
				face = card_stat.card1[0].face;
				type = CARD_TYPE_ONE;
				return type;
			}
			
			if (len == 2)
			{
				if (card_stat.line1.size() == 1
					&& card_stat.card2.size() == 2)
				{
					face = card_stat.card2[1].face;
					type = CARD_TYPE_TWO;
					return type;
				} 
				else if (card_stat.line1.size() == 2
						&& card_stat.card1.size() == 2
						&& card_stat.card1[0].face == CARD_FACE_SMALL
						&& card_stat.card1[1].face == CARD_FACE_BIG)
				{
					face = card_stat.card1[1].face;
					type = CARD_TYPE_ROCKET;
					return type;	
				}
			}
			
			if (len == 3)
			{
				if (card_stat.card3.size() == 3)
				{
					face = card_stat.card3[2].face;
					type = CARD_TYPE_THREE;
					return type;
				}
			}
			
			if (len == 4)
			{
				if (card_stat.card4.size() == 4)
				{
					face = card_stat.card4[3].face;
					type = CARD_TYPE_BOMB;
					return type;
				}
				else if (card_stat.card1.size() == 1
						&& card_stat.card3.size() == 3)
				{
					face = card_stat.card3[2].face;
					type = CARD_TYPE_THREEWITHONE;
					return type;
				}
			}
			
			if (len == 5)
			{
				if (card_stat.card2.size() == 2
					&& card_stat.card3.size() == 3)
				{
					face = card_stat.card3[2].face;
					type = CARD_TYPE_THREEWITHTWO;
					return type;
				}
			}
			
			if (len == 6)
			{
				if (card_stat.card1.size() == 2
					&& card_stat.card4.size() == 4)
				{
					face = card_stat.card4[3].face;
					type = CARD_TYPE_FOURWITHONE;
					return type;
				}
			}
			
			if (len == 8)
			{
				if (card_stat.card2.size() == 4
					&& card_stat.card4.size() == 4)
				{
					face = card_stat.card4[3].face;
					type = CARD_TYPE_FOURWITHTWO;
					return type;
				}
			}
			
			if (card_stat.card1.size() == card_stat.line1.size()) {
				if (check_is_line(card_stat, 1)) {
					face = card_stat.card1[0].face;
					type = CARD_TYPE_ONELINE;
					return type;
				}
			}
			
			if (len == card_stat.card2.size()
				&& card_stat.card2.size() == card_stat.line2.size()) {
				if (check_is_line(card_stat, 2)) {
					face = card_stat.card2[0].face;
					type = CARD_TYPE_TWOLINE;
					return type;
				}
			}
			
			if (len < 6)
			{
				return type;
			}
			
			unsigned int left_card_len;
			if (card_stat.card3.size() == card_stat.line3.size()
				&& card_stat.card4.size() == 0 && card_stat.card3.size() != 0)
			{
				if (check_is_line(card_stat, 3))
				{

					left_card_len = card_stat.card1.size() + card_stat.card2.size();
					if (left_card_len == 0)
					{
						face = card_stat.card3[0].face;
						type = CARD_TYPE_THREELINE;
						return type;

					}
					else if (left_card_len * 3 == card_stat.card3.size())
					{
						face = card_stat.card3[0].face;
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}
					else if (card_stat.card1.size() == 0
						&& left_card_len * 3 == card_stat.card3.size() * 2)
					{
						face = card_stat.card3[0].face;
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}
				}
				
				if (check_arr_is_line(card_stat.card3, 3, 3, card_stat.card3.size())) 
				{
					left_card_len = card_stat.card1.size() + card_stat.card2.size() + 3;
					if (left_card_len * 3 == (card_stat.card3.size() - 3))
					{
						face = card_stat.card3[3].face;
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}
				}
			
				if (check_arr_is_line(card_stat.card3, 3, 0, card_stat.card3.size() - 3)) 
				{
					left_card_len = card_stat.card1.size() + card_stat.card2.size() + 3;
					if (left_card_len * 3 == (card_stat.card3.size() - 3))
					{
						face = card_stat.card3[0].face;
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}
				}
			}
			
			if (card_stat.card3.size() != 0 && check_arr_is_line(card_stat.card3, 3))
			{
				left_card_len = card_stat.card1.size() + card_stat.card2.size() + card_stat.card4.size();
				if (left_card_len * 3 == card_stat.card3.size()) {
					face = card_stat.card3[card_stat.card3.size() - 1].face;
					type = CARD_TYPE_PLANEWITHONE;
					return type;
				}
				else if (card_stat.card1.size() == 0 
					&& left_card_len * 3 == card_stat.card3.size() * 2)
				{
					face = card_stat.card3[card_stat.card3.size() - 1].face;
					type = CARD_TYPE_PLANEWITHWING;
					return type;
				}
			}
			break;

/******************************************************************/
/************************one super**********************************/
/**************************************  ***************************/
#if 0
		case 1: // one super
			if (len == 1)
			{
				face = super_face;
				type = CARD_TYPE_ONE;
				return type;
			}

			if (len == 2)
			{
				if( (card_stat.card1[0].face != CARD_FACE_SMALL)
				&& (card_stat.card1[0].face != CARD_FACE_BIG)
				)
				{
					face = card_stat.card1[0].face;
					type = CARD_TYPE_ONE;
					return type;			
				}
			}

			if (len == 3)
			{
				if (card_stat.card2.size() == 2)
				{
					face = card_stat.card2[1].face;
					type = CARD_TYPE_THREE;
					return type;
				}
			}

			if (len == 4)
			{
				if (card_stat.card3.size() == 3)
				{
					face = card_stat.card3[2].face;
					type = CARD_TYPE_BOMB;
					return type;
				}
				else if (card_stat.card2.size() == 2)
				{
					face = card_stat.card2[1].face;
					type = CARD_TYPE_THREEWITHONE;
					return type;
				}
			}

			if (len == 5)
			{
				if (card_stat.card2.size() == 4)
				{
					face = card_stat.card2[3].face;
					type = CARD_TYPE_THREEWITHTWO;
					return type;
				}
				else if (card_stat.card1.size() == 4)
				{
					face = card_stat.card1[3].face;
					type = CARD_TYPE_THREEWITHTWO;
					return type;
				}
			}

			if (len == 6)
			{
				if ( (card_stat.line1.size() == 3)
					&&(card_stat.card3.size() == 3)
					)
				{
					face = card_stat.card3[2].face;
					type = CARD_TYPE_FOURWITHONE;
					return type;
				}
				else if ( (card_stat.line1.size() == 3)
						&&(card_stat.line2.size() == 4)
						)
				{
					if( (get_face_if_arr_is_line_super(card_stat.line1,1,super_num))
						)
					{
						face = card_stat.line1[2].face;
						type = CARD_TYPE_TWOLINE;
						return type;
					}
				}
				else if ( (card_stat.line2.size() == 4)
					&&(card_stat.line3.size() == 3)
					)
				{
					if( (get_face_if_arr_is_line_super(card_stat.line2,2,super_num))
						)
					{
						face = card_stat.card3[2].face;
						type = CARD_TYPE_FOURWITHONE;					
						face_other[0] = card_stat.line2[3].face;
						type_other[0] = CARD_TYPE_THREELINE;
						return type;
					}
					else
					{
						face = card_stat.card3[2].face;
						type = CARD_TYPE_FOURWITHONE;
						return type;
					}
				}
			}	

			if (len == 8)
			{
				// 33 1
				if ( (card_stat.card3.size() == 6)
					&& (get_face_if_arr_is_line_super(card_stat.line3,3,super_num))
					)
				{
					face = card_stat.card3[5].face;
					type = CARD_TYPE_PLANEWITHONE;
					return type;
				}
				// 32 1 1
				else if( (card_stat.card3.size() == 3)
					&& (card_stat.line2.size() == 4)
					&& (card_stat.line1.size() == 4)
					&& (get_face_if_arr_is_line_super(card_stat.line2,2,super_num))
					)
				{
					face = card_stat.line2[3].face;
					type = CARD_TYPE_PLANEWITHONE;
					return type;
				}
				// 3 2 2
				else if( (card_stat.card3.size() == 3)
					&& (card_stat.card2.size() == 4)
					&& (card_stat.line2.size() == 6)					
					)
				{
					face = card_stat.card3[2].face;
					type = CARD_TYPE_FOURWITHTWO;				

					// 2-32 2-23
					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[2].face))
					{
						face_other[0] = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[2].face);
						type_other[0] = CARD_TYPE_PLANEWITHONE;
						return type;
					}

					// 23-2 32-2 
					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[0].face))
					{
						face_other[0] = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[0].face);
						type_other[0] = CARD_TYPE_PLANEWITHONE;
						return type;
					}
					
					// 2-3-2 3-2-2 2-2-3 22-3 3-22
					return type;
				}


			}

			if(len == 9)
			{
				// 2 3 3
				if ( (card_stat.line1.size() == 3)
					&&(card_stat.line2.size() == 6)
					&&(card_stat.card3.size() == 6)
					)
				{
					if(get_face_if_arr_is_line_super(card_stat.line2,2,super_num))
					{
						face = card_stat.line2[5].face;
						type = CARD_TYPE_THREELINE;
						return type;
					}
				}
			}

			if(len == 10)
			{
				// 33 2 1
				if ( (card_stat.line1.size() == 4)
					&&(card_stat.line2.size() == 6)
					&&(card_stat.line3.size() == 6)
					)
				{
					if(get_face_if_arr_is_line_super(card_stat.line3,3,super_num))
					{
						face = card_stat.line3[5].face;
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}
				}

				// 3 2 2 2
				if ( (card_stat.line1.size() == 4)
					&&(card_stat.line2.size() == 8)
					&&(card_stat.line3.size() == 3)
					)
				{
					// 2-2-23 2-2-32
					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[4].face))
					{
						face = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[4].face);
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}

					// 2-23-2 2-32-2
					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[2].face))
					{
						face = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[2].face);
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}

					// 23-2-2 32-2-2
					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[0].face))
					{
						face = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card2[0].face);
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}					

				}				
			}


			if ( len == 12 )
			{
				// 333 1 1
				if ( (card_stat.line1.size() == 5)
					&&(card_stat.line3.size() == 9)	
					)
				{
					face = get_face_if_arr_is_line_super(card_stat.line3,3,super_num);
					if (face == 0)
					{
						type = CARD_TYPE_ERROR;
						return type;
					}
					else
					{
						type = CARD_TYPE_PLANEWITHONE;
						return type;					
					}
				}

				// 332 1 1 1
				if ( (card_stat.line1.size() == 6)
					&&(card_stat.line2.size() == 6)
					&&(card_stat.line3.size() == 6)
					)
				{
					face = get_face_if_arr_is_line_super(card_stat.line2,2,super_num);
					if (face == 0)
					{
						type = CARD_TYPE_ERROR;
						return type;
					}
					else
					{
						type = CARD_TYPE_PLANEWITHONE;
						return type;					
					}
				}

				// 3 3 2 2 1
				if ( (card_stat.line1.size() == 5)
					&&(card_stat.line2.size() == 8)
					&&(card_stat.line3.size() == 6)
					)
				{
					// 2-332-1     2-323-1     2-233-1
					if (get_face_if_three_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[2].face))
					{
						face = get_face_if_three_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[2].face);
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}

					// 332-2-1     323-2-1     233-2-1
					if (get_face_if_three_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[0].face))
					{
						face = get_face_if_three_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[0].face);
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}

				}				

				// 3 3 3 2
				if ( (card_stat.line1.size() == 4)
					&&(card_stat.line2.size() == 8)
					&&(card_stat.line3.size() == 9)
					)
				{
					// 2333 
					if(get_face_if_arr_is_line_super(card_stat.line2,2,super_num))
					{
						face = card_stat.line2[7].face;;
						type = CARD_TYPE_PLANEWITHONE;
						face_other[0] = face;
						type_other[0] = CARD_TYPE_THREELINE;
						return type;
					}

					// 2-333 3-233 3-323 3-332
					if(get_face_if_arr_is_line_super(card_stat.line2,2,2,8,super_num))
					{
						face = card_stat.line2[7].face;
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}

					// 233-3 323-3 332-3 333-2
					if(get_face_if_arr_is_line_super(card_stat.line2,2,0,6,super_num))
					{
						face = card_stat.line2[5].face;
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}					



				

				}
	
			}

			
			if(len == 15)
			{
				// 1 2 2 333
				if ( (card_stat.line1.size() == 6)
					&&(card_stat.line2.size() == 10)
					&&(card_stat.line3.size() == 9)
					)
				{
					if(get_face_if_arr_is_line_super(card_stat.line3,3,super_num))
					{
						face = card_stat.line3[8].face;
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}
				}

				// 2 2 2 2 33
				if ( (card_stat.line1.size() == 6)
					&&(card_stat.line2.size() == 10)
					&&(card_stat.line3.size() == 9)
					)
				{
					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[6].face))
					{
						face = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[6].face);
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}

					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[4].face))
					{
						face = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[4].face);
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}

					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[2].face))
					{
						face = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[2].face);
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}
					
					if(get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[0].face))
					{
						face = get_face_if_two_face_together_line(card_stat.card3[0].face,card_stat.card3[3].face,card_stat.card2[0].face);
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}					
				}		



				// 2 3 3 3 3
				if ( (card_stat.line1.size() == 5)
					&&(card_stat.line2.size() == 10)
					&&(card_stat.line3.size() == 12)
					)
				{
					if(get_face_if_arr_is_line_super(card_stat.line2,2,super_num))
					{
						face = card_stat.line2[9].face;
						type = CARD_TYPE_THREELINE;
						return type;
					}
				}				
			}

			if(len == 16)
			{

				if (
						// 1 1 1 3 3 3 3
						( (card_stat.line1.size() == 7)
						&&(card_stat.line2.size() == 8)
						&&(card_stat.line3.size() == 12)
						)
						||
						//  1 1 1 1 2 3 3 3
						((card_stat.line1.size() == 8)
						&&(card_stat.line2.size() == 8)
						&&(card_stat.line3.size() == 9)
						)
					)	
				{
					if(get_face_if_arr_is_line_super(card_stat.line2,2,super_num))
					{
						face = card_stat.line3[7].face;
						type = CARD_TYPE_PLANEWITHONE;
						return type;
					}
				}
			}

			if(len == 18)
			{
				//  2 3 3 3 3 3
				if((card_stat.line1.size() == 6)
				&&(card_stat.line2.size() == 12)
				&&(card_stat.line3.size() == 15)
				)
				{
					if(get_face_if_arr_is_line_super(card_stat.line2,2,super_num))
					{
						face = card_stat.line3[11].face;
						type = CARD_TYPE_THREELINE;
						return type;
					}
				}
			}

			if(len == 20)
			{
				//  1 2 2 2 3 3 3 3
				if((card_stat.line1.size() == 8)
				&&(card_stat.line2.size() == 14)
				&&(card_stat.line3.size() == 12)
				)
				{
					if(get_face_if_arr_is_line_super(card_stat.line3,3,super_num))
					{
						face = card_stat.line3[11].face;
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}
				}


				//	2 2 2 2 2 3 3 3
				if((card_stat.line1.size() == 8)
				&&(card_stat.line2.size() == 14)
				&&(card_stat.line3.size() == 12)
				)
				{
					if(get_face_if_arr_is_line_super(card_stat.line3,3,super_num))
					{
						face = card_stat.line3[11].face;
						type = CARD_TYPE_PLANEWITHWING;
						return type;
					}
				}				
			}


			/************************one line**********************************/		
			if((card_stat.line1.size() == len-1)
			&&	( len <= 12 )
			&&	( len >= 5 )			
			)
			{
				face = get_face_if_arr_is_line_super(card_stat.line1,1,super_num);
				if(face)
				{
					type = CARD_TYPE_ONELINE;
					return type;
				}
			}

			/************************two line**********************************/		
			if((card_stat.line1.size() == len/2)
			&&	( card_stat.line2.size() == (len/2-1) )				
			&&	( len%2 == 0 )
			&&	( len >= 6 )			
			)
			{
				// get line1 face here(it is not line2 face)
				face = get_face_if_arr_is_line_super(card_stat.line1,1,super_num);
				if(face)
				{
					face = card_stat.line1(len/2-1);
					type = CARD_TYPE_TWOLINE;
					return type;
				}
			}			



			
			break;


/******************************************************************/
/************************two super**********************************/
/******************************************************************/
		case 2:
			if (len == 2)
			{
					face = super_face;
					type = CARD_TYPE_TWO;
					return type;
			}

			if (len == 3)
			{
				face = card_stat.card1[0].face;
				if (face <= CARD_FACE_2_15) // not small not big
				{
					face = card_stat.card1[0].face;
					type = CARD_TYPE_THREE;
					return type;
				}
			}

			if (len == 4)
			{
				if (card_stat.card2.size() == 2)
				{
					face = card_stat.card2[1].face;
					type = CARD_TYPE_BOMB;
					return type;
				}
				else if (card_stat.card1.size() == 2)
				{
					if (card_stat.card1[1].face <=CARD_FACE_2_15)
					{
						face = card_stat.card1[1].face;
						type = CARD_TYPE_THREEWITHONE;
						return type;
					}
					else if (card_stat.card2[0].face <=CARD_FACE_2_15)
					{
						face = card_stat.card1[0].face;
						type = CARD_TYPE_THREEWITHONE;
						return type;
					}
				}
			}

			
			break;




			
/******************************************************************/
/************************three super*********************************/
/**************************************  ***************************/
		case 3:
			break;

			
/******************************************************************/
/************************four super**********************************/
/******************************************************************/
		case 4:
			break;
#endif
		default:
			type = analysis_super(card_stat);
			break;



	}

	return type;
}

bool CardAnalysis::check_is_line(CardStatistics &card_stat, int line_type)
{
	if (line_type == 1)
	{
		return check_arr_is_line(card_stat.line1, line_type);	
	}
	else if (line_type == 2)
	{
		return check_arr_is_line(card_stat.line2, line_type);
	}
	else if (line_type == 3)
	{
		return check_arr_is_line(card_stat.line3, line_type);	
	}
	
	return false;
}

bool CardAnalysis::check_arr_is_line(std::vector<Card> &line, int line_type)
{
	/*
	int len = 1;
	Card card = line[0];
	for (unsigned int i = line_type; i < line.size(); i += line_type)
	{
		if ((card.face + 1) == line[i].face && line[i].face != 15) { // 2 is not straight (Line)
			len++;
			card = line[i];
		}
		else
		{
			return false;
		}
	}
	
	if (line_type == 1 && len > 4) // single straight
		return true;
	else if (line_type == 2 && len > 2) // double straight
		return true;
	else if (line_type == 3 && len > 1) // three straight
		return true;
	
	return false;
	*/
	return check_arr_is_line(line, line_type, 0, line.size());
}

bool CardAnalysis::check_arr_is_line(std::vector<Card> &line, int line_type, unsigned int begin, unsigned int end)
{
	int len = 1;
	Card card = line[begin];
	for (unsigned int i = (line_type + begin); i < end; i += line_type)
	{
		if ((card.face + 1) == line[i].face && line[i].face != CARD_FACE_2_15) { // 2 is not straight (Line)
			len++;
			card = line[i];
		}
		else
		{
			return false;
		}
	}
	
	if (line_type == 1 && len > 4) // single straight
		return true;
	else if (line_type == 2 && len > 2) // double straight
		return true;
	else if (line_type == 3 && len > 1) // three straight
		return true;
	
	return false;
}

bool CardAnalysis::compare(CardAnalysis &card_analysis)
{
	printf("compare type[%s] len[%d] face[%d] vs type[%s] len[%d] face[%d]\n",
				card_type_str[type], len, face, card_type_str[card_analysis.type], card_analysis.len, card_analysis.face);
	if (card_analysis.type == CARD_TYPE_ERROR)
	{
		return false;
	}
	
	if (type == CARD_TYPE_ROCKET)
	{
		return true;
	}
	
	if (card_analysis.type == CARD_TYPE_ROCKET)
	{
		return false;
	}
	
	if (type == card_analysis.type)
	{
		if (len == card_analysis.len
			&& face > card_analysis.face)
		{
			return true;
		}
	}
	else
	{
		if (type == CARD_TYPE_BOMB)
		{
			return true;	
		}
	}
	return false;
}

bool CardAnalysis::compare_super(CardAnalysis &card_analysis,int last_card_type,map<string, int> &card_ana_for_task)
{
	printf("compare type[%s] len[%d] face[%d] vs type[%s] len[%d] face[%d]\n",
				card_type_str[type], len, face, card_type_str[card_analysis.type], card_analysis.len, card_analysis.face);
	if (card_analysis.type == CARD_TYPE_ERROR)
	{
//		printf("##111111\n");
		card_ana_for_task["type"] = 0;
		return false;
	}
	
	if (type == CARD_TYPE_ROCKET)
	{
		return true;
	}
	
	if (last_card_type == CARD_TYPE_ROCKET)
	{
//		printf("##2222222\n");
		card_ana_for_task["type"] = 0;
		return false;
	}
	
	if (type == last_card_type)
	{
		if (len == card_analysis.len
			&& face > card_analysis.face)
		{
			return true;
		}
	}
	else if (type_other[0] == last_card_type)
	{
		if (len == card_analysis.len
			&& face_other[0] > card_analysis.face)
		{
			card_ana_for_task["type"] = last_card_type;
			return true;
		}
	}
	else if (type_other[1] == last_card_type)
	{
		if (len == card_analysis.len
			&& face_other[1] > card_analysis.face)
		{
			card_ana_for_task["type"] = last_card_type;
			return true;
		}
	}
	else if (type_other[2] == last_card_type)
	{
		if (len == card_analysis.len
			&& face_other[2] > card_analysis.face)
		{
			card_ana_for_task["type"] = last_card_type;
			return true;
		}
	}
	else
	{
		switch(type)
		{
			case CARD_TYPE_SUPERBOMB:
				return true;

//			case CARD_TYPE_BOMB:
			case CARD_TYPE_HARDBOMB:
				if (last_card_type != CARD_TYPE_SUPERBOMB)
				{
					return true;
				}
				break;

			case CARD_TYPE_SOFTBOMB:
				if ( (last_card_type != CARD_TYPE_SUPERBOMB) && (last_card_type != CARD_TYPE_HARDBOMB) )
				{
					return true;
				}
				break;
		}
	}
//	printf("##3333\n");
	card_ana_for_task["type"] = 0;
	return false;
}

void CardAnalysis::debug()
{
	cout << "type: " << card_type_str[type] << " face: " << face << endl;
}

void CardAnalysis::format(CardStatistics &stat, vector<int> &cur)
{
	int len;
	cur.clear();
	
	len = stat.card4.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		cur.push_back(stat.card4[i].value);
	}

	len = stat.card3.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		cur.push_back(stat.card3[i].value);
	}

	len = stat.card2.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		cur.push_back(stat.card2[i].value);
	}

	len = stat.card1.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		cur.push_back(stat.card1[i].value);
	}
}

void CardAnalysis::format(CardStatistics &stat, vector<Card> &cur)
{
	int len;
	cur.clear();
	
	len = stat.card4.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		Card card(stat.card4[i].value);
		cur.push_back(card);
	}

	len = stat.card3.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		Card card(stat.card3[i].value);
		cur.push_back(card);
	}

	len = stat.card2.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		Card card(stat.card2[i].value);
		cur.push_back(card);
	}

	len = stat.card1.size() - 1;
	for (int i = len; i >= 0; i--)
	{
		Card card(stat.card1[i].value);
		cur.push_back(card);
	}
}

int CardAnalysis::isGreater(vector<int> &last, vector<int> &cur, int *card_type)
{
    if (last.size() == 0)
    {
        return -1;
    }
    
    if (cur.size() == 0)
    {
        return -2;
    }
    
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
	CardAnalysis card_ana1;
	card_ana1.analysis(card_stat1);
    if (card_ana1.type == 0)
    {
        return -2;
    }
    
	*card_type = card_ana1.type;
	bool res = card_ana1.compare(card_ana0);
    if (res)
    {
    	CardAnalysis::format(card_stat1, cur);
        return 1;
    }
    else
    {
        return 0;
    }
}

int CardAnalysis::isGreater_super(vector<int> &last, vector<int> &cur, int last_card_type,int super_face)
{
	int cur_card_type = CARD_TYPE_ERROR;

    if (last.size() == 0)
    {
        return -1;
    }
    
    if (cur.size() == 0)
    {
        return -2;
    }
    
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

	if (last_card_type == CARD_TYPE_ERROR)
	{
		cur_card_type = card_ana0.type;
	}
	else
	{
		cur_card_type = last_card_type;
	}
	
    vector<Card> cards1;
	for (unsigned int i = 0; i < cur.size(); i++)
	{
		Card card(cur[i]);
		cards1.push_back(card);
	}
	CardStatistics card_stat1 = CardStatistics(super_face);
	card_stat1.statistics(cards1);
	CardAnalysis card_ana1;
	card_ana1.analysis(card_stat1);
    if (card_ana1.type == CARD_TYPE_ERROR)
    {
        return -2;
    }
    map<string, int> card_ana_for_task;
	bool res = card_ana1.compare_super(card_ana0,cur_card_type,card_ana_for_task);
    if (res)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

int CardAnalysis::isGreater_super(vector<Card> &last, vector<Card> &cur, int last_card_type,int super_face,map<string, int> &card_ana_for_task)
{
	int cur_card_type = CARD_TYPE_ERROR;

    if (last.size() == 0)
    {
        return -1;
    }

    if (cur.size() == 0)
    {
        return -2;
    }

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

	if (last_card_type == CARD_TYPE_ERROR)
	{
		cur_card_type = card_ana0.type;
	}
	else
	{
		cur_card_type = last_card_type;
	}

    vector<Card> cards1;
	for (unsigned int i = 0; i < cur.size(); i++)
	{
		Card card(cur[i]);
		cards1.push_back(card);
	}
	CardStatistics card_stat1 = CardStatistics(super_face);
	card_stat1.statistics(cards1);
	CardAnalysis card_ana1;
	card_ana1.analysis(card_stat1);
    if (card_ana1.type == CARD_TYPE_ERROR)
    {
        return -2;
    }
    card_ana_for_task["type"] = card_ana1.type;
	card_ana_for_task["face"] = card_ana1.face;
	card_ana_for_task["len"] = card_ana1.len;

	Card::sort_by_descending(cur);
	card_ana_for_task["mv"] = cur[0].face;

	bool res = card_ana1.compare_super(card_ana0,cur_card_type,card_ana_for_task);
    if (res)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

int CardAnalysis::isGreater(vector<Card> &last, vector<Card> &cur, int *card_type,map<string, int> &card_ana_for_task)
{
    if (last.size() == 0)
    {
        return -1;
    }
    
    if (cur.size() == 0)
    {
        return -2;
    }
	CardStatistics card_stat0;
	card_stat0.statistics(last);
	CardAnalysis card_ana0;
	card_ana0.analysis(card_stat0);
    if (card_ana0.type == 0)
    {
        return -1;
    }
	
	CardStatistics card_stat1;
	card_stat1.statistics(cur);
	CardAnalysis card_ana1;
	card_ana1.analysis(card_stat1);
    if (card_ana1.type == 0)
    {
        return -2;
    }
    card_ana_for_task["type"] = card_ana1.type;
    card_ana_for_task["face"] = card_ana1.face;
    card_ana_for_task["len"] = card_ana1.len;

    Card::sort_by_descending(cur);
    card_ana_for_task["mv"] = cur[0].face;

	*card_type = card_ana1.type;
	bool res = card_ana1.compare(card_ana0);
    if (res)
    {
//    	CardAnalysis::format(card_stat1, cur);
        return 1;
    }
    else
    {
        return 0;
    }
}
int CardAnalysis::analysis_super(CardStatistics &card_stat)
{
//	int set_type = 0;
	int set_face = 0;

	type = CARD_TYPE_ERROR;
	type_other[0] = CARD_TYPE_ERROR;
	type_other[1] = CARD_TYPE_ERROR;
	type_other[2] = CARD_TYPE_ERROR;	

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	switch(len)
	{
		case 0:
			return 0;


		case 1:
			if(super_num == 1)
			{
				face = super_face;
				type = CARD_TYPE_ONE;
				return type;
			}
			else
			{
				face = card_stat.card1[0].face;
				type = CARD_TYPE_ONE;
				return type;				
			}
			break;

		case 2:
			if(super_num == 2)
			{
				face = super_face;
				type = CARD_TYPE_TWO;
				return type;
			}
			else if ( (super_num == 1) && (card_stat.card1[0].face <= CARD_FACE_2_15) )
			{
				face = card_stat.card1[0].face;
				type = CARD_TYPE_TWO;
				return type;
			}
			else if (card_stat.card2.size() == 2)
			{
				face = card_stat.card2[1].face;
				type = CARD_TYPE_TWO;
				return type;
			}
			else if (card_stat.card1.size() == 2)
			{
				if ( (card_stat.card1[0].face == CARD_FACE_SMALL) && (card_stat.card1[1].face == CARD_FACE_BIG) )
				{
					face = card_stat.card1[1].face;
					type = CARD_TYPE_ROCKET;
					return type;
				}
			}
			break;
			
		case 3:
			if(super_num == 3)
			{
				face = super_face;
				type = CARD_TYPE_THREE;
				return type;
			}
			else if ( (super_num == 2) && (card_stat.card1[0].face <= CARD_FACE_2_15) )
			{
				face = card_stat.card1[0].face;
				type = CARD_TYPE_THREE;
				return type;
			}
			else if ( (super_num == 1) && (card_stat.card2.size() == 2) )
			{
				face = card_stat.card2[1].face;
				type = CARD_TYPE_THREE;
				return type;
			}
			else if (card_stat.card3.size() == 3)
			{
				face = card_stat.card3[2].face;
				type = CARD_TYPE_THREE;
				return type;
			}
			break;

		default:

			set_face = get_face_if_it_is_superbomb(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_SUPERBOMB,set_face);
				return CARD_TYPE_SUPERBOMB;
			}

			set_face = get_face_if_it_is_hardbomb(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_HARDBOMB,set_face);
				return CARD_TYPE_HARDBOMB;
			}

			set_face = get_face_if_it_is_softbomb(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_SOFTBOMB,set_face);
				return CARD_TYPE_SOFTBOMB;
			}

			set_face = get_face_if_it_is_threewithone(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_THREEWITHONE,set_face);
				return CARD_TYPE_THREEWITHONE;
			}

			set_face = get_face_if_it_is_threewithtwo(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_THREEWITHTWO,set_face);
				return CARD_TYPE_THREEWITHTWO;
			}

			set_face = get_face_if_it_is_fourwithtwo(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_FOURWITHTWO,set_face);
			}

			set_face = get_face_if_it_is_fourwithone(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_FOURWITHONE,set_face);
			}

			set_face = get_face_if_it_is_planewithwing(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_PLANEWITHWING,set_face);
			}

			set_face = get_face_if_it_is_planewithone(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_PLANEWITHONE,set_face);
			}

			set_face = get_face_if_it_is_threeline(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_THREELINE,set_face);
			}

			set_face = get_face_if_it_is_twoline(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_TWOLINE,set_face);
			}

			set_face = get_face_if_it_is_oneline(card_stat);
			if (set_face != 0)
			{
				set_type_and_face(CARD_TYPE_ONELINE,set_face);
			}			

			return type;
	}

	return CARD_TYPE_ERROR;
}

int CardAnalysis::get_face_if_it_is_rocket(CardStatistics &card_stat)
{
	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( (len == 2) && (card_stat.card1.size() == 2) )
	{
		if ( (card_stat.card1[0].face == CARD_FACE_SMALL) && (card_stat.card1[1].face == CARD_FACE_BIG) )
		{
			return card_stat.card1[1].face;
		}
	}

	return 0;
}



int CardAnalysis::get_face_if_it_is_superbomb(CardStatistics &card_stat)
{
	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( (super_num == 4) && (len == 4) )
	{
		return super_face;
	}
	else
	{
		return 0;
	}
}

int CardAnalysis::get_face_if_it_is_hardbomb(CardStatistics &card_stat)
{
	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if (len != 4)
	{
		return 0;
	}

	if (card_stat.card4.size() == 4)
	{
		return card_stat.card4[3].face;
	}
	else
	{
		return 0;
	}
}



int CardAnalysis::get_face_if_it_is_softbomb(CardStatistics &card_stat)
{
	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if (len != 4)
	{
		return 0;
	}

	if (super_num == 4)
	{
		return 0;
	}

	if ( (card_stat.line1.size() == 1) && (card_stat.line1[0].face <= CARD_FACE_2_15) )
	{
		return card_stat.line1[0].face;
	}
	else
	{
		return 0;
	}
}



int CardAnalysis::get_face_if_it_is_oneline(CardStatistics &card_stat)
{
	unsigned int i = 0;
//	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( ( len > 12) || (len < 5) )
	{
		return 0;
	}

	if ( (card_stat.card2.size() > 0) || (card_stat.card3.size() > 0) || (card_stat.card4.size() > 0) )
	{
		return 0;
	}

	if ( (card_stat.facelist[CARD_FACE_2_15] != 0) || (card_stat.facelist[CARD_FACE_SMALL] != 0) || (card_stat.facelist[CARD_FACE_BIG] != 0) )
	{
		return 0;
	}

	int total_match = 0;
	unsigned int temp_len = len;

	for(i=CARD_FACE_A;i>=CARD_FACE_3;i--)
	{
		if ( i < (3+temp_len-1) )
		{
			break;
		}

		total_match = 0;
		temp_len = len;
	
		do
		{
			total_match +=card_stat.facelist[i-temp_len+1];		
			temp_len--;
		}while(temp_len > 0);

		// already match or not
		if ( (total_match+super_num) == len )
		{
			get_face = i;

			return i;
		}
		else
		{

			continue;
		}
	}	


	return 0;	
}

int CardAnalysis::get_face_if_it_is_twoline(CardStatistics &card_stat)
{
	unsigned int i = 0;
//	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( len < 6)
	{
		return 0;
	}

	if ( len%2 != 0 )
	{
		return 0;
	}	

	if ( (card_stat.card3.size() > 0) || (card_stat.card4.size() > 0) )
	{
		return 0;
	}

	if ( (card_stat.facelist[CARD_FACE_2_15] != 0) || (card_stat.facelist[CARD_FACE_SMALL] != 0) || (card_stat.facelist[CARD_FACE_BIG] != 0) )
	{
		return 0;
	}

	int total_match = 0;
	unsigned int temp_len = len/2;

	for(i=CARD_FACE_A;i>=CARD_FACE_3;i--)
	{
		if ( i < (3+temp_len-1) )
		{
			break;
		}

		total_match = 0;
		temp_len = len/2;
	
		do
		{
			total_match +=card_stat.facelist[i-temp_len+1];		
			temp_len--;
		}while(temp_len > 0);

		// already match or not
		if ( (total_match+super_num) == len )
		{
			get_face = i;

			return i;
		}
		else
		{

			continue;
		}
	}	


	return 0;	
}

int CardAnalysis::get_face_if_it_is_threeline(CardStatistics &card_stat)
{
	unsigned int i = 0;
//	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( len < 6)
	{
		return 0;
	}

	if ( len%3 != 0 )
	{
		return 0;
	}	

	if (card_stat.card4.size() > 0)
	{
		return 0;
	}

	if ( (card_stat.facelist[CARD_FACE_2_15] != 0) || (card_stat.facelist[CARD_FACE_SMALL] != 0) || (card_stat.facelist[CARD_FACE_BIG] != 0) )
	{
		return 0;
	}

	int total_match = 0;
	unsigned int temp_len = len/3;

	for(i=CARD_FACE_A;i>=CARD_FACE_3;i--)
	{
		if ( i < (3+temp_len-1) )
		{
			break;
		}

		total_match = 0;
		temp_len = len/3;
	
		do
		{
			total_match +=card_stat.facelist[i-temp_len+1];		
			temp_len--;
		}while(temp_len > 0);

		// already match or not
		if ( (total_match+super_num) == len )
		{
			get_face = i;

			return i;
		}
		else
		{

			continue;
		}
	}	


	return 0;	
}



int CardAnalysis::get_face_if_it_is_planewithone(CardStatistics &card_stat)
{
	unsigned int i = 0;
//	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;	

	if ( ( len%4 != 0) || (len < 8) )
	{
		return 0;
	}

	if (card_stat.card4.size() > 0)
	{
		return 0;
	}
	


//	std::map<int, int> tempfacelist;
//	tempfacelist.clear();

	unsigned int plane_len = len/4;
	int total_match = 0;
	unsigned int temp_len = 0;	


	for(i=CARD_FACE_A;i>=CARD_FACE_3;i--)
	{
		if ( i < (3+plane_len-1) )
		{
			break;
		}

		total_match = 0;
		temp_len = plane_len;
	
		do
		{
			total_match += card_stat.facelist[i-temp_len+1];		
			temp_len--;
		}while(temp_len > 0);

		// already find  33 333 333 or 3333
		if ( (total_match+super_num) >= 3*plane_len )
		{
			get_face = i;
			return get_face;
		}
		else
		{
			continue;
		}
	}

	return 0;	
}

int CardAnalysis::get_face_if_it_is_planewithwing(CardStatistics &card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;	

	if ( ( len%5 != 0) || (len < 10) )
	{
		return 0;
	}

	if (card_stat.card4.size() > 0)
	{
		return 0;
	}

	if ( (card_stat.facelist[CARD_FACE_SMALL] != 0) || (card_stat.facelist[CARD_FACE_BIG] != 0) )
	{
		return 0;
	}	

	unsigned int plane_len = len/5;



	int total_match = 0;
	int invalid_match = 0;
	unsigned int total_face_left = 0;	
	unsigned int temp_len = 0;	


	for(i=CARD_FACE_A;i>=CARD_FACE_3;i--)
	{
		if ( i < (3+plane_len-1) )
		{
			break;
		}

		total_match = 0;
		temp_len = plane_len;
	
		do
		{
			total_match +=card_stat.facelist[i-temp_len+1];		
			temp_len--;
		}while(temp_len > 0);

		// already find  33 333 333 or 3333
		if ( (total_match+super_num) >= 3*plane_len )
		{
			get_face = i;


	//		for(j=0;j<plane_len;j++)
	//		{
	//			card_stat.facelist[i-j] = 0;
	//		}

		}
		else
		{

			continue;
		}



		for(j=CARD_FACE_3;j<=CARD_FACE_2_15;j++)
		{
			if ( (j <= get_face) && (j >= (get_face-plane_len+1) ) )
			{
				continue;
			}

			// fix a ana bug such as 7 7 7 8 9 10 S S S S 201401115
			if (card_stat.facelist[j] >= 3)
			{
				total_face_left++;
				total_face_left++;
			}else if(card_stat.facelist[j] > 0)
			{
				total_face_left++;
			}
		}

		// fix a ana bug such as 7 7 7 8 9 10 S S S S 201401115
		// fix a ana bug such as 777 888 999 10

		if (total_face_left > plane_len)
		{
			continue;
		}
		else
		{
			return get_face;
		}
	}

	return 0;
			
}

int CardAnalysis::get_face_if_it_is_threewithone(CardStatistics &card_stat)
{
//	unsigned int i = 0;
//	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( len != 4 )
	{
		return 0;
	}

	if ( super_num > 2 )
	{
		return 0;
	}	

	switch(super_num)
	{
		case 0:
			if ( card_stat.card3.size() > 0)
			{
				get_face = card_stat.card3[2].face;
			}
			return get_face;
			
		case 1:
			if ( card_stat.card2.size() > 0)
			{
				get_face = card_stat.card2[1].face;
			}
			return get_face;

		case 2:
			if ( card_stat.card1.size() == 2)
			{
				if(card_stat.card1[1].face <= CARD_FACE_2_15)
				{
					get_face = card_stat.card1[1].face;
				}
				else if (card_stat.card1[0].face <= CARD_FACE_2_15)
				{
					get_face = card_stat.card1[0].face;
				}
				else
				{
					return 0;
				}
			}
			return get_face;
			
		default:
			break;


	}

	return 0;	
}


int CardAnalysis::get_face_if_it_is_threewithtwo(CardStatistics &card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( len != 5 )
	{
		return 0;
	}

	if ( (card_stat.facelist[CARD_FACE_SMALL] != 0) || (card_stat.facelist[CARD_FACE_BIG] != 0) )
	{
		return 0;
	}	

	if (card_stat.card4.size() > 0)
	{
		return 0;
	}

	int total_match = 0;
	unsigned int temp_len = len;
	unsigned int total_face_left = 0;	

	for(i=CARD_FACE_2_15;i>=CARD_FACE_3;i--)
	{
		total_face_left = 0;
	
		// already match or not
		if ( (card_stat.facelist[i] > 0) 
			&& ( (card_stat.facelist[i]+super_num) >= 3 )
			)
		{

			get_face = i;

			for(j=CARD_FACE_2_15;j>=3;j--)
			{
				if (( j != i ) && (card_stat.facelist[j]>0))
				{
					total_face_left++;
				}
			}

			if (total_face_left <= 1)
			{
				return get_face;
			}
		}
		else
		{
			continue;
		}
	}	


	return 0;	
}


int CardAnalysis::get_face_if_it_is_fourwithone(CardStatistics &card_stat)
{
	unsigned int i = 0;
//	unsigned int j = 0;
//	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( len != 6 )
	{
		return 0;
	}

	if ( (card_stat.facelist[CARD_FACE_SMALL] != 0) || (card_stat.facelist[CARD_FACE_BIG] != 0) )
	{
		return 0;
	}		

	for(i=CARD_FACE_2_15;i>=3;i--)
	{	
		// already match or not
		if ( (card_stat.facelist[i] > 0) 
			&& ( (card_stat.facelist[i]+super_num) >= 4 )
			)
		{
			return i;
		}
		else
		{
			continue;
		}
	}	

	return 0;	
}



int CardAnalysis::get_face_if_it_is_fourwithtwo(CardStatistics &card_stat)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int get_face = 0;

	len = card_stat.len;
	super_face = card_stat.super_face;
	super_num = card_stat.super_num;

	if ( len != 8 )
	{
		return 0;
	}

	if ( (card_stat.facelist[CARD_FACE_SMALL] != 0) || (card_stat.facelist[CARD_FACE_BIG] != 0) )
	{
		return 0;
	}	

	int invalid_match = 0;
	int total_match = 0;
	unsigned int temp_len = len;
	unsigned int total_face_left = 0;

	for(i=CARD_FACE_2_15;i>=3;i--)
	{
		total_face_left = 0;
	
		// already match or not
		if ( (card_stat.facelist[i] > 0) 
			&& ( (card_stat.facelist[i]+super_num) >= 4 )
			) 
		{
			get_face = i;

			for(j=CARD_FACE_2_15;j>=3;j--)
			{
				if ( ( j != i )
					&& (card_stat.facelist[j]>0)
					)
				{
					// fix a ana bug such as 7 7 7 9 10 S S S 201401115
					if (card_stat.facelist[j] >= 3 )
					{
						invalid_match = 1;
						break;
					}

					total_face_left++;


				}
			}

			// fix a ana bug such as 7 7 7 9 10 S S S 201401115
			if (1 == invalid_match)
			{
				invalid_match = 0;
				continue;
			}

			if (total_face_left <= 2)
			{
				return get_face;
			}
		}
		else
		{

			continue;
		}
	}	


	return 0;	
}


int CardAnalysis::set_type_and_face(int set_type,int set_face)
{
	if (type == CARD_TYPE_ERROR)
	{
		type = set_type;
		face = set_face;
		return 1;
	}

	if (type_other[0] == CARD_TYPE_ERROR)
	{
		type_other[0] = set_type;
		face_other[0] = set_face;
		return 1;
	}

	if (type_other[1] == CARD_TYPE_ERROR)
	{
		type_other[1] = set_type;
		face_other[1] = set_face;
		return 1;
	}

	if (type_other[2] == CARD_TYPE_ERROR)
	{
		type_other[2] = set_type;
		face_other[2] = set_face;
		return 1;
	}
	
	return 0;

}

int CardAnalysis::get_cards_show(CardStatistics &card_stat,int type,int last_type)
{
	unsigned int i = 0;
	unsigned int j = 0;
	Card card0;
	int super_face_left	= super_num;
	unsigned int plane_len = 0;
	int use_type = type;
    int use_face = 0;


	analysis(card_stat);


	if ( (super_num == 0) || (type == CARD_TYPE_ERROR) )
	{
		for (i = 0; i < card_stat.cards.size(); i++)
		{
			cards_show.push_back(card_stat.cards[i]);
		}
		return 1;
	}

	/*fix bug of show when muli type is possible*/
	if ( (type == CARD_TYPE_BOMB)
		||(type == CARD_TYPE_HARDBOMB)
		||(type == CARD_TYPE_SOFTBOMB)
		||(type == CARD_TYPE_SUPERBOMB)
		||(type == CARD_TYPE_ROCKET)
		)
	{
		use_type = type;
	}
	else
	{
		if (last_type != 0)
		{
			use_type = last_type;
		}
	}

    use_face = get_face_from_type(use_type);


	switch(use_type)
	{
		case CARD_TYPE_ERROR:
			break;

		case CARD_TYPE_ONE:
			cards_show.push_back(card_stat.cards[0]);
			break;

		case CARD_TYPE_TWO:
			switch(super_num)
			{
				case 1:
					cards_show.push_back(card_stat.card1[0]);
					card0.set_val(card_stat.card1[0].face,4);
					cards_show.push_back(card0);
					break;

				case 2:
					card0.set_val(this->super_face,4);
					cards_show.push_back(card0);
					cards_show.push_back(card0);
					break;
			}
			break;

		case CARD_TYPE_THREE:
			switch(super_num)
			{
				case 1:
					cards_show.push_back(card_stat.card2[0]);
					cards_show.push_back(card_stat.card2[1]);
					card0.set_val(card_stat.card2[0].face,4);
					cards_show.push_back(card0);
					break;

				case 2:
					cards_show.push_back(card_stat.card1[0]);
					card0.set_val(card_stat.card1[0].face,4);
					cards_show.push_back(card0);
					cards_show.push_back(card0);
					break;

				case 3:
					card0.set_val(this->super_face,4);
					cards_show.push_back(card0);
					cards_show.push_back(card0);
					cards_show.push_back(card0);
					break;
			}
			break;

		case CARD_TYPE_ONELINE:
			card0.set_val(use_face,4);
			plane_len = card_stat.len;
			super_face_left = super_num;
			for (i = use_face;i >= (use_face-plane_len+1);i-- )
			{
				if (card_stat.facelist[i] == 0)
				{
					if (super_face_left > 0)
					{
						card0.set_val(i, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
			}

			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						cards_show.push_back(card_stat.cards[i]);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}

			break;
		case CARD_TYPE_TWOLINE:
			card0.set_val(use_face,4);
			plane_len = card_stat.len/2;
			super_face_left = super_num;
			for (i = use_face;i >= (use_face-plane_len+1);i-- )
			{
				if (card_stat.facelist[i] == 0)
				{
					if (super_face_left > 0)
					{
						card0.set_val(i, 4);
						cards_show.push_back(card0);
						cards_show.push_back(card0);
						super_face_left = super_face_left-2;
					}
				}
				else if (card_stat.facelist[i] == 1)
				{
					if (super_face_left > 0)
					{
						card0.set_val(i, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
			}

			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						cards_show.push_back(card_stat.cards[i]);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}

			break;

		case CARD_TYPE_THREELINE:
			card0.set_val(use_face,4);
			plane_len = card_stat.len/3;
			super_face_left = super_num;
			for (i = use_face;i >= (use_face-plane_len+1);i-- )
			{
				if (card_stat.facelist[i] == 0)
				{
					if (super_face_left > 0)
					{
						card0.set_val(i, 4);
						cards_show.push_back(card0);
						cards_show.push_back(card0);
						cards_show.push_back(card0);
						super_face_left = super_face_left-3;
					}
				}
				else if (card_stat.facelist[i] == 1)
				{
					if (super_face_left > 0)
					{
						card0.set_val(i, 4);
						cards_show.push_back(card0);
						cards_show.push_back(card0);
						super_face_left = super_face_left-2;
					}
				}
				else if (card_stat.facelist[i] == 2)
				{
					if (super_face_left > 0)
					{
						card0.set_val(i, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
			}

			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						card0.set_val(this->super_face, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}

			break;

		case CARD_TYPE_THREEWITHONE:
			card0.set_val(use_face,4);
			for(i = 0; i < (3-card_stat.facelist[use_face]); i++ )
			{
				cards_show.push_back(card0);
			}
			for (i = 0; i < card_stat.card1.size(); i++)
			{
				cards_show.push_back(card_stat.card1[i]);
			}
			for (i = 0; i < card_stat.card2.size(); i++)
			{
				cards_show.push_back(card_stat.card2[i]);
			}
			break;

		case CARD_TYPE_THREEWITHTWO:
			card0.set_val(use_face,4);
			super_face_left = super_num;
			for(i = 0; i < (3-card_stat.facelist[use_face]); i++ )
			{
				if (super_face_left > 0)
				{
					cards_show.push_back(card0);
					super_face_left--;
				}
			}

			for(i = 3; i <= 15; i++)
			{
				if(i == use_face)
				{
					continue;
				}

				if(card_stat.facelist[i] == 1)
				{
					card0.set_val(i, 4);
					cards_show.push_back(card0);
					super_face_left--;
				}
			}

			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						card0.set_val(this->super_face, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}
			break;

		case CARD_TYPE_PLANEWITHONE:
			card0.set_val(use_face,4);
			super_face_left = super_num;
			plane_len = card_stat.len/4;

			for (j = 0;j < plane_len;j++)
			{
				for(i = 0; i < (3-card_stat.facelist[use_face-j]); i++ )
				{
					if (super_face_left > 0)
					{
						card0.set_val((use_face-j), 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
			}

			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						card0.set_val(this->super_face, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}

			break;

		case CARD_TYPE_PLANEWITHWING:
			card0.set_val(use_face,4);
			super_face_left = super_num;
			plane_len = card_stat.len/5;

			for (j = 0;j < plane_len;j++)
			{
				for(i = 0; i < (3-card_stat.facelist[use_face-j]); i++ )
				{
					if (super_face_left > 0)
					{
						card0.set_val((use_face-j), 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
			}

			for(i = 3; i <= 15; i++)
			{
				if( (i <= use_face) && (i >= use_face-plane_len+1) )
				{
					continue;
				}

				if( (card_stat.facelist[i] == 1)
					|| (card_stat.facelist[i] == 3)
					)
				{
					card0.set_val(i, 4);
					cards_show.push_back(card0);
					super_face_left--;
				}
			}



			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						card0.set_val(this->super_face, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}
			break;




		case CARD_TYPE_FOURWITHONE:
			card0.set_val(use_face,4);
			super_face_left = super_num;
			for(i = 0; i < (4-card_stat.facelist[use_face]); i++ )
			{
				if (super_face_left > 0)
				{
					cards_show.push_back(card0);
					super_face_left--;
				}
			}

			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						card0.set_val(this->super_face, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}
			break;

		case CARD_TYPE_FOURWITHTWO:
			card0.set_val(use_face,4);
			super_face_left = super_num;
			for(i = 0; i < (4-card_stat.facelist[use_face]); i++ )
			{
				if (super_face_left > 0)
				{
					cards_show.push_back(card0);
					super_face_left--;
				}
			}

			for(i = 3; i <= 15; i++)
			{
				if(i == use_face)
				{
					continue;
				}

				if(card_stat.facelist[i] == 1)
				{
					card0.set_val(i, 4);
					cards_show.push_back(card0);
					super_face_left--;
				}
			}

			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						card0.set_val(this->super_face, 4);
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}
			break;

		case CARD_TYPE_SOFTBOMB:
			card0.set_val(use_face,4);
			super_face_left = super_num;
			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if( card_stat.cards[i].face == super_face )
				{
					if (super_face_left > 0 )
					{
						cards_show.push_back(card0);
						super_face_left--;
					}
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}
			break;

		case CARD_TYPE_SUPERBOMB:
			card0.set_val(this->super_face,4);
			super_face_left = super_num;
			cards_show.push_back(card0);
			cards_show.push_back(card0);
			cards_show.push_back(card0);
			cards_show.push_back(card0);
			break;

		default:
			card0.set_val(this->super_face,4);
			for (i = 0; i < card_stat.cards.size(); i++)
			{
				if (card_stat.cards[i].face == this->super_face)
				{
					cards_show.push_back(card0);
				}
				else
				{
					cards_show.push_back(card_stat.cards[i]);
				}
			}
			break;


	}
	Card::sort_by_ascending(cards_show);


	return 1;

}

int CardAnalysis::get_face_from_type(int type)
{
	if (this->type == type)
	{
		return this->face;
	}

	if (this->type_other[0] == type)
	{
		return this->face_other[0];
	}

	if (this->type_other[1] == type)
	{
		return this->face_other[1];
	}

	if (this->type_other[2] == type)
	{
		return this->face_other[2];
	}

	return 0;
}

int CardAnalysis::get_card_type(vector<int> &input)
{
    if (input.size() == 0)
    {
        return 0;
    }
    
	vector<Card> cards;
	for (unsigned int i = 0; i < input.size(); i++)
	{
		Card card(input[i]);
		cards.push_back(card);
	}
	CardStatistics card_stat;
	card_stat.statistics(cards);
	CardAnalysis card_ana;
	card_ana.analysis(card_stat);
	CardAnalysis::format(card_stat, input);
    
    return card_ana.type;
}

int CardAnalysis::get_card_type(vector<Card> &input,int superFace,map<string, int> &card_ana_for_task)
{
	CardStatistics card_stat = CardStatistics(superFace);
	card_stat.statistics(input);
	CardAnalysis card_ana;
	card_ana.analysis(card_stat);
//    CardAnalysis::format(card_stat, input);
    // TODO return arr:inclu type and face and length(ep:duizi,input.size/2)
    card_ana_for_task["type"] = card_ana.type;
    card_ana_for_task["face"] = card_ana.face;
    card_ana_for_task["len"] = card_ana.len;
    Card::sort_by_descending(input);
    card_ana_for_task["mv"] = input[0].face;
    return card_ana.type;
}

int CardAnalysis::get_card_type_super(vector<int> &input,int super_face)
{
    if (input.size() == 0)
    {
        return 0;
    }

	vector<Card> cards;
	for (unsigned int i = 0; i < input.size(); i++)
	{
		Card card(input[i]);
		cards.push_back(card);
	}
	CardStatistics card_stat(super_face);
	card_stat.statistics(cards);
	CardAnalysis card_ana;
	card_ana.analysis(card_stat);

    return card_ana.type;
}

void CardAnalysis::test(int input[], int len)
{
	vector<Card> cards;
	for (int i = 0; i < len ; i++)
	{
		Card card(input[i]);
		cards.push_back(card);	
	}
	CardStatistics card_stat;
	card_stat.statistics(cards);
	CardAnalysis card_ana;
	card_ana.analysis(card_stat);
	Card::dump_cards(cards);
	card_ana.debug();
}

void CardAnalysis::test_cards_show(int input[], int len,int super_face)
{
	vector<Card> cards;
	for (int i = 0; i < len ; i++)
	{
		Card card(input[i]);
		cards.push_back(card);
	}
	CardStatistics card_stat = CardStatistics(super_face);
	card_stat.statistics(cards);
	CardAnalysis card_ana;
	card_ana.analysis(card_stat);
	card_ana.get_cards_show(card_stat,card_ana.type,card_ana.type);
	Card::dump_cards(cards);
	card_ana.debug();
	Card::dump_cards(card_ana.cards_show);
}


void CardAnalysis::test(int input0[], int len0, int input1[], int len1)
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
	CardAnalysis card_ana1;
	card_ana1.analysis(card_stat1);
	Card::dump_cards(cards1);
	card_ana1.debug();
	
	bool res = card_ana0.compare(card_ana1);
	cout << "res: " << res << endl;
}
