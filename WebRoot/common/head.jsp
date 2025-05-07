<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.util.*,org.json.JSONObject,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	// 页面尺寸(单位:px)
	static int pageW = 1280;
	static int pageH = 720;
	// 常量
	// 影视金曲榜 10000 recommend_song
	// 儿歌热搜榜 10001 recommend_song
	// 一周热歌榜 10002 recommend_song
	// 经典老歌榜 10003 recommend_song
	// 流行金曲榜 10004 recommend_song
	// 新歌速递榜 10005 recommend_song
	static int movieList = 10000;
	static int kidsList = 10001;
	static int weekList = 10002;
	static int nostalgiaList = 10003;
	static int popList = 10004;
	static int newList = 10005;
	// 人气飙升 10006 recommend_song
	// 麦霸必点 10007 recommend_song
	static int upList = 10006;
	static int mustList = 10007;
	// 人气歌手 10000 recommend_artist
	// 热门歌手 10001 recommend_artist
	static int popAList = 10000;
	static int hotAList = 10001;
	// 怀旧歌手10002
	// 抖音歌手10003
	static int nostalgiaAList = 10002;
	static int tiktokAList = 10003;
	
	// 确定每个元素的位置
	static JSONObject createBox(int i, int x, int y, int w, int h, int w2, int h2, int wt, int ht, String pic, String pic2, boolean flag){
		JSONObject param = new JSONObject();
		try{
			param.put("i", i);
			param.put("x", x);
			param.put("y", y);
			param.put("w", w);
			param.put("h", h);
			param.put("x2", Math.round((x - (w2 - w) / 2)));
			param.put("y2", Math.round((y - (h2 - h) / 2)));
			param.put("w2", w2);
			param.put("h2", h2);
			param.put("wt", wt);
			param.put("ht", ht);
			param.put("pic", pic);
			param.put("pic2", pic2);
			param.put("flag", flag);
		} catch (Exception e) {
		}
		return param;
	}
	
	// 获取字符长度
	static int getTitleTen(String value){
		int valueLength = 0;
		String chinese = "[\u4e00-\u9fa5]";
		for (int i = 0; i < value.length(); i++){
			String temp = value.substring(i, i + 1);
			if (temp.matches(chinese)) {
				valueLength += 2;
			} else {
				valueLength += 1;
			}
		}
		return valueLength;
	}
	
	// 缩放字符
	static String getTitleToTen(String str, int length){
    	String title = "";
    	try{
			byte[] bytes = str.getBytes("Unicode");
			int n = 0;
			int i = 2;
			for(; i < bytes.length && n < length; i++){
				if(i % 2 == 0){
	                n++;
				} else{
					if(bytes[i] != 0){
						n++;
					}
				}
			}
	        //将截一半的汉字要保留
			if(i % 2 == 1){
				i = i + 1;
			}
			if(bytes.length > length){
				title = new String(bytes, 0, i, "Unicode") + "...";
			} else{
				title = new String(bytes, 0, i, "Unicode");
			}
		} catch (Exception e) {
		}
		return title;
	}
