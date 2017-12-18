<?php
include_once 'ValidateService.php';
/**
 * 修改个人基本信息
 */
class UserEditInfo extends APIBase {
	public $tag = "UserEditInfo";
	public function before() {
		$this->initCacheRedis ();
		$this->initMysql ();
		return true;
	}
	public function logic() {
		$tmpArr = array ();
		$tmpArr ['edit'] = '';
		if (! isset ( $this->param ['edit'] )) {
			$this->returnError2 ( $tmpArr, 301, "缺少参数'edit'" );
			return;
		}
		
		$edit = $this->param ['edit'];
		//echo "edit=".$edit."</br>";
		
		// 1=修改基本信息
		$edit = ( int ) $edit;
		
		if ($edit == 1) {
			$this->logic_base ();
			return;
		} else if ($edit == 2) {
			// 修改帐号
			$this->logic_account ();
			return;
		} else if ($edit == 3) {
			// 修改密码
			$this->logic_password() ;
			return;
		} else if ($edit == 4) {
			// 绑定手机号
			$this->logic_mobile() ;
			return;
		}
		else {
			$this->returnError (301, 'edit参数非法！' );
			return;
		}
		
		return;
	}
	
	/**
	 * 修改昵称、性别等基础信息
	 */
	private function logic_base() {
		$name = $this->param ['name'];
		$sex = $this->param ['sex'];
		$sign = $this->param ['sign'];
		
		$user = $this->data_redis->hMget ( "hu:{$this->uid}", array (
				"coin",
				"name",
				"sex",
				"sign"
		) );
		$cc = ( int ) $user ['coin'];		
		
		$tmpArr = array ();		
		$taskFinishFlag = 0;		
		if (isset ( $name )) {
			$tmpArr ['name'] = $name;			
			if ($name != $user ['name']) {				
				$valid = ValidateService::validate_name ( $name , $this->mysql);
				if ($valid ['ret'] != 0) {
					$this->returnError ( 311, $valid ['msg'] );
					return;
				}								
				$name = mysql_real_escape_string ( $name );					
				// 验证用户名是否存在
				$row = $this->mysql->select ( "player", "COUNT(*) AS count", array (
						'name' => $name
				), " AND `id` != {$this->uid}" );
				if ($row [0] ['count'] >= 1) {
					$this->returnError2 ( $tmpArr, 313, '该昵称已被使用，请更换！' );
					return;
				}	
				$taskFinishFlag = 1;
			}			
		}
		
		if ( isset ($sex)) {						
			$sex = ( int ) mysql_real_escape_string ( $sex );							
			if ($sex == 0) {
				$tmpArr ["avater"] = "mm.png";
			}
			else if ($sex == 1) {
				$tmpArr ["avater"] = "gg.png";
			}
			else {
				$this->returnError2 ( $tmpArr, 301, '性别必填！' );
				return;
			}			
			$tmpArr ['sex'] = $sex;
		}
		if (isset ( $sign )) {
			$tmpArr ['sign'] = $sign;									
			$valid = ValidateService::validate_sign ( $sign , $this->mysql);
			if ($valid ['ret'] != 0) {
				$this->returnError ( 312, $valid ['msg'] );
				return;
			}
			
			$sign = mysql_real_escape_string ( $sign );			
		}
		
		if (count($tmpArr) == 0) {
			$this->returnError (  301, '请提交需要修改的内容！' );
			return;
		}
		
		$this->mysql->update ( "player", $tmpArr, array (
				'id' => $this->uid 
		) );
		$this->data_redis->hMset ( "hu:{$this->uid}", $tmpArr );
		// 更新任务状态
		if($taskFinishFlag == 1){
			$this->upTasksStatus(Game::$tasksId_edit_info);
		}
		$this->returnData ( $tmpArr );
	}
	
