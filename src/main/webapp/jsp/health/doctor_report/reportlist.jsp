<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120医生服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>

<script type="text/javascript">

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
		  
		  requestUrl = "/doctorReportAction/queryReportList.action";
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
				    var modelMap = response.modelMap;
				    recordList = modelMap.reportList;
				    if(modelMap.recordTotal==undefined){
				    	$.fn.page.settings.count = 1;
				    }else{
				    	$.fn.page.settings.count = modelMap.recordTotal;
				    }
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
	 var type= recordList[index].type;
	 	td=tr.insertCell(0);
	    td.innerHTML = recordList[index].create_time.substring(0,19);
	    td.align="center";
	    
	    td=tr.insertCell(1);
	    td.innerHTML =  type==2?'周报':type==3?'月报':type==4?'高血压预判':type==5?'高血压总结':'';
	    
	    td=tr.insertCell(2);
	    td.innerHTML =  recordList[index].hosptial_name;
	    
	    td=tr.insertCell(3);
	    td.innerHTML =  recordList[index].doctor_name;
	    
	    
	    var report = recordList[index].report;
	    var report_content = recordList[index].report_content;
	    var obj = new Object();
	    obj.type = type ;
	    obj.report = report;
	    obj.report_content = report_content;
	    
	    td=tr.insertCell(4);
	    td.obj = obj;
	    td.innerHTML = "<a href='javascript:void(0)' onclick=\"showDetail(this.parentNode.obj)\">详情</a>";
	  
	    
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
		$("#weekreport_detail").hide(200);
		hideScreenProtectDiv(1);
	}
	//打开周报详情
  	function openWeekReport(){
  		$('#weekreport_detail').draggable({
			disabled : false
		});
		$("#weekreport_detail").show(200);
		showScreenProtectDiv(1);
  	}
	//关闭周报详情窗口
	function closeMonthReport() {
		$("#monthreport_detail").hide(200);
		hideScreenProtectDiv(1);
	}
	//打开周报详情
  	function openMonthReport(){
  		$('#monthreport_detail').draggable({
			disabled : false
		});
		$("#monthreport_detail").show(200);
		showScreenProtectDiv(1);
  	}
  	function showDetail(obj){
  		//周报
  		if(obj.type==2||obj.type==4){
  			analyzeWeek(obj.report_content,obj.report);
  			if(obj.type==2){
  				$("#detail_title").html("周报详情");
  			}else{
  				$("#detail_title").html("高血压预判详情");
  			}
  			openWeekReport();
  		}else if(obj.type==3||obj.type==5){
  			analyzeMonth(obj.report_content,obj.report);
  			if(obj.type==3){
  				$("#detail_monthreport").html("月报详情");
  			}else{
  				$("#detail_monthreport").html("高血压跟踪详情");
  			}
  			openMonthReport();
  		}
  	}
</script>
</head>

