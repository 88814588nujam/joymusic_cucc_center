<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,java.text.DecimalFormat,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	// 获取私有页面参数
	int defaultIdx = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("h", request)) ? "1" : DoParam.AnalysisAbb("h", request));
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_setting_" + defaultIdx : DoParam.AnalysisAbb("n", request);
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));

	if(ajaxData == 1){ // 更改历史点播时间
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		int tmpHour = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("h", request)) ? "24" : DoParam.AnalysisAbb("h", request));
		int tmpMax = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("m", request)) ? "100" : DoParam.AnalysisAbb("m", request));
		int row = InfoData.updateUserInfo(tmpUid, "hour", String.valueOf(tmpHour));
		String checkedStr = InfoData.getCheckedStr(tmpUid, tmpHour, tmpMax);
		String[] idsCheckedStr = checkedStr.split(",");
		int idsCheckedNum = checkedStr.contains(",") ? idsCheckedStr.length : (StringUtils.isBlank(checkedStr) ? 0 : 1);
		String retStr = "{'idsCheckedNum':'" + idsCheckedNum + "'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 2){ // 更改历史点播条目数
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		int tmpHour = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("h", request)) ? "24" : DoParam.AnalysisAbb("h", request));
		int tmpMax = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("m", request)) ? "100" : DoParam.AnalysisAbb("m", request));
		int row = InfoData.updateUserInfo(tmpUid, "max", String.valueOf(tmpMax));
		String checkedStr = InfoData.getCheckedStr(tmpUid, tmpHour, tmpMax);
		String[] idsCheckedStr = checkedStr.split(",");
		int idsCheckedNum = checkedStr.contains(",") ? idsCheckedStr.length : (StringUtils.isBlank(checkedStr) ? 0 : 1);
		String retStr = "{'idsCheckedNum':'" + idsCheckedNum + "'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 3){ // 皮肤
		List<Map<String, Object>> gs = InfoData.getSkins();
		String t_0 = "";
		String t_1 = "";
		String t_2 = "";
		String themeList = "";
		String cnameList = "";
		if(gs.size() > 0){
			for(int i = 0; i < gs.size(); i++){
				int ctype = Integer.parseInt(gs.get(i).get("ctype").toString());
				if(ctype == 0) t_0 += "{'sid':'" + gs.get(i).get("id") + "', 'theme':'" + gs.get(i).get("theme") + "', 'cname':'" + gs.get(i).get("cname") + "'},";
				else if(ctype == 1) t_1 += "{'sid':'" + gs.get(i).get("id") + "', 'theme':'" + gs.get(i).get("theme") + "', 'cname':'" + gs.get(i).get("cname") + "'},";
				else if(ctype == 2) t_2 += "{'sid':'" + gs.get(i).get("id") + "', 'theme':'" + gs.get(i).get("theme") + "', 'cname':'" + gs.get(i).get("cname") + "'},";
				themeList += "'" + gs.get(i).get("theme") + "',";
				cnameList += "'" + gs.get(i).get("cname") + "',";
			}
		}
		t_0 = t_0.substring(0, t_0.lastIndexOf(","));
		t_1 = t_1.substring(0, t_1.lastIndexOf(","));
		t_2 = t_2.substring(0, t_2.lastIndexOf(","));
		themeList = themeList.substring(0, themeList.lastIndexOf(","));
		cnameList = cnameList.substring(0, cnameList.lastIndexOf(","));
		t_0 = "[" + t_0 + "]";
		t_1 = "[" + t_1 + "]";
		t_2 = "[" + t_2 + "]";
		themeList = "[" + themeList + "]";
		cnameList = "[" + cnameList + "]";;
		String retStr = "{'t_0':" + t_0 + ", 't_1':" + t_1 + ", 't_2':" + t_2 + ", 'themeList':" + themeList + ", 'cnameList':" + cnameList + "}";
		out.print(retStr);
		return;
	} else if(ajaxData == 4){ // 切换皮肤
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request);
		int row = InfoData.updateUserInfo(tmpUid, "preferTheme", key);
		String retStr = "{'result':'0'}";
		if(row > 0) retStr = "{'result':'1'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 5){ // 偏好设置 0或1
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		String prefer = StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "" : DoParam.AnalysisAbb("p", request);
		String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request);
		int row = InfoData.updateUserInfo(tmpUid, prefer, key);
		String retStr = "{'result':'0'}";
		if(row > 0) retStr = "{'result':'1'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 6){ // 切换导读模式
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request);
		int row = InfoData.updateUserInfo(tmpUid, "preferGuide", key);
		String retStr = "{'result':'0'}";
		if(row > 0) retStr = "{'result':'1'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 7){ // 初始化设置
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		int row1 = InfoData.updateUserInfo(tmpUid, "preferList", "0");
		int row2 = InfoData.updateUserInfo(tmpUid, "preferKeyboard", "0");
		int row3 = InfoData.updateUserInfo(tmpUid, "preferBubble", "0");
		int row4 = InfoData.updateUserInfo(tmpUid, "preferGuide", "1");
		String retStr = "{'result':'0'}";
		if(row1 > 0 && row2 > 0 && row3 > 0 && row4 > 0) retStr = "{'result':'1'}";
		out.print(retStr);
		return;
	}
