<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120医生服务中心</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/bootstrapCommon.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script type="text/javascript">
menuId = "#records";
var edit_image = "<a class='btn btn-success'><i class='fa fa-edit'></i> 编辑</a>";
var save_image = "<a class='btn btn-success'><i class='fa fa-save'></i> 保存</a>";

function startInit(){
	var $div_hrli = $(".safePage");
	//健康病史页签
	var tab_map = {0:1};
	//健康病史页签加载函数
	var iframe_map = {"memberhabit":"memberHabitIframe","memberfamilydisease":"memberFamilyDiseaseIframe",
			"memberhtcomplication":"memberHtComplicationIframe","memberIllnessHistory":"memberIllnessHistoryIframe","memberhtspecial":"memberHtSpecialIframe",
			"medicalexamination":"memberMedicalExamintaionIframe","check":"healthTestIframe"};
	var page_map = {"memberhabit":"memberhabit","memberfamilydisease":"memberfamilydisease",
									"memberhtcomplication":"memberhtcomplication","memberIllnessHistory":"memberIllnessHistory","memberhtspecial":"memberhtspecial",
									"medicalexamination":"medicalexamination","check":"check"};
									//5:"medicalexamination",6:"http://zijin.995120.cn/jktj/hasControl/index.htm?patientId=24913"};
	$div_hrli.click(function(){	
		//alert($(this).attr('id'));
	   var index = $div_hrli.index(this);
	   $("div.tab_healthRecords_box > div").eq(index).show().siblings().hide(); 

	   //页签已经加载
		if(index in tab_map){
			   
		}else{
		    //var fn = function_map[index];
		    var frame_sel = "";
		    var page = "";
		   frame_sel = iframe_map[$(this).attr('id')];
		   page = page_map[$(this).attr('id')];
		    
		    if(page !=null || page !=""){
		    	if(page == "check"){
		    		document.getElementById(frame_sel).src = "";
		    	}else{
		    		document.getElementById(frame_sel).src = "./"+page+".jsp";
		    	}
		    }
		 }
	});

   //$("table.bPhistory_table tr:even").addClass("even");
   //$("table.bPhistory_table tr:odd").addClass("odd");
   
   }
  
  
	var formdic = {"memberBaseInfo_form":1,"detail_form":1,"workinfo_form":1}
	function get_requestPara(iframeId,formId){
		var para = "";
		$(document.getElementById(iframeId).contentWindow.document).find("#"+formId+" :input").each(function(index,obj){
			if(obj.type== "checkbox"){
				para += obj.id+"=" +(obj.checked?"1":"0") + "&";
			}else{
				para += obj.id+"=" +obj.value + "&";
			}
		});
		
		return para.substring(0,para.length);
	}

 	/*
	id为div的id,obj按钮对象
	*/
	function send_request_forDisease(iframeId,formId,obj,requestUrl,para){
		document.getElementById(iframeId).contentWindow.showScreenProtectDiv(1);
		document.getElementById(iframeId).contentWindow.showLoading();
		xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			complete:function(){
				document.getElementById(iframeId).contentWindow.hideScreenProtectDiv(1);
				document.getElementById(iframeId).contentWindow.hideLoading();
			},
			error:function(){
				$.alert('无权限');
			},success:function(response){
			    var state = response.updateFlag;
			    if(state == "1"){
			    	obj.onclick = function(){
			    		if(formId == "habit_form"){
			    			document.getElementById(iframeId).contentWindow.edit_habit(obj);
			    		}else if(formId == "family_form"){
			    			document.getElementById(iframeId).contentWindow.edit_family(obj);
			    		}else if(formId == "complication_form"){
			    			document.getElementById(iframeId).contentWindow.edit_complication(obj);
			    		}
			    	};
			    	//按钮变成编辑图标，元素变成不可以编辑
			    	$(document.getElementById(iframeId).contentWindow.document).find("#"+formId+" :input").attr("disabled",true);
					$.alert("修改成功");
			    }else{
			    	$.alert("修改失败");
			    }
			}
		});
	}
 	

	 
	    function sonIframeResize(iframe) {
			try {
				var bHeight = iframe.contentWindow.document.body.scrollHeight;
				var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
				var height = Math.min(bHeight, dHeight);
				iframe.height = height;
			} catch (ex) {
			    
			}
		}
</script>
</head>

<body onload="startInit()"  class="skin-blue">
	<!-- header logo: style can be found in header.less -->
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	<!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
	<!-- Content Header (Page header) -->
        <section class="content-header">
             <h1>健康病历</h1>
             <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-dashboard"></i> 首页</a></li>
                  <li>健康档案</li>
                  <li class="active">健康病历</li>
             </ol>
         </section>
         
