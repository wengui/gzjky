package com.gzjky.action.menuControlAction;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

/**
 * 我的设备修改配置
 * @author yuting
 *
 */
public class EquipmentSetAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6800771420581807456L;
	
	/**
	 * 我的设备修改配置
	 * @return
	 */
	public String getequipment(){
		
		HttpServletRequest request = ServletActionContext.getRequest();
		// 将设备ID传到jsp页面
		request.setAttribute("device_id", request.getParameter("device_id"));
		
		return SUCCESS;
	}

}
