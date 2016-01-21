package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.QueryMemberHtSpecialOutputBean;
import com.gzjky.bean.extend.TakeDrugsBean;
import com.gzjky.dao.readdao.PatientHighBloodInfoReadMapper;
import com.gzjky.dao.readdao.PatientHighBloodTakingDrugsReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 高血压专项出力Bean
 * 
 * @author yuting
 *
 */
public class QueryMemberHtSpecialAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4803869954171461033L;
	
	@Autowired
	private PatientHighBloodInfoReadMapper highBloodInfoReadMapper;
	@Autowired
	private PatientHighBloodTakingDrugsReadMapper takingDrugsReadMapper;

	public String getRecord() {

		try {
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			// 患者ID要从session里取得
			QueryMemberHtSpecialOutputBean result = highBloodInfoReadMapper.selectRecordByPatientid(patientId);

			List<TakeDrugsBean> takeDrugsBeanList = null;
			
			if(!VaildateUtils.isNull(result)){
				takeDrugsBeanList = takingDrugsReadMapper.selectByHighbloodinfoId(NumberUtils.toInt(result.getId()));
			}
			
			result.setMedicineTakenItems(takeDrugsBeanList);

			ModelMap modelMap = new ModelMap();
			

			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();
			modelMap.setResult(result);
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
