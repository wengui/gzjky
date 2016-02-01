<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>

<script type="text/javascript">
menuId = "#pwd";
	$(function(){
		jQuery('#changePwd_form').validationEngine("attach",
		    	{
		    				promptPosition:"centerRight:0,-10",
		    				maxErrorsPerField:1,
		    				scroll:false
		    				//binded:false,
		    				//showArrow:false,
		    		}
		    	);
	});
	  function changePwd(){
		   //if(!$("#changePwd_form").valid()){
			if(!jQuery('#changePwd_form').validationEngine("validate")){
				return false;
		   }
		  var requestUrl = "/gzjky/findPwd/changePwdByUser.do";
		  var para = $("#changePwd_form").dataForJson({prefix:''});
	  	   showScreenProtectDiv(1);
		   showLoading();
	    	xmlHttp = $.ajax({
				url: requestUrl,
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
				},success:function(response){
				    var modelMap = response;
				    var state = modelMap.result;
				    if(state == "1"){
				    	$.alert("修改成功");
				    }else if(state == "-1"){
				    	$.alert("输入旧密码不正确");
				    }else{
				    	$.alert("修改失败");
				    }
				}
			});
	  }
</script>
</head>
<body class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
		<!-- Left side column. contains the logo and sidebar -->
		<%@ include file="../../shared/sidebarMenu.jsp"%>


			<aside class="right-side"> <!-- Main content --> 
			 <section class="content-header">
	             <h1>密码修改</h1>
	             <ol class="breadcrumb">
	                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
	                  <li>健康档案</li>
	                  <li class="active">密码修改</li>
	             </ol>
	         </section> 
	         <div class="bp_accouint">
					<div class="box box-info">
						<div class="box-header">
							<h3 class="box-title">密码修改</h3>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<form id="changePwd_form">
								
									<div class="box-group">
										<ul>
											<li>旧密码：</li>
											<li class="register_input"><input type="password"
												id="oldPwd" name="oldPwd"
												class="validate[required,minSize[6],maxSize[20],funcCall[filterSpecialSign]]" style="margin-top: 10px"
												 /></li>
											<li style="margin-top: 10px">新密码：</li>
											<li class="register_input"><input type="password"
												id="newPwd" name="newPwd"
												class="validate[required,minSize[6],maxSize[20],funcCall[password]]" 
												 /></li>
											<li style="margin-top: 10px">确认新密码：</li>
											<li class="register_input"><input type="password"
												id="confirmPwd" name="confirmPwd"
												class="validate[required,minSize[6],maxSize[20],equals[newPwd],funcCall[password]]" 
												/></li>
											<li style="margin-top: 10px" class="btn_reguster"  ><a onclick="changePwd()" 
												class="btn btn-success" style="cursor: pointer;"><span
													>确定</span></a></li>
										</ul>
									</div>
							
							</form>
						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->
			</div>
		</aside>
	</div>
	<div id="divloading">
		<img src="../../../images/public/blue-loading.gif" />
	</div>
	<div id="transparentDiv"></div>
	<div id="transparentDiv2"></div>
</body>
</html>