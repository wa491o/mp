var Domain={};

//初始化tab
Domain.status="";
Domain.firstLoad = true;
Domain.initTab=function(){
	$("#app_tabs").delegate("li","click",function(){
		var status=$(this).attr("data-tab");
		$(this).siblings().removeClass("tabTitle-selected");
		$(this).addClass("tabTitle-selected");
		Domain.status=status;
		Domain.getDataList(status);
	});
	$(".tabTitle-selected").click();
}

//初始化列表
Domain.getDataList=function(status){
	var initColumns;
	var initToolBar;
	var url;
	if("domain"==status){
//		if (Domain.firstLoad){
//			Domain.firstLoad = false;
//		} else {
//			location.reload();
//		}
		initColumns=[[
		  			{field:'key',title:'产品域代码',width:300,align:'center'},
					{field:'name',title:'产品域名称',width:300,align:'center'},
					{field:'action',title:'操作',width:270,align:'center',
						formatter:function(value,rowData,rowIndex){
							var str='<a href="javascript:;" title="编辑" onclick="Domain.editDomain(\''+rowData.id+'\',\''+rowData.key+'\',\''+rowData.name+'\');" class="btn_list_option"><span>编辑</span></a><a href="javascript:;" title="配置" onclick="Domain.configDomain(\''+rowData.id+'\');" class="btn_list_option"><span>配置</span></a>';
							return str;
						}}
				    ]];
		initToolBar="#tb";
		url=Domain.getDomainListUrl;
	}else if("school"==status){
		initColumns=[[
		  			{field:'code',title:'学校代码',width:100,align:'center'},
					{field:'name',title:'学校名称',width:350,align:'center'},
					{field:'region',title:'地区',width:350,align:'center'},
					{field:'action',title:'操作',width:100,align:'center',
						formatter:function(value,rowData,rowIndex){
							var str='<a href="javascript:;" title="编辑" onclick="Domain.editSchool(\''+rowData.id+'\',\''+rowData.code+'\',\''+rowData.name+'\','+rowData.regionId+','+rowData.regionPid+');" class="btn_list_option"><span>编辑</span></a>';
							return str;
						}}
				    ]];
		initToolBar=[{
			id:'btnAdd',
			text:'添加学校',
			iconCls:'icon-add',
			handler:function(){
				$("#region1Div").css('display','none');
				Domain.editSchool('');
			}
		}];
		url=Domain.getSchoolListUrl;
	}else if("campus"==status){
		initColumns=[[
					{field:'name',title:'校区名称',width:300,align:'center'},
					{field:'schoolName',title:'所属学校',width:300,align:'center'},
					{field:'action',title:'操作',width:270,align:'center',
						formatter:function(value,rowData,rowIndex){
							var str='<a href="javascript:;" title="编辑" onclick="Domain.editCampus(\''+rowData.id+'\',\''+rowData.name+'\',\''+rowData.schoolCode+'\',\''+rowData.schoolName+'\');" class="btn_list_option"><span>编辑</span></a>';
							return str;
						}}
				    ]];
		initToolBar=[{
			id:'btnAdd',
			text:'添加校区',
			iconCls:'icon-add',
			handler:function(){
				$("#region1Div").css('display','none');
				Domain.editCampus('');
			}
		}];
		url=Domain.getCampusListUrl;
	}else if("domainCampus"==status){
		initColumns=[[
			  			{field:'domain',title:'产品域',width:250,align:'center'},
						{field:'school',title:'学校',width:250,align:'center'},
						{field:'campus',title:'校区',width:250,align:'center'},
						{field:'action',title:'操作',width:170,align:'center',
							formatter:function(value,rowData,rowIndex){
								var str='<a href="javascript:;" title="编辑" onclick="Domain.editDomainCampus(\''+rowData.id+'\',\''+rowData.schoolId+'\',\''+rowData.domainId+'\',\''+rowData.campusId+'\');" class="btn_list_option"><span>编辑</span></a>';
								return str;
							}}
					    ]];
		initToolBar=[{
						id:'btnAdd',
						text:'添加校区与产品域关联',
						iconCls:'icon-add',
						handler:function(){
							Domain.editDomainCampus('');
						}
					}];
		url=Domain.getDomainCampusListUrl;
	}
	
	$('#dataTable').datagrid({
		width:952,
		nowrap: false,
		striped: true,
		collapsible:false,	
		remoteSort: false,
		pagination:true,
		singleSelect:true,
		pageList:[10],
		queryParams:{},
		url:url,
		columns:initColumns,
		toolbar:initToolBar,
		onLoadSuccess:function(data){
			
		},
		onLoadError:Public.sessionOut
	});
	
	$("#domainConfigs").on("change",function(){
		$.messager.confirm('确认','导入的记录将会覆盖原记录，确定？',function(r){
		    if (r){
		    	$.messager.progress({title:'请稍后',msg:'上传中,请稍后',interval:50});
		    	setTimeout(function(){ $.messager.progress('close');},550);
		    	$("#exportForm").submit();
		    }
		});
	});
}

