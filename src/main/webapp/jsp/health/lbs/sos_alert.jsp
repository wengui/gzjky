<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>sos告警</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/location.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script type="text/javascript" src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script type="text/javascript" src="<c:url value='/js/base.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/common/date.js'/>"></script>

<script type="text/javascript">
	//设备型号数组
	var parameter=[
				
				{id:"606",
				desc:"无线网络生理参数监测仪TE8000Y"
					
					},
					
				{id:"605",
				desc:"无线网络生理参数监测仪TE8000Y2"
					
					},
					
				{id:"301",
				desc:"腕式监测呼救定位器TE8000Y3"
					
					},
					
				{id:"108",
				desc:"无线电子测量血压计TE-7000Y"
					
					},
					
				{id:"801",
				desc:"十二导心电采集仪TE8000Y4"
					
					},
					
				{id:"502",
				desc:"心电蓝牙TE9100Y"
					
					}
					
			];
  var startDate="";
  var endDate="";
  var dateType=0;
  function startInit(){
	  queryStart();
  }
  function queryStart(){
	  $.fn.page.settings.currentnum = 1;
	  startDate = $("#startDate").val();
	  endDate = $("#endDate").val();
	  dateType=0;
	  query();
  }
  function query(){
	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;
	  var requestUrl = "";
	 var para = "startDate=" + startDate + "&endDate=" + endDate + "&pos_type="+dateType
		+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
		 requestUrl = "/lbs/querySosAlertList.action";
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
				//$.alert('无权限');
			},success:function(response){
			    var modelMap = response.modelMap;
			    	recordList = modelMap.sosAlertList;
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
  var columnArray = ["alert_time","serial_id","version","address"];
  function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);
	 var i = 0;
	 recordList[index].alert_time = recordList[index].alert_time.substring(0,19);
	 for(var j=0;j<parameter.length;j++){
		   		if(recordList[index].version==parameter[j].id){
		   			recordList[index].version=parameter[j].desc;
		   		};
		   	}
	 for(var k=0;k<columnArray.length;k++){
		  var td = tr.insertCell(i);
		  if(k==1){
		  	td.innerHTML = recordList[index][columnArray[k]]==""?"--":recordList[index][columnArray[k]];
		  }else if(k==2){
		  td.innerHTML = recordList[index][columnArray[k]]==0?"--":recordList[index][columnArray[k]];
		  }else{
		  td.innerHTML = recordList[index][columnArray[k]]=recordList[index][columnArray[k]];
		  }
		  i++;
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
</script>
</head>
<body onload="startInit()"  class="skin-blue">
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	         <!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
           <section class="content-header">
              <h1>SOS报警
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li >终端定位</li>
                  <li class="active">SOS报警</li>
              </ol>
          </section>
          <!-- Main content -->
          <section class="content">
			 <div class="bp_history">
					<div class="search">
						<ul>
							<li class="criteria_search">
								<ul>
									<li class="startTime">开始时间</li>
									<li class="time_input"><input type="text" id="startDate"
										name="startDate"
										onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})" />
									</li>
									<li class="endTime">结束时间</li>
									<li class="time_input"><input type="text" id="endDate"
										name="endDate"
										onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})" />
									</li>
									<li class="quick_search">
									<!--  快速查询：<a href="javascript:void(0);"
										onclick="query_week()">最近一周</a><a href="javascript:void(0);"
										onclick="query_month()">最近一月</a><a href="javascript:void(0);"
										onclick="query_quarter()">最近一季</a><a href="javascript:void(0);"
										onclick="query_year()">最近一年</a>-->
									 快速查询：<a href="javascript:changeDate(3)">最新3天</a><a href="javascript:changeDate(7)">最近一周</a><a href="javascript:changeDate(30)" style="margin-right:8px;">最近30天</a><a href="javascript:changeDate(365)" style="margin-right:2px;">最近一年</a>	
									</li>
								</ul></li>
							<li> <a href="javascript:void(0)" class="btn  btn_search" onclick="queryStart()"><span style="font-size:17px; font-weight:500;color:#5a5a5a">查询</span></a>
							</li>
						</ul>
					</div>
					<div class="index_table">
			            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table" id="faceTable">
			              <colgroup>
			                <col width="23%" />
			                <col width="12%" />
			                <col width="25%" />
			                <col width="40%" />
			              </colgroup>
			              <tr>
			                <th>报警时间</th>
			                <th>设备编号</th>
			                <th>设备类型</th>
			                <th>报警地址</th>
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
				    <li class="page_select">转<select id="gopage" onchange="gotoPage()"></select>页
				    </li>
				  </ul>
				</div>
 				<div id="divloading"><img src="../../../images/public/blue-loading.gif" /></div>
				<div id="transparentDiv" ></div>
				<div id="transparentDiv2"></div>
       		 </div>
         </section><!-- /.content -->
     </aside><!-- /.right-side -->
</div><!-- ./wrapper -->      
</body>
</html>
