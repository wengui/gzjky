package com.gzjky.action.login;

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
	
	/*
	 * 用户登录系统
	 */
	public String login() throws Exception{
		
		UserInfo userInfo = userInfoReadMapper.selectByUserName(loginId, loginId, passwd);
		
		//调用业务逻辑组件的valid方法来
		//验证用户输入的用户名和密码是否正确
		if (userInfo!=null)
		{
			//session中设置userInfoBean
			ActionContext.getContext().getSession().put("user",userInfo);
		}else
		{
			return INPUT;
		}
		
		System.out.println(loginId);
		System.out.println(passwd);
		return SUCCESS;
		
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

}
