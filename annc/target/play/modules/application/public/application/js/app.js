var App={};
var idChecked=[];
App.Status={
	online:["ONLINE","OFFLINESUBMIT","OFFLINEREJECTED"],
	online_value:[3,6,7],
	offline:["SUBMIT","REJECTED","OFFLINE"],
	offline_value:[1,2,4],
}
App.AppSrc={
	store:"STORE",open:"OPEN"
}
//初始应用列表
App.initAppList = function(status){
	var title=$('#title').val();
	var catId=$('#category').val();
	if(catId=="all"){
		catId='';
	}
	var runType=$('#runType').val();
	if(runType=="all"){
		runType='';
	}
	var fromAdmin = $("#fromAdmin").val();
	
	var osType=$('#osType').val();
	if(osType=="all"){
		osType='';
	}
	var detailFormat=function(value,row,rowIndex){
		//图片
		var filePath='/fs/app-icon/'+row.icon;
		var star=["暂无评价","★","★★","★★★","★★★★","★★★★★"];
		var ratingAvg=Math.round(row.statInfo.ratingAvg/10);
		var cont='<div class="imgBox">'+
				 '	<img src="'+filePath+'" id="'+row.icon+'">'+
				 '</div>'+
				 '<div class="contBox">'+
				 '	<p class="cont-tit">'+row.name+'</p>'+
				  '	<p class="cont-detail mt10">'+App.dealFormatSize(row.detailInfo.size)+' | 版本号：'+row.detailInfo.version+' | 版本：'+row.detailInfo.versionCode+'</p>'+
				 '	<p class="cont-detail mt10">评价:'+star[ratingAvg]+'('+row.statInfo.ratingCount+')</p>'+
				 '</div>';
		return cont;
	}
	
	var optionFormat=function(value,rowData,rowIndex){
		if(rowData && rowData.appSrc && rowData.appSrc ===App.AppSrc.open){
			return '<a href="javascript:;" onclick="App.gotoEditAuthroity(\''+rowData.id+'\',\''+rowData.name+'\')" class="btn_list_option" ><span>应用授权</span></a>';
		}
		return '<a href="javascript:;" onclick="App.gotoEdit(\''+rowData.id+'\')" class="btn_list_option" ><span>管理应用</span></a>';
	}
	$('#appListGrid').datagrid({
		width:952,
		nowrap: false,
		striped: true,
		collapsible:false,	
		remoteSort: false,
		pagination:true,
		singleSelect:true,
		pageList:[10],
		queryParams:{title:title,catId:catId,runType:runType,osType:osType,status:status,fromAdmin:fromAdmin},
		url:'/app/getAppList' ,
		columns:[[
			{field:'detail',title:'应用介绍',width:350,align:'center',formatter:detailFormat},
			{field:'osType',title:'系统类型',width:80,align:'center',formatter:function(value,row,index){
				//纠正拼写错误
				if(value.toLowerCase() == "hybird"){
					return "Hybrid";
				}else{
					return value;
				}
			}},
			{field:'status',title:'当前状态',width:100,align:'center',formatter:function(value,row,index){
				var flag=false;
				for(var i in App.Status.online){
					if(value===App.Status.online[i]){
						flag=true;
						break;
					}
				}
				return flag?"已上架":"未上架";
			}},
			{field:'time',title:'时间',width:140,align:'center',formatter:function(value,row,index){
				return '<p>最新更新：'+new Date(row.timeInfo.updateTime).format("yyyy-MM-dd")+'</p><p>创建时间：'+new Date(row.timeInfo.createTime).format("yyyy-MM-dd")+'</p>';
			}},
			{field:'source',title:'来源',width:80,align:'center',formatter:function(value,row,index){
				if(row && row.appSrc){
					if(row.appSrc ===App.AppSrc.store){
						return "超市";
					}else if(row.appSrc ===App.AppSrc.open){
						return "开放平台";
					}
				}
				return "";
			}},
			{field:'userCount',title:'用户数',width:80,align:'center',formatter:function(value,row,index){
				return row.statInfo.userCount;
			}},
			{field:'action',title:'操作',width:100,align:'center',formatter:optionFormat}
		]],
		onLoadSuccess:function(data){
			if(data.total=='-1'){						                       
				jQuery.messager.alert('提示','当前会话已过期，请重新登录','info');
			}
			if(data.total=='0'){
				$('#appTableDiv').css('display','none');
				$('#noMore').css('display','block');
			}else{
				$('#appTableDiv').css('display','block');
				$('#noMore').css('display','none');
			}
		},
		onLoadError:Public.sessionOut
	});
}
App.init=function(){
	$("#app_tabs").delegate("li","click",function(){
		var status=$(this).attr("data-tab");
		status=App.Status[status];
		$(this).siblings().removeClass("tabTitle-selected");
		$(this).addClass("tabTitle-selected");
		App.initAppList(status);
	});
	$(".search").click(function(){
		var status=$(".tabTitle-selected").attr("data-tab");
		status=App.Status[status];
		App.initAppList(status);
	});
	$(".tabTitle-selected").click();
}
App.gotoScreenShot=function(idApp,nameApp){
	location.href="/app/screenShot?idApp="+idApp+"&nameApp="+nameApp;
}

