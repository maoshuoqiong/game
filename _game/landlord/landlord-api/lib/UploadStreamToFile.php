<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2009 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
// $Id: UploadFile.class.php 2568 2012-01-10 12:15:45Z liu21st $
require_once 'Image.php';
/**
 +------------------------------------------------------------------------------
 * 文件上传类
 +------------------------------------------------------------------------------
 * @category   ORG
 * @package  ORG
 * @subpackage  Net
 * @author    liu21st <liu21st@gmail.com>
 * @version   $Id: UploadFile.class.php 2568 2012-01-10 12:15:45Z liu21st $
 +------------------------------------------------------------------------------
 */
class UploadFile {//类定义开始

    // 上传文件的最大值
    public $maxSize = -1;

	// 二进制流保持图片的后缀
    public $defExt = 'png';

    // 使用对上传图片进行缩略图处理
    public $thumb   =  false;
    // 缩略图最大宽度
    public $thumbMaxWidth;
    // 缩略图最大高度
    public $thumbMaxHeight;
    // 缩略图前缀
    public $thumbPrefix   =  'thumb_';
    public $thumbSuffix  =  '';
    // 缩略图保存路径
    public $thumbPath = '';
    // 缩略图文件名
    public $thumbFile		=	'';
    // 是否移除原图
    public $thumbRemoveOrigin = false;
    // 启用子目录保存文件
    public $autoSub   =  false;
    // 子目录创建方式 可以使用hash date
    public $subType   = 'hash';
    public $dateFormat = 'Ymd';
    public $hashLevel =  1; // hash的目录层次
    // 上传文件保存路径
    public $savePath = '';
    public $autoCheck = true; // 是否自动检查附件
    // 存在同名是否覆盖
    public $uploadReplace = false;

    // 上传文件命名规则
    // 例如可以是 time uniqid com_create_guid 等
    // 必须是一个无需任何参数的函数名 可以使用自定义函数
    public $saveRule = '';

    // 上传文件Hash规则函数名
    // 例如可以是 md5_file sha1_file 等
    public $hashType = 'md5_file';

    // 错误信息
    private $error = '';

    // 上传成功的文件信息
    private $uploadFileInfo ;

    /**
     +----------------------------------------------------------
     * 架构函数
     +----------------------------------------------------------
     * @access public
     +----------------------------------------------------------
     */
    public function __construct($maxSize='',$allowExts='',$allowTypes='',$savePath='',$saveRule='') {
        if(!empty($maxSize) && is_numeric($maxSize)) {
            $this->maxSize = $maxSize;
        }
        if(!empty($saveRule)) {
            $this->saveRule = $saveRule;
        }else{
            $this->saveRule	= "Upload_File_Rule";
        }
        $this->savePath = $savePath;
    }

