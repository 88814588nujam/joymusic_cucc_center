<%@page import="com.joymusic.api.*,java.util.*,java.net.*,java.io.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	// 获取一个长度len的随机数
	private static String getRadom(int len){
		double rand = Math.random();
		// 将随机数转换为字符串
		String str = String.valueOf(rand).replace("0.", "");
		// 截取字符串
		String newStr = str.substring(0, len);
		return newStr;
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

	// 联通要求上报数据
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

	// 用户信息
	private static Map<String, Object> getUserInfo(String uid) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_info WHERE uid=$uid ORDER BY createtime DESC LIMIT 1";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid });
		li = DB.query(sql, true);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// 用户该条浏览记录保持时长
	private static Map<String, Object> getUserStayTime(String uid, String viewId) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_logs_view WHERE uid=$uid AND viewid=$viewId";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, viewId });
		li = DB.query(sql, false);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}
%>
<%
	int opera = Integer.parseInt(StringUtils.isBlank(request.getParameter("o")) ? "0" : request.getParameter("o").toString()); // 操作类型
	
	if(opera == 0){ // 开始记录
		String userid = request.getParameter("u"); // 用户ID
		String userip = request.getParameter("i"); // 用户IP
		String cityN = request.getParameter("c"); // 用户所属地区
		String pageId = request.getParameter("p"); // 当前页面ID
		String key = request.getParameter("k"); // 页面关键字
		String other = request.getParameter("m"); // 其它(有必要的时候传，通常为空字符串)
		if(StringUtils.isBlank(other)) other = "";
		// 获取页面名称
		String cname = getCname(Integer.parseInt(pageId), key);
		// 生成播放唯一标识
		Date date = new Date();
		String viewId = date.getTime() + getRadom(11);
		int row = 0;
		if(StringUtils.isNotBlank(userid)) row = InfoData.addUserView(userip, userid, cityN, Integer.parseInt(pageId), cname, viewId, other);
		String jsonStr = "{\"row\":\"" + row + "\", \"viewId\":\"" + viewId + "\"}";
		out.print(jsonStr);
		return;
	} else if(opera == 1){ // 结束记录
		String userid = request.getParameter("u"); // 用户ID
		String funIdx = request.getParameter("f"); // 点击触发跳转的页面焦点下标
		String pageId = request.getParameter("p"); // 即将跳转的页面ID
		String key = request.getParameter("k"); // 即将跳转页面的关键字
		String viewId = request.getParameter("v"); // 访问页面唯一标识
		// 获取页面名称
		String cname = getCname(Integer.parseInt(pageId), key);
		int row = 0;
		if(StringUtils.isNotBlank(userid)) row = InfoData.modUserView(userid, viewId, Integer.parseInt(funIdx), Integer.parseInt(pageId), cname);
		String jsonStr = "{\"row\":\"" + row + "\", \"viewId\":\"" + viewId + "\"}";
		// 联通需要上报访问数据
		/* Map<String, Object> gui = getUserInfo(userid);
		if(!gui.isEmpty()){
			String provinceN = gui.get("provinceN").toString();
			String stbType = gui.get("stbType").toString();
			String platform = gui.get("platform").toString();
			Map<String, Object> gust = getUserStayTime(userid, viewId);
			String staylen = gust.get("staylen").toString();
			String result = postJsonLog(userid, provinceN, stbType, platform, "6", "", staylen);
		}*/
		out.print(jsonStr);
		return;
	}
%>