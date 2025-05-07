package com.joymusic.common;

import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;

public class UrlHandle {
	public static String getRequestString(HttpServletRequest req) {
		String requestPath = req.getServletPath().toString();
		String queryString = req.getQueryString();
		if (queryString != null)
			return requestPath + "?" + queryString;
		else
			return requestPath;
	}
	
	public static boolean isRealStr(String a) {
		boolean flag = true;
		if (StringUtils.isNotEmpty(a)) {
			if (a.contains("%22") || a.contains("%3E") || a.contains("%3e") || a.contains("%3C") || a.contains("%3c")
				|| a.contains("<") || a.contains(">") || a.contains("\"") || a.contains("'") || a.contains("+") || a.contains(" and ") 
				|| a.contains(" or ") || a.contains("select ") || a.contains("alert(") || a.contains("1=1") || a.contains("(") || a.contains(")")) {
				flag = false;
			}
		} else{
			flag = false;
		}
		return flag;
	}
	
	public static String TransactSQLInjection(String str){
		return str.replaceAll(".*([';]+|(--)+).*", " ");
    }
}
