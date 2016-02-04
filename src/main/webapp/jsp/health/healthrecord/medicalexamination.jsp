<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet"  type="text/css"/>
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
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

<script type="text/javascript">

function startInit(){
			$('.massage').hide();
	    	jQuery('#medicalExaminationForm').validationEngine("attach",
	    			{
	    				promptPosition:"centerRight:0,-10",
	    				maxErrorsPerField:1,
	    				scroll:false
	    				//binded:false,
	    				//showArrow:false,
	    			}
	    	);
			query();
		};
		function query(){
		 	$('#selAll').iCheck('uncheck');
			var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
			if(pointerStart<0)
	    		pointerStart = 0;
			var requestUrl = "/gzjky/healthRecordAction/queryMemberMedicalExaminationList.do";
			//var create_time = $("#create_time").val();
			var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id
						+"&member_unit_type="+window.parent.member_unit_type
						+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize
						//+"&create_time="+create_time;
		
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
					
					recordList = response.outBeanList;
					if(recordList.length == 0){
						$('.commonPage').hide();
						$('.massage').show();
					}
					$.fn.page.settings.count = response.recordTotal;
					page($.fn.page.settings.currentnum);
				}
			});
		}
		function clearMedicalExaminationTable(table){
			while (table.rows[1]){
				table.deleteRow(1);
			}
		}
		
		function showData(){
			  var table = document.getElementById("medicalExaminationTable");
			  clearMedicalExaminationTable(table);
			  for(var i=0;i<$.fn.page.settings.currentsize;i++){
				  addMedicalExaminationTable(table,i,recordList);
			  }
			  $("table.bPhistory_table tr:even").addClass("even");
			  $("table.bPhistory_table tr:odd").addClass("odd");
		}
		
		function addMedicalExaminationTable(table,i,recordList){
			try{
				 var rowcount=table.rows.length;
				 var tr=table.insertRow(rowcount);
				 var id  = recordList[i].id;
				 var chxt = recordList[i].chxt;
				 var kfqxxt = recordList[i].kfqxxt;
				 var zdgc = recordList[i].zdgc;
				 var gmdzdbdgc = recordList[i].gmdzdbdgc;
				 var dmdzdbdgc = recordList[i].dmdzdbdgc;
				 var xqjq = recordList[i].xqjq;
				 var wlnbdb = recordList[i].wlnbdb;
				 tr.name = i;
				 td=tr.insertCell(0);
				 td.innerHTML = '<input type="checkbox" id="selectCheckbox" class="form-input-checkbox" name="selectCheckbox" onclick="selectCheckBox(this)" value="'+id+'"/>'+'&nbsp;&nbsp;'+(($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize + (i+1));
				 td=tr.insertCell(1);
				 td.innerHTML = chxt+"mmol/L";
				 
				 td=tr.insertCell(2);
				 td.innerHTML = kfqxxt+"mmol/L";
				 
				 td=tr.insertCell(3);
				 td.innerHTML = zdgc+"mmol/L";
				 
				 td=tr.insertCell(4);
				 td.innerHTML = gmdzdbdgc+"mmol/L";
				 
				 td=tr.insertCell(5);
				 td.innerHTML = dmdzdbdgc+"mmol/L";
				 
				 td=tr.insertCell(6);
				 td.innerHTML = xqjq+"μmol/L";
				 
				 //td=tr.insertCell(7);
				 //td.innerHTML = wlnbdb+"mg/24h";
			}catch(e){
	    		$.alert('数据加载错误');
	   		}
		}
		
		//显示输入窗口
		function showMedicalExamintionDialog(obj){
		    var tt = "增加医学检查";
			$("#medicalExaminationForm").clearForm();
			jQuery('#medicalExaminationForm').validationEngine("hide");
			medicalExamination_popType = "add";
			
			if(obj == 1){
				medicalExamination_popType = "edit";
				tt = "编辑医学检查";
				
				var len = $("#medicalExaminationTable :checkbox:checked[name=selectCheckbox]").length;
  				if(len <=0){
					$.alert('请先选择一项！');
					return false;
				}
  				if(len > 1){
					$.alert('只能选择一项！');
					return false;
				}
  				var i = $("#medicalExaminationTable>tbody>tr:has(td:has(:checked[name=selectCheckbox])):last").prop("name");
				$("#medicalExaminationForm").jsonForForm({data:recordList[i],isobj:true});
				
			}
			
			$('#medicalExaminationWindow').draggable({
				disabled : true
			});
			$("#pop_medicalExaminationTitle").text(tt);
			$("#medicalExaminationWindow").modal('show');
			//showScreenProtectDiv(1);
		}
		function closeDiv_medicalExamination() {
			//$("#medicalExaminationWindow").hide(200);
			$("#medicalExaminationWindow").modal('hide');
			hideScreenProtectDiv(1);
		}
		function saveMedicalExamination(){
			if(!jQuery('#medicalExaminationForm').validationEngine('validate')) return false;
			var requestUrl = "/gzjky/healthRecordAction/addMemberMedicalExamination.do";
			var para  = $("#medicalExaminationForm").dataForJson({prefix:''});
			para += "&member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id
			+"&member_unit_type="+window.parent.member_unit_type;
			if(medicalExamination_popType == "edit"){
				requestUrl = "/gzjky/healthRecordAction/editMemberMedicalExamination.do";
			}else{
				para += "&creator_unit_id=" + window.parent.doctor_unit_id + "&creator_cluster_id=" + window.parent.doctor_cluster_id + "&creator_unit_type=" + window.parent.doctor_unit_type;
			}
			$("#transparentDiv2").css("z-index",31);
			$("#divloading").css("z-index",32);
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
			        $("#transparentDiv2").css("z-index",3);
					$("#divloading").css("z-index",30);
				    var status = response.updateFlag;
				    if(status == "1"){
				    	$.alert('保存成功！');
				    	if(medicalExamination_popType == "add"){
							$.fn.page.settings.realcount++;
							$.fn.page.settings.currentnum = 1;
							//pagemodify("add");
				    	}
				    	$('.commonPage').show();
						$('.massage').hide();
				    	closeDiv_medicalExamination();
				    	query();
				    }else if(status == "0"){
				    	$.alert('保存失败！');
				    }
				}
			});
		}
		
		function deleteMedicalExamination(){
			var len = $("#medicalExaminationTable :checkbox:checked[name=selectCheckbox]").length;
				if(len <=0){
				$.alert('请先选择一项！');
				return false;
			}
			
			$.confirm("确认删除当前选项吗？",function(){
				var para_value = "";
				$("#medicalExaminationTable :checkbox:checked[name=selectCheckbox]").each(function(index,obj){
					para_value += this.value + ":";
					return;
				});
				
				var requestUrl = "/gzjky/healthRecordAction/deleteMemberMedicalExamination.do";
				var para = "ids="+para_value.substring(0,para_value.length-1);
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
					    var status = response.updateFlag;
					    if(status == "1"){
					    	$.alert('删除成功！');
					    	$.fn.page.settings.realcount-=len;
							pagemodify("del");
					    	query();
					    }else if(status == "0"){
					    	$.alert('删除失败！');
					    }
					}
				});
			},function(){});
			
		}
		
		function selectAll(obj){
			$("#medicalExaminationTable input[name='selectCheckbox']").attr("checked",obj.checked);
		}
		
		function selectCheckBox(obj){
			var flag = true;
			$("#medicalExaminationTable input[name='selectCheckbox']").each(function(index,obj){
				if(!obj.checked){
					flag = false;
				}
			});
			$("#selAll").attr("checked",flag);
		}

