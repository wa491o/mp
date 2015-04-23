/**
 * 为String原型添加去除字符两端空格的方法
 */
String.prototype.trim = function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
};

/**
 * 为Date原型添加日期格式化方法
 * 
 * @example date.format("yyyy-MM-dd hh:mm:ss")
 * @return String
 */
Date.prototype.format = function(format){
	var o = {
		"M+" : this.getMonth()+1, //month
		"d+" : this.getDate(),    //day
		"h+" : this.getHours(),   //hour
		"m+" : this.getMinutes(), //minute
		"s+" : this.getSeconds(), //second
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter
		"S" : this.getMilliseconds() //millisecond
	};
	if(/(y+)/.test(format)){
		 format=format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
	}
	for(var k in o){
		if(new RegExp("("+ k +")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
		}
	}
	return format;
};
/**
 * 公共处理函数
 */
var Public = {};

/**
 * 浮点数取到小数点后几位
 * @param {} src 需要取值的原数字
 * @param {} pos 取到小数点后几位
 * @return {} 数值 例：fomatFloat(3.15159267, 1)为保留1位小数，结果为3.2
 */
Public.fomatFloat=function(src,pos){     
     return Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);     
}

/**
 * 截取字符串.
 * @param {} str 字符串
 * @param {} length 截取长度
 * @param {} suffix 后缀
 */
Public.dealWithStr=function(str,length,suffix){
	var newStr=str;
	if(str.length>length){
		newStr=str.substring(0,length-1)+suffix;
	}
	return newStr
}

/**
 * 修正IE下document.getElementsByName无法获取DIV标签
 */
Public.getElementsByName = function(tag, name){
    var returns = document.getElementsByName(name);
    if(returns.length > 0) return returns;
     returns = new Array();
    var e = document.getElementsByTagName(tag);
    for(var i = 0; i < e.length; i++){
        if(e[i].getAttribute("name") == name){
             returns[returns.length] = e[i];
         }
     }
    return returns;
}

/**
 * 验证器
 * 
 */
var Validator = {};

/**
	 * 是否为正整数，包括0
	 * @param str 验证字串
	 * @param min 最少字串个数
	 * @param max 最多字串个数
	 * @return boolean
	 */
Validator.isNormalNumber=function(str,min,max){
	min = null == min ? 0 : min;
	if(null != max){
		return str.trim().match(eval("/^[0-9]{"+min+","+max+"}$/"))==null?false:true;
	}else{
		return str.trim().match(/^[0-9]*$/)==null?false:true;
	}
}

/**
 * 是否为正浮点数及正整数，不包括0
 * @param str 验证字符串
 * @return boolean 
 */
Validator.isDoubleNumber= function(str){
	return str.trim().match(/^[1-9]\d*\.\d*|^[0-9]*$|0\.\d*[1-9]\d*$/)==null?false:true;
}

/**判断是否为图片
 * 
 * @param {} inputObj
 * 				对象
 * @return {Boolean}
 */
	
Validator.isPicture=function(inputObj){
	var imgInputValue = inputObj.value;
	return imgInputValue.trim().match(/^.*?\.(jpg|jpeg|bmp|gif|png)$/i)==null?false:true;
}

/**
 * 判断是否为指定的文件格式
 * @param {} inputObj
 * 					对象
 * @param {} suffix
 * 					后缀
 * @return {boolean}
 */
Validator.isFile=function(inputObj,suffix){
	var imgInputValue = inputObj.value;
	return imgInputValue.trim().match(eval("/^.*?\." + suffix + "$/i"))==null?false:true;
}

/**
 * 判断是否为指定类型的文件
 * @param {Object} inputObj
 * 					上传控件对象
 * @param {Object} fileType
 * 					1：图片类型（jpg|jpeg|bmp|gif|png）
 *					2：文本文件、文档类型（txt|doc|docx|xls|xlsx|ppt|pptx|pdf）
 *					3：压缩文件类型（rar|zip）
 *					9：特定的文件类型（由参数targetSuffix指定）
 * @param {Object} targetSuffix
 * 					文件类型后缀
 */
