<?php
	/**
	 * 绑定手机号
	 */
    class BindMob extends APIBase {

		public $tag = "BindMob";

		public function before() {
			$this->initMysql();
			return true;
		}

		public function logic() {
			if (!isset($this->param['mob'])) {
				$this->returnError(301, '手机号必须');
				return;
			}
			$n = $this->param['mob'];
			$mob = $this->data_redis->hGet("hpe:{$this->uid}","mob");
			if(strlen($mob)==11){
				$this->returnError(303, '只能绑定一次手机号');
				return;
			}
			if($n!=$mob){
				$patt = '/^1[3|5][0-9]{9}$|^18\d{9}$/';
				if(preg_match($patt, $n)!=1){
					$this->returnError(302, '手机号非法');
					return;
				}
				$bindUid = $this->mysql->select("playerext", "uid", array('mob' => $n));
				if(!empty($bindUid)){
					$this->returnError(304, '手机号已被其他用户使用');
					return;
				}
				$this->mysql->update("playerext",array('mob' => $n), array('uid' => $this->uid));
				$this->data_redis->hSet("hpe:{$this->uid}","mob",$n);
			}
			$this->returnData(array('mob' => $n));
		}

		public function after() {
    		$this->deinitDataRedis();
			$this->deinitMysql();
		}
    }
?>