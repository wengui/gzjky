<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>医生报告</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>"	type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script type="text/javascript">

  menuId = "#report";
  var startDate="";
  var endDate="";
  var recordList = null;
  var type="";
  function startInit(){
	  // 提示信息
	  $('.massage').hide();
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

	  var requestUrl = "";
	  var para = "startDate=" + startDate + "&endDate=" + endDate
		  +"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	  
	  requestUrl = "/gzjky/doctorReportAction/queryReportList.do";
	  showScreenProtectDiv(2);
	  showLoading();
	  xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			complete:function(){
			    hideScreenProtectDiv(2);
		        hideLoading();
			},
			success:function(response){
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
	  clearFaceTable();
	  var table = document.getElementById("faceTable");
	  if(recordList!=null&&recordList.length>0){
		  for(var i=0;i<$.fn.page.settings.currentsize;i++){
		  	  addrowtotable(table,i);
	  	  }
		  $("table.bPhistory_table tr:even").addClass("even");
		  $("table.bPhistory_table tr:odd").addClass("odd");
	  }
  }
 
  function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);
	 var i = 0;
	 var type= recordList[index].reportType;
	 	td=tr.insertCell(0);
	    td.innerHTML = recordList[index].createdOn.substring(0,19);
	    
	    td=tr.insertCell(1);
	    td.innerHTML =  type==1?'周报':type==2?'月报':type==4?'高血压预判':type==5?'高血压总结':'';
	    
	    td=tr.insertCell(2);
	    td.innerHTML =  recordList[index].hospitalName;
	    
	    td=tr.insertCell(3);
	    td.innerHTML =  recordList[index].doctorName;
	    
	    
	    var report = recordList[index].report;
	    var report_content = recordList[index].report_content;
	    var obj = new Object();
	    obj.type = type ;
	    obj.report = report;
	    obj.report_content = report_content;
	    
	    td=tr.insertCell(4);
	    td.obj = obj;
	    td.innerHTML = "<a href='javascript:void(0)' class='btn btn-info'   onclick=\"showDetail("+index+")\"><i class='fa fa-fw fa-eye'></i></i>查看</a>";
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
  	
  //关闭周报详情窗口
  function closeWeekReport() {
	 //$("#weekreport_detail").hide(200);
	 $("#weekreport_detail").modal('hide');
	 //hideScreenProtectDiv(1);
  }
  //打开周报详情
  function openWeekReport(){
     $('#weekreport_detail').draggable({
			disabled : false
	 });
	 //$("#weekreport_detail").show(200);
	 $("#weekreport_detail").modal('show');
	 //showScreenProtectDiv(1);
  }
  //关闭周报详情窗口
  function closeMonthReport() {
	 //$("#monthreport_detail").hide(200);
	 $("#monthreport_detail").modal('hide');
	 //hideScreenProtectDiv(1);
  }
  //打开周报详情
  function openMonthReport(){
	 $('#monthreport_detail').draggable({
	 	disabled : false
	 });
	 //$("#monthreport_detail").show(200);
	 $("#monthreport_detail").modal('show');
	 //showScreenProtectDiv(1);
  }

  function showDetail(index){
	 var report = recordList[index]
 		
	 var requestUrl = "";
	 var para = "startDate=" + report.starttime+" 00:00:00" + "&endDate=" + report.endtime+" 23:59:59"+"&reportType="+report.reportType;
	 requestUrl = "/gzjky/doctorReportAction/queryReportDetail.do";
	 xmlHttp = $.ajax({
						url: requestUrl,
						async:true,
						data:para,
						dataType:"json",
						type:"POST",
						complete:function(){
						},
				success:function(response){
					// 数据取得
					var modelMap = response.outBeanList;
					report.bp_static =  modelMap[0];
					report.incident =  modelMap[1];
					report.ecg_report =  modelMap[2];
					report.medicine_taken =  modelMap[3];
				 	 //周报
				 	 if(report.reportType==1){
				 	 	analyzeWeek(report);
				 		$("#detail_title").html("周报详情");
				 		openWeekReport();
				 	 }else if(report.reportType==2){
				 		analyzeMonth(report);
						$("#detail_monthreport").html("月报详情");
				 		openMonthReport();
				 	 }
				}
		});
   }
</script>
<style>
.color_y{
	background-color:#f3f4f5;
}
</style>
</head>

<body onload="startInit();" class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
		<!-- Left side column. contains the logo and sidebar -->
		<%@ include file="../../shared/sidebarMenu.jsp"%>
		<aside class="right-side"> <section class="content-header">
		<h1>
			医生报告 <small id="today"></small> <small id="weather"></small>
		</h1>
		<ol class="breadcrumb">
			<li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
			<li>医生报告</li>
			<li class="active">医生报告</li>
		</ol>
		</section>
			<div class="box box-danger">
				<div class="box-header">
					<h3 class="box-title">条件检索</h3>
				</div>
				<div class="box-body">
	              	 <div class="row">
		                 <div class="col-lg-4 col-xs-4"">
				                  	  <label  class="search-label">开始时间:</label>
				                  	  <div class="input-group">
				                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
				                      <input type="text" id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/>
				                  	  </div>
		                 </div>
		                 <div class="col-lg-4 col-xs-4""> 	
				                  	  <label  class="search-label">结束时间:</label>
				                  	  <div class="input-group">
				                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
				                      <input type="text" id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/>
				               		  </div>
			             </div>
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
						<table width="100%" style="border: none;" border="0"
							cellspacing="0" cellpadding="0"
							class="table-bordered bPhistory_table" id="faceTable">
							<colgroup>
								<col width="25%" />
								<col width="15%" />
								<col width="30%" />
								<col width="20%" />
								<col width="10%" />
							</colgroup>
							<tr>
								<th>创建日期</th>
								<th>报告类型</th>
								<th>分析医院</th>
								<th>分析医生</th>
								<th>操作</th>
							</tr>
						</table>
						<div class="massage text-center col-lg-11 col-xs-11" style="color: red;display:none;">对不起，没有数据。</div>
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
					<br />
					<div class="col-lg-4 col-xs-4" style="padding-left: 25px">
						共<span id="showcount"></span>条信息，第<span id="showcurrentnum"></span>页，共<span
							id="showpagecount"></span>页
					</div>
					<div class="col-lg-4 col-xs-4">
						<a href="###" class="page-first">首页</a> <a href="###"
							class="page-perv" style="margin-left: 5px">上一页</a> <a href="###"
							class="page-next" style="margin-left: 5px">下一页</a> <a href="###"
							class="page-last" style="margin-left: 5px">末页</a>
					</div>
					<div class="col-lg-4 col-xs-4" style="padding-left: 18%">
						转<select id="gopage" onchange="gotoPage()"></select>页
					</div>
				</div>
				<!-- /。row -->
				</div>
				<!-- /.box-body -->
			</div>
			<!-- /。box box-danger -->
		</aside>
		<!-- /.right-side -->
	</div>
	<!-- ./wrapper -->
	<div id="divloading">
		<img src="../../../images/public/blue-loading.gif" />
	</div>
	<div id="transparentDiv"></div>
	<div id="transparentDiv2"></div>