Validator.isYourFile=function(obj,fileType,targetSuffix){
	var value = obj.value;
	if(fileType==1){
		return Validator.isPicture(obj);
	}else if(fileType==2){
		return value.trim().match(/^.*?\.(txt|doc|docx|xls|xlsx|ppt|pptx|pdf)$/i)!=null;
	}else if(fileType==3){
		return value.trim().match(/^.*?\.(rar|zip)$/i)!=null;
	}else if(fileType==9){
		return value.trim().match(eval("/^.*?\."+targetSuffix+"$/i"))!=null;
	}
}
/**
 * 判断版本名称是否为合法
 * @param {} obj
 * 					对象
 * @return {boolean}
 */
Validator.isVersion=function(str){
	return str.trim().match(/^([1-9][0-9]?).([0-9]).([0-9])$/)==null?false:true;
}

/**
 * 检查邮箱是否为合法
 * @param {} obj
 * 					对象
 * @return {boolean}
 */
Validator.isEmail=function(str){
	return str.trim().match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)==null?false:true;
}

/**
 * 检查经度是否合法
 * @param {} str
 * 				字符串
 * @return {boolean}
 */
Validator.isLon=function(str){
	return str.trim().match(/^((\d|[1-9]\d|1[0-7]\d)(\.\d{1,6})?$)|(180$)/)==null?false:true;
}

/**
 * 检查纬度是否合法
 * @param {} str
 * 				字符串
 * @return {boolean}
 */
Validator.isLat=function(str){
	return str.trim().match(/^((\d|[1-8]\d)(\.\d{1,6})?$)|(90$)/)==null?false:true;
}

/**
 * 检查包括移动和固定电话是否合法
 * @param {} str
 * 				字符串
 * @return {boolean}
 */
