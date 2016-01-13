<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" type="text/css"/>
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<!-- <script type="text/javascript" src="<c:url value='/js/page/jquery.validate.js'/>"></script> -->
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="<c:url value='/js/page/validationEngine-additional-methods.js'/>"></script>
<!-- <script type="text/javascript" src="<c:url value='/js/page/jquery.metadata.js'/>"></script> -->
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script type="text/javascript">
   var edit_image = "<c:url value='/images/button/btn_editor.png'/>";
   var save_image = "<c:url value='/images/button/btn_preserve.png'/>";
   var basic_form_id =  "memberBaseInfo_form";
    var detail_form_id = "detail_form";
    var workinfo_form_id = "workinfo_form";
    
    $(function(){
    	$("#"+basic_form_id+" :input").attr("disabled",true);
    	$("#"+detail_form_id+" :input").attr("disabled",true);
    	$("#"+workinfo_form_id+" :input").attr("disabled",true);
    	query_memberBaseInfo();
    	jQuery('#memberBaseInfo_form').validationEngine("attach",
    			{
    				promptPosition:"centerRight:0,-10",
    				maxErrorsPerField:1,
    				scroll:false
    				//binded:false,
    				//showArrow:false,
    			}
    	);
    	
    	jQuery('#detail_form').validationEngine("attach",
    			{
    				promptPosition:"topRight:-100,20",
    				maxErrorsPerField:1,
    				scroll:false
    				//binded:false,
    				//showArrow:false,
    			}
    	);
    	jQuery('#workinfo_form').validationEngine("attach",
    			{
    				promptPosition:"topRight:-100,20",
    				maxErrorsPerField:1,
    				scroll:false
    				//binded:false,
    				//showArrow:false,
    			}
    	);
    })
    function query_memberBaseInfo(){
    	var requestUrl = "/gzjky/healthRecordAction/queryMemberBaseInfo.do";
    	var para = "unit_id=" + window.parent.member_unit_id + "&cluster_id=" + window.parent.member_cluster_id + "&unit_type=" + window.parent.member_unit_type;
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
			    memberBaseInfo = response.result;
			    init_memberBaseInfo(memberBaseInfo);
			}
		});
    }
    
    function init_memberBaseInfo(memberBaseInfo){
    	$("#main_div :input").each(function(index,obj){
    		var id = obj.id;
    		if(id in memberBaseInfo){
    			$("#main_div #"+id).val(memberBaseInfo[id]);
    			if(id=="credentials_type" && $("#main_div #"+id).val()=="身份证"){
    				//$("#main_div #cardnum").rules("add",{idcade:true});
    				$("#main_div #cardnum").addClass("validate[funcCall[idcade]]");
    			}
    		}
    	});
    }

    /*
    	id为div的id,obj按钮对象
    */
    function send_request(formId,obj,requestUrl,para){
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
			    var state = response.updateFlag;
			    var returnMessage=response.message;
			    if(state == "1"){
			    	if(formId == "memberBaseInfo_form"){
				    	var memberName = $("#patientname").val();
		    			var left_memberName = top.document.getElementById("left_memberName");
		    			
		    			var simpleMemberName = memberName;
		    			if(simpleMemberName.length>5){
		    				simpleMemberName = simpleMemberName.substring(0,5)+"..";
		    			}
		    			left_memberName.innerHTML = simpleMemberName;
		    			left_memberName.title = memberName;
			    	}
	    			
			    	obj.onclick = function(){
			    		if(formId == "memberBaseInfo_form"){
			    			edit_baseinfo(obj);
			    		}else if(formId == "detail_form"){
			    			edit_detail(obj);
			    		}else if(formId == "workinfo_form"){
			    			edit_workinfo(obj);
			    		}
			    	};
			    	//按钮变成编辑图标，元素变成不可以编辑
			    	$("#"+formId+" :input").attr("disabled",true);
					$(obj).find("img").attr("src",edit_image);
					$.alert(returnMessage);
			    }else{
			    	$.alert(returnMessage);
			    }
			}
		});
    }
    
	//基本信息编辑
	function edit_baseinfo(obj){
		obj.onclick = function(){save_baseinfo(obj);}
		$("#"+basic_form_id+" :input").attr("disabled",false);
		$(obj).find("img").attr("src",save_image);
		
	}
	//基本信息保存
	function save_baseinfo(obj){
		//if(!$("#"+basic_form_id).valid()) return false;
		if(!jQuery('#memberBaseInfo_form').validationEngine('validate')) return false;
		var url = "/gzjky/healthRecordAction/editMemberBaseInfo.do";
		var para = get_requestPara(basic_form_id);
		send_request(basic_form_id,obj,url,para);
	}
	//详细
	function edit_detail(obj){
		obj.onclick = function(){save_detail(obj);}
		$("#"+detail_form_id+" :input").attr("disabled",false);
		$(obj).find("img").attr("src",save_image);
	}
	function save_detail(obj){
		//if(!$("#"+detail_form_id).valid()) return false;
		if(!jQuery('#detail_form').validationEngine('validate')) return false;
		var url = "/gzjky/healthRecordAction/editMemberDetail.do";
		var para = get_requestPara(detail_form_id);
		send_request(detail_form_id,obj,url,para);
	}
	//工作信息
	function edit_workinfo(obj){
		obj.onclick = function(){save_workinfo(obj);}
		$("#"+workinfo_form_id+" :input").attr("disabled",false);
		$(obj).find("img").attr("src",save_image);
	}
	function save_workinfo(obj){
		//if(!$("#"+workinfo_form_id).valid()) return false;
		if(!jQuery('#workinfo_form').validationEngine('validate')) return false;
		var url = "/gzjky/healthRecordAction/editMemberWorkInfo.do";
		var para = get_requestPara(workinfo_form_id);
		send_request(workinfo_form_id,obj,url,para);
	}
	
	function edit_photo() {
		$('#popWindow').draggable({
			disabled : true
		});
		$("#popWindow").show(200);
		showScreenProtectDiv(1);
		$("#filePath").val("");
	}
	function closeDiv() {
		$("#popWindow").hide(200);
		hideScreenProtectDiv(1);
	}
	
	
	
	function callback(msg){  
	     if(msg == 0) {
	         $.alert("上传头像成功！");
	         
	     } else {
	         $.alert(msg);
	     }
	} 
		
    
    function refreshHeadImg(url) {
        if(url == null) return;
        var Rand = Math.random(); 
        url = url.replace("995120upload", "");
        var imgUrl = "http://v3.995120.cn/995120upload" + url + "?rand=" + Rand;
        
        document.getElementById("patientimage").src = imgUrl;
        parent.parent.document.getElementById("memberHeadImg").src = imgUrl;
        closeDiv();
    }
    
    function change_credentials_type(obj){
    	//validator.resetForm();
    	$("#main_div #cardnum").validationEngine("hide");
    	var obj_value = $(obj).val();
    	var credential_validate = {idcade:true};
    	if(obj_value=="身份证"){
    		$("#main_div #cardnum").addClass("validate[funcCall[idcade]]");
    		//$("#main_div #cardnum").rules("add",credential_validate);
    	}else{
    		//$("#main_div #cardnum").rules("remove");
    		$("#main_div #cardnum").removeClass("validate[funcCall[idcade]]")
    	}
    }

	var formdic = {"memberBaseInfo_form":1,"detail_form":1,"workinfo_form":1}
	function get_requestPara(formId){
		var para = "";
		$("#"+formId+" :input").each(function(index,obj){
			para += obj.id+"=" +obj.value + "&";
		});
		
		para += "unit_id=" + window.parent.member_unit_id + "&cluster_id=" + window.parent.member_cluster_id + "&unit_type=" + window.parent.member_unit_type
				+ "&login_id=" + window.parent.member_login_id;
		return para.substring(0,para.length);
	}
