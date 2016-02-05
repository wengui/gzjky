<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>电子围栏</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/location.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript" ></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript" ></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript" ></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript" ></script>
<!--百度相关的js文件-->
<script type="text/javascript" src="http://api.map.baidu.com/api?key=057b7037c8fb7eeaa6984870a1a63603&v=1.3&services=true"></script>
<script type="text/javascript" src="http://developer.baidu.com/map/jsdemo/demo/convertor.js"></script><!--google或GPS转百度坐标的js-->
<!--lbs模块的js文件-->
<script type="text/javascript" src="<c:url value='/js/lbs/query_location.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/lbs/pageFrame.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/lbs/safe_island1.js'/>"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script type="text/JavaScript"> 

	menuId = "#electronic";
	var para = "";
 	var xmlHttp;
 	var response;
 	var sysDate;
 	
 	var safeIsland;			//当前安全岛信息
   	var memberLocation;		//当前定位信息
   	var startQueryFlag;		//初始查询标志位
   	
   	var para2 = "";
 	var xmlHttp2;
 	var response2;
 	
 	var startDateTime;
 	var endDateTime;
 	var onePageSize = 5;	//每页显示条数
 	var memberLocationList;	  //历史定位给信息列表
 	
 	var close_show_location_history_flag = 0;	//历史定位信息弹出层关闭标志
 

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
	//判断是否有301设备标识0为无
  	var flagIsExist301=0;
	
	//对当前页面赋值
	function selDevOK() {
		//var dev_sid = $("#device_sid_global option:selected").text();
		//var dev_i = $("#device_sid_global option:selected").val();
		if(flagIsExist301!=0){
			var dev_sid = document.getElementById("device_sid_global").options[0].text;
			var dev_i = document.getElementById("device_sid_global").options[0].value;
			var dev_ver = recordList[dev_i].device_version;
			
			$("#dev_sid").text(dev_sid);
			var deviceContent=parameter[0].desc;
		   	for(var j=0;j<parameter.length;j++){
		   		if(dev_ver==parameter[j].id){
		   			deviceContent=parameter[j].desc;
		   		};
		   	}
		   
		   	para = "device_unit_id="+recordList[dev_i].device_unit_id+"&device_cluster_id="+recordList[dev_i].device_cluster_id+"&device_unit_type="+recordList[dev_i].device_unit_type;
			
			clearFaceTable();
		    delUsersLocationHistoryMarker();//清除地图上的标记
		    $("#showPageArea").html("");
		    //$("#show_location_button_close").hide(200);
			$("#show_location_history_div").hide(200);
			
			queryCurrentInfo();//查询当前安全岛信息和当前位置信息
			//初始化历史信息框查询
			queryStart();
		};
	}
	//初始化页面数据
	function initQuery() {
		showScreenProtectDiv(1);
	   showLoading();
		//给查询条件赋值当天日期
		$("#startDate").val(getdate()+" 00:00:00");
		$("#endDate").val(getdate()+" 23:59:59");
		//queryDeviceInfo();
		
		load();	//导入地图数据
		startQueryFlag = 0;
		hideScreenProtectDiv(1);
		hideLoading();
	}
	
	//查询为该用户绑定的设备
	function queryDeviceInfo() {
	   para= "member_cluster_id="+1+"&member_unit_id="+24913+
        		  "&member_unit_type="+2+"&version=301";	
		xmlHttp = $.ajax({
			url:"/welcome/queryMemberDeviceBind.action",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert('操作异常');
			},
			success:function(response) {
				var modelMap = response.modelMap;
				recordList=modelMap.memberDeviceBindList;
				if(recordList!=null && recordList!=""){
					
					for (var i = 0; i < recordList.length; i++){
						
						if(recordList[i].version=="301"){
							if(flagIsExist301==0){
							$("#sel__dev_div").append("产品类型及编号：<select style='width:200px;' id='device_sid_global' ></select>");
							}
							add_select_option(recordList[i],i);//显示查询的数据
							flagIsExist301++;
						}	
					}
					if(flagIsExist301==0){
					$("#sel__dev_div").append("<span style='color:red'>未绑定腕式监测呼救定位器，无法操作此项！</span>");
					}
					selDevOK();
				}else{
					$("#sel__dev_div").append("<span style='color:red'>未绑定腕式监测呼救定位器，无法操作此项！</span>");
					
				}
			}
		});
	}
	
	//添加产品类型选项
	function add_select_option(deviceInfo,i) {
		var deviceType='';
		for(var j=0;j<parameter.length;j++){
		   		if(deviceInfo.version==parameter[j].id){
		   			deviceType=parameter[j].desc;
		   		};
		   	}
        var device_sid = recordList[i].device_sid;
        var device_description = recordList[i].product + "(" + device_sid + ")";
        $("#device_sid_global").append("<option value='"+i+"'>" + device_description + "</option>");
        
		
	}
	
 	
	//查询当前安全岛信息和当前位置信息
	function queryCurrentInfo() {
		xmlHttp = $.ajax({
			url:"/lbs/queryMemberLocation.action",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("网络异常");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				safeIsland = modelMap.safeIsland;
				//memberLocation = modelMap.memberLocation;
				showData(safeIsland);		//显示查询的数据
			}
		});
	
	}
	
 	//显示查询的数据
 	function showData(safeIsland) {
	    clearSafeIslandCurrentTable();//清空面板上关于安全岛的相关数据
	    
	    var address;
	    var radius;
	    var lng;
	    var lat;
	    //var id;
	    
	    //var location_address;
	    //var datetime;
	    
	    if(safeIsland!=null) {
	    	address = safeIsland.address;
	    	radius = safeIsland.radius;
	    	lng = safeIsland.longitude;
			lat = safeIsland.latitude;
			
			if(startQueryFlag==0)
				safeCircle(lng,lat,radius,address);			//在地图上画圆
			
			address = myReplace(address);
			$("#cur_center_addr").html("<a href='javascript:void(0)'style='text-decoration: none; color: #5A5A5A;' onclick=safeCircle('"+lng+"','"+lat+"',"+radius+",'"+address+"')>"+address+"</a>");
   			$("#cur_center_radius").text(radius);
	    } else {
	    };
	    
	   /* if(memberLocation!=null) {
	    	location_address = memberLocation.address;
	    	datetime = memberLocation.pos_time.substring(0,19);
	    	lng = memberLocation.longitude;
			lat = memberLocation.latitude;
			id = memberLocation.id;
			var member_unit_id = memberLocation.member_unit_id;
			var member_cluster_id = memberLocation.member_cluster_id;
			var member_unit_type = memberLocation.member_unit_type;
			var cellular_id = memberLocation.cellular_id;
			
			百度地图有自己的矫正方式,在地图定位的时候调用百度api中的方法
			var gps_offset_id = memberLocation.gps_offset_id;
			var offsetlng = memberLocation.offsetlng;
			var offsetlat = memberLocation.offsetlat;
	    	if(gps_offset_id!=null &&  gps_offset_id!=0) {
	    	 	lng = lng*1 + offsetlng*1;
	    	 	lat = lat*1 + offsetlat*1;
	    	}
	    	
	    	location_address = myReplace(location_address);
	    	datetime = myReplace(datetime);
	    	if(location_address==null||location_address=="") {
	    		alert(lng+"-"+lat);
	    		gecoderAddressLA(2,-1,id,member_cluster_id,member_unit_id,member_unit_type,lng,lat,cellular_id,datetime);
	    	}else{
		    var addClick = "";
		    if(lng*1==0 || lat*1==0 || location_address==null||location_address=="" || location_address=="暂时无法定位"){
				addClick = "暂时无法定位";
				fitSafeBounds();
		    }else{
				addClick = "<a href='javascript:void(0);' style='text-decoration: none; color: #5A5A5A;' onclick=mindUsersLocationHistoryMarker('"+lng+"','"+lat+"','"+location_address+"','"+datetime+"')>"+location_address+"</a>";
				if(startQueryFlag==0)
					mindUsersLocationHistoryMarker(lng,lat,location_address,datetime);
		    }
		  	$("#cur_location_Addr").html(addClick);
	   		$("#cur_location_time").html(datetime);
		};*/
 	}

	//清空当前安全岛信息
   function clearSafeIslandCurrentTable(){
   		$("#cur_center_addr").text("");
   		$("#cur_center_radius").text("");
   		$("#cur_location_Addr").text("");
   		$("#cur_location_time").text("");
    }
    
    
    function adddates() {
    	addDate(sysDate,"start_year","start_month","start_day");
    	addDate(sysDate,"end_year","end_month","end_day");
    }
