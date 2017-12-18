<?php
include_once(path_format('config/config.php'));

class Mysql {
    private $conn = null;
	private $tag = "Mysql";

    public function __construct() {
		
    }
	
    public function connect($c) {
        if(!isset($c['port'])){
            $c['port'] = '3306';
        }
        $server = $c['host'] . ':' . $c['port'];
        $this->conn = mysql_connect($server, $c['username'], $c['password'], true);
		if ($this->conn) {
			$ret = mysql_select_db($c['dbname'], $this->conn);
			if (!$ret) {
				Config::$logger->error($this->tag, "Can not use db : " . mysql_error());
				return false;
			}
			if ($c['charset']) {
				return mysql_query("set names " . $c['charset'], $this->conn);
			}
			return true;
		}
		Config::$logger->error($this->tag, "Could not connect : " . mysql_error());
		return false;
    }
	
	public function close() {
		return mysql_close($this->conn);
	}
	
    public function find($sql) {
        $data = array();
// 		Config::$logger->debug($this->tag, $sql);
        $result = mysql_query($sql, $this->conn);
		if ($result) {
			while ($row = mysql_fetch_assoc($result)) {
				$data[] = $row;
			}
		}
        return $data;
    }
    
    public function select($table, $columns, $where, $other = '') {
        $cond = '';
        if (!empty($where) && sizeof($where)>0) {
        	foreach ($where as $k => $v) {
				$value = mysql_real_escape_string($v);
	            $cond .= "`$k` = '$value' AND ";
	        }
			$cond = substr($cond, 0, strlen($cond) - 5);
			
	        $sql = "SELECT $columns FROM `{$table}` WHERE $cond $other";
        }else {      	
        	$sql = "SELECT $columns FROM `{$table}` $other";
        }  
        
    	$data = array();
//     	Config::$logger->debug($this->tag, $sql);
    	$result = mysql_query($sql, $this->conn);
    	if ($result) {
    		while ($row = mysql_fetch_assoc($result)) {
    			$data[] = $row;
    		}
    	}
    	return $data;
    }
	
	public function insert($table, $row) {
        $stat = '';
        foreach ($row as $k => $v) {
			$value = mysql_real_escape_string($v);
            $stat .= "`$k` = '$value',";
        }
		
        $stat = substr($stat, 0, strlen($stat) - 1);
        $sql = "INSERT INTO `{$table}` SET $stat";
// 		Config::$logger->debug($this->tag, $sql);
        mysql_query($sql, $this->conn);
        return mysql_insert_id();
	}
	
	public function update($table, $row, $where) {
        $stat = '';
        foreach ($row as $k => $v) {
			$value = mysql_real_escape_string($v);
            $stat .= "`$k` = '$value',";
        }
        $stat = substr($stat, 0, strlen($stat) - 1);
		
        $cond = '';
        foreach ($where as $k => $v) {
			$value = mysql_real_escape_string($v);
            $cond .= "`$k` = '$value' AND ";
        }
		$cond = substr($cond, 0, strlen($cond) - 5);
		
        $sql = "UPDATE `{$table}` SET $stat where $cond";
// 		Config::$logger->debug($this->tag, $sql);
        return  mysql_query($sql, $this->conn);
	}
	
	public function insert_or_update($table, $row) {
	
        $stat = '';
        foreach ($row as $k => $v) {
			$value = mysql_real_escape_string($v);
            $stat .= "`$k` = '$value',";
        }

        $stat = substr($stat, 0, strlen($stat) - 1);
        $sql = "INSERT INTO `{$table}` SET $stat ON DUPLICATE KEY UPDATE $stat";
// 		Config::$logger->debug($this->tag, $sql);
        mysql_query($sql, $this->conn);
	}
	
	public function query($sql) {
// 		Config::$logger->debug($this->tag, $sql);
		return mysql_query($sql, $this->conn);
	}
}
?>
