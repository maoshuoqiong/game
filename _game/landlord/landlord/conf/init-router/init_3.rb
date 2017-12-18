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
	puts add_venue(3)
	puts add_zone(3, 30101, "211.151.69.231", 30101, 9000)
	puts add_zone(3, 30102, "211.151.69.231", 30102, 9000)
	puts add_zone(3, 30103, "211.151.69.231", 30103, 9000)
	puts add_zone(3, 30104, "211.151.69.231", 30104, 9000)
	puts add_zone(3, 30105, "211.151.69.231", 30105, 9000)
	puts add_zone(3, 30106, "211.151.69.231", 30106, 9000)
	puts add_zone(3, 30107, "211.151.69.231", 30107, 9000)
	puts add_zone(3, 30108, "211.151.69.231", 30108, 9000)
	puts add_zone(3, 30109, "211.151.69.231", 30109, 9000)
	puts add_zone(3, 30110, "211.151.69.231", 30110, 9000)
end

main()
