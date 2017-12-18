<?php
include_once 'ValidateService.php';

	/**
	 * 修改个人信息
	 */
    class ModifyInfo extends APIBase {
		
		public $tag = "ModifyInfo";
		
		public function before() {
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
			// 正则验证
			$reg = '/^[\x{4e00}-\x{9fa5}a-zA-Z0-9]+$/u';
			if(!preg_match($reg, $name) or strlen($name) > 24 or strlen($name) < 4) {
				$this->returnError2($tmpArr,312, '2至8个汉字或4到24英文数字');
				return;
			}	
			$name = mysql_real_escape_string($name);
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
			
			// 验证用户名是否存在
			$row = $this->mysql->select("player", "COUNT(*) AS count", array('name' => $name), " AND `id` != {$this->uid}");
			if ($row[0]['count'] >= 1) {
				$this->returnError2($tmpArr,313, '该昵称已被使用，请更换！');
			}
			
			$this->mysql->update("player", array('name' => $name, 'sex' => $sex), array('id' => $this->uid));
			$this->data_redis->hMset("hu:{$this->uid}", array('name' => $name, 'sex' => $sex));
			
			$data = array();
			$data['name'] = $name;
			$data['sex'] = (int)$sex;
			
			$this->returnData($data);
		}
		
    	public function after() {
			$this->deinitMysql();
			$this->deinitDataRedis();
		}
    }
?>