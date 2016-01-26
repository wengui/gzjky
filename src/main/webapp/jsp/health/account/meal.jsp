<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>套餐一览</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script>

<script type="text/javascript" >
	 var deviceBaseInfoList;
	 var packageBaseinfoList;
	 var platformServiceList;
	 
	 function startInit(){
	  	queryStart();
	 }
	 
	 function queryStart(){
		query();
	 }
	 
	function query(){
  	  showScreenProtectDiv(1);
	  showLoading();
	  var requestUrl="/packageAction/queryPackageBaseinfoList.action";
	  xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
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
				deviceBaseInfoList=modelMap.deviceBaseInfoList;
				packageBaseinfoList=modelMap.packageBaseinfoList;
				drawFaceTable();
			}
		});
  	}
 
	//画表
	function drawFaceTable() {
	    if(deviceBaseInfoList!=null){
			var t="";
			for(var i=0;i< deviceBaseInfoList.length;i++){
				t+="<option value='"+deviceBaseInfoList[i].unit_id+";"+deviceBaseInfoList[i].cluster_id+";"+deviceBaseInfoList[i].unit_type+";"+deviceBaseInfoList[i].version+"'>"+deviceBaseInfoList[i].serial_id+"("+deviceBaseInfoList[i].description+")</option>";
			} 
	
			$("#device").append(t); 
		} 
	    if(packageBaseinfoList != null){
		    for (var i = 0; i < packageBaseinfoList.length; i++){
		    		var id = packageBaseinfoList[i].id;
					var name = packageBaseinfoList[i].name;
					var type = packageBaseinfoList[i].type;
					var price = packageBaseinfoList[i].price;
					addrowtotable(i,id,name,type,price);
			}
			var u = $("#show_list"); 
			u.append("<br><br><br><br><br><br>");
	    }
    }
    
    function addrowtotable(i,id,name,type,price){
    	try{	
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
    		var u = $("#show_list"); 
      		var t="<div class='meal_list'>"; 
      		t+="<ul>";     		
     		t+="<li class='img_meal'><img src='/images/health/meal.png' /></li>"; 
     		t+="<li class='meal_information'>"; 
     		
     		t+="<ul>";
     		t+=" <li class='tblackName_meal'>"+name+"</li>";
     		
     		if(type==0){
     			t+="<li class='tName_meal'><span class='tgreyName_Meal'>套餐价格：</span>"+price+"元</li>";
     		}
     		else{
     		t+="<li class='tName_meal'><span class='tgreyName_Meal'>套餐价格：</span>"+price+"元/"+time_unit+"</li>";
     		}
     		t+="<li class='tName_meal'><span class='tgreyName_Meal'>套餐类型：</span>包"+time_unit+"套餐</li>"; 
     		t+="</ul>";
         	t+="</li>";
     		t+="<li class='btn_meal'><a href='javascript:void(0)' onclick='queryPlatformService("+i+")' class='btnMeal_information'>套餐详情</a><a href='javascript:void(0)' onclick='selectDevice("+i+")' class='btnMeal_buy'>立即购买</a></li>";
     		
     		/* t+="<li class='package_button'><a href='#' onclick='showDialog("+i+")'><img src='../../../images/index/btn_package.png' alt='购买' /></a>&nbsp;&nbsp;";
     		t+="<a href='QueryServiceByPackage.action?packageBaseinfo.id="+id+"&packageBaseinfo.name="+encodeURI(encodeURI(name))+"&packageBaseinfo.price="+price+"&packageBaseinfo.type="+type+"&packageBaseinfo.online="+online+"&packageBaseinfo.offline="+offline+"'><img src='../../../images/index/btn_package02.png' alt='详情' /></a></li>"; */
    		t+="</ul>"; 
    		t+="</div>"; 
    		u.append(t);
    		
    		
	   } catch(e){	   
	     hiAlert(e.toString()+"请注意");
	   }
    }
    
    function queryPlatformService(i){
    	  showScreenProtectDiv(1);
		  showLoading();
		  var id=packageBaseinfoList[i].id;
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
    
    //弹出套餐详情
     function showPackageInformation(index){
   			$("#packageInformationWindow").css("top",(100*index)+"px");
		 
    		$("#package_name").html(packageBaseinfoList[index].name);
    		
    		var type=packageBaseinfoList[index].type;
    		var price=packageBaseinfoList[index].price;
    		
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
	
	 //选择购买套餐的设备
	 function selectDevice(i){
    	if(deviceBaseInfoList==null||deviceBaseInfoList=="" ||deviceBaseInfoList.size==0){
    		$.alert("未登录或未绑定设备!");
    	}
    	else{   
    		$("#package_idv").val(packageBaseinfoList[i].id);
		    $("#package_typev").val(packageBaseinfoList[i].type);
		    $("#package_pricev").val(packageBaseinfoList[i].price);	
		    $("#package_namev"). val(packageBaseinfoList[i].name);
		    $("#package_name_li"). html(packageBaseinfoList[i].name);
		    //$("#selectDeviceWindow")	.attr("style","top:"+(200+50*i)+"px");
		    $("#selectDeviceWindow").css("top",(100*i)+"px");
		    $("#selectDeviceWindow").show(200);
		    
		    /* $("#selectDeviceWindow").draggable({
				disabled : true
			});  */		    
		    showScreenProtectDiv(1);		    
	    }       
    }
    //关闭设备选择
	function closeSelectDevice() {
		$("#selectDeviceWindow").hide(200);
		hideScreenProtectDiv(1);
	}
	
	//购买套餐
	function buyPackage(){
		  closeSelectDevice();
		  $("#selectDeviceForm").submit();		 
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
              <h1>购买套餐
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li >账户套餐</li>
                  <li class="active">购买套餐</li>
              </ol>
          </section>
		  <div class="box box-warning bp_accouint">
              <div class="box-header">
                  <h3 class="box-title">套餐一览</h3>
              </div>		
              <div class="box-body">


<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>

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
  

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
</head>
<body>
 <div class="popup" id="selectDeviceWindow" style="display:none;position:absolute;top:400px; left:100px;z-index: 30;">
 <form target="_blank" action="/packageAction/buyPackageOrder.helowin" id="selectDeviceForm" method="post">
  <div class="popup_header">
    <ul>
      <li class="name_popupHeader">选择设备</li>
      <li class="close_popupHeader"><a href="javascript:void(0)" onclick="closeSelectDevice();">X</a></li>
    </ul>
  </div>
  <div class="popup_main">
     
      	<input type="hidden" id="package_pricev"  name="pay"/>
      	<input type="hidden" id="package_idv" name="package_id"/>
      	<input type="hidden" id="package_typev" name="package_type"/>
      	<input type="hidden" id="package_namev" name="package_name"/>
		<div class="popup_main">
	            <ul>
	              <li class="tgrey_Packagedetails_left">套餐名称：</li>
	              <li class="tblack_Packagedetails_right" id="package_name_li"></li>
	              <li class="tgrey_Packagedetails_left">请选择设备：</li>
	              <li class="tblack_Packagedetails_right">
		             	<select  id="device"  name="device"  style="width: 280px">

		                </select>
	              </li>
	               <li class="btn_popup_confirm2"><a href="javascript:void(0)" onclick="buyPackage()">购买</a><a href="javascript:void(0)" onclick="closeSelectDevice()">取消</a></li>	
	     </ul>               	                 
  </div>
  
 </div>
 </form>
</div>
</body>
</html>

  		  </div>
  		  </div>
     </aside><!-- /.right-side -->
</div><!-- ./wrapper -->
</body>
</html>