//初始历史记录列表
App.backUpgradeList = function(){
	var versionCode = $("#versionCode").val();
	var idApp = $("#idApp").val();
	var detailFormat=function(value,row,rowIndex){
		//图片
		var filePath='/fs/app-icon/'+row.icon;
		var cont='<div class="imgBox">'+
				 '	<img src="'+filePath+'" id="'+row.icon+'">'+
				 '</div>'+
				 '<div class="contBox">'+
				 '	<p class="cont-tit">'+row.description+'</p>'+
				  '	<p class="cont-detail mt10">'+App.dealFormatSize(row.size)+' | 版本号：'+row.version+' | 版本：'+row.versionCode+'</p>'+
				 '</div>';
		return cont;
	}
	
	var optionFormat=function(value,rowData,rowIndex){
		var str="";
		if(rowData.versionCode!=versionCode){
			str+='<a href="javascript:;" onclick="App.backVersion(\''+rowData.id+'\')" class="btn_list_option" ><span>回退至该版本</span></a>';
		}
		return str;
	}
	$('#appListGrid').datagrid({
		width:952,
		nowrap: false,
		striped: true,
		collapsible:false,	
		remoteSort: false,
		pagination:true,
		singleSelect:true,
		pageList:[10],
		queryParams:{idApp:idApp},
		url:'/app/getAppDetailHistoryList' ,
		columns:[[
			{field:'detail',title:'应用介绍',width:770,align:'center',formatter:detailFormat},
			{field:'action',title:'操作',width:170,align:'center',formatter:optionFormat}
		]],
		onLoadSuccess:function(data){
			if(data.total=='-1'){						                       
				jQuery.messager.alert('提示','当前会话已过期，请重新登录','info');
			}
			if(data.total=='0'){
				$('#appTableDiv').css('display','none');
				$('#noMore').css('display','block');
			}else{
				$('#appTableDiv').css('display','block');
				$('#noMore').css('display','none');
			}
		},
		onLoadError:Public.sessionOut
	});	
}

//格式化应用大小
App.dealFormatSize=function(fileSize){
	var size='';
	if(fileSize>=(1024)){
		fileSize=fileSize/1024/1024;
		fileShowSize=Public.fomatFloat(fileSize, 2);
		size=fileShowSize+"M";
	}else{
		if(Public.fomatFloat(fileSize,0)==0){
			fileShowSize=Public.fomatFloat(fileSize,2);
		}else{
			fileShowSize=Public.fomatFloat(fileSize, 0);
		}
		size=fileShowSize+"K";
	}
	return size;
}

//上下架
App.updateFlag=function(idApp,status){
    var status=status;
	if(status=='ONLINE'){//原状态为上架
		if(!confirm("确定要下架该应用吗？")) {
			return;
		}
	}
	$.ajax({
		url : '/app/changeStatus',
		dataType: "json",
		type: "post",
		data: {idApp:idApp,status:status},
		success: function(state){
			if(state=="1"){
				if(status=="ONLINE"){//下架操作
					status='OFFLINE';
					$(".updateStatus").html("上架");
				}else{
					status='ONLINE';
					$(".updateStatus").html("下架");
				}
				$(".updateStatus").unbind().bind("click",function(){
					App.updateFlag(idApp,status);
				});
				$('#status').val(status);
			}else{
				$.messager.alert("错误","上下架出错",'error');   
			}
		},
		error: function(){
			jQuery.messager.alert('提示','服务器内部错误','error');
		},
		complete:Public.sessionOut
	});
}

//创建/编辑应用
App.gotoEdit=function(idApp){
	location.href= '/app/createNewApp?idApp='+idApp;
}
//创建/编辑应用
App.gotoUpgrade=function(idApp){
	location.href= '/app/upgradeApp?idApp='+idApp;
}
//版本回退页面
App.gotoBackVersion=function(idApp){
	location.href= '/app/backAppVersion?idApp='+idApp;
}

