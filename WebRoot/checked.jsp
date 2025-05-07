<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,java.text.DecimalFormat,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_list_100003" : DoParam.AnalysisAbb("n", request);
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "1" : DoParam.AnalysisAbb("p", request));
	pageIndex = pageIndex == 0 ? 1 : pageIndex; // 因为已选曲目有空列表问题

	int pageLimit = 10;
	if(ajaxData == 1){ // 列表歌曲
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		int tmpHour = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("h", request)) ? "24" : DoParam.AnalysisAbb("h", request));
		int tmpMax = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("m", request)) ? "100" : DoParam.AnalysisAbb("m", request));
		int totalRows = InfoData.getSongsCountByChecked(tmpUid, tmpHour, tmpMax);
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gsba = InfoData.getSongsByChecked(pages, tmpUid, tmpHour, tmpMax);
		String retStr = "{'ifNull':false, 'totalRows':'" + totalRows + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + gsba.size() + "', 'songList':[";
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
	}
%><%@include file="common/head.jsp" %>
<%
	// 获取推荐位
	int[] orUiIdxMar = {1002};
	int[] orUiIdxMar0 = {1002, Integer.parseInt(StringUtils.isNotBlank(provinceN) ? provinceN : "0")};
	int[] uiParms0;
	if(StringUtils.isNotBlank(provinceN)) uiParms0 = (int[]) orUiIdxMar0.clone();
	else uiParms0 = (int[]) orUiIdxMar.clone();
	List<Map<String, Object>> guir = InfoData.getUiSearchRecommend("", 6, uiParms0);
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
			// 翻页响应是否在遥控器上
			var answerFlag = false;
			// 异步加载出来的歌曲
			var songList = new Array();
			// 歌曲ID集合
			var songIds = '';
			// 收藏歌曲队列idsStr
			var collectStr = '<%=collectStr %>';
			// 是否支持动画 0:不支持 1:支持
			var animation = <%=animation %>;
			// 是否多次载入内容
			var multipleLoad = false;
			// 上依次执行的操作
			var lstOpera = '';
			// 删除曲目往上滚动一页并且选中最后一条目
			var needreload = false;
			// 遥控延迟响应计时器
			var layTimes;
			// 载入推荐位
			var jsonRec = [
				<%if(guir.size() > 0){for(int i = 0; i < guir.size(); i++){out.print("{'pic':'" + guir.get(i).get("pic") + "', 'pic_word':'" + guir.get(i).get("pic_word") + "', 'pic_word_color':'" + guir.get(i).get("pic_word_color") + "', 'onclick_type':'" + guir.get(i).get("onclick_type") + "', 'curl':'" + guir.get(i).get("curl") + "', 'params':'" + guir.get(i).get("params") + "', 'createtime':'" + guir.get(i).get("createtime").toString().substring(0, 19) + "'}"); if(i < guir.size() - 1){ out.print(",\n\t\t\t\t"); }}}%>
			];
			// 推荐位区域载入flag
			var loadFlag = false;
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
				<div style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/commonly/skins/<%=preferTheme %>.png)'></div>
				<div id='idsCheckedNum' style='position:absolute;width:30px;height:30px;left:1202px;top:30px;font-size:20px;color:#E7686A;text-align:center;z-index:3'><%if(idsCheckedNum > 99){%>99<span style='font-size:10px'>+</span><%} else{%><%=idsCheckedNum %><%}%></div>
				<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:1px;height:466px;left:412px;top:132px' />
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' />
				<img id='l1' src='images/application/pages/index/commonly/line.png' style='position:absolute;width:165px;height:3px;left:166px;top:494px;z-index:10;visibility:hidden' />
				<img id='l2' src='images/application/pages/index/commonly/line.png' style='position:absolute;width:165px;height:3px;left:166px;top:554px;z-index:10;visibility:hidden' />
				<img src='images/application/pages/checked/checked.png' style='position:absolute;width:199px;height:229px;left:148px;top:165px;z-index:1'>
				<div style='position:absolute;width:50px;height:30px;left:430px;top:206px;font-size:18px;color:#FFFFFF;z-index:2;visibility:hidden'>已点</div>
				<div id='totalRows' style='position:absolute;width:80px;height:30px;left:480px;top:200px;font-size:30px;color:#FFFFFF;z-index:2;visibility:hidden'></div>
				<img id='list_100001' src='images/application/pages/search/commonly/collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100001' src='images/application/pages/search/commonly/focus/f_collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:2' />
				<img id='list_100002' src='images/application/pages/search/commonly/checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100002' src='images/application/pages/search/commonly/focus/f_checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:2' />
				<img id='list_100003' src='images/application/pages/checked/playAll.png' style='position:absolute;width:153px;height:55px;left:172px;top:468px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100003' src='images/application/pages/checked/focus/f_playAll.png' style='position:absolute;width:153px;height:55px;left:172px;top:468px;z-index:2' />
				<img id='list_100004' src='images/application/pages/checked/clear.png' style='position:absolute;width:153px;height:55px;left:172px;top:528px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100004' src='images/application/pages/checked/focus/f_clear.png' style='position:absolute;width:153px;height:55px;left:172px;top:528px;z-index:2' />
				<div id='rightDiv_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
					<img id='nextP' src='images/application/pages/search/commonly/next.png' style='position:absolute;width:28px;height:15px;left:793px;top:673px;visibility:hidden' />
					<div id='pageIndex' style='position:absolute;width:40px;height:30px;left:1215px;top:364px;color:#FFFFFF;text-align:center'></div>
					<div id='pageTotal' style='position:absolute;width:40px;height:30px;left:1215px;top:406px;color:#FFFFFF;text-align:center'></div>
					<img id='pageDiv' src='images/application/pages/search/commonly/page.png' style='position:absolute;width:45px;height:162px;left:1213px;top:315px;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_100005' src='images/application/pages/search/commonly/focus/f_s.png' style='position:absolute;width:36px;height:36px;left:1218px;top:319px;z-index:2' />
					<img class='btn_focus_hidden' id='f_list_100006' src='images/application/pages/search/commonly/focus/f_x.png' style='position:absolute;width:36px;height:36px;left:1218px;top:438px;z-index:2' /><%for(int i = 1; i <= pageLimit; i++){ int x = 430; int y = 118;%>
					<div id='c_s_<%=i %>' style='position:absolute;width:325px;height:26px;left:<%=x %>px;top:<%=(i - 1) * 52 + y + 30 %>px;color:#FFFFFF;font-size:20px;overflow:hidden;z-index:1'></div>
					<img id='free_<%=i %>' src='images/application/pages/index/commonly/free.png' style='position:absolute;width:32px;height:15px;left:<%=x + 323 %>px;top:<%=(i - 1) * 52 + y + 37 %>px;z-index:1;visibility:hidden' />
					<div id='c_a_<%=i %>' style='position:absolute;width:200px;height:24px;left:<%=x + 359 %>px;top:<%=(i - 1) * 52 + y + 32 %>px;color:#B2AFAA;font-size:18px;text-align:right;overflow:hidden;z-index:1'></div>
					<img id='back_<%=i %>' src='images/application/pages/search/song/back.png' style='position:absolute;width:757px;height:50px;left:<%=x - 5 %>px;top:<%=(i - 1) * 52 + y + 17 %>px;z-index:2;visibility:hidden' />
					<img id='list_<%=i %>' src='images/application/pages/search/song/play.png' style='position:absolute;width:58px;height:58px;left:<%=x + 563 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_<%=i %>' src='images/application/pages/checked/focus/f_play.png' style='position:absolute;width:58px;height:58px;left:<%=x + 563 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:4' />
					<img id='list_<%=i + pageLimit %>' src='images/application/pages/checked/delete.png' style='position:absolute;width:58px;height:58px;left:<%=x + 630 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_<%=i + pageLimit %>' src='images/application/pages/checked/focus/f_delete.png' style='position:absolute;width:58px;height:58px;left:<%=x + 630 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:4' />
					<img id='list_<%=i + pageLimit * 2 %>' src='images/application/pages/checked/<%if(pageIndex == 1 && i == 1){%>first<%} else{%>top<%}%>.png' style='position:absolute;width:58px;height:58px;left:<%=x + 695 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_<%=i + pageLimit * 2 %>' src='images/application/pages/checked/focus/f_<%if(pageIndex == 1 && i == 1){%>first<%} else{%>top<%}%>.png' style='position:absolute;width:58px;height:58px;left:<%=x + 695 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:4' /><%}%>
					<div id='songS'></div>
					<div id='recDiv' style='display:none'>
						<img src='images/application/pages/search/commonly/guess.png' style='position:absolute;width:108px;height:25px;left:466px;top:248px;z-index:10' />
						<img src='images/application/pages/checked/none.png' style='position:absolute;width:285px;height:59px;left:675px;top:140px;z-index:10' /><%for(int i = 1; i <= 6; i++){ int y = i <= 3 ? 301 : 453;%>
						<img src='images/application/pages/search/commonly/recommend.png' style='position:absolute;width:244px;height:142px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 453 %>px;top:<%=y %>px;z-index:1' />
						<img id='f_r_<%=i %>' src='images/application/pages/search/commonly/null.png' style='position:absolute;width:244px;height:142px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 453 %>px;top:<%=y %>px;z-index:2' />
						<img class='btn_focus_hidden' id='f_list_<%=i + 100007 %>' src='images/application/pages/search/commonly/focus/f_recommend.png' style='position:absolute;width:267px;height:165px;left:<%=((i % 3 == 0 ? 3 : i % 3) - 1) * 254 + 442 %>px;top:<%=y - 11 %>px;z-index:3' /><%}%>
					</div>
				</div>
			</div>
			<script type='text/javascript' src='javascript/pages/checked.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>