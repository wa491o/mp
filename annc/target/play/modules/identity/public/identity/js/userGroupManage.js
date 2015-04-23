var Group=Group || {};
Group.requestUrl={};
Group.indexPage=function(){
	var clickAddGroup=$(".addGroup_btn"),
	groupTable=$("#groupTable"),
	roleName=$("#roleName"),
	roleNote=$("#roleNote"),
	roleNameEdit=$("#roleName_edit"),
	roleNoteEdit=$("#roleNote_edit"),
	editGroupDialog=$("#editGroupDialog"),
	clickEditGroupDialogConfirm=$(".editGroupDialog_confirm_btn"),
	clickEditGroupDialogCancel=$(".editGroupDialog_cancel_btn"),
	authSetDialog=$("#authSetDialog"),
	authSetDialogConfirm=$(".authSetDialog_confirm_btn"),
	authSetDialogCancel=$(".authSetDialog_cancel_btn"),
	
	getGroups=function(){
		var groupOpration=function(value,row,index){
			var str='<div class="optionDiv"><a href="javascript:;" class="btn_list_option authSet_btn" onclick="openAuthSetDialog(\''+row.id+'\')"><span>权限设定</span></a>'+
					'<a href="javascript:;" class="btn_list_option editGroup_btn" onclick="openEditDialog(\''+row.id+'\')"><span>编辑</span></a>'+
					'<a href="javascript:;" class="btn_list_option editGroup_btn" onclick="deleteGroup(\''+row.id+'\')"><span>删除</span></a>'+
					'</div>';
			return str;
		};
		groupTable.datagrid({
			width: 800,
			queryParams: {},
			url: Group.requestUrl.getGroupInfo,
			nowrap: false,
			striped: true,
			collapsible:true,	
			fitColumns:true, //是否列自动适应内容宽度
			remoteSort: false,
			pagination:false,
			singleSelect:true,
			columns:[[
				{field:'id',title:"组ID",width:80},
				{field:'name',title:"角色名称",width:150},
				{field:'userNum',title:"人数",width:100},
				{field:'description',title:"备注",width:200},
				{field:'manage',title:"管理",width:250,formatter:groupOpration}
			]],
			onLoadError:Public.sessionOut
		});
	},
	addGroup=function(){
		var name=$.trim(roleName.val()),
		note=$.trim(roleNote.val());
		if(!name){
			$.messager.alert("提示","请填写用户组名称！","info");
			return;
		}else if(name.length>10){
			$.messager.alert("提示","用户组名称不超过10个字！","info");
			return;
		}
		if(note && note.length>20){
			$.messager.alert("提示","备注不超过20个字！","info");
			return;
		}
		$.ajax({
			url:Group.requestUrl.addUserGroup,
			type:'post',
			data:{name:name,note:note},
			success:function(data){afterAddGroup(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	afterAddGroup=function(data){
		roleName.val("");
		roleNote.val("");
		groupTable.datagrid('reload');
	},
	saveGroupInfo=function(id){
		var name=$.trim(roleNameEdit.val());
		var note=$.trim(roleNoteEdit.val());
		if(!name){
			$.messager.alert("提示","请填写用户组名称！","info");
			return;
		}else if(name.length>10){
			$.messager.alert("提示","用户组名称不超过10个字！","info");
			return;
		}
		if(note && note.length>20){
			$.messager.alert("提示","备注不超过20个字！","info");
			return;
		}
		$.ajax({
			url:Group.requestUrl.updateGroupInfo,
			type:'post',
			data:{id:id,name:name,note:note},
			success:function(data){afterSaveGroup(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	}
	afterSaveGroup=function(data){
		groupTable.datagrid('reload');
		closeEditDialog();
		roleNameEdit.val("");
		roleNoteEdit.val("");
	},
	deleteGroup=function(id){
		$.messager.confirm('删除','确定删除该用户组？',function(r){
		    if (r){
		        $.ajax({
					url:Group.requestUrl.deleteUserGroup,
					type:'post',
					data:{id:id},
					success:function(data){afterDeleteGroup(data)},
					error: function(XMLHttpRequest) {},
					complete:Public.sessionOut
				});
		    }
		});
	},
	afterDeleteGroup=function(data){
		groupTable.datagrid('reload');
	},
	openEditDialog=function(id){
		editGroupDialog.dialog({
		    title: '编辑用户组',
		    width: 500,
			height:180,
		    closed: true,
		    cache: false,
		    modal: true,
			resizable:true,
			onclose:function(){editGroupDialog.hide()}
		});
		editGroupDialog.show();
		editGroupDialog.dialog('open');
		getGroupInfo(id);
		clickEditGroupDialogConfirm.unbind().click(function(){
			saveGroupInfo(id);
		});
		clickEditGroupDialogCancel.unbind().click(function(){
			closeEditDialog();
		});
	},
	closeEditDialog=function(){
		editGroupDialog.hide();
		editGroupDialog.dialog('close');
	},
	getGroupInfo=function(id){
		$.ajax({
			url:Group.requestUrl.editUserGroup,
			type:'post',
			data:{id:id},
			success:function(data){afterGetGroup(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	afterGetGroup=function(data){
		roleNameEdit.val(data.name);
		roleNoteEdit.val(data.description);
	},
	openAuthSetDialog=function(id){
		authSetDialog.dialog({
		    title: '权限设定',
		    width: 700,
			height:500,
		    closed: true,
		    cache: false,
		    modal: true,
			onclose:function(){authSetDialog.hide()}
		});
		authSetDialog.show();
		authSetDialog.dialog('open');
		getAuthInfo(id);
		authSetDialogConfirm.unbind().click(function(){
			saveAuthSet(id);
		});
		authSetDialogCancel.unbind().click(function(){
			closeAuthSetDialog();
		});
	},
	closeAuthSetDialog=function(){
		authSetDialog.hide();
		authSetDialog.dialog('close');
	},
	saveAuthSet=function(id){
		var ids=[];
		$(".auth_twoLevel input[type='checkbox']:checked").each(function(){
			ids.push($(this).attr('checkid'));
		});
		$.ajax({
			url:Group.requestUrl.saveGroupAuth,
			type:'post',
			data:{id:id,ids:ids},
			success:function(data){
				closeAuthSetDialog();
				groupTable.datagrid('reload');
			},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	getAuthInfo=function(id){
		$.ajax({
			url:Group.requestUrl.getModules,
			type:'post',
			data:{id:id},
			success:function(data){afterGetAuth(data)},
			error: function(XMLHttpRequest) {},
			complete:Public.sessionOut
		});
	},
	afterGetAuth=function(data){
		var str="" ,module=$("#authSetDialog_module");
		for(var i=0;i<data.module.length;i++){
			var item=data.module[i],roles=item.roles;
			str+='<div class="auth_oneLevel"><label><input type="checkbox" onclick="Group.indexPage.checkAll(\'child_'+item.name+'\',\'auth_'+item.name+'\')" name="auth_'+item.name+'" id="auth_'+item.name+'">'+item.title+'</label></div>';
			if(roles.length>0){
				str+='<div class="auth_twoLevel">';
				for(var j=0;j<roles.length;j++){
					var role=roles[j].role;
					str+='<label><input type="checkbox" checkid="'+role.id+'" name="child_'+item.name+'" onclick="Group.indexPage.chkSonClick(\'child_'+item.name+'\',\'auth_'+item.name+'\')"/>'+role.name+'</label>';
				}
				str+='</div>';
			}
		}
		module.empty().append(str);
		for (var i = 0; i < data.module.length; i++) {
			
		}
		for(var j=0;j<data.authList.items.length;j++){
			var item=data.authList.items[j];
			$('input[type=\'checkbox\'][checkid='+item.privilege+']').attr("checked","checked");
		}
	};
	return {
		init:function(){
			clickAddGroup.click(addGroup);
			getGroups();
		},
		/**
		 * 全选
		 * @param {Object} sonName
		 * @param {Object} cbAllId
		 */
		checkAll:function(sonName,cbAllId){
			var arrSon = document.getElementsByName(sonName);
			var cbAll = document.getElementById(cbAllId);
			var tempState=cbAll.checked;
			for(i=0;i<arrSon.length;i++) {
			if(arrSon[i].checked!=tempState)
			    arrSon[i].click();
			}
		},
		chkSonClick:function(sonName, cbAllId){
			var arrSon = document.getElementsByName(sonName);
		    var cbAll = document.getElementById(cbAllId);
		    for(var i=0; i<arrSon.length; i++) {
		        if(!arrSon[i].checked) {
			        cbAll.checked = false;
			        return;
		        }
		 	}
			cbAll.checked = true;
		},
		/**
		 * 全不选
		 * @param {Object} sonName
		 */
		chkOppClick:function(sonName){
			var arrSon = document.getElementsByName(sonName);
			for(i=0;i<arrSon.length;i++) {
				arrSon[i].click();
			}
		}
		
		
	}
}();
