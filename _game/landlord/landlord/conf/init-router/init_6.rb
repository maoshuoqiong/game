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
	puts add_venue(6)
	puts add_zone(6, 30251, "211.151.69.231", 30251, 9000)
	puts add_zone(6, 30252, "211.151.69.231", 30252, 9000)
	puts add_zone(6, 30253, "211.151.69.231", 30253, 9000)
	puts add_zone(6, 30254, "211.151.69.231", 30254, 9000)
	puts add_zone(6, 30255, "211.151.69.231", 30255, 9000)
	puts add_zone(6, 30256, "211.151.69.231", 30256, 9000)
	puts add_zone(6, 30257, "211.151.69.231", 30257, 9000)
	puts add_zone(6, 30258, "211.151.69.231", 30258, 9000)
	puts add_zone(6, 30259, "211.151.69.231", 30259, 9000)
	puts add_zone(6, 30260, "211.151.69.231", 30260, 9000)
end

main()
