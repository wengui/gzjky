package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.gen.PatientFamilyGeneticHistory;
import com.gzjky.bean.gen.PatientFamilyGeneticHistoryDetail;
import com.gzjky.dao.constant.CodeConstant;
import com.gzjky.dao.writedao.PatientFamilyGeneticHistoryDetailWriteMapper;
import com.gzjky.dao.writedao.PatientFamilyGeneticHistoryWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 家族遗传史更新
 * @author yuting
 *
 */
public class EditMemberFamilyDiseaseAction extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = -643585536445238367L;
	
	@Autowired
	private PatientFamilyGeneticHistoryWriteMapper historyWriteMapper;
	@Autowired
	private PatientFamilyGeneticHistoryDetailWriteMapper historyDetailWriteMapper;
	
	
	/**
	 * 家族遗传史更新
	 * @return
	 */
	public String editRecord(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			PatientFamilyGeneticHistory historyRecord = new PatientFamilyGeneticHistory();// 家族史
			List<PatientFamilyGeneticHistoryDetail> recordList = new ArrayList<PatientFamilyGeneticHistoryDetail>();
			
			int patientId = 1;
			
			// 参数设定
			historyRecord.setPatientid(1);
			historyRecord.setIshighbloodpressure(request.getParameter("heighBloodPressure"));// 高血压
			historyRecord.setIshyperlipidemia(request.getParameter("heighBloodFat"));// 高血脂
			historyRecord.setIsdiabetes(request.getParameter("diabetesMellitus"));// 糖尿病
			historyRecord.setIschd(request.getParameter("coronaryDisease"));// 冠心病
			historyRecord.setIscerebrovascularaccident(request.getParameter("cardiovascularAccident"));// 脑血管意外
			
			// 家族有高血压遗传病史的场合
			if(CodeConstant.DATA_HAVING.equals(historyRecord.getIshighbloodpressure())){
				
				setRecord(patientId, request.getParameter("heighBloodPressureRelationName"), request.getParameter("heighBloodPressureRelationYear"), 
						CodeConstant.DISEASE_NAME1, recordList);
			}
			
			// 家族有高血脂遗传病史的场合
			if(CodeConstant.DATA_HAVING.equals(historyRecord.getIshyperlipidemia())){
				
				setRecord(patientId, request.getParameter("heighBloodFatRelationName"), request.getParameter("heighBloodFatRelationYear"), 
						CodeConstant.DISEASE_NAME2, recordList);
			}
			
			// 家族有糖尿病遗传病史的场合
			if(CodeConstant.DATA_HAVING.equals(historyRecord.getIsdiabetes())){
				
				setRecord(patientId, request.getParameter("diabetesMellitusRelationName"), request.getParameter("diabetesMellitusRelationYear"), 
						CodeConstant.DISEASE_NAME3, recordList);
			}
			
			// 家族有冠心病遗传病史的场合
			if(CodeConstant.DATA_HAVING.equals(historyRecord.getIschd())){
				
				setRecord(patientId, request.getParameter("coronaryDiseaseRelationName"), request.getParameter("coronaryDiseaseRelationYear"), 
						CodeConstant.DISEASE_NAME4, recordList);
			}
			
			// 家族有脑血管意外遗传病史的场合
			if(CodeConstant.DATA_HAVING.equals(historyRecord.getIscerebrovascularaccident())){
				
				setRecord(patientId, request.getParameter("cardiovascularAccidentRelationName"), request.getParameter("cardiovascularAccidentRelationYear"), 
						CodeConstant.DISEASE_NAME5, recordList);
			}
			
			//TODO 旧数据删除
			historyWriteMapper.deleteByPatientId(1);
			// 新数据插入
			int state = historyWriteMapper.insertSelective(historyRecord);
            
			//TODO 旧数据删除
			historyDetailWriteMapper.deleteByPatientId(1);
			// 新数据插入
			for(PatientFamilyGeneticHistoryDetail record : recordList){
				historyDetailWriteMapper.insertSelective(record);
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
	
	/**
	 * 
	 * @param para
	 * @return
	 */
	public List<String> getPara(String para){
		
		if(VaildateUtils.isNullOrEmpty(para)){
			return null;
		}
		
		String[] valueStr = para.split(",");
		List<String> valueList = new ArrayList<String>();
		
		for(String str : valueStr){
			if(!VaildateUtils.isNullOrEmpty(str)){
				valueList.add(str);
			}
		}
		
		return valueList;
	}

	public void setRecord(int patientId, String relationship, String sickYear, String diaseaseName,List<PatientFamilyGeneticHistoryDetail> recordList){
		
		List<String> heighBloodPressureRelationNameList = getPara(relationship);
		List<String> heighBloodPressureRelationYearList = getPara(sickYear);
		
		for(int i = 0; i<heighBloodPressureRelationNameList.size(); i++){
			PatientFamilyGeneticHistoryDetail historyDetailRecord = new PatientFamilyGeneticHistoryDetail();// 家族成员疾病史
		
			historyDetailRecord.setPatientid(patientId);
			historyDetailRecord.setDiaseasename(diaseaseName);
			historyDetailRecord.setRelationship(heighBloodPressureRelationNameList.get(i));
			historyDetailRecord.setSickyear(heighBloodPressureRelationYearList.get(i));
			
			recordList.add(historyDetailRecord);
		}
	}
}