<div class="">
  <!--tab_healthRecords start-->
  <div class="">
		<div class="row">
           <div class="col-lg-2 col-xs-6 safePage" id="memberhabit">
            <!-- small box -->
            <div class="small-box bg-aqua">
            <div class="inner">
                <h4>生活习惯</h4>
             </div>
             <div class="icon  text-center">
                  <i class="ion ion-person-add"></i>
             </div>
             <a href="#" class="small-box-footer">
                More info <i class="fa fa-arrow-circle-right"></i>
             </a>
             </div>
            </div><!-- ./col -->
            <div class="col-lg-2 col-xs-6 safePage" id="memberfamilydisease">
               <!-- small box -->
               <div class="small-box bg-green">
                    <div class="inner">
                    <h4>家族遗传史</h4>
                    </div>
                    <div class="icon">
                         <i class="ion ion-person-add"></i>
                    </div>
                   <a href="#" class="small-box-footer">
                	More info <i class="fa fa-arrow-circle-right"></i>
             		</a>
               </div>
            </div><!-- ./col -->
         <div class="col-lg-2 col-xs-6 safePage" id="memberhtcomplication">
             <!-- small box -->
             <div class="small-box bg-yellow">
                 <div class="inner">
                     <h4>当前并发症</h4>
                 </div>
                 <div class="icon">
                     <i class="ion ion-person-add"></i>
                 </div>
                    <a href="#" class="small-box-footer">
                	More info <i class="fa fa-arrow-circle-right"></i>
             		</a>
             </div>
         </div><!-- ./col -->
         <div class="col-lg-2 col-xs-6 safePage" id="memberIllnessHistory">
             <!-- small box -->
             <div class="small-box bg-red">
                 <div class="inner">
                     <h4>疾病史</h4>
                 </div>
                 <div class="icon">
                     <i class="ion ion-person-add"></i>
                 </div>
                   <a href="#" class="small-box-footer">
                	More info <i class="fa fa-arrow-circle-right"></i>
             		</a>
             </div>
         </div><!-- ./col -->
         <div class="col-lg-2 col-xs-6 safePage" id="memberhtspecial">
            <!-- small box -->
            <div class="small-box bg-blue">
            <div class="inner">
                <h4>高血压专项</h4>
             </div>
             <div class="icon">
                  <i class="ion ion-person-add"></i>
             </div>
             <a href="#" class="small-box-footer">
                More info <i class="fa fa-arrow-circle-right"></i>
             </a>
             </div>
            </div><!-- ./col -->
            <div class="col-lg-2 col-xs-6 safePage" id="medicalexamination">
               <!-- small box -->
               <div class="small-box bg-purple">
                    <div class="inner">
                    <h4>健康检查</h4>
                    </div>
                    <div class="icon">
                         <i class="ion ion-person-add"></i>
                    </div>
                   <a href="#" class="small-box-footer">
                	More info <i class="fa fa-arrow-circle-right"></i>
             		</a>
               </div>
            </div><!-- ./col -->
       </div><!-- /.row -->
		<div class="row">
           
         <div class="col-lg-2 col-xs-6 safePage" id="check">
             <!-- small box -->
             <div class="small-box bg-teal">
                 <div class="inner">
                     <h4>健康体检</h4>
                 </div>
                 <div class="icon">
                     <i class="ion ion-person-add"></i>
                 </div>
                    <a href="#" class="small-box-footer">
                	More info <i class="fa fa-arrow-circle-right"></i>
             		</a>
             </div>
         </div><!-- ./col -->
         <div class="col-lg-3 col-xs-6">&nbsp;</div><!-- ./col -->
       </div><!-- /.row -->
       <!-- top row -->
       <div class="row">
           <div class="col-xs-12 connectedSortable">
               
           </div><!-- /.col -->
       </div>
       <!-- /.row -->
       
    <div class="tab_healthRecords_box">
       	
      <div>
      		<iframe id="memberHabitIframe"  name = "memberHabitIframe" src="./memberhabit.jsp"  frameborder="0" width="100%"  scrolling="no"   height="600px" ></iframe>
      </div>
      
      <div class="hide_healthRecords">
			<iframe id="memberFamilyDiseaseIframe" class="form-div-add" name = "memberFamilyDiseaseIframe" src=""  frameborder="0" width="100%"  scrolling="no" ></iframe>
      </div>
      
      <div class="hide_healthRecords">
      		<iframe id="memberHtComplicationIframe"  name = "memberHtComplicationIframe" src=""  frameborder="0" width="100%"  scrolling="no"   height="600px" ></iframe>
      </div>
      <div class="hide_healthRecords">
      		<iframe id="memberIllnessHistoryIframe"  name = "memberIllnessHistoryIframe" src=""  frameborder="0" width="100%"  scrolling="no"  height="600px" ></iframe>
      </div>
      <div class="hide_healthRecords">
      		<iframe id="memberHtSpecialIframe"  name = "memberHtSpecialIframe" src=""  frameborder="0" width="100%"  scrolling="no"    height="900px" ></iframe>
      </div>
      
      <div class="hide_healthRecords">
 			<iframe id="memberMedicalExamintaionIframe"  name = "memberMedicalExamintaionIframe" src=""  frameborder="0" width="100%"  scrolling="no"   height="650px" ></iframe>
      </div>
      
       <div class="hide_healthRecords">
      		<iframe id="healthTestIframe"  name = "healthTestIframe" src=""  frameborder="0" width="100%"  scrolling="yes"    height="900px" ></iframe>
      </div>     
  </div>
  <!--tab_healthRecords end-->
</div>
</div>
</aside>
</body>
</html>
