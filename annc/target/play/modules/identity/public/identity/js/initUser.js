var adminFormat=function(value,rowData,rowIndex){
	var str='<a href="javascript:;" onclick="InitUser.editOneUserIndex('+rowData.id+');" class="btn_list_option"><span>编辑</span><a>';
//	if(rowData.activeFlag == '0'){
//	str+='<a href="javascript:;" onclick="InitUser.delOneUserIndex('+rowData.id+');" class="btn_list_option"><span>删除</span><a>';
//	}
	return str;
}
var InitUser  = {
		initOneUserIndex:function(){
			window.location.href = initOrEditUserUrl;
		},
		editOneUserIndex:function(uid){
			window.location.href = initOrEditUserUrl+"?uid="+uid;
		},
		delOneUserIndex:function(uid){
			$.messager.confirm('确认','您确定要删除此用户吗？',function(r){
			    if (r){
			        $.ajax({
						url : delInitUserUrl,
						dataType: "json",
						type: "post",
						data: {uid:uid},
						success: function(data){
							if(data=='1'){
								$.messager.alert("提示","删除用户成功",'info');   
								InitUser.reloads();
							}else{
								$.messager.alert("错误","删除用户出错",'error');
							}
						},
						complete:Public.sessionOut
					});
			    }
			});
		},
		uploadTemplate:function(){
			$.messager.confirm('确认','您确定要导入用户吗？（IDS已经存在的用户将被忽略）',function(r){
			    if (r){
			    	$('#templateForm').submit(); 
				}
			});
		},
		uploadSuccess:function(data){
			var dataObj = eval("(" + data + ")");
			if(dataObj.r == '1'){
				jQuery.messager.alert('提示',dataObj.msg == ''?'导入用户成功':dataObj.msg,'info');
			}else{
				jQuery.messager.alert('提示',dataObj.msg == ''?'导入用户失败':dataObj.msg,'error');
			}
			$('#xlsfile').val("");
			$('#fileTemplate').val("");
			this.reloads();
		},
		searchParams:function(){
			return {
				'user.certInfo.realname':$('#realname').val(),
				'user.idsNo':$('#ids').val(),
				'user.schoolInfo.departmentName':$('#department').val(),
				'user.schoolInfo.specialtyName':$('#specialty').val(),
				'type':$('#userType').val()
			};
		},
		searchUser:function(){
			this.initGrid();
		},
		initGrid:function(){
			var p = this.searchParams();
			$('#userList').datagrid({
				width:970,
				singleSelect:true,
				pagination:true,
				pageList:[15,50,100],
				pageSize:15,
				queryParams:p,
			    url:initUserListUrl,
			    loadMsg:"正在加载数据,请稍候...",
			    columns:[[
			        {field:'realname',title:'姓名',width:100,align:'center'},
			        {field:'ids',title:'IDS帐号',width:100,align:'center',nowrap:false},
			        {field:'idsNames',title:'IDS别名',width:100,align:'center',nowrap:false,formatter:function(value,rowData,rowIndex){
			        	var html = "";
			        	if(typeof(value) != "undefined" && value != ""){
			        		var values = value.split(",");
			        		for(var i = 0; i < values.length; i++){
			        			if(i == values.length - 1){
			        				html += values[i];
			        			}else{
			        				html += values[i] + "<br/>";
			        			}
			        		}
			        	}
			        	return html;
			        }},
			        {field:'role',title:'角色',width:60,align:'center'},
			        {field:'department',title:'院系',width:200,align:'center'},
			        {field:'specialty',title:'专业',width:200,align:'center'},
			        {field:'active',title:'激活状态',width:80,align:'center'},
			        {field:'admin',title:'管理',width:120,align:'center',formatter:adminFormat}
			    ]],
				onLoadSuccess:function(data){
					if(data.total=='-1'){						                       
						jQuery.messager.alert('提示','当前会话已过期，请重新登录','info');
					}
				},
				onLoadError:Public.sessionOut
			});
		},
		reloads:function(){
            $('#userList').datagrid('reload');
        }
}