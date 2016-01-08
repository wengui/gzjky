package com.gzjky.common;

import java.io.IOException;
import java.util.Properties;

/**
 * 
 * @ClassName: GetProtertiesUtil
 * @Description: 读取sql.properties中sql的工具类
 * @author A18ccms a18ccms_gmail_com
 * @date 2012-10-20 下午12:11:06
 * 
 */
public class GetProtertiesUtil {

	/**
	 * 取得Properties文件里的内容
	 * 
	 * @return Properties
	 */
	public static Properties getproperties() {

		// 定义一个properties，即为需要读取的sql.properties
		Properties p = new Properties();

		try {
			//p.load(GetProtertiesUtil.class.getResourceAsStream("/proper/sql.properties"));
			p.load(GetProtertiesUtil.class.getResourceAsStream("/proper/message.properties"));
		} catch (IOException e) {

			System.out.println("该文件不存在！");
		}
		return p;
	}

	public static Object getProValue(String keyName) {

		// 得到sql.properties
		Properties pro = getproperties();

		if (pro == null) {
			System.out.println("该文件不存在！");
		}

		return pro.getProperty(keyName);

	}
	
}