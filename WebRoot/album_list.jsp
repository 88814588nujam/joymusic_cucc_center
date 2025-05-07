<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_a_album_1" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "1" : DoParam.AnalysisAbb("p", request));

	int pageLimit = 21;
	if(ajaxData == 1){ // 专题列表
		int totalRows = InfoData.getAlbumListCount();
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gal = InfoData.getAlbumList(pages);
		String retStr = "{'ifNull':false, 'totalRows':'" + totalRows + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + gal.size() + "', 'albumList':[";
		if(gal.size() > 0){
			for(int i = 0; i < gal.size(); i++){
				int docI = i + 1;
				String cname = gal.get(i).get("cname").toString();
				int len = getTitleTen(cname);
				if(i == gal.size() - 1) retStr += "{'keyword':'" + gal.get(i).get("keyword") + "', 'cname':'" + gal.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'pic':'" + gal.get(i).get("pic") + "', 'ctype':'" + gal.get(i).get("ctype") + "', 'createtime':'" + gal.get(i).get("createtime").toString().substring(0, 19) + "'}";
				else retStr +=  "{'keyword':'" + gal.get(i).get("keyword") + "', 'cname':'" + gal.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'pic':'" + gal.get(i).get("pic") + "', 'ctype':'" + gal.get(i).get("ctype") + "', 'createtime':'" + gal.get(i).get("createtime").toString().substring(0, 19) + "'},";
			}
		}
		retStr += "]}";
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
			// 异步加载出来的歌曲
			var albumList = new Array();
			// 是否第一次load
			var firstLoad = true;
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
			<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH  %>px;left:0px;top:0px'>
				<%=gpd.get("add") %>
				<div id='idsCheckedNum' style='position:absolute;width:30px;height:30px;left:1202px;top:30px;font-size:20px;color:#E7686A;text-align:center;z-index:3'><%if(idsCheckedNum > 99){%>99<span style='font-size:10px'>+</span><%} else{%><%=idsCheckedNum %><%}%></div>
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:70px' />
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:650px' />
				<img id='album_100000' src='images/application/pages/search/commonly/collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_album_100000' src='images/application/pages/search/commonly/focus/f_collect.png' style='position:absolute;width:123px;height:46px;left:994px;top:21px;z-index:2' />
				<img id='album_100001' src='images/application/pages/search/commonly/checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:1' />
				<img class='btn_focus_hidden' id='f_album_100001' src='images/application/pages/search/commonly/focus/f_checked.png' style='position:absolute;width:123px;height:46px;left:1120px;top:21px;z-index:2' />
				<img src='images/application/utils/common/grey.png' style='position:absolute;width:1280px;height:578px;left:0px;top:71px;z-index:3' />
				<div id='a_album' style='display:block'>
					<img id='a_album_1' src='images/application/pages/index/page1/224_296.png' style='position:absolute;width:289px;height:367px;left:54px;top:84px;z-index:1' />
					<img class='btn_focus_hidden'  id='f_a_album_1' src='images/application/pages/index/page1/focus/f_250_322.png' style='position:absolute;width:305px;height:383px;left:46px;top:76px;z-index:6'><%int docY = 1; int docX = 1; int docI = 1; for(int i = 1; i <= 24; i++){ docX = i % 8 == 0 ? 8 : i % 8; if(i != 1 && i != 2 && i != 9  && i != 10){ docI++;%>
					<img id='a_album_<%=docI %>' src='images/application/pages/index/page1/224_296.png' style='position:absolute;width:142px;height:180px;left:<%=54 + (docX - 1) * 147%>px;top:<%=84 + (docY - 1) * 187%>px;z-index:1' />
					<img class='btn_focus_hidden'  id='f_a_album_<%=docI %>' src='images/application/pages/index/page1/focus/f_250_322.png' style='position:absolute;width:158px;height:194px;left:<%=46 + (docX - 1) * 147%>px;top:<%=76 + (docY - 1) * 187%>px;z-index:6'><%} if(i % 8 == 0){docY++;}}%>
				</div>
				<div id='b_album' style='display:none'><%int docY2 = 1; int docX2 = 1; int docI2 = 0; for(int i = 1; i <= 24; i++){ docX2 = i % 8 == 0 ? 8 : i % 8; if(i != 15 && i != 16 && i != 23  && i != 24){ docI2++;%>
					<img id='b_album_<%=docI2 %>' src='images/application/pages/index/page1/224_296.png' style='position:absolute;width:142px;height:180px;left:<%=54 + (docX2 - 1) * 147%>px;top:<%=84 + (docY2 - 1) * 187%>px;z-index:1' />
					<img class='btn_focus_hidden' id='f_b_album_<%=docI2 %>' src='images/application/pages/index/page1/focus/f_250_322.png' style='position:absolute;width:158px;height:194px;left:<%=46 + (docX2 - 1) * 147%>px;top:<%=76 + (docY2 - 1) * 187%>px;z-index:6'><%} if(i % 8 == 0){docY2++;}}%>
					<img id='b_album_21' src='images/application/pages/index/page1/224_296.png' style='position:absolute;width:289px;height:367px;left:936px;top:271px;z-index:1' />
					<img class='btn_focus_hidden'  id='f_b_album_21' src='images/application/pages/index/page1/focus/f_250_322.png' style='position:absolute;width:305px;height:383px;left:928px;top:263px;z-index:6'>
				</div>
				<img id='album_100002' src='images/application/pages/album_list/l.png' style='position:absolute;width:50px;height:50px;left:985px;top:656px;z-index:1' />
				<img class='btn_focus_hidden' id='f_album_100002' src='images/application/pages/album_list/focus/f_l.png' style='position:absolute;width:50px;height:50px;left:985px;top:656px;z-index:2' />
				<img id='album_100003' src='images/application/pages/album_list/n.png' style='position:absolute;width:50px;height:50px;left:1190px;top:656px;z-index:1' />
				<img class='btn_focus_hidden' id='f_album_100003' src='images/application/pages/album_list/focus/f_n.png' style='position:absolute;width:50px;height:50px;left:1190px;top:656px;z-index:2' />
				<div id='pageInfo' style='position:absolute;width:175px;height:30px;left:1025px;top:673px;color:#FFFFFF;text-align:center'></div>
			</div>
			<script type='text/javascript' src='javascript/pages/album_list.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>