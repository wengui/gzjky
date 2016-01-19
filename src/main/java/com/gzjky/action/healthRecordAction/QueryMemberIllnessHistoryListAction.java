package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.PatientDiseaseHistoryInputBean;
import com.gzjky.bean.extend.PatientDiseaseHistoryOutputBean;
import com.gzjky.dao.readdao.PatientDiseaseHistoryReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 疾病史查询
 * @author yuting
 *
 */
public class QueryMemberIllnessHistoryListAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2151521342792399567L;
	
	private List<PatientDiseaseHistoryOutputBean> diseaseHistoryList;
	
	@Autowired
	private PatientDiseaseHistoryReadMapper patientDiseaseHistoryReadMapper;
	
	public String getList(){
		
		
		try {
			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 查询参数设定
			PatientDiseaseHistoryInputBean record = new PatientDiseaseHistoryInputBean();

			int pointerStart = NumberUtils.toInt(request.getParameter("pointerStart"));
			int pageSize = NumberUtils.toInt(request.getParameter("pageSize"));
			
			record.setPageMax((pointerStart + pageSize));
			record.setPageMin(pointerStart);
			
			// 患者id取得，最终是要从session里面取得一个可变的值
			record.setPatientId(ActionContext.getContext().getSession().get("PatientID").toString());
			
	        // 从数据库中取得需要的对象
			diseaseHistoryList = patientDiseaseHistoryReadMapper.selectByPatientId(record);
	        
	        ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合
			if (!VaildateUtils.isEmptyList(diseaseHistoryList)) {

				modelMap.setOutBeanList(diseaseHistoryList);

				modelMap.setRecordTotal(diseaseHistoryList.get(0).getTotal());
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