<body onload="startInit();" style="background:#e8e3d7">
<!--bp_history start-->
<div class="example-item alt-color gradient">
  <div class="tabs_framed styled" >
    <div class="inner tab_menu">
       <ul class="tabs clearfix active_bookmark1">
            <li class="active"><a href="#eq" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;">我的设备</a></li>
       </ul>
	   <div class="tab-content clearfix">
	     <div class="tab-pane fade in active" id="eq">
	       <div class="equipment">
	         <div class="tgreen_title_BPhistory">医生报告</div>
				<div class="bp_history" style="height: 1000px;">
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
				      <li><a href="javascript:void(0)" class="btn  btn_search" onclick="queryStart()"><span style="font-size:17px; font-weight:500;color:#5a5a5a">查询</span></a></li>            
				    </ul>
				  </div>
				  <div class="index_table">
				    <table width="100%" style="border: none;" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table" id="faceTable">
				      <colgroup>
				        <col width="25%" />
				        <col width="15%" />
				        <col width="30%" />
				        <col width="20%" />
				        <col width="10%" />
				      </colgroup>
				      <tr >
				        <th>创建日期</th>
				        <th>报告类型</th>
				        <th>分析医院</th>
				        <th>分析医生</th>
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
</div>
</div>
</div>
</div>
</div>
</div>
  

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
   

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120医生服务中心</title>
<script type="text/javascript" src="<c:url value='/js/highcharts/highcharts.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/highcharts/modules/exporting.js'/>"></script>
<style>
#secondview table{width:430px; border:1px solid #aeaeae; border-collapse: collapse;margin-left: 20px;}
#secondview th{text-align:center; border-bottom:1px solid #aeaeae; }
#secondview td{border-bottom:1px solid #aeaeae; border-right:1px solid #aeaeae; padding:5px;vertical-align: top;}
</style>
<script type="text/javascript">
	//解析周报XML
	function analyzeWeek(xml,report) {
		
		var doctor_report = "report_content="+report;

		xmlHttp = $.ajax({
			url:"/doctorReportAction/analyzeDoctorReport.action",
			async:true,
			data:doctor_report,
			dataType:"json",
			type:"POST",
			success:function(response) {
				var modelMap = response.modelMap;
				var doctor_reports = modelMap.doctor_report;
				
				if(doctor_reports!=null){
			
					$("#detail_doctor_report").html(doctor_reports.report);
					$("#detail_doctor_suggest").html(doctor_reports.Suggestion);
				}
				}
			});
	
		xml =  encodeURI(xml);  
		xml =  encodeURI(xml); 
		var para = "report_content="+xml;
		
		xmlHttp = $.ajax({
			url:"/doctorReportAction/analyzeWeekReport.action",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			success:function(response) {
				var modelMap = response.modelMap;
				var bpWeekReport = modelMap.bpWeekReport;
				if(bpWeekReport!=null){
					if(bpWeekReport.version=='1.0.0'){
						firstWeekVersion(bpWeekReport);
					}else if(bpWeekReport.version=='1.1.0'){
						$("#secondview").css("display","block"); 
						$("#view").css("display","none"); 
						secondWeekVersion(bpWeekReport);
					}
					
				}
		}
	});
	}
	//第一版本周报解析
	function firstWeekVersion(bpWeekReport){
		bloodPressureCharts(bpWeekReport.records,'血压趋势图');
		var target_diastole='';
		var target_shrink = '';
		if(bpWeekReport.target_shrink!=''){
			target_shrink = bpWeekReport.target_shrink+"mmHg";
			$("#target_shrink").html("目标收缩压:"+target_shrink);
		}
		if(bpWeekReport.target_diastole!=''){
			target_diastole = bpWeekReport.target_diastole+"mmHg";
			$("#target_diastole").html("目标舒张压:"+target_diastole);
		}
		var avgBp = '';
		if(bpWeekReport.avgBp!=''){
			var arr = bpWeekReport.avgBp.split(",");
			avgBp = "收缩压:"+arr[0]+"mmHg,收缩压:"+arr[1]+"mmHg";
		}
		$("#tracking_date").html(avgBp);
		var riskLvl = bpWeekReport.risk;
		var riskLvls=["低危","中危","高危","很高危"];//心血管的分层
		var riskVal=riskLvls[parseInt(riskLvl)-1];
		$("#level").html(riskLvl==""?"暂无":riskVal);
		var angiocarpyList = bpWeekReport.basis;
		var risk="";
		if(bpWeekReport.hype_type == '0'){
			$("#hyper_type").html("暂无");
			if(angiocarpyList!=null){
				for ( var i = 0; i < angiocarpyList.length; i++) {
					var ag = "(" + (i + 1) + ")" + angiocarpyList[i] + "<br/>";
					risk += ag;
				}
				  $("#basis").html(risk==""?"暂无":risk);
			}
		}else{
			
			if(angiocarpyList== ''){
				$("#hyper_type").html(bpWeekReport.bp_level);
			}else{
				$("#hyper_type").html(angiocarpyList[0]);
			}
			if(angiocarpyList!=null){
				for ( var i = 1; i < angiocarpyList.length; i++) {
					var ag = "(" + i  + ")" + angiocarpyList[i] + "<br/>";
					risk += ag;
				}
				  $("#basis").html(risk==""?"暂无":risk);
			}
		}
		
	 	var suggestion="";
	 	var suggestionList  = bpWeekReport.suggestion;
	  	if(suggestionList!=null){
			for ( var i = 0; i < suggestionList.length; i++) {
			var su = "(" + (i + 1) + ")" + suggestionList[i] + "<br>";
			suggestion += su;
		}
	  		$("#suggest").html(suggestion==""?"暂无":suggestion);
	  	}
	}
	//第二版周报解析
	function secondWeekVersion(bpWeekReport){
		$("#week_tracking_date").html(bpWeekReport.create_time);
		$("#week_interval").html(bpWeekReport.start_time+"~"+bpWeekReport.end_time);
		//日平均血压
		bloodPressureCharts(bpWeekReport.records,'血压趋势图');
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
				var tr = "<tr><td>"+medicine_taken[i].name+"</td><td>"+medicine_taken[i].dosage+"</td><td>"+medicine_taken[i].take_time+"</td></tr>";
				$("#week_plan_medicine").append(tr);
			}
		}
	
		//不适症状
		var sideeffect = bpWeekReport.sideeffect;
		if(sideeffect!=null){
			var tr = "";
			for(var i=0;i<sideeffect.length;i++){
				 tr += "("+(i+1)+")"+sideeffect[i];
			}
			$("#week_plan_inadaptation").html(tr);
		}
		//血压统计
		bp_static = bpWeekReport.bp_static;
		if(bp_static!=null){
			bp_week_start_plan = 0 ;
			bp_week_end_plan = bp_static.length>10?10:bp_static.length;
			weekdrawPlanbp(bp_week_start_plan,bp_week_end_plan);
			
		}
		//降压目标
		$("#bp_target").html("收缩压:"+bpWeekReport.target_shrink+"mmhg,舒张压:"+bpWeekReport.target_diastole+"mmhg");
		//血压分级
		$("#bp_hype_type").html(bpWeekReport.hype_type);
		//风险分层
		$("#risk_level").html(bpWeekReport.risk);
		//心血管风险因素
		$("#cv_risk").html(bpWeekReport.cv_risk);
		//靶器官损害
		$("#target_organ_damage").html(bpWeekReport.target_organ_damage);
		//伴临床疾患
		$("#clinical").html(bpWeekReport.clinical);
		//血压总体分析
		$("#mean_bp").html("平均血压:收缩压:"+bpWeekReport.comprehensive_analyse.mean_shrink+"mmhg,舒张压:"+bpWeekReport.comprehensive_analyse.mean_diastole+"mmhg");
		$("#bp_load").html("血压负荷:收缩压:"+bpWeekReport.comprehensive_analyse.shrink_load+"舒张压:"+bpWeekReport.comprehensive_analyse.diastole_load+";平均动脉压:"+bpWeekReport.comprehensive_analyse.map_load+",心律:"+bpWeekReport.comprehensive_analyse.hr_load);
		$("#cv").html("血压变异性:"+bpWeekReport.comprehensive_analyse.cv);
		$("#sbp").html("最大SBP:"+bpWeekReport.comprehensive_analyse.max_SBP+",发生时间:"+bpWeekReport.comprehensive_analyse.max_SBP_time+";最小SBP:"+bpWeekReport.comprehensive_analyse.min_SBP+",发生时间:"+bpWeekReport.comprehensive_analyse.min_SBP_time);
		$("#dbp").html("最大DBP:"+bpWeekReport.comprehensive_analyse.max_DBP+",发生时间:"+bpWeekReport.comprehensive_analyse.max_DBP_time+";最小DBP:"+bpWeekReport.comprehensive_analyse.min_DBP+",发生时间:"+bpWeekReport.comprehensive_analyse.min_DBP_time);
		//测压方案完成情况
		$("#measure_compliance").html(bpWeekReport.measure_compliance);
		//总结
		var conclusion = bpWeekReport.conclusion;
		if(conclusion!=null){
			var tr = "";
			for(var i=0;i<conclusion.length;i++){
				 tr += "("+(i+1)+")"+conclusion[i];
			}
			$("#conclusion").html(tr);
		}
		//建议
		var suggestion = bpWeekReport.suggestion;
		if(suggestion!=null){
			var tr = "";
			for(var i=0;i<suggestion.length;i++){
				 tr += "("+(i+1)+")"+suggestion[i];
			}
			$("#suggestion").html(tr);
		}
		
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
			var tr = "<tr><td>"+weekbprecords[i].value.replace(",","/")+"</td><td>"+weekbprecords[i].time+"</td><td>"+weekbprecords[i].description+"</td></tr>";
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
			var tr = "<tr><td>"+bp_static[i].take_time+"</td><td>"+bp_static[i].shrink+"</td><td>"+bp_static[i].diastole+"</td><td>"+bp_static[i].pulse_pressure+"</td><td>"+bp_static[i].mean_arterial_pressure+"</td><td>"+bp_static[i].heart_rate+"</td></tr>";
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

