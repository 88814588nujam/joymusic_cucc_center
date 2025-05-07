<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"check data error\"}");
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
		int platform = jsonObject.getInt("platform");
		int pageIndex = jsonObject.getInt("pageIndex");
		int pageLimit = jsonObject.getInt("pageLimit");
		String retStr = "";
		String josnGal = "";		
		boolean prefect = true;
		int hour = 24;
		int max = 100;
		Map<String, Object> uif = InfoData.getUserInfo(stbid, platform);
		if(!uif.isEmpty()){ // 老用户
			hour = Integer.parseInt(uif.get("hour").toString());
			max = Integer.parseInt(uif.get("max").toString());
		}
		int totalRows = InfoData.getSongsCountByChecked(stbid, hour, max);
		if(totalRows == 0){
			retStr = "{\"totalRows\":\"0\", \"pageTotal\":\"0\", \"pageSum\":\"0\"}";
			jsonStr = "{\"pages\":" + retStr + ", \"contentList\":[" + josnGal + "]}";
			jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"check data success\"}";
			out.print(jsonStr);
			return;
		}
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gsba = InfoData.getSongsByChecked(pages, stbid, hour, max);
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
		if(prefect){
			jsonStr = "{\"pages\":" + retStr + ", \"contentList\":[" + josnGal + "]}";
			jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"check data success\"}";
		} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"check data error\"}";
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"check data error\"}";
	out.print(jsonStr);
%>
<%!
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
<%@page language="java" import="java.io.*,com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>