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
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>
<script type="text/javascript">
	var family_form = "family_form";
	var save_image = window.parent.save_image;
	$(function(){
		queryMemberFamilyDisease();
	});
	
	function queryMemberFamilyDisease(){
    	var requestUrl = "/gzjky/healthRecordAction/queryMemberFamilyDisease.do";
    	var para = '';
  	    
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
			    var memberFamilyDisease =  response.outBeanList;
			    if(memberFamilyDisease != null){
			    	init_memberFamilyDisease(memberFamilyDisease);
			    }else{
					$("#"+family_form+" :input").attr("disabled",true);
			    }
			}
		});
	}
	
	function init_memberFamilyDisease(memberFamilyDisease){
		heighBloodPressureRelationNum=0;
		heighBloodFatRelationNum=0;
		diabetesMellitusRelationNum=0;
		coronaryDiseaseRelationNum=0;
		cardiovascularAccidentRelationNum=0;
		
		var familyDiseaseItems=  memberFamilyDisease;
		if(familyDiseaseItems!=null){
			for(var i=0;i<familyDiseaseItems.length;i++){
				
				if(familyDiseaseItems[i].name=="高血压"){
					$("#heighBloodPressure").val(familyDiseaseItems[i].have);
					if(familyDiseaseItems[i].have==1){
						var familyDiseaseRelationShips=familyDiseaseItems[i].familyDiseaseRelationShips;
						var str="";
						for(var j=0;j<familyDiseaseRelationShips.length;j++){
							heighBloodPressureRelationNum++;
							str+="<div id='heighBloodPressure_relation"+heighBloodPressureRelationNum+"'>亲属关系:<select id='heighBloodPressureRelationName"+heighBloodPressureRelationNum+"'>";
							str+=relation_name_str+"</select>";
							str+="&nbsp;&nbsp;患病年份:<select id='heighBloodPressureRelationYear"+heighBloodPressureRelationNum+"'>";
							str+=relation_year_str+"</select></div>";			
						}
						$("#heighBloodPressure_relation").html(str);
						if(heighBloodPressureRelationNum>0){
							$("#heighBloodPressure_relation"+heighBloodPressureRelationNum).append("<a href='javascript:void(0)' id='delHeighBloodPressureRelation_button' onclick='delHeighBloodPressureRelation()' class='relation_button'>删除</a>");
						}
						$("#heighBloodPressure_relation").append("<a href='javascript:void(0)' id='addHeighBloodPressureRelation_button' onclick='addHeighBloodPressureRelation()' class='relation_button'>+继续添加</a>");		
						
						for(var j=0;j<familyDiseaseRelationShips.length;j++){		
							$("#heighBloodPressureRelationName"+(j+1)).val(familyDiseaseRelationShips[j].name);
							$("#heighBloodPressureRelationYear"+(j+1)).val(familyDiseaseRelationShips[j].year);
						}
					}
				}	
						
				if(familyDiseaseItems[i].name=="高血脂"){
					$("#heighBloodFat").val(familyDiseaseItems[i].have);
					if(familyDiseaseItems[i].have==1){
						var familyDiseaseRelationShips=familyDiseaseItems[i].familyDiseaseRelationShips;
						var str="";
						for(var j=0;j<familyDiseaseRelationShips.length;j++){
							heighBloodFatRelationNum++;
							str+="<div id='heighBloodFat_relation"+heighBloodFatRelationNum+"'>亲属关系:<select id='heighBloodFatRelationName"+heighBloodFatRelationNum+"'>";
							str+=relation_name_str+"</select>";
							str+="&nbsp;&nbsp;患病年份:<select id='heighBloodFatRelationYear"+heighBloodFatRelationNum+"'>";
							str+=relation_year_str+"</select></div>";			
						}
						$("#heighBloodFat_relation").html(str);
						if(heighBloodFatRelationNum>0){
							$("#heighBloodFat_relation"+heighBloodFatRelationNum).append("<a href='javascript:void(0)' id='delHeighBloodFatRelation_button' onclick='delHeighBloodFatRelation()' class='relation_button'>删除</a>");
						}
						$("#heighBloodFat_relation").append("<a href='javascript:void(0)' id='addHeighBloodFatRelation_button' onclick='addHeighBloodFatRelation()' class='relation_button'>+继续添加</a>");		
						
						for(var j=0;j<familyDiseaseRelationShips.length;j++){		
							$("#heighBloodFatRelationName"+(j+1)).val(familyDiseaseRelationShips[j].name);
							$("#heighBloodFatRelationYear"+(j+1)).val(familyDiseaseRelationShips[j].year);
						}
					}
				}	
				
				if(familyDiseaseItems[i].name=="糖尿病"){
					$("#diabetesMellitus").val(familyDiseaseItems[i].have);
					if(familyDiseaseItems[i].have==1){
						var familyDiseaseRelationShips=familyDiseaseItems[i].familyDiseaseRelationShips;
						var str="";
						for(var j=0;j<familyDiseaseRelationShips.length;j++){
							diabetesMellitusRelationNum++;
							str+="<div id='diabetesMellitus_relation"+diabetesMellitusRelationNum+"'>亲属关系:<select id='diabetesMellitusRelationName"+diabetesMellitusRelationNum+"'>";
							str+=relation_name_str+"</select>";
							str+="&nbsp;&nbsp;患病年份:<select id='diabetesMellitusRelationYear"+diabetesMellitusRelationNum+"'>";
							str+=relation_year_str+"</select></div>";			
						}
						$("#diabetesMellitus_relation").html(str);
						if(diabetesMellitusRelationNum>0){
							$("#diabetesMellitus_relation"+diabetesMellitusRelationNum).append("<a href='javascript:void(0)' id='delDiabetesMellitusRelation_button' onclick='delDiabetesMellitusRelation()' class='relation_button'>删除</a>");
						}
						$("#diabetesMellitus_relation").append("<a href='javascript:void(0)' id='addDiabetesMellitusRelation_button' onclick='addDiabetesMellitusRelation()' class='relation_button'>+继续添加</a>");		
						
						for(var j=0;j<familyDiseaseRelationShips.length;j++){		
							$("#diabetesMellitusRelationName"+(j+1)).val(familyDiseaseRelationShips[j].name);
							$("#diabetesMellitusRelationYear"+(j+1)).val(familyDiseaseRelationShips[j].year);
						}
					}
				}
				
				if(familyDiseaseItems[i].name=="冠心病"){
					$("#coronaryDisease").val(familyDiseaseItems[i].have);
					if(familyDiseaseItems[i].have==1){
						var familyDiseaseRelationShips=familyDiseaseItems[i].familyDiseaseRelationShips;
						var str="";
						for(var j=0;j<familyDiseaseRelationShips.length;j++){
							coronaryDiseaseRelationNum++;
							str+="<div id='coronaryDisease_relation"+coronaryDiseaseRelationNum+"'>亲属关系:<select id='coronaryDiseaseRelationName"+coronaryDiseaseRelationNum+"'>";
							str+=relation_name_str+"</select>";
							str+="&nbsp;&nbsp;患病年份:<select id='coronaryDiseaseRelationYear"+coronaryDiseaseRelationNum+"'>";
							str+=relation_year_str+"</select></div>";			
						}
						$("#coronaryDisease_relation").html(str);
						if(coronaryDiseaseRelationNum>0){
							$("#coronaryDisease_relation"+coronaryDiseaseRelationNum).append("<a href='javascript:void(0)' id='delCoronaryDiseaseRelation_button' onclick='delCoronaryDiseaseRelation()' class='relation_button'>删除</a>");
						}
						$("#coronaryDisease_relation").append("<a href='javascript:void(0)' id='addCoronaryDiseaseRelation_button' onclick='addCoronaryDiseaseRelation()' class='relation_button'>+继续添加</a>");		
						
						for(var j=0;j<familyDiseaseRelationShips.length;j++){		
							$("#coronaryDiseaseRelationName"+(j+1)).val(familyDiseaseRelationShips[j].name);
							$("#coronaryDiseaseRelationYear"+(j+1)).val(familyDiseaseRelationShips[j].year);
						}
					}
				}
				
				if(familyDiseaseItems[i].name=="脑血管意外"){
					$("#cardiovascularAccident").val(familyDiseaseItems[i].have);
					if(familyDiseaseItems[i].have==1){
						var familyDiseaseRelationShips=familyDiseaseItems[i].familyDiseaseRelationShips;
						var str="";
						for(var j=0;j<familyDiseaseRelationShips.length;j++){
							cardiovascularAccidentRelationNum++;
							str+="<div id='cardiovascularAccident_relation"+cardiovascularAccidentRelationNum+"'>亲属关系:<select id='cardiovascularAccidentRelationName"+cardiovascularAccidentRelationNum+"'>";
							str+=relation_name_str+"</select>";
							str+="&nbsp;&nbsp;患病年份:<select id='cardiovascularAccidentRelationYear"+cardiovascularAccidentRelationNum+"'>";
							str+=relation_year_str+"</select></div>";			
						}
						$("#cardiovascularAccident_relation").html(str);
						if(cardiovascularAccidentRelationNum>0){
							$("#cardiovascularAccident_relation"+cardiovascularAccidentRelationNum).append("<a href='javascript:void(0)' id='delCardiovascularAccidentRelation_button' onclick='delCardiovascularAccidentRelation()' class='relation_button'>删除</a>");
						}
						$("#cardiovascularAccident_relation").append("<a href='javascript:void(0)' id='addCardiovascularAccidentRelation_button' onclick='addCardiovascularAccidentRelation()' class='relation_button'>+继续添加</a>");		
						
						for(var j=0;j<familyDiseaseRelationShips.length;j++){		
							$("#cardiovascularAccidentRelationName"+(j+1)).val(familyDiseaseRelationShips[j].name);
							$("#cardiovascularAccidentRelationYear"+(j+1)).val(familyDiseaseRelationShips[j].year);
						}
					}
				}	
			}
		}
		$(".relation_button").attr("style","display:none");
		$("#"+family_form+" :input").attr("disabled",true);
	}
	
	function edit_family(obj){
		obj.onclick = function(){save_family(obj);};
		$("#"+family_form+" :input").attr("disabled",false);
		$(obj).find("img").attr("src",save_image);
		$(".relation_button").attr("style","display");
	}
	function save_family(obj){
		var url = "/gzjky/healthRecordAction/editMemberFamilyDisease.do";
		var para = '';
		
		var heighBloodPressure=$("#heighBloodPressure").val();
		var heighBloodFat=$("#heighBloodFat").val();
		var diabetesMellitus=$("#diabetesMellitus").val();
		var coronaryDisease=$("#coronaryDisease").val();
		var cardiovascularAccident=$("#cardiovascularAccident").val();
		
		var heighBloodPressureRelationName="";
		var heighBloodPressureRelationYear="";
		for(var i=1;;i++){
			var name=$("#heighBloodPressureRelationName"+i).val();
			var year=$("#heighBloodPressureRelationYear"+i).val();
			if(name==undefined){
				break;
			}
			else{
				heighBloodPressureRelationName+=name+",";
				heighBloodPressureRelationYear+=year+",";
			}
		} 
		
		var heighBloodFatRelationName="";
		var heighBloodFatRelationYear="";
		for(var i=1;;i++){
			var name=$("#heighBloodFatRelationName"+i).val();
			var year=$("#heighBloodFatRelationYear"+i).val();
			if(name==undefined){
				break;
			}
			else{
				heighBloodFatRelationName+=name+",";
				heighBloodFatRelationYear+=year+",";
			}
		} 
		
		var diabetesMellitusRelationName="";
		var diabetesMellitusRelationYear="";
		for(var i=1;;i++){
			var name=$("#diabetesMellitusRelationName"+i).val();
			var year=$("#diabetesMellitusRelationYear"+i).val();
			if(name==undefined){
				break;
			}
			else{
				diabetesMellitusRelationName+=name+",";
				diabetesMellitusRelationYear+=year+",";
			}
		} 

		var coronaryDiseaseRelationName="";
		var coronaryDiseaseRelationYear="";
		for(var i=1;;i++){
			var name=$("#coronaryDiseaseRelationName"+i).val();
			var year=$("#coronaryDiseaseRelationYear"+i).val();
			if(name==undefined){
				break;
			}
			else{
				coronaryDiseaseRelationName+=name+",";
				coronaryDiseaseRelationYear+=year+",";
			}
		} 
		
		var cardiovascularAccidentRelationName="";
		var cardiovascularAccidentRelationYear="";
		for(var i=1;;i++){
			var name=$("#cardiovascularAccidentRelationName"+i).val();
			var year=$("#cardiovascularAccidentRelationYear"+i).val();
			if(name==undefined){
				break;
			}
			else{
				cardiovascularAccidentRelationName+=name+",";
				cardiovascularAccidentRelationYear+=year+",";
			}
		} 
		
		para+="&heighBloodPressure="+heighBloodPressure+"&heighBloodFat="+heighBloodFat+"&diabetesMellitus="+diabetesMellitus+"&coronaryDisease="+coronaryDisease+"&cardiovascularAccident="+cardiovascularAccident
				 +"&heighBloodPressureRelationName="+heighBloodPressureRelationName+"&heighBloodPressureRelationYear="+heighBloodPressureRelationYear
				 +"&heighBloodFatRelationName="+heighBloodFatRelationName+"&heighBloodFatRelationYear="+heighBloodFatRelationYear
				 +"&diabetesMellitusRelationName="+diabetesMellitusRelationName+"&diabetesMellitusRelationYear="+diabetesMellitusRelationYear
				 +"&coronaryDiseaseRelationName="+coronaryDiseaseRelationName+"&coronaryDiseaseRelationYear="+coronaryDiseaseRelationYear
				 +"&cardiovascularAccidentRelationName="+cardiovascularAccidentRelationName+"&cardiovascularAccidentRelationYear="+cardiovascularAccidentRelationYear

		send_request_forDisease(family_form,obj,url,para);
	}
	
    function get_requestPara(formId){
    	return window.parent.get_requestPara("memberFamilyDiseaseIframe",formId);
    }
    function send_request_forDisease(formId,obj,requestUrl,para){
    	window.parent.send_request_forDisease("memberFamilyDiseaseIframe",formId,obj,requestUrl,para);
    	$(".relation_button").attr("style","display:none");
    }
  