</head>

<body >
 <div class="popup" id="weekreport_detail" style="display:none;position:absolute;top:20px; left:20px;z-index: 30;width: 630px;">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader" id="detail_title">周报详情</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeWeekReport();">X</a></li>
    </ul>
  </div>
  
  <div class="popup_main">       
	   <div  id="container" style="width: 600px;height: 200px;" class="bpDiagnosis_results_trendChart" >
     </div>
     <!-- 周报第一版展示  -->
     <div class="bpDiagnosis_results" >
         <div class="bpDiagnosis_results_text" id="view" style="float: left;width: 600px;">
          <ul>
            <li class="tgreen_results" id="target_bpdown" >降压目标：<span  class="tblack_results" id="target_shrink"></span><span class="tblack_results" id="target_diastole"></span></li>
            <li class="tgreen_results">本周平均压：<span id="tracking_date" class="tblack_results"></span></li>
            <li class="tgreen_results">高血压等级： <span class="tblack_results" id="hyper_type"></span></li>
            <li class="tgreen_results">心血管风险分层：<span class="tblack_results" id="level"></span></li>
            <li class="tgreen_results">判断依据：</li>
            <li class="tblack_results" id="basis"></li>
           	<li class="tgreen_results">保健建议：</li>
            <li class="tblack_results" id="suggest"></li>
          </ul>
        </div>
        
      </div>   
      <!-- 周报第二版展示 -->
       <div class="bpDiagnosis_results_text" id="secondview" style="float: left;width: 600px;display: none;" >
          <ul>
           <li class="tgreen_results">创建日期：<span class="tblack_results" id="week_tracking_date" ></span></li>
            <li class="tgreen_results">统计区间：<span class="tblack_results" id="week_interval"></span></li>
            <li class="tgreen_results">降压目标：<span class="tblack_results" id="bp_target" ></span></li>
            <li class="tgreen_results">血压分级：<span class="tblack_results" id="bp_hype_type"></span></li>
            <li class="tgreen_results">风险分层：<span class="tblack_results" id="risk_level"></span></li>
               <li class="tgreen_results" >心血管风险因素：</span>
            </li>
             <li class="tblack_results"><span class="tblack_results" id="cv_risk"></li>
            <li class="tgreen_results" >靶器官损害：</li>
            <li class="tblack_results"><span class="tblack_results" id="target_organ_damage"></span></li>
            <li class="tgreen_results" >伴临床疾患：</li>
            <li class="tblack_results"><span class="tblack_results" id="clinical"></span></li>
            
            <li class="tgreen_results">血压数据统计表：</li>
            <li class="tblack_results">
	            <table class="detailtable" id="week_bp_static" style="width:560px; border:1px solid #aeaeae; border-collapse: collapse;">
	            <tr><td>时间 </td><td>收缩压</td><td>舒张压</td><td>脉压</td><td>平均动脉压</td><td>心律</td></tr>
	            </table>
            </li>
            <li class="tgreen_results">血压总体分析：</li>
            <li class="tblack_results" id="mean_bp"></li>
            <li class="tblack_results" id="bp_load"></li>
            <li class="tblack_results" id="cv"></li>
            <li class="tblack_results" id="sbp"></li>
            <li class="tblack_results" id="dbp"></li>
           
            
             <li class="tgreen_results">测压异常事件情况：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="week_plan_unnormal" style="width:560px; border:1px solid #aeaeae; border-collapse: collapse;">
	            <tr><td width="15%">血压值 </td><td width="45%">测压时间</td><td width="40%">反馈</td></tr>
	            </table>
            </li>
             <li class="tgreen_results">服用药物情况：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="week_plan_medicine" style="width:560px; border:1px solid #aeaeae; border-collapse: collapse;">
	            <tr><td>通用名称</td><td>剂量</td><td>服用时间</td></tr>
	            </table>
            </li>
            
             <li class="tgreen_results">不适应症情况：</li>
            <li class="tblack_results">
            	<span id="week_plan_inadaptation" style="border: 0px;">
	           
	            </span>
           
            </li>
             <li class="tgreen_results">测压方案完成情况：</li><li class="tblack_results" ><span id="measure_compliance" ></span></li>
            <li class="tgreen_results">总结：</li>
            <li class="tblack_results" id="conclusion"></li>
            <li class="tgreen_results">保健建议：</li>
            <li class="tblack_results" id="suggestion"></li>
           	
          </ul>
        </div>
        <!-- 医生分析结果 -->
        <div class="tgreen_results">
      	 医生分析结果：
        <span class="tblack_results" id="detail_doctor_report"></span>
        </div>
        <div class="tgreen_results">医生建议：
        <span class="tblack_results" id="detail_doctor_suggest"></span>
        </div>
  </div>
 
 </div>

