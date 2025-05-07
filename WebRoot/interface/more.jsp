<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"more data error\"}");
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
		int pageIndex = jsonObject.getInt("pageIndex");
		int pageLimit = jsonObject.getInt("pageLimit");
		int totalRows = InfoData.getAlbumListCount();
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gal = InfoData.getAlbumList(pages);
		String retStr = "{\"totalRows\":\"" + totalRows + "\", \"pageTotal\":\"" + pages.getPageTotal() + "\", \"pageSum\":\"" + gal.size() + "\", \"albumList\":[";
		boolean prefect = true;
		if(gal.size() > 0){
			for(int i = 0; i < gal.size(); i++){
				int docI = i + 1;
				String cname = gal.get(i).get("cname").toString();
				String keyword = gal.get(i).get("keyword").toString();
				// 获取专题详情
				Map<String, Object> gea = getEntityAlbum(keyword);
				int pid = Integer.parseInt(gea.get("id").toString());
				String pic = gea.get("pic").toString();
				String jsonStrTop = "{\"content\":\"" + keyword + "\", \"cname\":\"" + cname + "\", \"pic\":\"" + picQz + "images/homeList/album_free/" + pic + "\"}";
				// 获取专题曲目并且判断是否收藏
				List<Map<String, Object>> gaeac = getAlbumEles(pid);
				String josnGaeac = "";
				if(gaeac.size() > 0){
					for(int j = 0; j < gaeac.size(); j++){
						String newPic = gaeac.get(j).get("artist_pic") == null ? "default.png" : gaeac.get(j).get("artist_pic").toString();
						newPic = picQz + "images/artist/c_" + pic;
						josnGaeac += "{\"content\":\"" + gaeac.get(j).get("id") + "\", \"cname\":\"" + gaeac.get(j).get("cname") + "\", \"artist\":\"" + gaeac.get(j).get("artist") + "\", \"pic\":\"" + newPic + "\", \"cfree\":\"" + gaeac.get(j).get("cfree") + "\"}";
						if(j < gaeac.size() - 1) josnGaeac += ",";
					}
				} else prefect = false;
				String jsonListStr = "{\"top\":" + jsonStrTop + ", \"songList\":[]}";
				if(prefect) jsonListStr = "{\"top\":" + jsonStrTop + ", \"songList\":[" + josnGaeac + "]}";
				retStr = retStr + jsonListStr;
				if(i < gal.size() - 1) retStr += ",";
			}
		} else prefect = false;
		retStr += "]}";
		if(prefect) jsonStr = "{\"code\":0, \"data\":" + retStr + ", \"msg\":\"more data success\"}";
		else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"more data error\"}";
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"more data error\"}";
	out.print(jsonStr);
%>
<%!
	// 专题曲目详情
	private List<Map<String, Object>> getAlbumEles(int entryid){
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT B.id, B.cname, B.artist, B.artist_pic, B.cfree FROM ui_album_freestyle A, entity_song B WHERE A.pid=$pid AND A.onclick_type=1 AND A.params=B.id ORDER BY A.pos";
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
%>
<%@page language="java" import="java.io.*,com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>