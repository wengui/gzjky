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
	    td.align="center";
	    
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
	    td.innerHTML = "<a href='javascript:void(0)' onclick=\"showDetail("+index+")\">详情</a>";
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
		<div class="bp_history">
			<div class="box box-danger">
				<div class="box-header">
					<h3 class="box-title">条件检索</h3>
				</div>
				<div class="box-body">
					<div class="row">
						<div class="col-lg-3">
							<div class="input-group">
								<label>开始时间:</label> <span class="input-group-addon"><i
									class="fa fa-calendar"></i></span> <input type="text"
									class="form-control" id="startDate" name="startDate"
									onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})" />
							</div>
						</div>
						<!-- /.col-lg-3 -->
						<div class="col-lg-3">
							<div class="input-group">
								<label>结束时间:</label> <span class="input-group-addon"><i
									class="fa fa-calendar"></i></span> <input type="text"
									class="form-control" id="endDate" name="endDate"
									onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startDate\')}'})" />
							</div>
						</div>
						<!-- /.col-lg-3 -->
						<div class="col-lg-3">
							<button class="btn btn-success" style="margin-left: 20px"
								onclick="queryStart();"><i class="fa fa-search"></i> 查询</button>
						</div>
						<!-- /.col-lg-3 -->
						<div class="col-lg-3"></div><!-- /.col-lg-3 -->
					</div>
					<!-- /row -->
					<div class="row">
						<br />
						<div class="col-lg-6">
							<label>快速查询:</label> <a href="javascript:changeDate(3)"
								style="margin-left: 20px; margin-right: 15px;">最新3天</a> <a
								href="javascript:changeDate(7)" style="margin-right: 15px;">最近一周</a>
							<a href="javascript:changeDate(30)" style="margin-right: 15px;">最近30天</a>
							<a href="javascript:changeDate(365)">最近一年</a>
						</div>
						<!-- /.col-lg-6 -->
					</div>
					<!-- /row -->
				</div>
				<!-- /.box-body -->
				<div class="row">
					<br />
					<div class="col-lg-11">
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
					<br />
					<div class="col-lg-4" style="padding-left: 25px">
						共<span id="showcount"></span>条信息，第<span id="showcurrentnum"></span>页，共<span
							id="showpagecount"></span>页
					</div>
					<div class="col-lg-4">
						<a href="###" class="page-first">首页</a> <a href="###"
							class="page-perv" style="margin-left: 5px">上一页</a> <a href="###"
							class="page-next" style="margin-left: 5px">下一页</a> <a href="###"
							class="page-last" style="margin-left: 5px">末页</a>
					</div>
					<div class="col-lg-4" style="padding-left: 18%">
						转<select id="gopage" onchange="gotoPage()"></select>页
					</div>
				</div>
				<!-- /。row -->
			</div>
			<!-- /。box box-danger -->
		</div>
		<!-- /.bp_history -->
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
	width: 430px;
	border: 1px solid #aeaeae;
	border-collapse: collapse;
	margin-left: 20px;
}

#secondview th {
	text-align: center;
	border-bottom: 1px solid #aeaeae;
}