App.gotoEditAuthroity=function(idApp,nameApp){
	location.href= '/app/appAuthroity?idApp='+idApp+"&nameApp="+nameApp;
}
App.initScreenShotUpload=function(){
	$(".appScreen .screen-file").bind("change",function(){
		var form=$(this).parent().parent();
		var img=$(this).parent().find("img");
		var parent=$(this).parent();
		App.uploadScreenShot(form,this,img,parent);
	})
}
//如果是编辑页，则给相应的属性赋值
App.initData=function(){
	var idApp=$('#idApp').val();
	App.initScreenShotUpload();
	if(idApp==0){
		return;
	}
	$.ajax({
		url : '/app/getApp',
		dataType: "json",
		type: "post",
		data: {idApp:idApp},
		success: function(app){
			//应用名称
			$('#nameApp').val(app.name);
			//英文名称
			$('#nameAppEn').val(app.nameEn);
			//应用简介
			$('#descriptionApp').val(app.detailInfo.description);
			//操作系统
			var osType=document.getElementsByName('osRadio');
			for(var i=0;i<osType.length;i++){
				var obj=osType[i];
				if(app.osType==obj.value){
					obj.checked=true;
				}else{
					obj.disabled=true;
				}
			}
			//应用类型
			if(app.osType=='Android'){//安卓
				if(app.runType=='BUILD_IN'){
//					//应用上传
//					$('#fileUpload').css('display','none');
				}else if(app.runType=='THIRDPARTY'){
					$("#installUrl").removeAttr("disabled");
				}else{
					//应用上传
					$('#fileUpload').css('display','block');
					if(app.detailInfo.packFile != null){
						//文件名称
						$('#nameFile').html(app.detailInfo.packFile.name);
						//文件id
						$('#idFile').val(app.detailInfo.packFile.id);
					}
					
					var size=document.getElementById('size');
					size.disabled=true;
				}
				
			}else if(app.osType=='iOS'){//iOS
				var inter=document.getElementById('inter');
				var appstore=document.getElementById('appstore');
				var installUrl=document.getElementById('installUrl');
//				//应用上传
//				$('#fileUpload').css('display','none');
				if(app.runType=='BUILD_IN'){
				}else if(app.runType=='THIRDPARTY'){
					$("#installUrl").removeAttr("disabled");
				}else{
					//应用上传
					$('#fileUpload').css('display','block');
					if(app.detailInfo.packFile != null){
						//文件名称
						$('#nameFile').html(app.detailInfo.packFile.name);
						//文件id
						$('#idFile').val(app.detailInfo.packFile.id);
					}
					
					var size=document.getElementById('size');
					size.disabled=true;
				}
			}else if(app.osType=='Hybird'){
					//应用上传
					$('#fileUpload').css('display','block');
					if(app.detailInfo.packFile != null){
						//文件名称
						$('#nameFile').html(app.detailInfo.packFile.name);
						//文件id
						$('#idFile').val(app.detailInfo.packFile.id);
					}
					
					var size=document.getElementById('size');
					size.disabled=true;
					var codeApp = document.getElementById('codeApp');
					codeApp.disabled=true;
			}
			
			//运行方式
			var runType=document.getElementsByName('typeRadio');
			for(var i=0;i<runType.length;i++){
				var obj=runType[i];
				if(app.runType==obj.value){
					obj.checked=true;
				}else{
					obj.disabled=true;
				}
			}
			
			//应用地址
			$('#installUrl').val(app.installUrl);
			
			//罗列形式
			var listType=document.getElementsByName('listRadio');
			for(var i=0;i<listType.length;i++){
				var obj=listType[i];
				if(app.listType==obj.value){
					obj.checked=true;
				}
			}
			
			//应用图标
			var logoUrl='/fs/app-icon/'+app.icon;
			$('#logoAppImg').attr('src',logoUrl);
			$('#idLogo').val(app.icon);
			var open = app.openUrl;
			//打开地址
			$('#openUrl').val(open);
			//应用大小
			$('#size').val(App.dealFormatSize(app.detailInfo.size));
			//应用精确大小
			$('#accurateSize').val(app.detailInfo.size);
			//应用版本
			$('#version').val(app.detailInfo.version);
			$('#version').attr("disabled","disabled");
			//版本号
			$('#versionCode').val(app.detailInfo.versionCode);
			$('#versionCode').attr("disabled","disabled");
			//应用code
			$('#codeApp').val(app.code);
			//应用来源
			$("#appSrc").val(app.appSrc);
			//应用分类
			$('#category').val(app.detailInfo.category.id);
			//$('#category').attr("disabled","disabled");
			//应用状态
			$('#status').val(app.status);
			//应用角色
//			var roles=document.getElementsByName('roleCheckbox');
//			for(var i=0;i<roles.length;i++){
//				var obj=roles[i];
//				for(var j=0;j<app.roles.length;j++){
//					if(app.roles[j].id==obj.value){
//						obj.checked=true;
//						//obj.disabled = "disabled";
//					}
//				}
//			}
			var flag=false;
			for(var i in App.Status.online){
				if(app.status===App.Status.online[i]){
					flag=true;
					break;
				}
			}
			// 上下架操作，只有下架的应用才有删除
			if(flag){
				$(".updateStatus").html("下架");
				$(".deleteApp").css("display", "none");
			}else{
				$(".updateStatus").html("上架");
				$(".deleteApp").css("display", "");
			}
			$(".updateStatus").bind("click",function(){
				App.updateFlag(idApp,app.status);
			});
			$(".deleteApp").bind("click",function(){
				App.deleteAppWithId(idApp);
			});
			if(app.runType=='STANDALONE'){//APi授权
				$(".apiAuthroity").show();
				$(".apiAuthroity").bind("click",function(){
					App.gotoCredential(idApp);
				});
			}else{
				$(".apiAuthroity").hide();
			}
			if(app.runType != 'BUILD_IN'){
				$(".upgradeOption").show();
				$(".upgradeOption").bind("click",function(){
					App.gotoUpgrade(idApp);
				});
				$(".versionBack").show();
				$(".versionBack").bind("click",function(){
					App.gotoBackVersion(idApp);
				});
			}else{
				$(".upgradeOption").hide();
				$(".versionBack").hide();
			}
			if(idApp && idApp!="" && parseInt(idApp) !=0){
				$(".searchDiv").show();
			}
			var idScreens=app.detailInfo.screenShots;
			if(idScreens && idScreens.length>0){
				$(".appScreen").each(function(i){
					if(i>(idScreens.length-1)){
						return false;
					}
					var _this=$(this);
					var id=idScreens[i];
					var img=_this.find("img");
					img.attr("src",'/fs/app-screen/'+id);
					_this.attr("data-id",id);
					var delBtn=_this.find("div.screen-delete");
					delBtn.show();
					delBtn.unbind().bind("click",function(){
						App.delScreenShot(delBtn,img,_this);
					});
				});
			}
			$(".appAuthroity").bind("click",function(){
				App.gotoEditAuthroity(idApp,app.name);
			});
		},
		error: function(){
			jQuery.messager.alert('提示','服务器内部错误','error');
		},
		complete:Public.sessionOut
	});
}
//上传截图
App.uploadScreenShot=function(objForm,objFile,objImg,objParent){
		var id="";
		if (!Validator.isPicture(objFile)) {
			$.messager.alert('提示','上传的文件不符合格式要求！','info');
			return;
		}
		objForm.form('submit', {
			url:'/fs/api/upload',
			success:function(data){
				data=Public.removeHtml(data);
				var dataObj = eval("("+data+")");
				id=dataObj.id;
				if(id){
    				objImg.attr("src",'/fs/app-screen/'+id);
    				objParent.attr("data-id",id);
    				var delBtn=objParent.find("div.screen-delete");
                    delBtn.show();
                    delBtn.unbind().bind("click",function(){
                        App.delScreenShot($(this),objImg,objParent);
                    });
				}else{
				    $.messager.alert('提示',dataObj.msg,'error');
				}
			}
		});
		$(objFile).attr("value","");
		$(objFile).val("");
	};
