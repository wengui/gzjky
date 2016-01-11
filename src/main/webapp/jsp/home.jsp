
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心V3.0</title>
<meta http-equiv="keywords" content="个人健康服务中心,物联网,可穿戴设备,动态血压,心电,十二导联,电子围栏,用药提醒,测压提醒"/>
<meta http-equiv="description" content="个人健康服务中心"/>
<link rel="Shortcut Icon"  href="/995120.ico"/>
<link rel="stylesheet" href="<c:url value='/css/common.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/css/index_common.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/css/popup.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/js/artDialog/skins/default.css'/>" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/balance.js'/>" type="text/javascript"></script>

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
		//memberBindDevice();
		//hos_docInfo();
		//packageBaseinfo();
		//queryBalance();
		//connect("ws://v3.995120.cn/MemberActivityMsg/Server", "24913_1_2");
	}
	//查询用户绑定设备
	function memberBindDevice() {
		/*var para = "";	
		$.ajax({
			url:"/welcome/queryMemberDeviceBind.action",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常","请注意");
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var memberDeviceBindList=modelMap.memberDeviceBindList;
				
				
				$("#device").empty();
				$("#device").html("我的设备");
				$("#device").append("<ul id='deviceListUL'></ul>");
				
				$("#deviceListUL").empty();
				if(memberDeviceBindList != null && memberDeviceBindList.length > 0) {
					var str = "";
					for ( var i = 0; i < memberDeviceBindList.length; i++) {
						var text = '';
						var product = memberDeviceBindList[i].product;
						var description = memberDeviceBindList[i].description;
						text = product + "(" + description.replace(product, '') + ")";
						str += "<li class='wtBlack'>" + text + "</li>";
					}
					
					$("#deviceListUL").html(str);
					
				} else {
				    $("#deviceListUL").html("<li class='wtBlack'>暂无</li>");
				}
				
			
			
		        
		        $("#deviceListUL").append("<li class='wtaGreen'><a href='/jsp/health/equipment/member_bind_device.jsp' target='mainFrame' title='增加设备'>增加设备</a></li>"); 
				
			}
		});*/
	}
	
	//查询用户绑定的医院医生
	function hos_docInfo(){
		var para= "";	
		$.ajax({
			url:"/welcome/queryHosDocInfo.action",
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("发生异常1","请注意");
				return false;
			},
			success:function(response) {
				var modelMap = response.modelMap;
				var hosDocInfoList = modelMap.hosDocInfoList;
				
				$("#hos_doc").empty();
				$("#hos_doc").html("我的医院医生：");
				$("#hos_doc").append("<ul id='hosDocListUL'></ul>");
				
				$("#hosDocListUL").empty();
				if(hosDocInfoList != null && hosDocInfoList.length > 0) {
					var str = "";
					for ( var i = 0; i < hosDocInfoList.length; i++) {
						var text = '';
						var bind_type=hosDocInfoList[i].bind_type;
						if(bind_type==0||bind_type=='0'){
							text = hosDocInfoList[i].hosName + "(" + hosDocInfoList[i].code + ")";
						}else{
							text = hosDocInfoList[i].docName + "(" + hosDocInfoList[i].job_num + ")";
						}
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
</script>


</head>

<body onload="Query();">



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
<body>	
    <!--index_health_header start-->
    <div class="index_health_header">
      <div class="bgTop_index">
        <div class="index_out">
          <ul>
           <li class="index_wechat"><a href="../jsp/health/index/wechat.jsp" title="995120健康服务中心官方微信" target="_blank">官方微信</a></li>
           <li class="index_bolg"><a href="http://weibo.com/5137507355/profile" title="995120健康服务中心官方微博" target="_blank">官方微博</a></li>
           <li class="index_service_phone" title="400电话">400-0785-120</li>
           <li class="index_username">欢迎您，test1</li>
           <li class="index_signout">
               <a href="javascript:void(0)" onclick="logout();" title="安全退出">安全退出</a>
               <form action="/gzjky/login/layout.do" id="logoutForm" name="logoutForm" method="post">
               </form>
           </li> 
          </ul>
        </div>
      </div>
      <!--indexMenu start-->
      <div class="logo_menu" >
        <div class="bg_logo">
          <div class="index_menu">
            <ul id="topMenuNav">
              <li id="topMenu0" ></li>
              <li id="topMenu1" onclick="activeTopMenu(1)" class="activation"><a href="../jsp/home.jsp" title="健康中心">健康中心</a></li>
              <li id="topMenu2" ><a href="../jsp/download/download.jsp" title="APP下载、Android、iOS" target="_blank">应用下载</a></li>
              <li id="topMenu3" ><a href="/h/d.helowin?code=2hLtOLIuHAzLxbZoNN5q0st3F3pn8/rEvTb8AJjwM4QRf+HKJm4LWQiWiSGtt3lc&iv=4kmmmcebmot8f5uv" title="新手上路" target="_blank">新手上路</a></li>
            </ul>
          </div>
        </div>
      </div>
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
            <li class="wInformation_img"><a href="../jsp/health/healthrecord/healthrecords.jsp" target="mainFrame" title="健康档案"><img width="80" height="90" id="memberHeadImg" src="../images/health/default_head.gif?t=1452046474054" /></a></li>
            <li class="tGrayMax">您好！</li>
            <li class="tGreen" ><a class="title_info" href="../jsp/health/healthrecord/healthrecords.jsp" target="mainFrame" title="无名氏"  id="left_memberName">无名氏</a></li>
            <li class="tGrayMin" style="font-size:8px;">最近2016-01-06 09:57:38</li>
            <li class="wMedical"><a onclick="goToHealthRecord(this)" style="cursor: pointer;" target="mainFrame" title="健康档案">健康档案</a></li>
            <li class="wHome"><a onclick="goToAccount(this)" style="cursor: pointer;" target="mainFrame" title="账户/套餐">账户/套餐</a></li>
            <li class="wBalance">我的余额：<span class="wMoney" id="memberBalanceArea"></span>
            	<span class="title_info"><a title="充值" class="title_info" onclick="goToRecharge(this)" target="mainFrame">立即充值</a></span>
            </li>
            <li class="tGray wBalance" id="familyMember">我的家庭成员：
            </li>
            <li class="tGray" id="device">我的设备：
            	<ul id='deviceListUL'>
            	    
					<li class='wtBlack'>暂无</li>
					
					<li class='wtaGreen'><a onclick="goToEquipment(this)" target="mainFrame" title="增加设备">增加设备</a></li>
            	</ul>
            </li>
            <li class="tGray" id="hos_doc">我的医院医生：</li>
            <li class="tGray" id="package">我的套餐：</li>
          </ul>
        </div>  
      </div>
      <!--index_health_left end-->
      <!--index_health_right start-->
      <div class="index_health_right">
        <iframe src="<c:url value='/jsp/health/welcome.jsp'/>" scrolling="no" frameborder="0" name="mainFrame" id="mainFrame" onload="reinitIframe();"></iframe>
      </div>
      <!--index_health_right end-->
    </div>
    </div>
    <!--index_health_main start-->  

<style>
.tGray_bottom a{text-decoration: none; color: #ffffff;}
</style>


    <!--index_health_bottom start-->
    <a name="page_botton_block"></a>
    <div class="index_health_bottom" >
      <div class="bottom_main">
        <div class="bottom_contact">
          <ul>
            <li class="tWhite">
            <span class="tGreen" title="联系我们">Contact us</span>联系我们
            </li>
            <li class="tGray_bottom" title="地址">地址：浙江省杭州市西湖区西斗门路天堂软件园E幢13楼</li>
            <li class="tGray_bottom" title="客服热线">客服热线：400-0785-120</li>
            <li class="tGray_bottom" title="公司官网">公司官网：<a href="http://www.hellowin.cn" target="_blank">www.hellowin.cn</a></li>
            <li class="tGray_bottom" title="服务邮箱">邮箱：helowin@hellowin.cn</li>
            <li class="tGray_bottom">
				<a href="http://122.224.75.236/wzba/login.do?method=hdurl&doamin=http://www.995120.cn&id=330108000063652&SHID=1223.0AFF_NAME=com.rouger.
				gs.main.UserInfoAff&AFF_ACTION=qyhzdetail&PAGE_URL=ShowDetail"
				target="_blank"> <img src="http://122.224.75.236/wzba/view/baxx/gh.jpg" border="0"></a>        
            
            </li>
            
            
          </ul>
        </div>
        <div class="bottom_help">
          <ul>
            <li class="tWhite"></li>
            <li class="taqueation_left"></li>
            <li class="taqueation_middle"></li>
            <li class="taqueation_right"></li>
            <li class="taqueation_left"></li>
            <li class="taqueation_middle"></li>
            <li class="taqueation_right"></li>
          </ul>
        </div>
        <div class="bottom_concern">
          <ul>
            <li class="tWhite"><span class="tGreen">Concern us</span>关注我们</li>
            <li class="wechat_code">官方微信</li>
            <li class="blog_code">官方新浪微博</li>
          </ul>
        </div>
        <div class="copyright">
        
        
        Copyright © 2010-2014 浙江好络维物联网络技术有限公司版权所有  浙ICP备10212076号-1
        <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1000351579'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s22.cnzz.com/z_stat.php%3Fid%3D1000351579%26show%3Dpic1' type='text/javascript'%3E%3C/script%3E"));</script>    
 
        
        </div>
      </div>
    </div>
    <!--index_health_bottom start-->
    <div id="transparentDiv2" onclick="showPushMsgDetailDiv();"></div>
    
    
    
    
    
  </div>
</body>
</html>
