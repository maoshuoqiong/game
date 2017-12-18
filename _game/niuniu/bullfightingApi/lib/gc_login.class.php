<?php
/**
 * @author Simon 2013 sanwkj@163.com
 * @copyright yunzhongfei
 */

 // appKey  请求注意替换！！！
define('NEARME_CONSUMER_KEY', 'bGzGSkfzlHs8sK0c0Kc8Kk8sk');
// appSecret 请求注意替换！！！
define('NEARME_SHA1_KEY_BASE', '61eA0cdf6084973C1CB946Ff17806085');
// 接口地址
define('NM_UC_SERVER', 'http://thapi.nearme.com.cn/account/GetUserInfoByGame');

class gc_login_base{
		
	protected $token;
	protected $secret;
	
	function __construct( $secret=null,$token=null ){
		$this->token=$token;
		$this->secret=$secret;
	}
	
	private function getParams(){
		$time=microtime(true);
		static $params;
		if(!$params){
			$params=array(
				'oauth_consumer_key'=>NEARME_CONSUMER_KEY,
				'oauth_nonce'=>intval($time) + rand(0,9),
				'oauth_signature_method'=>'HMAC-SHA1',
				'oauth_timestamp'=>intval($time*1000),
				'oauth_version'=>'1.0',
				'oauth_token'=>$this->token,
			);
			ksort($params);
		}
		return $params;
	}
	
	private function getParamString(){
		return http_build_query($this->getParams());
	}
	
	private function getBaseString(){
		return "POST&" . urlencode(NM_UC_SERVER) . "&" . urlencode($this->getParamString());
	}
	
	private function signature(){
		return urlencode(base64_encode( hash_hmac( 'sha1', $this->getBaseString(), NEARME_SHA1_KEY_BASE."&".$this->secret,true) ));
	}
	
	private function getAuthorization(){
		$params = $this->getParams();
		$params['signature']=$this->signature();
		$Authorization='';
		
		foreach($params as $k => $p){
			if($Authorization==''){
				$Authorization.=$k.'="'.$p.'"';
			}else{
				$Authorization.=','.$k.'="'.$p.'"';
			}
		}
		
		$Authorization="OAuth ".$Authorization;
		
		return $Authorization;
	}
	
	public function getUserInfo( $secret=null,$token=null ){
		$secret and $this->secret=$secret;
		$token and $this->token=$token;
		$Authorization = $this->getAuthorization();
		$opt = array(
			"http"=>array(
				"method"=>"POST",
				'header'=>"Authorization:".$Authorization
			)
		);
		
		$res=file_get_contents(NM_UC_SERVER,null,stream_context_create($opt));
		if($res&&(strpos($res, 'errorCode')===false&&strpos($res, 'errorCode')===false)){
			return json_decode(urldecode($res),true);
		}else{
			return false;
		}
	}
}
?>