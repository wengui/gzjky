/**
 * jQuery page Plugin 1.0.0
 *
 *	http://www.995120.cn
 *
 * Copyright (c) 2011 hellowin
 *
 */
jQuery.fn.page = function (options) {
	settings = jQuery.fn.page.settings;
	jQuery.extend(settings,options);
	return this.each(function(){
		settings.currentnum = parseInt(settings.currentnum,10);
		if(settings.count==0)
		{
			settings.pagecount=settings.currentnum=settings.currentsize=0;
		}
		if(settings.count<=settings.pagesize && settings.count>0){
			settings.pagecount=settings.currentnum=1;
			settings.currentsize=settings.count;
		}
		if(settings.count>0 && settings.currentnum==0)
			settings.currentnum=1;
		settings.pagecount = parseInt(settings.count/settings.pagesize);
		if(settings.count%settings.pagesize!=0)
			settings.pagecount=settings.pagecount+1;
		if(settings.currentnum>settings.pagecount)
			settings.currentnum=settings.pagecount;
			
		if(settings.count%settings.pagesize!=0){
			if(settings.currentnum!=settings.pagecount)
				settings.currentsize=settings.pagesize;
			else
				settings.currentsize=settings.count%settings.pagesize;
		}else{
			if(settings.count>0)
				settings.currentsize=settings.pagesize;
		}
		
		settings.realcount=settings.count;
		
		if(settings.pagecount>1 && settings.currentnum>1){
			$(".page-first").unbind().click(function(){
				destPage=1;
				settings.buttonClickCallback(destPage);
			});
			$(".page-perv").unbind().click(function(){
				destPage=parseInt(settings.currentnum)-1;
				settings.buttonClickCallback(destPage);
			});
		}else{
			$(".page-first").unbind("click");
			$(".page-perv").unbind("click");
		}
		
		if(settings.pagecount>1 && settings.currentnum<settings.pagecount){
			$(".page-next").unbind().click(function(){
				destPage=parseInt(settings.currentnum)+1;
				settings.buttonClickCallback(destPage);
			});
			$(".page-last").unbind().click(function(){
				destPage=settings.pagecount;
				settings.buttonClickCallback(destPage);
			});
		}else{
			$(".page-next").unbind("click");
			$(".page-last").unbind("click");
		}
		if(settings.count==0)
			settings.currentnum=settings.pagecount=1;
		refreshselect();
		settings.drawTable();
		pageInfo();
	});
};


var recordList = null;

//外部暴露参数
jQuery.fn.page.settings ={
	count:0,//总记录条数
	pagecount:0,//总页数
	pagesize:10,//每页显示条数
	currentnum:1,//当前页码
	currentsize:0,//当前页实际条数
	realcount:0//真实总记录数,增加删除时修改
};

	//清空表格
	function clearFaceTable(){
   		var table = document.getElementById("faceTable");
		while (table.rows[1]){
			table.deleteRow(1);
		}
	}
	
	//清空表格
	function clearFaceTableByTableName(tableName){
   		var table = document.getElementById(tableName);
		while (table.rows[1]){
			table.deleteRow(1);
		}
	}
	
	var isAddSuccess = 0;
    //关闭所有弹出的层
    function closeAllPopWindow(){ 
       if(isAddSuccess == 1){
       		pagemodify();
       		query();
       } 
       isAddSuccess = 0;
       clearPopWindow("popWindow");
       document.getElementById("divloading").style.display="none";      
       document.getElementById("transparentDiv").style.display="none";
       document.getElementById("transparentDiv2").style.display="none";
       document.getElementById("popWindow").style.display="none";         
    }
    
	//获取选择中记录
	function getNumRowsArray() {
		var data = document.getElementsByName("selectCheckbox");
		var k = 0;
		for(i = 0;i<data.length;i++){
			 if(data[i].checked == true)
			     k++;
		}
		if(k == 0){
			return null;
		}
	    if(numSelectedRows != "") return numSelectedRows.split(",");
	   return null;
	}
	
	//页面加载事件注册
	jQuery(function(){
	   jQuery("#selectAllCheckbox").unbind().click(
		function(){
           jQuery("[name='selectCheckbox']").attr("checked", this.checked);
			
	    });
   });
   
   function selectCheckBox(){
   		jQuery("input[name='selectCheckbox']:checked").length == jQuery("input[name='selectCheckbox']").length ? jQuery("#selectAllCheckbox").attr("checked", true) : jQuery("#selectAllCheckbox").attr("checked", false);
   }
   
	//页面修正
	function pagemodify(option){
		var pagecount = parseInt(jQuery.fn.page.settings.realcount/jQuery.fn.page.settings.pagesize);
		if(jQuery.fn.page.settings.realcount%jQuery.fn.page.settings.pagesize!=0)
			pagecount++;
		if(pagecount==0)
			pagecount = 1;
		if(option=="add"){//增加时
			jQuery.fn.page.settings.currentnum=pagecount;
		}else{//删除时
			if(pagecount<jQuery.fn.page.settings.currentnum){
				jQuery.fn.page.settings.currentnum=pagecount;
			}
		}
	}
		
	//刷新选择框
	function refreshselect(){
		jQuery("#pageSelector").empty();
		jQuery("#pageSelector").unbind().change(function(){
			jQuery.fn.page.settings.buttonClickCallback(this.value);
		});
		for(var i=1;i<=jQuery.fn.page.settings.pagecount;i++){
			jQuery("#pageSelector").append("<option value="+i+">"+i+"</option>");	
		}
		setTimeout(function(){
			jQuery("#pageSelector").val(jQuery.fn.page.settings.currentnum);
		});
	}
		
	//设定页面信息
	function pageInfo(){
		jQuery("#showcount").html(jQuery.fn.page.settings.count);//总记录数
		jQuery("#showpagecount").html(jQuery.fn.page.settings.pagecount);//总页数
		jQuery("#showpagesize").html(jQuery.fn.page.settings.pagesize);//分页条目数
		jQuery("#showcurrentnum").html(jQuery.fn.page.settings.currentnum);//当前页码
		jQuery("#showcurrentsize").html(jQuery.fn.page.settings.currentsize);//当前页实际条目数
		jQuery("#showcurrentAndCountPage").html(jQuery.fn.page.settings.currentnum+'/'+jQuery.fn.page.settings.pagecount);//当前页实际条目数
		
		jQuery("#showpagecount-txt").val(jQuery.fn.page.settings.pagecount);//总页数
		jQuery("#showcurrentnum-txt").val(jQuery.fn.page.settings.currentnum);//当前页码
		
	    $("#selectAllCheckbox").attr("checked", false);
	    
	    var num = $("#gopage").val();
	    $("#gopage").empty();
		for(var i=1;i<=jQuery.fn.page.settings.pagecount;i++){
			$("#gopage").append("<option value='"+i+"'>"+i+"</option>");
		}
		$("#gopage").val(jQuery.fn.page.settings.currentnum);
	}
	
	function clearPopWindow(id){
	jQuery('#'+id+' :text').val('');
	jQuery('#'+id+' :password').val('');
	jQuery('#'+id+' :radio').attr("checked", "");
	jQuery('#'+id+' textarea').html('');
	jQuery('#'+id+' select option:nth-child(1)').attr("selected","selected");
	jQuery('#'+id+' select[multiple] option').attr("selected","");
	jQuery('#'+id+' :checkbox').attr("checked", "");
	jQuery('#'+id+' :file').attr('src','');
}