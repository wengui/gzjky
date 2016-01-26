<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>账户套餐</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript" ></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>

<script type="text/javascript">
  $(function(){
	var $div_trli = $("div.tab_menu ul li");
	
	$div_trli.click(function(){	
	$(this).addClass("selected_record").siblings().removeClass("selected_record");
    var index = $div_trli.index(this);
    $("div.tab_box_record > div").eq(index).show().siblings().hide(); 	
	});
	
    $("table.meal_table tr:even").addClass("even");
    $("table.meal_table tr:odd").addClass("odd");
	$("table.bPhistory_table tr:even").addClass("even");
    $("table.bPhistory_table tr:odd").addClass("odd");
   
   })
   
  var devicePackageList;
  var platformServiceList;
  var packageServiceStatusList;
  var useNumberList;
  var startDate="";
  var endDate="";  
  
  function startInit(){
	  queryStart();
	  queryBalance();
  }
 
  
  function queryStart(){
  	  $.fn.page.settings.currentnum = 1;  
  	  query();
  }
  
   function query(){
   	  var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
	  if(pointerStart<0) pointerStart = 0;
	  var para="pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	  
  	  showScreenProtectDiv(1);
	  showLoading();
	  var requestUrl="/packageAction/queryDevicePackage.action";
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
			    devicePackageList = modelMap.devicePackageList;
			    $.fn.page.settings.count = modelMap.devicePackageCount;
				page($.fn.page.settings.currentnum);
			}
		});
  }
  function showData(){
	  clearFaceTable();

	  for(var i=0;i<$.fn.page.settings.currentsize;i++){
	  	  var id = devicePackageList[i].id;
		  var package_name = devicePackageList[i].package_name;
		  var package_type = devicePackageList[i].package_type;
		  var start_date = devicePackageList[i].start_date;
		  var end_date =devicePackageList[i].end_date;
		  addrowtotable(i,id,package_name,package_type,start_date,end_date);
	  }
  } 
 
  function addrowtotable(i,id,package_name,package_type,start_date,end_date){
    	try{
    		var time_unit="";
    		if(package_type==0){
    			time_unit="次";
    		}
    		if(package_type==1){
     			time_unit="月";
     		}
     		if(package_type==3){
     			time_unit="季"; 
     		}
     		if(package_type==12){
     			time_unit="年"; 
     		}
  
     		var iDays=DateDiff(end_date, "2016-01-06");
     		
		    var table = document.getElementById("faceTable");
		    var rowcount=table.rows.length;
			var tr=table.insertRow(rowcount);
	
		    td=tr.insertCell(0);
		    if(package_name==null||package_name==""){
		    	td.innerHTML="--";
		    }
		    else{
		    	td.innerHTML="<a href='javascript:void(0)' onclick='queryPackageServiceStatus("+i+")'>"+package_name+"</a>";
		    }
		    td.align="center";
		    
		    td=tr.insertCell(1);
		    td.innerHTML ="包"+time_unit+"套餐" ;
		    td.align="center";
		    
		    td=tr.insertCell(2);
		    td.innerHTML =  start_date;
		    td.align="center";
		    
	        td=tr.insertCell(3);
		    td.innerHTML = end_date+"(剩余"+iDays+"天)";
		    td.align="center";
		    	    
		    
	   } catch(e){	   
	     alert(e.toString());
	   }
    } 
   
   //计算天数差
  function DateDiff(sDate1, sDate2){  //sDate1和sDate2是2004-10-18格式
    var  oDate1, oDate2, iDays;

    oDate1 = new Date(Date.parse(sDate1.replace(/-/g, "/"))).getTime();  
   
    oDate2 = new Date(Date.parse(sDate2.replace(/-/g, "/"))).getTime();
    
    iDays =Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24;  //把相差的毫秒数转换为天数
    return iDays;
  } 
  
  function queryPackageServiceStatus(i){
  	  showScreenProtectDiv(1);
	  showLoading();
	  var requestUrl="/packageAction/queryPackageServiceStatus.action";
	  var para="id="+devicePackageList[i].id+"&package_id="+devicePackageList[i].package_id;
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
			    packageServiceStatusList = modelMap.packageServiceStatusList;
			    showPackageServiceStatus(i);		   
			}
		});
  }
  
  //弹出套餐使用情况
	function showPackageServiceStatus(index) {				
    	var str="";
   		if(packageServiceStatusList!=null){
	    		for(var i=0;i<packageServiceStatusList.length;i++){
	    			var use_num=packageServiceStatusList[i].use_num;
	    			if(use_num==null||use_num==""){
	    				use_num=0;
	    			}
	    			var surplus=packageServiceStatusList[i].count-use_num;
	    			str+=i+1+"、"+ packageServiceStatusList[i].service_name+"(剩余"+surplus+"条）。<br>";
	    		} 
	    }
    	$("#package_name")	.html(devicePackageList[index].package_name);
    	$("#service").html(str);
    	
    	var description=devicePackageList[index].description;
    	var device_sid=devicePackageList[index].device_sid;
    	if(description==null){
    		description="";
    	}
    	
    	$("#device").html(device_sid+"("+description+")");
    	
		$("#packageServiceStatusWindow").draggable({
			disabled : true
		});
		$("#packageServiceStatusWindow").show(200);
		showScreenProtectDiv(1);
		
	}
	//关闭套餐使用情况
	function closeDiv() {
		$("#packageServiceStatusWindow").hide(200);
		hideScreenProtectDiv(1);
	}

    
    
    
    
    function sonIframeResize() {
		var iframe = document.getElementById("recharge_history_iframe");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.min(bHeight, dHeight);
			iframe.height = height + "px";
			
		} catch (ex) {
		    
		}
		
		var iframe = document.getElementById("consume_record_iframe");
		try {
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
			var height = Math.min(bHeight, dHeight);
			iframe.height = height + "px";
			
		} catch (ex) {
		    
		}
	}
	
	window.setInterval("sonIframeResize()", 200); 
	//查询余额
	function queryBalance() {
		
		  var requestUrl = "/h/queryBalance.action";
		  var login_id = 'test1';
		  var mobile = '15921041319'
		  var para="mobile="+mobile+"&login_id="+login_id;
		  
		  xmlHttp = $.ajax({
				url: requestUrl,
				async:true,
				data: para,
				dataType:"json",
				type:"POST",
				complete:function(){
				    
				},
				error:function(){
					$.alert('无权限');
				},success:function(response){
				  
				    if(response != null) {
				        var balance = response;
				        
				        document.getElementById("package_bill").innerHTML = balance;
				    }
				}
			});
		}
   
