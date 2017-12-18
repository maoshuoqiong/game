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
	puts add_venue(1)
	puts add_zone(1, 30001, "211.151.69.231", 30001, 9000)
	puts add_zone(1, 30002, "211.151.69.231", 30002, 9000)
	puts add_zone(1, 30003, "211.151.69.231", 30003, 9000)
	puts add_zone(1, 30004, "211.151.69.231", 30004, 9000)
	puts add_zone(1, 30005, "211.151.69.231", 30005, 9000)
	puts add_zone(1, 30006, "211.151.69.231", 30006, 9000)
	puts add_zone(1, 30007, "211.151.69.231", 30007, 9000)
	puts add_zone(1, 30008, "211.151.69.231", 30008, 9000)
	puts add_zone(1, 30009, "211.151.69.231", 30009, 9000)
	puts add_zone(1, 30010, "211.151.69.231", 30010, 9000)
	puts add_zone(1, 30011, "211.151.69.231", 30011, 9000)
	puts add_zone(1, 30012, "211.151.69.231", 30012, 9000)
	puts add_zone(1, 30013, "211.151.69.231", 30013, 9000)
	puts add_zone(1, 30014, "211.151.69.231", 30014, 9000)
	puts add_zone(1, 30015, "211.151.69.231", 30015, 9000)
end

main()
