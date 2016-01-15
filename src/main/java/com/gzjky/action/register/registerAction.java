package com.gzjky.action.register;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.action.login.PwdUtil;
import com.gzjky.bean.gen.PatientInfo;
import com.gzjky.bean.gen.UserAndPatient;
import com.gzjky.bean.gen.UserInfo;
import com.gzjky.dao.readdao.UserInfoReadMapper;
import com.gzjky.dao.writedao.PatientInfoWriteMapper;
import com.gzjky.dao.writedao.UserAndPatientWriteMapper;
import com.gzjky.dao.writedao.UserInfoWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 用户登录
 * @author Zhu
 *
 */
public class registerAction extends ActionSupport {

	private static final long serialVersionUID = -2493138373604361743L;
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
	public String register() {
		
		String result = "";
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 用户名
		loginId = request.getParameter("login_id");
		// 密码
		passwd = request.getParameter("passwd");
		// 手机
		phone = request.getParameter("cell_phone");
		// 邮箱
		email = request.getParameter("email");
		

		//是否存在相关用户名
		Integer check =0;
		check = userInfoReadMapper.selectByUserName(loginId);
		// 判断用户是否存在
		if (check== 1) {			
			//该用户已存在
			result="-3";
		}
		else
		{
			check = userInfoReadMapper.selectByCellPhone(phone);
			if (check== 1) {			
				//该手机已存在
				result="-4";
			}
			else{
				check = userInfoReadMapper.selectByEmail(email);
				if (check== 1) {			
					//该邮箱已存在
					result="-5";
				}
				else{
					//PatientInfo表录入
					PatientInfo patientInfo = new PatientInfo();
					patientInfo.setRegdatetime(new Date());
					//patientid获取
					result =  String.valueOf(patientInfoWriteMapper.insertSelective(patientInfo));
					if (result.equals("1")) {
						//插入User数据
						UserInfo userInfo = new UserInfo();
						userInfo.setName(loginId);
						userInfo.setPassword(PwdUtil.CreateDbPassword(passwd));
						userInfo.setCellphone(phone);
						userInfo.setEmail(email);
						userInfo.setEnabled(true);
						result = String.valueOf(userInfoWriteMapper.insertSelective(userInfo)) ;
						if (result.equals("1")) {
							UserAndPatient userAndPatient = new UserAndPatient();
							userAndPatient.setPatientid(patientInfo.getId());
							userAndPatient.setUserid(userInfo.getId());
							result = String.valueOf(userAndPatientWriteMapper.insertSelective(userAndPatient));
						}

					}

				}
			}
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
	public String queryMemberBaseInfoByLoginId() {
		
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
