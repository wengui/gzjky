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
	var complication_form = "complication_form";
	var save_image = window.parent.save_image;
	$(function(){
		$("#"+complication_form+" :input").attr("disabled",true);
		queryMemberHtComplication();
	});

	function queryMemberHtComplication(){
		var requestUrl = "/gzjky/healthRecordAction/queryMemberHtComplication.do";
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
    			$("#"+complication_form+" #"+id).attr("checked",memberHtComplication[id]==1?true:false);
    		}
    	});
	}
	function edit_complication(obj){
		obj.onclick = function(){save_complication(obj);};
		$("#"+complication_form+" :input").attr("disabled",false);
		$(obj).find("img").attr("src",save_image);
	}
	function save_complication(obj){
		var url = "/gzjky/healthRecordAction/editMemberHtComplication.do";
		var para = get_requestPara(complication_form);
		send_request_forDisease(complication_form,obj,url,para);
	}
	
    function get_requestPara(formId){
    	return window.parent.get_requestPara("memberHtComplicationIframe",formId);
    }
    function send_request_forDisease(formId,obj,requestUrl,para){
    	window.parent.send_request_forDisease("memberHtComplicationIframe",formId,obj,requestUrl,para)
    }
</script>
</head>
<body>
<div style="font-size:13px;font-family:微软雅黑">
<form id="complication_form">
        <div class="tgreenPrompt"><span class="tblackPrompt">温馨提示：</span>项目字体为深色的，表明该项目有提示内容，请将鼠标放于项目上，提示内容自动显示。</div>
        <div class="btn_title_informationModify">
            <ul>
              <li class="tLeft">当前并发症</li>
              <li class="tRight"><a href="javascript:void(0)" onclick="edit_complication(this)"><img src="/images/button/btn_editor.png" /></a></li>
            </ul>
         </div>
        <div class="health_examination">
          <ul>
            <li class="tleft_healthExamination">脑血管病：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input id="brainBleeding" name="brainBleeding" type="checkbox" value="1" />脑出血</li>
                <li class="tright_healthExamination_check8"><input id="ischemicStroke"  name="ischemicStroke" type="checkbox" value="1" />缺血性脑卒中</li>
                <li class="tright_healthExamination_check9"><input id="transientIschemicAttack"  name="transientIschemicAttack" type="checkbox" value="1" />短暂性脑缺血发作</li>
              </ul>
            </li>
            <li class="tleft_healthExamination">心脏疾病：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input id="myocardialInfarctionHistory"  name="myocardialInfarctionHistory" type="checkbox" value="1" />心肌梗死史</li>
                <li class="tright_healthExamination_check8"><input id="angina"  name="angina" type="checkbox" value="1" />心绞痛</li>
                <li class="tright_healthExamination_check9"><input id="revascularization"  name="revascularization" type="checkbox" value="1" />冠状动脉血运重建史</li>
                <li class="tright_healthExamination_check11"><input id="congestiveHeartFailure"  name="congestiveHeartFailure" type="checkbox" value="1" />充血性心力衰竭</li>
              </ul>
            </li>
            <li class="tleft_healthExamination">肾脏疾病：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input id="diabeticNephropathy"  name="diabeticNephropathy"  type="checkbox" value="1" />糖尿病肾病</li>
                <li class="tright_healthExamination_check8"><input id="renalImpairment"  name="renalImpairment" type="checkbox" value="1" />肾功能受损</li>
              </ul>
            </li>
            <li class="tleft_healthExamination">视网膜病变：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input id="haemorrhagesOrExudates"  name="haemorrhagesOrExudates" type="checkbox" value="1" />出血或渗出</li>
                <li class="tright_healthExamination_check8"><input id="lookMammillaEdema"  name="lookMammillaEdema" type="checkbox" value="1" />视乳头水肿</li>
              </ul>
            </li>
            <li class="tleft_healthExamination">糖尿病：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input id="diabetesMellitus"  name="diabetesMellitus" type="checkbox" value="1" />
                <a href="javascript:void(0)"  title="空腹血糖：≥7.0mmol/L( 126mg/dL)
餐后血糖：≥11.1mmol/L( 200mg/dL)
糖化血红蛋白：(HbA1c)≥6.5%
		          ">糖尿病</a>
                </li>
              </ul>
            </li>
            <li class="tleft_healthExamination">外周血管病：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input  id="peripheralVascular"  name="peripheralVascular" type="checkbox" value="1" />外周血管病</li>
              </ul>
            </li>
            <li class="tleft_healthExamination">心血管危险因素：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input id="impairedGlucoseTolerance"  name="impairedGlucoseTolerance" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="2小时血糖7.8-11.0 mmol/L">糖耐量受损</a>
                </li>
                <li class="tright_healthExamination_check8"><input id="fastingGlucose"  name="fastingGlucose" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="6.1-6.9 mmol/L">空腹血糖异常</a>
                
                </li>
                <li class="tright_healthExamination_check9"><input id="dyslipidemia" name="dyslipidemia" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="TC≥5.7mmol/L(220mg/dL)或
LDL-C>3.3mmol/L(130mg/dL)或  
HDL-C<1.0mmol/L(40mg/dL)">血脂异常</a>
                </li>
              </ul>
            </li>
            <li class="tleft_healthExamination">靶器官损害：</li>
            <li class="tright_healthExamination">
              <ul>
                <li class="tright_healthExamination_check8"><input id="leftVentricularHypertrophy"  name="leftVentricularHypertrophy" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="心电图：
Sokolow-Lyons>38mv或Cornell>2440mm•mms
超声心动图LVMI：
男125, 女120g/m2">左心室肥厚</a>
                </li>
                <li class="tright_healthExamination_check8"><input id="carotidUltrasoundAbnormalities"  name="carotidUltrasoundAbnormalities" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="IMT>0.9mm">颈动脉超声异常</a>
                </li>
                <li class="tright_healthExamination_check9"><input id="atheroscleroticPlaque" name="atheroscleroticPlaque" type="checkbox" value="1" />动脉粥样斑块</li>
                <li class="tright_healthExamination_check11"><input id="carotidFemoralPulseWva" name="carotidFemoralPulseWva" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="脉搏波速度>12m/s">颈股动脉脉搏波速度异常</a>
                </li>
                <li class="tright_healthExamination_check8"><input id="abnormalAnkleBrachialBPI"  name="abnormalAnkleBrachialBPI" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="血压指数<0.9">踝臂血压指数异常</a>
                </li>
                <li class="tright_healthExamination_check8"><input id="glomerularFiltrationRate"  name="glomerularFiltrationRate" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="eGFR<60ml/min/1.73m2">肾小球滤过率降低</a>
                </li>
                <li class="tright_healthExamination_check9"><input id="heightMildSerumCreatinine" name="heightMildSerumCreatinine" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="男性115-133mol/L(1.3-1.5mg/dL)，
女性107-124mol/L(1.2-1.4mg/dL)">血清肌酐轻度升高</a>
                </li>
                <li class="tright_healthExamination_check11"><input id="microalbuminuria"  name="microalbuminuria" type="checkbox" value="1" />
                <a href="javascript:void(0)"  title="30-300mg/24h">微量白蛋白尿</a>
                </li>
                <li class="tright_healthExamination_check8"><input  id="abnormalAlbuminCreatinineRatio"  name="abnormalAlbuminCreatinineRatio" type="checkbox" value="1" />
                <a href="javascript:void(0)" title="≥30mg/g(3.5mg/mmol)">白蛋白肌酐比异常</a>
                </li>
              </ul>
            </li>
          </ul>
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