</body>
</html>


<script type="text/javascript"	src="<c:url value='/js/highcharts/highcharts.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/js/highcharts/modules/exporting.js'/>"></script>
<style>
#secondview table {
.weekli_disc{
	list-style-type:disc;
}
.weekli_decimal{
	list-style-type:decimal;
}

.weekli_margin{
	margin-left:10px;
}
</style>
<script type="text/javascript">
	//第二版周报解析
	function analyzeWeek(bpWeekReport){
		
		$("#secondview").css("display","block"); 
		//创建日期
		$("#week_tracking_date").html(bpWeekReport.createdOn);
		//统计区间
		$("#week_interval").html(bpWeekReport.starttime+"~"+bpWeekReport.endtime);
		//日平均血压
		//bloodPressureCharts(bpWeekReport.records,'血压趋势图');
		//bloodPressureCharts(null,'血压趋势图');
		
		//血压数据统计表
		bp_static = bpWeekReport.bp_static;
		if(bp_static!=null){
			bp_week_start_plan = 0 ;
			bp_week_end_plan = bp_static.length>10?10:bp_static.length;
			weekdrawPlanbp(bp_week_start_plan,bp_week_end_plan);
			
		}
		bloodPressureCharts(bp_static,'血压趋势图',"0");
	
		//测压异常事件
		weekbprecords = bpWeekReport.incident;
		if(weekbprecords!=null){
			week_start_plan = 0 ;
			week_end_plan = weekbprecords.length>10?10:weekbprecords.length;
			weekdrawPlan(week_start_plan,week_end_plan);
		}
		
		//服用药物
		var medicine_taken = bpWeekReport.medicine_taken;
		 $("#week_plan_medicine tr").eq(0).nextAll().remove();
		if(medicine_taken!=null){
			for(var i=0;i<medicine_taken.length;i++){
				var tr = "<tr><td>"+medicine_taken[i].name+"</td><td>"+medicine_taken[i].dosage+"</td><td>"+medicine_taken[i].takeTime+"</td></tr>";
				$("#week_plan_medicine").append(tr);
			}
		}

		//降压目标
		//$("#bp_target").html("收缩压:"+bpWeekReport.goalOfSBP+"mmhg,舒张压:"+bpWeekReport.goalOfDBP+"mmhg");
		$("#week_target_shrink").html(bpWeekReport.goalOfSBP+"mmhg");
		$("#week_target_diastole").html(bpWeekReport.goalOfDBP+"mmhg");
		
		
		//血压分级
		$("#bp_hype_type").html(bpWeekReport.bloodLevel);
		//风险分层
		$("#risk_level").html(bpWeekReport.riskStratification);
		//心血管风险因素
		$("#cv_risk").html(bpWeekReport.cardiovascularRiskFactors);
		//靶器官损害
		$("#target_organ_damage").html(bpWeekReport.targetOrgan);
		//伴临床疾患
		$("#clinical").html(bpWeekReport.clinicalDisease);
		//血压总体分析
		//$("#mean_bp").html("平均血压:  收缩压:"+bpWeekReport.meanBloodPressureOfSBP+"mmhg,  舒张压:"+bpWeekReport.meanBloodPressureOfDBP+"mmhg");
		//$("#bp_load").html("血压负荷:  收缩压:"+bpWeekReport.bloodPressureLoadOfSBP+"舒张压:"+bpWeekReport.bloodPressureLoadOfDBP+";平均动脉压:"+bpWeekReport.bloodPressureLoadOfMAP+",心律:"+bpWeekReport.bloodPressureLoadOfHR);
		$("#week_avg_bp_shr").html(bpWeekReport.meanBloodPressureOfSBP+"mmhg");
		$("#week_avg_bp_dia").html(bpWeekReport.meanBloodPressureOfDBP+"mmhg");
		$("#week_bp_load_shr").html(bpWeekReport.bloodPressureLoadOfSBP+"mmhg");
		$("#week_bp_load_dia").html(bpWeekReport.bloodPressureLoadOfDBP+"mmhg");
		$("#week_mean_load").html(bpWeekReport.bloodPressureLoadOfMAP+"mmhg");
		$("#week_heart_rate").html(bpWeekReport.bloodPressureLoadOfHR);
		$("#week_cv").html(bpWeekReport.sdMean);
		
		//$("#sbp").html("最大SBP:"+bpWeekReport.maxSBP+",  发生时间:"+bpWeekReport.maxSBPTime+";  最小SBP:"+bpWeekReport.minSBP+",  发生时间:"+bpWeekReport.minSBPTime);
		//$("#dbp").html("最大DBP:"+bpWeekReport.maxDBP+",  发生时间:"+bpWeekReport.maxDBPTime+";  最小DBP:"+bpWeekReport.minDBP+",  发生时间:"+bpWeekReport.minDBPTime);
		$("#week_max_sbp").html(bpWeekReport.maxSBP);
		$("#week_max_sbp_time").html(bpWeekReport.maxSBPTime);
		$("#week_min_sbp").html(bpWeekReport.minSBP);
		$("#week_min_sbp_time").html(bpWeekReport.minSBPTime);
		$("#week_max_dbp").html(bpWeekReport.maxDBP);
		$("#week_max_dbp_time").html(bpWeekReport.maxDBPTime);
		$("#week_min_dbp").html(bpWeekReport.minDBP);
		$("#week_min_dbp_time").html(bpWeekReport.minDBPTime);
		
		//不适症状
		$("#week_plan_inadaptation").html(bpWeekReport.noIndication);
		//测压方案完成情况
		$("#measure_compliance").html(bpWeekReport.completionStatus);
		//总结
		$("#conclusion").html(bpWeekReport.summary);
		//建议
		$("#suggestion").html(bpWeekReport.healthAdvice);
		//分析结果
		$("#detail_doctor_report").html(bpWeekReport.analysisResult);
		//医生建议
		$("#detail_doctor_suggest").html(bpWeekReport.doctorHealthAdvice);
		
	}

	//血压趋势图
	function bloodPressureCharts(records,chartName,flag) {
		var tims = new Array(), cate = new Array();
		var dia = new Array(), shr = new Array(), av = new Array();
		if (records != null && records != 'null') {
			for ( var i = 0; i < records.length; i++) {
				if(i<records.length-1){
				cate[i] = i ;
				}
// 				var datetime= records[i].take_time;
				
// 				if(flag=="2"){
// 					datetime = records[i].create_time;
// 				}
				var datetime= records[i].takeTime;
				
				if (datetime == null) {
					datetime = '未知';
				} else {
					var year = datetime.substring(0, 4);
					if (year == "0200")
						datetime = '未知';
					if (year == "1970")
						datetime = '未知';
					if (year == "0000")
						datetime = '未知';
				}
				
				tims[records.length - i - 1] = datetime;
				var diap = parseInt(records[i].diastole);
				var shrp = parseInt(records[i].shrink);
				var avg = 0;
				//如果是血压等级分析依据图超出阈值的血压点显示红色
				if(flag=="1"){
					if (shrp<60 || shrp>255 || diap<30 || diap>195 || shrp <= diap) {
						dia[records.length - i - 1] = {y:0};
						shr[records.length - i - 1] = {y:0};
					} else {
						if(diap<60 || diap>90){
							dia[records.length - i - 1] = {color:'red',y:diap};
						}else{
							dia[records.length - i - 1] = {y:diap};
						}
						if(shrp<90 || shrp>140 ){
							shr[records.length - i - 1] = {color:'red',y:shrp};
						}else{
							shr[records.length - i - 1] = {y:shrp};
						}
						
						avg = Math.round((((shrp - diap) * 1 / 3) + diap) * 100) / 100;
					}
				}else{
					if (shrp<60 || shrp>255 || diap<30 || diap>195 || shrp <= diap) {
						dia[records.length - i - 1] = 0;
						shr[records.length - i - 1] = 0;
					} else {
						dia[records.length - i - 1] = diap;
						shr[records.length - i - 1] = shrp;
						avg = Math.round((((shrp - diap) * 1 / 3) + diap) * 100) / 100;
					}
				}
				av[records.length - i - 1] = avg;
			}
		}
		
			var renderId="container2";
			var vals = [ {
				name : '收缩压',
				data : shr,
			}, {
				name : '舒张压',
				data : dia
			}];
			if( flag=="0"){
				vals[2]={
				name : '平均压',
				data : av
				};
				renderId="container";
			}
			if( flag=="2"){
				vals[2]={
				name : '平均压',
				data : av
				};
				renderId="container1";
			}
			if( flag=="1"){
				vals[2]={
				name : '平均压',
				data : av
				};
				renderId="container2";
			}
			
			var ss = "";
			if (tims[0] != '未知')
				ss = tims[0];
				
			var text = '收缩压/舒张压(毫米汞柱)';
			
			new Highcharts.Chart({
				chart : {
					renderTo : renderId,
					defaultSeriesType : 'line',
					marginRight : 80,
					marginBottom : 45
				},
				colors:['#71A944','#51b336','#ff9600'],
				title:{
				text : chartName
				},
				xAxis : {
					categories : cate
				},
				yAxis : {
				
					title : {
						text : text
					},
					//max:150,
					//min:60,
					//tickInterval:25,
					lineWidth:1,
					plotLines : [ {
						value : 0,
						width : 1,
						color : '#808080'
					} ]
				},
				
				tooltip : {
					formatter : function() {
						var tips='';
						if( flag=="0"||flag=="2"){
							 tips='<b>' + tims[this.x ] + '</b><br/>'
									+ vals[0].name + ': ' + shr[this.x ]
									+ '毫米汞柱<br/>' + vals[1].name + ': '
									+ dia[this.x ] + '毫米汞柱<br/>';
									
								
						}else{
							 tips='<b>' + tims[this.x ] + '</b><br/>'
									+ vals[0].name + ': ' + shr[this.x ].y
									+ '毫米汞柱<br/>' + vals[1].name + ': '
									+ dia[this.x ].y + '毫米汞柱<br/>';
									
						}
						tips+=vals[2].name
									+ ': ' + av[this.x ] + '毫米汞柱';
						return tips;
					}
				},
				legend : {
					layout : 'vertical',
					align : 'right',
					verticalAlign : 'top',
					x : 5,
					y : 100,
					borderWidth : 0
				},
				exporting:{ 
                     enabled:false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示 
                },
                credits: {
            	  enabled: false//去掉highcharts水印
        		},
				series : vals
			});
			
			

	}	
	
	var weekbprecords ="";//测压完成情况集合
	var week_start_plan=0;//测压完成情况开始条数
	var week_end_plan=0;//测压完成情况结束条数
	function weekdrawPlan(start,end){
	 	$("#week_plan_unnormal tr").eq(0).nextAll().remove();
		if(weekbprecords!=null){
			for(var i=start;i<end;i++){
				var tr = "<tr><td>"+weekbprecords[i].shrink+"/"+weekbprecords[i].diastole+"</td><td>"+weekbprecords[i].takeTime+"</td><td>"+""+"</td></tr>";
				$("#week_plan_unnormal").append(tr);
			}
			if(weekbprecords.length>10){
				var str="<tr><td colspan='3' align='center' style='width: 100%'><a href='javascript:void(0);'   onclick='week_prevPlan();' >上页</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'   onclick='week_nextPlan();' >下页</a></td></tr>";
				$("#week_plan_unnormal").append(str);
			}
		}
	}
	function week_prevPlan(){
		if(week_start_plan!=0){
			week_end_plan =  week_start_plan;
			week_start_plan = week_start_plan-10;
			weekdrawPlan(week_start_plan,week_end_plan);
		}
	}
	function week_nextPlan(){
		if(weekbprecords.length>week_end_plan){
			week_start_plan = week_end_plan;
			week_end_plan= week_end_plan+10<weekbprecords.length?week_end_plan+10:weekbprecords.length;
			weekdrawPlan(week_start_plan,week_end_plan);
		}
	}
	
	var bp_static ="";//血压数据统计集合
	var bp_week_start_plan=0;//血压数据统计始条数
	var bp_week_end_plan=0;//血压数据统计结束条数
	function weekdrawPlanbp(start,end){
		 $("#week_bp_static tr").eq(0).nextAll().remove();
		if(bp_static!=null){
			for(var i=start;i<end;i++){
				var tr = "<tr><td>"+bp_static[i].takeTime+"</td><td>"+bp_static[i].shrink+"</td><td>"+bp_static[i].diastole+"</td><td>"+bp_static[i].pressureValue+"</td><td>"+""+"</td><td>"+bp_static[i].heartRate+"</td></tr>";
				$("#week_bp_static").append(tr);
			}
			if(bp_static.length>10){
				var str="<tr><td colspan='6' align='center' style='width: 100%'><a href='javascript:void(0);'   onclick='week_prevBp();' >上页</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'   onclick='week_nextBp();' >下页</a></td></tr>";
				$("#week_bp_static").append(str);
			}
		}
	}
	function week_prevBp(){
		if(bp_week_start_plan!=0){
			bp_week_end_plan =  bp_week_start_plan;
			bp_week_start_plan = bp_week_start_plan-10;
			weekdrawPlanbp(bp_week_start_plan,bp_week_end_plan);
		}
	}
	function week_nextBp(){
		if(bp_static.length>bp_week_end_plan){
			bp_week_start_plan = bp_week_end_plan;
			bp_week_end_plan= bp_week_end_plan+10<bp_static.length?bp_week_end_plan+10:bp_static.length;
			weekdrawPlanbp(bp_week_start_plan,bp_week_end_plan);
		}
	}
