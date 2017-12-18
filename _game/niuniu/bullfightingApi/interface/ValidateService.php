<?php
/**
	 * 信息有效性校验
	 */
class ValidateService {
	public $tag = "ValidateService";
	
	/**
	 * 检查用户帐号的合法性
	 * @user
	 */
	public static function validate_user($str, $objMysql = NULL) {
		$arr = array ();
		$arr ['ret'] = 0;
		$arr ['msg'] = 'OK';
		
		$user_reg = '/^[a-zA-Z0-9]{4,16}$/'; // '/^[a-z\d_]{6,18}$/i'
		if (! preg_match ( $user_reg, $str )) {
			$arr ['ret'] = 1;
			$arr ['msg'] = "账号长度为4-16位，包含英文、数字，请重新填写";
		}
		
		if (isset ( $objMysql )) {
			$ret = ValidateService::validate_blackword ( $str, $objMysql );
			if ($ret > 0) {
				$arr ['ret'] = 2;
				$arr ['msg'] = '含有敏感字符，请重新输入。';
				return $arr;
			}
		}
		
		return $arr;
	}
	
	/**
	 * 检查密码的有效性
	 *
	 * @param unknown $pwd        	
	 * @return multitype:number string
	 */
	public static function validate_password($str) {
		$arr = array ();
		$arr ['ret'] = 0;
		$arr ['msg'] = 'OK';
		
		$password_reg = '/^[a-zA-Z0-9]{6,16}$/';
		if (! preg_match ( $password_reg, $str )) {
			$arr ['ret'] = 1;
			$arr ['msg'] = '密码最长为6-16位，包含英文、数字，请重新填写';
		}
		
		return $arr;
	}
	
	/**
	 * 检查昵称的有效性
	 *
	 * @param unknown $str        	
	 * @return multitype:number string
	 */
	public static function validate_name($str, $objMysql = NULL) {
		$arr = array ();
		$arr ['ret'] = 0;
		$arr ['msg'] = 'OK';
		
		if (isset ( $str )) {
			// 正则验证
			$reg = '/^[\x{4e00}-\x{9fa5}a-zA-Z0-9]+$/u';
			if (! preg_match ( $reg, $str )) {
				$arr ['ret'] = 1;
				$arr ['msg'] = '含有非法字符，昵称由汉字、英文或数字组成。';
				return $arr;
			}
			// 判断长度
			if (strlen ( $str ) > 24 or strlen ( $str ) < 4) {
				$arr ['ret'] = 1;
				$arr ['msg'] = '昵称长度为2至8个汉字或4至16个英文数字。';
				return $arr;
			}
			
			if (isset ( $objMysql )) {
				$ret = ValidateService::validate_blackword ( $str, $objMysql );
				if ($ret > 0) {
					$arr ['ret'] = 2;
					$arr ['msg'] = '含有敏感字符，请重新输入。';
					return $arr;
				}
			}
		}
		return $arr;
	}
	public static function validate_sign($str, $objMysql = NULL) {
		$arr = array ();
		$arr ['ret'] = 0;
		$arr ['msg'] = 'OK';
		
		if (isset ( $str )) {
			
			if (strlen ( $str ) > 54) {
				$arr ['ret'] = 1;
				$arr ['msg'] = '签名太长了，不超过18个汉字。';
				return $arr;
			}
			
			if (isset ( $objMysql )) {
				$ret = ValidateService::validate_blackword ( $str, $objMysql );
				if ($ret > 0) {
					$arr ['ret'] = 2;
					$arr ['msg'] = '含有敏感字符，请重新输入。';
					return $arr;
				}
			}
		}
		return $arr;
	}
	
	/**
	 * 检查敏感词
	 *
	 * @param unknown $str        	
	 * @param string $objMysql        	
	 * @return number
	 */
	public static function validate_blackword($str, $objMysql = NULL) {
		$ret = 0;
		if (isset ( $objMysql )) {
			// 判断是否包含敏感关键字
			$sql = "select count(0) as num from blackword where INSTR('" . $str . "', word) > 0";
			$row = $objMysql->find ( $sql );
			if (count ( $row ) > 0) {
				if ($row [0] ['num'] > 0) {
					$ret = 1;
				}
			}
		}
		return $ret;
	}
}
?>