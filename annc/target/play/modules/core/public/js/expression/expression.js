//表情插件
var Expression2={};
(function($){  
	$.fn.expression = function(options){		
		var defaults = {
			id : 'facebox',
			path : '',
			assign : 'content',
			top:0,
			left:0,
			wordNum:100,
			divId:'actCommentSize',
			imgShowId:'imgShowDiv'
		};
		var option = $.extend(defaults, options);
		var assign = $('#'+option.assign);
		var id = option.id;
		var path = option.path;
		var top=option.top;
		var left=option.left;
		var wordNum=option.wordNum;
		var divId=option.divId;
		var imgShowId=option.imgShowId;
		$(this).click(function(e){
			if($('#'+id).css('display')=='block'){
				$('#'+id).hide();
				$('#'+id).remove();
				return;
			}
			if($("#"+imgShowId).css("display") != "none"){
				$("#"+imgShowId).css("display", "none");
			}
			var strFace, labFace;
			if($('#'+id).length<=0){
				strFace = '<div id="'+id+'" style="position:absolute;display:none;z-index:100000;" class="emotion">' +
							  '<table border="0" cellspacing="0" cellpadding="0"><tr>';
				for(var i=0; i<Expression2.data.length; i++){
					labFace = Expression2.data[i].code.replace("[","").replace("]","");
					strFace+='<td>';
					strFace += '<img title="'+labFace+'" src="'+path+Expression2.data[i].path+'" onclick="$(\'#'+option.assign+'\').setCaret();$(\'#'+option.assign+'\').insertAtCaret(\'[' + labFace + ']\','+wordNum+');$(\'#'+option.assign+'\').countNum(\''+option.divId+'\','+wordNum+');" />';
					strFace+='</td>';
					if(i!=0&& i % 14 == 13 ) strFace += '</tr><tr>';
				}
				strFace += '</tr></table><div style="position:absolute;top:-13px;left:11px;height: 13px;width: 28px;"><img src="'+path+'/com_arrow_expression.png"/></div>';
	 			//strFace+='<div style="position:absolute;top:0px;left:11px;height: 1px;width: 29px;background-color: #ffffff;"></div></div>';
			}
			$('body').append(strFace);
			var offsetTop = $("#"+option.assign).offset().top;
			var offsetLeft = $("#"+option.assign).offset().left;
			$('#'+id).css('top',offsetTop+top);
			$('#'+id).css('left',offsetLeft+left);
			$('#'+id).show();
			e.stopPropagation();
		});

		$(document).click(function(){
			$('#'+id).hide();
			$('#'+id).remove();	
			
		});
	};

})(jQuery);
jQuery.extend({ 
unselectContents: function(){ 
	if(window.getSelection) 
		window.getSelection().removeAllRanges(); 
	else if(document.selection) 
		document.selection.empty(); 
	} 
}); 
jQuery.fn.extend({ 
	selectContents: function(){ 
		$(this).each(function(i){ 
			var node = this; 
			var selection, range, doc, win; 
			if ((doc = node.ownerDocument) && (win = doc.defaultView) && typeof win.getSelection != 'undefined' && typeof doc.createRange != 'undefined' && (selection = window.getSelection()) && typeof selection.removeAllRanges != 'undefined'){ 
				range = doc.createRange(); 
				range.selectNode(node); 
				if(i == 0){ 
					selection.removeAllRanges(); 
				} 
				selection.addRange(range); 
			} else if (document.body && typeof document.body.createTextRange != 'undefined' && (range = document.body.createTextRange())){ 
				range.moveToElementText(node); 
				range.select(); 
			} 
		}); 
	}, 

	setCaret: function(){ 
		if(!/msie/.test(navigator.userAgent.toLowerCase())){
			return;
		}
//		if(!$.browser.msie) return; //jquery 1.9不再支持此方式
		var initSetCaret = function(){ 
			var textObj = $(this).get(0); 
			textObj.caretPos = document.selection.createRange().duplicate(); 
		}; 
		$(this).click(initSetCaret).select(initSetCaret).mouseup(initSetCaret).keyup(initSetCaret); 
	}, 

	insertAtCaret: function(textFeildValue,maxlimit){ 
		var textObj = $(this).get(0); 
		if(textObj.value.length>=maxlimit)
			return;
		var IE = window.ActiveXObject;
		if(document.all && textObj.createTextRange && textObj.caretPos){
			var caretPos=textObj.caretPos; 
			caretPos.text = caretPos.text.charAt(caretPos.text.length-1) == '' ? 
			textFeildValue+'' : textFeildValue; 
		} else if(!IE){ 
			var rangeStart=textObj.selectionStart; 
			var rangeEnd=textObj.selectionEnd; 
			var tempStr1=textObj.value.substring(0,rangeStart); 
			var tempStr2=textObj.value.substring(rangeEnd); 
			textObj.value=tempStr1+textFeildValue+tempStr2; 
			textObj.focus(); 
			var len=textFeildValue.length; 
			textObj.setSelectionRange(rangeStart+len,rangeStart+len); 
			//textObj.blur(); 
		}else{ 
			textObj.value+=textFeildValue; 
		} 
	} 
	,
	countNum:function(divId,maxlimit){
		if(divId==''){
			return;
		}
		if(divId=='wordNum'){
			$('#fastPostDiv_wordsCount').css('display','block');
		}
		var textObj = $(this).get(0); 
		var charcnt = textObj.value.length;
		if (charcnt > maxlimit) {
			textObj.value = textObj.value.substring(0, maxlimit);
		}
		document.getElementById(divId).innerHTML=maxlimit-charcnt<0?0:maxlimit-charcnt;
	}
});