</script>
<div class="modal fade" id="weekreport_detail" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:5%" >
  <div class="modal-dialog" style="width:1100px">
		<div class="popup_header">
			<ul>
				<li class="name_popupHeader" id="detail_title">周报详情</li>
				<li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal" class="d-close"></a></li>
			</ul>
		</div>

		<div class="popup_main" id="secondview" style="display: none;">
			<div class="row" >
				<div class="col-lg-12">
					 <div class="box box-info">
                        <div class="box-header">
                            <i class="fa fa-bar-chart-o"></i>
                            <h3 class="box-title">血压趋势图</h3>
                    	</div><!-- /.box-header -->
						<div class="box-body">
							<div class="row bpDiagnosis_results_trendChart">
								<div class="col-sm-12">
									<div id="container" style="height:250px;width:50%"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		    <div class="row" >
				<div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab_1" data-toggle="tab"><i class="fa fa-pencil-square-o"></i> 分析结果</a></li>
                            <li class=""><a href="#tab_2" data-toggle="tab"><i class="fa fa-book"></i> 数据统计</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab_1">

                            	<ul>
									<li class="weekli_disc weekli_margin"><span class="monthli_color">创建日期：</span><span class="tblack_results" id="week_tracking_date"></span></li>
									<li class="weekli_disc weekli_margin"><span class="monthli_color">统计区间：</span><span class="tblack_results" id="week_interval"></span></li> 
									<li class="weekli_disc weekli_margin monthli_color">总体情况：</li>
								</ul>	
	                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="detailtable table table-bordered dataTable">
									<colgroup>
										<col width="20%">
										<col width="20%">
										<col width="20%">
										<col width="20%">
										<col width="20%">
										<col width="20%">
									</colgroup>
									<tbody><tr>
										<td rowspan="2" class="color_y">降压目标</td>
										<td class="color_y">收缩压</td>
										<td id="week_target_shrink"></td>
										<td class="color_y">血压等级</td>
										<td id="bp_hype_type"></td>
									</tr>
									<tr>
										<td class="color_y">舒张压</td>
										<td id="week_target_diastole"></td>
										<td class="color_y">风险分层</td>
										<td id="risk_level">数据不足</td>
									</tr>
									<tr>
										<td colspan="2" rowspan="1" class="color_y" >心血管风险因素</td>
										<td colspan="3" id="cv_risk">&nbsp;</td>
									</tr>
									<tr id="month_tr_target_organ_damage">
										<td colspan="2" class="color_y" >靶器官损害</td>
										<td colspan="3" id="target_organ_damage">&nbsp;</td>
									</tr>
									<tr id="month_tr_clinical">
										<td colspan="2" class="color_y" rowspan="3">伴临床疾患</td>
										<td colspan="3" id="clinical"></td>
									</tbody>
								</table>		

                            	<ul>
									<li class="monthli_disc monthli_margin monthli_color">血压总体分析：</li>
								</ul>	
								<table width="100%" border="0" cellspacing="0" cellpadding="0"  class="detailtable table table-bordered dataTable">
									<colgroup>
										<col width="20%">
										<col width="15%">
										<col width="15%">
										<col width="20%">
										<col width="15%">
										<col width="15%">
									</colgroup>
									<tbody>
										<tr>
											<td rowspan="2" class="color_y">平均血压</td>
											<td class="color_y">收缩压</td>
											<td id="week_avg_bp_shr"></td>
											<td rowspan="4" class="color_y">血压负荷</td>
											<td class="color_y">收缩压</td>
											<td id="week_bp_load_shr"></td>
										</tr>
										<tr>
											<td class="color_y">舒张压</td>
											<td id="week_avg_bp_dia"></td>
											<td class="color_y">舒张压</td>
											<td id="week_bp_load_dia"></td>
										</tr>
										<tr>
											<td rowspan="2" class="color_y">血压变异性</td>
											<td colspan="2" rowspan="2" id="week_cv"></td>
											<td class="color_y">平均动脉压</td>
											<td id="week_mean_load"></td>
										</tr>
										<tr>
											<td class="color_y">心率</td>
											<td id="week_heart_rate"></td>
										</tr>
										<tr>
											<td class="color_y">最大SBP</td>
											<td colspan="2" id="week_max_sbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="week_max_sbp_time"></td>
										</tr>
										<tr>
											<td class="color_y">最小SBP</td>
											<td colspan="2" id="week_min_sbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="week_min_sbp_time"></td>
										</tr>
										<tr>
											<td class="color_y">最大DBP</td>
											<td colspan="2" id="week_max_dbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="week_max_dbp_time"></td>
										</tr>
										<tr>
											<td class="color_y">最小DBP</td>
											<td colspan="2" id="week_min_dbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="week_min_dbp_time"></td>
										</tr>
									</tbody>
								</table>                            
                            
 
 								<ul>
									<li class="weekli_disc weekli_margin monthli_color">分析小结：</li>
								</ul>	                            
	                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="detailtable table table-bordered dataTable">
										<colgroup>
											<col width="20%">
											<col width="80%">
										</colgroup>
										<tbody>
											<tr>
												<td class="color_y">不适应症情况：</td>
												<td id="week_plan_inadaptation"></td>
											</tr>
											<tr>
												<td class="color_y">测压方案完成情况：</td>
												<td id="measure_compliance"></td>
											</tr>
											<tr >
												<td class="color_y">总结：</td>
												<td id="conclusion"></td>
											</tr>
											<tr>
												<td class="color_y">保健建议：</td>
												<td id="suggestion"></td>
											</tr>
											<tr >
												<td class="color_y">医生分析结果：</td>
												<td id="detail_doctor_report"></td>
											</tr>
											<tr >
												<td class="color_y">医生建议： </td>
												<td id="detail_doctor_suggest"></td>
											</tr>
										</tbody>
								</table>	
                            </div><!-- /.tab-pane -->
                            <div class="tab-pane" id="tab_2">				
								<ul>
									<li class="weekli_disc weekli_margin monthli_color">血压数据统计表：</li>
									<li class="weekli_margin">
										<table class="detailtable table table-bordered table-striped dataTable" id="week_bp_static" >
											<tr>
												<td>时间</td>
												<td>收缩压</td>
												<td>舒张压</td>
												<td>脉压</td>
												<td>平均动脉压</td>
												<td>心律</td>
											</tr>
										</table>
									</li>
									<li class="weekli_disc weekli_margin monthli_color">测压异常事件情况：</li>
									<li class="weekli_margin">
										<table class="detailtable table table-bordered table-striped dataTable" id="week_plan_unnormal">
											<tr>
												<td width="25%">血压值</td>
												<td width="45%">测压时间</td>
												<td width="40%">反馈</td>
											</tr>
										</table>
									</li>
									<li class="weekli_disc weekli_margin monthli_color">服用药物情况：</li>
									<li class="weekli_margin">
										<table class="detailtable table table-bordered table-striped dataTable" id="week_plan_medicine" >
											<tr>
												<td width="25%">通用名称</td>
												<td width="10%">剂量</td>
												<td width="50%">服用时间</td>
											</tr>
										</table>
									</li>																
								</ul>
							</div>
						</div>
               	</div>
               <!-- col-lg-6 -->
			</div>
			<!-- row -->
		</div>
	</div>
