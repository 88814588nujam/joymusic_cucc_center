<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));
	int rightDiv = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("o", request)) ? "0" : DoParam.AnalysisAbb("o", request));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "1" : DoParam.AnalysisAbb("p", request));
	
	if(ajaxData == 1){ // 更改用户偏好播放器
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		int row = InfoData.updateUserInfo(tmpUid, "preferKeyboard", key);
		String retStr = "{'result':'0'}";
		if(row > 0) retStr = "{'result':'1'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 2){ // 搜索歌曲
		int totalRowsS = InfoData.getSongsCountBySpell(key);
		int totalRowsA = InfoData.getArtistsCount(key);
		Page pages = new Page(totalRowsS, 8);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gsbs = InfoData.getSongsBySpell(pages, key);
		List<Map<String, Object>> gsbs0 = new ArrayList<Map<String, Object>>();
		String retStr = "{'ifNull':false, 'totalRowsS':'" + totalRowsS + "', 'totalRowsA':'" + totalRowsA + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + gsbs.size() + "', 'songList':[";
		if(gsbs.size() > 0){
			for(int i = 0; i < gsbs.size(); i++){
				int docI = i + 1;
				String cname = gsbs.get(i).get("cname").toString();
				int len = getTitleTen(cname);
				if(i == gsbs.size() - 1) retStr += "{'sid':'" + gsbs.get(i).get("id") + "', 'cname':'" + gsbs.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbs.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsbs.get(i).get("cfree") + "'}";
				else retStr +=  "{'sid':'" + gsbs.get(i).get("id") + "', 'cname':'" + gsbs.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbs.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsbs.get(i).get("cfree") + "'},";
			}
		} else{
			gsbs0 = InfoData.getSongsBySpell(pages, "");
			retStr = "{'ifNull':true, 'totalRowsS':'" + totalRowsS + "', 'totalRowsA':'" + totalRowsA + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + gsbs0.size() + "', 'songList':[";
			if(gsbs0.size() > 0){
				for(int i = 0; i < gsbs0.size(); i++){
					int docI = i + 1;
					String cname = gsbs0.get(i).get("cname").toString();
					int len = getTitleTen(cname);
					if(i == gsbs0.size() - 1) retStr += "{'sid':'" + gsbs0.get(i).get("id") + "', 'cname':'" + gsbs0.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbs0.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsbs0.get(i).get("cfree") + "'}";
					else retStr +=  "{'sid':'" + gsbs0.get(i).get("id") + "', 'cname':'" + gsbs0.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbs0.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gsbs0.get(i).get("cfree") + "'},";
				}
			}
		}
		retStr += "]}";
		out.print(retStr);
		return;
	} else if(ajaxData == 3){ // 搜索歌手
		int totalRowsS = InfoData.getSongsCountBySpell(key);
		int totalRowsA = InfoData.getArtistsCount(key);
		Page pages = new Page(totalRowsA, 10);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> ga = InfoData.getArtists(pages, key);
		List<Map<String, Object>> ga0 = new ArrayList<Map<String, Object>>();
		String retStr = "{'ifNull':false, 'totalRowsS':'" + totalRowsS + "', 'totalRowsA':'" + totalRowsA + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + ga.size() + "', 'artistList':[";
		if(ga.size() > 0){
			for(int i = 0; i < ga.size(); i++){
				int docI = i + 1;
				String cname = ga.get(i).get("cname").toString();
				int len = getTitleTen(cname);
				if(i == ga.size() - 1) retStr += "{'aid':'" + ga.get(i).get("id") + "', 'cname':'" + ga.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'sname':'" + ga.get(i).get("sname").toString().replaceAll("'", "\\\\'") + "', 'carea':'" + ga.get(i).get("carea") + "', 'ctype':'" + ga.get(i).get("ctype") + "', 'pic':'" + ga.get(i).get("pic") + "'}";
				else retStr +=  "{'aid':'" + ga.get(i).get("id") + "', 'cname':'" + ga.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'sname':'" + ga.get(i).get("sname").toString().replaceAll("'", "\\\\'") + "', 'carea':'" + ga.get(i).get("carea") + "', 'ctype':'" + ga.get(i).get("ctype") + "', 'pic':'" + ga.get(i).get("pic") + "'},";
			}
		} else{
			ga0 = InfoData.getArtists(pages, "");
			retStr = "{'ifNull':true, 'totalRowsS':'" + totalRowsS + "', 'totalRowsA':'" + totalRowsA + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + ga0.size() + "', 'artistList':[";
			if(ga0.size() > 0){
				for(int i = 0; i < ga0.size(); i++){
					int docI = i + 1;
					String cname = ga0.get(i).get("cname").toString();
					int len = getTitleTen(cname);
					if(i == ga0.size() - 1) retStr += "{'aid':'" + ga0.get(i).get("id") + "', 'cname':'" + ga0.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'sname':'" + ga0.get(i).get("sname").toString().replaceAll("'", "\\\\'") + "', 'carea':'" + ga0.get(i).get("carea") + "', 'ctype':'" + ga0.get(i).get("ctype") + "', 'pic':'" + ga0.get(i).get("pic") + "'}";
					else retStr +=  "{'aid':'" + ga0.get(i).get("id") + "', 'cname':'" + ga0.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'sname':'" + ga0.get(i).get("sname").toString().replaceAll("'", "\\\\'") + "', 'carea':'" + ga0.get(i).get("carea") + "', 'ctype':'" + ga0.get(i).get("ctype") + "', 'pic':'" + ga0.get(i).get("pic") + "'},";
				}
			}
		}
		retStr += "]}";
		out.print(retStr);
		return;
	}
