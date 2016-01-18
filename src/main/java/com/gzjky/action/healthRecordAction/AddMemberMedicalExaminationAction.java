package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.PatientHealthCheck;
import com.gzjky.dao.writedao.PatientHealthCheckWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 添加健康检查记录
 * @author yuting
 *
 */
public class AddMemberMedicalExaminationAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1715446616472652449L;
	
	@Autowired
	private PatientHealthCheckWriteMapper writeMapper;
	
	/**
	 * 追加疾病历史
	 * @return
	 */
	public String addRecord(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			PatientHealthCheck record = new PatientHealthCheck();
			
			// 患者ID要从session中取得
			record.setPatientid(1);// 患者ID
			record.setPostprandialbloodglucose(NumberUtils.toDouble(request.getParameter("chxt")));// 餐后血糖
			record.setFastingplasmaglucose(NumberUtils.toDouble(request.getParameter("kfqxxt")));// 空腹血糖
			record.setTotalcholesterol(NumberUtils.toDouble(request.getParameter("zdgc")));// 总胆固醇
			record.setHighdensitycholesterol(NumberUtils.toDouble(request.getParameter("gmdzdbdgc")));// 高密度胆固醇
			record.setLowdensitycholesterol(NumberUtils.toDouble(request.getParameter("dmdzdbdgc")));// 低密度胆固醇	
			record.setSerumcreatinine(NumberUtils.toDouble(request.getParameter("xqjq")));// 清肌酐
			record.setTraceurinaryalbumin(NumberUtils.toDouble(request.getParameter("wlnbdb")));// 微量尿白蛋白

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
