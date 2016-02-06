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

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

	document.onkeydown=function() {  
		if (window.event.keyCode==13) {
		    window.location.href="/login.html";
		}
	};
	var i = 5; //倒计时变量  
	function reloadView()  
	{                                  
	    document.getElementById("tag").innerHTML=i;  
	    if(i == 0)  
	    {  
	        window.location.href="/gzjky/jsp/login.jsp";  
	    }  
	    i -= 1;  
	    window.setTimeout("reloadView()",1000);  
	}  

</script>
</head>

<body onload="reloadView();">
  <div class="register">
    <!--register_header start--> 
     <jsp:include page="/jsp/head.jsp" />
   
    <!--register_header end-->
    <!--register_middle start-->
    <div class="register_middle">
      <div class="register_main">
        <div class="bg_register">
          <div class="register_success">
            <ul>
              <li class="tgreen_success">密码修改成功</li>
              <li><a href="../login.jsp" title="立即登录">立即登录</a><span class="line_success">|</span><a href="/login.html" title="返回首页">返回首页</a></li>
              <li>
               <span id="tag" style="color: red;font-size: 25">5</span>  
   						秒钟之后，自动跳转
              </li>
            </ul>
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
 	 <jsp:include page="/jsp/bottom.jsp" />
    <!--index_health_bottom start-->
    <!--index_health_bottom start-->
  </div>
</body>
</html>
