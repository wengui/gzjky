package com.gzjky.action.login;

import java.net.InetAddress;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts2.ServletActionContext;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.base.util.date.DateUtil;
import com.gzjky.base.util.password.PwdUtil;
import com.gzjky.bean.extend.UserinfoAndPatientinfoBean;
import com.gzjky.bean.gen.Onlines;
import com.gzjky.bean.gen.UserInfo;
import com.gzjky.dao.readdao.OnlinesReadMapper;
import com.gzjky.dao.readdao.UserAndPatientReadMapper;
import com.gzjky.dao.readdao.UserInfoReadMapper;
import com.gzjky.dao.writedao.OnlinesWriteMapper;
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
	@Autowired
	private UserAndPatientReadMapper userAndPatientReadMapper;
	@Autowired
	private OnlinesWriteMapper onlinesWriteMapper;
	
	@Autowired
	private OnlinesReadMapper onlinesReadMapper;
	
	private String loginId;
	
	private String passwd;
	
	private String errorMessage;
	
	private String online;
	
	/*
	 * 用户登录系统
	 */
	public String login() throws Exception{
		

        //通过用户名，手机，邮箱查找用户信息
		UserInfo userInfo = userInfoReadMapper.selectBy(loginId, loginId, loginId);		
		//调用业务逻辑组件的valid方法进行check
        //用户名check

		//验证用户输入的用户名和密码是否正确
		if (userInfo!= null)
		{
            if(PwdUtil.ComparePasswords(userInfo.getPassword(), passwd)){
            	
            	//Online表数据插入
            	Onlines record = new Onlines();
            	Date now = new Date();
            	InetAddress addr=null;  
            	String ip="";  
            	addr=InetAddress.getLocalHost();  
                ip=addr.getHostAddress().toString();//获得本机IP　
                //IP地址
            	record.setIpadddress(ip);
            	//登录时间
            	record.setLogintime(new DateTime(now));
            	//更新时间
            	record.setUpdatetime(new DateTime(now));
            	//UserID
            	record.setUserid(userInfo.getId());
            	
            	Onlines historyOnline = new Onlines();
            	historyOnline=onlinesReadMapper.selectByUserID(userInfo.getId());
            	if(historyOnline==null){
            		onlinesWriteMapper.insertSelective(record);
            	}
            	else{
            		onlinesWriteMapper.updateByByUserId(record,userInfo.getId());
            	}
            	
            	
                //session中设置userInfoBean
                ActionContext.getContext().getSession().put("user",userInfo);
                List<UserinfoAndPatientinfoBean> userinfoAndPatientinfoList = null ;
                userinfoAndPatientinfoList = userAndPatientReadMapper.selectUserAndPatientinfoByUserId(userInfo.getId());
                //session中添加PatientList信息
                ActionContext.getContext().getSession().put("PatientList",userinfoAndPatientinfoList);
                //session中添加默认Patient信息 
                if(userinfoAndPatientinfoList.size()!=0){
                	ActionContext.getContext().getSession().put("Patient",userinfoAndPatientinfoList.get(0));
                	ActionContext.getContext().getSession().put("PatientID",userinfoAndPatientinfoList.get(0).getPid());
                }
                
               
                online=DateUtil.formatYMDHMS(historyOnline.getLogintime().toDate());
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

	public String getOnline() {
		return online;
	}

	public void setOnline(String online) {
		this.online = online;
	}

}
