package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.PatientNowComplicationsChecked;
import com.gzjky.dao.readdao.PatientNowComplicationsCheckedReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

public class QueryMemberHtComplicationAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7789743745373998517L;
	
	@Autowired
	private PatientNowComplicationsCheckedReadMapper readMapper;
	
	public String getHtComplication(){
		

		try {
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 患者ID要从session里取得			
			List<PatientNowComplicationsChecked> result = readMapper.selectByPatientId(patientId);
			
			HashMap<String,String> codemap =  new HashMap<String,String>();
			
			// 疾病勾选
			for(PatientNowComplicationsChecked record : result){
				codemap.put(record.getDiseaseidvalue(), record.getDiseaseidvalue());
			}
			
			ModelMap modelMap = new ModelMap();
			modelMap.setResult(codemap);
			
			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();
			modelMap.setResult(codemap);
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
