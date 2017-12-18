<?php
include_once 'ValidateService.php';
/**
 * 由管理后台调用的接口，可以修改一些个人信息
 */
class ZsystemCallApi extends APIBase {
	public $tag = "ZsystemCallApi";
	// 无需登录
	public $isLogin = false;
	public function before() {
		$this->initDataRedis (0);
		$this->initCacheRedis ();
		$this->initMysql ();
		return true;
	}
	public function logic() {
		$who = $_GET ['who'];
		$callpassword = $_GET ['callpassword'];
		$ip = $this->getIP ();
		// 操作事件
		$event = isset ( $this->param ['event'] ) ? $this->param ['event'] : "";
		
		$this->i ( "event=" . $event . ";who=" . $who . ";ip=" . $ip );
		if (isset ( $who ) && isset ( $ip ) && isset ( $callpassword )) {
			// 密码正确
			if (strcmp ( $callpassword, "SYS0o0o0o" ) == 0) {
				// ip正确
				if (strcmp ( $ip, "10.171.194.228" ) == 0 || strcmp ( $ip, "121.40.68.234" ) == 0
				|| strcmp ( $ip, "10.160.7.181" ) == 0 || strcmp ( $ip, "112.124.16.65" ) == 0) {
					// 修改个人信息
					if (strcmp ( $event, "user" ) == 0) {
						$this->logic_user ( $who );
						return;
					}
					;
				}
				else {
					$this->i ( $who . "[" . $this->uid . "IP is wrong:" . $ip );
				}
			}
			else {
				$this->i ( $who . "[" . $this->uid . "password is wrong:" . $callpassword );
			}
		}
		else {
			$this->i ( "非法请求");
		}
		return;
	}
	private function getIP() {
		$ip = "";
		// php获取ip的算法
		if ($_SERVER ['REMOTE_ADDR']) {
			$ip = $_SERVER ['REMOTE_ADDR'];
		} elseif (getenv ( "REMOTE_ADDR" )) {
			$ip = getenv ( "REMOTE_ADDR" );
		} elseif (getenv ( "HTTP_CLIENT_IP" )) {
			$ip = getenv ( "HTTP_CLIENT_IP" );
		} else {
			$ip = "unknown";
		}
		
		return $ip;
	}
	
	/**
	 * 修改用户基本信息(密码、金币)
	 */
	private function logic_user($who) {
		$this->uid = $_GET ['uid'];
		
		$this->i ( "uid=" . $this->uid );
		
		if (isset ( $this->uid )) {
			// 初始化redis 连接
			//$this->initDataRedis ( $this->uid );
			
			$password = isset ( $this->param ['password'] ) ? $this->param ['password'] : "";
			
			$money = isset ( $this->param ['money'] ) ? ( int ) $this->param ['money'] : 0;
			
			$coin = isset ( $this->param ['coin'] ) ? ( int ) $this->param ['coin'] : 0;
			
			$memo = isset ( $this->param ['memo'] ) ? $this->param ['memo'] : '';
			
			$tmpArr = array ();
			if ($money != 0) {
				$tmpArr ['money'] = $money;
				// 加金币
				$this->hincrMoney ( $money, "add Money by" . $who );
			}
			if ($coin != 0) {
				$tmpArr ['coin'] = $coin;
				// 加元宝
				$this->hincrCoin ( $coin, "add coin by" . $who );
			}
			
			if ($money != 0 || $coin != 0) {
				// 系统金币库 减除
				$this->mysql->query ( "update system_money set coin=coin - " . $coin . ",money=money - " . $money );
			}
			
			// 重新设置金币数
			// if (count($tmpArr) > 0) {
			// $this->data_redis->hMset ( "hu:{$this->uid}", $tmpArr);
			// }
			
			// 修改密码
			if (strlen ( $password ) > 0) {
				$str = $this->edit_password ( $password );
				if (strcmp ( $str, "success" ) == 0) {
					$tmpArr ['password'] = $password;
				}
				$this->i ( $who . " edited [" . $this->uid . "] password:" . $str );
			}
			
			// 记录修改日志
			if (count ( $tmpArr ) > 0) {
				$tmpArr ['uid'] = $this->uid;
				$tmpArr ['who'] = $who;
				$tmpArr ['memo'] = $memo;
				$this->mysql->insert ( "system_change_log", $tmpArr );
			}
			
			$this->returnData ( $tmpArr );
		} else {
			$this->e ( "uid is null , no action!" );
		}
		return;
	}
	
	/**
	 * 用户修改密码
	 */
	private function edit_password($new_password) {
		
		// 校验新密码的有效性
		$valid = ValidateService::validate_password ( $new_password );
		if ($valid ['ret'] != 0) {
			return "password error";
		}
		
		// 检查用户是否存在
		$row = $this->mysql->select ( "player", "password,salt", array (
				'id' => $this->uid 
		) );
		if (count ( $row ) == 0) {
			return "no this user:" . $this->uid;
		} else {
			$t_salt = $row [0] ['salt'];
			$pwd = md5 ( $new_password . $t_salt );
			$this->mysql->update ( "player", array (
					'password' => $pwd 
			), array (
					'id' => $this->uid 
			) );
			
			$this->data_redis->hMset ( "hu:{$this->uid}", array (
					'password' => $pwd 
			) );
		}
		
		return "success";
	}
	public function after() {
		$this->deinitDataRedis ();
		$this->deinitCacheRedis ();
		$this->deinitMysql ();		
	}
}

?>