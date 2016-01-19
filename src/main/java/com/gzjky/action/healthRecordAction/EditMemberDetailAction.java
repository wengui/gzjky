package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.PatientInfo;
import com.gzjky.dao.constant.MsgConstant;
import com.gzjky.dao.writedao.PatientInfoWriteMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 患者基本信息-详细更新
 * @author yuting
 *
 */
public class EditMemberDetailAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3637117680176818315L;
	
	@Autowired
	private PatientInfoWriteMapper patientInfoWriteMapper;
	
	/**
	 * 基本信息 - 详细更新
	 * @return
	 */
	public String editDetailInfo(){
		
		try {

			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			PatientInfo record = new PatientInfo();
			
			record.setId(patientId);// 患者ID
			record.setCardtype(request.getParameter("certiType"));// 证件类型
			record.setCardnum(request.getParameter("cardnum")); // 证件号
			if("1".equals(request.getParameter("issoldier"))){
				record.setIssoldier(true);// 是军人
			}else{
				record.setIssoldier(false);// 不是军人
			}
			
			if("1".equals(request.getParameter("isdisability"))){
				record.setIsdisability(true);// 是残疾
			}else{
				record.setIsdisability(false);// 不是残疾
			}
			record.setHeight(NumberUtils.toDouble(request.getParameter("height")));// 身高
			record.setWeight(NumberUtils.toDouble(request.getParameter("weight")));// 体重
			record.setPatientnational(request.getParameter("nationalityCodeDict"));// 民族
			record.setNativeplace(request.getParameter("nativeplace"));// 籍贯
			record.setMarriagestatus(request.getParameter("maritalStatusDict"));// 婚姻情况
			record.setHouseholdtype(request.getParameter("censusRegDict"));// 户籍类型
			record.setEducation(request.getParameter("userAcademic"));// 学历
			record.setPolitical(request.getParameter("politicalAffiliatio"));// 政治面貌
			record.setTelephone(request.getParameter("telephone"));// 固话
			record.setHomeaddress(request.getParameter("homeaddress"));// 家庭住址

			// 更新处理
			int updattCount = patientInfoWriteMapper.updateByPrimaryKeySelective(record);
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(updattCount);
			if(updattCount == 0){
				// 更新失败
				modelMap.setMessage(MsgConstant.UPDATEINFO002);
			}else{
				// 更新成功
				modelMap.setMessage(MsgConstant.UPDATEINFO001);
			}
			
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