/**
 * 表情定义
 */
Expression2.data = 
[
	{
		path: "expression_smile.png",
		code: "[微笑]"
	},
	{
		path: "expression_laugh.png",
		code: "[哈哈大笑]"
	},
	{
		path: "expression_happy.png",
		code: "[开心]"
	},
	{
		path: "expression_crafty_smile.png",
		code: "[窃笑]"
	},
	{
		path: "expression_snicker.png",
		code: "[坏笑]"
	},
	{
		path: "expression_88.png",
		code: "[拜拜]"
	},
	{
		path: "expression_naughty.png",
		code: "[调皮]"
	},
	{
		path: "expression_stunned.png",
		code: "[发呆]"
	},
	{
		path: "expression_hush.png",
		code: "[嘘]"
	},
	{
		path: "expression_surprised.png",
		code: "[惊吓]"
	},
	{
		path: "expression_cool.png",
		code: "[酷]"
	},
	{
		path: "expression_angry.png",
		code: "[生气]"
	},
	{
		path: "expression_rage.png",
		code: "[发怒]"
	},
	{
		path: "expression_dizzy.png",
		code: "[晕]"
	},
	{
		path: "expression_shutup.png",
		code: "[闭嘴]"
	},
	{
		path: "expression_white_eyes.png",
		code: "[白眼]"
	},
	{
		path: "expression_shy.png",
		code: "[害羞]"
	},
	{
		path: "expression_khan.png",
		code: "[汗]"
	},
	{
		path: "expression_lol.png",
		code: "[囧]"
	},
	{
		path: "expression_ignore.png",
		code: "[无视]"
	},
	{
		path: "expression_speechless.png",
		code: "[无语]"
	},
	{
		path: "expression_kkhan.png",
		code: "[狂汗]"
	},
	{
		path: "expression_cry.png",
		code: "[哭]"
	},
	{
		path: "expression_shuai.png",
		code: "[衰]"
	},
	{
		path: "expression_despise.png",
		code: "[鄙视]"
	},
	{
		path: "expression_unhappy.png",
		code: "[不高兴]"
	},
	{
		path: "expression_wonderful.png",
		code: "[真棒]"
	},
	{
		path: "expression_money.png",
		code: "[钱]"
	},
	{
		path: "expression_doubt.png",
		code: "[疑问]"
	},
	{
		path: "expression_snaky.png",
		code: "[阴险]"
	},
	{
		path: "expression_vomit.png",
		code: "[吐]"
	},
	{
		path: "expression_grievance.png",
		code: "[委屈]"
	},
	{
		path: "expression_color.png",
		code: "[发色]"
	},
	{
		path: "expression_saliva.png",
		code: "[流口水]"
	},
	{
		path: "expression_kiss.png",
		code: "[飞吻]"
	},
	{
		path: "expression_fickle.png",
		code: "[花心]"
	},
	{
		path: "expression_sleep.png",
		code: "[睡觉]"
	},
	{
		path: "expression_snore.png",
		code: "[打呼噜]"
	},
	{
		path: "expression_yawn.png",
		code: "[打哈欠]"
	},
	{
		path: "expression_cute.png",
		code: "[可爱]"
	},
	{
		path: "expression_winkat.png",
		code: "[挤眼]"
	},
	{
		path: "expression_lovely.png",
		code: "[可怜]"
	},
	{
		path: "expression_sad.png",
		code: "[忧伤]"
	},
	{
		path: "expression_comfort.png",
		code: "[安慰]"
	},
	{
		path: "expression_love.png",
		code: "[爱心]"
	},
	{
		path: "expression_heart.png",
		code: "[心碎]"
	},
	{
		path: "expression_rose.png",
		code: "[玫瑰]"
	},
	{
		path: "expression_gift.png",
		code: "[礼物]"
	},
	{
		path: "expression_bulb.png",
		code: "[灯泡]"
	},
	{
		path: "expression_coffee.png",
		code: "[咖啡]"
	},
	{
		path: "expression_cake.png",
		code: "[蛋糕]"
	},
	{
		path: "expression_victory.png",
		code: "[胜利]"
	},
	{
		path: "expression_thumb.png",
		code: "[大拇指]"
	},
	{
		path: "expression_feeble.png",
		code: "[弱]"
	},
	{
		path: "expression_ok.png",
		code: "[OK]"
	},
	{
		path: "expression_v5.png",
		code: "[V5]"
	},
	{
		path: "expression_peak.png",
		code: "[顶]"
	},
	{
		path: "expression_cooperation.png",
		code: "[合作愉快]"
	},
	{
		path: "expression_fists.png",
		code: "[抱拳]"
	},
	{
		path: "expression_hi.png",
		code: "[哈喽]"
	},
	{
		path: "expression_grimace.png",
		code: "[扮鬼脸]"
	},
	{
		path: "expression_nose_picking.png",
		code: "[抠鼻]"
	},
	{
		path: "expression_sigh.png",
		code: "[叹气]"
	},
	{
		path: "expression_crazy.png",
		code: "[抓狂]"
	},
	{
		path: "expression_hit_you.png",
		code: "[砸你]"
	},
	{
		path: "expression_snort.png",
		code: "[哼]"
	},
	{
		path: "expression_handclap.png",
		code: "[鼓掌]"
	},
	{
		path: "expression_pig.png",
		code: "[猪头]"
	}
];
