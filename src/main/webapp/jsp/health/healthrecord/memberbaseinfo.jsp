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
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
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
<script src="<c:url value='/js/dictionaryInfo.js'/>" type="text/javascript"></script>
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
    	queryDictionaryInfo("memberBaseInfo");
    	query_memberBaseInfo();
    	changeImage();
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
	     if(msg == 1) {
	         $.alert("上传头像成功！");
	         
	     } else {
	         $.alert("头像上传失败！");
	     }
	} 
		
    
    function refreshHeadImg(url) {
        //if(url == null) return;
        var Rand = Math.random(); 
        //url = url.replace("995120upload", "");
        //var imgUrl = "http://v3.995120.cn/995120upload" + url + "?rand=" + Rand;
        
        document.getElementById("patientimage").src = "http://localhost:8080/gzjky/imageUploadAction/showHeadImage.do";
        //parent.parent.document.getElementById("memberHeadImg").src = "http://localhost:8080/gzjky/imageUploadAction/showHeadImage.do";
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

<body class="skin-blue" >
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
		<!-- Content Header (Page header) -->
        <section class="content-header">
             <h1>健康档案<small>基本信息</small></h1>
             <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-dashboard"></i> 首页</a></li>
                  <li class="active">基本信息</li>
             </ol>
         </section>
		<!--information_modify start-->
	<div class="information_modify">
    <div class="information_modify_main"  id="main_div">
    <form id="memberBaseInfo_form" class="user_form formular">
      <!--basic_information start-->
      <div class="basic_information">
        <div class="row form-group btn_title_informationModify">
          <div class="form-group">
          	<label class="col-lg-4">基本信息</label>
            <li class="col-lg-8"><a href="javascript:void(0)" onclick="edit_baseinfo(this)"><img src="<c:url value='/images/button/btn_editor.png'/>" /></a></li>
           </div>
          </ul>
        </div>
        <div class="row informationModify_main" >
        <div class="col-lg-4 form-group">
        	<span class="col-lg-4 form-span">*真实姓名：</span>
        	<input class="col-lg-8 display-input validate[required,funcCall[chinaornumer],minSize[1],maxSize[16]] " style="width:230px;height:28px" type="text"  id="patientname"  name="patientname" maxlength="16" />
        </div>
        <div class="col-lg-4">
        	<span class="col-lg-4 form-span">*性别：</span>
        	<select  class="col-lg-8 display-input selectMax_informationModify  validate[required]"  id="dictSex"  name="dictSex"></select>
        </div>
        </div>
          
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
                <span class="select-style_baseinfo">
	                <select class="selectMax_informationModify"  id="certiType"  name="certiType"  onchange="change_credentials_type(this)">
	                </select>
	                </span>
	            </li>
	           <li class="tgrey_informationDetailed">是否军人：</li>
                <li class="tblack_informationDetailed">
                <span class="select-style_baseinfo">
                	<select class="selectMax_informationModify" id="issoldier"  name="issoldier">
                	<option value="1">是</option>
	                <option value="0">否</option>
	                </select>
	                </span>
                </li>
                <li class="tgrey_informationDetailed">身高(cm)：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMin_informationModify text-input validate[funcCall[pyheight]]"  style="width:230px;height:28px" type="text"  id="height"   name="height"  maxlength="3" />
                </li>
                <li class="tgrey_informationDetailed">民族：</li>
                <!-- <li class="tblack_informationDetailed">
                	   <input class="inputMin_informationModify text-input validate[funcCall[chinese]]" type="text"  id="tribe"  name="tribe"  maxlength="32" />
                </li>  --> 
				<li class="tblack_informationDetailed">
						<span class="select-style_baseinfo">
						<select class="selectMax_informationModify" id="nationalityCodeDict"  name="nationalityCodeDict" >
						</select>
						</span>
                </li>
                <li class="tgrey_informationDetailed">婚姻状况：</li>
                <li class="tblack_informationDetailed">
                	<span class="select-style_baseinfo">
	                <select class="selectMax_informationModify" id="maritalStatusDict"  name="maritalStatusDict" >
	                </select>
	                </span>
                </li>                     
                <li class="tgrey_informationDetailed">学历：</li>
                <li class="tblack_informationDetailed">
                	<span class="select-style_baseinfo">
	                <select class="selectMax_informationModify" id="userAcademic" name="userAcademic"  >
	                </select>
	                </span>
                </li>
                <li class="tgrey_informationDetailed">家庭电话：</li>
                <li class="tblack_informationDetailed">
                	<input class="inputMin_informationModify text-input validate[funcCall[telephone]]" style="width:230px;height:28px" type="text" id="telephone"  name="telephone"  />
                </li>   
	            <li class="tgrey_informationDetailed">家庭地址：</li>
	            <li class="tblack_informationDetailed">
	            	<input class="inputMax_informationModify text-input validate[funcCall[includespecialchar]]" style="width:555px;height:28px" type="text"  id="homeaddress"  name="homeaddress"  maxlength="128"  />
	            </li>                             
              </ul>
            </li>
            <li class="detailed_information_right">
              <ul>
                <li class="tgrey_informationDetailed">证件号码：</li>
                <li class="tblack_informationDetailed">
                	<input class="inputMin_informationModify  validate[funcCall[includespecialchar]]"  style="width:230px;height:28px" type="text"  maxlength="18" id="cardnum" name="cardnum"  />
                </li>
                <li class="tgrey_informationDetailed">是否残疾：</li>
                <li class="tblack_informationDetailed">
                	<span class="select-style_baseinfo">
                	<select class="selectMax_informationModify" id="isdisability"  name="isdisability" >
	                <option value="0">否</option>
	                <option value="1">是</option>
	                </select>
	                </span>
                </li>
                <li class="tgrey_informationDetailed">体重(kg)：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMin_informationModify text-input validate[funcCall[pyweight]]" type="text"  style="width:230px;height:28px" id="weight" name="weight"  maxlength="3" />
                </li>
                <li class="tgrey_informationDetailed">籍贯：</li>
                <li class="tblack_informationDetailed">
                	   <input class="inputMin_informationModify text-input validate[funcCall[chinese]]" type="text"  style="width:230px;height:28px" id="nativeplace"  name="nativeplace" maxlength="64" />
                </li>                  
                <li class="tgrey_informationDetailed">户籍类型：</li>
                <li class="tblack_informationDetailed">
                	<span class="select-style_baseinfo">
	                <select class="selectMax_informationModify" id="censusRegDict"  name="censusRegDict" >
	                </select>
	                </span>
                </li>    
                <li class="tgrey_informationDetailed">政治面貌：</li>
                <li class="tblack_informationDetailed">
                	<span class="select-style_baseinfo">
	                <select class="selectMax_informationModify" id="politicalAffiliatio"  name="politicalAffiliatio">
	                </select>
	                </span>
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
                	<span class="select-style_baseinfo">
	                <select class="selectMax_informationModify" id="workingyear" name="workingyear">
	                </select>
	                </span>
                </li>
                <li class="tgrey_informationDetailed">公司名称：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMax_informationModify validate[funcCall[includespecialchar]]" style="width:230px;height:28px" type="text"  id="companyname"  name="companyname"  maxlength="64" />
                </li>
                <li class="tgrey_informationDetailed">公司地址：</li>
                <li class="tblack_informationDetailed">
					<input class="inputMax_informationModify validate[funcCall[includespecialchar]]" style="width:555px;height:28px" type="text"  id="companyaddress"  name="companyaddress"  maxlength="120"  />
                </li>
              </ul>
            </li>
            <li class="detailed_information_right">
              <ul>
                <li class="tgrey_informationDetailed">薪酬：</li>
                <li class="tblack_informationDetailed">
                	<span class="select-style_baseinfo">
	                <select class="selectMax_informationModify" id="moneyForYear"  name="moneyForYear">
	                </select>
	                </span>
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
	<img src="../../../images/public/blue-loading.gif" />
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
		var obj_file = document.getElementById("filePath");  
		var maxsize = 1024*1024;//1M  
        var errMsg = "上传的附件文件不能超过1M！！！";  
        var tipMsg = "您的浏览器暂不支持计算上传文件的大小，确保上传文件不要超过1M，建议使用IE、FireFox、Chrome浏览器。";  
		
		var headImageReflag = false;
		
		if(filePath == "") {
			$.alert("请先选择一个图片文件！");
			document.getElementById("filePath").focus();
			return false;
		}
		
		var  browserCfg = {};  
        var ua = window.navigator.userAgent;  
        if (ua.indexOf("MSIE")>=1){  
            browserCfg.ie = true;  
        }else if(ua.indexOf("Firefox")>=1){  
            browserCfg.firefox = true;  
        }else if(ua.indexOf("Chrome")>=1){  
            browserCfg.chrome = true;  
        }
        
		var filesize = 0;  
        if(browserCfg.firefox || browserCfg.chrome ){  
            filesize = obj_file.files[0].size;  
        }else if(browserCfg.ie){  
            var obj_img = document.getElementById('tempimg');  
            obj_img.dynsrc=obj_file.value;  
            filesize = obj_img.fileSize;  
        }else{  
            alert(tipMsg);  
        return false;  
        }  
        
        if(filesize>maxsize){  
            alert(errMsg);  
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
		winload();
        callback(1);
        closeDiv();
        
	}
	
	function changeImage(){
		$("#patientimage").attr("src","<c:url value='/imageUploadAction/showHeadImage.do'/>");
		//parent.parent.document.getElementById("memberHeadImg").src = "<c:url value='/imageUploadAction/showHeadImage.do'/>";
	}
	
	function winload(){ 
		setTimeout("window.location.reload(true)",1500);

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
  <form id="upload_form" action="/gzjky/imageUploadAction/uploadHeadImage.do" method="post"  enctype="multipart/form-data"  target="hidden_frame">
  <div class="popup_main">
    <ul>
      <li class="img_upload">
      	<input type="file" id="filePath" name="filePath" ><br/>
      </li>
      <li class="btn_upload"><a href="javascript:void(0)"  class="btn" onclick="upload()"><span style="font-size:13px;color:#5a5a5a">上传</span></a></li>  
      <li class="tgreen_bpPrompt">图像文件类型只限JPG、PNG、GIF、BMP等常见格式，大小不超过2M</li>
      <li><iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe></li>
    </ul>
  </div>
  </form>
 </div>
</aside><!-- /.right-side -->
</body>
</html>
</body>
</html>
