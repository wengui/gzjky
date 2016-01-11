package com.gzjky.action.historyAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.QueryBloodPressureOutputBean;
import com.gzjky.dao.readdao.BloodPressureHistoryReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 血压查询Action
 * @author yuting
 *
 */
public class QueryBloodPressureListAction extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5540564677635944167L;
	
	private List<QueryBloodPressureOutputBean> bloodPressureList;
	

	@Autowired
	private BloodPressureHistoryReadMapper bloodPressureHistoryReadMapper;
	
	public String getList(){
		
		
		try {
			HttpServletResponse response=ServletActionContext.getResponse();  
	        //以下代码从JSON.java中拷过来的  
	        response.setContentType("text/html");  
	        PrintWriter out;  
	        out = response.getWriter();  
			
	        bloodPressureList = bloodPressureHistoryReadMapper.selectBloodPressureByCondition("", "正常");
	        
	        ModelMap modelMap = new ModelMap();
	        
	        modelMap.setOutBeanList(bloodPressureList);
	        
	        modelMap.setRecordTotal(bloodPressureList.size());
		
	        JSONObject jsonObject=JSONObject.fromObject(modelMap);//将list 转换为json 数组
			out.print(jsonObject);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		};

		
		return SUCCESS;
	}

	public List<QueryBloodPressureOutputBean> getBloodPressureList() {
		return bloodPressureList;
	}

	public void setBloodPressureList(List<QueryBloodPressureOutputBean> bloodPressureList) {
		this.bloodPressureList = bloodPressureList;
	}

}
