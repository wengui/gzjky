package com.gzjky.action.device;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.PatientDeviceInfoBean;
import com.gzjky.bean.extend.UserinfoAndPatientinfoBean;
import com.gzjky.bean.gen.Equipment;
import com.gzjky.bean.gen.EquipmentAndPatient;
import com.gzjky.bean.gen.PJcXybjSet;
import com.gzjky.bean.gen.PatientInfo;
import com.gzjky.bean.gen.UserInfo;
import com.gzjky.dao.readdao.EquipmentAndPatientReadMapper;
import com.gzjky.dao.readdao.EquipmentReadMapper;
import com.gzjky.dao.writedao.EquipmentAndPatientWriteMapper;
import com.gzjky.dao.writedao.PJcXybjSetWriteMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import org.joda.time.DateTime;

/**
 * 用户登录
 * @author Zhu
 *
 */
public class deviceAction extends ActionSupport {

	private static final long serialVersionUID = -2493138373604361743L;
	
	@Autowired
	EquipmentReadMapper equipmentReadMapper;
	@Autowired
	EquipmentAndPatientReadMapper equipmentAndPatientReadMapper;
	@Autowired
	EquipmentAndPatientWriteMapper equipmentAndPatientWriteMapper;
	@Autowired
	PJcXybjSetWriteMapper pJcXybjSetWriteMapper;
	
	//用户名
	private String loginId;
	//密码
	private String passwd;
	//手机
	private String phone;
	//email
	private String email;
	//错误信息
	private String errorMessage;
	//错误信息
	private String deviceSid;
		
	/*
	 * 用户登录系统
	 */
	public String deviceBind() {
		
		String message = "";
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 设备序列号
		deviceSid = request.getParameter("device_sid");
		
		//设备已绑定用户数
		String count = request.getParameter("count");
		//设备id
		String eId = request.getParameter("device_id");
		String device_ver= request.getParameter("device_ver");
		
		// 获取当前Patient信息
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean) ActionContext.getContext()
				.getSession().get("Patient");
		// 获取当前登录用户信息
		UserInfo userInfo = (UserInfo) ActionContext.getContext().getSession().get("user");

		EquipmentAndPatient quipmentAndPatient = new EquipmentAndPatient();
		// 是否删除flag
		quipmentAndPatient.setIsdelete(false);
		// patientID
		quipmentAndPatient.setPatientid(Integer.parseInt(userinfoAndPatientinfo.getPid()));
		// 设备ID
		quipmentAndPatient.setEquipmentid(Integer.parseInt(eId));
		// 创建者
		quipmentAndPatient.setCreator(String.valueOf(userInfo.getId()));
		// 创建时间
		DateTime now = new DateTime(new Date());
		quipmentAndPatient.setCreatedon(now);
		//Patienttype
		if(device_ver.equals("108")){
			if(count.equals("1")){
				quipmentAndPatient.setPatienttype(2);
			}
			else
			{
				quipmentAndPatient.setPatienttype(1);
			}
		}
		else{
			quipmentAndPatient.setPatienttype(1);
		}
		

		if ((equipmentAndPatientWriteMapper.insert(quipmentAndPatient)) == 1) {
			message = "绑定成功！";
		} else {
			message = "绑定失败";
		}
		
		try {			
			ModelMap modelMap = new ModelMap();
			modelMap.setMessage(message);

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

	
	/*
	 * 设备信息取得
	 */
	public String queryDeviceBySid() {
		
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 设备序列号
		deviceSid = request.getParameter("device_sid");
		
		
		Equipment equ= equipmentReadMapper.selectByPrimaryNum(deviceSid);
		List<PatientInfo> patientInfoList=null;
		//设备关联patient信息取得
		patientInfoList= equipmentAndPatientReadMapper.selectByEquipNum(deviceSid);
		
		
		try {			
			ModelMap modelMap = new ModelMap();
			modelMap.setResult(equ);
			modelMap.setOutBeanList(patientInfoList);
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
	/*
	 * 绑定设备信息取得
	 */
	public String queryMemberBindDevice() {
		
		
		// 获取当前Patient信息
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean) ActionContext.getContext()
				.getSession().get("Patient");
		List<PatientDeviceInfoBean> patientDeviceInfoList=null;
		
		patientDeviceInfoList= equipmentAndPatientReadMapper.queryMemberBindDevice(Integer.parseInt(userinfoAndPatientinfo.getPid()));

		try {			

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out = null;
			out = response.getWriter();
			// 将java对象转成json对象
			// 将java对象转成json对象
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
			JSONArray json = JSONArray.fromObject(patientDeviceInfoList, jsonConfig);
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
	 * 绑定设备信息取得
	 */
	public String deleteMemberDeviceBind() {
		
		
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 设备用户关系信息
		String epId = request.getParameter("epId");
		
		int result=equipmentAndPatientWriteMapper.updateDeleteFlagByPrimaryKey(Integer.parseInt(epId));

		try {			

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out = null;
			out = response.getWriter();
			// 将java对象转成json对象
			JSONObject jsonObject = JSONObject.fromObject(result);// 将list转换为json数组
			out.print(jsonObject);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
		

	}
	

	/*
	 * 阈值信息录入
	 */
	public String insertMemberBloodPressureThreshold() {
		
		int result;
		
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 设备用户关系信息
		String fid = request.getParameter("f_id");
		String eid = request.getParameter("device_id");
		String ssymax=request.getParameter("shrink_threshold_top");
		String ssymin=request.getParameter("shrink_threshold_bottom");
		String szymax=request.getParameter("diastole_threshold_top");
		String szymin=request.getParameter("diastole_threshold_bottom");
		
		PJcXybjSet pj= new PJcXybjSet();
		//收缩压
		pj.setSsymax(Integer.parseInt(ssymax));
		pj.setSsymin(Integer.parseInt(ssymin));
		//舒张压
		pj.setSzymax(Integer.parseInt(szymax));
		pj.setSzymin(Integer.parseInt(szymin));
		if(fid==null||fid.equals("")){
			// 获取当前Patient信息
			UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean) ActionContext.getContext()
					.getSession().get("Patient");
			//insert操作			
			pj.setIsdelete(false);
			pj.setEid(Integer.parseInt(eid));
			pj.setUid(userinfoAndPatientinfo.getPid());
			
			result=pJcXybjSetWriteMapper.insertSelective(pj);		
		}
		else{
			pj.setId(Integer.parseInt(fid));
			result=pJcXybjSetWriteMapper.updateByPrimaryKeySelective(pj);		
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
	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