App.delScreenShot=function(obj,objImg,objParent){
	objImg.attr("src",'/public/images/tx_2.png');
	objParent.removeAttr("data-id");
	obj.hide();
}
//如果是编辑页，则给相应的属性赋值
App.initUpgradeData=function(){
	var idApp=$('#idApp').val();
	var runType=$('#runType').val();
	App.initScreenShotUpload();
	if(idApp==0){
		return;
	}
	$.ajax({
		url : '/app/getApp',
		dataType: "json",
		type: "post",
		data: {idApp:idApp},
		success: function(app){
			//应用名称
			$('#nameApp').val(app.name);
			var installUrl=document.getElementById('installUrl');
			$("#osType").val(app.osType);
			$("#runType").val(app.runType);
			$("#installUrl").val(app.installUrl);
			//应用类型
			if(app.osType=='Android'){//安卓
				if(app.runType=='STANDALONE'){
					//应用上传
					$('#fileUpload').css('display','block');
					installUrl.style.display='none';
					if(app.detailInfo.packFile != null){
						//文件id
						$('#idFile').val(app.detailInfo.packFile.id);
					}
				}else if(app.runType=='THIRDPARTY'){
					$("#installUrl").css('display','');
					$("#urlApp").css('display','');
					$("#size").removeAttr("disabled");
				}
			}else if(app.osType=='iOS'){//iOS
				var inter=document.getElementById('inter');
				var appstore=document.getElementById('appstore');
				
				if(app.runType=='STANDALONE'){
					//应用上传
					$('#fileUpload').css('display','block');
					installUrl.style.display='none';
					if(app.detailInfo.packFile != null){
						//文件id
						$('#idFile').val(app.detailInfo.packFile.id);
					}
				}else if(app.runType=='THIRDPARTY'){
					installUrl.style.display='';
					$("#urlApp").css('display','');
					$('#fileUpload').css('display','none');
					$("#size").removeAttr("disabled");
				}else{
					installUrl.style.display='none';
					$("#urlApp").css('display','none');
				}
			}else if(app.osType=='Hybird'){
				//应用上传
				$('#fileUpload').css('display','block');
				if(app.detailInfo.packFile != null){
					//文件id
					$('#idFile').val(app.detailInfo.packFile.id);
				}
			}
			var idScreens=app.detailInfo.screenShots;
			if(idScreens && idScreens.length>0){
				$(".appScreen").each(function(i){
					if(i>(idScreens.length-1)){
						return false;
					}
					var _this=$(this);
					var id=idScreens[i];
					var img=_this.find("img");
					img.attr("src",'/fs/app-screen/'+id);
					_this.attr("data-id",id);
					var delBtn=_this.find("div.screen-delete");
					delBtn.show();
					delBtn.unbind().bind("click",function(){
						App.delScreenShot(delBtn,img,_this);
					});
				});
			}
			//应用大小
			$('#size').val(App.dealFormatSize(app.detailInfo.size));
			$('#descriptionApp').text(app.detailInfo.description);
			$('#curVersion').html(app.detailInfo.version);
			$('#versionCodeDiv').html(app.detailInfo.versionCode);
			//应用图标
			var logoUrl='/fs/app-icon/'+app.icon;
			$('#logoAppImg').attr('src',logoUrl);
			$('#idLogo').val(app.icon);
			
			//打开地址
			$('#openUrl').val(app.openUrl);
		},
		error: function(){
			jQuery.messager.alert('提示','服务器内部错误','error');
		},
		complete:Public.sessionOut
	});
}

//操作系统切换
App.changeOs=function(obj){
	if(!confirm("切换后，部分数据将清除，确定切换吗？")) {
		return;
	}
	var runType=document.getElementsByName('typeRadio');
	var run="BUILD_IN";
	
	var inter=document.getElementById('inter');
	inter.checked=true;
	for(var i=0;i<runType.length;i++){
		var objRun=runType[i];
		if(objRun.checked==true){
			run=objRun.value;
		}
	}
	var os=obj.value;
	var size=document.getElementById('size');
	var installUrl=document.getElementById('installUrl');
	var openUrl=document.getElementById('openUrl');
	if(os=='Hybird'){
		var typeRadio=document.getElementsByName('typeRadio');
		typeRadio[0].disabled=true;
		typeRadio[1].checked=true;
		typeRadio[2].disabled=true;
		$("#codeApp").attr("disabled","true");
		$('#fileUpload').css('display','');
		size.disabled=true;
		size.value='';
		installUrl.value='';
		$('#nameFile').html('');
		$('#idFile').val('');
		$('#accurateSize').val('');
		installUrl.disabled=true;
		openUrl.disabled=false;
		openUrl.value='';
		$("#independence").removeAttr("disabled");
	}else if(os=='iOS'){
		var typeRadio=document.getElementsByName('typeRadio');
		for(var i=0;i<typeRadio.length;i++){
			typeRadio[i].disabled=false;
		}
		$("#codeApp").removeAttr("disabled");
		$('#fileUpload').css('display','none');
		size.disabled=false;
		//installUrl.disabled=false;
		if(run!='BUILD_IN'){
			installUrl.disabled=false;
		}else{
			installUrl.disabled=true;
		}
		installUrl.value='';
		openUrl.disabled=false;
		openUrl.value='';
		size.value='';
		nameFile.value='';
		$('#idFile').val('');
		$('#accurateSize').val('');
		var size=document.getElementById('size');
		size.disabled=false;
		$('#fileUpload').css('display','none');
		//文件id清空
		$('#idFile').val('');
		//安装路径清空
		$('#installUrl').val('');
		//禁用独立运行选项
		$("#independence")[0].checked=false;
		$("#independence").attr("disabled","disabled");
	}else if(os=='Android'){
		var typeRadio=document.getElementsByName('typeRadio');
		for(var i=0;i<typeRadio.length;i++){
			typeRadio[i].disabled=false;
		}
		$("#codeApp").removeAttr("disabled");
		$('#fileUpload').css('display','none');
		size.disabled=false;
		if(run!='BUILD_IN'){
			installUrl.disabled=false;
		}else{
			installUrl.disabled=true;
		}
		openUrl.disabled=false;
		openUrl.value='';
		$('#accurateSize').val('');
		var size=document.getElementById('size');
		size.disabled=false;
		$('#fileUpload').css('display','none');
		//文件id清空
		$('#idFile').val('');
		//安装路径清空
		$('#installUrl').val('');
		size.value='';
		nameFile.value='';
		$("#independence").removeAttr("disabled");
	}
}

