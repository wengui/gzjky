<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- BEGIN SIDEBAR -->
 <aside class="left-side sidebar-offcanvas">
     <!-- sidebar: style can be found in sidebar.less -->
     <section class="sidebar">
         <!-- Sidebar user panel -->
         <div class="user-panel">
             <div class="pull-left image">
                 <img src="<c:url value='/imageUploadAction/showHeadImage.do'/>" class="img-circle" alt="User Image" />
             </div>
             <div class="pull-left info">
                 <p>您好, ${sessionScope.Patient.pname}</p>
                 <a href="#"><i class="fa fa-circle text-success"></i> 在线</a>
             </div>
         </div>
         <!-- sidebar menu: : style can be found in sidebar.less -->
         <ul class="sidebar-menu">
             <li id="home">
                 <a href="<c:url value='/jsp/home.jsp'/>">
                     <i class="fa fa-home"></i> <span>首页</span>
                 </a>
             </li>
             <li id="notice">
                 <a href="<c:url value='/jsp/health/welcome.jsp'/>">
                     <i class="fa fa-dashboard"></i> <span>健康通告</span>
                 </a>
             </li>
             <li class="treeview" id="analyse">
                 <a href="#">
                     <i class="fa fa-bar-chart-o" ></i>
                     <span>健康分析</span>
                     <i class="fa fa-angle-left pull-right"></i>
                 </a>
                 <ul class="treeview-menu">
                     <li id="bp"><a  href="<c:url value='/jsp/health/analyse/bp.jsp'/>"><i class="fa fa-angle-double-right"></i>血压历史</a></li>
                     <li id="ecg"><a href="<c:url value='/jsp/health/analyse/ecg.jsp'/>"><i class="fa fa-angle-double-right"></i>心电历史</a></li>
                 </ul>
             </li>
             <li class="treeview">
                 <a href="#">
                     <i class="fa fa-laptop"></i>
                     <span>终端定位</span>
                     <i class="fa fa-angle-left pull-right"></i>
                 </a>
                 <ul class="treeview-menu">
                     <li id="electronic" ><a href="<c:url value='/jsp/health/lbs/electronic_fence.jsp'/>"><i class="fa fa-angle-double-right"></i> 电子围栏</a></li>
                     <li id="sos" ><a href="<c:url value='/jsp/health/lbs/sos_alert.jsp'/>"><i class="fa fa-angle-double-right"></i> SOS报警</a></li>
                 </ul>
             </li>
             <li class="treeview">
                 <a href="#">
                     <i class="fa fa-edit"></i> <span>健康档案</span>
                     <i class="fa fa-angle-left pull-right"></i>
                 </a>
                 <ul class="treeview-menu">
                     <li id="baseinfo"><a href="<c:url value='/jsp/health/healthrecord/memberbaseinfo.jsp'/>"><i class="fa fa-angle-double-right"></i> 基本信息</a></li>
                     <li id="records"><a href="<c:url value='/jsp/health/healthrecord/disease_history.jsp'/>"><i class="fa fa-angle-double-right"></i> 健康病例</a></li>
                     <li id="phone"><a href="<c:url value='/jsp/health/healthrecord/family_phone.jsp'/>"><i class="fa fa-angle-double-right"></i> 亲情号码</a></li>
                     <li id="pwd"><a href="<c:url value='/jsp/health/healthrecord/modify_password.jsp'/>"><i class="fa fa-angle-double-right"></i> 密码修改</a></li>
                 </ul>
             </li>
             <li class="treeview">
                 <a href="#">
                     <i class="fa fa-table"></i> <span>健康设备</span>
                     <i class="fa fa-angle-left pull-right"></i>
                 </a>
                 <ul class="treeview-menu">
                     <li id="equipment"><a href="<c:url value='/jsp/health/equipment/equipment.jsp'/>"><i class="fa fa-angle-double-right"></i> 我的设备</a></li>
                     <li id="equipmentBind"><a href="<c:url value='/jsp/health/equipment/member_bind_device.jsp'/>"><i class="fa fa-angle-double-right"></i> 设备绑定</a></li>
                 </ul>
             </li>
             <li class="treeview">
                 <a href="#">
                     <i class="fa fa-credit-card"></i> <span>账户套餐</span>
                     <i class="fa fa-angle-left pull-right"></i>
                 </a>
                 <ul class="treeview-menu">
                     <li id="account"><a href="<c:url value='/jsp/health/account/account.jsp'/>"><i class="fa fa-angle-double-right"></i> 账户套餐</a></li>
                     <li id="recharge"><a href="<c:url value='/jsp/health/account/recharge_history.jsp'/>"><i class="fa fa-angle-double-right"></i> 充值记录</a></li>
                     <li id="consume"><a href="<c:url value='/jsp/health/account/consume_record.jsp'/>"><i class="fa fa-angle-double-right"></i> 消费记录</a></li>
                 </ul>
             </li>
             <li class="treeview">
                 <a href="#">
                     <i class="fa fa-folder-o"></i> <span>医生报告</span>
                     <i class="fa fa-angle-left pull-right"></i>
                 </a>
                 <ul class="treeview-menu">
                     <li id="report"><a href="<c:url value='/jsp/health/doctor_report/reportlist.jsp'/>"><i class="fa fa-angle-double-right"></i> 医生报告</a></li>
                 </ul>
             </li>
         </ul>
     </section>
     <!-- /.sidebar -->
 </aside>
 <script type="text/javascript">
var menuId;
if(menuId !=null && menuId != ""){
	$(menuId).addClass("active");
	$(menuId).parent().attr("style","display:block").parents("li").addClass("active");
}
</script>
<!-- END SIDEBAR -->