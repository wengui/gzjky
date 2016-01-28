<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<c:url value='//js/ztree/css/zTreeStyle.css'/>" type="text/css"></link>
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
<script src="<c:url value='/js/ztree/jquery.ztree.all-3.1.min.js'/>" type="text/javascript"></script>
<style type="text/css">
	ul.ztree {margin-top: 10px;border: 1px solid #617775;background: #f0f6e4;width:220px;height:360px;overflow-y:scroll;overflow-x:auto;}
</style>
<script type="text/javascript">

		$.fn.page.settings.pagesize=10;
    	function page(num){
    		$(this).page({
    		drawTable:showData,
    		currentnum:num,
    		buttonClickCallback:pageClick
    		});
		}
		function pageClick(num){
			$.fn.page.settings.currentnum = num;
    		query();
		}
</script>

<script type="text/javascript">
	var doctor_unit_id = window.parent.doctor_unit_id;
	var doctor_cluster_id = window.parent.doctor_cluster_id;
	var doctor_unit_type = window.parent.doctor_unit_type;

	


	var memberIllnessHistoryList;
	$.fn.page.settings.pagesize=10;
	
	function startInit(){
			$(".no-print").remove();
			queryStart();
	    	jQuery('#addMemberIllnessHistory').validationEngine("attach",
	    			{
	    				promptPosition:"topRight",
	    				maxErrorsPerField:1,
	    				scroll:false,
	    				focusFirstField:false
	    				//binded:false,
	    				//showArrow:false,
	    			}
	    	);
	    	
		};

	function queryStart(){
			$("#show_history").attr("style","display");
			$("#add_history").attr("style","display:none");
    		$.fn.page.settings.currentnum=1;
    		query();
    }

	function query(){
		var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
		if(pointerStart<0) pointerStart = 0;
		
		var requestUrl = "/gzjky/healthRecordAction/queryMemberIllnessHistoryList.do";
    	var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id+"&member_unit_type="+window.parent.member_unit_type
    					+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	
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
				
				// 数据取得
				memberIllnessHistoryList = response.outBeanList;
				
				$.fn.page.settings.count = response.recordTotal;
				page($.fn.page.settings.currentnum);
			}
		});
	}
	
	function showData(){
	    clearFaceTable(); 
		for (var i = 0; i < $.fn.page.settings.currentsize; i++){	 
			 addrowtotable(i);
		}
		  $("table.bPhistory_table tr:even").addClass("even");
		  $("table.bPhistory_table tr:odd").addClass("odd");
    }
    
    function addrowtotable(i){
    	try{
    		var startTime=memberIllnessHistoryList[i].startTime;
    		var endTime=memberIllnessHistoryList[i].endTime;
	
		    var table = document.getElementById("faceTable");
		    var rowcount=table.rows.length;
			var tr=table.insertRow(rowcount);
				    
		    td=tr.insertCell(0);
		    td.innerHTML = "&nbsp;&nbsp;&nbsp;" + (($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize + (i+1));
		    td.height=25;
		    
		    
		    td=tr.insertCell(1);
		    td.innerHTML =  memberIllnessHistoryList[i].diseaseName;
		  
		    
	        td=tr.insertCell(2);
		    td.innerHTML =  startTime;

		    if(endTime=="0000-00-00"||endTime=="3000-01-01"){
				endTime="";
			}
		    td=tr.insertCell(3);
		    td.innerHTML =  endTime;
		  
		    
		    td=tr.insertCell(4);
		    td.innerHTML =  "<a href='javascript:void(0)' onclick='showMemberIllness("+i+")'>查看</a>|&nbsp;&nbsp;<a href='javascript:void(0)' onclick='deleteMemberIllnessHistory("+i+")'>删除</a>";
		   
		    
	   } catch(e){	   
	     	alert(e.toString());
	   }
    }
	
	function deleteMemberIllnessHistory(i){
		var id=memberIllnessHistoryList[i].id;
		var requestUrl = "/gzjky/healthRecordAction/deleteMemberIllnessHistory.do";
    	var para = "id="+id;
		$.confirm('你确定要删除吗？', function () {
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
			    if(status==0){
			    	$.alert("删除发生异常！");
			    }
			    if(status==1){
			    	$.fn.page.settings.realcount-=1;
			    	pagemodify("del");
			    	$.alert("删除成功！");
			    	query();
			    }
			}
		});
		},function(){});
	}
	
	function showMemberIllness(i){
			$("#addMemberIllnessHistory").clearForm();
			$("#show_history").attr("style","display:none");
			$("#add_history").attr("style","");
			$("#addMemberIllnessHistory input,textarea").attr("disabled",true);
			$("#search_diseaseBtn").attr("style","display:none");
			$("#save_button").attr("style","display:none");
			
			$("#diseaseName").val(memberIllnessHistoryList[i].diseaseName);
			$("#startTime").val(memberIllnessHistoryList[i].startTime);
			var endTime=memberIllnessHistoryList[i].endTime;
			if(endTime=="0000-00-00"||endTime=="3000-01-01"){
				endTime="";
			}
			$("#endTime").val(endTime);
			$("#hospitalRecord").val(memberIllnessHistoryList[i].hospitalRecord);
			$("#recoverRecord").val(memberIllnessHistoryList[i].recoverRecord);
			$("#comment").val(memberIllnessHistoryList[i].comment);
	}
	
	function addMemberIllnessHistory(i){
		if(!jQuery('#addMemberIllnessHistory').validationEngine('validate')) return false;
	
		var diseaseId=$("#diseaseId").val();
		var diseaseName=$("#diseaseName").val();
		var startTime=$("#startTime").val();
		var endTime=$("#endTime").val();
		var hospitalRecord=$("#hospitalRecord").val();
		var recoverRecord=$("#recoverRecord").val();
		var comment=$("#comment").val();
		
		var requestUrl = "/gzjky/healthRecordAction/addMemberIllnessHistory.do";
    	var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id+"&member_unit_type="+window.parent.member_unit_type
    					+ "&operator_unit_id="+doctor_unit_id+"&diseaseId="+diseaseId+"&operator_unit_type="+doctor_unit_type
    					+ "&diseaseName="+diseaseName+"&startTime="+startTime+"&endTime="+endTime+"&hospitalRecord="+hospitalRecord
    					+ "&recoverRecord="+recoverRecord+"&comment="+comment ;
    					
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
			    if(status==0){
			    	$.alert("增加发生异常！");
			    }
			    if(status==1){
			    	$.alert("增加成功！");
			    	$.fn.page.settings.realcount++;
			    	$.fn.page.settings.currentnum = 1;
					//pagemodify("add");
			    	$("#show_history").attr("style","");
					$("#add_history").attr("style","display:none");
			    	query();
			    }
			}
		});
	}
	
	function toAddMemberIllnessHistory(){
		$("#addMemberIllnessHistory").clearForm();
	
		$("#show_history").attr("style","display:none");
		$("#add_history").attr("style","");
		$("#addMemberIllnessHistory input,textarea").attr("disabled",false);
		$("#search_diseaseBtn").attr("style","display");
		$("#save_button").attr("style","display");
	}
	
	function showMemberIllnessHistory(){
		jQuery("#addMemberIllnessHistory").validationEngine("hide");
		$("#show_history").attr("style","");
		$("#add_history").attr("style","display:none");
	}
		
