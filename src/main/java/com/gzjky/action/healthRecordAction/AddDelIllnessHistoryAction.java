package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.date.DateFormatter;
import com.gzjky.base.util.date.DateUtil;
import com.gzjky.bean.gen.PatientDiseaseHistory;
import com.gzjky.dao.writedao.PatientDiseaseHistoryWriteMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 追加疾病历史
 * @author yuting
 *
 */
public class AddDelIllnessHistoryAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5707722534512973032L;
	
	@Autowired
	private PatientDiseaseHistoryWriteMapper patientDiseaseHistoryWriteMapper;
	
	/**
	 * 追加疾病历史
	 * @return
	 */
	public String addDelIllnessHistory(){
		
		try {

			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			PatientDiseaseHistory record = new PatientDiseaseHistory();
			
			// 患者ID要从session中取得
			record.setPatientid(patientId);// 患者ID
			record.setDiseasename(request.getParameter("diseaseName"));// 疾病名称
			record.setDiseasecode(request.getParameter("diseaseId"));// 疾病code
			DateTime startTime = DateUtil.parseDate(request.getParameter("startTime"), DateFormatter.SDF_YMD);
			DateTime endTime = DateUtil.parseDate(request.getParameter("endTime"), DateFormatter.SDF_YMD);
			record.setStarttime(startTime);// 开始时间
			record.setEndtime(endTime);// 结束时间
			record.setHospitalization(request.getParameter("hospitalRecord"));// 住院情况
			record.setOutcome(request.getParameter("recoverRecord"));// 转归情况
			record.setNote(request.getParameter("comment"));// 备注

			// 更新处理
			int insertCount = patientDiseaseHistoryWriteMapper.insertSelective(record);
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(insertCount);
			
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
