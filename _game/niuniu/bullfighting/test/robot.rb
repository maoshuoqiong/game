#encoding:utf-8
require "redis"
require_relative "robrun"

$r = Redis.new
$r = Redis.new(:host => "127.0.0.1", :port => 6580)
$rd = Redis.new
$rd = Redis.new(:host => "127.0.0.1", :port => 6579)
$rd.auth("bullfighting")
$r.auth("bullfighting")

def isNeedRobot()
	res = $r.hgetall("hrob:need")
	if !res.empty?
		skey = $r.get("srob:skey")
		threads = []
		res.each do |k,v|
			len = v.to_i
			if len>0
				for i in 1..len
					hostInfo = getHostInfo(k.to_s)
					isrob = isRob()
					$r.hincrby("hrob:need",k,-1)
					robList = $r.lrange("lrob:ids",0,-1)
					#puts robList.length
					if robList.length>0
						uid = $r.lpop("lrob:ids")
						initJoinData(uid,hostInfo[2].to_i,hostInfo[3].to_i)
						threads << Thread.new(hostInfo[0],hostInfo[1],k.to_i,uid.to_i){|a,b,c,d|
							Rob.new(a,b,c,d)
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

def isRob()
        ind = rand(10)
	#puts "rand:#{ind}"
        if ind>1
                 role = 1
        else
                 role = 0
        end
end

def initJoinData(uid,minM,maxM)
        res = $rd.hmget("hu:#{uid}","money")
        currM = res[0].to_i
        if currM>minM and (maxM == 0 or currM<maxM)

        else
                newM = minM+minM*rand(10)/10+rand(minM)
		incM = newM - currM
                $rd.hset("hu:#{uid}","money",newM)
		res = $r.hmget("moneystat",Array["rob-1","rob-2"])
		stat = res[0].to_i
		stat1 = res[1].to_i
                stat = stat + incM
		if stat>2000000000
			stat = stat - 2000000000
			stat1 = stat1 + 1
		elsif stat<-2000000000
			stat = stat + 2000000000
                        stat1 = stat1 - 1
		end
		$r.hmset("moneystat","rob-1",stat,"rob-2",stat1);
        end
end

# check if need robot
while true
	isNeedRobot()
	sleep(3)
end
