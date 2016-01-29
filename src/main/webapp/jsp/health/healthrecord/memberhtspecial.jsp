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
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/dictionaryInfo.js'/>" type="text/javascript"></script>
<style type="text/css">
.advice_main table tr td span{float: right;text-align: right;}
</style>
<script type="text/javascript">
		var save_image = window.parent.save_image;
		var edit_image = window.parent.edit_image;
		function startInit(){
			queryDictionaryInfo("memberHtspecial");
			queryHtspecial();
	    	jQuery('#htspecialForm').validationEngine("attach",
	    			{
	    				promptPosition:"centerRight:0,-10",
	    				maxErrorsPerField:1,
	    				scroll:false,
	    				focusFirstField:false
	    			}
	    	);
			
		};
		
		function queryHtspecial(){
			var requestUrl = "/gzjky/healthRecordAction/queryMemberHtSpecial.do";
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
				    var memberHtSpecial = response.result;
				    if(memberHtSpecial != null){
				    	init_memberHtSpecial(memberHtSpecial);
				    	$("#RiskLevel").val(memberHtSpecial.riskLevel);
				    }else{    	
				    	$("#htspecialForm"+" :input").attr("disabled",true);
				    	$("#htspecialForm .from-med-tab").find("a").attr("disabled",true);
				    	$("#htspecialForm .from-med-table2").find("a").attr("disabled",true);
				    }
				}
			});
		}
		function init_memberHtSpecial(obj){
			$("#htspecialForm").jsonForForm({data:obj,isobj:true});
			$("input[name='isUseMedicine'][value='"+obj.isUseMedicine+"']").attr("checked",true);
			var medicalDetailTable = document.getElementById("med_table");
			var medicineTakenItems = obj.medicineTakenItems;
			if(medicineTakenItems != null){
				for(var k=0;k<medicineTakenItems.length;k++){
					var temp = medicineTakenItems[k];
					createMedicalDetailTable(medicalDetailTable,temp);
				}
			}
			
			$("#htspecialForm"+" :input").attr("disabled",true);
			$("#htspecialForm .from-med-tab").find("a").attr("disabled",true);
	    	$("#htspecialForm .from-med-table2").find("a").attr("disabled",true);
		}
		

		function clearHtspecialTable(table){
			while (table.rows[1]){
				table.deleteRow(1);
			}
		}
		
		function showData(){
			  var table = document.getElementById("htspecialTable");
			  clearHtspecialTable(table);
			  for(var i=0;i<$.fn.page.settings.currentsize;i++){
				  addHtspecialTable(table,i,recordList);
			  }
			  $("table.bPhistory_table tr:even").addClass("even");
			  $("table.bPhistory_table tr:odd").addClass("odd");
		}
		
		function addHtspecialTable(table,i,recordList){
			try{
				 var rowcount=table.rows.length;
				 var tr=table.insertRow(rowcount);
				 var id  = recordList[i].id;
				 td=tr.insertCell(0);
				 td.innerHTML = "&nbsp;&nbsp;&nbsp;" + (($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize + (i+1));
				 td=tr.insertCell(1);
				 td.innerHTML = recordList[i].havaBloodDate;
				 
				 td=tr.insertCell(2);
				 td.innerHTML = recordList[i].isUseMedicine == 1?"是":"否";
				 
				 td=tr.insertCell(3);
				 td.innerHTML = recordList[i].sbp;
				 
				 td=tr.insertCell(4);
				 td.innerHTML = recordList[i].dbp;
				 
				 td=tr.insertCell(5);
				 td.nowrap="nowrap";
				 td.innerHTML =  "<a href='javascript:void(0)' class='btn btn-success' onclick='updateHtspecial("+i+")'>查看</a>";
			}catch(e){
	    		$.alert('数据加载错误');
	   		}
		}
		function clearMedicalDetailTable(table){
			while (table.rows[1]){
				table.deleteRow(1);
			}
		}
		function createMedicalDetailTable(table,obj){
			 var rowcount=table.rows.length;
			 var tr=table.insertRow(rowcount);
			 var td=tr.insertCell(0);
			 td.innerHTML = 	'<input type="text" onclick="showMedicine(this)" class="med_hour validate[required]" name="medicine_taken.name" readonly="readonly" data-prompt-position="topLeft:0,0" onblur="validateControl(this)"/>';
			 
			 $('input[name="medicine_taken.name"]',td).val(obj.name);
			 td=tr.insertCell(1);
			 td.innerHTML = '<input type="text" class="med_dosage validate[required,minSize[2],maxSize[12]]" name="medicine_taken.dosage" value="'+obj.dosage+'" data-prompt-position="topLeft:25,0" onblur="validateControl(this)"/>' ;
			 td=tr.insertCell(2);
			 td.innerHTML = '<input type="text" onclick="showHours(this)" class="med_hour validate[required]" name="medicine_taken.hours"  readonly="readonly" value="'+obj.takeTime+'" data-prompt-position="topLeft:45,0" onblur="validateControl(this)"/>';
			
			 td=tr.insertCell(3);
			 td.innerHTML = '<a href="javascript:void(0)" class="btn btn-success del-show-status" onclick="deleteMed(this)" style="display: block;">删除</a>';
			 td.nowrap="nowrap" ;
		}
		
		var Htspecial_popType;
		//显示输入窗口
		function updateHtspecial(index){
			$("#htspecial_record").attr("style","display:none");
			$("#add_htspecial").attr("style","display:block");
			
			$("#htspecialForm").clearForm();
			jQuery('#htspecialForm').validationEngine("hide");
			
			Htspecial_popType = "edit";
			$("#htspecialForm").jsonForForm({data:recordList[index],isobj:true});
			$("input[name='isUseMedicine'][value='"+recordList[index].isUseMedicine+"']").attr("checked",true);
			var medicalDetailTable = document.getElementById("med_table");
			clearMedicalDetailTable(medicalDetailTable);
			var medicineTakenItems = recordList[index].medicineTakenItems;
			if(medicineTakenItems != null){
				for(var k=0;k<medicineTakenItems.length;k++){
					var obj = medicineTakenItems[k];
					createMedicalDetailTable(medicalDetailTable,obj);
				}
			}
			
			$("#htspecialForm"+" :input").attr("disabled",true);
			$("#htspecialForm .from-med-tab").find("a").attr("disabled",false);
	    	$("#htspecialForm .from-med-table2").find("a").attr("disabled",false);
			
			var btn_obj = document.getElementById("editHtspecialBtn");
			btn_obj.onclick = function(){edit_htSpecial(btn_obj);};
			$(btn_obj).find("img").attr("src",edit_image);
		}
		function addHtspecial(){
			//window.location.href = "modify_htspecial.jsp";
			
			$("#htspecial_record").attr("style","display:none");
			$("#add_htspecial").attr("style","display:block");
			
			$("#htspecialForm").clearForm();
			jQuery('#htspecialForm').validationEngine("hide");
			Htspecial_popType = "add";
			$("input[name='isUseMedicine'][value='1']").attr("checked",true);
			var medicalDetailTable = document.getElementById("med_table");
			clearMedicalDetailTable(medicalDetailTable);
			
		}
		
		function closeDiv_htspecial() {
			$("#htspecialWindow").hide(200);
			$("#medicine").hide(200);
			$("#med_hours").hide(200);
			hideScreenProtectDiv(1);
		}
		
		function showHtspecialRecord(){
			$("#htspecial_record").css("display","block");
			$("#add_htspecial").css("display","none");
		}
		function showAddspecial(){
			$("#htspecial_record").css("display","none");
			$("#add_htspecial").css("display","block");
		}
		
		function saveHtspecial(obj){
			if(!jQuery('#htspecialForm').validationEngine('validate')) return false;
			var requestUrl = "/gzjky/healthRecordAction/editMemberHtSpecial.do";
			var para  = $("#htspecialForm").dataForJson({prefix:''});
			var isUseMedicine = $("input[name='isUseMedicine']:checked").val();
			var id = $("#id").val();
			para += "&isUseMedicine=" + isUseMedicine;
			para += "&id=" + id;
			para += "&detail="+getMedicineXml();

			
			
			showScreenProtectDiv(2);
		    showLoading();
			xmlHttp = $.ajax({
				url: requestUrl,
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				complete:function(){

				},
				error:function(){
					$.alert('无权限');
				},success:function(response){
				    hideScreenProtectDiv(2);
			        hideLoading();
				    var state = response.updateFlag;
				    if(state == "1"){
				    	$.alert('保存成功！');
				    	//if(Htspecial_popType == "add"){
							$.fn.page.settings.realcount++;
							$.fn.page.settings.currentnum = 1;
							
							$("#htspecialForm"+" :input").attr("disabled",true);
							$("#htspecialForm .from-med-tab").find("a").attr("disabled",true);
					    	$("#htspecialForm .from-med-table2").find("a").attr("disabled",true);
							obj.onclick = function(){edit_htSpecial(obj);};
							$(obj).find("img").attr("src",edit_image);
				    	//}
				    	//closeDiv_htspecial();
				    	//showHtspecialRecord();
				    	//query();
				    }else if(state == "0"){
				    	$.alert('保存失败！');
				    }
				}
			});
		}
		
		
		function addMed(){
			var flag = false;
			jQuery('#med_table input').each(function(index,obj){
				if(jQuery(obj).validationEngine('validate')){
					flag = true;
				}
			});
			if(flag == true){
				$.alert("请填写信息完整后再继续添加");
				return false;
			}
			
			var delBtn='<a href="javascript:void(0)" class="btn btn-success del-show-status" onclick="deleteMed(this)" style="display: block;">删除</a>';
			$("#med_table").append('<tr>'
							+'<td>'
								+'<input type="text" onclick="showMedicine(this)" class="med_hour validate[required]" name="medicine_taken.name" readonly="readonly" data-prompt-position="topLeft:0,0" onblur="validateControl(this)"/>'
							+'</td>'
							+'<td>'
								+'<input type="text" class="med_dosage validate[required,minSize[2],maxSize[12]]" name="medicine_taken.dosage" data-prompt-position="topLeft:25,0" onblur="validateControl(this)"/>' 
							+'</td>'
							+'<td>'
								+'<input type="text" onclick="showHours(this)" class="med_hour validate[required]" name="medicine_taken.hours"  readonly="readonly" data-prompt-position="topLeft:45,0" onblur="validateControl(this)"/>'
							+'</td>'
							+'<td nowrap="nowrap" >'
								+delBtn	
							+'</td>'
						+'</tr>');
		}
		function validateControl(obj){
			jQuery(obj).validationEngine('validate');
		}
		
		function deleteMed(obj){
			$(obj).parent().parent().remove(); 
		}		
		
		function showHours(obj){
			var inputs=$("#hour_med input");
			for(var j=0;j<inputs.length;j++){
				inputs[j].checked="";
			}
			var i=$(obj).parent().parent().index();
			$("#rowIndex").val(i);
			var hour=$(obj).val();
			if(hour!=null&&hour!=""){
				var hours=hour.split("/");
				for(var i=0;i<hours.length;i++){
					var lis=$("#hour_med input");
					for(var j=0;j<lis.length;j++){
						if(lis[j].value==hours[i]){
							lis[j].checked="checked";
						}
					}
				}
			}//文本框赋值
	  		$("#med_hours").draggable({
				disabled : false
			});
			$("#med_hours").show(200);
			showScreenProtectDiv(1);
		}
		
		//关闭窗口
		function closeHours() {
			var i=$("#rowIndex").val();
			i=parseInt(i)-1;
			var hours="";
			$('#med_hours input[type="checkbox"]:checked').each(function(index){
				if(hours=="")
					hours+=$(this).val();
	            else hours+="/"+$(this).val();
	        });
	        $('input[name="medicine_taken.hours"]').each(function(index){
	        	if(index==i){
	        		$(this).val(hours);
	        	}
	        });
			$("#med_hours").hide(200);
			hideScreenProtectDiv(1);
		}
		
		//关闭窗口
		function closeMedicine() {
			var i=$("#rowIndex").val();
			i=parseInt(i)-1;
			var len = $("#faceTable :checkbox:checked[name=med_id]").length;
			if(len <=0){
				$.alert('请先选择一项！');
				return false;
			}
			if(len > 1){
				$.alert('只能选择一项！');
				return false;
			}
			var name = $("#faceTable :checkbox:checked[name=med_id]").val();
			var inputs=$("#faceTable input[name=med_id]");
			for(var j=0;j<inputs.length;j++){
				inputs[j].checked="";
			}
	        $('input[name="medicine_taken.name"]').each(function(index){
	        	if(index==i){
	        		$(this).val(name);
	        	}
	        });
			$("#medicine").hide(200);
			hideScreenProtectDiv(1);
		}
		
		function getMedicineXml(){
			var medicine=[];
			var medicalDetailTable = document.getElementById("med_table");
			var rowcount=medicalDetailTable.rows.length;
			for(var i=1;i<rowcount;i++){
				var mddicineDetail = [];
				var name=$('input[name="medicine_taken.name"]',medicalDetailTable.rows[i]);
				var fre=$('input[name="medicine_taken.dosage"]',medicalDetailTable.rows[i]);
				var hour=$('input[name="medicine_taken.hours"]',medicalDetailTable.rows[i]);
				mddicineDetail.push(name.val());
				mddicineDetail.push(fre.val());
				mddicineDetail.push(hour.val()+";");
				medicine.push(mddicineDetail);
			}
			return medicine;
		}
		
		var medical_obj;
		function showMedicine(obj){
			var url = "medicine.jsp";
			medical_obj = obj
			window.open( url ,'eeeee','fullscreen=no, resizable=no, status=no, z-look=yes, titlebar=no, scrollbars=no, toolbar=no, menubar=no, location=no, top=200, left=200, width=750, height=550') ;
		}
		
		function edit_htSpecial(obj){
			$("#htspecialForm"+" :input").attr("disabled",false);
			$("#htspecialForm .from-med-tab").find("a").attr("disabled",false);
	    	$("#htspecialForm .from-med-table2").find("a").attr("disabled",false);
			obj.onclick = function(){saveHtspecial(obj);};
			$(obj).find("img").attr("src",save_image);
		}
		
</script>
</head>
<body onload="startInit()"  class="skin-blue">
<div  id="" >

<div class=""  >
<form id="htspecialForm" > 
  	<input type="hidden" name="id"  id="id"  />
  	<!-- box box-info start -->
	<div class="box box-info">
              <div class="box-header">
                  <h3 class="box-title">高血压专项</h3>
              </div>		
              <div class="box-body">
				         <div class="row form-group btn_title_informationModify">
					          	<div class="col-lg-10 text-right" id="editImage" href="javascript:void(0)" onclick="edit_htSpecial(this)" id="editHtspecialBtn">
					          		<a class="btn btn-success">
					                   <i class="fa fa-edit"></i> 编辑
					             	</a>
					            </div>
 							</div>
	 			         <div class="row">
					         <div class="col-lg-11">
					         	<div class="col-lg-12">
					         	<div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<span class="col-lg-4 text-right form-span" >*患高血压日期：</span>
						        	<input class="col-lg-6 display-input validate[required]" type="text"  id="havaBloodDate"  name="havaBloodDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-%d'})" data-prompt-position="centerRight:0,-5"/>
						        </div>
						        <div class="col-lg-2">&nbsp;</div>
						        </div>
						        <div class="col-lg-12">
					         	<div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<lable class="col-lg-4 text-right form-span">*是否用药：</lable>
						        	<label class="checkbox-inline col-lg-2">
	                 				<input type="radio" class="col-lg-10 text-right form-span" name="isUseMedicine" value="1" checked="checked" >是</input>
	                 				</label>
	                 				<label class="checkbox-inline col-lg-2">
		            				<input type="radio" class="col-lg-10 text-right form-span" name="isUseMedicine" value="0">否</input>
		            				</label>
						        </div>
						        <div class="col-lg-2">&nbsp;</div>
						        </div>

								<div class="col-lg-12">
					         	<div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<span class="col-lg-4 text-right  form-span">*疗效及副作用：</span>
	                 				<textarea rows="10" cols="10" id="effect"  name="effect"  class="col-lg-6 display-textarea validate[required,funcCall[includespecialchar]]"  data-prompt-position="topRight:-200,0"></textarea>    
						        </div>
						        <div class="col-lg-2">&nbsp;</div>
						        </div>
						        
						        <div class="col-lg-12">
					         	<div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<lable class="col-lg-4 text-right form-span">*最高收缩压：</lable>
	                 				<input class="col-lg-6 display-input validate[required,funcCall[number2]]"  type="text"   id="sbp"  name="sbp"  maxlength="9"  data-prompt-position="centerRight:40,-5"/>mmHg      
						        </div>
						        <div class="col-lg-1">&nbsp;</div>
						        </div>
						        
						        <div class="col-lg-12">
					         	<div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<span class="col-lg-4 text-right form-span">*最高舒张压：</span>
	                 				<input class="col-lg-6 display-input validate[required,funcCall[number2]]"  type="text"   id="dbp"  name="dbp"  maxlength="9"  data-prompt-position="centerRight:40,-5"/>mmHg          
                 					
						        </div>
						        <div class="col-lg-1">&nbsp;</div>
						        </div>
						        <div class="col-lg-12">
					         	<div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<span class="col-lg-4 text-right form-span">血压等级：</span>
						        	<select id="BPLevel" class="col-lg-6 display-input" ></select>
						        </div>
						        <div class="col-lg-2">&nbsp;</div>
						        </div>
						        <div class="col-lg-12">
					         	<div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<span class="col-lg-4 text-right form-span">风险等级：</span>
						        	<select id="RiskLevel" class="col-lg-6 display-input" ></select>
						        </div>
						        <div class="col-lg-2">&nbsp;</div>
						        </div>
						        <div class="col-lg-12">
						        <div class="col-lg-12">
						        <div class="col-lg-2">&nbsp;</div>
						        <div class="col-lg-8">
						        	<span class="col-lg-4 text-right form-span">*当前服用药物：</span>
						        	<span class="col-lg-6">&nbsp;</span>
						        </div>
						        <div class="col-lg-2">&nbsp;</div>
						        </div>
						        <div class="col-lg-12">
						        	<div class="col-lg-3">&nbsp;</div>
						        	<div class="col-lg-8 table-medicine">
    								<div class="from-med-tab">
    									<a href="javascript:void(0)" class="btn btn-success del-show-status" onclick="addMed()">继续添加</a> 
    								</div>
    								<table cellpadding="0" cellspacing="0" width="100%" class="from-med-table2" id="med_table">
    									<colgroup>
						        			<col width="30%" />
						        			<col width="30%" />
						        			<col width="30%" />
						        			<col width="10%" />
						    			</colgroup>
    									<tr>
    										<th>*药物名称</th>
    										<th>*剂量(mg或g)</th>
    										<th>*用药时间</th>
    										<th>&nbsp;</th>
    									</tr>
    								</table>
    								</div>
    							</div>
						        </div>
						        
				        </div>
			        </div>
			     </div>
			     <!-- box box-info End -->
			    </div>
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
<title>995120健康服务中心</title>
<style type="text/css">
.tgreen_bp{
	background:url(../images/icon/greenMax.png) right center no-repeat;
	width:100%;
	text-align:left; 
	float:left; 
	height:auto; 
	color:#5a5a5a; 
	border-bottom:1px dotted #aeaeae;
}
.hour{margin: 0 0 0 30px;}
</style>
<script type="text/javascript">
//关闭窗口
function closeHours() {
	var i=$("#rowIndex").val();
	i=parseInt(i)-1;
	var hours="";
	$('#med_hours input[type="checkbox"]:checked').each(function(index){
		if(hours=="")
			hours+=$(this).val();
           else hours+="/"+$(this).val();
       });
       $('input[name="medicine_taken.hours"]').each(function(index){
       	if(index==i){
       		$(this).val(hours);
       		jQuery(this).validationEngine('validate');
       	}
       });
	closeHoursDiv();
}
function closeHoursDiv(){
	$("#med_hours").hide(200);
	hideScreenProtectDiv(1);
}
</script>
</head>

<body>
	<input type="hidden" id="rowIndex" />
	<div class="popup" id="med_hours" style="display:none;position:absolute;top:300px; left:100px;z-index: 6000;">
		<div class="popup_header">
			<ul>
	      		<li class="name_popupHeader">用药时间</li>
	      		<li class="close_popupHeader"><a href="javascript:void(0)" onclick=""></a></li>
	    	</ul>
	  	</div>
	  
	  	<div class="popup_main">
	    	<ul>
		   		<li class="tgreen_bp" >
   					<div class="hour" id="hour_med">
   						<input type="checkbox" value="00:00"/> 00:00 &nbsp;
   						<input type="checkbox" value="01:00"/> 01:00 &nbsp;
   						<input type="checkbox" value="02:00"/> 02:00 &nbsp;
   						<input type="checkbox" value="03:00"/> 03:00 &nbsp;
   						<input type="checkbox" value="04:00"/> 04:00 &nbsp;
   						<input type="checkbox" value="05:00"/> 05:00 <br/>
   						<input type="checkbox" value="06:00"/> 06:00 &nbsp; 
   						<input type="checkbox" value="07:00"/> 07:00 &nbsp;
   						<input type="checkbox" value="08:00"/> 08:00 &nbsp;
   						<input type="checkbox" value="09:00"/> 09:00 &nbsp;
   						<input type="checkbox" value="10:00"/> 10:00 &nbsp;
   						<input type="checkbox" value="11:00"/> 11:00 <br/>
   						<input type="checkbox" value="12:00"/> 12:00 &nbsp;
   						<input type="checkbox" value="13:00"/> 13:00 &nbsp;
   						<input type="checkbox" value="14:00"/> 14:00 &nbsp;
   						<input type="checkbox" value="15:00"/> 15:00 &nbsp;
   						<input type="checkbox" value="16:00"/> 16:00 &nbsp;
   						<input type="checkbox" value="17:00"/> 17:00 <br/>
   						<input type="checkbox" value="18:00"/> 18:00 &nbsp;
   						<input type="checkbox" value="19:00"/> 19:00 &nbsp;
   						<input type="checkbox" value="20:00"/> 20:00 &nbsp;
   						<input type="checkbox" value="21:00"/> 21:00 &nbsp;
   						<input type="checkbox" value="22:00"/> 22:00 &nbsp;
   						<input type="checkbox" value="23:00"/> 23:00 &nbsp;
   					</div>
    			</li>
		   		<li class="btn_popup_confirm" style="width: 65%;padding-left: 35%">
		   			<a id="closeTips" href="javascript:void(0)" onclick="closeHours();">确定</a>
		   			<a id="closeDiv" href="javascript:void(0)" onclick="closeHoursDiv();">取消</a>
		   		</li>
			</ul>
	  	</div>
	</div>
</body>
</html>

</body>
</html>