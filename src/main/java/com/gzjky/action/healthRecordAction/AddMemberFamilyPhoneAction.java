package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.FamilyPhoneOutputBean;
import com.gzjky.bean.gen.FamilyPhone;
import com.gzjky.dao.constant.CodeConstant;
import com.gzjky.dao.constant.MsgConstant;
import com.gzjky.dao.readdao.FamilyPhoneReadMapper;
import com.gzjky.dao.writedao.FamilyPhoneWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

public class AddMemberFamilyPhoneAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3974467296765078045L;
	
	@Autowired
	private FamilyPhoneReadMapper readMapper;
	
	@Autowired
	private FamilyPhoneWriteMapper writeMapper;
	
	/**
	 * 患者生活习惯更新
	 * @return
	 */
	public String addRecord(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
	        // 将java对象转成json对象
			HttpServletResponse response=ServletActionContext.getResponse();  
	        //以下代码从JSON.java中拷过来的  
	        response.setContentType("text/html");  
	        PrintWriter out;  
	        out = response.getWriter();  
	        
			ModelMap modelMap = new ModelMap();
			// 更新参数设定
			FamilyPhone record = new FamilyPhone();
			//TODO 患者ID要从共通拿出来
			String id = "1";
			
			record.setPatientid(NumberUtils.toInt(id));// 患者ID
			record.setName(request.getParameter("name"));
			record.setTelephone(request.getParameter("phone"));
			record.setCellphone(request.getParameter("cellphone"));
			record.setCompany(request.getParameter("company"));
			record.setEmail(request.getParameter("email"));
			record.setAddress(request.getParameter("homeAddress"));
			record.setReport(request.getParameter("report"));
			record.setFamilyship(request.getParameter("relationship"));
			
			int checkCellphone = readMapper.selectByPatientIdAndPhone(NumberUtils.toInt(id), request.getParameter("cellphone"));
			List<FamilyPhoneOutputBean> recordList = readMapper.selectByPatientId(NumberUtils.toInt(id));
			
			// 手机号已注册
			if(checkCellphone > 0){
				modelMap.setUpdateFlag(CodeConstant.EXIT_STATUS);
		        // 将java对象转成json对象
		        JSONObject jsonObject=JSONObject.fromObject(modelMap);//将list 转换为json 数组
				out.print(jsonObject);
				out.flush();
				out.close();
				return SUCCESS;
			}
			
			// 亲情号码最多只能设置三个
			if(recordList.size() >= 3){
				modelMap.setUpdateFlag(CodeConstant.FAIL_STATUS);
		        // 将java对象转成json对象
		        JSONObject jsonObject=JSONObject.fromObject(modelMap);//将list 转换为json 数组
				out.print(jsonObject);
				out.flush();
				out.close();
				return SUCCESS;
			}
			
			// 更新处理
			int updattCount = writeMapper.insertSelective(record);
			
			
			modelMap.setUpdateFlag(updattCount);
			if(updattCount == 0){
				// 更新失败
				modelMap.setMessage(MsgConstant.UPDATEINFO002);
			}else{
				// 更新成功
				modelMap.setMessage(MsgConstant.UPDATEINFO001);
			}
			
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