//编辑产品域
Domain.editDomain=function(id,key,name){
	var title='';
	if(id==''){
		title='添加产品域';
		$('#domainId').val('');
		$('#domainKey').val('');
		$('#domainName').val('');
	}else{
		title='编辑产品域';
		$('#domainId').val(id);
		$('#domainKey').val(key);
		$('#domainName').val(name);
	}
	$('#createDiv').css('display','block');
	$('#createDiv').dialog({
		modal: true,
		title: title,
		width:400,
		height:250,
		closable:true,
		resizable:false,
		shadow: true,
		onClose:function(){
			$('#createDiv').css('display','none');
		}
    });	
}

//编辑学校
Domain.editSchool=function(id,code,name,regionId,regionPid){
	var title='';
	if(id==''){
		title='添加学校';
		$('#schoolIdforSchool').val('');
		$('#schoolCode').val('');
		$('#schoolName').val('');
	}else{
		title='编辑学校';
		$('#schoolIdforSchool').val(id);
		$('#schoolCode').val(code);
		$('#schoolName').val(name);
	}
	$("#region1Div").css('display','none');
	$("#region1").html("");
	$('#createSchoolDiv').css('display','block');
	$('#createSchoolDiv').dialog({
		modal: true,
		title: title,
		width:400,
		height:350,
		closable:true,
		resizable:false,
		shadow: true,
		onClose: function(){
			$('#createSchoolDiv').css('display','none');
		}
    });
	
	if(regionId !=0 && regionPid==0){
		Domain.getRegionList("region0", 0, regionId, 0);
	}else{
		Domain.getRegionList("region0", 0, regionPid, 0);
	}
	
	if(regionId !=0 && regionPid > 0){
		$("#region1Div").css('display','');
		Domain.getRegionList("region1", regionPid, regionId, 1);
	}
}

//编辑校区
Domain.editCampus=function(id, name, schoolCode, schoolName){
	var title='';
	if(id==''){
		title='添加校区';
		$('#campusIdForCampus').val('');
		$('#campusSchoolCode').val('');
		$('#campusSchoolName').html('');
		$('#campusName').val('');
	}else{
		title='编辑校区';
		$('#campusIdForCampus').val(id);
		$('#campusSchoolCode').val(schoolCode);
		$('#campusSchoolName').html(schoolName);
		$('#campusName').val(name);
	}
	$('#createCampusDiv').css('display','block');
	$('#createCampusDiv').dialog({
		modal: true,
		title: title,
		width:400,
		height:350,
		closable:true,
		resizable:false,
		shadow: true,
		onClose: function(){
			$('#createCampusDiv').css('display','none');
		}
    });
}

/**
 *  获得地区节点
 *  @param pid 地区列表的父节点
 *  @param regionId 当前需要选中节点
 *  @param level 级别
 */
Domain.getRegionList = function(div, pid, regionId, level){
	$("#" + div).html("");
	$.ajax({
		type: "POST",
		url: Domain.getgetRegionListUrl,
		dataType: "json",
		data: {pid: pid},
		success: function(o){
			if(typeof(o.regionList) != undefined && typeof(o.regionList) != "undefined"){
				var region0Html = "";
				if(o.regionList.length > 0){
					if(pid > 0) $("#region1Div").css('display','');
					if(level == 0){
						region0Html = "<select class='noSelectClass' onchange='Domain.changeRegion0()'>";
					}else{
						region0Html = "<select class='noSelectClass'>";
					}
					region0Html += "<option value=''>请选择</option>";
					var selected = ""
					for(var i=0; i<o.regionList.length; i++){
						if(regionId == o.regionList[i].id){
							selected = "selected"
						}else{
							selected = "";
						}
						region0Html += "<option "+selected+" value='" +o.regionList[i].id+ "' >"+o.regionList[i].name+"</option>";
					}
					region0Html += "</select>";
				}else{
					$("#region1Div").css('display','none');
				}
				$("#" + div).html(region0Html);
			}
		}
	});
};

/**
 * 切换省自治区.
 */
Domain.changeRegion0 = function(){
	var selects = $('.noSelectClass');
	$("#region1Div").css('display', 'none');
	if(selects.length > 0){
		var id = $(selects[0]).val();
		Domain.getRegionList("region1", id, 0, 1);
	}
};

