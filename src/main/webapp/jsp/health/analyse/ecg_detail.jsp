<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script type="text/javascript" src="<c:url value='/js/base.js'/>"></script>
<script type="text/javascript">
   var hly_url=  "http://v3.995120.cn:7090/hly_svr";
	function query(){
		var url = "/gzjky/historyAction/queryEcgRecordDetail.action";
		var para = "device_version=&file_unit_id=&file_cluster_id=&file_unit_type=";
		
		 showScreenProtectDiv(1);
		 showLoading();
		 xmlHttp = $.ajax({
			 url:url,
			 async:true,
			 data:para,
			 dataType:"json",
			 type:"POST",
			 complete:function(){
				 hideScreenProtectDiv(1);
			     hideLoading();
			 },
			 error:function(){
				 $.alert('无权限');
			 },
			 success:function(response){
				   var modelMap = response.modelMap;
				   var detail = modelMap.ecgRecordDetail;
				   if(detail != null){
					   $("#ecg_image").attr("src",hly_url+detail["file_storage_path"].replace("/helowindata/tomcat/webapps/hly_svr","")+"-I.jpg");
					   $("span").each(function(index,obj){
						   var obj_id = obj.id;
						   if(obj_id != ""){
							   $(obj).text(detail[obj_id]);
						   }
					   });
				   }
			 }
		 });
	}
	function goback() {
		//window.location.href = "/jsp/health/analyse/ianalysis.jsp?tabIndex=1";
		//flag是否是通过返回按钮到某个页面
		window.location.href = "<c:url value='/jsp/health/analyse/ianalysis.jsp?tabIndex=1&flag=1'/>";
	}
</script>

</head>

<body onload="query()">
  <div class="ecg" id="ecg_detail" >
    <div class="ecg_title">
      <ul>
        <li class="ecg_titleGreen">心电详情</li>
        <li class="ecg_titleGray"></li>
      </ul>
    </div>
    <div class="ecg_main">
      <li><div style="width: 670px;height:300px;overflow:auto"><img id="ecg_image" /></div></li> <br/>
      <li class="tgreen_ecg">诊断结论</li>
      <li class="tGrey_ecgname">心率：</li>
      <li class="tblack_ecgname"><span></span><br/></li>
      <li class="tGrey_ecgname">采集时间：</li>
      <li class="tblack_ecgname"><span id="collection_time"></span><br/></li>
      <li class="tGrey_ecgname">分析时间：</li>
      <li class="tblack_ecgname"><span id="upload_time"></span><br/></li>
      <li class="tGrey_ecgname">采集时长：</li>
      <li class="tblack_ecgname"><span id="record_count"></span>秒<br/></li>
      <li class="tGrey_ecgname">分析结果：</li>
      <li class="tblack_ecgname"><span id="analyse_result"></span><br/></li>
      <li class="tGrey_ecgname">保健建议：</li>
      <li class="tblack_ecgname"><span id="suggestion"></span><br/></li>
      <li class="tGrey_ecgname">诊断医师：</li>
      <li class="tblack_ecgname"><span id="doctor_name"></span><br/></li>   
      <li class="btn_goback"><a href="javascript:void(0)" onclick="goback()">返回</a></li>   
    </div>
    

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
  </div>
</body>
</html>
