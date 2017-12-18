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
        $this->conn = mysqli_connect($server, $c['username'], $c['password']);
		if ($this->conn) {
			$ret = mysqli_select_db($this->conn,$c['dbname']);
			if (!$ret) {
				Config::$logger->error($this->tag, "Can not use db : " . mysqli_error($this->conn));
				return false;
			}
			if ($c['charset']) {
				return mysqli_query($this->conn, "set names " . $c['charset']);
			}
			return true;
		}
		Config::$logger->error($this->tag, "Could not connect : " . mysqli_error($this->conn));
		return false;
    }
	
	public function close() {
		return mysqli_close($this->conn);
	}
	
    public function find($sql) {
        $data = array();
// 		Config::$logger->debug($this->tag, $sql);
        $result = mysqli_query($this->conn, $sql);
		if ($result) {
			while ($row = mysqli_fetch_assoc($result)) {
				$data[] = $row;
			}
		}
        return $data;
    }
    
    public function select($table, $columns, $where, $other = '') {
        $cond = '';
        if (!empty($where) && sizeof($where)>0) {
        	foreach ($where as $k => $v) {
				$value = mysqli_real_escape_string($this->conn,$v);
	            $cond .= "`$k` = '$value' AND ";
	        }
			$cond = substr($cond, 0, strlen($cond) - 5);
			
	        $sql = "SELECT $columns FROM `{$table}` WHERE $cond $other";
        }else {      	
        	$sql = "SELECT $columns FROM `{$table}` $other";
        }  
        
    	$data = array();
//     	Config::$logger->debug($this->tag, $sql);
    	$result = mysqli_query($this->conn, $sql);
    	if ($result) {
    		while ($row = mysqli_fetch_assoc($result)) {
    			$data[] = $row;
    		}
    	}
    	return $data;
    }
	
	public function insert($table, $row) {
        $stat = '';
        foreach ($row as $k => $v) {
			$value = mysqli_real_escape_string($this->conn, $v);
            $stat .= "`$k` = '$value',";
        }
		
        $stat = substr($stat, 0, strlen($stat) - 1);
        $sql = "INSERT INTO `{$table}` SET $stat";
// 		Config::$logger->debug($this->tag, $sql);
        mysqli_query($this->conn, $sql);
        return mysqli_insert_id($this->conn);
	}
	
	public function update($table, $row, $where) {
        $stat = '';
        foreach ($row as $k => $v) {
			$value = mysqli_real_escape_string($this->conn,$v);
            $stat .= "`$k` = '$value',";
        }
        $stat = substr($stat, 0, strlen($stat) - 1);
		
        $cond = '';
        foreach ($where as $k => $v) {
			$value = mysqli_real_escape_string($this->conn,$v);
            $cond .= "`$k` = '$value' AND ";
        }
		$cond = substr($cond, 0, strlen($cond) - 5);
		
        $sql = "UPDATE `{$table}` SET $stat where $cond";
// 		Config::$logger->debug($this->tag, $sql);
        return  mysqli_query($this->conn, $sql);
	}
	
	public function insert_or_update($table, $row) {
	
        $stat = '';
        foreach ($row as $k => $v) {
			$value = mysqli_real_escape_string($this->conn,$v);
            $stat .= "`$k` = '$value',";
        }

        $stat = substr($stat, 0, strlen($stat) - 1);
        $sql = "INSERT INTO `{$table}` SET $stat ON DUPLICATE KEY UPDATE $stat";
// 		Config::$logger->debug($this->tag, $sql);
        mysqli_query($this->conn, $sql);
	}
	
	public function query($sql) {
// 		Config::$logger->debug($this->tag, $sql);
		return mysqli_query($this->conn, $sql);
	}
}
?>
