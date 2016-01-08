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
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet"  type="text/css"/>
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
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
<script type="text/javascript">
		$(function(){
	    	jQuery('#medicalExaminationForm').validationEngine("attach",
	    			{
	    				promptPosition:"centerRight:0,-10",
	    				maxErrorsPerField:1,
	    				scroll:false
	    				//binded:false,
	    				//showArrow:false,
	    			}
	    	);
			query();
		});
		function query(){
			var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
			if(pointerStart<0)
	    		pointerStart = 0;
			var requestUrl = "/healthRecordAction/queryMemberMedicalExaminationList.action";
			//var create_time = $("#create_time").val();
			var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id
						+"&member_unit_type="+window.parent.member_unit_type
						+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize
						//+"&create_time="+create_time;
		
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
				    var memberMedicalExaminationList = modelMap.memberMedicalExaminationList;
					recordList = memberMedicalExaminationList;
					$.fn.page.settings.count = modelMap.recordTotal;
					page($.fn.page.settings.currentnum);
				}
			});
		}
		function clearMedicalExaminationTable(table){
			while (table.rows[1]){
				table.deleteRow(1);
			}
		}
		
		function showData(){
			  var table = document.getElementById("medicalExaminationTable");
			  clearMedicalExaminationTable(table);
			  for(var i=0;i<$.fn.page.settings.currentsize;i++){
				  addMedicalExaminationTable(table,i,recordList);
			  }
			  $("table.bPhistory_table tr:even").addClass("even");
			  $("table.bPhistory_table tr:odd").addClass("odd");
		}
		
		function addMedicalExaminationTable(table,i,recordList){
			try{
				 var rowcount=table.rows.length;
				 var tr=table.insertRow(rowcount);
				 var id  = recordList[i].id;
				 var chxt = recordList[i].chxt;
				 var kfqxxt = recordList[i].kfqxxt;
				 var zdgc = recordList[i].zdgc;
				 var gmdzdbdgc = recordList[i].gmdzdbdgc;
				 var dmdzdbdgc = recordList[i].dmdzdbdgc;
				 var xqjq = recordList[i].xqjq;
				 var wlnbdb = recordList[i].wlnbdb;
				 tr.name = i;
				 td=tr.insertCell(0);
				 td.innerHTML = '<input type="checkbox" id="selectCheckbox" name="selectCheckbox" onclick="selectCheckBox(this)" value="'+id+'"/>'+'&nbsp;&nbsp;'+(($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize + (i+1));
				 td=tr.insertCell(1);
				 td.innerHTML = chxt+"mmol/L";
				 
				 td=tr.insertCell(2);
				 td.innerHTML = kfqxxt+"mmol/L";
				 
				 td=tr.insertCell(3);
				 td.innerHTML = zdgc+"mmol/L";
				 
				 td=tr.insertCell(4);
				 td.innerHTML = gmdzdbdgc+"mmol/L";
				 
				 td=tr.insertCell(5);
				 td.innerHTML = dmdzdbdgc+"mmol/L";
				 
				 td=tr.insertCell(6);
				 td.innerHTML = xqjq+"μmol/L";
				 
				 //td=tr.insertCell(7);
				 //td.innerHTML = wlnbdb+"mg/24h";
			}catch(e){
	    		$.alert('数据加载错误');
	   		}
		}
		
		//显示输入窗口
		function showMedicalExamintionDialog(obj){
		    var tt = "增加医学检查";
			$("#medicalExaminationForm").clearForm();
			jQuery('#medicalExaminationForm').validationEngine("hide");
			medicalExamination_popType = "add";
			
			if(obj == 1){
				medicalExamination_popType = "edit";
				tt = "编辑医学检查";
				
				var len = $("#medicalExaminationTable :checkbox:checked[name=selectCheckbox]").length;
  				if(len <=0){
					$.alert('请先选择一项！');
					return false;
				}
  				if(len > 1){
					$.alert('只能选择一项！');
					return false;
				}
  				var i = $("#medicalExaminationTable>tbody>tr:has(td:has(:checked[name=selectCheckbox])):last").prop("name");
				$("#medicalExaminationForm").jsonForForm({data:recordList[i],isobj:true});
				
			}
			
			$('#medicalExaminationWindow').draggable({
				disabled : true
			});
			$("#pop_medicalExaminationTitle").text(tt);
			$("#medicalExaminationWindow").show(200);
			showScreenProtectDiv(1);
		}
		function closeDiv_medicalExamination() {
			$("#medicalExaminationWindow").hide(200);
			hideScreenProtectDiv(1);
		}
		function saveMedicalExamination(){
			if(!jQuery('#medicalExaminationForm').validationEngine('validate')) return false;
			var requestUrl = "/healthRecordAction/addMemberMedicalExamination.action";
			var para  = $("#medicalExaminationForm").dataForJson({prefix:''});
			para += "&member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id
			+"&member_unit_type="+window.parent.member_unit_type;
			if(medicalExamination_popType == "edit"){
				requestUrl = "/healthRecordAction/updateMemberMedicalExamination.action";
			}else{
				para += "&creator_unit_id=" + window.parent.doctor_unit_id + "&creator_cluster_id=" + window.parent.doctor_cluster_id + "&creator_unit_type=" + window.parent.doctor_unit_type;
			}
			$("#transparentDiv2").css("z-index",31);
			$("#divloading").css("z-index",32);
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
			        $("#transparentDiv2").css("z-index",3);
					$("#divloading").css("z-index",30);
				    var modelMap = response.modelMap;
				    var status = modelMap.status;
				    if(status == "1"){
				    	$.alert('保存成功！');
				    	if(medicalExamination_popType == "add"){
							$.fn.page.settings.realcount++;
							$.fn.page.settings.currentnum = 1;
							//pagemodify("add");
				    	}
				    	closeDiv_medicalExamination();
				    	query();
				    }else if(status == "0"){
				    	$.alert('保存失败！');
				    }
				}
			});
		}
		
		function deleteMedicalExamination(){
			var len = $("#medicalExaminationTable :checkbox:checked[name=selectCheckbox]").length;
				if(len <=0){
				$.alert('请先选择一项！');
				return false;
			}
			
			$.confirm("确认删除当前选项吗？",function(){
				var para_value = "";
				$("#medicalExaminationTable :checkbox:checked[name=selectCheckbox]").each(function(index,obj){
					para_value += this.value + ":";
					return;
				});
				
				var requestUrl = "/healthRecordAction/deleteMemberMedicalExamination.action";
				var para = "ids="+para_value.substring(0,para_value.length-1);
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
					    var status = modelMap.status;
					    if(status == "1"){
					    	$.alert('删除成功！');
					    	$.fn.page.settings.realcount-=len;
							pagemodify("del");
					    	query();
					    }else if(status == "0"){
					    	$.alert('删除失败！');
					    }
					}
				});
			},function(){});
			
		}
		
		function selectAll(obj){
			$("#medicalExaminationTable input[name='selectCheckbox']").attr("checked",obj.checked);
		}
		
		function selectCheckBox(obj){
			var flag = true;
			$("#medicalExaminationTable input[name='selectCheckbox']").each(function(index,obj){
				if(!obj.checked){
					flag = false;
				}
			});
			$("#selAll").attr("checked",flag);
		}
