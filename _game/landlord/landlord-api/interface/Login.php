<?php
	include_once 'RegisterBase.php';
	/**
	 * 登录
	 */
    class Login extends APIBase {
		
		public $tag = "Login";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['user'])) {
				$this->returnError(310, "用户名或手机号不能为空");
			}
			if (!isset($this->param['password'])) {
				$this->returnError(310, "密码不能为空");
			}
			$user = strtolower($this->param['user']);
			$row = $this->mysql->select ( "player", "*", array (
				'user' => $user
			));
			$bln = 0;
			if (count($row) == 0) {
				$bln = 1;				
			} elseif (count($row) > 1) {
				$this->e("{$user} repeat");
				$this->returnError(500, "内部错误");
			}else {
				$password = md5($this->param['password'].$row[0]['salt']);
				if ($password != $row[0]['password']) {
					$bln = 2;					
				}
			}
			
			if($bln>0){
				if(CommonTool::preg_mobile( $user ) != 1){
					if($bln ==1){
						$this->returnError(312, '用户名错误');
					}elseif ($bln == 2){
						$this->returnError(312, '密码错误');
					}
					return;
				}
				$bindUid = $this->mysql->select("playerext", "uid", array('mob' => $user));
				if(isset($bindUid[0]['uid']) && !empty($bindUid[0]['uid'])){
					$row = $this->mysql->select("player", "*", array('id' => $bindUid[0]['uid']));
					if (count($row) == 0) {
						$this->returnError(312, '手机号错误');			
					} elseif (count($row) > 1) {
						$this->e("{$user} repeat");
						$this->returnError(500, "用户名和密码必需");
					}else {
						$password = md5($this->param['password'].$row[0]['salt']);
						if ($password != $row[0]['password']) {
							$this->returnError(312, '密码错误');				
						}
					}
				}else {
					if($bln ==1){
						$this->returnError(312, '手机号错误');
					}elseif ($bln == 2){
						$this->returnError(312, '密码错误');
					}
				}
			}
			$user_info = RegisterBase::commLogin($this,$row[0],'comm');			
			
			$this->returnData($user_info);
		}		
		
    	public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>