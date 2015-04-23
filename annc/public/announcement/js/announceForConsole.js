var Announcement=Announcement || {};
Announcement={
	getValue:function(obj,key){return obj[key]},
	subsourceStatus:{"ONLINE":0,"OFFLINE":2,"DELETE":1},
	announcementStatus:{"ONLINE":0,"DELETE":1},
	requestUrl:{},
	nowPageNo:1 //当前页码，翻页保持使用
};
/**
 * 新闻首页
 */
Announcement.indexPage=function() {
	 var manageDialog=$("#sourceDialog"),
	 manageBtn=$(".manageSour_btn"),
	 syncBtn=$(".sync_btn"),
	 editDialog=$("#editSourceDialog"),
	 editBtn=$(".addSource_btn"),
	 clickSaveSource=$(".saveSource_btn"),
	 clickCancel=$(".cancelSource_btn"),
	 soureItems=$(".sourceList .sourceItem"),
	 /**
	  * 上下架操作
	  * @param {Object} id
	  * @param {Object} d
	  */
	doChageState=function(id,d,a){
		if(d==Announcement.subsourceStatus.ONLINE)
			d=Announcement.subsourceStatus.OFFLINE;
		else
			d=Announcement.subsourceStatus.ONLINE;
		$.ajax({
			url:Announcement.requestUrl.changeSourceState,
			type:'post',
			data:{id:id,status:d},
			success:function(data){e(data,id,d,a)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	/**
	 * 上下架请求后的操作
	 * @param {Object} data
	 * @param {Object} id
	 * @param {Object} d
	 */
	e=function(data,id,d,a){
		a.unbind();
		if(d==Announcement.subsourceStatus.ONLINE){
			a.html("下架");
			a.attr("status",Announcement.subsourceStatus.ONLINE);
			a.click(function(){
				doChageState(id,Announcement.subsourceStatus.ONLINE,a);
			});
		}else{
			a.html("上架");
			a.attr("status",Announcement.subsourceStatus.OFFLINE);
			a.click(function(){
				doChageState(id,Announcement.subsourceStatus.OFFLINE,a);
			});
		}
		
	},
	/**
	 * 打开管理订阅源对话框
	 */
	openManageDialog=function(){
		manageDialog.dialog({
		    title: '管理订阅源',
		    width: 500,
		    closed: true,
		    cache: false,
		    modal: true,
			onClose:closeManageDialog
		});
		getAllSoure();
		manageDialog.show();
		manageDialog.dialog('open');
		var selection=$("#sourceTemplate");
		getAllTemplate(selection);
	},
	closeManageDialog=function(){
		manageDialog.hide();
		getAllOnlineSource();
	},
	/**
	 * 立即抓取通知公告
	 */
	syncAnnc=function(){
		$.ajax({
			url : Announcement.requestUrl.syncAnnouncement,
			type : 'post',
			data : {
			},
			success : function(data) {
			},
			error : function(XMLHttpRequest) {
			},
			complete:Public.sessionOut
		});
		jQuery.messager.alert('提示', '通知公告抓取任务已经启动', 'info');
	},
	/**
	 * 打开添加或编辑订阅源对话框
	 * @param {Object} addoredit
	 */
	openEditDialog=function(addoredit,id){
		var selection=$("#sourceTemplate");
		var name=$("#sourceName");
		$("#defaultSource").removeAttr("checked");
		editDialog.dialog({
		    title: addoredit=='add'?'添加订阅源':'编辑订阅源',
		    width: 500,
		    closed: true,
		    cache: false,
		    modal: true,
			onclose:function(){editDialog.hide()}
		});
		editDialog.show();
		editDialog.dialog('open');
		name.val('');
		if(addoredit!='add'){
			getSourceInfo(id,name,selection);
		}else{
			getAllRoles();
		}
		clickSaveSource.unbind();
		clickSaveSource.click(function(){saveSource(id,name.val(),selection.val())});
	},
	/**
	 * 获取所有的模版
	 * @param {Object} a
	 */
	getAllTemplate=function(a){
		$.ajax({
			url:Announcement.requestUrl.getTemplates,
			type:'post',
			data:{},
			success:function(data){templateOperate(data,a)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	templateOperate=function(data,a){
		var str="";
		for(var i=0;i<data.length;i++){
			var s=data[i];
			str+='<option value="'+s.id+'" >'+s.name+'</option>';
		}
		a.empty().append(str);
	},
	/**
	 * 获取订阅原信息
	 * @param {Object} id
	 * @param {Object} a
	 * @param {Object} b
	 */
	getSourceInfo=function(id,a,b){
		$.ajax({
			url:Announcement.requestUrl.editSubscribeSource,
			type:'post',
			data:{id:id},
			success:function(data){initSourceInfo(data,a,b)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	initSourceInfo=function(data,a,b){
		a.val(data.name);
		if(data.pTemplate){
			b.val(data.pTemplate.id);
		}
		if(data.defaultFlag==1){
			$("#defaultSource").click();
		}else{
			$("#defaultSource").removeAttr("checked");
		}
		getAllRoles(data.roles);
	},
	/**
	 * 
	 */
	closeEidtDialog=function(){
		editDialog.hide();
		editDialog.dialog('close');
	},
	/**
	 * 获取所有订阅源
	 */
	getAllSoure=function(){
		$.ajax({
			url:Announcement.requestUrl.manageSoruce,
			type:'post',
			data:{},
			success:function(data){listoperate(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	listoperate=function(data){
		var sourList=$("#sourceManage_body"), str;
		sourList.empty();
		for(var i=0;i<data.length;i++){
			(function(_i){
				var item=data[_i];
				var id=item.id,status=Announcement.getValue(Announcement.subsourceStatus,item.subscribeSourceStatus);
				str=appendSubSource(id,item.name,status);
				sourList.append(str);
				bindSoureOption(id,status,this);
			})(i);
		}
	},
	/**
	 * 获取上架的订阅源
	 */
	getAllOnlineSource=function(){
		$.ajax({
			url:Announcement.requestUrl.manageSoruce,
			type:'post',
			data:{type:Announcement.subsourceStatus.ONLINE},
			success:function(data){afterGetOnlineSource(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	afterGetOnlineSource=function(data){
		var str='<div class="sourceItem fl" sourceid="0" style="border-left:none;"><span>全部</span></div>',
		sourContainer=$("#subSourceContainer"),idSelected=$(".sourceItem_selected").attr('sourceid'),selected=false;
		for(var i=0;i<data.length;i++){
			(function(_i){
				var item=data[_i];
				if(idSelected==item.id){
					selected=true;
				}
				str+='<div class="sourceItem fl" sourceid="'+item.id+'"><span>'+item.name+'</span></div>';
			})(i);
		}
		sourContainer.empty().append(str);
		$(this).siblings().removeClass("sourceItem_selected");
		if(selected){
			sourContainer.find('div[sourceid="'+idSelected+'"]').addClass("sourceItem_selected");
		}else{
			sourContainer.find('div[sourceid="0"]').addClass("sourceItem_selected");
		}
		getAnnouncement($(".sourceItem_selected").attr('sourceid'));
		$(".sourceItem").hover(function(){
			$(this).addClass("sourceItem_hover");
		},function(){
			$(this).removeClass("sourceItem_hover");
		}).click(function(){
			$(this).siblings().removeClass("sourceItem_selected");
			$(this).addClass("sourceItem_selected");
			getAnnouncement($(this).attr("sourceid"));
		});
	},
	/**
	 * 获取所有角色
	 * @param {Object} ids
	 */
	getAllRoles=function(ids){
		$.ajax({
			url:Announcement.requestUrl.getAllRoles,
			type:'post',
			data:{},
			success:function(data){afterGetRoles(data,ids)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	afterGetRoles=function(data,ids){
		var roleList=$("#sourceManage_role"),str;
		roleList.empty();
		for(var i=0;i<data.length;i++){
			(function(_i){
				var item=data[_i];
				var id=item.id,name=item.name;
				str='<label><input type="checkbox" id="ck'+item.id+'" sourceid="'+item.id+'" name="'+item.code+'">'+item.name+'</label>';
				roleList.append(str);
			})(i);
		}
		for(var j in ids){
			$("#ck"+ids[j].id).attr("checked","checked");
		}
		var checkAll=$("#sourceManage_role input[name='everyone']");
		var checkSon=$("#sourceManage_role input[type='checkbox'][name!='everyone']");
		checkAll.click(function(){
			var checkstate=$(this)[0].checked;
			if($(this)[0].checked){
				checkSon.each(function(){
					if(!$(this)[0].checked){
						$(this).click();
					}
					$(this)[0].checked=true;
				});
			}else{
				checkSon.each(function(){
					if($(this)[0].checked){
						$(this).click();
					}
					$(this)[0].checked=false;
				});
			}
		});
		checkSon.click(function(){
			if ($(this)[0].checked) {
			 	checkAll[0].checked=true;
				checkSon.each(function(i){
					if(!$(this)[0].checked) {
				        checkAll[0].checked = false;
				        return false;
			        }
				});
			}else{
				checkAll[0].checked=false;
			}
			
		});
	},
	appendSubSource=function(id,name,status){
		var str='<tr>'+
//						'<td class="tit">'+name+'<a onclick="Announcement.goChange(\'down\','+id+')">&nbsp;&nbsp;↓&nbsp;&nbsp;</a><a onclick="Announcement.goChange(\'up\','+id+');">&nbsp;&nbsp;↑&nbsp;&nbsp</a>;'+' </td>'+
						'<td class="tit">'+name+'</td><td><img onclick="Announcement.goChange(\'down\','+id+')" src="/public/news/images/com_bt_arrowdown.png"/> <img onclick="Announcement.goChange(\'up\','+id+');" src="/public/news/images/com_bt_arrowup.png"/>'+' </td>'+
						'<td class="option"><a href="javascript:;" id="doUpdate'+id+'" class="bt_49_33_upload editSource_btn"  status="'+status+'">'+(status==Announcement.subsourceStatus.OFFLINE?"上架":"下架")+'</a>'+
						'<a href="javascript:;" class="bt_49_33_upload editSource_btn" id="doEdit'+id+'">编辑</a>'+
						'<a href="javascript:;" class="bt_49_33_upload editSource_btn" id="doDel'+id+'">删除</a></td>'+
					'</tr>';
		return str;
	},
	bindSoureOption=function(id,status,obj){
		var itemObj=$("#doUpdate"+id),eidtItem=$("#doEdit"+id),delItem=$("#doDel"+id);
		itemObj.click(function(){
			doChageState("" + id,status,itemObj);
		});
		eidtItem.click(function(){openEditDialog("edit",""+id)});
		delItem.click(function(){delSourceItem(""+id,delItem)});
	},
	/**
	 * 删除订阅源
	 * @param {Object} id
	 * @param {Object} obj
	 */
	delSourceItem=function(id,obj){
		$.messager.confirm('确认','确认删除该订阅源?',function(r){
		    if (r){
		        $.ajax({
					url:Announcement.requestUrl.deleteSubscribeSource,
					type:'post',
					data:{id:id},
					success:function(data){afterDel(data,obj)},
					error: function(XMLHttpRequest) {},
					complete:Public.sessionOut
				});
		    }
		});	
	},
	afterDel=function(data,obj){
		$(obj).parent().parent().remove();
	},
	/**
	 * 保存订阅源
	 * @param {Object} id
	 * @param {Object} name
	 * @param {Object} idTemplate
	 */
	saveSource=function(id,name,idTemplate){
		var roleids=[],roleObj=$("#sourceManage_role input[type='checkbox']:checked");
		for(var i=0;i<roleObj.length;i++){
			(function(_i){
				var obj=$(roleObj[_i]);
				roleids.push(obj.attr("sourceid"));
			})(i);
		}
		if(!name){
			$.messager.alert("提示","请填写订阅源名称！","info");
			return;
		}else if(name.length>5){
			$.messager.alert("提示","订阅源名称不超过5个字！","info");
			return;
		}
		var defaultFlag=0;
		if($("#defaultSource").is(":checked")){
			defaultFlag=1;
		}
		$.ajax({
			url:Announcement.requestUrl.saveSubscribeSource,
			type:'post',
			data:{id:id,name:name,idTemplate:idTemplate,ids:roleids,defaultFlag:defaultFlag},
			success:function(data){afterSave(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
		
	},
	afterSave=function(data){
		if(data.errMsg && data.errMsg!=""){
			$.messager.alert("错误","订阅源名称不能重复","error");
		}else{
			getAllSoure();
			closeEidtDialog();
		}
	},
	/**
	 * 获取公告列表
	 * @param {Object} idSubSource
	 */
	getAnnouncement=function(idSubSource){
		var contentFormat = function(value, row, index){
			row.status=Announcement.getValue(Announcement.announcementStatus,row.status);
			var content=removeHtml(row.detailInfo.content).substring(0,120)+"...",summary=row.baseInfo.summary,status;
			content=summary==""?content:summary;
			status=row.status==Announcement.announcementStatus.ONLINE?"屏蔽":"取消屏蔽";
			var cont=//'<div class="check">'+
					//		'<input type="checkbox" name="all">'+
					//	'</div>'+
						'<div class="contBox">'+
						'	<p class="cont-tit">'+row.baseInfo.title+'<span>【'+row.detailInfo.subscribeSource.name+'】</span></p>'+
						'	<p class="cont-detail mt10">'+content+'</p>'+
						'</div>'+
						'<div class="optionBox fr">'+
						'	<a class="btn_list_option editNews_btn" href="'+Announcement.requestUrl.editAnnouncement+'?id='+row.id+'"><span>编辑</span></a>'+
						'	<a class="btn_list_option sheildingNews_btn" href="javascript:;" onclick="Announcement.indexPage.shielding(\''+row.id+'\','+row.status+')"id="pb'+row.id+'"><span>'+status+'</span></a>'+
						'	<a class="btn_list_option deleteNews_btn" href="javascript:;" onclick="Announcement.deleteAnnouncement(['+row.id+'])"><span>删除</span></a>'+
						'</div>';
			return cont;
		};
		var removeHtml=function(str){
			if (!str)
				return "";
			return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
		};
		
		$(".newsList").datagrid({
			width: 830,
			queryParams: {idSubSource:idSubSource},
			url: Announcement.requestUrl.getAnnouncement,
			nowrap: false,
			striped: true,
			collapsible:true,	
			fitColumns: false, //是否列自动适应内容宽度
			remoteSort: false,
			pagination:true,
			singleSelect:false,
			pageList:[15],
			pageSize:15,
			pageNumber:Announcement.nowPageNo,
			columns:[[
				{field:'cb',width:30,checkbox:true},
				{field:'item',title:"",width:780,sortable:false,formatter:contentFormat}
			]],
			onLoadSuccess:function(data){
				if(typeof(data.page) != "undefined"){
					Announcement.nowPageNo = data.page; // 当前页码
				}
				jQuery('.newsList').datagrid('clearSelections');
			},
			onLoadError:Public.sessionOut
		});
	},
	/**
	 * 屏蔽公告
	 * @param {Object} id
	 * @param {Object} status
	 */
	shielding=function(id,status){
		var ids=[];//ID数组
		if(!id){
			var rows=jQuery('.newsList').datagrid('getSelections');
			for(var i=0;i<rows.length;i++){
				if(rows[i].status!=Announcement.announcementStatus.DELETE){
					ids.push(rows[i].id);
				}
			}
			if((ids=="" || ids==null)&& rows.length<=0){
				jQuery.messager.alert('提示','请选择公告！','info');
				return;
			}
		}else{
			if(status==Announcement.announcementStatus.DELETE){
				status=Announcement.announcementStatus.ONLINE;
			}else{
				status=Announcement.announcementStatus.DELETE;
			}
		}
		$.ajax({
			url:Announcement.requestUrl.shieldingAnnouncement,
			type:'post',
			data:{ids:ids,status:status,id:id},
			success:function(data){afterShielding(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	afterShielding=function(data){
		jQuery('.newsList').datagrid('reload');
		jQuery('.newsList').datagrid('clearSelections');
	},
	initHeader=function(){
		soureItems.hover(function(){
				$(this).addClass("sourceItem_hover");
			},function(){
				$(this).removeClass("sourceItem_hover");
			}).click(function(){
				$(this).siblings().removeClass("sourceItem_selected");
				$(this).addClass("sourceItem_selected");
				getAnnouncement($(this).attr("sourceid"));
			});
	};
	return {
		init:function(){
			getAnnouncement();
			manageBtn.click(openManageDialog);
			syncBtn.click(syncAnnc);
			clickCancel.click(closeEidtDialog);
			editBtn.click(function(){openEditDialog('add',"")});
			initHeader();
			$(".sheldingAll_btn").click(function(){
				shielding();
			});
			$(".deleteAll_btn").click(function(){
				Announcement.deleteAnnouncement();
			});
		},
		shielding:function(id,status){
			shielding(id,status);
		},
		getAnnouncement:function(idSubSource){
			getAnnouncement(idSubSource);
		},
		getNewsType: function(){
			getAllSoure();
		}
	}
} ();
/**
 * 发布公告
 */
Announcement.editPage=function(){
	var clickPulishNews=$(".confirm_btn"),
	clickBack=$(".back_btn"),
	attachList=[],
	delImgIds=[],
	removeHtml=function(str){
		return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
	};
	uploadAttachment=function(obj){
		if($("#attachContainer .attach-item").length>=5){
			$.messager.alert('提示','公告附件不能超过5个！','info');
			return;
		}
		if(!validatorFile(obj)){
			$.messager.alert('提示','上传的文件不符合格式要求！','info');
			return;
		}
		$('#annc_attachMent').form('submit', {
			url:Announcement.requestUrl.uploadPath,
			success:function(data){
				data=removeHtml(data);
				var dataObj = eval("("+data+")");
				if(typeof(dataObj.ret) != "undefined" && dataObj.ret == "403"){
					$.messager.alert('提示',dataObj.msg,'error');
					return;
				}
				var str="";
				var suffix=/\.[^\.]+/.exec(dataObj.name);
				var name=dataObj.name.split(".")[0].length>12?dataObj.name.split(".")[0].substring(0,10)+"..."+suffix:dataObj.name.split(".")[0]+suffix;
				str='<div class="attach-item" imgid="'+dataObj.id+'"><span title="'+dataObj.name+'">'+name+'</span><a onclick="Announcement.editPage.delImg(this)" href="javascript:;" title="删除附件">×</a></div>';
				$("#attachContainer").append(str);
			},
			failure:function(){}
		});
		$(obj).val("");
	},
	saveAnnouncement=function(){
		var title=$.trim($("#news_title").val()),
		idSubSource=$("#news_subSource").val(),
		summary=$.trim($("#news_summary").val()),
		content=Announcement.editor.html(),
		from=$.trim($("#news_from").val()),
		author=$.trim($("#news_author").val()),
		idAnnouncement=$("#idAnnouncement").val();
		if(!title){
			$.messager.alert("提示","请填写公告标题！","info");
			return;	
		}else if(title.length>50){
			$.messager.alert("提示","公告标题长度不超过50字！","info");
			return;	
		}
		if(from != "" && from.length>200){
			$.messager.alert("提示","公告来源长度不超过100字！","info");
			return;
		}
		if(author != "" && author.length>30){
			$.messager.alert("提示","作者长度不超过30字！","info");
			return;
		}
		if(!idSubSource){
			$.messager.alert("提示","请选择订阅源！","info");
			return;	
		}
		if(summary && summary.length>60){
			$.messager.alert("提示","公告摘要字数不超过60字！","info");
			return;	
		}
		if(content && content.length>10000){
			$.messager.alert("提示","公告正文字数不超过10000字！","info");
			return;
		}else if(!content){
			$.messager.alert("提示","请填写公告内容！","info");
			return;	
		}
		$("#attachContainer .attach-item").each(function(){
			attachList.push($(this).attr("imgid"));
		});
		var defaultPush=0;
		if($("#defaultPush").is(":checked")){
			defaultPush=1;
		};
		clickPulishNews.unbind();
		$.ajax({
			url:Announcement.requestUrl.saveAnnouncement,
			type:'post',
			data:{idAnnouncement:idAnnouncement,title:title,idSubSource:idSubSource,
			summary:summary,content:content,from:from,author:author,attachList:attachList,defaultPush:defaultPush},//,delImgIds:delImgIds
			success:function(data){afterSaveAnnouncement(data)},
			error: function(XMLHttpRequest) {
				clickPulishNews.click(function(){saveAnnouncement()});
			},
			complete:Public.sessionOut
		});
	},
	afterSaveAnnouncement=function(data){
		if (data.msg && data.msg != "") {
			$.messager.alert("错误",data.msg,"error");
    		clickPulishNews.unbind().click(function(){saveAnnouncement()});
		}else{
			location.href=Announcement.requestUrl.announcementManage;
		}
	},
	validatorFile=function(inputObj){
		var imgInputValue = inputObj.value;
		return imgInputValue.trim().match(/^.*?\.(jpg|jpeg|bmp|gif|png|doc|docx|xls|xlsx|ppt|pptx|rar|zip|pdf|txt)$/i)==null?false:true;
	},
	splitAttachname=function(name){
		var suffix=/\.[^\.]+/.exec(name);
		return name.split(".")[0].length>12?name.split(".")[0].substring(0,10)+"..."+suffix:name.split(".")[0]+suffix;
	};
	return {
		init:function(){
			clickPulishNews.unbind().click(function(){saveAnnouncement()});
			clickBack.click(function(){
				$.messager.confirm('确认','是否要放弃当前编辑?',function(r){
				    if (r){
						window.history.go(-1);
				    }
				});	
			});
			$(".attach-item").each(function(){
				var obj=$(this).find("span")[0];
				$(obj).html(splitAttachname(obj.innerHTML));
			});
		},
		uploadAttachment:function(obj){
			uploadAttachment(obj);
		},
		delImg:function(obj){
			//delImgIds.push($(obj).parent().attr("imgid"));
			$(obj).parent().remove();
		}
	}
}();

Announcement.editCrawlTemplate=function(title,id,directory,name,urlList,domainKey,domainName){
	if(typeof(id) != "undefined"){
		$('#idInput').val(id);
		$('#directoryInput').val(directory);
		$('#nameInput').val(name);
		$('#urlListInput').val(urlList);
		$('#domainInput').val(domainKey);
	}else{
		$('#idInput').val("");
		$('#directoryInput').val("");
		$('#nameInput').val("");
		$('#urlListInput').val("");
		$('#domainInput').val('');
	}
	$('#createDiv').css('display','');
	$('#createDiv').dialog({
		modal: true,
		title: title,
		width:400,
		height:400,
		closable:true,
		resizable:false,
		shadow: true,
		onClose: function(){
			$('#createDiv').css('display','none');
		}
    });
};

/**
 * 保存源
 */
Announcement.saveCrawlTemplate=function(){
	var id = $('#idInput').val();
	var directory =  $.trim($('#directoryInput').val());
	var name = $.trim($('#nameInput').val());
	var urlList = $.trim($('#urlListInput').val());
	var domainKey = $('#domainInput').val();
	if(name=="" || directory=="" || urlList=="" || domainKey==""){
		$.messager.alert("提示","域、目录、名称、url不得为空！","info");
		return;	
	}
	
	$.ajax({
		url:Announcement.requestUrl.saveTemplate,
		type:'post',
		data:{id:id,directory:directory,name:name,urlList:urlList,domainKey:domainKey}, //,delImgIds:delImgIds
		success:function(data){
//			$.messager.alert("提示","保存成功","info");
			window.location.reload();
		},
		error: function(data) {
			$.messager.alert("提示",data.msg,"info");
		},
		complete:Public.sessionOut
	});
};

/**
 * 删除源
 */
Announcement.deleteCrawlTemplate=function(id){
	$.ajax({
		url:Announcement.requestUrl.deleteTemplate,
		type:'post',
		data:{id:id}, //,delImgIds:delImgIds
		success:function(data){
//			$.messager.alert("提示","保存成功","info");
			if(data.state==1){
				window.location.reload();
			}else{
				$.messager.alert("提示",data.msg,"info");
			}
		},
		error: function(data) {
			$.messager.alert("提示",data.msg,"info");
		},
		complete:Public.sessionOut
	});
};

Announcement.cancelAddCrawlTemplate=function(){
	$('#createDiv').dialog('close');
	$('#createDiv').css('display','none');
};

/**
 * 通知公告删除.
 */
Announcement.deleteAnnouncement = function(ids){
	if( null == ids || typeof(ids) == "undefined" || ids.length == 0){
		var ids = [];
		var rows=jQuery('.newsList').datagrid('getSelections');
		for(var i=0;i<rows.length;i++){
			ids.push(rows[i].id);
		}
		if((ids=="" || ids==null) && rows.length<=0){
			jQuery.messager.alert('提示','请选择公告！','info');
			return false;
		}
	}
	if(!confirm("敬请谨慎操作，确认删除选择的公告吗？")) {
		return;
	}
	$.ajax({
		url:Announcement.requestUrl.deleteAnnouncements,
		type:'post',
		data:{ids:ids}, //,delImgIds:delImgIds
		success:function(data){
			if(data.state==1){
//				window.location.reload();
				Announcement.indexPage.getAnnouncement($(".sourceItem_selected").attr('sourceid'));
			}else{
				$.messager.alert("提示",data.msg,"info");
			}
		},
		error: function(data) {
			$.messager.alert("提示",data.msg,"info");
		},
		complete:Public.sessionOut
	});
};
Announcement.goChange=function(type,id){
	var chType=type;
	var id = id;
	$.ajax({
		url:Announcement.requestUrl.changerOrder,
		type:'post',
		data:{chType:chType,id:id}, 
		success:function(data){
			Announcement.indexPage.getNewsType();
		},
		error: function(data) {
			$.messager.alert("提示",data.msg,"info");
		},
		complete:Public.sessionOut
	});
};
