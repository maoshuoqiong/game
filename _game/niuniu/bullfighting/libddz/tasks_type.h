#ifndef __TASKS_TYPE_H__
#define __TASKS_TYPE_H__

enum task_type_code
{
	TT_PLAY_TIMES = 101,	// 玩牌次数
	TT_WIN_TIMES,			// 任意场馆胜利次数
	TT_GREAT_WIN_TIMES,		// 高级场馆胜利次数
	TT_KEEPER,				// 坐庄次数
	TT_COW_TEN				// 牛牛次数
};

#endif
