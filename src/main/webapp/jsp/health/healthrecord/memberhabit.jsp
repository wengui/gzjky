<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script type="text/javascript">
		var save_image = window.parent.save_image;
		var habit_form = "habit_form";
		$(function(){
			$("#"+habit_form+" :input").attr("disabled",true);
			queryMemberHabit();
		});
		function queryMemberHabit(){
			var requestUrl = "/healthRecordAction/queryMemberHabit.action";
			var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id+"&member_unit_type="+window.parent.member_unit_type;
		
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
				    var modelMap = response.modelMap;
				    var memberHabit = modelMap.memberHabit;
				    if(memberHabit != null){
				    	init_memberHabit(memberHabit);
				    }else{
				    	if(typeof memberFlag=='undefined'){
				    		//$.alert("没有查到相关数据");
				    	}	    	
				    }
				}
			});
		}
		
	 	function init_memberHabit(memberHabit){
	 		$("#"+habit_form+" :input").each(function(index,obj){
	    		var id = obj.id;
	    		if(id in memberHabit){
	    			$("#"+habit_form+" #"+id).val(memberHabit[id]);
	    		}
	    	});
		}
	 	
	 	function edit_habit(obj){
			$("#"+habit_form+" :input").attr("disabled",false);
			
			if($("#smokingTime").val() == "1"){
				  $("#smokingRate").attr("disabled","disabled");
			  }
			  if($("#sportRate").val() == "1"){
			  	$("#sportTime").attr("disabled","disabled");
			  }
			  if($("#drinkingRate").val() == "1"){
				  $("#drinkingType").attr("disabled","disabled");
			  }
			
			obj.onclick = function(){save_habit(obj);};
			$(obj).find("img").attr("src",save_image);
		}
		function save_habit(obj){
			var url = "/healthRecordAction/addMemberHabit.action";
			var para = get_requestPara(habit_form);
			send_request_forDisease(habit_form,obj,url,para);
		}
		
		  function changeSmokingTime(obj){
			  var index = obj.selectedIndex;
			  var value = obj.options[index].value;
			  if(value != "1"){
				  $("#smokingRate").removeAttr("disabled");
			  }else{
				  $("#smokingRate").attr("disabled","disabled");
				  $("#smokingRate").val("-1");
			  }
		  }
		 function  changeSportRate(obj){
			 var index = obj.selectedIndex;
			  var value = obj.options[index].value;
			  if(value != "1"){
				  $("#sportTime").removeAttr("disabled");
			  }else{
				  $("#sportTime").attr("disabled","disabled");
				  $("#sportTime").val("-1");
			  }
		 }
		 
		 function  changeDrinkingRate(obj){
			 var index = obj.selectedIndex;
			  var value = obj.options[index].value;
			  if(value != "1"){
				  $("#drinkingType").removeAttr("disabled");
			  }else{
				  $("#drinkingType").attr("disabled","disabled");
				  $("#drinkingType").val("-1");
			  }
		 }
		 
	    function get_requestPara(formId){
	    	return window.parent.get_requestPara("memberHabitIframe",formId);
	    }
	    function send_request_forDisease(formId,obj,requestUrl,para){
	    	window.parent.send_request_forDisease("memberHabitIframe",formId,obj,requestUrl,para)
	    }
