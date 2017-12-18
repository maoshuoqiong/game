<?php
require_once './lib/Image.php';
	/**
	 * 抽奖
	 */
    class DownloadImag extends APIBase {

		public $tag = "DownloadImag";
		public $isLogin = false;
		public function before() {
			$this->initUnCheckSkey();
			$this->initMysql();
			return true;
		}

		public function logic() {
			if(!isset($_GET['isbig']) || !isset($_GET['uid'])){
				$this->returnData(array('uid'=>$_GET['uid'],'img'=>''),301);
				return;
			}			
			$uid = $_GET['uid'];
			$pInfo = $this->data_redis->hMget("hu:".$uid,array("avaterUrl","avaterUrlCurr","headtime"));
			$imagTime = $pInfo['headtime'];
			if(strlen($imagTime)<=0 || $pInfo['avaterUrlCurr']=='null' || $pInfo['avaterUrlCurr']=='null/0' ||
			  $pInfo['avaterUrlCurr']=='/0'){
				$this->returnData(array('uid'=>$uid,'img'=>''),301);
				return;
			}
			$isbig = $_GET['isbig']==1?1:0;
			if(strlen($pInfo['avaterUrlCurr'])>0){
				$uHeadImg = $pInfo['avaterUrlCurr'];
				if($pInfo['avaterUrl']!=$uHeadImg){
					$lastTwoChar = substr($uHeadImg, 0,18);
					if($lastTwoChar=='http://wx.qlogo.cn'){
						$lastTwoChar = substr($uHeadImg, strlen($uHeadImg)-2);
						if($lastTwoChar!='/0'){
							$uHeadImg .= '/0';
						}
					}
					switch (exif_imagetype($uHeadImg)) {
						case IMAGETYPE_GIF :
							$img = imagecreatefromgif($uHeadImg);
							break;
						case IMAGETYPE_JPEG :
							$img = imagecreatefromjpeg($uHeadImg);
							// 						imagepng($img);
							break;
						case IMAGETYPE_PNG :
							$img = imagecreatefrompng($uHeadImg);
							break;
						default :
							$this->returnData(array('uid'=>$_GET['uid'],'img'=>''),301);
							return;
					}
					$subPath = Game::$avatar_upload_path .ceil ( $uid / 1000 );
// 					echo $subPath;
					if(!is_dir($subPath)) {
						// 尝试创建目录
						if(!mkdir($subPath)){
							$this->returnData(array('uid'=>$_GET['uid'],'img'=>''),301);
							return;
						}						
					}
					// 保存大图
					$savePath = $subPath . "/".$uid.'.png';
					imagepng($img,$savePath);
					// 生成缩略图
					$this->saveThumb($savePath);
					
					if($isbig==1){
						$imagPath = $subPath . "/b_".$uid.'.png';
					}else{
						$imagPath = $subPath . "/s_".$uid.'.png';
					}
					$this->data_redis->hMset("hu:".$uid,array('avaterUrl'=>$uHeadImg));
				}
			}
			$subPath = ceil($uid/1000);
			$ilst = explode ( ",", Config::$robotList);
			if($uid>=$ilst[0] && $uid<=$ilst[1]){
				$subPath = "robot";
			}
			
			$thumbPrefix = $isbig==1?"b_":"s_";
			$imagPath = Game::$avatar_upload_path.$subPath."/".$thumbPrefix.$uid.".png";
			if (!file_exists($imagPath)) {
				$this->returnData(array('uid'=>$_GET['uid'],'img'=>''),301);
				return;
			}
// 			echo $imagPath.'</br>';
// 			$imagPath = 'http://gcfs.nearme.com.cn/avatar/347/870/258def74e6984446a0d8a752f11dc0f4.jpg';
 			$imgStr = file_get_contents($imagPath);
 			$base64 = base64_encode($imgStr);

/*   			$bin = substr($imgStr,0,2);
 			$strInfo = @unpack("C2chars", $bin);
 			$typeCode = intval($strInfo['chars1'].$strInfo['chars2']);
 			echo $typeCode;  */
//  						echo $imagPath;
//  			header("Content-type: image/png");
// 			echo $imgStr; 
 			$this->returnData(array('uid'=>(int)$uid,'headtime'=>(int)$imagTime,'isbig'=>$isbig,'img'=>$base64));
		}
		
		private function saveThumb($filename){
			$image =  getimagesize($filename);
			if(false !== $image) {
				//是图像文件生成缩略图
				$subPath = ceil ( $this->uid / 1000 );
				$savePath = Game::$avatar_upload_path . $subPath . "/";
				// 设置需要生成缩略图的文件前缀缀
				$thumbPrefix = 'b_,s_'; // 生产2张缩略图
				// 设置需要生成缩略图的文件后缀
				$thumbSuffix = ','; // 生产2张缩略图
				// 设置缩略图最大宽度
				$thumbMaxWidth = '174,92';
				// 设置缩略图最大高度
				$thumbMaxHeight = '174,92';		
				$thumbWidth		=	explode(',',$thumbMaxWidth);
				$thumbHeight		=	explode(',',$thumbMaxHeight);
				$thumbPrefix		=	explode(',',$thumbPrefix);
				$thumbSuffix = explode(',',$thumbSuffix);
				
				for($i=0,$len=count($thumbWidth); $i<$len; $i++) {
					$thumbname	=	$savePath.$thumbPrefix[$i].$this->uid.$thumbSuffix[$i].'.png';
					Image::thumb($filename,$thumbname,'',$thumbWidth[$i],$thumbHeight[$i],true);
				}
			}
		}
		
		public function after() {
			$this->deinitMysql();
    		$this->deinitDataRedis();
		}
    }
?>