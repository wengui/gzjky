<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>心电详情</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<c:url value='/js/base.js'/>"></script>
<script type="text/javascript">
   var hly_url=  "http://gzjky.sh-sdhr.com/upload/Electrocardiograms/";
	function query(){
		var url = "/gzjky/historyAction/queryEcgRecordDetail.do";
		var para = "id=" + ${param.id};
		
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
				   var detail = response.result;
				   if(detail != null){
					   $("#ecgImage").attr("src",hly_url+detail["ecgImage"].replace("~/upload/Electrocardiograms/",""));
					   $("span").each(function(index,obj){
						   var obj_id = obj.id;
						   if(obj_id != ""){
							   $(obj).text(detail[obj_id]);
						   }
					   });
				   }else{
					   alert('无权限');
				   }
			 }
		 });
	}
	function goback() {
		//window.location.href = "/jsp/health/analyse/ianalysis.jsp?tabIndex=1";
		//flag是否是通过返回按钮到某个页面
		window.location.href = "<c:url value='/jsp/health/analyse/ecg.jsp'/>";
	}
</script>

</head>

<body onload="query()" class="skin-blue">
<!-- header logo: style can be found in header.less -->
<%@ include file="../../shared/pageHeader.jsp"%>
<div class="wrapper row-offcanvas row-offcanvas-left">
	<!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
	<!-- Content Header (Page header) -->
        <section class="content-header">
             <h1>心电历史</h1>
             <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li>健康分析</li>
                  <li>心电历史</li>
                  <li class="active">心电详情</li>
             </ol>
         </section>
		<!--bp_history start-->
		<div class="bp_accouint">
		  <div class="box box-success">
              <div class="box-header">
                  <h3 class="box-title">心电详情</h3>
              </div>	
              <div class="box-body">
              	<div class="row">
				  <div class="col-lg-10" id="ecg_detail" >
				    <div class="col-lg-10">
				    <input value="" name="id" id="id" type="hidden"/>
				      <li class="text-right"><a href="javascript:void(0)" class="btn btn-success" onclick="goback()">返回</a></li>
				       <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa  fa-stethoscope "></i>
                                    <h3 class="box-title ">心电图</h3>
                                </div><!-- /.box-header -->   
				      				<li><div style="height:350px;overflow:auto"><img id="ecgImage" /></div></li> <br/>
				      </div>
				      <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-file-text-o "></i>
                                    <h3 class="box-title ">诊断结论</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <dl class="dl-horizontal text-info">
                                        <dt>心率：</dt>
                                        <dd><span id="heartRate"></span></dd>
                                        <dt>采集时间：</dt>
                                        <dd><span id="collectionTime"></span></dd>
                                        <dt>分析时间：</dt>
                                        <dd><span id="uploadTime"></span></dd>
                                        <dt>采集时长：</dt>
                                        <dd><span id="recordCount"></span>秒</dd>
                                        <dt>分析结果：</dt>
                                        <dd><span id="analyseResult"></span></dd>
                                        <dt>保健建议：</dt>
                                        <dd><span id="suggestion"></span></dd>
                                        <dt>诊断医师：</dt>
                                        <dd><span id="doctorName"></span></dd>
                                    </dl>
                                </div><!-- /.box-body -->
                      </div>
				    </div>
				  </div>
				</div>
				</div>
			</div>
		</div>
	</aside><!-- /.right-side -->
</div><!-- ./wrapper -->
<!--bp_history end-->
<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>
<div id="transparentDiv" ></div>
<div id="transparentDiv2"></div>
</body>
</html>
