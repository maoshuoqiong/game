#encoding:utf-8
require 'rubygems'
require 'json'
require "socket"
require 'net/http'

class Rob
def initialize(host="127.0.0.1",port="50001",vid=1,uid=271)
      ##puts "#{host}: #{port}: #{uid}: #{vid}"
      @_host=host
      @_port=port
      @_uid=uid
      @_vid=vid
      @_skey="iigielllklk"
      @_ver="9.0"
      @_tid=0      
      @_isrunning=true
      @cards
      @cardtype
      @betnum      
      @keeper
      @playernum
      @isrob=0
      @chat_diy_str=["kkk","快点","大家好","谁能输点我","有美女么","谁来送礼","333","单挑","郁闷","我倒..","55555","呵呵","你好呀","你们哪的","运气不错","来个牛","牛牛去哪儿","纠结了","爽","艹"]
      @chat_def_str=["再见了俺会想念大家的","不要吵不要吵吵啥专心玩游戏吧","啊怎么又断线了网络怎么那么差啊","不要走,决战到天亮啊","各位真是不好意思我要离开一会儿","和你合作真是太愉快了啊","你是美眉还是哥哥","快一点啊都等到我花都谢了","大家好,很高兴见到各位"]
      @chat_def_size=@chat_def_str.size
      @chat_diy_size=@chat_diy_str.size
#=begin      
      begin
      timeout = 20
      @_client = TCPSocket.new(@_host, @_port)
      # 初始化SOCKET
      secs = Integer(timeout)
      usecs = Integer((timeout - secs) * 1_000_000)
      optval = [secs, usecs].pack("l_2")
      @_client.setsockopt Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, optval
      @_client.setsockopt Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, optval
	
      # 加入牌桌
      send_cmd(2001)
      i = 0
      while @_isrunning
              str = recv_msg(@_client)
              if str != nil
		      #接收指令
                      deal_recv(str.xor(13))
	      else
                      #puts "server down~"
                      @_isrunning = false
                      @_client.close
              end  
      end
      rescue => err
              ##puts err
      ensure
              if @_client != nil
                      @_client.close
              end
      end
end

def send_msg(handle, msg)
        handle.write([msg.length].pack('I') + msg)
end

def recv_msg(handle)
        if message_size = handle.read(4) # sizeof (I)
                message_size = message_size.unpack('I')[0]
                handle.read(message_size)
        end
end

def deal_recv(rec)
        rarr = JSON::parse(rec)
        cmd = rarr['cmd']
        nextUid = rarr['uid']
	##puts "@@@@@@@@Recv Start@@@@@@@@"
        #puts "recvCmd:#{rec}"
        ##puts "@@@@@@@@Recv End@@@@@@@@@@"
        if cmd == 5012
		if rand(10)>8
                	send_cmd(2007)
		else
			send_cmd(2011)
		end
        elsif cmd == 5010
		rand_chat(cmd)
                send_cmd(2005)
	elsif cmd == 5007
		@keeper = nextUid
	elsif cmd == 5003
		@playernum = rarr['players'].size
	end	
        if nextUid == @_uid
                rand_chat(cmd)
                if cmd == 5001
		        send_cmd(2002)
                elsif cmd == 5005
			@cards = rarr['cards']			
			calBetnum(rarr)
                        send_cmd(2003)
                elsif cmd == 5008
			if @_uid != @keeper
				@betnum = rarr['betrange'][@betind]
                        	send_cmd(2004)
			end
                elsif cmd == 5020
			if rarr['type'] !=3
				@_isrunning=false
				if @_client != nil
	                      		@_client.close
        			end
			end
		else
                end
        end
end

def rand_chat(cmd)
	if cmd>=5005 && cmd<=5012
		rn = rand(1000)
		#puts rn
		if rn<30
			send_cmd(2009)
		elsif rn>960
			send_cmd(2010)
		else 
		end
	end	
end

def calBetnum(rarr)	
	@cardtype = rarr['cardtype']
	randnum = rand(10)
	if randnum>6
		@isrob = 1
	else		
		if @cardtype>=5
			@isrob = 1	
		else
			@isrob = 0
		end
	end

	if @cardtype>=10	# 牛九以上
		@betind = 3
	elsif @cardtype>=6	# 牛5~牛8
		@betind = 2
	elsif @cardtype>=2	# 牛1~牛4
		@betind = 1
	else			# 无牛	
		@betind = 0
	end
end

def get_sleep_time()
	if @playernum >0
		s = @playernum%2>0?(@playernum+1)/2:@playernum/2
	else 
		s = 0
	end
end

def send_cmd(cmd)
        params = Hash.new
        params['cmd'] = cmd
        params['uid'] = @_uid
 	# 加入牌桌
        if cmd==2001
		#sleep(rand(3))
                params['vid'] = @_vid
                params['skey'] = @_skey
		params['ver'] = @_ver
		params['tid'] = @_tid
	elsif cmd==2002
		sleep(1+rand(5))
        # 抢庄
	elsif cmd==2003
		##puts "playerNum:#{@playernum},sleepT:#{get_sleep_time()}"
		sleep(get_sleep_time()+rand(3))
                params['action'] = @isrob
        # 下注
	elsif cmd==2004
		sleep(1+rand(5))
                params['betnum'] = @betnum
        # 亮牌
	elsif cmd==2005
        	sleep(1+rand(8))
                params['card_type']=0
                params['cards']=@cards
	# 文字聊天
	elsif cmd==2009
                if rand(10)>7
			indran = rand(@chat_def_size)
			params['tag']=indran
			params['str']=@chat_def_str[indran]
		else
			params['tag']=-1
			indran = rand(@chat_diy_size);
			params['str']=@chat_diy_str[indran]
		end
		sleep(rand(3))
	# 表情聊天
	elsif cmd==2010
                params['faceid']=rand(14)
	elsif cmd==2011
		sleep(2+rand(5))
		params['type']=1
	else
		sleep(1+rand(5))
        end

        #puts "*********send_start*********"
        data = params.to_json
        data = data.xor(13)
	#puts "sendcmd1:#{data}"
        send_msg(@_client, data)
	#puts "********send_end************"
end

end

class String
  def xor x
    if x.is_a?(String)
      r = ''
      j = 0
      0.upto(self.size-1) do |i|
        r << (self[i].ord^x[j].ord).chr
        j+=1
        j=0 if j>= x.size
      end
      r
    else
      r = ''
      #0.upto(self.size-1) do |i|
       # r << (self[i].ord^x).chr
      #end
      #增加对处理中文的支持
      ps = self.unpack('C*')
      0.upto(ps.size-1) do |i|
        r << (ps[i].ord^x).chr
      end
      r
    end
  end
end

if __FILE__ == $0
  # argv:0-IP,1-端口,2-牌桌VID,3-UID
  Rob.new(ARGV[0].to_s,ARGV[1].to_s,ARGV[2].to_i,ARGV[3].to_i)
end
