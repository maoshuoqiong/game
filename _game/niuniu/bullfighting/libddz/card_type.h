#ifndef _CARD_TYPE_H_
#define _CARD_TYPE_H_


#define OLD_METHOD_FOR_NO_SUPER

enum CardType
{
	CARD_TYPE_ERROR = 0,			// 错误类型
	CARD_TYPE_ONE = 1,			    // 单牌
	CARD_TYPE_ONELINE = 2,		    // 单连牌
	CARD_TYPE_TWO = 3,			    // 对子
	CARD_TYPE_TWOLINE = 4,		    // 连对		3个点数连续的
	CARD_TYPE_THREE = 5,			// 三张		
	CARD_TYPE_THREELINE = 6,		// 三顺		2个以上连续点数
	CARD_TYPE_THREEWITHONE = 7,	    // 三带一	
	CARD_TYPE_THREEWITHTWO = 8,  	// 三带二
	CARD_TYPE_PLANEWITHONE = 9, 	// 飞机带羿	和三带一差不多
	CARD_TYPE_PLANEWITHWING = 10,	// 飞机带翅	和三带二差不多
	CARD_TYPE_FOURWITHONE = 11, 	// 4个带一
	CARD_TYPE_FOURWITHTWO = 12, 	// 4个带二
	CARD_TYPE_BOMB = 13,			// 4个		炸弹
	CARD_TYPE_ROCKET = 14,		    // 2个鬼		火箭
	CARD_TYPE_SUPERBOMB = 15,		
	CARD_TYPE_SOFTBOMB= 16,
    
    //dcow
//	CARD_TYPE_ERROR = 0,			// 错误类型
//	CARD_TYPE_COW_NO = 1,			// 没牛
//    CARD_TYPE_COW_ONE = 2,          // 牛丁
//    CARD_TYPE_COW_TWO = 3,          // 牛二
//    CARD_TYPE_COW_THREE = 4,          // 牛三
//    CARD_TYPE_COW_FOUR = 5,          // 牛四
//    CARD_TYPE_COW_FIVE = 6,          // 牛五
//    CARD_TYPE_COW_SIX = 7,          // 牛六
//    CARD_TYPE_COW_SEVEN = 8,          // 牛七
//    CARD_TYPE_COW_EIGHT = 9,          // 牛八
//    CARD_TYPE_COW_NIGHT = 10,          // 牛九
//    CARD_TYPE_COW_TEN = 11,          // 牛牛
//    CARD_TYPE_COW_WHN = 12,          // 五花牛
//    CARD_TYPE_COW_BOMB = 13,          // 四炸
//    CARD_TYPE_COW_WXN = 14,          // 五小牛
    
    
};

enum CowCardType
{
    
    //dcow
    	CARD_TYPE_COW_ERROR = 0,			// 错误类型
    	CARD_TYPE_COW_NO = 1,			// 没牛
        CARD_TYPE_COW_ONE = 2,          // 牛丁
        CARD_TYPE_COW_TWO = 3,          // 牛二
        CARD_TYPE_COW_THREE = 4,          // 牛三
        CARD_TYPE_COW_FOUR = 5,          // 牛四
        CARD_TYPE_COW_FIVE = 6,          // 牛五
        CARD_TYPE_COW_SIX = 7,          // 牛六
        CARD_TYPE_COW_SEVEN = 8,          // 牛七
        CARD_TYPE_COW_EIGHT = 9,          // 牛八
        CARD_TYPE_COW_NIGHT = 10,          // 牛九
        CARD_TYPE_COW_TEN = 11,          // 牛牛
        CARD_TYPE_COW_WHN = 12,          // 五花牛
        CARD_TYPE_COW_BOMB = 13,          // 四炸
        CARD_TYPE_COW_WXN = 14,          // 五小牛
    
    
};

#define CARDS_MAX  5

#define CARD_TYPE_HARDBOMB 13


typedef enum {
	CARD_FACE_A = 1,
	CARD_FACE_2_15,
	CARD_FACE_3 = 3,
	CARD_FACE_4,
	CARD_FACE_5,
	CARD_FACE_6,
	CARD_FACE_7,
	CARD_FACE_8,
	CARD_FACE_9,
	CARD_FACE_10,
	CARD_FACE_J,
	CARD_FACE_Q,
	CARD_FACE_K,
	CARD_FACE_SMALL, // small Joker
	CARD_FACE_BIG, // big Joker
	
	FirstFace = CARD_FACE_A,
	LastFace = CARD_FACE_K
} Face;


#endif /* _CARD_TYPE_H_ */
