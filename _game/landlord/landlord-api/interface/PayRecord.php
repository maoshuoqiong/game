<?php
	/**
	 * 充值记录
	 */
    class PayRecord extends APIBase {
		
		public $tag = "PayRecord";
		
		public function before() {
			$this->initMysql();
			return true;
		}
		
		public function logic() {
			$row = $this->mysql->select("payrecord", "*", array('uid' => $this->uid), "ORDER BY create_time DESC");
			$payrecords = array();
			foreach ($row as $ro) {
				$payrecord = array();
				$payrecord['id'] = (int) $ro['id'];
				$payrecord['uid'] = (int) $ro['uid'];
				$payrecord['rmb'] = (int) $ro['rmb'];
				$payrecord['create_time'] = (int)$ro['create_time'];
				$payrecords[] = $payrecord;
			}
			$this->returnData(array('payrecords' => $payrecords));
		}
		
        public function after() {
			$this->deinitMysql();
		}
    }
?>