<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"collect data error\"}");
		return;
	}
	response.setHeader("Content-type", "application/json");
	response.setHeader("Access-Control-Allow-Origin", "*");
	response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
	response.setHeader("Access-Control-Allow-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type");
	String picQz = "https://txhyxa.njqyfk.com:59001/TXDC/";
	BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));
	StringBuffer sb = new StringBuffer("");
	String temp;
	while((temp = br.readLine()) != null) sb.append(temp);
	br.close();
	String params = sb.toString();
	String jsonStr = "";
	JSONObject jsonObject = new JSONObject(params);
	if(StringUtils.isNotBlank(params) && !"{}".equals(params)){
		String stbid = jsonObject.getString("stbid");
		int interType = jsonObject.getInt("interType");
		int pageIndex = jsonObject.getInt("pageIndex");
		int pageLimit = jsonObject.getInt("pageLimit");
		String retStr = "";
		String josnGal = "";		
		boolean prefect = true;
		int totalRows = interType == 0 ? getSongsCountByCollect(stbid) : getArtistsCountByCollect(stbid);
		if(totalRows == 0){
			retStr = "{\"totalRows\":\"0\", \"pageTotal\":\"0\", \"pageSum\":\"0\"}";
			jsonStr = "{\"pages\":" + retStr + ", \"contentList\":[" + josnGal + "]}";
			jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"collect data success\"}";
			out.print(jsonStr);
			return;
		}
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gccbs = interType == 0 ? getSongsByCollect(pages, stbid) : getArtistsByCollect(pages, stbid);
		if(interType == 0){
			retStr = "{\"totalRows\":\"" + totalRows + "\", \"pageTotal\":\"" + pages.getPageTotal() + "\", \"pageSum\":\"" + gccbs.size() + "\"}";
			if(gccbs.size() > 0){
				for(int i = 0; i < gccbs.size(); i++){
					String newPic = gccbs.get(i).get("artist_pic") == null ? "default.png" : gccbs.get(i).get("artist_pic").toString();
					newPic = picQz + "images/artist/c_" + newPic;
					josnGal += "{\"content\":\"" + gccbs.get(i).get("id") + "\", \"cname\":\"" + gccbs.get(i).get("cname") + "\", \"artist\":\"" + gccbs.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"cfree\":\"" + gccbs.get(i).get("cfree") + "\"}";
					if(i < gccbs.size() - 1) josnGal += ",";
				}
			} else prefect = false;
		} else if(interType == 1){
			retStr = "{\"totalRows\":\"" + totalRows + "\", \"pageTotal\":\"" + pages.getPageTotal() + "\", \"pageSum\":\"" + gccbs.size() + "\"}";
			if(gccbs.size() > 0){
				for(int i = 0; i < gccbs.size(); i++){
					String newPic = gccbs.get(i).get("pic") == null ? "default.png" : gccbs.get(i).get("pic").toString();
					newPic = picQz + "images/artist/c_" + newPic;
					josnGal += "{\"content\":\"" + gccbs.get(i).get("id") + "\", \"cname\":\"" + gccbs.get(i).get("cname") + "\", \"pic\":\"" + newPic + "\"}";
					if(i < gccbs.size() - 1) josnGal += ",";
				}
			} else prefect = false;
		}
		if(prefect){
			jsonStr = "{\"pages\":" + retStr + ", \"contentList\":[" + josnGal + "]}";
			jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"collect data success\"}";
		} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"collect data error\"}";
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"collect data error\"}";
	out.print(jsonStr);
%>
<%!
	// 收藏歌曲条目
	private int getSongsCountByCollect(String uid){
		int row = 0;
		String sql = "SELECT COUNT(0) FROM user_collect A, entity_song B WHERE A.id_item=B.id AND";
		sql = sql + " A.uid=$uid AND A.item_type=1 AND A.csort<>0 AND B.csort<>0";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		row = DB.queryCount(sql, false);
		return row;
	}

	// 收藏歌曲信息
	private List<Map<String, Object>> getSongsByCollect(Page page, String uid){
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_collect A, entity_song B WHERE A.id_item=B.id AND";
		sql = sql + " A.uid=$uid AND A.item_type=1 AND A.csort<>0 AND B.csort<>0";
		sql = sql + " ORDER BY A.csort DESC LIMIT " + page.getStartRow() + "," + page.getPageSize();
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		li = DB.query(sql, false);
		return li;
	}
	
	// 收藏歌手条目
	private int getArtistsCountByCollect(String uid){
		int row = 0;
		String sql = "SELECT COUNT(0) FROM user_collect A, entity_artist B WHERE A.id_item=B.id AND";
		sql = sql + " A.uid=$uid AND A.item_type=0 AND A.csort<>0 AND B.csort<>0";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		row = DB.queryCount(sql, false);
		return row;
	}

	// 收藏歌手信息
	private List<Map<String, Object>> getArtistsByCollect(Page page, String uid){
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_collect A, entity_artist B WHERE A.id_item=B.id AND";
		sql = sql + " A.uid=$uid AND A.item_type=0 AND A.csort<>0 AND B.csort<>0";
		sql = sql + " ORDER BY A.csort DESC LIMIT " + page.getStartRow() + "," + page.getPageSize();
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		li = DB.query(sql, false);
		return li;
	}
%>
<%@page language="java" import="java.io.*,com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>