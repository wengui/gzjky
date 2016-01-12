package com.gzjky.action.healthRecordAction;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.PatientInfoOutputBean;
import com.gzjky.dao.readdao.PatientInfoReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 取得基本信息
 * @author yuting
 *
 */
public class QueryMemberBaseInfoAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1989708698044880671L;

	@Autowired
	private PatientInfoReadMapper patientInfoReadMapper;
	
	public String getBaseInfo(){
		

		try {
			PatientInfoOutputBean result = patientInfoReadMapper.selectByPatientId(1);
			
			ModelMap modelMap = new ModelMap();
			
			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();
			modelMap.setResult(result);
			// 将java对象转成json对象
			JSONObject jsonObject = JSONObject.fromObject(modelMap);// 转换为json

			out.print(jsonObject);
			out.flush();
			out.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return SUCCESS;
	}
}
