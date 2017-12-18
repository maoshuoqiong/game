<?php
	/**
	 * 修改个人信息
	 */
    class ChangePwd extends APIBase {
		
		public $tag = "ChangePwd";
		
		public function before() {
			$this->initMysql();
			return true;
		}
		
		public function logic() { 
			if (!isset($this->param['pw']) || !isset($this->param['rpw'])) {
				$this->returnError(301, "请输入新密码");
				return;
			}
			$pw = $this->param['pw'];
			$rpw = $this->param['rpw'];
			if ($pw != $rpw) {
				$this->returnError(301, "两次输入不一致");
				return;
			}
			$password_reg = '/^[a-zA-Z0-9]{4,20}$/';
			if (!preg_match($password_reg,$pw)) {
				$this->returnError(301, '最长4-20位，含英文、数字，请重填');
				return;
			}
			$mdpw = md5($pw . Game::$salt_password);
			$this->mysql->update("player", array('password' => $mdpw), array('id' => $this->uid));
			$this->data_redis->hMset("hu:{$this->uid}", array('password' => $mdpw));
			
			$this->returnData(NULL,0,"密码修改成功");
		}
		
    	public function after() {
			$this->deinitMysql();
			$this->deinitDataRedis();
		}
    }
?>