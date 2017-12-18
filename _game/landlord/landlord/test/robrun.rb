require 'rubygems'
require 'json'
require "socket"
require 'net/http'

class Rob
def initialize(host,port,uid,skey,islandlord,isrob,vid)
      @_host=host
      @_port=port
      @_uid=uid
      @_vid=vid
      @_skey=skey
      @_islandlord=islandlord
      @_isrob=isrob
      @_isrunning=true
      
      time = Time.new
      ct = time.strftime("%Y-%m-%d %H:%M:%S")
      
#      puts "u:#{@_uid}.v:#{@_vid}.t:#{ct}"
#=begin      
      begin
      timeout = 20
      @_client = TCPSocket.new(@_host, @_port)

      secs = Integer(timeout)
      usecs = Integer((timeout - secs) * 1_000_000)
      optval = [secs, usecs].pack("l_2")
      @_client.setsockopt Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, optval
      @_client.setsockopt Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, optval
	
      # join table
      send_cmd(1001)

      while @_isrunning
              str = recv_msg(@_client)
              if str != nil
                      deal_recv(str.xor(13))
              end
      end
      rescue => err
              puts err
      ensure
              if @_client != nil
                      @_client.close
              end
      end
#=end	
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
        if cmd == 4014
                send_cmd(1008)
        end
        if nextUid == @_uid
#                puts "@@@@@@@@Start@@@@@@@@"
#                puts rec
#                puts "@@@@@@@@End@@@@@@@@@@"
                if cmd == 4001
                        send_cmd(1002)
                elsif cmd == 4006
                        send_cmd(1003)
                elsif cmd == 4008
                        send_cmd(1004)
                elsif cmd == 4011
                        send_cmd(1009)
                elsif cmd == 4018
			@_isrunning=false
			if @_client != nil
	                      @_client.close
        		end
		else
                end
        end
end

def send_cmd(cmd)
        params = Hash.new
        params['cmd'] = cmd
        params['uid'] = @_uid
        if cmd==1001
                params['vid'] = @_vid
                params['skey'] = @_skey
        elsif cmd==1003
                #叫地主3，不叫5
                params['action'] = @_islandlord
        elsif cmd==1004
                #抢地主4，不抢5
                params['action'] = @_isrob
        elsif cmd==1009
                params['robot'] = 2
        else
        end

    #    puts "send_cmd"
        data = params.to_json
     #   puts data;
        data = data.xor(13)
	st = 3+rand(8)
        sleep(st)
        send_msg(@_client, data)
#	puts "end_cmd"
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
      0.upto(self.size-1) do |i|
        r << (self[i].ord^x).chr
      end
      r
    end
  end
end
