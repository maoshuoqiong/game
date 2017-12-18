#ifndef _CARD_ANALYSIS_H_
#define _CARD_ANALYSIS_H_

#include <vector>
#include <string>

#include "card_statistics.h"

using namespace std;

class CardAnalysis
{
public:
	
	typedef enum {
		ONELINE = 1,
		TWOLINE,
		THREELINE,
	} Linetype;

	unsigned int len;
	int type;
	int face;
	
	int super_face;
	unsigned int super_num;	
	vector<Card> cards_show;
	int type_other[3];
	int face_other[3];	
	
	CardAnalysis();
	
	void clear();
	int analysis(CardStatistics &card_stat);
	bool check_is_line(CardStatistics &card_stat, int line_type);
	bool check_arr_is_line(std::vector<Card> &line, int line_type);
	bool check_arr_is_line(std::vector<Card> &line, int line_type, unsigned int begin, unsigned int end);
	int  get_face_if_arr_is_line_super(std::vector<Card> &line, int line_type,unsigned int super_num);
	int  get_face_if_arr_is_line_super(std::vector<Card> &line, int line_type, unsigned int begin, unsigned int end,unsigned int super_num);	
	
	bool compare(CardAnalysis &card_analysis);
    void debug();

	bool compare_super(CardAnalysis &card_analysis,int last_card_type,map<string, int> &card_ana_for_task);
	static int isGreater_super(vector<int> &last, vector<int> &cur, int last_card_type,int super_face);
	static int isGreater_super(vector<Card> &last, vector<Card> &cur, int last_card_type,int super_face,map<string, int> &card_ana_for_task);

	int analysis_super(CardStatistics &card_stat);
	int get_face_if_it_is_rocket(CardStatistics &card_stat);
	int get_face_if_it_is_superbomb(CardStatistics &card_stat);
	int get_face_if_it_is_hardbomb(CardStatistics &card_stat);
	int get_face_if_it_is_softbomb(CardStatistics &card_stat);
	int get_face_if_it_is_oneline(CardStatistics &card_stat);
	int get_face_if_it_is_twoline(CardStatistics &card_stat);
	int get_face_if_it_is_threeline(CardStatistics &card_stat);
	int get_face_if_it_is_planewithone(CardStatistics &card_stat);
	int get_face_if_it_is_planewithwing(CardStatistics &card_stat);
	int get_face_if_it_is_threewithone(CardStatistics &card_stat);
	int get_face_if_it_is_threewithtwo(CardStatistics &card_stat);
	int get_face_if_it_is_fourwithone(CardStatistics &card_stat);
	int get_face_if_it_is_fourwithtwo(CardStatistics &card_stat);
	int set_type_and_face(int set_type,int set_face);
	int get_face_from_type(int type);
	int get_cards_show(CardStatistics &card_stat,int type,int last_type);

    static void format(CardStatistics &stat, vector<int> &cur);
	static void format(CardStatistics &stat, vector<Card> &cur);
	static int isGreater(vector<int> &last, vector<int> &cur, int *card_type);
	static int isGreater(vector<Card> &last, vector<Card> &cur, int *card_type,map<string, int> &card_ana_for_task);
    static int get_card_type(vector<int> &input);
	static int get_card_type(vector<Card> &input,int superFace,map<string, int> &card_ana_for_task);
	static int get_card_type_super(vector<int> &input,int super_face);
    static void test(int input[], int len);
	static void test(int input0[], int len0, int input1[], int len1);
	static void test_cards_show(int input[], int len,int super_face);
};


#endif /* _CARD_STATISTICS_H_ */
