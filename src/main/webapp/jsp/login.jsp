
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>贵州健康云服务中心V1.0</title>
<link rel="Shortcut Icon"  href="995120.ico"/>
<meta http-equiv="keywords" content="个人健康服务中心,物联网,可穿戴设备,动态血压,心电,十二导联,电子围栏,用药提醒,测压提醒"/>
<meta http-equiv="description" content="个人健康服务中心"/>
<link rel="stylesheet" href="<c:url value='/css/common.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/css/login.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/css/index_common.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/css/popup.css'/>" type="text/css" />

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


<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.4.2.min.js'/>"></script>

<script type="text/JavaScript">

   var login_id_tip = "用户名/手机/邮箱";
   var regstr = /^[a-zA-Z0-9]{1}\w{4,29}$/;
   var regstr1 = /^[^\s%]{6,20}$/; 
		
   function login() {
   
        var login_id = $.trim($("#login_id").val());
		var passwd = $.trim($("#passwd").val());
		 	
        if(login_id == ""){
			$("#errMessageArea").html("账号不能为空");
			$("#login_id").focus();
			return false;
		}
		
		if(login_id == login_id_tip) {
		   $("#errMessageArea").html("请输入账号");
		   $("#login_id").focus();
		   return false;
		}
		
		if(passwd == ""){
			$("#errMessageArea").html("密码不能为空");
			$("#passwd").focus();
			return false;
		}
		
		/*
		if(!regstr.test(login_id)){
		    $("#errMessageArea").html("<font size='2' color='red'>账号格式不正确！</font>");
		    setTimeout("autoClearErrorMsg();", 10000);
		    $("#login_id").focus();
		    return false;
		}
		*/
		
		if(!regstr1.test(passwd)){
		    $("#errMessageArea").html("<font size='2' color='red'>密码格式不正确！</font>");
		    setTimeout("autoClearErrorMsg();", 10000);
		    $("#passwd").focus();
		    return false;
		}
		 	
		document.loginForm.submit();
		return true;
   }
   
   function checkLoginInput(event) {
        var login_id = $.trim($("#login_id").val());
        if(event == "onclick") {
            if(login_id == login_id_tip) {
                $("#login_id").val("");
            }
        }
        
        if(event == "onblur") {
            if(login_id.length == 0) {
                $("#login_id").val(login_id_tip);
            }
        }
   }
   
   document.onkeydown=function() {  
	   if (window.event.keyCode==13) {
	       login();
	   }
   }  
   
   function autoClearErrorMsg() {
       $("#errMessageArea").html("");
   }
   
</script>

</head>

<body>
  <div class="login">
    <!--login_header start-->
    <div class="login_header">
      <div class="bg_top_login">
        <div class="login_out">
          <ul>
           <li class="login_wechat"><a href="<c:url value='/jsp/health/index/wechat.jsp'/>" title="995120健康服务中心官方微信" target="_blank">官方微信</a></li>
           <li class="login_bolg"><a href="http://weibo.com/5137507355/profile" title="995120健康服务中心官方微博" target="_blank">官方微博</a></li>
           <li class="login_service_phone" title="客服电话">400-0785-120</li>
           <li class="login_top"></li>
           <li class="h6.foo"><a href="<c:url value='/jsp/register/protocol.jsp'/>" title="注册">立即注册</a></li> 
          </ul>
        </div>
      </div>
      <div class="logo_menu">
        <div class="bg_logo">
          <div class="login_menu">
            <ul>
              <li></li>
              <li class="activation"><a href="login.jsp" title="首页">首页</a></li>
              <li><a href="<c:url value='/jsp/download/download.jsp'/>" title="APP下载、Android、iOS" target="_blank">应用下载</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <!--login_header end-->
    
    <!--login_banner start-->
    <div class="login_banner">
      <div class="login_bannner_main">
        <div class="login_bannner_gg"></div>
        <div class="bg_login_mian">
          <div class="login_main">
          
            
            <form action="/gzjky/login/login.do" id="loginForm" name="loginForm" method="post" autocomplete="off">
            <ul>
              <li class="tBlue">登录</li>
              <li class="taRegister">还没有注册？<a href="<c:url value='/jsp/register/protocol.jsp'/>" title="注册">点击此处注册</a></li>
              <li class="tBlack">账号</li>
              <li class="field_text" style="width: 285px"><input type="text" id="login_id" name="loginId" class="lInput" value="用户名/手机/邮箱" onclick="checkLoginInput('onclick')" onblur="checkLoginInput('onblur')"/></li>
              <li class="tBlack">密码</li>
              <li class="field_text" style="width: 285px"><input type="password" id="passwd" name="passwd" class="lInput" /></li>
              <li class="tBlack" id="errMessageArea" style="color:#ff9600;"></li>
              <li class="tBlack" style="display:none;">验证码</li>
              <li class="lCaptcha_input" style="display:none;"><input type="text" class="yInput" /></li>
              <li class="login_captcha" style="display:none;"></li>
              <li class="taBlack" style="display:none;"><a href="###">换一换</a></li>
              <li ><a href="javascript:void(0)" onclick="login();" class="btn btn-large btn-green" style="width: 285px" title="登录"><span>登录</span></a></li>
              <li class="taBlack2"><a href="<c:url value='/jsp/password/forget_pwd.jsp'/>" title="忘记密码">忘记密码？</a></li>
              <li></li>
              <li></li>
              <li></li>
              <li></li>
              <li></li>
              <li></li>
            </ul>
            </form>
            
            
          </div>
        </div>
      </div>  
    </div>
    <!--login_header end-->
    
  </div>
</body>
</html>

