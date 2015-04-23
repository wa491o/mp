var List={};
var idChecked=[];

List.appListQuery = function(){	
	var optionFormat=function(value,rowData,rowIndex){
		var str="";
		str+='<a href="javascript:;" style="margin-left:10px;" onclick="List.gotoEditAppList(\''+rowData.id+'\')" class="btn_list_option" ><span>编辑</span></a>'
		str+='<a href="javascript:;" style="margin-left:10px;" onclick="List.editAppListItem(\''+rowData.id+'\')" class="btn_list_option" ><span>应用列表</span></a>'
		str+='<a href="javascript:;" style="margin-left:10px;" onclick="List.delAppList(\''+rowData.id+'\')" class="btn_list_option" ><span>删除</span></a>';
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
		queryParams:{},
		url:'/app/getAppListPage' ,
		columns:[[
			{field:'name',title:'名称',width:670,align:'center'},
			{field:'description',title:'简介',width:100,align:'center'},
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

List.delAppList = function(id){
	$.messager.confirm('确认','您确定要删除该应用列表吗？',function(r){
		if (r){
			$.ajax({
				url: '/app/delAppList',
				dataType: "json",
				type: "post",
				data: {
					idAppList:id
				},
				success: function(map){
					var state=map.state;
					var msg=map.msg;
					if(state=="1"){
						location.href='/app/appListPage'
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

List.initAppListData = function(){
	var idAppList=$('#idAppList').val();
	if(idAppList==0){
		List.initAppListPage();
		return;
	}
	$.ajax({
		url : '/app/getAppListDetail',
		dataType: "json",
		type: "get",
		data: {idAppList:idAppList},
		success: function(app){
			$('#description').val(app.description);
			$('#name').val(app.name);
			$("#listKey").val(app.listKey);
		},
		error: function(){
			jQuery.messager.alert('提示','服务器内部错误','error');
		},
		complete:Public.sessionOut
	});
}

List.initAppListPage = function(){
	var detailFormat=function(value,row,rowIndex){
		//图片
		var filePath='/fs/app-icon/'+row.icon;
		var cont='<div class="imgBox" style="width:60px;height:60px;margin-top:5px;margin-left:0px;">'+
				 '	<img src="'+filePath+'" id="'+row.icon+'" style="width:60px;height:60px;">'+
				 '</div>'+
				 '<div class="contBox" style="width:250px;margin-top:0px;">'+
				 '	<p class="cont-tit">'+row.name+'</p>'+
				  '	<p class="cont-detail mt10">'+List.dealFormatSize(row.detailInfo.size)+' | 用户数：'+row.statInfo.userCount+' | 版本号：'+row.detailInfo.version+'</p>'+
				 '	<p class="cont-detail mt10">'+row.detailInfo.description+'</p>'+
				 '</div>';
		return cont;
	}
	var checkboxFormater = function(value,rowData,rowIndex){
		var id=rowData.id;
		var checked = "";
		//图片
		var cont='<div style="align:center;margin:auto auto;width:20px;"><input type="checkbox" style="align:center;margin:auto auto" name="idCheck" onclick="List.idAppListCheck(this)" id="'+rowData.id+'" '+checked+'></div>';
		return cont;
	}
	var idAppList = $("#idAppList").val();
	$('#appListGrid').datagrid({
		width:950,
		nowrap: false,
		striped: true,
		collapsible:false,	
		remoteSort: false,
		pagination:true,
		singleSelect:true,
		pageList:[10],
		queryParams:{idAppList:idAppList},
		url:'/app/getAppList',
		columns:[[
		    {field:'id',width:50,formatter:checkboxFormater},
			{field:'detail',title:'应用介绍',width:690,align:'center',formatter:detailFormat},
			{field:'osType',title:'系统类型',width:200,align:'center'}
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

List.initAppListItemCheckedPage = function(){
	var title=$('#title').val();
	var catId=$('#category').val();
	if(catId=="all"){
		catId='';
	}
	var runType=$('#runType').val();
	if(runType=="all"){
		runType='';
	}
	
	var osType=$('#osType').val();
	if(osType=="all"){
		osType='';
	}
	var status=$(".tabTitle-selected").attr("data-tab");
	var fromAdmin = $("#fromAdmin").val();
	
	var detailFormat=function(value,row,rowIndex){
		//图片
		var filePath='/fs/app-icon/'+row.icon;
		var cont='<div class="imgBox" style="width:60px;height:60px;margin-top:5px;margin-left:0px;">'+
				 '	<img src="'+filePath+'" id="'+row.icon+'" style="width:60px;height:60px;">'+
				 '</div>'+
				 '<div class="contBox" style="width:250px;margin-top:0px;">'+
				 '	<p class="cont-tit">'+row.name+'</p>'+
				  '	<p class="cont-detail mt10">'+List.dealFormatSize(row.detailInfo.size)+' | 用户数：'+row.statInfo.userCount+' | 版本号：'+row.detailInfo.version+'</p>'+
				 '	<p class="cont-detail mt10">'+row.detailInfo.description+'</p>'+
				 '</div>';
		return cont;
	}
	var checkboxFormater = function(value,rowData,rowIndex){
		var id=rowData.id;
		var checked = "";
		//图片
		var cont='<div style="align:center;margin:auto auto;width:20px;"><input type="checkbox" style="align:center;margin:auto auto" name="idCheck" onclick="List.idAppListCheck(this)" id="'+rowData.id+'" '+checked+'></div>';
		return cont;
	}
	
	var excludeIds = $("#excludeIds").val();
	$('#appListGrid').datagrid({
		width:950,
		nowrap: false,
		striped: true,
		collapsible:false,	
		remoteSort: false,
		pagination:true,
		singleSelect:true,
		pageList:[10],
		queryParams:{excludeIds:excludeIds,title:title,catId:catId,runType:runType,osType:osType,status:status,fromAdmin:fromAdmin},
		url:'/app/getAppList',
		columns:[[
		    {field:'id',width:50,formatter:checkboxFormater},
			{field:'detail',title:'应用介绍',width:690,align:'center',formatter:detailFormat},
			{field:'osType',title:'系统类型',width:200,align:'center'}
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

//列表已选应用
List.initAppListItemsPage = function(){
	var detailFormat=function(value,row,rowIndex){
		//图片
		var filePath='/fs/app-icon/'+row.icon;
		var cont='<div class="imgBox" style="width:60px;height:60px;margin-top:5px;margin-left:0px;">'+
				 '	<img src="'+filePath+'" id="'+row.icon+'" style="width:60px;height:60px;">'+
				 '</div>'+
				 '<div class="contBox" style="width:250px;margin-top:0px;">'+
				 '	<p class="cont-tit">'+row.name+'</p>'+
				  '	<p class="cont-detail mt10">'+List.dealFormatSize(row.detailInfo.size)+' | 用户数：'+row.statInfo.userCount+' | 版本号：'+row.detailInfo.version+'</p>'+
				 '	<p class="cont-detail mt10">'+row.detailInfo.description+'</p>'+
				 '</div>';
		return cont;
	}
	var checkboxFormater = function(value,rowData,rowIndex){
		var id=rowData.id;
		var checked = "";
		//图片
		var cont='<div style="align:center;margin:auto auto;width:20px;"><input type="checkbox" style="align:center;margin:auto auto" name="idCheck" onclick="List.idAppListCheck(this)" id="'+rowData.id+'" '+checked+'></div>';
		return cont;
	}
	
	$('#appListGrid').datagrid({
		width:950,
		nowrap: false,
		striped: true,
		collapsible:false,	
		remoteSort: false,
		pagination:true,
		singleSelect:true,
		pageList:[10],
		queryParams:{idAppList:idAppList},
		url:'/app/getAppList',
		columns:[[
		    {field:'id',width:50,formatter:checkboxFormater},
			{field:'detail',title:'应用介绍',width:690,align:'center',formatter:detailFormat},
			{field:'osType',title:'系统类型',width:200,align:'center'}
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
List.dealFormatSize=function(fileSize){
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

List.idAppListCheck = function(obj){
	if(obj.checked){
		idChecked[obj.id]=obj.id;
	}else{
		idChecked[obj.id]=null;
	}
}

//保存应用列表
List.saveAppList = function(){
	var idAppList = $('#idAppList').val();//应用id
	var name = $('#name').val();//简介
	var description = $('#description').val();//简介
	var listKey = $('#listKey').val();
	if(name=='' || name==null){//
		$.messager.alert("消息","请输入列表名称！",'info');
		return;
	}
	
	if(description=='' || description==null){//
		$.messager.alert("消息","请输入应用简介！",'info');
		return;
	}else{
		if(description.length>100){
			$.messager.alert("消息","应用简介不能超过100个字！",'info');
			return;
		}
	}
	
	$.ajax({
		url: '/app/saveAppList',
		dataType: "json",
		type: "post",
		data: {
				name:name,
				description:description,
				idAppList:idAppList,
				listKey:listKey
			},
		success: function(map){
			var state=map.state;
			var msg=map.msg;
			if(state=="1"){
				location.href='/app/appListPage'
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
var idAppList = $("#idAppList").val();
List.delCheckedList = function(){
	if(idChecked.length == 0) {
		alert("请选择应用");
		return false;
	}
	var deleteids=';';
	for(var i=0;i<idChecked.length;i++){
		if(idChecked[i]!=null && idChecked[i]!='' && idChecked[i]!=undefined){
			deleteids+=idChecked[i]+";";
		}
	}
	$.ajax({
		url: '/app/updateAppList',
		dataType: "json",
		type: "post",
		data: {
				idAppList:idAppList,
				delApps:deleteids
			},
		success: function(map){
			var state=map.state;
			var msg=map.msg;
			if(state=="1"){
				List.initAppListPage();
				//location.href='/app/appListPage'
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

//保存应用列表
List.saveAppToList = function(){
	if(idChecked.length == 0) {
		alert("请选择应用");
		return false;
	}
	var idAppList = $("#idAppList").val();
	$.ajax({
		url: '/app/saveAppToList',
		dataType: "json",
		type: "post",
		data: {
				idChecked:idChecked,
				idAppList:idAppList
			},
		success: function(map){
			var state=map.state;
			var msg=map.msg;
			if(state=="1"){
				location.href='/app/appListPage'
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

List.cancelEditAppList = function(){
	location.href = '/app/appListPage';
}
List.gotoEditAppList = function(idAppList){
	location.href= '/app/createNewAppList?idAppList='+idAppList;
}
List.editAppList = function(idAppList){
	location.href = '/app/createNewAppList?idAppList='+idAppList;
}
List.editAppListItem = function(idAppList){
	location.href = '/app/appListItems?idAppList='+idAppList;
}
List.addAppToListPage = function(){
	var idAppList = $("#idAppList").val();
	location.href = '/app/appListCheck?idAppList='+idAppList;
}