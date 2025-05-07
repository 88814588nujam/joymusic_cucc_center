<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,java.text.DecimalFormat,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_artist_100004" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	String backPos = StringUtils.isBlank(DoParam.AnalysisAbb("b", request)) ? "0" : DoParam.AnalysisAbb("b", request);
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "1" : DoParam.AnalysisAbb("p", request));
	int pageLimit = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("l", request)) ? "20" : DoParam.AnalysisAbb("l", request));
	int tipsStat = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("t", request)) ? "0" : DoParam.AnalysisAbb("t", request));
	int rightStat = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("r", request)) ? "0" : DoParam.AnalysisAbb("r", request));
	
	int aid = Integer.parseInt(key);
	// 获取艺人信息
	Map<String, Object> gabr = InfoData.getEntityArtist(aid);
	if(ajaxData == 1){ // 歌手歌曲
		String aname = gabr.get("cname").toString();
		int totalRows = InfoData.getSongsCountByArtist(aname);
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		Page pagesReal = new Page(totalRows, 20);
		pagesReal.setPageIndex(pageIndex);
		List<Map<String, Object>> gsba = InfoData.getSongsByArtist(pages, aname);
		int pageSumReal = gsba.size() % (pageIndex * 20) == 0 ? 20 : gsba.size() % (pageIndex * 20);
		String retStr = "{'ifNull':false, 'totalRows':'" + totalRows + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pagesReal':'" + pagesReal.getPageTotal() + "', 'pageSum':'" + gsba.size() + "', 'pageSumReal':'" + pageSumReal + "', 'songList':[";
		if(gsba.size() > 0){
			for(int i = 0; i < gsba.size(); i++){
				int docI = i + 1;
				String cname = gsba.get(i).get("cname").toString();
				int len = getTitleTen(cname);
				if(i == gsba.size() - 1) retStr += "{'sid':'" + gsba.get(i).get("id") + "', 'cname':'" + gsba.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsba.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsba.get(i).get("cfree") + "', 'duration':'" + gsba.get(i).get("duration") + "'}";
				else retStr +=  "{'sid':'" + gsba.get(i).get("id") + "', 'cname':'" + gsba.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsba.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsba.get(i).get("cfree") + "', 'duration':'" + gsba.get(i).get("duration") + "'},";
			}
		}
		retStr += "]}";
		out.print(retStr);
		return;
	} else if(ajaxData == 2){ // 更改用户偏好明星列表
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		int row = InfoData.updateUserInfo(tmpUid, "preferList", key);
		String retStr = "{'result':'0'}";
		if(row > 0) retStr = "{'result':'1'}";
		out.print(retStr);
		return;
	}
