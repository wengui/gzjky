package com.gzjky.action.memberConsultAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.MemberConsultationInputBean;
import com.gzjky.bean.extend.MemberConsultationOutputBean;
import com.gzjky.dao.readdao.MemberConsultationReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

public class QueryMemberConsultListAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1195114109560347610L;
	
	@Autowired
	private MemberConsultationReadMapper readMapper;
	
	public String getList(){

		
		
		try {
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 查询参数设定
			MemberConsultationInputBean record = new MemberConsultationInputBean();

			int pointerStart = NumberUtils.toInt(request.getParameter("pointerStart"));
			int pageSize = NumberUtils.toInt(request.getParameter("pageSize"));
			
			record.setPageMax((pointerStart + pageSize));
			record.setPageMin(pointerStart);
			record.setPatientId(patientId);
			
	        // 从数据库中取得需要的对象
			List<MemberConsultationOutputBean> result = readMapper.selectByPatientId(record);
	        
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
			JSONObject jsonObject = JSONObject.fromObject(modelMap);// 转换为json
			out.print(jsonObject);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			return null;
		}
		
		return SUCCESS;
	
	}

}
