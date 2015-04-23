var editIndex = undefined;
function endEditing(){
    if (editIndex == undefined){return true}
    if ($('#dg').datagrid('validateRow', editIndex)){
        var keyEd = $('#dg').datagrid('getEditor', {index:editIndex,field:'key'});
        var keyValue = $.trim($(keyEd.target).val());
        if (keyValue){
        	var allRows = $('#dg').datagrid('getRows');
        	for(var i = 0; i<allRows.length; i++){
				if (i!=editIndex && $.trim(allRows[i]['key'])== keyValue){
					$.messager.alert('警告','键不能重复');
            		return false;
				}
        	}
        	$('#dg').datagrid('endEdit', editIndex);
        	$('#dg').datagrid('getRows')[editIndex]['key'] = keyValue;
        	editIndex = undefined;
        	return true;
        }
    }
    $.messager.alert('警告','键不能为空');
    return false;
}
function onClickRow(index){
    if (editIndex != index){
        if (endEditing()){
            $('#dg').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#dg').datagrid('selectRow', editIndex);
        }
    }
}
function append(){
    if (endEditing()){
        $('#dg').datagrid('appendRow',{});
        editIndex = $('#dg').datagrid('getRows').length-1;
        $('#dg').datagrid('selectRow', editIndex)
                .datagrid('beginEdit', editIndex);
    }
}
function removeit(){
    if (editIndex == undefined){return}
    $('#dg').datagrid('cancelEdit', editIndex)
            .datagrid('deleteRow', editIndex);
    editIndex = undefined;
}
function accept(domainId){
    if (endEditing()){
        $('#dg').datagrid('acceptChanges');
        var allRows = $('#dg').datagrid('getRows');
        var configs = new Array();
        for (var i = 0; i<allRows.length; i++){
        	configs.push(allRows[i]);
        }
        $.ajax({
			url : DomainCfg.saveConfigsUrl,
			dataType: "json",
			type: "post",
			data: {
				'domainId':domainId,
				'configs':configs
			},
			complete: function(data){
				$.messager.show({
					msg:"保存成功",
					timeout:1000
				});
			}
		});
    }
}