//切换应用类型
App.changeType=function(obj){
	var size=document.getElementById('size');
	//操作系统
	var ios=document.getElementById('ios');
	var installUrl=document.getElementById('installUrl');
	var hybird = document.getElementById('Hybird');
	if(obj.id=='inter' && !hybird.checked){//内置
		$('#fileUpload').css('display','none');
		size.disabled=false;
		installUrl.disabled=true;
	}else if(obj.id=='independence'){//独立APK，需上传文件
		if(ios.checked==true){//苹果
			installUrl.disabled=true;
			size.disabled=true;
			$('#fileUpload').css('display','');
		}else{//安卓
			installUrl.disabled=true;
			size.disabled=true;
			$('#fileUpload').css('display','');
		}
	}else if(obj.id=='thirdparty'){
		if(ios.checked==true){
			installUrl.disabled=false;
			//installUrl.value='';
			size.disabled=false;
			//size.value='';
			$('#fileUpload').css('display','none');
		}else{
			size.disabled=false;
			//size.value='';
			installUrl.disabled=false;
			//installUrl.value='';
			$('#fileUpload').css('display','none');
		}
	}
	//文件id清空
	$('#idFile').val('');
}
App.saveAppAuthroity=function(){
	var idApp=$("#idApp").val();
	var roles=document.getElementsByName('roleCheckbox');
	var roleSet=[];
	for(var i=0;i<roles.length;i++){
		var obj=roles[i];
		if(obj.checked==true){
			roleSet.push(obj.value);
		}
	}
	if(roleSet.length<=0){
		$.messager.alert("消息","请选择应用角色！",'info');
		return;
	}
	$.post("/app/saveAppAuthroity",{idApp:idApp,appRoles:roleSet},function(data,textStatus){
		if(textStatus=="success"){
			if(data.r=="1"){
				location.href='/app/appList';
			}else{
				$.messager.alert("错误",data.msg,'error');
			}
		}
	});
}
//保存应用
App.saveApp=function(){
	var idApp=$('#idApp').val();//应用id
	var name=$('#nameApp').val();//名称
	var nameEn=$('#nameAppEn').val();//英文名称
	if(name=='' || name==null){
		$.messager.alert("消息","请输入应用名称！",'info');
		return;
	}else{
		if(name.length>20){
			$.messager.alert("消息","应用标题不能超过20个字！",'info');
			return;
		}
	}
	var descriptionApp=$('#descriptionApp').val();//简介
	if(descriptionApp=='' || descriptionApp==null){//
		$.messager.alert("消息","请输入应用简介！",'info');
		return;
	}else{
		if(descriptionApp.length>1000){
			$.messager.alert("消息","应用简介不能超过1000个字！",'info');
			return;
		}
	}
	
	//运行方式
	var os="Android";
	var osType=document.getElementsByName('osRadio');
	for(var i=0;i<osType.length;i++){
		var obj=osType[i];
		if(obj.checked){
			os=obj.value;
		}
	}
	//应用类型
	var runType=document.getElementsByName('typeRadio');
	var run="BUILD_IN";
	for(var i=0;i<runType.length;i++){
		var obj=runType[i];
		if(obj.checked==true){
			run=obj.value;
		}
	}
	
	//罗列类型
	var listType=document.getElementsByName('listRadio');
	var list="FIXED";
	for(var i=0;i<listType.length;i++){
		var obj=listType[i];
		if(obj.checked==true){
			list=obj.value;
		}
	}
	//应用id
	var idFile=$('#idFile').val();
	//应用logo
	var idLogo=$('#idLogo').val();
	if(idLogo=='' || idLogo==null){
		$.messager.alert("消息","请上传logo！",'info');
		return;
	}
	
	//只有安卓独立需上传
	var android=document.getElementById('Hybird');
	var independence=document.getElementById('independence');
	//取消apk包上传限制begin
	if(android.checked && (idFile==''|| idFile==null)){
		$.messager.alert("消息","请上传应用包！",'info');
		return;
	}
	//取消apk包上传限制end
	
	var inter=document.getElementById('inter');
	//安装地址
	var installUrl=$('#installUrl').val();
//	if(inter.checked!=true){
//		if(installUrl=='' || installUrl==null){
//			$.messager.alert("消息","安装地址不能为空！",'info');
//			return;
//		}
//	}
	
	//打开地址
	//if($('#openUrl').attr("disabled")!='disabled'){
		var openUrl=$('#openUrl').val();
		if(openUrl=='' || openUrl==null){
			$.messager.alert("消息","请输入打开地址！",'info');
			return;
		}
	//}
	//应用大小
	var size=0;
	
	//如果不是手动填写，则直接存精确size
	if(document.getElementById('size').disabled){
		size=$('#accurateSize').val();
	}else{
		var sizeStr = $('#size').val();
		var sizeFloat=sizeStr.substring(0,sizeStr.length-1);
		if(!Validator.isDoubleNumber(sizeFloat)){
			$.messager.alert("消息","请按要求填写应用大小！",'info');
			return;
		}
		size=sizeFloat*1024;
		var unit=sizeStr.substring(sizeStr.length-1);
		if(unit=="k"||unit=="K"){
		}else if(unit=="m"||unit=="M"){
			size=size*1024;
		}else{
			$.messager.alert("消息","请按要求填写应用大小！",'info');
			return;
		}
	}
	
	//版本名称
	var version=$('#version').val();
	if(!Validator.isVersion(version)){
		$.messager.alert("消息","请输入正确的版本名称！",'info');
		return;
	}
//	if(version=='' || version==null){
//		$.messager.alert("消息","请输入版本名称！",'info');
//		return;
//	}
	//版本号
	var versionCode=$('#versionCode').val();
	if(!Validator.isNormalNumber(versionCode)){
		$.messager.alert("消息","版本号请填写正整数！",'info');
		return;
	}
	//应用code
	//if($('#codeApp').attr("disabled")!='disabled'){
		var codeApp=$('#codeApp').val();
		if(codeApp=='' || codeApp==null){
			$.messager.alert("消息","请输入应用code！",'info');
			return;
		}
	//}
	
	//应用分类
	var category=$('#category').val();
	if(category=='nothing'){
		$.messager.alert("消息","请选择应用分类！",'info');
		return;
	}
	
	//应用角色
//	var roles=document.getElementsByName('roleCheckbox');
//	var roleSet=[];
//	for(var i=0;i<roles.length;i++){
//		var obj=roles[i];
//		if(obj.checked==true){
//			roleSet.push(obj.value);
//		}
//	}
//	if(roles.length<=0){
//		$.messager.alert("消息","请选择应用角色！",'info');
//		return;
//	}
	//状态
	var status=$('#status').val();
	//截图id数组
	var idScreens=[];
	$(".appScreen").each(function(){
		idScreens.push($(this).attr("data-id"));
	});
	var appSrc=$("#appSrc").val();//应用来源
	$.ajax({
		url: '/app/saveApp',
		dataType: "json",
		type: "post",
		data: {
				idApp:idApp,
				idFile:idFile==''?0:idFile,
				idLogo:idLogo,
				name:name,
				descriptionApp:descriptionApp,
				os:os,
				run:run,
				installUrl:installUrl,
				openUrl:openUrl,
				size:size==''?0:size,
				version:version,
				versionCode:versionCode,
				codeApp:codeApp,
				status:status,
				category:category,
				//roles:roleSet,
				list:list,
				idScreens:idScreens,
				appSrc:appSrc,
				nameEn:nameEn
			},
		success: function(map){
			var state=map.state;
			var msg=map.msg;
			if(state=="1"){
				location.href='/app/appList';
			}else{
				jQuery.messager.alert('提示', msg, 'info');
			}
		},
		error: function(){
			jQuery.messager.alert('提示', '操作失败', 'info');
		},
		complete:Public.sessionOut
	});
}