%><%@include file="common/head.jsp" %>
<% 
	// 获取艺人其它信息
	int nowCollectNum = InfoData.getCollectCount(String.valueOf(aid), 0);
	int hotNum = nowCollectNum * Integer.parseInt(gabr.get("coefficientNum").toString()) + Integer.parseInt(gabr.get("baseNum").toString());
	String disNum = String.valueOf(hotNum);
	if(hotNum > 999){
		DecimalFormat df = new DecimalFormat("0.00");
		disNum = df.format((float) hotNum / 1000) + "k";
	}
	boolean ifc = InfoData.checkCollect(userid, String.valueOf(aid), 0);
	// 收藏歌曲队列idsStr
	String collectStr = InfoData.getCollectStr(userid, 1);
	// 已选歌曲队列idsStr
	String checkedStr = InfoData.getCheckedStr(userid, hour, max);
	String[] idsCheckedStr = checkedStr.split(",");
	int idsCheckedNum = checkedStr.contains(",") ? idsCheckedStr.length : (StringUtils.isBlank(checkedStr) ? 0 : 1);
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
			// 滑动频率
			var frequency = 10;
			// 用户偏好列表
			var preferList = <%=preferList %>;
			// 歌手ID
			var singerId = <%=key %>;
			// 歌手名
			var aname = '<%=gabr.get("cname").toString().replaceAll("'", "\\\\'") %>';
			// 当前页码
			var pageIndex = <%=pageIndex %>;
			// 当前总页数
			var pageTotal = 0;
			// 当前页面查询出来的内容数
			var pageSum = 0;
			// 查询出来的歌曲总数
			var totalRows = 0;
			// 每个页面总加载上限
			var pageLimit = <%=pageLimit %>;
			// 侧键出现的临界点
			var rightLine = -312;
			// 异步加载出来的歌曲
			var songList = new Array();
			// 异步加载出来的歌曲总集
			var songListAll = new Array();
			// 是否支持动画 0:不支持 1:支持
			var animation = <%=animation %>;
			// 收藏歌曲队列idsStr
			var collectStr = '<%=collectStr %>';
			// 是否多次载入内容
			var multipleLoad = false;
			// 载入页面滑动的位置
			var backPos = <%=backPos %>;
			// 记录当前页面提示语状态
			var tipsStat = <%=tipsStat %>;
			// 记录当前页面右侧快捷栏状态
			var rightStat = <%=rightStat %>;
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
			<img id='moreData' src='images/application/pages/artist/moreData.png' style='position:absolute;width:467px;height:40px;left:406px;top:662px;z-index:1;visibility:hidden' />
			<img id='maxData' src='images/application/pages/artist/maxData.png' style='position:absolute;width:340px;height:40px;left:470px;top:662px;z-index:1;visibility:hidden' />
			<div id='BigDivFather' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;overflow:hidden'>
				<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH  %>px;left:0px;top:0px'>
					<%=gpd.get("add") %>
					<div id='idsCheckedNum' style='position:absolute;width:30px;height:30px;left:1202px;top:30px;font-size:20px;color:#E7686A;text-align:center;z-index:3'><%if(idsCheckedNum > 99){%>99<span style='font-size:10px'>+</span><%} else{%><%=idsCheckedNum %><%}%></div>
					<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' />
					<img src='images/commonly/artist/c_<%=gabr.get("pic") %>' style='position:absolute;width:235px;height:235px;left:115px;top:116px;z-index:1' />
					<div style='position:absolute;width:235px;height:30px;left:400px;top:130px;font-size:28px;color:#FFFFFF;z-index:2'><%=gabr.get("cname").toString().replaceAll("'", "\\\\'") %></div>
					<div style='position:absolute;width:355px;height:30px;left:400px;top:190px;font-size:20px;color:#B2AFAA;z-index:2'>别名：<%=StringUtils.isNotBlank(gabr.get("sname").toString()) ? gabr.get("sname").toString().replaceAll("'", "\\\\'") : "────" %></div>
					<div style='position:absolute;width:355px;height:30px;left:710px;top:190px;font-size:20px;color:#B2AFAA;z-index:2'>地区：<%=gabr.get("carea") %></div>
					<div style='position:absolute;width:720px;height:80px;left:400px;top:220px;font-size:20px;color:#B2AFAA;word-wrap:break-word;z-index:2'><%=gabr.get("cdes") %></div>
					<div style='position:absolute;width:50px;height:30px;left:400px;top:306px;font-size:18px;color:#FFFFFF;z-index:2'>单曲</div>
					<div id='totalRows' style='position:absolute;width:80px;height:30px;left:450px;top:300px;font-size:30px;color:#FFFFFF;z-index:2'></div>
					<div style='position:absolute;width:10px;height:28px;left:515px;top:298px;font-size:30px;color:#FFFFFF;z-index:2'>|</div>
					<div style='position:absolute;width:50px;height:30px;left:545px;top:306px;font-size:18px;color:#FFFFFF;z-index:2'>热度</div>
					<div style='position:absolute;width:150px;height:30px;left:600px;top:300px;font-size:30px;color:#FFFFFF;z-index:2'><%=disNum %></div>
					<div style='position:absolute;width:235px;height:30px;left:190px;top:358px;font-size:18px;color:#B2AFAA;z-index:2'>歌曲</div>
					<div style='position:absolute;width:235px;height:30px;left:680px;top:358px;font-size:18px;color:#B2AFAA;z-index:2'>合作</div>
					<div style='position:absolute;width:235px;height:30px;left:850px;top:358px;font-size:18px;color:#B2AFAA;z-index:2'>时长</div>
					<div style='position:absolute;width:235px;height:30px;left:1000px;top:358px;font-size:18px;color:#B2AFAA;z-index:2'>功能</div>
					<img id='artist_100001' src='images/application/pages/artist/subscribe<%if(ifc){%>0<%}%>.png' style='position:absolute;width:73px;height:29px;left:265px;top:133px;z-index:1' />
					<img class='btn_focus_hidden' id='f_artist_100001' src='images/application/pages/artist/focus/f_subscribe<%if(ifc){%>0<%}%>.png' style='position:absolute;width:73px;height:29px;left:265px;top:133px;z-index:2' />
					<img id='artist_100002' src='images/application/pages/search/commonly/collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:1' />
					<img class='btn_focus_hidden' id='f_artist_100002' src='images/application/pages/search/commonly/focus/f_collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:2' />
					<img id='artist_100003' src='images/application/pages/search/commonly/checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:1' />
					<img class='btn_focus_hidden' id='f_artist_100003' src='images/application/pages/search/commonly/focus/f_checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:2' />
					<img id='artist_100004' src='images/application/pages/artist/playAll.png' style='position:absolute;width:153px;height:55px;left:818px;top:292px;z-index:1' />
					<img class='btn_focus_hidden' id='f_artist_100004' src='images/application/pages/artist/focus/f_playAll.png' style='position:absolute;width:153px;height:55px;left:818px;top:292px;z-index:2' />
					<img id='artist_100005' src='images/application/pages/artist/classic.png' style='position:absolute;width:153px;height:55px;left:965px;top:292px;z-index:1' />
					<img class='btn_focus_hidden' id='f_artist_100005' src='images/application/pages/artist/focus/f_classic.png' style='position:absolute;width:153px;height:55px;left:965px;top:292px;z-index:2' />
					<div id='songS'></div>
				</div>
			</div>
			<div id='right' style='position:absolute;width:75px;height:328px;left:1280px;top:196px;background-size:100% 100%;background-image:url(images/application/pages/artist/bottom.png)'>
				<img src='images/commonly/artist/c_<%=gabr.get("pic") %>' style='position:absolute;width:57px;height:57px;left:8px;top:8px;z-index:2' />
				<img id='artist_100006' src='images/application/pages/index/commonly/null.png' style='position:absolute;width:75px;height:72px;left:0px;top:10px;z-index:1' />
				<img class='btn_focus_hidden' id='f_artist_100006' src='images/application/pages/artist/focus/f_ele_collect<%if(ifc){%>0<%}%>.png' style='position:absolute;width:86px;height:75px;left:-5px;top:0px;z-index:2' />
				<img id='c_artist_100006' src='images/application/pages/artist/focus/c_f_ele_collect<%if(ifc){%>0<%}%>.png' style='position:absolute;width:12px;height:12px;left:60px;top:56px;z-index:3' />
				<img id='artist_100007' src='images/application/pages/artist/ele2.png' style='position:absolute;width:75px;height:64px;left:0px;top:82px;z-index:1' />
				<img class='btn_focus_hidden' id='f_artist_100007' src='images/application/pages/artist/focus/f_ele2.png' style='position:absolute;width:75px;height:64px;left:0px;top:72px;z-index:2' />
				<img id='artist_100008' src='images/application/pages/artist/ele3.png' style='position:absolute;width:75px;height:64px;left:0px;top:146px;z-index:1' />
				<img class='btn_focus_hidden' id='f_artist_100008' src='images/application/pages/artist/focus/f_ele3.png' style='position:absolute;width:75px;height:64px;left:0px;top:136px;z-index:2' />
				<img id='artist_100009' src='images/application/pages/artist/ele4.png' style='position:absolute;width:75px;height:64px;left:0px;top:210px;z-index:1' />
				<img class='btn_focus_hidden' id='f_artist_100009' src='images/application/pages/artist/focus/f_ele4.png' style='position:absolute;width:75px;height:64px;left:0px;top:200px;z-index:2' />
				<img id='artist_100010' src='images/application/pages/artist/ele5.png' style='position:absolute;width:75px;height:64px;left:0px;top:274px;z-index:1' />
				<img class='btn_focus_hidden' id='f_artist_100010' src='images/application/pages/artist/focus/f_ele5.png' style='position:absolute;width:75px;height:64px;left:0px;top:264px;z-index:2' />
			</div>
			<!-- 优先加载图 -->
			<img src='images/application/pages/search/song/collect.png' style='visibility:hidden'>
			<img src='images/application/pages/search/song/collect0.png' style='visibility:hidden'>
			<img src='images/application/pages/search/song/focus/f_collect.png' style='visibility:hidden'>
			<img src='images/application/pages/search/song/focus/f_collect0.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/subscribe.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/subscribe0.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/focus/f_subscribe.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/focus/f_subscribe0.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/focus/f_ele_collect.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/focus/f_ele_collect0.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/focus/c_f_ele_collect.png' style='visibility:hidden'>
			<img src='images/application/pages/artist/focus/c_f_ele_collect0.png' style='visibility:hidden'>
			<script type='text/javascript' src='javascript/pages/artist_fashion.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>