package com.gzjky.action.memberConsultAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.base.util.date.DateFormatter;
import com.gzjky.base.util.date.DateUtil;
import com.gzjky.bean.gen.MemberConsultation;
import com.gzjky.dao.constant.CodeConstant;
import com.gzjky.dao.writedao.MemberConsultationWriteMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 新增会员咨询
 * @author yuting
 *
 */
public class AddMemberConsultAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1802840239616859821L;
	@Autowired
	private MemberConsultationWriteMapper writeMapper;
	
	/**
	 * 新增会员咨询
	 * @return
	 */
	public String addRecord(){
		
		try {

			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			String checkValue = request.getParameter("symptomIds");
			String checkStr = null;
			if(!VaildateUtils.isNullOrEmpty(checkValue)){
				checkStr = checkValue.replace(":", ",");
			}
			
			// 更新参数设定
			MemberConsultation record = new MemberConsultation();
			
			// 患者ID要从session中取得
			record.setPatientid(patientId);// 患者ID
			record.setConsultingcontent(request.getParameter("content"));// 咨询内容
			record.setSymptom(checkStr);// 症状
			record.setSymptomname(request.getParameter("symptomStr"));// 症状名称
			record.setConsultingtime(DateUtil.formatDateTime(DateTime.now(), DateFormatter.SDF_YMDHMS6));;// 咨询时间
			record.setState(CodeConstant.COMMIT_INQUIRY);// 状态
			
			// 更新处理
			int insertCount = writeMapper.insertSelective(record);
			
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
