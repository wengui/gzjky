<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120医生服务中心</title>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>
<script type="text/javascript">
var member_unit_id = "24913";
var member_cluster_id = "1";
var member_unit_type = "2"
var member_login_id = "";
var doctor_unit_id = "24913";
var doctor_cluster_id = "1";
var doctor_unit_type = "2"
var edit_image = "<c:url value='/images/button/btn_editor.png'/>";
var save_image = "<c:url value='/images/button/btn_preserve.png'/>";

$(function(){
	var $div_hrli = $("div.healthRecords_menu_yuan ul li");
	//健康病史页签
	var tab_map = {0:1};
	//健康病史页签加载函数
	//var function_map = {0:"query_memberBaseInfo",1:"queryMemberHabit",2:"queryMemberFamilyDisease",
	//								3:"queryMemberHtComplication",4:"queryMemberIllnessHistory",5:"queryMemberHtSpecial",6:"queryMemberMedicalExaminationList"};
	var iframe_map = {0:"memberHabitIframe",1:"memberFamilyDiseaseIframe",
									2:"memberHtComplicationIframe",3:"memberIllnessHistoryIframe",4:"memberHtSpecialIframe",
									5:"memberMedicalExamintaionIframe",6:"healthTestIframe"};
	var page_map = {0:"memberhabit",1:"memberfamilydisease",
									2:"memberhtcomplication",3:"memberIllnessHistory",4:"memberhtspecial",
									5:"medicalexamination",6:""};
									//5:"medicalexamination",6:"http://zijin.995120.cn/jktj/hasControl/index.htm?patientId=24913"};
	$div_hrli.click(function(){	
	   $(this).addClass("selected_healthRecords_yuan").siblings().removeClass("selected_healthRecords_yuan");
	   var index = $div_hrli.index(this);
	   $("div.tab_healthRecords_box > div").eq(index).show().siblings().hide(); 

	   //页签已经加载
		if(index in tab_map){
			   
		}else{
		    //var fn = function_map[index];
		   var frame_sel = iframe_map[index];
		    var page = page_map[index];
		    if(index == 6){
		    	document.getElementById(frame_sel).src = page;
		    }else{
		    	document.getElementById(frame_sel).src = "./"+page+".jsp";
		    }
		    
		    tab_map[index] = 1;
		 }
	});

   //$("table.bPhistory_table tr:even").addClass("even");
   //$("table.bPhistory_table tr:odd").addClass("odd");
   
   })
  
  
	var formdic = {"memberBaseInfo_form":1,"detail_form":1,"workinfo_form":1}
	function get_requestPara(iframeId,formId){
		var para = "";
		$(document.getElementById(iframeId).contentWindow.document).find("#"+formId+" :input").each(function(index,obj){
			if(obj.type== "checkbox"){
				para += obj.id+"=" +(obj.checked?"1":"0") + "&";
			}else{
				para += obj.id+"=" +obj.value + "&";
			}
		});
		
		if(formId in formdic){
			para += "unit_id=" + member_unit_id + "&cluster_id=" + member_cluster_id + "&unit_type=" + member_unit_type;
		}else{
			para += "member_unit_id=" + member_unit_id + "&member_cluster_id=" + member_cluster_id + "&member_unit_type=" + member_unit_type;
			para += "&creator_unit_id=" + doctor_unit_id + "&creator_cluster_id=" + doctor_cluster_id + "&creator_unit_type=" + doctor_unit_type;
		}
		return para.substring(0,para.length);
	}

 	/*
	id为div的id,obj按钮对象
	*/
	function send_request_forDisease(iframeId,formId,obj,requestUrl,para){
		document.getElementById(iframeId).contentWindow.showScreenProtectDiv(1);
		document.getElementById(iframeId).contentWindow.showLoading();
		xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			complete:function(){
				document.getElementById(iframeId).contentWindow.hideScreenProtectDiv(1);
				document.getElementById(iframeId).contentWindow.hideLoading();
			},
			error:function(){
				$.alert('无权限');
			},success:function(response){
			    var state = response.updateFlag;
			    var returnMessage=response.message;
			    if(state == "1"){
			    	obj.onclick = function(){
			    		if(formId == "habit_form"){
			    			document.getElementById(iframeId).contentWindow.edit_habit(obj);
			    		}else if(formId == "family_form"){
			    			document.getElementById(iframeId).contentWindow.edit_family(obj);
			    		}else if(formId == "complication_form"){
			    			document.getElementById(iframeId).contentWindow.edit_complication(obj);
			    		}
			    	};
			    	//按钮变成编辑图标，元素变成不可以编辑
			    	$(document.getElementById(iframeId).contentWindow.document).find("#"+formId+" :input").attr("disabled",true);
					$(obj).find("img").attr("src",edit_image);
					$.alert("修改成功");
			    }else{
			    	$.alert("修改失败");
			    }
			}
		});
	}
 	

	 
	    function sonIframeResize(iframe) {
			try {
				var bHeight = iframe.contentWindow.document.body.scrollHeight;
				var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
				var height = Math.min(bHeight, dHeight);
				iframe.height = height;
			} catch (ex) {
			    
			}
		}
