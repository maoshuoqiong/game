<?php
	/**
	 * 反馈
	 */
    class Feedback extends APIBase {
		
		public $tag = "Feedback";
		
		public function before() {
			$this->initMysql();
			return true;
		}
		
		public function logic() {
			if (!isset($this->param['content'])) {
				$this->returnError(300, '请填写反馈内容');
				return;
			}
			$content = $this->param['content'];
			$now = time();
			$feedback = array(
				'uid' => $this->uid,
				'type' => 0,
				'status' => 0,
				'content' => $content,
				'reply' => '',
				'user_id' => 0,
				'create_time' => $now,
				'update_time' => $now
			);
			$this->mysql->insert("feedback", $feedback);
			$this->returnData(NULL);
		}
		
    	public function after() {
			$this->deinitMysql();
		}
    }
?>