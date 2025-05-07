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

	// 用户该条点播时长
	private static Map<String, Object> getUserPlayTime(String uid, String playId) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_logs_play WHERE uid=$uid AND playid=$playId";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, playId });
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
		String songId = request.getParameter("s"); // 点播内容
		String durlen = request.getParameter("l"); // 歌曲总长(秒)
		String pageId = request.getParameter("p"); // 当前页面ID
		String key = request.getParameter("k"); // 页面关键字
		String other = request.getParameter("m"); // 其它(有必要的时候传，通常为空字符串)
		if(StringUtils.isBlank(durlen)) durlen = "0";
		if(StringUtils.isBlank(other)) other = "";
		// 获取页面名称
		String cname = getCname(Integer.parseInt(pageId), key);
		if(cname.equals("error")) System.out.println(userid + " || " + userip + " || " + cityN + " || " + songId + " || " + durlen + " || " + pageId + " || " + key + " || " + other);
		// 生成播放唯一标识
		Date date = new Date();
		String playId = date.getTime() + getRadom(11);
		int row = 0;
		if(StringUtils.isNotBlank(userid)) row = InfoData.addUserPlay(userip, userid, cityN, songId, Integer.parseInt(durlen), playId, cname, other);
		String jsonStr = "{\"row\":\"" + row + "\", \"playId\":\"" + playId + "\"}";
		out.print(jsonStr);
		return;
	} else if(opera == 1){ // 结束记录
		String userid = request.getParameter("u"); // 用户ID
		String curlen = request.getParameter("h"); // 当前播放时长(秒)
		if(StringUtils.isBlank(curlen)) curlen = request.getParameter("c"); // 当前播放时长(秒)
		String playId = request.getParameter("y"); // 播放唯一标识
		if(StringUtils.isBlank(playId)) playId = request.getParameter("p"); // 播放唯一标识
		// 有时候会出现播放完毕却记录不到播放时长的可能性,这时候用结束时间减去开始时间作为播放时长
		int tmpCurlen = Integer.parseInt(curlen);
		int docType = 1;
		if(tmpCurlen == 0) docType = 2;
		int row = 0;
		if(StringUtils.isNotBlank(userid)) row = InfoData.modUserPlay(userid, Integer.parseInt(curlen), playId, docType);
		String jsonStr = "{\"row\":\"" + row + "\", \"playId\":\"" + playId + "\"}";
		// 联通需要上报访问数据
		Map<String, Object> gui = getUserInfo(userid);
		if(!gui.isEmpty()){
			String provinceN = gui.get("provinceN").toString();
			String stbType = gui.get("stbType").toString();
			String platform = gui.get("platform").toString();
			Map<String, Object> gust = getUserPlayTime(userid, playId);
			if(!gust.isEmpty()){
				String staylen = gust.get("curlen").toString();
				String songId = gust.get("id_song").toString();
				String result = postJsonLog(userid, provinceN, stbType, platform, "7", songId, staylen);
			}
		}
		out.print(jsonStr);
		return;
	} else if(opera == 2){ // 心跳记录
		String userid = request.getParameter("u"); // 用户ID
		String curlen = request.getParameter("h"); // 当前播放时长(秒)
		if(StringUtils.isBlank(curlen)) curlen = request.getParameter("c"); // 当前播放时长(秒)
		String playId = request.getParameter("y"); // 播放唯一标识
		if(StringUtils.isBlank(playId)) playId = request.getParameter("p"); // 播放唯一标识
		int row = 0;
		if(StringUtils.isNotBlank(userid)) row = InfoData.modUserPlay(userid, Integer.parseInt(curlen), playId, 0);
		String jsonStr = "{\"row\":\"" + row + "\", \"playId\":\"" + playId + "\"}";
		out.print(jsonStr);
		return;
	}
%>