</body>
</html>

   

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120医生服务中心</title>
<style>
#plan_inadaptation,#plan_complete,#plan_unnormal,#plan_medicine,#month_secondview table{width:430px; border:1px solid #aeaeae; border-collapse: collapse;margin-left: 20px;}
 table th{text-align:center; border-bottom:1px solid #aeaeae; }
 .detailtable tr td{border-bottom:1px solid #aeaeae; border-right:1px solid #aeaeae; padding:5px;vertical-align: top;}
</style>
<script type="text/javascript">
var bprecords ="";//测压完成情况集合
var start_plan=0;//测压完成情况开始条数
var end_plan=0;//测压完成情况结束条数
var version=0;//版本 	
//解析月报XML
function analyzeMonth(xml,report) {
	xml =  encodeURI(xml);  
	xml =  encodeURI(xml); 
	var para = "report_content="+xml;
	$.ajax({
		url:"/doctorReportAction/analyzeMonthReport.action",
		async:true,
		data:para,
		dataType:"json",
		type:"POST",
		success:function(response) {
			var modelMap = response.modelMap;
			var bpMonthReport = modelMap.bpMonthReport;
			if(bpMonthReport!=null){
				if(bpMonthReport.version=='1.0.0'){
					firstVersion(bpMonthReport);
				}else if(bpMonthReport.version=='1.1.0'){
					
					$("#month_secondview").css("display","block"); 
					$("#month_view").css("display","none"); 
					secondVersion(bpMonthReport);
				}
			}
	}
		
});
	var doctor_report = "report_content="+report;
	xmlHttp = $.ajax({
		url:"/doctorReportAction/analyzeDoctorReport.action",
		async:true,
		data:doctor_report,
		dataType:"json",
		type:"POST",
		success:function(response) {
			var modelMap = response.modelMap;
			var doctor_reports = modelMap.doctor_report;
			
			if(doctor_reports!=null){
				$("#unnormal_analyse").html(doctor_reports.anomalous);
				$("#inadaptation_analyse").html(doctor_reports.inadaptation);
				var level = document.getElementById("assessment_level");
				var state = document.getElementById("user_state");
				for(var i=0;i<level.options.length;i++) {  
		            if(level.options[i].value == doctor_reports.state) {  
		            	level.options[i].selected = true;  
		                break;  
		            }  
		        } 
				for(var i=0;i<state.options.length;i++) {  
		            if(state.options[i].value == doctor_reports.level) {  
		            	state.options[i].selected = true;  
		                break;  
		            }  
		        }
				if(doctor_reports.report!=null){
					$("#doctor_result").html("总结："+doctor_reports.report);
				}
			}
			}
		});
}

//第一版本月报解析
function firstVersion(bpMonthReport){
	$("#tracking_date_create").html(bpMonthReport.create_time);
	$("#interval").html(bpMonthReport.start_time+"~"+bpMonthReport.end_time);
	$("#month_level").html(bpMonthReport.hype_type+"("+bpMonthReport.risk+")");
	$("#target").html("收缩压 "+bpMonthReport.target_shrink+"&nbsp;舒张压"+bpMonthReport.target_diastole);
	
	bprecords = bpMonthReport.measure_plan;
	if(bprecords!=null){
		start_plan = 0 ;
		end_plan = bprecords.length>10?10:bprecords.length;
		drawPlan(start_plan,end_plan);
	}
	var incident = bpMonthReport.incident;
	 $("#plan_unnormal tr").eq(0).nextAll().remove();
	if(incident!=null){
		for(var i=0;i<incident.length;i++){
			var tr = "<tr><td>"+incident[i].time+"</td><td>"+incident[i].value+"</td><td>"+incident[i].description+"</td></tr>"
			$("#plan_unnormal").append(tr);
		}
	}
	var medicine_taken = bpMonthReport.medicine_taken;
	 $("#plan_medicine tr").eq(0).nextAll().remove();
	if(medicine_taken!=null){
		for(var i=0;i<medicine_taken.length;i++){
			var tr = "<tr><td>"+medicine_taken[i].name+"</td><td>"+medicine_taken[i].dosage+"</td><td>"+medicine_taken[i].take_time+"</td></tr>"
			$("#plan_medicine").append(tr);
		}
	}
	var sideeffect = bpMonthReport.sideeffect;
	if(sideeffect!=null){
		var tr = "";
		for(var i=0;i<sideeffect.length;i++){
			 tr += "("+(i+1)+")"+sideeffect[i];
		}
		$("#plan_inadaptation").html(tr);
	}
	var effect = bpMonthReport.effect;
	$("#effect").html(effect);
	var suggestion="";
	var suggestionList = bpMonthReport.suggestion;
	if(suggestionList!=null){
		for ( var i = 0; i < suggestionList.length; i++) {
		var su = "(" + (i + 1) + ")" + suggestionList[i] + "<br>";
		suggestion += su;
	}
  		$("#ecg_suggest").html(suggestion==""?"暂无":suggestion);
  	}
}


//第二版月报解析
	function secondVersion(bpMonthReport){
		$("#month_tracking_date").html(bpMonthReport.create_time);
		$("#month_interval").html(bpMonthReport.start_time+"~"+bpMonthReport.end_time);
		//日平均血压
		///bloodPressureCharts(bpMonthReport.records,'血压趋势图');
			version = 1;
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
				var tr = "<tr><td>"+medicine_taken[i].name+"</td><td>"+medicine_taken[i].dosage+"</td><td>"+medicine_taken[i].take_time+"</td></tr>"
				$("#plan_medicine2").append(tr);
			}
		}
		//不适症状
		var sideeffect = bpMonthReport.sideeffect;
		if(sideeffect!=null){
			var tr = "";
			for(var i=0;i<sideeffect.length;i++){
				 tr += "("+(i+1)+")"+sideeffect[i];
			}
			$("#plan_inadaptation2").html(tr);
		}
		//血压统计
		bp_static = bpMonthReport.bp_static;
		if(bp_static!=null){
			bp_start_plan = 0 ;
			bp_end_plan = bp_static.length>10?10:bp_static.length;
			drawPlanbp(bp_start_plan,bp_end_plan);
			
		}
		//服用药物后血压变化
		//var medicine_effect = bpMonthReport.medicine_effect;
		// $("#month_medicine_effect tr").eq(0).nextAll().remove();
		//if(medicine_effect!=null){
		//	for(var i=0;i<medicine_effect.length;i++){
		//		var tr = "<tr><td>"+medicine_effect[i].brand+"</td><td>"+medicine_effect[i].time+"</td><td>"+medicine_effect[i].weekly_mean_pressure+"</td></tr>"
		//		$("#month_medicine_effect").append(tr);
		//	}
		//}
		
		//心电监护结果
		ecg_report = bpMonthReport.ecg_report;

		if(ecg_report!=null){
			ecg_start_plan = 0 ;
			ecg_end_plan = ecg_report.length>10?10:ecg_report.length;
			drawPlanecg(ecg_start_plan,ecg_end_plan);
			
		}
		//降压目标
		$("#month_bp_target").html("收缩压:"+bpMonthReport.target_shrink+"mmhg,舒张压:"+bpMonthReport.target_diastole+"mmhg");
		//血压分级
		$("#month_bp_hype_type").html(bpMonthReport.hype_type);
		//风险分层
		$("#month_risk_level").html(bpMonthReport.risk);
		//心血管风险因素
		$("#month_cv_risk").html(bpMonthReport.cv_risk);
		//靶器官损害
		$("#month_target_organ_damage").html(bpMonthReport.target_organ_damage);
		//伴临床疾患
		$("#month_clinical").html(bpMonthReport.clinical);
		//血压总体分析
		$("#month_mean_bp").html("平均血压:收缩压:"+bpMonthReport.comprehensive_analyse.mean_shrink+"mmhg,舒张压:"+bpMonthReport.comprehensive_analyse.mean_diastole+"mmhg");
		$("#month_bp_load").html("血压负荷:收缩压:"+bpMonthReport.comprehensive_analyse.shrink_load+"舒张压:"+bpMonthReport.comprehensive_analyse.diastole_load+";<br/>平均动脉压:"+bpMonthReport.comprehensive_analyse.map_load+",心律:"+bpMonthReport.comprehensive_analyse.hr_load);
		$("#month_cv").html("血压变异性:"+bpMonthReport.comprehensive_analyse.cv);
		$("#month_sbp").html("最大SBP:"+bpMonthReport.comprehensive_analyse.max_SBP+",发生时间:"+bpMonthReport.comprehensive_analyse.max_SBP_time+";最小SBP:"+bpMonthReport.comprehensive_analyse.min_SBP+",发生时间:"+bpMonthReport.comprehensive_analyse.min_SBP_time);
		$("#month_dbp").html("最大DBP:"+bpMonthReport.comprehensive_analyse.max_DBP+",发生时间:"+bpMonthReport.comprehensive_analyse.max_DBP_time+";最小DBP:"+bpMonthReport.comprehensive_analyse.min_DBP+",发生时间:"+bpMonthReport.comprehensive_analyse.min_DBP_time);
		//测压方案完成情况
		$("#month_measure_compliance").html(bpMonthReport.measure_compliance);
		//总结
		var conclusion = bpMonthReport.conclusion;
		if(conclusion!=null){
			var tr = "";
			for(var i=0;i<conclusion.length;i++){
				 tr += "("+(i+1)+")"+conclusion[i];
			}
			$("#month_conclusion").html(tr);
		}
		//建议
		var suggestion = bpMonthReport.suggestion;
		if(suggestion!=null){
			var tr = "";
			for(var i=0;i<suggestion.length;i++){
				 tr += "("+(i+1)+")"+suggestion[i];
			}
			$("#month_suggestion").html(tr);
		}
		
	}
	function drawPlan(start,end){
		if(version==0){
			$("#plan_complete").empty();
			if(bprecords!=null){
				for(var i=start;i<end;i++){
					var tr = "<tr><td>"+bprecords[i].time+"</td><td>"+bprecords[i].description+"</td></tr>"
					$("#plan_complete").append(tr);
				}
				if(bprecords.length>10){
					var str="<tr><td colspan='2' align='center' style='width: 100%'><a href='javascript:void(0);'   onclick='prevPlan();' >上页</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'   onclick='nextPlan();' >下页</a></td></tr>";
					$("#plan_complete").append(str);
				}
			}
		}else{
			 $("#plan_unnormal2 tr").eq(0).nextAll().remove();
			if(bprecords!=null){
				for(var i=start;i<end;i++){
					var tr = "<tr><td>"+bprecords[i].value.replace(",","/")+"</td><td>"+bprecords[i].time+"</td><td>"+bprecords[i].description+"</td></tr>";
					$("#plan_unnormal2").append(tr);
				}
				if(bprecords.length>10){
					var str="<tr><td colspan='3' align='center' style='width: 100%'><a href='javascript:void(0);'   onclick='prevPlan();' >上页</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'   onclick='nextPlan();' >下页</a></td></tr>";
					$("#plan_unnormal2").append(str);
				}
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
			var tr = "<tr><td>"+bp_static[i].take_time+"</td><td>"+bp_static[i].shrink+"</td><td>"+bp_static[i].diastole+"</td><td>"+bp_static[i].pulse_pressure+"</td><td>"+bp_static[i].mean_arterial_pressure+"</td><td>"+bp_static[i].heart_rate+"</td></tr>";
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
			var tr = "<tr><td>"+ecg_report[i].time+"</td><td>"+ecg_report[i].duration+"</td><td>"+ecg_report[i].heart_rate+"</td><td>"+ecg_report[i].result+"</td></tr>";
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

</head>

<body >
 <div class="popup" id="monthreport_detail" style="display:none;position:absolute;top:20px; left:20px;z-index: 30;width: 630px;">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader" id="detail_monthreport">月报详情</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeMonthReport();">X</a></li>
    </ul>
  </div>
  
  <div class="popup_main">
   <!-- 月报第一版展示 -->       
	  <div class="bpDiagnosis_results" id="month_view" >
         <div class="bpDiagnosis_results_text"  style="float: left;">
          <ul>
            <li class="tgreen_results">创建日期：<span class="tblack_results" id="tracking_date_create" ></span></li>
            <li class="tgreen_results">统计区间：<span class="tblack_results" id="interval"></span></li>
            <li class="tgreen_results">高血压等级：<span class="tblack_results" id="month_level"></span></li>
            <li class="tgreen_results">降压目标：<span class="tblack_results" id="target"></span></li>
            <li class="tgreen_results">测压方案完成情况：</li>
            <li class="tblack_results">
	            <table class="detailtable" id="plan_complete">
	            <tr><td>计划时间 </td><td>描述</td></tr>
	            </table>
            </li>
             <li class="tgreen_results">测压异常事件情况：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="plan_unnormal">
	            <tr><td>血压值 </td><td>测压时间</td><td>事件名称</td></tr>
	            </table>
            </li>
            <li class="tblack_results" style="margin-left: 80px;">总结：<span id="unnormal_analyse" ></span></li>
             <li class="tgreen_results">服用药物情况：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="plan_medicine" style="width:430px; border:1px solid #aeaeae; border-collapse: collapse;margin-left: 80px;">
	            <tr><td>药物名称</td><td>服用频率</td><td>服用时间</td></tr>
	            </table>
            </li>
             <li class="tgreen_results">不适应症情况：</li>
            <li class="tblack_results">
            	<div id="plan_inadaptation" style="border: 0px;">
	           
	            </div>
           
            </li>
            <li class="tblack_results" style="margin-left: 80px;">分析：<span id="inadaptation_analyse" ></span></li>
          
            <li class="tgreen_results">高血压防治情况：</li>
            <li class="tblack_results" id="effect"></li>
            <li class="tgreen_results">保健建议：</li>
            <li class="tblack_results" id="ecg_suggest"></li>
           	
          </ul>
        </div>
       
      </div>
        <!-- 月报第二版展示 -->
         <div class="bpDiagnosis_results_text" id="month_secondview" style="float: left;width: 600px;display: none;" >
          <ul>
            <li class="tgreen_results">创建日期：<span class="tblack_results" id="month_tracking_date" ></span></li>
            <li class="tgreen_results">统计区间：<span class="tblack_results" id="month_interval"></span></li>
            <li class="tgreen_results">降压目标：<span class="tblack_results" id="month_bp_target" ></span></li>
            <li class="tgreen_results">血压分级：<span class="tblack_results" id="month_bp_hype_type"></span></li>
            <li class="tgreen_results">风险分层：<span class="tblack_results" id="month_risk_level"></span></li>
            <li class="tgreen_results" >心血管风险因素：</span>
            </li>
             <li class="tblack_results"><span class="tblack_results" id="month_cv_risk"></li>
            <li class="tgreen_results" >靶器官损害：</li>
            <li class="tblack_results"><span class="tblack_results" id="month_target_organ_damage"></span></li>
            <li class="tgreen_results" >伴临床疾患：</li>
            <li class="tblack_results"><span class="tblack_results" id="month_clinical"></span></li>
            <li class="tgreen_results">血压数据统计表：</li>
            <li class="tblack_results">
	            <table class="detailtable" id="month_bp_static" style="width:560px; border:1px solid #aeaeae; border-collapse: collapse;">
	            <tr><td>时间 </td><td>收缩压</td><td>舒张压</td><td>脉压</td><td >平均动脉压</td><td>心率</td></tr>
	            </table>
            </li>
            <li class="tgreen_results">血压总体分析：</li>
            <li class="tblack_results" id="month_mean_bp"></li>
            <li class="tblack_results" id="month_bp_load"></li>
            <li class="tblack_results" id="month_cv"></li>
            <li class="tblack_results" id="month_sbp"></li>
            <li class="tblack_results" id="month_dbp"></li>
           
            
             <li class="tgreen_results">测压异常事件情况：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="plan_unnormal2" style="width:560px; border:1px solid #aeaeae; border-collapse: collapse;">
	             <tr><td width="15%">血压值 </td><td width="35%">测压时间</td><td width="50%">反馈</td></tr>
	            </table>
            </li>
             <li class="tgreen_results">服用药物情况：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="plan_medicine2" style="width:560px; border:1px solid #aeaeae; border-collapse: collapse;">
	            <tr><td>通用名称</td><td>剂量</td><td>服用时间</td></tr>
	            </table>
            </li>
            <!--  
            <li class="tgreen_results">服用药物后血压变化：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="month_medicine_effect" style="width:430px; border:1px solid #aeaeae; border-collapse: collapse;margin-left: 80px;">
	            <tr><td>商品名称 </td><td>开始服用日期</td><td>血压值</td></tr>
	            </table>
            </li>-->
              <li class="tgreen_results">心电监护结果：</li>
            <li class="tblack_results">
	            <table class="detailtable"  id="month_ecg_report" style="width:560px; border:1px solid #aeaeae; border-collapse: collapse;">
	            <tr><td width="25%">采集时间 </td><td width="12%">采集时长</td><td width="12%">平均心率</td><td width="51%">分析结果</td></tr>
	            </table>
            </li>
             <li class="tgreen_results">不适应症情况：</li>
            <li class="tblack_results">
            	<span id="plan_inadaptation2" style="border: 0px;">
	           
	            </span>
           
            </li>
             <li class="tgreen_results">测压方案完成情况：</li><li class="tblack_results" ><span id="month_measure_compliance" ></span></li>
            
            <li class="tgreen_results">总结：</li>
            <li class="tblack_results" id="month_conclusion"></li>
            <li class="tgreen_results">保健建议：</li>
            <li class="tblack_results" id="month_suggestion"></li>
           	
          </ul>
        </div>
    <div class="ecg_main">
    <ul>
      <li>
      <div class="tGrey_ecgname" style="width: 300px;margin-top:10px;text-align: left;float: left;">
     	 评估等级：<select id="assessment_level" disabled="disabled">
     	 		<option value="高">高</option>
     	 		<option value="中">中</option>
     	 		<option value="低">低</option>
     	 		</select>
      </div>
      <div class="tGrey_ecgname" style="width: 370px;margin-top:10px;text-align: left;float: left;">
     	用户状态： 	<select id="user_state" disabled="disabled">
     	 		<option value="恢复迅速">恢复迅速</option>
     	 		<option value="有好转">有好转</option>
     	 		<option value="无好转">无好转</option>
     	 		<option value="更严重">更严重</option>
     	 		</select>	
      </div>
      <div style="width: 600px;">
      <span class="tGrey_ecgname" id="doctor_result" >总结：</span>
      </div>
      </li>  
      </ul>
    </div>
      
  </div>
 
 </div>

</body>
</html>

 </div>
<!--bp_history end-->
</body>
</html>
	