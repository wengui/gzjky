package com.gzjky.action.imageUploadAction;

import java.io.ByteArrayInputStream;
import java.io.IOException;

import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.bean.extend.HeadImageBean;
import com.gzjky.dao.readdao.PatientInfoReadMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 二进制流显示头像
 * 
 * @author yuting
 *
 */
public class ShowHeadImageAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1387412125933799439L;

	@Autowired
	private PatientInfoReadMapper readMapper;

	// 图片流
	private ByteArrayInputStream headImage;

	/**
	 * 头像显示
	 * 
	 * @return
	 * @throws IOException
	 */
	public String showHeadImage() {

		try {

			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			HeadImageBean result = readMapper.selectHeadImageByPatientId(patientId);

			if (result.getHeadImage().length > 0) {

				headImage = convertBytesToStream(result.getHeadImage());
			}

		} catch (Exception e) {
			// return null;
			e.printStackTrace();
		}

		return SUCCESS;

	}

	/**
	 * 将byte[]转换成ByteArrayInputStream
	 * 
	 * @param image
	 *            图片
	 * @return ByteArrayInputStream 流
	 */
	private static ByteArrayInputStream convertBytesToStream(byte[] image) {

		ByteArrayInputStream inputStream = new ByteArrayInputStream(image);

		return inputStream;
	}

	public ByteArrayInputStream getHeadImage() {
		return headImage;
	}

	public void setHeadImage(ByteArrayInputStream headImage) {
		this.headImage = headImage;
	}

}
