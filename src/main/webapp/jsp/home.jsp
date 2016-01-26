<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>贵州健康云服务中心</title>
<meta http-equiv="keywords" content="个人健康服务中心,物联网,可穿戴设备,动态血压,心电,十二导联,电子围栏,用药提醒,测压提醒"/>
<meta http-equiv="description" content="个人健康服务中心"/>
<meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>

<link rel="Shortcut Icon"  href="/995120.ico"/>
<link rel="stylesheet" href="<c:url value='/css/popup.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/js/artDialog/skins/default.css'/>" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/balance.js'/>" type="text/javascript"></script>

<%@ include file="./shared/importCss.jsp"%>
<%@ include file="./shared/importJs.jsp"%>

<script type="text/JavaScript">

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
				$.alert("发生异常","请注意");
			},
			success:function(response) {

				var memberDeviceBindList=response;	
				
				$("#device").empty();
				$("#device").html("我的设备");
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
						str += "<li class='wtBlack'>" + text + "</li>";
					}
					
					$("#deviceListUL").html(str);
					
				} else {
				    $("#deviceListUL").html("<li class='wtBlack'>暂无</li>");
				}
		        $("#deviceListUL").append("<li class='wtaGreen'><a href='../jsp/health/equipment/member_bind_device.jsp' target='mainFrame' title='增加设备'>增加设备</a></li>"); 
				
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
				$("#hos_doc").html("我的医院医生：");
				$("#hos_doc").append("<ul id='hosDocListUL'></ul>");
				
				$("#hosDocListUL").empty();
				if(hosDocInfoList != null && hosDocInfoList.length > 0) {
					var str = "";
					for ( var i = 0; i < hosDocInfoList.length; i++) {
						var text = '';
						var bind_type=hosDocInfoList[i].bind_type;
						
						text = hosDocInfoList[i].hName + "(" + hosDocInfoList[i].dName + ")";

						str += "<li class='wtBlack'>" + text + "</li>";
					}
					$("#hosDocListUL").html(str);
					
				} else {
				    $("#hosDocListUL").html("<li class='wtBlack'>暂无</li>");
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
	
	//Patient切换 
	function patientChange(obj) {
		var family=obj.id;
		var para="family="+family;
		if(family!=="${sessionScope.Patient.pid}"){
			$.ajax({
				url:"/gzjky/home/patientChange.do",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				error:function(){
					$.alert("发生异常","请注意");
				},
				success:function(response) {

					if(response.result=="1"){	
						window.location.href="../jsp/home.jsp";
					}
					else{
						$.alert("发生异常","请注意");
					}
				}
			});
		}
		
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
                        Dashboard
                        <small>Control panel</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li class="active">Dashboard</li>
                    </ol>
                </section>

                <!-- Main content -->
                <section class="content">

                    <!-- Small boxes (Stat box) -->
                    <div class="row">
                        <div class="col-lg-3 col-xs-6">
                            <!-- small box -->
                            <div class="small-box bg-aqua">
                                <div class="inner">
                                    <h3>
                                        150
                                    </h3>
                                    <p>
                                        New Orders
                                    </p>
                                </div>
                                <div class="icon">
                                    <i class="ion ion-bag"></i>
                                </div>
                                <a href="#" class="small-box-footer">
                                    More info <i class="fa fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div><!-- ./col -->
                        <div class="col-lg-3 col-xs-6">
                            <!-- small box -->
                            <div class="small-box bg-green">
                                <div class="inner">
                                    <h3>
                                        53<sup style="font-size: 20px">%</sup>
                                    </h3>
                                    <p>
                                        Bounce Rate
                                    </p>
                                </div>
                                <div class="icon">
                                    <i class="ion ion-stats-bars"></i>
                                </div>
                                <a href="#" class="small-box-footer">
                                    More info <i class="fa fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div><!-- ./col -->
                        <div class="col-lg-3 col-xs-6">
                            <!-- small box -->
                            <div class="small-box bg-yellow">
                                <div class="inner">
                                    <h3>
                                        44
                                    </h3>
                                    <p>
                                        User Registrations
                                    </p>
                                </div>
                                <div class="icon">
                                    <i class="ion ion-person-add"></i>
                                </div>
                                <a href="#" class="small-box-footer">
                                    More info <i class="fa fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div><!-- ./col -->
                        <div class="col-lg-3 col-xs-6">
                            <!-- small box -->
                            <div class="small-box bg-red">
                                <div class="inner">
                                    <h3>
                                        65
                                    </h3>
                                    <p>
                                        Unique Visitors
                                    </p>
                                </div>
                                <div class="icon">
                                    <i class="ion ion-pie-graph"></i>
                                </div>
                                <a href="#" class="small-box-footer">
                                    More info <i class="fa fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div><!-- ./col -->
                    </div><!-- /.row -->

                    <!-- top row -->
                    <div class="row">
                        <div class="col-xs-12 connectedSortable">
                            
                        </div><!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <!-- Main row -->
                    <div class="row">
                        <!-- Left col -->
                        <section class="col-lg-6 connectedSortable"> 
                            <!-- Box (with bar chart) -->
                            <div class="box box-danger" id="loading-example">
                                <div class="box-header">
                                    <!-- tools box -->
                                    <div class="pull-right box-tools">
                                        <button class="btn btn-danger btn-sm refresh-btn" data-toggle="tooltip" title="Reload"><i class="fa fa-refresh"></i></button>
                                        <button class="btn btn-danger btn-sm" data-widget='collapse' data-toggle="tooltip" title="Collapse"><i class="fa fa-minus"></i></button>
                                        <button class="btn btn-danger btn-sm" data-widget='remove' data-toggle="tooltip" title="Remove"><i class="fa fa-times"></i></button>
                                    </div><!-- /. tools -->
                                    <i class="fa fa-cloud"></i>

                                    <h3 class="box-title">Server Load</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body no-padding">
                                    <div class="row">
                                        <div class="col-sm-7">
                                            <!-- bar chart -->
                                            <div class="chart" id="bar-chart" style="height: 250px;"></div>
                                        </div>
                                        <div class="col-sm-5">
                                            <div class="pad">
                                                <!-- Progress bars -->
                                                <div class="clearfix">
                                                    <span class="pull-left">Bandwidth</span>
                                                    <small class="pull-right">10/200 GB</small>
                                                </div>
                                                <div class="progress xs">
                                                    <div class="progress-bar progress-bar-green" style="width: 70%;"></div>
                                                </div>

                                                <div class="clearfix">
                                                    <span class="pull-left">Transfered</span>
                                                    <small class="pull-right">10 GB</small>
                                                </div>
                                                <div class="progress xs">
                                                    <div class="progress-bar progress-bar-red" style="width: 70%;"></div>
                                                </div>

                                                <div class="clearfix">
                                                    <span class="pull-left">Activity</span>
                                                    <small class="pull-right">73%</small>
                                                </div>
                                                <div class="progress xs">
                                                    <div class="progress-bar progress-bar-light-blue" style="width: 70%;"></div>
                                                </div>

                                                <div class="clearfix">
                                                    <span class="pull-left">FTP</span>
                                                    <small class="pull-right">30 GB</small>
                                                </div>
                                                <div class="progress xs">
                                                    <div class="progress-bar progress-bar-aqua" style="width: 70%;"></div>
                                                </div>
                                                <!-- Buttons -->
                                                <p>
                                                    <button class="btn btn-default btn-sm"><i class="fa fa-cloud-download"></i> Generate PDF</button>
                                                </p>
                                            </div><!-- /.pad -->
                                        </div><!-- /.col -->
                                    </div><!-- /.row - inside box -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <div class="row">
                                        <div class="col-xs-4 text-center" style="border-right: 1px solid #f4f4f4">
                                            <input type="text" class="knob" data-readonly="true" value="80" data-width="60" data-height="60" data-fgColor="#f56954"/>
                                            <div class="knob-label">CPU</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-4 text-center" style="border-right: 1px solid #f4f4f4">
                                            <input type="text" class="knob" data-readonly="true" value="50" data-width="60" data-height="60" data-fgColor="#00a65a"/>
                                            <div class="knob-label">Disk</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-4 text-center">
                                            <input type="text" class="knob" data-readonly="true" value="30" data-width="60" data-height="60" data-fgColor="#3c8dbc"/>
                                            <div class="knob-label">RAM</div>
                                        </div><!-- ./col -->
                                    </div><!-- /.row -->
                                </div><!-- /.box-footer -->
                            </div><!-- /.box -->        
                            
                            <!-- Custom tabs (Charts with tabs)-->
                            <div class="nav-tabs-custom">
                                <!-- Tabs within a box -->
                                <ul class="nav nav-tabs pull-right">
                                    <li class="active"><a href="#revenue-chart" data-toggle="tab">Area</a></li>
                                    <li><a href="#sales-chart" data-toggle="tab">Donut</a></li>
                                    <li class="pull-left header"><i class="fa fa-inbox"></i> Sales</li>
                                </ul>
                                <div class="tab-content no-padding">
                                    <!-- Morris chart - Sales -->
                                    <div class="chart tab-pane active" id="revenue-chart" style="position: relative; height: 300px;"></div>
                                    <div class="chart tab-pane" id="sales-chart" style="position: relative; height: 300px;"></div>
                                </div>
                            </div><!-- /.nav-tabs-custom -->
                                                
                            <!-- Calendar -->
                            <div class="box box-warning">
                                <div class="box-header">
                                    <i class="fa fa-calendar"></i>
                                    <div class="box-title">Calendar</div>
                                    
                                    <!-- tools box -->
                                    <div class="pull-right box-tools">
                                        <!-- button with a dropdown -->
                                        <div class="btn-group">
                                            <button class="btn btn-warning btn-sm dropdown-toggle" data-toggle="dropdown"><i class="fa fa-bars"></i></button>
                                            <ul class="dropdown-menu pull-right" role="menu">
                                                <li><a href="#">Add new event</a></li>
                                                <li><a href="#">Clear events</a></li>
                                                <li class="divider"></li>
                                                <li><a href="#">View calendar</a></li>
                                            </ul>
                                        </div>
                                    </div><!-- /. tools -->                                    
                                </div><!-- /.box-header -->
                                <div class="box-body no-padding">
                                    <!--The calendar -->
                                    <div id="calendar"></div>
                                </div><!-- /.box-body -->
                            </div><!-- /.box -->

                            <!-- quick email widget -->
                            <div class="box box-info">
                                <div class="box-header">
                                    <i class="fa fa-envelope"></i>
                                    <h3 class="box-title">Quick Email</h3>
                                    <!-- tools box -->
                                    <div class="pull-right box-tools">
                                        <button class="btn btn-info btn-sm" data-widget="remove" data-toggle="tooltip" title="Remove"><i class="fa fa-times"></i></button>
                                    </div><!-- /. tools -->
                                </div>
                                <div class="box-body">
                                    <form action="#" method="post">
                                        <div class="form-group">
                                            <input type="email" class="form-control" name="emailto" placeholder="Email to:"/>
                                        </div>
                                        <div class="form-group">
                                            <input type="text" class="form-control" name="subject" placeholder="Subject"/>
                                        </div>
                                        <div>
                                            <textarea class="textarea" placeholder="Message" style="width: 100%; height: 125px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
                                        </div>
                                    </form>
                                </div>
                                <div class="box-footer clearfix">
                                    <button class="pull-right btn btn-default" id="sendEmail">Send <i class="fa fa-arrow-circle-right"></i></button>
                                </div>
                            </div>

                        </section><!-- /.Left col -->
                        <!-- right col (We are only adding the ID to make the widgets sortable)-->
                        <section class="col-lg-6 connectedSortable">
                            <!-- Map box -->
                            <div class="box box-primary">
                                <div class="box-header">
                                    <!-- tools box -->
                                    <div class="pull-right box-tools">                                        
                                        <button class="btn btn-primary btn-sm daterange pull-right" data-toggle="tooltip" title="Date range"><i class="fa fa-calendar"></i></button>
                                        <button class="btn btn-primary btn-sm pull-right" data-widget='collapse' data-toggle="tooltip" title="Collapse" style="margin-right: 5px;"><i class="fa fa-minus"></i></button>
                                    </div><!-- /. tools -->

                                    <i class="fa fa-map-marker"></i>
                                    <h3 class="box-title">
                                        Visitors
                                    </h3>
                                </div>
                                <div class="box-body no-padding">
                                    <div id="world-map" style="height: 300px;"></div>
                                    <div class="table-responsive">
                                        <!-- .table - Uses sparkline charts-->
                                        <table class="table table-striped">
                                            <tr>
                                                <th>Country</th>
                                                <th>Visitors</th>
                                                <th>Online</th>
                                                <th>Page Views</th>
                                            </tr>
                                            <tr>
                                                <td><a href="#">USA</a></td>
                                                <td><div id="sparkline-1"></div></td>
                                                <td>209</td>
                                                <td>239</td>
                                            </tr>
                                            <tr>
                                                <td><a href="#">India</a></td>
                                                <td><div id="sparkline-2"></div></td>
                                                <td>131</td>
                                                <td>958</td>
                                            </tr>
                                            <tr>
                                                <td><a href="#">Britain</a></td>
                                                <td><div id="sparkline-3"></div></td>
                                                <td>19</td>
                                                <td>417</td>
                                            </tr>
                                            <tr>
                                                <td><a href="#">Brazil</a></td>
                                                <td><div id="sparkline-4"></div></td>
                                                <td>109</td>
                                                <td>476</td>
                                            </tr>
                                            <tr>
                                                <td><a href="#">China</a></td>
                                                <td><div id="sparkline-5"></div></td>
                                                <td>192</td>
                                                <td>437</td>
                                            </tr>
                                            <tr>
                                                <td><a href="#">Australia</a></td>
                                                <td><div id="sparkline-6"></div></td>
                                                <td>1709</td>
                                                <td>947</td>
                                            </tr>
                                        </table><!-- /.table -->
                                    </div>
                                </div><!-- /.box-body-->
                                <div class="box-footer">
                                    <button class="btn btn-info"><i class="fa fa-download"></i> Generate PDF</button>
                                    <button class="btn btn-warning"><i class="fa fa-bug"></i> Report Bug</button>
                                </div>
                            </div>
                            <!-- /.box -->

                            <!-- Chat box -->
                            <div class="box box-success">
                                <div class="box-header">
                                    <h3 class="box-title"><i class="fa fa-comments-o"></i> Chat</h3>
                                    <div class="box-tools pull-right" data-toggle="tooltip" title="Status">
                                        <div class="btn-group" data-toggle="btn-toggle" >
                                            <button type="button" class="btn btn-default btn-sm active"><i class="fa fa-square text-green"></i></button>                                            
                                            <button type="button" class="btn btn-default btn-sm"><i class="fa fa-square text-red"></i></button>
                                        </div>
                                    </div>
                                </div>
                                <div class="box-body chat" id="chat-box">
                                    <!-- chat item -->
                                    <div class="item">
                                        <img src="img/avatar.png" alt="user image" class="online"/>
                                        <p class="message">
                                            <a href="#" class="name">
                                                <small class="text-muted pull-right"><i class="fa fa-clock-o"></i> 2:15</small>
                                                Mike Doe
                                            </a>
                                            I would like to meet you to discuss the latest news about
                                            the arrival of the new theme. They say it is going to be one the
                                            best themes on the market
                                        </p>
                                        <div class="attachment">
                                            <h4>Attachments:</h4>
                                            <p class="filename">
                                                Theme-thumbnail-image.jpg
                                            </p>
                                            <div class="pull-right">
                                                <button class="btn btn-primary btn-sm btn-flat">Open</button>
                                            </div>
                                        </div><!-- /.attachment -->
                                    </div><!-- /.item -->
                                    <!-- chat item -->
                                    <div class="item">
                                        <img src="img/avatar2.png" alt="user image" class="offline"/>
                                        <p class="message">
                                            <a href="#" class="name">
                                                <small class="text-muted pull-right"><i class="fa fa-clock-o"></i> 5:15</small>
                                                Jane Doe
                                            </a>
                                            I would like to meet you to discuss the latest news about
                                            the arrival of the new theme. They say it is going to be one the
                                            best themes on the market
                                        </p>
                                    </div><!-- /.item -->
                                    <!-- chat item -->
                                    <div class="item">
                                        <img src="img/avatar3.png" alt="user image" class="offline"/>
                                        <p class="message">
                                            <a href="#" class="name">
                                                <small class="text-muted pull-right"><i class="fa fa-clock-o"></i> 5:30</small>
                                                Susan Doe
                                            </a>
                                            I would like to meet you to discuss the latest news about
                                            the arrival of the new theme. They say it is going to be one the
                                            best themes on the market
                                        </p>
                                    </div><!-- /.item -->
                                </div><!-- /.chat -->
                                <div class="box-footer">
                                    <div class="input-group">
                                        <input class="form-control" placeholder="Type message..."/>
                                        <div class="input-group-btn">
                                            <button class="btn btn-success"><i class="fa fa-plus"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box (chat box) -->

                            <!-- TO DO List -->
                            <div class="box box-primary">
                                <div class="box-header">
                                    <i class="ion ion-clipboard"></i>
                                    <h3 class="box-title">To Do List</h3>
                                    <div class="box-tools pull-right">
                                        <ul class="pagination pagination-sm inline">
                                            <li><a href="#">&laquo;</a></li>
                                            <li><a href="#">1</a></li>
                                            <li><a href="#">2</a></li>
                                            <li><a href="#">3</a></li>
                                            <li><a href="#">&raquo;</a></li>
                                        </ul>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <ul class="todo-list">
                                        <li>
                                            <!-- drag handle -->
                                            <span class="handle">
                                                <i class="fa fa-ellipsis-v"></i>
                                                <i class="fa fa-ellipsis-v"></i>
                                            </span>  
                                            <!-- checkbox -->
                                            <input type="checkbox" value="" name=""/>                                            
                                            <!-- todo text -->
                                            <span class="text">Design a nice theme</span>
                                            <!-- Emphasis label -->
                                            <small class="label label-danger"><i class="fa fa-clock-o"></i> 2 mins</small>
                                            <!-- General tools such as edit or delete-->
                                            <div class="tools">
                                                <i class="fa fa-edit"></i>
                                                <i class="fa fa-trash-o"></i>
                                            </div>
                                        </li>
                                        <li>
                                            <span class="handle">
                                                <i class="fa fa-ellipsis-v"></i>
                                                <i class="fa fa-ellipsis-v"></i>
                                            </span>                                            
                                            <input type="checkbox" value="" name=""/>
                                            <span class="text">Make the theme responsive</span>
                                            <small class="label label-info"><i class="fa fa-clock-o"></i> 4 hours</small>
                                            <div class="tools">
                                                <i class="fa fa-edit"></i>
                                                <i class="fa fa-trash-o"></i>
                                            </div>
                                        </li>
                                        <li>
                                            <span class="handle">
                                                <i class="fa fa-ellipsis-v"></i>
                                                <i class="fa fa-ellipsis-v"></i>
                                            </span>
                                            <input type="checkbox" value="" name=""/>
                                            <span class="text">Let theme shine like a star</span>
                                            <small class="label label-warning"><i class="fa fa-clock-o"></i> 1 day</small>
                                            <div class="tools">
                                                <i class="fa fa-edit"></i>
                                                <i class="fa fa-trash-o"></i>
                                            </div>
                                        </li>
                                        <li>
                                            <span class="handle">
                                                <i class="fa fa-ellipsis-v"></i>
                                                <i class="fa fa-ellipsis-v"></i>
                                            </span>
                                            <input type="checkbox" value="" name=""/>
                                            <span class="text">Let theme shine like a star</span>
                                            <small class="label label-success"><i class="fa fa-clock-o"></i> 3 days</small>
                                            <div class="tools">
                                                <i class="fa fa-edit"></i>
                                                <i class="fa fa-trash-o"></i>
                                            </div>
                                        </li>
                                        <li>
                                            <span class="handle">
                                                <i class="fa fa-ellipsis-v"></i>
                                                <i class="fa fa-ellipsis-v"></i>
                                            </span>
                                            <input type="checkbox" value="" name=""/>
                                            <span class="text">Check your messages and notifications</span>
                                            <small class="label label-primary"><i class="fa fa-clock-o"></i> 1 week</small>
                                            <div class="tools">
                                                <i class="fa fa-edit"></i>
                                                <i class="fa fa-trash-o"></i>
                                            </div>
                                        </li>
                                        <li>
                                            <span class="handle">
                                                <i class="fa fa-ellipsis-v"></i>
                                                <i class="fa fa-ellipsis-v"></i>
                                            </span>
                                            <input type="checkbox" value="" name=""/>
                                            <span class="text">Let theme shine like a star</span>
                                            <small class="label label-default"><i class="fa fa-clock-o"></i> 1 month</small>
                                            <div class="tools">
                                                <i class="fa fa-edit"></i>
                                                <i class="fa fa-trash-o"></i>
                                            </div>
                                        </li>
                                    </ul>
                                </div><!-- /.box-body -->
                                <div class="box-footer clearfix no-border">
                                    <button class="btn btn-default pull-right"><i class="fa fa-plus"></i> Add item</button>
                                </div>
                            </div><!-- /.box -->

                        </section><!-- right col -->
                    </div><!-- /.row (main row) -->

                </section><!-- /.content -->
            </aside><!-- /.right-side -->
        </div><!-- ./wrapper -->

<div class="information_push">
  <div class="information_push_main" id="pushMsgDetailDiv">
    <ul>
      <li class="information_push_mainBG">
        <ul id="pushMsgList">
          <li class="information_push_title">消息窗口</li>
        </ul>
      </li>
      <li class="information_push_bottomBG"></li>
    </ul>
  </div>
  <div class="information_push_button"><a href="javascript:void(0)" onclick="showPushMsgDetailDiv()"><img title="推送消息" src="../images/icon/alarm_clock.png" class="img_alarm_clock" /><span id="pushMsgCount">0</span></a></div>
</div>
<div class="index_health">
<!doctype html>
<html lang="en">
<head>
<title></title>
<meta charset="utf-8" />
<script type="text/javascript" src="<c:url value='/js/topws.js'/>"></script>

	<script type="text/JavaScript">
		
		function logout() {
			document.logoutForm.submit();
			return true;
		}
		
		function activeTopMenu(id) {
		   $("#topMenuNav li").each(function() {
			   $(this).removeClass("activation");
		   });
		   var tempId = "#topMenu" + id;
		   $(tempId).addClass("activation");
		}
		
		function activeHelathMenu(id) {
		   $("#helathMenuNav li").each(function() {
			   $(this).removeClass("indexMenu_secondary_activation");
		   });
		   var tempId = "#hMenu" + id;
		   $(tempId).addClass("indexMenu_secondary_activation");
		}
		
		
		function goPageBottom() {
		    window.scrollTo(0,document.body.scrollHeight);
		}
		
		
	</script>
	
	<style type="text/css">
		.bg_logo{background:url(../images/icon/logo.jpg) 22px center no-repeat;}
	</style>
</head>
<body >	
    </div>
    <!--indexMenu end-->
    <!--indexMenu_secondary start-->
    <div class="indexMenu_secondary">
      <div >
        <ul id="helathMenuNav" class="dropdown clearfix gradient indexMenu_secondary_main">
          <li id="hMenu0" onclick="activeHelathMenu(0)" class="menu-level-0 indexMenu_secondary_activation "><a href="<c:url value='/jsp/health/welcome.jsp'/>" target="mainFrame" title="欢迎页">首页</a></li>
          <li id="hMenu1" onclick="activeHelathMenu(1)" class="menu-level-0"><a href="../jsp/health/analyse/ianalysis.jsp" target="mainFrame" title="健康分析">健康分析</a></li>
          <li id="hMenu2" onclick="activeHelathMenu(2)" class="menu-level-0"><a href="../jsp/health/lbs/location.jsp" target="mainFrame" title="终端定位">终端定位</a></li>
          <li id="hMenu3" onclick="activeHelathMenu(3)" class="menu-level-0"><a href="../jsp/health/healthrecord/healthrecords.jsp" target="mainFrame" title="健康档案">健康档案</a></li>
          <li id="hMenu4" onclick="activeHelathMenu(4)" class="menu-level-0"><a href="../jsp/health/equipment/equipment.jsp" target="mainFrame" title="我的设备">我的设备</a></li>
          <li id="hMenu5" onclick="activeHelathMenu(5)" class="menu-level-0"><a href="../jsp/health/account/account.jsp" target="mainFrame" title="账户/套餐">账户/套餐</a></li>
          <li id="hMenu6" onclick="activeHelathMenu(6)" class="menu-level-0"><a href="../jsp/health/doctor_report/reportlist.jsp" target="mainFrame" title="医生报告">医生报告</a></li>
        </ul> 
      </div>
    </div>
    <!--indexMenu_secondary end-->
    <!--index_health_header end-->
    
</body></html>
    
    
    <!--index_health_main start-->
    <div class="index_health_middle">
    <div class="index_health_main">
      <!--index_health_left start-->
      <div class="index_health_left">
        <div class="wInformation">
          <ul>
            <li class="wInformation_img"><a href="../jsp/health/healthrecord/healthrecords.jsp" target="mainFrame" title="健康档案"><img width="80" height="90" id="memberHeadImg" src="<c:url value='/imageUploadAction/showHeadImage.do'/>" /></a></li>
            <li class="tGrayMax">您好！</li>
            <li class="tGreen" ><a class="title_info" href="../jsp/health/healthrecord/healthrecords.jsp" target="mainFrame" title="无名氏"  id="left_memberName">${sessionScope.Patient.pname}</a></li>
            <li class="tGrayMin" style="font-size:8px;">最近2016-01-06 09:57:38</li>
            <li class="wMedical"><a onclick="goToHealthRecord(this)" style="cursor: pointer;" target="mainFrame" title="健康档案">健康档案</a></li>
            <li class="wHome"><a onclick="goToAccount(this)" style="cursor: pointer;" target="mainFrame" title="账户/套餐">账户/套餐</a></li>
            <li class="wBalance">我的余额：<span class="wMoney" id="memberBalanceArea"></span>
            	<span class="title_info"><a title="充值" class="title_info" onclick="goToRecharge(this)" target="mainFrame">立即充值</a></span>
            </li>
            <li class="tGray wBalance" id="familyMember">我的家庭成员：
	            <c:forEach items="${sessionScope.PatientList}"  var="pa">
	            <br/>

	            <a href="javascript:void(0)" onclick="patientChange(this)" id="${pa.pid}">				
					<c:out value="${pa.pname}"/>
				</a>
				
				</c:forEach>
            </li>
            <li class="tGray" id="device">我的设备：
            	<ul id='deviceListUL'>
       
            	</ul>
            </li>
            <li class="tGray" id="hos_doc">我的医院医生：</li>
            <li class="tGray" id="package">我的套餐：</li>
          </ul>
        </div>  
      </div>
      <!--index_health_left end-->
    </div>
    </div>
    <!--index_health_main start-->  
  </div>
</body>
</html>