/*********************设置安全岛****************************************************************************/    
	
	//增加用户安全岛信息
	function addSafeIsland() {
		para2 = "";
		$("#alert_message_add").text("");//清空消息框
		
		var address = $("#safe_island_address").val();
		var radius = $("#safe_island_radius").val();
	 	
	 	if(address==null || address==""){
	 		$("#alert_message_add").text("请输入安全岛中心");
	 		return;
	 	}else{
	 		if(gecoderAddressCheck(address)==false){
				$("#alert_message_add").text("请输入合理的安全岛中心!");
				document.getElementById("safe_island_address").focus();
				return false;
			};
	 	}
	 	
	 	if(radius==null || radius==""){
	 		$("#alert_message_add").text("请输入安全岛半径");
	 		return;
	 	}else{
	 		if(radiuscheck(radius)==false){
				$("#alert_message_add").text("请输入10米以上的安全岛半径!");
				document.getElementById("safe_island_radius").focus();
				return false;
			};
	 	}
	 	radius = parseInt(radius.replace(/\b(0+)/gi,""));  
		gecoder(address,radius);	//进行解析并且画圆与标注信息
		
	}

	//设置客户的圆心坐标（新增电子围栏）
	function addCenter(param) {
		xmlHttp2 = $.ajax({
			url:"/lbs/setSafeIsland.action",
			async:true,
			data:param,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("网络异常");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var state=modelMap.state;
				if(state =="0"){
				$.alert("设置成功");
				startQueryFlag = 0;
				closeDiv();
				queryCurrentInfo();//查询当前安全岛信息和当前位置信息
				}
			}
		});
		
	}

	//清除上次遗留信息
	function clearLastMessage() {
		$("#safe_island_address").val("");
		$("#safe_island_radius").val("");
		$("#alert_message_add").text("");
	}

