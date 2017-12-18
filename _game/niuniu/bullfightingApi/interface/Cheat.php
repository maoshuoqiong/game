<?php
	/**
	 * 举报
	 */
    class Cheat extends APIBase {
		public $tag = "Cheat";
		
		public function before() {
			$this->initMysql();
			return true;
		}
		public function logic() {
			if (!isset($this->param['ctype'])||!isset($this->param['cuid'])) {
				$this->returnError(301, '举报失败，信息异常');
				return;
			}
			$ci = $this->data_redis->hMget("hpe:{$this->uid}",array('cheatTime','cheatInfo'));
// 			var_dump($ci);
			if($ci['cheatTime']){
				$ss = strtotime(date("Y-m-d"));
				if((int)$ci['cheatTime']>$ss){
					if($ci['cheatInfo']){
						$arr = explode(",", $ci['cheatInfo']);
						if(sizeof($arr)>=5 || in_array($this->param['cuid'], $arr)){
							$this->returnError(301, '每天最多举报5人，每人只能举报一次');
							return;
						}
						$ci['cheatInfo'] = $ci['cheatInfo'].",".$this->param['cuid'];
					}
				}else{
					$ci['cheatInfo'] = $this->param['cuid'];
				}
			}
			if(!$ci['cheatInfo']){
				$ci['cheatInfo'] = $this->param['cuid'];
			}
			$ci['cheatTime'] = time();
			
			$this->data_redis->hMset("hpe:{$this->uid}",array('cheatTime'=>$ci['cheatTime'],'cheatInfo'=>$ci['cheatInfo']));
			$feedback = array(
				'suid' => $this->uid,
				'tuid' => $this->param['cuid'],
				'ctype' => $this->param['ctype'],
				'create_time' => time()
			);
			$this->mysql->insert("cheat", $feedback);
			$this->returnData(NULL,0,'举报成功');
		}
		public function after() {			
			$this->deinitMysql();
			$this->deinitDataRedis();
		}
    }
?>