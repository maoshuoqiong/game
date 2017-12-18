#ifndef __TASKS_H__
#define __TASKS_H__

#include <vector>
#include <stdlib.h>
#include <stdint.h>

class Tasks
{
public:
	Tasks();
    virtual ~Tasks();

    int				task_id;
    int				task_finish_type;
    int 			task_finish_num;  	// 0:no finish,1:conform type,2:win and finish if need
    int 			task_award_type;	// 0:money,1:coin
    int				task_award_amount;
    std::vector<int>		task_finish_players;
    int							ach_play_once;
    std::vector<int> 			ach_hole_no_7;
    std::vector<int>			ach_hole_less_k;
    int							ach_hole_rocket_bomb_2;

public:
    void init(int tid,int ft,int fn,int at,int aa);
};

#endif