%><%@include file="common/head.jsp" %>
<%
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
			// 当前右侧显示
			var rightDiv = <%=defaultIdx %>;
			// 是否支持动画 0:不支持 1:支持
			var animation = <%=animation %>;
			// 主题的列表
			var themeList = new Array();
			var cnameList = new Array();
			// 个性主题 | 节日主题 队列
			var t_1_ele = new Array();
			var t_2_ele = new Array();
			// 处于第一个的t1和t2焦点
			var t1Focus = '';
			var t2Focus = '';
			// 遥控延迟响应计时器
			var layTimes;
			// 时间定时器
			var clockTask;
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
				<div id='pageindexbgReal' style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/commonly/skins/<%=preferTheme %>.png)'></div>
				<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:1px;height:624px;left:300px;top:96px' />
				<img src='images/application/pages/setting/topic.png' style='position:absolute;width:77px;height:22px;left:60px;top:96px' />
				<!-- 左侧菜单 -->
				<img id='sta' src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:144px;z-index:1' />
				<img src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:194px;z-index:1;visibility:hidden' />
				<img src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:244px;z-index:1;visibility:hidden' />
				<img src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:294px;z-index:1;visibility:hidden' />
				<img src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:344px;z-index:1;visibility:hidden' />
				<img src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:394px;z-index:1;visibility:hidden' />
				<img src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:444px;z-index:1;visibility:hidden' />
				<img src='images/application/pages/setting/sta.png' style='position:absolute;width:220px;height:40px;left:52px;top:494px;z-index:1;visibility:hidden' />
				<img src='images/application/pages/setting/l1.png' style='position:absolute;width:30px;height:30px;left:70px;top:150px;z-index:2' />
				<img src='images/application/pages/setting/l2.png' style='position:absolute;width:30px;height:30px;left:70px;top:200px;z-index:2' />
				<img src='images/application/pages/setting/l3.png' style='position:absolute;width:30px;height:30px;left:70px;top:250px;z-index:2' />
				<img src='images/application/pages/setting/l4.png' style='position:absolute;width:30px;height:30px;left:70px;top:300px;z-index:2' />
				<img src='images/application/pages/setting/l5.png' style='position:absolute;width:30px;height:30px;left:70px;top:350px;z-index:2' />
				<img src='images/application/pages/setting/l6.png' style='position:absolute;width:30px;height:30px;left:70px;top:400px;z-index:2' />
				<img src='images/application/pages/setting/l7.png' style='position:absolute;width:30px;height:30px;left:70px;top:450px;z-index:2' />
				<img src='images/application/pages/setting/l8.png' style='position:absolute;width:30px;height:30px;left:70px;top:500px;z-index:2' />
				<div style='position:absolute;width:150px;height:28px;left:110px;top:150px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>个人信息</div>
				<div style='position:absolute;width:150px;height:28px;left:110px;top:200px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>历史</div>
				<div style='position:absolute;width:150px;height:28px;left:110px;top:250px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>主题、外观</div>
				<div style='position:absolute;width:150px;height:28px;left:110px;top:300px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>偏好</div>
				<div style='position:absolute;width:150px;height:28px;left:110px;top:350px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>时间</div>
				<div style='position:absolute;width:150px;height:28px;left:110px;top:400px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>遥控器使用</div>
				<div style='position:absolute;width:150px;height:28px;left:110px;top:450px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>重置设置</div>
				<div style='position:absolute;width:150px;height:28px;left:110px;top:500px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:2'>欢乐歌房</div>
				<div style='position:absolute;width:150px;height:28px;left:202px;top:505px;line-height:28px;color:#FFFFFF;font-size:16px;z-index:2'>ver3.0.0</div>
				<img id='f_setting_1' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:141px;z-index:3' />
				<img id='f_setting_2' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:191px;z-index:3' />
				<img id='f_setting_3' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:241px;z-index:3' />
				<img id='f_setting_4' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:291px;z-index:3' />
				<img id='f_setting_5' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:341px;z-index:3' />
				<img id='f_setting_6' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:391px;z-index:3' />
				<img id='f_setting_7' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:441px;z-index:3' />
				<img id='f_setting_8' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_menu.png' style='position:absolute;width:227px;height:47px;left:49px;top:491px;z-index:3' />
				<!-- 个人信息 -->
				<div id='rightDiv_1' style='display:none'>
					<div id='rightDiv_1_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:100px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>我的终端</div>
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:780px;height:150px;left:390px;top:145px' />
						<img src='images/application/pages/setting/pic.png' style='position:absolute;width:100px;height:100px;left:415px;top:170px;z-index:1' />
						<div style='position:absolute;width:150px;height:25px;left:540px;top:170px;line-height:25px;color:#FFFFFF;font-size:20px;z-index:1'>账号：</div>
						<div id='uid' style='position:absolute;width:350px;height:25px;left:585px;top:195px;line-height:25px;color:#FFFFFF;font-size:20px;z-index:1'></div>
						<div style='position:absolute;width:150px;height:25px;left:540px;top:220px;line-height:25px;color:#FFFFFF;font-size:20px;z-index:1'>终端型号：</div>
						<div id='stbType' style='position:absolute;width:330px;height:25px;left:585px;top:245px;line-height:25px;color:#FFFFFF;font-size:20px;z-index:1'></div>
						<div id='stbVersion' style='position:absolute;width:570px;height:20px;left:585px;top:270px;color:#B2AFAA;font-size:16px;text-align:right;z-index:1'></div>
						<img id='setting_101' src='images/application/pages/setting/exit.png' style='position:absolute;width:180px;height:55px;left:970px;top:192px;z-index:1' />
						<img id='f_setting_101' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_exit.png' style='position:absolute;width:180px;height:55px;left:970px;top:192px;z-index:2' /><%if(remote == 1){%>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:340px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>我的微信</div>
						<div style='position:absolute;width:150px;height:24px;left:482px;top:344px;line-height:24px;color:#FFFFFF;font-size:16px;z-index:1'>(&朋友们)</div>
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:780px;height:60px;left:390px;top:385px' />
						<img src='images/application/pages/setting/wx.png' style='position:absolute;width:25px;height:25px;left:415px;top:405px' />
						<div style='position:absolute;width:730px;height:25px;left:445px;top:405px;line-height:25px;color:#FFFFFF;font-size:20px;z-index:1'>还未使用微信扫描二维码登录？快来和朋友们一起试一试吧！</div>
						<img id='setting_102' src='images/application/pages/setting/scan.png' style='position:absolute;width:35px;height:35px;left:1122px;top:398px;z-index:1' />
						<img id='f_setting_102' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_scan.png' style='position:absolute;width:35px;height:35px;left:1122px;top:398px;z-index:2' /><%}%>
					</div>
				</div>
				<!-- 历史 -->
				<div id='rightDiv_2' style='display:none'>
					<div id='rightDiv_2_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:120px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>常规</div>
						<div style='position:absolute;width:550px;height:28px;left:520px;top:180px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>请选择您要保留历史点播曲目的时间周期</div>
						<div style='position:absolute;width:100px;height:28px;left:520px;top:220px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:2'>6小时</div>
						<div style='position:absolute;width:100px;height:28px;left:720px;top:220px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:2'>12小时</div>
						<div style='position:absolute;width:100px;height:28px;left:920px;top:220px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:2'>24小时</div>
						<div style='position:absolute;width:550px;height:28px;left:520px;top:290px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>请选择您要保留历史点播曲目的条目数</div>
						<div style='position:absolute;width:100px;height:28px;left:520px;top:330px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:2'>50条</div>
						<div style='position:absolute;width:100px;height:28px;left:720px;top:330px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:2'>100条</div>
						<div style='position:absolute;width:100px;height:28px;left:920px;top:330px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:2'>150条</div>
						<div style='position:absolute;width:550px;height:28px;left:520px;top:400px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>满足条件的历史点播曲目：</div>
						<div id='idsCheckedNum' style='position:absolute;width:30px;height:28px;left:755px;top:400px;line-height:28px;color:#E7686A;font-size:20px;z-index:1'><%=idsCheckedNum %></div>
						<img id='f_setting_201' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_button.png' style='position:absolute;width:125px;height:45px;left:500px;top:212px;z-index:1' />
						<img id='f_setting_202' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_button.png' style='position:absolute;width:125px;height:45px;left:700px;top:212px;z-index:1' />
						<img id='f_setting_203' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_button.png' style='position:absolute;width:125px;height:45px;left:900px;top:212px;z-index:1' />
						<img id='f_setting_204' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_button.png' style='position:absolute;width:125px;height:45px;left:500px;top:322px;z-index:1' />
						<img id='f_setting_205' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_button.png' style='position:absolute;width:125px;height:45px;left:700px;top:322px;z-index:1' />
						<img id='f_setting_206' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_button.png' style='position:absolute;width:125px;height:45px;left:900px;top:322px;z-index:1' />
						<img src='images/application/pages/setting/blank.png' style='position:absolute;width:20px;height:20px;left:587px;top:225px;z-index:2' />
						<img src='images/application/pages/setting/blank.png' style='position:absolute;width:20px;height:20px;left:787px;top:225px;z-index:2' />
						<img src='images/application/pages/setting/blank.png' style='position:absolute;width:20px;height:20px;left:987px;top:225px;z-index:2' />
						<img src='images/application/pages/setting/blank.png' style='position:absolute;width:20px;height:20px;left:587px;top:335px;z-index:2' />
						<img src='images/application/pages/setting/blank.png' style='position:absolute;width:20px;height:20px;left:787px;top:335px;z-index:2' />
						<img src='images/application/pages/setting/blank.png' style='position:absolute;width:20px;height:20px;left:987px;top:335px;z-index:2' />
						<img id='c_setting_h_6' class='btn_focus_hidden' src='images/application/pages/setting/check.png' style='position:absolute;width:20px;height:20px;left:587px;top:225px;z-index:3' />
						<img id='c_setting_h_12' class='btn_focus_hidden' src='images/application/pages/setting/check.png' style='position:absolute;width:20px;height:20px;left:787px;top:225px;z-index:3' />
						<img id='c_setting_h_24' class='btn_focus_hidden' src='images/application/pages/setting/check.png' style='position:absolute;width:20px;height:20px;left:987px;top:225px;z-index:3' />
						<img id='c_setting_m_50' class='btn_focus_hidden' src='images/application/pages/setting/check.png' style='position:absolute;width:20px;height:20px;left:587px;top:335px;z-index:3' />
						<img id='c_setting_m_100' class='btn_focus_hidden' src='images/application/pages/setting/check.png' style='position:absolute;width:20px;height:20px;left:787px;top:335px;z-index:3' />
						<img id='c_setting_m_150' class='btn_focus_hidden' src='images/application/pages/setting/check.png' style='position:absolute;width:20px;height:20px;left:987px;top:335px;z-index:3' />
						<img id='setting_207' src='images/application/pages/checked/clear.png' style='position:absolute;width:153px;height:55px;left:883px;top:420px;z-index:1' />
						<img class='btn_focus_hidden' id='f_setting_207' src='images/application/pages/checked/focus/f_clear.png' style='position:absolute;width:153px;height:55px;left:883px;top:420px;z-index:2' />
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:584px;height:108px;left:465px;top:160px' />
						<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:584px;height:1px;left:465px;top:268px' />
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:584px;height:108px;left:465px;top:269px' />
						<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:584px;height:1px;left:465px;top:377px' />
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:584px;height:108px;left:465px;top:378px' />
					</div>
				</div>
				<!-- 主题、外观 -->
				<div id='rightDiv_3' style='display:none'>
					<div id='rightDiv_3_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:40px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>默认主题</div>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:270px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>个性主题</div>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:500px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>节日主题</div>
						<div style='position:absolute;width:979px;height:240px;left:301px;top:68px;overflow:hidden'>
							<div id='t_0_blk'></div>
						</div>
						<div style='position:absolute;width:979px;height:240px;left:301px;top:298px;overflow:hidden'>
							<div id='t_1_blk' style='position:absolute;width:979px;height:240px;left:0px;top:0px'></div>
						</div>
						<div style='position:absolute;width:979px;height:240px;left:301px;top:528px;overflow:hidden'>
							<div id='t_2_blk' style='position:absolute;width:979px;height:240px;left:0px;top:0px'></div>
						</div>
					</div>
				</div>
				<!-- 偏好 -->
				<div id='rightDiv_4' style='display:none'>
					<div id='rightDiv_4_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:120px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>偏好设置</div>
						<div style='position:absolute;width:550px;height:28px;left:490px;top:180px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>开启专辑以传统列表形式展示</div>
						<div style='position:absolute;width:550px;height:20px;left:490px;top:210px;color:#B2AFAA;font-size:16px;z-index:1'>关闭此选项时，所有专辑页面将以时尚瀑布流形式展示该列表的曲目</div>
						<div style='position:absolute;width:550px;height:28px;left:490px;top:276px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>打开搜索页面的T9键输入法</div>
						<div style='position:absolute;width:550px;height:20px;left:490px;top:306px;color:#B2AFAA;font-size:16px;z-index:1'>关闭此选项时，搜索页面将默认使用全键盘输入法输入关键字</div>
						<div style='position:absolute;width:550px;height:28px;left:490px;top:372px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>打开彩色气泡提示</div>
						<div style='position:absolute;width:550px;height:20px;left:490px;top:402px;color:#B2AFAA;font-size:16px;z-index:1'>关闭此选项时，提示气泡将以灰色提示显示</div>
						<div style='position:absolute;width:550px;height:28px;left:490px;top:462px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>选择主页菜单栏导读模式</div>
						<div style='position:absolute;width:550px;height:20px;left:490px;top:492px;color:#B2AFAA;font-size:16px;z-index:1'>关闭、开启导读会持续隐藏或显示推荐导读，随动则只有当前推荐会显示导读</div>
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:650px;height:93px;left:465px;top:160px' />
						<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:650px;height:1px;left:465px;top:254px' />
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:650px;height:93px;left:465px;top:255px' />
						<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:650px;height:1px;left:465px;top:349px' />
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:650px;height:93px;left:465px;top:350px' />
						<img src='images/application/pages/search/commonly/line.png' style='position:absolute;width:650px;height:1px;left:465px;top:444px' />
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:650px;height:93px;left:465px;top:445px' />
						<img id='setting_401' src='images/application/utils/timenum/null.png' style='position:absolute;width:45px;height:22px;left:1040px;top:183px;z-index:1' />
						<img id='setting_402' src='images/application/utils/timenum/null.png' style='position:absolute;width:45px;height:22px;left:1040px;top:279px;z-index:1' />
						<img id='setting_403' src='images/application/utils/timenum/null.png' style='position:absolute;width:45px;height:22px;left:1040px;top:375px;z-index:1' />
						<img id='setting_404' src='images/application/pages/setting/gd.png' style='position:absolute;width:28px;height:8px;left:1048px;top:475px;z-index:2' />
						<img id='gd_alt_0' src='images/application/utils/common/grey.png' style='position:absolute;width:34px;height:20px;left:1045px;top:469px;z-index:1;visibility:hidden' />
						<img id='f_setting_401' class='btn_focus_hidden' src='images/application/utils/timenum/null.png' style='position:absolute;width:45px;height:22px;left:1040px;top:183px;z-index:2' />
						<img id='f_setting_402' class='btn_focus_hidden' src='images/application/utils/timenum/null.png' style='position:absolute;width:45px;height:22px;left:1040px;top:279px;z-index:2' />
						<img id='f_setting_403' class='btn_focus_hidden' src='images/application/utils/timenum/null.png' style='position:absolute;width:45px;height:22px;left:1040px;top:375px;z-index:2' />
						<img id='f_setting_404' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_gd.png' style='position:absolute;width:45px;height:22px;left:1040px;top:468px;z-index:3' />
						<img id='gd_alt_1' src='images/application/pages/setting/mode.png' style='position:absolute;width:72px;height:81px;left:1076px;top:485px;z-index:4;visibility:hidden' />
						<img id='gd_now_1' src='images/application/pages/setting/now.png' style='position:absolute;width:10px;height:10px;left:1133px;top:495px;z-index:6;visibility:hidden' />
						<img id='gd_now_0' src='images/application/pages/setting/now.png' style='position:absolute;width:10px;height:10px;left:1133px;top:521px;z-index:6;visibility:hidden' />
						<img id='gd_now_2' src='images/application/pages/setting/now.png' style='position:absolute;width:10px;height:10px;left:1133px;top:547px;z-index:6;visibility:hidden' />
						<img id='f_setting_405' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_gd_1.png' style='position:absolute;width:70px;height:27px;left:1077px;top:485px;z-index:5' />
						<img id='f_setting_406' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_gd_0.png' style='position:absolute;width:70px;height:27px;left:1077px;top:512px;z-index:5' />
						<img id='f_setting_407' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_gd_2.png' style='position:absolute;width:70px;height:27px;left:1077px;top:539px;z-index:5' />
					</div>
				</div>
				<!-- 时间 -->
				<div id='rightDiv_5' style='display:none'>
					<div id='rightDiv_5_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:120px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>当前时间</div>
						<div id='timeC1' style='position:absolute;width:120px;height:28px;left:500px;top:120px;line-height:28px;color:#FFFFFF;font-size:20px;text-align:center;z-index:1'></div>
						<div id='timeC2' style='position:absolute;width:120px;height:28px;left:730px;top:570px;line-height:28px;color:#FFFFFF;font-size:20px;text-align:center;z-index:1'></div>
						<img src='images/application/pages/setting/pos.png' style='position:absolute;width:27px;height:27px;left:1050px;top:118px;z-index:1'>
						<div id='cityC' style='position:absolute;width:150px;height:28px;left:1087px;top:120px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'></div>
						<div id='wkd1' style='position:absolute;width:40px;height:25px;left:525px;top:180px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:1'>日</div>
						<div id='wkd2' style='position:absolute;width:40px;height:25px;left:605px;top:180px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:1'>一</div>
						<div id='wkd3' style='position:absolute;width:40px;height:25px;left:685px;top:180px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:1'>二</div>
						<div id='wkd4' style='position:absolute;width:40px;height:25px;left:765px;top:180px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:1'>三</div>
						<div id='wkd5' style='position:absolute;width:40px;height:25px;left:845px;top:180px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:1'>四</div>
						<div id='wkd6' style='position:absolute;width:40px;height:25px;left:925px;top:180px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:1'>五</div>
						<div id='wkd7' style='position:absolute;width:40px;height:25px;left:1005px;top:180px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:1'>六</div>
						<div id='d_wkd1' style='position:absolute;width:40px;height:25px;left:525px;top:225px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:2'></div>
						<div id='d_wkd2' style='position:absolute;width:40px;height:25px;left:605px;top:225px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:2'></div>
						<div id='d_wkd3' style='position:absolute;width:40px;height:25px;left:685px;top:225px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:2'></div>
						<div id='d_wkd4' style='position:absolute;width:40px;height:25px;left:765px;top:225px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:2'></div>
						<div id='d_wkd5' style='position:absolute;width:40px;height:25px;left:845px;top:225px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:2'></div>
						<div id='d_wkd6' style='position:absolute;width:40px;height:25px;left:925px;top:225px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:2'></div>
						<div id='d_wkd7' style='position:absolute;width:40px;height:25px;left:1005px;top:225px;line-height:25px;color:#FFFFFF;font-size:22px;text-align:center;z-index:2'></div>
						<img id='b_wkd1' src='images/application/pages/setting/dot.png' style='position:absolute;width:37px;height:37px;left:527px;top:219px;z-index:1;visibility:hidden'>
						<img id='b_wkd2' src='images/application/pages/setting/dot.png' style='position:absolute;width:37px;height:37px;left:607px;top:219px;z-index:1;visibility:hidden'>
						<img id='b_wkd3' src='images/application/pages/setting/dot.png' style='position:absolute;width:37px;height:37px;left:687px;top:219px;z-index:1;visibility:hidden'>
						<img id='b_wkd4' src='images/application/pages/setting/dot.png' style='position:absolute;width:37px;height:37px;left:767px;top:219px;z-index:1;visibility:hidden'>
						<img id='b_wkd5' src='images/application/pages/setting/dot.png' style='position:absolute;width:37px;height:37px;left:847px;top:219px;z-index:1;visibility:hidden'>
						<img id='b_wkd6' src='images/application/pages/setting/dot.png' style='position:absolute;width:37px;height:37px;left:927px;top:219px;z-index:1;visibility:hidden'>
						<img id='b_wkd7' src='images/application/pages/setting/dot.png' style='position:absolute;width:37px;height:37px;left:1007px;top:219px;z-index:1;visibility:hidden'>
						<div style='position:absolute;width:730px;height:25px;left:560px;top:620px;line-height:25px;color:#E7686A;font-size:26px;z-index:1'>时间不准？</div>
						<div style='position:absolute;width:730px;height:25px;left:680px;top:623px;line-height:25px;color:#FFFFFF;font-size:20px;z-index:1'>请移至终端的设置界面进行时间校准！</div>
						<img src='images/application/utils/clock/clock.png' style='position:absolute;width:250px;height:250px;left:666px;top:290px;z-index:1'><%for(int i = 1; i <= 60; i++){%>
						<img id='s<%=i %>' src='images/application/utils/clock/second/s<%=i %>.png' style='position:absolute;width:250px;height:250px;left:666px;top:287px;z-index:2;visibility:hidden'>
						<img id='m<%=i %>' src='images/application/utils/clock/minute/m<%=i %>.png' style='position:absolute;width:250px;height:250px;left:666px;top:287px;z-index:2;visibility:hidden'>
						<img id='h<%=i %>' src='images/application/utils/clock/hour/h<%=i %>.png' style='position:absolute;width:250px;height:250px;left:666px;top:287px;z-index:2;visibility:hidden'><%}%>
					</div>
				</div>
				<!-- 遥控器使用 -->
				<div id='rightDiv_6' style='display:none'>
					<div id='rightDiv_6_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<img src='images/application/pages/setting/ctrl.png' style='position:absolute;width:839px;height:626px;left:370px;top:94px' />
					</div>
				</div>
				<!-- 重置设置 -->
				<div id='rightDiv_7' style='display:none'>
					<div id='rightDiv_7_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<div style='position:absolute;width:150px;height:28px;left:390px;top:120px;line-height:28px;color:#FFFFFF;font-size:22px;z-index:1'>重置设置</div>
						<div style='position:absolute;width:550px;height:28px;left:490px;top:180px;line-height:28px;color:#FFFFFF;font-size:20px;z-index:1'>将设置还原为其默认值</div>
						<img src='images/application/utils/common/grey.png' style='position:absolute;width:650px;height:70px;left:465px;top:160px' />
						<img id='setting_701' src='images/application/pages/setting/skip.png' style='position:absolute;width:25px;height:25px;left:1070px;top:182px;z-index:1' />
						<img id='f_setting_701' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_skip.png' style='position:absolute;width:25px;height:25px;left:1070px;top:182px;z-index:2' />
						<img id='rsDiv' src='images/application/pages/setting/rsDiv.png' style='position:absolute;width:473px;height:266px;left:553px;top:270px;z-index:3;visibility:hidden' />
						<img id='f_setting_702' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_rs.png' style='position:absolute;width:139px;height:56px;left:610px;top:446px;z-index:4' />
						<img id='f_setting_703' class='btn_focus_hidden' src='images/application/pages/setting/focus/f_cl.png' style='position:absolute;width:139px;height:56px;left:835px;top:446px;z-index:4' />
					</div>
				</div>
				<!-- 应用 -->
				<div id='rightDiv_8' style='display:none'>
					<div id='rightDiv_8_mar' style='position:absolute;width:1280px;height:720px;left:25px;top:0px'>
						<img src='images/application/pages/setting/info.png' style='position:absolute;width:693px;height:489px;left:440px;top:150px' />
					</div>
				</div>
			</div>
			<!-- 优先加载需要异步切换的图 -->
			<img src='images/application/pages/setting/close.png' style='visibility:hidden'>
			<img src='images/application/pages/setting/open.png' style='visibility:hidden'>
			<img src='images/application/pages/setting/focus/f_close.png' style='visibility:hidden'>
			<img src='images/application/pages/setting/focus/f_open.png' style='visibility:hidden'>
			<script type='text/javascript' src='javascript/pages/setting.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>