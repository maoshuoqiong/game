#! /usr/bin/python

#coding=UTF-8
# _*_ coding: UTF-8 _*_

import redis
import time
import random
from robrun import Robot

r=redis.Redis(host='localhost', password='bullfighting', port=6580)
rd = redis.Redis(host='localhost', password='bullfighting', port=6579)

def isNeedRobot():
    res = r.hgetall("hrob:need")
    if len(res) > 0:
        skey = r.get("srob:skey")
        for k,v in res.items():
            length = int(v)
            if length>0:
                for i in range(1,length+1):
                    hostInfo = getHostInfo(k)
                    isrob = isRob()
                    r.hincrby("hrob:need",k,-1)
                    robList = r.lrange("lrob:ids", 0, -1)
                    if len(robList)>0:
                        uid = r.lpop("lrob:ids")
                        initJoinData(uid, int(hostInfo[2]), int(hostInfo[3]))
                        thread1 = Robot(hostInfo[0],hostInfo[1], k, uid, skey)
                        thread1.start()
                        r.rpush("lrob:ids", uid)
                        #print(robList,type(robList))

        

def getHostInfo(vid):
    res = r.hmget("hv:"+vid, ["ip","port","min_money","max_money"])
    return res

def isRob():
    ind = random.randrange(10)
    if ind > 1:
        return 1
    else:
        return 0

def initJoinData(uid, minM, maxM):
    res = rd.hget("hu:"+uid, "money")
    currM = int(res)
    if currM > minM and (maxM == 0 or currM<maxM):
        pass
    else:
        newM = minM + minM * random.randrange(10)/10 + random.randrange(minM)
        incM = newM - currM
        rd.hset("hu:"+uid, "money", newM)
        res = r.hmget("moneystat", ['rob-1','rob-2'])
        stat = int(res[0])
        stat1 = int(res[1])
        stat = stat + incM
        if stat > 2000000000 :
            stat -= 2000000000
            stat1 += 1
        elif stat < -2000000000:
            stat += 2000000000
            stat1 -= 1
        r.hmset("moneystat",{"rob-1":stat, "rob-2":stat1})


if __name__ == '__main__':
    while True:
        isNeedRobot()
        time.sleep(3)