</div>

<style>
table th {
	text-align: center;
	border-bottom: 1px solid #aeaeae;
}

.detailtable tr td {
	border-bottom: 1px solid #aeaeae;
	border-right: 1px solid #aeaeae;
	padding: 5px;
	vertical-align: top;
}
.monthli_decimal{
	list-style-type:decimal;
}

.monthli_margin{
	margin-left:10px;
}
.monthli_color{
	color: #3c8dbc;
}
</style>
<script type="text/javascript">
var bprecords ="";//测压完成情况集合
var start_plan=0;//测压完成情况开始条数
var end_plan=0;//测压完成情况结束条数
var version=0;//版本 	

	function analyzeMonth(bpMonthReport){
	
		$("#month_secondview").css("display","block");
		
		$("#month_tracking_date").html(bpMonthReport.createdOn);
		$("#month_interval").html(bpMonthReport.starttime+"~"+bpMonthReport.endtime);
		//日平均血压
		//bloodPressureCharts(null,'血压趋势图');
		version = 1;
		//血压统计
		bp_static = bpMonthReport.bp_static;
		if(bp_static!=null){
			bp_start_plan = 0 ;
			bp_end_plan = bp_static.length>10?10:bp_static.length;
			drawPlanbp(bp_start_plan,bp_end_plan);
			
		}

		//测压异常事件
		bprecords = bpMonthReport.incident;
		if(bprecords!=null){
			start_plan = 0 ;
			end_plan = bprecords.length>10?10:bprecords.length;
			drawPlan(start_plan,end_plan);
		}
		
		//服用药物
		var medicine_taken = bpMonthReport.medicine_taken;
		 $("#plan_medicine2 tr").eq(0).nextAll().remove();
		if(medicine_taken!=null){
			for(var i=0;i<medicine_taken.length;i++){
				var tr = "<tr><td>"+medicine_taken[i].name+"</td><td>"+medicine_taken[i].dosage+"</td><td>"+medicine_taken[i].takeTime+"</td></tr>"
				$("#plan_medicine2").append(tr);
			}
		}
		
		//心电监护结果
		ecg_report = bpMonthReport.ecg_report;

		if(ecg_report!=null){
			ecg_start_plan = 0 ;
			ecg_end_plan = ecg_report.length>10?10:ecg_report.length;
			drawPlanecg(ecg_start_plan,ecg_end_plan);
			
		}
		
		//降压目标
		//$("#month_bp_target").html("收缩压:"+bpMonthReport.goalOfSBP+"mmhg,舒张压:"+bpMonthReport.goalOfDBP+"mmhg");
		$("#month_target_shrink").html(bpMonthReport.goalOfSBP+"mmhg");
		$("#month_target_diastole").html(bpMonthReport.goalOfDBP+"mmhg");
		
		//血压分级
		$("#month_bp_hype_type").html(bpMonthReport.bloodLevel);
		//风险分层
		$("#month_risk_level").html(bpMonthReport.riskStratification);
		//心血管风险因素
		$("#month_cv_risk").html(bpMonthReport.cardiovascularRiskFactors);
		//靶器官损害
		$("#month_target_organ_damage").html(bpMonthReport.targetOrgan);
		//伴临床疾患
		$("#month_clinical").html(bpMonthReport.clinicalDisease);
		//血压总体分析
		//$("#month_mean_bp").html("平均血压:  收缩压:"+bpMonthReport.meanBloodPressureOfSBP+"mmhg,  舒张压: "+bpMonthReport.meanBloodPressureOfDBP+"mmhg");
		//$("#month_bp_load").html("血压负荷:  收缩压:"+bpMonthReport.bloodPressureLoadOfSBP+"  舒张压:"+bpMonthReport.bloodPressureLoadOfDBP+";  平均动脉压:"+bpMonthReport.bloodPressureLoadOfMAP+"  心律:"+bpMonthReport.bloodPressureLoadOfHR);
		$("#month_avg_bp_shr").html(bpMonthReport.meanBloodPressureOfSBP+"mmhg");
		$("#month_avg_bp_dia").html(bpMonthReport.meanBloodPressureOfDBP+"mmhg");
		$("#month_bp_load_shr").html(bpMonthReport.bloodPressureLoadOfSBP+"mmhg");
		$("#month_bp_load_dia").html(bpMonthReport.bloodPressureLoadOfDBP+"mmhg");
		$("#month_mean_load").html(bpMonthReport.bloodPressureLoadOfMAP+"mmhg");
		$("#month_heart_rate").html(bpMonthReport.bloodPressureLoadOfHR);
		$("#month_cv").html(bpMonthReport.sdMean);

		//$("#month_sbp").html("最大SBP:"+bpMonthReport.maxSBP+",  发生时间:"+bpMonthReport.maxSBPTime+";  最小SBP:"+bpMonthReport.minSBP+",  发生时间:"+bpMonthReport.minSBPTime);
		//$("#month_dbp").html("最大DBP:"+bpMonthReport.maxDBP+",  发生时间:"+bpMonthReport.maxDBPTime+";  最小DBP:"+bpMonthReport.minDBP+",  发生时间:"+bpMonthReport.minDBPTime);
		$("#month_max_sbp").html(bpMonthReport.maxSBP);
		$("#month_max_sbp_time").html(bpMonthReport.maxSBPTime);
		$("#month_min_sbp").html(bpMonthReport.minSBP);
		$("#month_min_sbp_time").html(bpMonthReport.minSBPTime);

		$("#month_max_dbp").html(bpMonthReport.maxDBP);
		$("#month_max_dbp_time").html(bpMonthReport.maxDBPTime);
		$("#month_min_dbp").html(bpMonthReport.minDBP);
		$("#month_min_dbp_time").html(bpMonthReport.minDBPTime);		
		
		//不适症状
		$("#plan_inadaptation2").html(bpMonthReport.noIndication);
		//测压方案完成情况
		$("#month_measure_compliance").html(bpMonthReport.completionStatus);
		//总结
		$("#month_conclusion").html(bpMonthReport.summary);
		//建议
		$("#month_suggestion").html(bpMonthReport.healthAdvice);
		var level = document.getElementById("assessment_level");
		var state = document.getElementById("user_state");
		for(var i=0;i<level.options.length;i++) {  
            if(level.options[i].value == bpMonthReport.assessmentLevel) {  
            	level.options[i].selected = true;  
                break;  
            }  
        } 
		for(var i=0;i<state.options.length;i++) {  
            if(state.options[i].value == bpMonthReport.userStatus) {  
            	state.options[i].selected = true;  
                break;  
            }  
        }
		//医生总结
		$("#doctor_result").html(bpMonthReport.doctorSummary);
	}
	function drawPlan(start,end){
		$("#plan_unnormal2 tr").eq(0).nextAll().remove();
		if(bprecords!=null){
			for(var i=start;i<end;i++){
				var tr = "<tr><td>"+bprecords[i].shrink+"/"+bprecords[i].diastole+"</td><td>"+bprecords[i].takeTime+"</td><td>"+""+"</td></tr>";
				$("#plan_unnormal2").append(tr);
			}
			if(bprecords.length>10){
				var str="<tr><td colspan='3' align='center' style='width: 100%'><a href='javascript:void(0);'   onclick='prevPlan();' >上页</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'   onclick='nextPlan();' >下页</a></td></tr>";
				$("#plan_unnormal2").append(str);
			}
		}
	}
	function prevPlan(){
		if(start_plan!=0){
			end_plan =  start_plan;
			start_plan = start_plan-10;
			drawPlan(start_plan,end_plan);
		}
	}
	function nextPlan(){
		if(bprecords.length>end_plan){
			start_plan = end_plan;
			end_plan= end_plan+10<bprecords.length?end_plan+10:bprecords.length;
			drawPlan(start_plan,end_plan);
		}
	}
	var bp_static ="";//血压数据统计集合
	var bp_start_plan=0;//血压数据统计始条数
	var bp_end_plan=0;//血压数据统计结束条数
	function drawPlanbp(start,end){
		 $("#month_bp_static tr").eq(0).nextAll().remove();
		if(bp_static!=null){
			for(var i=start;i<end;i++){
				var tr = "<tr><td>"+bp_static[i].takeTime+"</td><td>"+bp_static[i].shrink+"</td><td>"+bp_static[i].diastole+"</td><td>"+bp_static[i].pressureValue+"</td><td>"+""+"</td><td>"+bp_static[i].heartRate+"</td></tr>";
				$("#month_bp_static").append(tr);
			}
			if(bp_static.length>10){
				var str="<tr><td colspan='6' align='center' style='width: 100%'><a href='javascript:void(0);'   onclick='prevBp();' >上页</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'   onclick='nextBp();' >下页</a></td></tr>";
				$("#month_bp_static").append(str);
			}
		}
	}
	function prevBp(){
		if(bp_start_plan!=0){
			bp_end_plan =  bp_start_plan;
			bp_start_plan = bp_start_plan-10;
			drawPlanbp(bp_start_plan,bp_end_plan);
		}
	}
	function nextBp(){
		if(bp_static.length>bp_end_plan){
			bp_start_plan = bp_end_plan;
			bp_end_plan= bp_end_plan+10<bp_static.length?bp_end_plan+10:bp_static.length;
			drawPlanbp(bp_start_plan,bp_end_plan);
		}
	}
	
	
	var ecg_report ="";//血压数据统计集合
	var ecg_start_plan=0;//血压数据统计始条数
	var ecg_end_plan=0;//血压数据统计结束条数
	function drawPlanecg(start,end){
	 $("#month_ecg_report tr").eq(0).nextAll().remove();
	if(ecg_report!=null){
		for(var i=start;i<end;i++){
			var tr = "<tr><td>"+ecg_report[i].takeTime+"</td><td>"+ecg_report[i].timeLength+"</td><td>"+ecg_report[i].heartRate+"</td><td>"+""+"</td></tr>";
			$("#month_ecg_report").append(tr);
		}
		if(ecg_report.length>10){
			var str="<tr><td colspan='4' align='center' style='width: 100%;'><a href='javascript:void(0);'   onclick='prevEcg();' >上页</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'   onclick='nextEcg();' >下页</a></td></tr>";
			$("#month_ecg_report").append(str);
		}
	}
	}
	function prevEcg(){
		if(ecg_start_plan!=0){
			ecg_end_plan =  ecg_start_plan;
			ecg_start_plan = ecg_start_plan-10;
			drawPlanecg(ecg_start_plan,ecg_end_plan);
		}
	}
	function nextEcg(){
		if(ecg_report.length>bp_end_plan){
			ecg_start_plan = ecg_end_plan;
			ecg_end_plan= ecg_end_plan+10<ecg_report.length?ecg_end_plan+10:ecg_report.length;
			drawPlanecg(ecg_start_plan,ecg_end_plan);
		}
	}
	
