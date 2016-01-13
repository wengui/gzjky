<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>995120健康服务中心</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/account.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.4.4.min.js'/>"></script>
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
<body id="body_content">
  <div class="account">
    <div class="account_title">
      <ul>
        <li class="account_titleGreen">账户/充值</li>
        <li class="account_titleGray">当前位置：<a href="/jsp/health/account/account.jsp" target="mainFrame">账户/套餐</a>>账户充值</li>
      </ul>
    </div>
    <div class="recharge">
    
    
      
      
      <form action="/recharge/generateOrder.helowin" id="addform" name="addform" method="post" autocomplete="off">
      <!--account_security start-->
      <div class="recharge_main">
        <ul>
          <li class="tgrey_recharge">充值账号：</li>
          <li class="tblack_recharge">test1</li>
          <li class="tgrey_recharge">充值金额：</li>
          <li class="Input_recharge"><input type="text" id="bill" name="bill" class="inputMin_informationModify" value="" validate="required:true,money:true,min:0.01,max:1000" value=""/></li>
          <li class="tgrey_recharge">验&nbsp;证&nbsp;码：</li>
          <li class="Input_recharge">
                
                <input type="text" name="verifyCode" id="verifyCode" class="inputMin_informationModify"  autocomplete="off"  maxlength="5" validate="required:true" />
          
          </li>
          <li class="tgrey_recharge"></li>
          <li class="Input_recharge">
               <table>
                  <tr>
                     <td><img id="imageCode" name="imageCode" onclick="changeVeriyCode()" src="/VerifyCode" border="0" title="点击换一张" width="85" height="22" /></td>
                     <td>&nbsp;&nbsp;<a style="text-decoration: none; color: #0ca7a1;" href="javascript:void(0)" onclick="changeVeriyCode()" title="点击换一张">换一张</a></td>
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
          <li class="btn_recharge"><a href="javascript:void(0)" onclick="pay();">下一步</a></li>
        </ul>
      </div>
      <!--account_security end-->
      </form>
      
      
      
      
    </div>
  </div>
</body>




<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div>

</html>
