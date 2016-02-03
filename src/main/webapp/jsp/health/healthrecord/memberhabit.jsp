<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/dictionaryInfo.js'/>" type="text/javascript"></script>
<script type="text/javascript">
		var edit_image = window.parent.edit_image;
		var save_image = window.parent.save_image;
		var habit_form = "habit_form";
		function startInit(){
			$("#"+habit_form+" :input").attr("disabled",true);
			queryDictionaryInfo("memberHabit");
			queryMemberHabit();
		};
		
		function queryMemberHabit(){
			var requestUrl = "/gzjky/healthRecordAction/queryMemberHabit.do";
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
				    var memberHabit = response.result;
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
			$("#editImage").empty();
	    	$("#editImage").html(save_image);
		}
		function save_habit(obj){
			var url = "/gzjky/healthRecordAction/editMemberHabit.do";
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
	    
	 	/*
		id为div的id,obj按钮对象
		*/
		function send_request_forDisease(formId,obj,requestUrl,para){
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
				    if(state == "1"){
				    	obj.onclick = function(){
				    		edit_habit(obj);
				    	};
				    	//按钮变成编辑图标，元素变成不可以编辑
			    		$("#"+formId+" :input").attr("disabled",true);
			    		$("#editImage").empty();
				    	$("#editImage").html(edit_image);
						$.alert("修改成功");
				    }else{
				    	$.alert("修改失败");
				    }
				}
			});
		}
</script>
</head>
<body onload="startInit()"  class="skin-blue">
<form id="habit_form">
   <!--detailed_information start-->
   <div>
     	<div class="box box-info">
              <div class="box-header">
                  <h3 class="box-title">生活习惯</h3>
              </div>		
              <div class="box-body">
				         <div class="row form-group btn_title_informationModify">
					          	<div class="col-lg-8 col-xs-8 text-right" id="editImage" href="javascript:void(0)" onclick="edit_habit(this)">
					          		<a class="btn btn-success">
					                   <i class="fa fa-edit"></i> 编辑
					             	</a>
					            </div>
 							</div>
	 			         <div class="row">
					         <div class="col-lg-8 col-xs-8">
					         <div class="col-lg-12 col-xs-12">
							        <div class="col-lg-6 col-xs-6">
							        	<span class="col-lg-4 col-xs-4 text-right  form-span" >工作类型：</span>
						            <select class="display-input col-lg-8 col-xs-8 selectMax_informationModify" id="workType"  name="workType" >
	             					</select>
							        </div>
							        <div class="col-lg-6 col-xs-6">
							        	<lable class="col-lg-4 col-xs-4 text-right form-span">工作压力：</lable>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify"  id="workPressure"  name="workPressure" ></select>
							        </div>
								</div>
								<div class="col-lg-12 col-xs-12">
							        <div class="col-lg-6 col-xs-6">
							        	<span class="col-lg-4 col-xs-4 text-right  form-span">血型：</span>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify" id="aboBloodTypeDict"  name="aboBloodTypeDict" ></select>
							        </div>
							        <div class="col-lg-6 col-xs-6">
							        	<lable class="col-lg-4 col-xs-4 text-right form-span">体重：</lable>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify"  id="Weight"  name="Weight"></select>  
							        </div>
						        </div>
						        
						        <div class="col-lg-12 col-xs-12">
							        <div class="col-lg-6 col-xs-6">
							        	<span class="col-lg-4 col-xs-4 text-right form-span">腰围：</span>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify" id="Waistline"  name="Waistline" ></select>
							        </div>
							        <div class="col-lg-6 col-xs-6">
							        	<span class="col-lg-4 col-xs-4 text-right form-span">睡眠时长：</span>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify"  id="SleepTime"  name="SleepTime"></select>
							        </div>
						        </div>
						        <div class="col-lg-12 col-xs-12">
							        <div class="col-lg-6 col-xs-6">
							        	<lable class="col-lg-4 col-xs-4 text-right form-span">吸烟年限：</lable>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify"  id="SmokeTime"  name="SmokeTime" onchange="changeSmokingTime(this)"></select> 
							        </div>
							        <div class="col-lg-6 col-xs-6">
							        	<span class="col-lg-4 col-xs-4 text-right  form-span">吸烟频次：</span>
										<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify" id="SmokeNum"  name="SmokeNum" ></select>
							        </div>
						        </div>
						        <div class="col-lg-12 col-xs-12">
							        <div class="col-lg-6 col-xs-6">
							        	<lable class="col-lg-4 col-xs-4 text-right form-span">饮酒类型：</lable>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify" id="alcoholTypeDict"  name="alcoholTypeDict" ></select>
							        </div>
							        <div class="col-lg-6 col-xs-6">
							        	<span class="col-lg-4 col-xs-4 text-right  form-span">饮酒频次：</span>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify"  id="drinkFreqCodeDict"  name="drinkFreqCodeDict" onchange="changeDrinkingRate(this)"></select>  
							        </div>
						        </div>
						        <div class="col-lg-12 col-xs-12">
							        <div class="col-lg-6 col-xs-6">
							        	<lable class="col-lg-4 col-xs-4 text-right form-span">运动时长：</lable>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify"   id="SportTime"  name="SportTime"></select>
							        </div>
							        <div class="col-lg-6 col-xs-6">
							        	<span class="col-lg-4 col-xs-4 text-right  form-span">运动频次：</span>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify"  id="SportNum"  name="SportNum" onchange="changeSportRate(this)"></select> 
							        </div>
						        </div>
						        <div class="col-lg-12 col-xs-12">
							        <div class="col-lg-6 col-xs-6">
							        	<lable class="col-lg-4 col-xs-4 text-right form-span">降压药：</lable>
							        	<select class="display-input col-lg-8 col-xs-8 selectMax_informationModify" id="Hypotensor"  name="Hypotensor" ></select>
							        </div>
							        <div class="col-lg-6">&nbsp;</div>
						        </div>
				        </div>
			        </div>
			     </div>
			    </div>
   </div>

</form>
 

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 
</body>
</html>