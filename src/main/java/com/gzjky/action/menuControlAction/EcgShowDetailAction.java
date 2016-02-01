package com.gzjky.action.menuControlAction;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

/**
 * 心电图详细信息跳转表示
 * @author yuting
 *
 */
public class EcgShowDetailAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5657568458168520993L;
	
	/**
	 * 心电图详细信息跳转
	 * @return
	 */
	public String getEcgDetail(){
		
		HttpServletRequest request = ServletActionContext.getRequest();
		// 将心电图ID传到jsp页面
		request.setAttribute("id", request.getParameter("id"));
		
		return SUCCESS;
	}

}
