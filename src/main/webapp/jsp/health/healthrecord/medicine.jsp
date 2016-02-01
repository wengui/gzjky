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
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>" type="text/javascript"></script>
<title>药物选择</title>
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
}
.med_search table tr td{font: 14px/42px "微软雅黑";}
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
</style>
<script type="text/javascript">
		function startInit(){
			if(name==""){
				$("#commonName").val(window.dialogArguments);
			}
			startInit();
			
		};
		function startInit(){
			initType();
			query();
		}
		
		function query(){
			var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
			if(pointerStart<0)
				pointerStart = 0;
			var name=$("#commonName").val();
			var typeId=$("#typeId").val();
			if(typeId==null)typeId="";
			var requestUrl = "/gzjky/medicineRecordAction/queryMedicine.do";
			var para = "typeId="+typeId+"&commonName="+ name //+ "&terminology=" + terminology
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
				    recordList = response.outBeanList;
					$.fn.page.settings.count = response.recordTotal;
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
		var columnArray = ["id","commonName","terminology","priority","indication"];
		var indicationMap = {};
		function addrowtotable(table,index){
			 var rowcount=table.rows.length;
			 var tr=table.insertRow(rowcount);
			 //tr.ondblclick = function(){tr_click(tr)};
			 tr.name = recordList[index].commonName;
			 var i = 0;
			 recordList[index].id = '<input type="checkbox" class="form-input-checkbox" value="'+recordList[index].commonName+'" name="med_id" />';
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
			var requestUrl = "/gzjky/medicineRecordAction/queryMedicineType.do";
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
				    medicineTypeList= response.outBeanList;
					drawType();
				}
			});
		}
		function drawType(){
			var select='<option value="">全部</option>';
			if(medicineTypeList!=null&&medicineTypeList.length>0){
				for(var i=0;i<medicineTypeList.length;i++){
					select+='<option value="'+medicineTypeList[i].id+'">'+medicineTypeList[i].catename+'</option>';
				}
			}
			$("#typeId").html(select);
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

<body onload="startInit()"  class="skin-blue">
<div class="" >
	<div class="box box-danger">
              <div class="box-header">
                  <h3 class="box-title">药品一览</h3>
              </div>
              <!-- box-body start -->
              <div class="box-body">
              	<div class="row">
	                 <div class="col-lg-4 col-xs-4">
		                  <label class="col-lg-4 col-xs-4  text-right form-span">药品类目:</label>
		                  <select class="col-lg-8 col-xs-8 display-input typeId" id="typeId"></select>
	                 </div>
	                <div class="col-lg-4 col-xs-4">
		                 <label class="col-lg-4 col-xs-4  text-right form-span">药品名称:</label>
		                 <input class="col-lg-8 col-xs-8 display-input commonName" id="commonName" type="text" />
	               </div>
	               <div class="col-lg-3 col-xs-3">
	               	 <button class="btn btn-success" onclick="queryStart();"><i class="fa fa-search"></i> 查询</button>
	               </div>
              </div>

    
  <div class="row">
  <br/>      
  <div class="col-lg-11 col-xs-11">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table"  id="faceTable">
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

		<div class="col-lg-11 col-xs-11">
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
  <div>
    	<ul>
    			<li>&nbsp;</li>
		   		<li class="btn_popup_confirm" style="width: 65%;padding-left: 35%">
		   			<a id="closeTips" href="javascript:void(0)"  class="btn btn-success" onclick="confirmMedicine();"><span>确定</span></a>
		   			<a id="closeDiv" href="javascript:void(0)" class="btn btn-success"  onclick="closeMedicine();"><span>取消</span></a>
		   		</li>
		</ul>   		
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
