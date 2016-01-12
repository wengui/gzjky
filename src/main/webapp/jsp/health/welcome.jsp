<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_right.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/highcharts/highcharts.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/highcharts/modules/exporting.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>

<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/jquery-1.10.0.js'/>"></script>
<script src="<c:url value='/js/libs/jquery-ui.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>

<style type="">
.wordbreak{word-break:break-all;}
</style>
<script type="text/JavaScript">

	//初始化方法
	function QueryHealth(){
		healthStatus();//查询用户健康状态
		queryDiagnose();//查询用户的血压趋势图
		queryDoctorAdvice();//查询用户的最新医嘱
		queryConsultive();//查询用户的最新咨询回复
		if(true)queryEcg();//查询用户的心电信息
		var week = "星期" + "日一二三四五六".split("")[new Date().getDay()];
		$('#today').text(getdate()+week);
		queryCityByIP();////根据IP查城市
	}
	//查询用户健康状态
	function healthStatus(){
		$.ajax({
			url:"/healthStatus/queryHealthStatus.action",
			async:true,
			data:null,
			dataType:"json",
			type:"POST",
			error:function(){
				//$.alert("发生异常1","请注意");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var bloodPressureAlert=modelMap.bloodPressureAlert;
				var bloodPressureRecord=modelMap.bloodPressureRecord;
				var sosAlert=null;
				var record =null;
				var alert = null;
				if(true){
					sosAlert=modelMap.sosAlert;
					record =modelMap.record;
					alert = modelMap.alert;
				}
				
				if(bloodPressureRecord != null){
					$('#last_bloodpressure').html(bloodPressureRecord.shrink+"/"+bloodPressureRecord.diastole+"<span class='tblack_datemin'>mmHg</span>");
					$('#last_bloodpressure_time').text("最近一次血压值（"+bloodPressureRecord.take_time.substring(0,19)+"）");
				}
				if(bloodPressureAlert!= null){
					$('#last_bloodalert').html(bloodPressureAlert.shrink+"/"+bloodPressureAlert.diastole+"<span class='tblack_datemin'>mmHg</span>");
					$('#last_bloodalert_time').text("血压异常记录（"+bloodPressureAlert.alert_time.substring(0,19)+"）");
				}
				if(sosAlert!=null){
					if(sosAlert.orgin_type=="0"){
						$('#last_island').text("SOS告警");
					}else if(sosAlert.orgin_type=="1"){
						$('#last_island').text("用户超出安全岛");
					}
					$('#last_sosalert').text("SOS异常记录（"+sosAlert.alert_time.substring(0,19)+"）");
				}
				
				/*if(record != null){
					$('#last_heartrate').html(record.heart_rate+"<span class='tblack_datemin'>bpm</span>");
					$('#last_heartrate_time').text("最近一次心率值（"+record.take_time.substring(0,19)+"）");
				}else{
					if(bloodPressureRecord != null){
					$('#last_heartrate').html(bloodPressureRecord.heart_rate+"<span class='tblack_datemin'>bpm</span>");
					$('#last_heartrate_time').text("最近一次脉率值（"+bloodPressureRecord.take_time.substring(0,19)+"）");
					}
				}*/
				var time2=0;
				var hearty='<span class="tblack_datemin">--</span>';
				var text2="最近一次心率值";
				
		 		if(record!=null){
		 			var take_t=record.take_time.substring(0,19);
		 			take_t=Date.parse(take_t.replace(/-/g,"\/"));
		 			if(take_t>time2){
		 				time2=take_t;
		 				text2="最近一次心率值（"+record.take_time.substring(0,19)+"）";
		 				hearty=record.heart_rate+"<span class='tblack_datemin'>bpm</span>";
		 			}
		 		}
				if(bloodPressureRecord != null){
					var take_t=bloodPressureRecord.take_time.substring(0,19);
		 			take_t=Date.parse(take_t.replace(/-/g,"\/"));
		 			if(take_t>time2){
		 				time2=take_t;
			 			text2="最近一次脉率值（"+bloodPressureRecord.take_time.substring(0,19)+"）";
			 			hearty=bloodPressureRecord.heart_rate+"<span class='tblack_datemin'>bpm</span>";
					}
				}
				$('#last_heartrate').html(hearty);
				$('#last_heartrate_time').text(text2);
				if(alert != null){
					if(alert.heart_rate == null){
						alert.heart_rate ="";
					}else{
						$('#last_heartratealert').html(alert.heart_rate+"<span class='tblack_datemin'>bpm</span>");
					}
					if(alert.take_time == null){
						alert.take_time = "";
					}else{
					$('#last_heartratealert_time').text("心率异常记录（"+alert.take_time.substring(0,19)+"）");
					}
				}
			}
		});
	}
	//查询心电信息 
	 var hly_url=  "http://v3.995120.cn:7090/hly_svr";
	function queryEcg(){
		$.ajax({
			url:"/healthStatus/queryEcgHeartRateAndReport.action",
			async:true,
			data:null,
			dataType:"json",
			type:"POST",
			error:function(){
				//$.alert("发生异常2","请注意");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var ecgRecordVo=modelMap.ecgRecordVo;
				if(ecgRecordVo == null){
					$('#doctor_report').text("暂无");
					$('#image_heart_rate').html("<img src='../../images/health/bottom.png' />");
				}else{
					$('#doctor_report').text(ecgRecordVo.report);
					$('#reference_range').html("您的心率值为"+ecgRecordVo.heart_rate+"<a class='tblack_results' href='javascript:void(0);' onclick='ecgPic();'>心电图</a>");
					$("#ecg_image").attr("src",hly_url+ecgRecordVo.file_storage_path.replace("/helowindata/tomcat/webapps/hly_svr","")+"-I.jpg");
					if(ecgRecordVo.heart_rate>=100){
						$('#image_heart_rate').
						html("<img style='margin-right: "+(20-(ecgRecordVo.heart_rate-100))+"px;' src='../../images/health/top.png'/><img src='../../images/health/bottom.png' />");
					}else if(ecgRecordVo.heart_rate<=60){
						$('#image_heart_rate').
							html("<img style='margin-right: "+(150+(60-ecgRecordVo.heart_rate)*2)+"px;' src='../../images/health/top.png'/><img src='../../images/health/bottom.png' />");
					}else{
						$('#image_heart_rate').
							html("<img style='margin-right: "+(150-(ecgRecordVo.heart_rate-60)*3.25)+"px;' src='../../images/health/top.png'/><img src='../../images/health/bottom.png' />");
					}
				}
				
			}
		});
	}
	
	//查询血压记录
	function queryDiagnose() {
		var onePageSize = 10;
	    var pointerStart = 0;
		var para = "pointerStart="+pointerStart+"&pageSize="+onePageSize;
		xmlHttp = $.ajax({
			url:"/healthStatus/queryBloodPressureRecord.action",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				//$.alert("发生异常3","请注意");
			},
			success:function(response) {
				var headTitle="近期血压趋势图";
				var morningHeadTitle="血压等级分析依据图";
				var newMorningHeadTitle="近期晨峰血压趋势图";
				var modelMap = response.modelMap;
				var bloodPressureRecordList = modelMap.bloodPressureRecordList;//最新血压趋势数据
				var morningSurgeBpList = modelMap.morningSurgeBpList;//最新晨峰血压趋势数据
				var bloodPressureDiagnoseVo = modelMap.bloodPressureDiagnoseVo;
				var bpcompleted = modelMap.bpcompleted;//最新医生血压回复
				var typeLvl=null;//血压等级
				var suggestionList=new Array();
				
				var riskLvl=null;//心血管分层
				var angiocarpyList=null;//判断依据
				var moringBpRecord=null;//近期晨峰压记录
				var diagnose_time="";//历史血压分析时间
				var versio="";
				var angiocarpyNewList=""
				if(bloodPressureDiagnoseVo!=null){
					//心血管分层
					riskLvl=bloodPressureDiagnoseVo.risk;
					//心血管诊断依据
					angiocarpyList=bloodPressureDiagnoseVo.basis;
					angiocarpyNewList=bloodPressureDiagnoseVo.cv_risk;
					//晨峰血压数据
					moringBpRecord=bloodPressureDiagnoseVo.records;
					//血压等级
					typeLvl=bloodPressureDiagnoseVo.hype_type;
					//保健建议
		    		suggestionList=bloodPressureDiagnoseVo.suggestionList;
		    		//历史血压分析时间
		    		diagnose_time=bloodPressureDiagnoseVo.diagnose_time;
		    		//版本
		    		versio=bloodPressureDiagnoseVo.version;
				}
				if(diagnose_time==""||diagnose_time==null){
					$("#histroy_bp_diagnose").html("血压等级分析");
				}else{
					$("#histroy_bp_diagnose").html("血压等级分析("+diagnose_time.substring(0,19)+")");
				}
				
				//保健建议、血压诊断，治疗方案等的显示。如果没有则显示暂无
				showDiagnose(typeLvl,suggestionList,riskLvl,angiocarpyList,angiocarpyNewList,bpcompleted,versio);
				if(bloodPressureRecordList == null){
					headTitle="近期血压趋势图(暂无数据)";	
				}
				if(moringBpRecord==null || moringBpRecord==""){
					morningHeadTitle="血压等级分析依据图(暂无数据)";
				}else{
					var max = moringBpRecord.length-1;
					$("#container2_time").text(moringBpRecord[max].take_time.substring(0,11)+"~"+moringBpRecord[0].take_time.substring(0,11));
				}
				if(morningSurgeBpList==null){
					newMorningHeadTitle="近期晨峰血压趋势图(暂无数据)";
					$("#bpmorning_what").html("无晨峰血压数据，请查看<a class='tgreen_results' style='font-size: 12px;' href='javascript:void(0);' onclick='moringBp();'>晨峰血压是什么？</a>正确测量晨峰血压");
				}
				//显示最新血压趋势图
				bloodPressureCharts(bloodPressureRecordList,headTitle,"0");
				
				//显示最新晨峰血压趋势图
				bloodPressureCharts(morningSurgeBpList,newMorningHeadTitle,"2");
				
				//显示血压等级分析依据图
				bloodPressureCharts(moringBpRecord,morningHeadTitle,"1");
			
			}
		});
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
				var datetime= records[i].take_time;
				
				if(flag=="2"){
					datetime = records[i].create_time;
				}
				
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
				colors:['#0ca7a1','#51b336','#ff9600'],
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
	//最新医生医嘱
	function queryDoctorAdvice(){
		$.ajax({
			url:"/healthStatus/queryDoctorAdvice.action",
			async:true,
			data:"",
			dataType:"json",
			type:"POST",
			error:function(){
				//$.alert("发生异常4","请注意");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var doctorAdvice = modelMap.doctorAdvice;//最新医嘱	
				//显示最新医嘱内容
				drawAdvice(doctorAdvice);
			}
		});
	}
	function drawAdvice(doctorAdvice){
		if(doctorAdvice==null){
			return;
		}
		var state=doctorAdvice.state;
		if(state=='2'||state=='3'){return;}
		var dp_goal="舒张压："+doctorAdvice.target_dp_bottom+"mmHg-"+doctorAdvice.target_dp_top+
			"mmHg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
			"收缩压："+doctorAdvice.target_sp_bottom+"mmHg-"+doctorAdvice.target_sp_top+"mmHg";
		var bp=doctorAdvice.bp_taken;
		var days=bp.days.split(",");
		for(var i=0;i<days.length;i++){
			if(days[i]=='0'){days[i]="周日";
			}else if(days[i]=='1'){days[i]="周一";
			}else if(days[i]=='2'){days[i]="周二";
			}else if(days[i]=='3'){days[i]="周三";
			}else if(days[i]=='4'){days[i]="周四";
			}else if(days[i]=='5'){days[i]="周五";
			}else{days[i]="周六";}
		}
		var plan="<div>起始时间："+bp.start_time+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
			"测压频率："+days+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
			"<span class='wordbreak'>测压时间段："+bp.hours+"</span></div>";
		var med=doctorAdvice.medicine_taken;
		var med_div="<div>";
		if(med!=null&&med.length>0){
			for(var i=0;i<med.length;i++){
				var div="<div>("+(i+1)+") 药名："+med[i].name+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
					"剂量："+med[i].dosage+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
					"<span class='wordbreak'>用药时间："+med[i].hours+"</span></div>";
				med_div+=div;
			}
			med_div+="</div>";
		}else{
			med_div+="暂无</div>";
		}
		$("#goal").html(dp_goal);
		$("#plan").html(plan);
		$("#medicine").html(med_div);
		if(doctorAdvice.suggestion!=null&&doctorAdvice.suggestion!='')
			$("#suggestion").html("<div class='wordbreak'>"+doctorAdvice.suggestion+"</div>");
	}
	//最新咨询回复
	function queryConsultive(){
		$.ajax({
			url:"/healthStatus/queryMemberConsult.action",
			async:true,
			data:"",
			dataType:"json",
			type:"POST",
			error:function(){
				//$.alert("发生异常5","请注意");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var memberConsult = modelMap.memberConsult;//最新医嘱	
				//显示最新医嘱内容
				drawConsult(memberConsult);
			}
		});
	}
	function drawConsult(memberConsult){
		if(memberConsult==null){
			return;
		}else{
			var create_time=memberConsult.create_time.substring(0,19);
			var finish_time=memberConsult.report_create_time.substring(0,19);
			var cont="<div><div>咨询时间："+create_time+"</div><div class='wordbreak'>内容："+memberConsult.content+"</div></div>";
			var report="<div><div>回复时间："+finish_time+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
				"医生："+memberConsult.doctor_name+"</div>"+
				"<div class='wordbreak'>内容："+memberConsult.report+"</div></div>";
			$("#consult_cont").html(cont+report);
		}
		
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
			/*
			返回的数据
			city='北京';
			year1='14';//
			month1='02';
			day1='21';
			year2='14';
			month2='02';
			day2='22';
			city='北京';
			savedate_weather='2014-02-21';
			savedate_life='2014-02-21';
			savedate_zhishu='2014-02-21';
			status1='霾';
			status2='雾';
			figure1='mai';
			figure2='wu';
			direction1='无持续风向';
			direction2='无持续风向';
			power1='≤3';
			power2='≤3';
			temperature1='3';//白天温度
			temperature2='-2';//晚上温度
			 */
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
	//关闭血压分级标准窗口
	function closeDiv() {
		$("#popWindow").hide(200);
		hideScreenProtectDiv(1);
	}
	
	//弹出晨峰血压
	function moringBp() {
		$('#popWindow1').draggable({
			disabled : true
		});
		$("#popWindow1").show(200);
		showScreenProtectDiv(1);
	}
	//关闭晨峰血压
	function closeDiv1() {
		$("#popWindow1").hide(200);
		hideScreenProtectDiv(1);
	}
	//弹出心电图
	function ecgPic() {
		$('#popWindow2').draggable({
			disabled : true
		});
		$("#popWindow2").show(200);
		showScreenProtectDiv(1);
	}
	//关闭心电图
	function closeDiv2() {
		$("#popWindow2").hide(200);
		hideScreenProtectDiv(1);
	}


</script>

</head>

<body onload="QueryHealth();" >
  <div class="index_welcome">
    <!--index_welcome_header start-->
    <div class="index_welcome_header">
      <div class="notice">
        <ul>
          <li class="tgreen_notice">健康通告</li>
          <li class="tgrey_notice">Announcement</li>
        </ul>
      </div>
      <div class="health_tip">
        <ul>
          <li class="tgrey_healthTip" id="today"></li>
          <li class="tgreen_healthTip" id="weather">
          </li>
        </ul>
      </div>
    </div>
    <!--index_welcome_header end-->
    <!--index_welcome_main start-->
    <div class="index_welcome_main">
      <!--health_date start--> 
      <div class="health_date">
       <ul>
         <li class="tgreen_healthDate"><span class="tgrey_healthDate">健康</span>状况</li>
         <li class="bloodPressure_date">
           <ul>
             <li class="tblack_date" id="last_bloodpressure"><span class="tblack_datemin">--</span></li>
             <li class="tgrey_time" id="last_bloodpressure_time">最近一次血压值</li>
           </ul>
         </li>
         <li class="bloodPressure_alarm">
           <ul>
             <li class="tblack_date" id="last_bloodalert"><span class="tblack_datemin">--</span></li>
             <li class="tgrey_time" id="last_bloodalert_time">血压异常记录</li>
           </ul>
         </li>
         <li class="heartRate_date">
           <ul>
             <li class="tblack_date" id="last_heartrate"><span class="tblack_datemin">--</span></li>
             
             <li class="tgrey_time" id="last_heartrate_time">最近一次脉率值</li>
             
           </ul>
         </li>
         <li class="heartRate_alarm">
           <ul>
             <li class="tblack_date" id="last_heartratealert"><span class="tblack_datemin">--</span></li>
             <li class="tgrey_time" id="last_heartratealert_time">心率异常记录</li>
           </ul>
         </li>
         <li class="oxygen_date">
           <ul>
             <li class="tblack_date"><span class="tblack_datemin">--</span></li>
             <li class="tgrey_time">最近一次血氧值</li>
           </ul>
         </li>
         <li class="sos_alarm">
           <ul>
             <li class="tblack_sosdate" id="last_island" ><span class="tblack_datemin">--</span></li>
             <li class="tgrey_time" id="last_sosalert">SOS异常记录</li>
           </ul>
         </li>
       </ul>
      </div>
      <!--health_date end-->
      <!--医生医嘱 -->
	  	<div class="bpDiagnosis_results" id="doctorAdvice" style="display:block;margin-top:8px">
       		<div style="text-align: left;width:100%;color:#0ca7a1;font:18px/30px '微软雅黑'; font-weight: bolder;">最新医嘱</div>
       		<div class="bpDiagnosis_results_text"  style="font-size: 12px;width: 100%;">
				<ul id="advice">
					<li class="tgreen_results" style="font-size: 16px; padding-left:20px">测压目标：</li>
					<li class="tblack_results" style="font-size: 13px; padding-left:30px" id="goal">暂无</li>
					
					<li class="tgreen_results" style="font-size: 16px; padding-left:20px">测压方案：</li>
					<li class="tblack_results" style="font-size: 13px; padding-left:30px" id="plan">暂无</li>
					
					<li class="tgreen_results" style="font-size: 16px; padding-left:20px">用药推荐：</li>
					<li class="tblack_results" style="font-size: 13px; padding-left:30px" id="medicine">暂无</li>
					
					<li class="tgreen_results" style="font-size: 16px; padding-left:20px">保健建议：</li>
         			<li class="tblack_results" style="font-size: 13px; padding-left:30px" id="suggestion">暂无</li>
				</ul>
			</div>
	  	</div>
       	<div class="bpDiagnosis_results" id="consultative" style="display:block;margin-top:10px">
          	<div style="text-align: left;width:50%;color:#0ca7a1;font:18px/30px '微软雅黑'; font-weight: bolder;float: left;">最新咨询</div>
          	<div style="text-align: right;width:47%;color:#0ca7a1;float: left;">
          		<a class='tgreen_results' style="font-size: 13px;" href='/jsp/health/healthrecord/member_consult.jsp'  >会员咨询历史</a>
			</div>
       		<div class="bpDiagnosis_results_text"  style="font-size: 12px;width: 100%;">
       			<ul id="advice">
					<li class="tgreen_results" style="font-size: 16px; padding-left:20px">咨询内容：</li>
					<li class="tblack_results" style="font-size: 13px; padding-left:30px" id="consult_cont">暂无</li>
				</ul>
       		</div>
       	</div>
      <!--bpDiagnosis_results start-->
       
      <div class="bpDiagnosis_results">
        <div class="bpDiagnosis_results_trendChart" style="width: 310px;" id="container"></div> 
       	<div class="bpDiagnosis_results_trendChart"  id="container1" style="padding-left: 10px; width:310px; "></div>
       	<div style="float: right;font-size: 12px;margin-top: -10px;" id="bpmorning_what" class="tblack_results">
       		<a class='tgreen_results' style="font-size: 12px;" href='javascript:void(0);' onclick='moringBp();'>晨峰血压是什么？</a></div>
      </div>
      <!-- 晨峰血压 -->
       <div class="bpDiagnosis_results" id="morningBP" style="display:block;margin-top:0px">
       <div style="text-align: left;width:100%;color:#0ca7a1;font:18px/30px '微软雅黑'; font-weight: bolder;" id="histroy_bp_diagnose">血压等级分析</div>
       		<div class="bpDiagnosis_results_text"  style="font-size: 12px;">
					<ul id="bpanalyse">
					
						<li class="tgreen_results" style="font-size: 16px; padding-left:20px">血压等级：</li>
						<li class="tblack_results" id="pressure_level" style="font-size: 13px; padding-left:30px">暂无<a
							href="javascript:void(0);" onclick="bloodPressureStandard();" style="font-size: 13px; padding-left:30px">高血压分级标准</a>
						</li>
						
						<li class="tgreen_results" style="font-size: 16px; padding-left:20px">心血管风险分层：</li>
						<li class="tblack_results" id="risk_level" style="font-size: 13px; padding-left:30px">暂无</li>
						
						<li class="tgreen_results" style="font-size: 16px; padding-left:20px">诊断依据：</li>
						<li class="tblack_results" id="angiocarpy" style="font-size: 13px; padding-left:30px">暂无</li>
						
						<li class="tgreen_results" id="doctor_bpana" style="font-size: 16px; padding-left:20px;display: none;">医生分析</li>
          				<li class="tblack_results" id="doctor_bpreport" style="font-size: 13px; padding-left:30px;display: none;">暂无</li>
						
						<li class="tgreen_results" id="suggest_name" style="font-size: 16px; padding-left:20px">保健建议</li>
          				<li class="tblack_results" id="health_suggest" style="font-size: 13px; padding-left:30px"><h1>暂无</h1></li>

					</ul>
				</div>
       <div class="bpDiagnosis_results_text" id="bpDiagnos">
          <ul>
           
          </ul>
        </div>
       	 	<div class="bpDiagnosis_results_trendChart" style="padding-left: 10px;" id="container2"></div> 
       		<div class="tblack_results" id="container2_time"></div> 
       </div>    
      
      
      <!--bpDiagnosis_results end-->
      <!--hrDiagnosis_results start-->
      <div class="hrDiagnosis_results">
        <div class="hrDiagnosis_results_text">
          <ul>
            <li class="tgreen_results">心电医生回复：</li>
            <li class="tblack_results" id="doctor_report"></li>
          </ul>
        </div>
        <div class="hrDiagnosis_results_sketchMap">
          <ul>
            <li class="tblack_sketchMap" id="reference_range">心率</li>
            <li class="tgrey_sketchMap" >参考正常范围：60 &lt; 心率  &lt; 100</li>
            <li class="sketchMap" id="image_heart_rate"><img style="margin-right: 150px;" src="../../images/health/top.png" /><img src="../../images/health/bottom.png" /></li>
          </ul>
        </div>
      </div>
    </div>
    <!--index_welcome_main end-->
    	

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
</head>
<body>
 <div class="popup" id="popWindow" style="display:none;position:absolute;top:900px; left:100px;z-index: 30;">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">血压分级标准</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv();">X</a></li>
    </ul>
  </div>
  <div class="popup_main">
    <ul>
      <li class="tblack_bp">中国高血压防治指南2010年修订版</li>
      <li class="tyellow_max_bp"><img src="/images/icon/tyellow.png" class="img_color" />
      低血压：<span class="tgrey_bp">收缩压小于</span>90<span class="tgrey_bp">，舒张压小于</span>60</li>
      
      <li class="tgreen_bp"><img src="/images/icon/green.png" class="img_color" />
      正常血压：<span class="tgrey_bp">收缩压小于</span>120<span class="tgrey_bp">，舒张压小于</span>80</li>
      <li class="tblue_bp"><img src="/images/icon/blue.png" class="img_color" />
      正常高值：<span class="tgrey_bp">收缩压</span>120-139<span class="tgrey_bp">，舒张压</span>80-89</li>
      <li class="tyellow_bp"><img src="/images/icon/yellow.png" class="img_color" />
      高于正常：<span class="tgrey_bp">收缩压大于等于</span>140<span class="tgrey_bp">，舒张压大于等于</span>90</li>
      <li class="torange_bp"><img src="/images/icon/orange.png" class="img_color" />
      高血压一级：<span class="tgrey_bp">收缩压</span>140-159<span class="tgrey_bp">，舒张压</span>90-99</li>
      <li class="tbrown_bp"><img src="/images/icon/brown.png" class="img_color" />
      高血压二级：<span class="tgrey_bp">收缩压</span>160-179<span class="tgrey_bp">，舒张压</span>100-109</li>
      <li class="tred_bp"><img src="/images/icon/red.png" class="img_color" />
      高血压三级：<span class="tgrey_bp">收缩压大于等于</span>180<span class="tgrey_bp">，舒张压大于等于</span>110</li>
      
       <li class="tred_orange_bp"><img src="/images/icon/red_orange.png" class="img_color" />
      单纯收缩期高血压：<span class="tgrey_bp">收缩压大于等于</span>140<span class="tgrey_bp">，舒张压小于</span>90</li>
      
      <li class="tgreen_bpPrompt">注意：高压和低压分属于不同级别时，以较高分级为标准</li>
    </ul>
  </div>
 </div>

</body>
</html>
		

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
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
<body>
 <div class="popup" id="popWindow1" style="display:none;position:absolute;top:900px; left:100px;z-index: 30;">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">晨峰血压</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv1();">X</a></li>
    </ul>
  </div>
  <div class="popup_main">
    <ul>
      <li class="tgreen_bpPrompt" style="height: 250px;">
        1.定义：<span style="color:#5a5a5a;">血压在一天中是波动的，存在血压变异。正常人的收缩压及舒张压呈明显的昼夜节律。人体由睡眠状态转为清醒并开始活动，血压从相对较低水平迅速上升至较高水平，这种现象即为“血压晨峰”。用户在规定的测压时间内测压2—3次，取其平均值作为该日的晨峰血压值。</span><br/>
      	2.意义：<span style="color:#5a5a5a;">清晨血压急剧升高或者异常血压晨峰现象，与心血管疾病发生有密切的关系。所以，晨峰血压是医生查看患者血压数据的重要指标。</span><br/>
        3.测压时间：<span style="color:#5a5a5a;">新疆地区早上8点—11点，中国其它地区早上6点—9点。</span><br/>
        4.测压频率：<span style="color:#5a5a5a;">每天在规定时间内测压2—3次。</span>
      </li>
    </ul>
  </div>
 </div>

</body>
</html>
		

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
</head>
<body>
 <div class="popup" id="popWindow2" style="width: 650px;display:none;position:absolute;top:900px; left:100px;z-index: 30;">
  <div class="popup_header" >
    <ul >
      <li class="name_popupHeader" >心电图</li>
      <li class="close_popupHeader" ><a href="javascript:void(0)" onclick="closeDiv2();">X</a></li>
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

</body>
</html>
	</div>
</body>
</html>
