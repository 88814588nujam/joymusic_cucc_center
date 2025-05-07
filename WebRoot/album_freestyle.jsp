<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));

	if(ajaxData == 1){ // 专辑页面元素
		int aid = Integer.parseInt(key);
		List<Map<String, Object>> gae = InfoData.getAlbumEles(aid);
		String idxArr = "";
		String focusArr = "";
		String pageEle = "";
		String freeArr = "";
		
		if(gae.size() > 0){
			for(int i = 0; i < gae.size(); i++){
				int docI = i + 1;
				if(i == gae.size() - 1) pageEle += "{'pos':'" + gae.get(i).get("pos") + "', 'zindex':'" + gae.get(i).get("zindex") + "', 'w':'" + gae.get(i).get("w") + "', 'h':'" + gae.get(i).get("h") + "', 'x':'" + gae.get(i).get("x") + "', 'y':'" + gae.get(i).get("y") + "', 'w2':'" + gae.get(i).get("w2") + "', 'h2':'" + gae.get(i).get("h2") + "', 'x2':'" + gae.get(i).get("x2") + "', 'y2':'" + gae.get(i).get("y2") + "', 'pic':'" + gae.get(i).get("pic") + "', 'pic_word':'" + gae.get(i).get("pic_word") + "', 'pic_word_css':'" + gae.get(i).get("pic_word_css") + "', 'cfocus':'" + gae.get(i).get("cfocus") + "', 'defaultfocus':'" + gae.get(i).get("defaultfocus") + "', 'direct':'" + gae.get(i).get("direct") + "', 'onclick_type':'" + gae.get(i).get("onclick_type") + "', 'curl':'" + gae.get(i).get("curl") + "', 'params':'" + gae.get(i).get("params") + "'}";
				else pageEle += "{'pos':'" + gae.get(i).get("pos") + "', 'zindex':'" + gae.get(i).get("zindex") + "', 'w':'" + gae.get(i).get("w") + "', 'h':'" + gae.get(i).get("h") + "', 'x':'" + gae.get(i).get("x") + "', 'y':'" + gae.get(i).get("y") + "', 'w2':'" + gae.get(i).get("w2") + "', 'h2':'" + gae.get(i).get("h2") + "', 'x2':'" + gae.get(i).get("x2") + "', 'y2':'" + gae.get(i).get("y2") + "', 'pic':'" + gae.get(i).get("pic") + "', 'pic_word':'" + gae.get(i).get("pic_word") + "', 'pic_word_css':'" + gae.get(i).get("pic_word_css") + "', 'cfocus':'" + gae.get(i).get("cfocus") + "', 'defaultfocus':'" + gae.get(i).get("defaultfocus") + "', 'direct':'" + gae.get(i).get("direct") + "', 'onclick_type':'" + gae.get(i).get("onclick_type") + "', 'curl':'" + gae.get(i).get("curl") + "', 'params':'" + gae.get(i).get("params") + "'},";
				int onclick_type = Integer.parseInt(gae.get(i).get("onclick_type").toString());
				if(onclick_type == 1) idxArr += gae.get(i).get("params") + ",";
				else if(onclick_type == -1) freeArr = gae.get(i).get("params").toString();
				int cfocus = Integer.parseInt(gae.get(i).get("cfocus").toString());
				if(cfocus > 0) focusArr += cfocus + ",";
			}
		}
		List<Map<String, Object>> gsbaf = InfoData.getSongByIds(freeArr);
		String freeEle = "";
		if(gsbaf.size() > 0){
			for(int i = 0; i < gsbaf.size(); i++){
				String cres = gsbaf.get(i).get("cres").toString();
				if(cres.contains("playurl")){ // 针对福建移动特殊判断 2022-01-19
					JSONObject cresJson = new JSONObject(cres);
					cres = cresJson.get("playurl").toString();
				}
				if(i == gsbaf.size() - 1) freeEle += "{'sid':'" + gsbaf.get(i).get("id") + "', 'cname':'" + gsbaf.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbaf.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsbaf.get(i).get("cfree") + "', 'cres':'" + cres + "'}";
				else freeEle += "{'sid':'" + gsbaf.get(i).get("id") + "', 'cname':'" + gsbaf.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbaf.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsbaf.get(i).get("cfree") + "', 'cres':'" + cres + "'},";
			}
		}
		idxArr = idxArr.substring(0, idxArr.lastIndexOf(","));
		focusArr = focusArr.substring(0, focusArr.lastIndexOf(","));
		List<Map<String, Object>> gsba = InfoData.getSongByIds(idxArr);
		String songEle = "";
		if(gsba.size() > 0){
			for(int i = 0; i < gsba.size(); i++){
				int docI = i + 1;
				int csort = Integer.parseInt(gsba.get(i).get("csort").toString());
				String isline = csort == 0 ? "n" : "y";
				if(i == gsba.size() - 1) songEle += "{'sid':'" + gsba.get(i).get("id") + "', 'cname':'" + gsba.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsba.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsba.get(i).get("cfree") + "', 'isline':'" + isline + "'}";
				else songEle += "{'sid':'" + gsba.get(i).get("id") + "', 'cname':'" + gsba.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsba.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsba.get(i).get("cfree") + "', 'isline':'" + isline + "'},";
			}
		}
		String retStr = "{'idxArr':'" + idxArr + "', 'focusArr':[" + focusArr + "], 'pageEle':[" + pageEle + "], 'freeEle':[" + freeEle + "], 'songEle':[" + songEle + "]}";
		out.print(retStr);
		return;
	}
%><%@include file="common/head.jsp" %>
<% 
	// 获取专题信息
	Map<String, Object> gea = InfoData.getEntityAlbum(key);
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
			// 上一个焦点(用户存储侧键前的按键)
			var lastFocus = '<%=nowFocus %>';
			// 当前页码ID
			var pageId = <%=pageId %>;
			// 允许按键
			var allowClick = true;
			// 专辑关键字
			var key = '<%=key %>';
			// 专辑id
			var aid = <%=gea.get("id") %>;
			// 专辑名
			var cname = '<%=gea.get("cname") %>';
			// 专辑图片文件夹
			var picPath = '<%=gea.get("pic_path") %>';
			// 曲目id
			var idxArr = '';
			// 焦点选中方式
			var focusArr = new Array();
			// 按键响应
			var direct = new Array();
			// 按键元素
			var clkEle = new Array();
			// 播放队列
			var playList = new Array();
			// 是否载入小视频
			var needVod = false;
			// 控制是否执行start函数
			var ctlStart = false;
			// 访问页面的唯一id
			var viewId = '';
		</script>
	</head>

	<body onload='start()' onunload='outDestroy()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 -->
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH  %>px;left:0px;top:0px'>
				<%=gpd.get("add") %>
			</div>
			<script type='text/javascript' src='javascript/pages/album_freestyle.js?r=<%=Math.random() %>'></script>
			<script type='text/javascript' src='javascript/player/player_small.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>