<?php
	include_once 'RegisterBase.php';
	
	/**
	 *  注册
	 */
    class ChannelRegLogin extends APIBase {
		
		public $tag = "ChannelRegLogin";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['user']) || !isset($this->param['channel'])) {
				$this->returnError(301, "参数错误");
			}
			$password = Game::$channel_default_password;
			$username = $this->param['channel'].'_'.$this->param['user'];
			$where = array('user' => strtolower($username));
			$row = $this->mysql->select("player", "*", $where);
// 			var_dump($row);
			if (!empty($row) && sizeof($row[0]) >= 1) {
				$user_info = RegisterBase::commLogin($this, $row[0],$this->param['channel']);
			}else {
				if (!isset($this->param['name']) || strlen($this->param['name'])==0) {
					$this->param['name'] = $this->param['user'];
				}
				if (!isset($this->param['sex']) || strlen($this->param['sex'])==0) {
					$this->param['sex'] = 1;
				}
				$user_info = RegisterBase::commReg($this,$username,$this->param['name'],$password,$this->param['sex'],0);
			}		
			$this->returnData($user_info);
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>