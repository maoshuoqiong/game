<?php
include_once('config.php');

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
				return false;
			}
			if ($c['charset']) {
				return mysql_query("set names " . $c['charset'], $this->conn);
			}
			return true;
		}
		return false;
    }
	
	public function close() {
		return mysql_close($this->conn);
	}
	
    public function find($sql) {
        $data = array();
		
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
        foreach ($where as $k => $v) {
			$value = mysql_real_escape_string($v);
            $cond .= "`$k` = '$value' AND ";
        }
		$cond = substr($cond, 0, strlen($cond) - 5);
		
        $sql = "SELECT $columns FROM `{$table}` WHERE $cond $other";
        
    	$data = array();
    	
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
		
        mysql_query($sql, $this->conn);
	}
	
	public function query($sql) {
		return mysql_query($sql, $this->conn);
	}
}
?>
