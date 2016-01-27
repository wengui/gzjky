<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心 | 注册</title>
<link rel="Shortcut Icon" href="/995120.ico" />
<%@ include file="../shared/importCss.jsp"%>
<%@ include file="../shared/importJs.jsp"%>

<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/register.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_bottom.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>"  rel="stylesheet"  type="text/css" />
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>"  type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>"  type="text/javascript"></script>



<script type="text/javascript">


	var pwdStrongContext="";

	$(function(){
	    	jQuery('#addform').validationEngine("attach",
	    	{
	    				promptPosition:"topRight",
	    				maxErrorsPerField:1,
	    				scroll:false,
	    				autoPositionUpdate:"true"
	    				//binded:false,
	    				//showArrow:false,
	    		}
	    	);
	   });

	function checkLoginId(){
		var login_id=$("#login_id").val();
		if(login_id==""){
			//$("#login_id").attr("style","color:#ccc;");
			$("#login_id").val("用户名");
		}
	}
	
	function pwdStatusCheck(){
		
		var passwd=$("#passwd").val();
		
		if(passwd.length<6){
			$("#pwdStatus").attr("style","display:none"); 
			/* $("#passwd_point").attr("style","margin-top:0px");*/
		}
		
		if(passwd.length>=6 && /^\d+$/.test(passwd)){
			/* $("#passwd_point").attr("style","margin-top:20px"); */
			$("#pwdStatus").attr("style","display:block");
			$("#pwdStatus").attr("class","pswState pswState-poor");
			pwdStrongContext="弱";
		}
		
		if(passwd.length>=6 && (passwd.search(/[A-Za-z]/)!=-1 || passwd.search(/[^A-Za-z0-9]/)!=-1)){
			/* $("#passwd_point").attr("style","margin-top:20px"); */
			$("#pwdStatus").attr("style","display:block");
			$("#pwdStatus").attr("class","pswState pswState-normal");
			pwdStrongContext="中等";
		}
		
		if(passwd.length>=6 && (passwd.search(/[A-Za-z]/)!=-1 && passwd.search(/[^A-Za-z0-9]/)!=-1)){
			/* $("#passwd_point").attr("style","margin-top:20px");*/
			$("#pwdStatus").attr("style","display:block"); 
			$("#pwdStatus").attr("class","pswState pswState-strong");
			pwdStrongContext="强";
		}
	} 
	
	function	checkPasswd(){
		var passwd=$("#passwd").val();
		if(passwd==""){
			$("#passwd").attr("style","display:none");	
			$("#passwdv").attr("style","display:block");	
		}	
		/* $("#passwd_point").html("<img src='../../images/login/tick.png'/><span style='color:green'>密码强度:"+pwdStrongContext+"</span>");
		$("#pwdStatus").attr("style","display:none");
		$("#passwd_point").attr("style","margin-top:0px"); */
	}
	
	function checkRePasswd(){
		var re_passwd=$("#re_passwd").val();
		if(re_passwd==""){
			$("#re_passwd").attr("style","display:none;");
			$("#re_passwdv").attr("style","display:block;");
		}
	}
	
	function showLoginIdPoint(){
		if($("#login_id").val()=="用户名"){
			$("#login_id").val("");
			$("#login_id").attr("style","color:#5a5a5a;");
		}
	}

	function showPasswdPoint(){
		$("#passwdv").validationEngine("hide");
		$("#passwdv").attr("style","display:none");
		$("#passwd").attr("style","display:block");
		$("#passwd").focus();
	}
	function showRePasswdPoint(){
		$("#re_passwdv").validationEngine("hide");
		$("#re_passwdv").attr("style","display:none");
		$("#re_passwd").attr("style","display:block");
		$("#re_passwd").focus();
	}

	function sendCellPhone(){	
			var cell_phone=$("#cell_phone").val();		
			var c=/^((00){1}[1-9]{1}[0-9]{1,3}|86|\+86)?1[3458]\d{9}$/;
			if(!c.test(cell_phone)){
				return false;
			}			
			time();		
			var para="cell_phone="+cell_phone;
			xmlHttp = $.ajax({						
				url:"/register/sendCellPhone.action",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",		
				error:function(){
					$.alert('异常');
				},success:function(response){					
					$.alert(response);			
				}
			});	
	}
	
	function showCellPhonePoint(){
			var cell_phone=$("#cell_phone").val();
			if(cell_phone=="手机号码"){
				$("#cell_phone").attr("style","color:#5a5a5a;");
				$("#cell_phone").val("");
			}		
	} 
	function showEmailPoint(){
		var email=$("#email").val();
		if(email=="邮箱"){
			$("#email").attr("style","color:#5a5a5a;");
			$("#email").val("");
		}		
} 
	
	function checkCellPhone(){
			var cell_phone=$("#cell_phone").val();
			if(cell_phone==""){
				//$("#cell_phone").attr("style","color:#ccc;");
				$("#cell_phone").val("手机号码");
			}		
	} 
	function checkEmail(){
		var email=$("#email").val();
		if(email==""){
			//$("#email").attr("style","color:#ccc;");
			$("#email").val("邮箱");
		}		
	} 
	
	function showCodePoint(){
			var check_code=$("#check_code").val();
			if(check_code=="验证码"){
				$("#check_code").attr("style","color:#5a5a5a;");
				$("#check_code").val("");
			}		
	} 
	
	function checkCode(){
		var check_code=$("#check_code").val();
		if(check_code==""){
			//$("#check_code").attr("style","color:#ccc;");
			$("#check_code").val("验证码");
		}	
	} 
	
	var wait=60;
	function time() {
		if (wait == -1) {
			$("#send_check_code").attr("onclick","sendCellPhone()");
			//$("#send_check_code").onclick = function(){sendCellPhone();};	
			$("#send_check_code").html("发送验证码");	
			wait = 60;
		} else {
			$("#send_check_code").attr("onclick", "");
			$("#send_check_code").html("重新发送(" + wait + ")");
			wait--;
			setTimeout(function() {
				time();
			},
			1000);
		}
	}
	
	function registerMember(){
		if(!jQuery('#addform').validationEngine("validate")){
			return false;
	    }	    
		$("#register_button").attr("onclick", "");
		
		var login_id=$("#login_id").val();
		var passwd=$("#passwd").val();
		var cell_phone=$("#cell_phone").val();
		var check_code=$("#check_code").val();
		var email=$("#email").val();
		var para="login_id="+login_id+"&passwd="+passwd+"&cell_phone="+cell_phone+"&memo="+check_code+"&email="+email;
		var requestUrl ="/gzjky/register/register.do";

		xmlHttp = $.ajax({						
			url: requestUrl,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",		
			error:function(){
				$.alert('注册发生异常！');			
			},success:function(response){	
				if(response.result=="0"){	
					$.alert('注册发生异常！');
				}
				if(response.result=="-1"){	
					$.alert("请先获取手机验证码！");
				}	
				if(response.result=="-2"){	
					$.alert("验证码错误或失效！");	
				}	
				if(response.result=="-3"){		
					$.alert("该用户名已存在！");	
				}
				if(response.result=="-4"){		
					$.alert("该手机号码已存在！");	
				}	
				if(response.result=="-5"){		
					$.alert("该邮箱已存在！");	
				}	
				if(response.result=="1"){	
					window.location.href="register_success.jsp";
				}
			}
			});
			$("#register_button").attr("onclick", "registerMember();");
	}
	
	document.onkeydown=function() {  
		if (window.event.keyCode==13) {
		   $("#register_button").click();
		}
	};  	
