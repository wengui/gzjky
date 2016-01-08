<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<style type="text/css">

.popup_main ul li.huanhang{width:100%;float:left;   }
.huanhang li input{height:20px; line-height: 20px; }
.tgrey_popup1{width:16%;float:left; text-align:right; color:#aeaeae;  padding:5px 0; margin:-15px 0; }
.tblack_popup1{width:83%; padding_left:1%;float:left; text-align:left; color:#aeaeae;padding:5px 0;margin:-15px 0;}

</style>
<script type="text/javascript">
	jQuery('#addMemberConsultForm').validationEngine("attach",
    			{
    				promptPosition:"centerRight:0,-10",
    				maxErrorsPerField:1,
    				scroll:false
    				//binded:false,
    				//showArrow:false,
    			}
    );
</script>
<style type="text/css">
	td{word-break:break-all;}
</style>
<script type="text/javascript">
  var htRelatedSymptomMap = {};
  var htRelatedSymptomStrMap = {};
  
  		htRelatedSymptomMap[1] = "发烧";
  		htRelatedSymptomStrMap["发烧"] = 1;
  
  		htRelatedSymptomMap[2] = "感冒";
  		htRelatedSymptomStrMap["感冒"] = 2;
  
  function startInit(){
	  queryStart();
  }
  function queryStart(){
	  $.fn.page.settings.currentnum = 1;
	  query();
  }
  function query(){
	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;

	  //var startDate = $("#startDate").val();
	  //var endDate = $("#endDate").val();
	 var requestUrl = "";
	 //var para = "startDate=" + startDate + "&endDate=" + endDate
	 var para = "pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	 requestUrl = "/memberConsultAction/queryMemberConsultList.action";
      
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
			    recordList = modelMap.memberConsultList;
				$.fn.page.settings.count = modelMap.recordTotal;
				page($.fn.page.settings.currentnum);
			}
		});
  }
  function showData(){
	  clearFaceTable();
	  var table = document.getElementById("faceTable");
	  for(var i=0;i<$.fn.page.settings.currentsize;i++){
		  addrowtotable(table,i);
	  }
	  $("table.bPhistory_table tr:even").addClass("even");
	  $("table.bPhistory_table tr:odd").addClass("odd");
  }

  var stateMap = {1:"新建",2:"处理中",3:"完成"}
  function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);
	 
	 var content = recordList[index].content.split(" ")[0];
	  var td = tr.insertCell(0);
	  td.innerHTML = content.length>=12?content.substring(0,10)+".." : content;
	  td.title = content;
	  
	  td = tr.insertCell(1);
	  td.innerHTML = recordList[index].create_time.substring(0,19);
	  
	  var report_content = recordList[index].report;
	  td = tr.insertCell(2);
	  td.innerHTML = report_content.length>=12?report_content.substring(0,10)+".." : report_content;

	  td = tr.insertCell(3);
	  td.innerHTML = stateMap[recordList[index].state];
	 
	  td = tr.insertCell(4);
	  td.innerHTML = "<a href='javascript:void(0)' onclick='showDialogDetail("+index+")'>查看</a>";
  }
  
  
  function showDialog(){
		$("#addMemberConsultForm :checkbox").attr("checked",false);
		$("#addMemberConsultForm").find("#content").val("");
		jQuery('#addMemberConsultForm').validationEngine("hide");
	   var tt = "增加会员咨询";
		$('#memberConsultWindow').draggable({
			disabled : true
		});
		$("#pop_memberConsultTitle").text(tt);
		$("#memberConsultWindow").show(200);
		showScreenProtectDiv(1);
  }
  
  function showDialogDetail(index){
	   var tt = "会员咨询详情";
	   $("#memberConsultDetailForm :checkbox").attr("checked",false);
	   var content = recordList[index].content;
	   var content_arr = content.split(" ");
	   var symptom_strs = new Array();
	   if(content_arr.length>1){
		   symptom_strs = content_arr[1].split(",");
		   for(var i=0;i<symptom_strs.length;i++){
			   $("#memberConsultDetailForm input[name='symptom_id'][value='"+htRelatedSymptomStrMap[symptom_strs[i]]+"']").attr("checked",true);
		   }
	   }
	   $("#memberConsultDetailForm").find("#content").val(content_arr[0]);
	   $("#memberConsultDetailForm").find("#create_time").val(recordList[index].create_time.substring(0,19));
	   $("#memberConsultDetailForm").find("#report").val(recordList[index].report);
	   $("#memberConsultDetailForm").find("#report_create_time").val(recordList[index].report_create_time.substring(0,19));
	   $("#memberConsultDetailForm").find("#state").val(stateMap[recordList[index].state]);
	   
		$('#memberConsultDetailWindow').draggable({
			disabled : true
		});
		$("#pop_memberConsultDetailTitle").text(tt);
		$("#memberConsultDetailWindow").show(200);
		showScreenProtectDiv(1);
}
  
  
  function saveMemberConsult(){
		if(!jQuery('#addMemberConsultForm').validationEngine("validate")){
			return false;
		}
		var requestUrl = "/memberConsultAction/insertMemberConsult.action";
	   var content = $("#addMemberConsultForm").find("#content").val();
	   var para = "content="+content;
	   var symptom_ids = "";
	   var symptom_str = "";
	   $("#addMemberConsultForm input[name='symptom_id']").each(function(index,obj){
		   if(this.checked){
		   		symptom_ids += this.value+":";
		   		symptom_str += htRelatedSymptomMap[this.value] + ",";
		   }
	   });
	   if(symptom_ids.length>0){
		   para += "&symptom_ids=" + symptom_ids.substring(0,symptom_ids.length-1);
		   para += "&symptom_str=" + symptom_str.substring(0,symptom_str.length-1);
	   }else{
		   para += "&symptom_ids=";
		   para += "&symptom_str=";
	   }
  	   showScreenProtectDiv(1);
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
				hideScreenProtectDiv(1);
		        hideLoading();
			    var state = response;
			    if(state == "1"){
			    	$.alert("增加成功");
			    }else{
			    	$.alert("增加失败");
			    }
			    closeDiv_memberConsult();
			    query();
			}
		});
  }
  
  function closeDiv_memberConsult() {
		$("#memberConsultWindow").hide(200);
		hideScreenProtectDiv(1);
	}
  
  function closeDiv_memberConsultDetail(){
		$("#memberConsultDetailWindow").hide(200);
		hideScreenProtectDiv(1);
  }
