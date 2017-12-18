#coding=UTF-8
# _*_ coding: UTF-8 _*_

import threading
import time
import socket
import random
import json
import struct

class Robot (threading.Thread):
    def __init__(self, host, port, vid, uid, skey):
        threading.Thread.__init__(self)
        self.host = host
        self.port = int(port)
        self.vid = int(vid)
        self.uid = int(uid)
        self.skey = skey
        self.isrunning = True
        self.ver ="9.0"
        self.tid = 0
        self.isrob = 0
        self.chat_diy_str=["kkk","快点","大家好","谁能输点我","有美女么","谁来送礼","333","单挑","郁闷","我倒..",
        "55555","呵呵","你好呀","你们哪的","运气不错","来个牛","牛牛去哪儿","纠结了","爽","艹"]
        self.chat_def_str=["再见了俺会想念大家的","不要吵不要吵吵啥专心玩游戏吧","啊怎么又断线了网络怎么那么差啊","不要走,决战到天亮啊",
        "各位真是不好意思我要离开一会儿","和你合作真是太愉快了啊","你是美眉还是哥哥","快一点啊都等到我花都谢了","大家好,很高兴见到各位"]
        self.chat_diy_size=len(self.chat_diy_str)
        self.chat_def_size=len(self.chat_def_str)
        self.playernum = 0
        self.betnum = 0
        self.cards =''
        self.cardtype = 0
        self.keeper = ''
        self.s = socket.socket()
    
    def run(self):
        #print(time.ctime(time.time()))
        #print(self.host + ":" + self.port +":" + self.vid +":" + self.uid)
        self.s.settimeout(20)
        self.s.connect((self.host, self.port))

        self.send_cmd(2001) # 加入牌桌
        i = 0
        while self.isrunning:
            msg = self.recv_msg()
            if msg and len(msg) > 0:
                msg = self.xor(msg,13)
                self.deal_recv(msg)
            else:
                self.isrunning = False
                self.s.close()
        
        self.s.close()

    def get_sleep_time(self):
        s = 0
        if self.playernum > 0:
            if self.playernum %2 > 0 :
                s = (self.playernum + 1) /2
            else:
                s = self.playernum/2
        return s

    def send_cmd(self, cmd):
        params = {}
        params['cmd'] = cmd
        params['uid'] = self.uid
        if cmd == 2001: # 加入牌桌
            params['vid'] = self.vid
            params['skey']= self.skey
            params['ver'] = self.ver
            params['tid'] = self.tid
        elif cmd == 2002:
            time.sleep(1+random.randrange(5))
        elif cmd == 2003: # 抢庄
            time.sleep(self.get_sleep_time() + random.randrange(3))
            params['action'] = self.isrob
        elif cmd == 2004: # 下注
            time.sleep(1+random.randrange(5))
            params['betnum'] = self.betnum
        elif cmd == 2005: # 亮牌
            time.sleep(1+random.randrange(8))
            params['card_type'] = 0
            params['cards'] = self.cards
        elif cmd == 2009:
            # 文字聊天
            if random.randrange(10) > 7 :
                indran = random.randrange(self.chat_def_size)
                params['tag'] = indran
                params['str'] = self.chat_def_str[indran]
            else:
                params['tag'] = -1
                indran = random.randrange(self.chat_diy_size)
                params['str'] = self.chat_diy_str[indran]
            time.sleep(3)
        elif cmd == 2010:
            # 表情聊天
            params['faceid'] = random.randrange(14)
        elif cmd == 2011:
            time.sleep(2 + random.randrange(5))
            params['type'] = 1
        else:
            time.sleep(1+random.randrange(5))
        
        data = json.dumps(params)
        data = self.xor(data,13)
        self.send_msg(data)

    def send_msg(self,msg):
        lens = len(msg)
        self.s.sendall(struct.pack('i',lens)+msg)
    
    def recv_msg(self):
        message_size = self.s.recv(4)
        #print("recvs:%d" % len(message_size))
        if message_size :
            message_size = struct.unpack('i',message_size)
            #print("recv:%d" % message_size[0])
            return self.s.recv(message_size[0])

    def rand_chat(self, cmd):
        if cmd >= 5005 and cmd <= 5012:
            rn = random.randrange(1000)
            if rn < 30:
                self.send_cmd(2009)
            elif rn > 960:
                self.send_cmd(2010)


    def deal_recv(self, rec):
        rarr = json.loads(rec)
        cmd = int(rarr['cmd'])
        nextUid = 0
        if rarr.has_key('uid'):
            nextUid = rarr['uid']

        if cmd == 5012:
            if random.randrange(10) > 8:
                self.send_cmd(2007)
            else:
                self.send_cmd(2011)
        elif cmd == 5010:
            self.rand_chat(cmd)
            self.send_cmd(2005)
        elif cmd == 5007:
            self.keeper = nextUid
        elif cmd == 5003:
            self.playernum = len(rarr['players'])
        
        if nextUid == self.uid:
            self.rand_chat(cmd)
            if cmd == 5001:
                self.send_cmd(2002)
            elif cmd == 5005:
                self.cards = rarr['cards']
                self.calBetnum(rarr)
                self.send_cmd(2003)
            elif cmd == 5008:
                if self.uid != self.keeper:
                    self.betnum = rarr['betrange'][self.betind]
                    self.send_cmd(2004)
            elif cmd == 5020:
                if rarr['type'] != '3':
                    self.isrunning = False
                    if self.s:
                        self.s.close()
    

    def calBetnum(self, rarr):
        self.cardtype = rarr['cardtype']
        randnum = random.randrange(10)
        if randnum > 6 :
            self.isrob = 1
        else:
            if self.cardtype >=5:
                self.isrob =1
            else:
                self.isrob = 0

        if self.cardtype >= 10:
            #牛9以上
            self.betind = 3
        elif self.cardtype >= 6: # 牛5 ～ 牛8
            self.betind = 2
        elif self.cardtype >= 2: # 牛1 ～ 牛4
            self.betind = 1
        else:
            self.betind = 0 # 无牛

    def xor(self,data,x):
        ret = ''
        if isinstance(x, int):
            for i in data:
                ret += chr(ord(i)^x)
        return ret





        


        