</script>
</head>
<body>
<div style="font-size:13px;font-family:微软雅黑">
<div class="bp_history" style="height:500px">
 <div class="search" style="padding-right:0px; width:650px;" >
    <ul>
      <li class="criteria_search_zsgc" >
        <ul>
          <li class="startTime">健康检查</li>
          <li class="time_input"><!-- <input type="text"   id="create_time" name="create_time" value='' onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/> --></li>
        </ul>
      </li>
      <li class="btn_search_zsgc">
          <ul>
	      <!-- <li><a href="javascript:void(0)" onclick="queryStart()">查询</a></li> -->
	      <li><a href="javascript:void(0)" onclick="deleteMedicalExamination()">删除</a></li>
	      <li><a href="javascript:void(0)" onclick="showMedicalExamintionDialog(1)">修改</a></li>
	      <li> <a href="javascript:void(0)" onclick="showMedicalExamintionDialog()">增加</a></li>
	      </ul>
      </li>
    </ul>
  </div>
  <div class="index_table">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table"  id="medicalExaminationTable">
      <colgroup>
        <col width="5%" />
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
        <!-- <col width="20%" /> -->
      </colgroup>
      <tr>
      	<th nowrap="nowrap"><input type="checkbox" id="selAll"  onclick="selectAll(this)"  />选择</th>
        <th nowrap="nowrap" title="餐后血糖(餐后2小时内)">餐后血糖</th>
        <th nowrap="nowrap" title="空腹全血血糖">空腹血糖</th>
        <th nowrap="nowrap" title="总胆固醇">总胆固醇</th>
        <th nowrap="nowrap" title="高密度脂蛋白胆固醇">高密度胆固醇</th>
        <th nowrap="nowrap" title="低密度脂蛋白胆固醇">低密度胆固醇</th>
        <th nowrap="nowrap" title="血清肌酐">血清肌酐</th>
        <!-- <th nowrap="nowrap" title="微量尿白蛋白">微量尿白蛋白</th> -->
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
  

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
</div>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />

<style type="text/css">

.tgrey_popup{width:16%;float:left; height:30px; line-height:30px; text-align:right; color:#aeaeae; margin-bottom: 10px}
.tblack_popup{width:84%; padding_left:1%;float:left; height:30px; line-height:30px; text-align:left; color:#aeaeae;margin-bottom: 10px}

</style>

</head>
<body>
 <div class="popup" id="medicalExaminationWindow" style="width:600px;display:none;position:absolute;top:20px; left:10px;z-index: 30;height:300">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader"  id="pop_medicalExaminationTitle">增加亲情号码</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv_medicalExamination();">X</a></li>
    </ul>
  </div>
  <form id="medicalExaminationForm" >
  		<input type="hidden" name="id"  id="id"  />
	   <div class="popup_main">
	         <ul>
	              <li class="tgrey_popup2">*餐后血糖(餐后2小时内)：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,20]]]" type="text"  id="chxt"  name="chxt" maxlength="5" />
	              		mmol/L
	              </li>
	              <li class="tgrey_popup2">*空腹全血血糖：</li>
	              <li class="tblack_popup2">
		              <input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,20]]]" type="text"  id="kfqxxt"  name="kfqxxt"  maxlength="5" />
		              mmol/L
	           	   </li>
	              <li class="tgrey_popup2">*总胆固醇：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,20]]]"  type="text"   id="zdgc"  name="zdgc"  maxlength="5" />
	              		mmol/L
	              </li>
	              <li class="tgrey_popup2">*高密度脂蛋白胆固醇：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,10]]]"  type="text"   id="gmdzdbdgc"  name="gmdzdbdgc"  maxlength="5" />
		             	mmol/L
	              </li>
	              <li class="tgrey_popup2">*低密度脂蛋白胆固醇：</li>
	              <li class="tblack_popup2">
						<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,10]]]"  type="text"   id="dmdzdbdgc"  name="dmdzdbdgc"  maxlength="5" />
	              		mmol/L
	              </li>
	             <li class="tgrey_popup2">*血清肌酐：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[1,200]]]"  type="text"   id="xqjq"  name="xqjq" maxlength="5" />
	              		μmol/L
	              </li>
	             <li class="tgrey_popup2">*微量尿白蛋白：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,100]]]"  type="text"   id="wlnbdb"  name="wlnbdb" maxlength="5" />
	              		mg/24h
	              </li>			              
	              <li class="btn_popup_confirm2"><a href="javascript:void(0)" onclick="saveMedicalExamination()">保存</a></li>                                       
	         </ul>
	      </div>                 
  </form>
 </div>

</body>
</html>
</div>
</body>
</html>