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
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script type="text/javascript">
	var complication_form = "complication_form";
	var edit_image = window.parent.edit_image;
	var save_image = window.parent.save_image;

	function startInit(){
		$(".no-print").remove();
		reloadCheckBox() ;
		
		$("#"+complication_form+" :input").attr("disabled",true);
		queryMemberHtComplication();
		
		$(window.parent.document).find("#memberHtComplicationIframe").load(function(){
			var main = $(window.parent.document).find("#memberHtComplicationIframe");
			var thisheight = $(document).height()+30;
			main.height(thisheight);
			});
	};

	function queryMemberHtComplication(){
		var requestUrl = "/gzjky/healthRecordAction/queryMemberHtComplication.do";
		var para = "";
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
			    var memberHtComplication = response.result;
			    if(memberHtComplication != null){
			    	init_memberHtComplication(memberHtComplication);
			    }else{
			    	//$.alert("没有查到相关数据");
			    }
			}
		});
	}
	
	function init_memberHtComplication(memberHtComplication){
    	$("#"+complication_form+" :input").each(function(index,obj){
    		var id = obj.id;
    		if(id in memberHtComplication){
    			$("#"+complication_form+" #"+id).attr("checked",memberHtComplication[id]==$("#"+id).val()?true:false);
    		}
    	});
	}
	function edit_complication(obj){
		obj.onclick = function(){save_complication(obj);};
		$("#"+complication_form+" :input").attr("disabled",false);
		$("#editImage").empty();
		$("#editImage").html(save_image);
	}
	function save_complication(obj){
		var url = "/gzjky/healthRecordAction/editMemberHtComplication.do";
		var para = get_requestPara(complication_form);
		send_request_forDisease(complication_form,obj,url,para);
	}
	
    function get_requestPara(formId){
    	return getRequestPara("memberHtComplicationIframe",formId);
    }
    
	function getRequestPara(iframeId,formId){
		var para = "";
		$("#"+formId+" :input").each(function(index,obj){
			if(obj.type== "checkbox"){
				if(obj.checked == true){
					para += obj.id+"=" +obj.value + "&";
				}else{
					para += obj.id+"=" +"" + "&";
				}
			}else{
				para += obj.id+"=" +obj.value + "&";
			}
		});
		
		return para.substring(0,para.length);
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
			    		edit_complication(obj);
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
    
    function reloadCheckBox() {
		para='';
		xmlHttp = $.ajax({
		url:'/gzjky/healthRecordAction/queryDisease.do',
		async:false,
		data:para,
		dataType:"json",
		type:"POST",
		error:function(){
			$.alert('无权限或操作异常');
		},success:function(response){
			
			var state = response.updateFlag;
			var recordList = [];
			if(state=='1'){
				recordList = response.outBeanList;

				showCheckBox(recordList);
			}else if(state=='2'){
				$.alert('未知的错误');
			}
		}
	}); 
	}
    
    function showCheckBox(recordList){
    	
    	var $ul = $("#"+"health_ul");   //获取UL对象
    	
		 var $htmlLi = '';  //创建DOM对象
		
		 
         
		var count = 0;
		for (var i = 0; i < recordList.length; i++){	
			
			var $htmlUlStart = $("<li class='input-group col-lg-9 col-xs-9'><ul id = li_ul"+i+">"); // 创建DOM对象 ul			
			var $htmlLiId = $("<li class='col-lg-3 col-xs-3 form-li form-font-bold text-right'>"+recordList[i].diseasename+"：</li>"); // 创建DOM对象 疾病类别
			var $htmlLiName = '';
			if(recordList[i].comment == null || recordList[i].comment == ''){
				$htmlLiName = $("<li class='col-lg-4 col-xs-4 form-li'><input class='form-input-checkbox' id="+recordList[i].diseaseidvalue+" name="+recordList[i].diseaseidvalue+" type='checkbox' value="+recordList[i].diseaseidvalue+" /><span class='form-font-size'>"+recordList[i].diseasesubname+"</span></li>"); // 创建DOM对象 li
			}else{
				$htmlLiName = $("<li class='col-lg-4 col-xs-4 form-li'><input class='form-input-checkbox' id="+recordList[i].diseaseidvalue+" name="+recordList[i].diseaseidvalue+" type='checkbox' value="+recordList[i].diseaseidvalue+" />"+
						 "<a href='javascript:void(0)' title="+recordList[i].comment+">"+recordList[i].diseasesubname+"</a></li>"); // 创建DOM对象 li
			}
			 
			if(i == 0){
				$ul.append($htmlLiId);
				$ul.append($htmlUlStart);
				count = i;
				var $getul = $("#"+'li_ul'+count);
		         $getul.append($htmlLiName);
				
			}else{
				if(i < recordList.length && i != 0){
					if(recordList[i].diseasename != recordList[i-1].diseasename){
						$ul.append($htmlLiId);
						//$ul.append($htmlSubLi);
						$ul.append($htmlUlStart);
						count = i;
					}
				}
			
			var $getul = $("#"+'li_ul'+count);
	         $getul.append($htmlLiName); 
	         
		}
    }
   }
    
</script>
</head>
<body onload="startInit()"  class="skin-blue">
<form id="complication_form">
 <div>
        <div class="box box-info">
              <div class="box-header">
                 <h3 class="box-title">当前并发症</h3>
              </div>		
              <div class="box-body">
				         <div class="row form-group btn_title_informationModify">
					          	<div class="col-lg-10 col-xs-10 text-right" id="editImage" href="javascript:void(0)" onclick="edit_complication(this)">
					          		<a class="btn btn-success">
					                   <i class="fa fa-edit"></i> 编辑
					             	</a>
					            </div>
 							</div>
 						<div class="row" id="health_examination">
            					<ul class="col-lg-12 col-xs-12" id="health_ul">
																		
            					</ul>
            			</div>
			     </div>
			    </div>
        </div>
</form>
 

<div id="divloading">
	<img src="<c:url value='/images/public/blue-loading.gif'/>" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 
</body>
</html>