<?php
	/**
	 * 消息列表
	 */
    class MessageListNew extends APIBase {
		
		public $tag = "MessageListNew";
		
		public function before() {
			$this->initCacheRedis();
			return true;
		}
		
		public function logic() {
			$channel = 'def';
			if(isset($this->param['channel'])){
				$channel = $this->param['channel'];
			}
			$prizeStr = $this->cache_redis->get("smesslist:".$channel);
			if(!$prizeStr){
				$this->returnError(301, "暂无消息");
				return;
			}
			$prizeArr = json_decode($prizeStr);
			$readStatus = $this->data_redis->hGetAll("hpmess:{$this->uid}");
// 			var_dump($prizeArr);
			if(isset($this->param["id"]) && $this->param['id']>0){
				$id = $this->param['id'];
				if(sizeof($readStatus)<=0 || !array_key_exists("m".$id,$readStatus)){
					$this->data_redis->hSet("hpmess:{$this->uid}","m".$id,1);
				}
				foreach ($prizeArr as $award) {
					if((int)$award->mid == $id){
						$g["ti"] = $award->title;
						$g["d"] = $award->date;
						$g["c"] = $award->content;
						$this->returnData(array('mes' => $g));
						return;
					}
				}
				$this->returnError(301, "消息已过期");
				return;
			}else {
				$ct = $this->data_redis->hGet("hu:{$this->uid}","create_time");
				foreach ($prizeArr as $award) {
					if($ct>0 && $award->date<$ct){
						continue;
					}
					$g["ir"] = sizeof($readStatus)>0 && array_key_exists("m".$award->mid,$readStatus)?1:0;
					$g["id"] = $award->mid;
					$g["ti"] = $award->title;
					$g["d"] = $award->date;
					$awardes[] = $g;
				}
				if (empty($awardes) || sizeof($awardes)<=0) {
					$g["ir"] = sizeof($readStatus)>0 && array_key_exists("m".$prizeArr[0]->mid,$readStatus)?1:0;
					$g["id"] = $prizeArr[0]->mid;
					$g["ti"] = $prizeArr[0]->title;
					$g["d"] = $prizeArr[0]->date;
					$awardes[] = $g;
				}
				$this->returnData(array('mes' => $awardes));
			}
		}
		
		public function after() {
			$this->deinitDataRedis();
			$this->deinitCacheRedis();
		}
    }
?>