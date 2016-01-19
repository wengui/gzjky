package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.gen.PatientNowComplicationsChecked;
import com.gzjky.dao.writedao.PatientNowComplicationsCheckedWriteMapper;
import com.opensymphony.xwork2.ActionContext;
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
	
	@Autowired
	private PatientNowComplicationsCheckedWriteMapper writeMapper;
	
	/**
	 * 患者生活习惯更新
	 * @return
	 */
	public String editComplicationInfo(){
		
		try {
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
            writeMapper.deleteByPatientId(1);
            
            
            Enumeration<String> en = request.getParameterNames();  
            String parameterName = null;
            int state = 1;
            while (en.hasMoreElements()) {  
                parameterName = (String) en.nextElement();  
                String value = request.getParameter(parameterName);  
                if(!VaildateUtils.isNullOrEmpty(value)){
                	PatientNowComplicationsChecked record = new PatientNowComplicationsChecked();
                	record.setPatientid(patientId);
                	record.setDiseaseidvalue(value);
                	int insertCount = writeMapper.insert(record);
                	
                	// 插入失败的场合
                	if(insertCount == 0){
                		state = 0;
                	}
                }
                
            } 
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(state);
			
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