%>
<%
	// 禁止GET请求直接访问
	String reqMethod = request.getMethod();
	if(reqMethod.equals("GET")){
		response.sendRedirect("correctU");
		return;
	}
	// 开启缓存
	Cache.OpenCache(application);
	// 获取公共全局参数
	// 用户ID
	String userid = StringUtils.isBlank(DoParam.Analysis("globle", "userid", request)) ? "" : DoParam.Analysis("globle", "userid", request);
	// 用户IP
	String userip = StringUtils.isBlank(DoParam.Analysis("globle", "userip", request)) ? "" : DoParam.Analysis("globle", "userip", request);
	// 用户临时token
	String userToken = StringUtils.isBlank(DoParam.Analysis("globle", "userToken", request)) ? "" : DoParam.Analysis("globle", "userToken", request);
	// 用户所属省份编号(暂时仅应用于联通地区)
	String provinceN = StringUtils.isBlank(DoParam.Analysis("globle", "provinceN", request)) ? "" : DoParam.Analysis("globle", "provinceN", request);
	// 用户所属城市编号(并非完全准确)
	String cityN = StringUtils.isBlank(DoParam.Analysis("globle", "cityN", request)) ? "" : DoParam.Analysis("globle", "cityN", request);
	// 当前是否为在线用户使用
	String isOnline = StringUtils.isBlank(DoParam.Analysis("globle", "isOnline", request)) ? "n" : DoParam.Analysis("globle", "isOnline", request);
	// 用户机顶盒编号(有需要用到的地区使用)
	String stbid = StringUtils.isBlank(DoParam.Analysis("globle", "stbid", request)) ? "" : DoParam.Analysis("globle", "stbid", request);
	// 用户当前使用机顶盒型号
	String stbType = StringUtils.isBlank(DoParam.Analysis("globle", "stbType", request)) ? "UNKNOWNSTB" : DoParam.Analysis("globle", "stbType", request);
	// 用户当前使用机顶盒版本
	String stbVersion = StringUtils.isBlank(DoParam.Analysis("globle", "stbVersion", request)) ? "UNKNOWNSTB" : DoParam.Analysis("globle", "stbVersion", request);
	// 用户偏好主题
	String preferTheme = StringUtils.isBlank(DoParam.Analysis("globle", "preferTheme", request)) ? "default" : DoParam.Analysis("globle", "preferTheme", request);
	// 用户偏好列表
	String preferList = StringUtils.isBlank(DoParam.Analysis("globle", "preferList", request)) ? "0" : DoParam.Analysis("globle", "preferList", request);
	// 用户偏好键盘
	String preferKeyboard = StringUtils.isBlank(DoParam.Analysis("globle", "preferKeyboard", request)) ? "0" : DoParam.Analysis("globle", "preferKeyboard", request);
	// 有效时间
	int hour = Integer.parseInt(StringUtils.isBlank(DoParam.Analysis("globle", "hour", request)) ? "24" : DoParam.Analysis("globle", "hour", request));
	// 列表条目上限数
	int max = Integer.parseInt(StringUtils.isBlank(DoParam.Analysis("globle", "max", request)) ? "100" : DoParam.Analysis("globle", "max", request));
	// 用户登陆的平台 1:中兴 2:华为
	int platform = Integer.parseInt(StringUtils.isBlank(DoParam.Analysis("globle", "platform", request)) ? "1" : DoParam.Analysis("globle", "platform", request));
	// 是否激活观察模式（0：未激活 1：激活 只有非tv可见）
	int observerSwitch = Integer.parseInt(StringUtils.isBlank(DoParam.Analysis("globle", "observerSwitch", request)) ? "0" : DoParam.Analysis("globle", "observerSwitch", request));
	// 哀悼日 (0：不是哀悼日 1：是哀悼日)
	int mourningDay = Integer.parseInt(StringUtils.isBlank(DoParam.Analysis("globle", "mourningDay", request)) ? "0" : DoParam.Analysis("globle", "mourningDay", request));
	// 是否支持动画 0:不支持 1:支持
	int animation = Integer.parseInt(StringUtils.isBlank(DoParam.Analysis("globle", "animation", request)) ? "0" : DoParam.Analysis("globle", "animation", request));
	// 是否支持手机遥控 0:不支持 1:支持
	int remote = Integer.parseInt(StringUtils.isBlank(DoParam.Analysis("globle", "remote", request)) ? "0" : DoParam.Analysis("globle", "remote", request));
	// 获取公共页面参数
	// 当前页面页码ID(对应ui_page_detail表)
	int pageId = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("i", request)) ? "1" : DoParam.AnalysisAbb("i", request));
	// 获取页面信息
	Map<String, Object> gpd = InfoData.getUiPageDetail(pageId);
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
			html{filter:progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-webkit-filter:grayscale(100%)}
		</style><%}%>
		<script type='text/javascript' src='javascript/jsdata.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/tools.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/extra.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/message.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript'>
			var isOnline = '<%=isOnline %>';

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
				// 浏览器测试音效
				if(typeof audio == 'object') audio.play();
				// 安卓版测试音效
				if(typeof joymusic == 'object') joymusic.tipsPlay();
				if(keyCode == 8 || keyCode == 24 || keyCode == 27 || keyCode == 32){
					if(provinceN == '201'){
						if($gg('cdowDiv')) $g('realDis').removeChild($g('cdowDiv'));
						else{
							if(pageId == 1){
								var tempF = getIdx(nowFocus, 'f_index_');
								if(tempF > 12) onkeyBack();
								else{
									if($gg('cdowDiv0')) $g('realDis').removeChild($g('cdowDiv0'));
									else{
										var cdowDiv0 = document.createElement('div');
										cdowDiv0.id = 'cdowDiv0';
										$g('realDis').appendChild(cdowDiv0);
										var cdowBj0 = document.createElement('img');
										cdowBj0.id = 'cdowBj0';
										cdowBj0.src = 'images/application/retain/201/rt/bj.png';
										cdowBj0.style.cssText = 'position:absolute;width:1280px;height:720px;left:0px;top:0px;z-index:200';
										cdowDiv0.appendChild(cdowBj0);
										var cdowBack0 = document.createElement('img');
										cdowBack0.id = 'cdowBack0';
										cdowBack0.src = 'images/application/retain/201/rt/1.png';
										cdowBack0.style.cssText = 'position:absolute;width:102px;height:57px;left:450px;top:500px;z-index:201';
										cdowDiv0.appendChild(cdowBack0);
										var cdowCont0 = document.createElement('img');
										cdowCont0.id = 'cdowCont0';
										cdowCont0.src = 'images/application/retain/201/rt/2.png';
										cdowCont0.style.cssText = 'position:absolute;width:102px;height:57px;left:730px;top:500px;z-index:201';
										cdowDiv0.appendChild(cdowCont0);
										var fcdowBack0 = document.createElement('img');
										fcdowBack0.id = 'fcdowBack0';
										fcdowBack0.src = 'images/application/retain/201/rt/focus/f_1.png';
										fcdowBack0.style.cssText = 'position:absolute;width:112px;height:69px;left:444px;top:494px;z-index:202';
										cdowDiv0.appendChild(fcdowBack0);
										var fcdowCont0 = document.createElement('img');
										fcdowCont0.id = 'fcdowCont0';
										fcdowCont0.src = 'images/application/retain/201/rt/focus/f_2.png';
										fcdowCont0.style.cssText = 'position:absolute;width:112px;height:69px;left:724px;top:494px;z-index:202;visibility:hidden';
										cdowDiv0.appendChild(fcdowCont0);
									}
								}
							} else onkeyBack();
						}
					} else onkeyBack();
				} else if(keyCode == 37){
					if(provinceN == '201'){
						if($gg('cdowDiv')){
							var fcdowBack = $g('fcdowBack').style.visibility;
							if(fcdowBack == 'hidden'){
								$g('fcdowCont').style.visibility = 'hidden';
								$g('fcdowBack').style.visibility = 'visible';
							}
						} else{
							if($gg('cdowDiv0')){
								var fcdowBack0 = $g('fcdowBack0').style.visibility;
								if(fcdowBack0 == 'hidden'){
									$g('fcdowCont0').style.visibility = 'hidden';
									$g('fcdowBack0').style.visibility = 'visible';
								}
							} else onkeyLeft();
						}
					} else onkeyLeft();
				} else if(keyCode == 38){
					if(!$gg('cdowDiv') && !$gg('cdowDiv0')) onkeyUp();
				} else if(keyCode == 39){
					if(provinceN == '201'){
						if($gg('cdowDiv')){
							var fcdowCont = $g('fcdowCont').style.visibility;
							if(fcdowCont == 'hidden'){
								$g('fcdowBack').style.visibility = 'hidden';
								$g('fcdowCont').style.visibility = 'visible';
							}
						} else{
							if($gg('cdowDiv0')){
								var fcdowCont0 = $g('fcdowCont0').style.visibility;
								if(fcdowCont0 == 'hidden'){
									$g('fcdowBack0').style.visibility = 'hidden';
									$g('fcdowCont0').style.visibility = 'visible';
								}
							} else onkeyRight();
						}
					} else onkeyRight();
				} else if(keyCode == 40){
					if(!$gg('cdowDiv') && !$gg('cdowDiv0')) onkeyDown();
				} else if(keyCode == 13){
					if(provinceN == '201'){
						if($gg('cdowDiv')){
							var fcdowCont = $g('fcdowCont').style.visibility;
							if(fcdowCont == 'hidden') exitApp();
							else $g('realDis').removeChild($g('cdowDiv'));
						} else{
							if($gg('cdowDiv0')){
								var fcdowCont0 = $g('fcdowCont0').style.visibility;
								if(fcdowCont0 == 'hidden') exitApp();
								else $g('realDis').removeChild($g('cdowDiv0'));
							} else onkeyOK();
						}
					} else onkeyOK();
				} else if(keyCode > 47 && keyCode < 58){
					if(provinceN == '201'){
						if(!$gg('cdowDiv') && !$gg('cdowDiv0')){
							var countdown = 5;
							// 天津联通需要在按数字键的时候直接触发退出
							var cdowDiv = document.createElement('div');
							cdowDiv.id = 'cdowDiv';
							$g('realDis').appendChild(cdowDiv);
							var cdowBj = document.createElement('img');
							cdowBj.id = 'cdowBj';
							cdowBj.src = 'images/application/retain/201/bj.png';
							cdowBj.style.cssText = 'position:absolute;width:800px;height:434px;left:240px;top:143px;z-index:100';
							cdowDiv.appendChild(cdowBj);
							var cdowBack = document.createElement('img');
							cdowBack.id = 'cdowBack';
							cdowBack.src = 'images/application/retain/201/1.png';
							cdowBack.style.cssText = 'position:absolute;width:160px;height:55px;left:380px;top:484px;z-index:101';
							cdowDiv.appendChild(cdowBack);
							var cdowCont = document.createElement('img');
							cdowCont.id = 'cdowCont';
							cdowCont.src = 'images/application/retain/201/2.png';
							cdowCont.style.cssText = 'position:absolute;width:160px;height:55px;left:730px;top:484px;z-index:101';
							cdowDiv.appendChild(cdowCont);
							var fcdowBack = document.createElement('img');
							fcdowBack.id = 'fcdowBack';
							fcdowBack.src = 'images/application/retain/201/focus/f_1.png';
							fcdowBack.style.cssText = 'position:absolute;width:189px;height:85px;left:360px;top:470px;z-index:102';
							cdowDiv.appendChild(fcdowBack);
							var fcdowCont = document.createElement('img');
							fcdowCont.id = 'fcdowCont';
							fcdowCont.src = 'images/application/retain/201/focus/f_2.png';
							fcdowCont.style.cssText = 'position:absolute;width:189px;height:85px;left:710px;top:470px;z-index:102;visibility:hidden';
							cdowDiv.appendChild(fcdowCont);
							var cdowNum = document.createElement('div');
							cdowNum.id = 'cdowNum';
							cdowNum.style.cssText = 'position:absolute;width:80px;height:80px;left:921px;top:185px;font-size:60px;color:#FFFFFF;text-align:center;z-index:101';
							cdowNum.innerText = countdown;
							cdowDiv.appendChild(cdowNum);
							var countdownTimer = setInterval(function(){
								if(!$gg('cdowDiv')) clearInterval(countdownTimer);
								else{
									countdown--;
									cdowNum.innerText = countdown;
									if(countdown < 1){
										clearInterval(countdownTimer);
										exitApp();
									}
								}
							}, 1000);
						}
					}
				} else{
					var isFunction = false;
					try{
						isFunction = typeof(eval(onKeyOther(keyCode))) == 'function';
					} catch(e){}
					if(isFunction){
						eval(onKeyOther(keyCode));
					}
				}
			}

			if(isOnline == 'n'){
				var audio = document.createElement('audio');
				audio.src = 'sound/key.mp3';
			}
		</script>