/*********************删除安全岛*********************************************************************/
//删除安全岛
function safe_island_del() {
	$.confirm("你确定要删除安全岛吗?",function(){
		para2 = para;
		xmlHttp2 = $.ajax({
				url:"/lbs/delSafeIsland.action",
				async:true,
				data:para2,
				dataType:"json",
				type:"POST",
				error:function(){
					$.alert("网络异常");
				},
				success:function() {
					$.alert("操作成功");
					startQueryFlag = 0;
					delSafeIslandMarker();
					queryCurrentInfo();//查询当前安全岛信息和当前位置信息
				}
			});
	},function(){});
}

/*********************历史定位信息*******************************************************************/    
    
 	
	//重新组织参数查询
	function queryStart() {
		startDateTime = $("#startDate").val();
		endDateTime = $("#endDate").val();
		query();
	}
	
    //查询历史定位信息
    function query() {
		showScreenProtectDiv(1);
		var pointerStart = currentPageNum * onePageSize;
		
		para2 = "startDate="+startDateTime+"&endDate="+endDateTime+
				"&pointerStart="+pointerStart+"&pageSize="+onePageSize;
		//alert(para2);
		xmlHttp2 = $.ajax({
			url:"/lbs/queryLocationHistory.action",
			async:true,
			data:para2,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("网络异常");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				recordTotal = modelMap.recordTotal;
				memberLocationList = modelMap.memberLocationList;
				showLocationHistoryData(recordTotal,memberLocationList);		//显示查询的数据
			}
		});
    }
    
   

 	//显示查询的数据
 	function showLocationHistoryData(recordTotal,memberLocationList) {
	    clearFaceTable();
	   // delUsersLocationHistoryMarker();//清除地图上的标记
		if(recordTotal==0) {
			$("#showPageArea").html('<span style="font-size:12px;color: #1A70C7;">　当前历史定位信息不存在</span>');
		}else{
			var i = 0;
		    hostory_for_method(i);
			valiatePageInfo();
	 		thingsOfAfterDraw();
		}
		hideScreenProtectDiv(1);
 	}
 	
 	function hostory_for_method(i) {
		
		if(i<onePageSize ) {
			if((currentPageNum * onePageSize + i) >= recordTotal){
				return;
			}
			 var member_unit_id = memberLocationList[i].member_unit_id;
			 var member_cluster_id = memberLocationList[i].member_cluster_id;
			 var member_unit_type = memberLocationList[i].member_unit_type;
		     var id = memberLocationList[i].id;
			 var longitude = memberLocationList[i].longitude;
			 var latitude = memberLocationList[i].latitude;
			 var cellular_id = memberLocationList[i].cellular_id;
			 var address = memberLocationList[i].address;
			 var datetime = memberLocationList[i].pos_time.substring(0,19);
			 var pos_type = memberLocationList[i].pos_type;
			 
			 address = myReplace(address);
			 datetime = myReplace(datetime);
			 	 findAddress(1,i, id, longitude,latitude,cellular_id,address,datetime,member_unit_id,member_cluster_id,member_unit_type,pos_type);
	 	 		 i++;
			 	 hostory_for_method(i);
		}else {
		};
	}
 	 
 	 function findAddress(type,i, id, lng,lat,cellular_id,address,datetime,member_unit_id,member_cluster_id,member_unit_type,pos_type) {
		addrowtotable(i, id, lng,lat,cellular_id,address,datetime,member_unit_id,member_cluster_id,member_unit_type,pos_type);
    	if(lng*1!=0 && lat*1!=0 && address!=null&&address!=""&&address!="暂时无法定位"&&i==0){
			mindUsersLocationHistoryMarker(lng,lat,address,datetime);
    	};
	 }

 	
 	//画历史定位信息表格
 	function addrowtotable(i, id, longitude,latitude,cellular_id,address,datetime,member_unit_id,member_cluster_id,member_unit_type,pos_type) {
    	try{
		    var table = document.getElementById("faceTable");
		    var rowcount=table.rows.length;
			var tr=table.insertRow(rowcount);
			tr.name = i;
			
			datetime = datetime.substring(0,19);
			
			var addClick = "";
		 	if(longitude*1==0 || latitude*1==0 || address==null ||address==""||address=="暂时无法定位"){
				addClick = address;
		    }else{
		    addClick = "<a href='javascript:void(0)' style='text-decoration: none; color: #CCC;' onclick=mindUsersLocationHistoryMarker('"+longitude+"','"+latitude+"','"+address+"','"+datetime+"')>"+address+"</a>";
	    	}
	    	td=tr.insertCell(0);
	    	if(pos_type=="1"){
	    		td.innerHTML = '<img title="快速定位" src="/images/icon/quick.png"></img>';
	    	}else if(pos_type=="0"){
	    		td.innerHTML = '<img title="精确定位" src="/images/icon/accurate.png"></img>';
	    	}
	    	
	    	
	    	
			td=tr.insertCell(1);
			td.align="left";
		    td.innerHTML =  '<span style="font-size:12px;color:#fff">时间：'+datetime+'</span>'+
		    				'<br /><span style="color:#ccc">地址：'+addClick+'</span><br/>';
		    				
		    				
	   } catch(e){	   
	     	$.alert(e.toString());
	   };
    }
    
	 
    //清空表格
   function clearFaceTable(){
   		var table=document.getElementById("faceTable");
		while (table.rows[0]){
			table.deleteRow(0);
		};
    }
    
    
   //关闭历史定位信息层
	function closeShowLocationHistoryDiv() {
		//$("#show_location_button_close").show(200);
		if(close_show_location_history_flag == 0) {
			$('#show_location_history_div').slideUp("slow");
			//$('#show_location_history_div').css("z-index",-1);
			close_show_location_history_flag = 1;
		} else if(close_show_location_history_flag == 1) {
			$('#show_location_history_div').slideDown("slow");
			//$('#show_location_history_div').css("z-index",3);
			close_show_location_history_flag = 0;
		} 
	}
	 
    //打开历史定位信息层
	function openShowLocationHistoryDiv() {
		$("#show_location_button_close").show(200);
		$("#show_location_history_div").show(200);
		close_show_location_history_flag = 0;
	}

   
 /************************************地图服务********************************************************/  

	//将对应的符号换成css可辨别的字符 
   function myReplace(myString){
	    myString=myString.replace(/\ /g,"　"); 
	    return myString;                             //'返回函数值
	}
	

 	//打开设置安全岛
	function showIsland() {
	clearLastMessage();		//清除上次遗留信息
		var address = $("#cur_center_addr").text();
		var radius = $("#cur_center_radius").text();
		$("#safe_island_address").val(address);
		$("#safe_island_radius").val(radius);
		$('#ShowLogin').draggable({
			disabled : true
		});
		$("#ShowLogin").modal('show');
		//showScreenProtectDiv(1);
	}
	//关闭设置安全岛
	function closeDiv() {
		$("#ShowLogin").modal('hide');
		//hideScreenProtectDiv(1);
	}
	   //半径匹配
	function radiuscheck(s){
   		var str=s;
   		
   		if(!isNaN(s)){
   		if (s>10)
			return true;
		else
			return false;
   		}else{
   			return false;
   		}
		
   }
   	//安全岛地址匹配
	function gecoderAddressCheck(s){
   		var str=s;
		var reg=/[\%\&]/g;
		
		if (reg.test(str)==true)
			return false;
		else
			return true;
   }
   //获取当前日期
	function getdate() {
		var now = new Date();
		y = now.getFullYear();
		m = now.getMonth() + 1;
		d = now.getDate();
		m = m < 10 ? "0" + m : m;
		d = d < 10 ? "0" + d : d;
		return y + "-" + m + "-" + d;
	}
	// 发送远程定位指令 
	function position(){
		var dev_sid = $("#device_sid_global option:selected").text();
		var dev_i = $("#device_sid_global option:selected").val();
		if(dev_sid!=""){
			var para = "unit_id="+recordList[dev_i].device_unit_id+"&cluster_id="+recordList[dev_i].device_cluster_id+"&unit_type="
					+recordList[dev_i].device_unit_type;
			xmlHttp = $.ajax({
				url:"/deviceBaseInfo/sendPositionLbs.action",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				error:function(){
					xmlHttp.responseText;
					$.alert("执行过程中，出现错误，未发送成功！");
				},success:function(response) {
					var modelMap = response.modelMap;
					var message= modelMap.message;
					$.alert(message);
				}
			});
		}else{
			$.alert("抱歉您未绑定腕式监测呼救定位器无法远程定位");
		}
	}
	