</script>

<SCRIPT type="text/javascript">
		var menu_zTree;
  		var menu_Nodes;
  		var search_menu_zTree;
		var menu_setting = {
			view: {
				dblClickExpand: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			callback: {
				beforeClick: menu_beforeClick,
				onClick: menu_onClick
			}
		};
		var search_menu_setting = {
				view: {
					dblClickExpand: false
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback: {
					beforeClick: search_menu_beforeClick,
					onClick: search_menu_onClick
				}
			};

		function menu_beforeClick(treeId, treeNode) {
			check = treeNode;
			return check;
		}
		
		function menu_onClick(e, treeId, treeNode) {
			menu_zTree = $.fn.zTree.getZTreeObj("menu_tree");
			nodes = menu_zTree.getSelectedNodes();
			v = "";
			vv = "";
			for (var i=0, l=nodes.length; i<l; i++) {
				v += nodes[i].name + ",";
				vv += nodes[i].id + ",";
			}
			if (v.length > 0 ) v = v.substring(0, v.length-1);
			if (vv.length > 0 ) vv = vv.substring(0, vv.length-1);
			//alert(v);
			//alert(vv);
			$("#areaName").val(v);
			$("#areaId").val(vv);
			hideMenu();
		}

		function showMenu() {
			var cityObj = $("#areaName");
			menu_zTree.cancelSelectedNode();
			
			var cityPosition = $("#areaName").position();
			$("#menuContent").css({left:cityPosition.left + "px", top:cityPosition.top + cityObj.outerHeight() + "px"}).slideDown("fast");
			$("body").bind("mousedown", onBodyDown);
		}
		function hideMenu() {
			$("#menuContent").fadeOut("fast");
			$("body").unbind("mousedown", onBodyDown);
		}
		function onBodyDown(event) {
			if (!(event.target.id == "areaBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
				hideMenu();
			}
		}
		
		function search_menu_beforeClick(treeId, treeNode) {
			check = treeNode;
			return check;
		}
		
		function search_menu_onClick(e, treeId, treeNode) {
			search_menu_zTree = $.fn.zTree.getZTreeObj("search_menu_tree");
			nodes = search_menu_zTree.getSelectedNodes();
			v = "";
			vv = "";
			for (var i=0, l=nodes.length; i<l; i++) {
				v += nodes[i].name + ",";
				vv += nodes[i].id + ",";
			}
			if (v.length > 0 ) v = v.substring(0, v.length-1);
			if (vv.length > 0 ) vv = vv.substring(0, vv.length-1);
			//alert(v);
			//alert(vv);
			if(vv>0){
				$("#diseaseName").val(v);
				$("#diseaseId").val(vv);
				search_hideMenu();
			}
		}

		function search_showMenu() {
			var cityObj = $("#diseaseName");
			search_menu_zTree.cancelSelectedNode();
			
			var cityPosition = $("#diseaseName").position();
			$("#search_menuContent").css({left:cityPosition.left + "px", top:cityPosition.top + cityObj.outerHeight() + "px"}).slideDown("fast");
			$("body").bind("mousedown", search_onBodyDown);
		}
		function search_hideMenu() {
			$("#search_menuContent").fadeOut("fast");
			$("body").unbind("mousedown", search_onBodyDown);
		}
		function search_onBodyDown(event) {
			if (!(event.target.id == "search_diseaseBtn" || event.target.id == "search_menuContent" || $(event.target).parents("#search_menuContent").length>0)) {
				search_hideMenu();
			}
		}
		
		function reloadTree() {
			para='';
  			xmlHttp = $.ajax({
			url:'/gzjky/healthRecordAction/searchAllOfficeDiseaseByTree.do',
			async:false,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert('无权限或操作异常');
			},success:function(response){
				
				var state = response.updateFlag;
				if(state=='0'){
					menu_Nodes = response.outBeanList;
					$.fn.zTree.init($("#search_menu_tree"), search_menu_setting, menu_Nodes);
					search_menu_zTree = $.fn.zTree.getZTreeObj("search_menu_tree");
					search_menu_zTree.expandAll(true);
				}else if(state=='2'){
					$.alert('未知的错误');
				}
			}
		}); 
		}
		$(function(){
			reloadTree() ;
		});
</SCRIPT>

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

<body onload="startInit()"  class="skin-blue">
<div style="font-size:13px;font-family:微软雅黑;color:#5a5a5a;">
<!--bp_history start-->
  <div class="box box-info">
<div class="" id="show_history">

              <div class="box-header">
                 <h3 class="box-title">疾病史</h3>
              </div>		
              <div class="box-body">
				         <div class="row form-group">
					          	<div class="col-lg-11 text-right" id="editImage" href="javascript:void(0)" onclick="toAddMemberIllnessHistory()">
					          		<a class="btn btn-success">
					                   <i class="fa fa-edit"></i> 新建疾病史
					             	</a>
					            </div>
 							</div>
 					<div class="row">
 						<br/>
		  				<div class="col-lg-11">
		  				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table"  id="faceTable">
      					<colgroup>
        					<col width="10%" />
        					<col width="20%" />
        					<col width="20%" />
        					<col width="20%" />
        					<col width="20%" />
      					</colgroup>
      					<tr>
        					<th>序号</th>
        					<th>疾病名称</th>
        					<th>发生日期</th>
        					<th>结束日期</th>
        					<th>操作</th>
      					</tr>
    					</table>
		  				</div>
 					</div>
 					
 					<div class="row">
						<br/>
						<div class="col-lg-4" style="padding-left:25px">
							共<span  id="showcount"></span>条信息，第<span id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页
						</div>
						<div class="col-lg-4">
							<a href="###" class="page-first" >首页</a>
						    <a href="###" class="page-perv" style="margin-left:5px">上一页</a>
						    <a href="###" class="page-next" style="margin-left:5px">下一页</a>
						    <a href="###" class="page-last" style="margin-left:5px">末页</a>
						</div>
						<div class="col-lg-4" style="padding-left:18%">
							 转<select id="gopage" onchange="gotoPage()"></select>页
						</div>
						</div>
			     </div>
  
</div><!--bp_history end-->

<div class="row" id="add_history" style="display:none;">
	<div class="box-header form-margin-left">
      <h3 class="box-title">疾病史详细</h3>
	</div>
	<div class="col-lg-2">&nbsp;</div>
	<div class="col-lg-8">
	<form id="addMemberIllnessHistory"  method="post" >
		<input type="text"  id="diseaseId"  name="diseaseId" maxlength=32  style="display:none"/>
	 <div class="row">
		 <div class="col-lg-8" id="diseaseNameList">
		 	<span class="col-lg-4 text-right  form-span" >*疾病名称：</span>
            <input class="col-lg-6 display-input inputMin_informationModify validate[required] " type="text" id="diseaseName"  name="diseaseName" maxlength=32  readonly="readonly"/>
            <a class="btn btn-success" id="search_diseaseBtn" href="javascript:void(0)" onclick="search_showMenu(); return false;">选择疾病</a>              		
		 </div>
		 <div class="col-lg-8">
		 	<lable class="col-lg-4 text-right form-span">*开始日期：</lable>
		 	<input type="text" class="col-lg-6 display-input inputMin_informationModify validate[required,date]"  id="startTime" name="startTime" value='' onfocus="var startTime=$dp.$('startTime');WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){startTime.focus();},maxDate:'#F{$dp.$D(\'startTime\') || \'%y-%M-%d\'}' })" />
		 </div>

		 <div class="col-lg-8">
		 	<span class="col-lg-4 text-right  form-span">结束日期：</span>
		 	<input type="text"  class="col-lg-6 display-input inputMin_informationModify text-input validate[date]" id="endTime" name="endTime" value='' onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'endTime\')}',maxDate:'%y-%M-%d'})"/>
		 </div>
		 <div class="col-lg-8">
		 	<lable class="col-lg-4 text-right form-span">住院情况：</lable>
		 	<textarea rows="5" cols="40" name="hospitalRecord"  id="hospitalRecord"  class="col-lg-8 display-textarea validate[funcCall[includespecialchar]]" ></textarea>
		 </div>
		 <div class="col-lg-8">
		 	<span class="col-lg-4 text-right form-span">转归情况：</span>
		 	<textarea rows="5" cols="40" name="recoverRecord"  id="recoverRecord" class="col-lg-8 display-textarea validate[funcCall[includespecialchar]]" ></textarea>
		 </div>
		 <div class="col-lg-8">
		 	<lable class="col-lg-4 text-right form-span">备注：</lable>
		 	<textarea rows="5" cols="40" name="comment"  id="comment"  class="col-lg-8 display-textarea validate[funcCall[includespecialchar]]" ></textarea>
		 </div>
		 <div class="col-lg-8">
		 	<div class="col-lg-6 text-right"><a href="javascript:void(0)"  class="btn btn-success" onclick="addMemberIllnessHistory()" id="save_button">保存</a></div>
		 	<div class="col-lg-6 text-left"><a href="javascript:void(0)"  class="btn btn-success" onclick="showMemberIllnessHistory()">返回列表</a></div>
		 </div>
		</div>
        
        <div id="search_menuContent" class="menuContent" style="display:none; position: absolute;">
			<ul id="search_menu_tree" class="ztree" style="margin-top:1px; width:220px;"></ul>
 		</div>  	
	</form> 
	</div>
	<div class="col-lg-2">&nbsp;</div>
	
</div>
<!-- box box-info end -->
</div>	

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 
</div>
</body>
</html>
