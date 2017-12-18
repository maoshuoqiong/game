<?php

class HttpClient{
	private $ch;

	function __construct() {
		$this->ch = curl_init();
		curl_setopt($this->ch, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; QQDownload 685; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; .NET4.0E)');//UA
		curl_setopt($this->ch, CURLOPT_TIMEOUT, 40);//超时
		//curl_setopt($this->ch, CURLOPT_FOLLOWLOCATION, TRUE);
		curl_setopt($this->ch, CURLOPT_AUTOREFERER, true);
		curl_setopt($this->ch, CURLOPT_RETURNTRANSFER, TRUE);
		curl_setopt($this->ch, CURLOPT_ENCODING, 'UTF-8');
	}

	function __destruct() {
		curl_close($this->ch);
	}

	final public function setProxy($proxy='http://192.168.0.103:3128') {
		//curl_setopt($this->ch, CURLOPT_HTTPPROXYTUNNEL, TRUE);
		//curl_setopt($this->ch, CURLOPT_PROXYTYPE, CURLPROXY_HTTP);//HTTP代理
		//curl_setopt($this->ch, CURLOPT_PROXYTYPE, CURLPROXY_SOCKS5);//Socks5代理
		curl_setopt($this->ch, CURLOPT_PROXY, $proxy);
	}

	final public function setReferer($ref='') {
		if($ref != '') {
			curl_setopt($this->ch, CURLOPT_REFERER, $ref);//Referrer
		}
	}

	final public function setCookie($ck='') {
		if($ck != '') {
			curl_setopt($this->ch, CURLOPT_COOKIE, $ck);//Cookie
		}
	}

	final public function Get($url, $header=false, $nobody=false) {
		curl_setopt($this->ch, CURLOPT_URL, $url);
		curl_setopt($this->ch, CURLOPT_POST, false);//POST
		curl_setopt($this->ch, CURLOPT_HEADER, $header);//返回Header
		curl_setopt($this->ch, CURLOPT_NOBODY, $nobody);//不需要内容
		return curl_exec($this->ch);
	}

	final public function Post($url, $data=array(), $header=false, $nobody=false) {
		curl_setopt($this->ch, CURLOPT_URL, $url);
		curl_setopt($this->ch, CURLOPT_HEADER, $header);//返回Header
		curl_setopt($this->ch, CURLOPT_NOBODY, $nobody);//不需要内容
		curl_setopt($this->ch, CURLOPT_POST, true);//POST
		curl_setopt($this->ch, CURLOPT_POSTFIELDS, http_build_query($data));
		return curl_exec($this->ch);
	}

}
?>
