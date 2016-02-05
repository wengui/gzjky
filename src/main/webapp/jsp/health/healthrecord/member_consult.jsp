<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>会员咨询</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>

<style type="text/css">

.popup_main ul li.huanhang{width:100%;float:left;   }
.tgrey_popup1{width:20%;float:left; text-align:right;padding:5px 0; margin:-15px 0; }
.tblack_popup1{width:70%; padding_left:1%;float:left; text-align:left;padding:5px 0;margin:-15px 0;}

</style>
<script type="text/javascript" >
	jQuery('#addMemberConsultForm').validationEngine("attach",
    			{
    				promptPosition:"centerRight:0,-10",
    				maxErrorsPerField:1,
    				scroll:false
    				//binded:false,
    				//showArrow:false,
    			}
    );
</script>
<style type="text/css">
	td{word-break:break-all;}
</style>
<script type="text/javascript">
  menuId = "#notice";
  var htRelatedSymptomMap = {};
  var htRelatedSymptomStrMap = {};
  
  		htRelatedSymptomMap[1] = "发烧";
  		htRelatedSymptomStrMap["发烧"] = 1;
  
  		htRelatedSymptomMap[2] = "感冒";
  		htRelatedSymptomStrMap["感冒"] = 2;
  
  function startInit(){
	  queryStart();
  }
  function queryStart(){
	  $.fn.page.settings.currentnum = 1;
	  query();
  }
  function query(){
	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;

	  //var startDate = $("#startDate").val();
	  //var endDate = $("#endDate").val();
	 var requestUrl = "";
	 //var para = "startDate=" + startDate + "&endDate=" + endDate
	 var para = "pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	 requestUrl = "/gzjky/memberConsultAction/queryMemberConsultList.do";
      
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
	  $("table.bPhistory_table tr:even").addClass("even");
	  $("table.bPhistory_table tr:odd").addClass("odd");
  }

  function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);
	 
	 var content = recordList[index].content.split(" ")[0];
	  var td = tr.insertCell(0);
	  td.innerHTML = content.length>=12?content.substring(0,10)+".." : content;
	  td.title = content;
	  
	  td = tr.insertCell(1);
	  td.innerHTML = recordList[index].createTime.substring(0,19);
	  
	  var report_content = recordList[index].report;
	  td = tr.insertCell(2);
	  td.innerHTML = report_content.length>=12?report_content.substring(0,10)+".." : report_content;

	  td = tr.insertCell(3);
	  td.innerHTML = recordList[index].state;
	 
	  td = tr.insertCell(4);
	  td.innerHTML = "<a href='javascript:void(0)' class='btn btn-info' style='width:85px' onclick='showDialogDetail("+index+")'><i class='fa fa-fw fa-eye'></i>查看</a>";
  }
  
  
  function showDialog(){
		//$("#addMemberConsultForm :checkbox").attr("checked",false);
		$("#addMemberConsultForm :checkbox").iCheck('uncheck');
		$("#addMemberConsultForm").find("#content").val("");
		jQuery('#addMemberConsultForm').validationEngine("hide");
	   var tt = "增加会员咨询";
		$('#memberConsultWindow').draggable({
			disabled : true
		});
		$("#pop_memberConsultTitle").text(tt);
		$("#memberConsultWindow").modal('show');
		//showScreenProtectDiv(1);
  }
  
  function showDialogDetail(index){
	   var tt = "会员咨询详情";
	   //$("#memberConsultDetailForm :checkbox").attr("checked",false);
	   $("#memberConsultDetailForm :checkbox").iCheck('uncheck');
	   var content = recordList[index].content;
	   var content_arr = content.split(" ");
	   var symptomStrs = new Array();
	   if(recordList[index].symptom != '' && recordList[index].symptom != null){
		   symptomStrs = recordList[index].symptom.split(",");
		   for(var i=0;i<symptomStrs.length;i++){
			   $("#memberConsultDetailForm input[name='symptomId'][value='"+symptomStrs[i]+"']").iCheck('check');
		   }
	   }
	   $("#memberConsultDetailForm").find("#content").val(content_arr[0]);
	   $("#memberConsultDetailForm").find("#createTime").val(recordList[index].createTime.substring(0,19));
	   $("#memberConsultDetailForm").find("#report").val(recordList[index].report);
	   $("#memberConsultDetailForm").find("#reportCreateTime").val(recordList[index].reportCreateTime.substring(0,19));
	   $("#memberConsultDetailForm").find("#state").val(recordList[index].state);
	   
		$('#memberConsultDetailWindow').draggable({
			disabled : true
		});
		$("#pop_memberConsultDetailTitle").text(tt);
		$("#memberConsultDetailWindow").modal('show');
		//showScreenProtectDiv(1);
}
  
  
  function saveMemberConsult(){
		if(!jQuery('#addMemberConsultForm').validationEngine("validate")){
			return false;
		}
		var requestUrl = "/gzjky/memberConsultAction/addMemberConsult.do";
	   var content = $("#addMemberConsultForm").find("#content").val();
	   var para = "content="+content;
	   var symptomIds = "";
	   var symptomStr = "";
	   $("#addMemberConsultForm input[name='symptomId']").each(function(index,obj){
		   if(this.checked){
		   		symptomIds += this.value+":";
		   		symptomStr += htRelatedSymptomMap[this.value] + ",";
		   }
	   });
	   if(symptomIds.length>0){
		   para += "&symptomIds=" + symptomIds.substring(0,symptomIds.length-1);
		   para += "&symptomStr=" + symptomStr.substring(0,symptomStr.length-1);
	   }else{
		   para += "&symptomIds=";
		   para += "&symptomStr=";
	   }
  	   showScreenProtectDiv(1);
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
				hideScreenProtectDiv(1);
		        hideLoading();
			    var state = response.updateFlag;
			    if(state == "1"){
			    	$.alert("增加成功");
			    }else{
			    	$.alert("增加失败");
			    }
			    closeDiv_memberConsult();
			    query();
			}
		});
  }
  
  function closeDiv_memberConsult() {
		$("#memberConsultWindow").modal('hide');
		//hideScreenProtectDiv(1);
	}
  
  function closeDiv_memberConsultDetail(){
		$("#memberConsultDetailWindow").modal('hide');
		//hideScreenProtectDiv(1);
  }
