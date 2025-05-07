<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.util.*,java.io.*,java.net.*,java.util.regex.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	private List<Map<String, Object>> getUiIndexRecommendHall(int entryid, String provinceN) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM zone_ui_index_recommend_hall WHERE pos<>0";
		if(entryid > 0) sql += " AND pid=" + entryid;
		if(StringUtils.isNotBlank(provinceN)) sql += " AND provinceN='" + provinceN + "'";
		sql += " ORDER BY pos";
		li = DB.query(sql, true);
		return li;
	}
	
	// 包月鉴权正式计费的
	static String authResult211(String u, String t, String p){
		String rt = "y";
        BufferedReader reader = null;
		try{
			String spid = "96596";
			String serviceId = "wjyydb";
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
			String jsonStr  = "{\"spId\":\"" + spid + "\",\"carrierId\":\"" + p + "\",\"userId\":\"" + u + "\",\"userToken\":\"" + t + "\",\"serviceId\":\"" + serviceId + "\",\"timeStamp\":\"" + new Date().getTime() + "\"}";
			outwritestream.write(jsonStr.getBytes());
			outwritestream.flush();
			outwritestream.close();
			if(conn.getResponseCode() == 200){
				reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String result = reader.readLine();
				// System.out.println("// ========================= ");
				// System.out.println(result);
				result = result.substring(result.indexOf("\"result\":") + "\"result\":".length());
				result = result.substring(0, result.indexOf(","));
				if(result.equals("0")){
					rt = "0";
				}
			}
		} catch(Exception e){
		}
		return rt;
	}
