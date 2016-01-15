package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.PatientLivingHabitsInfo;
import com.gzjky.dao.constant.MsgConstant;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 当前并发症更新
 * @author yuting
 *
 */
public class EditMemberHtComplicationAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3786376143842917884L;
	
	/**
	 * 患者生活习惯更新
	 * @return
	 */
	public String editComplicationInfo(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			PatientLivingHabitsInfo record = new PatientLivingHabitsInfo();
			//TODO 患者ID要从共通拿出来
			String id = "1";
			
			
			// 更新处理
			//int updattCount = patientLivingHabitsInfoWriteMapper.updateByPatientIdSelective(record);
			int updattCount = 0;
			
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
