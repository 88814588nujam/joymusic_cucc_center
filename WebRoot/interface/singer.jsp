<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"singer data error\"}");
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
	String josnGabr = "";
	JSONObject jsonObject = new JSONObject(params);
	if(StringUtils.isNotBlank(params) && !"{}".equals(params)){
		List<Map<String, Object>> gabr = getAllArtists();
		if(gabr.size() > 0){
			char[] chars = new char[26];
			for(int m = 0; m < chars.length; m++){
				char tmpC = (char) ('a' + m);
				String newC = String.valueOf(tmpC);
				String josnBox = "";
				for(int n = 0; n < gabr.size(); n++){
					String pic = gabr.get(n).get("pic").toString();
					String newPic = picQz + "images/artist/c_" + pic;
					String abbr = gabr.get(n).get("abbr").toString();
					abbr = abbr.substring(0, 1);
					if(newC.equals(abbr)){
						String abbrA = abbr.toUpperCase();
						josnBox += "{\"content\":\"" + gabr.get(n).get("id") + "\", \"abbr\":\"" + abbrA + "\", \"cname\":\"" + gabr.get(n).get("cname") + "\", \"pic\":\"" + newPic + "\"},";
					}
				}
				josnGabr = "[" + josnBox + "],";
				jsonStr += josnGabr;
			}
			jsonStr = "{\"code\":0, \"data\":[" + jsonStr + "], \"msg\":\"singer data success\"}";
			jsonStr = jsonStr.replaceAll("\\},\\],\\[", "\\}\\],\\[").replaceAll("\\},\\],\\]", "\\}\\]\\]");
		} else jsonStr = "{\"code\":0, \"data\":[], \"msg\":\"singer data success\"}";
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"singer data error\"}";
	out.print(jsonStr);
%>
<%!
	// 全部在线歌手
	private List<Map<String, Object>> getAllArtists(){
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_artist WHERE csort<>0 ORDER BY abbr";
		li = DB.query(sql, true);
		return li;
	}
%>
<%@page language="java" import="java.io.*,com.joymusic.api.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>