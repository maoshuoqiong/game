<?php
include_once 'RegisterBase.php';
include_once 'ValidateService.php';

/**
 * 注册
 */
class Register extends APIBase {
	public $tag = "Register";
	public $isLogin = false;
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis ();
		return true;
	}
	public function logic() {
		// 是否自动注册 0=手动; 1=自动
		$auto = 0;
		$user = "";
		$pwd = "";
		$sex = 1;
		
		if (! isset ( $this->param ['auto'] )) {
			$this->returnError ( 310, "是否自动注册参数:auto[0|1]必须" );
		}
		
		$auto = ( int ) $this->param ['auto'];
		
		if ($auto == 0) {
			$user = $this->param ['user'];
			$pwd = $this->param ['password'];
			$sex = isset($this->param ['sex']) ? $this->param ['sex'] : 1;
			
			// 校验用户名、密码
			if (! isset ( $user )) {
				$this->returnError ( 310, "用户名不能为空" );
			}
			if (! isset ( $pwd )) {
				$this->returnError ( 310, "密码不能为空" );
			}
			
			$sex = isset ( $sex ) ? ( int ) isset ( $sex ) : 1;
			
			$valid = ValidateService::validate_user ( $user , $this->mysql);
			if ($valid ['ret'] != 0) {
				$this->returnError ( 311, $valid ['msg'] );
			}
			
			$valid = ValidateService::validate_password ( $pwd );
			if ($valid ['ret'] != 0) {
				$this->returnError ( 312, $valid ['msg'] );
			}
			// 检查用户是否存在
			$where = array (
					'user' => strtolower ( $user ) 
			);
			$row = $this->mysql->select ( "player", "COUNT(*) AS `count`", $where );
			if ($row [0] ['count'] >= 1) {
				$this->returnError ( 313, '用户名已经存在' );
			}
		} else {
			// 自动注册, 用户名、密码自动生成
			$sex = 1;
			$user = $this->getRandomKeys ( 4 ) . $this->getRandomKeys ( 6, false );
			$pwd = substr ( md5 ( time () . rand ( 0, 10000 ) ), 0, 6 );
			
			$where = array (
					'user' => strtolower ( $user ) 
			);
			$row = $this->mysql->select ( "player", "COUNT(*) AS `count`", $where );
			if ($row [0] ['count'] >= 1) {
				// 重新获取用户名
				$user = $this->getRandomKeys ( 4 ) . $this->getRandomKeys ( 6, false );
			}
		}
		
		$user_info = RegisterBase::commReg ( $this, $user, $user, $pwd, $sex, $auto ,"0");
		
		$this->returnData ( $user_info );
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
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
		$this->deinitMysql ();
	}
}
?>