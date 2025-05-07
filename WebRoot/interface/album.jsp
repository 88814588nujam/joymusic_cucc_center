<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"album data error\"}");
		return;
	}
	response.setHeader("Content-type", "application/json");
	response.setHeader("Access-Control-Allow-Origin", "*");
	response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
	response.setHeader("Access-Control-Allow-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type");
	String picQz = "https://txhyxa.njqyfk.com:59001/TXDC/";
	String jsonStr = "";
	String content = "";
	String stbid = "";	
	String referer = request.getHeader("referer");
	if(referer == null){
		BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));
		StringBuffer sb = new StringBuffer("");
		String temp;
		while((temp = br.readLine()) != null) sb.append(temp);
		br.close();
		String params = sb.toString();
		if(StringUtils.isNotBlank(params) && !"{}".equals(params)){
			JSONObject jsonObject = new JSONObject(params);
			content = jsonObject.getString("content");
			stbid = jsonObject.getString("stbid");
		} else{
			out.print("{\"code\":-1, \"data\":[], \"msg\":\"album data error\"}");
			return;
		}
	} else{
		content = StringUtils.isBlank(request.getParameter("c")) ? "" : request.getParameter("c").toString();
		stbid = StringUtils.isBlank(request.getParameter("u")) ? "" : request.getParameter("u").toString();
		if(StringUtils.isBlank(content) || StringUtils.isBlank(stbid)){
			out.print("{\"code\":-1, \"data\":[], \"msg\":\"album data error\"}");
			return;
		}
	}
	// 获取专题详情
	Map<String, Object> gea = getEntityAlbum(content);
	int pid = Integer.parseInt(gea.get("id").toString());
	String cname = gea.get("cname").toString();
	String pic = gea.get("pic").toString();
	String jsonStrTop = "{\"cname\":\"" + cname + "\", \"pic\":\"" + picQz + "images/homeList/album_free/" + pic + "\"}";
	// 获取专题曲目并且判断是否收藏
	List<Map<String, Object>> gaeac = getAlbumEles(pid);
	String josnGaeac = "";
	boolean prefect = true;
	if(gaeac.size() > 0){
		for(int i = 0; i < gaeac.size(); i++){
			Boolean flag = checkCollect(stbid, gaeac.get(i).get("id").toString(), 1);
			String newPic = gaeac.get(i).get("artist_pic") == null ? "default.png" : gaeac.get(i).get("artist_pic").toString();
			int online = Integer.parseInt(gaeac.get(i).get("csort").toString());
			boolean oltmp = online > 0 ? true : false;
			newPic = picQz + "images/artist/c_" + newPic;
			josnGaeac += "{\"content\":\"" + gaeac.get(i).get("id") + "\", \"cname\":\"" + gaeac.get(i).get("cname") + "\", \"artist\":\"" + gaeac.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"collect\":" + flag + ", \"online\":" + oltmp + ", \"cfree\":\"" + gaeac.get(i).get("cfree") + "\"}";
			if(i < gaeac.size() - 1) josnGaeac += ",";
		}
	} else prefect = false;
	if(prefect){
		jsonStr = "{\"top\":" + jsonStrTop + ", \"songList\":[" + josnGaeac + "]}";
		jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"album data success\"}";
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"album data error\"}";
	out.print(jsonStr);
%>
<%!
	// 专题曲目详情
	private List<Map<String, Object>> getAlbumEles(int entryid){
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT B.id, B.cname, B.artist, B.artist_pic, B.cfree, B.csort FROM ui_album_freestyle A, entity_song B WHERE A.pid=$pid AND A.onclick_type=1 AND A.params=B.id ORDER BY A.pos";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(entryid) });
		li = DB.query(sql, true);
		return li;
	}

	// 专题详情
	private Map<String, Object> getEntityAlbum(String keyword){
		Map<String, Object> map = null;
		List<Map<String, Object>> li = null;
		String sql = "SELECT * FROM entity_album WHERE keyword=$keyword";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { keyword });
		li = DB.query(sql, true);
		if(li.size() > 0)
			map = li.get(0);
		return map;
	}

	// 判断用户是否收藏歌曲
	private boolean checkCollect(String uid, String entryEle, int ctype){
		boolean flg = false;
		String sql = "SELECT COUNT(0) FROM user_collect WHERE uid=$uid AND item_type=$ctype AND id_item=$entryid AND csort<>0";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, Integer.valueOf(ctype), entryEle });
		int row = DB.queryCount(sql, false);
		if (row > 0)
			flg = true;
		return flg;
	}
%>
<%@page language="java" import="java.io.*,com.joymusic.api.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>