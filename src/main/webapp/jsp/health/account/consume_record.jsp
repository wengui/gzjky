<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>消费记录</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/common/date.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>


<script type="text/javascript">
  menuId = "#consume";
  var startDate="";
  var endDate="";
  var recordList;
  function startInit(){	
	  //queryStart();
  }
  function queryStart(){
	  $.fn.page.settings.currentnum = 1;  
	  startDate = $("#startDate").val();
	  endDate = $("#endDate").val();
	  query();
  }
  function query(){
	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;

	 var para = "startDate=" + startDate + "&endDate=" + endDate
		+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	 var requestUrl="/packageAction/queryConsumeRecord.action";
    
	  showScreenProtectDiv(1);
	  //showLoading();
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
			    var modelMap = response.modelMap;		   
			    recordList = modelMap.ConsumeRecordList;		    			
				$.fn.page.settings.count = modelMap.ConsumeRecordCount;
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
	  /* $("table.bPhistory_table tr:even").addClass("even");
	  $("table.bPhistory_table tr:odd").addClass("odd"); */
  }

  function addrowtotable(table,index){
	 var rowcount=table.rows.length;
	 var tr=table.insertRow(rowcount);

	 recordList[index].create_time = recordList[index].create_time.substring(0,19);
	
	 var td = tr.insertCell(0);
	 td.innerHTML=recordList[index].create_time;
	
	
	 var td = tr.insertCell(1);
	 td.innerHTML=recordList[index].pay;
	 
	 var td = tr.insertCell(2);	 
	 if(recordList[index].business_code=="0001"){
	 	td.innerHTML="套餐定制";
	 }
	 
	 var td = tr.insertCell(3);
	 if(recordList[index].business_name==null||recordList[index].business_name==""){
	 	td.innerHTML="--";
	 }
	 else{
	 	td.innerHTML=recordList[index].business_name;
	 }
  } 

    function queryPlatformService(i){
    	  showScreenProtectDiv(1);
		  showLoading();
		  var id=recordList[i].business_id;
		  var para="id="+id;
	
		  var requestUrl="/packageAction/queryPlatformService.action";
		  xmlHttp = $.ajax({
				url: requestUrl,
				async:true,
				data:para,
				dataType:"json",				
				type:"POST",
				complete:function(){
				     hideLoading();
				},
				error:function(){
					$.alert('无权限');
				},success:function(response){
				    var modelMap = response.modelMap;
					platformServiceList=modelMap.platformServiceList;		 
				   
					showPackageInformation(i);
				}
			});
    }
    
     function showPackageInformation(index){
 	 
    		$("#package_name").html(recordList[index].business_name);
    		
    		var type=recordList[index].business_type;
    		var price=recordList[index].pay;
    		
    		var time_unit="";
    		if(type==0){
    			time_unit="次";
    		}
    		if(type==1){
     			time_unit="月";
     		}
     		if(type==3){
     			time_unit="季"; 
     		}
     		if(type==12){
     			time_unit="年"; 
     		}
    		
    		if(type==0){
     			$("#package_price").html(price+"元");
     		}
     		else{
     			$("#package_price").html(price+"元/"+time_unit);
     		}
    		$("#package_type").html("包"+time_unit+"套餐");
    		
    		var str="";
   			if(platformServiceList!=null){
	    		for(var i=0;i<platformServiceList.length;i++){
	    			str+=i+1+"、"+ platformServiceList[i].name+"。<br>";
	    		} 
	    	}  	
	    	$("#service").html(str);
    		$("#packageInformationWindow").draggable({
				disabled : true
			});
			$("#packageInformationWindow").show(200);
			showScreenProtectDiv(1);
     }
     
	//关闭套餐详情
	function closeDiv() {
		$("#packageInformationWindow").hide(200);
		hideScreenProtectDiv(1);
	}
</script>
</head>

<body onload="startInit()" class="skin-blue">
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
           <section class="content-header">
              <h1>消费记录
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li >账户套餐</li>
                  <li class="active">消费记录</li>
              </ol>
          </section>
          <!-- Main content -->
		<div class="bp_history">
		  <div class="box box-success">
              <div class="box-header">
                  <h3 class="box-title">条件检索</h3>
              </div>		
              <div class="box-body">
	              	<div class="row">
		                 <div class="col-lg-4">
			                  <div class="input-group">
			                  	  <label style="width:70px">开始时间:</label>
			                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
			                      <input type="text" class="form-control" id="startDate" name="startDate" onfocus="var endDate=$dp.$('endDate');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})"/>
			                  </div>
		                 </div><!-- /.col-lg-3 -->
		                <div class="col-lg-4">
		                  <div class="input-group">
			                  	  <label style="width:70px">结束时间:</label>
			                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
			                      <input type="text"  class="form-control"  id="endDate" name="endDate"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})"/>
			               </div>
		               </div><!-- /.col-lg-3 -->
		               <div class="col-lg-3">
		               	 <button class="btn btn-success" style="margin-left:20px" onclick="queryStart();"><i class="fa fa-search"></i> 查询</button></div><!-- /.col-lg-3 -->
		               <div class="col-lg-3">
		               </div>
	              </div><!-- /.box-body -->
	              <div class="row">
	              	<br/>
	              	<div class="col-lg-6">
	              		 <label>快速查询:</label>
	              		 <a href="javascript:changeDate(3)" style="margin-left:20px;margin-right:15px;">最新3天</a>
	              		 <a href="javascript:changeDate(7)" style="margin-right:15px;">最近一周</a>
	              		 <a href="javascript:changeDate(30)" style="margin-right:15px;">最近30天</a>
	              		 <a href="javascript:changeDate(365)">最近一年</a>
	              	</div>
	              </div>
	      </div>		

		  <div class="row">
		  	<br/>
		  	<div class="col-lg-11">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-bordered bPhistory_table" id="faceTable">
			      <colgroup>
			        <col width="30%" />
			        <col width="20%" />
			        <col width="20%" />
			        <col width="30%" />
			      </colgroup>
			      <tr>
			        <th>消费日期</th>
			        <th>消费金额(元)</th>
			        <th>消费类型</th>
			        <th>购买业务</th>
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
  

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
		</div>
		</div>
     </aside><!-- /.right-side -->
</div><!-- ./wrapper -->       

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
</head>
<body>
 <div class="popup" id="packageInformationWindow" style="display:none;position:absolute;top:0px; left:100px;z-index: 30;">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">套餐详情</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv();">X</a></li>
    </ul>
  </div>
  

      <form id="packageInformationform" >
		<div class="popup_main">
	         <ul>
	            <li class="tgrey_Packagedetails_left">套餐名称：</li>
	            <li class="tblack_Packagedetails_right"  id="package_name"></li>
	            <li class="tgrey_Packagedetails_left">套餐类型：</li>
	            <li class="tblack_Packagedetails_right"  id="package_type"></li>
	            <li class="tgrey_Packagedetails_left">套餐价格：</li>
	            <li class="tblack_Packagedetails_right"  id="package_price"></li>
	            <li class="tgrey_Packagedetails_left">服务内容：</li>
	            <li class="tblack_Packagedetails_right" id="service"></li>
	            
	  		</ul>
	  </div>
   </form>

 </div>

</body>
</html>
<!--bp_history end-->
</body>
</html>
