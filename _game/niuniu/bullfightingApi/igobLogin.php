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
    Config::$logger_request->info("igobLogin.php", $url);

	$class_name = 'IgobSync';
	 
	$file = path_format("interface/" . $class_name . ".php");
	 
	
//	echo "<pre />";
//	print_r($_REQUEST);
	
	if (file_exists($file)) {
		include_once($file);
		$cmd = new $class_name;
		$cmd->exec_logic();
	}
	
	echo '0' ;
?>

 