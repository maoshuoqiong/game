<?php
	/**
	 * 私人场
	 */
    class PrivateVenue extends APIBase {
		public $tag = "PrivateVenue";
		public function before() {
			$this->initCacheRedis();
			$this->initMysql();
			return true;
		}
		public function logic() {
			if (!isset($this->param['type'])) {
				$this->returnError(301, '购买失败,非法操作');
				return;
			}
			$type = $this->param['type'];
			if($type == 'list'){
				$this->venueList();
			}elseif ($type == 'build'){
				$this->venueBuild();
			}elseif ($type == 'join'){
				$this->venueJoin();
			}else{
				$this->returnError(301, '非法操作');
				return;
			}
		}
		
		public function venueJoin(){
			if(!isset($this->param['ouid'])){
				$this->returnError(301, '非法操作');
				return;
			}
			if(!$this->cache_redis->exists('hpriVenue:'.$this->param['ouid'])){
				$this->returnError(301, '房间不存在');
				return;
			}
			$ven = $this->cache_redis->hMget('hpriVenue:'.$this->uid,array('tid','pass','pnum','limit'));
			
			if(strlen($ven['pass'])>0 && $ven['pass']!=$this->param['pass']){
				$this->returnError(301, '密码错误!'.$ven['pass'].':'.$this->param['pass']);
				return;
			}
			if($ven['pnum']>=5){
				$this->returnError(301, '房间已满员');
				return;
			}
			$pMoney = $this->data_redis->hGet('hu:'.$this->uid,'money');
			if($ven['limit']>$pMoney){
				$this->returnError(301, '金币不足');
				return;
			}
			$this->returnData(array('tid'=>(int)$ven['tid']));
		}
		
		public function venueList(){			
			$row = $this->cache_redis->keys("hpriVenue:*");
			$prizeArr = array();
			foreach ($row as $key) {
				$ven = $this->cache_redis->hGetAll($key);
				$ven['ouid']=(int)$ven['ouid'];	// 房主ID
				if($this->uid == $ven['ouid'] || $ven['tid']==0){
					continue;
				}
				$ven['tid']=(int)$ven['tid'];	// 房主ID
				if($this->uid == $ven['ouid']){
				    continue;
				}
				$ven['sex']=(int)$ven['sex'];	// 房主ID
				$ven['base']=(int)$ven['base'];	// 底分
			    if(strlen($ven['pass'])>0){
        		    $ven['pass'] = 1;
        		}else{
        		    $ven['pass'] = 0;
        		}
				$ven['pnum']=(int)$ven['pnum'];	// 玩家数量
				$ven['pname']=$ven['pname'];	// 房主名称
				$ven['limit']=(int)$ven['limit'];	// 底分
				$prizeArr[] = $ven;
			}
			$this->returnData(array('res'=>$prizeArr));
		}
		
		public function venueBuild(){
			$res = 0;
			if(!isset($this->param['base']) || $this->param['base']<=100){
				$base = 100;
			}
			if($this->cache_redis->exists('hpriVenue:'.$this->uid)){
				$ven = $this->cache_redis->hGetAll('hpriVenue:'.$this->uid);
				$ven['tid']=(int)$ven['tid'];	// 房主ID
				$ven['sex']=(int)$ven['sex'];	// 房主ID
				$ven['ouid']=(int)$ven['ouid'];	// 房主ID
				$ven['base']=(int)$ven['base'];	// 底分
        		if(strlen($ven['pass'])>0){
        		    $ven['pass'] = 1;
        		}else{
        		    $ven['pass'] = 0;
        		}
				$ven['pnum']=(int)$ven['pnum'];	// 玩家数量
				$ven['pname']=$ven['pname'];	// 房主名称
				$ven['limit']=(int)$ven['limit'];	// 底分
				$this->returnData(array('res'=>$ven));
				return;
			}			
			$pinfo = $this->data_redis->hMget("hu:{$this->uid}", array('name', 'sex', 'money'));
			if(!$pinfo['name'] || strlen(trim($pinfo['name']))<=0){
				$pname = '***';
			}else{
			    $pname = $pinfo['name'];
			}
			$base = (int)$this->param['base'];
		    $pass = trim($this->param['pass']);
			$limit = $this->getLimit($base);
			if($pinfo['money']<=$limit){
			    $this->returnError(301, '金币低于准入');
				return;
			}
			$ven = array(
			        'tid'=>0,	       // 房间ID
					'ouid'=>(int)$this->uid,	// 房主ID
					'base'=>$base,		// 底分
					'pass'=>$pass,		// 密码
					'pnum'=>0,			// 玩家数量
					'pname'=>$pname,	// 房主名称
			        'sex'=>(int)$pinfo['sex'],	// 房主性别
					'limit'=>$limit		// 准入
			);
			$this->cache_redis->hMset('hpriVenue:'.$this->uid,$ven);
			if(strlen($pass)>0){
			    $ven['pass'] = 1;
			}else{
			    $ven['pass'] = 0;
			}
			$this->returnData(array('res'=>$ven));
		}
		
		private function getLimit($base){
		    foreach (Game::$priv_config as $val){
		        if($val[0] == $base){
		            return $val[1];
		        }
		    }
		    return Game::$priv_config[0][1];
		}
		
		public function after() {
			$this->deinitCacheRedis();
			$this->deinitDataRedis();
			$this->deinitMysql();
		}
    }
?>