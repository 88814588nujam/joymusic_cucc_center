<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"push data error\"}");
		return;
	}
	response.setHeader("Content-type", "application/json");
	response.setHeader("Access-Control-Allow-Origin", "*");
	response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
	response.setHeader("Access-Control-Allow-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type");
	String picQz = "https://txhyxa.njqyfk.com:59001/TXDC/";
	Page newPageS = new Page(8, 8);
	newPageS.setPageIndex(1);
	int weekList = 10002;
	List<Map<String, Object>> gsbr = InfoData.getSongsByRecommend(newPageS, weekList, false);
	Page newPageA = new Page(5, 5);
	newPageA.setPageIndex(1);
	int hotAList = 10001;
	List<Map<String, Object>> gabr = InfoData.getArtistsByRecommend(newPageA, hotAList, false);
	String jsonStr = "";
	String jsonGsbr = "";
	String jsonGabr = "";
	boolean prefect = true;
	if(gsbr.size() > 0){
		for(int i = 0; i < gsbr.size(); i++){
			String newPic = gsbr.get(i).get("artist_pic") == null ? "default.png" : gsbr.get(i).get("artist_pic").toString();
			newPic = picQz + "images/artist/c_" + newPic;
			jsonGsbr += "{\"content\":\"" + gsbr.get(i).get("id") + "\", \"cname\":\"" + gsbr.get(i).get("cname") + "\", \"artist\":\"" + gsbr.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"cfree\":\"" + gsbr.get(i).get("cfree") + "\"}";
			if(i < gsbr.size() - 1) jsonGsbr += ",";
		}
	} else prefect = false;
	if(gabr.size() > 0){
		for(int i = 0; i < gabr.size(); i++){
			String newPic = gabr.get(i).get("pic") == null ? "default.png" : gabr.get(i).get("pic").toString();
			newPic = picQz + "images/artist/c_" + newPic;
			jsonGabr += "{\"content\":\"" + gabr.get(i).get("id") + "\", \"cname\":\"" + gabr.get(i).get("cname") + "\", \"pic\":\"" + newPic + "\"}";
			if(i < gabr.size() - 1) jsonGabr += ",";
		}
	} else prefect = false;
	if(prefect){
		jsonStr = "{\"songList\":[" + jsonGsbr + "], \"singerList\":[" + jsonGabr + "], \"push\":{\"pic\":\"" + picQz + "images/push/push.jpg\"}}";
		jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"push data success\"}";
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"push data error\"}";
	out.print(jsonStr);
%>
<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>