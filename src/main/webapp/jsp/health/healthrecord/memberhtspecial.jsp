<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>"  type="text/javascript"></script>
<style type="text/css">
.advice_main table tr td span{float: right;text-align: right;}
</style>
<script type="text/javascript">
		var save_image = window.parent.save_image;
		var edit_image = window.parent.edit_image;
		$(function(){
			query();
			queryHtspecial();
	    	jQuery('#htspecialForm').validationEngine("attach",
	    			{
	    				promptPosition:"centerRight:0,-10",
	    				maxErrorsPerField:1,
	    				scroll:false,
	    				focusFirstField:false
	    				//binded:false,
	    				//showArrow:false,
	    			}
	    	);
			
		});
		function queryHtspecial(){
			var requestUrl = "/healthRecordAction/queryMemberHtSpecial.action";
			var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id
						+"&member_unit_type="+window.parent.member_unit_type;
		
			showScreenProtectDiv(1);
		    showLoading();
			xmlHttp = $.ajax({
				url: requestUrl,
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				complete:function(){
				    hideScreenProtectDiv(1);
			        hideLoading();
				},
				error:function(){
					$.alert('无权限');
				},success:function(response){
				    var modelMap = response.modelMap;
				    var memberHtSpecial = modelMap.memberHtSpecial;
				    if(memberHtSpecial != null){
				    	init_memberHtSpecial(memberHtSpecial);
				    }else{    	
				    	$("#htspecialForm"+" :input").attr("disabled",true);
				    	$("#htspecialForm .med_tab").find("a").css("display","none");
				    }
				}
			});
		}
		function init_memberHtSpecial(obj){
			$("#htspecialForm").jsonForForm({data:obj,isobj:true});
			$("input[name='is_use_medicine'][value='"+obj.is_use_medicine+"']").attr("checked",true);
			var medicalDetailTable = document.getElementById("med_table");
			//clearMedicalDetailTable(medicalDetailTable);
			var medicineTakenItems = obj.medicineTakenItems;
			if(medicineTakenItems != null){
				for(var k=0;k<medicineTakenItems.length;k++){
					var temp = medicineTakenItems[k];
					createMedicalDetailTable(medicalDetailTable,temp);
				}
			}
			
			$("#htspecialForm"+" :input").attr("disabled",true);
			//$("#htspecialForm .med_tab").find("a").attr("disabled",true);
			//$("#htspecialForm").find("#med_table a").attr("disabled",true);
			$("#htspecialForm .med_tab").find("a").css("display","none");
			$("#htspecialForm").find("#med_table a").css("display","none");
		}
		
		function query(){
			var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
			if(pointerStart<0)
	    		pointerStart = 0;
			var requestUrl = "/healthRecordAction/queryMemberHtSpecialList.action";
			var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id
						+"&member_unit_type="+window.parent.member_unit_type
						+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
		
			showScreenProtectDiv(1);
		    showLoading();
			xmlHttp = $.ajax({
				url: requestUrl,
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				complete:function(){
				    hideScreenProtectDiv(1);
			        hideLoading();
				},
				error:function(){
					$.alert('无权限');
				},success:function(response){
				    var modelMap = response.modelMap;
				    var memberHtSpecialList = modelMap.memberHtSpecialList;
					recordList = memberHtSpecialList;
					$.fn.page.settings.count = modelMap.recordTotal;
					page($.fn.page.settings.currentnum);
				}
			});
		}
		function clearHtspecialTable(table){
			while (table.rows[1]){
				table.deleteRow(1);
			}
		}
		
		function showData(){
			  var table = document.getElementById("htspecialTable");
			  clearHtspecialTable(table);
			  for(var i=0;i<$.fn.page.settings.currentsize;i++){
				  addHtspecialTable(table,i,recordList);
			  }
			  $("table.bPhistory_table tr:even").addClass("even");
			  $("table.bPhistory_table tr:odd").addClass("odd");
		}
		
		function addHtspecialTable(table,i,recordList){
			try{
				 var rowcount=table.rows.length;
				 var tr=table.insertRow(rowcount);
				 var id  = recordList[i].id;
				 td=tr.insertCell(0);
				 td.innerHTML = "&nbsp;&nbsp;&nbsp;" + (($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize + (i+1));
				 td=tr.insertCell(1);
				 td.innerHTML = recordList[i].ill_date;
				 
				 td=tr.insertCell(2);
				 td.innerHTML = recordList[i].is_use_medicine == 1?"是":"否";
				 
				 td=tr.insertCell(3);
				 td.innerHTML = recordList[i].sbp;
				 
				 td=tr.insertCell(4);
				 td.innerHTML = recordList[i].dbp;
				 
				 td=tr.insertCell(5);
				 td.nowrap="nowrap";
				 //td.innerHTML =  "<a href='javascript:void(0)' onclick='updateHtspecial("+i+")'>修改</a>|<a href='javascript:void(0)' onclick='deleteHtspecial("+i+")'>删除</a>";
				 td.innerHTML =  "<a href='javascript:void(0)' onclick='updateHtspecial("+i+")'>查看</a>";
			}catch(e){
	    		$.alert('数据加载错误');
	   		}
		}
		function clearMedicalDetailTable(table){
			while (table.rows[1]){
				table.deleteRow(1);
			}
		}
		function createMedicalDetailTable(table,obj){
			 var rowcount=table.rows.length;
			 var tr=table.insertRow(rowcount);
			 var td=tr.insertCell(0);
			 td.innerHTML = 	'<input type="text" onclick="showMedicine(this)" class="med_hour validate[required]" name="medicine_taken.name" readonly="readonly" data-prompt-position="topLeft:0,0" onblur="validateControl(this)"/>';
			 
			 $('input[name="medicine_taken.name"]',td).val(obj.name);
			 td=tr.insertCell(1);
			 td.innerHTML = '<input type="text" class="med_dosage validate[required,minSize[2],maxSize[12]]" name="medicine_taken.dosage" value="'+obj.dosage+'" data-prompt-position="topLeft:25,0" onblur="validateControl(this)"/>' ;
			 td=tr.insertCell(2);
			 td.innerHTML = '<input type="text" onclick="showHours(this)" class="med_hour validate[required]" name="medicine_taken.hours"  readonly="readonly" value="'+obj.take_time+'" data-prompt-position="topLeft:45,0" onblur="validateControl(this)"/>';
			
			 td=tr.insertCell(3);
			 td.innerHTML = '<a href="javascript:void(0)" onclick="deleteMed(this)">删除</a>';
			 td.nowrap="nowrap" ;
		}
		
		var Htspecial_popType;
		//显示输入窗口
		function updateHtspecial(index){
			$("#htspecial_record").attr("style","display:none");
			$("#add_htspecial").attr("style","display:block");
			
			$("#htspecialForm").clearForm();
			jQuery('#htspecialForm').validationEngine("hide");
			
			Htspecial_popType = "edit";
			$("#htspecialForm").jsonForForm({data:recordList[index],isobj:true});
			$("input[name='is_use_medicine'][value='"+recordList[index].is_use_medicine+"']").attr("checked",true);
			var medicalDetailTable = document.getElementById("med_table");
			clearMedicalDetailTable(medicalDetailTable);
			var medicineTakenItems = recordList[index].medicineTakenItems;
			if(medicineTakenItems != null){
				for(var k=0;k<medicineTakenItems.length;k++){
					var obj = medicineTakenItems[k];
					createMedicalDetailTable(medicalDetailTable,obj);
				}
			}
			
			$("#htspecialForm"+" :input").attr("disabled",true);
			$("#htspecialForm .med_tab").find("a").attr("disabled",true);
			$("#htspecialForm").find("#med_table a").attr("disabled",true);
			
			var btn_obj = document.getElementById("editHtspecialBtn");
			btn_obj.onclick = function(){edit_htSpecial(btn_obj);};
			$(btn_obj).find("img").attr("src",edit_image);
		}
		function addHtspecial(){
			//window.location.href = "modify_htspecial.jsp";
			
			$("#htspecial_record").attr("style","display:none");
			$("#add_htspecial").attr("style","display:block");
			
			$("#htspecialForm").clearForm();
			jQuery('#htspecialForm').validationEngine("hide");
			Htspecial_popType = "add";
			$("input[name='is_use_medicine'][value='1']").attr("checked",true);
			var medicalDetailTable = document.getElementById("med_table");
			clearMedicalDetailTable(medicalDetailTable);
			
		}
		
		function closeDiv_htspecial() {
			$("#htspecialWindow").hide(200);
			$("#medicine").hide(200);
			$("#med_hours").hide(200);
			hideScreenProtectDiv(1);
		}
		
		function showHtspecialRecord(){
			$("#htspecial_record").css("display","block");
			$("#add_htspecial").css("display","none");
		}
		function showAddspecial(){
			$("#htspecial_record").css("display","none");
			$("#add_htspecial").css("display","block");
		}
		
		function saveHtspecial(obj){
			if(!jQuery('#htspecialForm').validationEngine('validate')) return false;
			var requestUrl = "/healthRecordAction/addMemberHtSpecial.action";
			var para  = $("#htspecialForm").dataForJson({prefix:''});
			var is_use_medicine = $("input[name='is_use_medicine']:checked").val();
			para += "&is_use_medicine=" + is_use_medicine;
			para += "&member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id
					+"&member_unit_type="+window.parent.member_unit_type;
			para += "&operator_unit_id=" + window.parent.doctor_unit_id + "&operator_cluster_id=" + window.parent.doctor_cluster_id + "&operator_unit_type=" + window.parent.doctor_unit_type;
			para += "&detail="+getMedicineXml();

			//if(Htspecial_popType == "edit"){
				//requestUrl = "/healthRecordAction/updateMemberHtSpecial.action";
			//}
			
			
			showScreenProtectDiv(2);
		    showLoading();
			xmlHttp = $.ajax({
				url: requestUrl,
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				complete:function(){

				},
				error:function(){
					$.alert('无权限');
				},success:function(response){
				    hideScreenProtectDiv(2);
			        hideLoading();
				    var modelMap = response.modelMap;
				    var state = modelMap.state;
				    if(state == "1"){
				    	$.alert('保存成功！');
				    	//if(Htspecial_popType == "add"){
							$.fn.page.settings.realcount++;
							$.fn.page.settings.currentnum = 1;
							
							$("#htspecialForm"+" :input").attr("disabled",true);
							//$("#htspecialForm .med_tab").find("a").attr("disabled",true);
							//$("#htspecialForm").find("#med_table a").attr("disabled",true);
							$("#htspecialForm .med_tab").find("a").css("display","none");
							$("#htspecialForm").find("#med_table a").css("display","none");
							obj.onclick = function(){edit_htSpecial(obj);};
							$(obj).find("img").attr("src",edit_image);
				    	//}
				    	//closeDiv_htspecial();
				    	//showHtspecialRecord();
				    	query();
				    }else if(state == "0"){
				    	$.alert('保存失败！');
				    }
				}
			});
		}
		
		function deleteHtspecial(index){
			$.confirm("确认删除该数据",function(){
				var id = recordList[index].id;
			
				var requestUrl = "/healthRecordAction/deleteMemberHtSpecial.action";
				var para = "id="+id;
				showScreenProtectDiv(2);
			    showLoading();
				xmlHttp = $.ajax({
					url: requestUrl,
					async:true,
					data:para,
					dataType:"json",
					type:"POST",
					complete:function(){

					},
					error:function(){
						$.alert('无权限');
					},success:function(response){
					    hideScreenProtectDiv(2);
				        hideLoading();
					    var modelMap = response.modelMap;
					    var state = modelMap.state;
					    if(state == "1"){
					    	$.alert('删除成功！');
					    	$.fn.page.settings.realcount-=1;
							pagemodify("del");
					    	query();
					    }else if(state == "0"){
					    	$.alert('删除失败！');
					    }
					}
				});
			},function(){});	
		}
		
		
		function addMed(){
			var flag = false;
			jQuery('#med_table input').each(function(index,obj){
				if(jQuery(obj).validationEngine('validate')){
					flag = true;
				}
			});
			if(flag == true){
				$.alert("请填写信息完整后再继续添加");
				return false;
			}
			
			var delBtn='<a href="javascript:void(0)" onclick="deleteMed(this)">删除</a>';
			$("#med_table").append('<tr>'
							+'<td>'
								+'<input type="text" onclick="showMedicine(this)" class="med_hour validate[required]" name="medicine_taken.name" readonly="readonly" data-prompt-position="topLeft:0,0" onblur="validateControl(this)"/>'
							+'</td>'
							+'<td>'
								+'<input type="text" class="med_dosage validate[required,minSize[2],maxSize[12]]" name="medicine_taken.dosage" data-prompt-position="topLeft:25,0" onblur="validateControl(this)"/>' 
							+'</td>'
							+'<td>'
								+'<input type="text" onclick="showHours(this)" class="med_hour validate[required]" name="medicine_taken.hours"  readonly="readonly" data-prompt-position="topLeft:45,0" onblur="validateControl(this)"/>'
							+'</td>'
							+'<td nowrap="nowrap" >'
								+delBtn	
							+'</td>'
						+'</tr>');
		}
		function validateControl(obj){
			jQuery(obj).validationEngine('validate');
		}
		
		function deleteMed(obj){
			$(obj).parent().parent().remove(); 
		}		
		
		function showHours(obj){
			var inputs=$("#hour_med input");
			for(var j=0;j<inputs.length;j++){
				inputs[j].checked="";
			}
			var i=$(obj).parent().parent().index();
			$("#rowIndex").val(i);
			var hour=$(obj).val();
			if(hour!=null&&hour!=""){
				var hours=hour.split("/");
				for(var i=0;i<hours.length;i++){
					var lis=$("#hour_med input");
					for(var j=0;j<lis.length;j++){
						if(lis[j].value==hours[i]){
							lis[j].checked="checked";
						}
					}
				}
			}//文本框赋值
	  		$("#med_hours").draggable({
				disabled : false
			});
			$("#med_hours").show(200);
			showScreenProtectDiv(1);
		}
		
		//关闭窗口
		function closeHours() {
			var i=$("#rowIndex").val();
			i=parseInt(i)-1;
			var hours="";
			$('#med_hours input[type="checkbox"]:checked').each(function(index){
				if(hours=="")
					hours+=$(this).val();
	            else hours+="/"+$(this).val();
	        });
	        $('input[name="medicine_taken.hours"]').each(function(index){
	        	if(index==i){
	        		$(this).val(hours);
	        	}
	        });
			$("#med_hours").hide(200);
			hideScreenProtectDiv(1);
		}
		
		//关闭窗口
		function closeMedicine() {
			var i=$("#rowIndex").val();
			i=parseInt(i)-1;
			var len = $("#faceTable :checkbox:checked[name=med_id]").length;
			if(len <=0){
				$.alert('请先选择一项！');
				return false;
			}
			if(len > 1){
				$.alert('只能选择一项！');
				return false;
			}
			var name = $("#faceTable :checkbox:checked[name=med_id]").val();
			var inputs=$("#faceTable input[name=med_id]");
			for(var j=0;j<inputs.length;j++){
				inputs[j].checked="";
			}
	        $('input[name="medicine_taken.name"]').each(function(index){
	        	if(index==i){
	        		$(this).val(name);
	        	}
	        });
			$("#medicine").hide(200);
			hideScreenProtectDiv(1);
		}
		
		function getMedicineXml(){
			var medicine="<medicine_taken>";
			var medicalDetailTable = document.getElementById("med_table");
			var rowcount=medicalDetailTable.rows.length;
			for(var i=1;i<rowcount;i++){
				var name=$('input[name="medicine_taken.name"]',medicalDetailTable.rows[i]);
				var fre=$('input[name="medicine_taken.dosage"]',medicalDetailTable.rows[i]);
				var hour=$('input[name="medicine_taken.hours"]',medicalDetailTable.rows[i]);
				var item="<item>"+
							"<name>"+name.val()+"</name>"+
							"<dosage>"+fre.val()+"</dosage>"+
							"<take_time>"+hour.val()+"</take_time>"+
							"</item>";
				medicine+=item;
			}
			medicine+="</medicine_taken>";
			return medicine;
		}
		
		var medical_obj;
		function showMedicine(obj){
			var url = "medicine.jsp";
			//返回选择的用户信息
			//var medicine_name = window.showModalDialog( url , obj.value , "dialogWidth=750px;dialogHeight=550px;scroll=no") ;
			//if(medicine_name != undefined && medicine_name != null){
			//	obj.value = medicine_name;
			//}
			medical_obj = obj
			window.open( url ,'eeeee','fullscreen=no, resizable=no, status=no, z-look=yes, titlebar=no, scrollbars=no, toolbar=no, menubar=no, location=no, top=200, left=200, width=750, height=550') ;
		}
		
		function edit_htSpecial(obj){
			$("#htspecialForm"+" :input").attr("disabled",false);
			//$("#htspecialForm .med_tab").find("a").attr("disabled",false);
			//$("#htspecialForm").find("#med_table a").attr("disabled",false);
			$("#htspecialForm .med_tab").find("a").css("display","block");
			$("#htspecialForm").find("#med_table a").css("display","block");
			obj.onclick = function(){saveHtspecial(obj);};
			$(obj).find("img").attr("src",save_image);
		}
		
</script>
</head>
<body>
<div  style="display:none;height:500px;float:left; margin-top:24px;font-size:13px;font-family:微软雅黑;color:#5a5a5a;" id="htspecial_record" >
 <div class="search">
    <ul>
      <li class="criteria_search" style="height: 40px;">高血压专项</li>
      <li class="btn_search" style="height: 40px;"><a href="javascript:void(0)" onclick="showAddspecial()"> 返回</a></li> 
    </ul>
  </div>
  <div class="index_table">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table"  id="htspecialTable">
      <colgroup>
        <col width="10%" />
        <col width="20%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="40%" />
      </colgroup>
      <tr>
      	<th nowrap="nowrap">序号</th>
        <th nowrap="nowrap" >患高血压日期</th>
        <th nowrap="nowrap" >是否接受过降压治疗</th>
        <th nowrap="nowrap" >最高收缩压</th>
        <th nowrap="nowrap" >最高舒张压</th>
        <th nowrap="nowrap" >操作</th>
      </tr>
    </table>
  </div>
  

<script type="text/javascript">
		var reg = /^[1-9]{6,16}/; 
		
		function gotoPage(){
			var num = $.trim($("#gopage").val());
			if(num==''){
				$.alert('请输入页码');
				$("#gopage").focus();
				return false;
			}
			if(!/^\d+$/.test(num)){
				$.alert('页码中包括非数字字符');
				$("#gopage").focus();
				return false;
			}
			if(num == '0') {
			    $.alert('页码不正确');
			    return false;
			}
			if(parseInt(num)>$.fn.page.settings.pagecount)
			{
				$.alert('无效的页码');
				$("#gopage").focus();
				return false;
			}
			pageClick(num);
		}
	</script>

<!-- 
<div id="sjxx">共 <span style="font-weight:bold; color:#000;" id="showcount"></span> 条信息，当前：第 <span style="font-weight:bold;color:#000;" id="showcurrentnum"></span> 页 ，共 <span style="font-weight:bold;color:#000;" id="showpagecount"></span> 页</div>
<div id="fanye" >
<input type="button" value="首页" class="button_fy page-first" />
<input type="button" value="上一页" class="button_fy page-perv" />
<input type="button" value="下一页" class="button_fy page-next" />
<input type="button" value="末页" class="button_fy page-last" style="margin-right:15px;" /> 
 转到<input id="gopage" type="text" style="border:1px solid #bababa; width:30px; height:18px; margin:0 3px;text-align: center;" />
<input type="button" value="跳" class="button_fy" onclick="gotoPage()"/>
</div>
 -->
 
<div class="index_page">
  <ul>
    <li class="page_information">共<span  id="showcount"></span>条信息，当前：第<span  id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页</li>
    <li class="page_button">
	    <a href="###" class="page-first">首页</a>
	    <a href="###" class="page-perv">上一页</a>
	    <a href="###" class="page-next">下一页</a>
	    <a href="###" class="page-last">末页</a>
    </li>
    <li class="page_select">
    转<select id="gopage" onchange="gotoPage()">
    	</select>页
    </li>
  </ul>
</div>
</div>

<div  id="add_htspecial" >
<div class="detailed_information"  style="font-size:13px;font-family:微软雅黑">
     <div class="btn_title_informationModify">
       <ul>
         <li class="tLeft">高血压专项</li>
         <li class="tRight">
         	<a href="javascript:void(0)" onclick="edit_htSpecial(this)" id="editHtspecialBtn"><img src="/images/button/btn_editor.png" /></a>
         	<!-- <a href="javascript:void(0)" onclick="showHtspecialRecord()"><img src="/images/button/btn_his.png" /></a> -->
         </li>
       </ul>
	</div>
</div>

<div class="bp_history"  >
<form id="htspecialForm" > 
  	<input type="hidden" name="id"  id="id"  />

	<div class="advice"  >
    <div class="advice_main" >
    	<table cellpadding="0" cellspacing="0" width="100%" class="adviceInfo" style="height: 600px;padding-left: 10px">
    		
    		<tr>
    			<td width="130px"><span>*患高血压日期：</span></td>
    			<td align="left">
    			<input class="inputMin_informationModify text-input validate[required]" type="text"  id="ill_date"  name="ill_date" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-%d'})" data-prompt-position="centerRight:0,-5"/>
    			</td>
    		</tr>
    		<tr>
    			<td width="130px"><span class="method">*是否用药：</span></td>
    			<td>
    				<input type="radio" name="is_use_medicine" value="1" checked="checked" />是
		            <input type="radio" name="is_use_medicine" value="0"/>否
    			</td>
    		</tr>
    		<tr>
    			<td width="130px"><span class="method">*疗效及副作用：</span></td>
    			<td>
	              		<textarea rows="10" cols="10" id="effect"  name="effect"  class="text-input validate[required,funcCall[includespecialchar]]"  data-prompt-position="topRight:-200,0"></textarea>
    			</td>
    		</tr>    		
    		<tr>
    			<td width="130px"><span class="method">*最高收缩压：</span></td>
    			<td>
					<input class="inputMin_informationModify text-input validate[required,funcCall[number2]]"  type="text"   id="sbp"  name="sbp"  maxlength="9"  data-prompt-position="centerRight:40,-5"/>mmHg
    			</td>
    		</tr>     	
    		<tr>
    			<td width="130px"><span class="method">*最高舒张压：</span></td>
    			<td>
						<input class="inputMin_informationModify text-input validate[required,funcCall[number2]]"  type="text"   id="dbp"  name="dbp"  maxlength="9"  data-prompt-position="centerRight:40,-5"/>mmHg
    			</td>
    		</tr>     
    		<tr>
    			<td width="130px"><span class="method">血压等级：</span></td>
    			<td>
						<select id="ht_level" style="width:100px">
							<option value="9">不详</option>
							<option value="1">一级高血压</option>
							<option value="2">二级高血压</option>
							<option value="3">三级高血压</option>
						</select>
    			</td>
    		</tr>
    		<tr>
    			<td width="130px"><span class="method">风险等级：</span></td>
    			<td>
						<select id="risk_level" style="width:100px">
							<option value="9">不详</option>
							<option value="1">低危</option>
							<option value="2">中危</option>
							<option value="3">高危</option>
							<option value="4">超高危</option>
						</select>
    			</td>
    		</tr>  			
    		<tr>
    			<td width="130px" valign="top"><span class="method">*当前服用药物：</span></td>
    			<td>
    				<div class="medicine"  style="overflow-y:auto;position:relative;height: 350px">
    					<div class="med_tab">
    						<a href="javascript:void(0)" onclick="addMed()">继续添加</a> 
    					</div>
    					<table cellpadding="0" cellspacing="0" width="100%" class="med_table2" id="med_table">
    						<colgroup>
						        <col width="20%" />
						        <col width="30%" />
						        <col width="30%" />
						        <col width="20%" />
						    </colgroup>
    						<tr>
    							<th>*药物名称</th>
    							<th>*剂量(mg或g)</th>
    							<th>*用药时间</th>
    							<th>&nbsp;</th>
    						</tr>
    					</table>
    				</div>
    			</td>
    		</tr>
    		<tr>
    			<td width="130px">&nbsp;</td>
    			<td>&nbsp;</td>
    		</tr>
    		<!-- 
    		<tr>
    			<td colspan="2">
    				<ul>
    					<li class="btn_search" style="float: left;"><a href="javascript:void(0)" onclick="saveHtspecial()">保存</a></li>
    					<li class="btn_search" style="float: left;"><a href="javascript:void(0)" onclick="showHtspecialRecord()">返回列表</a></li> 
    				</ul>
    			</td>
    		</tr>
    		-->
    	</table>
    </div>
  </div>                        
  </form>
 </div> 
 </div>


<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<style type="text/css">
.tgreen_bp{
	background:url(../images/icon/greenMax.png) right center no-repeat;
	width:100%;
	text-align:left; 
	float:left; 
	height:auto; 
	color:#5a5a5a; 
	border-bottom:1px dotted #aeaeae;
}
.hour{margin: 0 0 0 30px;}
</style>
<script type="text/javascript">
//关闭窗口
function closeHours() {
	var i=$("#rowIndex").val();
	i=parseInt(i)-1;
	var hours="";
	$('#med_hours input[type="checkbox"]:checked').each(function(index){
		if(hours=="")
			hours+=$(this).val();
           else hours+="/"+$(this).val();
       });
       $('input[name="medicine_taken.hours"]').each(function(index){
       	if(index==i){
       		$(this).val(hours);
       		jQuery(this).validationEngine('validate');
       	}
       });
	closeHoursDiv();
}
function closeHoursDiv(){
	$("#med_hours").hide(200);
	hideScreenProtectDiv(1);
}
</script>
</head>

<body>
	<input type="hidden" id="rowIndex" />
	<div class="popup" id="med_hours" style="display:none;position:absolute;top:300px; left:100px;z-index: 6000;">
		<div class="popup_header">
			<ul>
	      		<li class="name_popupHeader">用药时间</li>
	      		<li class="close_popupHeader"><a href="javascript:void(0)" onclick=""></a></li>
	    	</ul>
	  	</div>
	  
	  	<div class="popup_main">
	    	<ul>
		   		<li class="tgreen_bp" >
   					<div class="hour" id="hour_med">
   						<input type="checkbox" value="00:00"/> 00:00 &nbsp;
   						<input type="checkbox" value="01:00"/> 01:00 &nbsp;
   						<input type="checkbox" value="02:00"/> 02:00 &nbsp;
   						<input type="checkbox" value="03:00"/> 03:00 &nbsp;
   						<input type="checkbox" value="04:00"/> 04:00 &nbsp;
   						<input type="checkbox" value="05:00"/> 05:00 <br/>
   						<input type="checkbox" value="06:00"/> 06:00 &nbsp; 
   						<input type="checkbox" value="07:00"/> 07:00 &nbsp;
   						<input type="checkbox" value="08:00"/> 08:00 &nbsp;
   						<input type="checkbox" value="09:00"/> 09:00 &nbsp;
   						<input type="checkbox" value="10:00"/> 10:00 &nbsp;
   						<input type="checkbox" value="11:00"/> 11:00 <br/>
   						<input type="checkbox" value="12:00"/> 12:00 &nbsp;
   						<input type="checkbox" value="13:00"/> 13:00 &nbsp;
   						<input type="checkbox" value="14:00"/> 14:00 &nbsp;
   						<input type="checkbox" value="15:00"/> 15:00 &nbsp;
   						<input type="checkbox" value="16:00"/> 16:00 &nbsp;
   						<input type="checkbox" value="17:00"/> 17:00 <br/>
   						<input type="checkbox" value="18:00"/> 18:00 &nbsp;
   						<input type="checkbox" value="19:00"/> 19:00 &nbsp;
   						<input type="checkbox" value="20:00"/> 20:00 &nbsp;
   						<input type="checkbox" value="21:00"/> 21:00 &nbsp;
   						<input type="checkbox" value="22:00"/> 22:00 &nbsp;
   						<input type="checkbox" value="23:00"/> 23:00 &nbsp;
   					</div>
    			</li>
		   		<li class="btn_popup_confirm" style="width: 65%;padding-left: 35%">
		   			<a id="closeTips" href="javascript:void(0)" onclick="closeHours();">确定</a>
		   			<a id="closeDiv" href="javascript:void(0)" onclick="closeHoursDiv();">取消</a>
		   		</li>
			</ul>
	  	</div>
	</div>
</body>
</html>

</body>
</html>