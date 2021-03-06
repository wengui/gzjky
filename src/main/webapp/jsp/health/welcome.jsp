<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>健康报告</title>
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/highcharts/highcharts.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/highcharts/modules/exporting.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<%@ include file="../shared/importCss.jsp"%>
<%@ include file="../shared/importJs.jsp"%>
<script type="text/JavaScript">
	menuId = "#notice";
	//初始化方法
	function QueryHealth(){
		//2016/1/13 liu test START 用
		{
			bloodPressureCharts(null,"血压等级分析依据图","1");
		}
		//2016/1/13 liu test END 用
		
		healthStatus();//查询用户健康状态
		queryDoctorAdvice();//查询用户的最新医嘱
		queryConsultive();//查询用户的最新咨询回复
		queryDiagnose();//查询用户的血压趋势图
		queryDoctorReport();//查询周报月报信息
		if(true)queryEcg();//查询用户的心电信息
		var week = "星期" + "日一二三四五六".split("")[new Date().getDay()];
		$('#today').text(getdate()+week);
		queryCityByIP();////根据IP查城市
	}
	
	//查询用户健康状态
	function healthStatus(){
		$.ajax({
			url:"/gzjky/healthStatus/queryHealthStatus.do",
			async:true,
			data:null,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
			},
			success:function(response) {
				var modelMap = response.result;
				if(modelMap == null){
					return;
				}
				
				var sosAlert=null;
				if(modelMap.shrink != ""){
					$('#last_bloodpressure').html(modelMap.shrink+"/"+modelMap.diastole+"<span class='tblack_datemin'>mmHg</span>");
					$('#last_bloodpressure_time').text("最近一次血压值（"+modelMap.bloodTakeTime+"）");
				}
				if(modelMap.shrinkAlert!= ""){
					$('#last_bloodalert').html(modelMap.shrinkAlert+"/"+modelMap.diastoleAlert+"<span class='tblack_datemin'>mmHg</span>");
					$('#last_bloodalert_time').text("血压异常记录（"+modelMap.bloodTakeTimeAlert+"）");
				}
				if(sosAlert!=null){
					if(sosAlert.orgin_type=="0"){
						$('#last_island').text("SOS告警");
					}else if(sosAlert.orgin_type=="1"){
						$('#last_island').text("用户超出安全岛");
					}
					$('#last_sosalert').text("SOS异常记录（"+sosAlert.alert_time.substring(0,19)+"）");
				}
				
				var time1=0;
				var hearty='<span class="tblack_datemin">--</span>';
				var text2="最近一次心率值";
				
		 		if(modelMap.heartRate != ""){
		 			var take_t=modelMap.heartTakeTime;
	 				time1=take_t;
	 				text2="最近一次心率值（"+modelMap.heartTakeTime+"）";
	 				hearty=modelMap.heartRate+"<span class='tblack_datemin'>bpm</span>";
		 		}
				if(modelMap.pulseRate != ""){
					var take_t=modelMap.bloodTakeTime;
		 			if(take_t>time1){
		 				time2=take_t;
			 			text2="最近一次脉率值（"+modelMap.bloodTakeTime+"）";
			 			hearty=modelMap.pulseRate+"<span class='tblack_datemin'>bpm</span>";
					}
				}
				$('#last_heartrate').html(hearty);
				$('#last_heartrate_time').text(text2);
				if(modelMap.heartRateAlert != ""){
					$('#last_heartratealert').html(modelMap.heartRateAlert+"<span class='tblack_datemin'>bpm</span>");
					$('#last_heartratealert_time').text("心率异常记录（"+modelMap.heartTakeTimeAlert+"）");
				}
			}
		});
	}
	
	//最新医生医嘱
	function queryDoctorAdvice(){
		$.ajax({
			url:"/gzjky/healthStatus/queryDoctorAdvice.do",
			async:true,
			data:"",
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
			},
			success:function(response) {
				var modelMap = response.result;
				//显示最新医嘱内容
				drawAdvice(modelMap);
			}
		});
	}
	function drawAdvice(doctorAdvice){
		if(doctorAdvice==null || doctorAdvice.length == 0){
			return;
		}
		var advice = doctorAdvice[0];
		var dp_goal="舒张压："+advice.targetDpBottom+"mmHg-"+advice.targetDpTop+
			"mmHg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
			"收缩压："+advice.targetSpBottom+"mmHg-"+advice.targetSpTop+"mmHg";
		var plan="<div>起始时间："+advice.startTime.substring(0,11)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
			"测压频率："+advice.pl+"&nbsp;"+advice.xq+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
			"<span class='wordbreak'>测压时间段："+advice.hours+"</span></div>";
		var med=doctorAdvice.medicine_taken;
		var med_div="<div>";
		if(advice.name!=null& advice.name != ""){
			for(var i=0;i<doctorAdvice.length;i++){
				var div="<div>("+(i+1)+") 药名："+doctorAdvice[i].name+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;疗程："+doctorAdvice[i].lc+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
					"剂量："+doctorAdvice[i].jl+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
					"<span class='wordbreak'>用药时间："+doctorAdvice[i].fqfh+"&nbsp;"+doctorAdvice[i].jtsj+"</span></div>";
				med_div+=div;
			}
			med_div+="</div>";
		}else{
			med_div+="暂无</div>";
		}
		$("#goal").html(dp_goal);
		$("#plan").html(plan);
		$("#medicine").html(med_div);
		if(advice.suggestion!=null&&advice.suggestion!='')
			$("#suggestion").html("<div class='wordbreak'>"+advice.suggestion+"</div>");
	}
	
	//最新咨询回复
	function queryConsultive(){
		$.ajax({
			url:"/gzjky/healthStatus/queryMemberConsult.do",
			async:true,
			data:"",
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
			},
			success:function(response) {
				var modelMap = response.result;
				//var memberConsult = modelMap.memberConsult;//最新医嘱	
				//显示最新医嘱内容
				drawConsult(modelMap);
			}
		});
	}
	function drawConsult(memberConsult){
		if(memberConsult==null){
			return;
		}else{
			var create_time=memberConsult.consultingtime.substring(0,19);
			var finish_time=memberConsult.resulttime.substring(0,19);
			var cont="<div><div>咨询时间："+create_time+"</div><div class='wordbreak'>内容："+memberConsult.consultingcontent+"&nbsp;&nbsp;"+memberConsult.symptomname+"</div></div>";
			var report="<div><div>回复时间："+finish_time+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
				"医生："+memberConsult.doctorloginname+"</div>"+
				"<div class='wordbreak'>内容："+memberConsult.result+"</div></div>";
			$("#consult_cont").html(cont+report);
			
			$("#consultTime").html(create_time);
			$("#consultContent").html(memberConsult.consultingcontent+"&nbsp;&nbsp;"+memberConsult.symptomname);
			$("#replyTime").html("回复时间："+finish_time+"&nbsp;&nbsp;&nbsp;医生："+memberConsult.doctorloginname);
			$("#replyContent").html(memberConsult.result);
		}
		
	}
	
	//查询血压记录
	function queryDiagnose() {
		
		var onePageSize = 10;
	    var pointerStart = 0;
		var para = "pointerStart="+pointerStart+"&pageSize="+onePageSize;
		xmlHttp = $.ajax({
			url:"/gzjky/healthStatus/queryBloodPressureRecord.do",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
			},
			success:function(response) {
				var headTitle="近期血压趋势图";
				var morningHeadTitle="血压等级分析依据图";
				var newMorningHeadTitle="近期晨峰血压趋势图";
				var modelMap = response.outBeanList;
				var bloodPressureRecordList = modelMap[0];
				var morningSurgeBpList = modelMap[1];

				//显示最新血压趋势图
				bloodPressureCharts(bloodPressureRecordList,headTitle,"0");
				
				//显示最新晨峰血压趋势图
				bloodPressureCharts(morningSurgeBpList,newMorningHeadTitle,"2");
				
				//显示血压等级分析依据图
//				bloodPressureCharts(moringBpRecord,morningHeadTitle,"1");
			
			}
		});
	}
	
	//最新医生医嘱
	function queryDoctorReport(){
		$.ajax({
			url:"/gzjky/healthStatus/queryDoctorReport.do",
			async:true,
			data:"",
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
			},
			success:function(response) {
				var modelMap = response.result;
				//显示最新医嘱内容
				drawReport(modelMap);
			}
		});
	}
	
	function drawReport(report){
		if(report==null){
			return;
		}else{
			
			//血压等级分析
			if (report.bloodlevel == null||report.bloodlevel == ""||report.bloodlevel == "null") {
				$("#pressure_level").html("暂无&nbsp;&nbsp;&nbsp;&nbsp;<br>");
			} else {
				$("#pressure_level").html(report.bloodlevel+"&nbsp;&nbsp;<br>");
			
			}
			//心血管分层
			if (report.riskstratification == null||report.riskstratification == ""||report.riskstratification == "null") {
				$("#risk_level").html("暂无");
			} else {
				$("#risk_level").html(report.riskstratification);
			}
			//保健建议
			if(report.healthadvice !=null && report.healthadvice != ""){
				$("#health_suggest").html(report.healthadvice);
			}else{
				$("#health_suggest").html("暂无");
			}
			
			if(report.analysisResult == "undefined"){
				$("#doctor_bpana").css("display","none");
				$("#doctor_bpreport").css("display","none");
				$("#doctor_spana").css("display","none");
				$("#doctor_suggest").css("display","none");
			}else{
				//医生分析
				if(report.analysisresult !=null && report.analysisresult != ""){
					$("#doctor_bpreport").html(report.analysisresult);
				}else{
					$("#doctor_bpreport").html("暂无");
				}
				//医生建议
				if(report.doctorhealthadvice !=null && report.doctorhealthadvice != ""){
					$("#doctor_suggest").html(report.doctorhealthadvice);
				}else{
					$("#doctor_suggest").html("暂无");
				}				
			}
		}
		
	}
	//保健建议、血压诊断
	function showDiagnose(typeLvl,suggestionList,riskLvl,angiocarpyList,angiocarpyNewList,bpcompleted,versio) {
		var riskLvls=["低危","中危","高危","很高危"];//心血管的分层
		var divmap=typeLvl;
		var sulist="";
		var angiocarpy="";
	
		if(suggestionList!=null){
			for ( var i = 0; i < suggestionList.length; i++) {
				var su = "(" + (i + 1) + ")" + suggestionList[i] + "<br>";
				sulist += su;
			}
		}
		
		//判断是否有医生回复
		if(bpcompleted!=null){
			if(bpcompleted.report!=''){
				$("#doctor_bpana").css("display","block");
				$("#doctor_bpreport").css("display","block");
				$("#doctor_bpreport").html(bpcompleted.report);
			}
			if(bpcompleted.suggestion!=''){
   				$("#suggest_name").html("医生建议");
   				$("#health_suggest").html(bpcompleted.suggestion);
			}
		}else{
			if(sulist == "" ){
				$("#health_suggest").html("暂无");
			}else{
				$("#health_suggest").html(sulist);
			}
		}
		
		if (divmap == null||divmap == ""||divmap == "null") {
			$("#pressure_level").html("暂无&nbsp;&nbsp;&nbsp;&nbsp;<br><a href='javascript:void(0);' onclick='bloodPressureStandard();'>高血压分级标准</a>");
		} else {
			$("#pressure_level").html(divmap+"&nbsp;&nbsp;<br><a href='javascript:void(0);' onclick='bloodPressureStandard();'>高血压分级标准</a>");
		
		}
		var riskVal="";
		if(versio=='1.1.0'){
			riskVal=riskLvl;
			if(angiocarpyNewList!=null){
				for ( var i = 0; i < angiocarpyNewList.length; i++) {
					var ag = "(" + (i + 1) + ")" + angiocarpyNewList[i] + "<br/>";
					angiocarpy += ag;
				}
			}
		}else{
			riskVal=riskLvls[parseInt(riskLvl)-1];
			if(angiocarpyList!=null){
				for ( var i = 0; i < angiocarpyList.length; i++) {
					var ag = "(" + (i + 1) + ")" + angiocarpyList[i] + "<br/>";
					angiocarpy += ag;
				}
			}
		}
		
		$("#risk_level").html(riskVal==null?"暂无":riskVal);
			
		
			
		$("#angiocarpy").html(angiocarpy==""?"暂无":angiocarpy);
				
	}
	//血压趋势图
	function bloodPressureCharts(records,headTitle,flag) {
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
				text : headTitle
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

	//查询心电信息 
	var hly_url=  "http://gzjky.sh-sdhr.com/upload/Electrocardiograms/";
	function queryEcg(){
		$.ajax({
			url:"/gzjky/healthStatus/queryEcgHeartRateAndReport.do",
			async:true,
			data:null,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
			},
			success:function(response) {
				var ecgRecordVo=response.result
				if(ecgRecordVo == null){
					$('#doctor_report').html("暂无");
					$('#image_heart_rate').html("<div><img src='<c:url value='/images/health/bottom.png'/>' /></div>");
				}else{
					$('#doctor_report').html(ecgRecordVo.analyseResult);
					$('#reference_range').html("您的心率值为"+ecgRecordVo.heartRate+"&nbsp;&nbsp;<a class='tblack_results'style='text-decoration: underline;' data-toggle='modal' href='#ecgDiagram'>心电图</a>");
					if(ecgRecordVo.ecgImage != null && ecgRecordVo.ecgImage != ""){
						$("#ecg_image").attr("src",hly_url+ecgRecordVo.ecgImage.replace("~/upload/Electrocardiograms/",""));
					}
					
 					if(ecgRecordVo.heartRate>=100){
 						$('#image_heart_rate').
 						html("<div><img style='margin-right: "+(-165-(ecgRecordVo.heartRate-100)*2.6)+"px;' src='<c:url value='/images/health/top.png'/>'/></div><div><img src='<c:url value='/images/health/bottom.png'/>' /></div>");
 					}else if(ecgRecordVo.heartRate<=60){
 						$('#image_heart_rate').
 							html("<div><img style='margin-right: "+(95+(60-ecgRecordVo.heartRate)*2.6)+"px;' src='<c:url value='/images/health/top.png'/>'/></div><div><img src='<c:url value='/images/health/bottom.png'/>' /></div>");
 					}else{
 						$('#image_heart_rate').
 							html("<div><img style='margin-right: "+(95-(ecgRecordVo.heartRate-60)*6.75)+"px;' src='<c:url value='/images/health/top.png'/>'/></div><div><img src='<c:url value='/images/health/bottom.png'/>' /></div>");
 					}
				}
				
			}
		});
	}
	
	//获取当前日期
	function getdate() {
		var now = new Date();
		y = now.getFullYear();
		m = now.getMonth() + 1;
		d = now.getDate();
		m = m < 10 ? "0" + m : m;
		d = d < 10 ? "0" + d : d;
		return y + "." + m + "." + d;

	}
	//根据IP查城市
	function queryCityByIP() {
		var province = '';
		var city = '';
		var ip = '';
		jQuery.getScript(
				"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js",
				function() {
					province = remote_ip_info["province"];
					city = remote_ip_info["city"];
					queryWeather(unescape(city));
				});
	}
	//查询该城市天气预报
	function queryWeather(city) {
		$.getScript("http://php.weather.sina.com.cn/js.php?" + $.param({
			city : city, //城市
			day : 0,
			password : "DJOYnieT8234jlsK"
		}), function(json) {
			var weather = '今日' + city + '天气：' + status1 + ',温度：' + temperature2
					+'°'+'-'+temperature1+'°,'+direction1;
			$('#weather').text(weather);	
		});
	}


	//弹出血压分级标准
	function bloodPressureStandard() {
		$('#popWindow').draggable({
			disabled : true
		});
		$("#popWindow").show(200);
		showScreenProtectDiv(1);
	}
