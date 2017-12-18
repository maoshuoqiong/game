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
	puts add_venue(5)
	puts add_zone(5, 30201, "211.151.69.231", 30201, 9000)
	puts add_zone(5, 30202, "211.151.69.231", 30202, 9000)
	puts add_zone(5, 30203, "211.151.69.231", 30203, 9000)
	puts add_zone(5, 30204, "211.151.69.231", 30204, 9000)
	puts add_zone(5, 30205, "211.151.69.231", 30205, 9000)
	puts add_zone(5, 30206, "211.151.69.231", 30206, 9000)
	puts add_zone(5, 30207, "211.151.69.231", 30207, 9000)
	puts add_zone(5, 30208, "211.151.69.231", 30208, 9000)
	puts add_zone(5, 30209, "211.151.69.231", 30209, 9000)
	puts add_zone(5, 30210, "211.151.69.231", 30210, 9000)
end

main()