#secondview td {
	border-bottom: 1px solid #aeaeae;
	border-right: 1px solid #aeaeae;
	padding: 5px;
	vertical-align: top;
}
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
		bloodPressureCharts(null,'血压趋势图');
		
		//血压数据统计表
		bp_static = bpWeekReport.bp_static;
		if(bp_static!=null){
			bp_week_start_plan = 0 ;
			bp_week_end_plan = bp_static.length>10?10:bp_static.length;
			weekdrawPlanbp(bp_week_start_plan,bp_week_end_plan);
			
		}
	
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
		$("#bp_target").html("收缩压:"+bpWeekReport.goalOfSBP+"mmhg,舒张压:"+bpWeekReport.goalOfDBP+"mmhg");
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
		$("#mean_bp").html("平均血压:  收缩压:"+bpWeekReport.meanBloodPressureOfSBP+"mmhg,  舒张压:"+bpWeekReport.meanBloodPressureOfDBP+"mmhg");
		$("#bp_load").html("血压负荷:  收缩压:"+bpWeekReport.bloodPressureLoadOfSBP+"舒张压:"+bpWeekReport.bloodPressureLoadOfDBP+";平均动脉压:"+bpWeekReport.bloodPressureLoadOfMAP+",心律:"+bpWeekReport.bloodPressureLoadOfHR);
		$("#cv").html("血压变异性:"+bpWeekReport.sdMean);
		$("#sbp").html("最大SBP:"+bpWeekReport.maxSBP+",  发生时间:"+bpWeekReport.maxSBPTime+";  最小SBP:"+bpWeekReport.minSBP+",  发生时间:"+bpWeekReport.minSBPTime);
		$("#dbp").html("最大DBP:"+bpWeekReport.maxDBP+",  发生时间:"+bpWeekReport.maxDBPTime+";  最小DBP:"+bpWeekReport.minDBP+",  发生时间:"+bpWeekReport.minDBPTime);
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
	function bloodPressureCharts(records,chartName) {
		var tims = new Array(), cate = new Array();
		var dia = new Array(), shr = new Array(), av = new Array();
		
		if (records != null && records != 'null') {
			for ( var i = 0; i < records.length; i++) {
				if(i<records.length-1){
				cate[i] = i ;
				}
				
				var datetime= records[i].take_time;
				
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
				var diap = records[i].diastole; 
				var shrp = records[i].shrink;
				
				var avg = 0;
				if (shrp<60 || shrp>255 || diap<30 || diap>195 || shrp <= diap) {
				
					dia[records.length - i - 1] = 0;
					shr[records.length - i - 1] = 0;
				} else {
					dia[records.length - i - 1] = diap;
					shr[records.length - i - 1] = shrp;
					avg = Math.round((((shrp - diap) * 1 / 3) + diap) * 100) / 100;
				}
				av[records.length - i - 1] = avg;
			}
		}
			var vals = [ {
				name : '收缩压',
				data : shr
			}, {
				name : '舒张压',
				data : dia
			}];
			
				vals[2]={
				name : '平均压',
				data : av
				};
			
			var ss = "";
			if (tims[0] != '未知')
				ss = tims[0];
				
			var text = '收缩压/舒张压(毫米汞柱)';
		
			new Highcharts.Chart({
				chart : {
					renderTo : 'container',
					defaultSeriesType : 'line',
					marginRight : 80,
					marginBottom : 45
				},
				colors:['#0ca7a1','#51b336','#ff9600'],
				title:{
				text : chartName
				},
				xAxis : {
					categories : cate,
					 plotLines: [{
			                label: {
			                	rotation: 40
			                }
			            }]
				},
				yAxis : {
				
					title : {
						text : text
					},
					lineWidth:1,
					plotLines : [ {
						value : 0,
						width : 1,
						color : '#808080'
					} ]
				},
				
				tooltip : {
					formatter : function() {
						var tips='<b>' + tims[this.x ] + '</b><br/>'
								+ vals[0].name + ': ' + shr[this.x ]
								+ '毫米汞柱<br/>' + vals[1].name + ': '
								+ dia[this.x ] + '毫米汞柱<br/>';
								
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
				<li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal">X</a></li>
			</ul>
		</div>

		<div class="popup_main" id="secondview" style="display: none;">
			<div class="row" >
				<div class="col-lg-12">
					 <div class="box box-success">
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
                  <div class="col-lg-6">
	                <div class="box box-success">
                          <div class="box-header">
                            <i class="fa fa-pencil-square-o"></i>
                            <h3 class="box-title">分析结果</h3>
                    	</div><!-- /.box-header -->
						<div class="box-body">
						<!-- 周报第二版展示 -->
						<ul>
							<li class="weekli_disc weekli_margin">创建日期：<span class="tblack_results" id="week_tracking_date"></span></li>
							<li class="weekli_disc weekli_margin">统计区间：<span class="tblack_results" id="week_interval"></span></li>
							<li class="weekli_disc weekli_margin">降压目标：<span class="tblack_results" id="bp_target"></span></li>
							<li class="weekli_disc weekli_margin">血压分级：<span class="tblack_results" id="bp_hype_type"></span></li>
							<li class="weekli_disc weekli_margin">风险分层：<span class="tblack_results" id="risk_level"></span></li>
							<li class="weekli_disc weekli_margin">心血管风险因素：</li>
							<li class="weekli_margin"><span class="tblack_results"	id="cv_risk"></span></li>
							<li class="weekli_disc weekli_margin">靶器官损害：</li>
							<li class="weekli_margin"><span class="tblack_results"	id="target_organ_damage"></span></li>
							<li class="weekli_disc weekli_margin">伴临床疾患：</li>
							<li class="weekli_margin"><span class="tblack_results"	id="clinical"></span></li>
							<li class="weekli_disc weekli_margin">血压总体分析：</li>
							<li class="weekli_margin" id="mean_bp"></li>
							<li class="weekli_margin" id="bp_load"></li>
							<li class="weekli_margin" id="cv"></li>
							<li class="weekli_margin" id="sbp"></li>
							<li class="weekli_margin" id="dbp"></li>
							<li class="weekli_disc weekli_margin">不适应症情况：</li>
							<li class="weekli_margin"><span id="week_plan_inadaptation"style="border: 0px;"> </span></li>
							<li class="weekli_disc weekli_margin">测压方案完成情况：</li>
							<li class="weekli_margin"><span id="measure_compliance"></span></li>
							<li class="weekli_disc weekli_margin">总结：</li>
							<li class="weekli_margin" id="conclusion"></li>
							<li class="weekli_disc weekli_margin">保健建议：</li>
							<li class="weekli_margin" id="suggestion"></li>
							<li class="weekli_disc weekli_margin">医生分析结果： <span class="tblack_results" id="detail_doctor_report"></span>	</li>
							<li class="weekli_disc weekli_margin">医生建议： <span class="tblack_results" id="detail_doctor_suggest"></span></li>
						</ul>
	               		</div>
	           		</div>
	           </div>
               <div class="col-lg-6">
					<div class="box box-success">
	                     <div class="box-header">
	                       <i class="fa fa-book"></i>
	                       <h3 class="box-title">数据统计</h3>
	                     </div><!-- /.box-header -->
						<div class="box-body">					
							<ul>
								<li class="weekli_disc weekli_margin">血压数据统计表：</li>
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
								<li class="weekli_disc weekli_margin">测压异常事件情况：</li>
								<li class="weekli_margin">
									<table class="detailtable table table-bordered table-striped dataTable" id="week_plan_unnormal">
										<tr>
											<td width="15%">血压值</td>
											<td width="45%">测压时间</td>
											<td width="40%">反馈</td>
										</tr>
									</table>
								</li>
								<li class="weekli_disc weekli_margin">服用药物情况：</li>
								<li class="weekli_margin">
									<table class="detailtable table table-bordered table-striped dataTable" id="week_plan_medicine" >
										<tr>
											<td>通用名称</td>
											<td>剂量</td>
											<td>服用时间</td>
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
.monthli_disc{
	list-style-type:disc;
}
.monthli_decimal{
	list-style-type:decimal;
}

.monthli_margin{
	margin-left:10px;
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
		bloodPressureCharts(null,'血压趋势图');
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
		$("#month_bp_target").html("收缩压:"+bpMonthReport.goalOfSBP+"mmhg,舒张压:"+bpMonthReport.goalOfDBP+"mmhg");
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
		$("#month_mean_bp").html("平均血压:  收缩压:"+bpMonthReport.meanBloodPressureOfSBP+"mmhg,  舒张压: "+bpMonthReport.meanBloodPressureOfDBP+"mmhg");
		$("#month_bp_load").html("血压负荷:  收缩压:"+bpMonthReport.bloodPressureLoadOfSBP+"  舒张压:"+bpMonthReport.bloodPressureLoadOfDBP+";  平均动脉压:"+bpMonthReport.bloodPressureLoadOfMAP+"  心律:"+bpMonthReport.bloodPressureLoadOfHR);
		$("#month_cv").html("血压变异性:"+bpMonthReport.sdMean);
		$("#month_sbp").html("最大SBP:"+bpMonthReport.maxSBP+",  发生时间:"+bpMonthReport.maxSBPTime+";  最小SBP:"+bpMonthReport.minSBP+",  发生时间:"+bpMonthReport.minSBPTime);
		$("#month_dbp").html("最大DBP:"+bpMonthReport.maxDBP+",  发生时间:"+bpMonthReport.maxDBPTime+";  最小DBP:"+bpMonthReport.minDBP+",  发生时间:"+bpMonthReport.minDBPTime);
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
				<li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal">X</a></li>
			</ul>
		</div>

		<div class="popup_main">
		    <div class="row" id="month_secondview" style="display: none;">
                  <div class="col-lg-6">
	                  <div class="box box-info">
                          <div class="box-header">
                            <i class="fa fa-pencil-square-o"></i>
                            <h3 class="box-title">分析结果</h3>
                          </div><!-- /.box-header -->
						<div class="box-body">
							<ul>
								<li class="monthli_disc monthli_margin">创建日期：<span class="tblack_results" id="month_tracking_date"></span></li>
								<li class="monthli_disc monthli_margin">统计区间：<span class="tblack_results" id="month_interval"></span></li>
								<li class="monthli_disc monthli_margin">降压目标：<span class="tblack_results" id="month_bp_target"></span></li>
								<li class="monthli_disc monthli_margin">血压分级：<span class="tblack_results" id="month_bp_hype_type"></span></li>
								<li class="monthli_disc monthli_margin">风险分层：<span class="tblack_results" id="month_risk_level"></span></li>
								<li class="monthli_disc monthli_margin">心血管风险因素：</li>
								<li class="monthli_margin"><span class="tblack_results" id="month_cv_risk"></span> </li>
								<li class="monthli_disc monthli_margin">靶器官损害：</li>
								<li class="monthli_margin"><span class="tblack_results"	id="month_target_organ_damage"></span></li>
								<li class="monthli_disc monthli_margin">伴临床疾患：</li>
								<li class="monthli_margin"><span class="tblack_results" id="month_clinical"></span></li>
								<li class="monthli_disc monthli_margin">血压总体分析：</li>
								<li class="monthli_margin" id="month_mean_bp"></li>
								<li class="monthli_margin" id="month_bp_load"></li>
								<li class="monthli_margin" id="month_cv"></li>
								<li class="monthli_margin" id="month_sbp"></li>
								<li class="monthli_margin" id="month_dbp"></li>
								<li class="monthli_disc monthli_margin">不适应症情况：</li>
								<li class="monthli_margin"><span id="plan_inadaptation2"style="border: 0px;"> </span></li>
								<li class="monthli_disc monthli_margin">测压方案完成情况：</li>
								<li class="monthli_margin"><span id="month_measure_compliance"></span></li>
			
								<li class="monthli_disc monthli_margin">总结：</li>
								<li class="monthli_margin" id="month_conclusion"></li>
								<li class="monthli_disc monthli_margin">保健建议：</li>
								<li class="monthli_margin" id="month_suggestion"></li>
								<li class="monthli_disc monthli_margin">评估等级：<select id="assessment_level" disabled="disabled">
											<option value="高">高</option>
											<option value="中">中</option>
											<option value="低">低</option>
										</select>
										用户状态： <select id="user_state" disabled="disabled">
											<option value="恢复迅速">恢复迅速</option>
											<option value="有好转">有好转</option>
											<option value="无好转">无好转</option>
											<option value="更严重">更严重</option>
										</select>
								</li>
								<li class="monthli_disc monthli_margin">总结：<span class="tGrey_ecgname" id="doctor_result"></span>
								</li>
							</ul>
						</div>
                  	</div>
                  </div>
                  <div class="col-lg-6">
				   <div class="box box-info">
                        <div class="box-header">
                          <i class="fa fa-book"></i>
                          <h3 class="box-title">数据统计</h3>
                        </div><!-- /.box-header -->
						<div class="box-body">
							<ul>
								<li class="monthli_disc monthli_margin">血压数据统计表：</li>
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
								<li class="monthli_disc monthli_margin">测压异常事件情况：</li>
								<li class="tblack_results monthli_margin">
									<table class="detailtable table table-bordered table-striped dataTable" id="month_bp_static"id="plan_unnormal2">
										<tr>
											<td width="15%">血压值</td>
											<td width="35%">测压时间</td>
											<td width="50%">反馈</td>
										</tr>
									</table>
								</li>
								<li class="monthli_disc monthli_margin">服用药物情况：</li>
								<li class="tblack_results monthli_margin">
									<table class="detailtable table table-bordered table-striped dataTable" id="plan_medicine2">
										<tr>
											<td>通用名称</td>
											<td>剂量</td>
											<td>服用时间</td>
										</tr>
									</table>
								</li>
								<li class="monthli_disc monthli_margin">心电监护结果：</li>
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
						</div>
					</div>
                  </div>
                  <!-- col-lg-7 -->
			</div>
			<!-- row -->
		</div>
	</div>
</div>