</script>

</head>

<body class="skin-blue" onload="QueryHealth();" >

	<!-- header logo: style can be found in header.less -->
	<%@ include file="../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	         <!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
           <section class="content-header">
              <h1>健康通告
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li class="active">健康报告</li>
              </ol>
          </section>

          <!-- Main content -->
          <section class="content">
              <!-- Small boxes (Stat box) -->
              <div class="row">
                  <div class="col-lg-6 col-xs-6">
                      <!-- small box -->
                      <div class="small-box bg-aqua">
                          <div class="inner">
                           	  <h3>
                                 	血压值
                              </h3>
                              <h3 id="last_bloodpressure">
                                  &nbsp;
                              </h3>
                              <p id="last_bloodpressure_time">
                                  	最近一次血压值
                              </p>
                          </div>
                          <div class="icon">
                              <i class="ion ion-waterdrop"></i>
                          </div>
                      </div>
                  </div><!-- ./col -->
                  
                  <div class="col-lg-6 col-xs-6">
                      <!-- small box -->
                      <div class="small-box bg-green">
                          <div class="inner">
                          	  <h3>
                                 	血压异常值
                              </h3>
                              <h3 id="last_bloodalert">
                              	&nbsp;
                              </h3>
                              <p id="last_bloodalert_time">
                                  	血压异常记录
                              </p>
                          </div>
                          <div class="icon">
                              <i class="ion ion-stats-bars"></i>
                          </div>
                      </div>
                  </div><!-- ./col -->
              </div><!-- /.row -->
              <div class="row">
                  <div class="col-lg-6 col-xs-6">
                      <!-- small box -->
                      <div class="small-box bg-yellow">
                          <div class="inner">
                          	  <h3>
                                                                                                                   心率/脉率值
                              </h3>
                              <h3 id="last_heartrate">
                                  &nbsp;
                              </h3>
                              <p id="last_heartrate_time">
                                                                                                                    最近一次脉率值
                              </p>
                          </div>
                          <div class="icon">
                              <i class="ion ion-person-add"></i>
                          </div>
                      </div>
                  </div><!-- ./col -->

                  <div class="col-lg-6 col-xs-6">
                      <!-- small box -->
                      <div class="small-box bg-red">
                          <div class="inner">
                          	  <h3>
                                                                                                                   心率异常值
                              </h3>
                              <h3 id="last_heartratealert">
                                  &nbsp;
                              </h3>
                              <p id="last_heartratealert_time">
                              	心率异常记录
                              </p>
                          </div>
                          <div class="icon">
                              <i class="ion ion-heart"></i>
                          </div>
                      </div>
                  </div><!-- ./col -->
              </div><!-- /.row -->
              <div class="row">    
                  <div class="col-lg-6 col-xs-6">
                      <!-- small box -->
                      <div class="small-box bg-maroon">
                          <div class="inner">
                          	  <h3>
                                                                                                                   血氧值
                              </h3>
                              <h3 >
                                  &nbsp;
                              </h3>
                              <p id="last_heartratealert_time">
                              	最近一次血氧值
                              </p>
                          </div>
                          <div class="icon">
                              <i class="ion ion-pie-graph"></i>
                          </div>
                      </div>
                  </div><!-- ./col -->
                  
                  <div class="col-lg-6 col-xs-6">
                      <!-- small box -->
                      <div class="small-box bg-purple">
                          <div class="inner">
                          	  <h3>
                                 SOS异常
                              </h3>
                              <h3 id="last_island">
                                  &nbsp;
                              </h3>
                              <p id="last_sosalert">
                              	SOS异常记录
                              </p>
                          </div>
                          <div class="icon">
                              <i class="ion ion-alert"></i>
                          </div>
                      </div>
                  </div><!-- ./col -->
              </div><!-- /.row -->

              <!-- top row -->
              <div class="row">
                  <div class="col-xs-12 connectedSortable">
                      
                  </div><!-- /.col -->
              </div>
              <!-- /.row -->

			  <div class="row">
                        <div class="col-md-12" id="doctorAdvice">
                            <div class="box box-danger">
                                <div class="box-header">
                                    <i class="fa fa-warning"></i>
                                    <h3 class="box-title">最新医嘱</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body" id="advice">
                                    <div class="callout callout-danger">
                                        <h4>测压目标</h4>
                                        <p id="goal">暂无</p>
                                    </div>
                                    <div class="callout callout-info">
                                        <h4>测压方案</h4>
                                        <p id="plan">暂无</p>
                                    </div>
                                    <div class="callout callout-warning">
                                        <h4>用药推荐</h4>
                                        <p id="medicine">暂无</p>
                                    </div>
                                    <div class="callout callout-success">
                                        <h4>保健建议</h4>
                                        <p id="suggestion">暂无</p>
                                    </div>
                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                </div>
                <div class="row">
                        <div class="col-md-12">
                            <div class="box box-info">
                                <div class="box-header">
                                    <i class="fa fa-bullhorn"></i>
                                    <h3 class="box-title">最新咨询  <a href='<c:url value='/menuControlAction/memberConsult.do'/>' style="color:#3A87AD;font-size:18px"><i class="fa fa-angle-double-right"></i>会员咨询历史</a></h3>
                                    
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <div class="callout callout-danger">
                                        <h4>咨询时间</h4>
                                        <p id="consultTime">暂无</p>
                                    </div>
                                    <div class="callout callout-info">
                                        <h4>咨询内容</h4>
                                        <p id="consultContent">暂无</p>
                                    </div>
                                    <div class="callout callout-warning">
                                        <h4>医生/回复时间</h4>
                                        <p id="replyTime">暂无</p>
                                    </div>
                                     <div class="callout callout-success">
                                        <h4>回复内容</h4>
                                        <p id="replyContent">暂无</p>
                                    </div>
                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
              </div>

              <!-- Main row -->
              <div class="row">
                  <!-- Left col -->
                  <section class="col-lg-12 connectedSortable"> 
                      <!-- Box (with bar chart) -->
                      <div class="box box-danger" >
                          <div class="box-header">
                              <!-- tools box -->
                              <i class="fa fa-bar-chart-o"></i>

                              <h3 class="box-title">近期血压趋势图</h3>
                          </div><!-- /.box-header -->
                          <div class="box-body no-padding">
                              <div class="row bpDiagnosis_results_trendChart">
                                  <div class="col-sm-12">
										<div class="bpDiagnosis_results_trendChart" id="container"></div> 
                                  </div><!-- /.col -->
                              </div><!-- /.row - inside box -->
                          </div><!-- /.box-body -->
                      </div><!-- /.box -->        
                      
                      <!-- Custom tabs (Charts with tabs)-->
                  </section><!-- /.Left col -->
                  <!-- right col (We are only adding the ID to make the widgets sortable)-->
               </div>
               <div class="row">   
                  <section class="col-lg-12 connectedSortable">
                      <!-- Map box -->
                      <div class="box box-primary">
                          <div class="box-header">
                              <i class="fa fa-bar-chart-o"></i>
                              <h3 class="box-title">
                                  	近期晨峰血压趋势图
                                  	<a style="color:#3A87AD;text-decoration: underline;font-size:18px"  data-toggle="modal" href="#popWindow1">晨峰血压是什么？</a>
                              </h3>
                               
                      	</div>
                       <div class="box-body no-padding">
                          <div class="row bpDiagnosis_results_trendChart">
                               <div class="col-sm-12">
								<div class="bpDiagnosis_results_trendChart"  id="container1" ></div> 
                               </div><!-- /.col -->
                           </div><!-- /.row - inside box -->
                       </div><!-- /.box-body-->
                      </div><!-- /.box -->
                   </section><!-- right col -->   
              </div>                  
              <div class="row">
                        <section class="col-lg-12 connectedSortable"> 
                            <div class="box box-danger" id="histroy_bp_diagnose">
                                <div class="box-header">
                                    <i class="fa fa-map-marker"></i>
                                    <h3 class="box-title">血压等级分析
                                    <a style="color:#3A87AD;text-decoration: underline;font-size:18px" data-toggle="modal" href="#bloodstandard">高血压分级标准</a>
                                    </h3>
                                    
                                </div><!-- /.box-header -->
								<div class="box-body">
                                    <div class="box-group" id="accordion">
                                        <!-- we are adding the .panel class so bootstrap.js collapse plugin detects it -->
                                        <div class="panel box box-primary">
                                            <div class="box-header">
                                                <h4 class="box-title" style="color: #3c8dbc">血压等级 </h4>
                                            </div>
                                            <div class="box-body" id="pressure_level">
                                                        		暂无
                                            </div>
                                        </div>
                                        <div class="panel box box-danger">
                                            <div class="box-header">
                                                <h4 class="box-title" style="color: #f56954">心血管风险分层 </h4>
                                            </div>
                                            <div id="collapseTwo" class="panel-collapse collapse in">
                                                <div class="box-body" id="risk_level">
                                                	暂无
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel box box-warning">
                                            <div class="box-header">
                                                <h4 class="box-title" style="color: #f39c12;">诊断依据</h4>
                                            </div>
                                            <div id="collapseThree" class="panel-collapse collapse in">
                                                <div class="box-body">
														体力活动时没有心悸、轻微疲劳、呼吸正常。
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel box box-info">
                                        
                                        <div class="box-header"  id="doctor_bpana">
                                                <h4 class="box-title" style="color: #00c0ef">医生分析</h4>
                                            </div>
                                            <div id="collapseFour" class="panel-collapse collapse in">
                                                <div class="box-body" id="doctor_bpreport" >
                                                		暂无
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel box box-success">
                                            <div class="box-header">
                                                <h4 class="box-title" style="color: #00a65a">医生建议</h4>
                                            </div>
                                            <div id="collapseFive" class="panel-collapse collapse in">
                                                <div class="box-body" id="doctor_suggest">
                                                	暂无
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel box box-primary"  id="doctor_spana">
                                            <div class="box-header">
                                                <h4 class="box-title" style="color: #3c8dbc;">
                                                        	保健建议
                                                </h4>
                                            </div>
                                            <div id="collapseSix" class="panel-collapse collapse in">
                                                <div class="box-body" id="health_suggest">
														暂无
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box -->
                        </section><!-- /.Left col -->
                </div>
                <div class="row">       
						<section class="col-lg-12 connectedSortable">
                            <div class="box box-info">
                             <div class="box-header">
                              <i class="fa fa-bar-chart-o"></i>
                              <h3 class="box-title">
                                  	血压等级分析依据图
                              </h3>
 	                          <div class="box-body no-padding">
	                             <div class="row bpDiagnosis_results_trendChart">
	                                  <div class="col-sm-12">
											<div class="bpDiagnosis_results_trendChart"  id="container2" ></div> 
	                                  </div><!-- /.col -->
	                              </div><!-- /.row - inside box -->
	                          </div><!-- /.box-body-->
                            </div><!-- /.box -->
                        	</div><!-- /.col -->
                   			</section><!-- right col -->   
		        </div><!-- /.row (main row) -->
				  
				<div class="row">
                      	  <section class="col-lg-12 connectedSortable"> 
						  <div class="box box-danger" >
	                                <div class="box-header" style="cursor: move;">
	                                    <!-- tools box -->
	                                    <i class="fa fa-cloud"></i>
	                                    <h3 class="box-title">心电医生回复</h3>
	                                </div><!-- /.box-header -->
	                                <div class="box-body" style="padding-left:22px" >
	                                 <div id="doctor_report"> 暂无</div><!-- /.row - inside box -->
	                                </div><!-- /.box-body -->
	                                <div class="box-footer">
	                                    <div class="row">
	                                        <div class="col-xs-4 text-center" style="border-right: 1px solid #f4f4f4">
	                                        	<div><h4 class="box-body" id="reference_range"></h4></div>
	                                            <div><h5 class="box-body" style="font-size:18px">参考正常范围：60 &lt; 心率  &lt; 100</h5></div>
	                                        </div><!-- ./col -->
	                                        <div class="col-xs-8 text-center">
	                                        	<li class="sketchMap" id="image_heart_rate">
	                                        		<div>
													<img style="margin-right: 150px;" src="<c:url value='/images/health/top.png'/>" />
													</div>
													
													<div>
													<img src="<c:url value='/images/health/bottom.png'/>" />
													</div>
	                                        	</li>
	                                        </div><!-- ./col -->
	                                    </div><!-- /.row -->
	                                </div><!-- /.box-footer -->
	                        </div>
                        </section><!-- right col -->   
	              	</div><!-- /.row (main row) -->
          </section><!-- /.content -->
     </aside><!-- /.right-side -->
