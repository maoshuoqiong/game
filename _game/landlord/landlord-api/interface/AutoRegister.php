<?php
	include_once 'RegisterBase.php';
	/**
	 *  注册
	 */
    class AutoRegister extends APIBase {
		
		public $tag = "AutoRegister";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			$sex = 1;
			$user = $this->getRandomKeys(4).$this->getRandomKeys(6,false);
			$pwd = substr(md5(time().rand(0, 10000)), 0, 6);
			
			$user_info = RegisterBase::commReg($this,$user,$user,$pwd,$sex,1);
			$user_info['pwd'] = $pwd;				
			$this->returnData($user_info);
		}
		
		private function getRandomKeys($length, $bol=true){
			$output='';
			if($bol){
				for($a=0;$a<$length;$a++){
					$output.=chr(mt_rand(97,122));//小写字母
				}
			}else{
				for($a=0;$a<$length;$a++){
					$output.=chr(mt_rand(48,57));//数字
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