</script>
</head>
<body onload="initQuery();" class="skin-blue">

	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	         <!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
           <section class="content-header">
              <h1>电子围栏
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li>终端定位</li>
                  <li class="active">电子围栏</li>
              </ol>
          </section>

          <!-- Main content -->
          <section class="">
			 <div>
		        <div class="row">
                 <div class="col-md-6">
	                 <div class="box box-primary">
	                    <div class="box-header">
	                        <h3 class="box-title">终端定位：</h3>
	                        <button class="btn btn-success " style="float:right;margin-top: 10px;" onclick="position();"><i class="fa fa-fw fa-location-arrow"></i>重新定位</button>
	                    </div>
	                    <div class="box-body">
	                        <!-- Date range -->
	                        <div class="form-group">
	                            <label>产品类型及编号选择:</label>
	                            <div class="input-group" style="margin-top: 6px;padding-bottom:12px">
	                                <div class="input-group-addon">
	                                    <i class="fa  fa-bars"></i>
	                                </div>
	                                <select id="device_sid_global" style="width:320px"><option value="1">TE8000Y3(A10120144012757)</option></select>
	                                
	                            </div><!-- /.input group -->
	                        </div><!-- /.form group -->
	                   </div><!-- /.box-body -->
	                </div>
		        </div>
		        <div class="col-md-6">
		        	<div class="box box-success">
	                    <div class="box-header">
	                        <h3 class="box-title">安全岛设置：</h3>
	                        <div style="float:right;margin-top: 10px;">
	                        	<button class="btn btn-success " style="" onclick="showIsland();"><i class="fa fa-fw fa-gear"></i>设置</button>
	                        	<button class="btn btn-success " style="margin-left:20px" onclick="safe_island_del();"><i class='fa fa-fw fa-trash-o'></i>清除</button>
	                    	</div>
	                    </div>
	                    <div class="box-body">
	                        <div class="form-group">
	                        	<label>安全岛中心：</label>
	                            <label id="cur_center_addr" style="font-weight:normal">上海火车站</label>
	                        </div><!-- /.form group -->
	                        <div class="form-group">
	                        	<label>安全岛半径：</label>
	                            <label id="cur_center_radius" style="font-weight:normal">500</label><label style="font-weight:normal">米</label>
	                        </div><!-- /.form group -->
	                   </div><!-- /.box-body -->
	                </div>
		        </div>
		        </div>
		        <div class="row">
			        <div class="col-md-12">
			       	  <div id="map_canvas" style="width: 97%;height: 600px; position:absolute; top:0; left:15px; z-index: 2"></div>
			       	  <div class="btn_islandHistory" id="show_location_button_close"><img title="定位历史查询" onclick="closeShowLocationHistoryDiv();" src="<c:url value='/images/icon/history.png'/>" /></div>
			          <div class="bgblack" id="show_location_history_div" >
			              	<div class="form-group">
	                            <label style="color:#fff">开始时间:</label>
	                            <div class="input-group">
	                                <div class="input-group-addon">
	                                    <i class="fa  fa-calendar"></i>
	                                </div>
	                                <input type="text" name="startDate" id="startDate" style=" border:1px solid #ccc;height:28px;width:100%" onFocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/>
	                            </div><!-- /.input group -->
	                        </div><!-- /.form group -->
							<div class="form-group">
	                            <label style="color:#fff">结束时间:</label>
	                            <div class="input-group">
	                                <div class="input-group-addon">
	                                    <i class="fa  fa-calendar"></i>
	                                </div>
	                                <input type="text" name="endDate" id="endDate" style="border:1px solid #ccc;height:28px;width:100%" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/>
	                            </div><!-- /.input group -->
	                        </div><!-- /.form group -->	
	                        <div class="form-group">
	                        	 <button class="btn btn-success" style="width:100%" onclick="queryStart();"><i class="fa fa-fw fa-search"></i>查询</button>
			               	</div><!-- /.form group -->	
			              <div class="map_queryResults" id="scrollBar" style="overflow-x:hidden;">
			              <!--   <ul>
			                  <li class="search_rapidPositioning"><h1>2014-04-30 18:18:18</h1><p>地址：浙江省杭州市西湖区天堂软件园E幢13楼</p><p>定位类型：快速定位</p></li>
			                  <li class="search_rapidPositioning"><h1>2014-04-30 18:18:18</h1><p>地址：浙江省杭州市西湖区天堂软件园E幢13楼</p><p>定位类型：快速定位</p></li>
			                  <li class="search_accuratePositioning"><h1>2014-04-30 18:18:18</h1><p>地址：浙江省杭州市西湖区天堂软件园E幢13楼</p><p>定位类型：精确定位</p></li>
			                  <li class="search_rapidPositioning"><h1>2014-04-30 18:18:18</h1><p>地址：浙江省杭州市西湖区天堂软件园E幢13楼</p><p>定位类型：快速定位</p></li>
			                  <li class="search_rapidPositioning"><h1>2014-04-30 18:18:18</h1><p>地址：浙江省杭州市西湖区天堂软件园E幢13楼</p><p>定位类型：快速定位</p></li>
			                </ul>-->
								<div id="posmain">
									<table width="90%" border="0" align="center" id="faceTable">
									</table>
									<p align="left" id="showPageArea" style="color:#fff;width: 300px;" ></p>
								</div>
						  </div>
		              </div>
			        </div>
		        </div>
		      </div>
          </section><!-- /.content -->
     </aside><!-- /.right-side -->