%>
<%
	// 该大厅只有黑龙江使用
	String provinceN = "211";
	int pageId = Integer.parseInt(provinceN);
	
	// 直接可以访问到的页面便面参数异常等问题做的操作
	String requestStr = UrlHandle.getRequestString(request);
	boolean sqlFlag = UrlHandle.isRealStr(requestStr);
	// 如果该参数不合法直接转向错误页面
	if(!sqlFlag) response.sendRedirect("error.jsp");
	// 有时候需要整串接收参数(如在测试环境中,向测试页面传递入口常规参数)
	String allStr = request.getQueryString();
	if(StringUtils.isBlank(allStr)) allStr = "";
	// System.out.println("allStr : " + allStr);
	
	// 异步加载211大厅的数据
	String ajaxData = request.getParameter("d");
	if(StringUtils.isBlank(ajaxData)) ajaxData = "";
	else{
		String jsonStr = "";
		if(ajaxData.equals("1")){
			List<Map<String, Object>> guir = getUiIndexRecommendHall(0, provinceN);
			if(guir.size() > 0){
				for(int i = 0; i < guir.size(); i++){
					String pic = guir.get(i).get("pic").toString();
					jsonStr += "{\"provinceN\":\"" + provinceN + "\", \"pos\":\"" + guir.get(i).get("pos") + "\",\"w\":\"" + guir.get(i).get("w") + "\", \"h\":\"" + guir.get(i).get("h") + "\", \"pic\":\"" + guir.get(i).get("pic") + "\", \"pic_word\":\"" + guir.get(i).get("pic_word") + "\", \"pic_word_color\":\"" + guir.get(i).get("pic_word_color") + "\", \"onclick_type\":\"" + guir.get(i).get("onclick_type") + "\", \"curl\":\"" + guir.get(i).get("curl") + "\", \"params\":\"" + guir.get(i).get("params") + "\", \"createtime\":\"" + guir.get(i).get("createtime").toString().substring(0, 19) + "\"}";
					if(i < guir.size() - 1) jsonStr += ",";
				}
			}
			jsonStr = "[" + jsonStr + "]";
			out.println(jsonStr);
			return;
		}
	}
	
	// 用户登陆的是否是测试平台(本条对应的是机顶盒而言) 
	String isOnline = request.getParameter("isOnline");
	if(StringUtils.isBlank(isOnline)) isOnline = "y";
	
	String moveHIdx = request.getParameter("moveHIdx");
	if(StringUtils.isBlank(moveHIdx)) moveHIdx = "0";
	
	String tempF = request.getParameter("tempF");
	if(StringUtils.isBlank(tempF)) tempF = "1";
	
	// 接收使用该产品的用户账号(可能进入不传递该参数,需要从JS API中获取)
	String userid = request.getParameter("UserID");
	if(StringUtils.isBlank(userid)){
        userid = request.getParameter("userId");
        if(StringUtils.isBlank(userid)) userid = "";
    }
    String UserID = userid;
    if(StringUtils.isBlank(UserID)) UserID = "";
    if(userid.contains("_")){
		String[] ifTogether = userid.split("_");
		Pattern pattern = Pattern.compile("[0-9]*");
		Matcher isNum = pattern.matcher(ifTogether[1]);
		if(isNum.matches()) userid = userid.substring(0, userid.indexOf("_"));
	}

	// 接收使用该产品的用户临时身份证明(可能进入不传递该参数,需要从JS API中获取)
    String userToken = request.getParameter("UserToken");
    if(StringUtils.isBlank(userToken)) userToken = "";

	// 一些地区一次性会传过来很多个返回地址,因为暂时不知道会需要返回哪个,干脆全部存储,按照url有长度的限制来看,最多只能传进来5条返回地址进行接收
    String backUrl01 = request.getParameter("HomeUrl");
    if(StringUtils.isNotBlank(backUrl01)) backUrl01 = URLDecoder.decode(backUrl01, "UTF-8");
	else backUrl01 = "";

    String backUrl02 = request.getParameter("ReturnUrl");
    if(StringUtils.isNotBlank(backUrl02)) backUrl02 = URLDecoder.decode(backUrl02, "UTF-8");
	else backUrl02 = "";

	String backUrl03 = request.getParameter("backUrl03");
    if(StringUtils.isBlank(backUrl03)){
        String epgInfo = request.getParameter("epg_info");
        if(StringUtils.isNotBlank(epgInfo)){
        	if(epgInfo.contains("<page_url>")){
				backUrl03 = epgInfo.substring(epgInfo.indexOf("<page_url>") + "<page_url>".length());
				backUrl03 = backUrl03.substring(0, backUrl03.indexOf("</page_url>"));
			} else backUrl03 = "";
		} else backUrl03 = "";
    }

    String backUrl04 = request.getParameter("backUrl04");
    if(StringUtils.isBlank(backUrl04)) backUrl04 = "";

    String backUrl05 = request.getParameter("backUrl05");
    if(StringUtils.isBlank(backUrl05)) backUrl05 = "";

	// 用户登录平台,一般只有中兴和华为 1:中兴用户 2:华为用户
    int platform = 1;
    String providerid = request.getParameter("StbVendor");
    if(StringUtils.isNotBlank(providerid)){
        if(providerid.indexOf("HW") > -1 || providerid.indexOf("hw") > -1 || providerid.indexOf("HUAWEI") > -1 || providerid.indexOf("huawei") > -1) platform = 2;
    }
	// 获取全局APP配置信息,但可能这些信息不是应用中会使用的(具体配置参数含义请参照config_app表)
	List<Map<String, Object>> gac = InfoData.getAppConfig("admin");
	// 首先给APP配置信息都设置一个默认值
	int mourningDay = 0;
	for(int i = 0; i < gac.size(); i++){
		Map<String, Object> mapAC = gac.get(i);
		String ckey = mapAC.get("ckey").toString();
		String cval = mapAC.get("cval").toString();
		if(ckey.equals("mourningDay")) mourningDay = Integer.parseInt(cval);
	}
	// 页面尺寸
	int pageW = 1280;
	int pageH = 720;

	Map<String, Object> gpd = InfoData.getUiPageDetail(pageId);
	String grul = request.getRequestURL().toString();
	String bootPath = "http://202.99.114.152:26800/joymusic_bs_tjlt/interface/zone_hall_211.jsp";
	if(grul.contains("192.168.") || grul.contains("127.0.0.1") || grul.contains("localhost")) bootPath = "http://192.168.100.161:53004/joymusic_bs_tjlt/interface/zone_hall_211.jsp";
	
	String rt = authResult211(userid, "", provinceN);