</script>
</head>
<body onload="startInit()"  class="skin-blue" >
<div>
  
  	<div class="box box-danger">
              <div class="box-header">
                  <h3 class="box-title">健康检查</h3>
              </div>
              <!-- box-body start -->
              <div class="box-body">
              	<div class="col-lg-11 col-xs-11 text-right">
	                 <div class="col-lg-6 col-xs-6">&nbsp;</div>
	                <div class="col-lg-6 col-xs-6 from-float">
		                 <a href="javascript:void(0)" class="btn btn-success from-a text-left col-lg-2 col-xs-2" onclick="showMedicalExamintionDialog()"><i class="fa fa-plus-square"></i> 增加</a>
		                 <a href="javascript:void(0)" class="btn btn-success from-a text-left col-lg-2 col-xs-2" onclick="showMedicalExamintionDialog(1)"><i class="fa fa-edit"></i> 修改</a>
		                 <a href="javascript:void(0)" class="btn btn-success from-a text-left col-lg-2 col-xs-2"  onclick="deleteMedicalExamination()"><i class="fa fa-trash-o"></i> 删除</a>
	                </div>
              </div>
              
  <div class="row">
  <br/> 
  <div class="col-lg-11 col-xs-11">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table"  id="medicalExaminationTable">
      <colgroup>
        <col width="5%" />
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
        <!-- <col width="20%" /> -->
      </colgroup>
      <tr>
      	<th nowrap="nowrap"><div class="rowCheckbox"><input type="checkbox" name="chkall" id="selAll" /><label for="chkall">选择</label></div></th>
        <th nowrap="nowrap" title="餐后血糖(餐后2小时内)">餐后血糖</th>
        <th nowrap="nowrap" title="空腹全血血糖">空腹血糖</th>
        <th nowrap="nowrap" title="总胆固醇">总胆固醇</th>
        <th nowrap="nowrap" title="高密度脂蛋白胆固醇">高密度胆固醇</th>
        <th nowrap="nowrap" title="低密度脂蛋白胆固醇">低密度胆固醇</th>
        <th nowrap="nowrap" title="血清肌酐">血清肌酐</th>
        <!-- <th nowrap="nowrap" title="微量尿白蛋白">微量尿白蛋白</th> -->
      </tr>
    </table>
    <div class="massage text-center col-lg-11 col-xs-11" style="color: red;display:none;">对不起，没有数据。</div>
  </div>
  

