require 'rubygems'
require 'json'
require "socket"

$host = "192.168.1.106"
$port = 30001

client = nil
data = nil

params = Hash.new

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

# Assumes 'msg' is single-byte encoded
# and not larger than 4,3 GB ((2**(4*8)-1) bytes)
def send_msg(handle, msg)
	handle.write([msg.length].pack('I') + msg)
end

def recv_msg(handle)
	if message_size = handle.read(4) # sizeof (I)
		message_size = message_size.unpack('I')[0]
		handle.read(message_size)
	end
end
	
begin
timeout = 20
client = TCPSocket.new($host, $port)

secs = Integer(timeout)
usecs = Integer((timeout - secs) * 1_000_000)
optval = [secs, usecs].pack("l_2")
client.setsockopt Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, optval
client.setsockopt Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, optval
total = 0
d1 = 0
d2 = 0
d3 = 0
d4 = 0
while true 
	params['cmd'] = 0x1
	params['seqid'] = total
	t1 = Time.now.to_i
	puts "=============================="
	data = params.to_json
	data = data.xor(13)
	send_msg(client, data)
	str = recv_msg(client)
	puts str.xor(13)
	puts "=============================="
	puts ""
	t2 = Time.now.to_i
	t3 = t2 - t1
	total += 1
	if t3 == 1
		d1 += 1
	end

	if t3 == 2
		d2 += 1
	end

	if t3 == 3
		d3 += 1
	end

	if t3 >= 4
		d4 += 1
	end
	puts "total: [" + total.to_s + "] " + " d1: [" + d1.to_s + "] d2: [" + d2.to_s + "] d3: [" + d3.to_s + "] d4: [" + d4.to_s + "]"
	sleep(1)
end
rescue => err
	puts err
ensure
	if client != nil
		client.close
	end
end

