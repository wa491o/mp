var Role={};

Role.nowPageNo=1; //当前页码，翻页保持使用

//初始化角色管理
Role.initPage=function(){
	var url='/identity/queryRoleList';
	var nameFormat=function(value,rowData,rowIndex){
		return rowData.name;
	}
	var descriptionFormat=function(value,rowData,rowIndex){
		return rowData.description;
	}
	var optionFormat=function(value,rowData,rowIndex){
		if(rowData.type == 'BUILD_IN')
			return '';
		else
			return '<a href="javascript:;" onclick="Role.toEdit('+rowData.id+')" class="btn_list_option" ><span>编辑</span></a>' + 
				'<a href="javascript:;" onclick="Role.toDelete('+rowData.id+')" class="btn_list_option" ><span>删除</span></a>';
	}
	$('#roleList').datagrid({
		width:952,
		nowrap: false,
		striped: true,
		collapsible:true,	
		fitColumns: false, //是否列自动适应内容宽度
		remoteSort: false,
		singleSelect:true,
		pagination:true,
		pageNumber:Role.nowPageNo,
		pageList:[10],
		url:url ,
		columns:[[
			{field:'name',title:'角色名',width:300,align:'center',formatter:nameFormat},
			{field:'description',title:'描述',width:470,align:'center',formatter:descriptionFormat},
			{field:'operation',title:'管理',width:152,align:'center',formatter:optionFormat}																
					
		]],
		onLoadSuccess:function(data){
			if(data.total=='-1'){						                       
				jQuery.messager.alert('提示','当前会话已过期，请重新登录','info');
			}
			if(typeof(data.page) != "undefined"){
				Role.nowPageNo = data.page; // 当前页码
			}
		},
		onLoadError:Public.sessionOut
	});	
}

//创建角色
Role.saveRole=function(){
	var name=$('#name').val();//角色名称
	var description=$('#description').val();//角色描述
	if(name==''||description==''||name.trim()==''||description.trim()==''){
		jQuery.messager.alert('提示','角色名称和描述不能为空','info');
		return;
	}
	//var type=$('#type').val();//角色类型
	$.ajax({
		url: '/identity/saveRole',
		dataType: "json",
		type: "post",
		data: {
			name:name,
			description:description
				//type:type
		},
		success: function(data){
			if(data.state == "1"){
				jQuery.messager.alert('提示',"添加成功！",'info');
				Role.initPage();
				$('#name').val('');
				$('#description').val('');
			}else{
				jQuery.messager.alert('提示',data.msg,'warn');
			}
		},
		error: function(){
		},
		complete:Public.sessionOut
	});
}

//修改角色
Role.toEdit=function(id){
	var editRoleDialog=$("#editRoleDialog");
	editRoleDialog.dialog({
		title: '编辑角色',
	    width: 400,
	    closed: true,
	    cache: false,
	    modal: true,
		onclose:function(){
			editRoleDialog.hide();
		}
	});
	Role.getRole(id);
	editRoleDialog.show();
	editRoleDialog.dialog('open');
}

Role.getRole=function(id){
	$.ajax({
		url:'/identity/getRole',
		type:'post',
		data:{
			id:id
		},
		success:function(data){
			$('#id').val(data.id);
			$('#name_edit').val(data.name);
			$('#description_edit').val(data.description);
			//$('#type_edit').val(data.type_val);
		},
		error: function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}

Role.updateRole=function(){
	var id=$('#id').val();//角色ID
	var name=$('#name_edit').val();//角色名称
	var description=$('#description_edit').val();//角色描述
	if(name==''||description==''||name.trim()==''||description.trim()==''){
		jQuery.messager.alert('提示','角色名称和描述不能为空','info');
		return;
	}
	//var type=$('#type_edit').val();//角色类型
	var editRoleDialog=$("#editRoleDialog");
	$.ajax({
		url: '/identity/updateRole',
		dataType: "json",
		type: "post",
		data: {
				id:id,
				name:name,
				description:description,
				//type:type
		},
		success: function(state){
			editRoleDialog.hide();
			editRoleDialog.dialog('close');
			Role.initPage();
		},
		error: function(){
		},
		complete:Public.sessionOut
	});
}

/**
 * 删除角色.
 */
Role.toDelete = function(id){
	if(!confirm("敬请谨慎操作，原该组下的用户将被移至未分组角色中，确定要删除该角色吗？")) {
		return;
	}
	$.ajax({
		url:'/identity/deleteRole',
		type:'post',
		data:{
			id:id
		},
		success:function(data){
			if(data.state == "1"){
				Role.initPage();
				$('#name').val('');
				$('#description').val('');
			}else{
				jQuery.messager.alert('提示',data.msg,'warn');
			}
		},
		error: function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}

