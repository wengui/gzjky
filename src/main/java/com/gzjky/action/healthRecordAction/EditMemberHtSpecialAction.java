package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

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
import com.gzjky.bean.gen.PatientHighBloodInfo;
import com.gzjky.bean.gen.PatientHighBloodTakingDrugs;
import com.gzjky.dao.constant.MsgConstant;
import com.gzjky.dao.readdao.PatientHighBloodInfoReadMapper;
import com.gzjky.dao.writedao.PatientHighBloodInfoWriteMapper;
import com.gzjky.dao.writedao.PatientHighBloodTakingDrugsWriteMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 高血压专项变更
 * @author yuting
 *
 */
public class EditMemberHtSpecialAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5791346656807611243L;
	
	@Autowired
	private PatientHighBloodInfoReadMapper readMapper;
	@Autowired
	private PatientHighBloodInfoWriteMapper writeMapper;
	@Autowired
	private PatientHighBloodTakingDrugsWriteMapper takingDrugsWriteMapper;
	/**
	 * 基本信息更新
	 * @return
	 */
	public String editRecord(){
		
		try {

			int state = 0;
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			PatientHighBloodInfo record = new PatientHighBloodInfo();
			
			record.setPatientid(patientId);// 患者ID
			DateTime haveHighBloodTime = DateUtil.parseDate(request.getParameter("havaBloodDate"), DateFormatter.SDF_YMD);
			record.setHavehighbloodtime(haveHighBloodTime);
			record.setIsdrug(request.getParameter("isUseMedicine"));
			record.setEfficacy(request.getParameter("effect"));
			record.setHighestsystolicpressure(NumberUtils.toInt(request.getParameter("sbp")));
			record.setHighestdiastolicpressure(NumberUtils.toInt(request.getParameter("dbp")));
			record.setBloodpressurelevel(request.getParameter("BPLevel"));
			record.setRisklevel(request.getParameter("RiskLevel"));

			// 
			int highBloodInfoId = 0;

			// 查是否已经有记录
			PatientHighBloodInfo info = readMapper.selectByPatientid(patientId);
			// 已经有记录的场合
			if(VaildateUtils.isNull(info)){
				// 登录处理
				state = writeMapper.insertSelective(record);
				highBloodInfoId = record.getId();
			}else{
				// 更新处理
				record.setId(info.getId());
				state = writeMapper.updateByPrimaryKeySelective(record);
				highBloodInfoId = info.getId();
			}
			
			List<PatientHighBloodTakingDrugs> takingDrugsList = new ArrayList<PatientHighBloodTakingDrugs>();
			String str = request.getParameter("detail");
			
			String[] medicine = str.split(";,");
			for(String string : medicine){
				if(!VaildateUtils.isNullOrEmpty(string)){
					String[] subMedicine = string.split(",");
					PatientHighBloodTakingDrugs takeDrugs = new PatientHighBloodTakingDrugs();
					takeDrugs.setPatienthighbloodinfoid(highBloodInfoId);
					takeDrugs.setDrugsname(subMedicine[0]);
					takeDrugs.setDose(subMedicine[1]);
					takeDrugs.setDuration(subMedicine[2].replace(";", ""));
					takingDrugsList.add(takeDrugs);
					}
			}
			
			// 当前服用药物数据删除
			takingDrugsWriteMapper.deleteByPatientHighBloodInfoId(highBloodInfoId);
			// 当前服用药物数据插入
			for(PatientHighBloodTakingDrugs takingDrugs : takingDrugsList){
				takingDrugsWriteMapper.insertSelective(takingDrugs);
			}
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(state);
			if(state == 0){
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
