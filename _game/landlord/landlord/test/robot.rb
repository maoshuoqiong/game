require "redis"
require_relative "robrun"

$r = Redis.new
$r = Redis.new(:host => "127.0.0.1", :port => 23000)
$rd = Redis.new
$rd = Redis.new(:host => "127.0.0.1", :port => 23000)
$r.auth("yourpassword")
$rd.auth("yourpassword")

def isNeedRobot()
	res = $r.hgetall("hrob:need")
	if !res.empty?
		skey = $r.get("srob:skey")
		threads = []
		res.each do |k,v|
#			puts k.to_s + "====>" + v
			len = v.to_i
			if len>0
				for i in 1..len
					hostInfo = getHostInfo(k.to_s)
					roleInfo = getRoleInfo()
#					puts hostInfo
					#puts roleInfo
					$r.hincrby("hrob:need",k,-1)
					robList = $r.lrange("lrob:ids",0,-1)
				#	puts robList.length
					if robList.length>0
						uid = $r.lpop("lrob:ids")
						initJoinData(uid,hostInfo[2].to_i,hostInfo[3].to_i)
						threads << Thread.new(hostInfo[0],hostInfo[1],uid.to_i,skey,roleInfo[0],roleInfo[1],k.to_i){|a,b,c,d,e,f,g|
							Rob.new(a,b,c,d,e,f,g)
						}
						$r.rpush("lrob:ids",uid)
					end
				end
			end
        	end 
	end
end

def getHostInfo(vid)
        res = $r.hmget("hv:#{vid}",Array["ip","port","min_money","max_money"])
end

def getRoleInfo()
        ind = rand(10)
#	puts "rand:#{ind}"
        if ind==0
                 role = Array[5, 5]
        elsif ind>5
                 role = Array[3, 5]
        else
                 role = Array[3, 4]
        end
end

def initJoinData(uid,minM,maxM)
        res = $rd.hmget("hu:#{uid}","money")
        currM = res[0].to_i
#        puts "u:#{uid}.cM:#{currM}"
#       puts minM
#       puts maxM
        if currM>minM and (maxM == 0 or currM<maxM)

        else
                currM = minM+rand(maxM-minM)
#		puts "cU:#{currM}"
                $rd.hset("hu:#{uid}","money",currM)
        end
end

# check if need robot
while true
	isNeedRobot()
	sleep(3)
end