</script>
</head>

<body onload="startInit()" class="skin-blue">
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	         <!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
           <section class="content-header">
              <h1>账户/套餐
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li >账户套餐</li>
                  <li class="active">账户/套餐</li>
              </ol>
          </section>
          <!-- Main content -->
          <section class="content">
		    	<div class="account_main">
			     <div class="my_meal">
			        <div class="title_myMeal">
			          <ul>
			            <li class="tLeft_myMeal">我的套餐</li>
			            <li class="tRight_myMeal"><a href="meal.jsp"><img src="../../../images/button/btn_buy.png" title="购买套餐"/></a></li>
			          </ul>
			        </div>
			        <div class="index_table">
			          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table"  id="faceTable">
			            <colgroup>
			              <col width="35%" />
			              <col width="15%" />
			              <col width="20%" />
			              <col width="30%" />
			            </colgroup>
			            <tr>
			              <th>套餐名称</th>
			              <th>套餐类型</th>
			              <th>起始日期</th>
			              <th>结束日期</th>
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
			<!--account_security start-->
			
			      <div class="my_meal">
			      <br> </br>
			        <div class="title_myMeal">
			          <ul>
			            <li class="tLeft_myMeal">我的余额：<span id="package_bill">0.00</span>元&nbsp;&nbsp;&nbsp;<a title="充值" class="btn" style="color:margin-left:20px; text-decoration: none;" href="recharge.jsp"><span style="color:#5a5a5a">立即充值</span></a></li>
			            <li class="tRight_myMeal"></li>
			          </ul>
			        </div>
			      </div>
			      
			      <!--account_security end-->
			        </div>
			      </div>
			      <!--my_meal end-->
          </section><!-- /.content -->
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
 <div class="popup" id="packageServiceStatusWindow" style="display:none;position:absolute;top:200px; left:100px;z-index: 30;">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">套餐使用情况</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeDiv();">X</a></li>
    </ul>
  </div>
 
  <form id="packageServiceStatusform" >
		<div class="popup_main">
	         <ul>
	            <li class="tgrey_Packagedetails_left">套餐名称：</li>
	            <li class="tblack_Packagedetails_right"  id="package_name"></li>
	            <li class="tgrey_Packagedetails_left">所属设备：</li>
	            <li class="tblack_Packagedetails_right"  id="device"></li>
	            <li class="tgrey_Packagedetails_left">服务内容：</li>
	            <li class="tblack_Packagedetails_right" id="service"></li>
	            
	  		</ul>
	  </div>
   </form>
 </div>

</body>
</html>
  	

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
</body>
</html>
