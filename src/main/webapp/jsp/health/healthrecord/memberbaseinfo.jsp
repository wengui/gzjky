<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>基本信息</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet"  type="text/css"/>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/dictionaryInfo.js'/>" type="text/javascript"></script>
<script type="text/javascript">

   menuId = "#baseinfo";
   var edit_image = "<a class='btn btn-success'><i class='fa fa-edit'></i> 编辑</a>";
   var save_image = "<a class='btn btn-success'><i class='fa fa-save'></i> 保存</a>";
   var basic_form_id =  "memberBaseInfo_form";
   var detail_form_id = "detail_form";
   var workinfo_form_id = "workinfo_form";
    
   function startInit(){
	   
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
    }
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
    function send_request(formId,obj,requestUrl,para,formflag){
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
		    			//var left_memberName = top.document.getElementById("left_memberName");
		    			
		    			var simpleMemberName = memberName;
		    			if(simpleMemberName.length>5){
		    				simpleMemberName = simpleMemberName.substring(0,5)+"..";
		    			}
		    			//left_memberName.innerHTML = simpleMemberName;
		    			//left_memberName.title = memberName;
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
			    	
			    	if(formflag == 0){
			    		$("#saveImage").empty();
			    		$("#saveImage").html(edit_image);
			    	}else if(formflag == 1){
			    		$("#detailImage").empty();
			    		$("#detailImage").html(edit_image);
			    	}else if(formflag == 2){
			    		$("#workImage").empty();
			    		$("#workImage").html(edit_image);
			    	}
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
		$("#saveImage").empty();
		$("#saveImage").html(save_image);
		
	}
	//基本信息保存
	function save_baseinfo(obj){
		//if(!$("#"+basic_form_id).valid()) return false;
		if(!jQuery('#memberBaseInfo_form').validationEngine('validate')) return false;
		var url = "/gzjky/healthRecordAction/editMemberBaseInfo.do";
		var para = get_requestPara(basic_form_id);
		send_request(basic_form_id,obj,url,para,0);
	}
	//详细
	function edit_detail(obj){
		obj.onclick = function(){save_detail(obj);}
		$("#"+detail_form_id+" :input").attr("disabled",false);
		$("#detailImage").empty();
		$("#detailImage").html(save_image);
	}
	function save_detail(obj){
		//if(!$("#"+detail_form_id).valid()) return false;
		if(!jQuery('#detail_form').validationEngine('validate')) return false;
		var url = "/gzjky/healthRecordAction/editMemberDetail.do";
		var para = get_requestPara(detail_form_id);
		send_request(detail_form_id,obj,url,para,1);
	}
	//工作信息
	function edit_workinfo(obj){
		obj.onclick = function(){save_workinfo(obj);}
		$("#"+workinfo_form_id+" :input").attr("disabled",false);
		$("#workImage").empty();
		$("#workImage").html(save_image);
	}
	function save_workinfo(obj){
		//if(!$("#"+workinfo_form_id).valid()) return false;
		if(!jQuery('#workinfo_form').validationEngine('validate')) return false;
		var url = "/gzjky/healthRecordAction/editMemberWorkInfo.do";
		var para = get_requestPara(workinfo_form_id);
		send_request(workinfo_form_id,obj,url,para,2);
	}
	
	function edit_photo() {
		$('#selectImage').draggable({
			disabled : true
		});
		$("#selectImage").modal('show');
		//showScreenProtectDiv(1);
		$("#filePath").val("");
	}
	function closeDiv() {
		$("#selectImage").modal('hide');
		//hideScreenProtectDiv(1);
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

<body class="skin-blue" onload="startInit()" >
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
		<!-- Content Header (Page header) -->
        <section class="content-header">
             <h1>基本信息</h1>
             <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li>健康档案</li>
                  <li class="active">基本信息</li>
             </ol>
         </section>
	<div class="bp_accouint" id="main_div">
		  <div class="box box-success">
              <div class="box-header">
                  <h3 class="box-title">基本信息</h3>
              </div>		
              <div class="box-body">
				    <div>
					    <form id="memberBaseInfo_form" class="user_form formular">
					      <!--basic_information start-->
					        <div class="row form-group btn_title_informationModify">
					          	<div class="col-lg-8 text-right" id="saveImage" href="javascript:void(0)" onclick="edit_baseinfo(this)">
					          		<a class="btn btn-success">
					                   <i class="fa fa-edit"></i> 编辑
					             	</a>
					            </div>
					        </div>
					        <div class="row" >
					        <div class="col-lg-8">
					        	<div class="form-group">
							        <div class="col-lg-6">
							        	<span class="col-lg-4 text-right  form-span">*真实姓名：</span>
							        	<input class="col-lg-8 display-input validate[required,funcCall[chinaornumer],minSize[1],maxSize[16]] " type="text"  id="patientname"  name="patientname" maxlength="16" />
							        	<lable class="col-lg-4 text-right form-span">*性别：</lable>
							        	<select  class="col-lg-8 display-input selectMax_informationModify  validate[required]"  id="dictSex"  name="dictSex"></select>
							        	<span class="col-lg-4 text-right  form-span">*出生日期：</span>
							        	<input class="col-lg-8 display-input validate[required]"  type="text"   id="patientbirthday"  name="patientbirthday"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-%d',errDealMode:2})" />
							        	<lable class="col-lg-4 text-right form-span">*手机号：</lable>
							        	<input class="col-lg-8 display-input validate[required,funcCall[mobilephone]]"  type="text"  id="patientphone"  name="patientphone"   />
							        	<span class="col-lg-4 text-right  form-span">*电子邮箱：</span>
							        	<input class="col-lg-8 display-input validate[required,custom[email]]" type="text"  id="email"   name="email"   />

							        </div>
							        <div class="col-lg-6">
							           <ul class="text-center">
							               <li><div calss="image-detail"><img height="200px" id="patientimage" src="<c:url value='/imageUploadAction/showHeadImage.do'/>" /></div></li>
							               <li class="thead_informationModify"><a href="javascript:void(0)" class="btn btn-success" onclick="edit_photo()">修改头像</a></li>
					         		   </ul>
							        </div>
						        </div>
					        </div>
				        </div>
			      </form>
			  </div>
			</div>
		</div>
			<div class="box box-info ">
              <div class="box-header">
                  <h3 class="box-title">详细信息</h3>
              </div>		
              <div class="box-body">
			      <form id="detail_form">

				         <div class="row form-group btn_title_informationModify">
					          	<div class="col-lg-8 text-right" id="detailImage" href="javascript:void(0)" onclick="edit_detail(this)">
					          		<a class="btn btn-success">
					                   <i class="fa fa-edit"></i> 编辑
					             	</a>
					            </div>
 						</div>
	 			         <div class="row">
					         <div class="col-lg-8">
						        <div class="col-lg-6">
						        	<span class="col-lg-4 text-right  form-span" >证件类型：</span>
						        	<select class="display-input selectMax_informationModify col-lg-8"  id="certiType"  name="certiType"  onchange="change_credentials_type(this)">
					                </select>
						        </div>
						        <div class="col-lg-6">
						        	<lable class="col-lg-4 text-right form-span">证件号码：</lable>
						        	<input class="col-lg-8 display-input validate[funcCall[includespecialchar]]"  type="text"  maxlength="18" id="cardnum" name="cardnum"  />
						        </div>

						        <div class="col-lg-6">
						        	<span class="col-lg-4 text-right  form-span">是否军人：</span>
						        	<select class="col-lg-8 display-input selectMax_informationModify" id="issoldier"  name="issoldier">
				                	<option value="1">是</option>
					                <option value="0">否</option>
					                </select>
						        </div>
						        <div class="col-lg-6">
						        	<lable class="col-lg-4 text-right form-span">是否残疾：</lable>
						        	<select class="col-lg-8 display-input selectMax_informationModify" id="isdisability"  name="isdisability" >
					                <option value="0">否</option>
					                <option value="1">是</option>
					                </select>
						        </div>
						        <div class="col-lg-6">
						        	<span class="col-lg-4 text-right form-span">身高(cm)：</span>
						        	<input class="col-lg-8 display-input inputMin_informationModify validate[funcCall[pyheight]]"  type="text"  id="height"   name="height"  maxlength="3" />
						        </div>
						        <div class="col-lg-6">
						        	<lable class="col-lg-4 text-right form-span">体重(kg)：</lable>
						        	<input class="col-lg-8 display-input inputMin_informationModify validate[funcCall[pyweight]]" type="text"  id="weight" name="weight"  maxlength="3" />
						        </div>
						        <div class="col-lg-6">
						        	<span class="col-lg-4 text-right  form-span">民族：</span>
									<select class="col-lg-8 display-input selectMax_informationModify" id="nationalityCodeDict"  name="nationalityCodeDict" >
									</select>
						        </div>
						        <div class="col-lg-6">
						        	<lable class="col-lg-4 text-right form-span">籍贯：</lable>
						        	<input class="col-lg-8 display-input inputMin_informationModify validate[funcCall[chinese]]" type="text" id="nativeplace"  name="nativeplace" maxlength="64" />
						        </div>
						        <div class="col-lg-6">
						        	<span class="col-lg-4 text-right  form-span">婚姻状况：</span>
						        	<select class="col-lg-8 display-input selectMax_informationModify" id="maritalStatusDict"  name="maritalStatusDict" >
					                </select>
						        </div>
						        <div class="col-lg-6">
						        	<lable class="col-lg-4 text-right form-span">户籍类型：</lable>
						        	<select class="col-lg-8 display-input selectMax_informationModify" id="censusRegDict"  name="censusRegDict" >
					                </select>
						        </div>
						        <div class="col-lg-6">
						        	<span class="col-lg-4 text-right  form-span">学历：</span>
						        	<select class="col-lg-8 display-input selectMax_informationModify" id="userAcademic" name="userAcademic"  >
					                </select>
						        </div>
						        <div class="col-lg-6">
						        	<lable class="col-lg-4 text-right form-span">政治面貌：</lable>
						        	<select class="col-lg-8 display-input selectMax_informationModify" id="politicalAffiliatio"  name="politicalAffiliatio">
					                </select>
						        </div>
						        <div class="col-lg-6">
						        	<span class="col-lg-4 text-right form-span">家庭电话：</span>
						        	<input class="col-lg-8 display-input inputMin_informationModify text-input validate[funcCall[telephone]]" type="text" id="telephone"  name="telephone"  />
						        </div>
						        <div class="col-lg-6">&nbsp;</div>
						        <div  class="col-lg-12">
						        	<span class="col-lg-2 text-right form-span">家庭地址：</span>
						        	<input class="col-lg-10 display-input inputMax_informationModify text-input validate[funcCall[includespecialchar]]" type="text"  id="homeaddress"  name="homeaddress"  maxlength="128"  />
						        </div>
				        </div>
			        </div>
			      </form>
			   </div>
			</div>
			<div class="box box-warning">
              <div class="box-header">
                  <h3 class="box-title">工作信息</h3>
              </div>		
              <div class="box-body">
			      <form id="workinfo_form">
			      <!--job_information start-->
			      <div class="detailed_information">
			          <div class="row form-group btn_title_informationModify">
			          	<div class="col-lg-8 text-right" id="workImage" href="javascript:void(0)" onclick="edit_workinfo(this)">
			          		<a class="btn btn-success">
			                   <i class="fa fa-edit"></i> 编辑
			             	</a>
			            </div>
			        </div>
			        
			        <div class="row informationModify_main" >
			          <div class="col-lg-8">
			        	<div class="form-group">
					        <div class="col-lg-6">
					        	<span class="col-lg-4 text-right form-span">工作年限：</span>
					        	 <select class="col-lg-8 display-input selectMax_informationModify" id="workingyear" name="workingyear">
				                </select>
					        </div>
					        <div class="col-lg-6">
					        	<lable class="col-lg-4 text-right form-span">薪酬：</lable>
					        	<select class="col-lg-8 display-input selectMax_informationModify" id="moneyForYear"  name="moneyForYear">
				                </select>
					        </div>
				        </div>
				        
				        <div class="form-group">
					        <div class="col-lg-6">
					        	<span class="col-lg-4 text-right  form-span">公司名称：</span>
					        	<input class="col-lg-8 display-input inputMax_informationModify validate[funcCall[includespecialchar]]" type="text"  id="companyname"  name="companyname"  maxlength="64" />
					        </div>
					        <div class="col-lg-6">&nbsp;</div>
				        </div>
				        <div class="form-group">
					        <div class="col-lg-12 form-div-add">
					        	<span class="col-lg-2 text-right form-span">公司地址：</span>
					        	<input class="display-input text-input inputMax_informationModify validate[funcCall[includespecialchar]]" style="width:83%" type="text"  id="companyaddress"  name="companyaddress"  maxlength="120"  />
					        </div>
				        </div>
			        </div>
			        </div>
			      </div>
			      <!--job_information end-->
			      </form>
			   </div>
			</div>
    </div>
</div>
 

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 

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
<div class="modal fade" id="selectImage" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%" >
  <div class="modal-dialog">	
	  <div class="popup_header">
	    <ul>
	      <li class="name_popupHeader">上传头像</li>
	      <li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal">X</a></li>
	    </ul>
	  </div>
	  <form id="upload_form" action="/gzjky/imageUploadAction/uploadHeadImage.do" method="post"  enctype="multipart/form-data"  target="hidden_frame">
	  <div class="popup_main">
	    <ul>
	      <li class="img_upload">
	      	<input type="file" class="btn btn-info" id="filePath" name="filePath" >
	      </li>
	      <li class="tgreen_bpPrompt">图像文件类型只限JPG、PNG、GIF、BMP等常见格式，大小不超过1M</li><br/><br/>
	      <li class="btn_upload"><a href="javascript:void(0)"  class="btn btn-info"  onclick="upload()">上传</a></li>  
	      <li><iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe></li>
	    </ul>
	  </div>
  	</form>
 </div>
</div>
</aside><!-- /.right-side -->
</body>
</html>
