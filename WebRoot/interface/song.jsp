<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"song data error\"}");
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
		String stbid = jsonObject.getString("stbid");
		int interType = jsonObject.getInt("interType");
		// interType 0:获取歌曲详情 1:收藏|取消收藏
		if(interType == 0){
			Map<String, Object> gss = InfoData.getSingleSong(content);
			String pic = gss.get("artist_pic") == null ? "default.png" : gss.get("artist_pic").toString();
			String newPic = picQz + "images/artist/c_" + pic;
			jsonStr = "{\"content\":\"" + content + "\", \"cname\":\"" + gss.get("cname") + "\", \"artist\":\"" + gss.get("artist") + "\", \"pic\":\"" + newPic + "\", \"duration\":\"" + gss.get("duration") + "\", \"definition\":\"" + gss.get("definition") + "\", \"cfree\":\"" + gss.get("cfree") + "\"}";
		} else if(interType == 1){
			int row = 0;
			int ckd = 0;
			String collectStr = "";
			if(StringUtils.isNotBlank(stbid)){
				if(StringUtils.isNotBlank(content)) row = InfoData.addToCollect(stbid, content, 1);
				else{ // 删除全部收藏队列
					int rt = InfoData.delToCollect(stbid, 1);
					if(rt > 0) row = -1;
				}
				collectStr = InfoData.getCollectStr(stbid, 1);
				String[] idsCollectStr = collectStr.split(",");
				ckd = collectStr.contains(",") ? idsCollectStr.length : (StringUtils.isBlank(collectStr) ? 0 : 1);
			}
			jsonStr = ("{\"list_num\":\"" + ckd + "\", \"list_ids_str\":\"" + collectStr + "\"}");
		}
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"song data error\"}";
	out.print(jsonStr);
%>
<%@page language="java" import="java.io.*,com.joymusic.api.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>