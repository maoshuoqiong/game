<?php
	/**
	 * 个人消息列表
	 */
    class PerMessList extends APIBase {
		
		public $tag = "PerMessList";
		
		public function before() {
			return true;
		}
		
		public function logic() {
			$prizeStr = $this->data_redis->get("pmess:{$this->uid}");
			if(!$prizeStr){
				$this->returnError(301, "暂无消息");
				return;
			}
			$prizeArr = json_decode($prizeStr);
			$id = 0;
			if(isset($this->param["id"]) && $this->param['id']>0){
				$id = $this->param['id'];
				if($id>10){
					$this->returnError(301, "消息不存在");
					return;
				}
			}			
			$inc = 1;
			$readItem = null;
			$awardes = array();
			$needUp = 0;
// 			var_dump($prizeArr);
			foreach ($prizeArr as $key) {
				if($key==null){
					continue;
				}
				$msg['ty'] = $key->ty;
				$msg['ti'] = $key->ti;
				$msg['d'] = (int)$key->d;
				$msg['id'] = $inc;
				$msg['ir'] = (int)$key->ir;
				if($id>0){
					$msg['c'] = $key->c;
				}				
				if($inc==$id){
					$msg['ir'] = 1;
					$needUp = (int)$key->ir;
					$readItem = $msg;
				}
				$inc++;
				$awardes[] = $msg;
			}
			if ($id>0) {
				if($readItem==null){
					$this->returnError(301, "消息已过期");
					return;
				}
				if($needUp==0){
					$prizeStr = json_encode($awardes);
					$this->data_redis->set("pmess:{$this->uid}",$prizeStr);
				}
// 				var_dump($readItem);
				$this->returnData(array('mes' => $readItem));
			}else{
// 				var_dump($awardes);
				$this->returnData(array('mes' => $awardes));
			}
// 			
		}
		
		public function after() {
			$this->deinitDataRedis();
		}
    }
?>