</div><!-- ./wrapper -->       

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
       

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<style type="text/css">
.btn_map_edit{text-align: center;}
.btn_map_edit a{background:url(/images/button/btn_location.png) no-repeat; float:left; margin-right:20px; height:30px; width:80px; line-height:30px; text-align:center; color:#fff; text-decoration:none; display:block;}
</style>
</head>
<body>
<div class="modal fade" id="ShowLogin"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%">
  <div class="modal-dialog">	
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">安全岛中心设置</li>
      <li class="close_popupHeader"><a href="javascript:void(0);" onclick="closeDiv();">X</a></li>
    </ul>
  </div>
  <div  id="popWindow_main" class="popup_main">
      <table width="550" border="0" cellspacing="0" cellpadding="0" style="font-size:14px;" class="popWindow_tab">
          <colgroup><col width="40%" /><col width="60%" /></colgroup>
          <tr>
            <td ><span style="line-height:30px;font:20px '微软雅黑';"><span style="color:#c00">*</span>新安全岛中心地址：</span></td>
            <td>
            	<input type="text" name="name" id="safe_island_address" value="" maxlength="128" style="height:28px; padding-top:5px; border:#CCCCCC solid 1px; width:248px; padding-left:3px; font:20px '微软雅黑';"/>
            </td>
          </tr>
          <tr>
          <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="right_text"><span style="line-height:30px;font:20px '微软雅黑';"><span style="color:#c00">*</span>新安全岛半径：</span></td>
            <td class="left_text">
            	<input type="text" name="phone" id="safe_island_radius" value="" maxlength="8" style="height:28px; padding-top:5px; border:#CCCCCC solid 1px; width:248px; padding-left:3px; font:20px '微软雅黑';"/>
            </td>
          </tr>
          <tr>
            <td class="right_text"></td>
            <td class="left_text">
            	<span id="alert_message_add" style="font-size:12px;color:red;"></span>
            </td>
          </tr>
          <tr>
            <td></td>
            <td >
            	<br/>
            	<a href="javascript:void(0);" class="btn btn-info"  onclick="addSafeIsland();">确&nbsp;&nbsp;定</a>
            	&nbsp;&nbsp;
            	&nbsp;&nbsp;
            	<a href="javascript:void(0);" class="btn btn-info"  onclick="clearLastMessage();">重&nbsp;&nbsp;置</a>
            </td>
          </tr>
        </table>
  </div>
 </div>
</div>
</body>
</html>
      
</body>
<script type="text/javascript" src="<c:url value='/js/jquery/jquery.nicescroll.js'/>"></script>
<script type="text/javascript">
$("#scrollBar").niceScroll({  
	cursorcolor:"#aeaeae",  
	cursoropacitymax:1,  
	touchbehavior:false,  
	cursorwidth:"5px",  
	cursorborder:"0",  
	cursorborderradius:"5px" ,
	horizrailenabled:false
}); 
</script>
</html>
