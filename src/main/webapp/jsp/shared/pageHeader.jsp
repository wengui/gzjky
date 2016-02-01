<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript">
	//Patient切换 
	function patientChange(obj) {
		var family=obj.id;
		var para="family="+family;
		if(family!=="${sessionScope.Patient.pid}"){
			$.ajax({
				url:"/gzjky/home/patientChange.do",
				async:true,
				data:para,
				dataType:"json",
				type:"POST",
				error:function(){
					$.alert("发生异常","请注意");
				},
				success:function(response) {

					if(response.result=="1"){	
						window.location.href="/gzjky/jsp/home.jsp";
					}
					else{
						$.alert("发生异常","请注意");
					}
				}
			});
		}
		
	}

</script>
<header class="header">
    <a href="index.html" class="logo">
        <!-- Add the class icon to your logo image or logo icon to add the margining -->
		贵州健康云服务中心
       </a>
       <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top" role="navigation">
        <!-- Sidebar toggle button-->
        <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </a>
        <div class="navbar-right">
            <ul class="nav navbar-nav">
                  <li class="dropdown messages-menu">
                    <a href="#" class="dropdown-toggle"
					data-toggle="dropdown"> <i class="fa fa-users"></i> <c:set
							var="len" value="0" /> <c:forEach
							items="${sessionScope.PatientList}">
							<c:set var="len" value="${len+1}" />
						</c:forEach> <span class="label label-success">${len}</span>
				</a>
					<ul class="dropdown-menu">
						<li class="header">家庭成员切换</li>
						<li>
							<!-- inner menu: contains the actual data -->
							<ul class="menu">

								<c:forEach items="${sessionScope.PatientList}" var="pa">

									<li>
										<!-- start message --> <c:choose>
											<c:when test="${sessionScope.PatientID == pa.pid}">

												<a href="javascript:void(0)" 
													id="${pa.pid}" style="line-height: 10px">
													<div class="pull-left">
														<img src="<c:url value='/imageUploadAction/showHeadImage.do'/>" class="img-circle" alt="User Image" />
													</div>
													<h4 style="color:#ccc">
														<c:out value="${pa.pname}" />(当前账户)
													</h4>

													</a>
											</c:when>
											<c:otherwise>

												<a href="javascript:void(0)" onclick="patientChange(this)"
													id="${pa.pid}" style="line-height: 10px">
													<div class="pull-left">
														<img src="<c:url value='/imageUploadAction/showHeadImage.do'/>" class="img-circle" alt="User Image" />
													</div>

													<h4>
														<c:out value="${pa.pname}" />
													</h4>

												</a>
											</c:otherwise>
										</c:choose>

									</li>
									<!-- end message -->

								</c:forEach>

							</ul>
						</li>
 						<li class="footer"><a href="#">添加家庭成员</a></li>
					</ul>
				</li>
                <!-- Messages: style can be found in dropdown.less-->               
                <li class="dropdown messages-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-envelope"></i>
                        <span class="label label-success">4</span>
                    </a>
                    <ul class="dropdown-menu">
                        <li class="header">You have 4 messages</li>
                        <li>
                            <!-- inner menu: contains the actual data -->
                            <ul class="menu">
                                <li><!-- start message -->
                                    <a href="#">
                                        <div class="pull-left">
                                            <img src="<c:url value='/img/avatar3.png'/>" class="img-circle" alt="User Image"/>
                                        </div>
                                        <h4>
                                            Support Team
                                            <small><i class="fa fa-clock-o"></i> 5 mins</small>
                                        </h4>
                                        <p>Why not buy a new awesome theme?</p>
                                    </a>
                                </li><!-- end message -->
                                <li>
                                    <a href="#">
                                        <div class="pull-left">
                                            <img src="<c:url value='/img/avatar2.png'/>" class="img-circle" alt="user image"/>
                                        </div>
                                        <h4>
                                            AdminLTE Design Team
                                            <small><i class="fa fa-clock-o"></i> 2 hours</small>
                                        </h4>
                                        <p>Why not buy a new awesome theme?</p>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <div class="pull-left">
                                            <img src="<c:url value='/img/avatar.png'/>" class="img-circle" alt="user image"/>
                                        </div>
                                        <h4>
                                            Developers
                                            <small><i class="fa fa-clock-o"></i> Today</small>
                                        </h4>
                                        <p>Why not buy a new awesome theme?</p>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <div class="pull-left">
                                            <img src="<c:url value='/img/avatar2.png'/>" class="img-circle" alt="user image"/>
                                        </div>
                                        <h4>
                                            Sales Department
                                            <small><i class="fa fa-clock-o"></i> Yesterday</small>
                                        </h4>
                                        <p>Why not buy a new awesome theme?</p>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <div class="pull-left">
                                            <img src="<c:url value='/img/avatar.png'/>" class="img-circle" alt="user image"/>
                                        </div>
                                        <h4>
                                            Reviewers
                                            <small><i class="fa fa-clock-o"></i> 2 days</small>
                                        </h4>
                                        <p>Why not buy a new awesome theme?</p>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li class="footer"><a href="#">See All Messages</a></li>
                    </ul>
                </li>
                <!-- User Account: style can be found in dropdown.less -->
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="glyphicon glyphicon-user"></i>
                        <span>${sessionScope.Patient.uname} <i class="caret"></i></span>
                    </a>
                    <ul class="dropdown-menu" style="width:160px">
                        <!-- User image -->
                        <li class="user-header bg-light-blue" style="height:110px">
                            <img src="<c:url value='/images/health/default_head.gif'/>" class="img-circle" alt="User Image" />
                        </li>
                        <!-- Menu Footer-->
                        <li class="user-footer">         
                            <div class="pull-center">
                                <a href="/gzjky/login/layout.do" class="btn btn-default">注销</a>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>
<!-- END HEADER -->