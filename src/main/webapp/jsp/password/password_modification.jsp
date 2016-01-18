<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/register.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/password.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_bottom.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	<!--
	function MM_jumpMenu(targ,selObj,restore){ //v3.0
	  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
	  if (restore) selObj.selectedIndex=0;
	}
	//-->
	var pwdStrongContext;
	function pwdStatusCheck(){
		
		var passwd=$("#passwd").val();
		
		if(passwd.length<6){
			$("#pwdStatus").attr("style","display:none");
			$("#passwd_point").attr("style","margin-top:0px");
		}
		
		if(passwd.length>=6 && /^\d+$/.test(passwd)){
			$("#passwd_point").attr("style","margin-top:20px");
			$("#pwdStatus").attr("style","display:block");
			$("#pwdStatus").attr("class","pswState pswState-poor");
			pwdStrongContext="弱";
		}
		
		if(passwd.length>=6 && (passwd.search(/[A-Za-z]/)!=-1 || passwd.search(/[^A-Za-z0-9]/)!=-1)){
			$("#pwdStatus").attr("style","display:block");
			$("#passwd_point").attr("style","margin-top:20px");
			$("#pwdStatus").attr("class","pswState pswState-normal");
			pwdStrongContext="中等";
		}
		
		if(passwd.length>=6 && (passwd.search(/[A-Za-z]/)!=-1 && passwd.search(/[^A-Za-z0-9]/)!=-1)){
			$("#pwdStatus").attr("style","display:block");
			$("#passwd_point").attr("style","margin-top:20px");
			$("#pwdStatus").attr("class","pswState pswState-strong");
			pwdStrongContext="强";
		}
	}	

	function showPasswdPoint(){
		$("#passwdv").attr("style","display:none");
		$("#passwd").attr("style","display:block");
		$("#passwd").focus();
		$("#passwd_point").html("<span class='tBluev'>*</span>长度为6-20个字符，请以字母、数字或符号的组合，不要使用单纯字母、数字或字符。");
	}

	function	checkPasswd(){
		var passwd=$("#passwd").val();
		if(passwd==""){
			$("#passwd").attr("style","display:none");	
			$("#passwdv").attr("style","display:block");	
		}
		for(var i=0;i<passwd.length;i++){
			if(passwd.charAt(i)==" "){
				$("#passwd_point").html("<span class='tRed'>*</span>密码不能包含空格！");
				return false;
			}
		}
		if(passwd.length<6||passwd.length>20){
			$("#passwd_point").html("<span class='tRed'>*</span>密码长度在6-20之间！");
			return false;
		}
		var num=0;
		if(passwd.search(/[A-Za-z]/)!=-1)
		{
		  num+=1;
		}
		if(passwd.search(/[0-9]/)!=-1)
		{
		  num+=1;
	    }
		if(passwd.search(/[^A-Za-z0-9]/)!=-1)
		{
		   num+=1;
		}
	    if(num<2 )
		{
			$("#passwd_point").html("<span class='tRed'>*</span>密码只能以数字、字母和字符的组合输入！");
			return false;
		}
		$("#passwd_point").html("<img src='../../images/login/tick.png'/><span style='color:green'>密码强度:"+pwdStrongContext+"</span>");
		$("#pwdStatus").attr("style","display:none");
		$("#passwd_point").attr("style","margin-top:0px");
		return true;
	}

	function showRePasswdPoint(){
		$("#re_passwdv").attr("style","display:none");
		$("#re_passwd").attr("style","display:block");
		$("#re_passwd").focus();
		$("#re_passwd_point").html("<span class='tBluev'>*</span>请重复输入密码。");
	}
	
	function checkRePasswd(){
		var passwd=$("#passwd").val();
		var re_passwd=$("#re_passwd").val();
		if(re_passwd==""){
			$("#re_passwd").attr("style","display:none");	
			$("#re_passwdv").attr("style","display:block");	
		}
		if(re_passwd!=passwd){
			$("#re_passwd_point").html("<span class='tRed'>*</span>两次输入密码不一致，请重新输入！");
			return false;
		}
		if(re_passwd.length<6||re_passwd.length>20){
			$("#re_passwd_point").html("<span class='tRed'>*</span>密码长度在6-20之间！");
			return false;
		}
		$("#re_passwd_point").html("<img src='../../images/login/tick.png'/>");
		return true;
	}
	
	
	function changePasswd(obj){
		$("#confirm_button").attr("onclick", "");
		var login_id="<%=request.getParameter("login_id")%>";
		var passwd=$("#passwd").val();
		if(checkPasswd()&checkRePasswd()&login_id!=null){
			var para="login_id="+login_id+"&passwd="+passwd;

			xmlHttp = $.ajax({						
				url:"/gzjky/findPwd/changePasswd.do",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",		
				error:function(){
					$.alert('密码修改发生异常！',function(){
						window.location.href="forget_pwd.jsp";
					});
					
				},success:function(response){	
					if(response.result=="1"){	
					    $("#passwd").val("");
					    $("#re_passwd").val("");	
						window.location.href="password_success.jsp";
					}
					else{
						$.alert('密码修改发生异常！',function(){
							window.location.href="forget_pwd.jsp";
						});
						
					}
				}
			});	
		}
		
	}
	
	document.onkeydown=function() {  
		if (window.event.keyCode==13) {
		   $("#confirm_button").click();
		}
	};  	