</div><!-- ./wrapper -->
<!--index_welcome_main end-->

<div class="modal fade" id="popWindow1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%">
  <div class="modal-dialog">	
	 <div class="popup_header">
	   <ul>
	     <li class="name_popupHeader">晨峰血压</li>
	     <li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal" class="d-close"></a></li>
	   </ul>
	 </div>
	 <div class="popup_main">
	   <ul>
	     <li class="tgreen_bpPrompt" style="height: 350px;">
	       1.定义：<span style="color:#5a5a5a;">血压在一天中是波动的，存在血压变异。正常人的收缩压及舒张压呈明显的昼夜节律。人体由睡眠状态转为清醒并开始活动，血压从相对较低水平迅速上升至较高水平，这种现象即为“血压晨峰”。用户在规定的测压时间内测压2—3次，取其平均值作为该日的晨峰血压值。</span><br/>
	     	2.意义：<span style="color:#5a5a5a;">清晨血压急剧升高或者异常血压晨峰现象，与心血管疾病发生有密切的关系。所以，晨峰血压是医生查看患者血压数据的重要指标。</span><br/>
	       3.测压时间：<span style="color:#5a5a5a;">新疆地区早上8点—11点，中国其它地区早上6点—9点。</span><br/>
	       4.测压频率：<span style="color:#5a5a5a;">每天在规定时间内测压2—3次。</span>
	     </li>
	   </ul>
	 </div>
  </div>
