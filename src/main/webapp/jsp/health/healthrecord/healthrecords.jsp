<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/healthRecords.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	var member_unit_id = "24913";;
	var member_cluster_id = "1";
	var member_unit_type = "2"
	var member_login_id = "test1";
	var doctor_unit_id = "24913";
	var doctor_cluster_id = "1";
	var doctor_unit_type = "2";

	  $(function(){
	    var $div_li = $("div.tab_menu ul li");
		
	   $div_li.click(function(){	
		   $(this).addClass("selected").siblings().removeClass("selected");
		});
	   
		
	  });


    function sonIframeResize() {
        
		var iframe = document.getElementById("indexFrame");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.min(bHeight, dHeight);
			iframe.height = height;
		} catch (ex) {
		    
		}
	}
	window.setInterval("sonIframeResize()", 200); 

</script>
</head>

<body>
  <div class="index_tab">   
   <div class="tab_menu">
      <ul>
        <li class="selected"><a style="width:166px; height: 48px; display:block;text-decoration:none;color:#fff; " href="./memberbaseinfo.jsp" target="indexFrame" title="基本信息" >基本信息</a></li>
        <li><a style="width:166px; height: 48px; display:block; text-decoration:none;color:#fff; " href="./disease_history.jsp" target="indexFrame" title="健康病历">健康病历</a></li>
        <li><a style="width:166px; height: 48px; display:block;text-decoration:none;color:#fff; " href="./family_phone.jsp" target="indexFrame" title="亲情号码">亲情号码</a></li>
        <li style="margin-right:-2px;"><a style="width:166px; height: 48px; display:block;text-decoration:none;color:#fff; " href="./modify_password.jsp" target="indexFrame" title="密码修改">密码修改</a></li>
      </ul>
   </div>
   <div class="tab_box" >
       <iframe id="indexFrame"  name = "indexFrame" src="./memberbaseinfo.jsp"  frameborder="0" width="100%"  scrolling="no"  onload="sonIframeResize();"></iframe>
   </div> 
  </div>   
   
</body>
</html>
