<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>

<style type="text/css">
	td{word-break:break-all;}
	.index_table table#faceTable tr th{
		height: inherit;
		line-height: normal;
	}
</style>
<script type="text/javascript">

 var startDate="";
  var endDate="";
  //var dateType=0;
  var bloodType = 0;
  function startInit(){
	  queryStart();
	  jQuery('#bpRemarkform').validationEngine("attach",
    			{
    				promptPosition:"topRight",
    				maxErrorsPerField:1,
    				scroll:false,
    				focusFirstField:false
    				//binded:false,
    				//showArrow:false,
    			}
   	   ); 
  }
  function queryStart(){
	  $.fn.page.settings.currentnum = 1;
	  startDate = $("#startDate").val();
	  endDate = $("#endDate").val();
	  //dateType=0;
	  query();
  }
  function query(){
	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;

	  	var requestUrl = "";
		var para = "startDate=" + startDate + "&endDate=" + endDate + "&bloodType="+bloodType
		+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;

	  requestUrl = "/gzjky/historyAction/queryBloodPressureList.do";

      
      
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
		var table = document.getElementById("faceTable");
		var table2 = document.getElementById("faceTable2");
  		if(bloodType == 0){
		   clearFaceTable();   
		   table.style.display = "block";
		   table2.style.display = "none";
		   
		   for(var i=0;i<$.fn.page.settings.currentsize;i++){
		  		addrowtotable(table,i);
	  	   }
		}else if(bloodType == 1){
		   clearFaceTableByTableName("faceTable2");

		   table2.style.display = "block";
		   table.style.display = "none";
		   for(var i=0;i<$.fn.page.settings.currentsize;i++){
		  		addrowtotable(table2,i);
	  	   }
		}
	  	
	  	$("table.bPhistory_table tr:even").addClass("even");
	  	$("table.bPhistory_table tr:odd").addClass("odd");
  	}
  var columnArray = ["deviceSerialId","deviceVersion","takeTime","pressure_value"];
  function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);
	 var i = 0;
	 recordList[index].takeTime = recordList[index].takeTime.substring(0,19);
	 if(recordList[index].takeTime=='1970-01-01 00:00:00')
	 	recordList[index].takeTime=recordList[index].upload_time;
	 //收缩压
	 var shrink = recordList[index].shrink;
	 //舒张压
	 var diastole = recordList[index].diastole;
	 if(shrink < diastole || (shrink<60 || shrink >255) || (diastole<30 || diastole>195)){
		 recordList[index].pressure_value = "打压失败";
	 }else{
		 recordList[index].pressure_value = shrink +"/"+ diastole;
	 }
	 
	 if(bloodType == 0 && recordList[index].state != "正常"){
		 tr.className = "abnormal";
	 }
	 for(var k=0;k<columnArray.length;k++){
		  var td = tr.insertCell(i);
		  //td.style="word-break:break-all;";
		  if(columnArray[k] == "deviceSerialId" || columnArray[k] == "deviceVersion"){
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
		  	td.innerHTML = recordList[index][columnArray[k]];
		  }
		  i++;
	}
	  if(bloodType == 0){
		  var td = tr.insertCell(i);
		  if(recordList[index]["pressureValue"] == 0 || recordList[index]["pressureValue"] == "" || recordList[index]["pressureValue"] == null || recordList[index]["pressureValue"]=="null"){
			  td.innerHTML = "--";
		  }else{
			  td.innerHTML = recordList[index]["pressureValue"];
		  }
		  i++;
	  }
	  td = tr.insertCell(i);
	  td.innerHTML = "<a href='javascript:void(0)' onclick='show_bp_remark("+index+")'>备注</a><a href='javascript:void(0)' onclick='del_bp("+index+")'>删除</a>";
  }
  
  function del_bp(i){
  	 $.confirm("确定删除该记录吗?",function(){			
	  	 var requestUrl = "";
		 var para = "id=" + recordList[i].id;
		 requestUrl = "/gzjky/historyAction/delBloodPressure.do";
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
					if(response.updateFlag=="1"){
					$.alert("删除成功！");
					closeDiv();
					query();
					}
					else if(response.updateFlag=="0"){
						$.alert("删除出现异常！");
					}
				}
			});
		},function(){
		});
  }
  //周
 function query_week(){
	  $.fn.page.settings.currentnum = 1;
	  dateType = 1;
	  query();
  }
  //月
  function query_month(){
	  $.fn.page.settings.currentnum = 1;
	  dateType = 2;
	  query();
  }
  //季度
 function query_quarter(){
	  $.fn.page.settings.currentnum = 1;
	  dateType = 3;
	  query();
  }
  //年
 function query_year(){
	  $.fn.page.settings.currentnum = 1;
	  dateType = 4;
	  query();
  }
  
  function changeBloodType(obj){
	  bloodType = $(obj).val();
	  if(bloodType == 0){
		  //$("#bp_title").text("血压");
		  $("#sub_title").text("历史");
	  }else if(bloodType == 1){
		  //$("#bp_title").text("血压");
		  $("#sub_title").text("告警");
	  }
	  dateType = 0;
	  $.fn.page.settings.currentnum = 1;
	  query();
  }
  
  function show_bp_remark(i){
  		$("#bp_id").val(recordList[i].id);	
  		$("#feedback").val(recordList[i].feedback);
  		$("#bp_time").html(recordList[i].takeTime.substring(0,19));
		$("#bp_value").html(recordList[i].shrink+"/"+recordList[i].diastole+"mmHg");
  		$("#bpRemarkWindow").draggable({
			disabled : true
		});
		$("#bpRemarkWindow").show(200);
		showScreenProtectDiv(1);
  }
  
  function addRemark(){
  	if(!jQuery('#bpRemarkform').validationEngine('validate')) return false;
  	var id=$("#bp_id").val();
  	var feedback=$("#feedback").val();
  	var requestUrl = "";
	var para = "id=" + id+"&feedback="+feedback;
	requestUrl = "/gzjky/historyAction/addBloodPressureFeedback.do";
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
				if(response.updateFlag=="1"){
					$.alert("备注成功！");
					closeDiv();
					query();
				}
				else if(response.updateFlag=="0"){
					$.alert("备注出现异常！");
				}
			}
		});
  }
  
  function closeDiv() {
		$("#bpRemarkWindow").hide(200);
		hideScreenProtectDiv(1);
	}
