package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.dao.writedao.PatientHealthCheckWriteMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 删除健康检查记录
 * @author yuting
 *
 */
public class DeleteMemberMedicalExaminationAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8361738352184955158L;
	
	@Autowired
	private PatientHealthCheckWriteMapper writeMapper;
	
	public String delRecord(){
		
		try {

			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			
			String ids = request.getParameter("ids");
			
			String[] idValue = null;
			if(!VaildateUtils.isNullOrEmpty(ids)){
				idValue = ids.split(":");
			}
			
			int state = 1;
			for(String id : idValue){
				// 删除处理
				int deleteCount = writeMapper.deleteByPrimaryKey(NumberUtils.toInt(id));
				
				// 删除失败
				if(deleteCount == 0){
					state = 0;
				}
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

}
