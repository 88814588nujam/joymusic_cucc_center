<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.util.*,java.io.*,java.net.*,java.util.regex.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger("mydebug");
	
	// 读取本期载入的一个本地loading图
	private String getRandPic(String path){
		// 设置一个默认的loadind图以防没有载入图
		String picPath = "images/commonly/boot/joymusic.png";
		try{
			List<Integer> list = new ArrayList<Integer>();
			File file = new File(path);
			// 如果传入的本地载入图路径是存在的,遍历该路径下所有文件夹,得到日期最靠后的文件夹名
			if(file.exists()){
	            File[] files = file.listFiles();
	            for(File fileSon : files){
	                if(fileSon.isDirectory()){
	                	int tempNum = Integer.parseInt(fileSon.getName().replace("boot", ""));
	                    list.add(tempNum);
	                }
	            }
			}
			// 得到日期最靠后的文件夹名后,随机从中间读取一张载入图并返回该图片的路径
			if(list.size() > 0){
				int fileSum = 0;
				int max = Collections.max(list);
				List<String> list0 = new ArrayList<String>();
				File tempFile = new File(path + "/boot" + max);
				if(tempFile.exists()){
		            File[] files = tempFile.listFiles();
					for(File fileSon : files){
		                if(!fileSon.isDirectory()){
		                	list0.add(fileSon.getName());
		                }
		            }
				}
				if(list0.size() > 0){
					Collections.shuffle(list0);
					picPath = "images/HD/photos/boot/boot" + max + "/" + list0.get(0);
				}
			}
		} catch(Exception e){}
		return picPath;
	}
 %>