</script>
</head>

<body style="background:#e8e3d7">
<div class="health_records">
  <div class="tgreen_title_BPhistory">健康病历</div>
  <!--tab_healthRecords start-->
  <div class="tab_healthRecords">
	<div class="healthRecords_menu_yuan">
           <ul>
             <li title="生活习惯" class="selected_healthRecords_yuan" ><img src="<c:url value='/images/health/habit.png'/>"><span>生活习惯</span></li>
             <li title="家族遗传史"><img src="<c:url value='/images/health/family.png'/>"><span>家族遗传史</span></li>
             <li title="当前并发症"><img src="<c:url value='/images/health/cp.png'/>"><span>当前并发症</span></li>
             <li title="疾病史"><img src="<c:url value='/images/health/disease.png'/>"><span>疾病史</span></li>
             <li title="高血压专项"><img src="<c:url value='/images/health/bp.png'/>"><span>高血压专项</span></li>
             <li title="健康检查"><img src="<c:url value='/images/health/health.png'/>"><span>健康检查</span></li>
			 <li style="margin-right: -25px" title="健康体检"><img src="<c:url value='/images/health/icon_physical_z.jpg'/>"><span>健康体检</span></li>            
           </ul>
	 </div>
    <div class="tab_healthRecords_box">
       	
      <div>
      		<iframe id="memberHabitIframe"  name = "memberHabitIframe" src="./memberhabit.jsp"  frameborder="0" width="100%"  scrolling="no"   height="600px" ></iframe>
      </div>
      
      <div class="hide_healthRecords">
			<iframe id="memberFamilyDiseaseIframe"  name = "memberFamilyDiseaseIframe" src=""  frameborder="0" width="100%"  scrolling="no"   height="600px" ></iframe>
      </div>
      
      <div class="hide_healthRecords">
      		<iframe id="memberHtComplicationIframe"  name = "memberHtComplicationIframe" src=""  frameborder="0" width="100%"  scrolling="no"   height="600px" ></iframe>
      </div>
      <div class="hide_healthRecords">
      		<iframe id="memberIllnessHistoryIframe"  name = "memberIllnessHistoryIframe" src=""  frameborder="0" width="100%"  scrolling="no"  height="600px" ></iframe>
      </div>
      <div class="hide_healthRecords">
      		<iframe id="memberHtSpecialIframe"  name = "memberHtSpecialIframe" src=""  frameborder="0" width="100%"  scrolling="no"    height="900px" ></iframe>
      </div>
      
      <div class="hide_healthRecords">
 			<iframe id="memberMedicalExamintaionIframe"  name = "memberMedicalExamintaionIframe" src=""  frameborder="0" width="100%"  scrolling="no"   height="650px" ></iframe>
      </div>
      
       <div class="hide_healthRecords">
      		<iframe id="healthTestIframe"  name = "healthTestIframe" src=""  frameborder="0" width="100%"  scrolling="yes"    height="900px" ></iframe>
      </div>     
  </div>
  <!--tab_healthRecords end-->
</div>
</body>
</html>
