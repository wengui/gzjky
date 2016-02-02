package com.gzjky.action.device;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.PatientDeviceInfoBean;
import com.gzjky.bean.extend.TerminalInfoBean;
import com.gzjky.bean.extend.UserinfoAndPatientinfoBean;
import com.gzjky.bean.gen.Equipment;
import com.gzjky.bean.gen.EquipmentAndPatient;
import com.gzjky.bean.gen.JcBdhmSet;
import com.gzjky.bean.gen.JcCytxSet;
import com.gzjky.bean.gen.JcDsscSet;
import com.gzjky.bean.gen.JcSetFlag;
import com.gzjky.bean.gen.JcXlbjSet;
import com.gzjky.bean.gen.JcXybjSet;
import com.gzjky.bean.gen.JcYytxSet;
import com.gzjky.bean.gen.PJcXybjSet;
import com.gzjky.bean.gen.PatientInfo;
import com.gzjky.bean.gen.UserInfo;
import com.gzjky.dao.readdao.EquipmentAndPatientReadMapper;
import com.gzjky.dao.readdao.EquipmentReadMapper;
import com.gzjky.dao.readdao.JcBdhmSetReadMapper;
import com.gzjky.dao.readdao.JcCytxSetReadMapper;
import com.gzjky.dao.readdao.JcDsscSetReadMapper;
import com.gzjky.dao.readdao.JcSetFlagReadMapper;
import com.gzjky.dao.readdao.JcXlbjSetReadMapper;
import com.gzjky.dao.readdao.JcXybjSetReadMapper;
import com.gzjky.dao.readdao.JcYytxSetReadMapper;
import com.gzjky.dao.writedao.EquipmentAndPatientWriteMapper;
import com.gzjky.dao.writedao.JcBdhmSetWriteMapper;
import com.gzjky.dao.writedao.JcCytxSetWriteMapper;
import com.gzjky.dao.writedao.JcDsscSetWriteMapper;
import com.gzjky.dao.writedao.JcSetFlagWriteMapper;
import com.gzjky.dao.writedao.JcXlbjSetWriteMapper;
import com.gzjky.dao.writedao.JcXybjSetWriteMapper;
import com.gzjky.dao.writedao.JcYytxSetWriteMapper;
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
	@Autowired
	JcBdhmSetReadMapper jcBdhmSetReadMapper;
	
	@Autowired
	JcBdhmSetWriteMapper jcBdhmSetWriteMapper;
	
	@Autowired
	JcDsscSetReadMapper jcDsscSetReadMapper;
	@Autowired
	JcDsscSetWriteMapper jcDsscSetWriteMapper;
	
	@Autowired
	JcCytxSetReadMapper jcCytxSetReadMapper;

	@Autowired
	JcCytxSetWriteMapper jcCytxSetWriteMapper;
	
	@Autowired
	JcXlbjSetReadMapper jcXlbjSetReadMapper;
	
	@Autowired
	JcXlbjSetWriteMapper jcXlbjSetWriteMapper;
	
	@Autowired
	JcXybjSetReadMapper jcXybjSetReadMapper;
	@Autowired
	JcXybjSetWriteMapper jcXybjSetWriteMapper;
	
	
	
	@Autowired
	JcYytxSetReadMapper jcYytxSetReadMapper;
	@Autowired
	JcYytxSetWriteMapper jcYytxSetWriteMapper;
	
	@Autowired
	JcSetFlagReadMapper jcSetFlagReadMapper;
	@Autowired
	JcSetFlagWriteMapper jcSetFlagWriteMapper;
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
		
		String nickname=request.getParameter("device_nickname");
		
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
		//设备别名设置
		quipmentAndPatient.setNickname(nickname);

		if ((equipmentAndPatientWriteMapper.insertSelective(quipmentAndPatient)) == 1) {
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
	public String UpdateNickname() {
		
		int result;
		
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 设备用户关系信息
		String fid = request.getParameter("epId");
		// 设备别名
		String nickname = request.getParameter("nickname");
		
		
		
		result=equipmentAndPatientWriteMapper.updateNicknameByPrimaryKey(Integer.parseInt(fid),nickname);

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
	
	/*
	 * 阈值信息录入
	 */
	public String updateBloodPressureNotice() {
		
		int result;
		
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		// 设备用户关系信息
		String fid = request.getParameter("f_id");
		String isAdd = request.getParameter("isAdd");
		String eid = request.getParameter("device_id");
		PJcXybjSet pj= new PJcXybjSet();
	
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
			pj.setNoticeflag(Integer.parseInt(isAdd));
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
	/*
	 * 绑定设备信息取得
	 */
	public String queryDeviceSettingCommonInfo() {

		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		//获取设备ID
		String eid = request.getParameter("device_id");
		// 获取当前Patient信息
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean) ActionContext.getContext()
				.getSession().get("Patient");
		//绑定号码设置信息
		JcBdhmSet bdhmSet =  new JcBdhmSet();
		bdhmSet= jcBdhmSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(eid), userinfoAndPatientinfo.getPid());		
		//定时上传信息
		JcDsscSet dsscSet = new JcDsscSet();
		dsscSet= jcDsscSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(eid), userinfoAndPatientinfo.getPid());
		//心率报警设置
		JcXlbjSet xlbjSet=new JcXlbjSet();
		xlbjSet= jcXlbjSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(eid), userinfoAndPatientinfo.getPid());
		//血压报警设置
		JcXybjSet xybjSet = new JcXybjSet();
		xybjSet= jcXybjSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(eid), userinfoAndPatientinfo.getPid());		
		//用药时间提醒设置
		List<JcYytxSet> yytxSetList = null;
		yytxSetList= jcYytxSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(eid), userinfoAndPatientinfo.getPid());
		//测压时间提醒设置
		List<JcCytxSet> cytxSetList = null;
		cytxSetList= jcCytxSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(eid), userinfoAndPatientinfo.getPid());

		//取消设置
		JcSetFlag setFlag=new JcSetFlag();
		setFlag= jcSetFlagReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(eid), userinfoAndPatientinfo.getPid());

		
		TerminalInfoBean terminalinfo = new TerminalInfoBean();
		//绑定号码设置信息
		if(bdhmSet!=null){
			terminalinfo.setSim1(bdhmSet.getSim1());
			terminalinfo.setSim2(bdhmSet.getSim2());
			terminalinfo.setSim3(bdhmSet.getSim3());
		}
		
		//定时上传信息
		if(dsscSet!=null){
			terminalinfo.setSend_data_interval(dsscSet.getSjzq());
		}
		
		//心率报警设置
		if(xlbjSet!=null){
			terminalinfo.setHeartrate_alert_threshold_bottom(String.valueOf(xlbjSet.getXlmin()));
			terminalinfo.setHeartrate_alert_threshold_top(String.valueOf(xlbjSet.getXlmax()));
		}
		
		//血压报警设置
		if(xybjSet!=null){
			terminalinfo.setBlood_pressure_alert_diastole_threshold_bottom(String.valueOf(xybjSet.getSzymin()));
			terminalinfo.setBlood_pressure_alert_diastole_threshold_top(String.valueOf(xybjSet.getSzymax()));
			terminalinfo.setBlood_pressure_alert_shrink_threshold_bottom(String.valueOf(xybjSet.getSsymin()));
			terminalinfo.setBlood_pressure_alert_shrink_threshold_top(String.valueOf(xybjSet.getSsymax()));
		}
		
	/*	//用药时间提醒设置
		if(yytxSet!=null){
			String time[]=yytxSet.getTxtime().split(":");
			if(!(yytxSet.getTxtime()==null)&&!yytxSet.getTxtime().equals("")){
				
			}
			terminalinfo.setHour(time[0].replaceAll("^(0+)", ""));
			terminalinfo.setMinute(time[1].replaceAll("^(0+)", ""));
			terminalinfo.setNotice_interval(yytxSet.getTxzq());
			terminalinfo.setNote(yytxSet.getTxnr());
		}
		
		//测压时间提醒设置
		if(cytxSet!=null){
			terminalinfo.setStart_time(String.valueOf(cytxSet.getTbegin()));
			terminalinfo.setEnd_time(String.valueOf(cytxSet.getTend()));
			terminalinfo.setNotice_intervals(String.valueOf(cytxSet.getTxzq()));		
		}
		*/
		//取消设置
		if(setFlag!=null){
			
			terminalinfo.setSetting_flag_blood_pressure_alert(String.valueOf(setFlag.getSettingFlagBloodPressureAlert()));
			terminalinfo.setSetting_flag_heartrate_alert(String.valueOf(setFlag.getSettingFlagHeartrateAlert()));
			terminalinfo.setSetting_flag_send_data_interval(String.valueOf(setFlag.getSettingFlagSendDataInterval()));
			terminalinfo.setSetting_flag_simcard(String.valueOf(setFlag.getSettingFlagSimcard()));
			terminalinfo.setSetting_flag_take_medicine_notice(String.valueOf(setFlag.getSettingFlagTakeMedicineNotice()));
			terminalinfo.setSetting_flag_test_blood_pressure_notice(String.valueOf(setFlag.getSettingFlagTestBloodPressureNotice()));
		}
		try {			
			ModelMap modelMap = new ModelMap();
			modelMap.setResult(terminalinfo);
			modelMap.setOutBeanList(yytxSetList);
			modelMap.setOutBeanList2(cytxSetList);
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
	 * 用药时间提醒添加
	 */
	public String addTakeMedicineNotice() {
		int result=0;
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		String device_id = request.getParameter("device_id");
		// 获取当前Patient信息
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean) ActionContext.getContext()
				.getSession().get("Patient");
		if(request.getParameter("sms_center")==null){
			
			result=jcYytxSetWriteMapper.updateStateByEidAndPid(1,Integer.parseInt(device_id),userinfoAndPatientinfo.getPid());
		}
		else{
			String para[] = request.getParameter("sms_center").split(",");

			

			HashMap<Integer, JcYytxSet> hs = new HashMap<Integer, JcYytxSet>();		
			List<JcYytxSet> yytxSetList = null;
			
			//数据库里数据取得
			yytxSetList= jcYytxSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(device_id), userinfoAndPatientinfo.getPid());
			
			
				for(int i =0;i<yytxSetList.size();i++){
					//将数据库的数据插入hashmap
					hs.put((yytxSetList.get(i).getId()) ,yytxSetList.get(i));
				}
		
			
			// 用户表数据取得
			for (int i = 0; i < para.length; i++) {
				JcYytxSet jcYytxSet = new JcYytxSet();
				jcYytxSet.setEid(Integer.parseInt(device_id));
				jcYytxSet.setUid(userinfoAndPatientinfo.getPid());
				String info[] = para[i].split(";");
				// str+=","+id+":"+times+":"+notice_interval+":"+note+":"+sta;
				jcYytxSet.setTxnr(info[3]);
				jcYytxSet.setTxtime(info[1]);
				jcYytxSet.setTxzq(info[2]);
				if (info[4].equals("false")) {
					jcYytxSet.setIsdelete(false);
				} else {
					jcYytxSet.setIsdelete(true);
				}
				// id为空的时候
				if (info[0].equals("")) {
					result=jcYytxSetWriteMapper.insertSelective(jcYytxSet);

				} else {
					if (hs.containsKey(Integer.parseInt(info[0]))) {
						jcYytxSet.setId(Integer.parseInt(info[0]));
						result=jcYytxSetWriteMapper.updateByPrimaryKeySelective(jcYytxSet);
						hs.remove(Integer.parseInt(info[0]));
					} else {
						result=jcYytxSetWriteMapper.insertSelective(jcYytxSet);
					}

				}

			}
			for (Integer key : hs.keySet()) {
				result=jcYytxSetWriteMapper.updateStateByPrimaryKey(1,key);
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
	
	/*
	 * 测压提醒添加
	 */
	public String addTestBloodPressureNotice() {
		int result=0;
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		String device_id = request.getParameter("device_id");
		// 获取当前Patient信息
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean) ActionContext.getContext()
				.getSession().get("Patient");		
		
		if(request.getParameter("sms_center")==null){
			
			result=jcCytxSetWriteMapper.updateStateByEidAndPid(1,Integer.parseInt(device_id),userinfoAndPatientinfo.getPid());
		}
		else{
			String para[] = request.getParameter("sms_center").split(",");
			

			HashMap<Integer, JcCytxSet> hs = new HashMap<Integer, JcCytxSet>();		
			List<JcCytxSet> cytxSetList = null;
			
			//数据库里数据取得
			cytxSetList= jcCytxSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(device_id), userinfoAndPatientinfo.getPid());
			
			
				for(int i =0;i<cytxSetList.size();i++){
					//将数据库的数据插入hashmap
					hs.put((cytxSetList.get(i).getId()) ,cytxSetList.get(i));
				}
		
			
			// 用户表数据取得
			for (int i = 0; i < para.length; i++) {
				JcCytxSet jcCytxSet = new JcCytxSet();
				jcCytxSet.setEid(Integer.parseInt(device_id));
				jcCytxSet.setUid(userinfoAndPatientinfo.getPid());
				String info[] = para[i].split(";");
				jcCytxSet.setTbegin(Integer.parseInt(info[1]));
				jcCytxSet.setTend(Integer.parseInt(info[2]));
				jcCytxSet.setTxzq(Integer.parseInt(info[3]));
				
				if (info[4].equals("false")) {
					jcCytxSet.setIsdelete(false);
				} else {
					jcCytxSet.setIsdelete(true);
				}
				// id为空的时候
				if (info[0].equals("")) {
					result=jcCytxSetWriteMapper.insertSelective(jcCytxSet);

				} else {
					if (hs.containsKey(Integer.parseInt(info[0]))) {
						jcCytxSet.setId(Integer.parseInt(info[0]));
						result=jcCytxSetWriteMapper.updateByPrimaryKeySelective(jcCytxSet);
						hs.remove(Integer.parseInt(info[0]));
					} else {
						result=jcCytxSetWriteMapper.insertSelective(jcCytxSet);
					}

				}

			}
			for (Integer key : hs.keySet()) {
				result=jcCytxSetWriteMapper.updateStateByPrimaryKey(1,key);
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
	
	public String updateCommonInfo() {
		int result =0;
		// 页面参数取得
		HttpServletRequest request = ServletActionContext.getRequest();
		String device_id = request.getParameter("device_id");
		//信息类型
		String commontype = request.getParameter("commontype");
		// 获取当前Patient信息
		UserinfoAndPatientinfoBean userinfoAndPatientinfo = (UserinfoAndPatientinfoBean) ActionContext.getContext()
				.getSession().get("Patient");
		
		//绑定号码设置
		if(commontype.equals("1")){
			String sim1 = request.getParameter("simcard_1");
			String sim2 = request.getParameter("simcard_2");
			String sim3 = request.getParameter("simcard_3");
			JcBdhmSet bdhmSet= new JcBdhmSet();
			bdhmSet=jcBdhmSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(device_id), userinfoAndPatientinfo.getPid());
			JcBdhmSet bdhmSetInsert= new JcBdhmSet();
			bdhmSetInsert.setEid(Integer.parseInt(device_id));
			bdhmSetInsert.setSim1(sim1);
			bdhmSetInsert.setSim2(sim2);
			bdhmSetInsert.setSim3(sim3);
			bdhmSetInsert.setUid(userinfoAndPatientinfo.getPid());
			if(bdhmSet==null){
				
				result=jcBdhmSetWriteMapper.insertSelective(bdhmSetInsert);		
			}
			else{
				result=jcBdhmSetWriteMapper.updateByEidAndPid(bdhmSetInsert);
			}
	
		}
		//定时上传设置
		else if (commontype.equals("2")){
			String sjzq = request.getParameter("send_data_interval");

			JcDsscSet jcDsscSet= new JcDsscSet();
			jcDsscSet=jcDsscSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(device_id), userinfoAndPatientinfo.getPid());
			JcDsscSet dsscSetInsert= new JcDsscSet();
			dsscSetInsert.setEid(Integer.parseInt(device_id));
			dsscSetInsert.setSjzq(sjzq);
			dsscSetInsert.setUid(userinfoAndPatientinfo.getPid());
			if(jcDsscSet==null){
				
				result=jcDsscSetWriteMapper.insertSelective(dsscSetInsert);		
			}
			else{
				result=jcDsscSetWriteMapper.updateByEidAndPid(dsscSetInsert);
			}			
		
		}
		//心率报警设置
		else if (commontype.equals("3")){
			String xlmax = request.getParameter("heartrate_alert_threshold_top");
			String xlmin = request.getParameter("heartrate_alert_threshold_bottom");
			JcXlbjSet jcXlbjSet= new JcXlbjSet();
			jcXlbjSet=jcXlbjSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(device_id), userinfoAndPatientinfo.getPid());
			JcXlbjSet xlbjSetInsert= new JcXlbjSet();
			xlbjSetInsert.setEid(Integer.parseInt(device_id));
			xlbjSetInsert.setXlmax(Integer.parseInt(xlmax));
			xlbjSetInsert.setXlmin(Integer.parseInt(xlmin));
			xlbjSetInsert.setUid(userinfoAndPatientinfo.getPid());
			if(jcXlbjSet==null){
				
				result=jcXlbjSetWriteMapper.insertSelective(xlbjSetInsert);		
			}
			else{
				result=jcXlbjSetWriteMapper.updateByEidAndPid(xlbjSetInsert);
			}			
		}
		//血压报警设置
		else if (commontype.equals("4")){
			//收缩压
			String ssymax = request.getParameter("blood_pressure_alert_shrink_threshold_top");
			String ssymin = request.getParameter("blood_pressure_alert_shrink_threshold_bottom");
			//舒张压
			String szymax = request.getParameter("blood_pressure_alert_diastole_threshold_top");
			String szymin = request.getParameter("blood_pressure_alert_diastole_threshold_bottom");
			JcXybjSet jcXybjSet= new JcXybjSet();
			jcXybjSet=jcXybjSetReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(device_id), userinfoAndPatientinfo.getPid());
			JcXybjSet xybjSetInsert= new JcXybjSet();
			xybjSetInsert.setEid(Integer.parseInt(device_id));
			xybjSetInsert.setSsymax(Integer.parseInt(ssymax));
			xybjSetInsert.setSsymin(Integer.parseInt(ssymin));
			xybjSetInsert.setSzymax(Integer.parseInt(szymax));
			xybjSetInsert.setSzymin(Integer.parseInt(szymin));
			xybjSetInsert.setUid(userinfoAndPatientinfo.getPid());
			if(jcXybjSet==null){
				
				result=jcXybjSetWriteMapper.insertSelective(xybjSetInsert);		
			}
			else{
				result=jcXybjSetWriteMapper.updateByEidAndPid(xybjSetInsert);
			}			
		}
		
		//取消指令设置
		else if (commontype.equals("5")){
			//收缩压
			String setting_flag_simcard = request.getParameter("setting_flag_simcard");
			String setting_flag_heartrate_alert = request.getParameter("setting_flag_heartrate_alert");
			//舒张压
			String setting_flag_blood_pressure_alert = request.getParameter("setting_flag_blood_pressure_alert");
			String setting_flag_take_medicine_notice = request.getParameter("setting_flag_take_medicine_notice");
			String setting_flag_test_blood_pressure_notice = request.getParameter("setting_flag_test_blood_pressure_notice");
			String setting_flag_send_data_interval = request.getParameter("setting_flag_send_data_interval");
			JcSetFlag setFlag= new JcSetFlag();
			setFlag=jcSetFlagReadMapper.selectByDeviceIdAndPatientId(Integer.parseInt(device_id), userinfoAndPatientinfo.getPid());
			JcSetFlag setFlagInsert= new JcSetFlag();
			setFlagInsert.setEid(Integer.parseInt(device_id));
			setFlagInsert.setSettingFlagBloodPressureAlert(Integer.parseInt(setting_flag_blood_pressure_alert));
			setFlagInsert.setSettingFlagHeartrateAlert(Integer.parseInt(setting_flag_heartrate_alert));
			setFlagInsert.setSettingFlagSendDataInterval(Integer.parseInt(setting_flag_send_data_interval));
			setFlagInsert.setSettingFlagSimcard(Integer.parseInt(setting_flag_simcard));
			setFlagInsert.setSettingFlagTakeMedicineNotice(Integer.parseInt(setting_flag_take_medicine_notice));
			setFlagInsert.setSettingFlagTestBloodPressureNotice(Integer.parseInt(setting_flag_test_blood_pressure_notice));
			
			
			
			setFlagInsert.setUid(userinfoAndPatientinfo.getPid());
			if(setFlag==null){
				
				result=jcSetFlagWriteMapper.insertSelective(setFlagInsert);		
			}
			else{
				result=jcSetFlagWriteMapper.updateByEidAndPid(setFlagInsert);
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
