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
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_index_12" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	String backPos = StringUtils.isBlank(DoParam.AnalysisAbb("b", request)) ? "0" : DoParam.AnalysisAbb("b", request);
	// 创建页面焦点元素
	String imgSrcTop = "images/application/pages/index/commonly/";
	String imgSrcPage = "images/application/pages/index/page2/";
	List<JSONObject> pageT = new ArrayList<JSONObject>();
	pageT.add(createBox(1, 779, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "search.png", imgSrcTop + "focus/f_search.png", false));
	pageT.add(createBox(2, 875, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "collect.png", imgSrcTop + "focus/f_collect.png", false));
	pageT.add(createBox(3, 970, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "history.png", imgSrcTop + "focus/f_history.png", false));
	pageT.add(createBox(4, 1066, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "setting.png", imgSrcTop + "focus/f_setting.png", false));
	pageT.add(createBox(5, 88, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "karaoke.png", imgSrcTop + "focus/f_karaoke.png", false));
	pageT.add(createBox(6, 305, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "recommend.png", imgSrcTop + "focus/f_recommend.png", false));
	pageT.add(createBox(7, 522, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "status/c_f_kids.png", imgSrcTop + "focus/f_kids.png", false));
	pageT.add(createBox(8, 739, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "nostalgia.png", imgSrcTop + "focus/f_nostalgia.png", false));
	pageT.add(createBox(9, 956, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "tiktok.png", imgSrcTop + "focus/f_tiktok.png", false));
	pageT.add(createBox(10, 60, 178, 453, 236, 480, 263, 0, 0, imgSrcPage + "453_236.png", imgSrcPage + "focus/f_480_263.png", true));
	pageT.add(createBox(11, 522, 178, 267, 236, 294, 263, 0, 0, imgSrcPage + "267_236.png", imgSrcPage + "focus/f_294_263.png", true));
	pageT.add(createBox(12, 800, 178, 420, 236, 447, 263, 0, 0, imgSrcPage + "420_236.png", imgSrcPage + "focus/f_447_263.png", false));
	pageT.add(createBox(13, 60, 424, 453, 186, 480, 213, 0, 0, imgSrcPage + "453_186.png", imgSrcPage + "focus/f_480_213.png", true));
	pageT.add(createBox(14, 522, 424, 267, 186, 294, 213, 0, 0, imgSrcPage + "267_186.png", imgSrcPage + "focus/f_294_213.png", true));
	pageT.add(createBox(15, 800, 424, 205, 186, 232, 213, 0, 0, imgSrcPage + "205_186.png", imgSrcPage + "focus/f_232_213.png", true));
	pageT.add(createBox(16, 1015, 424, 205, 186, 232, 213, 0, 0, imgSrcPage + "205_186.png", imgSrcPage + "focus/f_232_213.png", true));
	pageT.add(createBox(17, 56, 673, 205, 222, 221, 226, 0, 0, imgSrcPage + "bweg.png", imgSrcPage + "focus/f_bweg.png", false));
	pageT.add(createBox(18, 297, 673, 205, 222, 221, 226, 0, 0, imgSrcPage + "yzeg.png", imgSrcPage + "focus/f_yzeg.png", false));
	pageT.add(createBox(19, 539, 673, 205, 222, 221, 226, 0, 0, imgSrcPage + "ggleg.png", imgSrcPage + "focus/f_ggleg.png", false));
	pageT.add(createBox(20, 780, 673, 205, 222, 221, 226, 0, 0, imgSrcPage + "dddd.png", imgSrcPage + "focus/f_dddd.png", false));
	pageT.add(createBox(21, 1021, 673, 205, 222, 221, 226, 0, 0, imgSrcPage + "sqeg.png", imgSrcPage + "focus/f_sqeg.png", false));
	pageT.add(createBox(22, 60, 906, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(23, 450, 906, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(24, 840, 906, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(25, 60, 1201, 224, 224, 250, 250, 0, 0, imgSrcPage + "224_224.png", imgSrcPage + "focus/f_250_250.png", true));
	pageT.add(createBox(26, 294, 1201, 224, 224, 250, 250, 0, 0, imgSrcPage + "224_224.png", imgSrcPage + "focus/f_250_250.png", true));
	pageT.add(createBox(27, 528, 1201, 224, 224, 250, 250, 0, 0, imgSrcPage + "224_224.png", imgSrcPage + "focus/f_250_250.png", true));
	pageT.add(createBox(28, 762, 1201, 458, 224, 484, 250, 0, 0, imgSrcPage + "458_224.png", imgSrcPage + "focus/f_484_250.png", true));
	pageT.add(createBox(29, 60, 1435, 458, 224, 484, 250, 0, 0, imgSrcPage + "458_224.png", imgSrcPage + "focus/f_484_250.png", true));
	pageT.add(createBox(30, 528, 1435, 224, 224, 250, 250, 0, 0, imgSrcPage + "224_224.png", imgSrcPage + "focus/f_250_250.png", true));
	pageT.add(createBox(31, 762, 1435, 224, 224, 250, 250, 0, 0, imgSrcPage + "224_224.png", imgSrcPage + "focus/f_250_250.png", true));
	pageT.add(createBox(32, 996, 1435, 224, 224, 250, 250, 0, 0, imgSrcPage + "224_224.png", imgSrcPage + "focus/f_250_250.png", true));
	pageT.add(createBox(33, 60, 1736, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(34, 450, 1736, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(35, 840, 1736, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(36, 60, 1966, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(37, 450, 1966, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(38, 840, 1966, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(39, 60, 2264, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(40, 294, 2264, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(41, 528, 2264, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(42, 762, 2264, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(43, 996, 2264, 224, 296, 250, 322, 0, 0, imgSrcPage + "224_296.png", imgSrcPage + "focus/f_250_322.png", true));
	pageT.add(createBox(44, 60, 2636, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(45, 450, 2636, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(46, 840, 2636, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(47, 60, 2866, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(48, 450, 2866, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(49, 840, 2866, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	
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
%><%@include file="common/head.jsp" %>
<% 
	// 获取界面推荐的参数
	int[] orUiIdx = {pageId};
	int[] orUiIdx0 = {pageId, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
	int[] uiParms;
	if(StringUtils.isNotBlank(provinceN)) uiParms = (int[]) orUiIdx0.clone();
	else uiParms = (int[]) orUiIdx.clone();
	// 获取界面小视频
	int[] orUiIdxVod = {10002};
	int[] orUiIdxVod0 = {10002, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
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
			// 推荐位区域载入flag
			var loadFlag = [false, false, false, false, false, false];
			// 小视频位置
			var stbPos = [800, 178, 420, 236];
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
					<%=gpd.get("add") %>
					<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' />
					<img id='nTime01' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1140px;top:24px;z-index:3' />
					<img id='nTime02' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1160px;top:24px;z-index:3' />
					<img id='twinkle' src='images/application/utils/timenum/null.png' style='position:absolute;width:28px;height:51px;left:1174px;top:21px;z-index:3' />
					<img id='nTime03' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1200px;top:24px;z-index:3' />
					<img id='nTime04' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1220px;top:24px;z-index:3' />
					<div style='position:absolute;width:150px;height:40px;left:60px;top:636px;font-size:30px;color:#FFFFFF;z-index:1'>宝宝最爱</div>
					<div style='position:absolute;width:150px;height:40px;left:60px;top:1150px;font-size:30px;color:#FFFFFF;z-index:1'>儿歌多多</div>
					<div style='position:absolute;width:150px;height:40px;left:60px;top:1688px;font-size:30px;color:#FFFFFF;z-index:1'>睡前故事</div>
					<div style='position:absolute;width:150px;height:40px;left:60px;top:2212px;font-size:30px;color:#FFFFFF;z-index:1'>寓教于乐</div>
					<div style='position:absolute;width:150px;height:40px;left:60px;top:2584px;font-size:30px;color:#FFFFFF;z-index:1'>动画原声</div>
					<img src='images/application/pages/index/other/rtTop.png' style='position:absolute;width:159px;height:23px;left:556px;top:3111px;z-index:1' />
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
			<script type='text/javascript' src='javascript/pages/kids.js?r=<%=Math.random() %>'></script>
			<script type='text/javascript' src='javascript/player/player_small.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>
		<script type='text/javascript'>
			// 计算出小视频的镂空<%JSONObject partB = pageT.get(11);%>
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