</script>
</head>

<body>
<div class="information_modify">
    <div class="title_informationModify"><span class="tgrey_title_informationModify">基本</span>信息</div>
    <div class="information_modify_main"  id="main_div">
    <form id="memberBaseInfo_form" class="user_form formular">
      <!--basic_information start-->
      <div class="basic_information">
        <div class="btn_title_informationModify">
          <ul>
            <li class="tLeft">基本信息</li>
            <li class="tRight"><a href="javascript:void(0)" onclick="edit_baseinfo(this)"><img src="<c:url value='/images/button/btn_editor.png'/>" /></a></li>
          </ul>
        </div>
        <div class="informationModify_main" >
          <ul>
           <li class="tLeft_informationModify">
             <ul>
               <li class="tgrey_informationModify">*真实姓名：</li>
               <li class="tblack_informationModify">
               		<input class="inputMin_informationModify text-input validate[required,funcCall[chinaornumer],minSize[1],maxSize[16]] " type="text"  id="patientname"  name="patientname" maxlength="16" />
               </li>
               <li class="tgrey_informationModify">*性别：</li>
               <li class="tblack_informationModify">
	               <select  class="selectMax_informationModify  text-input validate[required]"  id="patientsex"  name="patientsex">
	                   <option value="">请选择</option>
		               <option value="0">男</option>
		               <option value="1">女</option>
	               </select>
	           </li>
               <li class="tgrey_informationModify">*出生日期：</li>
               <li class="tblack_informationModify">
               		<input class="inputMin_informationModify text-input validate[required]"  type="text"   id="patientbirthday"  name="patientbirthday"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-%d',errDealMode:2})" />
               </li>
               <li class="tgrey_informationModify">*手机号：</li>
               <li class="tblack_informationModify">
              		 <input class="inputMin_informationModify text-input validate[required,funcCall[mobilephone]]" type="text"  id="patientphone"  name="patientphone"   />
               </li>
               <li class="tgrey_informationModify">*电子邮箱：</li>
               <li class="tblack_informationModify">
               		<input class="inputMin_informationModify text-input validate[required,custom[email]]" type="text"  id="email"   name="email"   />
               </li>
             </ul>
           </li>
           <li class="tRight_informationModify">
             <ul>
               <li><img height="80" id="patientimage" src="/images/health/default_head.gif?t=1452044932829" /></li>
               <li class="thead_informationModify"><a href="javascript:void(0)" onclick="edit_photo()">修改头像</a></li>
             </ul>
           </li>
          </ul>
        </div> 
      </div>
      </form>
      <form id="detail_form">
      <!--detailed_information start-->
      <div class="detailed_information">
        <div class="btn_title_informationModify">
          <ul>
            <li class="tLeft">详细信息</li>
            <li class="tRight"><a href="javascript:void(0)"  onclick="edit_detail(this)"><img src="<c:url value='/images/button/btn_editor.png'/>" /></a></li>
          </ul>
        </div>
        <div class="informationModify_main">
          <ul>
            <li class="detailed_information_left">
              <ul>
                <li class="tgrey_informationDetailed">证件类型：</li>
                <li class="tblack_informationDetailed">
	                <select class="selectMax_informationModify"  id="cardtype"  name="cardtype"  onchange="change_credentials_type(this)">
	                    <option value="">请选择</option>
	                	<option value="身份证">身份证</option>
	                	<option value="驾驶证">驾驶证</option>
	                	<option value="学生证">学生证</option>
	                	<option value="护照">护照</option>
	                	<option value="军官证">军官证</option>
	                	<option value="港澳通行证">港澳通行证</option>
	                </select>
	            </li>
	           <li class="tgrey_informationDetailed">是否军人：</li>
                <li class="tblack_informationDetailed">
                	<select class="selectMax_informationModify" id="issoldier"  name="issoldier">
	                	<option value="1">是</option>
	                	<option value="0">否</option>
	                </select>
                </li>
                <li class="tgrey_informationDetailed">身高(cm)：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMin_informationModify text-input validate[funcCall[pyheight]]"  type="text"  id="height"   name="height"  maxlength="3" />
                </li>
                <li class="tgrey_informationDetailed">民族：</li>
                <!-- <li class="tblack_informationDetailed">
                	   <input class="inputMin_informationModify text-input validate[funcCall[chinese]]" type="text"  id="tribe"  name="tribe"  maxlength="32" />
                </li>  --> 
				<li class="tblack_informationDetailed">
						<select class="selectMax_informationModify" id="patientnational"  name="patientnational" >
							<option value="">请选择</option>
							
							<option value="汉族">汉族</option>
							
							<option value="蒙古族">蒙古族</option>
							
							<option value="回族">回族</option>
							
							<option value="藏族">藏族</option>
							
							<option value="维吾尔族">维吾尔族</option>
							
							<option value="苗族">苗族</option>
							
							<option value="彝族">彝族</option>
							
							<option value="壮族">壮族</option>
							
							<option value="布依族">布依族</option>
							
							<option value="朝鲜族">朝鲜族</option>
							
							<option value="满族">满族</option>
							
							<option value="侗族">侗族</option>
							
							<option value="瑶族">瑶族</option>
							
							<option value="白族">白族</option>
							
							<option value="土家族">土家族</option>
							
							<option value="哈尼族">哈尼族</option>
							
							<option value="哈萨克族">哈萨克族</option>
							
							<option value="傣族">傣族</option>
							
							<option value="黎族">黎族</option>
							
							<option value="傈僳族">傈僳族</option>
							
							<option value="佤族">佤族</option>
							
							<option value="畲族">畲族</option>
							
							<option value="高山族">高山族</option>
							
							<option value="拉祜族">拉祜族</option>
							
							<option value="水族">水族</option>
							
							<option value="东乡族">东乡族</option>
							
							<option value="纳西族">纳西族</option>
							
							<option value="景颇族">景颇族</option>
							
							<option value="柯尔克孜族">柯尔克孜族</option>
							
							<option value="土族">土族</option>
							
							<option value="达斡尔族">达斡尔族</option>
							
							<option value="仫佬族">仫佬族</option>
							
							<option value="羌族">羌族</option>
							
							<option value="布朗族">布朗族</option>
							
							<option value="撒拉族">撒拉族</option>
							
							<option value="毛南族">毛南族</option>
							
							<option value="仡佬族">仡佬族</option>
							
							<option value="锡伯族">锡伯族</option>
							
							<option value="阿昌族">阿昌族</option>
							
							<option value="普米族">普米族</option>
							
							<option value="塔吉克族">塔吉克族</option>
							
							<option value="怒族">怒族</option>
							
							<option value="乌孜别克族">乌孜别克族</option>
							
							<option value="俄罗斯族">俄罗斯族</option>
							
							<option value="鄂温克族">鄂温克族</option>
							
							<option value="德昂族">德昂族</option>
							
							<option value="保安族">保安族</option>
							
							<option value="裕固族">裕固族</option>
							
							<option value="京族">京族</option>
							
							<option value="塔塔尔族">塔塔尔族</option>
							
							<option value="独龙族">独龙族</option>
							
							<option value="鄂伦春族">鄂伦春族</option>
							
							<option value="赫哲族">赫哲族</option>
							
							<option value="门巴族">门巴族</option>
							
							<option value="珞巴族">珞巴族</option>
							
							<option value="基诺族">基诺族</option>
							
							<option value="其它未识别民族">其它未识别民族</option>
							
							<option value="外国人入中国籍">外国人入中国籍</option>
							
						</select>
                </li>
                <li class="tgrey_informationDetailed">婚姻状况：</li>
                <li class="tblack_informationDetailed">
	                <select class="selectMax_informationModify" id="marriagestatus"  name="marriagestatus" >
	                	<option value="0">未婚</option>
	                	<option value="2">已婚</option>
	                	<option value="1">离异</option>
	                </select>
                </li>                     
                <li class="tgrey_informationDetailed">学历：</li>
                <li class="tblack_informationDetailed">
	                <select class="selectMax_informationModify" id="education" name="education"  >
		                <option value="">请选择</option>
					    <option value="初中">初中</option>
						<option value="高中">高中</option>
						<option value="中技">中技</option>
						<option value="中专">中专</option>
						<option value="大专">大专</option>
						<option value="本科">本科</option>
						<option value="MBA">MBA</option>
						<option value="硕士">硕士</option>
						<option value="博士">博士</option>
						<option value="其他">其他</option>
	                </select>
                </li>
                <li class="tgrey_informationDetailed">家庭电话：</li>
                <li class="tblack_informationDetailed">
                	<input class="inputMin_informationModify text-input validate[funcCall[telephone]]" type="text" id="telephone"  name="telephone"  />
                </li>   
	            <li class="tgrey_informationDetailed">家庭地址：</li>
	            <li class="tblack_informationDetailed">
	            	<input class="inputMax_informationModify text-input validate[funcCall[includespecialchar]]" type="text"  id="homeaddress"  name="homeaddress"  maxlength="128"  />
	            </li>                             
              </ul>
            </li>
            <li class="detailed_information_right">
              <ul>
                <li class="tgrey_informationDetailed">证件号码：</li>
                <li class="tblack_informationDetailed">
                	<input class="inputMin_informationModify  validate[funcCall[includespecialchar]]" type="text"  maxlength="18" id="cardnum" name="cardnum"  />
                </li>
                <li class="tgrey_informationDetailed">是否残疾：</li>
                <li class="tblack_informationDetailed">
                	<select class="selectMax_informationModify" id="isdisability"  name="isdisability" >
                		<option value="0">否</option>
	                	<option value="1">是</option>
	                </select>
                </li>
                <li class="tgrey_informationDetailed">体重(kg)：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMin_informationModify text-input validate[funcCall[pyweight]]" type="text"  id="weight" name="weight"  maxlength="3" />
                </li>
                <li class="tgrey_informationDetailed">籍贯：</li>
                <li class="tblack_informationDetailed">
                	   <input class="inputMin_informationModify text-input validate[funcCall[chinese]]" type="text"  id="nativeplace"  name="nativeplace" maxlength="64" />
                </li>                  
                <li class="tgrey_informationDetailed">户籍类型：</li>
                <li class="tblack_informationDetailed">
	                <select class="selectMax_informationModify" id="householdtype"  name="householdtype" >
			              <option value="">请选择</option>
						  <option value="0">城市</option>
						  <option value="1">农村</option>
	                </select>
                </li>    
                <li class="tgrey_informationDetailed">政治面貌：</li>
                <li class="tblack_informationDetailed">
	                <select class="selectMax_informationModify" id="political"  name="political">
	              		<option value="">请选择</option>
						<option value="中共党员">中共党员</option>
						<option value="共青团员">共青团员</option>
						<option value="民主党派成员">民主党派成员</option>
						<option value="群众">群众</option>
	                </select>
                </li>                    
              </ul>
            </li>
          </ul>
        </div>
      </div>
      </form>
      <form id="workinfo_form">
      <!--job_information start-->
      <div class="detailed_information">
        <div class="btn_title_informationModify">
          <ul>
            <li class="tLeft">工作信息</li>
            <li class="tRight"><a href="javascript:void(0)" onclick="edit_workinfo(this)"><img src="<c:url value='/images/button/btn_editor.png'/>" /></a></li>
          </ul>
        </div>
        <div class="informationModify_main">
          <ul>
            <li class="detailed_information_left">
              <ul>
                <li class="tgrey_informationDetailed">工作年限：</li>
                <li class="tblack_informationDetailed"> 
	                <select class="selectMax_informationModify" id="workyears" name="workyears">
	                	<option value="">请选择</option>
						<option value="1-2年">1-2年</option>
						<option value="3年以上">3年以上</option>
	                </select>
                </li>
                <li class="tgrey_informationDetailed">公司名称：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMax_informationModify validate[funcCall[includespecialchar]]" type="text"  id="companyname"  name="companyname"  maxlength="64" />
                </li>
                <li class="tgrey_informationDetailed">公司地址：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMax_informationModify validate[funcCall[includespecialchar]]" type="text"  id="companyaddress"  name="companyaddress"  maxlength="120"  />
                </li>
              </ul>
            </li>
            <li class="detailed_information_right">
              <ul>
                <li class="tgrey_informationDetailed">薪酬：</li>
                <li class="tblack_informationDetailed">
	                <select class="selectMax_informationModify" id="annualincome"  name="annualincome">
	                	<option value="">请选择</option>
						<option value="1">2万以下</option>
						<option value="2">2-5万</option>
						<option value="3">5-8万</option>
						<option value="4">8-10万</option>
						<option value="5">10-15万</option>
						<option value="6">15-30万</option>
						<option value="7">30-50万</option>
						<option value="8">50-100万</option>
						<option value="9">100万以上</option>
	                </select>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
      <!--job_information end-->
      </form>
    </div>
