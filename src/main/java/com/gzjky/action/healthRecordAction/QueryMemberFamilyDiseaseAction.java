package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.FamilyDiseaseRelationShips;
import com.gzjky.bean.extend.MemberFamilyDiseaseOutputBean;
import com.gzjky.bean.gen.PatientFamilyGeneticHistory;
import com.gzjky.bean.gen.PatientFamilyGeneticHistoryDetail;
import com.gzjky.dao.constant.CodeConstant;
import com.gzjky.dao.readdao.PatientFamilyGeneticHistoryDetailReadMapper;
import com.gzjky.dao.readdao.PatientFamilyGeneticHistoryReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 家族遗传病史查询
 * @author yuting
 *
 */
public class QueryMemberFamilyDiseaseAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8561770831634645398L;
	@Autowired
	private PatientFamilyGeneticHistoryReadMapper historyReadMapper;
	@Autowired
	private PatientFamilyGeneticHistoryDetailReadMapper historyDetailReadMapper;
	
	
	
	public String getRecord(){
		
		try {
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

	        // 从数据库中取得需要的对象
			PatientFamilyGeneticHistory historyRecord = historyReadMapper.selectByPatientId(patientId);
			
			List<PatientFamilyGeneticHistoryDetail> historyDetailRecordList = historyDetailReadMapper.selectByPatientId(patientId);
	        
			List<MemberFamilyDiseaseOutputBean> result = new ArrayList<MemberFamilyDiseaseOutputBean>();
	        
			ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合;
			if (!VaildateUtils.isNull(historyRecord)) {
				// 高血压的场合
				setResult(historyRecord.getIshighbloodpressure(),CodeConstant.DISEASE_NAME1,historyDetailRecordList, result);
				// 高血脂的场合
				setResult(historyRecord.getIshyperlipidemia(),CodeConstant.DISEASE_NAME2,historyDetailRecordList, result);
				// 糖尿病的场合
				setResult(historyRecord.getIsdiabetes(),CodeConstant.DISEASE_NAME3,historyDetailRecordList, result);
				// 冠心病的场合
				setResult(historyRecord.getIschd(),CodeConstant.DISEASE_NAME4,historyDetailRecordList, result);
				// 脑血管意外的场合
				setResult(historyRecord.getIscerebrovascularaccident(),CodeConstant.DISEASE_NAME5,historyDetailRecordList, result);
				
				modelMap.setOutBeanList(result);

				modelMap.setUpdateFlag(1);
			}
			

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();

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
	
	public void setResult(String have,String diseaseName,List<PatientFamilyGeneticHistoryDetail> historyDetailRecordList,List<MemberFamilyDiseaseOutputBean> result){
		
		if(CodeConstant.DATA_HAVING.equals(have)){
			MemberFamilyDiseaseOutputBean record = new MemberFamilyDiseaseOutputBean();
			record.setHave(CodeConstant.DATA_HAVING);
			record.setName(diseaseName);
			List<FamilyDiseaseRelationShips> shipsList = new ArrayList<FamilyDiseaseRelationShips>();
			for(PatientFamilyGeneticHistoryDetail detail : historyDetailRecordList){
				if(diseaseName.equals(detail.getDiaseasename())){
					FamilyDiseaseRelationShips ships = new FamilyDiseaseRelationShips();
					ships.setName(detail.getRelationship());
					ships.setYear(detail.getSickyear());
					
					shipsList.add(ships);
				}
			}
			record.setFamilyDiseaseRelationShips(shipsList);
			result.add(record);
			
		}else{
			MemberFamilyDiseaseOutputBean record = new MemberFamilyDiseaseOutputBean();
			record.setHave(CodeConstant.DATA_NOTHING);
			result.add(record);
		}
	}
}
