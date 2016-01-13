package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.gen.PatientInfo;
import com.gzjky.dao.constant.MsgConstant;
import com.gzjky.dao.writedao.PatientInfoWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 基本信息 - 工作信息更新
 * @author yuting
 *
 */
public class EditMemberWorkInfoAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 854695292985626898L;
	
	
	@Autowired
	private PatientInfoWriteMapper patientInfoWriteMapper;
	
	/**
	 * 基本信息 - 工作信息更新
	 * @return
	 */
	public String editWorkInfo(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 更新参数设定
			PatientInfo record = new PatientInfo();
			//TODO 患者ID要从共通拿出来
			String id = "1";
			
			record.setId(NumberUtils.toInt(id));// 患者ID
			record.setWorkyears(request.getParameter("workyears"));// 工作年限
			record.setAnnualincome(request.getParameter("annualincome"));// 工作年限
			record.setCompanyname(request.getParameter("companyname"));// 公司名称
			record.setCompanyaddress(request.getParameter("companyaddress"));// 公司地址

			// 更新处理
			int updattCount = patientInfoWriteMapper.updateByPrimaryKeySelective(record);
			
			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(updattCount);
			if(updattCount == 0){
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
