<?php
/**
 * v1.0
 * 计费规则处理（客户端应用哪个支付SDK）
 * http://admin.53jiankang.com:88/api.php?uid=170607&skey=fff69dc3079a4178ac3b84a61afdddec&action=PayRule&param={%22imsi%22:%22460002228602609%22,%22sdks%22:%2201.03%22,%22cpId%22:%22100wpaytest000001%22,%22appId%22:%22com.landlord.ddzxh.10%22}
 */
class PayRule extends APIBase {

	public $tag = "PayRule";
	public $isLogin = false;

	public function before() {
		$this->initCacheRedis();
// 		$this->initMysql();
		return true;
	}

	public function logic() {		
		$sdk = CommonTool::getSdk($this->cache_redis,$_GET['uid'],$this->param['imsi'],
					strtolower($this->param['appId']),strtolower($this->param['cpId']),$this->param['sdks']);
		$data = array();
		$data['sdk'] = $sdk;
		$this->returnData($data);
	}

	public function after() {
// 		$this->deinitMysql();
		$this->deinitCacheRedis();
	}
}
?>