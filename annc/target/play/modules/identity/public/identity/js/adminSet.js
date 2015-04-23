var AdminSet = {};

AdminSet.indexPage = function() {
	var operatorType;
	var url = '/identity/listAdminSetInfo';
	var idFormat = function(value, rowData, index) {
		return rowData.id;
	}
	var nameFormat = function(value, rowData, index) {
		return rowData.name;
	}
	var roleFormat = function(value, rowData, index) {
		return rowData.roles;
	}
	var noteFormat = function(value, rowData, index) {
		return rowData.note;
	}
	var manageFormat = function(value, rowData, index) {
		var str="";
		if(rowData.type!='SUPER_ADMIN_USER'){
			str += '<a href="javascript:;" title="角色设定" onclick="AdminSet.toSetGroup('
					+ rowData.userId + ')" class="btn_list_option" ><span>角色设定</span></a>';
			str += '<a href="javascript:;" title="编辑" onclick="AdminSet.toEdit('
					+ rowData.id + ')" class="btn_list_option" ><span>编辑</span></a>';
			str += '<a href="javascript:;" title="删除" onclick="AdminSet.del('
					+ rowData.id + ')" class="btn_list_option" ><span>删除</span></a>';
			if (rowData.status == '1')
				str += '<a href="javascript:;" title="停用" onclick="AdminSet.stop('
						+ rowData.id + ')" class="btn_list_option" ><span>停用</span></a>';
			else
				str += '<a href="javascript:;" title="启用" onclick="AdminSet.start('
						+ rowData.id + ')" class="btn_list_option" ><span>启用</span></a>';
		}else if(rowData.type=='SUPER_ADMIN_USER' && rowData.isSuperAdmin){
			str += '<a href="javascript:;" title="编辑" onclick="AdminSet.toEdit('
					+ rowData.id + ')" class="btn_list_option" ><span>编辑</span></a>';
			str += '<a href="javascript:;" title="删除" onclick="AdminSet.del('
					+ rowData.id + ')" class="btn_list_option" ><span>删除</span></a>';
			if (rowData.status == '1')
				str += '<a href="javascript:;" title="停用" onclick="AdminSet.stop('
						+ rowData.id + ')" class="btn_list_option" ><span>停用</span></a>';
			else
				str += '<a href="javascript:;" title="启用" onclick="AdminSet.start('
						+ rowData.id + ')" class="btn_list_option" ><span>启用</span></a>';
		}
		return str;
	};
	$("#adminSetTable").datagrid({
		width : 952,
		nowrap : false,
		striped : true,
		collapsible : true,
		fitColumns : false, // 是否列自动适应内容宽度
		remoteSort : false,
		singleSelect : true,
		pagination : true,
		pageList : [ 10 ],
		url : url,
		columns : [ [ {
			field : 'id',
			title : "ID",
			width : 80,
			align : 'center',
			formatter : idFormat
		}, {
			field : 'name',
			title : "登录名",
			width : 150,
			align : 'center',
			formatter : nameFormat
		}, {
			field : 'roles',
			title : "用户组角色",
			width : 230,
			align : 'center',
			formatter : roleFormat
		}, {
			field : 'note',
			title : "备注",
			width : 180,
			align : 'center',
			formatter : noteFormat
		}, {
			field : 'manage',
			title : "管理",
			width : 280,
			align : 'center',
			formatter : manageFormat
		} ] ],
		onLoadSuccess : function(data) {
			operatorType = data.operatorType;
			if (data.total == '-1') {
				jQuery.messager.alert('提示', '当前会话已过期，请重新登录', 'info');
			}
		},
		onLoadError:Public.sessionOut
	});
	$("#name").bind('mouseup keyup click',function(){
		var offset=$(this).offset();
		var tip;
		if($.trim($(this).val()).length>10){
			$("#errTip").remove();
			tip=document.createElement("div");
			tip.setAttribute("id","errTip");
			tip.style.color="red";
			tip.style.height="18px";
			tip.style.fontSize="12px";
			tip.style.lineHeight="18px";
			tip.style.padding="4px";
			tip.innerHTML="登录名最长不超过10个字";
			tip.style.position="absolute";
			tip.style.top=(offset.top-20)+"px";
			tip.style.left=offset.left+"px";
			$("body").append(tip);
		}else{
			$("#errTip").remove();
		}
	});
}

