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
<link rel="stylesheet" href="<c:url value='/css/register.css'/>" type="text/css" />

<%@ include file="shared/importCss.jsp"%>
<%@ include file="shared/importJs.jsp"%>
<!-- scripts -->

<script type="text/JavaScript">


	var msg="${requestScope.errorMessage}";
	if(msg!=""){
		$("#errMessageArea").html(msg);
	}

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
	<div class="login_header" >

		<div class="register_header">
			<div class="bgTop_register">

				<div class="logo_menu">
					<div class="bgLogo_register">
						<ul>
							<li class="tGraymax" style="width:350px">欢迎使用贵州健康云服务平台</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!--login_banner start-->
	<div class="login_banner">
		<div class="login_bannner_main">
			<div class="login_bannner_gg"></div>

			<div class="login_main">
				<div class="form-box" id="login-box">
					<div class="header">登录您的帐户</div>
					<form action="/gzjky/login/login.do" id="loginForm"
						name="loginForm" method="post" autocomplete="off">

						<div class="body bg-gray">
							<div class="form-group">
								<input type="text" id="login_id" name="loginId"
									class="form-control" placeholder="用户名" />
							</div>
							<div class="form-group">
								<input type="password" id="passwd" name="passwd"
									class="form-control" placeholder="密码" />
							</div>
							<div id="errMessageArea" style="color: #ff9600;height:20px;text-align:left">
								${errorMessage}
							</div>
						</div>
						<div class="footer">
							<a href="javascript:void(0)" onclick="login();"
								class="btn bg-olive btn-block" title="登录"><span>登录</span></a>
								<p>
								<a href="<c:url value='/jsp/password/forget_pwd.jsp'/>"	title="忘记密码" class="text-left" style="text-decoration: underline;float: left;width:230px;font-size:18px">忘记密码？</a>
								
								<a href="<c:url value='/jsp/register/protocol.jsp'/>" title="注册" class="text-right" style="text-decoration: underline;font-size:18px">新用户注册</a>
								</p>
						</div>
					</form>
				</div>
			</div>

		</div>
	</div>
	<!--index_health_bottom start-->
   <jsp:include page="/jsp/bottom.jsp" />
    <!--index_health_bottom end-->

</body>
</html>

