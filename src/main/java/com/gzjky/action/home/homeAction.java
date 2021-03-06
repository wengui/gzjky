package com.gzjky.action.home;
import java.io.IOException;
import java.io.PrintWriter;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.PatientAndDoctorHospitalBean;
import com.gzjky.bean.extend.PatientAndEquipmentBean;
import com.gzjky.bean.extend.UserinfoAndPatientinfoBean;

import com.gzjky.dao.readdao.EquipmentAndPatientReadMapper;
import com.gzjky.dao.readdao.PatientAndHospitalDoctorReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

/**
 * 主页面相关action
 * @author Zhu
 *
 */
public class homeAction extends ActionSupport {

	private static final long serialVersionUID = -2493138373604361743L;
	@Autowired
	private EquipmentAndPatientReadMapper equipmentAndPatientReadMapper;
	@Autowired
	private PatientAndHospitalDoctorReadMapper patientAndHospitalDoctorReadMapper;
	
	//用户名
	private String patientId;
	//家庭用户
	private String family;
	
	public String getFamily() {
		return family;
	}


	public void setFamily(String family) {
		this.family = family;
	}


	public String getPatientId() {
		return patientId;
	}


	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}


	/*
	 * 用户设备信息取得
	 */
	public String getEquipment() {
		
		// 用户名
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean)ActionContext.getContext().getSession().get("Patient");
		//用户设备信息取得
		List<PatientAndEquipmentBean> equipmentList=null;
		equipmentList = equipmentAndPatientReadMapper.selectByPatientId(Integer.parseInt(userinfoAndPatientinfo.getPid()));
		
		try {			

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out = null;
			out = response.getWriter();
			// 将java对象转成json对象
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

			JSONArray json = JSONArray.fromObject(equipmentList, jsonConfig);

			out.print(json.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
	}

	
	/*
	 * 用户医院医生信息取得
	 */
	public String getHospitalAndDoctor() {
		// 用户名
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean)ActionContext.getContext().getSession().get("Patient");
		//用户设备信息取得
		List<PatientAndDoctorHospitalBean> patientAndDoctorHospitalList=null;
		patientAndDoctorHospitalList = patientAndHospitalDoctorReadMapper.selectByPatientId(Integer.parseInt(userinfoAndPatientinfo.getPid()));
		
		try {			

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out = null;
			out = response.getWriter();
			// 将java对象转成json对象
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

			JSONArray json = JSONArray.fromObject(patientAndDoctorHospitalList, jsonConfig);

			out.print(json.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
	}

	/*
	 * 用户医院医生信息取得
	 */
	public String patientChange() {
		// 用户名
		//页面参数取得
        HttpServletRequest request = ServletActionContext.getRequest();
        String result="0";
        family = request.getParameter("family");
        
        
        List<UserinfoAndPatientinfoBean> userinfoAndPatientinfoList = null ;
        userinfoAndPatientinfoList=(List<UserinfoAndPatientinfoBean>)ActionContext.getContext().getSession().get("PatientList");
        for(int i = 0; i < userinfoAndPatientinfoList.size(); i++)  
        {  
        	if(userinfoAndPatientinfoList.get(i).getPid().equals(family)){
        		ActionContext.getContext().getSession().put("Patient",userinfoAndPatientinfoList.get(i));
             	ActionContext.getContext().getSession().put("PatientID",userinfoAndPatientinfoList.get(i).getPid());
             	result="1";
            	break;
        	}    	
        }  
        
   
        try {			
			ModelMap modelMap = new ModelMap();
			modelMap.setResult(result);

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out = null;
			out = response.getWriter();
			// 将java对象转成json对象
			JSONObject jsonObject = JSONObject.fromObject(modelMap);// 将list转换为json数组
			out.print(jsonObject);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return "success";
	}

}
