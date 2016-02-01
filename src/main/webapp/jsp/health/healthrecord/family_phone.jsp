<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>亲情号码</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>

<script type="text/javascript">

	menuId = "#phone";
	function startInit(){
		/*
		validator_familyPhone = $("#addFamilyPhoneForm").validate({
			messages: {
				'name': {
					required:"真实姓名  是必填项."
				},'cellphone':{
					required:"手机号码  是必填项."
				},'relationship':{
					required:"亲属关系 是必选项"
				},'report':{
					required:"诊断报告 是必选项"
				}
			}
		    });
		*/
		
    	jQuery('#addFamilyPhoneForm').validationEngine("attach",
    			{
    				promptPosition:"centerRight:0,-10",
    				maxErrorsPerField:1,
    				scroll:false,
    				//binded:false,
    				//showArrow:false,
    				maxErrorsPerField:1
    			}
    	);
    	queryFamilyPhone();
	};

	function queryFamilyPhone(){
		var requestUrl = "/gzjky/healthRecordAction/queryMemberFamilyPhone.do";
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
			    recordList = response.outBeanList;
			    if(recordList != null){
			    	drawTable();
			    }
			}
		});
	}
	var columns = ["name","cellphone","relationship"];
	function drawTable(){
		clearFaceTableByTableName("familyPhoneTable");
		var tableObj = document.getElementById("familyPhoneTable");
		for(var i=0;i<recordList.length;i++){
			var row = tableObj.insertRow(i+1);
			
			//列位置
			var j = 0;
			var cell = row.insertCell(j++);
			//序号
			cell.innerHTML = i+1;
			
			for(var k=0;k<columns.length;k++){
				cell = row.insertCell(j++);
				var columnKey = columns[k];
				if(columnKey in recordList[i]){
					cell.innerHTML = recordList[i][columnKey];
				}
			}
			
			cell = row.insertCell(j++);
			cell.innerHTML = '<a href="javascript:void(0)" class="btn btn-success" style="color:#fff;width:78px" onclick="edit_familyPhone('+i+
					')"> <i class="fa fa-edit"></i>编辑</a>'+
					'<a href="javascript:void(0)" class="btn btn-success" style="color:#fff;width:78px"  onclick="delete_familyPhone('+i+
							')"> <i class="fa fa-fw fa-trash-o"></i>删除</a>';
		
	
		
		}
	}
	
	var popType = "";
	function edit_familyPhone(index){
		showDialog(1,index);
	}
	function add_familyPhone(){
		showDialog();
	}
	function delete_familyPhone(index){
		$.confirm("确定要删除？",function(){
			var requestUrl = "/gzjky/healthRecordAction/deleteMemberFamilyPhone.do";
	    	var para = "id="+recordList[index].id;
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
				    	queryFamilyPhone();
				    	$.alert("删除成功");
				    }else{
				    	$.alert("删除失败");
				    }
				}
			});
		},function(){})
	}
	
	function saveFamilyPhone(){
		//if(!$("#addFamilyPhoneForm").valid()) return false;
		if(!jQuery('#addFamilyPhoneForm').validationEngine("validate")){
			return false;
		}
		var requestUrl = "/gzjky/healthRecordAction/addMemberFamilyPhone.do";
		if(popType == "edit"){
			requestUrl = "/gzjky/healthRecordAction/editMemberFamilyPhone.do";
		}
	   var para = $("#addFamilyPhoneForm").dataForJson({prefix:''});
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
			    	queryFamilyPhone();
			    	if(popType == "add"){
			    		$.alert("增加成功");
			    	}else if(popType == "edit"){
			    		$.alert("修改成功");
			    	}
			    	closeDiv_familyPhone();
			    }else if(state == "2"){
			    	$.alert("亲情号码最多只能设置3个");
			    }else if(state == "3"){
			    	$.alert("亲情号码已存在");
			    }else{
			    	if(popType == "add"){
			    		$.alert("增加失败");
			    	}else if(popType == "edit"){
			    		$.alert("修改失败");
			    	}
			    }
			}
		});
	}
	
	//显示输入窗口
	function showDialog(obj,index){
	    var tt = "增加亲情号码";
		$("#addFamilyPhoneForm").clearForm();
		//validator_familyPhone.resetForm();
		jQuery('#addFamilyPhoneForm').validationEngine("hide");
		popType = "add";
		
		if(obj == 1){
			popType = "edit";
			tt = "编辑亲情号码";
			$("#addFamilyPhoneForm").jsonForForm({data:recordList[index],isobj:true});
		}
		
		$('#popWindow').draggable({
			disabled : true
		});
		$("#pop_familyPhoneTitle").text(tt);
		//$("#familyPhoneWindow").show(200);
		$("#familyPhoneWindow").modal('show');
		showScreenProtectDiv(1);
	}
	function closeDiv_familyPhone() {
		//$("#familyPhoneWindow").hide(200);
		$("#familyPhoneWindow").modal('hide');
		hideScreenProtectDiv(1);
	}
