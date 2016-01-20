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

<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet"/>
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet"/>
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>
<script type="text/javascript">
	$.metadata.setType("attr", "validate");
	$(function(){$("#memberBindDevice_form").validate({
		messages:{
        	'member_login_id':{
			required:"新用户不能为空.",
			alphanumeric:"只能输入字母，数字与下划线."
        	},'member_login_id1':{
			required:"新用户不能为空.",
			alphanumeric:"只能输入字母，数字与下划线."
        	},'member_login_id2':{
			alphanumeric:"只能输入字母，数字与下划线."
        	},'device_bind_code':{
        	required:"绑定码不能为空.",
        	rangelength:"绑定码有效长度为6位.",
			alphanumeric:"只能输入字母，数字与下划线."
       		}
      	},
      	errorPlacement: function(error, element) { 
      	     error.appendTo(element.parent()); 
      	}
	});
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
				}
	
				else{				
					check_sid=true;
					device_ver=  deviceBaseInfo.equipmentversion;	
					device_id = deviceBaseInfo.id;	
					if(device_ver=="108"){	
						if(list.length >1){
							$.alert("该设备已绑定两个账户！");		
						}	
						else if(list.length == 0){
							var str="";
							str+="<li>此次绑定用户：</li>";
							str+="<li class='register_input'>";	
							str+="<input type='text' readonly='readonly' "+"value="+ "${sessionScope.Patient.pname}"+" id='member_login_id1'  name='member_login_id1'   maxlength='30' />";	
							str+="</li>";
							$("#new_user").html(str);	
						}
						else if(list.length == 1){
							if("${sessionScope.Patient.pid}"==list[0].id){
								$.alert("该设备已被绑定！");	
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
							}						
						}						    
					}                                    		              
					else{
						if(list.length >0){
							$.alert("该设备已绑定一个账户！");		
						}
						else{
							if("${sessionScope.Patient.pid}"==list[0].id){}
							else{
								var str="";
								str+="<li>此次绑定用户：</li>";
								str+="<li class='register_input'>	";
								str+="<input type='text' readonly='readonly'"+"value=222 " +" id='member_login_id'  name='member_login_id' maxlength='30'  />";
								str+="</li>";
								$("#new_user").html(str);	
							}
							
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
		if(!$("#memberBindDevice_form").valid()){
			return false;
		} 
		
		if($("#member_login_id1").val()==undefined){
			return false;
		} 
		
		var member_login_id;
		device_sid=$("#device_sid").val();		
		device_bind_code=$("#device_bind_code").val();
		

		var para="device_sid="+device_sid+"&device_bind_code="+device_bind_code+"&count="+devicebind_count +"&device_id="+device_id+"&device_ver="+device_ver;
	
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
		window.location.href="equipment.jsp";
	}
</script>
</head>
<body>
<div class="example-item alt-color gradient">
  <div class="tabs_framed styled" >
    <div class="inner tab_menu">
       <ul class="tabs clearfix active_bookmark1">
            <li class="active"><a href="#mb" data-toggle="tab" hidefocus="true" class="gradient" style="outline: none;">我的设备</a></li>
       </ul>
	   <div class="tab-content clearfix">
	     <div class="tab-pane fade in active" id="eq">
      	<div class="">
      	<form id="memberBindDevice_form">
	        <div class="password_information">
	          <div class="tgreen_title_BPhistory">绑定设备</div>
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
	              <li><a href="javascript:void(0)" class="btn" onclick="deviceBinding()"><span style="font-size:17px; font-weight:500;color:#5a5a5a;width:140px">提交</span></a>
                  	 <a class="btn"href="javascript:void(0)" onclick="returnEquipment()"><span style="font-size:17px; font-weight:500;color:#5a5a5a;width:140px">返回</span></a></li>
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
    </div>
  </div>
</div>
  

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>   
</body>
</html>