<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,java.text.DecimalFormat,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_list_100003" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "1" : DoParam.AnalysisAbb("p", request));

	int pageLimit = 8;
	int defList = key.contains(",") ? 0 : Integer.parseInt(key);
	if(ajaxData == 1){ // 列表歌曲
		int totalRows = InfoData.getSongsCountByRecommend(defList, false);
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gsba = InfoData.getSongsByRecommend(pages, defList, false);
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
	} else if(ajaxData == 2){ // 更改用户偏好列表
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		int row = InfoData.updateUserInfo(tmpUid, "preferList", key);
		String retStr = "{'result':'0'}";
		if(row > 0) retStr = "{'result':'1'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 3){
		List<Map<String, Object>> gsba = InfoData.getSongByIds(key);
		String jsonStr = "";
		if(gsba.size() > 0){
			for(int i = 0; i < gsba.size(); i++){
				String cres = gsba.get(i).get("cres").toString();
				if(cres.contains("playurl")){ // 针对福建移动特殊判断 2022-01-19
					JSONObject cresJson = new JSONObject(cres);
					cres = cresJson.get("playurl").toString();
				}
				jsonStr += "{'sid':'" + gsba.get(i).get("id") + "', 'cname':'" + gsba.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsba.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cres':'" + cres + "'}";
				if(i < gsba.size() - 1){
					jsonStr += ",";
				}
			}
		}
		jsonStr = "[" + jsonStr + "]";
		out.print(jsonStr);
		return;
	}
