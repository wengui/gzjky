package com.gzjky.action.doctorReportAction;

import java.io.PrintWriter;
import java.util.ArrayList;
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
import com.gzjky.bean.extend.QueryBloodPressureInputBean;
import com.gzjky.bean.extend.QueryBloodPressureOutputBean;
import com.gzjky.bean.extend.QueryDoctorReportInputBean;
import com.gzjky.bean.extend.QueryDoctorReportOutputBean;
import com.gzjky.bean.extend.QueryMemberHtSpecialOutputBean;
import com.gzjky.bean.extend.TakeDrugsBean;
import com.gzjky.dao.constant.CodeConstant;
import com.gzjky.dao.readdao.BloodPressureHistoryReadMapper;
import com.gzjky.dao.readdao.DoctorsReportReadMapper;
import com.gzjky.dao.readdao.ElectrocardioHistoryReadMapper;
import com.gzjky.dao.readdao.PatientHighBloodInfoReadMapper;
import com.gzjky.dao.readdao.PatientHighBloodTakingDrugsReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 血压查询Action
 * @author yuting
 *
 */
public class QueryDoctorReportDetailAction extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5540564677635944167L;
	
	@Autowired
	private BloodPressureHistoryReadMapper bloodPressureHistoryReadMapper;
	@Autowired
	private ElectrocardioHistoryReadMapper electrocardioHistoryReadMapper;
	@Autowired
	private PatientHighBloodInfoReadMapper highBloodInfoReadMapper;
	@Autowired
	private PatientHighBloodTakingDrugsReadMapper takingDrugsReadMapper;
	
	public String getDoctorReportDetail(){
		
		
		try {
			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 血压查询参数设定
			String reportType = request.getParameter("reportType");
			QueryBloodPressureInputBean queryBloodPressureInputBean = new QueryBloodPressureInputBean();
			queryBloodPressureInputBean.setStartDate(request.getParameter("startDate")); // 开始时间
			queryBloodPressureInputBean.setEndDate(request.getParameter("endDate"));// 结束时间
			queryBloodPressureInputBean.setBloodType(CodeConstant.HISTORY_TYPE_STATUS);
			queryBloodPressureInputBean.setPatientId(ActionContext.getContext().getSession().get("PatientID").toString());
			
	        // 血压历史
			List<QueryBloodPressureOutputBean>  bloodPressureNormalList = bloodPressureHistoryReadMapper.selectBloodPressureByCondition(queryBloodPressureInputBean);
			
	        // 血压报警
			queryBloodPressureInputBean.setBloodType(CodeConstant.WARN_TYPE_STATUS);
			List<QueryBloodPressureOutputBean>  bloodPressureDangerList = bloodPressureHistoryReadMapper.selectBloodPressureByCondition(queryBloodPressureInputBean);
			
			// 心电查询查询参数设定
			ElectrocardioInputBean input = new ElectrocardioInputBean();
			input.setStartDate(request.getParameter("startDate")); // 开始时间
			input.setEndDate(request.getParameter("endDate"));// 结束时间
			input.setHeartType(CodeConstant.HISTORY_TYPE_STATUS);
			input.setPatientId(ActionContext.getContext().getSession().get("PatientID").toString());
			
	        // 心电历史
			List<ElectrocardioOutputBean> electrocardioList = null;
			if(reportType.equals(CodeConstant.MONTH_REPORT)){
				electrocardioList = electrocardioHistoryReadMapper.selectElectrocardioByCondition(input);
			}
			// 用药查询参数设定
			List<TakeDrugsBean> takeDrugsBeanList = null;
			// 用药查询
			QueryMemberHtSpecialOutputBean result = highBloodInfoReadMapper.selectRecordByPatientid(Integer.parseInt(ActionContext.getContext().getSession().get("PatientID").toString()));
			if(!VaildateUtils.isNull(result)){
				takeDrugsBeanList = takingDrugsReadMapper.selectByHighbloodinfoId(NumberUtils.toInt(result.getId()));
			}
			
			List<List<?>> outbeanList = new ArrayList<List<?>>();
			outbeanList.add(bloodPressureNormalList);
			outbeanList.add(bloodPressureDangerList);
			outbeanList.add(electrocardioList);
			outbeanList.add(takeDrugsBeanList);
			
	        ModelMap modelMap = new ModelMap();

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();
			modelMap.setOutBeanList(outbeanList);
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