</script>
</head>

<body onload="startInit()"style="background:#e8e3d7">
<!--bp_history start-->
<div class="bp_history">
  <div class="title_BPhistory">
    <ul>
      <li class="tgreen_title_BPhistory">血压历史</li>
      <li class="select_BPhistory"><span class="select-style"><select onchange="changeBloodType(this)"><option selected="selected" value="0">血压历史</option><option value="1">血压告警</option></select></span></li>
    </ul>
  </div>
  <div class="search">
    <ul>
      <li class="criteria_search">
        <ul>
          <li class="startTime">开始时间</li>
          <li class="time_input"><input type="text"  id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/></li>
          <li class="endTime">结束时间</li>
          <li class="time_input"><input type="text"  id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/></li>
          <li class="quick_search">
                  快速查询：<a href="javascript:changeDate(3)">最新3天</a><a href="javascript:changeDate(7)">最近一周</a><a href="javascript:changeDate(30)" style="margin-right:8px;">最近30天</a><a href="javascript:changeDate(365)" style="margin-right:2px;">最近一年</a>
          </li>
        </ul>
      </li>
      <li> <a href="javascript:void(0)" class="btn  btn_search" onclick="queryStart()"><span style="font-size:17px; font-weight:500;color:#5a5a5a">查询</span></a></li>           
    </ul>
  </div>
  <div class="index_table">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table" id="faceTable">
      <colgroup>
        <col width="15%" />
        <col width="20%" />
        <col width="25%" />
        <col width="10%" />
        <col width="10%" />
        <col width="18%" />
      </colgroup>
      <tr>
        <th >设备编号</th>
        <th>设备类型</th>
        <th>测压时间</th>
        <th nowrap="nowrap">收缩压/舒张压<br/>&nbsp;&nbsp;&nbsp;&nbsp;(mmHg)</th>
        <th>脉率</th>
        <th>操作</th>
      </tr>
    </table>
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table" id="faceTable2" style="display:none;">
      <colgroup>
        <col width="15%" />
        <col width="20%" />
        <col width="25%" />
        <col width="20%" />
        <col width="20%" />
      </colgroup>
      <tr>
        <th>设备编号</th>
        <th>设备类型</th>
        <th>测压时间</th>
        <th nowrap="nowrap">收缩压/舒张压(mmHg)</th>
        <th>操作</th>
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
  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />

</head>
<body><br />
 <div class="popup" id="bpRemarkWindow" style="display:none;position:absolute;top:40px; left:100px;z-index: 30;">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">血压备注</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv();">X</a></li>
    </ul>
  </div>
      <form id="bpRemarkform" method="post">
      	<input type="text" style="display:none" id="bp_id"/>
		<div class="popup_main2">
			 <ul>
	            <li class="tgrey_Packagedetails_left2">测压时间：</li>
	            <li class="tblack_Packagedetails_right2" >
	            	<div id="bp_time"></div>
	            </li>            
	  		</ul>
	  		<ul>
	            <li class="tgrey_Packagedetails_left2">收缩压/舒张压：</li>
	            <li class="tblack_Packagedetails_right2" >
	            		<div id="bp_value"></div>
	            </li>            
	  		</ul>
	         <ul>
	            <li class="tgrey_Packagedetails_left2">备注：</li>
	            <li class="tblack_Packagedetails_right2" >
	            	<textarea class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray" id="feedback" name="feedback" rows="5" cols="35" maxlength="100"></textarea>
	            </li>            
	  		</ul>
	  		<ul>
	            <li class="btn_popup_confirm2" >
	                &nbsp;&nbsp;
	            	<a href="javascript:void(0)" class="btn" onclick="addRemark();"><span style="color:#5a5a5a">确定</span></a>
			        <a href="javascript:void(0)" class="btn" onclick="closeDiv();"><span style="color:#5a5a5a">取消</span></a>
	            </li>     
	  		</ul>
	  </div>
   </form>

 </div>

</body>
</html>
 </div>
<!--bp_history end-->
</body>
</html>
