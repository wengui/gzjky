<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>

<script type="text/javascript">

var startDate="";
var endDate="";
//var dateType=0;
var heartType = 0;
$.fn.page.settings.currentnum = 1;
function startInit(){
	  	
	  query();
	  /*
	  if(dateType == 0){
		  query();
	  }else if(dateType == 1){
		  query_week();
	  }else if(dateType == 2){
		  query_month();
	  }else if(dateType == 3){
		  //query_quarter();
		  query_lateTreeDay();
	  }else if(dateType == 4){
		  query_year();
	  }
	  */
}
function queryStart(){
	  $.fn.page.settings.currentnum = 1;
	  //dateType=0;
	  query();
	  
}
function query(){
	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;

	  startDate = $("#startDate").val();
	  endDate = $("#endDate").val();
	  
	 var requestUrl = "";
	 var para = "startDate=" + startDate + "&endDate=" + endDate + "&heartType="+heartType
		+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize + "&currentnum="+$.fn.page.settings.currentnum;
	 
	 requestUrl = "/gzjky/historyAction/queryEcgList.do";
  
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
				// 数据取得
				recordList = response.outBeanList;
				
				$.fn.page.settings.count = response.recordTotal;
				page($.fn.page.settings.currentnum);
			}
		});
}

function showData(){
	  if(heartType == 0){
		  clearFaceTable();
		  var table = document.getElementById("faceTable");
		  var table2 = document.getElementById("faceTable2");
		  $('#faceTable').show();
		  $('#faceTable2').hide();
	  }else if(heartType == 1){
		  clearFaceTableByTableName("faceTable2");
		  $('#faceTable').hide();
		  $('#faceTable2').show();
	  }
	  for(var i=0;i<$.fn.page.settings.currentsize;i++){
		  addrowtotable(table,i);
	  }
	  $("table.bPhistory_table tr:even").addClass("even");
	  $("table.bPhistory_table tr:odd").addClass("odd");
}
var columnArray = ["deviceSerialId","deviceVersion","takeTime","heartRate","timeLength"];
function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);
	 var i = 0;
	 recordList[index].takeTime = recordList[index].takeTime.substring(0,19);
	 //recordList[index].heartRate = recordList[index].heartRate +"(次/分)";
	if(heartType == 1){
		 recordList[index].timeLength = "心率超出阀值";
	 }
	 
	 for(var k=0;k<columnArray.length;k++){
		  var td = tr.insertCell(i);
		  if(columnArray[k] == "heartRate"){
			  if(recordList[index][columnArray[k]] == "0"){
				  td.innerHTML = "--"
			  }else{
				  td.innerHTML = recordList[index][columnArray[k]];  
			  }
			  
		  }else if(columnArray[k] == "deviceSerialId" || columnArray[k] == "deviceVersion"){
			  if(recordList[index][columnArray[k]] == "" || recordList[index][columnArray[k]] == null || recordList[index][columnArray[k]]=="null"){
				  td.innerHTML = "--";
			  }else{
				  if(columnArray[k] == "deviceSerialId"){
				  	  td.innerHTML = recordList[index][columnArray[k]];
				  }else{
					  td.innerHTML = recordList[index][columnArray[k]];
				  }
			  }
			   
		  }else{
			  td.innerHTML = recordList[index][columnArray[k]] 
		  }
		  
		  i++;
	  }
	 if(heartType == 0){
		 var td = tr.insertCell(i);
		 //td.nowrap="nowrap";
		 td.innerHTML = '<a href="javascript:void(0)" onclick="showEcgDetail(this,'+index+')">查看心电图</a>';
		 
	 }
}
function query_lateTreeDay(){
	$.fn.page.settings.currentnum = 1
	 dateType = 3;
	changeDate(3);
	 query();
}

//周
function query_week(){
	  $.fn.page.settings.currentnum = 1
	  dateType = 1;
	  changeDate(7);
	  query();
}
//月
function query_month(){
	  $.fn.page.settings.currentnum = 1
	  dateType = 2;
	  changeDate(30);
	  query();
}
//季度
function query_quarter(){
	  $.fn.page.settings.currentnum = 1
	  dateType = 3;
	  query();
}
//年
function query_year(){
	  $.fn.page.settings.currentnum = 1
	  dateType = 4;
	  changeDate(365);
	  query();
}

