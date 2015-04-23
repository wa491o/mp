/**
 * 按钮切换
 */

var Button = {};

/**
 * 按钮、分割线等变换方法
 * @param obj 按钮 DIV
 * @param action 动作 "over"、"out"
 */
Button.imgChange = function(obj, action){
	if(action=="over"){
		if(obj.className.indexOf("bt_49_33_upload")!=-1){
			jQuery(obj).css("background-position","-185px -559px");
		}
	}else{
		if(obj.className.indexOf("bt_49_33_upload")!=-1){
			jQuery(obj).css("background-position","-4px -559px");
		}
	}
};