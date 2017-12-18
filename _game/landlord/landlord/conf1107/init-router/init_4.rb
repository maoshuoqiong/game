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
	puts add_venue(4)
	puts add_zone(4, 30151, "211.151.69.231", 30151, 9000)
	puts add_zone(4, 30152, "211.151.69.231", 30152, 9000)
	puts add_zone(4, 30153, "211.151.69.231", 30153, 9000)
	puts add_zone(4, 30154, "211.151.69.231", 30154, 9000)
	puts add_zone(4, 30155, "211.151.69.231", 30155, 9000)
	puts add_zone(4, 30156, "211.151.69.231", 30156, 9000)
	puts add_zone(4, 30157, "211.151.69.231", 30157, 9000)
	puts add_zone(4, 30158, "211.151.69.231", 30158, 9000)
	puts add_zone(4, 30159, "211.151.69.231", 30159, 9000)
	puts add_zone(4, 30160, "211.151.69.231", 30160, 9000)
end

main()