%><%@include file="common/head.jsp" %>
<% 
	if(StringUtils.isBlank(nowFocus)){
		if(preferKeyboard.equals("0")) nowFocus = "f_search_5";
		else nowFocus = "f_search_33";
	}
	
	Page newPageS = new Page(8, 8);
	newPageS.setPageIndex(1);
	List<Map<String, Object>> gsbr = InfoData.getSongsByRecommend(newPageS, weekList, false);
	Page newPageA = new Page(5, 5);
	newPageA.setPageIndex(1);
	List<Map<String, Object>> gabr = InfoData.getArtistsByRecommend(newPageA, hotAList, false);
	// 获取推荐位
	int[] orUiIdxMar = {1002};
	int[] orUiIdxMar0 = {1002, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
	int[] uiParms0;
	if(StringUtils.isNotBlank(provinceN)) uiParms0 = (int[]) orUiIdxMar0.clone();
	else uiParms0 = (int[]) orUiIdxMar.clone();
	List<Map<String, Object>> guir = InfoData.getUiSearchRecommend("", 3, uiParms0);
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
			// 当前页码ID
			var pageId = <%=pageId %>;
			// 允许按键
			var allowClick = true;
			// 滑动频率
			var frequency = 10;
			// 用户偏好列表
			var preferList = <%=preferList %>;
			// 当前键盘
			var preferKeyboard = <%=preferKeyboard %>;
			// 当前右侧显示
			var rightDiv = <%=rightDiv %>;
			// t9键盘弹出
			var t9pop = 0;
			// 查询的关键字
			var speedstr = '<%=key.toUpperCase() %>';
			// 当前页码
			var pageIndex = <%=pageIndex %>;
			// 当前总页数
			var pageTotal = 0;
			// 当前页面查询出来的内容数
			var pageSum = 0;
			// 查询出来的歌曲总数
			var totalRowsS = 0;
			// 查询出来的歌手总数
			var totalRowsA = 0;
			// 当前类型检索结果是否空集
			var ifNull = false;
			// 搜索关键字歌曲是否存在
			var searchFlag = true;
			// 翻页响应是否在遥控器上
			var answerFlag = false;
			// 载入热门歌曲
			var jsonSong = [
				<%if(gsbr.size() > 0){for(int i = 0; i < gsbr.size(); i++){out.print("{'sid':'" + gsbr.get(i).get("id") + "', 'cname':'" + gsbr.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsbr.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'artistPic':'" + gsbr.get(i).get("artist_pic") + "', 'cfree':'" + gsbr.get(i).get("cfree") + "'}"); if(i < gsbr.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 载入热门歌手
			var jsonArtist = [
				<%if(gabr.size() > 0){for(int i = 0; i < gabr.size(); i++){out.print("{'aid':'" + gabr.get(i).get("id") + "', 'cname':'" + gabr.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'sname':'" + gabr.get(i).get("sname").toString().replaceAll("'", "\\\\'") + "', 'carea':'" + gabr.get(i).get("carea") + "', 'ctype':'" + gabr.get(i).get("ctype") + "', 'pic':'" + gabr.get(i).get("pic") + "'}"); if(i < gabr.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 载入推荐位
			var jsonRec = [
				<%if(guir.size() > 0){for(int i = 0; i < guir.size(); i++){out.print("{'pic':'" + guir.get(i).get("pic") + "', 'pic_word':'" + guir.get(i).get("pic_word") + "', 'pic_word_color':'" + guir.get(i).get("pic_word_color") + "', 'onclick_type':'" + guir.get(i).get("onclick_type") + "', 'curl':'" + guir.get(i).get("curl") + "', 'params':'" + guir.get(i).get("params") + "', 'createtime':'" + guir.get(i).get("createtime").toString().substring(0, 19) + "'}"); if(i < guir.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 异步加载出来的歌曲
			var songList = new Array();
			// 异步加载出来的歌手
			var artistList = new Array();
			// 收藏歌曲队列idsStr
			var collectStr = '<%=collectStr %>';
			// 推荐位区域载入flag
			var loadFlag = [false, false, false, false];
			// 控制是否执行start函数
			var ctlStart = false;
			// 访问页面的唯一id
			var viewId = '';
		</script>
	</head>

	<body onload='start()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 -->
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH  %>px;left:0px;top:0px'>
				<%=gpd.get("add") %>
				<div id='idsCheckedNum' style='position:absolute;width:30px;height:30px;left:1202px;top:30px;font-size:20px;color:#E7686A;text-align:center;z-index:3'><%if(idsCheckedNum > 99){%>99<span style='font-size:10px'>+</span><%} else{%><%=idsCheckedNum %><%}%></div>
				<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' />
				<div style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/commonly/skins/<%=preferTheme %>.png)'></div>
				<img src='images/application/pages/search/commonly/rt.png' style='position:absolute;width:108px;height:25px;left:466px;top:97px;visibility:hidden' />
				<div id='inputWords' style='position:absolute;width:265px;height:44px;left:132px;top:164px;font-size:20px;color:#FFFFFF;z-index:1'></div>
				<div id='tips' style='position:absolute;width:265px;height:44px;left:132px;top:164px;font-size:20px;color:#B2AFAA;z-index:1'>输入歌曲名或者歌手名</div>
				<img src='images/application/pages/search/commonly/input.png' style='position:absolute;width:328px;height:66px;left:77px;top:143px;z-index:1' />
				<img src='images/application/pages/search/commonly/magnifier.png' style='position:absolute;width:27px;height:27px;left:95px;top:162px;z-index:2' />
				<div style='position:absolute;width:320px;height:40px;left:85px;top:635px;font-size:17px;color:#FFFFFF;z-index:1'>输入拼音首字母，例如：王菲请输入“WF”</div>
				<img id='search_47' src='images/application/pages/search/commonly/t9.png' style='position:absolute;width:129px;height:49px;left:78px;top:84px;z-index:1' />
				<img class='btn_focus_hidden' id='f_search_47' src='images/application/pages/search/commonly/focus/f_t9.png' style='position:absolute;width:129px;height:49px;left:78px;top:84px;z-index:2' />
				<img id='c_f_search_47' src='images/application/pages/search/commonly/focus/c_f_t9.png' style='position:absolute;width:129px;height:49px;left:78px;top:84px;z-index:3;visibility:<%if(preferKeyboard.equals("0")){%>visible<%} else{%>hidden<%}%>' />
				<img id='search_48' src='images/application/pages/search/commonly/all.png' style='position:absolute;width:129px;height:49px;left:274px;top:84px;z-index:1' />
				<img class='btn_focus_hidden' id='f_search_48' src='images/application/pages/search/commonly/focus/f_all.png' style='position:absolute;width:129px;height:49px;left:274px;top:84px;z-index:2' />
				<img id='c_f_search_48' src='images/application/pages/search/commonly/focus/c_f_all.png' style='position:absolute;width:129px;height:49px;left:274px;top:84px;z-index:3;visibility:<%if(preferKeyboard.equals("1")){%>visible<%} else{%>hidden<%}%>' />
				<img id='search_49' src='images/application/pages/search/t9/del.png' style='position:absolute;width:102px;height:49px;left:78px;top:552px;z-index:1' />
				<img class='btn_focus_hidden' id='f_search_49' src='images/application/pages/search/t9/focus/f_del.png' style='position:absolute;width:102px;height:49px;left:78px;top:552px;z-index:2' />
				<img id='search_50' src='images/application/pages/search/t9/clear.png' style='position:absolute;width:102px;height:49px;left:302px;top:552px;z-index:1' />
				<img class='btn_focus_hidden' id='f_search_50' src='images/application/pages/search/t9/focus/f_clear.png' style='position:absolute;width:102px;height:49px;left:302px;top:552px;z-index:2' />
				<img id='search_51' src='images/application/pages/search/commonly/collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_search_51' src='images/application/pages/search/commonly/focus/f_collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:2' />
				<img id='search_52' src='images/application/pages/search/commonly/checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_search_52' src='images/application/pages/search/commonly/focus/f_checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:2' />
				<!-- t9键盘 -->
				<div id='t9Div' style='display:<%if(preferKeyboard.equals("0")){%>block<%} else{%>none<%}%>'>
					<div id='t9bottom'><%for(int i = 1; i <= 9; i++){%>
						<img id='search_<%=i %>' src='images/application/pages/search/t9/<%=i %>.png' style='position:absolute;width:83px;height:83px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 112 + 87 %>px;top:<%=(((int) Math.ceil((double) i / 3)) - 1) * 103 + 231 %>px;z-index:1' />
						<img class='btn_focus_hidden' id='f_search_<%=i %>' src='images/application/pages/search/t9/focus/f_<%=i %>.png' style='position:absolute;width:83px;height:83px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 112 + 87 %>px;top:<%=(((int) Math.ceil((double) i / 3)) - 1) * 103 + 231 %>px;z-index:2' /><%}%>
					</div>
					<img id='search_10' src='images/application/pages/search/t9/0.png' style='position:absolute;width:83px;height:83px;left:199px;top:540px;z-index:1' />
					<img class='btn_focus_hidden' id='f_search_10' src='images/application/pages/search/t9/focus/f_0.png' style='position:absolute;width:83px;height:83px;left:199px;top:540px;z-index:2' /><%for(int i = 2; i <= 9; i++){%>
					<img id='c_f_search_<%=i %>' src='images/application/pages/search/t9/focus/c_f_<%=i %>.png' style='position:absolute;width:314px;height:298px;left:83px;top:231px;z-index:3;visibility:hidden' /><%}%>
				</div>
				<!-- 全键盘 -->
				<div id='allDiv' style='display:<%if(preferKeyboard.equals("1")){%>block<%} else{%>none<%}%>'><%for(int i = 1; i <= 36; i++){%>
					<img id='search_<%=i + 10 %>' src='images/application/pages/search/all/<%if(i < 27){%><%=(char) (i + 64)%><%} else{%><%=i - 27%><%}%>.png' style='position:absolute;width:49px;height:49px;left:<%=((i % 6 == 0 ? 6 : i % 6) - 1) * 54 + 82 %>px;top:<%=(((int) Math.ceil((double) i / 6)) - 1) * 53 + 223 %>px;z-index:1' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 10 %>' src='images/application/pages/search/all/focus/f_<%if(i < 27){%><%=(char) (i + 64) %><%} else{%><%=i - 27 %><%}%>.png' style='position:absolute;width:49px;height:49px;left:<%=((i % 6 == 0 ? 6 : i % 6) - 1) * 54 + 82 %>px;top:<%=(((int) Math.ceil((double) i / 6)) - 1) * 53 + 223 %>px;z-index:2' /><%}%>
				</div>
				<!-- 优化加载闪烁，右边部分抽离一些元素 -->
				<img id='rtDiv' src='images/application/pages/search/commonly/rt.png' style='position:absolute;width:108px;height:25px;left:466px;top:97px;visibility:hidden' />
				<!-- 右半边默认 -->
				<div id='right_default'>
					<img src='images/application/pages/search/commonly/hot.png' style='position:absolute;width:99px;height:24px;left:466px;top:97px' />
					<img src='images/application/pages/search/commonly/song.png' style='position:absolute;width:49px;height:20px;left:464px;top:145px' />
					<img src='images/application/pages/search/commonly/artist.png' style='position:absolute;width:49px;height:20px;left:464px;top:423px' /><%for(int i = 1; i <= 8; i++){%>
					<img src='images/application/pages/search/commonly/song_bot.png' style='position:absolute;width:343px;height:51px;left:<%=i <= 4 ? 465 : 857 %>px;top:<%=((i % 4 == 0 ? 4 : i % 4) - 1) * 55 + 180 %>px;z-index:1' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 52 %>' src='images/application/pages/search/commonly/focus/f_rms.png' style='position:absolute;width:365px;height:73px;left:<%=i <= 4 ? 454 : 846 %>px;top:<%=((i % 4 == 0 ? 4 : i % 4) - 1) * 55 + 169 %>px;z-index:3' />
					<div id='s_<%=i %>' style='position:absolute;width:292px;height:28px;left:<%=i <= 4 ? 474 : 866 %>px;top:<%=((i % 4 == 0 ? 4 : i % 4) - 1) * 55 + 190 %>px;font-size:22px;color:#FFFFFF;overflow:hidden;z-index:2'></div>
					<img id='free_s_<%=i %>' src='images/application/pages/index/commonly/free.png' style='position:absolute;width:38px;height:17px;left:<%=i <= 4 ? 766 : 1158 %>px;top:<%=((i % 4 == 0 ? 4 : i % 4) - 1) * 55 + 198 %>px;z-index:4;visibility:hidden' /><%} for(int i = 1; i <= 5; i++){%>
					<img src='images/application/pages/search/commonly/underlay.png' style='position:absolute;width:136px;height:136px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 464 %>px;top:470px;z-index:1' />
					<img id='ap_<%=i %>' src='images/application/pages/search/commonly/null.png' style='position:absolute;width:136px;height:136px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 464 %>px;top:470px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 60 %>' src='images/application/pages/search/commonly/focus/f_rma.png' style='position:absolute;width:158px;height:158px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 453 %>px;top:459px;z-index:3' />
					<div id='at_<%=i %>' style='position:absolute;width:158px;height:40px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 453 %>px;top:625px;color:#FFFFFF;font-size:20px;text-align:center;z-index:1'></div><%}%>
				</div>
				<!-- 右半边歌曲搜索有结果 -->
				<div id='right_song_y' style='display:none'>
					<div id='totalRowsS' style='position:absolute;width:50px;height:30px;left:529px;top:161px;color:#FFAE00'></div>
					<div id='totalRowsA' style='position:absolute;width:50px;height:30px;left:660px;top:161px;color:#FFAE00'></div>
					<div id='pageIndex' style='position:absolute;width:40px;height:30px;left:1188px;top:345px;color:#FFFFFF;text-align:center'></div>
					<div id='pageTotal' style='position:absolute;width:40px;height:30px;left:1188px;top:387px;color:#FFFFFF;text-align:center'></div>
					<img id='nextPS' src='images/application/pages/search/commonly/next.png' style='position:absolute;width:28px;height:15px;left:793px;top:635px;visibility:hidden' />
					<img id='pageDiv' src='images/application/pages/search/commonly/page.png' style='position:absolute;width:45px;height:162px;left:1186px;top:296px;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_92' src='images/application/pages/search/commonly/focus/f_s.png' style='position:absolute;width:36px;height:36px;left:1191px;top:300px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_93' src='images/application/pages/search/commonly/focus/f_x.png' style='position:absolute;width:36px;height:36px;left:1191px;top:419px;z-index:2' />
					<img id='search_66' src='images/application/pages/search/commonly/r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:1' />
					<img id='search_67' src='images/application/pages/search/commonly/r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:1' />
					<img class='btn_focus_hidden' id='f_search_66' src='images/application/pages/search/commonly/focus/f_r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_67' src='images/application/pages/search/commonly/focus/f_r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:2' />
					<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:69px;height:1px;left:461px;top:185px;z-index:3' /><%for(int i = 1; i <= 8; i++){%>
					<div id='c_s_<%=i %>' style='position:absolute;width:290px;height:26px;left:466px;top:<%=(i - 1) * 52 + 212 %>px;color:#FFFFFF;font-size:20px;overflow:hidden;z-index:1'></div>
					<img id='free_<%=i %>' src='images/application/pages/index/commonly/free.png' style='position:absolute;width:32px;height:15px;left:754px;top:<%=(i - 1) * 52 + 219 %>px;z-index:1;visibility:hidden' />
					<div id='c_a_<%=i %>' style='position:absolute;width:165px;height:24px;left:790px;top:<%=(i - 1) * 52 + 214 %>px;color:#B2AFAA;font-size:18px;text-align:right;overflow:hidden;z-index:1'></div>
					<img id='back_<%=i %>' src='images/application/pages/search/song/back.png' style='position:absolute;width:687px;height:50px;left:461px;top:<%=(i - 1) * 52 + 199 %>px;z-index:2;visibility:hidden' />
					<img id='search_<%=i + 67 %>' src='images/application/pages/search/song/play.png' style='position:absolute;width:58px;height:58px;left:959px;top:<%=(i - 1) * 52 + 195 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 67 %>' src='images/application/pages/search/song/focus/f_play.png' style='position:absolute;width:58px;height:58px;left:959px;top:<%=(i - 1) * 52 + 195 %>px;z-index:4' />
					<img id='search_<%=i + 75 %>' src='images/application/pages/search/song/collect.png' style='position:absolute;width:58px;height:58px;left:1026px;top:<%=(i - 1) * 52 + 195 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 75 %>' src='images/application/pages/search/song/focus/f_collect.png' style='position:absolute;width:58px;height:58px;left:1026px;top:<%=(i - 1) * 52 + 195 %>px;z-index:4' />
					<img id='search_<%=i + 83 %>' src='images/application/pages/search/song/add.png' style='position:absolute;width:58px;height:58px;left:1091px;top:<%=(i - 1) * 52 + 195 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 83 %>' src='images/application/pages/search/song/focus/f_add.png' style='position:absolute;width:58px;height:58px;left:1091px;top:<%=(i - 1) * 52 + 195 %>px;z-index:4' /><%}%>
				</div>
				<!-- 右半边歌手搜索有结果 -->
				<div id='right_artist_y' style='display:none'>
					<div id='totalRowsSA' style='position:absolute;width:50px;height:30px;left:529px;top:161px;color:#FFAE00'></div>
					<div id='totalRowsAA' style='position:absolute;width:50px;height:30px;left:660px;top:161px;color:#FFAE00'></div>
					<div id='pageIndexA' style='position:absolute;width:40px;height:30px;left:1188px;top:345px;color:#FFFFFF;text-align:center'></div>
					<div id='pageTotalA' style='position:absolute;width:40px;height:30px;left:1188px;top:387px;color:#FFFFFF;text-align:center'></div>
					<img id='nextPA' src='images/application/pages/search/commonly/next.png' style='position:absolute;width:28px;height:15px;left:793px;top:635px;visibility:hidden' />
					<img id='pageDivA' src='images/application/pages/search/commonly/page.png' style='position:absolute;width:45px;height:162px;left:1186px;top:296px;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_104' src='images/application/pages/search/commonly/focus/f_s.png' style='position:absolute;width:36px;height:36px;left:1191px;top:300px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_105' src='images/application/pages/search/commonly/focus/f_x.png' style='position:absolute;width:36px;height:36px;left:1191px;top:419px;z-index:2' />
					<img id='search_106' src='images/application/pages/search/commonly/r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:1' />
					<img id='search_107' src='images/application/pages/search/commonly/r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:1;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_106' src='images/application/pages/search/commonly/focus/f_r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_107' src='images/application/pages/search/commonly/focus/f_r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:2' />
					<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:69px;height:1px;left:590px;top:185px;z-index:3' /><%for(int i = 1; i <= 10; i++){%>
					<img src='images/application/pages/search/commonly/underlay.png' style='position:absolute;width:136px;height:136px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 439 %>px;top:<%=i <= 5 ? 205 : 414 %>px;z-index:1' />
					<img id='d_p_<%=i %>' src='images/application/pages/search/commonly/null.png' style='position:absolute;width:136px;height:136px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 439 %>px;top:<%=i <= 5 ? 205 : 414 %>px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 107 %>' src='images/application/pages/search/commonly/focus/f_rma.png' style='position:absolute;width:158px;height:158px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 428 %>px;top:<%=i <= 5 ? 194 : 403 %>px;z-index:3' />
					<div id='d_a_<%=i %>' style='position:absolute;width:158px;height:40px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 428 %>px;top:<%=i <= 5 ? 356 : 565 %>px;color:#FFFFFF;font-size:20px;text-align:center;z-index:1'></div><%}%>
				</div>
				<!-- 右半边歌曲搜索没有结果 -->
				<div id='right_song_n' style='display:none'>
					<img src='images/application/pages/search/commonly/guess.png' style='position:absolute;width:108px;height:25px;left:466px;top:438px' />
					<div id='totalRowsSE' style='position:absolute;width:50px;height:30px;left:529px;top:161px;color:#FFAE00'></div>
					<div id='totalRowsAE' style='position:absolute;width:50px;height:30px;left:660px;top:161px;color:#FFAE00'></div>
					<img id='search_118' src='images/application/pages/search/commonly/r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:1;visibility:hidden' />
					<img id='search_119' src='images/application/pages/search/commonly/r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:1' />
					<img class='btn_focus_hidden' id='f_search_118' src='images/application/pages/search/commonly/focus/f_r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_119' src='images/application/pages/search/commonly/focus/f_r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:2' />
					<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:69px;height:1px;left:461px;top:185px;z-index:3' /><%for(int i = 1; i <= 4; i++){%>
					<div id='e_s_<%=i %>' style='position:absolute;width:290px;height:26px;left:466px;top:<%=(i - 1) * 52 + 212 %>px;color:#FFFFFF;font-size:20px;overflow:hidden;z-index:1'></div>
					<img id='free_e_<%=i %>' src='images/application/pages/index/commonly/free.png' style='position:absolute;width:32px;height:15px;left:754px;top:<%=(i - 1) * 52 + 219 %>px;z-index:1;visibility:hidden' />
					<div id='e_a_<%=i %>' style='position:absolute;width:165px;height:24px;left:790px;top:<%=(i - 1) * 52 + 214 %>px;color:#B2AFAA;font-size:18px;text-align:right;overflow:hidden;z-index:1'></div>
					<img id='back_e_<%=i %>' src='images/application/pages/search/song/back.png' style='position:absolute;width:687px;height:50px;left:461px;top:<%=(i - 1) * 52 + 199 %>px;z-index:2;visibility:hidden' />
					<img id='search_<%=i + 119 %>' src='images/application/pages/search/song/play.png' style='position:absolute;width:58px;height:58px;left:959px;top:<%=(i - 1) * 52 + 195 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 119 %>' src='images/application/pages/search/song/focus/f_play.png' style='position:absolute;width:58px;height:58px;left:959px;top:<%=(i - 1) * 52 + 195 %>px;z-index:4' />
					<img id='search_<%=i + 123 %>' src='images/application/pages/search/song/collect.png' style='position:absolute;width:58px;height:58px;left:1026px;top:<%=(i - 1) * 52 + 195 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 123 %>' src='images/application/pages/search/song/focus/f_collect.png' style='position:absolute;width:58px;height:58px;left:1026px;top:<%=(i - 1) * 52 + 195 %>px;z-index:4' />
					<img id='search_<%=i + 127 %>' src='images/application/pages/search/song/add.png' style='position:absolute;width:58px;height:58px;left:1091px;top:<%=(i - 1) * 52 + 195 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 127 %>' src='images/application/pages/search/song/focus/f_add.png' style='position:absolute;width:58px;height:58px;left:1091px;top:<%=(i - 1) * 52 + 195 %>px;z-index:4' /><%} for(int i = 1; i <= 3; i++){%>
					<img src='images/application/pages/search/commonly/recommend.png' style='position:absolute;width:244px;height:142px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 453 %>px;top:485px;z-index:1' />
					<img id='e_r_<%=i %>' src='images/application/pages/search/commonly/null.png' style='position:absolute;width:244px;height:142px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 453 %>px;top:485px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 131 %>' src='images/application/pages/search/commonly/focus/f_recommend.png' style='position:absolute;width:267px;height:165px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 442 %>px;top:474px;z-index:3' /><%}%>
				</div>
				<!-- 右半边歌曲搜索没有结果 -->
				<div id='right_artist_n' style='display:none'>
					<img src='images/application/pages/search/commonly/guess.png' style='position:absolute;width:108px;height:25px;left:466px;top:438px' />
					<div id='totalRowsSF' style='position:absolute;width:50px;height:30px;left:529px;top:161px;color:#FFAE00'></div>
					<div id='totalRowsAF' style='position:absolute;width:50px;height:30px;left:660px;top:161px;color:#FFAE00'></div>
					<img id='search_135' src='images/application/pages/search/commonly/r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:1;visibility:hidden' />
					<img id='search_136' src='images/application/pages/search/commonly/r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:1' />
					<img class='btn_focus_hidden' id='f_search_135' src='images/application/pages/search/commonly/focus/f_r_song.png' style='position:absolute;width:69px;height:37px;left:461px;top:148px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_136' src='images/application/pages/search/commonly/focus/f_r_artist.png' style='position:absolute;width:69px;height:37px;left:590px;top:148px;z-index:2' />
					<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:69px;height:1px;left:590px;top:185px;z-index:3' /><%for(int i = 1; i <= 5; i++){%>
					<img src='images/application/pages/search/commonly/underlay.png' style='position:absolute;width:136px;height:136px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 439 %>px;top:205px;z-index:1' />
					<img id='f_p_<%=i %>' src='images/application/pages/search/commonly/null.png' style='position:absolute;width:136px;height:136px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 439 %>px;top:205px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 136 %>' src='images/application/pages/search/commonly/focus/f_rma.png' style='position:absolute;width:158px;height:158px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 428 %>px;top:194px;z-index:3' />
					<div id='f_a_<%=i %>' style='position:absolute;width:158px;height:40px;left:<%=((i % 5 == 0 ? 5 : i % 5) - 1) * 150 + 428 %>px;top:356px;color:#FFFFFF;font-size:20px;text-align:center;z-index:1'></div><%} for(int i = 1; i <= 3; i++){%>
					<img src='images/application/pages/search/commonly/recommend.png' style='position:absolute;width:244px;height:142px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 453 %>px;top:485px;z-index:1' />
					<img id='f_r_<%=i %>' src='images/application/pages/search/commonly/null.png' style='position:absolute;width:244px;height:142px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 453 %>px;top:485px;z-index:2' />
					<img class='btn_focus_hidden' id='f_search_<%=i + 141 %>' src='images/application/pages/search/commonly/focus/f_recommend.png' style='position:absolute;width:267px;height:165px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 442 %>px;top:474px;z-index:3' /><%}%>
				</div>
				<script type='text/javascript' src='javascript/pages/search.js?r=<%=Math.random() %>'></script>
			</div>
		</div><%@include file="common/footer.jsp" %>