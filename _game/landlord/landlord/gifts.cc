#include "gifts.h"

Gifts::Gifts() {
}

Gifts::~Gifts() {
}

void Gifts::init(int gid, int mon, int cha) {
	gift_id = gid;
	money = mon;
	charm = cha;

}

