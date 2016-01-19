package com.gzjky.action.healthRecordAction;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.VaildateUtils;
import com.gzjky.bean.extend.TreeNodesBean;
import com.gzjky.dao.readdao.DictionaryInfoReadMapper;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 疾病史名称查询
 * @author yuting
 *
 */
public class SearchAllOfficeDiseaseByTreeAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8302281447929175161L;
	
	private static List<String> list = new ArrayList<String>();
	
	@Autowired
	private DictionaryInfoReadMapper dictionaryInfoReadMapper;
	
	private List<TreeNodesBean> treeNodesBeanList;
	
	/**
	 * 疾病史名称查询
	 * @return
	 */
	public String searchTree(){
		
		try {
			
			list.add("hxnk");
			list.add("xhnk");
			list.add("sjnk");
			list.add("nfmk");
			list.add("xyk");
			list.add("snk");
			list.add("xxgnk");
			list.add("zlk");
			list.add("fk");
			list.add("ek");
			list.add("ck");
			list.add("pfk");
			list.add("xbk");
			list.add("gb");
			list.add("jsbk");
			list.add("yk");
			list.add("ebhk");
			list.add("kqk");
			list.add("xxwk");
			list.add("nwk");
			list.add("mnwk");
			list.add("gk");
			list.add("wsk");
			list.add("ssk");
			list.add("xgwk");
			
	        // 从数据库中取得需要的对象
			treeNodesBeanList = dictionaryInfoReadMapper.selectTreeNodes(list);
	        
	        ModelMap modelMap = new ModelMap();
	        
	        // 取得结果不为空的场合
			if (!VaildateUtils.isEmptyList(treeNodesBeanList)) {

				modelMap.setOutBeanList(treeNodesBeanList);
				modelMap.setUpdateFlag(0);
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
