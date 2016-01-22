package com.gzjky.action.imageUploadAction;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.bean.extend.PatientimageInputBean;
import com.gzjky.dao.writedao.PatientInfoWriteMapper;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import net.sf.json.JSONObject;

/**
 * 头像上传
 * 
 * @author yuting
 *
 */
public class UploadHeadImageAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5434412943463513669L;

	private File filePath;
	private String filePathFileName;
	private String filePathContentType;

	@Autowired
	private PatientInfoWriteMapper writeMapper;

	public String upload() {

		try {

			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			byte[] image = imageToByte(filePath);

			PatientimageInputBean record = new PatientimageInputBean();
			record.setPatienId(patientId);
			record.setPatientImage(image);
			// 更新处理
			int updattCount = writeMapper.updatePatientimageById(record);

			ModelMap modelMap = new ModelMap();
			modelMap.setUpdateFlag(updattCount);

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

	/**
	 * 将图片转成2进制
	 * 
	 * @param file
	 * @return
	 */
	public byte[] imageToByte(File file) {

		byte[] by = new byte[(int) filePath.length()];

		try {
			// BufferedImage tt = ImageIO.read(filePath);
			FileInputStream inputStream = new FileInputStream(filePath);
			ByteArrayOutputStream bytestream = new ByteArrayOutputStream();
			byte[] b = new byte[(int) filePath.length()];

			int len = 0;
			while ((len = inputStream.read(b)) > 0) {
				bytestream.write(b, 0, len);
				len = inputStream.read(b);
			}
			by = bytestream.toByteArray();
		} catch (IOException e) {

			e.printStackTrace();
		}

		return by;
	}

	public File getFilePath() {
		return filePath;
	}

	public void setFilePath(File filePath) {
		this.filePath = filePath;
	}

	public String getFilePathFileName() {
		return filePathFileName;
	}

	public void setFilePathFileName(String filePathFileName) {
		this.filePathFileName = filePathFileName;
	}

	public String getFilePathContentType() {
		return filePathContentType;
	}

	public void setFilePathContentType(String filePathContentType) {
		this.filePathContentType = filePathContentType;
	}

}
