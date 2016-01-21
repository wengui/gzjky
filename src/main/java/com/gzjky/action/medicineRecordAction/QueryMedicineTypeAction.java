package com.gzjky.action.medicineRecordAction;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.gen.MedicinesCate;
import com.gzjky.dao.readdao.MedicinesCateReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 药品类目查询
 * 
 * @author yuting
 *
 */
public class QueryMedicineTypeAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3485409119689200413L;
	
	@Autowired
	private MedicinesCateReadMapper readMapper;

	/**
	 * 药品类目查询
	 * @return
	 */
	public String getList() {

		try {
			// 从数据库中取得需要的对象
			List<MedicinesCate> result = readMapper.selectAllRecord();

			ModelMap modelMap = new ModelMap();

			// 取得结果不为空的场合
			if (!VaildateUtils.isEmptyList(result)) {

				modelMap.setOutBeanList(result);
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
