<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.validate.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/hwin-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.metadata.js'/>" type="text/javascript" ></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	$.metadata.setType("attr", "validate");
	$(function(){$("#editform").validate({
		messages:{
        	'memberDeviceBind.member_login_id':{
			required:"新用户不能为空.",
			alphanumeric:"只能输入字母，数字与下划线."
        	},'memberDeviceBind.member_login_id1':{
			required:"新用户不能为空.",
			alphanumeric:"只能输入字母，数字与下划线."
        	},'memberDeviceBind.member_login_id2':{
			alphanumeric:"只能输入字母，数字与下划线."
        	},'memberDeviceBind.device_bind_code':{
        	required:"绑定码不能为空.",
        	rangelength:"绑定码有效长度为6位.",
			alphanumeric:"只能输入字母，数字与下划线."
       		}
      	}
	});
	});
	
	
	var device_sid;
	var device_bind_code;
	var device_ver;
	var check_sid=false;
	
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
			url: "/deviceBaseInfo/queryDeviceBySid.action",
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
				var modelMap=response.modelMap;
				var deviceBaseInfo=modelMap.deviceBaseInfo;
				if(deviceBaseInfo==null){
					$.alert("设备序列号不存在！");		
				}							
				else{				
					check_sid=true;
					device_ver=  deviceBaseInfo.version;						
					if(device_ver=="108"){		
						var str="";
						str+="<li>绑定新用户A：</li>";
						str+="<li class='register_input'>";	
						str+="<input type='text'  id='member_login_id1'  name='member_login_id1'   maxlength='30' validate='required:true,alphanumeric:true,rangelength:[5,30]'/>";	
						str+="</li>";
						str+="<li>绑定新用户B：</li>";
						str+="<li class='register_input'>";
						str+="<input type='text'  id='member_login_id2'  name='member_login_id2' maxlength='30'  validate='alphanumeric:true,rangelength:[5,30]'/>";
						str+="</li>";

						$("#new_user").html(str);	    
					}                                    	
	              
					else{
						var str="";
						str+="<li>绑定新用户：</li>";
						str+="<li class='register_input'>	";
						str+="<input type='text'  id='member_login_id'  name='member_login_id' maxlength='30'  validate='required:true,alphanumeric:true,rangelength:[5,30]'/>";
						str+="</li>";
						$("#new_user").html(str);	  
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
		if(!$("#memberBindDevice_form").valid()){
			return false;
		} 
		
		var member_login_id;
		device_sid=$("#device_sid").val();		
		device_bind_code=$("#device_bind_code").val();
		
		if(device_ver=="108"){
			var member_login_id1=$("#member_login_id1").val();
			var member_login_id2=$("#member_login_id2").val();
			member_login_id=member_login_id1+";"+member_login_id2;
		}
		else{
			member_login_id=$("#member_login_id").val();
		}
		
		var para="device_sid="+device_sid+"&member_login_id="+member_login_id+"&device_bind_code="+device_bind_code+"&version="+device_ver;
	
		showScreenProtectDiv(1); 
		showLoading();
		$.ajax({
					url: "/deviceBaseInfo/memberBindDevice.action",
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
						if(response=="绑定成功！"){
							$.alert(response,function(){returnEquipment();});
							//returnEquipment();
						}
						else{
							$.alert(response);
						}
					}
				});
	}
	
	function returnEquipment(){
		window.location.href="equipment.jsp";
	}
</script>
</head>
<body>
  <div class="index_tab">   
   <div class="tab_menu">
      <ul>
        <li class="selected">&nbsp;我的设备</li>
      </ul>
   </div>
   <div class="tab_box">
      <div class="">
      	<form id="memberBindDevice_form">
	        <div class="password_information">
	          <div class="title_informationModify"><span class="tgrey_title_informationModify">绑定</span>设备</div>
	          <div class="password_informationMain">
	            <ul>
	              <li>设备序列号：</li>
	              <li class="register_input">
	              	<input type="text"  id="device_sid" name="device_sid"  onblur="queryVersion()"  maxlength="16"  validate="required:true"/>
	              </li>
	              
	              
	              <li>设备绑定码：</li>
	              <li class="register_input">
	              	<input type="text"  name="device_bind_code"   id="device_bind_code" maxlength="6" validate="required:true,alphanumeric:true,rangelength:[6,6]"/>
	              </li>
	              
	              <div id="new_user" name="new_user" >
	              
	              </div>              
	              
	              <li class="btn_popup_confirm3"><a href="javascript:void(0)" onclick="deviceBinding()">提交</a><a href="javascript:void(0)" onclick="returnEquipment()">返回</a></li>
	              <!-- <li class="btn_reguster"><a href="javascript:void(0)" onclick="deviceBinding()">提交</a></li>
	              <li class="btn_reguster"><a href="javascript:void(0)" onclick="returnEquipment()">返回</a></li> -->
	            </ul>
	          </div>
	          
	        </div>
        </form>
      </div>
      <!--password_modification end-->
   </div> 
  </div>
  

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>   
</body>
</html>