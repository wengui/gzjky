<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<c:url value='/css/index_right.css'/>" rel="stylesheet" type="text/css" />
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
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>" type="text/javascript"></script>
<!-- main JS libs -->
<script src="<c:url value='/js/libs/modernizr.min.js'/>"></script>
<script src="<c:url value='/js/libs/bootstrap.min.js'/>"></script>
<!-- Style CSS -->
<link href="<c:url value='/css/bootstrap.css'/>" media="screen" rel="stylesheet">
<link href="<c:url value='/style.css'/>" media="screen" rel="stylesheet">
<!-- scripts -->
<script src="<c:url value='/js/general.js'/>"></script>
<title>995120健康服务中心</title>
<style type="text/css">
.med_table1 {
	float: left;
	width: 100%;
	text-align: left;
	font-family: "微软雅黑";
	 border-collapse: collapse;
}
.med_table1 th {
background: #0ca7a1;
height: 40px;
padding-left: 20px;
line-height: 40px;
color: #fff;
text-align: left;
font-size: 14px;
}
.med_search{
	width:100%;
	text-align:left; 
	float:left; 
	height:auto; 
	color:#5a5a5a; 
	background: #f7f7f7;
}
.med_search table tr td{font: 14px/28px "微软雅黑";}
table#faceTable tr:HOVER{background-color: rgb(239, 249, 229); cursor: pointer;}
.tgreen_bp{
	background:url(../images/icon/greenMax.png) right center no-repeat;
	width:100%;
	text-align:left; 
	float:left; 
	height:auto; 
	color:#5a5a5a; 
	border-bottom:1px dotted #aeaeae;
}
#type_id{height: 28px;}
#common_name{border: 1px solid #aeaeae;height: 28px;}
</style>
<script type="text/javascript">
		$(function(){
			if(name==""){
				$("#common_name").val(window.dialogArguments);
			}
			startInit();
			
		});
		function startInit(){
			initType();
			query();
		}
		
		function query(){
			var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
			if(pointerStart<0)
				pointerStart = 0;
			var name=$("#common_name").val();
			var type_id=$("#type_id").val();
			if(type_id==null)type_id="";
			var requestUrl = "/medicineRecordAction/queryMedicine.action";
			var para = "type_id="+type_id+"&common_name="+ name //+ "&terminology=" + terminology
				+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize + 
				"&currentnum="+$.fn.page.settings.currentnum;
			showScreenProtectDiv(1);
			showLoading();
			$.ajax({
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
				    recordList = modelMap.medicineList;
					$.fn.page.settings.count = modelMap.recordTotal;
					page($.fn.page.settings.currentnum);
				}
			});  
		}

		function showData(){
			clearFaceTable();
			var table = document.getElementById("faceTable");
			for(var i=0;i<$.fn.page.settings.currentsize;i++){
				addrowtotable(table,i);
			}
			$(".tgreen_bp #faceTable tr").each(function(index){
				$(this).attr("onclick","checkedType("+index+")");  
				$("input[name='med_id'][value='"+"']").attr("checked",true);
			});
			$("table.bPhistory_table tr:even").addClass("even");
			$("table.bPhistory_table tr:odd").addClass("odd");
		}
		var columnArray = ["id","common_name","terminology","priority","indication"];
		var indicationMap = {};
		function addrowtotable(table,index){
			 var rowcount=table.rows.length;
			 var tr=table.insertRow(rowcount);
			 //tr.ondblclick = function(){tr_click(tr)};
			 tr.name = recordList[index].common_name;
			 var i = 0;
			 recordList[index].id = '<input type="checkbox" value="'+recordList[index].common_name+'" name="med_id" />';
			 var st=recordList[index].priority;
			 if(st=='1'||st==1){
			 	recordList[index].priority="一线药物";
			 }else if(st=='2'||st==2){
			 	recordList[index].priority="二线药物";
			 }else{
			 	recordList[index].priority="三线药物";
			 }
			 var intt=recordList[index].indication;
			 recordList[index].indication=(intt.length>15?intt.substring(0,15)+"...":intt);
			 indicationMap[index] = intt;
			 for(var k=0;k<columnArray.length;k++){
				  var td = tr.insertCell(i);
				  td.innerHTML = recordList[index][columnArray[k]] ;
				  if(columnArray[k] == "indication"){
					  td.title = indicationMap[index];
				  }
				  i++;
			 }
		}

		function initType(){
			var requestUrl = "/medicineRecordAction/queryMedicineType.action";
			var para = "";
			$.ajax({
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
				    var modelMap = response.modelMap;
				    medicineTypeList= modelMap.medicineTypeList;
					drawType();
				}
			});
		}
		function drawType(){
			var select='<option value="">全部</option>';
			if(medicineTypeList!=null&&medicineTypeList.length>0){
				for(var i=0;i<medicineTypeList.length;i++){
					select+='<option value="'+medicineTypeList[i].id+'">'+medicineTypeList[i].type+'</option>';
				}
			}
			$("#type_id").html(select);
		}
		
		function cancelMedicine(){
			$("#medicine").hide(200);
			hideScreenProtectDiv(1);
		}
		
		function tr_click(obj){
			window.returnValue = $("input[name='med_id']",obj).val();
			window.close();
		}
		
		function check_click(obj){
			window.returnValue = obj.value;
			window.close();
		}
		
		function confirmMedicine(){
			var obj = $("input[name='med_id']:checked");
			if(obj.length <=0){
				$.alert('请先选择一项！');
				return false;
			}
			if(obj.length>1){
				$.alert('只能选择一项！');
				return false;
			}
			//window.returnValue = obj.val();
			window.opener.medical_obj.value = obj.val();
			window.close();
		}
		
		function closeMedicine(){
			window.close();
		}
