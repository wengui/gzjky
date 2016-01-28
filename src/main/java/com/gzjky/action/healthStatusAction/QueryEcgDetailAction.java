package com.gzjky.action.healthStatusAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.QueryEcgRecordDetailOutputBean;
import com.gzjky.dao.readdao.ElectrocardioHistoryReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 患者生活习惯
 * @author yuting
 *
 */
public class QueryEcgDetailAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2957143535668658323L;
	
	@Autowired
	private ElectrocardioHistoryReadMapper electrocardioHistoryReadMapper;
	
	
	public String getEcgDetail(){
		

		try {
			
			HttpServletRequest request = ServletActionContext.getRequest();
			String str = ActionContext.getContext().getSession().get("Patient").toString();
			int patientID = Integer.parseInt(ActionContext.getContext().getSession().get("PatientID").toString());
			
			//TODO 患者ID要从session里取得
			QueryEcgRecordDetailOutputBean result = electrocardioHistoryReadMapper.selectRecentElectrocardioDetail(patientID);
			
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
			
		} catch (Exception e) {
			e.printStackTrace();
//			return null;
		}

		return SUCCESS;
	}

}