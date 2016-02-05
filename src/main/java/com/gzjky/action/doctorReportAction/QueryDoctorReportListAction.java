package com.gzjky.action.doctorReportAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.QueryDoctorReportInputBean;
import com.gzjky.bean.extend.QueryDoctorReportOutputBean;
import com.gzjky.dao.readdao.DoctorsReportReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 血压查询Action
 * @author yuting
 *
 */
public class QueryDoctorReportListAction extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5540564677635944167L;
	
	private List<QueryDoctorReportOutputBean> doctorReportList;
	

	@Autowired
	private DoctorsReportReadMapper doctorsReportReadMapper;
	
	public String getList(){
		
		
		try {
			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 查询参数设定
			QueryDoctorReportInputBean queryDoctorReportInputBean = new QueryDoctorReportInputBean();
			queryDoctorReportInputBean.setStartDate(request.getParameter("startDate")); // 开始时间
			queryDoctorReportInputBean.setEndDate(request.getParameter("endDate"));// 结束时间
			int pointerStart = NumberUtils.toInt(request.getParameter("pointerStart"));
			int pageSize = NumberUtils.toInt(request.getParameter("pageSize"));
			
			queryDoctorReportInputBean.setPageMax((pointerStart + pageSize));
			queryDoctorReportInputBean.setPageMin(pointerStart);
			
			// 患者id取得，最终是要从session里面取得一个可变的值
			queryDoctorReportInputBean.setPatientId(ActionContext.getContext().getSession().get("PatientID").toString());
			
	        // 从数据库中取得需要的对象
			doctorReportList = doctorsReportReadMapper.selectReportDetailByPatientId(queryDoctorReportInputBean);
	        
	        ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合
			if (!VaildateUtils.isEmptyList(doctorReportList)) {

				modelMap.setOutBeanList(doctorReportList);

				modelMap.setRecordTotal(doctorReportList.get(0).getTotal());
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