</script>
</head>

<body onload="startInit()" class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
		<!-- Content Header (Page header) -->
        <section class="content-header">
             <h1>会员咨询</h1>
             <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li>健康通告</li>
                  <li class="active">会员咨询</li>
             </ol>
         </section>
			<!--bp_history start-->
			<div >
			  <div class="box box-info">
	              <div class="box-header">
						<h3 class="box-title">咨询历史</h3>
						<a href="javascript:void(0)" onclick="showDialog()" style="float: right;margin: -12px;padding: 0px 22px 0px 0px;">
						<h3 class="btn btn-success"><i class="fa fa-plus-square"></i> 新增</h3></a>
					</div>
              	  <div class="box-body">
				  <div class="row">
				  <br/>
				  <br/>
				  <div class="col-lg-11">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table" id="faceTable" >
				      <colgroup>
				        <col width="28%" />
				        <col width="24%" />
				        <col width="28%" />
				        <col width="10%" />
				        <col width="10%" />
				      </colgroup>
				      <tr>
				        <th nowrap="nowrap">咨询内容</th>
				        <th nowrap="nowrap">咨询时间</th>
				        <th nowrap="nowrap">医生回复</th>
				        <th nowrap="nowrap">状态</th>
				        <th nowrap="nowrap">操作</th>
				      </tr>
				    </table>
				  </div>
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
	</div>
 </div>
 <div class="modal fade" id="memberConsultWindow"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%">
  <div class="modal-dialog">	
	  <div class="popup_header">
	    <ul>
	      <li class="name_popupHeader" id="pop_memberConsultTitle">增加亲情号码</li>
	      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv_memberConsult();">X</a></li>
	    </ul>
	  </div>
	  <form id="addMemberConsultForm" >
			<div class="popup_main">
		         <ul>
		         	<li class="huanhang">
		              <ul>
			              <li class="tgrey_popup1">症状：</li>
			              <li class="tblack_popup1"  >
		             			<input type="checkbox" name="symptomId"  style="margin-bottom:-5px; margin-right:2px;"   value="1"/>发烧
		             			<input type="checkbox" name="symptomId"  style="margin-bottom:-5px; margin-right:2px;"   value="2"/>感冒
			              </li>
		              </ul>
		              </li>
		            <li class="huanhang">
		              <ul>
			              <li class="tgrey_popup1">*咨询内容：</li>
			              <li class="tblack_popup1">
		              	  <textarea class="inputMin_informationModify validate[required]"  name="content" id="content" rows="5" cols="40" style="border: 1px solid #ccc"></textarea>
		           	   	  </li>	
		           	  </ul>
		           	</li>
		            <li class="text-center"><a href="javascript:void(0)" class="btn btn-info " onclick="saveMemberConsult()"><i class='fa fa-edit'></i> 保存</a></li>                                       
		         </ul>
		      </div> 
	  </form>
 	</div>
 </div>
 
