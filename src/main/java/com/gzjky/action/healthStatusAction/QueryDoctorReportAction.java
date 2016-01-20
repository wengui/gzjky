package com.gzjky.action.healthStatusAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.DoctorsReport;
import com.gzjky.bean.gen.WeeklyReports;
import com.gzjky.bean.gen.MonthlyReports;
import com.gzjky.dao.readdao.DoctorsReportReadMapper;
import com.gzjky.dao.readdao.WeeklyReportsReadMapper;
import com.gzjky.dao.readdao.MonthlyReportsReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 血压等级分析
 * @author yuting
 *
 */
public class QueryDoctorReportAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2957143535668658323L;
	
	@Autowired
	private DoctorsReportReadMapper doctorsReportReadMapper;
	@Autowired
	private WeeklyReportsReadMapper weeklyReportsReadMapper;
	@Autowired
	private MonthlyReportsReadMapper monthlyReportsReadMapper;	
	
	public String getDoctorReport(){
		

		try {
			
			HttpServletRequest request = ServletActionContext.getRequest();
			String str = ActionContext.getContext().getSession().get("Patient").toString();
			int patientID = Integer.parseInt(ActionContext.getContext().getSession().get("PatientID").toString());
			
			DoctorsReport result = doctorsReportReadMapper.selectByPatientId(patientID);
			WeeklyReports weeklyResutlt = null;
			MonthlyReports monthlyResutlt = null;
			
			ModelMap modelMap = new ModelMap();
			if(result == null){
				modelMap.setResult(result);
			}else{
				if (result.getReporttype().equals("1")){
					weeklyResutlt = weeklyReportsReadMapper.selectByPrimaryKey(result.getRpid());
					modelMap.setResult(weeklyResutlt);
				}else{
					monthlyResutlt = monthlyReportsReadMapper.selectByPrimaryKey(result.getRpid());
					modelMap.setResult(monthlyResutlt);
				}
			}
			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();
			
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