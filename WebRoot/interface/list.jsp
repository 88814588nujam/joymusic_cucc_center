<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"list data error\"}");
		return;
	}
	response.setHeader("Content-type", "application/json");
	response.setHeader("Access-Control-Allow-Origin", "*");
	response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
	response.setHeader("Access-Control-Allow-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type");
	String picQz = "https://txhyxa.njqyfk.com:59001/TXDC/";
	String jsonStr = "";
	String jsonStrTop = "";
	String retStr = "";
	String josnGal = "";
	String content = "";
	String stbid = "";
	int pageIndex = 1;
	int pageLimit = 15;
	int listType = 0;
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
			listType = jsonObject.getInt("listType");
			pageIndex = jsonObject.getInt("pageIndex");
			pageLimit = jsonObject.getInt("pageLimit");
		} else{
			out.print("{\"code\":-1, \"data\":[], \"msg\":\"list data error\"}");
			return;
		}
	} else{
		content = StringUtils.isBlank(request.getParameter("c")) ? "" : request.getParameter("c").toString();
		stbid = StringUtils.isBlank(request.getParameter("u")) ? "" : request.getParameter("u").toString();
		listType = Integer.parseInt(StringUtils.isBlank(request.getParameter("t")) ? "0" : request.getParameter("t").toString());
		pageIndex = Integer.parseInt(StringUtils.isBlank(request.getParameter("i")) ? "1" : request.getParameter("i").toString());
		pageLimit = Integer.parseInt(StringUtils.isBlank(request.getParameter("l")) ? "15" : request.getParameter("l").toString());
		if(StringUtils.isBlank(content) || StringUtils.isBlank(stbid)){
			out.print("{\"code\":-1, \"data\":[], \"msg\":\"list data error\"}");
			return;
		}
	}
	boolean prefect = true;
	if(listType < 4){
		if(listType == 2){
			int defList = Integer.parseInt(content);
			Map<String, Object> gea = InfoData.getEntityAlbumlist(defList);
			String cname = gea.get("cname").toString();
			String desc = gea.get("cdes").toString();
			String pic = gea.get("pic").toString();
			String pos = gea.get("pic_pos").toString();
			jsonStrTop = "{\"cname\":\"" + cname + "\", \"pic\":\"" + picQz + "images/homeList/album_list/" + pic + "\", \"width\":\"" + pos.split(",")[0] + "\", \"height\":\"" + pos.split(",")[1] + "\", \"desc\":\"" + desc + "\"}";
			int totalRows = InfoData.getSongsCountByRecommend(defList, false);
			Page pages = new Page(totalRows, pageLimit);
			pages.setPageIndex(pageIndex);
			List<Map<String, Object>> gsbr = InfoData.getSongsByRecommend(pages, defList, false);
			retStr = "{\"totalRows\":\"" + totalRows + "\", \"pageTotal\":\"" + pages.getPageTotal() + "\", \"pageSum\":\"" + gsbr.size() + "\"}";
			if(gsbr.size() > 0){
				for(int i = 0; i < gsbr.size(); i++){
					Boolean flag = checkCollect(stbid, gsbr.get(i).get("id").toString(), 1);
					String newPic = gsbr.get(i).get("artist_pic") == null ? "default.png" : gsbr.get(i).get("artist_pic").toString();
					newPic = picQz + "images/artist/c_" + newPic;
					josnGal += "{\"content\":\"" + gsbr.get(i).get("id") + "\", \"cname\":\"" + gsbr.get(i).get("cname") + "\", \"artist\":\"" + gsbr.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"collect\":" + flag + ", \"cfree\":\"" + gsbr.get(i).get("cfree") + "\"}";
					if(i < gsbr.size() - 1) josnGal += ",";
				}
			} else prefect = false;
		} else if(listType == 3){
			int aid = Integer.parseInt(content);
			Map<String, Object> gea = InfoData.getEntityArtist(aid);
			String cname = gea.get("cname").toString();
			String desc = gea.get("cdes").toString();
			String pic = gea.get("pic") == null ? "default.png" : gea.get("pic").toString();
			boolean aFlag = checkCollect(stbid, content, 0);
			jsonStrTop = "{\"cname\":\"" + cname + "\", \"pic\":\"" + picQz + "images/artist/c_" + pic + "\", \"collect\":" + aFlag + ", \"width\":\"200\", \"height\":\"200\", \"desc\":\"" + desc + "\"}";
			int totalRows = InfoData.getSongsCountByArtist(cname);
			Page pages = new Page(totalRows, pageLimit);
			pages.setPageIndex(pageIndex);
			List<Map<String, Object>> gsba = InfoData.getSongsByArtist(pages, cname);
			retStr = "{\"totalRows\":\"" + totalRows + "\", \"pageTotal\":\"" + pages.getPageTotal() + "\", \"pageSum\":\"" + gsba.size() + "\"}";
			if(gsba.size() > 0){
				for(int i = 0; i < gsba.size(); i++){
					Boolean flag = checkCollect(stbid, gsba.get(i).get("id").toString(), 1);
					String newPic = gsba.get(i).get("artist_pic") == null ? "default.png" : gsba.get(i).get("artist_pic").toString();
					newPic = picQz + "images/artist/c_" + newPic;
					josnGal += "{\"content\":\"" + gsba.get(i).get("id") + "\", \"cname\":\"" + gsba.get(i).get("cname") + "\", \"artist\":\"" + gsba.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"collect\":" + flag + ", \"cfree\":\"" + gsba.get(i).get("cfree") + "\"}";
					if(i < gsba.size() - 1) josnGal += ",";
				}
			} else prefect = false;
		} else prefect = false;
		if(prefect){
			jsonStr = "{\"top\":" + jsonStrTop + ", \"pages\":" + retStr + ", \"songList\":[" + josnGal + "]}";
			jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"list data success\"}";
		} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"list data error\"}";
	} else{
		if(listType == 4){
			int defList = Integer.parseInt(content);
			Map<String, Object> gea = InfoData.getEntityAlbumlist(defList);
			String cname = gea.get("cname").toString();
			String desc = gea.get("cdes").toString();
			String pic = gea.get("pic").toString();
			String pos = gea.get("pic_pos").toString();
			jsonStrTop = "{\"cname\":\"" + cname + "\", \"pic\":\"" + picQz + "images/homeList/album_list/" + pic + "\", \"width\":\"" + pos.split(",")[0] + "\", \"height\":\"" + pos.split(",")[1] + "\", \"desc\":\"" + desc + "\"}";
			List<Map<String, Object>> gasbr = getAllSongsByRecommend(defList, false);
			String josnGaeac = "";
			if(gasbr.size() > 0){
				for(int i = 0; i < gasbr.size(); i++){
					String newPic = gasbr.get(i).get("artist_pic") == null ? "default.png" : gasbr.get(i).get("artist_pic").toString();
					newPic = picQz + "images/artist/c_" + newPic;
					josnGaeac += "{\"content\":\"" + gasbr.get(i).get("id") + "\", \"cname\":\"" + gasbr.get(i).get("cname") + "\", \"artist\":\"" + gasbr.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"cfree\":\"" + gasbr.get(i).get("cfree") + "\"}";
					if(i < gasbr.size() - 1) josnGaeac += ",";
				}
			} else prefect = false;
			if(prefect){
				jsonStr = "{\"top\":" + jsonStrTop + ", \"songList\":[" + josnGaeac + "]}";
				jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"list data success\"}";
			} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"list data error\"}";
		} else if(listType == 5){
			int aid = Integer.parseInt(content);
			Map<String, Object> gea = InfoData.getEntityArtist(aid);
			String cname = gea.get("cname").toString();
			String desc = gea.get("cdes").toString();
			String pic = gea.get("pic") == null ? "default.png" : gea.get("pic").toString();
			boolean aFlag = checkCollect(stbid, content, 0);
			jsonStrTop = "{\"cname\":\"" + cname + "\", \"pic\":\"" + picQz + "images/artist/c_" + pic + "\", \"collect\":" + aFlag + ", \"width\":\"200\", \"height\":\"200\", \"desc\":\"" + desc + "\"}";
			List<Map<String, Object>> gasba = InfoData.getAllSongsByArtist(cname);
			String josnGaeac = "";
			if(gasba.size() > 0){
				for(int i = 0; i < gasba.size(); i++){
					String newPic = gasba.get(i).get("artist_pic") == null ? "default.png" : gasba.get(i).get("artist_pic").toString();
					newPic = picQz + "images/artist/c_" + newPic;
					josnGaeac += "{\"content\":\"" + gasba.get(i).get("id") + "\", \"cname\":\"" + gasba.get(i).get("cname") + "\", \"artist\":\"" + gasba.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"cfree\":\"" + gasba.get(i).get("cfree") + "\"}";
					if(i < gasba.size() - 1) josnGaeac += ",";
				}
			} else prefect = false;
			if(prefect){
				jsonStr = "{\"top\":" + jsonStrTop + ", \"songList\":[" + josnGaeac + "]}";
				jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"list data success\"}";
			} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"list data error\"}";
		}
	}
	out.print(jsonStr);
%>
<%!
	// 榜单点歌查询歌曲信息
	private List<Map<String, Object>> getAllSongsByRecommend(int ctype, boolean flag) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT ES.id,ES.cname,ES.artist,ES.artist_pic,ES.cfree,ES.duration FROM recommend_song RS, entity_song ES WHERE";
		sql += " RS.id_song=ES.id AND RS.item_type=$ctype AND RS.csort<>0 AND ES.csort<>0 ORDER BY RS.csort DESC";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(ctype) });
		li = DB.query(sql, flag);
		return li;
	}
	
	// 判断用户是否收藏内容
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
<%@page language="java" import="java.io.*,com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>