</script>

<script type="text/javascript">
	var relation_name_str="<option value='爸爸'>爸爸</option><option value='妈妈'>妈妈</option><option value='爷爷'>爷爷</option><option value='奶奶'>奶奶</option>";
	relation_name_str+="<option value='外公'>外公</option><option value='外婆'>外婆</option><option value='儿子'>儿子</option><option value='女儿'>女儿</option>";
	var relation_year_str="";
	var d=new Date();
	var year=d.getFullYear();
	for(var i=year;i>=1900;i--){
		relation_year_str+="<option value='"+i+"'>"+i+"</option>";
	}
	
	//高血压
	var heighBloodPressureRelationNum=0;	
	function changeHeighBloodPressure(){
		var heighBloodPressure=$("#heighBloodPressure").val();
		if(heighBloodPressure==1){

			heighBloodPressureRelationNum++;
			var str="<div id='heighBloodPressure_relation"+heighBloodPressureRelationNum+"'>亲属关系:<span class='select-style_relation'><select id='heighBloodPressureRelationName"+heighBloodPressureRelationNum+"'>";
			str+=relation_name_str+"</select></span>";
			str+="&nbsp;&nbsp;患病年份:<span class='select-style_relation'><select id='heighBloodPressureRelationYear"+heighBloodPressureRelationNum+"'>";
			str+=relation_year_str+"</select></span>";
			str+="<a href='javascript:void(0)' id='delHeighBloodPressureRelation_button' onclick='delHeighBloodPressureRelation()' class='relation_button'>删除</a></div>";
			str+="<a href='javascript:void(0)' id='addHeighBloodPressureRelation_button' onclick='addHeighBloodPressureRelation()' class='relation_button'>+继续添加</a>";
			$("#heighBloodPressure_relation").html(str);
		}
		else{
			heighBloodPressureRelationNum=0;
			$("#heighBloodPressure_relation").html("");
		}
	}	
	function addHeighBloodPressureRelation(){
		$("#addHeighBloodPressureRelation_button").remove();
		$("#delHeighBloodPressureRelation_button").remove();
		heighBloodPressureRelationNum++;	
		
		
		var str="<div id='heighBloodPressure_relation"+heighBloodPressureRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='heighBloodPressureRelationName"+heighBloodPressureRelationNum+"'>";
		str+=relation_name_str+"</select>";
		str+="&nbsp;&nbsp;患病年份:<select id='heighBloodPressureRelationYear"+heighBloodPressureRelationNum+"'>";
		str+=relation_year_str+"</select>";
		str+="<a href='javascript:void(0)' id='delHeighBloodPressureRelation_button' onclick='delHeighBloodPressureRelation()' class='relation_button'>删除</a></div>";
		str+="<a href='javascript:void(0)' id='addHeighBloodPressureRelation_button' onclick='addHeighBloodPressureRelation()' class='relation_button'>+继续添加</a>";
		$("#heighBloodPressure_relation").append(str);	
	}
	function delHeighBloodPressureRelation(){
		$("#heighBloodPressure_relation"+heighBloodPressureRelationNum).remove();	

		heighBloodPressureRelationNum--;	
		$("#heighBloodPressure_relation"+heighBloodPressureRelationNum).append("<a href='javascript:void(0)' id='delHeighBloodPressureRelation_button' onclick='delHeighBloodPressureRelation()' class='relation_button'>删除</a>");
	}
	
	//高血脂
	var heighBloodFatRelationNum=0;	
	function changeHeighBloodFat(){
		var heighBloodFat=$("#heighBloodFat").val();
		if(heighBloodFat==1){
			heighBloodFatRelationNum++;
			var str="<div id='heighBloodFat_relation"+heighBloodFatRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='heighBloodFatRelationName"+heighBloodFatRelationNum+"'>";
			str+=relation_name_str+"</select>";
			str+="&nbsp;&nbsp;患病年份:<select id='heighBloodFatRelationYear"+heighBloodFatRelationNum+"'>";
			str+=relation_year_str+"</select></span>";
			str+="<a href='javascript:void(0)' id='delHeighBloodFatRelation_button' onclick='delHeighBloodFatRelation()' class='relation_button'>删除</a></div>";
			str+="<a href='javascript:void(0)' id='addHeighBloodFatRelation_button' onclick='addHeighBloodFatRelation()' class='relation_button'>+继续添加</a>";
			$("#heighBloodFat_relation").html(str);
		}
		else{
			heighBloodFatRelationNum=0;
			$("#heighBloodFat_relation").html("");
		}
	}	
	function addHeighBloodFatRelation(){
		$("#addHeighBloodFatRelation_button").remove();
		$("#delHeighBloodFatRelation_button").remove();
		heighBloodFatRelationNum++;	
		var str="<div id='heighBloodFat_relation"+heighBloodFatRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='heighBloodFatRelationName"+heighBloodFatRelationNum+"'>";
		str+=relation_name_str+"</select>";
		str+="&nbsp;&nbsp;患病年份:<select id='heighBloodFatRelationYear"+heighBloodFatRelationNum+"'>";
		str+=relation_year_str+"</select></span>";
		str+="<a href='javascript:void(0)' id='delHeighBloodFatRelation_button' onclick='delHeighBloodFatRelation()' class='relation_button'>删除</a></div>";
		str+="<a href='javascript:void(0)' id='addHeighBloodFatRelation_button' onclick='addHeighBloodFatRelation()' class='relation_button'>+继续添加</a>";
		$("#heighBloodFat_relation").append(str);	
	}
	function delHeighBloodFatRelation(){
		$("#heighBloodFat_relation"+heighBloodFatRelationNum).remove();
		heighBloodFatRelationNum--;	
		$("#heighBloodFat_relation"+heighBloodFatRelationNum).append("<a href='javascript:void(0)' id='delHeighBloodFatRelation_button' onclick='delHeighBloodFatRelation()' class='relation_button'>删除</a>");
	}
	
	
	//糖尿病
	var diabetesMellitusRelationNum=0;	
	function changeDiabetesMellitus(){
		var diabetesMellitus=$("#diabetesMellitus").val();
		if(diabetesMellitus==1){
			diabetesMellitusRelationNum++;
			var str="<div id='diabetesMellitus_relation"+diabetesMellitusRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='diabetesMellitusRelationName"+diabetesMellitusRelationNum+"'>";
			str+=relation_name_str+"</select>";
			str+="&nbsp;&nbsp;患病年份:<select id='diabetesMellitusRelationYear"+diabetesMellitusRelationNum+"'>";
			str+=relation_year_str+"</select></span>";
			str+="<a href='javascript:void(0)' id='delDiabetesMellitusRelation_button' onclick='delDiabetesMellitusRelation()' class='relation_button'>删除</a></div>";
			str+="<a href='javascript:void(0)' id='addDiabetesMellitusRelation_button' onclick='addDiabetesMellitusRelation()' class='relation_button'>+继续添加</a>";
			$("#diabetesMellitus_relation").html(str);
		}
		else{
			diabetesMellitusRelationNum=0;
			$("#diabetesMellitus_relation").html("");
		}
	}	
	function addDiabetesMellitusRelation(){
		$("#addDiabetesMellitusRelation_button").remove();
		$("#delDiabetesMellitusRelation_button").remove();
		diabetesMellitusRelationNum++;	
		var str="<div id='diabetesMellitus_relation"+diabetesMellitusRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='diabetesMellitusRelationName"+diabetesMellitusRelationNum+"'>";
		str+=relation_name_str+"</select>";
		str+="&nbsp;&nbsp;患病年份:<select id='diabetesMellitusRelationYear"+diabetesMellitusRelationNum+"'>";
		str+=relation_year_str+"</select></span>";
		str+="<a href='javascript:void(0)' id='delDiabetesMellitusRelation_button' onclick='delDiabetesMellitusRelation()' class='relation_button'>删除</a></div>";
		str+="<a href='javascript:void(0)' id='addDiabetesMellitusRelation_button' onclick='addDiabetesMellitusRelation()' class='relation_button'>+继续添加</a>";
		$("#diabetesMellitus_relation").append(str);	
	}
	function delDiabetesMellitusRelation(){
		$("#diabetesMellitus_relation"+diabetesMellitusRelationNum).remove();
		diabetesMellitusRelationNum--;	
		$("#diabetesMellitus_relation"+diabetesMellitusRelationNum).append("<a href='javascript:void(0)' id='delDiabetesMellitusRelation_button' onclick='delDiabetesMellitusRelation()' class='relation_button'>删除</a>");
	}
	
	
	//冠心病
	var coronaryDiseaseRelationNum=0;	
	function changeCoronaryDisease(){
		var coronaryDisease=$("#coronaryDisease").val();
		if(coronaryDisease==1){
			coronaryDiseaseRelationNum++;
			var str="<div id='coronaryDisease_relation"+coronaryDiseaseRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='coronaryDiseaseRelationName"+coronaryDiseaseRelationNum+"'>";
			str+=relation_name_str+"</select>";
			str+="&nbsp;&nbsp;患病年份:<select id='coronaryDiseaseRelationYear"+coronaryDiseaseRelationNum+"'>";
			str+=relation_year_str+"</select></span>";
			str+="<a href='javascript:void(0)' id='delCoronaryDiseaseRelation_button' onclick='delCoronaryDiseaseRelation()' class='relation_button'>删除</a></div>";
			str+="<a href='javascript:void(0)' id='addCoronaryDiseaseRelation_button' onclick='addCoronaryDiseaseRelation()' class='relation_button'>+继续添加</a>";
			$("#coronaryDisease_relation").html(str);
		}
		else{
			coronaryDiseaseRelationNum=0;
			$("#coronaryDisease_relation").html("");
		}
	}	
	function addCoronaryDiseaseRelation(){
		$("#addCoronaryDiseaseRelation_button").remove();
		$("#delCoronaryDiseaseRelation_button").remove();
		coronaryDiseaseRelationNum++;	
		var str="<div id='coronaryDisease_relation"+coronaryDiseaseRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='coronaryDiseaseRelationName"+coronaryDiseaseRelationNum+"'>";
		str+=relation_name_str+"</select>";
		str+="&nbsp;&nbsp;患病年份:<select id='coronaryDiseaseRelationYear"+coronaryDiseaseRelationNum+"'>";
		str+=relation_year_str+"</select></sapn>";
		str+="<a href='javascript:void(0)' id='delCoronaryDiseaseRelation_button' onclick='delCoronaryDiseaseRelation()' class='relation_button'>删除</a></div>";
		str+="<a href='javascript:void(0)' id='addCoronaryDiseaseRelation_button' onclick='addCoronaryDiseaseRelation()' class='relation_button'>+继续添加</a>";
		$("#coronaryDisease_relation").append(str);	
	}
	function delCoronaryDiseaseRelation(){
		$("#coronaryDisease_relation"+coronaryDiseaseRelationNum).remove();
		coronaryDiseaseRelationNum--;	
		$("#coronaryDisease_relation"+coronaryDiseaseRelationNum).append("<a href='javascript:void(0)' id='delCoronaryDiseaseRelation_button' onclick='delCoronaryDiseaseRelation()'  class='relation_button'>删除</a>");
	}
	
	
	
	var cardiovascularAccidentRelationNum=0;	
	function changeCardiovascularAccident(){
		var cardiovascularAccident=$("#cardiovascularAccident").val();
		if(cardiovascularAccident==1){
			cardiovascularAccidentRelationNum++;
			var str="<div id='cardiovascularAccident_relation"+cardiovascularAccidentRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='cardiovascularAccidentRelationName"+cardiovascularAccidentRelationNum+"'>";
			str+=relation_name_str+"</select>";
			str+="&nbsp;&nbsp;患病年份:<select id='cardiovascularAccidentRelationYear"+cardiovascularAccidentRelationNum+"'>";
			str+=relation_year_str+"</select></span>";
			str+="<a href='javascript:void(0)' id='delCardiovascularAccidentRelation_button' onclick='delCardiovascularAccidentRelation()' class='relation_button'>删除</a></div>";
			str+="<a href='javascript:void(0)' id='addCardiovascularAccidentRelation_button' onclick='addCardiovascularAccidentRelation()' class='relation_button'>+继续添加</a>";
			$("#cardiovascularAccident_relation").html(str);
		}
		else{
			cardiovascularAccidentRelationNum=0;
			$("#cardiovascularAccident_relation").html("");
		}
	}	
	function addCardiovascularAccidentRelation(){
		$("#addCardiovascularAccidentRelation_button").remove();
		$("#delCardiovascularAccidentRelation_button").remove();
		cardiovascularAccidentRelationNum++;	
		var str="<div id='cardiovascularAccident_relation"+cardiovascularAccidentRelationNum+"'><span class='select-style_relation'>亲属关系:<select id='cardiovascularAccidentRelationName"+cardiovascularAccidentRelationNum+"'>";
		str+=relation_name_str+"</select>";
		str+="&nbsp;&nbsp;患病年份:<select id='cardiovascularAccidentRelationYear"+cardiovascularAccidentRelationNum+"'>";
		str+=relation_year_str+"</select></span>";
		str+="<a href='javascript:void(0)' id='delCardiovascularAccidentRelation_button' onclick='delCardiovascularAccidentRelation()' class='relation_button'>删除</a></div>";
		str+="<a href='javascript:void(0)' id='addCardiovascularAccidentRelation_button' onclick='addCardiovascularAccidentRelation()' class='relation_button'>+继续添加</a>";
		$("#cardiovascularAccident_relation").append(str);	
	}
	function delCardiovascularAccidentRelation(){
		$("#cardiovascularAccident_relation"+cardiovascularAccidentRelationNum).remove();
		cardiovascularAccidentRelationNum--;	
		$("#cardiovascularAccident_relation"+cardiovascularAccidentRelationNum).append("<a href='javascript:void(0)' id='delCardiovascularAccidentRelation_button' onclick='delCardiovascularAccidentRelation()' class='relation_button'>删除</a>");
	}
