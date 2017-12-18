<?php
	error_reporting(E_ALL);
	require_once './lib/Thrift/ClassLoader/ThriftClassLoader.php';	
	use Thrift\ClassLoader\ThriftClassLoader;
	
	$GEN_DIR = realpath(dirname(__FILE__)).'/gen-php';
	$LIB_DIR = realpath(dirname(__FILE__));
	$loader = new ThriftClassLoader();
	$loader->registerNamespace('Thrift', $LIB_DIR);
	$loader->registerDefinition('inner_service', $GEN_DIR);
	$loader->register();
	
	use Thrift\Protocol\TBinaryProtocol;
	use Thrift\Transport\TSocket;
	use Thrift\Transport\TFramedTransport;
	use Thrift\Exception\TException;
	
	class ThriftProxy{
		private $socket;
		private $transport;
		private $protocol;
		private $client;
		
		public function __construct() {
// 			echo "AAA<br/>";
			$this->socket = new TSocket(ChannelInfo::$proxy_ip, ChannelInfo::$proxy_port);
			$this->socket->setSendTimeout(100000);
			$this->transport = new TFramedTransport($this->socket,true,true);
			$this->protocol = new TBinaryProtocol($this->transport);
			$this->transport->open();				
			$this->client = new \inner_service\InnerTencentProxyServiceClient($this->protocol);
		}
		
		public function verify_qq_login($param){
			try {				
				$param = array(
						'openID'=>'1111',
						'openKey'=>'2222',
						'payToken'=>'33333',
						'pf'=>'44444',
						'pfKey'=>'55555',
						'clientIP'=>'66666'
				);
				$qqp = new \inner_service\QQLoginParam ($param);
				$this->client->verify_qq_login($qqp);
				echo "verify_qq_login...<br/>";
			} catch (TException $tx) {
				print 'TException: '.$tx->getMessage()."\n";
			}
		}

		public function check_wechat_token($param){
			try {
				$param = array(
						'openID'=>'1111',
						'openKey'=>'2222',
						'pf'=>'44444',
						'pfKey'=>'55555'
				);
				$qqp = new \inner_service\WeChatCheckTokenParam($param);
				$this->client->check_wechat_token($qqp);
				echo "check_wechat_token...<br/>";
			} catch (TException $tx) {
				print 'TException: '.$tx->getMessage()."\n";
			}
		}

		public function refresh_wechat_token($param){
			try {
				$param = array(
						'openID'=>'1111',
						'openKey'=>'2222',
						'refreshToken'=>'33333',
						'pf'=>'44444',
						'pfKey'=>'55555'
				);
				$qqp = new \inner_service\WeChatRefreshTokenParam ($param);
				$this->client->refresh_wechat_token($qqp);
				echo "refresh_wechat_token...<br/>";
			} catch (TException $tx) {
				print 'TException: '.$tx->getMessage()."\n";
			}
		}
		
		public function query_game_coins($param){
			try {
				$qqp = new \inner_service\QueryGameCoinsParam ($param);
				$res = $this->client->query_game_coins($qqp);
				
// 				echo "query_game_coins...<br/>";
				return $res;
			} catch (TException $tx) {
				print 'TException: '.$tx->getMessage()."\n";
			}
		}
		
		public function pay_game_coins($param){
			try {
				$param = array(
						'openID'=>'1111',
						'openKey'=>'2222',
						'payToken'=>'33333',
						'pf'=>'44444',
						'pfKey'=>'55555',
						'accountType'=>'66666',
						'gameCoins'=>'7777'
				);
				$qqp = new \inner_service\PayGameCoinsParam ($param);
				$this->client->pay_game_coins($qqp);
				echo "pay_game_coins...<br/>";
			} catch (TException $tx) {
				print 'TException: '.$tx->getMessage()."\n";
			}
		}
		
		public function cancel_pay($param){
			try {
				$param = array(
						'openID'=>'1111',
						'openKey'=>'2222',
						'payToken'=>'33333',
						'pf'=>'44444',
						'pfKey'=>'55555',
						'accountType'=>'66666',
						'gameCoins'=>'7777',
						'billno'=>'8888'
				);
				$qqp = new \inner_service\CancelPayParam ($param);
				$this->client->cancel_pay($qqp);
				echo "cancel_pay...<br/>";
			} catch (TException $tx) {
				print 'TException: '.$tx->getMessage()."\n";
			}
		}
		public function __destruct() {
// 			echo "BBB<br/>";
			$this->transport->close();
		}
	}
?>