<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>贵州健康云服务中心</title>
<meta http-equiv="keywords"
	content="个人健康服务中心,物联网,可穿戴设备,动态血压,心电,十二导联,电子围栏,用药提醒,测压提醒" />
<meta http-equiv="description" content="个人健康服务中心" />
<meta
	content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'
	name='viewport'>
<%@ include file="./shared/importCss.jsp"%>
<%@ include file="./shared/importJs.jsp"%>
<link rel="Shortcut Icon" href="/995120.ico" />
<link rel="stylesheet" href="<c:url value='/css/index_common.css'/>"	type="text/css" />
<link rel="stylesheet" href="<c:url value='/css/popup.css'/>"	type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>


<script type="text/JavaScript">
	menuId = "#home";
	function reinitIframe() {
		var iframe = document.getElementById("mainFrame");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.min(bHeight, dHeight);
			iframe.height = height;
		} catch (ex) {
		    //alert(ex);
		}
	}
        
	window.setInterval("reinitIframe();", 500);
	//初始化方法
	function Query() {
		memberBindDevice();
		hos_docInfo();
	}
	//查询用户绑定设备
	function memberBindDevice() {
		var para = "";	
		$.ajax({
			url:"/gzjky/home/getEquipment.do",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				alert("发生异常","请注意");
			},
			success:function(response) {

				var memberDeviceBindList=response;	
				
				$("#device").empty();
				
				$("#device").append("<ul id='deviceListUL'></ul>");
				
				$("#deviceListUL").empty();
				if(memberDeviceBindList != null && memberDeviceBindList.length > 0) {
					var str = "";
					for ( var i = 0; i < memberDeviceBindList.length; i++) {
						var text = '';
						var product = memberDeviceBindList[i].equipmentNum;
						var description = memberDeviceBindList[i].deviceVersionName;
						//text = product + "(" + description.replace(product, '') + ")";
						text = description;
						str += "<li class=''>" + text + "</li>";
					}
					
					$("#deviceListUL").html(str);
					
				} else {
				    $("#deviceListUL").html("<li class=''>暂无</li>");
				}
		        $("#deviceListUL").append("<li class='wtaGreen'><a href='/gzjky/menuControlAction/memberBindDevice.do' target='mainFrame' title='增加设备'>增加设备</a></li>"); 
				
			}
		});
	}
	
	//查询用户绑定的医院医生
	function hos_docInfo(){
		var para= "";	
		$.ajax({
			url:"/gzjky/home/getHospitalAndDoctor.do",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
				return false;
			},
			success:function(response) {

				var hosDocInfoList = response;
				
				$("#hos_doc").empty();
				$("#hos_doc").append("<ul id='hosDocListUL'></ul>");
				
				$("#hosDocListUL").empty();
				if(hosDocInfoList != null && hosDocInfoList.length > 0) {
					var str = "";
					for ( var i = 0; i < hosDocInfoList.length; i++) {
						var text = '';
						var bind_type=hosDocInfoList[i].bind_type;
						
						//text = hosDocInfoList[i].hName + "(" + hosDocInfoList[i].dName + ")";
						str += "<li class=''>" + "医院："+ hosDocInfoList[i].hName + "</li>";
						str += "<li class=''>" + "医生："+  hosDocInfoList[i].dName + "</li>";
					}
					$("#hosDocListUL").html(str);
					
				} else {
				    $("#hosDocListUL").html("<li class=''>暂无</li>");
				}
				
		        $("#hosDocListUL").append("<li class='wtaGreen'></li>");
						
			}
		});
	}
	
	//查询用户套餐
	function packageBaseinfo(){
		var para= "";	
		$.ajax({
			url:"/welcome/queryPackageBaseinfo.action",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常2","请注意");
				return false;
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var packageBaseinfoList = modelMap.packageBaseinfoList;
				
				$("#package").empty();
				$("#package").html("我的套餐：");
				$("#package").append("<ul id='packageListUL'></ul>");
				
				$("#packageListUL").empty();
				if(packageBaseinfoList != null && packageBaseinfoList.length > 0) {
					var str = "";
					for ( var i = 0; i < packageBaseinfoList.length; i++) {
					
						var text = '';
						var name = packageBaseinfoList[i].name;
						//var online = packageBaseinfoList[i].online;
						var offline = packageBaseinfoList[i].offline;
						if(getdate() < offline) {
							text = name +"(剩余："+ GetDateDiff(getdate(),offline)+"天)";
						} else {
							text = name +"(剩余：0天)";
						}
						str += "<li class='wtBlack'>" + text + "</li>";
					}
					$("#packageListUL").html(str);
					
				} else {
				    $("#packageListUL").html("<li class='wtBlack'>暂无</li>");
				}
				
		        $("#packageListUL").append("<li class='wtaGreen'><a onclick='goToAccountMeal(this)' target='mainFrame'  title='增加套餐'>增加套餐</a></li>");
					
			}
		});
	}
	
	
	function queryMemberBalance() {

	  var requestUrl = "/recharge/queryMemberBalance.action";
	  xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
			data: null,
			dataType:"json",
			type:"POST",
			complete:function(){
			    
			},
			error:function(){
				$.alert('无权限');
			},success:function(response){
			    var modelMap = response.modelMap;
			    var memberBaseInfo = modelMap.memberBaseInfo;
			    if(memberBaseInfo != null) {
			        var balance = memberBaseInfo.balance;
			        balance = formatCurrency(balance);
			        document.getElementById("memberBalanceArea").innerHTML = balance;
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
		return y + "-" + m + "-" + d;
	}

	//计算日期间隔天数
	function GetDateDiff(startDate, endDate) {
		var startTime = new Date(Date.parse(startDate.replace(/-/g, "/")))
				.getTime();
		var endTime = new Date(Date.parse(endDate.replace(/-/g, "/")))
				.getTime();
		var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
		return dates;
	}
	//查询余额
	function queryBalance() {
		  var requestUrl = "/h/queryBalance.action";
		  var login_id = 'test1';
		  var mobile = '15921041319';
		  var para="mobile="+mobile+"&login_id="+login_id;
		  
		  xmlHttp = $.ajax({
				url: requestUrl,
				async:true,
				data: para,
				dataType:"json",
				type:"POST",
				complete:function(){
				    
				},
				error:function(){
					$.alert('无权限');
				},success:function(response){
				  
				    if(response != null) {
				        var balance = response;
				        
				        document.getElementById("memberBalanceArea").innerHTML = balance;
				    }
				}
			});
		}
	
	
	var pushMsgDetailDivDisplayFlag = 0;
	function showPushMsgDetailDiv() {
	    if(pushMsgDetailDivDisplayFlag == 0) {
	        //$("#pushMsgDetailDiv").show(500);
	        $("#pushMsgDetailDiv").slideToggle(500, null);
	        showScreenProtectDiv(2);
	        pushMsgDetailDivDisplayFlag = 1;
	    } else {
	        $("#pushMsgDetailDiv").slideToggle(200, null);
	        hideScreenProtectDiv(2);
	        pushMsgDetailDivDisplayFlag = 0;
	    }
	    
	}
	
	
	function goToEquipment(obj){
		activeHelathMenu(4);
		obj.href="../jsp/health/equipment/member_bind_device.jsp" ;
	}
	function goToHealthRecord(obj){
		activeHelathMenu(3);
		obj.href = "../jsp/health/healthrecord/healthrecords.jsp" ;
	}
	function goToAccount(obj){
		activeHelathMenu(5);
		obj.href = "../jsp/health/account/account.jsp";
	}
	function goToAccountMeal(obj){
		activeHelathMenu(5);
		obj.href = "/jsp/health/account/meal.jsp" ;
	}
	function goToRecharge(obj){
		activeHelathMenu(5);
		obj.href="../jsp/health/account/recharge.jsp";
	}
	
	function switchFamilyUser(){
		$.confirm("确定要切换用户？",function(){
			window.location.href="/h/switchUser.helowin";
		},function(){
		});
		return true;
	}

</script>


</head>

<body class="skin-blue" onload="Query();">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="./shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
		<!-- Left side column. contains the logo and sidebar -->
		<%@ include file="./shared/sidebarMenu.jsp"%>

		<!-- Right side column. Contains the navbar and content of the page -->
		<aside class="right-side">
			<!-- Content Header (Page header) -->
			<section class="content-header">
				<h1>
					 <small>最近登录 : ${sessionScope.online}</small>
				</h1>
				<ol class="breadcrumb">
					<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
					<li class="active">个人信息</li>
				</ol>
			</section>
			<!-- Main content -->

			<section class="content invoice">

				<!-- START ALERTS AND CALLOUTS -->
				<h2 class="page-header">个人相关信息</h2>

				<div class="row">


					<div class="col-md-6">
						<div class="box box-danger">
							<div class="box-header">
								<i class="fa fa-warning"></i>
								<h3 class="box-title">家庭成员和医院医生</h3>
							</div>
							<!-- /.box-header -->
							<div class="box-body">
								<div class="callout callout-danger">
									<h4>我的家庭成员：</h4>
									<ul>
										<li class="tGray" id="family"><c:forEach
												items="${sessionScope.PatientList}" var="pa">

												<ul>
													<c:choose>
														<c:when test="${sessionScope.PatientID == pa.pid}">
															<c:out value="${pa.pname}" />

														</c:when>
														<c:otherwise>
															<a href="javascript:void(0)"
																onclick="patientChange(this)" id="${pa.pid}"> <c:out
																	value="${pa.pname}" /></a>
														</c:otherwise>
													</c:choose>
												</ul>
											</c:forEach></li>
										<li class='wtaGreen'></li>
									</ul>

								</div>
								<div class="callout callout-info">
									<h4>我的医院医生：</h4>
									<ul>
										<li class="tGray" id="hos_doc">：</li>
									</ul>

								</div>


							</div>
							<!-- /.box-body -->
						</div>
						<!-- /.box -->
					</div>
					<!-- /.col -->
					<div class="col-md-6">
						<div class="box box-info">
							<div class="box-header">
								<i class="fa fa-bullhorn"></i>
								<h3 class="box-title">我的设备和套餐</h3>
							</div>
							<!-- /.box-header -->
							<div class="box-body">

								<div class="callout callout-warning">
									<h4>我的设备：</h4>
									<ul>
										<li class="tGray" id="device">我的设备：
									</ul>
								</div>
									<div class="callout callout-success">
									<h4>我的套餐</h4>
									<ul>
										<li class='wtBlack'>暂无</li>
										<li class='wtaGreen'><a onclick='goToAccountMeal(this)' target='mainFrame'  title='增加套餐'>增加套餐</a></li>
									</ul>

								</div>
							</div>
							<!-- /.box-body -->
						</div>
						<!-- /.box -->
					</div>
					<!-- /.col -->
				</div>
				<!-- /.row -->
			</section>
			<!-- /.content -->
		</aside>
		<!-- /.right-side -->
	</div>
	<!-- ./wrapper -->
</html>


