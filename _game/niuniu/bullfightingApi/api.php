<?php
	if (!defined("DDZ_DIR")) {
		define("DDZ_DIR", dirname(__FILE__));	
	}
	
	function path_format($file) {
		return DDZ_DIR . '/' . $file;
	}
	
	include_once(path_format('lib/logger.php'));
	include_once(path_format('lib/apibase.php'));
	include_once(path_format('config/config.php'));
	include_once(path_format('config/cmd.php'));
	include_once(path_format('config/game.php'));
	include_once(path_format('config/channelInfo.php'));
	include_once(path_format('lib/mysql.php'));
	
        //log request
       $url = 'http://'.$_SERVER['SERVER_NAME'].':'.$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];  
    Config::$logger_request->info("api.php", $url);

	$class_name = null;
	if (isset($_GET['cmd'])) {
		$class_name = Cmd::$cmd_array[$_GET['cmd']];
	} elseif (isset($_GET['action'])) {
		$class_name = $_GET['action'];
	} else {
		echo json_encode(array('ret' => 1, "desc" => "action no found."));
		exit(1);
	}

	$file = path_format("interface/" . $class_name . ".php");
	if (isset($_GET['ver'])) {
		$file = path_format("interface/" . $_GET['ver'] . '/' .  $class_name . ".php");
	}
	
//	echo "<pre />";
//	print_r($_REQUEST);
	
	if (file_exists($file)) {
		include_once($file);
		$cmd = new $class_name;
		$cmd->exec_logic();
	} else {
		echo json_encode(array('ret' => 2, "desc" => "file no found."));
		exit(2);
	}
?>