%>
<!DOCTYPE html>
<html lang='\"n'>
	<head>
		<meta http-equiv='pragma' content='no-cache'>
		<meta http-equiv='Content-Type' content='text/html;charset=UTF-8' />
		<meta http-equiv='cache-control' content='no-store,no-cache,must-revalidate'>
		<meta http-equiv='expires' content='0'>
		<meta name='page-view-size' content='<%=pageW %>*<%=pageH %>'>
		<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
		<title><%=gpd.get("cname") %></title><%if(mourningDay == 1){%>
		<!-- 全国哀悼日灰色网站 -->
		<style type='text/css'>
			html{filter: progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-webkit-filter:grayscale(100%)}
		</style><%}%>
		<script type='text/javascript' src='javascript/jsdata.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/tools.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/extra.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript'>
			// 用户ID
			var userid = '<%=userid %>';
			var UserID = '<%=UserID %>';
			//设备号
			var deviceId = '';
			var userip = '';
			// 用户临时token
			var userToken = '<%=userToken %>';
			// 用户平台
			var platform = <%=platform %>;
			// 用户省份编号
			var provinceN = '<%=provinceN %>';
			// 用户城市编号
			var cityN = '';
			// 实际应用显示尺寸
			var pageW = <%=pageW %>;
			var pageH = <%=pageH %>;
			// 当前焦点
			var nowFocus = 'f_211_<%=tempF %>';
			// 当前页码ID
			var pageId = <%=pageId %>;
			// 滑动频率
			var frequency = 0;
			// 允许按键
			var allowClick = true;
			// 是否支持动画 0:不支持 1:支持
			var animation = 1;
			// 机顶盒型号|机顶盒版本
			var stbType = '';
			var stbVersion = '';
			// 可能涉及到的返回页面地址
			var backUrl01 = '';
			if(backUrl01.indexOf('?') > -1 || backUrl01.indexOf('<') > -1) backUrl01 = encodeURIComponent(backUrl01);
			var backUrl02 = '<%=backUrl02 %>';
			if(backUrl02.indexOf('?') > -1 || backUrl02.indexOf('<') > -1) backUrl02 = encodeURIComponent(backUrl02);
			// if(backUrl02 && backUrl02 != '') SetCookie('backUrl02', backUrl02, 1, '', '', '');
			var backUrl03 = '';
			if(backUrl03.indexOf('?') > -1 || backUrl03.indexOf('<') > -1) backUrl03 = encodeURIComponent(backUrl03);
			var backUrl04 = '';
			if(backUrl04.indexOf('?') > -1 || backUrl04.indexOf('<') > -1) backUrl04 = encodeURIComponent(backUrl04);
			var backUrl05 = '';
			if(backUrl05.indexOf('?') > -1 || backUrl05.indexOf('<') > -1) backUrl05 = encodeURIComponent(backUrl05);
			// 传入引导页的参数
			var allStr = '<%=allStr %>';
			if(allStr.indexOf('?') > -1 || allStr.indexOf('<') > -1) allStr = encodeURIComponent(allStr);
			// config
			var isOnline = '<%=isOnline %>';
			var mourningDay = <%=mourningDay %>;
			// 控制是否执行start函数
			var ctlStart = false;
			// 6张推荐位
			var contentArr = new Array();
			// 接收中间歌曲
			var songArr = new Array();
			// 每次移动目标纵轴
			var moveH = [0, -39, -99, -159, -219, -279, -339, -350];
			// 移动的基础点
			var moveHIdx = <%=moveHIdx %>;

			try{
				stbType = Authentication.CTCGetConfig('STBType');
				stbVersion = Authentication.CTCGetConfig('STBVersion');
				// 中兴老的盒子获取机顶盒型号的方法 
				if((!stbType || stbType == '') && typeof(ztebw) == 'object'){
					stbType = ztebw.ioctlRead('infoZTEHWType'); 
					if(!stbType || stbType == ''){ 
						stbType = ztebw.ioctlRead('infoHWProduct'); 
					} 
				}
				if(!userid || userid == ''){
					// 此方法经测试目前可以获取到华为，中兴，创维三款机顶盒型号
					userid = Authentication.CTCGetConfig('UserID');
					if(!userid || userid == ''){
						userid = Authentication.CUGetConfig('UserID');
					}
					// 烽火的机顶盒 
					if(!userid || userid == ''){
						userid = Authentication.CTCGetConfig('device.userid'); 
					}
					if(!userid || userid == ''){
						userid = 'tvtest';
					}
					platform = 1;
		        }
		    } catch(e){
		    	if(!userid){
		    		// 浏览器测试
					var ua = window.navigator.userAgent.toLocaleLowerCase();
					var browserType = null;
					if(ua.match(/msie/) != null || ua.match(/trident/) != null) userid = 'IEbrowsertest';
					else if(ua.match(/tencenttraveler/) != null || ua.match(/qqbrowse/) != null) userid = 'QQbrowsertest';
					else if(ua.match(/ubrowser/) != null) userid = 'UCbrowsertest';
					else if(ua.match(/bidubrowser/) != null) userid = 'baidubrowsertest';
					else if(ua.match(/firefox/) != null) userid = 'firefoxbrowsertest';
					else if(ua.match(/metasr/) != null) userid = 'sogoubrowsertest';
					else if(ua.match(/opr/) != null) userid = 'operabrowsertest';
					else if(ua.match(/maxthon/) != null) userid = 'maxthonbrowsertest';
					else if(ua.match(/edg/) != null) userid = 'Edgebrowsertest';
					else if(ua.match(/chrome/) != null) {
						var is360 = _mime('type', 'application/vnd.chromium.remoting-viewer');
						function _mime(option, value){
							var mimeTypes = window.navigator.mimeTypes;
							for(var mt in mimeTypes){
								if(mimeTypes[mt][option] == value || mimeTypes[mt][option] == 'application/360softmgrplugin') return true;
							}
							return false;
						}
						if(is360) userid = '360browsertest';
						else userid = 'chromebrowsertest';
					} else if(ua.match(/safari/) != null) browserType = 'safaribrowsertest';
					if(!userid){ // 移动终端测试
						if(ua.match(/Android/) != null || ua.match(/android/) != null) userid = 'androidmobiletest';
						else if(ua.match(/iPhone/) != null || ua.match(/iphone/) != null || ua.match(/iPad/) != null || ua.match(/ipad/) != null) userid = 'iphonemobiletest';
					}
				}
				userid = userid + 'cucc999999';
				stbType = userid + 'STBTEST';
				stbVersion = userid + '_1.0';
			}
			if(!userid){
				window.opener = null;
				window.open('', '_self');
				window.close();
			}

			// 页面初始载入function
			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				loadEle();
				var posM = moveH[moveHIdx];
				$g('BigDiv').style.top = posM + 'px';
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
			}

			function loadEle(){
				allowClick = false;
				var reqUrl = pageId + '?d=1';
				ajaxRequest('POST', reqUrl, function(){
					if(xmlhttp.readyState == 4){
						if(xmlhttp.status == 200){
							var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
							contentArr = eval('(' + retText + ')');
							if(contentArr.length > 0){
								for(var i = 0; i < contentArr.length; i++){
									var idx = i + 1;
									$g('cp' + idx).src = 'images/commonly/zone_hall_211/' + contentArr[i].pic;
									if(i == contentArr.length - 1) loadSong();
								}
							}
						}
					}
				});
			}

			function loadSong(){
				allowClick = false;
				var reqUrl = '<%=bootPath %>';
				ajaxRequest('POST', reqUrl, function(){
					if(xmlhttp.readyState == 4){
						if(xmlhttp.status == 200){
							var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
							songArr = eval('(' + retText + ')');
							if(songArr.length > 0){
								for(var i = 0; i < 10; i++){
									var idx = i + 1;
									if(i < 3 || (i > 4 && i < 8)) $g('z_211_' + idx).innerHTML = '<div style=\'float:left\'>' + songArr[i].cname + '</div><img style=\'float:left;padding-left:20px;padding-top:17px\' src=\'images/application/pages/zone_hall_211/vip.png\' />';
									else $g('z_211_' + idx).innerHTML = '<div style=\'float:left\'>' + songArr[i].cname + '</div><img style=\'float:left;padding-left:20px;padding-top:17px\' src=\'images/application/pages/zone_hall_211/free.png\' />';
									$g('a_211_' + idx).innerHTML = songArr[i].artist;
									if(i == 9) allowClick = true;
								}
							}
						}
					}
				});
			}

		    function keyPress(event){
				event = event ? event : window.event;<%if(isOnline.equals("y")){%>
				if(event.preventDefault) event.preventDefault();
				else event.returnValue = false;
				if(event.stopPropagation) event.stopPropagation();
				else event.cancelBubble = true;<%}%>
				var keyCode = event.which ? event.which : event.keyCode;

				keyAction(keyCode);
			}
			// 键盘事件
			document.onkeydown = keyPress;

			function keyAction(keyCode){
				if(keyCode == 8 || keyCode == 24 || keyCode == 27 || keyCode == 32){
					onkeyBack();
				} else if(keyCode == 37){
					onkeyLeft();
				} else if(keyCode == 38){
					onkeyUp();
				} else if(keyCode == 39){
					onkeyRight();
				} else if(keyCode == 40){
					onkeyDown();
				} else if(keyCode == 13){
					onkeyOK();
				}
			}

			function onkeyLeft(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 1 && tempF < 4) || (tempF > 14 && tempF < 17)){
						var newIdx = tempF - 1;
						nowFocus = 'f_211_' + newIdx;
					} else if(tempF > 8 && tempF < 14){
						var newIdx = tempF - 5;
						nowFocus = 'f_211_' + newIdx;
					}
					var tempS = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 0 && tempF < 3) || (tempF > 13 && tempF < 16)){
						var newIdx = tempF + 1;
						nowFocus = 'f_211_' + newIdx;
					} else if(tempF > 3 && tempF < 9){
						var newIdx = tempF + 5;
						nowFocus = 'f_211_' + newIdx;
					}
					var tempS = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyUp(){
				if(allowClick){
					// allowClick = false;
					var tempF = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 4) nowFocus = 'f_211_1';
					else if(tempF == 9) nowFocus = 'f_211_3';
					else if((tempF > 4 && tempF < 9) || (tempF > 9 && tempF < 14)){
						var newIdx = tempF - 1;
						nowFocus = 'f_211_' + newIdx;
					} else if(tempF == 14 || tempF == 15) nowFocus = 'f_211_8';
					else if(tempF == 16) nowFocus = 'f_211_13';
					var tempS = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					// movePos('up');
				}
			}

			function onkeyDown(){
				if(allowClick){
					// allowClick = false;
					var tempF = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 3) nowFocus = 'f_211_4';
					else if(tempF == 3) nowFocus = 'f_211_9';
					else if((tempF > 3 && tempF < 8) || (tempF > 8 && tempF < 13)){
						var newIdx = tempF + 1;
						nowFocus = 'f_211_' + newIdx;
					} else if(tempF == 8) nowFocus = 'f_211_14';
					else if(tempF == 13) nowFocus = 'f_211_16';
					var tempS = getIdx(nowFocus, 'f_211_');
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					// movePos('down');
				}
			}

			function movePos(dir){
				// var tempS = getIdx(nowFocus, 'f_211_');
				if(dir == 'down'){
					if(moveHIdx < moveH.length - 1) moveHIdx++;
					/*var eleH = $g('f_211_' + tempS).offsetHeight;
					var eleT = $g('f_211_' + tempS).offsetTop;
					var posM = (720 - eleH) / 2 - eleT;
					if(posM <= -350) posM = -350;
					animateY('BigDiv', posM, frequency, function(){
						allowClick = true;
					});*/
				} else if(dir == 'up'){
					if(moveHIdx > 0) moveHIdx--;
					/*var eleH = $g('f_211_' + tempS).offsetHeight;
					var eleT = $g('f_211_' + tempS).offsetTop;
					var posM = (720 - eleH) / 2 - eleT;
					if(posM >= 0) posM = 0;
					animateY('BigDiv', posM, frequency, function(){
						allowClick = true;
					});*/
				}
				var posM = moveH[moveHIdx];
				$g('BigDiv').style.top = posM + 'px';
				// animateY('BigDiv', posM, frequency, function(){
				//	allowClick = true;
				// });
			}

			function animateY(id, target, speed, fun){
				if(animation == 0) nextDirectY(id, target, fun);
				else nextSlideY(id, target, speed, fun);
			}

			function onkeyBack(){
				exitHall211();
			}

			function onkeyOK(){
				var tempF = getIdx(nowFocus, 'f_211_');
				var ReturnUrl = 'http://202.99.114.152:26800/joymusic_cucc_center/211?moveHIdx=' + moveHIdx + '&tempF=' + tempF + '&UserID=' + UserID + '&LoginID=' + UserID + '&carrierId=211&UserToken=' + userToken + '&ReturnUrl=' + backUrl02;
				ReturnUrl = encodeURIComponent(ReturnUrl);
				var toUrl = '';
				var key = '';
				if(tempF < 4){
					var i = tempF - 1;
					toUrl = contentArr[i].curl;
					key = contentArr[i].params;
				} else if(tempF >= 4 && tempF < 14){
					var i = tempF - 4;
					if(tempF < 7 || (tempF > 8 && tempF < 12)) toUrl = 'http://202.99.114.152:26800/joymusic_bs_tjlt/?boot=999_211_' + songArr[i].id + '&entryId=' + songArr[i].id;
					else toUrl = 'http://202.99.114.152:26800/joymusic_bs_tjlt/?boot=998_211_' + songArr[i].id + '&entryId=' + songArr[i].id;
					key = songArr[i].tsid;
				} else{
					var i = tempF - 11;
					toUrl = contentArr[i].curl;
					key = contentArr[i].params;
				}
				var docUrl = 'h5?o=1&u=' + userid + '&k=' + key + '&ps=' + tempF + '&p=211&ot=';
				ajaxRequest('POST', docUrl, function(){
					if(xmlhttp.readyState == 4){
						if(xmlhttp.status == 200){
							var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
							var contentJson = eval('(' + retText + ')');
							toUrl = toUrl + (toUrl.indexOf('?') > -1 ? '&' : '?');
							toUrl = toUrl + 'UserID=' + UserID + '&LoginID=' + UserID + '&carrierId=211&UserToken=' + userToken + '&ifReturn=y&ReturnUrl=' + ReturnUrl;
							window.location.href = toUrl;
						}
					}
				});
			}

			function exitHall211(){
				var backUrl = decodeURIComponent(backUrl02);
				if(backUrl && backUrl != '') window.location.href = backUrl;
			}
		</script>
	</head>

	<body onload='start()' bgcolor='<%if(isOnline.equals("y")){%>#000000<%} else{%>#444444<%}%>'>
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<div style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/application/pages/zone_hall_211/hall211.jpg)'></div>
			<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px'>
				<img id='cp1' src='images/application/pages/zone_hall_211/null.png' style='position:absolute;width:340px;height:81px;left:82px;top:54px;z-index:1' />
				<img id='cp2' src='images/application/pages/zone_hall_211/null.png' style='position:absolute;width:340px;height:81px;left:464px;top:54px;z-index:1' />
				<img id='cp3' src='images/application/pages/zone_hall_211/null.png' style='position:absolute;width:340px;height:81px;left:846px;top:54px;z-index:1' />
				<img id='pay1' src='images/application/pages/zone_hall_211/payhall<%if(!rt.equals("0")){%>1<%}%>.png' style='position:absolute;width:80px;height:54px;left:347px;top:50px;z-index:2' />
				<img id='pay2' src='images/application/pages/zone_hall_211/payhall<%if(!rt.equals("0")){%>1<%}%>.png' style='position:absolute;width:80px;height:54px;left:729px;top:50px;z-index:2' />
				<img id='pay3' src='images/application/pages/zone_hall_211/payhall<%if(!rt.equals("0")){%>1<%}%>.png' style='position:absolute;width:80px;height:54px;left:1111px;top:50px;z-index:2' />
				<img id='f_211_1' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_4.png' style='position:absolute;width:351px;height:92px;left:77px;top:49px;z-index:3' />
				<img id='f_211_2' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_4.png' style='position:absolute;width:351px;height:92px;left:459px;top:49px;z-index:3' />
				<img id='f_211_3' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_4.png' style='position:absolute;width:351px;height:92px;left:841px;top:49px;z-index:3' /><%int left = 0; int top = 0; for(int i = 1; i < 6; i++){ top = (i - 1) * 46 + 216; left = 55;%>
				<div id='z_211_<%=i %>' style='position:absolute;width:400px;height:53px;left:<%=left + 60 %>px;top:<%=top %>px;line-height:53px;font-size:22px;color:#FFFFFF;z-index:2'></div>
				<div id='a_211_<%=i %>' style='position:absolute;width:179px;height:53px;left:<%=left + 380 %>px;top:<%=top %>px;line-height:53px;font-size:22px;color:#FFFFFF;text-align:right;z-index:2'></div>
				<img id='f_211_<%=i + 3 %>' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_5.png' style='position:absolute;width:579px;height:53px;left:<%=left %>px;top:<%=top %>px;z-index:3' /><%left = 644;%>
				<div id='z_211_<%=i + 5 %>' style='position:absolute;width:400px;height:53px;left:<%=left + 60 %>px;top:<%=top %>px;line-height:53px;font-size:22px;color:#FFFFFF;z-index:2'></div>
				<div id='a_211_<%=i + 5 %>' style='position:absolute;width:179px;height:53px;left:<%=left + 380 %>px;top:<%=top %>px;line-height:53px;font-size:22px;color:#FFFFFF;text-align:right;z-index:2'></div>
				<img id='f_211_<%=i + 8 %>' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_5.png' style='position:absolute;width:579px;height:53px;left:<%=left %>px;top:<%=top %>px;z-index:3' /><%}%>
				<img src='images/application/pages/zone_hall_211/list1.png' style='position:absolute;width:570px;height:273px;left:59px;top:175px;z-index:1' />
				<img src='images/application/pages/zone_hall_211/list2.png' style='position:absolute;width:570px;height:273px;left:644px;top:175px;z-index:1' />
				<img src='images/application/pages/zone_hall_211/rec.png' style='position:absolute;width:141px;height:33px;left:61px;top:758px;z-index:1' />
				<img id='cp4' src='images/application/pages/zone_hall_211/370_210.png' style='position:absolute;width:370px;height:210px;left:54px;top:455px;z-index:1' />
				<img id='cp5' src='images/application/pages/zone_hall_211/370_210.png' style='position:absolute;width:370px;height:210px;left:448px;top:455px;z-index:1' />
				<img id='cp6' src='images/application/pages/zone_hall_211/370_210.png' style='position:absolute;width:370px;height:210px;left:842px;top:455px;z-index:1' />
				<img id='f_211_14' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_3.png' style='position:absolute;width:381px;height:221px;left:49px;top:450px;z-index:2;' />
				<img id='f_211_15' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_3.png' style='position:absolute;width:381px;height:221px;left:443px;top:450px;z-index:2' />
				<img id='f_211_16' class='btn_focus_hidden' src='images/application/pages/zone_hall_211/focus/f_3.png' style='position:absolute;width:381px;height:221px;left:837px;top:450px;z-index:2' />
				<img src='images/application/pages/zone_hall_211/free.png' style='position:absolute;width:47px;height:23px;left:375px;top:482px;z-index:3;' />
				<img src='images/application/pages/zone_hall_211/free.png' style='position:absolute;width:47px;height:23px;left:769px;top:482px;z-index:3' />
				<img src='images/application/pages/zone_hall_211/free.png' style='position:absolute;width:47px;height:23px;left:1163px;top:482px;z-index:3' />
			</div>
		</div>
	</body>
	<script type='text/javascript'>
		start();
	</script>
	<script type='text/javascript' src='javascript/app.js?r=<%=Math.random() %>'></script>
</html>