//保存升级信息
App.saveUpgradeApp=function(){
	var idApp=$('#idApp').val();//应用id
	var runType = $('#runType').val();
	var descriptionApp=$('#summary').val();//简介
	if(descriptionApp=='' || descriptionApp==null){//
		$.messager.alert("消息","请输入应用简介！",'info');
		return;
	}else{
		if(descriptionApp.length>100){
			$.messager.alert("消息","应用简介不能超过100个字！",'info');
			return;
		}
	}
	
	//应用id
	var idFile=$('#idFile').val();
	//应用logo
	var idLogo=$('#idLogo').val();
	if(idLogo=='' || idLogo==null){
		$.messager.alert("消息","请上传logo！",'info');
		return;
	}
	
	//只有安卓独立需上传
	var android=document.getElementById('android');
	var independence=document.getElementById('independence');
	
	//安装地址
	var installUrl=$('#installUrl').val();
	if(runType=='2' && installUrl=='' || installUrl==null){
		$.messager.alert("消息","安装地址不能为空！",'info');
		return;
	}
	
	//打开地址
	if($('#openUrl').attr("disabled")!='disabled'){
		var openUrl=$('#openUrl').val();
		if(openUrl=='' || openUrl==null){
			$.messager.alert("消息","请输入打开地址！",'info');
			return;
		}
	}
	//应用大小
	var size=0;
	
	//如果不是手动填写，则直接存精确size
	if(document.getElementById('size').disabled){
		size=$('#accurateSize').val();
	}else{
		var sizeStr = $('#size').val();
		var sizeFloat=sizeStr.substring(0,sizeStr.length-1);
		if(!Validator.isDoubleNumber(sizeFloat)){
			$.messager.alert("消息","请按要求填写应用大小！",'info');
			return;
		}
		size=sizeFloat*1024;
		var unit=sizeStr.substring(sizeStr.length-1);
		if(unit=="k"||unit=="K"){
		}else if(unit=="m"||unit=="M"){
			size=size*1024;
		}else{
			$.messager.alert("消息","请按要求填写应用大小！",'info');
			return;
		}
	}
	
	//版本名称
	var version=$('#version').val();
	if(!Validator.isVersion(version)){
		$.messager.alert("消息","请输入正确的版本名称！",'info');
		return;
	}

	//版本号
	var versionCode=$('#versionCode').val();
	if(!Validator.isNormalNumber(versionCode)){
		$.messager.alert("消息","版本号请填写正整数！",'info');
		return;
	}
	
	var versionCodeDiv = $('#versionCodeDiv').html();
	if(parseInt(versionCode)<=parseInt(versionCodeDiv)){
		$.messager.alert("消息","版本号必须大于当前版本号！",'info');
		return;
	}
	//截图id数组
	var idScreens=[];
	$(".appScreen").each(function(){
		idScreens.push($(this).attr("data-id"));
	});
	$.ajax({
		url: '/app/saveUpgradeApp',
		dataType: "json",
		type: "post",
		data: {
				idApp:idApp,
				idFile:idFile==''?0:idFile,
				idLogo:idLogo,
				descriptionApp:descriptionApp,
				installUrl:installUrl,
				openUrl:openUrl,
				size:size==''?0:size,
				version:version,
				versionCode:versionCode,
				idScreens:idScreens
			},
		success: function(map){
			var state=map.state;
			var msg=map.msg;
			if(state=="1"){
				location.href='/app/appList'
			}else{
				jQuery.messager.alert('提示', msg, 'info');
			}
		},
		error: function(){
			jQuery.messager.alert('提示', '操作失败', 'info');
		},
		complete:Public.sessionOut
	});
}



