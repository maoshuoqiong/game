<?php	
	/**
	 *  统计
	 */
    class Stat_Func extends APIBase {		
		public $tag = "Stat_Func";
		
		public function before() {
			$this->initMysqlSlave();
			return true;
		}

		public function logic() {
			if (!isset($this->param['st']) || !isset($this->param['et'])) {
				$this->returnError(301, '日期必须');
				return;
			}
			$st = strtotime($this->param['st']);
			$et = strtotime($this->param['et']);
			$type = $this->param['type'];
			if($type=="playTime"){
				$sqlAll = "select count(*) as num from player where heartbeat_at>".$st." and heartbeat_at<=".$et;
				$sqlNew = "select count(*) as num from player where create_time>".$st." and create_time<=".$et;
				$actAllPlayer = $this->mysqlSlave->find($sqlAll);
				$actNewPlayer = $this->mysqlSlave->find($sqlNew);
				// 玩牌局数
				$n0AllP = $this->mysqlSlave->find($sqlAll." and total_board=0");
				$n0NewP = $this->mysqlSlave->find($sqlNew." and total_board=0");
				$n1AllP = $this->mysqlSlave->find($sqlAll." and total_board=1");
				$n1NewP = $this->mysqlSlave->find($sqlNew." and total_board=1");
				$n2AllP = $this->mysqlSlave->find($sqlAll." and total_board=2");
				$n2NewP = $this->mysqlSlave->find($sqlNew." and total_board=2");
				$n3AllP = $this->mysqlSlave->find($sqlAll." and total_board=3");
				$n3NewP = $this->mysqlSlave->find($sqlNew." and total_board=3");
					
				$n3T5AllP = $this->mysqlSlave->find($sqlAll." and total_board>3 and total_board<=5");
				$n3T5NewP = $this->mysqlSlave->find($sqlNew." and total_board>3 and total_board<=5");
				
				$n5T10AllP = $this->mysqlSlave->find($sqlAll." and total_board>5 and total_board<=10");
				$n5T10NewP = $this->mysqlSlave->find($sqlNew." and total_board>5 and total_board<=10");
				$n10T20AllP = $this->mysqlSlave->find($sqlAll." and total_board>10 and total_board<=20");
				$n10T20NewP = $this->mysqlSlave->find($sqlNew." and total_board>10 and total_board<=20");
				$n20T50AllP = $this->mysqlSlave->find($sqlAll." and total_board>20 and total_board<=50");
				$n20T50NewP = $this->mysqlSlave->find($sqlNew." and total_board>20 and total_board<=50");
				$n50T100AllP = $this->mysqlSlave->find($sqlAll." and to tal_board>50 and total_board<=100");
				$n50T100NewP = $this->mysqlSlave->find($sqlNew." and total_board>50 and total_board<=100");
				$n100T200AllP = $this->mysqlSlave->find($sqlAll." and total_board>100 and total_board<=200");
				$n100T200NewP = $this->mysqlSlave->find($sqlNew." and total_board>100 and total_board<=200");
				$n200T500AllP = $this->mysqlSlave->find($sqlAll." and total_board>200 and total_board<=500");
				$n200T500NewP = $this->mysqlSlave->find($sqlNew." and total_board>200 and total_board<=500");
				$n500GAllP = $this->mysqlSlave->find($sqlAll." and total_board>500");
				$n500GNewP = $this->mysqlSlave->find($sqlNew." and total_board>500");
				 
				// 			var_dump($actAllPlayer);
				// 			var_dump($actNewPlayer);
				echo $this->param['st']."~".$this->param['et']."<br/>";
				echo "playerTime:ActUser:NewUser<br/>";
				echo "          :".$actAllPlayer[0]['num']."---".$actNewPlayer[0]['num']."<br/>";
				echo "       N=0:".$n0AllP[0]['num']."---".$n0NewP[0]['num']."<br/>";
				echo "       N=1:".$n1AllP[0]['num']."---".$n1NewP[0]['num']."<br/>";
				echo "       N=2:".$n2AllP[0]['num']."---".$n2NewP[0]['num']."<br/>";
				echo "       N=3:".$n3AllP[0]['num']."---".$n3NewP[0]['num']."<br/>";
				echo "    3~N=~5:".$n3T5AllP[0]['num']."---".$n3T5NewP[0]['num']."<br/>";
				echo "   5~N=~10:".$n5T10AllP[0]['num']."---".$n5T10NewP[0]['num']."<br/>";
				echo "  10~N=~20:".$n10T20AllP[0]['num']."---".$n10T20NewP[0]['num']."<br/>";
				echo "  20~N=~50:".$n20T50AllP[0]['num']."---".$n20T50NewP[0]['num']."<br/>";
				echo " 50~N=~100:".$n50T100AllP[0]['num']."---".$n50T100NewP[0]['num']."<br/>";
				echo "100~N=~200:".$n100T200AllP[0]['num']."---".$n100T200NewP[0]['num']."<br/>";
				echo "200~N=~500:".$n200T500AllP[0]['num']."---".$n200T500NewP[0]['num']."<br/>";
				echo "     500~N:".$n500GAllP[0]['num']."---".$n500GNewP[0]['num']."<br/>";
			}else if($type=="money"){
				$sqlAll = "select count(*) as num from player where heartbeat_at>".$st." and heartbeat_at<=".$et;
				$sqlNew = "select count(*) as num from player where create_time>".$st." and create_time<=".$et;
				$m2kAllP = $this->mysqlSlave->find($sqlAll." and money<=2000");
				$m2kNewP = $this->mysqlSlave->find($sqlNew." and money<=2000");
				
				$m2kT5kAllP = $this->mysqlSlave->find($sqlAll." and money>2000 and money<5000");
				$m2kT5kNewP = $this->mysqlSlave->find($sqlNew." and money>2000 and money<5000");
				$m5kAllP = $this->mysqlSlave->find($sqlAll." and money=5000");
				$m5kNewP = $this->mysqlSlave->find($sqlNew." and money=5000");
				$m6kAllP = $this->mysqlSlave->find($sqlAll." and money=6000");
				$m6kNewP = $this->mysqlSlave->find($sqlNew." and money=6000");
				$m5kT2wAllP = $this->mysqlSlave->find($sqlAll." and money>5000 and money<=20000 and money!=6000");
				$m5kT2wNewP = $this->mysqlSlave->find($sqlNew." and money>5000 and money<=20000 and money!=6000");
				$m2wT5wAllP = $this->mysqlSlave->find($sqlAll." and money>20000 and money<=50000");
				$m2wT5wNewP = $this->mysqlSlave->find($sqlNew." and money>20000 and money<=50000");
				$m5wT10wAllP = $this->mysqlSlave->find($sqlAll." and money>50000 and money<=100000");
				$m5wT10wNewP = $this->mysqlSlave->find($sqlNew." and money>50000 and money<=100000");
				$m10wT100wAllP = $this->mysqlSlave->find($sqlAll." and money>100000 and money<=1000000");
				$m10wT100wNewP = $this->mysqlSlave->find($sqlNew." and money>100000 and money<=1000000");
				$mG100wAllP = $this->mysqlSlave->find($sqlAll." and money>1000000");
				$mG100wNewP = $this->mysqlSlave->find($sqlNew." and money>1000000");
				
				echo $this->param['st']."~".$this->param['et']."<br/>";
				echo "moneyStat:ActUser:NewUser<br/>";
				echo "       N~=2K:".$m2kAllP[0]['num']."---".$m2kNewP[0]['num']."<br/>";
				echo "     2K~N~5K:".$m2kT5kAllP[0]['num']."---".$m2kT5kNewP[0]['num']."<br/>";
				echo "        N=5K:".$m5kAllP[0]['num']."---".$m5kNewP[0]['num']."<br/>";
				echo "        N=6K:".$m6kAllP[0]['num']."---".$m6kNewP[0]['num']."<br/>";
				echo "     5k~N=2w:".$m5kT2wAllP[0]['num']."---".$m5kT2wNewP[0]['num']."<br/>";
				echo "     2w~N=5w:".$m2wT5wAllP[0]['num']."---".$m2wT5wNewP[0]['num']."<br/>";
				echo "    5w~N=10w:".$m5wT10wAllP[0]['num']."---".$m5wT10wNewP[0]['num']."<br/>";
				echo "  10w~N=100w:".$m10wT100wAllP[0]['num']."---".$m10wT100wNewP[0]['num']."<br/>";
				echo "     N~=100w:".$mG100wAllP[0]['num']."---".$mG100wNewP[0]['num']."<br/>";				
			}else if($type=="initplayer"){
				$st = $this->param['su'];
				$et = $this->param['eu'];
				$sql = "select * from player where id>=".$st." and id<=".$et;
				$allPlayer = $this->mysqlSlave->find($sql);
				$inc = 0;
				foreach ($allPlayer as $p){
					$this->data_redis->hMset("hu:".$p['id'],$p); 			
					$inc++;
				}
				echo 'has init player '.$inc;
			}				
			//$this->returnData($user_info);
		}
		
		public function after() {
			$this->deinitMysqlSlave();
			$this->deinitDataRedis();
		}
    }
?>