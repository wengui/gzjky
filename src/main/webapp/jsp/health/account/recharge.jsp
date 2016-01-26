<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>账户充值</title>
<%@ include file="../../shared/importCss.jsp"%>
<%@ include file="../../shared/importJs.jsp"%>
<script src="<c:url value='/js/jquery/jquery-migrate1.3.0.js'/>" type="text/javascript"></script>
<link href="<c:url value='/css/account.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<c:url value='/js/base.js'/>"></script>
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/js/page/screen.css'/>" />
<!-- 验证框架 -->
<script src="<c:url value='/js/page/jquery.validate.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/hwin-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.metadata.js'/>" type="text/javascript"></script>

<script type="text/javascript">
	$.metadata.setType("attr", "validate");
	var validator;
	$(function(){
	    $("#errMessageArea").empty();
		validator = $("#addform").validate({
			messages:{
				'bill': {
					required:"充值金额是必填项.",
					min:"充值金额不能少于0.01元"
        		},'verifyCode':{
        			required:"验证码是必填项."
        		}
       		}
		});
	});
	
	
	function changeVeriyCode(){
		document.getElementById("imageCode").src="/VerifyCode?randomCode="+Math.random();
	}
	
	function pay() {
        
		if($("#addform").valid()) {
		   showLoading();
	       showScreenProtectDiv(2);
	       document.addform.submit();
	       lock = true;
	       return true;
		}
		return false;
		
   }
	
   var lock = false;
   document.onkeydown=function() {  
	   if (window.event.keyCode==13) {
	       if(!lock) pay();
	   }
   }  
	
</script>	
</head>
<body id="body_content" class="skin-blue">
	<%@ include file="../../shared/pageHeader.jsp"%>
	<div class="wrapper row-offcanvas row-offcanvas-left">
	         <!-- Left side column. contains the logo and sidebar -->
	<%@ include file="../../shared/sidebarMenu.jsp"%>
	<aside class="right-side">
           <section class="content-header">
              <h1>账户充值
              	 <small id="today"></small>
              	 <small id="weather"></small>
              </h1>
              <ol class="breadcrumb">
                  <li><a href="#"><i class="fa fa-home"></i> 首页</a></li>
                  <li >账户套餐</li>
                  <li class="active">账户充值</li>
              </ol>
          </section>
		  <div class="box box-success bp_accouint">
              <div class="box-header">
                  <h3 class="box-title">充值</h3>
              </div>		
              <div class="box-body">
				<div class="row">
				  <div class="account">
				    <div class="recharge">
				      <form action="/recharge/generateOrder.helowin" id="addform" name="addform" method="post" autocomplete="off">
				      <!--account_security start-->
				      <div class="recharge_main">
				        <ul>
				          <li class="tgrey_recharge">充值账号：</li>
				          <li class="tblack_recharge">test1</li>
				          <li class="tgrey_recharge">充值金额：</li>
				          <li class="Input_recharge"><input type="text" class="form-control" id="bill" name="bill" style="width:200px" value="" validate="required:true,money:true,min:0.01,max:1000" value=""/></li>
				          <li class="tgrey_recharge">验&nbsp;证&nbsp;码：</li>
				          <li class="Input_recharge">
				                <input type="text" name="verifyCode" class="form-control" id="verifyCode" style="width:200px" autocomplete="off"  maxlength="5" validate="required:true" />
				          </li>
				          <li class="tgrey_recharge"></li>
				          <li class="Input_recharge">
				               <table>
				                  <tr>
				                     <td><img id="imageCode" name="imageCode" onclick="changeVeriyCode()" src="../../../images/VerifyCode.jpg" border="0" title="点击换一张" width="85" height="22" /></td>
				                     <td>&nbsp;&nbsp;<a class="btn btn-success" href="javascript:void(0)" onclick="changeVeriyCode()" title="点击换一张">换一张</a></td>
				                  </tr>
				               </table>
				          </li>
				          <li class="tgrey_recharge"></li>
				          <li class="Input_recharge" id="errMessageArea" style="color:red;"></li>
				          
				          <li class="thirdParty_payment" style="display:none;">
				            <ul>
				              <li class="tgrey_thirdParty">第三方支付：</li>
				              <li class="radio_thirdParty"><input name="pay_type" type="radio" value="alipay" checked/><img src="/images/bank/zfb.png" class="img_bank"  /></li>
				            </ul>
				          </li>
				          <li class="thirdParty_payment" style="display:none;">
				            <ul>
				              <li class="tgrey_thirdParty">储蓄卡支付：</li>
				              <li class="savings_card">
				              <input name="pay_type" type="radio" value="ABC" /><img src="/images/bank/abc.png" class="img_bank" />
				              <input name="pay_type" type="radio" value="ICBCB2C" /><img src="/images/bank/icbc.png" class="img_bank" />
				              <input name="pay_type" type="radio" value="CCB" /><img src="/images/bank/ccb.png" class="img_bank" /><br/>
				              <input name="pay_type" type="radio" value="PSBC-DEBIT" /><img src="/images/bank/post.png" class="img_bank" />
				              <input name="pay_type" type="radio" value="CMB" /><img src="/images/bank/cmb.png" class="img_bank" />
				              <input name="pay_type" type="radio" value="CEBBANK" /><img src="/images/bank/ceb.png" class="img_bank" /><br/>
				              <input name="pay_type" type="radio" value="BJBANK" /><img src="/images/bank/bob.png" class="img_bank" />
				              <input name="pay_type" type="radio" value="BOCB2C" /><img src="/images/bank/boc.png" class="img_bank" />
				              <input name="pay_type" type="radio" value="CMBC" /><img src="/images/bank/cmbc.png" class="img_bank" /><br/>
				              <input name="pay_type" type="radio" value="GDB" /><img src="/images/bank/gdb.png" class="img_bank" />
				              <input name="pay_type" type="radio" value="SPABANK" /><img src="/images/bank/pab.png" class="img_bank" />
				              </li>
				            </ul>
				          </li>
				          <li class="btn_recharge"><a href="javascript:void(0)" class="btn btn-success" style="width:200px" onclick="pay();">下一步</a></li>
				        </ul>
				      </div>
				      <!--account_security end-->
				      </form>
 				</div>
 				</div>
 				</div>
		</div>
		</div>
     </aside><!-- /.right-side -->
</div><!-- ./wrapper --> 
</body>

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>

</html>
