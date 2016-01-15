package com.gzjky.action.password;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.mail.mailControl;
import com.gzjky.bean.gen.UserInfo;
import com.gzjky.dao.readdao.UserInfoReadMapper;
import com.gzjky.dao.writedao.PatientInfoWriteMapper;
import com.gzjky.dao.writedao.UserAndPatientWriteMapper;
import com.gzjky.dao.writedao.UserInfoWriteMapper;
import com.opensymphony.xwork2.ActionSupport;
import java.util.Properties;

import javax.mail.AuthenticationFailedException;
import javax.mail.Authenticator;
import javax.mail.Message.RecipientType;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import net.sf.json.JSONObject;

/**
 * 用户登录
 * @author Zhu
 *
 */
public class passwordAction extends ActionSupport {


	private static final long serialVersionUID = 730960376980017822L;
	@Autowired
	private UserInfoWriteMapper userInfoWriteMapper;
	@Autowired
	private UserInfoReadMapper userInfoReadMapper;
	@Autowired
	PatientInfoWriteMapper patientInfoWriteMapper;
	@Autowired
	UserAndPatientWriteMapper userAndPatientWriteMapper;
	
	//用户名
	private String loginId;
	//密码
	private String passwd;
	//手机
	private String phone;
	//email
	private String email;
	//错误信息
	private String errorMessage;
	
	/*
	 * 用户登录系统
	 */
	public String sendPwd() {
		
		String result = "1";
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();		
		// 用户名
		loginId = request.getParameter("login_id");
		// 邮箱
		email = request.getParameter("email");
	
		mailControl mail = new mailControl(); 
		mail.setTo("87547931@qq.com");
		mail.setFrom("13761370411@163.com");// 你的邮箱
		mail.setHost("smtp.163.com");
		mail.setUsername("13761370411@163.com");// 用户
		mail.setPassword("jhizhrxvbmmvvinn");// 密码
		mail.setSubject("我忘记密码了！");
		mail.setContent("尊敬的用户： "
        		+ loginId+"，通过您提交的忘记密码申请，新密码已被系统随机设置为："
				+ "814293"
				+ "，点此链接马上激活新密码:"
				+ "http://v3.995120.cn/jsp/password/active_new_pwd.jsp?sign=92E8469CE62C3A93FA8E0D430EAA3937"
				+ "，请在一个小时内处理此业务，超过时间上次申请将无效！");
		
		if (!mail.sendMail()) {
			//连接邮件服务失败
        	result= "-1";
		}
		try {			
			ModelMap modelMap = new ModelMap();
			modelMap.setResult(result);

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out = null;
			out = response.getWriter();
			// 将java对象转成json对象
			JSONObject jsonObject = JSONObject.fromObject(modelMap);// 将list转换为json数组
			out.print(jsonObject);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
	}

	
	/*
	 * 用户信息取得
	 */
	public String activePwd() {
		
		String result = "";
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 用户名
		loginId = request.getParameter("login_id");
		
		UserInfo userInfo = new UserInfo();
		userInfo = userInfoReadMapper.selectUserByUserName(loginId);
		
		try {			
			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out = null;
			out = response.getWriter();
			// 将java对象转成json对象
			JSONObject jsonObject = JSONObject.fromObject(userInfo);// 将list转换为json数组
			out.print(jsonObject);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		return "success";
		
	}
	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
