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
import com.gzjky.bean.extend.QueryBloodPressureInputBean;
import com.gzjky.bean.extend.QueryBloodPressureOutputBean;
import com.gzjky.dao.constant.CodeConstant;
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

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 查询参数设定
			QueryBloodPressureInputBean queryBloodPressureInputBean = new QueryBloodPressureInputBean();
			queryBloodPressureInputBean.setStartDate(request.getParameter("startDate")); // 开始时间
			queryBloodPressureInputBean.setEndDate(request.getParameter("endDate"));// 结束时间
			String bloodType = request.getParameter("bloodType");
			if(CodeConstant.WARN_TYPE.equals(bloodType)){
				// 告警的场合
				queryBloodPressureInputBean.setBloodType(CodeConstant.WARN_TYPE_STATUS);
			}
			int pointerStart = NumberUtils.toInt(request.getParameter("pointerStart"));
			int pageSize = NumberUtils.toInt(request.getParameter("pageSize"));
			
			queryBloodPressureInputBean.setPageMax((pointerStart + pageSize));
			queryBloodPressureInputBean.setPageMin(pointerStart);
			
			//TODO 患者id取得，最终是要从session里面取得一个可变的值
			queryBloodPressureInputBean.setPatientId("1");
			
	        // 从数据库中取得需要的对象
	        bloodPressureList = bloodPressureHistoryReadMapper.selectBloodPressureByCondition(queryBloodPressureInputBean);
	        
	        ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合
			if (!VaildateUtils.isEmptyList(bloodPressureList)) {

				modelMap.setOutBeanList(bloodPressureList);

				modelMap.setRecordTotal(bloodPressureList.get(0).getTotal());
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