<div class="modal fade" id="memberConsultDetailWindow"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:10%">
  <div class="modal-dialog">	
	  <div class="popup_header">
	    <ul>
	      <li class="name_popupHeader" id="pop_memberConsultDtailTitle">会员咨询详情</li>
	      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv_memberConsultDetail();">X</a></li>
	    </ul>
	  </div>
	  <form id="memberConsultDetailForm" >
			<div class="popup_main">
		         <ul>
	         
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">症状：</li>
	              <li class="tblack_popup1"  >
	              	<input type="checkbox" name="symptomId"  style="margin-bottom:-5px; margin-right:2px;" disabled="disabled"  value="1"/>发烧
	              	<input type="checkbox" name="symptomId"  style="margin-bottom:-5px; margin-right:2px;" disabled="disabled"  value="2"/>感冒
	              </li>
	              </ul>
	              </li>
	              
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">咨询内容：</li>
	              <li class="tblack_popup1">
	              <textarea  name="content" id="content"  class="inputMin_informationModify" rows="5" cols="40" disabled="disabled" style="border: 1px solid #ccc"></textarea>
	           	   </li>
	           	   </ul>
	           	   </li>
	           	   
	           	   <li class="huanhang">
	              <ul>			
	           	  <li class="tgrey_popup1">咨询时间：</li>
	              <li class="tblack_popup1">
	              		<input class="inputMin_informationModify " type="text"  id="createTime"  name="createTime"  disabled="disabled" />
	              </li> 
	              </ul>
	              </li>  
	              
	              <li class="huanhang">
	              <ul>             
	              <li class="tgrey_popup1">医生回复：</li>
	              <li class="tblack_popup1">
	              		<textarea  name="report" id="report"  class="inputMin_informationModify" rows="5" cols="40" disabled="disabled"  style="border: 1px solid #ccc"></textarea>
	              </li>
	              </ul>
	              </li>              
	              
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">回复时间：</li>
	              <li class="tblack_popup1">
	              		<input class="inputMin_informationModify " type="text"  id="reportCreateTime"  name="reportCreateTime"   disabled="disabled"/>
	              </li> 
	              </ul>
	              </li>   
	              
	              <li class="huanhang">
	              <ul>
	              <li class="tgrey_popup1">状态：</li>
	              <li class="tblack_popup1">
	              		<input class="inputMin_informationModify " type="text"  id="state"  name="state"   disabled="disabled" />
	              </li> 
	              </ul>
	              </li>  	              
	                               
	         </ul>
	      </div> 
	      </form>
	 </div>
 </div>
   

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
<!--bp_history end-->
</body>
</html>
