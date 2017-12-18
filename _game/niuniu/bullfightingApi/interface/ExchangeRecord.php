<?php
/**
	 * 兑换记录
	 */
class ExchangeRecord extends APIBase {
	public $tag = "ExchangeRecord";
	public function before() {
		$this->initMysql ();
		return true;
	}
	public function logic() {
		$row = $this->mysql->select ( "awardlog", "*", array (
				'uid' => $this->uid 
		), "ORDER BY create_time DESC" );
		if (empty ( $row ) || sizeof ( $row ) <= 0) {
			$this->returnError ( 301, "暂无兑换记录" );
			return;
		}
		$payrecords = array ();
		foreach ( $row as $ro ) {
			$payrecord = array ();
			$payrecord ['info'] = "您花费" . ( int ) $ro ['coin'] . $this->getMoneyName ( ( int ) $ro ['type'] ) . "兑换" . $ro ['desc'] . $this->getState ( ( int ) $ro ['status'] );
			$payrecord ['ct'] = ( int ) $ro ['create_time'];
			$payrecords [] = $payrecord;
		}
		// var_dump($payrecords);
		$this->returnData ( array (
				'res' => $payrecords 
		) );
	}
	private function getMoneyName($type) {
		if ($type == 2) {
			return "话费券";
		} else {
			return "元宝";
		}
	}
	private function getState($type) {
		if ($type == 2) {
			return "(已兑换)";
		} else {
			return "(处理中)";
		}
	}
	public function after() {
		$this->deinitMysql ();
	}
}
?>