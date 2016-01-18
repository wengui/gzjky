package com.gzjky.action.acitonCommon;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.bean.extend.DictionaryInfoBean;
import com.gzjky.dao.readdao.DictionaryInfoReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 画面表示用下拉框查询
 * @author liukun
 *
 */
public class QueryDictionaryInfo extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5679802469667836298L;
	
	@Autowired
	private DictionaryInfoReadMapper readMapper;
	
	//基本信息
	static List<String> memberBaseInfoList = new ArrayList<String>(){{
        add("dictSex");
        add("certiType");
        add("nationalityCodeDict");
        add("maritalStatusDict");
        add("censusRegDict");
        add("userAcademic");
        add("politicalAffiliatio");
        add("workingyear");
        add("moneyForYear");
    }};
	//健康病例-生活习惯
	static List<String> memberHabitList = new ArrayList<String>(){{
        add("workType");
        add("workPressure");
        add("aboBloodTypeDict");
        add("Weight");
        add("Waistline");
        add("SmokeTime");
        add("SmokeNum");
        add("drinkFreqCodeDict");
        add("alcoholTypeDict");
        add("SportNum");
        add("SportTime");
        add("SleepTime");
        add("Hypotensor");
    }};
	//健康病例-家族遗传史
	static List<String> memberFamilyDiseaseList = new ArrayList<String>(){{

    }};
	//健康病例-高血压专项
	static List<String> memberHtspecialList = new ArrayList<String>(){{
        add("BPLevel");
        add("RiskLevel");
    }};	
	public final static Map map = new HashMap() {{
		put("memberBaseInfo", memberBaseInfoList);  
	    put("memberHabit", memberHabitList); 
	    put("memberFamilyDisease", memberFamilyDiseaseList); 
	    put("memberHtspecial", memberHtspecialList); 
	}};
	/**
	 * 下拉列表取得
	 * @return
	 */
	public String getDictionaryInfo(){
		
		try {
			// 页面参数取得
			HttpServletRequest request = ServletActionContext.getRequest();
			List list = (List)map.get(request.getParameter("viewName"));

			// 从数据库中取得需要的对象
			List<DictionaryInfoBean> recordList = readMapper.selectDictionaryInfo(list);
	        
	        ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合			if (!VaildateUtils.isEmptyList(recordList)) {

			modelMap.setOutBeanList(recordList);

			modelMap.setUpdateFlag(1);

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
