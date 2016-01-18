<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>

<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/password.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_bottom.css'/>" rel="stylesheet" type="text/css" />
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
<script type="text/javascript">


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
           <li class="login_service_phone" title="客服电话" >400-0785-120</li>
           <li class="login_top"><a href="../login.jsp" title="登录">用户登录</a></li>
           <li class="login_register"><a href="../register/register.jsp" title="注册">立即注册</a></li> 
          </ul>
        </div>
        <div class="logo_menu">
          <div class="bgLogo_register">
            <ul>
             <li class="tGraymax">找回密码</li>
             <li class="goHome"><a href="../login.jsp">返回首页</a></li>
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
    <div class="index_health_bottom">
      <div class="bottom_main">
        <div class="bottom_contact">
          <ul>
            <li class="tWhite"><span class="tGreen">Contact us</span>联系我们</li>
            <li class="tGray_bottom">地址：浙江省杭州市西湖区西斗门路天堂软件园E幢13楼</li>
            <li class="tGray_bottom">客服热线：400-0785-120</li>
            <li class="tGray_bottom">13楼总机：0571—89938332  传真转8006</li>
            <li class="tGray_bottom">7楼总机：0571-81902353  传真转8006</li>
            <li class="tGray_bottom">网址：www.helowin.cn</li>
            <li class="tGray_bottom">邮箱：helowin@163.com</li>
          </ul>
        </div>
        <div class="bottom_help">
          <ul>
            <li class="tWhite"><span class="tGreen">Question</span>常见问题</li>
            <li class="taqueation_left"><a href="###">用户注册</a></li>
            <li class="taqueation_middle"><a href="###">设备绑定</a></li>
            <li class="taqueation_right"><a href="###">找回密码</a></li>
            <li class="taqueation_left"><a href="###">投诉建议</a></li>
            <li class="taqueation_middle"><a href="###">设备报修</a></li>
            <li class="taqueation_right"><a href="###">退货/换货</a></li>
          </ul>
        </div>
        <div class="bottom_concern">
          <ul>
            <li class="tWhite"><span class="tGreen">Concern us</span>关注我们</li>
            <li class="wechat_code">官方微信</li>
            <li class="blog_code">官方微博</li>
          </ul>
        </div>
        <div class="copyright">Copyright ? 2010-2013 浙江好络维物联网络技术有限公司版权所有  浙ICP备10212076号</div>
      </div>
    </div>
    <!--index_health_bottom start-->
  </div>
</body>
</html>