<script type="text/javascript">
		var reg = /^[1-9]{6,16}/; 
		
		function gotoPage(){
			var num = $.trim($("#gopage").val());
			if(num==''){
				$.alert('请输入页码');
				$("#gopage").focus();
				return false;
			}
			if(!/^\d+$/.test(num)){
				$.alert('页码中包括非数字字符');
				$("#gopage").focus();
				return false;
			}
			if(num == '0') {
			    $.alert('页码不正确');
			    return false;
			}
			if(parseInt(num)>$.fn.page.settings.pagecount)
			{
				$.alert('无效的页码');
				$("#gopage").focus();
				return false;
			}
			pageClick(num);
		}
	</script>

		<div class="col-lg-11 col-xs-11 commonPage">
			<br/>
			<div class="col-lg-4 col-xs-4" style="padding-left:25px">
				共<span  id="showcount"></span>条信息，第<span id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页
			</div>
			<div class="col-lg-4 col-xs-4">
				<a href="###" class="page-first" >首页</a>
			    <a href="###" class="page-perv" style="margin-left:5px">上一页</a>
			    <a href="###" class="page-next" style="margin-left:5px">下一页</a>
			    <a href="###" class="page-last" style="margin-left:5px">末页</a>
			</div>
			<div class="col-lg-4 col-xs-4" style="padding-left:18%">
				 转<select id="gopage" onchange="gotoPage()"></select>页
			</div>

		</div>
  

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>

<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />

<style type="text/css">

.tgrey_popup{width:16%;float:left; height:30px; line-height:30px; text-align:right; color:#aeaeae; margin-bottom: 10px}
.tblack_popup{width:84%; padding_left:1%;float:left; height:30px; line-height:30px; text-align:left; color:#aeaeae;margin-bottom: 10px}

</style>
<div class="modal fade" id="medicalExaminationWindow"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%">
 <div class="modal-dialog"  style="width:750px">	
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader"  id="pop_medicalExaminationTitle">增加亲情号码</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" data-dismiss="modal">X</a></li>
    </ul>
  </div>
  <form id="medicalExaminationForm" >
  		<input type="hidden" name="id"  id="id"  />
	   <div class="popup_main">
	         <ul>
	              <li class="tgrey_popup2">*餐后血糖(餐后2小时内)：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,20]]]" style="width:230px" type="text"  id="chxt"  name="chxt" maxlength="5" />
	              		mmol/L
	              </li>
	              <li class="tgrey_popup2">*空腹全血血糖：</li>
	              <li class="tblack_popup2">
		              <input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,20]]]" style="width:230px" type="text"  id="kfqxxt"  name="kfqxxt"  maxlength="5" />
		              mmol/L
	           	   </li>
	              <li class="tgrey_popup2">*总胆固醇：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,20]]]" style="width:230px" type="text"   id="zdgc"  name="zdgc"  maxlength="5" />
	              		mmol/L
	              </li>
	              <li class="tgrey_popup2">*高密度脂蛋白胆固醇：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,10]]]" style="width:230px" type="text"   id="gmdzdbdgc"  name="gmdzdbdgc"  maxlength="5" />
		             	mmol/L
	              </li>
	              <li class="tgrey_popup2">*低密度脂蛋白胆固醇：</li>
	              <li class="tblack_popup2">
						<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,10]]]"  type="text" style="width:230px" id="dmdzdbdgc"  name="dmdzdbdgc"  maxlength="5" />
	              		mmol/L
	              </li>
	             <li class="tgrey_popup2">*血清肌酐：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[1,200]]]" style="width:230px" type="text"   id="xqjq"  name="xqjq" maxlength="5" />
	              		μmol/L
	              </li>
	             <li class="tgrey_popup2">*微量尿白蛋白：</li>
	              <li class="tblack_popup2">
	              		<input class="inputMin_informationModify text-input validate[required,custom[number],funcCall[decimalRange[0.1,100]]]" style="width:230px" type="text"   id="wlnbdb"  name="wlnbdb" maxlength="5" />
	              		mg/24h
	              </li>			              
	              <li class="btn_popup_confirm2 text-center"><a href="javascript:void(0)" class="btn btn-info" onclick="saveMedicalExamination()"><span>保存</span></a></li>                                       
	         </ul>
	      </div>                 
  </form>
 </div>
 <script>
	$('#selAll').on('ifChecked', function(event){
		$("#medicalExaminationTable input[name='selectCheckbox']").attr("checked",true);
	});
	$('#selAll').on('ifUnchecked', function(event){
		$("#medicalExaminationTable input[name='selectCheckbox']").attr("checked",false);
	});
 </script>
</div>
  <!-- row start -->
  </div>
  <!-- box-body end -->
  </div>
  <!-- box end -->
  </div>
  </div>
</body>
</html>