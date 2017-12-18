#ifndef __PROTO_H__
#define __PROTO_H__

enum system_command
{
    SYS_ECHO						= 0001,       /* echo */
    SYS_ONLINE						= 0002,       /* get online */
};

enum client_command
{
	CLIENT_HEART_BEAT				= 2000,
	CLIENT_JOIN_TABLE_REQ			= 2001,       	/* join table */
	CLIENT_GAME_READY_REQ			= 2002,	     	/* game ready */
	CLIENT_ROB_REQ					= 2003,         /* ROB Keeper */
	CLIENT_BET_REQ					= 2004,			/* BET Ratio */
	CLIENT_FIGHT_REQ 				= 2005,			/* Fight card */
	CLIENT_CHANGE_TABLE_REQ			= 2006,			/* change table */
	CLIENT_LOGOUT_REQ				= 2007,			/* logout */
	CLIENT_CHAT_REQ					= 2009,			/* chat */
	CLIENT_FACE_REQ					= 2010,			/* face */
	CLIENT_NEXT_GAME_REQ			= 2011,			/* start again */
	CLIENT_PLAYER_GIVE_GIFT_REQ     = 2012,			/* send gifts */
	CLIENT_TALK_LIST_REQ			= 2013,			/* free talk */
	CLIENT_HELP_REQ					= 2014,			/*  */
};

enum server_command
{
    SERVER_JOIN_TABLE_SUCC_UC        = 5001,       /* join table succ */
    SERVER_JOIN_TABLE_ERR_UC         = 5002,       /* join table err */
		
	SERVER_TABLE_INFO_BC			 = 5003,       /* push table info */
	SERVER_GAME_READY_BC			 = 5004,	   /* game ready */
	
	SERVER_GAME_START_UC			 = 5005,	   /* game start */
	SERVER_ROB_SUCC_BC				 = 5006,	   /* rob succ */
	SERVER_KEEPER_BC				 = 5007,	   /* who is keeper */
	SERVER_BET_BC		    		 = 5008,	   /* start bet */
	SERVER_BET_SUCC_BC				 = 5009,	   /* bet succ */
	SERVER_FIGHT_BC		 	 		 = 5010,	   /* start fight */
	SERVER_FIGHT_SUCC_BC		 	 = 5011,	   /* fight succ */
		
	SERVER_GAME_END_BC				 = 5012,	   /* game end */
	SERVER_CHANGE_TABLE_SUCC_UC		 = 5013,
	SERVER_CHANGE_TABLE_ERR_UC 	 	 = 5014,
	SERVER_REBIND_UC				 = 5015,	   /*  */
	SERVER_GAME_PREREADY_BC			 = 5016,	   /* continue next round */
	SERVER_CHAT_BC					 = 5018,	   /* chat */
	SERVER_FACE_BC					 = 5019,	   /* expression */
	SERVER_LOGOUT_BC			 	 = 5020,	   /*  */
	
	SERVER_FREE_GIVE_UC			 	 = 5021,	   /*  */

	SERVER_PLAYER_GIVE_GIFT_BC       = 5022,      /* gift */

	SERVER_TALK_ERR_UC			 	 = 5023,
	SERVER_TALK_LIST_SUCC_UC		 = 5024,
	SERVER_HELP_SUCC_UC				 = 5025,

	SERVER_TASK_FINISH_BC			 = 5030,	   /*  */
	SERVER_SPEAKER_BC			 	 = 5031,	   /*  */
	SERVER_PLAYER_GIVE_GIFT_ERR      = 5032,      /* gift -error */

};

#endif