Validator.isTel=function(str){
	return str.trim().match(/^(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/)==null?false:true;
};
/**
 *验证URL地址 
 */
Validator.isRightUrl=function(url){
  return url.trim().match(/(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/)!=null;
};
///**
// * 检查包括手机是否合法
// * @param {} str
// * 				字符串
// * @return {boolean}
// */
//Validator.isMobile=function(str){
//	return str.trim().match(/^((\d|[1-8]\d)(\.\d{1,6})?$)|(90$)/)==null?false:true;
//}

//去掉所有的html标记
Public.removeHtml=function(str){
	return str.replace(/<[^>]+>/g,"");
};

/**
 * 格式化时间
 * @param {} timestamp 时间戳
 * @return {String}
 */
Public.timestampFormater=function(timestamp){
	if(timestamp==null || timestamp==''){
		return '';
	}
	var myDate = new Date( timestamp );
	var dateStr = myDate.format("yyyy-MM-dd hh:mm");
	return dateStr;
}

/**
 * 格式化时间
 * @param {} timestamp 时间戳
 * @param {} format 格式，例：yyyy-MM-dd hh:mm或yyyy-MM-dd等
 * @return {String}
 */
Public.timestampFormaterNew=function(timestamp,format){
	if(timestamp==null || timestamp==''){
		return '';
	}
	var myDate = new Date( timestamp );
	var dateStr = myDate.format(format);
	return dateStr;
}

/**
 * session 失效检查
 * @param {Object} XMLHttpRequest
 * @param {Object} ts
 */
Public.sessionOut=function(XMLHttpRequest,ts){
	if(XMLHttpRequest.readyState==4){
		if(XMLHttpRequest.getResponseHeader("SCC-ISLOGIN")=='true'){
			$.messager.alert("提示","会话已经失效，请重新登录！","info",function(){
				location.href="/login";
			});
		}
	}
	
}
/**
 * 动态加载script文件
 * @param {Object} url
 * @param {Object} callback
 */
Public.loadScript=function (url, callback){
    var script = document.createElement("script")
    script.type = "text/javascript";
    if (script.readyState) { //IE
        script.onreadystatechange = function(){
            if (script.readyState == "loaded" ||
            script.readyState == "complete") {
                script.onreadystatechange = null;
                callback();
            }
        };
    }
    else { //Others
        script.onload = function(){
            callback();
        };
    }
    script.src = url;
    document.getElementsByTagName("head")[0].appendChild(script);
}
/**
 *	统一设置ajax请求检查session问题，不用再单独设置
 */
$(document).ajaxComplete(function( event, xhr, settings ) {
    Public.sessionOut(xhr);
});
/**
 * 
 * @param {Object} obj  dom对象
 * @param {Object} params 上传所需参数 例如{bizKey:'bizkey'}
 * @param {Object} callback 上传成功回调函数
 * @param {Object} fileType  文件类型，默认为 *.jpg;*.jpeg;*.gif;*.png
 * @param {Object} fileSizeLimit 限制大小 默认为3MB，其他单位为（B，KB，MB,GB）
 * @param {Object} uploadLimit 上传数量限制，默认为1
 */
Public.initUploadify=function(obj,params,callback,fileType,fileSizeLimit,uploadLimit){
    var fileTypeExts='*.jpg;*.jpeg;*.gif;*.png',limit="3MB",countLimit=1,isMulti=false;
    if(fileType){
        fileTypeExts=fileType;
    }
    if(fileSizeLimit){
    	limit=fileSizeLimit;
    }
    if(uploadLimit){
    	countLimit=uploadLimit;
    	if(countLimit>1){
    		isMulti=true;
    	}
    }    
    
    $(obj).uploadify({
    	//是否允许多选上传
        multi:isMulti,
        //上传数量限制
        queueSizeLimit:countLimit,
        //附带值
        formData:params,
        buttonClass:"lh33",
        buttonText:"上传",
        //flash
        swf: "/public/js/uploadify-3.2.1/uploadify.swf",
        //上传处理程序
        uploader:"/fs/api/upload",
        //浏览按钮的宽度
        width:'49',
        //浏览按钮的高度
        height:'33',
        //在浏览窗口底部的文件类型下拉菜单中显示的文本
        fileTypeDesc:'支持的格式：',
        //允许上传的文件后缀
        fileTypeExts:fileTypeExts,
        //上传文件的大小限制
        fileSizeLimit:limit,
        //返回一个错误，选择文件的时候触发
        onSelectError:function(file, errorCode, errorMsg){
        	var settings = this.settings;
            switch(errorCode) {
	            case -100:
	            	this.queueData.errorMsg="一次性最多选择"+settings.queueSizeLimit+"张图片上传！";
	                break;
                case -110:
                    alert("文件 ["+file.name+"] 大小超出系统限制的"+$('#file_upload').uploadify('settings','fileSizeLimit')+"大小！");
                    break;
                case -120:
                    alert("文件 ["+file.name+"] 大小异常！");
                    break;
                case -130:
                    alert("文件 ["+file.name+"] 类型不正确！");
                    break;
            }
        },
        onUploadError:function(file, errorCode, errorMsg) {
            switch(errorCode) {
                case -230:
                    alert("安全错误");
                    break;
            }
        },
        //检测FLASH失败调用
        onFallback:function(){
            alert("您未安装FLASH控件，无法上传图片！请安装FLASH控件后再试。");
        },
        //上传到服务器，服务器返回相应信息到data里
        onUploadSuccess:function(file, data, response){
            var data = eval("("+data+")");
            if(data && data.ret && !data.id){
                $.messager.alert("错误",data.msg,"error");
                return;
            }
            if(callback){
                callback(data);
            }
        }
    });
};

/**
 * 检验两个日期字串+时间的先后关系
 * 
 * 日期输入格式为字串yyyy-MM-dd HH:mm:ss
 * 当firstDate<lastDate 返回值为-1
 * 当firstDate=lastDate 返回值为0
 * 当firstDate>lastDate 返回值为1
 * @param firstDate 第一个日期
 * @param lastDate 第二个日期
 * @return boolean
 */
Public.compareDateTime=function(firstDate,lastDate){
	var d1 = new Date(firstDate.replace(/\-/g, "\/"));
    var d2 = new Date(lastDate.replace(/\-/g, "\/"));
    if (d1.getTime() > d2.getTime()) {            
        return 1;
    }else if(d1.getTime() == d2.getTime()){
		return 0;
	}else{
		return -1;
	} 			  
};
