<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心V3.0</title>
<meta http-equiv="keywords" content="APP下载,Android,iOS,个人健康服务中心,物联网,可穿戴设备,动态血压,心电,十二导联,电子围栏,用药提醒,测压提醒"/>
<meta http-equiv="description" content="个人健康服务中心"/>
<link rel="Shortcut Icon"  href="/995120.ico"/>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/artDialog/skins/blue.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/download.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/base.js'/> type="text/javascript""></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script type="text/javascript">
	var clientVersionList;
	function clickDownloadTab(id) {
		$("#menuUL li").each(function() {
			$(this).removeClass("appDownload_selected");
		});
		var tempId = "#donwnloadMenu" + id;
		$(tempId).addClass("appDownload_selected");
		  
		if(id == 1) {
			$("#androidAppList").show();
			$("#iosAppList").hide();
		} else {
			$("#androidAppList").hide();
			$("#iosAppList").show();
		}
	}	
   
	function goPageBottom() {
		window.scrollTo(0,document.body.scrollHeight);
	}
	function query(){
		showScreenProtectDiv(1);
	  	showLoading();
		var requestUrl="/clientVersion.action";
	  	$.ajax({
			url: requestUrl,
			async:true,
			data:"",
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
			    clientVersionList = modelMap.clientVersionList;
				drawDiv();
			}
		});
	}
	function drawDiv(){
		$("#iosAppList").html("");
		$("#androidAppList").html("");
		if(clientVersionList!=null&&clientVersionList.length>0){
			var ios='<div class="app_android_left">';
			var android='<div class="app_android_left">';
			for(var i=0;i<clientVersionList.length;i++){
				var div=drawItem(clientVersionList[i]);
				if(clientVersionList[i].model=='IOS'||clientVersionList[i].model=='ios'){
					ios+=div;
				}else{
					android+=div;
				}
			}
			var blank='</div>'+
				 '<div class="app_android_right">'+
				 	'<ul>'+
				 		'<li class="download_protocol"></li>'+
	                    '<li></li>'+
	                '</ul>'+
	             '</div>';
			$("#iosAppList").append(ios+blank);
			$("#androidAppList").append(android+blank);
		}
	}
	function drawItem(item){
		var pos=item.pos_time.substr(0, 10);
		var size=(item.file_size*1.0/1024/1024)+"";
		size=size.substring(0,size.indexOf(".")+3);
		var path=item.file_path;
		if(item.model=='IOS'||item.model=='ios'){
			path=item.app_path;
		}
		var div='<div class="app_information" ><ul>';
		div+='<li class="app_icon_android"><img src="'+item.icon_img_path+'" width="64px" height="64px"/></li>';
		div+='<li class="app_information_main"><ul>'+
				 '<li class="app_name">'+item.display_name+'</li>'+
                    '<li class="app_edition">'+
                           '<span class="tgray_appLeft">最新版本：</span>V'+item.version+
                           '<span class="tgray_appRight">发布日期：</span>'+pos+
                           '<span class="tgray_appRight">软件大小：</span>'+size+'M'+
                    '</li>'+
                    '<li class="app_deployment"><span class="tgray_appLeft">配置要求：</span>'+item.deploy_memo+'</li>'+
                    '<li class="tgray_app">版本说明：</li>'+
                    '<li class="tblack_app">'+item.memo+'</li>'+
              	 '</ul></li>'+
              	 '<li><ul>'+
                        '<li class="app_coad" style="margin-top:8px;"><img src="'+item.code_img_path+'" width="110px" height="110px"/></li>'+
                        '<li class="app_coad"><a href="'+ path +'">'+
                        	'<img src="/images/button/download.png" /></a>'+
                        '</li>'+
                   '</ul></li>';   
		div+='</ul></div>';
		return div;
	}
</script>
</head>