//保存海报
App.backVersion=function(idHistory){
	var idApp=$('#idApp').val();//应用id
	$.messager.confirm('确认','您确定要回退到改版本吗？',function(r){
		if (r){
			$.ajax({
				url: '/app/saveBackAppVersion',
				dataType: "json",
				type: "post",
				data: {
						idApp:idApp,
						idHistory:idHistory
					},
				success: function(map){
					var state=map.state;
					var msg=map.msg;
					if(state=="1"){
						jQuery.messager.alert('提示', "操作成功", 'info',function(){
							location.reload();
						});
					}else{
						jQuery.messager.alert('提示', msg, 'info');
					}
				},
				error: function(){
					jQuery.messager.alert('提示', '操作失败', 'info');
				},
				complete:Public.sessionOut
			});
	}});
}


//上传应用
App.uploadApp=function(obj){
	var suffix='zip';
	
	//应用类型
	var runType=document.getElementsByName('typeRadio');
	var osRadio = document.getElementsByName('osRadio');
	
	var run="BUILD_IN";
	for(var i=0;i<runType.length;i++){
		var objType=runType[i];
		if(objType.checked==true){
			run=objType.value;
		}
	}
	var os="Android";
	for(var i=0;i<osRadio.length;i++){
		var osType=osRadio[i];
		if(osType.checked==true){
			os=osType.value;
		}
	}
	
	if(run=="STANDALONE" && os=='iOS'){
		suffix='ipa';
	}else if(run=="STANDALONE" && os=='Android'){
		suffix='apk';
	}
	if (Validator.isFile(obj,suffix)) {
		$('#appFileForm').form('submit', {
			url:'/fs/api/upload',
			success: function(data){
				var dataObj = eval("(" + Public.removeHtml(data) + ")");
				var nameFile=dataObj.name;
				$('#nameFile').html(nameFile);
				$('#idFile').val(dataObj.id);
				$('#size').val(App.dealFormatSize(dataObj.size));
				$('#accurateSize').val(dataObj.size);
				if(suffix=='zip'){
					$("#codeApp").val(nameFile.substr(0,nameFile.indexOf('.')));
					var appCode = nameFile.substr(0,nameFile.indexOf('.'));
					var openUrl="scc://wisorg.com/Hybird/res/"+appCode+"/index.html";
					$("#openUrl").val(openUrl);
				}
				
				var filePath='/fs/'+dataObj.bizKey+'/'+dataObj.id;
				$('#installUrl').val(filePath);
			},
			failure: function(){
				jQuery.messager.alert('提示','服务器内部错误','error');
			}
		});
	}else{
		jQuery.messager.alert('提示', '文件格式不正确，系统只支持'+suffix+'格式的文件', 'info');
	}
}
//上传应用
App.uploadUpgradeApp=function(obj){
	var suffix='zip';
	
	//应用类型
	var run=$('#runType').val();
	var os=$("#osType").val();
	
	if(run=="STANDALONE" && os=='iOS'){
		suffix='ipa';
	}else if(run=="STANDALONE" && os=='Android'){
		suffix='apk';
	}
	if (Validator.isFile(obj,suffix)) {
		$('#appFileForm').form('submit', {
			url:'/fs/api/upload',
			success: function(data){
				var dataObj = eval("(" + Public.removeHtml(data) + ")");
				var nameFile=dataObj.name;
				$('#nameFile').html(nameFile);
				$('#idFile').val(dataObj.id);
				$('#size').val(App.dealFormatSize(dataObj.size));
				$('#accurateSize').val(dataObj.size);
				if(suffix=='zip'){
					$("#codeApp").val(nameFile.substr(0,nameFile.indexOf('.')));
					var appCode = nameFile.substr(0,nameFile.indexOf('.'));
					var openUrl="scc://wisorg.com/Hybird/res/"+appCode+"/index.html";
					$("#openUrl").val(openUrl);
				}
				
				var filePath='/fs/'+dataObj.bizKey+'/'+dataObj.id;
				$('#installUrl').val(filePath);
			},
			failure: function(){
				jQuery.messager.alert('提示','服务器内部错误','error');
			}
		});
	}else{
		jQuery.messager.alert('提示', '文件格式不正确，系统只支持'+suffix+'格式的文件', 'info');
	}
}

//上传应用logo
App.uploadAppLogo=function(obj){
	if (Validator.isFile(obj, "png")) {
		$('#appLogoForm').form('submit', {
			url:'/fs/api/upload',
			success: function(data){
				var dataObj = eval("(" + Public.removeHtml(data) + ")");
				if(typeof(dataObj.msg) != undefined && typeof(dataObj.msg) != "undefined" && dataObj.msg !=""){
					jQuery.messager.alert('提示', dataObj.msg, 'error');
				}else{
					var filePath='/fs/'+dataObj.bizKey+'/'+dataObj.id;
					$('#logoAppImg').attr('src',filePath);
					$('#idLogo').val(dataObj.id);
				}
			},
			failure: function(){
				jQuery.messager.alert('提示','服务器内部错误','error');
			}
		});
	}else{
		jQuery.messager.alert('提示', '图片格式不正确，应用logo只支持png格式的图片', 'info');
	}
}

//取消编辑应用
App.cancelEditApp=function(){
	if(confirm("您确定要放弃吗？")){
		location.href = '/app/appList';
	}
}

//删除应用
App.deleteApp=function(){
	$('#nameFile').html('');
	$('#idFile').val('');
	$('#size').val('');
	$('#accurateSize').val('');
	$('#installUrl').val('');
}

//删除应用logo
App.deleteLogo=function(){
	$('#idLogo').val('');
	$('#logoAppImg').attr('src','/public/images/tx_2.png');
}

