package com.gzjky.action.login;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;

import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.bean.gen.UserInfo;
import com.gzjky.dao.readdao.UserInfoReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 用户登录
 * @author yuting
 *
 */
public class LoginAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6889342988521215331L;
	
	@Autowired
	private UserInfoReadMapper userInfoReadMapper;
	
	private String loginId;
	
	private String passwd;
	
	private String errorMessage;
	
	/*
	 * 用户登录系统
	 */
	public String login() throws Exception{
		
		//页面参数取得
        HttpServletRequest request = ServletActionContext.getRequest();
        
        loginId = request.getParameter("loginId");
        passwd = request.getParameter("passwd");

        //通过用户名，手机，邮箱查找用户信息
		UserInfo userInfo = userInfoReadMapper.selectBy(loginId, loginId, loginId);		
		//调用业务逻辑组件的valid方法进行check
        //用户名check

		//验证用户输入的用户名和密码是否正确
		if (userInfo!= null)
		{
            if(PwdUtil.ComparePasswords(userInfo.getPassword(), passwd)){
                //session中设置userInfoBean
                ActionContext.getContext().getSession().put("user",userInfo);
                return "success";
            }
            else{
            	//设置 error内容
            	errorMessage= "用户名或密码错误!";
                return "error";
            }
		}else
		{			
			//设置 error内容
        	errorMessage= "该用户不存在!";
            return "error";
		}		
	}
	
	/*
	 * 用户退出系统
	 */
	public String layout(){
		
		//清除session
		ActionContext.getContext().getSession().clear();
		
		//返回到登录页面
		return "layout";
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

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
