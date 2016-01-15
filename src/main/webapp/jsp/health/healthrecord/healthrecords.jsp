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

<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>

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
        
		var iframe = document.getElementById("mbi");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.min(bHeight, dHeight);
			iframe.height = height;
		} catch (ex) {
		    
		}
		var iframe = document.getElementById("dh");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.min(bHeight, dHeight);
			iframe.height = height;
			
		} catch (ex) {
		    
		}
		var iframe = document.getElementById("fp");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.min(bHeight, dHeight);
			iframe.height = height;
			
		} catch (ex) {
		    
		}
		var iframe = document.getElementById("mp");
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

<div class="example-item alt-color gradient">
<div class="tabs_framed styled" >
    <div class="inner tab_menu">
        <ul class="tabs clearfix active_bookmark1">
            <li class="active"><a href="#memberbaseinfo" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;" title="基本信息"">基本信息</a></li>
            <li ><a href="#disease_history" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;"  title="健康病历">健康病历</a></li>
            <li ><a href="#family_phone" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;"  title="亲情号码">亲情号码</a></li>
            <li ><a href="#modify_password" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;" title="密码修改">密码修改</a></li>
        </ul>

        <div class="tab-content clearfix">
            <div class="tab-pane fade in active" id="memberbaseinfo">
              	<iframe id="mbi"  src="./memberbaseinfo.jsp" frameborder="0" width="100%"  scrolling="no"  onload="sonIframeResize();"></iframe>
            </div>
            <div class="tab-pane fade" id="disease_history">
                <iframe id ="dh" src="./disease_history.jsp" frameborder="0" width="100%"  scrolling="no" onload="sonIframeResize();"></iframe>
            </div>
            <div class="tab-pane fade" id="family_phone">
                <iframe id ="fp" src="./family_phone.jsp" frameborder="0" width="100%"  scrolling="no" onload="sonIframeResize();"></iframe>
            </div>
            <div class="tab-pane fade" id="modify_password">
                <iframe id ="mp" src="./modify_password.jsp" frameborder="0" width="100%"  scrolling="no" onload="sonIframeResize();"></iframe>
            </div>
        </div>
    </div>
</div>
</div>
</body>
</html>
