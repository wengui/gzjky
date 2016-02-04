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
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<script type="text/javascript" src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script type="text/javascript" src="<c:url value='/js/base.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/common/date.js'/>"></script>

<script type="text/javascript">
	menuId = "#sos";
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
	  $('.commonPage').hide();
	  $('.massage').show();
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
			    	// 没有查到结果
			    	if(recordList.length == 0){
						$('.commonPage').hide();
						$('.massage').show();
					}
			    	
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
			 <div class="bp_history">
				  <div class="box box-warning">
		              <div class="box-header">
		                  <h3 class="box-title">条件检索</h3>
		              </div>
		              <div class="box-body col-lg-12 col-xs-12">
		              	<div class="col-lg-12 col-xs-12 form-font-size">
			                 <div class="col-lg-6 col-xs-6">
				                  <div>
				                  	  <label class="col-lg-4 col-xs-4 text-right">开始时间:</label>
				                  	  <div class="col-lg-8 col-xs-8 input-group">
				                      <span class="input-group-addon col-lg-2 col-xs-2"><i class="fa fa-calendar"></i></span>
				                      <input type="text" class="col-lg-8 col-xs-8" id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/>
				                  	  </div>
				                  </div>
			                 </div><!-- /.col-lg-3 -->
			                <div class="col-lg-6 col-xs-6">
			                  <div>
				                  	  <label class="col-lg-3 col-xs-3 text-right">结束时间:</label>
				                  	  <div class="col-lg-8 col-xs-8 input-group">
				                      <span class="input-group-addon col-lg-2 col-xs-2"><i class="fa fa-calendar"></i></span>
				                      <input type="text"  class="col-lg-8 col-xs-8"  id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/>
				               		 </div>
				               </div>
			               </div><!-- /.col-lg-3 -->
		              </div><!-- /.box-body -->
		              <div class="col-lg-12 col-xs-12">
		              	<div class="col-lg-8 col-xs-8 text-right">
		              		 <span class="col-lg-3 col-xs-3">快速查询:</span>
		              		 <a href="javascript:changeDate(3)" class="col-lg-2 col-xs-2">最新3天</a>
		              		 <a href="javascript:changeDate(7)" class="col-lg-2 col-xs-2">最近一周</a>
		              		 <a href="javascript:changeDate(30)" class="col-lg-2 col-xs-2">最近30天</a>
		              		 <a href="javascript:changeDate(365)" class="col-lg-2 col-xs-2">最近一年</a>
		              	</div>
		              	<div class="col-lg-3 col-xs-3 text-right">
			               	<button class="btn btn-success" style="margin-left:20px" onclick="queryStart();"><i class="fa fa-search"></i> 查询</button>
			               </div><!-- /.col-lg-3 -->
		              </div>
		          </div>			 

		  	<div class="row">
		  		<br/>
					<div class="col-lg-11 col-xs-11">
			            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table" id="faceTable">
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
			            <div class="massage text-center col-lg-11 col-xs-11" style="color: red;">对不起，没有数据。</div>
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
 				<div id="divloading"><img src="../../../images/public/blue-loading.gif" /></div>
				<div id="transparentDiv" ></div>
				<div id="transparentDiv2"></div>
       		 </div>
       		 </div>
       	</div>
     </aside><!-- /.right-side -->
</div><!-- ./wrapper -->      
</body>
</html>
