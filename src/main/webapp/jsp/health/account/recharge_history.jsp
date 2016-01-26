<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>充值记录</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript" ></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js"  type="text/javascript'/>"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript" ></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>

<script type="text/javascript">

<script type="text/javascript">
  var startDate="";
  var endDate="";
  function startInit(){
	  hideLoading();
	  queryStart();
  }
  function queryStart(){
	  $.fn.page.settings.currentnum = 1;
	  startDate = $("#startDate").val();
	  endDate = $("#endDate").val();	
	  query();
  }
  function query(){
	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;

	  var para = "startDate=" + startDate + "&endDate=" + endDate 
		+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	  var requestUrl="/packageAction/queryMemberRechargeHistory.action";
      
	  //showScreenProtectDiv(1);
	  //showLoading();

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
			    recordList = modelMap.memberRechargeHistoryList;		    			
				$.fn.page.settings.count = modelMap.memberRechargeHistoryCount;
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
	  /* $("table.bPhistory_table tr:even").addClass("even");
	  $("table.bPhistory_table tr:odd").addClass("odd"); */
  }

  function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);

	 recordList[index].datetime = recordList[index].datetime.substring(0,19);
	
	 var td = tr.insertCell(0);
	 td.innerHTML=recordList[index].datetime;
	
	
	 var td = tr.insertCell(1);
	 td.innerHTML=recordList[index].bill;
	 	 
	 var td = tr.insertCell(2);
	 td.innerHTML=recordList[index].platform_order_id;
	 
	 var td = tr.insertCell(3);
	 var state=recordList[index].state;
	 if(state==0){
	 	td.innerHTML="充值成功";
	 }	
	 if(state==1){
	 	td.innerHTML="充值中";
	 }	
	 if(state==-1){
	 	td.innerHTML="充值失败";
	 }	
  }
  
</script>
</head>

<body onload="startInit()" class="skin-blue">
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
           <section class="content-header">
              <h1>充值记录
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li >账户套餐</li>
                  <li class="active">充值记录</li>
              </ol>
          </section>
		<div class="bp_history">
		  <div class="box box-danger">
              <div class="box-header">
                  <h3 class="box-title">条件检索</h3>
              </div>		
              <div class="box-body">
	              	<div class="row">
		                 <div class="col-lg-3">
			                  <div class="input-group">
			                  	  <label>开始时间:</label>
			                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
			                      <input type="text" class="form-control" id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/>
			                  </div>
		                 </div><!-- /.col-lg-3 -->
		                <div class="col-lg-3">
		                  <div class="input-group">
			                  	  <label>结束时间:</label>
			                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
			                      <input type="text"  class="form-control"  id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/>
			               </div>
		               </div><!-- /.col-lg-3 -->
		               <div class="col-lg-3">
		               	 <button class="btn btn-success" style="margin-left:20px" onclick="queryStart();">查询</button>		               </div><!-- /.col-lg-3 -->
		               <div class="col-lg-3">
		               </div>
	              </div><!-- /.box-body -->
	              <div class="row">
	              	<br/>
	              	<div class="col-lg-6">
	              		 <label>快速查询:</label>
	              		 <a href="javascript:changeDate(3)" style="margin-left:20px;margin-right:15px;">最新3天</a>
	              		 <a href="javascript:changeDate(7)" style="margin-right:15px;">最近一周</a>
	              		 <a href="javascript:changeDate(30)" style="margin-right:15px;">最近30天</a>
	              		 <a href="javascript:changeDate(365)">最近一年</a>
	              	</div>
	              </div>
	      	  </div>
	      <div class="row">
		  	<br/>
		  	<div class="col-lg-11">
			
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table" id="faceTable">
				      <colgroup>
				        <col width="30%" />
				        <col width="20%" />
				        <col width="30%" />
				        <col width="20%" />
				      </colgroup>
				      <tr>
				        <th>充值日期</th>
				        <th>充值金额(元)</th>
				        <th>平台订单号</th>
				        <th>状态</th>
				      </tr>
				    </table>
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
				

				<div class="row">
					<br/>
					<div class="col-lg-4" style="padding-left:25px">
						共<span  id="showcount"></span>条信息，第<span id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页
					</div>
					<div class="col-lg-4">
						<a href="###" class="page-first" >首页</a>
					    <a href="###" class="page-perv" style="margin-left:5px">上一页</a>
					    <a href="###" class="page-next" style="margin-left:5px">下一页</a>
					    <a href="###" class="page-last" style="margin-left:5px">末页</a>
					</div>
					<div class="col-lg-4" style="padding-left:18%">
						 转<select id="gopage" onchange="gotoPage()"></select>页
					</div>
			
				</div>
				
				<div id="divloading">
					<img src="../../../images/public/blue-loading.gif" />
				</div>
				
				<div id="transparentDiv" ></div>
				
				<div id="transparentDiv2"></div>
				 </div>
				<!--bp_history end-->
		</div>
     </aside><!-- /.right-side -->
</div><!-- ./wrapper -->     
</body>
</html>
