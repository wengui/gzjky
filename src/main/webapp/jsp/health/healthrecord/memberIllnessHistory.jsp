<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
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
<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>
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
	
	$(function(){
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
		});

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

<body style="background:#e8e3d7">
<div style="font-size:13px;font-family:微软雅黑;color:#5a5a5a;">
<!--bp_history start-->
<div class="bp_history" id="show_history">
  <div class="width:670px">
    <ul>
      <li style="font-size:17px; font-weight:500;color:#5a5a5a;text-align:cener;float:left;width:530px;text-align:left;padding-left:20px">疾病史</li>
      <li class="btn" style="height: 40px;"><a href="javascript:void(0)" onclick="toAddMemberIllnessHistory()"><span style="font-size:14px; font-weight:500;color:#5a5a5a">新建疾病史</span></a></li>           
    </ul>
  </div>
  <div class="index_table">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table"  id="faceTable">
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
 
<div class="index_page">
  <ul>
    <li class="page_information">共<span  id="showcount"></span>条信息，第<span  id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页</li>
    <li class="page_button">
	    <a href="###" class="btn page-first"><span style="color:#5a5a5a">首页</span></a>
	    <a href="###" class="btn page-perv"><span style="color:#5a5a5a">上一页</span></a>
	    <a href="###" class="btn page-next"><span style="color:#5a5a5a">下一页</span></a>
	    <a href="###" class="btn page-last"><span style="color:#5a5a5a">末页</span></a>
    </li>
    <li class="page_select">
    转<select id="gopage" onchange="gotoPage()">
    	</select>页
    </li>
  </ul>
</div>

</div>
<div class="bp_history" id="add_history" style="display:none;">
	<div class="index_table" style="background:#fff">
	<form id="addMemberIllnessHistory"  method="post" style="height: 300px">
		<input type="text"  id="diseaseId"  name="diseaseId" maxlength=32  style="display:none"/>
	 	
	 	<div class="informationModify_main2" >
          <ul>
          
           <li class="tLeft_informationModify">            
             <ul>
               <li class="tgrey_informationModify" style="height:40px;">*疾病名称：</li>
               <li class="tblack_informationModify">
               		<div class="family_disease_relation">
               		<input class="inputMin_informationModify text-input validate[required] " type="text" style="width:230px" id="diseaseName"  name="diseaseName" maxlength=32  readonly="readonly"/>
               		<a id="search_diseaseBtn" href="javascript:void(0)" onclick="search_showMenu(); return false;">选择疾病</a>              		
               		</div>
               </li>
             </ul>
             </li>
             
             <li>
             <ul>
               <li class="tgrey_informationModify">*开始日期：</li>
               <li class="tblack_informationModify">
               		<input type="text"   id="startTime" name="startTime" value='' onfocus="var startTime=$dp.$('startTime');WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){startTime.focus();},maxDate:'#F{$dp.$D(\'startTime\') || \'%y-%M-%d\'}' })" class="inputMin_informationModify text-input validate[required,date]" style="width:230px"/>
               </li>
             </ul>
             </li>
             
             <li>
             <ul>
               <li class="tgrey_informationModify">结束日期：</li>
               <li class="tblack_informationModify">
               		<input type="text"   id="endTime" name="endTime" value='' onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'endTime\')}',maxDate:'%y-%M-%d'})" class="inputMin_informationModify text-input validate[date]" style="width:230px"/>
               </li>
             </ul>

             </li>
             
             <li>
             <ul style="height:110px;">
               <li class="tgrey_informationModify">住院情况：</li>
               <li class="tblack_informationModify" style="width:300px;height:80px;">
               		<textarea rows="5" cols="40" name="hospitalRecord"  id="hospitalRecord"  class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray;font-size:12px" ></textarea>
               </li>
             </ul>

             </li>
             
             <li>
             <ul style="height:110px;">
               <li class="tgrey_informationModify">转归情况：</li>
               <li class="tblack_informationModify" style="width:300px;height:80px;">
               		<textarea rows="5" cols="40" name="recoverRecord"  id="recoverRecord" class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray;font-size:12px" ></textarea>
               </li>
             </ul>

             </li>
             
             <li>
             <ul style="height:110px;">

               <li class="tgrey_informationModify">备注：</li>
               <li class="tblack_informationModify" style="width:300px;height:80px;">
               		<textarea rows="5" cols="40" name="comment"  id="comment"  class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray;font-size:12px" ></textarea>
               </li>
             </ul>

             </li>
             
             <li>

             <ul>
             	<!-- <li class="tgrey_informationModify"></li> -->
	 			<li style="height: 40px;margin-left:80px"><a href="javascript:void(0)"  class="btn" onclick="addMemberIllnessHistory()" id="save_button"><span style="font-size:14px; color:#5a5a5a;width:110px">保存</span></a></li>
	 			<li style="height: 40px;"><a href="javascript:void(0)"  class="btn" onclick="showMemberIllnessHistory()"><span style="font-size:14px; color:#5a5a5a;width:110px">返回列表</span></a></li>
	 		 </ul>
	 		 </li>
            </li>
          </ul>
        </div>
        
        <div id="search_menuContent" class="menuContent" style="display:none; position: absolute;">
			<ul id="search_menu_tree" class="ztree" style="margin-top:1px; width:220px;"></ul>
 		</div>  	
	</form> 
	</div>
	
</div>
	

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 
</div>
</body>
</html>