</script>
</head>

<body onload="startInit()" style="height:500px">
<!--bp_history start-->
<div class="bp_history">
  <div class="title_BPhistory">
    <ul>
      <li class="tgreen_title_BPhistory"  ><span class="tgrey_title_BPhistory" >会员</span><span id="sub_title">咨询</span></li>
    </ul>
  </div>
  <div class="search">
    <ul style="float: right">
      <!-- 
      <li class="criteria_search">
        <ul>
          <li class="startTime">开始时间</li>
          <li class="time_input"><input type="text"  id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/></li>
          <li class="endTime">结束时间</li>
          <li class="time_input"><input type="text"  id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/></li>
        </ul>
      </li>
       
      <li class="btn_search"><a href="javascript:void(0)" onclick="queryStart()">查询</a></li>     
      -->  
      <li class="btn_search"><a href="javascript:void(0)" onclick="showDialog()">新增</a></li>               
    </ul>
  </div>
  <div class="index_table">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table" id="faceTable" >
      <colgroup>
        <col width="28%" />
        <col width="24%" />
        <col width="28%" />
        <col width="10%" />
        <col width="10%" />
      </colgroup>
      <tr>
        <th nowrap="nowrap">咨询内容</th>
        <th nowrap="nowrap">咨询时间</th>
        <th nowrap="nowrap">医生回复</th>
        <th nowrap="nowrap">状态</th>
        <th nowrap="nowrap">操作</th>
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
 
 <div class="popup" id="memberConsultWindow" style="width:600px;display:none;position:absolute;top:10px; left:30px;z-index: 30;height:500">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader" id="pop_memberConsultTitle">增加亲情号码</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv_memberConsult();">X</a></li>
    </ul>
  </div>
  <form id="addMemberConsultForm" >
		<div class="popup_main">
	         <ul>
	         	  <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">症状：</li>
	              <li class="tblack_popup1"  >
	              		
	              			
	              			<input type="checkbox" name="symptom_id"  style="margin-bottom:-5px; margin-right:2px;"   value="1"/>发烧
	              			
	              		
	              			
	              			<input type="checkbox" name="symptom_id"  style="margin-bottom:-5px; margin-right:2px;"   value="2"/>感冒
	              			
	              		
	              </li>
	              </ul>
	              </li>
	              
	              
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">*咨询内容：</li>
	              <li class="tblack_popup1">
	              <textarea class="inputMin_informationModify validate[required]"  name="content" id="content" rows="5" cols="30" style="border: 1px solid #ccc"></textarea>
	           	   </li>	
	           	   </ul>
	           	   </li>
	           	   		              
	           	   <li>&nbsp;&nbsp;</li>
	              <li class="btn_popup_confirm"><a href="javascript:void(0)" onclick="saveMemberConsult()">保存</a></li>                                       
	         </ul>
	      </div> 
  </form>
 </div>
 
 <div class="popup" id="memberConsultDetailWindow" style="width:600px;display:none;position:absolute;top:10px; left:30px;z-index: 30;height:500">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader" id="pop_memberConsultDtailTitle">会员咨询详情</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv_memberConsultDetail();">X</a></li>
    </ul>
  </div>
  <form id="memberConsultDetailForm" >
		<div class="popup_main">
	         <ul>
	         
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">症状：</li>
	              <li class="tblack_popup1"  >
	              		
	              			
	              			<input type="checkbox" name="symptom_id"  style="margin-bottom:-5px; margin-right:2px;" disabled="disabled"  value="1"/>发烧
	              			
	              		
	              			
	              			<input type="checkbox" name="symptom_id"  style="margin-bottom:-5px; margin-right:2px;" disabled="disabled"  value="2"/>感冒
	              			
	              		
	              </li>
	              </ul>
	              </li>
	              
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">咨询内容：</li>
	              <li class="tblack_popup1">
	              <textarea  name="content" id="content"  class="inputMin_informationModify" rows="5" cols="30" disabled="disabled" style="border: 1px solid #ccc"></textarea>
	           	   </li>
	           	   </ul>
	           	   </li>
	           	   
	           	   <li class="huanhang">
	              <ul>			
	           	  <li class="tgrey_popup1">咨询时间：</li>
	              <li class="tblack_popup1">
	              		<input class="inputMin_informationModify " type="text"  id="create_time"  name="create_time"  disabled="disabled" />
	              </li> 
	              </ul>
	              </li>  
	              
	              <li class="huanhang">
	              <ul>             
	              <li class="tgrey_popup1">医生回复：</li>
	              <li class="tblack_popup1">
	              		<textarea  name="report" id="report"  class="inputMin_informationModify" rows="5" cols="30" disabled="disabled"  style="border: 1px solid #ccc"></textarea>
	              </li>
	              </ul>
	              </li>              
	              
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">回复时间：</li>
	              <li class="tblack_popup1">
	              		<input class="inputMin_informationModify " type="text"  id="report_create_time"  name="report_create_time"   disabled="disabled"/>
	              </li> 
	              </ul>
	              </li>   
	              
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">状态：</li>
	              <li class="tblack_popup1">
	              		<input class="inputMin_informationModify " type="text"  id="state"  name="state"   disabled="disabled" />
	              </li> 
	              </ul>
	              </li>  	              
	                               
	         </ul>
	      </div> 
	      </form>
 </div>
   

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
<!--bp_history end-->
</body>
</html>
