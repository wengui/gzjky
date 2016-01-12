package com.gzjky.action.historyAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.BloodPressureHistory;
import com.gzjky.dao.writedao.BloodPressureHistoryWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 血压历史备注追加
 * @author yuting
 *
 */
public class AddBloodPressureFeedback extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2907174309612204893L;
	
	@Autowired
	private BloodPressureHistoryWriteMapper bloodPressureHistoryWriteMapper;

	public String addFeedBack(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			BloodPressureHistory record = new BloodPressureHistory();
			record.setId(NumberUtils.toInt(request.getParameter("id")));
			record.setRemark(request.getParameter("feedback"));

			// 更新处理
			int updattCount = bloodPressureHistoryWriteMapper.updateByPrimaryKeySelective(record);
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(updattCount);
			
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
