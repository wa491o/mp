/**
 * @author whg
 */
var App= App || {};
App.category=function(){
	function saveCategory(id,name,desc){
		$.post(App.category.req.save,{id:id,name:name,desc:desc},function(data,textStatus){
			if(textStatus=="success"){
				if(data){
				    if(data.state=="1"){
				        closeEditDialog();
    					$("#appCatGrid").datagrid('reload');
				    }else{
				        $.messager.alert("提示",data.msg,"error");
				    }
				}else{
					$.messager.alert("提示","保存失败！","error");
				}
			}
		});
	};
	function delCategory(id){
		$.post(App.category.req.remove,{id:id},function(data,textStatus){
			if(textStatus=="success"){
				if(data && data=="1"){
					$("#appCatGrid").datagrid('reload');
				}else{
					$.messager.alert("提示","删除失败！","error");
				}
			}
		});
	};
	function updateCategory(id,status){
	    $.post(App.category.req.update,{id:id,status:status},function(data,textStatus){
            if(textStatus=="success"){
                if(data && data=="1"){
                    $("#appCatGrid").datagrid('reload');
                }else{
                    $.messager.alert("提示","操作失败！","error");
                }
            }
        });
	}
	function editCategory(rows){
	    $(".addCat-name").val("");
        $(".addCat-desc").val("");
		$(".addCatDialog").dialog({
		    title: '添加分类',
		    width: 400,
			height:200,
		    closed: false,
		    cache: false,
		    modal: true
		});
		$(".addCatDialog").show();
		var id="",name,desc;
		if(rows){
			id=rows.id;
			name=rows.name;
			desc=rows.description;
			$(".addCat-name").val(name);
			$(".addCat-desc").val(desc);
		}
		$(".addCat-yes").unbind().bind("click",function(){
			name=$(".addCat-name").val();
			desc=$(".addCat-desc").val();
			if(name.trim().length<=0){
				$.messager.alert("提示","请填写分类名称！","warning");
				return false;
			}else if(name.trim().length>20){
				$.messager.alert("提示","分类名称不要超过20个字！","warning");
				return false;
			}
			saveCategory(id,name,desc);
		});
	};
	function closeEditDialog(){
		$(".addCatDialog").dialog('close');
		$(".addCatDialog").hide();
	};
	function getAppCatList(keywords){
		$("#appCatGrid").datagrid({
			width: 900,
			url: App.category.req.getList,
			pagination:false,
			singleSelect:true,
			fitColumns:true,
			queryParams:{keywords:keywords},
			columns:[[
				{field:'id',title:"ID",width:50,align:"center"},
				{field:'name',width:330,title:"分类名称",align:"center"},
				{field:'description',title:"分类描述",width:380,align:"center"},
				{field:'option',title:"操作",width:120,align:"center",formatter:function(val,row,index){
				    var str='<div class="option"><a class="btn_list_option" href="javascript:;" onclick="App.category.edit('+index+')"><span>编辑</span></a>';
				    if(row.status =="ENABLED"){
				       str+='<a class="btn_list_option updateStatus" href="javascript:;" data-status="DISABLED" data-id="'+row.id+'"><span>禁用</span></a>';
				    }else{
				       str+='<a class="btn_list_option updateStatus" href="javascript:;" data-status="ENABLED" data-id="'+row.id+'"><span>启用</span></a>';
				    }
				    return str+"</div>";
					// return '<a class="btn_list_option" href="javascript:;" onclick="App.category.edit('+index+')"><span>编辑</span></a>'
							// +'<a class="btn_list_option" href="javascript:;" onclick="App.category.remove(\''+row.id+'\')"><span>删除</span></a>';		
				}},
			]],
			onLoadSuccess:function(data){
				if(data && data.state ==0){
					$.messager.alert("提示","加载数据错误","error");
				};
				$(".updateStatus").on("click",function(){
                    var id=$(this).attr("data-id");
                    var status=$(this).attr("data-status");
                    if(status=="DISABLED"){
                        $.messager.confirm("确认","确认禁用？",function(){
                            updateCategory(id,status);
                        });
                    }else{
                        updateCategory(id,status);
                    }
                });
			},
			onLoadError:Public.sessionOut
		});
	};
	function search(){
		var name=$(".categoryName").val().trim();
		getAppCatList(name);
	};
	//方法绑定
	$(".addCategory").bind("click",function(){
		editCategory();
	});
	$(".addCat-no").bind("click",function(){
		closeEditDialog();
	});
	$(".searchCategory").click(function(){
		search();
	});
	$(".categoryName").keypress(function(e){
		if(e.keyCode == 13){
			search();
		}
	});
	return {
		init:function(){
			getAppCatList();
		},
		edit:function(index){
			var rows=$("#appCatGrid").datagrid("getRows")[index];
			editCategory(rows);
		},
		remove:function(id){
			$.messager.confirm('确认','确定删除?',function(r){
			    if (r){
					delCategory(id);
			    }
			});	
		}
	};
	
}();