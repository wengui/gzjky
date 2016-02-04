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

<script type="text/javascript">
	menuId = "#equipmentBind";
	

	$(function(){
    	jQuery('#memberBindDevice_form').validationEngine("attach",
    	{
    				promptPosition:"topRight",
    				maxErrorsPerField:1,
    				scroll:false,
    				autoPositionUpdate:"true"
    				//binded:false,
    				//showArrow:false,
    		}
    	);
   });
	
	var device_sid;
	var device_bind_code;
	var device_ver;
	var check_sid=false;
	var devicebind_count;
	var device_id;
	function queryVersion(){	
 	
		device_sid=$("#device_sid").val();
		if(device_sid==null||device_sid==""){
			$.alert("请输入设备序列号！");		
			return false;
		}
		
		showScreenProtectDiv(1);
		showLoading();

		var para="device_sid="+device_sid;
		$.ajax({
			url: "/gzjky/device/queryDeviceBySid.do",
			async:true,
			data: para,
			dataType:"json",
			type:"POST",
			complete:function(){
				hideScreenProtectDiv(1); 
				hideLoading();
			}, 
			error:function(){
				$.alert("异常！");
			},success:function(response){
				var deviceBaseInfo=response.result;
				var list = new Array();
				list=response.outBeanList;
				devicebind_count=list.length;
				if(deviceBaseInfo==null){
					$.alert("设备序列号不存在！");		
					$("#commit").attr("disabled",true); 
				}
	
				else{				
					check_sid=true;
					device_ver=  deviceBaseInfo.equipmentversion;	
					device_id = deviceBaseInfo.id;	
					if(device_ver=="108"){	
						if(list.length >1){
							$.alert("该设备已绑定两个账户！");	
							$("#commit").attr("disabled",true); 
						}	
						else if(list.length == 0){
							var str="";
							str+="<li>此次绑定用户：</li>";
							str+="<li class='register_input'>";	
							str+="<input type='text' readonly='readonly' "+"value="+ "${sessionScope.Patient.pname}"+" id='member_login_id1'  name='member_login_id1'   maxlength='30' />";	
							str+="</li>";
							$("#new_user").html(str);	
							$("#commit").attr("disabled",false); 
						}
						else if(list.length == 1){
							if("${sessionScope.Patient.pid}"==list[0].id){
								$.alert("该设备已被绑定！");	
								$("#commit").attr("disabled",true); 
							}
							else{
								var str="";
								str+="<li>已绑定用户：</li>";
								str+="<li class='register_input'>";	
								str+="<input type='text' readonly='readonly' "+"value="+ list[0].patientname+" id='member_login_id1'  name='member_login_id1'   maxlength='30' />";	
								str+="</li>";
								str+="<li>此次绑定用户：</li>";
								str+="<li class='register_input'>";
								str+="<input type='text' readonly='readonly'"+"value="+"${sessionScope.Patient.pname}"+" id='member_login_id2'  name='member_login_id2' maxlength='30'  />";
								str+="</li>";
								$("#new_user").html(str);
								$("#commit").attr("disabled",false); 
							}						
						}						    
					}                                    		              
					else{
						if(list.length >0){
							$.alert("该设备已绑定一个账户！");	
							$("#commit").attr("disabled",true); 
						}
						else{
							
								var str="";
								str+="<li>此次绑定用户：</li>";
								str+="<li class='register_input'>	";
								str+="<input type='text' readonly='readonly'"+"value="+"${sessionScope.Patient.pname}"+" id='member_login_id1'  name='member_login_id1' maxlength='30'  />";
								str+="</li>";
								$("#new_user").html(str);	
						
								$("#commit").attr("disabled",false); 
						}
						  
					} 
				} 		 
			}
		}); 
	} 

	function deviceBinding(){
		
		if(!check_sid){
			$.alert("请检查设备序列号！");
			return false;
		}
		
		if(!jQuery('#memberBindDevice_form').validationEngine("validate")){
			return false;
	    }	
	
		if($("#member_login_id1").val()==undefined){
			return false;
		} 
		
		var member_login_id;
		device_sid=$("#device_sid").val();		
		device_bind_code=$("#device_bind_code").val();
		device_nickname=$("#device_nickname").val();

		var para="device_sid="+device_sid+"&device_bind_code="+device_bind_code+"&count="+devicebind_count +"&device_id="+device_id+"&device_ver="+device_ver
		+"&device_nickname="+device_nickname;
	
		showScreenProtectDiv(1); 
		showLoading();
		$.ajax({
					url: "/gzjky/device/deviceBind.do",
					async:true,
					data: para,
					dataType:"json",
					type:"POST",
					complete:function(){
					    hideScreenProtectDiv(1); 
					    hideLoading();
					}, 
					error:function(){
						$.alert("异常！");
					},success:function(response){
						if(response.message=="绑定成功！"){
							$.alert(response.message,function(){returnEquipment();});
							//returnEquipment();
						}
						else{
							$.alert(response);
						}
					}
				});
	}
	
	function returnEquipment(){
		window.location.href="/gzjky/menuControlAction/equipment.do";
	}
</script>
</head>

<body class="skin-blue">

	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
		<!-- Left side column. contains the logo and sidebar -->
		<%@ include file="../../shared/sidebarMenu.jsp"%>

		<form id="memberBindDevice_form">
			<aside class="right-side"> <!-- Main content --> 
			<section class="content-header">
	             <h1>设备绑定</h1>
	             <ol class="breadcrumb">
	                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
	                  <li>健康档设备</li>
	                  <li class="active">设备绑定</li>
	             </ol>
	         </section> 
			<div class="bp_accouint">
					<div class="box box-danger">
						<div class="box-header">
							<h3 class="box-title">绑定设备</h3>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<ul>
								<div class="form-group">
									<li>设备序列号：</li>
									<li class="register_input"><input type="text"
										id="device_sid" name="device_sid" onblur="queryVersion()"
										maxlength="16" class="validate[required]" /></li>
								</div>
								<div class="form-group">
									<li>设备绑定码：</li>
									<li class="register_input"><input type="text"
										name="device_bind_code" id="device_bind_code" maxlength="6"
										class="validate[required,alphanumeric,rangelength[6,6]]" />
									</li>
								</div>
								
								<div class="form-group">
									<li>设备别名：</li>
									<li class="register_input"><input type="text"
										name="device_nickname" id="device_nickname" />
									</li>
								</div>
								
								<div class="form-group">
									<div id="new_user" name="new_user"></div>
								</div>
								<li><a href="javascript:void(0)" id="commit" class="btn btn-success" disabled=true
									onclick="deviceBinding()"><span>提交</span></a> <a
									class="btn btn-success" href="javascript:void(0)"
									onclick="returnEquipment()"><span>返回</span></a></li>
								<!-- <li class="btn_reguster"><a href="javascript:void(0)" onclick="deviceBinding()">提交</a></li>
	              <li class="btn_reguster"><a href="javascript:void(0)" onclick="returnEquipment()">返回</a></li> -->
							</ul>

						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->
			</div>
		</aside>
		</form>
	</div>
	<div id="divloading">
		<img src="/gzjky/images/public/blue-loading.gif" />
	</div>

	<div id="transparentDiv"></div>

	<div id="transparentDiv2"></div>

</body>

</html>