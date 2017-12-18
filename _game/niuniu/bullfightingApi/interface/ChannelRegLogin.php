<?php
	include_once 'RegisterBase.php';
	
	/**
	 *  注册
	 */
    class ChannelRegLogin extends APIBase {
		
		public $tag = "ChannelRegLogin";
		public $isLogin = false;
		
		public function before() {
			$this->initMysql();
			$this->initCacheRedis();
			return true;
		}

		public function logic() {
			if (!isset($this->param['uid']) || !isset($this->param['user']) 
					|| !isset($this->param['channel'])) {
				$this->returnError(301, "参数错误");
			}
			$password = Game::$channel_default_password;
			$username = $this->param['user'];
			$extid = "keke_".$this->param['uid'];
			$row = $this->mysql->select("player", "*", array('extid'=>$extid));
			if (!empty($row) && sizeof($row[0]) >= 1) {
				$user_info = RegisterBase::commLogin($this, $row[0],'c_keke');
			}else {
				if (!isset($this->param['name']) || strlen($this->param['name'])==0) {
					$this->param['name'] = $this->param['user'];
				}
				if (!isset($this->param['sex']) || strlen($this->param['sex'])==0) {
					$this->param['sex'] = 1;
				}
				$user_info = RegisterBase::commReg($this,$username,$this->param['name'],$password,$this->param['sex'],1,$extid);
			}	
			/* if(isset($this->param['image']) && strlen($this->param['image'])>0)	{
				$avaterUrl = $this->data_redis->hGet("hu:".$user_info['uid'],"avaterUrl");
				if($avaterUrl!=$this->param['image']){
					$this->data_redis->hMset("hu:".$user_info['uid'],array('avaterUrl'=>$this->param['image'],'headtime'=>time()));
				}
			} */
			$this->returnData($user_info);
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitCacheRedis();
			$this->deinitMysql();
		}
    }
?>