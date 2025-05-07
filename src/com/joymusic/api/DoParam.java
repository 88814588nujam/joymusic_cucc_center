package com.joymusic.api;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;

public class DoParam {
	public static String Analysis(String zone, String cname,
			HttpServletRequest request) {
		String temp = "";
		JSData data = new JSData();
		if (StringUtils.isNotBlank(request.getParameter("jsdata"))) {
			try {
				if (URLDecoder.decode(request.getParameter("jsdata"), "UTF-8")
						.indexOf("[{") > -1) {
					data.parse(URLDecoder.decode(
							request.getParameter("jsdata"), "UTF-8"));
				}
				temp = StringUtils.isBlank(data.get(zone, cname)) ? "" : data
						.get(zone, cname);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return temp;
	}

	public static String AnalysisAbb(String cname, HttpServletRequest request) {
		String temp = "";
		JSData data = new JSData();
		if (StringUtils.isNotBlank(request.getParameter("jsdata"))) {
			try {
				if (URLDecoder.decode(request.getParameter("jsdata"), "UTF-8")
						.indexOf("[{") > -1) {
					data.parse(URLDecoder.decode(
							request.getParameter("jsdata"), "UTF-8"));
				}
				if (StringUtils.isNotBlank(data.get("request", "params"))) {
					String[] params = data.get("request", "params").split("&");
					for (int i = 0; i < params.length; i++) {
						if (params[i].split("=")[0].equals(cname)) {
							if (params[i].length() > 2) {
								temp = params[i].split("=")[1];
							} else {
								temp = "";
							}
						}
					}
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return temp;
	}
}