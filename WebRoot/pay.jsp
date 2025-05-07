<%@page language="java" import="java.text.SimpleDateFormat,java.security.*,com.joymusic.api.*,java.util.*,java.net.*,java.io.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger("mydebug");

	private int saveOrderInfo(String ip, String uid, String cityN, String purchase, String sid, String sname, String detail, int platform){
		Integer totalRows = null;
		if(totalRows == null){
			String sql = "INSERT INTO user_pay_info(ip, uid, cityN, fee, purchase, id_content, content, detail, platform, createtime) VALUE(\"" + ip + "\", \"" + uid + "\", \"" + cityN + "\", 2900, \"" + purchase + "\", \"" + sid + "\", \"" + sname + "\", \"" + detail + "\", " + platform + ", NOW())";
			totalRows = DB.update(sql);
		}
		return totalRows;
	}

	private int saveOrderApply(String ip, String uid, String cityN, String purchase, String sid, String sname, String detail, int platform){
		Integer totalRows = null;
		if(totalRows == null){
			String sql = "INSERT INTO user_pay_apply(ip, uid, cityN, fee, purchase, id_content, content, detail, platform, createtime) VALUE(\"" + ip + "\", \"" + uid + "\", \"" + cityN + "\", 2900, \"" + purchase + "\", \"" + sid + "\", \"" + sname + "\", \"" + detail + "\", " + platform + ", NOW())";
			totalRows = DB.update(sql);
		}
		return totalRows;
	}

	private int saveOrderAll(String ip, String uid, String cityN, String result, String description, String sid, String sname, String detail, int platform){
		Integer totalRows = null;
		if(totalRows == null){
			String sql = "INSERT INTO user_pay_all(ip, uid, cityN, result, cdes, id_content, content, detail, platform, createtime) VALUE(\"" + ip + "\", \"" + uid + "\", \"" + cityN + "\", \"" + result + "\", \"" + description + "\", \"" + sid + "\", \"" + sname + "\",\"" + detail + "\", " + platform + ", NOW())";
			totalRows = DB.update(sql);
		}
		return totalRows;
	}

	private int modifyUnsub(String uid){
		Integer totalRows = null;
		if (totalRows == null) {
			String sql = "UPDATE zone_user_pay_unsub SET inline=0 WHERE uid='" + uid + "'";
			totalRows = DB.update(sql);
		}
		return totalRows;
	}

	private static String getCname(int pageId, String key){
		String cname = "";
		if(pageId == -1){
			cname = "终端大厅";
		} else if(pageId == 99){ // 自由式专题
			Map<String, Object> gea = InfoData.getEntityAlbum(key);
			cname = "专题_" + gea.get("cname").toString();
		} else if(pageId == 7 || pageId == 8){
			int aid = Integer.parseInt(key);
			Map<String, Object> gabr = InfoData.getEntityArtist(aid);
			cname = (pageId == 7 ? "时尚艺人列表_" : "经典艺人列表_") + gabr.get("cname").toString().replaceAll("'", "\\\\'");
		} else if(pageId == 11 || pageId == 12){
			int defList = Integer.parseInt(key);
			Map<String, Object> gabr = InfoData.getEntityAlbumlist(defList);
			cname = (pageId == 11 ? "时尚专辑列表_" : "经典专辑列表_") + gabr.get("cname").toString().replaceAll("'", "\\\\'");
		} else{
			Map<String, Object> gpd = InfoData.getUiPageDetail(pageId);
			if(!gpd.isEmpty()) cname = gpd.get("cname").toString();
		}
		return cname;
	}

	// 天津联通的河南有童锁功能
	private boolean isLocked(String u){
		boolean flag = false;
        BufferedReader reader = null;
		try{
			URL url = new URL("http://202.99.114.14:15081/hn/querySafetylockSts");
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
			String nowT = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
			String sign = toString(md5Private(("yturtyyt" + nowT).getBytes())).toLowerCase();
			String productId = "hlgfby020@204";
			String jsonStr = "{\"productId\":\"" + productId + "\",\"loginAccount\":\"" + u + "\",\"appId\":\"cp0014\",\"time\":\"" + nowT + "\",\"sign\":\"" + sign + "\"}";
			outwritestream.write(jsonStr.getBytes());
			outwritestream.flush();
			outwritestream.close();
			if(conn.getResponseCode() == 200){
				reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String result = reader.readLine();
				// System.out.println("// ==============================================");
				// System.out.println("pay result : " + result);
				result = result.substring(result.indexOf("\"returncode\":") + "\"returncode\":".length(), result.indexOf(",\"returnmsg\":\""));
				if(result.equals("1")){
					flag = true;
				}
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return flag;
	}

	private byte[] md5Private(byte[] cs){
		byte[] rs = null;
	      try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			rs = md.digest(cs);
		} catch(Exception e) {
			e.printStackTrace();
		} 
		return rs;
	}

	private String toString(byte[] a){
        if (a == null)
            return "null";
        if (a.length == 0)
            return "";
 
        StringBuilder buf = new StringBuilder();
        for (int i = 0; i < a.length; i++) {
        	if (a[i] < 0)
        		buf.append(Integer.toHexString(a[i]&0xff));
        	else if (a[i] < 16) {
        		buf.append('0');
        		buf.append(Integer.toHexString(a[i]));
        	} else {
        		buf.append(Integer.toHexString(a[i]));
        	}
        }
        return buf.toString();
    }

	private static String postJsonLog(String u, String p, String s, String pf, String ot, String or, String st){
		String rt = "";
        BufferedReader reader = null;
		try{
			String authUrl = "http://172.16.34.11:8081/joymusic_cucc_center/h5";
			authUrl = authUrl + "?u=" + u + "&p=" + p + "&s=" + s + "&pf=" + pf + "&ot=" + ot + "&or=" + or + "&st=" + st;
			URL url = new URL(authUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setRequestProperty("Charset", "UTF-8");
			if(conn.getResponseCode() == 200){
				reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				rt = reader.readLine();
			}
		} catch(Exception e){
		}
		return rt;
	}
%>
<%
	int opera = Integer.parseInt(StringUtils.isBlank(request.getParameter("o")) ? "0" : request.getParameter("o").toString()); // 操作类型
	// 用户ID
	String userid = StringUtils.isBlank(request.getParameter("u")) ? "" : request.getParameter("u");
	// 获取盒子ip
	String userip = StringUtils.isBlank(request.getParameter("i")) ? "" : request.getParameter("i");
	// 曲目id
	String songId = StringUtils.isBlank(request.getParameter("s")) ? "" : request.getParameter("s");
	// 当前页面ID
	String pageId = StringUtils.isBlank(request.getParameter("p")) ? "-1" : request.getParameter("p");
	// 页面关键字
	String key = StringUtils.isBlank(request.getParameter("k")) ? "" : request.getParameter("k");
	// 使用设备城市编号
	String cityN = StringUtils.isBlank(request.getParameter("c")) ? "" : request.getParameter("c");
	// 地区ID
	String areaCode = StringUtils.isBlank(request.getParameter("a")) ? "" : request.getParameter("a");
	// token
	String userToken = StringUtils.isBlank(request.getParameter("t")) ? "" : request.getParameter("t");
	// 机顶盒型号
	String stbType = StringUtils.isBlank(request.getParameter("st")) ? "" : request.getParameter("st");
	// 用户登陆的平台 1:中兴 2:华为
	int platform = Integer.parseInt(StringUtils.isBlank(request.getParameter("f")) ? "1" : request.getParameter("f"));
	// 获取页面名称
	String cname = getCname(Integer.parseInt(pageId), key);
	String curl = request.getScheme() + "://" + request.getServerName() + ":8882" + request.getContextPath() + request.getServletPath();
	String jsdata = "";
	String success = "";

	if(opera == 0){
		// 在跳转前,要将用户的所有信息参数用session临时保存起来
		jsdata = request.getParameter("jsdata");
		if(StringUtils.isNotBlank(jsdata)) session.setAttribute("pay_" + userid, jsdata);
		List<Map<String, Object>> li = InfoData.getSongByIds(songId);
		String disN = "'订购'按钮触发";
		if(li.size() > 0) disN = li.get(0).get("cname") == null ? "N/A" : li.get(0).get("cname").toString() + " - " + li.get(0).get("artist").toString();
		saveOrderAll(userip, userid, cityN, "-1", "发起订购续包月", songId, disN, cname, platform);
		String spid = "96596";
		/*String serviceId = "wjyydb";
		String productId = "xwjyyby020@" + areaCode;
		if(areaCode.equals("204")){ // 河南是wjyydbhlgf@204 智享音乐
			serviceId = "wjyydb";
			productId = "wjyydbhlgf@204";
		}*/
		String serviceId = "hlgfby020";
		String productId = "xwjyyby020@" + areaCode;
		if(areaCode.equals("201")){ // 天津不变成沃家音乐
			serviceId = "hlgfby020";
			productId = "hlgfby010dlrknew@201";
		} else if(areaCode.equals("204")){
			serviceId = "hlgfby020";
			productId = "wjyydbhlgf@204";
		} else if(areaCode.equals("211")){
			serviceId = "wjyydb";
			productId = "xwjyyby020@211";
		}
		String payUid = userid;
		if(!areaCode.equals("201")) payUid = userid + "_" + areaCode;
		String payUrl = "http://202.99.114.14:10020/ACS/vas/serviceorder";
		payUrl = payUrl + "?SPID=" + spid + "&UserID=" + payUid + "&UserToken=" + userToken + "&Action=1&OrderMode=1&ContinueType=0";
		payUrl = payUrl + "&ServiceID=" + serviceId + "&ProductID=" + productId;
		String returnURL = "http://202.99.114.152:26800/joymusic_cucc_center/pay.jsp?o=1&u=" + userid + "&i=" + userip + "&s=" + songId + "&p=" + pageId + "&k=" + key + "&c=" + cityN + "&a=" + areaCode + "&t=" + userToken + "&st=" + stbType + "&f=" + platform;
		returnURL = URLEncoder.encode(returnURL, "GBK");
		payUrl = payUrl + "&ReturnURL=" + returnURL;
		// System.out.println("// ==============================================");
		// System.out.println("pay payUrl : " + payUrl);

		if(areaCode.equals("204")){
			// 判断是否开启了童锁
			boolean flag = isLocked(userid);
			if(flag){
				String nowT = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
				String sign = toString(md5Private(("yturtyyt" + nowT).getBytes())).toLowerCase();
				// 童锁的返回
				returnURL = "http://202.99.114.152:26800/joymusic_cucc_center/pay.jsp?o=3&u=" + userid + "&i=" + userip + "&s=" + songId + "&p=" + pageId + "&k=" + key + "&c=" + cityN + "&a=" + areaCode + "&t=" + userToken + "&st=" + stbType + "&f=" + platform;
				returnURL = URLEncoder.encode(returnURL, "GBK");
				String lockPayUrl = "http://202.99.114.14:15081/payLock/payVerify.html?userid=" + userid + "&appId=cp0014&time=" + nowT + "&sign=" + sign + "&productPrice=20&productId=hlgfby020@204&returnUrl=" + returnURL;
				response.sendRedirect(lockPayUrl);
				return;
			}
		}

		response.sendRedirect(payUrl);
		return;
	} else if(opera == 1){ // 订购成功通知
		String queryStr = request.getQueryString();
		// System.out.println("// ==============================================");
		// System.out.println("pay queryStr : " + queryStr);
		success = request.getParameter("Result"); // 订购成功与否标志
		List<Map<String, Object>> li = InfoData.getSongByIds(songId);
		String disN = "'订购'按钮触发";
		if(li.size() > 0) disN = li.get(0).get("cname") == null ? "N/A" : li.get(0).get("cname").toString() + " - " + li.get(0).get("artist").toString();
		if("0".equals(success)){
			saveOrderInfo(userip, userid, cityN, "wjyydb", songId, disN, cname, platform);
			saveOrderAll(userip, userid, cityN, "0", "订购成功续包月", songId, disN, cname, platform);
			// 将退订表状态刷新
			modifyUnsub(userid);
			// 同步订购成功日志
			String result = postJsonLog(userid, areaCode, stbType, String.valueOf(platform), "1", "0", "15");
		} else if("001".equals(success)) saveOrderAll(userip, userid, cityN, "-100", "订购取消续包月", songId, disN, cname, platform);
		else saveOrderAll(userip, userid, cityN, "-100", "订购失败", songId, disN, cname, platform);

		// 订购失败后弹出积分订购 2020-04-08
		/*if(!success.equals("0")){
			if(areaCode.equals("201") || areaCode.equals("204") || areaCode.equals("208") || areaCode.equals("211") || areaCode.equals("214") || areaCode.equals("217") || areaCode.equals("223")){
				saveOrderAll(userip, userid, cityN, "-99", "发起积分订购7天", songId, disN, cname, platform);
				String returnURL = "http://202.99.114.152:26800/joymusic_cucc_center/pay.jsp?o=2&u=" + userid + "&i=" + userip + "&s=" + songId + "&p=" + pageId + "&k=" + key + "&c=" + cityN + "&a=" + areaCode + "&t=" + userToken + "&st=" + stbType + "&f=" + platform;
				returnURL = URLEncoder.encode(returnURL, "GBK");
				String payUid = userid;
				if(!areaCode.equals("201")) payUid = userid + "_" + areaCode;
				String toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=201&specialareatype=2&goodsid=V321300000046&returnurl=" + returnURL;
				if(areaCode.equals("204")) toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=204&specialareatype=2&goodsid=V327600000075&returnurl=" + returnURL;
				else if(areaCode.equals("207")) toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=207&specialareatype=2&goodsid=V321900000233&returnurl=" + returnURL;
				else if(areaCode.equals("208")) toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=208&specialareatype=2&goodsid=V321000000005&returnurl=" + returnURL;
				else if(areaCode.equals("211")) toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=211&specialareatype=2&goodsid=V329700000058&returnurl=" + returnURL;
				else if(areaCode.equals("214")) toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=214&specialareatype=2&goodsid=V323800000000&returnurl=" + returnURL;
				else if(areaCode.equals("217")) toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=217&specialareatype=2&goodsid=V327100000003&returnurl=" + returnURL;
				else if(areaCode.equals("223")) toUrl = "http://202.99.114.14:15081/integralExchange/recommend.html?userId=" + payUid + "&carrierid=223&specialareatype=2&goodsid=V328500000000&returnurl=" + returnURL;
				// System.out.println("// ==============================================");
				// System.out.println("pay toUrl : " + toUrl);
				
				response.sendRedirect(toUrl);
				return;
			}
		}*/

		// 回调回来后要记得接收用户的所有信息参数,并且清空该session
		Enumeration<String> enumNames = session.getAttributeNames();
		while(enumNames.hasMoreElements()){
			String name = enumNames.nextElement();
			if(name.equals("pay_" + userid)){
				jsdata = session.getAttribute("pay_" + userid).toString();
				session.removeAttribute("pay_" + userid);
			}
		}
	} else if(opera == 2){ // 积分兑换的返回
		String rest = request.getQueryString();
		// System.out.println("// ==============================================");
		// System.out.println("pay rest : " + rest);

		// 回调回来后要记得接收用户的所有信息参数,并且清空该session
		Enumeration<String> enumNames = session.getAttributeNames();
		while(enumNames.hasMoreElements()){
			String name = enumNames.nextElement();
			if(name.equals("pay_" + userid)){
				jsdata = session.getAttribute("pay_" + userid).toString();
				session.removeAttribute("pay_" + userid);
			}
		}
	} else if(opera == 3){ // 河南童锁页面的返回
		String flag = request.getParameter("flag");
		String result = flag.equals("success") ? "0" : "1";
		if(result.equals("0")){ // 解锁成功了,需要跳转订购
			String spid = "96596";
			// 天津联通老计费
			String serviceId = "hlgfby020";
			String productId = "wjyydbhlgf@204";
			String payUrl = "http://202.99.114.14:10020/ACS/vas/serviceorder";
			String payUid = userid + "_" + areaCode;
			payUrl = payUrl + "?SPID=" + spid + "&UserID=" + payUid + "&UserToken=" + userToken + "&Action=1&OrderMode=1&ContinueType=0";
			payUrl = payUrl + "&ServiceID=" + serviceId + "&ProductID=" + productId;
			String returnURL = "http://202.99.114.152:26800/joymusic_cucc_center/pay.jsp?o=1&u=" + userid + "&i=" + userip + "&s=" + songId + "&p=" + pageId + "&k=" + key + "&c=" + cityN + "&a=" + areaCode + "&t=" + userToken + "&st=" + stbType + "&f=" + platform;
			returnURL = URLEncoder.encode(returnURL, "GBK");
			payUrl = payUrl + "&ReturnURL=" + returnURL;
			response.sendRedirect(payUrl);
			return;
		}

		// 回调回来后要记得接收用户的所有信息参数,并且清空该session
		Enumeration<String> enumNames = session.getAttributeNames();
		while(enumNames.hasMoreElements()){
			String name = enumNames.nextElement();
			if(name.equals("pay_" + userid)){
				jsdata = session.getAttribute("pay_" + userid).toString();
				session.removeAttribute("pay_" + userid);
			}
		}
	} else if(opera == 10){ // apply订购准备
		List<Map<String, Object>> li = InfoData.getSongByIds(songId);
		String disN = "'订购'按钮触发";
		if(li.size() > 0) disN = li.get(0).get("cname") == null ? "N/A" : li.get(0).get("cname").toString() + " - " + li.get(0).get("artist").toString();
		saveOrderAll(userip, userid, cityN, "-2", "发起订购续包月(apply)", songId, disN, cname, platform);
		String spid = "96596";
		/*String serviceId = "wjyydb";
		String productId = "xwjyyby020@" + areaCode;
		if(areaCode.equals("204")){ // 河南是wjyydbhlgf@204 智享音乐
			serviceId = "wjyydb";
			productId = "wjyydbhlgf@204";
		}*/
		String serviceId = "hlgfby020";
		String productId = "xwjyyby020@" + areaCode;
		if(areaCode.equals("201")){ // 天津不变成沃家音乐
			serviceId = "hlgfby020";
			productId = "hlgfby010dlrknew@201";
		} else if(areaCode.equals("204")){
			serviceId = "hlgfby020";
			productId = "wjyydbhlgf@204";
		} else if(areaCode.equals("211")){
			serviceId = "wjyydb";
			productId = "xwjyyby020@211";
		}
		String payUid = userid;
		if(!areaCode.equals("201")) payUid = userid + "_" + areaCode;
		String payUrl = "http://202.99.114.14:10020/ACS/vas/serviceorder";
		payUrl = payUrl + "?SPID=" + spid + "&UserID=" + payUid + "&UserToken=" + userToken + "&Action=1&OrderMode=1&ContinueType=0";
		payUrl = payUrl + "&ServiceID=" + serviceId + "&ProductID=" + productId;
		String returnURL = "http://202.99.114.152:26800/joymusic_cucc_center/pay.jsp?o=11&u=" + userid + "&i=" + userip + "&s=" + songId + "&p=" + pageId + "&k=" + key + "&c=" + cityN + "&a=" + areaCode + "&t=" + userToken + "&st=" + stbType + "&f=" + platform;
		returnURL = URLEncoder.encode(returnURL, "GBK");
		payUrl = payUrl + "&ReturnURL=" + returnURL;
		// System.out.println("// ==============================================");
		// System.out.println("pay payUrl : " + payUrl);

		if(areaCode.equals("204")){
			// 判断是否开启了童锁
			boolean flag = isLocked(userid);
			if(flag) return;
		}

		response.sendRedirect(payUrl);
		return;
	} else if(opera == 11){ // apply订购成功通知
		String queryStr = request.getQueryString();
		// System.out.println("// ==============================================");
		// System.out.println("pay queryStr : " + queryStr);
		success = request.getParameter("Result"); // 订购成功与否标志
		List<Map<String, Object>> li = InfoData.getSongByIds(songId);
		String disN = "'订购'按钮触发";
		if(li.size() > 0) disN = li.get(0).get("cname") == null ? "N/A" : li.get(0).get("cname").toString() + " - " + li.get(0).get("artist").toString();
		if("0".equals(success)){
			saveOrderInfo(userip, userid, cityN, "wjyydb", songId, disN, cname, platform);
			saveOrderApply(userip, userid, cityN, "wjyydb", songId, disN, cname, platform);
			saveOrderAll(userip, userid, cityN, "1", "订购成功续包月(apply)", songId, disN, cname, platform);
			// 将退订表状态刷新
			modifyUnsub(userid);
			// 同步订购成功日志
			String result = postJsonLog(userid, areaCode, stbType, String.valueOf(platform), "1", "0", "15");
		} else saveOrderAll(userip, userid, cityN, "-101", "订购失败(apply)", songId, disN, cname, platform);
	}
%>
<%if(opera == 1 || opera == 2 || opera == 3 || opera == 11){%><!DOCTYPE html><%}%>
<%if(opera == 1 || opera == 2 || opera == 3){%>
<html lang='en'>
	<head>
		<meta http-equiv='pragma' content='no-cache'>
		<meta http-equiv='Content-Type' content='text/html;charset=UTF-8' />
		<meta http-equiv='cache-control' content='no-store,no-cache,must-revalidate'>
		<meta http-equiv='expires' content='0'>
		<meta name='page-view-size' content='1280*720'>
		<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
		<title>订购返回</title>
		<script type='text/javascript' src='javascript/jsdata.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/tools.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/extra.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/message.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript'>
			function start(){<%if("0".equals(success)){
				// 由订购按钮触发的返回上一层
				if("0".equals(songId)){%>
					__return();
				<%} else{%>
				put('globle', 'isOrder', '0'); // 用户是否订购 y:否 0:是
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				go(toPageId);
			<%}} else{%>
				put('globle', 'nowRealPlay', '0');
				__return();
			<%}%>}
		</script>
	</head>

	<body bgcolor="transparent"></body>
<%
	JSData data = new JSData();
	if(StringUtils.isNotBlank(jsdata)){
		try {
			if(URLDecoder.decode(jsdata, "UTF-8").indexOf("[{") > -1){
				data.parse(URLDecoder.decode(jsdata, "UTF-8"));
			}
		} catch(Exception ex){
		}
	}
	if(data.getSize() > 0){
		try{
			out.println("\n\t\t<script type='text/javascript'>");
			String[] array = data.toStringArray();
			for(String str : array){
				str = str.replaceAll("\"", "\\\\'");
				if(str.indexOf("request") < 0) out.println("\t\t\t" + str);
			}
			out.println("\t\t</script>");
		} catch(Exception ex){
		}
	}
	out.print("\t\t");
%>
	<script type='text/javascript'>
		start();
	</script>
</html>
<%} else if(opera == 11){%>
<html lang='en'>
	<head>
		<meta http-equiv='pragma' content='no-cache'>
		<meta http-equiv='Content-Type' content='text/html;charset=UTF-8' />
		<meta http-equiv='cache-control' content='no-store,no-cache,must-revalidate'>
		<meta http-equiv='expires' content='0'>
		<meta name='page-view-size' content='1280*720'>
		<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
		<title>订购返回(apply)</title>
		<script type='text/javascript' src='javascript/jsdata.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/tools.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/extra.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/message.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript'>
			function start(){<%if("0".equals(success)){%>
				parent.isOrder = '0';
				parent.clearApply();
			<%} else{%>
				parent.isOrder = 'y';
				parent.clearApply();
			<%}%>}
		</script>
	</head>

	<body bgcolor="transparent"></body>
	<script type='text/javascript'>
		start();
	</script>
</html>
<%}%>