	/**
	 * 修改帐号、密码
	 */
	private function logic_account() {
		$user = $this->param ['user'];
		$password = $this->param ['password'];
		
		if (! isset ( $user )) {
			$this->returnError ( 301, '帐号必填！' );
			return;
		}
		if (! isset ( $password )) {
			$this->returnError ( 301, '密码必填！' );
			return;
		}
		
		$valid = ValidateService::validate_user ( $user , $this->mysql);
		if ($valid ['ret'] != 0) {
			$this->returnError ( 311, $valid ['msg'] );
		}
		
		$valid = ValidateService::validate_password ( $password );
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
		// 获取salt
		$row = $this->mysql->select ( "player", "salt,isauto", array (
				'id' => $this->uid 
		) );
		
		$auto = isset($row [0] ['isauto']) ? (int)$row [0] ['isauto'] : 1;
		if ($auto != 1) {
			$this->returnError ( 314, '只能修改一次帐号！' );
			return ;
		}
		
		$salt = $row [0] ['salt'];
		if (! isset ( $salt )) {
			$salt = Game::$salt_password;
		}
		$pwd = md5 ( $password . $salt );
		
		$tmp = array (
				'user' => $user,
				'password' => $pwd,
				'salt' => $salt,
				'isauto' => 0 
		);
		
		$this->mysql->update ( "player", $tmp, array (
				'id' => $this->uid 
		) );
		
		$this->data_redis->hMset ( "hu:{$this->uid}", $tmp );
		
		$data = array ();
		$data ['user'] = $user;
		$data ['password'] = $password;
		
		// var_dump($data);
		$this->returnData ( $data );
	}
	
	/**
	 * 用户修改密码
	 */
	private function logic_password() {
		$new_password = $this->param ['newpwd'];
		$password = $this->param ['password'];
		
		if (! isset ( $password ) || ! isset ( $new_password )) {
			$this->returnError ( 301, '密码必填！' );
			return;
		}
		// 校验旧密码的有效性
		// $valid = ValidateService::validate_password($password);
		// if ($valid['ret'] != 0) {
		// $this->returnError ( 312, $valid['msg']);
		// }
		
		// 校验新密码的有效性
		$valid = ValidateService::validate_password ( $new_password );
		if ($valid ['ret'] != 0) {
			$this->returnError ( 312, $valid ['msg'] );
		}
		
		// 检查用户是否存在
		$row = $this->mysql->select ( "player", "password,salt", array (
				'id' => $this->uid 
		) );
		if (count ( $row ) == 0) {
			$this->returnError ( 313, '用户不存在' );
		} else {
			$t_pwd = $row [0] ['password'];
			$t_salt = $row [0] ['salt'];
			$t_pwd2 = md5 ( $password . $t_salt );
			if (strcmp ( $t_pwd2, $t_pwd ) == 0) {
				// 输入的原密码正确
				$pwd = $t_pwd2 = md5 ( $new_password . $t_salt );
				$this->mysql->update ( "player", array (
						'password' => $pwd 
				), array (
						'id' => $this->uid 
				) );
				
				$this->data_redis->hMset("hu:{$this->uid}", array('password' => $pwd));					
			}
			else {
				$this->returnError ( 314, '请输入正确的原密码！' );
				return;
			}
		}
		
		$data = array ();
		//$data ['user'] = $user;
		
		// var_dump($data);
		$this->returnData ( $data , 0 , 'success' );
	}
	
	/**
	 * 绑定用户手机号码
	 */
	public function logic_mobile() {
		$phn = $this->param ['mobile'];
		
		if (! isset ( $phn )) {
			$this->returnError ( 301, '手机号必须' );
			return;
		}
		
		$mob = $this->data_redis->hGet ( "hu:{$this->uid}", "mobile" );
		if (strlen ( $mob ) == 11) {
			$this->returnError ( 303, '只能绑定一次手机号' );
			return;
		}
		if ($phn != $mob) {
			if (CommonTool::preg_mobile ( $phn ) != 1) {
				$this->returnError ( 302, '手机号非法' );
				return;
			}
			$bindUid = $this->mysql->select ( "player", "id", array (
					'mobile' => $phn
			) );
			if (! empty ( $bindUid )) {
				$this->returnError ( 304, '手机号已被其他用户使用' );
				return;
			}
			$this->mysql->update ( "player", array (
					'mobile' => $phn
			), array (
					'uid' => $this->uid
			) );
			$this->data_redis->hSet ( "hu:{$this->uid}", "mobile", $phn );
		}
		$this->returnData ( array (
				'mobile' => $phn
		) );
	}
	public function after() {
		$this->deinitCacheRedis ();
		$this->deinitMysql ();
		$this->deinitDataRedis ();
	}
}

?>