<body onload="query()">
  <div class="download">
    <!--index_health_header start-->
    
	<div class="index_health_header">
      <div class="bgTop_index">
        <div class="index_out">
          <ul>
           <li class="index_wechat"><a href="/jsp/health/index/wechat.jsp" title="995120健康服务中心官方微信" target="_blank">官方微信</a></li>
           <li class="index_bolg"><a href="http://weibo.com/5137507355/profile" title="995120健康服务中心官方微博" target="_blank">官方微博</a></li>
           <li class="index_service_phone" title="400电话">400-0785-120</li>
           <li class="index_username"></li>
           <li >
               
           </li> 
          </ul>
        </div>
      </div>
      <!--indexMenu start-->
      <div class="logo_menu">
        <div class="bg_logo">
          <div class="index_menu">
            <ul id="topMenuNav">
              <li id="topMenu0" style="font-size:8px;"></li>
              <li id="topMenu1"></li>
              <li id="topMenu2"></li>
              <li id="topMenu3">
                  
                  
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>


    <!--indexMenu end-->
    <!--app_download start-->
    <div class="app_download">
      <div class="appDownload_main">
        <div class="tabs_framed styled appDownload_tab">
          <div class="appDownload_tab_menu">
            <ul id="menuUL">
              <li title="android客户端下载" id="donwnloadMenu1" onclick="clickDownloadTab(1)" class="appDownload_selected"><img src="../../images/icon/icon_android.png"  />Android版</li>
              <li title="iOS客户端下载" id="donwnloadMenu2" onclick="clickDownloadTab(2)"><img src="../../images/icon/icon_iphone.png"  />iPhone版</li>
            </ul>
          </div>
          <div class="appDownload_box">
            <div>
              <div class="app_android" id="androidAppList" >  </div>
            
              <div class="app_android" id="iosAppList" style="display:none;"></div>
            
            </div>
            <div class="hide"></div>
          </div>
        </div>
      </div>
    </div>
    <!--app_download end-->
    
    
    
    <!--index_health_bottom start-->
    

<style>
.tGray_bottom a{text-decoration: none; color: #ffffff;}
</style>


    <!--index_health_bottom start-->
    <a name="page_botton_block"></a>
    <div class="index_health_bottom" >
      <div class="bottom_main">
        <div class="bottom_contact">
          <ul>
            <li class="tWhite">
            <span class="tGreen" title="联系我们">Contact us</span>联系我们
            </li>
            <li class="tGray_bottom" title="地址">地址：</li>
            <li class="tGray_bottom" title="客服热线">客服热线：</li>
            <li class="tGray_bottom" title="公司官网">公司官网：</li>
            <li class="tGray_bottom" title="服务邮箱">邮箱：</li>
            <li class="tGray_bottom">
				<a href="http://122.224.75.236/wzba/login.do?method=hdurl&doamin=http://www.995120.cn&id=330108000063652&SHID=1223.0AFF_NAME=com.rouger.
				gs.main.UserInfoAff&AFF_ACTION=qyhzdetail&PAGE_URL=ShowDetail"
				target="_blank"> <img src="http://122.224.75.236/wzba/view/baxx/gh.jpg" border="0"></a>        
            
            </li>
            
            
          </ul>
        </div>
        <div class="bottom_help">
          <ul>
            <li class="tWhite"></li>
            <li class="taqueation_left"></li>
            <li class="taqueation_middle"></li>
            <li class="taqueation_right"></li>
            <li class="taqueation_left"></li>
            <li class="taqueation_middle"></li>
            <li class="taqueation_right"></li>
          </ul>
        </div>
        <div class="bottom_concern">
          <ul>
            <li class="tWhite"><span class="tGreen">Concern us</span>关注我们</li>
            <li class="wechat_code">安卓 APP</li>
            <li class="blog_code">IOS APP</li>
          </ul>
        </div>
        <div class="copyright">
        
        
        Copyright ©
        <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1000351579'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s22.cnzz.com/z_stat.php%3Fid%3D1000351579%26show%3Dpic1' type='text/javascript'%3E%3C/script%3E"));</script>    
 
        
        </div>
      </div>
    </div>
    <!--index_health_bottom start-->
    <!--index_health_bottom start-->
    
    
    
    
  </div>

</body>
 

<div id="divloading">
	<img src="../../../images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>
</html>
