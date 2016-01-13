package com.gzjky.interceptor;

import com.gzjky.action.login.LoginAction;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

/** 
 * 通常我们自定义一个拦截器类需要实现Interceptor接口 
* 这个接口中有三个方法void destroy(); 
*                       void init(); 
*                       String intercept(ActionInvocation invocation); 
* 一般只需实现第三个接口即可 
* 所以我们可以继承AbstractInterceptor类 
* 这个类是实现了这三个接口，同时将第三个接口实现为抽象方法 
* 防止非法登录的拦截器
 *  
 */
public class AuthenticationInterceptor extends AbstractInterceptor {

	/** 
	* @Fields serialVersionUID 
	*/
	private static final long serialVersionUID = 1L;

	public String intercept(ActionInvocation invocation) throws Exception {

		// 判断是否请求为登录界面(login),如果是则不拦截
		if (LoginAction.class == invocation.getAction().getClass()) {
			return invocation.invoke();
		}

//		// 判断session里user属性是否null
//		if (invocation.getInvocationContext().getSession().get("user") != null) {
//			// 如果验证通过则继续程序的正常流程
//			return invocation.invoke();
//		} else {
//			// 如果验证失败，返回name为loginError的result
//			return "loginError";
//		}
		return invocation.invoke();
	}

}
