<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>指令设置</title>
<link href="/css/common.css" rel="stylesheet" type="text/css" />
<link href="/css/index_tab.css" rel="stylesheet" type="text/css" />
<style type="text/css">
#list{width:670px; margin:10px auto;font-family:"微软雅黑";}
.list_bg{background:#f7f7f7; height:40px; line-height:40px; width:100%; float:left;border-top:1px solid #aeaeae }
.list_bt{width:50%; height:40px; float:left; text-align:left; padding-left:10px; font-family:"微软雅黑"; font-size:14px; color:#5a5a5a}
.list_button{float:left; width:48%; text-align:right; line-height:40px; height:40px;}
.list_main{width:98%; margin:10px auto; text-align:left;font-family:"微软雅黑"; font-size:13px; color:#5a5a5a} 
#bt01{width:100%; float:left; text-align:right; margin-top:10px;}
#bt02{width:100%; float:left; margin-bottom:10px;}
.sr01{width:228px; height:21px; text-align:left; padding-left:3px; line-height:21px; margin-top:4px;border:1px solid #7f9db9;}
.button01{background:url(/gzjky/images/button/btn_Submit.png) no-repeat; height:30px; width:80px; border:none; line-height:30px;color:#fff}
.sjtx{border-collapse:collapse; border:1px solid #7f9db9; margin-top:10px;}
.sjtx td{text-align:center; height:25px;border-bottom:1px solid #7f9db9;border-right:1px solid #7f9db9;}
.sjtx_hander{background-color:#b4cee6;  font-size:12px; font-weight:bold; color:#1b3b58 }
.fx{margin-right:5px;}
</style>
<style type="text/css">
* {margin:0; padding:0;}
html,body{height:80%;}
html{overflow-x:hidden;} 
body {text-align:center; margin:0; padding:0; font-size:12px; background-color:#FFFFFF;}
ul{padding:0;margin:0;list-style-type:none;}
img {vertical-align:top;}
div,form,img,ul,li {margin:0;padding:0;border:0;}
strong {font-weight:normal}
h1,h2,h3,h4,h5,h6 { margin:0; padding:0;font-weight:normal;}

html {height:100%; border:0; overflow:hidden;overflow-x:hidden}
body {height:100%; margin:0; overflow:hidden;overflow-x:hidden}
</style>
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/ztree/jquery.ztree.all-3.1.min.js'/>" type="text/javascript"></script>
<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet"/>
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet"/>
<link href="/js/artDialog/skins/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
	
	$(function(){
		$('textarea').maxlength({});
	});
	//收起展开按钮功能的实现
	function expand(lbname, liname){
		if($("#"+liname).css("display")=="none"){
			$("#"+lbname).attr("src","/gzjky/images/button/sq.png");
			$("#"+liname).show();
		}else{
			$("#"+lbname).attr("src","/gzjky/images/button/zk.png");
			$("#"+liname).hide();
		}
	}
	//页面加载查询
	function query() {
		queryDeviceInfo();
	}
	var para = "";
 	var xmlHttp;
 	var response;
	var regx = /^\d+$/;
	var array8 = new Array();
	var array9 = new Array();
	var device_id = "${param.device_id}";
	function queryDeviceInfo() {
		var param="device_id="+device_id;
		//para = "device_unit_id=1129550&device_cluster_id=1&device_unit_type=10";
		xmlHttp = $.ajax({
			url:"/gzjky/device/queryDeviceSettingCommonInfo.do",
			async:true,
			data:param,
			dataType:"json",
			type:"POST",
			error:function(){
				$("#alert_message").text('查询失败');
			},
			success:function(response) {
				var modelMap = response;
				deviceSettingCommon = modelMap.result;
				deviceTakeMedicineNoticeList = modelMap.deviceTakeMedicineNoticeList;
				deviceTestBloodPressureNoticeList = modelMap.deviceTestBloodPressureNoticeList;
				//显示数据
				$("#settingform").jsonForForm({data:deviceSettingCommon,isobj:true});
				//显示数据
				showData(modelMap.outBeanList);
				showData2(modelMap.outBeanList2);
				//取消区域
				initdirectivecancel(deviceSettingCommon);
			}
		});
	}
	//初始化取消指令设置
	function initdirectivecancel(deviceSettingCommon){
		var setting_flag_simcard = deviceSettingCommon.setting_flag_simcard;
		var setting_flag_heartrate_alert = deviceSettingCommon.setting_flag_heartrate_alert;
		var setting_flag_blood_pressure_alert = deviceSettingCommon.setting_flag_blood_pressure_alert;
		var setting_flag_safe_island = deviceSettingCommon.setting_flag_safe_island;
		var setting_flag_take_medicine_notice = deviceSettingCommon.setting_flag_take_medicine_notice;
		var setting_flag_test_blood_pressure_notice = deviceSettingCommon.setting_flag_test_blood_pressure_notice;
		var setting_flag_send_data_interval = deviceSettingCommon.setting_flag_send_data_interval;
		if(setting_flag_simcard=="2")
			$("#setting_flag_simcard").attr("checked","checked");
		else
			$("#setting_flag_simcard").attr("checked","");
			
		if(setting_flag_heartrate_alert=="2")
			$("#setting_flag_heartrate_alert").attr("checked","checked");
		else
			$("#setting_flag_heartrate_alert").attr("checked","");
			
		if(setting_flag_blood_pressure_alert=="2")
			$("#setting_flag_blood_pressure_alert").attr("checked","checked");
		else
			$("#setting_flag_blood_pressure_alert").attr("checked","");
			
		if(setting_flag_safe_island=="2")
			$("#setting_flag_safe_island").attr("checked","checked");
		else
			$("#setting_flag_safe_island").attr("checked","");
			
		if(setting_flag_take_medicine_notice=="2")
			$("#setting_flag_take_medicine_notice").attr("checked","checked");
		else
			$("#setting_flag_take_medicine_notice").attr("checked","");
			
		if(setting_flag_test_blood_pressure_notice=="2")
			$("#setting_flag_test_blood_pressure_notice").attr("checked","checked");
		else
			$("#setting_flag_test_blood_pressure_notice").attr("checked","");
			
		if(setting_flag_send_data_interval=="2")
			$("#setting_flag_send_data_interval").attr("checked","checked");
		else
			$("#setting_flag_send_data_interval").attr("checked","");
		
	}
	//初始化用药提醒
	function showData(deviceTakeMedicineNoticeList){
		clearTable('tableH88');
		array8 = new Array();
		if (deviceTakeMedicineNoticeList==null)
			return;
		for(var i=0;i<deviceTakeMedicineNoticeList.length;i++){
			var id = deviceTakeMedicineNoticeList[i].id;
			var time = deviceTakeMedicineNoticeList[i].txtime.split(':')
			var hour = time[0];
			var minute = time[1];
			var note = deviceTakeMedicineNoticeList[i].txnr;
			var notice_interval = deviceTakeMedicineNoticeList[i].txzq;
			var state = deviceTakeMedicineNoticeList[i].isdelete;
			addtable1(id,hour,minute,note,notice_interval,state);
		}
	}
	//画出用药提醒table
	function addtable1(id,hour,minute,note,notice_interval,state){
		//重复性验证
		array8.push(hour+'-'+minute+'-'+notice_interval);
		
		var table = document.getElementById("tableH88");
		var rowcount=table.rows.length;
		var tr=table.insertRow(rowcount);
		tr.id = id;
		td=tr.insertCell(0);
		if(minute<10){minute="0"+Number(minute);}
		td.innerHTML=hour+":"+minute;
		td=tr.insertCell(1);
		td.innerHTML=notice_interval;
		td=tr.insertCell(2);
		td.innerHTML=note;
		td=tr.insertCell(3);
		var sta='<input type="button" name="'+state+'" onClick="validObjState(this)" value="开启"> ';
		if(state==false){
			sta='<input type="button" name="'+state+'" onClick="validObjState(this)" value="关闭"> ';
		}
		var dele='| <input name="button" type="button" onClick="del(this.parentNode.parentNode.rowIndex)" value="删除">';
		td.innerHTML=sta+dele;
	}
	//初始化测压时间提醒数据
	function showData2(deviceTestBloodPressureNoticeList){
		clearTable('tableH89');
		array9 = new Array();
		if (deviceTestBloodPressureNoticeList==null)
			return;
		for(var i=0;i<deviceTestBloodPressureNoticeList.length;i++){
			var id = deviceTestBloodPressureNoticeList[i].id;
			var start_time = deviceTestBloodPressureNoticeList[i].tbegin;
			var end_time = deviceTestBloodPressureNoticeList[i].tend;
			var notice_interval = deviceTestBloodPressureNoticeList[i].txzq;
			var state = deviceTestBloodPressureNoticeList[i].isdelete;
			addtable2(id,start_time,end_time,notice_interval,state);
		}
	}
	//画出测压时间提醒table
	function addtable2(id,start_time,end_time,notice_interval,state){
		//重复性验证
		array9.push(start_time+'-'+end_time+'-'+notice_interval);
	
		var table = document.getElementById("tableH89");
		var rowcount=table.rows.length;
		var tr=table.insertRow(rowcount);
		tr.id = id;
		td=tr.insertCell(0);
		td.innerHTML=start_time;
		td=tr.insertCell(1);
		td.innerHTML=end_time;
		td=tr.insertCell(2);
		td.innerHTML=notice_interval;
		td=tr.insertCell(3);
		var sta='<input type="button" name="'+state+'" onClick="validObjState(this)" value="开启"> ';
		if(state==false){
			sta='<input type="button" name="'+state+'" onClick="validObjState(this)" value="关闭"> ';
		}
		var dele='| <input name="button" type="button" onClick="del2(this.parentNode.parentNode.rowIndex)" value="删除">';
		td.innerHTML=sta+dele;
	}
	
	//更新数据方法
	function updateCommonInfo(para) {
		commonajax(para,"/gzjky/device/updateCommonInfo.do");
	}
	
	//短信中心号码设置（未用）		
	function generateH81(){
		var sms_center = $("#sms_center").val().trim();
		if(sms_center.length<=0 || !mobilephone(sms_center)){
			$.alert('短信中心号码不能为空或格式不正确.');
			$("#sms_center").focus();
			return false;
		}
		var para = "instype=H81&device_unit_id=1129550&device_cluster_id=1&device_unit_type=10&sms_center="+sms_center;
		
		updateCommonInfo(para);
		
	}
	//sim卡正则规则
	simcard_reg =/(^((0\d{2,3})(-)?)?(\d{7,8})(-(\d{3,}))?$)|^((00){1}[1-9]{1}[0-9]{1,3}|86|\+86)?1[3458]\d{9}$/;
	// /^((00){1}[1-9]{1}[0-9]{1,3}|86|\+86)?1[3458]\d{9}$/;
	
	//绑定号码设置保存验证及提交
	function generateH82(){
		var card=new Array();
		var model="";
		var simcard = $(".simcard");
		var flag=0;
		for(var i=0;i<simcard.length;i++){
			var sim=simcard[i].value;
			card[i]=sim;
			if(sim!=null&&sim!=""){
				model=sim;
				flag=1;
				if(!simcard_reg.test(sim)){
					var k=i+1;
					$.alert('号码'+k+'格式不正确.');
					$("#simcard_"+k).focus();
					return false;
				}
			}
		}
		if(flag==0){
			$.alert('至少有一个号码不能为空.');
			$("#simcard_1").focus();
			return false;
		}
		/*var simcard_1 = $("#simcard_1").val().trim();
		var simcard_2 = $("#simcard_2").val().trim();
		var simcard_3 = $("#simcard_3").val().trim();
		if(simcard_1.length<=0 || !simcard_reg.test(simcard_1)){
			$.alert('号码1不能为空或格式不正确.');
			$("#simcard_1").focus();
			return false;
		}
		if(simcard_2.length<=0 || !simcard_reg.test(simcard_2)){
			$.alert('号码2不能为空或格式不正确.');
			$("#simcard_2").focus();
			return false;
		}
		if(simcard_3.length<=0 || !simcard_reg.test(simcard_3)){
			$.alert('号码3不能为空或格式不正确.');
			$("#simcard_3").focus();
			return false;
		}*/
		for(var i=0;i<3;i++){
			if(card[i]==null||card[i]=="")card[i]=model;
		}
		var para = "device_id="+device_id+"&commontype=1"+"&simcard_1="+card[0]+"&simcard_2="+card[1]+"&simcard_3="+card[2];
		updateCommonInfo(para);
	}
	
	function generateH83(){
		var send_data_interval = $("#send_data_interval").val();
		if(send_data_interval.length<=0 ||!regx.test(send_data_interval) || Number(send_data_interval)>255)
		{
			$.alert('时间周期不能为空');
			$("#send_data_interval").focus();
			return false;
		}
		var para = "device_id="+device_id+"&commontype=2"+"&send_data_interval="+send_data_interval;
		updateCommonInfo(para);
	}
	
	function generateH84(){
		var safe_island_radius = $("#safe_island_radius").val().trim();
		var safe_island_verify_interval = $("#safe_island_verify_interval").val().trim();
		var safe_island_longitude = $("#safe_island_longitude").val().trim();
		var safe_island_latitude = $("#safe_island_latitude").val().trim();
		var regularlat = /^-?(?:90(?:\.0{1,6})?|(?:[1-8]?\d(?:\.\d{1,6})?))$/;
        var regularlng = /^-?(?:(?:180(?:\.0{1,6})?)|(?:(?:(?:1[0-7]\d)|(?:[1-9]?\d))(?:\.\d{1,6})?))$/;
		if(safe_island_radius.length<=0 || !regx.test(safe_island_radius) || Number(safe_island_radius)<=0){
			$.alert('围栏半径不能为空或必须为正整数');
			$("#safe_island_radius").focus();
			return false;
		}
		if(safe_island_verify_interval.length<=0 || !regx.test(safe_island_verify_interval) || Number(safe_island_verify_interval)<0 || Number(safe_island_verify_interval)>255){
			$.alert('时间周期不能为空或必须为小于255的非负整数');
			$("#safe_island_verify_interval").focus();
			return false;
		} 
		if(safe_island_latitude.length<=0 || !regularlat.test(safe_island_latitude)){
			$.alert('中心纬度不能为空或格式不正确');
			$("#safe_island_latitude").focus();
			return false;
		}
		if(safe_island_longitude.length<=0 || !regularlng.test(safe_island_longitude)){
			$.alert('中心经度不能为空或格式不正确');
			$("#safe_island_longitude").focus();
			return false;
		}
		var para = "instype=H84&device_unit_id=1129550&device_cluster_id=1&device_unit_type=10&safe_island_radius="+safe_island_radius+"&safe_island_verify_interval="+safe_island_verify_interval+"&safe_island_longitude="+safe_island_longitude+"&safe_island_latitude="+safe_island_latitude;
		updateCommonInfo(para);
	}
	
	function generateH86(){
		var heartrate_alert_threshold_top = $("#heartrate_alert_threshold_top").val().trim();
		var heartrate_alert_threshold_bottom = $("#heartrate_alert_threshold_bottom").val().trim();
		if(heartrate_alert_threshold_top.length<=0 || !regx.test(heartrate_alert_threshold_top) || Number(heartrate_alert_threshold_top)<=0 || Number(heartrate_alert_threshold_top)>231){
			$.alert('心率上限值有效范围为1~231');
			$("#heartrate_alert_threshold_top").focus();
			return false;
		}
		if(heartrate_alert_threshold_bottom.length<=0 || !regx.test(heartrate_alert_threshold_bottom) || Number(heartrate_alert_threshold_bottom)<=0 || Number(heartrate_alert_threshold_bottom)>231){
			$.alert('心率下限值有效范围为1~231');
			$("#heartrate_alert_threshold_bottom").focus();
			return false;
		}
		if(Number(heartrate_alert_threshold_top)<Number(heartrate_alert_threshold_bottom)){
			 $.alert("下限值不能高于上限值");
             return false;
		}
		if(Number(heartrate_alert_threshold_top)==Number(heartrate_alert_threshold_bottom)){
			 $.alert("下限值不能等于上限值");
             return false;
		}
		var para = "device_id="+device_id+"&commontype=3"+"&heartrate_alert_threshold_top="+heartrate_alert_threshold_top+"&heartrate_alert_threshold_bottom="+heartrate_alert_threshold_bottom;
		updateCommonInfo(para);
	}
	
	function generateH87(){
		var blood_pressure_alert_shrink_threshold_top = $("#blood_pressure_alert_shrink_threshold_top").val().trim();
		var blood_pressure_alert_shrink_threshold_bottom = $("#blood_pressure_alert_shrink_threshold_bottom").val().trim();
		var blood_pressure_alert_diastole_threshold_top = $("#blood_pressure_alert_diastole_threshold_top").val().trim();
		var blood_pressure_alert_diastole_threshold_bottom = $("#blood_pressure_alert_diastole_threshold_bottom").val().trim();
		if(blood_pressure_alert_shrink_threshold_top.length<=0 || !regx.test(blood_pressure_alert_shrink_threshold_top) || Number(blood_pressure_alert_shrink_threshold_top)<=0 || Number(blood_pressure_alert_shrink_threshold_top)>231){
			$.alert('收缩压上限值有效范围为1~231');
			$("#blood_pressure_alert_shrink_threshold_top").focus();
			return false;
		}
		if(blood_pressure_alert_shrink_threshold_bottom.length<=0 || !regx.test(blood_pressure_alert_shrink_threshold_bottom) || Number(blood_pressure_alert_shrink_threshold_bottom)<=0 || Number(blood_pressure_alert_shrink_threshold_bottom)>231){
			$.alert('收缩压下限值有效范围为1~231');
			$("#blood_pressure_alert_shrink_threshold_bottom").focus();
			return false;
		}
		if(Number(blood_pressure_alert_shrink_threshold_top)<Number(blood_pressure_alert_shrink_threshold_bottom)){
			 $.alert("收缩压下限值不能高于上限值");
             return false;
		}
		if(Number(blood_pressure_alert_shrink_threshold_top)==Number(blood_pressure_alert_shrink_threshold_bottom)){
			 $.alert("收缩压下限值不能等于上限值");
             return false;
		}
		if(blood_pressure_alert_diastole_threshold_top.length<=0 || !regx.test(blood_pressure_alert_diastole_threshold_top) || Number(blood_pressure_alert_diastole_threshold_top)<=0 || Number(blood_pressure_alert_diastole_threshold_top)>231){
			$.alert('舒张压上限值有效范围为1~231');
			$("#blood_pressure_alert_diastole_threshold_top").focus();
			return false;
		}
		if(blood_pressure_alert_diastole_threshold_bottom.length<=0 || !regx.test(blood_pressure_alert_diastole_threshold_bottom) || Number(blood_pressure_alert_diastole_threshold_bottom)<=0 || Number(blood_pressure_alert_diastole_threshold_bottom)>231){
			$.alert('舒张压下限值有效范围为1~231');
			$("#blood_pressure_alert_diastole_threshold_bottom").focus();
			return false;
		}
		if(Number(blood_pressure_alert_diastole_threshold_top)<Number(blood_pressure_alert_diastole_threshold_bottom)){
			 $.alert("舒张压下限值不能高于上限值");
             return false;
		}
		if(Number(blood_pressure_alert_diastole_threshold_top)==Number(blood_pressure_alert_diastole_threshold_bottom)){
			 $.alert("舒张压下限值不能等于上限值");
             return false;
		}
		var para = "device_id="+device_id+"&commontype=4"+"&blood_pressure_alert_shrink_threshold_top="+blood_pressure_alert_shrink_threshold_top+"&blood_pressure_alert_shrink_threshold_bottom="+blood_pressure_alert_shrink_threshold_bottom+"&blood_pressure_alert_diastole_threshold_top="+blood_pressure_alert_diastole_threshold_top+"&blood_pressure_alert_diastole_threshold_bottom="+blood_pressure_alert_diastole_threshold_bottom;
		updateCommonInfo(para);
		
	}
	//删除画出的table的所有行
	function clearTable(id){
		 var table = document.getElementById(id);
		 var rowcount=table.rows.length;
		 for(var i = rowcount-1;i>0;i--){
		 	table.deleteRow(i);
		 }
	}
	
	function generateH8A(){
		var time_zone_ew = $("#time_zone_ew").val();
		var time_zone_offset = $("#time_zone_offset").val();
		var para = "instype=H8A&device_unit_id=1129550&device_cluster_id=1&device_unit_type=10&time_zone_ew="+time_zone_ew+"&time_zone_offset="+time_zone_offset
		updateCommonInfo(para);
	}
	//验证用药提醒内容
	function addMedicationRemind(){
	
		var table = document.getElementById("tableH88");
		var rowcount=table.rows.length;
		if(rowcount>10)
		{
			$.alert('用药时间提醒任务数量过多');
			return false;
		}
		
		var hour =  $("#hour").val();
		var minute =  $("#minute").val();
		var note =  $.trim($("#note").val());
		var notice_interval =  $("#notice_interval").val();
		if(minute.length<=0 || !regx.test(minute) || Number(minute)>60){
			$.alert('提醒时间不能为空或必须为非负整数');
			$("#minute").focus();
			return false;
		}
		if(note.length<=0){
			$.alert('提醒内容不能为空');
			$("#note").focus();
			return false;
		}
		if(/[~#$%^&!@*]+/.test(note)){
			$.alert('提醒内容包括系统禁止使用的特殊符号');
			$("#note").focus();
			return false;	
		}
		var l_key;
		for (var i = 0; i < array8.length; i++)
		{
			l_key=array8[i];
			if(l_key==hour+'-'+minute+'-'+notice_interval)
			{
				$.alert('用药提醒任务重复!');
				return;
			}
		}
		
		addtable1("",hour,minute,note,notice_interval,false);
		
		$("#note").val('');
		$('#hour option:nth-child(1)').attr("selected","selected");
    	$('#minute option:nth-child(1)').attr("selected","selected");
    	$('#notice_interval option:nth-child(1)').attr("selected","selected");
	}
	
	function commonajax(para,urlStr,refresh){
		xmlHttp = $.ajax({
			url:urlStr,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert('操作失败');
			},
			
			success:function(response) {

				var state = response.result;
				if(state=="1"){
					query();
					$.alert('配置成功');
				}
				
				if(refresh=="true"){
					$("#settingform").clearForm();
					
				}
			//	queryDeviceInfo();
			}
		});
	}
	//验证测压提醒
	function addMpRemind(){
	
		var table = document.getElementById("tableH89");
		var rowcount=table.rows.length;
		if(rowcount>10)
		{
			$.alert('测压提醒任务数量过多');
			return false;
		}
		var start_time =  $("#start_time").val();
		var end_time =  $("#end_time").val();
		var end_time_mm;
		if(start_time==end_time){
			$.alert('开始时间与结束时间不能相同');
			return false;
		}
		if(Number(end_time)==0){
			end_time_mm = 24;
		}else{
			end_time_mm = end_time;
		}
		if(Number(end_time_mm)<=Number(start_time)){
			$.alert('结束时间早于开始时间');
			return false;
		}
		var notice_interval =  $("#notice_intervals").val();
		if(notice_interval.length<=0 || !regx.test(notice_interval) || Number(notice_interval)<=0){
			$.alert('测压周期不能为空或必须为正整数');
			$("#notice_intervals").focus();
			return false;
		}
		if(Number(notice_interval)>255)
		{
			$.alert('测压周期不能超过255分钟');
			$("#notice_intervals").focus();
			return false;
		}
		if((end_time_mm-start_time)*60<notice_interval){
			$.alert('测压周期过长');
			$("#notice_intervals").focus();
			return false;
		}
		if((end_time_mm-start_time)*60/notice_interval>=30){
			$.alert('开始时间到结束时间内，测压次数超过30次');
			$("#notice_intervals").focus();
			return false;
		}
		var l_key;
		for (i = 0; i < array9.length; i++)
		{
			l_key=array9[i];
			if(l_key==start_time+'-'+end_time+'-'+notice_interval)
			{
				$.alert('测压提醒任务重复!');
				return;
			}
		}
		
		addtable2("",start_time,end_time,notice_interval,false);
		
		$('#start_time option:nth-child(1)').attr("selected","selected");
    	$('#end_time option:nth-child(1)').attr("selected","selected");
		$("#notice_intervals").val('');
		
	}
	//删除tableH88某一行
	function del(obj){
		var table = document.getElementById("tableH88");
		table.deleteRow(obj);
		array8.splice(obj-1,1);
	}
	//删除tableH89某一行
	function del2(obj){
		var table = document.getElementById("tableH89");
		table.deleteRow(obj);
		array9.splice(obj-1,1);
	}
	function validObjState(obj){
		var sta=$(obj).attr("name");
		if(sta=="false"){
			$(obj).attr("value","开启");
			$(obj).attr("name","true");
		} 			
		else {
			$(obj).attr("value","关闭");
			$(obj).attr("name","false");
		}
		
	}
	function generateH88(){
		var table = document.getElementById("tableH88");
		var rowcount=table.rows.length;
		if(rowcount<=1)
		{
			//para = "device_unit_id=1129550&device_cluster_id=1&device_unit_type=10&setting_flag_take_medicine_notice=2";
			para= "device_id="+ device_id;
			commonajax(para,"/gzjky/device/addTakeMedicineNotice.do","true");
		}else{
			var str = "";
			for(var i=1;i<rowcount;i++){
				var id = table.rows[i].id;
				var times = table.rows[i].cells[0].innerHTML;
				var notice_interval = table.rows[i].cells[1].innerHTML;
				var note = table.rows[i].cells[2].innerHTML;
				var sta=table.rows[i].cells[3].childNodes[0].name;
				str+=","+id+";"+times+";"+notice_interval+";"+note+";"+sta;
			}
			str = str.slice(1);
			//para = "device_unit_id=1129550&device_cluster_id=1&device_unit_type=10&sms_center="+str;
			para ="device_id="+device_id+"&sms_center="+str;
			commonajax(para,"/gzjky/device/addTakeMedicineNotice.do");
		}
		
		
	}
	
	function generateH89(){
		var table = document.getElementById("tableH89");
		var rowcount=table.rows.length;
		if(rowcount<=1)
		{
			para= "device_id="+ device_id;
			commonajax(para,"/gzjky/device/addTestBloodPressureNotice.do");
		}else{
			var str = "";
			for(var i=1;i<rowcount;i++){
				var id = table.rows[i].id;
				var start_time = table.rows[i].cells[0].innerHTML;
				var end_time = table.rows[i].cells[1].innerHTML;
				var notice_interval = table.rows[i].cells[2].innerHTML;
				var sta=table.rows[i].cells[3].childNodes[0].name;
				str+=","+id+";"+start_time+";"+end_time+";"+notice_interval+";"+sta;
			}
			str = str.slice(1);
			para ="device_id="+device_id+"&sms_center="+str;
			//para = "device_unit_id=1129550&device_cluster_id=1&device_unit_type=10&sms_center="+str;
			commonajax(para,"/gzjky/device/addTestBloodPressureNotice.do");
		}
	}
	
	
	
	function generatedirectivecancel(){
		para = "device_unit_id=1129550&device_cluster_id=1&device_unit_type=10";
		var setting_flag_simcard = $("#setting_flag_simcard").attr("checked");
		var setting_flag_heartrate_alert = $("#setting_flag_heartrate_alert").attr("checked");
		var setting_flag_blood_pressure_alert = $("#setting_flag_blood_pressure_alert").attr("checked");
		//var setting_flag_safe_island = $("#setting_flag_safe_island").attr("checked");
		var setting_flag_take_medicine_notice = $("#setting_flag_take_medicine_notice").attr("checked");
		var setting_flag_test_blood_pressure_notice = $("#setting_flag_test_blood_pressure_notice").attr("checked");
		var setting_flag_send_data_interval = $("#setting_flag_send_data_interval").attr("checked");
		if(setting_flag_simcard){
			para+="&setting_flag_simcard=2";
		}else{
			para+="&setting_flag_simcard=0";
		}
		
		if(setting_flag_heartrate_alert){
			para+="&setting_flag_heartrate_alert=2";
		}else{
			para+="&setting_flag_heartrate_alert=0";
		}
			
		if(setting_flag_blood_pressure_alert){
			para+="&setting_flag_blood_pressure_alert=2";
		}else{
			para+="&setting_flag_blood_pressure_alert=0";
		}
			
		//if(setting_flag_safe_island)
		//	para+="&deviceSettingCommon.setting_flag_safe_island=2"
		if(setting_flag_take_medicine_notice){
			para+="&setting_flag_take_medicine_notice=2";
		}else{
			para+="&setting_flag_take_medicine_notice=0";
		}
			
		if(setting_flag_test_blood_pressure_notice){
			para+="&setting_flag_test_blood_pressure_notice=2";
		}else{
			para+="&setting_flag_test_blood_pressure_notice=0";
		}
			
		if(setting_flag_send_data_interval){
			para+="&setting_flag_send_data_interval=2";
		}else{
			para+="&setting_flag_send_data_interval=0";	
		}
		commonajax(para,"/deviceBaseInfo/generatedirectivecancel.action","true");
	}
</script>
</head>

<body onload="query();" style="height: 1500px;">
   <div class="ecg_title">
      <ul>
        <li class="ecg_titleGreen">修改配置</li>
        <li class="ecg_titleGray">当前位置：<a href="/jsp/health/equipment/equipment.jsp">我的设备</a>>修改配置</li>
      </ul>
    </div>
<form id="settingform">
  <div id="list" >
    <ul class="list_tab">
    <!--短信中心号码设置
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">短信中心号码设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb81Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb81Hexpand','li_81H');"/></a></div>
          </li>
          <li class="list_main" id="li_81H">
            <div id="bt01"><input type="button" value="提 交" class="button01" onclick="generateH81()"/></div>
            <div id="bt02">中心号码：<input name="sms_center" id="sms_center" class="sr01" type="text" maxlength="11"/></div>
          </li>
        </ul>  
      </li>
      --> 
<!--绑定号码设置-->      
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">绑定号码设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb82Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb82Hexpand','li_82H');" /></a></div>
          </li>
          <li class="list_main" id="li_82H">
            <div id="bt01"><div style="float: left;">号码可以为手机或固定电话，固话前请加区号如0571</div><input type="button" value="提 交" class="button01" onclick="generateH82()"/></div>
            <div id="bt02">
            	号码1：<input name="sim1" id="sim1" type="text" class="sr01 simcard" maxlength="12"/><br />
            	号码2：<input name="sim2" id="sim2" type="text" class="sr01 simcard"  maxlength="12"/><br />
            	号码3：<input name="sim3" id="sim3" type="text" class="sr01 simcard"  maxlength="12"/>
            </div>
          </li>
        </ul>   
      </li>
<!--数据上传定时设置-->        
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">定时上传设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb83Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb83Hexpand','li_83H');" /></a></div>
          </li>
          <li class="list_main" id="li_83H">
            <div id="bt01"><input type="button" value="提 交" class="button01" onclick="generateH83()"/></div>
            <div id="bt02">
            时间周期：<select name="send_data_interval" id="send_data_interval"><option value="">--请选择--</option><option value="5">5分钟</option><option value="10">10分钟</option><option value="15">15分钟</option><option value="30">30分钟</option><option value="60">60分钟</option></select><span style="color:#aeaeae; margin-left:10px">(单位：分钟)</span>
            </div>
          </li>
        </ul>   
      </li>
<!--电子围栏设置 
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">电子围栏设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb84Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb84Hexpand','li_84H');" /></a></div>
          </li>
          <li id="li_84H" class="list_main">
            <div id="bt01"><input type="button" value="提 交" onclick="generateH84()" class="button01" /></div>
            <div id="bt02">
            围栏半径：<input name="safe_island_radius" id="safe_island_radius" type="text" class="sr01" maxlength="3"/><span style="color:#aeaeae; margin-left:10px">(单位：米)</span><br />
            验证周期：<input name="safe_island_verify_interval" id="safe_island_verify_interval" type="text" class="sr01" maxlength="3"/><span style="color:#aeaeae; margin-left:10px">(单位：分钟)</span><br />
            中心纬度：<input name="safe_island_latitude" id="safe_island_latitude" type="text" class="sr01" maxlength="10"/><span style="color:#aeaeae; margin-left:10px">(纬度范围：-90.000000~90.000000)</span><br />
            中心经度：<input name="safe_island_longitude" id="safe_island_longitude" type="text" class="sr01" maxlength="11"/><span style="color:#aeaeae; margin-left:10px">(经度范围：-180.000000~180.000000)</span><br />
            </div>
          </li>
        </ul>   
      </li>-->
      <!--心率报警设置-->        
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">心率报警设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb86Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb86Hexpand','li_86H');" /></a></div>
          </li>
          <li id="li_86H" class="list_main" style="">
            <div id="bt01"><input type="button" value="提 交" onclick="generateH86()" class="button01" /></div>
            <div id="bt02">
            心率上限值：<input name="heartrate_alert_threshold_top" id="heartrate_alert_threshold_top" type="text" class="sr01"  maxlength="3"/><span style="color:#aeaeae; margin-left:10px">(单位：次/分)</span><br />
            心率下限值：<input name="heartrate_alert_threshold_bottom" id="heartrate_alert_threshold_bottom" type="text" class="sr01" maxlength="3"/><span style="color:#aeaeae; margin-left:10px">(单位：次/分)</span><br />
            </div>
          </li>
        </ul>   
      </li>
<!--血压报警设置--> 
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">血压报警设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb87Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb87Hexpand','li_87H');" /></a></div>
          </li>
          <li id="li_87H" class="list_main" style="">
            <div id="bt01"><input type="button" value="提 交" class="button01" onclick="generateH87()" /></div>
            <div id="bt02">
            收缩压上限值：<input name="blood_pressure_alert_shrink_threshold_top" id="blood_pressure_alert_shrink_threshold_top" type="text" class="sr01"  maxlength="3"/><span style="color:#aeaeae; margin-left:10px">(单位：毫米汞柱)</span><br />
            收缩压下限值：<input name="blood_pressure_alert_shrink_threshold_bottom" id="blood_pressure_alert_shrink_threshold_bottom" type="text" class="sr01"  maxlength="3"/><span style="color:#aeaeae; margin-left:10px">(单位：毫米汞柱)</span><br />
            舒张压上限值：<input name="blood_pressure_alert_diastole_threshold_top" id="blood_pressure_alert_diastole_threshold_top" type="text" class="sr01"  maxlength="3"/><span style="color:#aeaeae;margin-left:10px">(单位：毫米汞柱)</span><br />
            舒张压下限值：<input name="blood_pressure_alert_diastole_threshold_bottom" id="blood_pressure_alert_diastole_threshold_bottom" type="text" class="sr01"  maxlength="3"/><span style="color:#aeaeae; margin-left:10px">(单位：毫米汞柱)</span><br />
            </div>
          </li>
        </ul>
      </li>
 <!--用药时间提醒设置--> 
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">用药时间提醒设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb88Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb88Hexpand','li_88H');" /></a></div>
          </li>
          <li id="li_88H" class="list_main" >
           	<div id="bt01"><input type="button" value="提 交" class="button01" onclick="generateH88()" /></div>
            <div id="bt02">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="45%" height="25">提醒时间：
                  <select name="hour" id="hour" style="height:20px; width:70px;">
                  
                    <option value="0">0</option>
                  
                    <option value="1">1</option>
                  
                    <option value="2">2</option>
                  
                    <option value="3">3</option>
                  
                    <option value="4">4</option>
                  
                    <option value="5">5</option>
                  
                    <option value="6">6</option>
                  
                    <option value="7">7</option>
                  
                    <option value="8">8</option>
                  
                    <option value="9">9</option>
                  
                    <option value="10">10</option>
                  
                    <option value="11">11</option>
                  
                    <option value="12">12</option>
                  
                    <option value="13">13</option>
                  
                    <option value="14">14</option>
                  
                    <option value="15">15</option>
                  
                    <option value="16">16</option>
                  
                    <option value="17">17</option>
                  
                    <option value="18">18</option>
                  
                    <option value="19">19</option>
                  
                    <option value="20">20</option>
                  
                    <option value="21">21</option>
                  
                    <option value="22">22</option>
                  
                    <option value="23">23</option>
                  
                  </select>
                  <span style="color:#aeaeae;; margin:0 5px">时</span>
                  <select name="minute" id="minute" style="height:20px; width:70px;">
                  
                    <option value="0">0</option>
                  
                    <option value="1">1</option>
                  
                    <option value="2">2</option>
                  
                    <option value="3">3</option>
                  
                    <option value="4">4</option>
                  
                    <option value="5">5</option>
                  
                    <option value="6">6</option>
                  
                    <option value="7">7</option>
                  
                    <option value="8">8</option>
                  
                    <option value="9">9</option>
                  
                    <option value="10">10</option>
                  
                    <option value="11">11</option>
                  
                    <option value="12">12</option>
                  
                    <option value="13">13</option>
                  
                    <option value="14">14</option>
                  
                    <option value="15">15</option>
                  
                    <option value="16">16</option>
                  
                    <option value="17">17</option>
                  
                    <option value="18">18</option>
                  
                    <option value="19">19</option>
                  
                    <option value="20">20</option>
                  
                    <option value="21">21</option>
                  
                    <option value="22">22</option>
                  
                    <option value="23">23</option>
                  
                    <option value="24">24</option>
                  
                    <option value="25">25</option>
                  
                    <option value="26">26</option>
                  
                    <option value="27">27</option>
                  
                    <option value="28">28</option>
                  
                    <option value="29">29</option>
                  
                    <option value="30">30</option>
                  
                    <option value="31">31</option>
                  
                    <option value="32">32</option>
                  
                    <option value="33">33</option>
                  
                    <option value="34">34</option>
                  
                    <option value="35">35</option>
                  
                    <option value="36">36</option>
                  
                    <option value="37">37</option>
                  
                    <option value="38">38</option>
                  
                    <option value="39">39</option>
                  
                    <option value="40">40</option>
                  
                    <option value="41">41</option>
                  
                    <option value="42">42</option>
                  
                    <option value="43">43</option>
                  
                    <option value="44">44</option>
                  
                    <option value="45">45</option>
                  
                    <option value="46">46</option>
                  
                    <option value="47">47</option>
                  
                    <option value="48">48</option>
                  
                    <option value="49">49</option>
                  
                    <option value="50">50</option>
                  
                    <option value="51">51</option>
                  
                    <option value="52">52</option>
                  
                    <option value="53">53</option>
                  
                    <option value="54">54</option>
                  
                    <option value="55">55</option>
                  
                    <option value="56">56</option>
                  
                    <option value="57">57</option>
                  
                    <option value="58">58</option>
                  
                    <option value="59">59</option>
                  
                  </select>
                  <span style="color:#aeaeae;; margin:0 5px">分</span></td>
                <td width="55%" rowspan="5" align="center" valign="top">
                <table id="tableH88" width="100%" border="0" cellspacing="0" cellpadding="0" class="sjtx">
                <colgroup><col width="15%" /><col width="15%" /><col width="45%" /><col width="25%" /></colgroup>
                  <tr class="sjtx_hander">
                    <td>时间</td>
                    <td>周期</td>
                    <td>内容</td>
                    <td>操作</td>
                  </tr>
                </table></td>  
              </tr>
              <tr>
                <td height="25">提醒周期：
                  <select name="notice_interval" id="notice_interval" style="height:20px; width:118px;">
                    <option value="一天">一天</option>
                    <option value="一周">一周</option>
                    <option value="一月">一月</option>
                </select></td>
              </tr>
              <tr>
                <td height="30">提醒内容：</td>
              </tr>
              <tr>
                <td><textarea name="note" id="note" rows="3" style="padding:5px; width:280px;border: 1px solid #7f9db9 " maxlength="13"></textarea></td>
              </tr>
              <tr>
                <td valign="top" style="padding-top:15px;"><input type="button" value="添 加" onclick="addMedicationRemind()" class="button01" /></td>
              </tr>
            </table>
            </div>
          </li>
        </ul>          
      </li>
<!--测压时间提醒设置--> 
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">测压时间提醒设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb89Hexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb89Hexpand','li_89H');" /></a></div>
          </li>
          <li id="li_89H" class="list_main" >
          		<div id="bt01"><input type="button" value="提 交" class="button01" onclick="generateH89()" /></div>
            <div id="bt02">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="45%" height="25">开始时间：
                  <select name="start_time" id="start_time" style="height:20px; width:180px;margin:3px 0;">
                  
                    <option value="0">0</option>
                  
                    <option value="1">1</option>
                  
                    <option value="2">2</option>
                  
                    <option value="3">3</option>
                  
                    <option value="4">4</option>
                  
                    <option value="5">5</option>
                  
                    <option value="6">6</option>
                  
                    <option value="7">7</option>
                  
                    <option value="8">8</option>
                  
                    <option value="9">9</option>
                  
                    <option value="10">10</option>
                  
                    <option value="11">11</option>
                  
                    <option value="12">12</option>
                  
                    <option value="13">13</option>
                  
                    <option value="14">14</option>
                  
                    <option value="15">15</option>
                  
                    <option value="16">16</option>
                  
                    <option value="17">17</option>
                  
                    <option value="18">18</option>
                  
                    <option value="19">19</option>
                  
                    <option value="20">20</option>
                  
                    <option value="21">21</option>
                  
                    <option value="22">22</option>
                  
                    <option value="23">23</option>
                  
                  </select>
                  <span style="color:#aeaeae;margin:0 5px">时</span></td>
                <td width="55%" rowspan="4" align="center" valign="top">
                <table id="tableH89" width="100%" border="0" cellspacing="0" cellpadding="0" class="sjtx">
                <colgroup><col width="20%" /><col width="20%" /><col width="25%" /><col width="35%" /></colgroup>
                  <tr class="sjtx_hander">
                    <td>开始时间</td>
                    <td>结束时间</td>
                    <td>提醒周期</td>
                    <td>操作</td>
                  </tr>
                </table></td>  
              </tr>
              <tr>
                <td>结束时间：
                  <select name="end_time" id="end_time" style="height:20px; width:180px; margin:3px 0;">
                    
                    <option value="1">1</option>
                  
                    <option value="2">2</option>
                  
                    <option value="3">3</option>
                  
                    <option value="4">4</option>
                  
                    <option value="5">5</option>
                  
                    <option value="6">6</option>
                  
                    <option value="7">7</option>
                  
                    <option value="8">8</option>
                  
                    <option value="9">9</option>
                  
                    <option value="10">10</option>
                  
                    <option value="11">11</option>
                  
                    <option value="12">12</option>
                  
                    <option value="13">13</option>
                  
                    <option value="14">14</option>
                  
                    <option value="15">15</option>
                  
                    <option value="16">16</option>
                  
                    <option value="17">17</option>
                  
                    <option value="18">18</option>
                  
                    <option value="19">19</option>
                  
                    <option value="20">20</option>
                  
                    <option value="21">21</option>
                  
                    <option value="22">22</option>
                  
                    <option value="23">23</option>
                  
		    		<option value="0">0</option>
                  </select>
                  <span style="color:#aeaeae; margin:0 5px">时</span></td>
              </tr>
              <tr>
                <td height="25">提醒周期：
                	<input name="notice_intervals" id="notice_intervals" type="text" class="sr01" style="width: 180px;"  maxlength="3"/>分钟
                </td>
              </tr>
              <tr>
                <td valign="top" style="padding-top:15px;"><input type="button" value="添 加" onclick="addMpRemind()" class="button01" /></td>
              </tr>
            </table>
            </div>
          </li>
        </ul>          
      </li>
      <!--时区设置       
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">时区设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb8AHexpand" src="/gzjky/images/button/zk.png" style="height:40px;" onclick="expand('lb8AHexpand','li_8AH');" /></a></div>
          </li>
          <li id="li_8AH" class="list_main" style="display:none">
            <div id="bt01"><input type="button" value="提 交" class="button01" onclick="generateH8A();"/></div>
            <div id="bt02">
            时区：<select name="time_zone_ew" id="time_zone_ew" style="height:20px; width:118px;">
                    <option value="1">东区</option>
                    <option value="0">西区</option>
                  </select>
                  <select name="time_zone_offset" id="time_zone_offset" style="height:20px; width:118px; margin-left:5px;">
                    <option selected="selected" value="0">0</option>
					<option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                  </select>
            </div>
          </li>
        </ul>   
      </li>
      --> 
<!--取消指令设置-->      
      <li>
        <ul>
          <li class="list_bg">
           <div class="list_bt">取消指令设置</div>
           <div class="list_button"><a href="javascript:void(0)"><img id="lb8EHexpand" src="/gzjky/images/button/sq.png" style="height:40px;" onclick="expand('lb8EHexpand','li_8EH');" /></a></div>
          </li>
          <li id="li_8EH" class="list_main" >
            <div id="bt01"><input type="button" onclick="generatedirectivecancel();" value="提 交" class="button01" /></div>
            <div id="bt02" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0" >
              <tr>
                <td width="25%"><input name="setting_flag_simcard" id="setting_flag_simcard" type="checkbox" value="" class="fx"/>绑定号码</td>
                <td width="25%"><input name="setting_flag_heartrate_alert" id="setting_flag_heartrate_alert" type="checkbox" value="" class="fx"/>心率报警</td>
                <td width="25%" height="25"><input name="setting_flag_blood_pressure_alert" id="setting_flag_blood_pressure_alert" type="checkbox" value="" class="fx"/>血压报警</td>
                <td width="25%"><!-- <input name="setting_flag_safe_island" id="setting_flag_safe_island" type="checkbox" value="" class="fx"/>电子围栏 --></td>
              </tr>
              <tr>
                <td><input name="setting_flag_take_medicine_notice" id="setting_flag_take_medicine_notice" type="checkbox" value="" class="fx"/>用药提醒</td>
                <td><input name="setting_flag_test_blood_pressure_notice" id="setting_flag_test_blood_pressure_notice" type="checkbox" value="" class="fx"/>测压提醒</td>
                <td><input name="setting_flag_send_data_interval" id="setting_flag_send_data_interval" type="checkbox" value="" class="fx"/>定时上传</td>
                <td height="25">&nbsp;</td>
              </tr>
            </table>
            </div>
          </li>
        </ul>   
      </li>
    </ul>
  </div>
  </form>
</body>
</html>