</div>


<div class="modal fade" id="bloodstandard" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%" >
  <div class="modal-dialog"  style="width:750px">	
	 <div class="popup_header">
	   <ul>
	     <li class="name_popupHeader">血压分级标准</li>
	     <li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal" class="d-close"></a></li>
	   </ul>
	 </div>
	 <div class="popup_main" >
	   <ul>
	     <li class="tblack_bp">中国高血压防治指南2010年修订版</li>
	     <li class="tyellow_max_bp"><img src="<c:url value='/images/icon/tyellow.png'/>" class="img_color" />
	     低血压：<span class="tgrey_bp">收缩压小于</span>90<span class="tgrey_bp">，舒张压小于</span>60</li>
	     
	     <li class="tgreen_bp"><img src="<c:url value='/images/icon/green.png'/>" class="img_color" />
	     正常血压：<span class="tgrey_bp">收缩压小于</span>120<span class="tgrey_bp">，舒张压小于</span>80</li>
	     <li class="tblue_bp"><img src="<c:url value='/images/icon/blue.png'/>" class="img_color" />
	     正常高值：<span class="tgrey_bp">收缩压</span>120-139<span class="tgrey_bp">，舒张压</span>80-89</li>
	     <li class="tyellow_bp"><img src="<c:url value='/images/icon/yellow.png'/>" class="img_color" />
	     高于正常：<span class="tgrey_bp">收缩压大于等于</span>140<span class="tgrey_bp">，舒张压大于等于</span>90</li>
	     <li class="torange_bp"><img src="<c:url value='/images/icon/orange.png'/>" class="img_color" />
	     高血压一级：<span class="tgrey_bp">收缩压</span>140-159<span class="tgrey_bp">，舒张压</span>90-99</li>
	     <li class="tbrown_bp"><img src="<c:url value='/images/icon/brown.png'/>" class="img_color" />
	     高血压二级：<span class="tgrey_bp">收缩压</span>160-179<span class="tgrey_bp">，舒张压</span>100-109</li>
	     <li class="tred_bp"><img src="<c:url value='/images/icon/red.png'/>" class="img_color" />
	     高血压三级：<span class="tgrey_bp">收缩压大于等于</span>180<span class="tgrey_bp">，舒张压大于等于</span>110</li>
	     
	      <li class="tred_orange_bp"><img src="<c:url value='/images/icon/red_orange.png'/>" class="img_color" />
	     单纯收缩期高血压：<span class="tgrey_bp">收缩压大于等于</span>140<span class="tgrey_bp">，舒张压小于</span>90</li>
	     
	     <li class="tgreen_bpPrompt">注意：高压和低压分属于不同级别时，以较高分级为标准</li>
	   </ul>
	 </div>
  </div>
</div>

<div class="modal fade" id="ecgDiagram" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:5%" >
  <div class="modal-dialog">	
	 <div class="popup_header" >
	   <ul >
	     <li class="name_popupHeader" >心电图</li>
	     <li class="close_popupHeader" ><a href="javascript:void(0)" data-dismiss="modal" class="d-close"></a></li>
	   </ul>
	 </div>
	 <div class="popup_main">
	   <ul>
	     <li>
	       <div style="height:600px;overflow:auto"><img id="ecg_image" /></div>
	     </li>
	   </ul>
	 </div>
 </div>
</div>

<div id="divloading"><img src="<c:url value='/images/public/blue-loading.gif'/>" /></div>
<div id="transparentDiv" ></div>
<div id="transparentDiv2"></div>
</body>
</html>
