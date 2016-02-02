package com.gzjky.action.imageUploadAction;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.multipart.MultiPartRequestWrapper;
import org.springframework.beans.factory.annotation.Autowired;

import com.gzjky.action.acitonCommon.ModelMap;
import com.gzjky.base.util.imageUpload.IImageUpload;
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

	@Autowired
	private PatientInfoWriteMapper writeMapper;
	@Autowired
	private IImageUpload imageUpload;

	public String upload() {

		try {

			HttpServletRequest request = ServletActionContext.getRequest();
			
			// 患者ID取得
			int patientId = NumberUtils.toInt(ActionContext.getContext().getSession().get("PatientID").toString());

			byte[] image = getRequestPayload(request);

			PatientimageInputBean record = new PatientimageInputBean();
			record.setPatienId(patientId);
			record.setPatientImage(image);
			// 更新处理
			int count = writeMapper.updatePatientimageById(record);
			
			ModelMap modelMap = new ModelMap();
			
			// 将java对象转成json对象
			HttpServletResponse response = ServletActionContext.getResponse();
			// 以下代码从JSON.java中拷过来的
			response.setContentType("text/html");
			PrintWriter out;
			out = response.getWriter();
			modelMap.setUpdateFlag(count);
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
	
	private byte[] getRequestPayload(HttpServletRequest req) {  

		byte[] image = null;
		//用来限制用户上传文件大小的
        try {
        	
        	// MultiPartRequestWrapper 取得
        	MultiPartRequestWrapper wrapper = (MultiPartRequestWrapper)req; 
        	
        	// 取得上传文件
        	File[] files = wrapper.getFiles("file");

        	for(File file : files){
        		// 对图片进行压缩
        		image = imageUpload.zipImageFile(file);
        	}
        	
        	
		} catch (Exception e) {
			return null;
		}
        
        return image;
}

	/**
	 * 将图片转成2进制
	 * 
	 * @param file
	 * @return
	 */
	public byte[] imageToByte(File file) {

		byte[] by = new byte[(int) file.length()];

		try {
			// BufferedImage tt = ImageIO.read(filePath);
			FileInputStream inputStream = new FileInputStream(file);
			ByteArrayOutputStream bytestream = new ByteArrayOutputStream();
			byte[] b = new byte[(int) file.length()];

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

}
