<?php
	/**
	 * 获取MoreGame列表
	 */
    class MoreGameDownload extends APIBase {
		
		public $tag = "MoreGameDownload";
		public $isLogin = false;
		public function before() {
			$this->initCacheRedis();
			$this->initMysql();
			return true;
		}

		public function logic() {
			if (!isset($this->param['id']) || empty($this->param['id'])) {
				$this->returnError(301, '游戏不存在');
				return;
			}
			$id = $this->param['id'];
			$g = $this->cache_redis->hGetAll("hMoregame:{$id}");
			if(empty($g)){
				$this->returnError(301, '游戏信息不存在');
				return;
			}
			$goods ["id"] = (int)$g ["id"];
			$goods ["name"] = $g ["name"];
			$goods ["imagPath"] = $g["imagPath"];
			$goods ["status"] = (int)$g["status"];
			$goods ["size"] = $g["size"];
			$goods ["ver"] = $g["ver"];
			$goods ["star"] = (int)$g["star"];
			$goods ["pname"] = $g["packageName"];					
			$goods ["dev"] = $g["dev"];
			$goods ["extImag"] = explode(",", $g ["extImag"]);
			$goods ["desp"] = $g ["desp"];
			$goods ["type"] = $g ["type"];
			$goods ["md5"] = $g ["md5"];
			$goods ["url"] = $g["url"];
			$this->returnData(array('res' => $goods));
			/* else{
				$url = $this->cache_redis->hGet("hMoregame:{$id}","url");					
				if(isset($url)){
					$lottLog ['uid'] = $this->uid;
					$lottLog ['gameId'] = $id;
					$lottLog ['create_time'] = time();
					$this->mysql->insert ( "moregamelog", $lottLog );
					header("Location: ".$url);
				}
			} */			
		}
		
    	public function after() {
    		$this->deinitMysql();
			$this->deinitCacheRedis();
		}
    }
?>