//选择分类（当选择所有人时，其他灰显）
App.changeGrey=function(){
   var checkAll=$("#app_role input[id='everyone']");//所有人
   var checkSon=$("#app_role input[type='checkbox'][id!='everyone']");//除了所有人以外的其他人
   var loginUser=$("#app_role input[id='user']");//已登录用户
   var guest=$("#app_role input[id='guest']");//游客
   var commonUser=$("#app_role input[id!='user'][id!='everyone'][id!='guest']");//除了所有人、用户、游客以外的人
   checkAll.click(function(){
       var checkstate=$(this)[0].checked ;
       if($(this)[0].checked ){
            checkSon.each(function(){
                 $(this).attr("disabled","disabled");
            });
       }else{
			if(loginUser[0].checked){
				guest.removeAttr("disabled");
				loginUser.removeAttr("disabled");
			}else{
	            checkSon.each(function(){
             		$(this).removeAttr("disabled");
	            });
			}
       }
   });
   loginUser.click(function(){
       var checkstate=$(this)[0].checked ;
       if($(this)[0].checked ){
            commonUser.each(function(){
                 $(this).attr("disabled","disabled");
            });
       }else{
            commonUser.each(function(){
                 $(this).removeAttr("disabled");
            });
       }
   });
   if(checkAll[0].checked){
   		checkSon.each(function(){
             $(this).attr("disabled","disabled");
        });
   }else if(loginUser[0].checked){
   		commonUser.each(function(){
             $(this).attr("disabled","disabled");
        });
   }
}

//重置app Secret
App.resetSecret = function(){
	var idApp=$('#idApp').val();
	$.messager.confirm('确认','您确定要重置app secret吗？',function(r){
		if (r){
			$.ajax({
				url : resetSecretUrl,
				dataType: "json",
				type: "post",
				data: {'idApp':idApp},
				success: function(data){
					if(data.r=='1'){
						$('#appSecret').val(data.newSecret);
						$.messager.alert("提示","重置app secret成功",'info');   
					}else{
						$.messager.alert("提示",data.msg == ''?"重置app secret 失败":data.msg,'error');   
					}
				}
			});
		}
	});
}
App.createSecret = function(){
	var idApp=$('#idApp').val();
	$.messager.confirm('确认','您确定要创建此应用凭证吗？',function(r){
		if (r){
			$.ajax({
				url : createSecretUrl,
				dataType: "json",
				type: "post",
				data: {'idApp':idApp},
				success: function(data){
					if(data.r=='1'){
						App.gotoCredential(idApp);
					}else{
						$.messager.alert("提示",data.msg == ''?"创建应用凭证失败":data.msg,'error');   
					}
				}
			});
		}
	});
}
App.gotoCredential = function(idApp){
	location.href = toCredentialUrl+"?idApp="+idApp;
}
App.saveApiRoles = function(){
	var idApp=$('#idApp').val();
	$.messager.confirm('确认','您确定要为此应用授权吗？',function(r){
		if (r){
			var apiRoles=document.getElementsByName('apiRoleCheckbox');
			var apiRoleSet=[];
			for(var i=0;i<apiRoles.length;i++){
				var obj=apiRoles[i];
				if(obj.checked==true){
					apiRoleSet.push(obj.value);
				}
			}
			$.ajax({
				url : saveApiRolesUrl,
				dataType: "json",
				type: "post",
				data: {'idApp':idApp,'apiRoles':apiRoleSet, 'spaceTypes':$("input[name=spaceType]:checked").map(function() {return $(this).val();}).get()},
				success: function(data){
					if(data.r=='1'){
						App.gotoCredential(idApp);
					}else{
						$.messager.alert("提示",data.msg == ''?"设置应用api访问角色失败":data.msg,'error');   
					}
				}
			});
			
		}
	});
}
App.initApiRoles = function(){
	var idApp=$('#idApp').val();
			$.ajax({
				url : initApiRolesUrl,
				dataType: "json",
				type: "post",
				data: {'idApp':idApp},
				success: function(apiIdRoles){
					var apiRoles =document.getElementsByName('apiRoleCheckbox');
					for(var i=0;i<apiRoles.length;i++){
						var obj=apiRoles[i];
						for(var j=0;j<apiIdRoles.length;j++){
							if(apiIdRoles[j]==obj.value){
								obj.checked=true;
							}
						}
					}
				}
			});
}
App.uptCredStatus = function(){
	var idApp=$('#idApp').val();
	var appStatusBtnVal=$('#appStatusBtn').text();
	$.messager.confirm('确认','您确定要'+appStatusBtnVal+'此应用凭证吗？',function(r){
		if (r){
			var apiRoles=document.getElementsByName('apiRoleCheckbox');
			var apiRoleSet=[];
			for(var i=0;i<apiRoles.length;i++){
				var obj=apiRoles[i];
				if(obj.checked==true){
					apiRoleSet.push(obj.value);
				}
			}
			$.ajax({
				url : uptCredStatusUrl,
				dataType: "json",
				type: "post",
				data: {'idApp':idApp,'apiRoles':apiRoleSet},
				success: function(data){
					if(data.r=='1'){
						App.gotoCredential(idApp);
					}else{
						$.messager.alert("提示",data.msg == ''?appStatusBtnVal+"应用凭证失败":data.msg,'error');   
					}
				}
			});
		}
	});
}

/**
 * 删除应用.
 * @param idApp 应用ID
 */
App.deleteAppWithId = function(idApp){
	if(!confirm("敬请谨慎操作，确认删除该应用信息吗？")) {
		return;
	}
	$.ajax({
		url : deleteAppUrl,
		dataType: "json",
		type: "post",
		data: {'idApp':idApp},
		success: function(data){
			if(data.state=='1'){
				App.gotoCredential(idApp);
				window.location.href = appListUrl;
			}else{
				$.messager.alert("提示",data.msg == ''?"删除应用失败":data.msg,'error');   
			}
		}
	});
};

