package com.gzjky.action.historyAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.ElectrocardioInputBean;
import com.gzjky.bean.extend.ElectrocardioOutputBean;
import com.gzjky.dao.constant.CodeConstant;
import com.gzjky.dao.readdao.ElectrocardioHistoryReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 血压查询Action
 * @author yuting
 *
 */
public class ElectrocardioHistoryListAction extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5540564677635944167L;
	
	private List<ElectrocardioOutputBean> result;
	

	@Autowired
	private ElectrocardioHistoryReadMapper electrocardioHistoryReadMapper;
	
	public String getList(){
		
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 查询参数设定
			ElectrocardioInputBean input = new ElectrocardioInputBean();
			input.setStartDate(request.getParameter("startDate")); // 开始时间
			input.setEndDate(request.getParameter("endDate"));// 结束时间
			String heartType = request.getParameter("heartType");
			if(CodeConstant.WARN_TYPE.equals(heartType)){
				// 告警的场合
				input.setHeartType(CodeConstant.ELC_WARN_STATUS);
			}
			int pointerStart = NumberUtils.toInt(request.getParameter("pointerStart"));
			int pageSize = NumberUtils.toInt(request.getParameter("pageSize"));
			
			input.setPageMax((pointerStart + pageSize));
			input.setPageMin(pointerStart);
			
			//TODO 患者id取得，最终是要从session里面取得一个可变的值
			//input.setPatientId("5");
			
	        // 从数据库中取得需要的对象
			result = electrocardioHistoryReadMapper.selectElectrocardioByCondition(input);
	        
	        ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合
			if (!VaildateUtils.isEmptyList(result)) {

				modelMap.setOutBeanList(result);

				modelMap.setRecordTotal(result.get(0).getTotal());
			}
			

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();

			// 将java对象转成json对象
			JSONObject jsonObject = JSONObject.fromObject(modelMap);// 将list
																	// 转换为json
																	// 数组
			out.print(jsonObject);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			return null;
		}

		
		return SUCCESS;
	}

}
