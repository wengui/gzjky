package com.gzjky.action.acitonCommon;

import java.util.List;

public class ModelMap {
	
	public int recordTotal;
	
	public List<?> outBeanList;
	
	public int updateFlag;

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

}
