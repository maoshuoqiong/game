<?php
include_once 'ValidateService.php';
	/**
	 * 修改个人信息
	 */
    class ModifyInfoNew extends APIBase {
		
		public $tag = "ModifyInfoNew";
		
		public function before() {
			$this->initCacheRedis();
			$this->initMysql();
			return true;
		}
		
		public function logic() {
            $tmpArr = array();
            $tmpArr['name'] = '';
            $tmpArr['sex'] = 0; 
 
			if (!isset($this->param['name'])) {
				$this->returnError2($tmpArr,301, '昵称必填！');
				return;
			}
			if (!isset($this->param['sex'])) {
				$this->returnError2($tmpArr,301, '性别必填！');
				return;
			}
			
			$name = $this->param['name'];
			$sex = $this->param['sex'];
			
			$sex = mysql_real_escape_string($sex);
			if($sex<1 || $sex>2){
				$this->returnError2($tmpArr,301, '性别必填！');
				return;
			}

			// 判断敏感字
			$ret = ValidateService::validate_blackword ( $name, $this->mysql);
			if ($ret > 0) {				
				$this->returnError2($tmpArr,302, '含有敏感字符，请重新输入。');
				return;
			}
			
			
			$user = $this->data_redis->hMget("hu:{$this->uid}", array("coin","name","sex"));
			$cc = (int)$user['coin'];
			if($name!=$user['name']){
				// 正则验证
				$reg = '/^[\x{4e00}-\x{9fa5}a-zA-Z0-9]+$/u';
				if(!preg_match($reg, $name) or strlen($name) > 24 or strlen($name) < 4) {
					$this->returnError2($tmpArr,312, '2至8个汉字或4到24英文数字');
					return;
				}
				$name = mysql_real_escape_string($name);
				// 验证用户名是否存在
				$row = $this->mysql->select("player", "COUNT(*) AS count", array('name' => $name), " AND `id` != {$this->uid}");
				if ($row[0]['count'] >= 1) {
					$this->returnError2($tmpArr,313, '该昵称已被使用，请更换！');
				}
				// 如果已经修改过一次，则需要元宝才能修改
				$hasModify = $this->data_redis->hGet("hpe:{$this->uid}", "modifyName");
				//  			var_dump($hasModify);
				if(!empty($hasModify) && $hasModify==1){
					if($cc<Game::$modify_cost_coin){
						$this->returnError2($tmpArr,301, '再次修改昵称需要'.Game::$modify_cost_coin.'元宝');
						return;
					}
					$cc = $this->hincrCoin(-Game::$modify_cost_coin, "modifyName");
				}else{
					$this->data_redis->hSet("hpe:{$this->uid}", "modifyName",1);
					$this->mysql->update("playerext",array('modifyName' => 1), array('uid' => $this->uid));
				}				
			}	
			
			$this->mysql->update("player", array('name' => $name, 'sex' => $sex), array('id' => $this->uid));
			$this->data_redis->hMset("hu:{$this->uid}", array('name' => $name, 'sex' => $sex));
			
			$data = array();
			$data['name'] = $name;
			$data['sex'] = (int)$sex;
			$data['coin'] = $cc;
// 			var_dump($data);
			$this->returnData($data);
		}
		
    	public function after() {
    		$this->deinitCacheRedis();
			$this->deinitMysql();
			$this->deinitDataRedis();
		}
    }
?>