<%
	// 直接可以访问到的页面便面参数异常等问题做的操作
	String requestStr = UrlHandle.getRequestString(request);
	boolean sqlFlag = UrlHandle.isRealStr(requestStr);
	// 如果该参数不合法直接转向错误页面
	if(!sqlFlag) response.sendRedirect("error.jsp");
	// 有时候需要整串接收参数(如在测试环境中,向测试页面传递入口常规参数)
	String allStr = request.getQueryString();
	if(StringUtils.isBlank(allStr)) allStr = "";
	// 用户登陆的是否是测试平台(本条对应的是机顶盒而言) 
	String isOnline = request.getParameter("isOnline");
	if(StringUtils.isBlank(isOnline)){
		isOnline = "y";
	}
	// 由于有些地区要求EPG大厅等入口推荐位进入活动专题不允许出现loading图而产生的参数
	String loadpic = request.getParameter("loadpic");
	if(StringUtils.isBlank(loadpic)){
		loadpic = "y";
	}
	// 进入时的页码
	String pageId = request.getParameter("p");
	if(StringUtils.isBlank(pageId)){
		pageId = "1";
	}
	// 进入时的关键字
	String keyword = request.getParameter("k");
	if(StringUtils.isBlank(keyword)){
		keyword = "";
	}
	// 进入的平台
	String fromPage = request.getParameter("f");
	if(StringUtils.isBlank(fromPage)){
		fromPage = "";
	}
	// 是否直接退出平台 n不直接退出 y直接退出
	String needQuit = request.getParameter("q");
	if(StringUtils.isBlank(needQuit)){
		needQuit = "n";
	}
	// 接收所属省份的code
	String provinceN = request.getParameter("areaID");
	if(StringUtils.isBlank(provinceN)){
		provinceN = "201";
	}
	// 接收使用该产品的用户账号(可能进入不传递该参数,需要从JS API中获取)
	String userid = request.getParameter("UserID");
    if(StringUtils.isBlank(userid)){
        userid = request.getParameter("userId");
        if(StringUtils.isBlank(userid)){
            userid = "";
        }
    }
    // 接收使用该产品的用户IP
    String userip = request.getParameter("userIP");
    if(StringUtils.isBlank(userip)){
        userip = "";
    }
    if(userid.contains("_")){
		String[] ifTogether = userid.split("_");
		Pattern pattern = Pattern.compile("[0-9]*");
		Matcher isNum = pattern.matcher(ifTogether[1]);
		if(isNum.matches()){
			provinceN = userid.substring(userid.indexOf("_") + "_".length());
			userid = userid.substring(0, userid.indexOf("_"));
		} else{
			provinceN = request.getParameter("carrierId");
			if(StringUtils.isBlank(provinceN)) provinceN = request.getParameter("carrierid");
		}
	} else{
		provinceN = request.getParameter("carrierId");
		if(StringUtils.isBlank(provinceN)) provinceN = request.getParameter("carrierid");
    }
	if(StringUtils.isBlank(provinceN)){
		provinceN = "201";
	}
	// 接收使用该产品的用户临时身份证明(可能进入不传递该参数,需要从JS API中获取)
    String userToken = request.getParameter("UserToken");
    if(StringUtils.isBlank(userToken)){
        userToken = "";
    }
	// 一些地区一次性会传过来很多个返回地址,因为暂时不知道会需要返回哪个,干脆全部存储,按照url有长度的限制来看,最多只能传进来5条返回地址进行接收
    String backUrl01 = request.getParameter("HomeUrl");
    if(StringUtils.isNotBlank(backUrl01)){
        backUrl01 = URLDecoder.decode(backUrl01, "UTF-8");
    } else{
        backUrl01 = "";
    }
    String backUrl02 = request.getParameter("ReturnUrl");
    if(StringUtils.isNotBlank(backUrl02)){
        backUrl02 = URLDecoder.decode(backUrl02, "UTF-8");
    } else{
        backUrl02 = "";
    }
	String backUrl03 = request.getParameter("backUrl03");
    if(StringUtils.isBlank(backUrl03)){
        if(StringUtils.isBlank(userToken) && provinceN.equals("204") && fromPage.equals("2")){
            backUrl03 = "http://202.99.114.27:35811/epg_uc/views/login/login.html?carrierId=204&userId="
				+ userid + "&returnUrl=" + URLEncoder.encode(backUrl02, "UTF-8") + "&UserToken=&tvplat=";
        } else{
        	String epgInfo = request.getParameter("epg_info");
        	if(StringUtils.isNotBlank(epgInfo)){
        		if(epgInfo.contains("<page_url>")){
					backUrl03 = epgInfo.substring(epgInfo.indexOf("<page_url>") + "<page_url>".length());
					backUrl03 = backUrl03.substring(0, backUrl03.indexOf("</page_url>"));
				} else{
					backUrl03 = "";
	            }
        	} else{
				backUrl03 = "";
            }
        }
    }
	String usingPageNav = request.getParameter("usingPageNav");
	if(StringUtils.isNotBlank(usingPageNav) && provinceN.equals("204")){
		backUrl03 = "http://10.253.255.43:9141/toUrl/toUrl.html?contId=221334173";
	}
    String backUrl04 = request.getParameter("backUrl04");
    if(StringUtils.isBlank(backUrl04)){
        backUrl04 = "";
    }
    String backUrl05 = request.getParameter("backUrl05");
    if(StringUtils.isBlank(backUrl05)){
        backUrl05 = "";
    }
	// 用户登录平台,一般只有中兴和华为 1:中兴用户 2:华为用户
    int platform = 1;
    String providerid = request.getParameter("StbVendor");
    // 河南有平台字段
    if(provinceN.equals("204")){
        providerid = request.getParameter("platform");
    }
    if(StringUtils.isNotBlank(providerid)){
        if(providerid.indexOf("HW") > -1 || providerid.indexOf("hw") > -1 || providerid.indexOf("HUAWEI") > -1 || providerid.indexOf("huawei") > -1){
            platform = 2;
        }
    }
	// 获取全局APP配置信息,但可能这些信息不是应用中会使用的(具体配置参数含义请参照config_app表)
	List<Map<String, Object>> gac = InfoData.getAppConfig("admin");
	// 首先给APP配置信息都设置一个默认值
	int allFreeSwitch = 0;
	int observerSwitch = 0;
	int paymentMode = 0;
	int mourningDay = 0;
	for(int i = 0; i < gac.size(); i++){
		Map<String, Object> mapAC = gac.get(i);
		String ckey = mapAC.get("ckey").toString();
		String cval = mapAC.get("cval").toString();
		if(ckey.equals("allFreeSwitch")) allFreeSwitch = Integer.parseInt(cval);
		else if(ckey.equals("observerSwitch")) observerSwitch = Integer.parseInt(cval);
		else if(ckey.equals("paymentMode")) paymentMode = Integer.parseInt(cval);
		else if(ckey.equals("mourningDay")) mourningDay = Integer.parseInt(cval);
	}
	// 默认载入图应该是在服务器上一个物理位置存储
	String grul = request.getRequestURL().toString();
	String bootPath = "/home/data/wwwroot/tomcat1/" + request.getContextPath() + "/images/HD/photos/boot/";
	if(grul.contains("127.0.0.1") || grul.contains("192.168.") || grul.contains("localhost")) bootPath = "C:/apache-tomcat-8.5.68/webapps" + request.getContextPath() + "/images/commonly/boot/";
	// 读取本期载入的一个本地loading图
	String picPath = getRandPic(bootPath);
	// 页面尺寸
	int pageW = 1280;
	int pageH = 720;

	Map<String, Object> gpd = InfoData.getUiPageDetail(0);
	String domainName = "txhyxa.njqyfk.com:59001";
