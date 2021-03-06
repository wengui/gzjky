package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.dao.writedao.PatientDiseaseHistoryWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 疾病史删除
 * @author yuting
 *
 */
public class DeleteMemberIllnessHistoryAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1077641158826111978L;
	
	@Autowired
	private PatientDiseaseHistoryWriteMapper patientDiseaseHistoryWriteMapper;
	
	public String delIllnessHistory(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新处理
			int deleteCount = patientDiseaseHistoryWriteMapper.deleteByPrimaryKey(NumberUtils.toInt(request.getParameter("id")));
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(deleteCount);
			
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
