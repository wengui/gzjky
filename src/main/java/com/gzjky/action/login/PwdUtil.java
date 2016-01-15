package com.gzjky.action.login;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import org.apache.commons.codec.binary.Base64;
/**
 * 密码加密
 * @author Zhu
 *
 */
public class PwdUtil  {
    
    private static int saltLength = 4;
    private static Random random = new Random();
    
    public PwdUtil() { }
    
    /**
     * SHA-1加密
     * @param strSrc
     * @return
     */
    public static byte[] Encrypt(String strSrc) {
        MessageDigest md=null;
        
        byte[] bt=strSrc.getBytes();
        try {
            md=MessageDigest.getInstance("SHA-1");
            md.update(bt);
            
        }catch (NoSuchAlgorithmException e) {
            System.out.println("Invalid algorithm.");
            return null;
        }
        return md.digest();
    }
    
    
    /**
     * 生成salt随机数
     * @param salt大小
     * @return salt
     */
    public static byte[] randomSalt(int size) {
        byte[] salt = new byte[size];
        random.nextBytes(salt);
        return salt;
    }
    
    /**
     * 创建插入数据库的密码
     * @param userPassword 用户输入密码
     * @return salt后的密码
     */
	public static String CreateDbPassword(String userPassword)
	{
		byte[] unsaltedPassword = Encrypt(userPassword);

		byte[] saltValue = randomSalt(saltLength);
		
		byte[] saltedPassword = CreateSaltedPassword(saltValue, unsaltedPassword);

		return Base64.encodeBase64String(saltedPassword);

	}
    
	
    /**
     * 密码salt
     * @param saltValue salt值
     * @param unsaltedPassword 未salt的密码
     * @return salt后的密码
     * @throws NoSuchAlgorithmException 
     */
    private static byte[] CreateSaltedPassword(byte[] saltValue, byte[] unsaltedPassword)
    {
        // add the salt to the hash
        byte[] rawSalted  = new byte[unsaltedPassword.length + saltValue.length];
        
        System.arraycopy(unsaltedPassword, 0, rawSalted, 0, unsaltedPassword.length);
        
        System.arraycopy(saltValue, 0, rawSalted, unsaltedPassword.length, saltValue.length);
             
        return rawSalted;
    }
    
    
    /**
     * 验证密码
     * @param dbPassword db中存储的密码
     * @param userPassword 用户输入的密码
     * @return
        true 验证成功
        false 验证失败
     * @throws NoSuchAlgorithmException 
     */
    public static Boolean ComparePasswords(String dbPassword,String userPassword) 
    {
    	
        byte[] dbPwd = Base64.decodeBase64(dbPassword);
        
        byte[] hashedPwd = Encrypt(userPassword);
        
        if(dbPwd.length ==0 || hashedPwd.length ==0 || dbPwd.length !=hashedPwd.length + saltLength )
        {
            return false;
        }
        
        byte[] saltValue = new byte[saltLength];
        
        int saltOffset = hashedPwd.length;
        for (int i = 0; i < saltLength; i++)
            saltValue[i] = dbPwd[saltOffset + i];
        
        byte[] saltedPassword = CreateSaltedPassword(saltValue, hashedPwd);
        
        // compare the values
        return CompareByteArray(dbPwd, saltedPassword);
        
        
    }    
    /**
     * 数组比较
     * @param array1 比较数组1
     * @param array1 比较数组2
     *
     */
    private static boolean  CompareByteArray(byte[] array1, byte[] array2)
    {
        if (array1.length != array2.length)
            return false;
        for (int i = 0; i < array1.length; i++)
        {
            if (array1[i] != array2[i])
                return false;
        }
        return true;
    }
    

 }
