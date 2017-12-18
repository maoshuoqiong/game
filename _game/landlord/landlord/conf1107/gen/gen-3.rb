require 'json'
require 'fileutils'

$prefix = "/usr/local/nddz/landlord/"
# $prefix = "/Users/luochuanting/Desktop/nddz/landlord/"
$vid = 3

$log_level = 3
$log_console = 0

$target_host = "211.151.69.231"
$game_host = "0.0.0.0"
$game_begin_port = 30101
$game_end_port = 30110

$log_agent_host = "211.151.69.230"
$log_agent_port = 32000
$log_agent_pass = "udppass123"

$main_db_host = "211.151.69.229"
$main_db_begin_port = 33001
$main_db_end_port = 33010
$main_db_pass = "coolplay159357"

$tables_begin = 1
$tables_end = 3000
$tables_min_money = 20000
$tables_max_money = 120000
$tables_base_money = 300
$tables_table_type = 1
$tables_min_bomb = 0
$tables_max_bomb = 1

$fix_task_96 = 4
$fix_task_192 = 6
$fix_task_384 = 10
$fix_task_768 = 12
$fix_task_1536 = 14

$random_task_enable = 1
$random_task_type1 = 4
$random_task_type2 = 2
$random_task_type3 = 4

def predo(dir)
	if (File.exist?(dir))
		FileUtils.rm_r(dir)
	end
	Dir::mkdir(dir)
end

def create_conf_file(port)
	conf = Hash.new
	conf["self"] = $prefix + "conf/" + $vid.to_s + "/landlord-" + port.to_s +  ".conf"
	# pid file
	conf["pid_file"] = $prefix + "conf/" + $vid.to_s + "/landlord-" + port.to_s +  ".pid"

	# log
	conf["log"] = Hash.new
	conf["log"]["log_file"] = $prefix + "log/" + $vid.to_s + "/landlord-" + port.to_s +  ".log"
	conf["log"]["level"] = $log_level
	conf["log"]["console"] = $log_console
	conf["log"]["rotate"] = 1
	conf["log"]["max_size"] = 1073741824
	conf["log"]["max_file"] = 10

	# server
	conf["game"] = Hash.new
	conf["game"]["host"] = $game_host
	conf["game"]["port"] = port

	# log agnet
	conf["log-agent"] = Hash.new
	conf["log-agent"]["host"] = $log_agent_host
	conf["log-agent"]["port"] = $log_agent_port
	conf["log-agent"]["pass"] = $log_agent_pass

	# main db
	conf["main-db"] = Array.new
	i = 0
	num = $main_db_end_port - $main_db_begin_port

	while i <= num  do
		conf["main-db"][i] = Hash.new
		conf["main-db"][i]["host"] = $main_db_host;
		conf["main-db"][i]["port"] = $main_db_begin_port + i;
		conf["main-db"][i]["pass"] = $main_db_pass;
		i +=1
	end

	# tables
	conf["tables"] = Hash.new
	conf["tables"]["begin"] = $tables_begin
	conf["tables"]["end"] = $tables_end
	conf["tables"]["min_money"] = $tables_min_money
	conf["tables"]["max_money"] = $tables_max_money
	conf["tables"]["base_money"] = $tables_base_money
	conf["tables"]["vid"] = $vid
	conf["tables"]["zid"] = port
	conf["tables"]["table_type"] = $tables_table_type
	conf["tables"]["min_bomb"] = $tables_min_bomb
	conf["tables"]["max_bomb"] = $tables_max_bomb

	# fix task
	conf["fix-task"] = Hash.new
	conf["fix-task"]["96"] = $fix_task_96
	conf["fix-task"]["192"] = $fix_task_192
	conf["fix-task"]["384"] = $fix_task_384
	conf["fix-task"]["768"] = $fix_task_768
	conf["fix-task"]["1536"] = $fix_task_1536

	# random task
	conf["random-task"] = Hash.new
	conf["random-task"]["enable"] = $random_task_enable
	conf["random-task"]["type1"] = $random_task_type1
	conf["random-task"]["type2"] = $random_task_type2
	conf["random-task"]["type3"] = $random_task_type3
	
	data = JSON.pretty_generate(conf)

	File.open(conf["self"], "w") do |file| 
	    file.puts(data) 
	end

	File.open(conf["pid_file"], "w") do |file| 
	end

	File.open(conf["log"]["log_file"], "w") do |file| 
	end
end

def create_conf
	predo($prefix + "conf/" + $vid.to_s)
	predo($prefix + "log/" + $vid.to_s)

	init_str = "\ndef main\n";
	init_str += "	puts add_venue(" + $vid.to_s + ")\n"
	start_str = ""
	i = $game_begin_port
	num = $game_end_port
	while i <= num  do
		create_conf_file(i)
		init_str += "	puts add_zone(" + $vid.to_s + ", " + i.to_s + ", \"" +  $target_host + "\", " + i.to_s + ", 9000)\n"
		start_str += $prefix + "landlord -f " + $prefix + "conf/" + $vid.to_s + "/landlord-" + i.to_s + ".conf -D\n"
		i +=1
	end

	content = ""
	File.open($prefix + "conf/init-router/init-std.rb", "r") do |file|  
		content = file.read()  
  	end

	init_str += "end\n";
	init_str += "\nmain()\n";
	File.open($prefix + "conf/init-router/init_" + $vid.to_s + ".rb", "w") do |file|
		file.puts(content)
	    file.puts(init_str)
	end

	File.open($prefix + "conf/start-sh/start_" + $vid.to_s + ".sh", "w") do |file|
		file.puts(start_str)
	end
end

create_conf()
