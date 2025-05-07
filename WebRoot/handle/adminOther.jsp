<%@page import="java.text.SimpleDateFormat,com.joymusic.api.*,java.security.*,java.net.*,java.io.*,java.util.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	// 联通要求上报数据
	private String postJsonLog(String u, String p, String s, int pf, String ot, String or, String st){
		String rt = "{\"result\":\"999\",\"description\":\"prepare params.\"}";
        BufferedReader reader = null;
		try{
			String logUrl = "http://202.99.114.28:10000/externalDataNotify";
			URL url = new URL(logUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setRequestProperty("Charset", "UTF-8");
			// 设置文件类型
			conn.setRequestProperty("Content-Type","application/json; charset=UTF-8");
			conn.setRequestProperty("accept","application/json");
			// 往服务器里面发送数据
			OutputStream outwritestream = conn.getOutputStream();
			String userid = u;
			if(!"201".equals(p)){
				userid = u + "_" + p;
			}
			String cpDataRecords = "";
			String outSource = "40";
			String cpId = "txhy";
			String cpKey = "txhy";
			String stbModel = s;
			String tvPlatform = pf == 1 ? "2" : "1"; // 1：华为 2：中兴
			String operateType = ot;
			String operateResult = or;
			Date date = new Date();
			String operateTime = new SimpleDateFormat("yyyyMMddHHmmss").format(date);
			String productId = "";
			if(p.equals("201")) productId = "hlgfby020dlrk@" + p;
			else productId = "xwjyyby020@" + p;
			String positionNum = "";
			if(p.equals("201")) positionNum = "天津-同信互娱-欢乐歌房-01";
			else if(p.equals("204")) positionNum = "河南-同信互娱-欢乐歌房-04";
			else if(p.equals("207")) positionNum = "山西-同信互娱-欢乐歌房-07";
			else if(p.equals("208")) positionNum = "内蒙古-同信互娱-欢乐歌房-08";
            else if(p.equals("211")) positionNum = "黑龙江-同信互娱-欢乐歌房-11";
			else if(p.equals("214")) positionNum = "福建-同信互娱-欢乐歌房-14";
			else if(p.equals("216")) positionNum = "山东-同信互娱-欢乐歌房-16";
			else if(p.equals("217")) positionNum = "湖北-同信互娱-欢乐歌房-17";
			else if(p.equals("223")) positionNum = "贵州-同信互娱-欢乐歌房-23";
			String staytime = st;
			cpDataRecords = "{\"cpId\":\"" + cpId + "\", \"cpKey\":\"" + cpKey + "\", \"stbModel\":\"" + stbModel + "\", \"tvPlatform\":\"" + tvPlatform + "\", \"operateType\":\"" + operateType + "\", \"operateResult\":\"" + operateResult + "\", \"operateTime\":\"" + operateTime + "\", \"productId\":\"" + productId + "\", \"positionNum\":\"" + positionNum + "\", \"staytime\":\"" + staytime + "\"}";
			String signature = cpId + userid + p + outSource + operateTime;
			signature = getSHA256StrJava(signature) + operateTime;
			String jsonStr  = "{\"userId\":\"" + userid + "\", \"carrierId\":\"" + p + "\", \"outSource\":\"" + outSource + "\", \"signature\":\"" + signature + "\", \"cpDataRecords\":[" + cpDataRecords + "]}";
			System.out.println("log jsonStr : " + jsonStr);
			outwritestream.write(jsonStr.getBytes());
			outwritestream.flush();
			outwritestream.close();
			if(conn.getResponseCode() == 200){
				reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				rt = reader.readLine();
				System.out.println("log result : " + rt);
			}
		} catch(Exception e){
		}
		return rt;
	}

	private String getSHA256StrJava(String str){
		MessageDigest messageDigest;
		String encodeStr = "";
		try{
			messageDigest = MessageDigest.getInstance("SHA-256");
			messageDigest.update(str.getBytes("UTF-8"));
			encodeStr = byte2Hex(messageDigest.digest());
		} catch(Exception e){}
		return encodeStr;
	}

	private String byte2Hex(byte[] bytes){
		StringBuffer stringBuffer = new StringBuffer();
		String temp = null;
		for(int i = 0; i < bytes.length; i++){
			temp = Integer.toHexString(bytes[i] & 0xFF);
			if(temp.length() == 1){
				stringBuffer.append("0");
			}
			stringBuffer.append(temp);
		}
		return stringBuffer.toString();
	}

	private int addHallLogs(String uid, String key, String pos, String provinceN, String other) {
		Integer totalRows = 0;
		String sql = "INSERT INTO zone_user_logs_flow_hall(uid, from_key, from_pos, provinceN, other, createtime) VALUE($uid, $key, $pos, $provinceN, $other, NOW())";
		sql = DB.sqlWrapperByParams(
				sql,
				new Object[] { uid, key, pos, provinceN, other });
		totalRows = DB.update(sql);
		return totalRows;
	}
%>
<%
	int opera = Integer.parseInt(StringUtils.isBlank(request.getParameter("o")) ? "0" : request.getParameter("o").toString()); // 操作类型
	
	if(opera == 0){ // 联通中心同步日志
		String u = StringUtils.isBlank(request.getParameter("u")) ? "" : request.getParameter("u");
		String p = StringUtils.isBlank(request.getParameter("p")) ? "" : request.getParameter("p");
		String s = StringUtils.isBlank(request.getParameter("s")) ? "" : request.getParameter("s");
		int pf = Integer.parseInt(StringUtils.isBlank(request.getParameter("pf")) ? "0" : request.getParameter("pf").toString());
		String ot = StringUtils.isBlank(request.getParameter("ot")) ? "" : request.getParameter("ot");
		String or = StringUtils.isBlank(request.getParameter("or")) ? "" : request.getParameter("or");
		String st = StringUtils.isBlank(request.getParameter("st")) ? "" : request.getParameter("st");
		String jsonStr = "{\"result\":\"999\",\"description\":\"prepare params.\"}";
		if(ot.equals("7")){ // 点播记录要传实际播放内容
			List<Map<String, Object>> li = InfoData.getSongByIds(or);
			or = "(曲目可能被删除 曲目id:" + or + ")";
			if(li.size() > 0) or = li.get(0).get("cname").toString() + " - " + li.get(0).get("artist").toString();
		}
		if(StringUtils.isNotBlank(u) && !u.contains("browsertest") && !u.contains("mobiletest")) jsonStr = postJsonLog(u, p, s, pf, ot, or, st);
		out.print(jsonStr);
		return;
	} else if(opera == 1){ // 联通大厅记录日志
		String u = StringUtils.isBlank(request.getParameter("u")) ? "" : request.getParameter("u");
		String k = StringUtils.isBlank(request.getParameter("k")) ? "" : request.getParameter("k");
		String ps = StringUtils.isBlank(request.getParameter("ps")) ? "" : request.getParameter("ps");
		String p = StringUtils.isBlank(request.getParameter("p")) ? "" : request.getParameter("p");
		String ot = StringUtils.isBlank(request.getParameter("ot")) ? "" : request.getParameter("ot");
		String jsonStr = "{\"result\":\"999\",\"description\":\"prepare params.\"}";
		if(StringUtils.isNotBlank(u) && !u.contains("browsertest") && !u.contains("mobiletest")){
			int row = addHallLogs(u, k, ps, p, ot);
			if(row > 0) jsonStr = "{\"result\":\"0\",\"description\":\"log success.\"}";
		}
		out.print(jsonStr);
		return;
	}
%>