</script>

</head>
<body>
	<div class="register">
	    <!--register_header start--> 
     <jsp:include page="/jsp/head.jsp" />
   
    <!--register_header end-->

		<!--register_middle start-->
		<form id="addform">
			<div class="register_middle">
				<div class="register_main">
					<div class="step_register"></div>
					<div class="bg_register">
						<div class="register_title">
							<div class="header">Register New Membership</div>
						</div>
						<div class="register_write">
							<div class="register_write_left">
								<ul>
									<li class="register_input" style="margin-top: 10px"><input
										type="text" value="用户名" name="login_id" id="login_id"
										maxlength="30"
										class="validate[required, minSize[5], maxSize[30], funcCall[alphanumeric]]"
										onblur="checkLoginId()" onfocus="showLoginIdPoint()" /></li>
									<li class="register_prompt" id="login_id_point"
										style="margin-top: 10px"><span class='tBluev'>*</span>长度为5-30个字符，只能由字母、数字以及“_”组成。
									</li>
									<li class="register_input" style="margin-top: 10px"><input
										type="text" value="密码" style="display: block;" name="passwdv"
										id="passwdv" maxlength="20" onfocus="showPasswdPoint()"
										class="validate[required, minSize[6], maxSize[20]]" /> <input
										type="password" value="" style="display: none;" name="passwd"
										id="passwd" maxlength="20"
										class="validate[required, minSize[6], maxSize[20], funcCall[password]]"
										onkeyup="pwdStatusCheck()" onblur="checkPasswd()" />
										<div id="pwdTips" class="tips" style="position: relative">
											<div id="pwdStatus" class="pswState pswState-poor"
												style="display: none">
												<span class="s1">弱</span>
												<span class="s2">中等</span>
												<span class="s3">强</span>
											</div>
										</div></li>
									<li class="register_prompt" id="passwd_point"
										style="margin-top: 10px"><span class='tBluev'>*</span>长度为6-20个字符，请以字母、数字或符号的组合，不要使用单纯字母、数字或字符。
									</li>
									<li class="password_rank"></li>
									<li class="register_input" style="margin-top: 10px"><input
										type="text" value="重复密码" style="display: block;"
										name="re_passwdv" id="re_passwdv" maxlength="20"
										onfocus="showRePasswdPoint()"
										class="validate[required, minSize[6], maxSize[20]]" /> <input
										type="password" value="" style="display: none;"
										name="re_passwd" id="re_passwd" maxlength="20"
										class="validate[required, minSize[6], maxSize[20], equals[passwd]，funcCall[password]]"
										onblur="checkRePasswd()" /></li>
									<!-- <li class="register_prompt" id="re_passwd_point"></li> -->
									
									
									<li class="register_input" style="margin-top: 10px"><input
										type="text" value="邮箱" name="email" id="email"
										class="validate[required, funcCall[email]]"
										onfocus="showEmailPoint();" onblur="checkEmail();"
										maxlength="20" /></li>
									
									<li class="register_input" style="margin-top: 10px"><input
										type="text" value="手机号码" name="cell_phone" id="cell_phone"
										class="validate[required, funcCall[worldtelephone2]]"
										onfocus="showCellPhonePoint();" onblur="checkCellPhone();"
										maxlength="20" /></li>
										
										
									<li class="captcha" style="margin-top: 10px"><a
										href="javascript:void(0)" onclick="sendCellPhone();"
										id="send_check_code" title="发送验证码">发送验证码</a></li>
									<!-- <li class="captcha_prompt" id="cell_phone_point">验证码已发送到您的手机，请注意查收，<span class="tBlue">60秒后重新发送</span></li> -->
									<li class="register_input" style="margin-top: 10px"><input
										type="text" value="验证码" name="check_code" id="check_code"
										class="validate[required, funcCall[number]]"
										onfocus="showCodePoint();" onblur="checkCode();" maxlength="8" /></li>
									<!-- <li class="register_prompt" id="check_code_point"></li> -->
									<li class="btn_reguster"><a href="javascript:void(0)"
										href="javascript:void(0)" onclick="registerMember()"
										name="register_button" id="register_button" title="注册">注册</a></li>
								</ul>
							</div>
							<div class="register_write_right">
								<ul>
									<li class="login_prompt">已经注册，立即登录</li>
									<li class="register_signin"><a href="../login.jsp" title="登录">登录</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
		<!--register_middle end-->

		<!--index_health_bottom start-->
<style>
.tGray_bottom a {
	text-decoration: none;
	color: #ffffff;
}
</style>

		    <!--index_health_bottom start-->
    	 <jsp:include page="/jsp/bottom.jsp" />
    <!--index_health_bottom end-->
	</div>
</body>
</html>