</script>
</head>
<body>
<div style="font-size:13px;font-family:微软雅黑">
<form id="habit_form">
   <!--detailed_information start-->
   <div class="detailed_information">
     <div class="btn_title_informationModify">
       <ul>
         <li class="tLeft">生活习惯</li>
         <li class="tRight"><a href="javascript:void(0)" onclick="edit_habit(this)"><img src="/images/button/btn_editor.png" /></a></li>
       </ul>
     </div>
     <div class="informationModify_main">
       <ul>
         <li class="detailed_information_left">
           <ul>
             <li class="tgrey_informationDetailed">工作类型：</li>
             <li class="tblack_informationDetailed">
              <select class="selectMax_informationModify" id="workType"  name="workType" >
		         	<option value="-1"></option>
		           <option value="1">脑力</option>
		           <option value="2">体力</option>
		           <option value="3">脑力+体力</option>
              </select>
          </li>
             <li class="tgrey_informationDetailed">血型：</li>
             <li class="tblack_informationDetailed"> 
             <select class="selectMax_informationModify" id="bloodType"  name="bloodType" >
		          <option value="-1"></option>
		          <option value="1">A</option>
		          <option value="2">B</option>
		          <option value="3">AB</option>
		          <option value="4">O</option>
             </select>
             </li>
             <li class="tgrey_informationDetailed">腰围：</li>
             <li class="tblack_informationDetailed">
              <select class="selectMax_informationModify" id="waistline"  name="waistline" >
		           <option value="-1"></option>
		           <option value="1">正常</option>
		           <option value="2">非正常</option>option>
              </select>
          </li>
             <li class="tgrey_informationDetailed">吸烟频次：</li>
             <li class="tblack_informationDetailed">
              <select class="selectMax_informationModify" id="smokingRate"  name="smokingRate" >
		           <option value="-1"></option>
		           <option value="1">1-5根/天</option>
		           <option value="2">5-10根/天</option>
		           <option value="3">10-20根/天</option>
		           <option value="4">20根以上/天</option>
              </select>
             </li>
             <li class="tgrey_informationDetailed">饮酒类型：</li>
             <li class="tblack_informationDetailed">
              <select class="selectMax_informationModify" id="drinkingType"  name="drinkingType" >
		           <option value="-1"></option>
		           <option value="1">白酒</option>
		           <option value="2">红酒</option>
		           <option value="3">黄酒</option>
		           <option value="4">啤酒</option>
              </select>
             </li>
             <li class="tgrey_informationDetailed">运动时长：</li>
             <li class="tblack_informationDetailed"> 
              <select class="selectMax_informationModify"   id="sportTime"  name="sportTime">
		           <option value="-1"></option>
		           <option value="1">15分钟以下</option>
		           <option value="2">15-30分钟</option>
		           <option value="3">30-45分钟</option>
		           <option value="4">45-60分钟</option>
		           <option value="5">60-90分钟</option>
		           <option value="6">90分钟以上</option>
              </select>
             </li>
             <li class="tgrey_informationDetailed">降压药：</li>
             <li class="tblack_informationDetailed">
              <select class="selectMax_informationModify" id="hypotensor"  name="hypotensor" >
	               <option value="-1"></option>
	               <option value="2">按时服用</option>
	               <option value="1">从来不吃</option>
              </select>
             </li>
           </ul>
         </li>
         <li class="detailed_information_right">
           <ul>
             <li class="tgrey_informationDetailed">工作压力：</li>
             <li class="tblack_informationDetailed">
              <select class="selectMax_informationModify"  id="workPressure"  name="workPressure" >
		           <option value="-1"></option>
		           <option value="1">高</option>
		           <option value="2">中</option>
		           <option value="3">低</option>
              </select>
             </li>
             <li class="tgrey_informationDetailed">体重：</li>
             <li class="tblack_informationDetailed">
              <select class="selectMax_informationModify"  id="weight"  name="weight">
		           <option value="-1"></option>
		           <option value="1">未超重</option>
		           <option value="2">超重</option>
              </select>                  	
             </li>
             <li class="tgrey_informationDetailed">吸烟年限：</li>
             <li class="tblack_informationDetailed">
             	  <select class="selectMax_informationModify"  id="smokingTime"  name="smokingTime" onchange="changeSmokingTime(this)">
			           <option value="-1"></option>
			           <option value="1">不吸烟</option>
			           <option value="2">1-3年</option>
			           <option value="3">3-5年</option>
			           <option value="4">5-10年</option>
			           <option value="5">10年以上</option>
               </select>   
             </li>
             <li class="tgrey_informationDetailed">饮酒频次：</li>
             <li class="tblack_informationDetailed">
             	  <select class="selectMax_informationModify"  id="drinkingRate"  name="drinkingRate" onchange="changeDrinkingRate(this)">
			           <option value="-1"></option>
			           <option value="1">不饮酒</option>
			           <option value="2">1-50ml/天</option>
			           <option value="3">50-100ml/天</option>
			           <option value="4">100-300ml/天</option>
			           <option value="5">300ml以上/天</option>
               </select>                    		
             </li>
             <li class="tgrey_informationDetailed">运动频次：</li>
             <li class="tblack_informationDetailed">
              	  <select class="selectMax_informationModify"  id="sportRate"  name="sportRate" onchange="changeSportRate(this)">
			           <option value="-1"></option>
			           <option value="1">不运动</option>
			           <option value="2">1天/周</option>
			           <option value="3">2天/周</option>
			           <option value="4">3天/周</option>
			           <option value="5">4天/周</option>
			           <option value="6">5天/周</option>
			           <option value="7">6天/周</option>
               </select>                    		
             </li>
             <li class="tgrey_informationDetailed">睡眠时长：</li>
             <li class="tblack_informationDetailed">
              	  <select class="selectMax_informationModify"  id="sleepTime"  name="sleepTime">
			          <option value="-1"></option>
			           <option value="1">0-1小时</option>
			           <option value="2">1-2小时</option>
			           <option value="3">2-3小时</option>
			           <option value="4">3-4小时</option>
			           <option value="5">4-5小时</option>
			           <option value="6">5-6小时</option>
			           <option value="7">6-7小时</option>
			           <option value="8">7-8小时</option>
			           <option value="9">8小时以上</option>
               </select>                   
             </li>   
           </ul>
         </li>
       </ul>
     </div>
   </div>
</form>
</div>
 

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 
</body>
</html>