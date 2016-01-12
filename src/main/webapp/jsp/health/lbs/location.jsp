<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/location.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.js'/>" type="text/javascript"></script>
<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery/jquery.nicescroll.js'/>"></script>

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
$("#scrollBar").niceScroll({  
	cursorcolor:"#aeaeae",  
	cursoropacitymax:1,  
	touchbehavior:false,  
	cursorwidth:"5px",  
	cursorborder:"0",  
	cursorborderradius:"5px"  
}); 
</script>
<script type="text/javascript">
var tabMap = {};
  $(function(){
    var $div_li = $("div.tab_menu ul li");
	
    $div_li.click(function(){	
	   $(this).addClass("selected").siblings().removeClass("selected");
	   var index = $div_li.index(this);
	   $("div.tab_box > div").eq(index).show().siblings().hide(); 	
	   
	if (index in tabMap) {

			} else {
				if (index == 0) {
					$("#ef_iframe").attr("src", "./electronic_fence.jsp");
				} else if (index == 1) {
					$("#sos_iframe").attr("src", "./sos_alert.jsp");
				}
				tabMap[index] = 1;
			}
		});

		$("table.bPhistory_table tr:even").addClass("even");
		$("table.bPhistory_table tr:odd").addClass("odd");

	})

	function reinitIframe() {
		var iframe = document.getElementById("ef_iframe");
		var iframe_sos = document.getElementById("sos_iframe");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.max(bHeight, dHeight);
			var bHeight_sos = iframe_sos.contentWindow.document.body.scrollHeight;
			var dHeight_sos = iframe_sos.contentWindow.document.documentElement.scrollHeight;
			var height_sos = Math.max(bHeight_sos, dHeight_sos);
			iframe.height = height;
			iframe_sos.height = height_sos;
		} catch (ex) {

		}
	}
	window.setInterval("reinitIframe()", 200);
</script>
</head>

<body>
<div class="example-item alt-color gradient">
<div class="tabs_framed styled" >
    <div class="inner tab_menu">
        <ul class="tabs clearfix active_bookmark1">
            <li class="active"><a href="#ef" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;">电子围栏</a></li>
            <li ><a href="#sos" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;">SOS报警</a></li>
        </ul>

        <div class="tab-content clearfix">
            <div class="tab-pane fade in active" id="ef">
              	<iframe id="ef_iframe" src="./electronic_fence.jsp" frameborder="0" width="100%"  scrolling="no"  onload="sonIframeResize();"></iframe>
            </div>
            <div class="tab-pane fade" id="sos">
                <iframe id ="sos_iframe" src="./sos_alert.jsp" frameborder="0" width="100%"  scrolling="no" onload="sonIframeResize();"></iframe>
            </div>
        </div>
    </div>
</div>
</div>
<!-- 
  <div class="index_tab">
    <div class="tab_menu">
      <ul>
        <li class="selected">电子围栏</li>
        <li>SOS报警</li>
      </ul>
    </div>
    <div class="tab_box">
      <div>
			<iframe id="ef_iframe" frameborder="0" width="100%"  scrolling="no" src="./electronic_fence.jsp"></iframe>
      </div>
      <div class="hide">
        	<iframe id ="sos_iframe"  frameborder="0" width="100%"  scrolling="no"></iframe>
      </div>
    </div>
  </div>
 -->
</body>
</html>
