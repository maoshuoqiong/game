<?php	
	/**
	 *  统计
	 */
    class Stat_Func extends APIBase {
		
		public $tag = "Stat_Func";
		public $isLogin = false;
		
		public function before() {
			$this->initMysqlSlave();
			$this->initMysql();
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
			if($type=="playboard"){
				$sqlAll = "select count(*) as num from player where id>10000 and heartbeat_at>".$st." and heartbeat_at<=".$et;
				$sqlNew = "select count(*) as num from player where id>10000 and create_time>".$st." and create_time<=".$et;
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
				$n50T100AllP = $this->mysqlSlave->find($sqlAll." and total_board>50 and total_board<=100");
				$n50T100NewP = $this->mysqlSlave->find($sqlNew." and total_board>50 and total_board<=100");
				$n100T200AllP = $this->mysqlSlave->find($sqlAll." and total_board>100 and total_board<=200");
				$n100T200NewP = $this->mysqlSlave->find($sqlNew." and total_board>100 and total_board<=200");
				$n200T500AllP = $this->mysqlSlave->find($sqlAll." and total_board>200 and total_board<=500");
				$n200T500NewP = $this->mysqlSlave->find($sqlNew." and total_board>200 and total_board<=500");
				$n500GAllP = $this->mysqlSlave->find($sqlAll." and total_board>500");
				$n500GNewP = $this->mysqlSlave->find($sqlNew." and total_board>500");
				 
				echo $this->param['st']."~".$this->param['et']."<br/>";
				echo "playerTime:ActUser:NewUser<br/>";
				echo "          &#9;".$actAllPlayer[0]['num']."---".$actNewPlayer[0]['num']."<br/>";
				echo "       0:&#9;".$n0AllP[0]['num']."---".$n0NewP[0]['num']."<br/>";
				echo "       1:&#9;".$n1AllP[0]['num']."---".$n1NewP[0]['num']."<br/>";
				echo "       2:&#9;".$n2AllP[0]['num']."---".$n2NewP[0]['num']."<br/>";
				echo "       3:&#9;".$n3AllP[0]['num']."---".$n3NewP[0]['num']."<br/>";
				echo "    3~5:&#9;".$n3T5AllP[0]['num']."---".$n3T5NewP[0]['num']."<br/>";
				echo "   5~10:&#9;".$n5T10AllP[0]['num']."---".$n5T10NewP[0]['num']."<br/>";
				echo "  10~20:&#9;".$n10T20AllP[0]['num']."---".$n10T20NewP[0]['num']."<br/>";
				echo "  20~50:&#9;".$n20T50AllP[0]['num']."---".$n20T50NewP[0]['num']."<br/>";
				echo " 50~100:&#9;".$n50T100AllP[0]['num']."---".$n50T100NewP[0]['num']."<br/>";
				echo "100~200:&#9;".$n100T200AllP[0]['num']."---".$n100T200NewP[0]['num']."<br/>";
				echo "200~500:&#9;".$n200T500AllP[0]['num']."---".$n200T500NewP[0]['num']."<br/>";
				echo "  500~N:&#9;".$n500GAllP[0]['num']."---".$n500GNewP[0]['num']."<br/>";
			}else if($type=="money"){
				$sqlAll = "select count(*) as num from player where id>10000 and heartbeat_at>".$st." and heartbeat_at<=".$et;
				$sqlNew = "select count(*) as num from player where id>10000 and rmb>0 and heartbeat_at>".$st." and heartbeat_at<=".$et;
				$m2kAllP = $this->mysqlSlave->find($sqlAll." and money<=300");
				$m2kNewP = $this->mysqlSlave->find($sqlNew." and money<=300");
				
				$m2kT5kAllP = $this->mysqlSlave->find($sqlAll." and money>300 and money<2000");
				$m2kT5kNewP = $this->mysqlSlave->find($sqlNew." and money>300 and money<2000");
				$m5kAllP = $this->mysqlSlave->find($sqlAll." and money=2000");
				$m5kNewP = $this->mysqlSlave->find($sqlNew." and money=2000");
				$m6kAllP = $this->mysqlSlave->find($sqlAll." and money>2000 and money<=5000");
				$m6kNewP = $this->mysqlSlave->find($sqlNew." and money>2000 and money<=5000");
				$m5kT2wAllP = $this->mysqlSlave->find($sqlAll." and money>5000 and money<=20000");
				$m5kT2wNewP = $this->mysqlSlave->find($sqlNew." and money>5000 and money<=20000");
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
				echo "       N~=300:".$m2kAllP[0]['num']."---".$m2kNewP[0]['num']."<br/>";
				echo "     300~N~2K:".$m2kT5kAllP[0]['num']."---".$m2kT5kNewP[0]['num']."<br/>";
				echo "        N=2K:".$m5kAllP[0]['num']."---".$m5kNewP[0]['num']."<br/>";
				echo "       2K~5K:".$m6kAllP[0]['num']."---".$m6kNewP[0]['num']."<br/>";
				echo "     5k~N=2w:".$m5kT2wAllP[0]['num']."---".$m5kT2wNewP[0]['num']."<br/>";
				echo "     2w~N=5w:".$m2wT5wAllP[0]['num']."---".$m2wT5wNewP[0]['num']."<br/>";
				echo "    5w~N=10w:".$m5wT10wAllP[0]['num']."---".$m5wT10wNewP[0]['num']."<br/>";
				echo "  10w~N=100w:".$m10wT100wAllP[0]['num']."---".$m10wT100wNewP[0]['num']."<br/>";
				echo "     N~=100w:".$mG100wAllP[0]['num']."---".$mG100wNewP[0]['num']."<br/>";				
			}else if($type=="lose"){
				$sqlc = "select count(id) as num from player where id>10000 and create_time>".$st." and create_time<=".$et;
				$sqlb = "select count(id) as num from player where id>10000 and create_time>".$st." and create_time<=".$et." and heartbeat_at<".$et;
				$sqlq = "select count(id) as num from player where id>10000 and create_time>".$st." and create_time<=".$et." and heartbeat_at<".$et." and broke_time>".$st." and broke_num=3";
				
				$day3 = $et+259200;
				$sqlb3 = "select count(id) as num from player where id>10000 and create_time>".$st." and create_time<=".$et." and heartbeat_at<".$day3;
				$sqlq3 = "select count(id) as num from player where id>10000 and create_time>".$st." and create_time<=".$et." and heartbeat_at<".$day3." and broke_time>".$st." and broke_num=3";
				
				$rsc = $this->mysqlSlave->find($sqlc);
				$rsb1 = $this->mysqlSlave->find($sqlb);
				$rsq1 = $this->mysqlSlave->find($sqlq);
				$ratioL1 = $rsb1[0]['num']/$rsc[0]['num'];
				$ratioB1 = $rsq1[0]['num']/$rsc[0]['num'];
				
				$rsb3 = $this->mysqlSlave->find($sqlb3);
				$rsq3 = $this->mysqlSlave->find($sqlq3);
				$ratioL3 = $rsb3[0]['num']/$rsc[0]['num'];
				$ratioB3 = $rsq3[0]['num']/$rsc[0]['num'];
				echo $this->param['st']."~".$this->param['et']."<br/>";
				echo "new num:".$rsc[0]['num']."<br/>";
				echo "1day lose num:".$rsb1[0]['num'].",lose ratio:".$ratioL1."<br/>";				
				echo "1day broke num:".$rsq1[0]['num'].",lose ratio:".$ratioB1."<br/>";
				echo "3day lose num:".$rsb3[0]['num'].",lose ratio:".$ratioL3."<br/>";
				echo "3day broke num:".$rsq3[0]['num'].",lose ratio:".$ratioB3."<br/>";
			}else if($type=="playtime"){
				$sqlAll = "select * from player where id>10000 and create_time>".$st." and create_time<=".$et;
				echo $sqlAll;
				$res = $this->mysqlSlave->find($sqlAll);
				$diff = 0;
				$this->mysqlSlave->query("truncate table stat_play_time;");
				set_time_limit(0);
				foreach ($res as $g){
					$diff = $g['heartbeat_at']==0?0:ceil(($g['heartbeat_at']-$g['create_time'])/60);
					$this->mysqlSlave->insert("stat_play_time", array('uid'=>$g['id'],'playTime'=>$diff));
				}
				var_dump(sizeof($res));
				echo "<br/>";
				$sqStart = "select count(*) as num from stat_play_time where playTime>";
				$sqEnd = " and playTime<=";
				
				$d0 = $this->mysqlSlave->find("select count(*) as num from stat_play_time where playTime=0");
				$d3 = $this->mysqlSlave->find($sqStart."0".$sqEnd."3");
				$d5 = $this->mysqlSlave->find($sqStart."3".$sqEnd."5");
				$d10 = $this->mysqlSlave->find($sqStart."5".$sqEnd."10");
				$d30 = $this->mysqlSlave->find($sqStart."10".$sqEnd."30");
				$d1h = $this->mysqlSlave->find($sqStart."30".$sqEnd."60");
				$d6h = $this->mysqlSlave->find($sqStart."60".$sqEnd."360");
				$d12h = $this->mysqlSlave->find($sqStart."360".$sqEnd."720");
				$d24h = $this->mysqlSlave->find($sqStart."720".$sqEnd."1440");
				$d2d = $this->mysqlSlave->find($sqStart."1440".$sqEnd."2880");
				$d3d = $this->mysqlSlave->find($sqStart."2880".$sqEnd."4320");
				$d1w = $this->mysqlSlave->find($sqStart."4320".$sqEnd."10080");
				$d1wm = $this->mysqlSlave->find($sqStart."10080");
				
				echo "       0:".$d0[0]['num']."<br/>";
				echo "     0~3:".$d3[0]['num']."<br/>";
				echo "     3~5:".$d5[0]['num']."<br/>";
				echo "     5~10:".$d10[0]['num']."<br/>";
				echo "     10~30:".$d30[0]['num']."<br/>";
				echo "     1H:".$d1h[0]['num']."<br/>";
				echo "     6H:".$d6h[0]['num']."<br/>";
				echo "     12H:".$d12h[0]['num']."<br/>";
				echo "     24H:".$d24h[0]['num']."<br/>";
				echo "     2d:".$d2d[0]['num']."<br/>";
				echo "     3d:".$d3d[0]['num']."<br/>";
				echo "     1W:".$d1w[0]['num']."<br/>";
				echo "     >1W:".$d1wm[0]['num']."<br/>";
			}else if($type=="rechargeBu"){
				$reTypeArr = array(2,3,5,6,10,20,30,50,100,300,500);	
				$strSt = date('Y-m-d H:i:s', $st);
				$strEt = date('Y-m-d H:i:s', $et);
				$inc = 0;
				foreach ($reTypeArr as $g){
					$sqlAll = "select count(*) as num from payorder where success=1 and rmb=".$g." and created_at>'".$strSt."' and created_at<='".$strEt."'";
// 					echo $sqlAll."<br/>";
					$tt = $this->mysqlSlave->find($sqlAll);
					$inc += $g*$tt[0]['num'];
// 					var_dump($tt);
					echo $g.":".$tt[0]['num']."<br/>";
				}
				echo "all:".$inc;				
			}else if($type=="loseDetail"){
				$bln = true;
				while ($bln) {
					$inc = 0;
					if($st>=$et){
						$bln = false;
						return;
					}
					$tempT = $st+86400;
					$sqlA = "select count(*) as num from tmplost where rmb>0 and create_time>".$st." and create_time<=".$tempT;
					$sqlB = "select count(*) as num from tmplost where total_board=0 and create_time>".$st." and create_time<=".$tempT;
					$sqlC = "select count(*) as num from tmplost where total_board>0 and total_board<=5 and create_time>".$st." and create_time<=".$tempT;
					$sqlD = "select count(*) as num from tmplost where total_board>5 and total_board<=10 and create_time>".$st." and create_time<=".$tempT;
					$sqlE = "select count(*) as num from tmplost where total_board>10 and total_board<=50 and create_time>".$st." and create_time<=".$tempT;
					$sqlF = "select count(*) as num from tmplost where total_board>50 and create_time>".$st." and create_time<=".$tempT;
					
					$sqlAR = $this->mysqlSlave->find($sqlA);
					$sqlBR = $this->mysqlSlave->find($sqlB);
					$sqlCR = $this->mysqlSlave->find($sqlC);
					$sqlDR = $this->mysqlSlave->find($sqlD);
					$sqlER = $this->mysqlSlave->find($sqlE);
					$sqlFR = $this->mysqlSlave->find($sqlF);
					
					$st = $tempT;
					$inc += $sqlBR[0]['num']+$sqlCR[0]['num']+$sqlDR[0]['num']+$sqlER[0]['num']+$sqlFR[0]['num'];
					echo date('Y-m-d H:i:s', $st)."<br/>";
					
					echo "eq0:".$sqlBR[0]['num']."<br/>";
					echo "lq5:".$sqlCR[0]['num']."<br/>";
					echo "lq10:".$sqlDR[0]['num']."<br/>";
					echo "lq50:".$sqlER[0]['num']."<br/>";
					echo "gq50:".$sqlFR[0]['num']."<br/>";
					echo "rmb:".$sqlAR[0]['num']."<br/>";
					
					echo "all:".$inc."<br/>";
				}								
			}else if($type=="pump"){
				$bln = true;
				while ($bln) {
					$inc = 0;
					if($st>=$et){
						$bln = false;
						return;
					}
					$tempT = $st+86400;
					$sqlA = "select sum(diff_val) as num from agent_log_201410 where id>11900000 and vid=1 and `type`='game' and `action`=1 and create_time>".$st." and create_time<=".$tempT;
					$sqlB = "select sum(diff_val) as num from agent_log_201410 where id>11900000 and vid=2 and `type`='game' and `action`=1 and create_time>".$st." and create_time<=".$tempT;
					$sqlC = "select sum(diff_val) as num from agent_log_201410 where id>11900000 and vid=3 and `type`='game' and `action`=1 and create_time>".$st." and create_time<=".$tempT;
					$sqlD = "select sum(diff_val) as num from agent_log_201410 where id>11900000 and vid=4 and `type`='game' and `action`=1 and create_time>".$st." and create_time<=".$tempT;
					$sqlE = "select sum(diff_val) as num from agent_log_201410 where id>11900000 and vid=5 and `type`='game' and `action`=1 and create_time>".$st." and create_time<=".$tempT;
					$sqlF = "select sum(diff_val) as num from agent_log_201410 where id>11900000 and vid=6 and `type`='game' and `action`=1 and create_time>".$st." and create_time<=".$tempT;
					
					$sqlAR = $this->mysqlSlave->find($sqlA);
					$sqlBR = $this->mysqlSlave->find($sqlB);
					$sqlCR = $this->mysqlSlave->find($sqlC);
					$sqlDR = $this->mysqlSlave->find($sqlD);
					$sqlER = $this->mysqlSlave->find($sqlE);
					$sqlFR = $this->mysqlSlave->find($sqlF);
					
					$st = $tempT;
					echo date('Y-m-d H:i:s', $st)."<br/>";

					echo "v1:".ceil($sqlAR[0]['num']*0.15/10000)."<br/>";
					echo "v2:".ceil($sqlBR[0]['num']*0.15/10000)."<br/>";
					echo "v3:".ceil($sqlCR[0]['num']*0.15/10000)."<br/>";
					echo "v4:".ceil($sqlDR[0]['num']*0.25/10000)."<br/>";
					echo "v5:".ceil($sqlER[0]['num']*0.25/10000)."<br/>";
					echo "v6:".ceil($sqlFR[0]['num']*0.25/10000)."<br/>";
				}							
			}elseif ($type=="coin2money"){
				$bln = true;
				while ($bln) {
					if($st>=$et){
						$bln = false;
						return;
					}
					$tempT = $st+86400;
					$sqlA = "select count(*) as num from awardlog where award_id=7 and create_time>".$st." and create_time<=".$tempT;
					$sqlAR = $this->mysqlSlave->find($sqlA);
						
					$st = $tempT;
					echo date('Y-m-d H:i:s', $st)."<br/>";
					echo "num:".($sqlAR[0]['num']*22)."<br/>";
				}
			}elseif ($type=="brokeNum"){
				$tb = $this->param['tb'];
				$bln = true;
				while ($bln) {
					if($st>=$et){
						$bln = false;
						return;
					}
					$tempT = $st+86400;
					$sqlA = "select count(*) as num from ".$tb." where type='freeGive' and create_time>".$st." and create_time<=".$tempT;
					$sqlAR = $this->mysqlSlave->find($sqlA);
						
					$st = $tempT;
					echo date('Y-m-d H:i:s', $st)."<br/>";
					echo "num:".floor($sqlAR[0]['num']/10)."<br/>";
				}
			}elseif ($type=="repQQ"){
				$sqlAll = "select * from player where extid like 'qq_%'";
				$res = $this->mysqlSlave->find($sqlAll);
				echo sizeof($res)."<br/>";
				$inc=0;
				foreach ($res as $g){
					$extid = substr($g['extid'], 3);
// 					echo "select * from player where extid='wb_".$extid."'<br/>";
					$r = $this->mysqlSlave->find("select * from player where extid='wb_".$extid."'");
					if(sizeof($r)>0){
						echo $r[0]['id'].'-'.$r[0]['rmb'].'-'.$r[0]['money']."<br/>";
						$inc++;
					}
				}
				echo $inc."<br/>";
			}else if($type=="rmb"){
				$sqlAll = "select count(*) as num from player where heartbeat_at>".$st." and heartbeat_at<=".$et." and ";
// 				$sqlAll = "select count(*) as num from player where ";
				$ay = $this->mysqlSlave->find("select count(*) as num from player where heartbeat_at>".$st." and heartbeat_at<=".$et);
				$a = $this->mysqlSlave->find($sqlAll." rmb=2");
				$b = $this->mysqlSlave->find($sqlAll." rmb=3");
				$c = $this->mysqlSlave->find($sqlAll." rmb=4");
				$d = $this->mysqlSlave->find($sqlAll." rmb=5");
				$e = $this->mysqlSlave->find($sqlAll." rmb>5 and rmb<=10");
				$f = $this->mysqlSlave->find($sqlAll." rmb>10 and rmb<=20");
				$g = $this->mysqlSlave->find($sqlAll." rmb>20 and rmb<=50");
				$h = $this->mysqlSlave->find($sqlAll." rmb>50 and rmb<=200");
				$i = $this->mysqlSlave->find($sqlAll." rmb>200 and rmb<=1000");
				$j = $this->mysqlSlave->find($sqlAll." rmb>1000");
				
				echo $this->param['st']."~".$this->param['et']."<br/>";
				echo "rmbstat:".$ay[0]['num']."<br/>";
				echo "2:".$a[0]['num']."<br/>";
				echo "3:".$b[0]['num']."<br/>";
				echo "4:".$c[0]['num']."<br/>";
				echo "5:".$d[0]['num']."<br/>";
				echo "5~10:".$e[0]['num']."<br/>";
				echo "10~20:".$f[0]['num']."<br/>";
				echo "20~50:".$g[0]['num']."<br/>";
				echo "50~200:".$h[0]['num']."<br/>";
				echo "200~1000:".$i[0]['num']."<br/>";
				echo ">1000:".$j[0]['num']."<br/>";				
			}/* elseif ($type=="insertPext"){
				$inc=0;
				set_time_limit(0);
				$now = date('Y-m-d H:i:s', time());
				for ($i=1;$i<2365;$i++){
					$pext = array(
						'uid'=>$i,
						'create_time'=>$now
					);
					$this->mysql->insert("playerext", $pext);
					$inc++;
				}
				echo $inc."<br/>";
			} */elseif ($type=="paypoint"){
				$sqlAll = "select count(*) as num from payorder where sdk='08' and created_at>'".$this->param['st']."' and created_at<='".$this->param['et']."'";
				$sqlsucc = "select count(*) as num from payorder where sdk='08' and success=1 and created_at>'".$this->param['st']."' and created_at<='".$this->param['et']."'";
				
				
// 				$sqlAll = "select count(*) as num from player where ";
// 				echo $sqlAll." and trap=-1 and pos=-1";
				$shopAll = $this->mysqlSlave->find($sqlAll." and pos=-1 and trap=-1");
				$shopsucc = $this->mysqlSlave->find($sqlsucc." and pos=-1 and trap=-1");
				$d0a = $this->mysqlSlave->find($sqlAll." and pos=0 and trap=0");
				$d0s = $this->mysqlSlave->find($sqlsucc." and pos=0 and trap=0");
				$d1a = $this->mysqlSlave->find($sqlAll." and pos=0 and trap=1");
				$d1s = $this->mysqlSlave->find($sqlsucc." and pos=0 and trap=1");
				$d2a = $this->mysqlSlave->find($sqlAll." and pos=0 and trap=5");
				$d2s = $this->mysqlSlave->find($sqlsucc." and pos=0 and trap=5");
				$d3a = $this->mysqlSlave->find($sqlAll." and pos=0 and trap=6");
				$d3s = $this->mysqlSlave->find($sqlsucc." and pos=0 and trap=6");
				$k1a = $this->mysqlSlave->find($sqlAll." and pos=1 and trap=2");
				$k1s = $this->mysqlSlave->find($sqlsucc." and pos=1 and trap=2");
				$r1a = $this->mysqlSlave->find($sqlAll." and pos=1 and trap=3");
				$r1s = $this->mysqlSlave->find($sqlsucc." and pos=1 and trap=3");
				$p1a = $this->mysqlSlave->find($sqlAll." and pos=1 and trap=4");
				$p1s = $this->mysqlSlave->find($sqlsucc." and pos=1 and trap=4");
				$k2a = $this->mysqlSlave->find($sqlAll." and pos=2 and trap=2");
				$k2s = $this->mysqlSlave->find($sqlsucc." and pos=2 and trap=2");
				$r2a = $this->mysqlSlave->find($sqlAll." and pos=2 and trap=3");
				$r2s = $this->mysqlSlave->find($sqlsucc." and pos=2 and trap=3");
				$p2a = $this->mysqlSlave->find($sqlAll." and pos=2 and trap=4");
				$p2s = $this->mysqlSlave->find($sqlsucc." and pos=2 and trap=4");
				$k3a = $this->mysqlSlave->find($sqlAll." and pos=3 and trap=2");
				$k3s = $this->mysqlSlave->find($sqlsucc." and pos=3 and trap=2");
				$r3a = $this->mysqlSlave->find($sqlAll." and pos=3 and trap=3");
				$r3s = $this->mysqlSlave->find($sqlsucc." and pos=3 and trap=3");
				$p3a = $this->mysqlSlave->find($sqlAll." and pos=3 and trap=4");
				$p3s = $this->mysqlSlave->find($sqlsucc." and pos=3 and trap=4");
				$k4a = $this->mysqlSlave->find($sqlAll." and pos=4 and trap=2");
				$k4s = $this->mysqlSlave->find($sqlsucc." and pos=4 and trap=2");
				$r4a = $this->mysqlSlave->find($sqlAll." and pos=4 and trap=3");
				$r4s = $this->mysqlSlave->find($sqlsucc." and pos=4 and trap=3");
				$p4a = $this->mysqlSlave->find($sqlAll." and pos=4 and trap=4");
				$p4s = $this->mysqlSlave->find($sqlsucc." and pos=4 and trap=4");
				$k5a = $this->mysqlSlave->find($sqlAll." and pos=5 and trap=2");
				$k5s = $this->mysqlSlave->find($sqlsucc." and pos=5 and trap=2");
				$r5a = $this->mysqlSlave->find($sqlAll." and pos=5 and trap=3");
				$r5s = $this->mysqlSlave->find($sqlsucc." and pos=5 and trap=3");
				$p5a = $this->mysqlSlave->find($sqlAll." and pos=5 and trap=4");
				$p5s = $this->mysqlSlave->find($sqlsucc." and pos=5 and trap=4");
				$k6a = $this->mysqlSlave->find($sqlAll." and pos=6 and trap=2");
				$k6s = $this->mysqlSlave->find($sqlsucc." and pos=6 and trap=2");
				$r6a = $this->mysqlSlave->find($sqlAll." and pos=6 and trap=3");
				$r6s = $this->mysqlSlave->find($sqlsucc." and pos=6 and trap=3");
				$p6a = $this->mysqlSlave->find($sqlAll." and pos=6 and trap=4");
				$p6s = $this->mysqlSlave->find($sqlsucc." and pos=6 and trap=4");
				
				echo "商城ALL:".$shopAll[0]['num']."<br/>";
				echo "商城SUCC:".$shopsucc[0]['num']."<br/>";
				echo "大厅特惠ALL:".$d0a[0]['num']."<br/>";
				echo "大厅特惠SUCC:".$d0s[0]['num']."<br/>";
				echo "大厅快充ALL:".$d1a[0]['num']."<br/>";
				echo "大厅快充SUCC:".$d1s[0]['num']."<br/>";
				echo "大厅老虎机拦截ALL:".$d2a[0]['num']."<br/>";
				echo "大厅老虎机拦截SUCC:".$d2s[0]['num']."<br/>";
				echo "大厅充值榜快充ALL:".$d3a[0]['num']."<br/>";
				echo "大厅充值榜快充SUCC:".$d3s[0]['num']."<br/>";
				echo "场馆1快充ALL:".$k1a[0]['num']."<br/>";
				echo "场馆1快充SUCC:".$k1s[0]['num']."<br/>";
				echo "场馆1入桌ALL:".$r1a[0]['num']."<br/>";
				echo "场馆1入桌SUCC:".$r1s[0]['num']."<br/>";
				echo "场馆1破产ALL:".$p1a[0]['num']."<br/>";
				echo "场馆1破产SUCC:".$p1s[0]['num']."<br/>";
				echo "场馆2快充ALL:".$k2a[0]['num']."<br/>";
				echo "场馆2快充SUCC:".$k2s[0]['num']."<br/>";
				echo "场馆2入桌ALL:".$r2a[0]['num']."<br/>";
				echo "场馆2入桌SUCC:".$r2s[0]['num']."<br/>";
				echo "场馆2破产ALL:".$p2a[0]['num']."<br/>";
				echo "场馆2破产SUCC:".$p2s[0]['num']."<br/>";
				echo "场馆3快充ALL:".$k3a[0]['num']."<br/>";
				echo "场馆3快充SUCC:".$k3s[0]['num']."<br/>";
				echo "场馆3入桌ALL:".$r3a[0]['num']."<br/>";
				echo "场馆3入桌SUCC:".$r3s[0]['num']."<br/>";
				echo "场馆3破产ALL:".$p3a[0]['num']."<br/>";
				echo "场馆3破产SUCC:".$p3s[0]['num']."<br/>";
				echo "场馆4快充ALL:".$k4a[0]['num']."<br/>";
				echo "场馆4快充SUCC:".$k4s[0]['num']."<br/>";
				echo "场馆4入桌ALL:".$r4a[0]['num']."<br/>";
				echo "场馆4入桌SUCC:".$r4s[0]['num']."<br/>";
				echo "场馆4破产ALL:".$p4a[0]['num']."<br/>";
				echo "场馆4破产SUCC:".$p4s[0]['num']."<br/>";
				echo "场馆5快充ALL:".$k5a[0]['num']."<br/>";
				echo "场馆5快充SUCC:".$k5s[0]['num']."<br/>";
				echo "场馆5入桌ALL:".$r5a[0]['num']."<br/>";
				echo "场馆5入桌SUCC:".$r5s[0]['num']."<br/>";
				echo "场馆5破产ALL:".$p5a[0]['num']."<br/>";
				echo "场馆5破产SUCC:".$p5s[0]['num']."<br/>";
				echo "场馆6快充ALL:".$k6a[0]['num']."<br/>";
				echo "场馆6快充SUCC:".$k6s[0]['num']."<br/>";
				echo "场馆6入桌ALL:".$r6a[0]['num']."<br/>";
				echo "场馆6入桌SUCC:".$r6s[0]['num']."<br/>";
				echo "场馆6破产ALL:".$p6a[0]['num']."<br/>";
				echo "场馆6破产SUCC:".$p6s[0]['num']."<br/>";
			}
							
			//$this->returnData($user_info);
		}
		
		public function after() {
			$this->deinitMysqlSlave();
			$this->deinitMysql();
		}
    }
?>