%>
<!DOCTYPE html>
<html lang='en'>
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
			// 机顶盒型号|机顶盒版本
			var stbType = '';
			var stbVersion = '';
			// 可能涉及到的返回页面地址
			var backUrl01 = '';
			if(backUrl01.indexOf('?') > -1 || backUrl01.indexOf('<') > -1) backUrl01 = encodeURIComponent(backUrl01);
			var backUrl02 = '';
			if(backUrl02.indexOf('?') > -1 || backUrl02.indexOf('<') > -1) backUrl02 = encodeURIComponent(backUrl02);
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
			var allFreeSwitch = <%=allFreeSwitch %>;
			var observerSwitch = <%=observerSwitch %>;
			var paymentMode = <%=paymentMode %>;
			var mourningDay = <%=mourningDay %>;
			// 需要转向的页面和参数
			var pageId = <%=pageId %>;
			var keyword = '<%=keyword %>';
			// 页面入口接收参数
			var fromPage = '<%=fromPage %>';
			var needQuit = '<%=needQuit %>';
			// 控制是否执行start函数
			var ctlStart = false;
			// 中心服务域名
			var domainName = '<%=domainName %>';

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
				var uInfo = 'h1?u=' + userid + '&p=' + platform + '&pn=' + provinceN + '&cn=' + cityN + '&o=' + userToken + '&i=' + userip + '&st=' + stbType + '&sv=' + stbVersion + '&tp=' + pageId + '&tk=' + keyword;
				ajaxRequest('POST', uInfo, toNext);
			}

			function toNext(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var jsonStr = eval('(' + retText + ')');
						postJsonLog(3, '', 0, function(){ moreInfoBack(jsonStr); });
					}
				}
			}

			function moreInfoBack(json){
				var delayT = 1000; // 延时跳转时间,毫秒计算
				// 以下参数虽然不是线上应用内容必须使用到的,但可能涉及测试
				put('globle', 'isOnline', isOnline + ''); // 如果入口不传参则为测试环境
				put('globle', 'allFreeSwitch', allFreeSwitch + ''); // 是否激活免费观看
				put('globle', 'observerSwitch', observerSwitch + ''); // 是否激活观察模式（0：未激活 1：激活 只有非tv可见）
				put('globle', 'paymentMode', paymentMode + ''); // 付费模式 (0：点播即刻付费 1：试看后付费)
				put('globle', 'mourningDay', mourningDay + ''); // 哀悼日 (0：不是哀悼日 1：是哀悼日)
				put('globle', 'stbType', stbType + ''); // 使用机顶盒型号
				put('globle', 'stbVersion', stbVersion + ''); // 使用机顶盒版本
				put('globle', 'animation', json.animation + ''); // 机顶盒是否支持动画
				put('globle', 'remote', '0'); // 机顶盒是否支持手机遥控
				put('globle', 'fromPage', fromPage + ''); // 用户进入页面时的平台
				put('globle', 'needQuit', needQuit + ''); // 用户进入页面后是否需要直接退出平台
				// 以下参数基本都是有用处的参数,实际情况下应该尽量获取
				put('globle', 'keyword', keyword + ''); // 进入地址使用的跳转标志
				put('globle', 'provinceN', json.provinceN + ''); // 所属省份编号
				put('globle', 'provinceC', json.provinceC + ''); // 所属省份中文
				put('globle', 'cityN', json.cityN + ''); // 所属城市编号
				put('globle', 'cityC', json.cityC + ''); // 所属城市中文
				put('globle', 'platform', platform + ''); // 用户登陆的平台 1:中兴 2:华为
				put('globle', 'userid', userid + ''); // 使用该产品的用户账号
				put('globle', 'userip', json.userip + ''); // 使用该产品的用户ip
				put('globle', 'userToken', userToken + ''); // 使用该产品的用户临时token
				put('globle', 'isOrder', json.isOrder + ''); // 用户是否订购 y:否 0:是
				put('globle', 'preferTheme', json.preferTheme + ''); // 用户偏好主题
				put('globle', 'preferPlayer', json.preferPlayer + ''); // 用户偏好阅读器
				put('globle', 'preferList', json.preferList + ''); // 用户偏好列表
				put('globle', 'preferKeyboard', json.preferKeyboard + ''); // 用户偏爱输入键盘
				put('globle', 'preferBubble', json.preferBubble + ''); // 偏好气泡提示
				put('globle', 'preferGuide', json.preferGuide + ''); // 偏好导读模式
				put('globle', 'hour', json.hour + ''); // 用户使用列表有效时间
				put('globle', 'max', json.max + ''); // 用户使用列表有效条目上限数
				// 以下参数是保存websocket相关信息
				put('globle', 'domainName', domainName + '');
				// 一些地区一次性会传过来很多个返回地址,因为暂时不知道会需要返回哪个,干脆全部存储,按照url有长度的限制来看,最多只能传进来5条返回地址进行接收
				put('globle', 'backUrl01', backUrl01 + ''); // 可能会携带的第一个返回地址
				put('globle', 'backUrl02', backUrl02 + ''); // 可能会携带的第二个返回地址
				put('globle', 'backUrl03', backUrl03 + ''); // 可能会携带的第三个返回地址
				put('globle', 'backUrl04', backUrl04 + ''); // 可能会携带的第四个返回地址
				put('globle', 'backUrl05', backUrl05 + ''); // 可能会携带的第五个返回地址
				// 因为地址过长等等问题,最好记录一下cookie
				ClearCookie('backUrl01');
				if(backUrl01 && backUrl01 != '') SetCookie('backUrl01', backUrl01, 1, '', '', '');
				ClearCookie('backUrl02');
				if(backUrl02 && backUrl02 != '') SetCookie('backUrl02', backUrl02, 1, '', '', '');
				ClearCookie('backUrl03');
				if(backUrl03 && backUrl03 != '') SetCookie('backUrl03', backUrl03, 1, '', '', '');
				ClearCookie('backUrl04');
				if(backUrl04 && backUrl04 != '') SetCookie('backUrl04', backUrl04, 1, '', '', '');
				ClearCookie('backUrl05');
				if(backUrl05 && backUrl05 != '') SetCookie('backUrl05', backUrl05, 1, '', '', '');
				ClearCookie('allStr');
				if(allStr && allStr != '') SetCookie('allStr', allStr, 1, '', '', '');
				// 跳转目标页面
				if(pageId == 100){ //说明需要去单独播放
					var dataUrl = 'h2';
				    var sid = keyword;
				    var hour = json.hour;
				    var max = json.max;
				    var opr = 1;
				    operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
				        setTimeout(function(){
				       		toPlayer();
				        }, delayT);
			       });
				} else{
					if(pageId == 7 || pageId == 8){
						if(json.preferList == 0) pageId = 7;
						else if(json.preferList == 1) pageId = 8;
					} else if(pageId == 11 || pageId == 12){
						if(json.preferList == 0) pageId = 11;
						else if(json.preferList == 1) pageId = 12;
					}
					put('request', 'params', 'i=' + pageId + (!keyword ? '' : '&k=' + keyword));
					setTimeout(function(){go(pageId);}, delayT);
				}
			}
			
			function toPlayer(){
			    var delayT = 500;
			    put('request', 'params', 'i=' + pageId);
			    setTimeout(function(){round(pageId);}, delayT);
		    }
		</script>
	</head>

	<body onload='start()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<div style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;z-index:1'>
				<!-- <img src='<%=picPath%>' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;z-index:2;display:<%if(loadpic.equals("y")){%>block<%} else{%>none<%}%>'/> -->
				<img src='images/commonly/boot/black_boot.png' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;left:0px;top:0px;z-index:2'/>
			</div>
		</div>
	</body>
	<script type='text/javascript'>
		start();
	</script>
	<script type='text/javascript' src='javascript/app.js?r=<%=Math.random() %>'></script>
</html>