</script>
</head>
<body onload="startInit()" class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
		<!-- Left side column. contains the logo and sidebar -->
		<%@ include file="../../shared/sidebarMenu.jsp"%>
		<aside class="right-side"> <!-- Main content -->
			 <section class="content-header">
	             <h1>亲情号码</h1>
	             <ol class="breadcrumb">
	                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
	                  <li>健康档案</li>
	                  <li class="active">亲情号码</li>
	             </ol>
	         </section> 
	        <div class="bp_accouint">
					<div class="box box-danger">
						<div class="box-header">
							<h3 class="box-title">亲情号码</h3>
						</div>
						<!-- /.box-header -->
						<div class="box-body col-lg-11">
							<div class="col-lg-11">
								<a href="javascript:void(0)" onclick="add_familyPhone()"><h3 class="btn btn-success" ><i class="fa fa-plus-square"></i> 增加</h3></a>
							</div>
						</div><!-- /.box-body -->
						<div class="row " style="padding-bottom:15px">
							<div class="col-lg-8">
						    <table width="100%" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table" id="familyPhoneTable">
								<colgroup> 	
									<col width="10%" />
									<col width="15%" />
									<col width="25%" />
									<col width="25%" />
									<col width="25%" />
								</colgroup>
								<tr>
									<th>序号</th>
									<th>姓名</th>
									<th>手机号码</th>
									<th>亲属关系</th>
									<th>操作</th>
								</tr>
							</table>
							</div>
							<br/>
							
							<br/>
							<br/>
						</div>

					</div><!-- /.box -->
			</div>
		</aside>
</div>
<div class="modal fade" id="familyPhoneWindow" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	style="margin-top: 10%">
	<div class="modal-dialog">
		<div class="popup_header">
			<ul>
				<li class="name_popupHeader" id="pop_familyPhoneTitle">增加亲情号码</li>

				<li class="close_popupHeader"><a
					href="javascript:void(0)" onclick="closeDiv_familyPhone();"
					data-dismiss="modal">X</a></li>
			</ul>
		</div>
		<form id="addFamilyPhoneForm">
			<input type="hidden" name="id" id="id" /> <input type="hidden"
				name="member_unit_id" id="member_unit_id" /> <input
				type="hidden" name="member_cluster_id" id="member_cluster_id" />
			<input type="hidden" name="member_unit_type"
				id="member_unit_type" />
			<div class="popup_main">
				<ul>
					<li class="tgrey_popup">*真实姓名：</li>
					<li class="tblack_popup"><input
						class="inputMin_informationModify text-input validate[required,funcCall[chinaornumer]]"
						style="width: 230px" type="text" id="name" name="name"
						maxlength="32" /></li>
					<li class="tgrey_popup">固定电话：</li>
					<li class="tblack_popup"><input
						class="inputMin_informationModify text-input validate[funcCall[telephone]]"
						style="width: 230px" type="text" id="phone" name="phone" />
					</li>
					<li class="tgrey_popup">*手机号码：</li>
					<li class="tblack_popup"><input
						class="inputMin_informationModify text-input validate[required,funcCall[Internationalmobilephone]]"
						style="width: 230px" type="text" id="cellphone"
						name="cellphone" /></li>
					<li class="tgrey_popup">*诊断报告：</li>
					<li class="tblack_popup"><span
						class="select-style_habit"> <select
							class="selectMax_informationModify text-input validate[required]"
							id="report" name="report">
								<option value="">请选择</option>
								<option value="1">接收</option>
								<option value="0">不接收</option>
						</select>
					</span></li>
					<li class="tgrey_popup">*亲属关系：</li>
					<li class="tblack_popup"><span
						class="select-style_habit"> <select
							class="selectMax_informationModify text-input validate[required]"
							id="relationship" name="relationship">
								<option value="">请选择</option>
								<option value="家庭成员" selected="selected">家庭成员</option>
								<option value="朋友">朋友</option>
								<option value="同事">同事</option>
								<option value="其他">其他</option>
						</select>
					</span></li>
					<li class="tgrey_popup">单位：</li>
					<li class="tblack_popup"><input
						class="inputMin_informationModify text-input validate[funcCall[includespecialchar]]"
						style="width: 230px" type="text" id="company" name="company"
						maxlength="128" /></li>
					<li class="tgrey_popup">邮箱：</li>
					<li class="tblack_popup"><input
						class="inputMin_informationModify text-input validate[custom[email]]"
						style="width: 230px" type="text" id="email" name="email" />
					</li>
					<li class="tgrey_popup">家庭地址：</li>
					<li class="tblack_popup"><input
						class="inputMin_informationModify text-input validate[funcCall[includespecialchar]]"
						style="width: 230px" type="text" id="homeAddress"
						name="homeAddress" maxlength="256" /></li>
					<li class="btn_popup_confirm"><a
						href="javascript:void(0)" class="btn btn-info" 
						onclick="saveFamilyPhone()"><i class="fa fa-save"></i> 保存</a></li>
							

					</ul>
				</div>
			</form>
	</div>
</div>


<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>
<div id="transparentDiv"></div>
<div id="transparentDiv2"></div>
</body>
</html>