Domain.configDomainInit = function(){
	$("#recreate").click(function(){
		location.href = Domain.configsUrl + "?domainId="+$("#targetDomainId").val();
	});
	$("#copyFormExist").click(function(){
		$("#createMethodSelect").dialog('close');
		$('#chooseSourceDomain').show();
		$("#chooseSourceDomain").dialog({
			modal: true,
			title: "选择你要复制的源",
			width:300,
			height:110,
			closable:true,
			resizable:false,
			shadow: true,
			onClose:function(){
				$('#chooseSourceDomain').hide();
			}
	    });	
	});
	
	var confirming = false;
	$("#confirmSource").click(function(){
		if (!confirming){
			var source = $("#chooseSourceDomain select").val();
			var target = $("#targetDomainId").val();
			confirming = true;
			$.post(Domain.copyConfigsUrl+"?source="+source+"&target="+target,function(){
				location.href = Domain.configsUrl + "?domainId=" + target;
			});
		}
	});
	$("#cancelSource").click(function(){
		$("#chooseSourceDomain").dialog('close');
	});
}

Domain.configDomain=function(domainId){
	var configed = false;
	$.ajax({
		type : "GET",
		url : Domain.isConfigedUrl+"?domainId="+domainId,
		async: false,
		success : function(res){
			configed = (res == 'true');
		}
	});
	if (configed){
		//goto edit page
		location.href = Domain.configsUrl + "?domainId="+domainId;
	} else {
		$.ajax({
			type : "GET",
			url : Domain.getConfigedDomainsUrl,
			dataType: "json",
			success : function(res){
				if (res && res.length == 0){
					//goto edit page
					location.href = Domain.configsUrl + "?domainId="+domainId;
				} else {
					//show window and let we choose one to copy
					$("#targetDomainId").val(domainId);
					var selectHtml = "";
					for (var i = 0; i < res.length; i++) {
						var cd = res[i];
						selectHtml+= "<option value=\""+cd.id+"\">"+cd.name+"</option>";
					}
					$("#sourceContainer").html(selectHtml);
					
					$('#createMethodSelect').show();
					$("#createMethodSelect").dialog({
						modal: true,
						title: "配置创建方式选择",
						width:400,
						closable:true,
						resizable:false,
						shadow: true,
						onClose:function(){
							$('#createMethodSelect').hide();
						}
					})
				}
			}
		});
		
	}
}

Domain.cancelAdd=function(){
	$('#createDiv').dialog('close');
	$('#createDiv').css('display','none');
};

Domain.cancelAddSchool=function(){
	$('#createSchoolDiv').dialog('close');
	$('#createSchoolDiv').css('display','none');
};

Domain.cancelAddCampus=function(){
	$('#createCampusDiv').dialog('close');
	$('#createCampusDiv').css('display','none');
};

Domain.cancelAddDomainCampus=function(){
	$('#createDomainCampusDiv').dialog('close');
	$('#createDomainCampusDiv').css('display','none');
}

//保存产品域
Domain.saveDomain=function(){
	var domainId=$('#domainId').val();
	var domainKey=$('#domainKey').val();
	var domainName=$('#domainName').val();
	if(domainKey==''||domainName==''){
		jQuery.messager.alert('提示','产品域的key和名称不能为空','info');
		return;
	}
	$.ajax({	
		url:Domain.saveDomainUrl,
		type:'post',
		dataType: "json",
		data:{domainId:domainId,domainKey:domainKey,domainName:domainName},
		success:function(data){
			if(data.state=='1'){
				jQuery.messager.alert('提示','保存成功','info');
				Domain.getDataList(Domain.status);
				Domain.cancelAdd();
			}else{
				jQuery.messager.alert('提示',data.msg,'info');
			}
		},
		error: function() {
			jQuery.messager.alert('提示','服务器错误，请稍候再试','info');
		},
		complete:Public.sessionOut
	});	 
};

/**
 * 保存学校
 */
Domain.saveSchool=function(){
	var id = $('#schoolIdforSchool').val();
	var schoolCode = $('#schoolCode').val();
	var name = $('#schoolName').val();
	var region = "";
	var selects = $('.noSelectClass');
	if(selects.length > 0){
		region = $(selects[selects.length-1]).val();
	}
	if(schoolCode == "" || name == "" || region == ""){
		jQuery.messager.alert('提示','学校信息不完整','info');
		return;
	}
	
	$.ajax({	
		url:Domain.saveSchoolUrl,
		type:'post',
		dataType: "json",
		data:{schoolId:id,schoolCode:schoolCode,schoolName:name,regionId:region},
		success:function(data){
			if(data.state=='1'){
				jQuery.messager.alert('提示','保存成功','info');
				Domain.getDataList(Domain.status);
				Domain.cancelAddSchool();
			}else{
				jQuery.messager.alert('提示',data.msg,'info');
			}
		},
		error: function() {
			jQuery.messager.alert('提示','服务器错误，请稍候再试','info');
		},
		complete:Public.sessionOut
	});	 
};

