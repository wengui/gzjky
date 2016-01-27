<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<%@ include file="../shared/importCss.jsp"%>
<%@ include file="../shared/importJs.jsp"%>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/password.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_bottom.css'/>" rel="stylesheet" type="text/css" />


<script type="text/javascript">


</script>
</head>

<body>
  <div class="register">
    <!--register_header start--> 
     <jsp:include page="/jsp/head.jsp" />
   
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
                <li class="tPassword_mail">已发送邮件至您绑定邮箱：<%=request.getParameter("mail") %></li>
                <li class="tPassword_mail">邮件24小时内有效，请尽快登录您的邮箱点击连接进行修改</li>
                <li class="tPassword_mail"><a href="http://mail.<%=request.getParameter("mail").split("@")[1]%>">立即登录邮箱</a></li>
                <li class="tgrayPassword_mail">没收到邮件？<br />请检查广告箱或垃圾箱，邮件有可能被误认为垃圾或广告邮件。</li>
              </ul>
            </div>  
          </div>   
        </div>
      </div>  
    </div>
    <!--register_middle end-->
    <!--index_health_bottom start-->
    	 <jsp:include page="/jsp/bottom.jsp" />
    <!--index_health_bottom end-->
  </div>
</body>
</html>