</script>
</head>

<body>
<div class="bp_history" >
 <div class="search"  >
    <ul>
   		<li class="med_search">
 					<table width="100%" cellpadding="0" cellspacing="0" border="0" class="med_table1">
 						<tr>
 							<td>
 								<span class="select-style_medcine">
 								&nbsp;&nbsp;药品类目: <select class="type_id" id="type_id">
 								</select>
 								</span>
 								<span style="margin-left:240px">
 								药品名称: <input class="common_name" id="common_name" />
 								</span>
 								<span style="margin-left:10px">
 								<a href="javascript:void(0)" class="btn  btn_search" onclick="query()"><span style="font-size:14px; color:#5a5a5a">查询</span></a>
 								</span>
 							</td>
 						</tr>
 					</table>
  			</li>
    </ul>
  </div>
  <div class="index_table">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table"  id="faceTable">
    	<colgroup>
	        <col width="5%" />
	        <col width="24%" />
	        <col width="24%" />
	        <col width="12%" />
	        <col width="35%" />
		</colgroup>
      	<tr>
	        <th>&nbsp;</th>
	        <th>通用名称</th>
	        <th>专用名称</th>
	        <th>优先级</th>
	        <th>适用症状</th>
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

<!-- 
<div id="sjxx">共 <span style="font-weight:bold; color:#000;" id="showcount"></span> 条信息，当前：第 <span style="font-weight:bold;color:#000;" id="showcurrentnum"></span> 页 ，共 <span style="font-weight:bold;color:#000;" id="showpagecount"></span> 页</div>
<div id="fanye" >
<input type="button" value="首页" class="button_fy page-first" />
<input type="button" value="上一页" class="button_fy page-perv" />
<input type="button" value="下一页" class="button_fy page-next" />
<input type="button" value="末页" class="button_fy page-last" style="margin-right:15px;" /> 
 转到<input id="gopage" type="text" style="border:1px solid #bababa; width:30px; height:18px; margin:0 3px;text-align: center;" />
<input type="button" value="跳" class="button_fy" onclick="gotoPage()"/>
</div>
 -->
 
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
  

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
  <div>
    	<ul>
    			<li>&nbsp;</li>
		   		<li class="btn_popup_confirm" style="width: 65%;padding-left: 35%">
		   			<a id="closeTips" href="javascript:void(0)" onclick="confirmMedicine();">确定</a>
		   			<a id="closeDiv" href="javascript:void(0)" onclick="closeMedicine();">取消</a>
		   		</li>
		</ul>   		
  </div>
</div>
</body>
</html>
