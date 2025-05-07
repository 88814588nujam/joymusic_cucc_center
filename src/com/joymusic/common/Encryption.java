package com.joymusic.common;

import java.security.spec.KeySpec;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;

public class Encryption {
	public static String key1 = "AAE108C5B21DDA230A64E0D17430C2BB3093B56ADA8798A4";
	public static String key2 = "344A98604F976F9D";
	private static byte[] key = HexStringToByteArray(key1);
	private static byte[] iv = HexStringToByteArray(key2);

	public static final String ENCODING = "UTF-8";

	private static String encode(byte[] data) throws Exception {
		byte[] b = Base64.encodeBase64(data);
		return new String(b, "UTF-8");
	}

	private static byte[] decode(String data) throws Exception {
		byte[] b = Base64.decodeBase64(data.getBytes("UTF-8"));
		return b;
	}

	public static String getDecrypt(String date) {
		if(StringUtils.isNotBlank(date)) return Decrypt(key, date, iv);
		else return "";
	}

	public static String getEncrypt(String date) {
		if(StringUtils.isNotBlank(date)) return Encrypt(key, date, iv);
		else return "";
	}

	private static byte[] HexStringToByteArray(String str) {
		int l = str.length();
		int bytelen = l / 2;
		byte[] bytes = new byte[bytelen];
		String buf = str.toLowerCase();
		for (int i = 0; i < buf.length(); i += 2) {
			char left = buf.toCharArray()[i];
			char right = buf.toCharArray()[i + 1];
			int index = i / 2;
			if (left < 'a') {
				bytes[index] = (byte) (left - 48 << 4);
			} else {
				bytes[index] = (byte) (left - 97 + 10 << 4);
			}
			if (right < 'a') {
				bytes[index] = (byte) (bytes[index] + (byte) (right - 48));
			} else {
				bytes[index] = (byte) (bytes[index] + (byte) (right - 97 + 10));
			}
		}
		return bytes;
	}

	private static String Encrypt(byte[] key, String strToEnc, byte[] iv) {
		String tmpresult = "";
		try {
			byte[] plainText = strToEnc.getBytes();
			IvParameterSpec ivps = new IvParameterSpec(iv, 0, iv.length);
			SecretKeyFactory kf = SecretKeyFactory.getInstance("DESede");
			DESedeKeySpec ks = new DESedeKeySpec(key);
			SecretKey ky2 = kf.generateSecret(ks);
			Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
			cipher.init(1, ky2, ivps);
			byte[] cipherText = cipher.doFinal(plainText);
			tmpresult = Encryption.encode(cipherText);
		} catch (Exception e) {
			Log.LogErr("加密出错");
		}
		return tmpresult;
	}

	private static String Decrypt(byte[] key, String datades, byte[] iv) {
		String tmpresult = "";
		try {
			byte[] data = Encryption.decode(datades);
			IvParameterSpec ivps = new IvParameterSpec(iv, 0, iv.length);
			KeySpec ks = new DESedeKeySpec(key);
			SecretKeyFactory kf = SecretKeyFactory.getInstance("DESede");
			SecretKey ky = kf.generateSecret(ks);
			Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
			cipher.init(2, ky, ivps);
			byte[] newPlainText = cipher.doFinal(data);
			tmpresult = new String(newPlainText);
		} catch (Exception e) {
			Log.LogErr("解密出错");
		}
		return tmpresult;
	}
}