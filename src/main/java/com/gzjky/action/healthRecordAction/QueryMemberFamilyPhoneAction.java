package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.FamilyPhoneOutputBean;
import com.gzjky.dao.readdao.FamilyPhoneReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 亲情号码一览查询
 * @author yuting
 *
 */
public class QueryMemberFamilyPhoneAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -805765831979747406L;
	@Autowired
	private FamilyPhoneReadMapper readMapper;
	
	public String getList(){
		
		try {
			
	        // 从数据库中取得需要的对象
			List<FamilyPhoneOutputBean> recordList = readMapper.selectByPatientId(1);
	        
	        ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合
			if (!VaildateUtils.isEmptyList(recordList)) {

				modelMap.setOutBeanList(recordList);
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

}
