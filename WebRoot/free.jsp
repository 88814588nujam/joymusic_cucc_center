<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,java.io.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%! 
	private String getRandPic(String path){
		String picPaths = "";
		try{
			List<String> list = new ArrayList<String>();
			File file = new File(path);
			if(file.exists()){
	            File[] files = file.listFiles();
	            for(File fileSon : files){
					list.add(fileSon.getName());
	            }
			}
			if(list.size() > 0){
				Collections.shuffle(list);
				int maxSize = 10;
				if(list.size() < maxSize) maxSize = list.size();
				for(int i = 0; i < maxSize; i++){
					if(i == list.size() - 1) picPaths += "'" + list.get(i) + "'";
					else picPaths += "'" + list.get(i) + "',";
				}
			}
		} catch(Exception e){}
		picPaths = "[" + picPaths + "]";
		return picPaths;
	}
%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_free_6" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "1" : DoParam.AnalysisAbb("p", request));

	int pageLimit = 12;
	if(ajaxData == 1){ // 歌手歌曲
		int totalRows = InfoData.getFreeSongsCount();
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gfs = InfoData.getFreeSongs(pages);
		String retStr = "{'ifNull':false, 'totalRows':'" + totalRows + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + gfs.size() + "', 'songList':[";
		if(gfs.size() > 0){
			for(int i = 0; i < gfs.size(); i++){
				int docI = i + 1;
				String cname = gfs.get(i).get("cname").toString();
				int len = getTitleTen(cname);
				if(i == gfs.size() - 1) retStr += "{'sid':'" + gfs.get(i).get("id") + "', 'cname':'" + gfs.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gfs.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gfs.get(i).get("cfree") + "', 'duration':'" + gfs.get(i).get("duration") + "'}";
				else retStr +=  "{'sid':'" + gfs.get(i).get("id") + "', 'cname':'" + gfs.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gfs.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gfs.get(i).get("cfree") + "', 'duration':'" + gfs.get(i).get("duration") + "'},";
			}
		}
		retStr += "]}";
		out.print(retStr);
		return;
	} else if(ajaxData == 2){
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
	String path = new File(application.getRealPath(request.getServletPath())).getParent();
	String picPaths = getRandPic(path + "/images/commonly/free");
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
			// 底衬图队列
			var picPaths = <%=picPaths %>;
			// 小视频尺寸
			var playWinW = 280;
			var playWinH = 157;
			// 遥控延迟响应计时器
			var layTimes;
			// 控制是否执行start函数
			var ctlStart = false;
			// 访问页面的唯一id
			var viewId = '';
		</script>
	</head>

	<body onload='start()' onunload='destoryMP()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 -->
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
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
			<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH  %>px;left:0px;top:0px'>
				<%=gpd.get("add") %>
				<div id='idsCheckedNum' style='position:absolute;width:30px;height:30px;left:1202px;top:30px;font-size:20px;color:#E7686A;text-align:center;z-index:3'><%if(idsCheckedNum > 99){%>99<span style='font-size:10px'>+</span><%} else{%><%=idsCheckedNum %><%}%></div>
				<div id='pageInfo' style='position:absolute;width:200px;height:30px;left:1035px;top:632px;color:#FFFFFF;text-align:center'></div>
				<img src='images/application/pages/free/free.png' style='position:absolute;width:53px;height:53px;left:880px;top:8px;z-index:1' />
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px;z-index:1' />
				<img id='free_13' src='images/application/pages/search/commonly/collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_free_13' src='images/application/pages/search/commonly/focus/f_collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:2' />
				<img id='free_14' src='images/application/pages/search/commonly/checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_free_14' src='images/application/pages/search/commonly/focus/f_checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:2' />
				<img id='il' src='images/application/pages/free/il.png' style='position:absolute;width:22px;height:38px;left:30px;top:342px;z-index:1;visibility:hidden' />
				<img id='ir' src='images/application/pages/free/ir.png' style='position:absolute;width:22px;height:38px;left:1228px;top:342px;z-index:1;visibility:hidden' />
				<%int j = 1;for(int i = 1; i <= 12; i++){ int x = 65 + ((i < 5 ? i : (i < 9 ? i - 4 : i - 8)) - 1) * 290; int y = i < 5 ? 115 : (i < 9 ? 282 : 449); j = i % 4 == 1 ? 1 : j + 1; %>
				<div id='s_f_free_<%=i %>' style='position:absolute;width:280px;height:30px;left:<%=x %>px;top:<%=y + 30 %>px;color:#FFFFFF;font-size:22px;text-align:center;overflow:hidden;z-index:4'></div>
				<div id='a_f_free_<%=i %>' style='position:absolute;width:280px;height:30px;left:<%=x %>px;top:<%=y + 70 %>px;color:#B2AFAA;font-size:16px;text-align:center;z-index:4'></div>
				<div id='d_f_free_<%=i %>' style='position:absolute;width:270px;height:30px;left:<%=x %>px;top:<%=y + 130 %>px;color:#B2AFAA;font-size:16px;text-align:right;z-index:4'></div>
				<img id='free_<%=i %>' src='images/application/pages/free/back.png' style='position:absolute;width:280px;height:157px;left:<%=x %>px;top:<%=y %>px;z-index:3' />
				<img class='btn_focus_hidden' id='f_free_<%=i %>' src='images/application/pages/free/focus/f_ele.png' style='position:absolute;width:306px;height:183px;left:<%=x - 13 %>px;top:<%=y - 13 %>px;z-index:2' />
				<div id='c_f_free_<%=i %>' style='position:absolute;width:280px;height:157px;left:<%=x %>px;top:<%=y %>px;z-index:2;overflow:hidden'>
					<img id='p_f_free_<%=i %>' src='images/application/pages/index/commonly/null.png' style='position:absolute;width:1150px;height:491px;left:-<%=(j - 1) * 290 %>px;top:-<%=i < 5 ? 0 : (i < 9 ? 167 : 334)%>px;' />
				</div><%}%>
				<div id='nowPlay' style='position:absolute;width:600px;height:30px;left:340px;top:640px;color:#FFFFFF;font-size:22px;text-align:center;text-align:center;overflow;z-index:5;visibility:hidden'></div>
				<div id='nowTips' style='position:absolute;width:600px;height:30px;left:340px;top:668px;color:#B2AFAA;font-size:18px;text-align:center;z-index:5;visibility:hidden'>遥控器按 '确认' 键开启全屏极致体验</div>
			</div>
			<!-- 优先加载小视频垫图 -->
			<img id='backDis' src='images/application/pages/free/loading.png' style='position:absolute;width:280px;height:157px;visibility:hidden'>
			<script type='text/javascript' src='javascript/pages/free.js?r=<%=Math.random() %>'></script>
			<script type='text/javascript' src='javascript/player/player_small.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>