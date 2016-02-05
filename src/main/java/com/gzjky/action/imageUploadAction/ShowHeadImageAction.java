package com.gzjky.action.imageUploadAction;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.base.util.imageUpload.IImageUpload;
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
	
	// 默认头像
	private static String DEFAULT_HEAD_IMAGE = "/images/health/default_head.gif";

	@Autowired
	private PatientInfoReadMapper readMapper;
	@Autowired
	private IImageUpload imageUpload;

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

			// request取得
			HttpServletRequest request = ServletActionContext.getRequest();
	        
	        // 	取得相对路径
	        String basePath = request.getSession().getServletContext().getRealPath("/");
	        
	        // 默认头像设定
	        File file = new File(basePath + DEFAULT_HEAD_IMAGE);
			
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			HeadImageBean result = readMapper.selectHeadImageByPatientId(patientId);

			if (result.getHeadImage().length > 0) {

				headImage = convertBytesToStream(result.getHeadImage());
			}else{
				headImage = imageUpload.getImageBinary(file);
			}

		} catch (Exception e) {
			// return null;
			e.printStackTrace();
		}

		return SUCCESS;

	}

	/**
	 * 头像显示(患者ID)
	 * 
	 * @return
	 * @throws IOException
	 */
	public String showHeadImageByPid() {

		try {

			// request取得
			HttpServletRequest request = ServletActionContext.getRequest();
	        
	        // 	取得相对路径
	        String basePath = request.getSession().getServletContext().getRealPath("/");
	        
	        // 默认头像设定
	        File file = new File(basePath + DEFAULT_HEAD_IMAGE);
			
			// 患者ID取得
			int patientId = NumberUtils.toInt(request.getParameter("pid"));

			HeadImageBean result = readMapper.selectHeadImageByPatientId(patientId);

			if (result.getHeadImage().length > 0) {

				headImage = convertBytesToStream(result.getHeadImage());
			}else{
				headImage = imageUpload.getImageBinary(file);
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
