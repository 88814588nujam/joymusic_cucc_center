<%@page language="java" import="java.text.SimpleDateFormat,com.joymusic.api.*,com.joymusic.common.*,java.security.*,java.net.*,java.io.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	// 河南有童锁功能
	private boolean isLocked(String u){
		boolean flag = false;
        BufferedReader reader = null;
		try{
			URL url = new URL("http://202.99.114.14:15081/hn/querySafetylockSts");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setRequestProperty("Charset", "UTF-8");
			// 设置文件类型
			conn.setRequestProperty("Content-Type","application/json; charset=UTF-8");
			conn.setRequestProperty("accept","application/json");
			// 往服务器里面发送数据
			OutputStream outwritestream = conn.getOutputStream();
			String nowT = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
			String sign = toString(md5Private(("yturtyyt" + nowT).getBytes())).toLowerCase();
			String productId = "hlgfby020@204";
			String jsonStr = "{\"productId\":\"" + productId + "\",\"loginAccount\":\"" + u + "\",\"appId\":\"cp0014\",\"time\":\"" + nowT + "\",\"sign\":\"" + sign + "\"}";
			outwritestream.write(jsonStr.getBytes());
			outwritestream.flush();
			outwritestream.close();
			if(conn.getResponseCode() == 200){
				reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String result = reader.readLine();
				result = result.substring(result.indexOf("\"returncode\":") + "\"returncode\":".length(), result.indexOf(",\"returnmsg\":\""));
				if(result.equals("1")){
					flag = true;
				}
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return flag;
	}
	
	private byte[] md5Private(byte[] cs){
		byte[] rs = null;
	      try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			rs = md.digest(cs);
		} catch(Exception e) {
			e.printStackTrace();
		} 
		return rs;
	}
	
	private String toString(byte[] a){
        if (a == null)
            return "null";
        if (a.length == 0)
            return "";
 
        StringBuilder buf = new StringBuilder();
        for (int i = 0; i < a.length; i++) {
        	if (a[i] < 0)
        		buf.append(Integer.toHexString(a[i]&0xff));
        	else if (a[i] < 16) {
        		buf.append('0');
        		buf.append(Integer.toHexString(a[i]));
        	} else {
        		buf.append(Integer.toHexString(a[i]));
        	}
        }
        return buf.toString();
    }

	// 包月鉴权正式计费的
	static String authResult(String u, String t, String p){
		String rt = "y";
        BufferedReader reader = null;
		try{
			String spid = "96596";
			String serviceId = "wjyydb,hlgfby020,wjyyby,musicby020";
			if(p.equals("211") || p.equals("217")) serviceId += ",hlgfac030";
			if(!p.equals("201")) u = u + "_" + p;
			String[] serviceIds = serviceId.split(",");
			for(String tmpSer : serviceIds){
				String authUrl = "http://202.99.114.14:10020/ACS/vas/authorization";
				URL url = new URL(authUrl);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("POST");
				conn.setDoOutput(true);
				conn.setDoInput(true);
				conn.setUseCaches(false);
				conn.setRequestProperty("Connection", "Keep-Alive");
				conn.setRequestProperty("Charset", "UTF-8");
				// 设置文件类型
				conn.setRequestProperty("Content-Type","application/json; charset=UTF-8");
				conn.setRequestProperty("accept","application/json");
				// 往服务器里面发送数据
				OutputStream outwritestream = conn.getOutputStream();
				String jsonStr  = "{\"spId\":\"" + spid + "\",\"carrierId\":\"" + p + "\",\"userId\":\"" + u + "\",\"userToken\":\"" + t + "\",\"serviceId\":\"" + tmpSer + "\",\"timeStamp\":\"" + new Date().getTime() + "\"}";
				outwritestream.write(jsonStr.getBytes());
				outwritestream.flush();
				outwritestream.close();
				if(conn.getResponseCode() == 200){
					reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
					String result = reader.readLine();
					result = result.substring(result.indexOf("\"result\":") + "\"result\":".length());
					result = result.substring(0, result.indexOf(","));
					if(result.equals("0")){
						rt = "0";
						break;
					}
				}
				Thread.sleep(500);
			}
		} catch(Exception e){
		}
		return rt;
	}

	private Boolean getOutTime(String u){
		Boolean flag = false;
		try{
			String createtime = "2000-01-01 00:00:00";
			List<Map<String, Object>> li = null;
			String sql = "SELECT * FROM zone_user_pay_unsub WHERE uid='" + u + "' AND inline=1 ORDER BY id DESC LIMIT 1";
			li = DB.query(sql, false);
			if(li.size() > 0){
				createtime = li.get(0).get("createtime").toString().substring(0, 19);
				long nowDate = new Date().getTime();
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date exdateTime = formatter.parse(createtime);
				long exDate = exdateTime.getTime();
				int diffSeconds = (int) ((nowDate - exDate) / 1000);
				// 反悔订购时间为1小时，超过1小时后退订只会取消续订
				if(diffSeconds > 3600) flag = true;
			}
		} catch(Exception e){
		}
		return flag;
	}
%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_index_10" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	String backPos = StringUtils.isBlank(DoParam.AnalysisAbb("b", request)) ? "0" : DoParam.AnalysisAbb("b", request);
	String marSort = StringUtils.isBlank(DoParam.AnalysisAbb("m", request)) ? "1" : DoParam.AnalysisAbb("m", request);
	// 创建页面焦点元素
	String imgSrcTop = "images/application/pages/index/commonly/";
	String imgSrcPage = "images/application/pages/index/page1/";
	List<JSONObject> pageT = new ArrayList<JSONObject>();
	pageT.add(createBox(1, 779, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "search.png", imgSrcTop + "focus/f_search.png", false));
	pageT.add(createBox(2, 875, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "collect.png", imgSrcTop + "focus/f_collect.png", false));
	pageT.add(createBox(3, 970, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "history.png", imgSrcTop + "focus/f_history.png", false));
	pageT.add(createBox(4, 1066, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "setting.png", imgSrcTop + "focus/f_setting.png", false));
	pageT.add(createBox(5, 88, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "karaoke.png", imgSrcTop + "focus/f_karaoke.png", false));
	pageT.add(createBox(6, 305, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "status/c_f_recommend.png", imgSrcTop + "focus/f_recommend.png", false));
	pageT.add(createBox(7, 522, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "kids.png", imgSrcTop + "focus/f_kids.png", false));
	pageT.add(createBox(8, 739, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "nostalgia.png", imgSrcTop + "focus/f_nostalgia.png", false));
	pageT.add(createBox(9, 956, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "tiktok.png", imgSrcTop + "focus/f_tiktok.png", false));
	pageT.add(createBox(10, 60, 178, 420, 236, 447, 263, 0, 0, imgSrcPage + "420_236.png", imgSrcPage + "focus/f_447_263.png", false));
	pageT.add(createBox(11, 490, 178, 453, 236, 480, 263, 0, 0, imgSrcPage + "453_236.png", imgSrcPage + "focus/f_480_263.png", true));
	pageT.add(createBox(12, 953, 178, 267, 236, 294, 263, 0, 0, imgSrcPage + "267_236.png", imgSrcPage + "focus/f_294_263.png", true));
	pageT.add(createBox(13, 60, 424, 205, 186, 232, 213, 0, 0, imgSrcPage + "205_186.png", imgSrcPage + "focus/f_232_213.png", true));
	pageT.add(createBox(14, 275, 424, 205, 186, 232, 213, 0, 0, imgSrcPage + "205_186.png", imgSrcPage + "focus/f_232_213.png", true));
	pageT.add(createBox(15, 490, 424, 453, 186, 480, 213, 0, 0, imgSrcPage + "453_186.png", imgSrcPage + "focus/f_480_213.png", true));
	pageT.add(createBox(16, 953, 424, 267, 186, 294, 213, 0, 0, imgSrcPage + "free.png", imgSrcPage + "focus/f_294_213.png", false));
	pageT.add(createBox(17, 60, 693, 220, 220, 235, 235, 0, 0, imgSrcPage + "movie.png", imgSrcPage + "focus/f_235_235.png", false));
	pageT.add(createBox(18, 60, 923, 220, 220, 235, 235, 0, 0, imgSrcPage + "kids.png", imgSrcPage + "focus/f_235_235.png", false));
	pageT.add(createBox(19, 645, 693, 220, 220, 235, 235, 0, 0, imgSrcPage + "classic.png", imgSrcPage + "focus/f_235_235.png", false));
	pageT.add(createBox(20, 645, 923, 220, 220, 235, 235, 0, 0, imgSrcPage + "pop.png", imgSrcPage + "focus/f_235_235.png", false));
	pageT.add(createBox(21, 278, 737, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(22, 278, 793, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(23, 278, 849, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(24, 278, 905, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(25, 278, 961, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(26, 278, 1017, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(27, 864, 737, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(28, 864, 793, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(29, 864, 849, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(30, 864, 905, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(31, 864, 961, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(32, 864, 1017, 371, 79, 371, 79, 0, 0, imgSrcPage + "null.png", imgSrcPage + "focus/f_371_79.png", false));
	pageT.add(createBox(33, 289, 1097, 145, 42, 171, 68, 0, 0, imgSrcPage + "playall.png", imgSrcPage + "focus/f_171_68.png", false));
	pageT.add(createBox(34, 490, 1097, 145, 42, 171, 68, 0, 0, imgSrcPage + "more.png", imgSrcPage + "focus/f_171_68.png", false));
	pageT.add(createBox(35, 874, 1097, 145, 42, 171, 68, 0, 0, imgSrcPage + "playall.png", imgSrcPage + "focus/f_171_68.png", false));
	pageT.add(createBox(36, 1075, 1097, 145, 42, 171, 68, 0, 0, imgSrcPage + "more.png", imgSrcPage + "focus/f_171_68.png", false));
	pageT.add(createBox(37, 60, 1225, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(38, 260, 1225, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(39, 460, 1225, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(40, 660, 1225, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(41, 860, 1225, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(42, 1060, 1225, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(43, 60, 1449, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(44, 260, 1449, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(45, 460, 1449, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(46, 660, 1449, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(47, 860, 1449, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(48, 1060, 1449, 160, 160, 186, 186, 0, 0, imgSrcPage + "160_160.png", imgSrcPage + "focus/f_186_186.png", false));
	pageT.add(createBox(49, 60, 1737, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(50, 450, 1737, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(51, 840, 1737, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(52, 60, 1967, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(53, 450, 1967, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(54, 840, 1967, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(55, 60, 2261, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(56, 294, 2261, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(57, 528, 2261, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(58, 762, 2261, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(59, 996, 2261, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(60, 60, 2631, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(61, 450, 2631, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(62, 840, 2631, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(63, 60, 2861, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(64, 450, 2861, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(65, 840, 2861, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(66, 60, 3155, 1160, 271, 1186, 297, 0, 0, imgSrcPage + "1160_271.png", imgSrcPage + "focus/f_1186_297.png", false));
	pageT.add(createBox(67, 60, 3436, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(68, 294, 3436, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(69, 528, 3436, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(70, 762, 3436, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(71, 996, 3436, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(72, 60, 3809, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	pageT.add(createBox(73, 353, 3809, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	pageT.add(createBox(74, 645, 3809, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	pageT.add(createBox(75, 938, 3809, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	pageT.add(createBox(76, 60, 3989, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	pageT.add(createBox(77, 353, 3989, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	pageT.add(createBox(78, 645, 3989, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	pageT.add(createBox(79, 938, 3989, 282, 170, 308, 196, 0, 0, imgSrcPage + "282_170.png", imgSrcPage + "focus/f_308_196.png", true));
	
	// 获取推荐位对应的元素
	String idxForDoc = "";
	for(int i = 0; i < pageT.size(); i++){
		JSONObject part = pageT.get(i);
		if(Boolean.parseBoolean(part.get("flag").toString())){
			int realIdx = i + 1;
			idxForDoc += realIdx + ",";
		}
	}
	if(idxForDoc.contains(",")) idxForDoc = idxForDoc.substring(0, idxForDoc.lastIndexOf(","));
	String[] idxForDocArr = idxForDoc.split(",");
	
	Page newPageS = new Page(6, 6);
	newPageS.setPageIndex(1);
	List<Map<String, Object>> gsbr1 = InfoData.getSongsByRecommend(newPageS, weekList, false);
	List<Map<String, Object>> gsbr2 = InfoData.getSongsByRecommend(newPageS, newList, false);
	Page newPageA = new Page(12, 12);
	newPageA.setPageIndex(1);
	List<Map<String, Object>> gabr = InfoData.getArtistsByRecommend(newPageA, popAList, false);
	
%><%@include file="common/head.jsp" %>
<% 
	// 获取界面推荐的参数
	int[] orUiIdx = {pageId};
	int[] orUiIdx0 = {pageId, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
	int[] uiParms;
	if(StringUtils.isNotBlank(provinceN)) uiParms = (int[]) orUiIdx0.clone();
	else uiParms = (int[]) orUiIdx.clone();
	// 获取界面轮播的参数
	int[] orUiIdxMar = {1001};
	int[] orUiIdxMar0 = {1001, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
	int[] uiParms0;
	if(StringUtils.isNotBlank(provinceN)) uiParms0 = (int[]) orUiIdxMar0.clone();
	else uiParms0 = (int[]) orUiIdxMar.clone();
	// 获取界面小视频
	int[] orUiIdxVod = {10001};
	int[] orUiIdxVod0 = {10001, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
	int[] uiParms1;
	if(StringUtils.isNotBlank(provinceN)) uiParms1 = (int[]) orUiIdxVod0.clone();
	else uiParms1 = (int[]) orUiIdxVod.clone();
	List<Map<String, Object>> guirVod = InfoData.getUiIndexRecommend(uiParms1);
	String songIdxs = "10001";
	if(guirVod.size() > 0){
		songIdxs = guirVod.get(0).get("params").toString();
	}
	List<Map<String, Object>> gsba = InfoData.getSongByIds(songIdxs);
	Collections.shuffle(gsba);

	String picName = "";
	boolean flag = false;
	String elePicStr = "44,52,683,10";
	// 天津和河南追加特殊按钮
	if(provinceN.equals("201")){
		picName = "order.png";
		// 是否订购过 y:未订购 0:订购
		String isOrder = StringUtils.isBlank(DoParam.Analysis("globle", "isOrder", request)) ? "y" : DoParam.Analysis("globle", "isOrder", request);
		boolean isOutTime = false;
		if(isOrder.equals("y")){
			// 如果鉴权结果是y:未订购的话，最好再去鉴权确认一下
			isOrder = authResult(userid, userToken, provinceN);
			if(isOrder.equals("0")){
				// 鉴权结果是订购的话，需要差异判断厮显示已订购还是退订
				isOutTime = getOutTime(userid);
				if(isOutTime) picName = "ex201.png";
				else picName = "unsub.png";
			}
		} else{
			// 鉴权结果是订购的话，需要差异判断厮显示已订购还是退订
			isOutTime = getOutTime(userid);
			if(isOutTime) picName = "ex201.png";
			else picName = "unsub.png";
		}
	} else if(provinceN.equals("204")){
		flag = isLocked(userid);
		if(!flag) picName = "lock.png";
		else picName = "lock0.png";
	} else picName = "null.png";
	if(picName.equals("ex201.png")) elePicStr = "135,33,275,0";
	String[] elePic = elePicStr.split(",");
%>
		<script type='text/javascript'>
			// 用户ID
			var userid = '<%=userid %>';
			// 用户IP
			var userip = '<%=userip %>';
			// 用户临时token
			var userToken = '<%=userToken %>';
			// 用户平台
			var platform = <%=platform %>;
			// 用户省份编号
			var provinceN = '<%=provinceN %>';
			// 用户城市编号
			var cityN = '<%=cityN %>';
			// 实际应用显示尺寸
			var pageW = <%=pageW %>;
			var pageH = <%=pageH %>;
			// 机顶盒型号|机顶盒版本
			var stbType = '<%=stbType %>';
			var stbVersion = '<%=stbVersion %>';
			// 当前焦点
			var nowFocus = '<%=nowFocus %>';
			// 当前页码ID
			var pageId = <%=pageId %>;
			// 载入页面滑动的位置
			var backPos = <%=backPos %>;
			// 允许按键
			var allowClick = true;
			// 滑动频率
			var frequency = 10;
			// 用户偏好列表
			var preferList = <%=preferList %>;
			// %2=0:时间冒号闪烁灭 %2=1:时间冒号闪烁亮
			var twinkle = 0;
			// 定时器获取时间
			var nowTime = setInterval(function(){twinkle++; getNowFormatDate(twinkle);}, 500);
			// 载入推荐位
			var jsonRec = [
				<%List<Map<String, Object>> guir = InfoData.getUiIndexRecommend(uiParms);if(guir.size() > 0){for(int i = 0; i < guir.size(); i++){out.print("{'idx':'" + idxForDocArr[i] + "', 'pos':'" + guir.get(i).get("pos") + "','w':'" + guir.get(i).get("w") + "', 'h':'" + guir.get(i).get("h") + "', 'pic':'" + guir.get(i).get("pic") + "', 'pic_word':'" + guir.get(i).get("pic_word") + "', 'pic_word_color':'" + guir.get(i).get("pic_word_color") + "', 'onclick_type':'" + guir.get(i).get("onclick_type") + "', 'curl':'" + guir.get(i).get("curl") + "', 'params':'" + guir.get(i).get("params") + "', 'createtime':'" + guir.get(i).get("createtime").toString().substring(0, 19) + "'}"); if(i < guir.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 载入轮播推荐位
			var jsonMarRec = [
				<%List<Map<String, Object>> guir1 = InfoData.getUiIndexRecommend(uiParms0);if(guir1.size() > 0){for(int i = 0; i < guir1.size(); i++){out.print("{'pic':'" + guir1.get(i).get("pic") + "', 'pic_word':'" + guir1.get(i).get("pic_word") + "', 'pic_word_color':'" + guir1.get(i).get("pic_word_color") + "', 'onclick_type':'" + guir1.get(i).get("onclick_type") + "', 'curl':'" + guir1.get(i).get("curl") + "', 'params':'" + guir1.get(i).get("params") + "', 'createtime':'" + guir1.get(i).get("createtime").toString().substring(0, 19) + "'}"); if(i < guir1.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 载入一周热歌榜
			var jsonSong1 = [
				<%if(gsbr1.size() > 0){for(int i = 0; i < gsbr1.size(); i++){out.print("{'sid':'" + gsbr1.get(i).get("id") + "', 'cname':'" + gsbr1.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbr1.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'artistPic':'" + gsbr1.get(i).get("artist_pic") + "', 'cfree':'" + gsbr1.get(i).get("cfree") + "'}"); if(i < gsbr1.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 载入新歌速递榜
			var jsonSong2 = [
				<%if(gsbr2.size() > 0){for(int i = 0; i < gsbr2.size(); i++){out.print("{'sid':'" + gsbr2.get(i).get("id") + "', 'cname':'" + gsbr2.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbr2.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'artistPic':'" + gsbr2.get(i).get("artist_pic") + "', 'cfree':'" + gsbr2.get(i).get("cfree") + "'}"); if(i < gsbr2.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 载入人气歌手
			var jsonArtist = [
				<%if(gabr.size() > 0){for(int i = 0; i < gabr.size(); i++){out.print("{'aid':'" + gabr.get(i).get("id") + "', 'cname':'" + gabr.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'sname':'" + gabr.get(i).get("sname").toString().replaceAll("'", "\\\\'") + "', 'carea':'" + gabr.get(i).get("carea") + "', 'ctype':'" + gabr.get(i).get("ctype") + "', 'pic':'" + gabr.get(i).get("pic") + "'}"); if(i < gabr.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 载入小视频
			var playList = [
				<%if(gsba.size() > 0){
					for(int i = 0; i < gsba.size(); i++){
						String cres = gsba.get(i).get("cres").toString();
						if(cres.contains("playurl")){ // 针对福建移动特殊判断 2022-01-19
							JSONObject cresJson = new JSONObject(cres);
							cres = cresJson.get("playurl").toString();
						}
						out.print("{'sid':'" + gsba.get(i).get("id") + "', 'cname':'" + gsba.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsba.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cres':'" + cres + "'}");
						if(i < gsba.size() - 1) out.print(",\n\t\t\t\t"); 
					}
				}%>
			];
			// 轮播相关参数
			var index_timeID = <%=marSort %>;
			var index_timer = null;
			var index_delay = 5000;
			// 几个推送列表的ID
			var weekList = <%=weekList %>;
			var newList = <%=newList %>;
			var movieList = <%=movieList %>;
			var kidsList = <%=kidsList %>;
			var nostalgiaList = <%=nostalgiaList %>;
			var popList = <%=popList %>;
			// 推荐位区域载入flag
			var loadFlag = [false, false, false, false, false, false, false, false, false];
			// 小视频位置
			var stbPos = [60, 178, 420, 236];
			// 是否支持动画 0:不支持 1:支持
			var animation = <%=animation %>;
			// 控制是否执行start函数
			var ctlStart = false;
			// 访问页面的唯一id
			var viewId = '';
		</script>
	</head>

	<body onload='start()' onunload='destoryMP()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 -->
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<div id='pageindexbgReal' style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/commonly/skins/<%=preferTheme %>.png);visibility:hidden'></div>
			<div id='pageindexbgl' style='position:absolute;width:0px;height:<%=pageH %>px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img src='images/commonly/skins/<%=preferTheme %>.png'>
			</div>
			<div id='pageindexbgu' style='position:absolute;width:<%=pageW %>px;height:0px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img src='images/commonly/skins/<%=preferTheme %>.png'>
			</div>
			<div id='pageindexbgr' style='position:absolute;width:0px;height:<%=pageH %>px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img id='imgindexbgr' src='images/commonly/skins/<%=preferTheme %>.png' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;z-index:-1'>
			</div>
			<div id='pageindexbgd' style='position:absolute;width:<%=pageW %>px;height:0px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img id='imgindexbgd' src='images/commonly/skins/<%=preferTheme %>.png' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;z-index:-1'>
			</div>
			<div id='BigDivFather' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;overflow:hidden'>
				<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px'>
					<%=gpd.get("add") %><%JSONObject partM = pageT.get(65);%>
					<div style='position:absolute;width:<%=partM.get("w") %>px;height:<%=partM.get("h") %>px;left:<%=partM.get("x") %>px;top:<%=partM.get("y") %>px;z-index:2;overflow:hidden'>
						<div id='pic_mar' style='position:absolute;width:<%=partM.get("w") %>px;height:<%=partM.get("h") %>px;left:<%=0 - (Integer.parseInt(marSort) - 1) * Integer.parseInt(partM.get("w").toString()) %>px;top:0px;z-index:1'><%for(int i = guir1.size() - 1; i >= 0; i--){%>
							<img id='mar_<%=guir1.size() - i %>' src='images/application/pages/index/commonly/null.png' style='position:absolute;width:<%=partM.get("w") %>px;height:<%=partM.get("h") %>px;left:<%=(guir1.size() - i - 1) * Integer.parseInt(partM.get("w").toString()) %>px;top:0px;z-index:2' />
							<div id='words_mar_<%=guir1.size() - i %>' style='position:absolute;width:<%=partM.get("w") %>px;height:50px;left:<%=(guir1.size() - i - 1) * Integer.parseInt(partM.get("w").toString()) %>px;top:<%=Integer.parseInt(partM.get("h").toString()) - 50 %>px;text-align:center;line-height:50px;color:#FFFFFF;font-size:26px;background-image:url(images/application/pages/index/commonly/grey.png);z-index:3;visibility:hidden'></div><%}%>
						</div><%int spr = 8; int l = guir1.size() * 20 + (guir1.size() - 1) * spr; l = (int) Math.floor((Integer.parseInt(partM.get("w").toString()) - l) / 2); for(int i = guir1.size() - 1; i >= 0; i--){%>
						<img src='images/application/pages/index/commonly/mar.png' style='position:absolute;width:20px;height:4px;left:<%=l %>px;top:<%=Integer.parseInt(partM.get("h").toString()) - 8 %>px;z-index:4' />
						<img id='mar_index_<%=guir1.size() - i %>' src='images/application/pages/index/commonly/mar0.png' style='position:absolute;width:20px;height:4px;left:<%=l %>px;top:<%=Integer.parseInt(partM.get("h").toString()) - 8 %>px;z-index:5;visibility:hidden' /><%l += spr + 20;}%>
					</div><%for(int i = 1; i <= 6; i++){%>
					<div id='s1_<%=i %>' style='position:absolute;width:250px;height:30px;left:333px;top:<%=(i - 1) * 56 + 754 %>px;color:#FFFFFF;font-size:22px;z-index:4;overflow:hidden'></div><%} for(int i = 1; i <= 6; i++){%>
					<div id='s2_<%=i %>' style='position:absolute;width:250px;height:30px;left:917px;top:<%=(i - 1) * 56 + 754 %>px;color:#FFFFFF;font-size:22px;z-index:4;overflow:hidden'></div><%} for(int i = 1; i <= 6; i++){%>
					<img id='free_1_<%=i %>' src='images/application/pages/index/commonly/free.png' style='position:absolute;width:48px;height:21px;left:583px;top:<%=(i - 1) * 56 + 769 %>px;z-index:4;visibility:hidden' /><%} for(int i = 1; i <= 6; i++){%>
					<div id='a1_<%=i %>' style='position:absolute;width:250px;height:30px;left:333px;top:<%=(i - 1) * 56 + 780 %>px;color:#B2AFAA;font-size:16px;z-index:4'></div><%} for(int i = 1; i <= 6; i++){%>
					<div id='a2_<%=i %>' style='position:absolute;width:250px;height:30px;left:917px;top:<%=(i - 1) * 56 + 780 %>px;color:#B2AFAA;font-size:16px;z-index:4'></div><%} for(int i = 1; i <= 6; i++){%>
					<img id='free_2_<%=i %>' src='images/application/pages/index/commonly/free.png' style='position:absolute;width:48px;height:21px;left:1167px;top:<%=(i - 1) * 56 + 769 %>px;z-index:4;visibility:hidden' /><%} int t = 0; for(int i = 1; i <= 12; i++){ t = i > 6 ? 1449 : 1225;%>
					<img id='ap_<%=i %>' src='images/application/pages/index/commonly/null.png' style='position:absolute;width:160px;height:160px;left:<%=((i % 6 == 0 ? 6 : i % 6) - 1) * 200 + 60%>px;top:<%=t %>px;z-index:4' /><%} int tt = 0; for(int i = 1; i <= 12; i++){ tt = i > 6 ? 1617 : 1393;%>
					<div id='at_<%=i %>' style='position:absolute;width:160px;height:40px;left:<%=((i % 6 == 0 ? 6 : i % 6) - 1) * 200 + 60%>px;top:<%=tt %>px;color:#FFFFFF;font-size:20px;text-align:center;z-index:4'></div><%}%>
					<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' />
					<img id='nTime01' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1140px;top:24px;z-index:3' />
					<img id='nTime02' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1160px;top:24px;z-index:3' />
					<img id='twinkle' src='images/application/utils/timenum/null.png' style='position:absolute;width:28px;height:51px;left:1174px;top:21px;z-index:3' />
					<img id='nTime03' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1200px;top:24px;z-index:3' />
					<img id='nTime04' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1220px;top:24px;z-index:3' />
					<div style='position:absolute;width:200px;height:40px;left:60px;top:636px;font-size:30px;color:#FFFFFF;z-index:1'>本期榜单</div>
					<div style='position:absolute;width:200px;height:40px;left:60px;top:1168px;font-size:30px;color:#FFFFFF;z-index:1'>人气歌手</div>
					<div style='position:absolute;width:200px;height:40px;left:60px;top:1688px;font-size:30px;color:#FFFFFF;z-index:1'>燃脂广场舞曲</div>
					<div style='position:absolute;width:200px;height:40px;left:60px;top:2212px;font-size:30px;color:#FFFFFF;z-index:1'>影视原声</div>
					<div style='position:absolute;width:200px;height:40px;left:60px;top:2584px;font-size:30px;color:#FFFFFF;z-index:1'>年度洗脑神曲</div>
					<div style='position:absolute;width:200px;height:40px;left:60px;top:3107px;font-size:30px;color:#FFFFFF;z-index:1'>演唱会现场</div>
					<div style='position:absolute;width:200px;height:40px;left:60px;top:3760px;font-size:30px;color:#FFFFFF;z-index:1'>免费专区</div>
					<img src='images/application/pages/index/other/list1.png' style='position:absolute;width:348px;height:379px;left:287px;top:705px;z-index:1' />
					<img src='images/application/pages/index/other/list2.png' style='position:absolute;width:348px;height:379px;left:873px;top:705px;z-index:1' />
					<img src='images/application/pages/index/other/rtTop.png' style='position:absolute;width:159px;height:23px;left:556px;top:4184px;z-index:1' />
					<img id='index_0' src='images/application/pages/index/commonly/<%=picName %>' style='position:absolute;width:<%=elePic[0] %>px;height:<%=elePic[1] %>px;left:<%=elePic[2] %>px;top:<%=elePic[3] %>px;z-index:1'/>
					<div id='d_index_0' style='position:absolute;width:<%=elePic[0] %>px;height:<%=elePic[1] %>px;left:<%=elePic[2] %>px;top:<%=elePic[3] %>px;z-index:4'>
						<img class='btn_focus_hidden' id='f_index_0' src='images/application/pages/index/commonly/focus/f_<%=picName %>' style='width:<%=elePic[0] %>px;height:<%=elePic[1] %>px' />
					</div><%int recDoc = 0; for(int i = 0; i < pageT.size(); i++){ JSONObject part = pageT.get(i); if(Boolean.parseBoolean(part.get("flag").toString())){ recDoc++;%>
					<div style='position:absolute;left:<%=Integer.parseInt(part.get("x").toString()) + 30 %>px;top:<%=Integer.parseInt(part.get("y").toString()) + 12 %>px;color:#FFFFFF;font-size:26px;z-index:4;background-image:url(images/application/pages/index/commonly/grey.png);visibility:<%if(isOnline.equals("n") && observerSwitch == 1){%>visible<%} else{%>hidden<%}%>'>推荐<%=recDoc %></div>
					<div style='position:absolute;left:<%=Integer.parseInt(part.get("x").toString()) + 30 %>px;top:<%=Integer.parseInt(part.get("y").toString()) + 47 %>px;color:#FFFFFF;font-size:20px;z-index:4;background-image:url(images/application/pages/index/commonly/grey.png);visibility:<%if(isOnline.equals("n") && observerSwitch == 1){%>visible<%} else{%>hidden<%}%>'>宽:<%=Integer.parseInt(part.get("w").toString()) %>px 高:<%=Integer.parseInt(part.get("h").toString()) %>px<br/>位置:<%=part.get("i") %></div>
					<img id='pic_<%=recDoc %>' src='images/application/pages/index/commonly/null.png' style='position:absolute;width:<%=part.get("w") %>px;height:<%=part.get("h") %>px;left:<%=part.get("x") %>px;top:<%=part.get("y") %>px;z-index:2'/>
					<div id='words_<%=recDoc %>' style='position:absolute;width:<%=part.get("w") %>px;height:50px;left:<%=part.get("x") %>px;top:<%=Integer.parseInt(part.get("y").toString()) + Integer.parseInt(part.get("h").toString()) - 50 %>px;text-align:center;line-height:50px;color:#FFFFFF;font-size:26px;background-image:url(images/application/pages/index/commonly/grey.png);z-index:3;visibility:hidden'></div><%}%>
					<img id='index_<%=part.get("i") %>' src='<%=part.get("pic") %>' style='position:absolute;width:<%=part.get("w") %>px;height:<%=part.get("h") %>px;left:<%=part.get("x") %>px;top:<%=part.get("y") %>px;z-index:1'/>
					<div id='d_index_<%=part.get("i") %>' style='position:absolute;width:<%=part.get("w2") %>px;height:<%=part.get("h2") %>px;left:<%=part.get("x2") %>px;top:<%=part.get("y2") %>px;z-index:4'>
						<img class='btn_focus_hidden' id='f_index_<%=part.get("i") %>' src='<%=part.get("pic2") %>' style='width:<%=part.get("w2") %>px;height:<%=part.get("h2") %>px' />
					</div><%}%>
				</div>
			</div>
			<!-- 优先加载小视频垫图 -->
			<img src='<%=imgSrcPage %>window.png' style='visibility:hidden'>
			<script type='text/javascript' src='javascript/pages/recommend.js?r=<%=Math.random() %>'></script>
			<script type='text/javascript' src='javascript/player/player_small.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>
		<script type='text/javascript'>
			// 计算出小视频的镂空<%JSONObject partB = pageT.get(9);%>
			$g('pageindexbgl').style.width = '<%=partB.get("x") %>px';
			$g('pageindexbgu').style.height = '<%=partB.get("y") %>px';
			$g('imgindexbgr').style.left = '-<%=Integer.parseInt(partB.get("x").toString()) + Integer.parseInt(partB.get("w").toString()) %>px';
			$g('pageindexbgr').style.left = '<%=Integer.parseInt(partB.get("x").toString()) + Integer.parseInt(partB.get("w").toString()) %>px';
			$g('pageindexbgr').style.width = '<%=pageW - Integer.parseInt(partB.get("x").toString()) - Integer.parseInt(partB.get("w").toString()) %>px';
			$g('imgindexbgd').style.top = '-<%=Integer.parseInt(partB.get("y").toString()) + Integer.parseInt(partB.get("h").toString()) %>px';
			$g('pageindexbgd').style.top = '<%=Integer.parseInt(partB.get("y").toString()) + Integer.parseInt(partB.get("h").toString()) %>px';
			$g('pageindexbgd').style.height = '<%=pageH - Integer.parseInt(partB.get("y").toString()) - Integer.parseInt(partB.get("h").toString()) %>px';
			var stbType = getVal('globle', 'stbType');
			if(stbType.indexOf('EC6108V9') > -1) $g('pageindexbgd').scrollTop = <%=Integer.parseInt(partB.get("y").toString()) + Integer.parseInt(partB.get("h").toString()) %>;
		</script>