</script>

</head>
<body  style="background:#e8e3d7">
<div style="font-size:13px;font-family:微软雅黑">
<form id="family_form">
        <!--basic_information start-->
        <div class="basic_information">
          <div class="btn_title_informationModify">
            <ul>
              <li class="tLeft" style="font-size:17px; font-weight:500;">家族遗传史</li>
              <li class="tRight"><a href="javascript:void(0)" onclick="edit_family(this)"><img src="../../../images/button/btn_editor.png" /></a></li>
            </ul>
          </div>
          <div class="informationModify_main2" style="overflow-y:auto;position:relative;height: 500px;">
            <ul>
             <li class="tLeft_informationModify">
               <ul>         	
                 <li class="tgrey_informationModify">高血压：</li>
                 <li class="tblack_informationModify">
                 	 <span class="select-style_familydisease">
	                 <select class="selectMax_informationModify" id="heighBloodPressure"  name="heighBloodPressure" onchange="changeHeighBloodPressure()">
				            <option value="0">无</option>
				            <option value="1">有</option>
	                 </select>
	                 </span>
                 </li>
                 <div class="family_disease_relation" id="heighBloodPressure_relation" align="left"  style="margin-left:80px;padding-top:40px"></div>
                        
                 <li class="tgrey_informationModify">高血脂：</li>
                 <li class="tblack_informationModify">
                 	<span class="select-style_familydisease">
	                 <select class="selectMax_informationModify" id="heighBloodFat"  name="heighBloodFat"  onchange="changeHeighBloodFat()">
				            <option value="0">无</option>
				            <option value="1">有</option>
	                 </select>    
	                 </span>             
                 </li>
                 <div class="family_disease_relation" id="heighBloodFat_relation" align="left"  style="margin-left:80px;padding-top:40px"></div>
                
                
                 <li class="tgrey_informationModify">糖尿病：</li>
                 <li class="tblack_informationModify">
                 <span class="select-style_familydisease">
	                 <select class="selectMax_informationModify" id="diabetesMellitus"  name="diabetesMellitus" onchange="changeDiabetesMellitus()">
				            <option value="0">无</option>
				            <option value="1">有</option>
	                 </select>   
	                 </span>                 
                 </li>
                 <div class="family_disease_relation" id="diabetesMellitus_relation" align="left"  style="margin-left:80px;padding-top:40px"></div>
                 
                 
                 <li class="tgrey_informationModify">冠心病：</li>
                 <li class="tblack_informationModify">
                 <span class="select-style_familydisease">
	                 <select class="selectMax_informationModify" id="coronaryDisease"  name="coronaryDisease"  onchange="changeCoronaryDisease()">
				            <option value="0">无</option>
				            <option value="1">有</option>
	                 </select>      
	                 </span>             
                 </li>
                 <div class="family_disease_relation" id="coronaryDisease_relation" align="left"  style="margin-left:80px;padding-top:40px"></div>
                 
                 
                 <li class="tgrey_informationModify">脑血管意外：</li>
                 <li class="tblack_informationModify">
                 <span class="select-style_familydisease">
	                 <select class="selectMax_informationModify" id="cardiovascularAccident"  name="cardiovascularAccident" onchange="changeCardiovascularAccident()">
				            <option value="0">无</option>
				            <option value="1">有</option>
	                 </select>         
	                 </span>          
                 </li>
                 <div class="family_disease_relation" id="cardiovascularAccident_relation" align="left"  style="margin-left:80px;padding-top:40px"></div>
                 
               </ul>
             </li>
            </ul>
          </div> 
        </div>
        <!--basic_information start-->
</form>


<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 
</div>
</body>
</html>