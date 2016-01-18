package com.gzjky.action.password;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.mail.mailControl;
import com.gzjky.base.util.password.PwdUtil;
import com.gzjky.bean.gen.UserInfo;
import com.gzjky.bean.gen.UserPasswordFind;
import com.gzjky.dao.readdao.UserInfoReadMapper;
import com.gzjky.dao.readdao.UserPasswordFindReadMapper;
import com.gzjky.dao.writedao.PatientInfoWriteMapper;
import com.gzjky.dao.writedao.UserAndPatientWriteMapper;
import com.gzjky.dao.writedao.UserInfoWriteMapper;
import com.gzjky.dao.writedao.UserPasswordFindWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import java.util.Calendar;
import java.util.Date;
import java.util.Random;
import java.util.UUID;

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
	@Autowired
	UserPasswordFindWriteMapper userPasswordFindWriteMapper;
	@Autowired
	UserPasswordFindReadMapper userPasswordFindReadMapper;
	//用户名
	private String loginId;
	//密码
	private String passwd;
	//手机
	private String phone;
	//email
	private String email;
	//短信验证码
	private String phoneCheckcode;
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
	
		//userPasswordFind表信息处理
		UUID uuid = UUID.randomUUID();
		UserPasswordFind userPasswordFind = new UserPasswordFind();
		userPasswordFind.setUid(uuid.toString());
		userPasswordFind.setUserid(userInfoReadMapper.selectUserByUserName(loginId).getId());
		Date now = new Date();
		userPasswordFind.setBegintime(now);
		Calendar rightNow = Calendar.getInstance();
		rightNow.setTime(now);
		//日期加1天
		rightNow.add(Calendar.DAY_OF_YEAR,1);
		userPasswordFind.setEndtime(rightNow.getTime());
		Random r=new Random();
		String newPassword = String.valueOf(r.nextInt(9))
				+String.valueOf(r.nextInt(9))
				+String.valueOf(r.nextInt(9))
				+String.valueOf(r.nextInt(9))
				+String.valueOf(r.nextInt(9))
				+String.valueOf(r.nextInt(9));
		userPasswordFind.setNewpassword(newPassword);
		userPasswordFindWriteMapper.insert(userPasswordFind);
		
		mailControl mail = new mailControl(); 
		mail.setTo("87547931@qq.com");
		mail.setFrom("13761370411@163.com");// 你的邮箱
		mail.setHost("smtp.163.com");
		mail.setUsername("13761370411@163.com");// 用户
		mail.setPassword("jhizhrxvbmmvvinn");// 密码
		mail.setSubject("我忘记密码了！");
		mail.setContent("尊敬的用户： "
        		+ loginId+"，通过您提交的忘记密码申请，新密码已被系统随机设置为："
				+ newPassword
				+ "，点此链接马上激活新密码:"
				+ "http://localhost:8080/gzjky/jsp/password/active_new_pwd.jsp?sign="
				+ uuid.toString()
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
	 * 邮箱取回密码激活
	 */
	public String activePwd() {
		
		String result = "";
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 用户名
		String uid = request.getParameter("sign");
		
		UserPasswordFind userPasswordFind = new UserPasswordFind();
		userPasswordFind = userPasswordFindReadMapper.selectByPrimaryKey(uid);
		result = String.valueOf(userInfoWriteMapper.updatePasswordById(userPasswordFind.getUserid(), PwdUtil.CreateDbPassword(userPasswordFind.getNewpassword()))) ;
				
		if(result.equals("1")){
			return "success";
		}
		else{
			//设置 error内容
	    	errorMessage= "用户名或密码错误!";
	        return "error";
		}
	
	}
	
	/*
	 * 短信炎症
	 */
	public String checkCode() {
		
		String result = "";
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 用户名
		loginId = request.getParameter("login_id");
		// 手机
		phone = request.getParameter("cell_phone");
		// 短信验证码
		phoneCheckcode = request.getParameter("memo");
		
		//短信验证
		//TODO		
		result = "1";
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
	 * 密码修改
	 */
	public String changePasswd() {
		
		String result = "";
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 用户名
		loginId = request.getParameter("login_id");
		// 用户名
		passwd = request.getParameter("passwd");
			
		result = String.valueOf(userInfoWriteMapper.updatePasswordByName(loginId, PwdUtil.CreateDbPassword(passwd)));

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
	
	public String getPhoneCheckcode() {
		return phoneCheckcode;
	}

	public void setPhoneCheckcode(String phoneCheckcode) {
		this.phoneCheckcode = phoneCheckcode;
	}

}
