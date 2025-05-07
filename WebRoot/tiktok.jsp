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
	// 创建页面焦点元素
	String imgSrcTop = "images/application/pages/index/commonly/";
	String imgSrcPage = "images/application/pages/index/page4/";
	List<JSONObject> pageT = new ArrayList<JSONObject>();
	pageT.add(createBox(1, 779, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "search.png", imgSrcTop + "focus/f_search.png", false));
	pageT.add(createBox(2, 875, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "collect.png", imgSrcTop + "focus/f_collect.png", false));
	pageT.add(createBox(3, 970, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "history.png", imgSrcTop + "focus/f_history.png", false));
	pageT.add(createBox(4, 1066, 10, 44, 52, 44, 52, 0, 0, imgSrcTop + "setting.png", imgSrcTop + "focus/f_setting.png", false));
	pageT.add(createBox(5, 88, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "karaoke.png", imgSrcTop + "focus/f_karaoke.png", false));
	pageT.add(createBox(6, 305, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "recommend.png", imgSrcTop + "focus/f_recommend.png", false));
	pageT.add(createBox(7, 522, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "kids.png", imgSrcTop + "focus/f_kids.png", false));
	pageT.add(createBox(8, 739, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "nostalgia.png", imgSrcTop + "focus/f_nostalgia.png", false));
	pageT.add(createBox(9, 956, 70, 240, 110, 240, 110, 0, 0, imgSrcTop + "status/c_f_tiktok.png", imgSrcTop + "focus/f_tiktok.png", false));
	pageT.add(createBox(10, 60, 178, 420, 236, 447, 263, 0, 0, imgSrcPage + "420_236.png", imgSrcPage + "focus/f_447_263.png", true));
	pageT.add(createBox(11, 490, 178, 453, 236, 480, 263, 0, 0, imgSrcPage + "453_236.png", imgSrcPage + "focus/f_480_263.png", true));
	pageT.add(createBox(12, 953, 178, 267, 236, 294, 263, 0, 0, imgSrcPage + "267_236.png", imgSrcPage + "focus/f_294_263.png", true));
	pageT.add(createBox(13, 60, 424, 205, 186, 232, 213, 0, 0, imgSrcPage + "205_186.png", imgSrcPage + "focus/f_232_213.png", true));
	pageT.add(createBox(14, 275, 424, 205, 186, 232, 213, 0, 0, imgSrcPage + "205_186.png", imgSrcPage + "focus/f_232_213.png", true));
	pageT.add(createBox(15, 490, 424, 453, 186, 480, 213, 0, 0, imgSrcPage + "453_186.png", imgSrcPage + "focus/f_480_213.png", true));
	pageT.add(createBox(16, 953, 424, 267, 186, 294, 213, 0, 0, imgSrcPage + "267_186.png", imgSrcPage + "focus/f_294_213.png", true));
	pageT.add(createBox(17, 60, 691, 193, 193, 221, 221, 0, 0, imgSrcPage + "193_193.png", imgSrcPage + "focus/f_221_221.png", false));
	pageT.add(createBox(18, 301, 691, 193, 193, 221, 221, 0, 0, imgSrcPage + "193_193.png", imgSrcPage + "focus/f_221_221.png", false));
	pageT.add(createBox(19, 543, 691, 193, 193, 221, 221, 0, 0, imgSrcPage + "193_193.png", imgSrcPage + "focus/f_221_221.png", false));
	pageT.add(createBox(20, 784, 691, 193, 193, 221, 221, 0, 0, imgSrcPage + "193_193.png", imgSrcPage + "focus/f_221_221.png", false));
	pageT.add(createBox(21, 1025, 691, 193, 193, 221, 221, 0, 0, imgSrcPage + "193_193.png", imgSrcPage + "focus/f_221_221.png", false));
	pageT.add(createBox(22, 60, 906, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(23, 450, 906, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(24, 840, 906, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(25, 60, 1203, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(26, 450, 1203, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(27, 840, 1203, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(28, 60, 1433, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(29, 450, 1433, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(30, 840, 1433, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(31, 60, 1733, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(32, 450, 1733, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(33, 840, 1733, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(34, 60, 1963, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(35, 450, 1963, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(36, 840, 1963, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(37, 60, 2261, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(38, 450, 2261, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(39, 840, 2261, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(40, 60, 2491, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(41, 450, 2491, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(42, 840, 2491, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(43, 60, 2787, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(44, 450, 2787, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	pageT.add(createBox(45, 840, 2787, 380, 220, 406, 246, 0, 0, imgSrcPage + "380_220.png", imgSrcPage + "focus/f_406_246.png", true));
	
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
	Page newPageA = new Page(5, 5);
	newPageA.setPageIndex(1);
	List<Map<String, Object>> gabr = InfoData.getArtistsByRecommend(newPageA, tiktokAList, false);
%><%@include file="common/head.jsp" %>
<% 
	// 获取界面推荐的参数
	int[] orUiIdx = {pageId};
	int[] orUiIdx0 = {pageId, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
	int[] uiParms;
	if(StringUtils.isNotBlank(provinceN)) uiParms = (int[]) orUiIdx0.clone();
	else uiParms = (int[]) orUiIdx.clone();

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
			// 载入推荐歌手
			var jsonArtist = [
				<%if(gabr.size() > 0){for(int i = 0; i < gabr.size(); i++){out.print("{'aid':'" + gabr.get(i).get("id") + "', 'cname':'" + gabr.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'sname':'" + gabr.get(i).get("sname").toString().replaceAll("'", "\\\\'") + "', 'carea':'" + gabr.get(i).get("carea") + "', 'ctype':'" + gabr.get(i).get("ctype") + "', 'pic':'" + gabr.get(i).get("pic") + "'}"); if(i < gabr.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 推荐位区域载入flag
			var loadFlag = [false, false, false, false, false, false];
			// 是否支持动画 0:不支持 1:支持
			var animation = <%=animation %>;
			// 控制是否执行start函数
			var ctlStart = false;
			// 访问页面的唯一id
			var viewId = '';
		</script>
	</head>

	<body onload='start()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 -->
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<div style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/commonly/skins/<%=preferTheme %>.png)'></div>
			<div id='BigDivFather' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;overflow:hidden'>
				<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px'>
					<%=gpd.get("add") %><%for(int i = 1; i <= 5; i++){%>
					<img id='ap_<%=i %>' src='images/application/pages/index/commonly/null.png' style='position:absolute;width:193px;height:193px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 241 + 60%>px;top:691px;z-index:2' />
					<div id='at_<%=i %>' style='position:absolute;width:193px;height:40px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 241 + 60%>px;top:841px;color:#FFFFFF;font-size:20px;text-align:center;z-index:4'></div>
					<img id='ap_<%=i %>' src='images/application/pages/index/commonly/status/c_f_singer.png' style='position:absolute;width:195px;height:195px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 241 + 59%>px;top:690px;z-index:3' /><%}%>
					<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' />
					<img id='nTime01' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1140px;top:24px;z-index:3' />
					<img id='nTime02' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1160px;top:24px;z-index:3' />
					<img id='twinkle' src='images/application/utils/timenum/null.png' style='position:absolute;width:28px;height:51px;left:1174px;top:21px;z-index:3' />
					<img id='nTime03' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1200px;top:24px;z-index:3' />
					<img id='nTime04' src='images/application/utils/timenum/null.png' style='position:absolute;width:18px;height:35px;left:1220px;top:24px;z-index:3' />
					<div style='position:absolute;width:150px;height:40px;left:60px;top:636px;font-size:30px;color:#FFFFFF;z-index:1'>热播榜单</div>
					<div style='position:absolute;width:150px;height:40px;left:60px;top:1154px;font-size:30px;color:#FFFFFF;z-index:1'>网红推荐</div>
					<div style='position:absolute;width:150px;height:40px;left:60px;top:1683px;font-size:30px;color:#FFFFFF;z-index:1'>古风歌曲</div>
					<div style='position:absolute;width:150px;height:40px;left:60px;top:2209px;font-size:30px;color:#FFFFFF;z-index:1'>草原歌曲</div>
					<img src='images/application/pages/index/other/rtTop.png' style='position:absolute;width:159px;height:23px;left:556px;top:2733px;z-index:1' />
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
			<script type='text/javascript' src='javascript/pages/tiktok.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>