AdminSet.updateGroup = function() {
	var uid = $('#uid').val();
	var groupIds = new Array();
	var index = 0;
	$("[name='role_cb']:checked").each(function() {
		groupIds[index] = $(this).val();
		index++;
	});
	var setGroupDialog = $("#setGroupDialog");
	$.ajax({
		url : '/identity/updateGroup',
		type : 'post',
		data : {
			id : uid,
			groudIds : groupIds
		},
		success : function(data) {
			setGroupDialog.hide();
			setGroupDialog.dialog('close');
			AdminSet.indexPage();
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}

AdminSet.toSetGroup = function(uid) {
	$('#uid').val(uid);
	var setGroupDialog = $("#setGroupDialog");
	setGroupDialog.dialog({
		title : '设定用户组角色',
		width : 600,
		closed : true,
		cache : false,
		modal : true,
		onclose : function() {
			setGroupDialog.hide();
		}
	});
	var content = '<div class="adminSet"><ul>';
	$.ajax({
		url : '/identity/listUserGroup',
		type : 'post',
		data : {
			id : uid
		},
		success : function(data) {
			for ( var i = 0; i < data.length; i++) {
				content += '<li><input type="checkbox" style="margin-right:5px;" name="role_cb" '
						+ (data[i].checked == 1 ? "checked" : "")
						+ ' value="'
						+ data[i].id
						+ '">'
						+ data[i].name
						+ '</li>';
			}
			content += '</ul></div>';
			$("#groupList").html(content);
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
	setGroupDialog.show();
	setGroupDialog.dialog('open');
}

AdminSet.toEdit = function(uid) {
	var editAdminDialog = $("#editAdminDialog");
	editAdminDialog.dialog({
		title : '编辑用户信息',
		width : 400,
		closed : true,
		cache : false,
		modal : true,
		onclose : function() {
			editAdminDialog.hide();
		}
	});
	$('#id').val('');
	$('#name_edit').val('');
	$('#password_edit').val('');
	$('#note_edit').val('');
	AdminSet.getAdmin(uid);
	editAdminDialog.show();
	editAdminDialog.dialog('open');
}

AdminSet.getAdmin = function(uid) {
	$.ajax({
		url : '/identity/getAdminInfo',
		type : 'post',
		data : {
			id : uid
		},
		success : function(data) {
			$('#id').val(data.id);
			$('#name_edit').val(data.credentials[0].name);
			$('#note_edit').val(data.user.attributes['note']);
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}

AdminSet.toAdd = function(name, password, note) {
	var name = $('#name').val();
	var password = $('#password').val();
	var note = $('#note').val();
	if(name.length>10){
		jQuery.messager.alert('提示', '登录名请控制在10个字以内', 'info');
		return;
	}
	if (name == '' || password == '' || name.trim() == ''
			|| password.trim() == '') {
		jQuery.messager.alert('提示', '登录名和密码不能为空', 'info');
		return;
	}
	$.ajax({
		url : '/identity/addAdminInfo',
		type : 'post',
		data : {
			name : name,
			password : password,
			note : note
		},
		success : function(data) {
			AdminSet.indexPage();
			$('#name').val('');
			$('#password').val('');
			$('#note').val('');
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}

AdminSet.updateAdmin = function() {
	var id = $('#id').val();
	var name = $('#name_edit').val();
	var password = $('#password_edit').val();
	var note = $('#note_edit').val();
	if(name.length>10){
		jQuery.messager.alert('提示', '登录名请控制在10个字以内', 'info');
		return;
	}
	if (name == '' || password == '' || name.trim() == ''
			|| password.trim() == '') {
		jQuery.messager.alert('提示', '密码不能为空', 'info');
		return;
	}
	var editAdminDialog = $("#editAdminDialog");
	$.ajax({
		url : '/identity/updateAdminInfo',
		dataType : "json",
		type : "post",
		data : {
			id : id,
			name : name,
			password : password,
			note : note
		},
		success : function(state) {
			editAdminDialog.hide();
			editAdminDialog.dialog('close');
			AdminSet.indexPage();
		},
		error : function() {
		},
		complete:Public.sessionOut
	});
}

AdminSet.updateAdminStatus = function(uid, status) {
	$.ajax({
		url : '/identity/updateAdminStatus',
		dataType : "json",
		type : "post",
		data : {
			id : uid,
			status : status
		},
		success : function(state) {
			AdminSet.indexPage();
		},
		error : function() {
		},
		complete:Public.sessionOut
	});
}

AdminSet.del = function(uid) {
	jQuery.messager.confirm('提示:', '确认要删除吗?', function(event) {
		if (event) {
			AdminSet.updateAdminStatus(uid, 4);
		}
	});
}

AdminSet.stop = function(uid) {
	jQuery.messager.confirm('提示:', '确认要停用吗?', function(event) {
		if (event) {
			AdminSet.updateAdminStatus(uid, 3);
		}
	});
}

AdminSet.start = function(uid) {
	jQuery.messager.confirm('提示:', '确认要启用吗?', function(event) {
		if (event) {
			AdminSet.updateAdminStatus(uid, 1);
		}
	});
}
