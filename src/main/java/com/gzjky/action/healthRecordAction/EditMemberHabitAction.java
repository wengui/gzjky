package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.PatientLivingHabitsOutputBean;
import com.gzjky.bean.gen.PatientLivingHabitsInfo;
import com.gzjky.dao.constant.MsgConstant;
import com.gzjky.dao.readdao.PatientLivingHabitsInfoReadMapper;
import com.gzjky.dao.writedao.PatientLivingHabitsInfoWriteMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 患者生活习惯更新
 * @author yuting
 *
 */
public class EditMemberHabitAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3878534138630690167L;
	@Autowired
	private PatientLivingHabitsInfoReadMapper readMapper;
	@Autowired
	private PatientLivingHabitsInfoWriteMapper patientLivingHabitsInfoWriteMapper;
	
	/**
	 * 患者生活习惯更新
	 * @return
	 */
	public String editHabitInfo(){
		
		try {

			int state = 0;
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			PatientLivingHabitsInfo record = new PatientLivingHabitsInfo();
			
			record.setPatientid(patientId);// 患者ID
			record.setWorktype(request.getParameter("workType"));// 工作类型
			record.setWorkpressure(request.getParameter("workPressure"));// 工作压力
			record.setBloodtype(request.getParameter("aboBloodTypeDict"));// 血型
			record.setWeight(request.getParameter("Weight"));// 体重
			record.setWaistcircumference(request.getParameter("Waistline"));// 腰围
			record.setSmokingyear(request.getParameter("SmokeTime"));// 吸烟年限
			record.setSmokingfrequency(request.getParameter("SmokeNum"));// 吸烟频次
			record.setDrinkfrequency(request.getParameter("drinkFreqCodeDict"));// 饮酒频次
			record.setDrinktype(request.getParameter("alcoholTypeDict"));// 饮酒类型
			record.setMovementfrequency(request.getParameter("SportNum"));// 运动频次
			record.setMovementtime(request.getParameter("SportTime"));// 运动时长
			record.setSleeptime(request.getParameter("SleepTime"));// 睡眠时长
			record.setIsmedication(request.getParameter("Hypotensor"));// 降压药
			
			// check表中是否有记录
			PatientLivingHabitsOutputBean checkRecord =  readMapper.selectByPatientId(patientId); 
			
			// 没有记录的场合，新数据插入
			if(VaildateUtils.isNull(checkRecord)){
				state = patientLivingHabitsInfoWriteMapper.insertSelective(record);
			}else{
				// 有数据 的场合，更新处理
				state = patientLivingHabitsInfoWriteMapper.updateByPatientIdSelective(record);
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
