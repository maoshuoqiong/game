#ifndef _CARD_FIND_H_
#define _CARD_FIND_H_

#include <vector>
#include <string>

#include "card.h"
#include "card_type.h"
#include "card_analysis.h"
#include "card_statistics.h"


using namespace std;

class CardFind
{
public:
	vector<vector<Card> > results;
	vector<Card> results_dcow;//dcow
	vector<int> results_faces;

	int super_face;
	int type;
	int cow_card_type;//dcow
	
	CardFind();
	CardFind(int type);
	
	void clear();
	int find(CardAnalysis &card_ana, CardStatistics &card_stat,	CardStatistics &my_card_stat,
			int last_is_partner,int last_hole_size,int cur_hole_size);
	
	void find_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_two(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_three(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_one_ine(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_two_ine(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_three_line(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_three_with_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_three_with_two(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_plane_with_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_plane_with_wing(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_four_with_one(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_four_with_two(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_rocket(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	
	void debug();
    int tip(vector<int> &last, vector<int> &cur);
	int tip(vector<Card> &last, vector<Card> &cur,int last_hole_size,int last_is_partner);
	static int find_straight(vector<int> &input, vector<int> &output);
	static int find_straight(vector<Card> &input, vector<Card> &output);
	static int get_straight(CardStatistics &card_stat, vector<Card> &output);
	static int get_max(unsigned int a, unsigned int b, unsigned int c);
	static void get_longest_straight(vector<Card> &input, int type, vector<Card> &output);
	static void test(int input0[], int len0, int input1[], int len1);
	static void test(int input[], int len);

	int find_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &target_card_stat);
	int find_soft_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_hard_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);	
	int find_super_bomb(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);

	int find_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_two_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_three_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);	
	int find_one_line_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_two_line_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_three_line_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_three_with_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_three_with_two_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_four_with_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_four_with_two_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);	

	int find_plane_with_one_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	int find_plane_with_wing_super(CardAnalysis &card_ana, CardStatistics &card_stat, CardStatistics &my_card_stat);
	void find_with_two(CardStatistics &card_stat,int with_len,vector<Card> &cards_super_temp,unsigned int super_num_left);
	void find_with_one(CardStatistics &card_stat,int with_len,vector<Card> &cards_super_temp,unsigned int super_num_left);	

	int tip_super(vector<int> &last, vector<int> &cur,int type,int super_face);
	int tip_super(vector<Card> &last, vector<Card> &cur,int type,int super_face,int last_hole_size,int last_is_partner);
	int get_face_from_ana(CardAnalysis &card_ana,int type);
	int is_hit_partner(int last_is_partner,int cardType,int cardFace,int curSize);
	void add_result_element(vector<Card> cards_result1);	
	void add_result_element(vector<Card> cards_result1,vector<Card> cards_result2,vector<Card> cards_result3);

	void init(int type);
	void init(int type,int super_face);

	void clear_temp_result(void);
	void init_cards_super_temp(CardStatistics &card_stat);

	void test_tip_super(int input0[], int len0, int input1[], int len1,int type,int super_face);
    
    
    int tip_dcow(vector<Card> &card_ana);//dcow
    int get_type_from_cow_card_type(vector<Card> card_face);//dcow 计算点数，牛型，
    
    int find_card_type_is_need_to_show(vector<Card> &card_ana); //是否五小牛,四炸,五花牛

    bool find_card_type_is_wxn(vector<Card> &card_ana); //是否五小牛
    bool find_card_type_is_bomb(vector<Card> &card_ana); //是否四炸
    bool find_card_type_is_whn(vector<Card> &card_ana); //是否五花牛
    
    void add_cards_results_type_is_wxn(vector<Card> &card_ana);//dcow 添加五小牛结果
    void add_cards_results_type_is_bomb(vector<Card> &card_ana);//dcow 添加四炸结果
    void add_cards_results_type_is_whn(vector<Card> &card_ana);//dcow 添加四炸结果
    void add_cards_results_face_type_is_five_greater_or_equal_ten(vector<Card> &card_ana);//五张都是 >=10
    void add_cards_results_face_type_is_four_three_greater_or_equal_ten(vector<Card> &card_ana0,vector<Card> &card_ana1);//四张/三张 都是 >=10
    void add_cards_results_face_type_is_two_greater_or_equal_ten(vector<Card> &card_ana0,vector<Card> &card_ana1);//两张 都是 >=10
    void add_cards_results_face_type_is_one_greater_or_equal_ten(vector<Card> &card_ana0,vector<Card> &card_ana1);//只有一张 >=10
    void add_cards_results_face_type_is_five_less_ten(vector<Card> &card_ana);//五张都 <10
    void add_cards_results_default_type_is_no(vector<Card> &card_ana);//默认没牛牌型

    //dcow
	int get_cards_select_total_num(vector<int> &card_input);
	int get_cards_select_type(vector<int> &card_input, vector<Card> &card_left);
    int get_cards_change_face(int face);


	// higher rank ; return: 1=闲家赢 , 0=闲家输
	static int get_winner(vector<Card> &keeper_cards, int keeper_cardtype, vector<Card> &leisure_cards, int leisure_cardtype);

	// return : 0 = 一致， -1 = 不一致
	int valid_cards(vector<Card> &ori_cards, vector<Card> &c_cards, vector<Card> &s_cards, int c_cardtype);

private:
	vector<Card> cards_result1;
	vector<Card> cards_result2; 
	vector<Card> cards_result3;
	vector<Card> cards_left;
	vector<Card> cards_super_temp;

};


#endif /* _CARD_FIND_H_ */
