<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"find data error\"}");
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
		String content = jsonObject.getString("content");
		int pageIndex = jsonObject.getInt("pageIndex");
		int pageLimit = jsonObject.getInt("pageLimit");
		int interType = jsonObject.getInt("interType");
		String retStr = "";
		String josnGal = "";		
		boolean prefect = true;
		int totalRows = getContentsCountBySpell(content, interType);
		if(totalRows == 0){
			retStr = "{\"totalRows\":\"0\", \"pageTotal\":\"0\", \"pageSum\":\"0\"}";
			jsonStr = "{\"pages\":" + retStr + ", \"contentList\":[" + josnGal + "]}";
			jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"find data success\"}";
			out.print(jsonStr);
			return;
		}
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gccbs = getContentsBySpell(pages, content, interType);
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
			jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"find data success\"}";
		} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"find data error\"}";
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"find data error\"}";
	out.print(jsonStr);
%>
<%!
	// 歌曲缩写查询条目数
	private int getContentsCountBySpell(String words, int interType){
		int row = 0;
		String sql = "SELECT COUNT(0) FROM " + (interType == 0 ? "entity_song" : "entity_artist") + " WHERE";
		sql = sql + " cname Like \"%" + words + "%\" AND csort<>0";
		row = DB.queryCount(sql, true);
		return row;
	}

	// 歌曲缩写查询信息
	private List<Map<String, Object>> getContentsBySpell(Page page, String words, int interType){
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM " + (interType == 0 ? "entity_song" : "entity_artist") + " WHERE cname Like \"%" + words + "%\" AND";
		sql = sql + " csort<>0 ORDER BY length(abbr) ASC, id DESC LIMIT " + page.getStartRow() + "," + page.getPageSize();
		li = DB.query(sql, true);
		return li;
	}
%>
<%@page language="java" import="java.io.*,com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>