%><%@include file="common/head.jsp" %>
<%
	// 获取列表信息
	Map<String, Object> gabr = InfoData.getEntityAlbumlist(defList);
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
			// 列表ID
			var albumlistId = <%=key %>;
			// 列表名
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
			// 翻页响应是否在遥控器上
			var answerFlag = false;
			// 异步加载出来的歌曲
			var songList = new Array();
			// 播放队列
			var playList = new Array();
			// 歌曲ID集合
			var songIds = '';
			// 上一个播放的曲目ID
			var lastId = '';
			// 收藏歌曲队列idsStr
			var collectStr = '<%=collectStr %>';
			// 是否支持动画 0:不支持 1:支持
			var animation = <%=animation %>;
			// 是否多次载入内容
			var multipleLoad = false;
			// 小视频位置
			var stbPos = [1014, 95, 243, 136];
			// 遥控延迟响应计时器
			var layTimes;
			// 控制是否执行start函数
			var ctlStart = false;
			// 访问页面的唯一id
			var viewId = '';
		</script>
	</head>

	<body onload='start()' onunload='destoryMP()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 --><%String backPic = gabr.get("back_pic") == null ? "" : gabr.get("back_pic").toString();%>
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<div id='pageindexbgReal' style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/commonly/skins/<%=preferTheme %>.png)'></div>
			<div id='pageindexbgl' style='position:absolute;width:0px;height:<%if(StringUtils.isBlank(backPic)){%><%=pageH %><%} else{%><%=pageH %><%}%>px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img src='<%if(StringUtils.isBlank(backPic)){%>images/commonly/skins/<%=preferTheme %>.png<%} else{%>images/commonly/list_back_pic/<%=backPic %><%}%>'>
			</div>
			<div id='pageindexbgu' style='position:absolute;width:<%=pageW %>px;height:0px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img src='<%if(StringUtils.isBlank(backPic)){%>images/commonly/skins/<%=preferTheme %>.png<%} else{%>images/commonly/list_back_pic/<%=backPic %><%}%>'>
			</div>
			<div id='pageindexbgr' style='position:absolute;width:0px;height:<%if(StringUtils.isBlank(backPic)){%><%=pageH %><%} else{%><%=pageH %><%}%>px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img id='imgindexbgr' src='<%if(StringUtils.isBlank(backPic)){%>images/commonly/skins/<%=preferTheme %>.png<%} else{%>images/commonly/list_back_pic/<%=backPic %><%}%>' style='position:absolute;width:<%=pageW %>px;height:<%if(StringUtils.isBlank(backPic)){%><%=pageH %><%} else{%><%=pageH %><%}%>px;left:0px;top:0px;z-index:-1'>
			</div>
			<div id='pageindexbgd' style='position:absolute;width:<%=pageW %>px;height:0px;left:0px;top:0px;z-index:-1;overflow:hidden'>
				<img id='imgindexbgd' src='<%if(StringUtils.isBlank(backPic)){%>images/commonly/skins/<%=preferTheme %>.png<%} else{%>images/commonly/list_back_pic/<%=backPic %><%}%>' style='position:absolute;width:<%=pageW %>px;height:<%if(StringUtils.isBlank(backPic)){%><%=pageH %><%} else{%><%=pageH %><%}%>px;left:0px;top:0px;z-index:-1'>
			</div><%int backGrey = Integer.parseInt(gabr.get("back_grey").toString()); if(StringUtils.isNotBlank(backPic) && backGrey == 1){%>
			<img src='images/application/utils/common/grey.png' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px' /><%}%>
			<script type='text/javascript'>
				function calculateSmallVod(){
					// 计算出小视频的镂空<%JSONObject partB = new JSONObject(); partB.put("x", "1015"); partB.put("y", "95"); partB.put("w", "242"); partB.put("h", "136"); %>
					$g('pageindexbgl').style.width = '<%=partB.get("x") %>px';
					$g('pageindexbgu').style.height = '<%=partB.get("y") %>px';
					$g('imgindexbgr').style.left = '-<%=Integer.parseInt(partB.get("x").toString()) + Integer.parseInt(partB.get("w").toString()) %>px';
					$g('pageindexbgr').style.left = '<%=Integer.parseInt(partB.get("x").toString()) + Integer.parseInt(partB.get("w").toString()) %>px';
					$g('pageindexbgr').style.width = '<%=pageW - Integer.parseInt(partB.get("x").toString()) - Integer.parseInt(partB.get("w").toString()) %>px';
					$g('imgindexbgd').style.top = '-<%=Integer.parseInt(partB.get("y").toString()) + Integer.parseInt(partB.get("h").toString()) %>px';
					$g('pageindexbgd').style.top = '<%=Integer.parseInt(partB.get("y").toString()) + Integer.parseInt(partB.get("h").toString()) %>px';
					$g('pageindexbgd').style.height = '<%=pageH - Integer.parseInt(partB.get("y").toString()) - Integer.parseInt(partB.get("h").toString()) %>px';
				}
			</script>
			<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH  %>px;left:0px;top:0px'>
				<%=gpd.get("add") %>
				<div id='idsCheckedNum' style='position:absolute;width:30px;height:30px;left:1202px;top:30px;font-size:20px;color:#E7686A;text-align:center;z-index:3'><%if(idsCheckedNum > 99){%>99<span style='font-size:10px'>+</span><%} else{%><%=idsCheckedNum %><%}%></div>
				<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:1px;height:466px;left:412px;top:132px' />
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' /><%String picPos = gabr.get("pic_pos") == null ? "0,0,0,0" : gabr.get("pic_pos").toString(); String[] realPos = picPos.split(",");%>
				<img src='images/commonly/list_pic/<%=gabr.get("pic") %>' style='position:absolute;width:<%=realPos[0]%>px;height:<%=realPos[1]%>px;left:<%=realPos[2]%>px;top:<%=realPos[3]%>px;z-index:1' />
				<img id='list_100001' src='images/application/pages/search/commonly/collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100001' src='images/application/pages/search/commonly/focus/f_collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:2' />
				<img id='list_100002' src='images/application/pages/search/commonly/checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100002' src='images/application/pages/search/commonly/focus/f_checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:2' />
				<img id='list_100003' src='images/application/pages/artist/playAll.png' style='position:absolute;width:153px;height:55px;left:172px;top:468px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100003' src='images/application/pages/artist/focus/f_playAll.png' style='position:absolute;width:153px;height:55px;left:172px;top:468px;z-index:2' />
				<img id='list_100004' src='images/application/pages/artist/fashion.png' style='position:absolute;width:153px;height:55px;left:172px;top:528px;z-index:1' />
				<img class='btn_focus_hidden' id='f_list_100004' src='images/application/pages/artist/focus/f_fashion.png' style='position:absolute;width:153px;height:55px;left:172px;top:528px;z-index:2' />
				<div style='position:absolute;width:270px;height:30px;left:115px;top:375px;font-size:28px;color:#FFFFFF;text-align:center;z-index:2'><%=gabr.get("cname").toString().replaceAll("'", "\\\\'") %></div>
				<div style='position:absolute;width:355px;height:30px;left:70px;top:410px;font-size:20px;color:#B2AFAA;text-align:center;z-index:2'><%=gabr.get("sname").toString().replaceAll("'", "\\\\'") %></div>
				<div id='rightDiv_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
					<div style='position:absolute;width:570px;height:110px;left:430px;top:95px;font-size:20px;color:#B2AFAA;text-indent:40px;word-wrap:break-word;z-index:2'><%=gabr.get("cdes") %></div>
					<div style='position:absolute;width:50px;height:30px;left:430px;top:206px;font-size:18px;color:#FFFFFF;z-index:2'>单曲</div>
					<div id='totalRows' style='position:absolute;width:80px;height:30px;left:480px;top:200px;font-size:30px;color:#FFFFFF;z-index:2'></div>
					<img id='nextP' src='images/application/pages/search/commonly/next.png' style='position:absolute;width:28px;height:15px;left:793px;top:673px;visibility:hidden' />
					<div style='position:absolute;width:10px;height:28px;left:545px;top:198px;font-size:30px;color:#FFFFFF;z-index:2'>|</div>
					<div style='position:absolute;width:355px;height:30px;left:575px;top:210px;font-size:18px;color:#E7686A;z-index:2'><%=gabr.get("topic") %></div>
					<div id='pageIndex' style='position:absolute;width:40px;height:30px;left:1215px;top:418px;color:#FFFFFF;text-align:center'></div>
					<div id='pageTotal' style='position:absolute;width:40px;height:30px;left:1215px;top:460px;color:#FFFFFF;text-align:center'></div>
					<img id='pageDiv' src='images/application/pages/search/commonly/page.png' style='position:absolute;width:45px;height:162px;left:1213px;top:369px;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_100005' src='images/application/pages/search/commonly/focus/f_s.png' style='position:absolute;width:36px;height:36px;left:1218px;top:373px;z-index:2' />
					<img class='btn_focus_hidden' id='f_list_100006' src='images/application/pages/search/commonly/focus/f_x.png' style='position:absolute;width:36px;height:36px;left:1218px;top:492px;z-index:2' /><%for(int i = 1; i <= pageLimit; i++){ int x = 430; int y = 222;%>
					<div id='c_s_<%=i %>' style='position:absolute;width:325px;height:26px;left:<%=x %>px;top:<%=(i - 1) * 52 + y + 30 %>px;color:#FFFFFF;font-size:20px;overflow:hidden;z-index:1'></div>
					<img id='free_<%=i %>' src='images/application/pages/index/commonly/free.png' style='position:absolute;width:32px;height:15px;left:<%=x + 323 %>px;top:<%=(i - 1) * 52 + y + 37 %>px;z-index:1;visibility:hidden' />
					<div id='c_a_<%=i %>' style='position:absolute;width:200px;height:24px;left:<%=x + 359 %>px;top:<%=(i - 1) * 52 + y + 32 %>px;color:#B2AFAA;font-size:18px;text-align:right;overflow:hidden;z-index:1'></div>
					<img id='back_<%=i %>' src='images/application/pages/search/song/back.png' style='position:absolute;width:757px;height:50px;left:<%=x - 5 %>px;top:<%=(i - 1) * 52 + y + 17 %>px;z-index:2;visibility:hidden' />
					<img id='list_<%=i %>' src='images/application/pages/search/song/play.png' style='position:absolute;width:58px;height:58px;left:<%=x + 563 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_<%=i %>' src='images/application/pages/search/song/focus/f_play.png' style='position:absolute;width:58px;height:58px;left:<%=x + 563 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:4' />
					<img id='list_<%=i + pageLimit %>' src='images/application/pages/search/song/collect.png' style='position:absolute;width:58px;height:58px;left:<%=x + 630 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_<%=i + pageLimit %>' src='images/application/pages/search/song/focus/f_collect.png' style='position:absolute;width:58px;height:58px;left:<%=x + 630 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:4' />
					<img id='list_<%=i + pageLimit * 2 %>' src='images/application/pages/search/song/add.png' style='position:absolute;width:58px;height:58px;left:<%=x + 695 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:3;visibility:hidden' />
					<img class='btn_focus_hidden' id='f_list_<%=i + pageLimit * 2 %>' src='images/application/pages/search/song/focus/f_add.png' style='position:absolute;width:58px;height:58px;left:<%=x + 695 %>px;top:<%=(i - 1) * 52 + y + 13 %>px;z-index:4' /><%}%>
					<div id='songS'></div>
				</div>
			</div>
			<!-- 优先加载图 -->
			<img src='images/application/pages/search/song/collect.png' style='visibility:hidden'>
			<img src='images/application/pages/search/song/collect0.png' style='visibility:hidden'>
			<img src='images/application/pages/search/song/focus/f_collect.png' style='visibility:hidden'>
			<img src='images/application/pages/search/song/focus/f_collect0.png' style='visibility:hidden'>
			<script type='text/javascript' src='javascript/pages/list_classic.js?r=<%=Math.random() %>'></script>
			<script type='text/javascript' src='javascript/player/player_small.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>