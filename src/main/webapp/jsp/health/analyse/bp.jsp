<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>血压历史</title>

<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
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


<script type="text/javascript">
  var startDate="";
  var endDate="";
  //var dateType=0;
  var bloodType = 0;
  menuId = "#bp";
  function startInit(){
	  $('.massage').hide();
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
				
				if(recordList.length == 0){
					$('.commonPage').hide();
					$('.massage').show();
				}else{
					$('.commonPage').show();
					$('.massage').hide();
				}
				
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
		   $('#faceTable').show();
		   $('#faceTable2').hide();
		   
		   for(var i=0;i<$.fn.page.settings.currentsize;i++){
		  		addrowtotable(table,i);
	  	   }
		}else if(bloodType == 1){
		   clearFaceTableByTableName("faceTable2");

		   $('#faceTable').hide();
		   $('#faceTable2').show();
		   
		   for(var i=0;i<$.fn.page.settings.currentsize;i++){
		  		addrowtotable(table2,i);
	  	   }
		}
	  	
	  	$("table.bPhistory_table tr:even").addClass("even");
	  	$("table.bPhistory_table tr:odd").addClass("odd");
  	}
  var columnArray = ["deviceSerialId","takeTime","pressure_value"];
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
	 if((parseInt(shrink) < parseInt(diastole)) || (shrink<60 || shrink >255) || (diastole<30 || diastole>195)){
		 recordList[index].pressure_value = "打压失败";
	 }else{
		 recordList[index].pressure_value = shrink +"/"+ diastole;
	 }
	 
	 if(bloodType == 0 && recordList[index].state != "Normal"){
		 tr.className = "abnormal";
	 }
	 for(var k=0;k<columnArray.length;k++){
		  var td = tr.insertCell(i);
		  //td.style="word-break:break-all;";
		  if(columnArray[k] == "deviceSerialId"){
			  if(recordList[index][columnArray[k]] == "" || recordList[index][columnArray[k]] == null || recordList[index][columnArray[k]]=="null"){
				  td.innerHTML = "--";
			  }else{
				  if("" == recordList[index]['nickname'] || null == recordList[index]['nickname']){
					  td.innerHTML = recordList[index]["deviceVersion"];
				  }else{
					  td.innerHTML =  recordList[index]["nickname"];
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
	  td.innerHTML = "<a href='javascript:void(0)' class='btn btn-info' onclick='show_bp_remark("+index+")'><i class='fa fa-fw fa-edit'></i>备注</a><a href='javascript:void(0)' class='btn btn-info' onclick='del_bp("+index+")'><i class='fa fa-fw fa-trash-o'></i>删除</a>";
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
		$("#bpRemarkWindow").modal('show');
		//showScreenProtectDiv(1);
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
		//$("#bpRemarkWindow").hide(200);
		$("#bpRemarkWindow").modal('hide');
		hideScreenProtectDiv(1);
	}
</script>
</head>

<body onload="startInit()" class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
		<!-- Content Header (Page header) -->
        <section class="content-header">
             <h1>血压历史</h1>
             <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li>健康分析</li>
                  <li class="active">血压历史</li>
             </ol>
         </section>
	   	 <div class="box box-danger">
              <div class="box-header">
                  <h3 class="box-title">条件检索</h3>
              </div>
              <div class="box-body">
              	 <div class="row">
	                 <div class="col-lg-4 col-xs-4"">
	                 	  <label class="search-label">开始时间:</label>
	                 	  <div class="input-group">
	                 	  <span class="input-group-addon "><i class="fa fa-calendar"></i></span>
	                      <input type="text" id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/>
	                 	  </div>
	                 </div>
	                 <div class="col-lg-4 col-xs-4""> 	  
	                  	  <label class="search-label">结束时间:</label>
		                  	  <div class="input-group">
		                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
		                      <input type="text" id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/>
		               		  </div>
		             </div>
	            </div>
	            <div class="row" style="margin-top:10px">
	                <div class="col-lg-4 col-xs-4"">
	                  	  <label class="search-label">血压历史:</label>
	                  	  <div class="input-group">
	                      <span class="input-group-addon"><i class="fa fa-bars"></i></span>
	                      <select onchange="changeBloodType(this)"><option selected="selected" value="0">血压历史</option><option value="1">血压告警</option></select>
	               		  </div>
	              	</div><!-- /.col-lg-12 -->
	              	<div class="col-lg-4 col-xs-4"> 	
	              		<button class="btn btn-success"  onclick="queryStart();"><i class="fa fa-search"></i> 查询</button>
	              	</div>
              	</div>
              	<div class="row" style="margin-top:10px">
              		<div class="col-lg-12 col-xs-12">
              		 <label class="search-label">快速查询:</label>
              		 <a href="javascript:changeDate(3)" style="text-decoration: underline;">最新3天</a>
              		 <a href="javascript:changeDate(7)" style="text-decoration: underline;padding-left:10px">最近一周</a>
              		 <a href="javascript:changeDate(30)" style="text-decoration: underline;padding-left:10px">最近30天</a>
              		 <a href="javascript:changeDate(365)" style="text-decoration: underline;padding-left:10px">最近一年</a>
              		</div>
               </div>
		  <div class="row">
		  	<br/>
		  	<div class="col-lg-11 col-xs-11" style="padding-left:10px">
			    <table width="100%" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table" id="faceTable">
			      <tr>
			        <th width="25%" class="text-center">设备</th>
			        <th width="25%">测压时间</th>
			        <th width="20%">收缩压/舒张压&nbsp;(mmHg)</th>
			        <th width="10%">脉率</th>
			        <th width="20%">操作</th>
			      </tr>
			    </table>
			    
			    <table width="100%"  cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table" id="faceTable2" style="display:none;">
			      <colgroup>
			        <col width="25%" />
			        <col width="25%" />
			        <col width="20%" />
			        <col width="20%" />
			      </colgroup>
			      <tr>
			        <th class="text-center">设备</th>
			        <th>测压时间</th>
			        <th>收缩压/舒张压&nbsp;(mmHg)</th>
			        <th>操作</th>
			      </tr>
			    </table>
			    <div class="massage text-center col-lg-11 col-xs-11" style="color: red; display:none;">对不起，没有数据。</div>
		    </div>
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
		
		<div class="row commonPage">
			<br/>
			<div class="col-lg-4 col-xs-4" style="padding-left:25px">
				共<span  id="showcount"></span>条信息，第<span id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页
			</div>
			<div class="col-lg-4 col-xs-4">
				<a href="###" class="page-first" >首页</a>
			    <a href="###" class="page-perv" style="margin-left:5px">上一页</a>
			    <a href="###" class="page-next" style="margin-left:5px">下一页</a>
			    <a href="###" class="page-last" style="margin-left:5px">末页</a>
			</div>
			<div class="col-lg-4 col-xs-4" style="padding-left:18%">
				 转<select id="gopage" onchange="gotoPage()"></select>页
			</div>

		</div>
</div>		
		<div id="divloading">
			<img src="../../../images/public/blue-loading.gif" />
		</div>
		<div id="transparentDiv" ></div>
		<div id="transparentDiv2"></div>
		  
<div class="modal fade" id="bpRemarkWindow"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%">
  <div class="modal-dialog">	
		  <div class="popup_header">
		    <ul>
		      <li class="name_popupHeader">血压备注</li>
		      <li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal" class="d-close"></a></li>
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
			            	<textarea class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray;" id="feedback" name="feedback" rows="5" cols="35" maxlength="100"></textarea>
			            </li>            
			  		</ul>
			  		<ul>
			            <li class="btn_popup_confirm2 text-center">
			                
			            	<a href="javascript:void(0)" class="btn btn-info"  onclick="addRemark();">确定</a>
			            	&nbsp;&nbsp;
					        <a href="javascript:void(0)" class="btn btn-info"  data-dismiss="modal">取消</a>
			            </li>     
			  		</ul>
			  </div>
		   </form>
	 </div>
</div>
</aside><!-- /.right-side -->
</div><!-- ./wrapper -->
<!--bp_history end-->
</body>
</html>
