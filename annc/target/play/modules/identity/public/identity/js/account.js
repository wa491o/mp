var Account = {};

Account.initRoles = function() {
	$.ajax({
		url : '/identity/queryRoleList',
		type : 'post',
		data : {},
		success : function(data) {
			var htmlContent = '<option value="">全部</option>';
			for ( var i = 0; i < data.rows.length; i++) {
				htmlContent = htmlContent + '<option value="' + data.rows[i].id
						+ '">' + data.rows[i].name + '</option>';
			}
			$('#role').html(htmlContent);
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}

// 初始化账号管理
Account.initPage = function() {
	var url = '/identity/queryAccountList';
	var uidFormat = function(value, rowData, rowIndex) {
	    if(rowData.user && rowData.user.id){
    		return rowData.user.id;
	    }else{
	        return "";
	    }
	}
	var nickNameFormat = function(value, rowData, rowIndex) {
		return rowData.user ? rowData.user.nickname : "";
	}
	var realNameFormat = function(value, rowData, rowIndex) {
		return rowData.user && rowData.user.certInfo ? rowData.user.certInfo.realname : "";
	}
	var genderFormat = function(value, rowData, rowIndex) {
		if (rowData.user){
			if (rowData.user.gender == 'UNKNOWN') {
				return '未知';
			} else if (rowData.user.gender == 'BOY') {
				return '男';
			} else if (rowData.user.gender == 'GIRL') {
				return '女';
			} else {
				return '';
			}	
		}else{
			return '';
		}
	}
	var departmentFormat = function(value, rowData, rowIndex) {
		return rowData.user && rowData.user.schoolInfo ? rowData.user.schoolInfo.departmentName : "";
	}
	var specialtyFormat = function(value, rowData, rowIndex) {
		return rowData.user && rowData.user.schoolInfo ? rowData.user.schoolInfo.specialtyName : "";
	}
	var roleFormat = function(value, rowData, rowIndex) {
		if (rowData.roles.length == 0) {
			return '';
		} else {
			var roleNames = '';
			for ( var i = 0; i < rowData.roles.length; i++) {
				if (rowData.roles[i].type == 'END_USER_ROLE') {
					roleNames += (rowData.roles[i].name + ' ');
				}
			}
			return roleNames;
		}
	}
	var idsFormat = function(value, rowData, rowIndex) {
		return rowData.user ? rowData.user.idsNo : '';
	}
	var regTimeFormat = function(value, rowData, rowIndex) {
		if (rowData.timeInfo){
			var date = new Date(rowData.timeInfo.createTime);
			return date.format("yyyyMMdd hh:mm");
		}else{
			return '';
		}
	}
	var optionFormat = function(value, rowData, rowIndex) {
		var str = '<a href="javascript:;" onclick="Account.toAccountDetail('
				+ rowData.id + ')" class="btn_list_option" ><span>详情</span><a>';
		if (rowData.status == 'DISABLED') {
			str += '<a href="javascript:;" onclick="Account.enableAccount('
					+ rowData.id + ')" class="btn_list_option" ><span>解封</span><a>';
		} else {
			str += '<a href="javascript:;" onclick="Account.disableAccount('
					+ rowData.id + ')" class="btn_list_option" ><span>封号</span><a>';
		}
		return str;
	}
	$('#accountList').datagrid({
		width : 1010,
		nowrap : false,
		striped : true,
		collapsible : true,
		fitColumns : false, // 是否列自动适应内容宽度
		remoteSort : false,
		singleSelect : true,
		pagination : true,
		pageList : [ 10 ],
		url : url,
		queryParams : {
			realName : $('#realName').val(),
			idsNo : $('#idsNo').val(),
			role : $('#role').val(),
			nickName : $('#nickName').val(),
			gender : $('#gender').val(),
			department : $('#department').val(),
			specialty : $('#specialty').val()
		},
		columns : [ [ {
			field : 'uid',
			title : 'UID',
			width : 50,
			align : 'center',
			formatter : uidFormat
		}, {
			field : 'nickName',
			title : '昵称',
			width : 80,
			align : 'center',
			formatter : nickNameFormat
		}, {
			field : 'realName',
			title : '姓名',
			width : 80,
			align : 'center',
			formatter : realNameFormat
		}, {
			field : 'gender',
			title : '性别',
			width : 40,
			align : 'center',
			formatter : genderFormat
		}, {
			field : 'department',
			title : '院系',
			width : 120,
			align : 'center',
			formatter : departmentFormat
		}, {
			field : 'specialty',
			title : '专业',
			width : 120,
			align : 'center',
			formatter : specialtyFormat
		}, {
			field : 'role',
			title : '角色',
			width : 80,
			align : 'center',
			formatter : roleFormat
		}, {
			field : 'ids',
			title : 'IDS账号(学号)',
			width : 150,
			align : 'center',
			formatter : idsFormat
		}, {
			field : 'regTime',
			title : '注册时间',
			width : 120,
			align : 'center',
			formatter : regTimeFormat
		}, {
			field : 'operation',
			title : '管理',
			width : 140,
			align : 'center',
			formatter : optionFormat
		} ] ],
		onLoadSuccess : function(data) {
			if (data.total == '-1') {
				jQuery.messager.alert('提示', '当前会话已过期，请重新登录', 'info');
			}
		},
		onLoadError:Public.sessionOut
	});
}

Account.updateAccountStatus = function(uid, status) {
	$.ajax({
		url : '/identity/updateAccountStatus',
		dataType : "json",
		type : "post",
		data : {
			id : uid,
			status : status
		},
		success : function(state) {
			Account.initPage();
		},
		error : function() {
		},
		complete:Public.sessionOut
	});
}

Account.disableAccount = function(uid) {
	jQuery.messager.confirm('提示:', '封号后该用户将无法登录和操作，您确认要对该用户封号吗？', function(
			event) {
		if (event) {
			Account.updateAccountStatus(uid, 3);
		}
	});
}

Account.enableAccount = function(uid) {
	jQuery.messager.confirm('提示:', '您确认要对该用户解封吗？', function(event) {
		if (event) {
			Account.updateAccountStatus(uid, 1);
		}
	});
}

Account.toUserDetail = function(uid) {
	location.href = '/identity/accountDetail?uid=' + uid;
}

Account.toAccountDetail = function(id) {
	location.href = '/identity/accountDetail?id=' + id;
}

Account.toManage = function() {
	location.href = '/identity/accountManage';
}

Account.initDetail = function(gender) {
	if (gender == 'GIRL') {
		$('#gender').val(2);
	} else {
		$('#gender').val(1);
	}
}

Account.updateAccount4Detail = function(uid, status, btnValue) {
	$.ajax({
		url : '/identity/updateAccountStatus',
		dataType : "json",
		type : "post",
		data : {
			id : uid,
			status : status
		},
		success : function(state) {
			$('#status').val(status);
			$('#statusBtn').text(btnValue);
		},
		error : function() {
		},
		complete:Public.sessionOut
	});
}

Account.updateStatus = function(uid) {
	var status = $('#status').val();
	if (status == 3) {
		jQuery.messager.confirm('提示:', '您确认要对该用户解封吗？', function(event) {
			if (event) {
				Account.updateAccount4Detail(uid, 1, '封号');
			}
		});
	} else {
		jQuery.messager.confirm('提示:', '封号后该用户将无法登录和操作，您确认要对该用户封号吗？', function(
				event) {
			if (event) {
				Account.updateAccount4Detail(uid, 3, '解封');
			}
		});
	}
}

Account.updateAccount = function() {
	var realName = $.trim($('#realName').val());
	var idsNo = $.trim($('#idsNo').val());
	var idsNames = $.trim($('#idsNames').val());
	var nickName = $.trim($('#nickName').val());
	var department = $.trim($('#department').val());
	var specialty = $.trim($('#specialty').val());
	var authenticationInfo = $.trim($('#authenticationInfo').val());
	if (realName != '' && realName.length > 30) {
		jQuery.messager.alert('提示', '用户姓名不得超过30个字', 'info');
		return;
	}
	if (idsNo == '' || idsNo.length > 30) {
		jQuery.messager.alert('提示', '用户的IDS账号不得为空且不超过30个字', 'info');
		return;
	}
	if (nickName == '' || nickName.length > 30) {
		jQuery.messager.alert('提示', '用户的昵称不能为空且不超过30个字', 'info');
		return;
	}
	var roleIds = new Array();
	var index = 0;
	$("[name='role_cb']:checked").each(function() {
		roleIds[index] = $(this).val();
		index++;
	});
	if (roleIds.length ==0) {
		jQuery.messager.alert('提示', '用户的角色信息不能为空', 'info');
		return;
	}
	if ($('#qq').val().trim() != '') {
		if($('#qq').val().trim().length < 5 || !Validator.isNormalNumber($('#qq').val())) {
			$.messager.alert("消息","请输入正确的QQ号",'info');
			return;
		}
	}
	if ($('#email').val().trim() != '') {
		if(!Validator.isEmail($('#email').val())){
			$.messager.alert("消息","请输入正确的邮箱地址",'info');
			return;
		}
	}
	if (department != '' && department.length > 50) {
		jQuery.messager.alert('提示', '用户院系不得超过50个字', 'info');
		return;
	}
	if (specialty != '' && specialty.length > 50) {
		jQuery.messager.alert('提示', '用户专业不得超过50个字', 'info');
		return;
	}

	var certIds = new Array();
	var certIndex = 0;
	$("[name='certInfo']:checked").each(function() {
		var certVal = $(this).val();
		certIds[certIndex] = certVal;
		certIndex++;
	});

	$.ajax({
		url : '/identity/isExistsCheck',
		dataType : "json",
		type : "post",
		data : {
			id : $('#id').val(),
			idsNo : idsNo,
			nickName : nickName
		},
		success : function(state) {
			if (state == '2') {
				jQuery.messager.alert('提示', '您填写的IDS账号已经被占用，请重新填写', 'info');
			} else if (state == '1') {
				jQuery.messager.alert('提示', '您填写的用户昵称已经被占用，请重新填写', 'info');
			} else {
				var province = $('#province').val();
				var city = $('#city').val();
				var forwardPage = $('#forwardPage').val();
				$.ajax({
					url : '/identity/updateAccount',
					dataType : "json",
					type : "post",
					data : {
						id : $('#id').val(),
						avatar : $('#avatar').val(),
						realName : realName,
						idsNo : idsNo,
						idsNames : idsNames,
						nickName : nickName,
						gender : $('#gender').val(),
						department : department,
						specialty : specialty,
						address : (city==''|| city==null)? province : city,
						qq : $('#qq').val(),
						email : $('#email').val(),
						roleIds : roleIds,
						birthDay : $('#birthDay').datebox('getValue'),
						certIds:certIds,
						authenticationInfo:authenticationInfo
					},
					success : function(state) {
						if (forwardPage == 'accountManage') {
							Account.toManage();
						} else {
							Account.toUserManage();
						}
					},
					error : function() {
					},
					complete:Public.sessionOut
				});
			}
		},
		error : function() {
		},
		complete:Public.sessionOut
	});
}

Account.initDetailPageRoles = function(roleIdStr) {
	var roleIds = roleIdStr.split(',');
	$.ajax({
		url : '/identity/queryRoleList',
		type : 'post',
		data : {},
		success : function(data) {
			var content = '<div class="acount"><ul>';
			for ( var i = 0; i < data.rows.length; i++) {
				content += '<input type="checkbox" style="margin-right:5px;" name="role_cb"';
				for ( var j = 0; j < roleIds.length; j++) {
					if (data.rows[i].id == roleIds[j]) {
						content += ' checked="checked"';
					}
				}
				content += ' value="' + data.rows[i].id + '">'
						+ data.rows[i].name + '</li>';
			}
			content += '</ul></div>';
			$('#role').html(content);
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}

Account.toUserManage = function() {
	location.href = '/identity/initUserIndex';
}

Account.initRegion = function() {
	var provinceId = $('#p_id').val();
	var cityId = $('#c_id').val();
	$.ajax({
		url : '/identity/initRegion',
		type : 'post',
		data : {
			pid : 0
		},
		success : function(data) {
			var htmlContent = '<option value="">省份</option>';
			for ( var i = 0; i < data.length; i++) {
				htmlContent = htmlContent + '<option value="' + data[i].id
						+ '">' + data[i].name + '</option>';
			}
			$('#province').html(htmlContent);
			$('#province').val(provinceId == '0' ? '' : provinceId);
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
	if (provinceId != '' && provinceId != '0') {
		$.ajax({
			url : '/identity/initRegion',
			type : 'post',
			data : {
				pid : provinceId
			},
			success : function(data) {
				if (data.length > 0) {
					$('#span_city').show();
					var htmlContent = '<option value="">城市</option>';
					for ( var i = 0; i < data.length; i++) {
						htmlContent = htmlContent + '<option value="'
								+ data[i].id + '">' + data[i].name
								+ '</option>';
					}
					$('#city').html(htmlContent);
					$('#city').val(cityId);
				} else {
					$('#span_city').hide();
					$('#city').html('');
					$('#city').val('');
				}
			},
			error : function(XMLHttpRequest) {
			},
			complete:Public.sessionOut
		});
	} else {
		$('#span_city').hide();
		$('#city').html('');
		$('#city').val('');
	}
}

Account.initRegion4City = function() {
	$.ajax({
		url : '/identity/initRegion',
		type : 'post',
		data : {
			pid : $('#province').val()
		},
		success : function(data) {
			if (data.length > 0) {
				$('#span_city').show();
				var htmlContent = '<option value="">城市</option>';
				for ( var i = 0; i < data.length; i++) {
					htmlContent = htmlContent + '<option value="' + data[i].id
							+ '">' + data[i].name + '</option>';
				}
				$('#city').html(htmlContent);
			} else {
				$('#span_city').hide();
				$('#city').html('');
				$('#city').val('');
			}
		},
		error : function(XMLHttpRequest) {
		},
		complete:Public.sessionOut
	});
}
Account.saveAvatar=function(data){
        if(data){
            $("#img_avatar").attr("src",'/fs/user-avatar/'+data.id);
            $("#avatar").val(data.id);
        }
    };