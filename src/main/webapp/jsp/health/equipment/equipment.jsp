<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
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

<script type="text/javascript">
  menuId = "#equipment";
  $(function(){
    var $div_li = $("div.tab_menu ul li");
	
    $div_li.click(function(){	
	   $(this).addClass("selected").siblings().removeClass("selected");
	   var index = $div_li.index(this);
	   $("div.tab_box > div").eq(index).show().siblings().hide(); 	
	});

   $("table.bPhistory_table tr:even").addClass("even");
   $("table.bPhistory_table tr:odd").addClass("odd");
   
   })


	var deviceBaseInfoList = null; 		
	//查询用户设备
	function query(){
		showScreenProtectDiv(1);
	 	//showLoading();
		$.ajax({
				url:"/gzjky/device/queryMemberBindDevice.do",
				async:true,
				data:null,
				dataType:"json",
				type:"POST",
				complete:function(){
				    hideScreenProtectDiv(1);
			        hideLoading();
				},
				error:function(){
					$.alert("发生异常");
				},
				success:function(response) {
					deviceBaseInfoList=response;
					createDeviceInfoDiv(deviceBaseInfoList);
				}
			});
	}
	//画出设备列表
	function createDeviceInfoDiv(List) {
		var div = '';
		if (List == null || List.length == 0) {
			div = "<div class='equipment_main'>暂无设备绑定</div>";
		} else {
			for(var i = 0; i < List.length; i++){
			var deviceType = '';
			var serial_id = '';
			var sim = List[i].sim==null?'无':List[i].sim;
			var nickname = List[i].nickname==""?'无':List[i].nickname;
			if(List[i].num == null || List[i].num == -1 || List[i].num == 0){
				serial_id = "未绑定";
			}else{
				serial_id = List[i].num;
			} 
			var deviceType  = List[i].versionname;
		
		   	var flag = List[i].version == '301';
		   	var notice = List[i].area;
		    var shr_top = deviceBaseInfoList[i].ssymax;
			var shr_bottom = deviceBaseInfoList[i].ssymin;
			var dia_top = deviceBaseInfoList[i].szymax;
			var dia_bottom = deviceBaseInfoList[i].szymin;
			var isExistBlood = false;
			if(shr_top==null||shr_top==""
					||shr_bottom==null||shr_bottom==""
					||dia_top==null||dia_top==""
					||dia_bottom==null||dia_bottom==""){
				isExistBlood = true;
			}
			if(i%2==0){
				 div+="<div class='callout callout-success' id='device_div_id_"+i+"'>"
			}
			else{
				 div+="<div class='callout callout-info' id='device_div_id_"+i+"'>"
			}
			//div+="<div style='width: 220px;float:left;'><img src='/gzjky/img/user-bg.png' width='80' height='500'></div>"
			if(List[i].image==""){
				div+="<table><tr><td><img src='/gzjky/images/device/device_notfount.png'  class='img-device'></td><td>"
			}
			else{
				div+="<table><tr><td><img src='"+List[i].image+"' class='img-device' ></td><td>"
			}
			
			
			//div+="<div style='margin-left: 220px;'>"
			div+="<dl class='dl-horizontal'>"+
			
			//div+="<ul>"+	
            "<dt>设备类型：</dt>"+
            "<dd>"+deviceType+"</dd>"+
            "<dt>设备编号：</dt>"+
            "<dd id='serial_id_"+i+"'>"+serial_id+"<a href='javascript:void(0)' onclick='unbind("+i+")' title='解除绑定' class='pl_equipmentMain'>   解除绑定</a></dd>"+
            "<dt>设备别名：</dt>"+
            "<dd id='nickname_"+i+"'>"+nickname+"<a href='javascript:void(0)' class='pl_equipmentMain'><span title='设备别名修改' onclick='editNickname("+i+");'>   设备别名修改</span></a></dd>"+
            "<dt>SIM卡号：</dt>"+
            "<dd id='sim_"+i+"'>"+sim+"<a href='javascript:void(0)' class='pl_equipmentMain'><span title='SIM卡号修改' onclick='editSim("+i+");'>   卡号修改</span></a></dd>";
            //301设备
            if(flag){
            div+="<dt>远程定位：</dt>"+
            "<dd><img id='position_"+i+"' onclick=\"position('"+i+"');\" src='/gzjky/images/icon/quick.png' title='远程定位'/></dd>";
            }
            //是否有血压通知
            if(notice == 0){
             div+="<dt>血压通知：</dt>"+
            "<dd><img title='点击开启测压通知' onclick=\"switchingPic('img_notice','"+i+"');\"  id='img_notice_"+i+"' src='/gzjky/images/icon/btn_off.png' /><span>已关闭血压检测短信通知服务</span></dd>";
            }else{
             div+="<dt>血压通知：</dt>"+
            "<dd class='tblack_equipmentMain'><img title='点击关闭测压通知' id='img_notice_"+i+"' onclick=\"switchingPic('img_notice','"+i+"');\" src='/gzjky/images/icon/btn_on.png' /><span>已开启血压检测短信通知服务</span></dd>";
            }
           
           //301设备是操作,108血压设置
            if(flag){
            div+= "<dt>操作：</dt>"+
            "<dd><a href='javascript:void(0)'><span title='修改配置' onclick='updateConfiguration("+i+");'>修改配置</span></a></dd>";
            }else{
            div+= "<dt>血压设置：</dt>"
            	if(isExistBlood){
            		div+="<dd id='blood_set_"+i+"' >您暂未设置直传血压计的阈值"
          	  	}else{
            		div+="<dd id='blood_set_"+i+"' >收缩压："+shr_bottom+"-"+shr_top+"mmHg,舒张压："+dia_bottom+"-"+dia_top+"mmHg"
            	}
            
            if(isExistBlood){
            	div+="<a href='javascript:void(0)' class='pl_equipmentMain'><span title='阈值设置' onclick='eidtBlood("+i+","+0+","+0+","+0+","+0+");'>阈值设置</span></a><dd  style='color:red'>系统默认的正常血压范围（收缩压：90-140mmHg,舒张压：60-90mmHg）</dd>";
            }
            else{
            	div+="<a href='javascript:void(0)' class='pl_equipmentMain'><span title='阈值设置' onclick='eidtBlood("+i+","+shr_bottom+","+shr_top+","+dia_bottom+","+dia_top+");'>阈值设置</span></a><dd  style='color:red'>系统默认的正常血压范围（收缩压：90-140mmHg,舒张压：60-90mmHg）</dd>";
            }
            	
            
            }
           
           //div+="</ul>"+
         	div+="</dl>"+
         	 "</td></table>"+
           "</div>"
			}
		}
		$('#deviceInfo_head').after(div);
	}
	//编辑血压设置
	function eidtBlood(i,shr_bottom,shr_top,dia_bottom,dia_top){
	 var shr_bottom = shr_bottom==null?'':shr_bottom;
			var shr_top = shr_top==null?'':shr_top;
			var dia_bottom = dia_bottom==null?'':dia_bottom;
			var dia_top = dia_top==null?'':dia_top;
			
		$("#blood_set_"+i).html('收缩压：<input type="input" style="width:40px;height:30px;border:1px solid #bbb" value="'+shr_bottom+'"  id="shrl_'+i+'"/>-'
				+'<input type="input" style="width:40px;height:30px;border:1px solid #bbb" value="'+shr_top+'"  id="shrh_'+i+'"/>mmHg,'
				+'舒张压：<input type="input" style="width:40px;height:30px;border:1px solid #bbb" value="'+dia_bottom+'"  id="dial_'+i+'"/>-'
				+'<input type="input" style="width:40px;height:30px;border:1px solid #bbb"  value="'+dia_top+'"  id="diah_'+i+'"/>mmHg'
				+"<a href='javascript:void(0)' class='pl_equipmentMain'><span onclick='editThreshold("+i+");'>保存</span></a>");
	}
	var regx = /^\d+$/;
	//提交血压阈值设置
	function editThreshold(i){
		var shrl=$("#shrl_"+i).val();//下限
		var shrh=$("#shrh_"+i).val();//上
		var dial=$("#dial_"+i).val();
		var diah=$("#diah_"+i).val();
		if(shrl.length<=0 || !regx.test(shrl) || Number(shrl)<=0 || Number(shrl)>231){
			$.alert("收缩压下限值有效范围为1~231！");
			$("#shrl_"+i).focus();
			return ;
		}
		if(shrh.length<=0 || !regx.test(shrh) || Number(shrh)<=0 || Number(shrh)>231){
			$.alert("收缩压上限值有效范围为1~231！");
			$("#shrh_"+i).focus();
			return ;
		}
		if(Number(shrh)<=Number(shrl)){
			$.alert("收缩压上限值不能低于下限值！");
			$("#shrh_"+i).focus();
			return ;
		}
		if(dial.length<=0 || !regx.test(dial) || Number(dial)<=0 || Number(dial)>231){
			$.alert("舒张压下限值有效范围为1~231！");
			$("#dial_"+i).focus();
			return ;
		}
		if(diah.length<=0 || !regx.test(diah) || Number(diah)<=0 || Number(diah)>231){
			$.alert("舒张压上限值有效范围为1~231！");
			$("#diah_"+i).focus();
			return ;
		}
		if(Number(diah)<=Number(dial)){
			$.alert("舒张压上限值不能低于下限值！");
			$("#diah_"+i).focus();
			return ;
		}
		
		var param="device_id="+deviceBaseInfoList[i].id+"&f_id="+deviceBaseInfoList[i].fId+"&shrink_threshold_bottom="+shrl+"&shrink_threshold_top="
			+shrh+"&diastole_threshold_bottom="+dial+"&diastole_threshold_top="+diah;
		$.ajax({
			url:"/gzjky/device/insertMemberBloodPressureThreshold.do",
			async:true,
			data:param,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert("执行过程中，出现错误！");
			},
			success:function(response) {
				
				var state = response.result
				if(state == "1"){
					$.alert("设置成功");
					$("#blood_set_"+i).html("收缩压："+shrl+"-"+shrh+"mmHg,舒张压："+dial+"-"+diah+"mmHg"+
	            	"<a href='javascript:void(0)' class='pl_equipmentMain'><span onclick='eidtBlood("+i+","+shrl+","+shrh+","+dial+","+diah+");'>阈值设置</span></a>");
				}
				else{
					$.alert("设置失败");

				}
			}
		});
	}
	//sim卡正则规则
	simcard_reg = /^((00){1}[1-9]{1}[0-9]{1,3}|86|\+86)?1[3458]\d{9}$/;
	//编辑sim卡
	function editSim(i){
		var sim = deviceBaseInfoList[i].sim==null?'':deviceBaseInfoList[i].sim;
		$("#sim_"+i).html("<input type='input'  value='"+sim+"' style='height:30px;border:1px solid #bbb' id='simCode_"+i+"'/>"
		+"<a href='javascript:void(0)' class='pl_equipmentMain'><span onclick='editSimCode("+i+");'>保存</span></a>");
		$("#simCode_"+i).focus();
	}
	//编辑sim卡
	function editNickname(i){
		var nickname = deviceBaseInfoList[i].nickname==null?'':deviceBaseInfoList[i].nickname;
		$("#nickname_"+i).html("<input type='input'  value='"+nickname+"' style='height:30px;border:1px solid #bbb' id='dbnickname_"+i+"'/>"
		+"<a href='javascript:void(0)' class='pl_equipmentMain'><span onclick='DbeditNickname("+i+");'>保存</span></a>");
		$("#simCode_"+i).focus();
	}
	
	
	function editSim1(i,sim){
		$("#sim_"+i).html("<input type='input'  value='"+sim+"' style='height:30px;border:1px solid #bbb' id='simCode_"+i+"'/>"
		+"<a href='javascript:void(0)' class='pl_equipmentMain'><span onclick='editSimCode("+i+");'>保存</span></a>");
		$("#simCode_"+i).focus();
	}
	//提交sim修改
	function editSimCode(i){
		var code=$("#simCode_"+i).val();
		if(code==''||!simcard_reg.test(code)){
			$.alert("你输入的sim卡格式不对");
			return;
		}
		var paramt="sim="+code+"&device_id="+deviceBaseInfoList[i].id;
			xmlHttp =$.ajax({
			url : "/gzjky/device/updateDeviceSim.do",
			async : true,
			data : paramt,
			dataType : "json",
			type : "POST",
			error : function() {
				$.alert("发生异常");
			},
			success : function(response) {
				//var modelMap = response.modelMap;
				var state = response.result;
				if(state!='1'){
					$.alert("该sim卡已被使用，请输入新的sim卡");
				}else{
					$.alert('操作成功');
					var str = ""+code+"<a href='javascript:void(0)' class='pl_equipmentMain'><span onclick='editSim1("+i+","+code+");'>卡号修改</span></a>";
					$("#sim_"+i).html(str);
				};
			}
		});
	}
	//切换图片
	function switchingPic(picId,i){
		//判断图片是on还是off
		var flag = $("#"+picId+"_"+i).attr("src").indexOf("btn_on")>0;
		if(flag){
		if(picId == "position"){
			$("#"+picId+"_"+i).attr("src", "/gzjky/images/icon/btn_off.png");
			}else{
				$.confirm('你确认取消血压通知吗?', function() {
					bloodpressureNotice(i,"0");
					$("#"+picId+"_"+i).attr("src", "/gzjky/images/icon/btn_off.png");
					$("#"+picId+"_"+i).attr("title", "点击开启测压通知");
					$("#"+picId+"_"+i).nextAll().remove();
					$("#"+picId+"_"+i).after("<span>已关闭血压检测短信通知服务</span>");
				});
			}
		}else{
			if(picId == "position"){
					position(i);
					$("#"+picId+"_"+i).attr("src", "/gzjky/images/icon/btn_on.png");
				}else{
			$.confirm('你确认增加血压通知吗?', function() {
				bloodpressureNotice(i,"1");
				$("#"+picId+"_"+i).attr("src", "/gzjky/images/icon/btn_on.png");
				$("#"+picId+"_"+i).attr("title", "点击关闭测压通知");
				$("#"+picId+"_"+i).nextAll().remove();
				$("#"+picId+"_"+i).after("<span>已开启血压检测短信通知服务</span>");
			});
			}
		}
	}
	//血压通知
	function bloodpressureNotice(i,isAdd){
	    var url ='';

	   url = "/gzjky/device/updateBloodPressureNotice.do";
	
	   //var paramt="device_unit_id="+deviceBaseInfoList[i].unit_id+"&device_cluster_id="+deviceBaseInfoList[i].cluster_id+"&device_unit_type="+deviceBaseInfoList[i].unit_type;
	   var param="device_id="+deviceBaseInfoList[i].id+"&f_id="+deviceBaseInfoList[i].fId+"&isAdd="+isAdd
		xmlHttp =$.ajax({
			url : url,
			async : true,
			data : param,
			dataType : "json",
			type : "POST",
			error : function() {
				$.alert("发生异常");
			},
			success : function(response) {
				var state = response.result;
				if(state =='1'){
					$.alert('操作成功');
				}
			}
		});
	}
	// 发送远程定位指令 
	function position(i){
		var sim = deviceBaseInfoList[i].sim;
		if(sim.length>0){
			 para = "sim="+sim;
        	xmlHttp = $.ajax({
				url:"/deviceBaseInfo/sendPosition.action",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				error:function(){
					xmlHttp.responseText;
					$.alert("执行过程中，出现错误，未发送成功！");
				},success:function(response) {
					var modelMap = response.modelMap;
					var message= modelMap.message;
					$.alert(message);
				}
			});
		}else{
			$.alert("抱歉！您的设备未设置SIM卡号，不能启动远程定位！");
		}
	}
	//修改配置(301设备)
	function updateConfiguration(i){
		//document.location.href="terminal_setting.jsp?device_unit_id="+deviceBaseInfoList[i].unit_id+"&device_cluster_id="+deviceBaseInfoList[i].cluster_id+"&device_unit_type="+deviceBaseInfoList[i].unit_type;
		document.location.href="/gzjky/menuControlAction/modifyEquipmentSet.do?device_id="+deviceBaseInfoList[i].id;
	}
	
	//显示增加窗口
	function showDialog() {
	$('#popWindow').draggable({
			disabled : true
		});
		$("#popWindow").show(200);
		showScreenProtectDiv(1);
	}
	//关闭增加窗口
	function closeDiv() {
		$("#popWindow").hide(200);
		hideScreenProtectDiv(1);
	}
	
	function unbind(i){
		var para="epId="+deviceBaseInfoList[i].epId;
		$.confirm('你确认解除绑定设备吗?', function() {
				xmlHttp = $.ajax({
				url:"/gzjky/device/deleteMemberDeviceBind.do",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				error:function(){
					$.alert("设备解除失败！");
				},success:function(response) {
					$.alert("设备解除成功！",function(){location.reload();});					
				}
		});
	});
	}
	
	function DbeditNickname(i){
		
		var nick=$("#dbnickname_"+i).val();
		var para="epId="+deviceBaseInfoList[i].epId+"&nickname="+nick;
		
		$.confirm('你确认将设备别名改为：'+nick, function() {
				xmlHttp = $.ajax({
				url:"/gzjky/device/UpdateNickname.do",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				error:function(){
					$.alert("设备别名设置失败！");
				},success:function(response) {
					$.alert("设备别名设置成功！",function(){location.reload();});					
				}
		});
	});
	}
	
	
	
	$('input').on('ifChecked', function(event){  
		  alert(event.type + ' callback');  
		});  
</script>
</head>

<body class="skin-blue" onload="query();" >


	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
		<!-- Left side column. contains the logo and sidebar -->
		<%@ include file="../../shared/sidebarMenu.jsp"%>
		<aside class="right-side">
		
	
			<!-- Main content --> 
			 <section class="content-header">
	             <h1>我的设备</h1>
	             <ol class="breadcrumb">
	                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
	                  <li>健康设备</li>
	                  <li class="active">我的设备</li>
	             </ol>
	         </section> 
			<div class="bp_accouint">
					<div class="box box-danger">
						<div class="box-header">
							<h3 class="box-title">设备信息</h3>
							<a href="/gzjky/menuControlAction/memberBindDevice.do" style="float: right;margin: -12px;padding: 0px 22px 0px 0px;">
							 <h3 class="btn btn-success"><i class="fa fa-plus-square"></i> 新增</h3></a>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							
							<div class="header_equipment" style="margin-top:10px" id="deviceInfo_head">
							</div>
						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->
			</div>
		</aside>
	<form id="addform" style="display: none;"></form>
</div>

</body>
</html>
