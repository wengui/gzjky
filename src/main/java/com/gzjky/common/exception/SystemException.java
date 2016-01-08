package com.gzjky.common.exception;

import java.util.List;

import com.gzjky.common.GetProtertiesUtil;

/**
 * @ClassName: SystemException
 * @Description: 自定义共通异常类
 * @author A18ccms a18ccms_gmail_com
 * @date 2012-11-9 下午09:39:23
 * 
 */
public class SystemException extends Exception {

	/**
	 * @Fields serialVersionUID 
	 */
	private static final long serialVersionUID = 1L;

	private String key;

	private Object[] values;

	public String getKey() {
		return key;

	}

	public Object[] getValues() {
		return values;

	}

	public SystemException() {
		super();

	}

	public SystemException(String message, Throwable throwable) {
		super(message, throwable);

	}

	public SystemException(String message) {
		super(message);
	}

	public SystemException(Throwable throwable) {
		super(throwable);

	}

	public SystemException(String key, String message) {
		super(message);
		this.key = key;
		
	}

	public SystemException(String key, Object value, String message) {
		super(message);
		this.key = key;
		this.values = new Object[] { value };

	}

	public SystemException(String key, Object[] values, String message) {
		super(message);
		this.key = key;
		this.values = values;

	}

	public List<?> getExceptions() {
		return null;
	}
	/**
	 * 
	 * @Title: getPropValue
	 * @Description: (通过共通的方法取得properties配置文件中的值)
	 * @param @param keyName
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @throws
	 */
	public String getPropValue(String keyName) {

		String codeMessage = (String) GetProtertiesUtil.getProValue(keyName);

		return codeMessage;
	}
}
