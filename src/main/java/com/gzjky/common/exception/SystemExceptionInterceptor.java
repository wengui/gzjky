package com.gzjky.common.exception;

import com.gzjky.common.GetProtertiesUtil;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

/**
 * 
* @ClassName: SystemExceptionInterceptor 
* @Description: (异常拦截器，将发生的异常转化为我们自定义的异常) 
* @author A18ccms a18ccms_gmail_com 
* @date 2013-8-27 下午09:47:16 
*
 */
public class SystemExceptionInterceptor extends AbstractInterceptor {

	/** 
	* @Fields serialVersionUID 
	*/
	private static final long serialVersionUID = 1L;

	/**
	 * 将所有拦截到的异常转变为我们自定义异常类进行处理
	 */
//	public String intercept(ActionInvocation invocation) throws Exception {
//		String result = null;
//		try {
//			result = invocation.invoke();
//		} catch (SystemException exception) {
//
//			ActionSupport as = (ActionSupport) invocation.getAction();
//			processBaseException(as, exception);
//			//TODO 这个方法不知道怎么处理
//			List exceptions = exception.getExceptions();
//			if (exceptions != null && !exceptions.isEmpty()) {
//				for (int i = 0; i < exceptions.size(); i++) {
//					SystemException subEX = (SystemException) exceptions.get(i);
//					processBaseException(as, subEX);
//				}
//			}
//			throw exception;
//		}
//		return result;
//	}

	public String intercept(ActionInvocation invocation) throws Exception {
		String result = null;
		try {
			result = invocation.invoke();
		} catch (SystemException exception) {

			ActionSupport as = (ActionSupport) invocation.getAction();
			processBaseException(as, exception);
			throw exception;
		}
		return result;
	}
	
	private void processBaseException(ActionSupport action,
			SystemException systemException) {
		String messageKey = systemException.getKey();
		String[] args = (String[]) systemException.getValues();

		if (args != null && args.length > 0) {
			String s = action.getText(messageKey, args);
			action.addActionError(s);
		} else {
			String s = action.getText(getPropValue(messageKey));
			action.addActionError(s);
		}
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