</script>
</head>

<body>
  <div class="register">
    <!--register_header start--> 
    <div class="register_header">
      <div class="bgTop_register">
        <div class="login_out">
          <ul>
           <li class="login_wechat"><a href="javascript:void(0)" title="995120健康服务中心官方微信">官方微信</a></li>
           <li class="login_bolg"><a href="http://weibo.com/5137507355/profile" title="995120健康服务中心官方微博" target="_blank">官方微博</a></li>
           <li class="login_service_phone" title="客服电话">400-0785-120</li>
           <li class="login_top"><a href="/login.html" title="登录">用户登录</a></li>
           <li class="login_register"><a href="/jsp/register/protocol.jsp" title="注册">立即注册</a></li> 
          </ul>
        </div>
        <div class="logo_menu">
          <div class="bgLogo_register">
            <ul>
             <li class="tGraymax">找回密码</li>
             <li class="goHome"><a href="/login.html">返回首页</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <!--register_header end-->
    <!--register_middle start-->
    <div class="register_middle">
      <div class="register_main">
        <div class="bg_register">
          <div class="register_title">
            <ul>
              <li class="titleGreen">找回密码</li>
              <li class="titleGray"></li>
            </ul>
          </div>
          <div class="password_choice">
            <div class="password_modification_left"></div>
            <div class="password_choice_right">
              <ul>
                <li class="register_input">
                	<input type="text" value="新密码"  style="display:block;" name="passwdv" id="passwdv" maxlength="20" onfocus="showPasswdPoint()"/>
                	<input type="password"  value=""  style="display:none;"  name="passwd" id="passwd" maxlength="20" onkeyup="pwdStatusCheck()" onblur="checkPasswd()"/>
                	<div id="pwdTips" class="tips" style="position:relative">
						<div id="pwdStatus" class="pswState pswState-poor" style="display:none;">
							<span class="s1">弱</span>
							<span class="s2">中等</span>
							<span class="s3">强</span>
						</div>
					</div>
                
                </li>
                <li class="register_prompt" id="passwd_point"></li>
                <li class="password_rank"></li>
                <li class="register_input">
                	<input type="text"  value="重复新密码" style="display:block;" name="re_passwdv" id="re_passwdv" maxlength="20" onfocus="showRePasswdPoint()"/>
                	<input type="password" value=""  name="re_passwd" style="display:none;"  id="re_passwd" maxlength="20" onblur="checkRePasswd()"/> 	
                </li>
                <li class="register_prompt" id="re_passwd_point"></li>
                <li class="btn_reguster"><a onclick="changePasswd(this)" name="confirm_button" id="confirm_button" title="确定">确定</a></li>
              </ul>
            </div>  
          </div>   
        </div>
      </div>  
    </div>
    <!--register_middle end-->
    <!--index_health_bottom start-->
    

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
    <!--index_health_bottom start-->
  </div>
</body>
</html>