</script>
<div class="modal fade" id="monthreport_detail" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:5%" >
  <div class="modal-dialog" style="width:1100px">
		<div class="popup_header">
			<ul>
				<li class="name_popupHeader" id="detail_monthreport">月报详情</li>
				<li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal" class="d-close"></a></li>
			</ul>
		</div>

		<div class="popup_main">
		    <div class="row" id="month_secondview" style="display: none;">
		    	<div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab_3" data-toggle="tab"><i class="fa fa-pencil-square-o"></i> 分析结果</a></li>
                            <li class=""><a href="#tab_4" data-toggle="tab"><i class="fa fa-book"></i> 数据统计</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab_3">
                            
                            	<ul>
									<li class="monthli_disc monthli_margin"><span class="monthli_color">创建日期：</span><span class="tblack_results" id="month_tracking_date"></span></li>
									<li class="monthli_disc monthli_margin"><span class="monthli_color">统计区间：</span><span class="tblack_results" id="month_interval"></span></li> 
									<li class="monthli_disc monthli_margin monthli_color">总体情况：<span class="tblack_results" id="month_interval"></span></li>
								</ul>	
	                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="detailtable table table-bordered dataTable">
									<colgroup>
										<col width="20%">
										<col width="20%">
										<col width="20%">
										<col width="20%">
										<col width="20%">
										<col width="20%">
									</colgroup>
									<tbody><tr>
										<td rowspan="2" class="color_y">降压目标</td>
										<td class="color_y">收缩压</td>
										<td id="month_target_shrink"></td>
										<td class="color_y">血压等级</td>
										<td id="month_bp_hype_type"></td>
									</tr>
									<tr>
										<td class="color_y">舒张压</td>
										<td id="month_target_diastole"></td>
										<td class="color_y">风险分层</td>
										<td id="month_risk_level">数据不足</td>
									</tr>
									<tr id="month_tr_cv_risk">
										<td colspan="2" rowspan="1" class="color_y" >心血管风险因素</td>
										<td colspan="3" id="month_cv_risk">&nbsp;</td>
									</tr>
									<tr id="month_tr_target_organ_damage">
										<td colspan="2" class="color_y" >靶器官损害</td>
										<td colspan="3" id="month_target_organ_damage">&nbsp;</td>
									</tr>
									<tr id="month_tr_clinical">
										<td colspan="2" class="color_y" rowspan="3">伴临床疾患</td>
										<td colspan="3" id="month_clinical"></td>
									</tbody>
								</table>		

                            	<ul>
									<li class="monthli_disc monthli_margin monthli_color">血压总体分析：</li>
								</ul>	
								<table width="100%" border="0" cellspacing="0" cellpadding="0"  class="detailtable table table-bordered dataTable">
									<colgroup>
										<col width="20%">
										<col width="15%">
										<col width="15%">
										<col width="20%">
										<col width="15%">
										<col width="15%">
									</colgroup>
									<tbody>
										<tr>
											<td rowspan="2" class="color_y">平均血压</td>
											<td class="color_y">收缩压</td>
											<td id="month_avg_bp_shr"></td>
											<td rowspan="4" class="color_y">血压负荷</td>
											<td class="color_y">收缩压</td>
											<td id="month_bp_load_shr"></td>
										</tr>
										<tr>
											<td class="color_y">舒张压</td>
											<td id="month_avg_bp_dia"></td>
											<td class="color_y">舒张压</td>
											<td id="month_bp_load_dia"></td>
										</tr>
										<tr>
											<td rowspan="2" class="color_y">血压变异性</td>
											<td colspan="2" rowspan="2" id="month_cv"></td>
											<td class="color_y">平均动脉压</td>
											<td id="month_mean_load"></td>
										</tr>
										<tr>
											<td class="color_y">心率</td>
											<td id="month_heart_rate"></td>
										</tr>
										<tr>
											<td class="color_y">最大SBP</td>
											<td colspan="2" id="month_max_sbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="month_max_sbp_time"></td>
										</tr>
										<tr>
											<td class="color_y">最小SBP</td>
											<td colspan="2" id="month_min_sbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="month_min_sbp_time"></td>
										</tr>
										<tr>
											<td class="color_y">最大DBP</td>
											<td colspan="2" id="month_max_dbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="month_max_dbp_time"></td>
										</tr>
										<tr>
											<td class="color_y">最小DBP</td>
											<td colspan="2" id="month_min_dbp"></td>
											<td class="color_y">发生时间</td>
											<td colspan="2" id="month_min_dbp_time"></td>
										</tr>
									</tbody>
								</table>
								<ul>
									<li class="monthli_disc monthli_margin monthli_color">分析小结：</li>
								</ul>	                            
	                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="detailtable table table-bordered dataTable">
										<colgroup>
											<col width="20%">
											<col width="80%">
										</colgroup>
										<tbody>
											<tr>
												<td class="color_y">不适应症情况：</td>
												<td id="plan_inadaptation2"></td>
											</tr>
											<tr>
												<td class="color_y">测压方案完成情况：</td>
												<td id="month_measure_compliance"></td>
											</tr>
											<tr >
												<td class="color_y">总结：</td>
												<td id="month_conclusion"></td>
											</tr>
											<tr>
												<td class="color_y">保健建议：</td>
												<td id="month_suggestion"></td>
											</tr>
											<tr >
												<td class="color_y">评估等级：</td>
												<td id="plan_inadaptation2">
														<select id="assessment_level" disabled="disabled">
															<option value="高">高</option>
															<option value="中">中</option>
															<option value="低">低</option>
														</select>
												</td>
											</tr>
											<tr >
												<td class="color_y">用户状态： </td>
												<td id="plan_inadaptation2">
													<select id="user_state" disabled="disabled">
														<option value="恢复迅速">恢复迅速</option>
														<option value="有好转">有好转</option>
														<option value="无好转">无好转</option>
														<option value="更严重">更严重</option>
													</select>
												</td>
											</tr>
											<tr>
												<td class="color_y">医生总结：</td>
												<td id="doctor_result"></td>
											</tr>
										</tbody>
								</table>	
                            </div><!-- /.tab-pane -->
                            <div class="tab-pane" id="tab_4">
								<ul>
									<li class="monthli_disc monthli_margin monthli_color">血压数据统计表：</li>
									<li class="tblack_results monthli_margin">
										<table class="detailtable table table-bordered table-striped dataTable" id="month_bp_static">
											<tr>
												<td >时间</td>
												<td>收缩压</td>
												<td>舒张压</td>
												<td>脉压</td>
												<td>平均动脉压</td>
												<td>心率</td>
											</tr>
										</table>
									</li>
									<li class="monthli_disc monthli_margin monthli_color">测压异常事件情况：</li>
									<li class="tblack_results monthli_margin">
										<table class="detailtable table table-bordered table-striped dataTable" id="plan_unnormal2">
											<tr>
												<td width="25%">血压值</td>
												<td width="35%">测压时间</td>
												<td width="50%">反馈</td>
											</tr>
										</table>
									</li>
									<li class="monthli_disc monthli_margin monthli_color">服用药物情况：</li>
									<li class="tblack_results monthli_margin">
										<table class="detailtable table table-bordered table-striped dataTable" id="plan_medicine2">
											<tr>
												<td  width="25%">通用名称</td>
												<td width="10%">剂量</td>
												<td width="50%">服用时间</td>
											</tr>
										</table>
									</li>
									<li class="monthli_disc monthli_margin monthli_color">心电监护结果：</li>
									<li class="tblack_results monthli_margin">
										<table class="detailtable table table-bordered table-striped dataTable" id="month_ecg_report">
											<tr>
												<td width="25%">采集时间</td>
												<td width="12%">采集时长</td>
												<td width="12%">平均心率</td>
												<td width="51%">分析结果</td>
											</tr>
										</table>
									</li>
								</ul>
                            </div><!-- /.tab-pane -->
                        </div><!-- /.tab-content -->
                  </div>
			</div>
			<!-- row -->
		</div>
	</div>
</div>


