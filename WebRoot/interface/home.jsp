<%
	String method = request.getMethod();
	if(!method.equals("POST")){
		out.print("{\"code\":-1, \"data\":[], \"msg\":\"home data error\"}");
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
		String provinceN = jsonObject.getString("provinceN");
		int interType = jsonObject.getInt("interType");
		// 获取界面推荐的参数
		int[] orUiIdx = {1};
		int[] orUiIdx0 = {1, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
		int[] uiParms;
		if(StringUtils.isNotBlank(provinceN)) uiParms = (int[]) orUiIdx0.clone();
		else uiParms = (int[]) orUiIdx.clone();
		List<Map<String, Object>> guir = InfoData.getUiIndexRecommend(uiParms);
		// interType 0:返回首页全文 1:返回头部marquee
		if(interType == 0){
			List<Map<String, Object>> geal = getEntityAlbumlist();
			List<Map<String, Object>> gea = getEntityAlbum(6);
			Page newPageS = new Page(6, 6);
			newPageS.setPageIndex(1);
			// 人气飙升 10006 recommend_song
			// 麦霸必点 10007 recommend_song
			int upList = 10006;
			int mustList = 10007;
			List<Map<String, Object>> gsbr1 = InfoData.getSongsByRecommend(newPageS, upList, false);
			List<Map<String, Object>> gsbr2 = InfoData.getSongsByRecommend(newPageS, mustList, false);
			Page newPageA = new Page(8, 8);
			newPageA.setPageIndex(1);
			// 人气歌手 10000 recommend_artist
			int popAList = 10000;
			List<Map<String, Object>> gabr = InfoData.getArtistsByRecommend(newPageA, popAList, false);
			String jsonStrTop = "";
			String jsonStrNav = "";
			String jsonStrAlbum = "";
			String josnGsbr1 = "";
			String josnGsbr2 = "";
			String josnGabr = "";
			boolean prefect = true;
			if(guir.size() > 0){
				for(int i = 0; i < 5; i++){
					String pic = guir.get(i).get("pic").toString();
					String[] pics = pic.split("_");
					String[] dots = pic.split("\\.");
					String newPic = pics[0] + "_" + pics[1] + "." + dots[1];
					jsonStrTop += "{\"type\":" + guir.get(i).get("onclick_type") + ", \"content\":\"" + guir.get(i).get("params").toString().replace("k=", "") + "\", \"pic\":\"" + picQz + "images/homeList/recommend/" + newPic + "?r=" + Math.random() + "\"}";
					if(i < 4) jsonStrTop += ",";
				}
			} else prefect = false;
			if(geal.size() > 0){
				for(int i = 0; i < geal.size(); i++){
					jsonStrNav += "{\"content\":\"" + geal.get(i).get("id") + "\", \"txt\":\"" + geal.get(i).get("cname").toString().replace("榜", "") + "\", \"pic\":\"" + picQz + "images/homeList/nav/" + geal.get(i).get("pic").toString().replace("_", "") + "?r=" + Math.random() + "\"}";
					if(i < geal.size() - 1) jsonStrNav += ",";
				}
			} else prefect = false;
			if(gea.size() > 0){
				for(int i = 0; i < gea.size(); i++){
					String pic = gea.get(i).get("pic").toString();
					jsonStrAlbum += "{\"content\":\"" + gea.get(i).get("keyword") + "\", \"pic\":\"" + picQz + "images/homeList/recommend/" + pic + "?r=" + Math.random() + "\"}";
					if(i < gea.size() - 1) jsonStrAlbum += ",";
				}
			} else prefect = false;
			if(gsbr1.size() > 0){
				for(int i = 0; i < gsbr1.size(); i++){
					String pic = gsbr1.get(i).get("artist_pic") == null ? "default.png" : gsbr1.get(i).get("artist_pic").toString();
					String newPic = picQz + "images/artist/c_" + pic;
					josnGsbr1 += "{\"content\":\"" + gsbr1.get(i).get("id") + "\", \"cname\":\"" + gsbr1.get(i).get("cname") + "\", \"artist\":\"" + gsbr1.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"cfree\":\"" + gsbr1.get(i).get("cfree") + "\"}";
					if(i < gsbr1.size() - 1) josnGsbr1 += ",";
				}
			} else prefect = false;
			if(gsbr2.size() > 0){
				for(int i = 0; i < gsbr2.size(); i++){
					String pic = gsbr2.get(i).get("artist_pic") == null ? "default.png" : gsbr2.get(i).get("artist_pic").toString();
					String newPic = picQz + "images/artist/c_" + pic;
					josnGsbr2 += "{\"content\":\"" + gsbr2.get(i).get("id") + "\", \"cname\":\"" + gsbr2.get(i).get("cname") + "\", \"artist\":\"" + gsbr2.get(i).get("artist") + "\", \"pic\":\"" + newPic + "\", \"cfree\":\"" + gsbr2.get(i).get("cfree") + "\"}";
					if(i < gsbr2.size() - 1) josnGsbr2 += ",";
				}
			} else prefect = false;
			if(gabr.size() > 0){
				for(int i = 0; i < gabr.size(); i++){
					String pic = gabr.get(i).get("pic").toString();
					String newPic = picQz + "images/artist/c_" + pic;
					josnGabr += "{\"content\":\"" + gabr.get(i).get("id") + "\", \"cname\":\"" + gabr.get(i).get("cname") + "\", \"pic\":\"" + newPic + "\"}";
					if(i < gabr.size() - 1) josnGabr += ",";
				}
			} else prefect = false;
			if(prefect){
				jsonStr = "{\"top\":[" + jsonStrTop + "], \"nav\":[" + jsonStrNav + "], \"album\":[" + jsonStrAlbum + "], \"upList\":[" + josnGsbr1 + "], \"mustList\":[" + josnGsbr2 + "], \"popAList\":[" + josnGabr + "]}";
				jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"home data success\"}";
			} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"home data error\"}";
		} else{
			String jsonStrTop = "";
			boolean prefect = true;
			if(guir.size() > 0){
				for(int i = 0; i < 5; i++){
					String pic = guir.get(i).get("pic").toString();
					String[] pics = pic.split("_");
					String[] dots = pic.split("\\.");
					String newPic = pics[0] + "_" + pics[1] + "." + dots[1];
					jsonStrTop += "{\"type\":" + guir.get(i).get("onclick_type") + ", \"content\":\"" + guir.get(i).get("params").toString().replace("k=", "") + "\", \"pic\":\"" + picQz + "images/homeList/recommend/" + newPic + "?r=" + Math.random() + "\"}";
					if(i < 4) jsonStrTop += ",";
				}
			} else prefect = false;
			if(prefect){
				jsonStr = "{\"top\":[" + jsonStrTop + "]}";
				jsonStr = "{\"code\":0, \"data\":" + jsonStr + ", \"msg\":\"home data success\"}";
			} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"home data error\"}";
		}
	} else jsonStr = "{\"code\":-1, \"data\":[], \"msg\":\"home data error\"}";
	out.print(jsonStr);
%>
<%!
	// 歌曲列表详情
	private List<Map<String, Object>> getEntityAlbumlist(){
		List<Map<String, Object>> li = null;
		String sql = "SELECT * FROM entity_albumlist WHERE id<10006";
		li = DB.query(sql, true);
		return li;
	}
	
	// 专题列表详情
	private List<Map<String, Object>> getEntityAlbum(int lmt){
		List<Map<String, Object>> li = null;
		String sql = "SELECT * FROM entity_album ORDER BY createtime DESC, id DESC limit " + lmt;
		li = DB.query(sql, false);
		return li;
	}
%>
<%@page language="java" import="java.io.*,com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>