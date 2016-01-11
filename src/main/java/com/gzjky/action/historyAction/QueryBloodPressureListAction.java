package com.gzjky.action.historyAction;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.bean.extend.QueryBloodPressureOutputBean;
import com.gzjky.dao.readdao.BloodPressureHistoryReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONArray;

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
	
	private List<QueryBloodPressureOutputBean> outputBeanList;
	

	@Autowired
	private BloodPressureHistoryReadMapper bloodPressureHistoryReadMapper;
	
	public String getList(){
		
		try {
			
			outputBeanList = bloodPressureHistoryReadMapper.selectBloodPressureByCondition("", "正常");
		
		
			JSONArray jsonArray=JSONArray.fromObject(outputBeanList);//将list 转换为json 数组
//			response.getWriter().print(jsonArray);
//			response.getWriter().flush();
//			response.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		};

		
		return SUCCESS;
	}

	public List<QueryBloodPressureOutputBean> getOutputBeanList() {
		return outputBeanList;
	}

	public void setOutputBeanList(List<QueryBloodPressureOutputBean> outputBeanList) {
		this.outputBeanList = outputBeanList;
	}
	
}
