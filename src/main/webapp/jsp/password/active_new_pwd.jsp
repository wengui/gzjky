<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>找回密码</title>
  </head>
  <body onload="javascript:document.forms[0].submit();">
  	<form id="activePwd" name="activePwd" action="/gzjky/findPwd/activePwd.do" method="post">
  		<input type="hidden" name="sign" id="sign" value=<%=request.getParameter("sign")%>>
  	</form>
    
  </body>
</html>