</div>
 

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script type="text/javascript">
	function upload(){
		var filePath = document.getElementById("filePath").value;
		
		if(filePath == "") {
			$.alert("请先选择一个图片文件！");
			document.getElementById("filePath").focus();
			return false;
		}
		var importFileType = filePath.substring(filePath.lastIndexOf(".")+1,filePath.length).toLowerCase();
		if(importFileType != "gif" && importFileType != "bmp" && importFileType != "jpeg" && importFileType != "png" && importFileType != "jpg"){
			$.alert("请选择图片文件！");
			document.getElementById("filePath").focus();
			return false;
		}
		//$("#upload_form").submit(); 
		var upload_form = document.getElementById("upload_form");
		upload_form.submit();
	}
</script>
</head>
<body>
 <div class="popup" id="popWindow" style="display:none;position:absolute;top:200px; left:100px;z-index: 30;height:300">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">上传头像</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv();">X</a></li>
    </ul>
  </div>
  <form id="upload_form" action="/gzjky/jsp/health/healthrecord/upload_member_head_img.jsp" method="post"  enctype="multipart/form-data"  target="hidden_frame">
  <div class="popup_main">
    <ul>
      <li class="img_upload">
      	<input class="inputMin_informationModify" type="file"  id="filePath"   name="filePath"  />
      </li>
      <li class="btn_upload"><a href="javascript:void(0)" onclick="upload()">上传</a></li>  
      <li class="tgreen_bpPrompt">图像文件类型只限JPG、PNG、GIF、BMP等常见格式，大小不超过2M</li>
      <li><iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe></li>
    </ul>
  </div>
  </form>
 </div>

</body>
</html>
</body>
</html>
