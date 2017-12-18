<?php
	include_once 'RegisterBase.php';
	include_once 'ValidateService.php';
	/**
	 *  注册
	 */
    class Register extends APIBase {
		
		public $tag = "Register";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			// 是否自动注册 0=手动; 1=自动
			$auto = 0;
			$user = "";
			$pwd = "";
			$sex = rand(1, 2);
			
			if (isset($this->param ['auto'])) {
				$auto = ( int ) $this->param ['auto'];
			}			
			if ($auto == 0) {
				if (!isset($this->param['user'])) {
					$this->returnError(310, "用户名必需");
				}					
				if (!isset($this->param['password'])) {
					$this->returnError(310, "密码必需");
				}
				$user = $this->param['user'];
				$pwd = $this->param['password'];
				
				$user_reg = '/^[a-zA-Z0-9]{4,16}$/';
				$password_reg = '/^[a-zA-Z0-9]{4,16}$/';
				if (!preg_match($user_reg,$user)) {
					$this->returnError(311, '账号长度为4-16位，包含英文、数字，请重新填写');
				}
				if (!preg_match($password_reg,$pwd)) {
					$this->returnError(312, '密码最长为4-16位，包含英文、数字，请重新填写');
				}
					
				$where = array('user' => strtolower($user));
				$row = $this->mysql->select("player", "COUNT(*) AS `count`", $where);
				if ($row[0]['count'] >= 1) {
					$this->returnError(313, '用户名已经存在');
				}
					
				// 判断敏感字
				$ret = ValidateService::validate_blackword ($user, $this->mysql);
				if ($ret > 0) {
					$this->returnError(302, "含有敏感字符，请重新输入。");
					return;
				}
			}else {
				// 自动注册, 用户名、密码自动生成
				$sex = 1;
				$user = $this->getRandomKeys ( 6 ) . $this->getRandomKeys ( 6, false );
				$pwd = substr ( md5 ( time () . rand ( 0, 10000 ) ), 0, 6 );
			}			
			$user_info = RegisterBase::commReg($this,$user,$user,$pwd,$sex,$auto);
			$this->returnData($user_info);
		}
		
		private function getRandomKeys($length, $bol = true) {
			$output = '';
			if ($bol) {
				for($a = 0; $a < $length; $a ++) {
					$output .= chr ( mt_rand ( 97, 122 ) ); // 小写字母
				}
			} else {
				for($a = 0; $a < $length; $a ++) {
					$output .= chr ( mt_rand ( 48, 57 ) ); // 数字
				}
			}
			return $output;
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>