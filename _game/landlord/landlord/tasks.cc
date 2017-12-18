#include "tasks.h"
#include "log.h"

Tasks::Tasks()
{
}

Tasks::~Tasks()
{
}

void Tasks::init(int tid,int ft,int fn,int at,int aa){
	task_id = tid;
	task_finish_type = ft;
	task_finish_num = fn;
	task_award_type = at;
	task_award_amount = aa;
}

