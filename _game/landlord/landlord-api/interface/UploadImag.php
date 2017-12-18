<?php
	include_once './lib/UploadStreamToFile.php';
	/**
	 * 抽奖
	 */
    class UploadImag extends APIBase {

		public $tag = "UploadImag";

		public function before() {
			$this->initMysql();
			return true;
		}

		public function logic() {
			//导入上传类
			$upload = new UploadFile();
			//设置上传文件大小
			$upload->maxSize = 3292200;
			//设置附件上传目录,每一千个用户一个目录
			$subPath = ceil($this->uid/1000);			
			$upload->savePath = Game::$avatar_upload_path.$subPath."/";
			//设置需要生成缩略图，仅对图像文件有效
			$upload->thumb = true;
			//设置需要生成缩略图的文件前缀缀
			$upload->thumbPrefix = 'b_,s_';  //生产2张缩略图
			//设置需要生成缩略图的文件后缀
			$upload->thumbSuffix = ',';  //生产2张缩略图
			//设置缩略图最大宽度
			$upload->thumbMaxWidth = '300,120';
			//设置缩略图最大高度
			$upload->thumbMaxHeight = '300,120';
			//设置上传文件规则
			$upload->saveRule = $this->uid;
			//如果已存在头像则覆盖
			$upload->uploadReplace = true;
			if (!$upload->upload()) {
				//捕获上传异常
// 				echo $upload->getErrorMsg();
				$this->returnError(301, $upload->getErrorMsg());
			} else {	
				$now = time();
				$this->mysql->update("playerext",array('avatar' => $now), array('uid' => $this->uid));
				$this->data_redis->hSet("hpe:{$this->uid}","avatar",$now);
				$this->returnData(array('headtime'=>$now));
			}			
		}
		
		public function after() {
    		$this->deinitDataRedis();
			$this->deinitMysql();
		}
    }
?>