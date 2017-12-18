require_relative "core"

$host = '211.151.69.231'
$port = 30000
$passwd = 'coolplay159357'

def join_zone(uid, vid, action)
	params = Hash.new
	params['cmd'] = 1001
	params['pass'] = $passwd;
	params['uid'] = uid
	params['vid'] = vid
	params['action'] = action
    core = Core.new()
    core.exec_cmd($host, $port, params)
end

def add_zone(vid, zid, host, port, max)
	params = Hash.new
	params['cmd'] = 1003
	params['pass'] = $passwd;
	params['vid'] = vid
	params['zid'] = zid
	params['host'] = host
	params['port'] = port
	params['max'] = max
    core = Core.new()
    core.exec_cmd($host, $port, params)
end

def del_zone(vid, zid)
	params = Hash.new
	params['cmd'] = 1004
	params['pass'] = $passwd;
	params['vid'] = vid
	params['zid'] = zid
    core = Core.new()
    core.exec_cmd($host, $port, params)
end

def add_venue(vid)
	params = Hash.new
	params['cmd'] = 1006
	params['pass'] = $passwd;
	params['vid'] = vid
    core = Core.new()
    core.exec_cmd($host, $port, params)
end

def del_venue(vid)
	params = Hash.new
	params['cmd'] = 1007
	params['pass'] = $passwd;
	params['vid'] = vid
    core = Core.new()
    core.exec_cmd($host, $port, params)
end

def get_venue(vid, action)
	params = Hash.new
	params['cmd'] = 1008
	params['pass'] = $passwd;
	params['vid'] = vid
	params['action'] = action
    core = Core.new()
    core.exec_cmd($host, $port, params)
end

def get_player()
	params = Hash.new
	params['cmd'] = 1009
	params['pass'] = $passwd;
    core = Core.new()
    core.exec_cmd($host, $port, params)
end

def main
	puts add_venue(2)
	puts add_zone(2, 30051, "211.151.69.231", 30051, 9000)
	puts add_zone(2, 30052, "211.151.69.231", 30052, 9000)
	puts add_zone(2, 30053, "211.151.69.231", 30053, 9000)
	puts add_zone(2, 30054, "211.151.69.231", 30054, 9000)
	puts add_zone(2, 30055, "211.151.69.231", 30055, 9000)
	puts add_zone(2, 30056, "211.151.69.231", 30056, 9000)
	puts add_zone(2, 30057, "211.151.69.231", 30057, 9000)
	puts add_zone(2, 30058, "211.151.69.231", 30058, 9000)
	puts add_zone(2, 30059, "211.151.69.231", 30059, 9000)
	puts add_zone(2, 30060, "211.151.69.231", 30060, 9000)
	puts add_zone(2, 30061, "211.151.69.231", 30061, 9000)
	puts add_zone(2, 30062, "211.151.69.231", 30062, 9000)
	puts add_zone(2, 30063, "211.151.69.231", 30063, 9000)
	puts add_zone(2, 30064, "211.151.69.231", 30064, 9000)
	puts add_zone(2, 30065, "211.151.69.231", 30065, 9000)
end

main()
