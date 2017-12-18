<?php
include_once './lib/UploadStreamToFile.php';
/**
 * 上传头像
 */
class UploadImag extends APIBase {
	public $tag = "UploadImag";
	public function before() {
		$this->initMysql ();
		$this->initCacheRedis();
		return true;
	}
	public function logic() {
		// 导入上传类
		$upload = new UploadFile ();
		// 设置上传文件大小
		$upload->maxSize = 3292200;
		// 设置附件上传目录,每一千个用户一个目录
		$subPath = ceil ( $this->uid / 1000 );
		$upload->savePath = Game::$avatar_upload_path . $subPath . "/";
		// 设置需要生成缩略图，仅对图像文件有效
		$upload->thumb = true;
		// 设置需要生成缩略图的文件前缀缀
		$upload->thumbPrefix = 'b_,s_'; // 生产2张缩略图
		                                // 设置需要生成缩略图的文件后缀
		$upload->thumbSuffix = ','; // 生产2张缩略图
		                            // 设置缩略图最大宽度
		$upload->thumbMaxWidth = '174,92';
		// 设置缩略图最大高度
		$upload->thumbMaxHeight = '174,92';
		// 设置上传文件规则
		$upload->saveRule = $this->uid;
		// 如果已存在头像则覆盖
		$upload->uploadReplace = true;
		if (! $upload->upload ()) {
			// 捕获上传异常
			// echo $upload->getErrorMsg();
			$this->returnError ( 301, $upload->getErrorMsg () );
		} else {
			$img_money = Game::$upload_head_img_money;
			// 判断用户是否第一次上传头像
			$imagTime = $this->data_redis->hGet ( "hu:{$this->uid}", "headtime" );
			if (strlen ( $imagTime ) <= 1) {
				$img_money = 0;
			}			
			$total_money =  $this->data_redis->hGet ( "hu:{$this->uid}", "money" );
			if (!isset($total_money)) {
				$total_money = 0;
			}
			if ($img_money > 0 && $total_money < $img_money) {
				//不够钱
				$this->returnError ( 302, "上传头像需花费{$img_money}金币，请先充值。" );
				return;
			}
			
			$now = time ();
			$this->mysql->update ( "player", array (
					'headtime' => $now 
			), array (
					'uid' => $this->uid 
			) );
			$this->data_redis->hSet ( "hu:{$this->uid}", "headtime", $now );
			// 更新任务状态
			$this->upTasksStatus ( Game::$tasksId_up_avatar );			
			//扣钱
			$money = $this->hincrMoney(0 - $img_money,"uploadImage");			
			$this->returnData ( array (
					'headtime' => $now,
					'money' => $money
			) );
			
		}
	}
	public function after() {
		$this->deinitDataRedis ();
		$this->deinitCacheRedis();
		$this->deinitMysql ();
	}
}
?>