/**
 * 保存校区
 */
Domain.saveCampus=function(){
	var id = $('#campusIdForCampus').val();
	var schoolCode = $('#campusSchoolCode').val();
	var name = $('#campusName').val();
	if(schoolCode == "" || name == ""){
		jQuery.messager.alert('提示','请填写校区所属学校的编码及校区名称','info');
		return;
	}
	
	$.ajax({	
		url:Domain.saveCampusUrl,
		type:'post',
		dataType: "json",
		data:{campusId:id,schoolCode:schoolCode,name:name},
		success:function(data){
			if(data.state=='1'){
				jQuery.messager.alert('提示','保存成功','info');
				Domain.getDataList(Domain.status);
				Domain.cancelAddCampus();
			}else{
				jQuery.messager.alert('提示',data.msg,'info');
			}
		},
		error: function() {
			jQuery.messager.alert('提示','服务器错误，请稍候再试','info');
		},
		complete:Public.sessionOut
	});	 
};

//编辑产品域与校区关联
Domain.editDomainCampus=function(id,schoolId,domainId,campusId){
	if(id==''){
		$('#domainCampusId').val('');
		$('#domainId2').val('');
		$('#schoolId').val('');
		$('#campusId').val('');
		
		$('#createDomainCampusDiv').css('display','block');
		$('#createDomainCampusDiv').dialog({
			modal: true,
			title: '添加校区与产品域',
			width:400,
			height:300,
			closable:true,
			resizable:false,
			shadow: true,
			onClose:function(){
				$('#createDomainCampusDiv').css('display','none');
			}
	    });	
	}else{
		$('#domainCampusId').val(id);
		$('#domainId2').val(domainId);
		$('#schoolId').val(schoolId);
		Domain.changeSchool(campusId);
	}
}

//保存产品域与校区关联
Domain.saveDomainCampus=function(){
	var domainCampusId=$('#domainCampusId').val();
	var domainId=$('#domainId2').val();
	var schoolId=$('#schoolId').val();
	var campusId=$('#campusId').val();
	if(domainId==''){
		jQuery.messager.alert('提示','请选择产品域','info');
		return;
	}
	if(schoolId==''){
		jQuery.messager.alert('提示','请选择学校','info');
		return;
	}
	if(campusId==''){
		jQuery.messager.alert('提示','请选择校区','info');
		return;
	}
	$.ajax({	
		url:Domain.saveDomainCampusUrl,
		type:'post',
		dataType: "json",
		data:{domainCampusId:domainCampusId,domainId:domainId,schoolId:schoolId,campusId:campusId},
		success:function(data){
			if(data.state=='1'){
				jQuery.messager.alert('提示','保存成功','info');
				Domain.getDataList(Domain.status);
				Domain.cancelAddDomainCampus();
			}else{
				jQuery.messager.alert('提示',data.msg,'info');
			}						
		},
		error: function() {
			jQuery.messager.alert('提示','服务器错误，请稍候再试','info');
		},
		complete:Public.sessionOut
	});	 
}


//根据学校获取校区
Domain.changeSchool=function(campusId){	
	$.ajax({	
		url:Domain.getCampusUrl,
		type:'post',
		dataType: "json",
		data:{schoolId:$('#schoolId').val()},
		success:function(data){
			var campusList=data.campusList;
			var str="<option value=''>请选择</option>";
			for(var i=0;i<campusList.length;i++){
				var campus=campusList[i];
				str+="<option value='"+campus.campusId+"'>"+campus.name+"</option>";
			}
			$('#campusId').empty().append(str);
			
			if(typeof(campusId)!='undefind'){
				$('#campusId').val(campusId);
				
				$('#createDomainCampusDiv').css('display','block');
				$('#createDomainCampusDiv').dialog({
					modal: true,
					title: '编辑校区与产品域',
					width:400,
					height:300,
					closable:true,
					resizable:false,
					shadow: true,
					onClose:function(){
						$('#createDomainCampusDiv').css('display','none');
					}
			    });	
			}else{
				$('#campusId').val('');
			}
		},
		error: function() {
			jQuery.messager.alert('提示','服务器错误，请稍候再试','info');
		},
		complete:Public.sessionOut
	});	 
}