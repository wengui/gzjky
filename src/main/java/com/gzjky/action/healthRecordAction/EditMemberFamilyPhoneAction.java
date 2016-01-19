package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.FamilyPhone;
import com.gzjky.dao.writedao.FamilyPhoneWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 更新亲情号
 * 
 * @author yuting
 *
 */
public class EditMemberFamilyPhoneAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4724431980187962370L;

	@Autowired
	private FamilyPhoneWriteMapper writeMapper;

	/**
	 * 更新亲情号
	 * @return
	 */
	public String editRecord(){
		
		try {
			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			    
			// 更新参数设定
			FamilyPhone record = new FamilyPhone();
			//TODO 患者ID要从共通拿出来
			String id = "1";

			record.setPatientid(NumberUtils.toInt(id));// 患者ID
			record.setId(NumberUtils.toInt(request.getParameter("id")));
			record.setName(request.getParameter("name"));
			record.setTelephone(request.getParameter("phone"));
			record.setCellphone(request.getParameter("cellphone"));
			record.setCompany(request.getParameter("company"));
			record.setEmail(request.getParameter("email"));
			record.setAddress(request.getParameter("homeAddress"));
			record.setReport(request.getParameter("report"));
			record.setFamilyship(request.getParameter("relationship"));
						
			int state = writeMapper.updateByPrimaryKeySelective(record);
			
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(state);
			
	        // 将java对象转成json对象
			HttpServletResponse response=ServletActionContext.getResponse();  
	        //以下代码从JSON.java中拷过来的  
	        response.setContentType("text/html");  
	        PrintWriter out;  
	        out = response.getWriter();  
	        
	        // 将java对象转成json对象
	        JSONObject jsonObject=JSONObject.fromObject(modelMap);//将list 转换为json 数组
			out.print(jsonObject);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			return null;
		}
		
		return SUCCESS;
	}
}
