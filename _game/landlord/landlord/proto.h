#ifndef __PROTO_H__
#define __PROTO_H__

enum system_command
{
    SYS_ECHO						= 0001,       /* echo */
    SYS_ONLINE						= 0002,       /* get online */
};

enum client_command
{
	CLIENT_HEART_BEAT				= 1000,
	CLIENT_JOIN_TABLE_REQ			= 1001,       /* join table */
	CLIENT_GAME_READY_REQ			= 1002,	     /* game ready */
	CLIENT_PREPLAY_ONE_REQ			= 1003,       /* call landlord request */
	CLIENT_PREPLAY_TWO_REQ			= 1004,
	CLIENT_PLAY_CARD_REQ 			= 1005,
	CLIENT_CHAT_REQ					= 1006,
	CLIENT_FACE_REQ					= 1007,
	CLIENT_LOGOUT_REQ				= 1008,
	CLIENT_ROBOT_REQ				= 1009,
	CLIENT_PLAYER_GIVE_GIFT_REQ     = 1010,			/* send gifts */
};

enum server_command
{
    SERVER_JOIN_TABLE_SUCC_UC        = 4001,       /* join table succ */
    SERVER_JOIN_TABLE_ERR_UC         = 4002,       /* join table err */
		
	SERVER_TABLE_INFO_BC			 = 4003,       /* push table info */
	SERVER_GAME_READY_BC			 = 4004,	   /* game ready */
	
	SERVER_GAME_START_UC			 = 4005,	   /* game start */
	SERVER_PREPLAY_ONE_BC		     = 4006,	   /* call landlord */
	SERVER_PREPLAY_ONE_SUCC_BC		 = 4007,	   /* call landlord succ */
	SERVER_PREPLAY_TWO_BC		     = 4008,	   /* rob landlord */
	SERVER_PREPLAY_TWO_SUCC_BC		 = 4009,	   /* rob landlord succ */
		
	SERVER_LANDLORD_BC				 = 4010,	   /* who is landlord */
	
	SERVER_PLAY_CARD_BC			 	 = 4011,	   /*  */
	SERVER_PLAY_CARD_SUCC_BC		 = 4012,	   /*  */
	SERVER_PLAY_CARD_ERR_BC		     = 4013,	   /*  */
		
	SERVER_GAME_END_BC				 = 4014,	   /*  */
	SERVER_GAME_PREREADY_BC			 = 4015,	   /*  */
		
	SERVER_CHAT_BC					 = 4016,	   /* chat */
	SERVER_FACE_BC					 = 4017,	   /* expression */
		
	SERVER_LOGOUT_BC			 	 = 4018,	   /*  */
	SERVER_REBIND_UC				 = 4019,	   /*  */
	
	SERVER_ROBOT_BC					 = 4020,	   /*  */
	SERVER_FREE_GIVE_UC			 	 = 4021,	   /*  */
	SERVER_TASK_FINISH_BC			 = 4030,	   /*  */
	SERVER_SPEAKER_BC			 = 4031,	   /*  */

	SERVER_PLAYER_GIVE_GIFT_BC       = 4032,      /* gift */
	SERVER_PLAYER_GIVE_GIFT_ERR      = 4033,      /* gift -error */
	SERVER_MATCH_WAITING_UC      	= 4034,      /* match waiting... */
	SERVER_MATCH_END_UC      		= 4035,      /* match waiting... */
};

#endif