    private function Upload_File_Rule(){
    	return time().rand(1, 10000);
    }
    /**
     +----------------------------------------------------------
     * 上传一个文件
     +----------------------------------------------------------
     * @access public
     +----------------------------------------------------------
     * @param mixed $name 数据
     * @param string $value  数据表名
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    private function save($file) {
        $filename = $file['savepath'].$file['savename'];
        if(!$this->uploadReplace && is_file($filename)) {
            // 不覆盖同名文件
            $this->error	=	'file has exist'.$filename;
            return false;
        }
        
        if($this->thumb) {
            $image =  getimagesize($filename);
            if(false !== $image) {
                //是图像文件生成缩略图
                $thumbWidth		=	explode(',',$this->thumbMaxWidth);
                $thumbHeight		=	explode(',',$this->thumbMaxHeight);
                $thumbPrefix		=	explode(',',$this->thumbPrefix);
                $thumbSuffix = explode(',',$this->thumbSuffix);
                $thumbFile			=	explode(',',$this->thumbFile);
                $thumbPath    =  $this->thumbPath?$this->thumbPath:$file['savepath'];
                // 生成图像缩略图
                $realFilename  =  $this->autoSub?basename($file['savename']):$file['savename'];
                for($i=0,$len=count($thumbWidth); $i<$len; $i++) {
                    $thumbname	=	$thumbPath.$thumbPrefix[$i].substr($realFilename,0,strrpos($realFilename, '.')).$thumbSuffix[$i].'.'.$this->defExt;
                    Image::thumb($filename,$thumbname,'',$thumbWidth[$i],$thumbHeight[$i],true);
                }
                if($this->thumbRemoveOrigin) {
                    // 生成缩略图之后删除原图
                    unlink($filename);
                }
            }
        }
        return true;
    }

    /**
     +----------------------------------------------------------
     * 上传所有文件
     +----------------------------------------------------------
     * @access public
     +----------------------------------------------------------
     * @param string $savePath  上传文件保存路径
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    public function upload($savePath ='') {
        //如果不指定保存文件名，则由系统默认
        if(empty($savePath))
            $savePath = $this->savePath;
        // 检查上传目录
        if(!is_dir($savePath)) {
            // 检查目录是否编码后的
            if(is_dir(base64_decode($savePath))) {
                $savePath	=	base64_decode($savePath);
            }else{
                // 尝试创建目录
                if(!mkdir($savePath)){
                    $this->error  =  'path '.$savePath.'no exist';
                    return false;
                }
            }
        }else {
            if(!is_writeable($savePath)) {
                $this->error  =  'path '.$savePath.'can not write';
                return false;
            }
        }
                
        //二进制数据流
        $data = file_get_contents ( 'php://input' ) ? file_get_contents ( 'php://input' ) : gzuncompress ( $GLOBALS ['HTTP_RAW_POST_DATA'] );

        $file['savepath']   = $savePath;
        $file['savename']   = $this->getSaveName($file);
        //数据流不为空，则进行保存操作
        if (! empty ( $data )) {
        	//创建并写入数据流，然后保存文件
        	if (@$fp = fopen ($file['savepath'].$file['savename'], 'w+' )) {
        		fwrite ( $fp, $data );
        		fclose ( $fp );
        	} else {
        		$this->error  =  'can not open save fill';
        		return false;
        	}
        } else {
        	//没有接收到数据流
        	$this->error  =  'not 2stream input';
        	return false;
        }
        //保存上传文件
        if(!$this->save($file)) return false;
        if(function_exists($this->hashType)) {
           $fun =  $this->hashType;
           $file['hash']   =  $fun($this->autoCharset($file['savepath'].$file['savename'],'utf-8','gbk'));
        }
        $this->uploadFileInfo = $file;           
        return true;
    }

    /**
     +----------------------------------------------------------
     * 获取错误代码信息
     +----------------------------------------------------------
     * @access public
     +----------------------------------------------------------
     * @param string $errorNo  错误号码
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    protected function error($errorNo) {
         switch($errorNo) {
            case 1:
                $this->error = 'over php upload_max_filesize';
                break;
            case 2:
                $this->error = 'over HTML MAX_FILE_SIZE';
                break;
            case 3:
                $this->error = 'part imag upload';
                break;
            case 4:
                $this->error = 'no imag upload';
                break;
            case 6:
                $this->error = 'canot find temp dir';
                break;
            case 7:
                $this->error = 'file write fail!';
                break;
            default:
                $this->error = 'unkown error';
        }
        return ;
    }

    /**
     +----------------------------------------------------------
     * 根据上传文件命名规则取得保存文件名
     +----------------------------------------------------------
     * @access private
     +----------------------------------------------------------
     * @param string $filename 数据
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
    private function getSaveName($filename) {
        $rule = $this->saveRule;
        if(empty($rule)) {//没有定义命名规则，则保持文件名不变
            $saveName = rand(1, 10000);
        }else {
            if(function_exists($rule)) {
                //使用函数生成一个唯一文件标识号
                $saveName = $rule().".".$this->defExt;
            }else {
                //使用给定的文件名作为标识号
                $saveName = $rule.".".$this->defExt;
            }
        }
        if($this->autoSub) {
            // 使用子目录保存文件
            $filename['savename'] = $saveName;
            $saveName = $this->getSubName($filename).'/'.$saveName;
        }
        return $saveName;
    }

    /**
     +----------------------------------------------------------
     * 获取子目录的名称
     +----------------------------------------------------------
     * @access private
     +----------------------------------------------------------
     * @param array $file  上传的文件信息
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
    private function getSubName($file) {
        switch($this->subType) {
            case 'date':
                $dir   =  date($this->dateFormat,time());
                break;
            case 'hash':
            default:
                $name = md5($file['savename']);
                $dir   =  '';
                for($i=0;$i<$this->hashLevel;$i++) {
                    $dir   .=  $name{$i}.'/';
                }
                break;
        }
        if(!is_dir($file['savepath'].$dir)) {
            $this->mk_dir($file['savepath'].$dir);
        }
        return $dir;
    }

    // 循环创建目录
    private function mk_dir($dir, $mode = 0777) {
    	if (is_dir($dir) || @mkdir($dir, $mode))
    		return true;
    	if (!$this->mk_dir(dirname($dir), $mode))
    		return false;
    	return @mkdir($dir, $mode);
    }

    // 自动转换字符集 支持数组转换
    private function autoCharset($fContents, $from='gbk', $to='utf-8') {
        $from = strtoupper($from) == 'UTF8' ? 'utf-8' : $from;
        $to = strtoupper($to) == 'UTF8' ? 'utf-8' : $to;
        if (strtoupper($from) === strtoupper($to) || empty($fContents) || (is_scalar($fContents) && !is_string($fContents))) {
            //如果编码相同或者非字符串标量则不转换
            return $fContents;
        }
        if (function_exists('mb_convert_encoding')) {
            return mb_convert_encoding($fContents, $to, $from);
        } elseif (function_exists('iconv')) {
            return iconv($from, $to, $fContents);
        } else {
            return $fContents;
        }
    }

    /**
     +----------------------------------------------------------
     * 取得上传文件的信息
     +----------------------------------------------------------
     * @access public
     +----------------------------------------------------------
     * @return array
     +----------------------------------------------------------
     */
    public function getUploadFileInfo() {
        return $this->uploadFileInfo;
    }

    /**
     +----------------------------------------------------------
     * 取得最后一次错误信息
     +----------------------------------------------------------
     * @access public
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
    public function getErrorMsg() {
        return $this->error;
    }

}