function changeHeartType(obj){
	heartType = $(obj).val();
	 if(heartType == 0){
		  $("#ecg_title").text("心电");
		  $("#sub_title").text("历史");
	  }else if(heartType == 1){
		  $("#ecg_title").text("心率");
		  $("#sub_title").text("告警");
	  }
	  //dateType = 0;
	  $.fn.page.settings.currentnum = 1
	  query();
}

function showEcgDetail(obj,index){
	var id = recordList[index].id;
	obj.target = "mainFrame";
	obj.href = "./ecg_detail.jsp?id="+id;
}
</script>
</head>

<body onload="startInit()"  class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
	<!-- Content Header (Page header) -->
        <section class="content-header">
             <h1>心电历史</h1>
             <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-dashboard"></i> 首页</a></li>
                  <li class="active">心电历史</li>
             </ol>
         </section>
		<!--bp_history start-->
		<div class="bp_history">
		  <div class="search">
		    <ul>
		      <li class="criteria_search">
		        <ul>
		          <li class="startTime">开始时间</li>
		          <li class="time_input"><input type="text"  id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/></li>
		          <li class="endTime">结束时间</li>
		          <li class="time_input"><input type="text"  id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/></li>
		          <li class="startTime">心电历史</li>
		          <li class="time_input"><span><select onchange="changeHeartType(this)"><option selected="selected" value="0">心电历史</option><option value="1">心率告警</option></select></span></li>
		          <li> <a href="javascript:void(0)" class="btn-primary_select" onclick="queryStart()"><span style="font-size:17px; font-weight:500;color:#5a5a5a">查询</span></a></li>
		          <li class="quick_search">
		                  快速查询：<a href="javascript:changeDate(3)">最新3天</a><a href="javascript:changeDate(7)">最近一周</a><a href="javascript:changeDate(30)" style="margin-right:8px;">最近30天</a><a href="javascript:changeDate(365)" style="margin-right:2px;">最近一年</a>
		          </li>
		        </ul>
		      </li>
		    </ul>
		  </div>
		  <div class="index_table">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table"  id="faceTable">
		      <colgroup>
		        <col width="15%" />
		        <col width="20%" />
		        <col width="25%" />
		        <col width="11%" />
		        <col width="11%" />
		        <col width="20%" />
		      </colgroup>
		      <tr>
		        <th>设备编号</th>
		        <th>设备类型</th>
		        <th>采集时间</th>
		        <th nowrap="nowrap">心率(次/分)</th>
		        <th nowrap="nowrap">时间长度(秒)</th>
		        <th>操作</th>
		      </tr>
		    </table>
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table"  id="faceTable2" style="display:none;">
		      <colgroup>
		        <col width="15%" />
		        <col width="15%" />
		        <col width="25%" />
		        <col width="13%" />
		        <col width="12%" />
		      </colgroup>
		      <tr>
		        <th>设备编号</th>
		        <th>设备类型</th>
		        <th>采集时间</th>
		        <th nowrap="nowrap">心率(次/分)</th>
		        <th>状态</th>
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
		 
		<div class="index_page">
		  <ul>
		    <li class="page_information">共<span  id="showcount"></span>条信息，第<span  id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页</li>
		    <li class="page_button">
			    <a href="###" class="btn page-first"><span style="color:#5a5a5a">首页</span></a>
			    <a href="###" class="btn page-perv"><span style="color:#5a5a5a">上一页</span></a>
			    <a href="###" class="btn page-next"><span style="color:#5a5a5a">下一页</span></a>
			    <a href="###" class="btn page-last"><span style="color:#5a5a5a">末页</span></a>
		    </li>
		    <li class="page_select">
		    	转<select id="gopage" onchange="gotoPage()">
		    	</select>页
		    </li>
		  </ul>
		</div>
		  
		
		<div id="divloading">
			<img src="../../../images/public/blue-loading.gif" />
		</div>
		
		<div id="transparentDiv" ></div>
		
		<div id="transparentDiv2"></div>
		</div>
	</aside><!-- /.right-side -->
</div><!-- ./wrapper -->
<!--bp_history end-->
</body>
</html>
