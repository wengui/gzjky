package com.gzjky.action.acitonCommon;

import java.util.List;

public class ModelMap {
	
	/**
	 * 返回页面总记录条数
	 */
	public int recordTotal;
	
	/**
	 * 返回页面的json list对象
	 */
	public List<?> outBeanList;
	
	/**
	 * 处理成功标志
	 */
	public int updateFlag;
	
	/**
	 * 返回页面message
	 */
	public String message;
	
	/**
	 * 返回页面的json对象
	 */
	public Object result;
	
	public int getRecordTotal() {
		return recordTotal;
	}

	public void setRecordTotal(int recordTotal) {
		this.recordTotal = recordTotal;
	}

	public List<?> getOutBeanList() {
		return outBeanList;
	}

	public void setOutBeanList(List<?> outBeanList) {
		this.outBeanList = outBeanList;
	}

	public int getUpdateFlag() {
		return updateFlag;
	}

	public void setUpdateFlag(int updateFlag) {
		this.updateFlag = updateFlag;
	}

	public Object getResult() {
		return result;
	}

	public void setResult(Object result) {
		this.result = result;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
}
