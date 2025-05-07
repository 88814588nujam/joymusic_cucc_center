<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%@include file="handle/adminUser.jsp" %>
<%@include file="handle/payApply.jsp" %>
<%
	org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger("mydebug");
	
	// 获取私有页面参数
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));

	int pageSize = 9;
	if(ajaxData == 1){ // 鉴权回调接口
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		String tmpToken = StringUtils.isBlank(DoParam.AnalysisAbb("t", request)) ? "" : DoParam.AnalysisAbb("t", request);
		String tmpPrinvce = StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "" : DoParam.AnalysisAbb("p", request);
		String tmpIsOrder = authResult(tmpUid, tmpToken, tmpPrinvce);
		String retStr = "{'token':'" + tmpToken + "', 'provinceN':'" + tmpPrinvce + "', 'isOrder':'" + tmpIsOrder + "'}";
		out.print(retStr);
		return;
	} else if(ajaxData == 2){ // 删除已点歌曲列表歌曲回调接口
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		String tmpSid = StringUtils.isBlank(DoParam.AnalysisAbb("s", request)) ? "" : DoParam.AnalysisAbb("s", request);
		int tmpHour = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("h", request)) ? "24" : DoParam.AnalysisAbb("h", request));
		int tmpMax = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("m", request)) ? "100" : DoParam.AnalysisAbb("m", request));
		int row = InfoData.delToChecked(tmpUid, tmpSid, tmpHour);
		List<Map<String, Object>> gauc = InfoData.getAllUserChecked(tmpUid, tmpHour, tmpMax);
		Page pages = new Page(gauc.size(), pageSize);
		String json = "";
		if(gauc.size() > 0){
			for(int i = 0;i < gauc.size();i++){
				Object artistPicObj = gauc.get(i).get("artist_pic");
				String artistPic = artistPicObj == null ? "default.png" : (StringUtils.isBlank(artistPicObj.toString()) ? "default.png" : artistPicObj.toString());
				json += "{'songId':'" + gauc.get(i).get("id") + "', 'songName':'" + gauc.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'singer':'" + gauc.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'pic':'images/commonly/artist/c_" + artistPic + "', 'cres':'" + gauc.get(i).get("cres") + "', 'songStatus':'" + gauc.get(i).get("songStatus") + "', 'cfree':'" + gauc.get(i).get("cfree") + "'}";
				if(i < gauc.size() - 1){
					json += ",";
				}
			}
		}
		json = "[" + json + "]";
		if(gauc.size() > 0) out.print("{'opera':'collect', 'result':'" + row + "', 'pageTotals':" + pages.getPageTotal() + ", 'playList':" + json + "}");
		else out.print("{'opera':'delPlayerChecked', 'result':'" + row + "', 'pageTotals':0, 'playList':" + json + "}");
		return;
	} else if(ajaxData == 3){ // 增加已点歌曲列表歌曲回调接口
		String tmpUid = StringUtils.isBlank(DoParam.AnalysisAbb("u", request)) ? "" : DoParam.AnalysisAbb("u", request);
		String tmpSid = StringUtils.isBlank(DoParam.AnalysisAbb("s", request)) ? "" : DoParam.AnalysisAbb("s", request);
		int tmpHour = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("h", request)) ? "24" : DoParam.AnalysisAbb("h", request));
		int tmpMax = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("m", request)) ? "100" : DoParam.AnalysisAbb("m", request));
		int row = InfoData.addToChecked(tmpUid, tmpSid, tmpHour);
		List<Map<String, Object>> gauc = InfoData.getAllUserChecked(tmpUid, tmpHour, tmpMax);
		Page pages = new Page(gauc.size(), pageSize);
		String json = "";
		if(gauc.size() > 0){
			for(int i = 0;i < gauc.size();i++){
				Object artistPicObj = gauc.get(i).get("artist_pic");
				String artistPic = artistPicObj == null ? "default.png" : (StringUtils.isBlank(artistPicObj.toString()) ? "default.png" : artistPicObj.toString());
				json += "{'songId':'" + gauc.get(i).get("id") + "', 'songName':'" + gauc.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'singer':'" + gauc.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'pic':'images/commonly/artist/c_" + artistPic + "', 'cres':'" + gauc.get(i).get("cres") + "', 'songStatus':'" + gauc.get(i).get("songStatus") + "', 'cfree':'" + gauc.get(i).get("cfree") + "'}";
				if(i < gauc.size() - 1){
					json += ",";
				}
			}
		}
		json = "[" + json + "]";
		if(gauc.size() > 0) out.print("{'opera':'collect', 'result':'" + row + "', 'pageTotals':" + pages.getPageTotal() + ", 'playList':" + json + "}");
		else out.print("{'opera':'delPlayerChecked', 'result':'" + row + "', 'pageTotals':0, 'playList':" + json + "}");
		return;
	}
%><%@include file="common/head.jsp" %>
<%
	// 用户是否订购  y:异常  0:是 http:否
	String isOrder = StringUtils.isBlank(DoParam.Analysis("globle", "isOrder", request)) ? "y" : DoParam.Analysis("globle", "isOrder", request);
	String bindUer = "false";
	String payN = "0";
	// 没订购过筛选是否进入策略
	if(isOrder.equals("y")){
		String payApply = getApplyPercent(provinceN, cityN, userid);
		JSONObject jsonStr = new JSONObject(payApply);
		bindUer = jsonStr.get("bindUer").toString();
		payN = jsonStr.get("payN").toString();
	}
	// 读取用户已选列表
	List<Map<String, Object>> gauc = InfoData.getAllUserChecked(userid, hour, max);
	// 接收第一首歌收费曲目判断标准
	String cfree = ""; // cfree是否免费  0:免费  1:收费
	String sid = "";
	String json = "";
	if(gauc.size() > 0){
		cfree = gauc.get(0).get("cfree").toString();
		sid = gauc.get(0).get("id").toString();
		for(int i = 0; i < gauc.size(); i++){
			Object artistPicObj = gauc.get(i).get("artist_pic");
			String artistPic = artistPicObj == null ? "default.png" : (StringUtils.isBlank(artistPicObj.toString()) ? "default.png" : artistPicObj.toString());
			json += "{'songId':'" + gauc.get(i).get("id") + "', 'songName':'" + gauc.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'singer':'" + gauc.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'pic':'images/commonly/artist/c_" + artistPic + "', 'cres':'" + gauc.get(i).get("cres") + "', 'songStatus':'" + gauc.get(i).get("songStatus") + "', 'cfree':'" + gauc.get(i).get("cfree") + "'}";
			if(i < gauc.size() - 1){
				json += ",";
			}
		}
	}
	json = "[" + json + "]";
	Page pages = new Page(gauc.size(), pageSize);
	// 收藏歌曲队列idsStr
	String collectStr = InfoData.getCollectStr(userid, 1);
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
			// 当前页码ID
			var pageId = <%=pageId %>;
			// 控制是否执行start函数
			var ctlStart = false;
			// 播放唯一id
			var playId = '';
			// 允许按键
			var allowClick = false;
			// ----------------------------------------------------------------------------------------------------------------- player参数
			var bindUer = <%=bindUer %>;
			// 获取当前的鉴权结果
			var isOrder = '<%=isOrder %>';
			// 收藏歌曲队列idsStr
			var collectStr = '<%=collectStr %>';
			// 播放器内置列表页码
			var pageIndex = 1;
			var pageSize = <%=pageSize %>;
			var pageTotals = <%=pages.getPageTotal() %>;
			// 已选播放列表
			var playList = <%=json %>;
			// 播放器提示
			var words = ['下一曲：', '单曲循环中··· ···', '随机循环中··· ···', '下一曲即将恢复列表循环播放模式', '下一曲即将开始单曲循环播放模式', '下一曲即将进入随机循环播放模式'];
			// 进入播放前的页面
			var toPageId = -1;
			// 进入播放前的页面参数
			var key = '';
			// 开始记录的标志
			var startLog = false;
			// 心跳刷新歌曲播放时长
			var refreshLog;
			// 判断是bs的还是cs的
			var productType = 'bs';
			// 播放器进入后永久成为next
			var plyFlg = false;
			// 接收单点鉴权的播放码
			var connectId = '';

			function start(){
				if(typeof joymusic == 'object') productType = 'cs';
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				// bindUer:true → apply
				if(bindUer) startApply();
				else realStart();
			}
			
			function realStart(){
				// 将顶部鉴权标记刷新
				put('globle', 'isOrder', isOrder + ''); // 用户是否订购   0:是
				// 是否允许websocket
				var remote = getVal('globle', 'remote');
				if(remote == 0) init();
			}

			function onWebsocketOpen(){
				// 如果连接了websocket,初次载入需要拦截
				init();
			}

			function onWebsocketError(){
				// 如果连接websocket失败,也得继续放歌
				init();
			}

			function init(){
				var returnPage = getVal('globle', 'return');
				if(returnPage){
					var jsonR = eval('(' + returnPage + ')');
					toPageId = jsonR[jsonR.length - 1].back[0].target;
					var params = jsonR[jsonR.length - 1].back[1].params;
					if(params.indexOf('k=') > -1){
						params = params.substr(params.indexOf('k=') + ('k='.length));
						if(params.indexOf('&') > -1) key = params.substr(0, params.indexOf('&'));
						else key = params;
					}
				}
				// 赋值真正的当前播放曲目下标
				nowRealPlay = Number(getVal('globle', 'nowRealPlay'));
				// 执行播放
				getWebUrlResult();
			}

			function goAuthOrder(){
				put('globle', 'nowRealPlay', nowRealPlay + '');
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&u=' + userid + '&t=' + userToken + '&p=' + provinceN + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, getAuthBack);
			}

			function getAuthBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						var jsonOrder = contentJson.isOrder;
						if(jsonOrder == '0'){ // 订购过包月,直接播放
							isOrder = '0';
							put('globle', 'isOrder', isOrder + ''); // 用户是否订购 0:是
							getWebUrlResult();
						} else{
							destoryMP();
							var songId = playList[nowRealPlay].songId;
							var toUrl = 'pay.jsp?o=0&u=' + userid + '&i=' + userip + '&s=' + songId + '&p=' + toPageId + '&k=' + key + '&c=' + cityN + '&a=' + provinceN + '&t=' + userToken + '&st=' + stbType + '&f=' + platform;
							setTimeout(function(){go(toUrl);}, 500);
							return;
						}
					}
				}
			}

			// 退出播放器
			function exitPlayer(){
				endPlayLog(1, playCurTime, function(){
					// 通知小程序用户
					var remote = getVal('globle', 'remote');
					if(remote > 0){
						if(typeof websocket == 'object'){
							// 记得给小程序同步消息
							WXSendMsg('qtpl,0');
						}
					}
					destoryMP();
					setTimeout('__return()', 500);
				});
			}

			// 开始记录播放记录
	        function startPlayLog(sid){
				var playDoc = 'h3?o=0&u=' + userid + '&i=' + userip + '&c=' + cityN + '&s=' + sid + '&l=' + playDuration + '&p=' + toPageId + '&k=' + key;
	            ajaxRequest('POST', playDoc, function(){
	            	if(xmlhttp.readyState == 4){
						if(xmlhttp.status == 200){
							var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
							var contentJson = eval('(' + retText + ')');
							playId = contentJson.playId;
							if(refreshLog > -1){
								clearInterval(refreshLog); 
								refreshLog = -1;
							}
							refreshLog = setInterval(function(){
								endPlayLog(2, playCurTime, null);
							}, 5000);
						}
					}
	            });
	        }

			// 结束记录播放记录
	        function endPlayLog(opr, cur, fun){
	        	if(opr == 1){
					if(refreshLog > -1){
						clearInterval(refreshLog); 
						refreshLog = -1;
					}
				}
				var playDoc = 'h3?o=' + opr + '&u=' + userid + '&h=' + cur + '&y=' + playId;
	            ajaxRequest('POST', playDoc, function(){
	            	if(xmlhttp.readyState == 4){
						if(xmlhttp.status == 200){
							var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
							var contentJson = eval('(' + retText + ')');
							if(opr == 1){
								// 记得清理定时器
								if(delayTimesAuto > -1){
									clearInterval(delayTimesAuto); 
									delayTimesAuto = -1;
								}
								startLog = false;
							}
							if(fun) eval(fun(contentJson));
						}
					}
	            });
	        }

			function loadSong(f){
				// f:true 点击list按钮第一次载入要初始化
				if(f){
					isEnd = 0;
					flagEnd = false;
					nowMenu = 2;
					pageIndex = 1;
					lfocus = 'p1';
					$g('f_' + lfocus).style.visibility = 'visible';
					$g('f1').style.visibility = 'visible';
					$g('begin').style.display = 'none';
					$g('list').style.display = 'block';
					if(delayTimes > -1){
						clearTimeout(delayTimes); 
						delayTimes = -1;
					}
					if(delayTimesList > -1){
						clearTimeout(delayTimesList); 
						delayTimesList = -1;
					}
					delayTimesList = setTimeout(function(){
						$g('list').style.display = 'none';
						$g('f_' + lfocus).style.visibility = 'hidden';
						nowMenu = 0;
					}, 10000);
				}
				var staIdx = (pageIndex - 1) * pageSize;
				var y = 0;
				for(var i = 1; i < 10; i++){
					y = (i - 1) * 56 + 120;
					var tmpIdx = staIdx + i;
					if(tmpIdx <= playList.length){
						var len = getBytesLength(playList[tmpIdx - 1].songName);
						if(len > 14){
							var newy = y + 3;
							$g('s' + i).style.top = newy + 'px';
							$g('s' + i).style.fontSize = '18px';
							if(len > 18){
								$g('s' + i).innerHTML = '<marquee behavior=\'alternate\' scrollamount=\'1\'>' + playList[tmpIdx - 1].songName + '</marquee>';
							} else{
								$g('s' + i).innerHTML = playList[tmpIdx - 1].songName;
							}
						} else{
							$g('s' + i).innerHTML = playList[tmpIdx - 1].songName;
						}
						$g('a' + i).innerHTML = playList[tmpIdx - 1].singer;
						$g('p' + i).style.visibility = 'visible';
						$g('d' + i).style.visibility = 'visible';
					} else{
						$g('s' + i).style.top = y + 'px';
						$g('s' + i).style.fontSize = '24px';
						$g('s' + i).innerHTML = '';
						$g('a' + i).innerHTML = '';
						$g('p' + i).style.visibility = 'hidden';
						$g('d' + i).style.visibility = 'hidden';
					}
				}
				$g('resultSrh').innerHTML = '已点歌曲（<font color=\'#EC6878\'>' + playList.length + '</font>）首';
				$g('pageInfo').innerHTML = pageIndex + '/' + pageTotals;
			}

			function directOnList(dir){
				if(delayTimesList > -1){
					clearTimeout(delayTimesList); 
					delayTimesList = -1;
				}
				delayTimesList = setTimeout(function(){
					$g('list').style.display = 'none';
					$g('f_' + lfocus).style.visibility = 'hidden';
					if(lfocus.indexOf('p') > -1 || lfocus.indexOf('d') > -1){
						var idx = lfocus.replace('p', '').replace('d', '');
						$g('f' + idx).style.visibility = 'hidden';
					}
					nowMenu = 0;
				}, 10000);
				var nowPages = pageSize;
				for(var i = 1; i < 10; i++){
					var innerStr = $g('s' + i).innerHTML;
					if(innerStr == ''){
						nowPages = i - 1;
						break;
					}
				}
				if(dir == 'ok'){
					if(lfocus.indexOf('p') > -1){
						var tempF = Number(lfocus.substr(1, lfocus.length - 1));
						var nowIdx = (pageIndex - 1) * pageSize + tempF - 1;
						var nowSid = playList[nowIdx].songId;
						if(mode == 3){
							for(var i = 0; i < randPlayList.length; i++){
								if(nowSid == randPlayList[i].songId){
									nowRealPlay = i;
									break;
								}
							}
							endPlayLog(1, playCurTime, function(){
								try{
									getWebUrlResult();
								} catch(e){}
							});
						} else{
							nowRealPlay = nowIdx;
							endPlayLog(1, playCurTime, function(){
								try{
									getWebUrlResult();
								} catch(e){}
							});
						}
					} else if(lfocus.indexOf('d') > -1){
						allowClick = false;
						var tempF = Number(lfocus.substr(1, lfocus.length - 1));
						var nowIdx = (pageIndex - 1) * pageSize + tempF - 1;
						var sid = playList[nowIdx].songId;
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=2&u=' + userid + '&s=' + sid + '&h=' + hour + '&m=' + max + '\'}]';
						var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
						ajaxRequest('POST', reqUrl, deleteSong_getdocBack);
					} else{
						if(lfocus == 'l'){
							if(pageIndex > 1){
								pageIndex--;
								loadSong(false);
							}
						} else if(lfocus == 'n'){
							if(pageIndex < pageTotals){
								pageIndex++;
								loadSong(false);
							}
						}
					}
				} else{
					$g('f_' + lfocus).style.visibility = 'hidden';
					if(dir == 'l'){
						if(lfocus.indexOf('d') > -1){
							var tempF = Number(lfocus.substr(1, lfocus.length - 1));
							lfocus = 'p' + tempF;
						} else{
							if(lfocus == 'n') lfocus = 'l';
						}
					} else if(dir == 'u'){
						if(lfocus.indexOf('p') > -1){
							var tempF = Number(lfocus.substr(1, lfocus.length - 1));
							if($gg('f' + tempF) && tempF > 1) $g('f' + tempF).style.visibility = 'hidden';
							if(tempF > 1) lfocus = 'p' + Number(tempF - 1);
							if($gg('f' + Number(tempF - 1))) $g('f' + Number(tempF - 1)).style.visibility = 'visible';
						} else if(lfocus.indexOf('d') > -1){
							var tempF = Number(lfocus.substr(1, lfocus.length - 1));
							if($gg('f' + tempF) && tempF > 1) $g('f' + tempF).style.visibility = 'hidden';
							if(tempF > 1) lfocus = 'd' + Number(tempF - 1);
							if($gg('f' + Number(tempF - 1))) $g('f' + Number(tempF - 1)).style.visibility = 'visible';
						} else{
							if(lfocus == 'l') lfocus = 'p' + nowPages;
							else if(lfocus == 'n') lfocus = 'd' + nowPages;
							if($gg('f' + nowPages)) $g('f' + nowPages).style.visibility = 'visible';
						}
					} else if(dir == 'r'){
						if(lfocus.indexOf('p') > -1){
							var tempF = Number(lfocus.substr(1, lfocus.length - 1));
							lfocus = 'd' + tempF;
						} else{
							if(lfocus == 'l') lfocus = 'n';
						}
					} else if(dir == 'd'){
						if(lfocus.indexOf('p') > -1){
							var tempF = Number(lfocus.substr(1, lfocus.length - 1));
							if($gg('f' + tempF)) $g('f' + tempF).style.visibility = 'hidden';
							if(tempF < nowPages) lfocus = 'p' + Number(tempF + 1);
							else lfocus = 'l';
							if($gg('f' + Number(tempF + 1)) && tempF < nowPages) $g('f' + Number(tempF + 1)).style.visibility = 'visible';
						} else if(lfocus.indexOf('d') > -1){
							var tempF = Number(lfocus.substr(1, lfocus.length - 1));
							if($gg('f' + tempF)) $g('f' + tempF).style.visibility = 'hidden';
							if(tempF < nowPages) lfocus = 'd' + Number(tempF + 1);
							else lfocus = 'n';
							if($gg('f' + Number(tempF + 1)) && tempF < nowPages) $g('f' + Number(tempF + 1)).style.visibility = 'visible';
						}
					}
					if($gg('f' + lfocus)) $g('f' + lfocus).style.visibility = 'visible';
					$g('f_' + lfocus).style.visibility = 'visible';
				}
			}

			function deleteSong_getdocBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$g)/g, '');
						var contentJson = eval('(' + retText + ')');
						var result = contentJson.result;
						if(result > 0){
							var tempPageTotals = contentJson.pageTotals;
							if(tempPageTotals == 0){
								if(delayTimesList > -1){
									clearTimeout(delayTimesList); 
									delayTimesList = -1;
								}
								$g('list').style.display = 'none';
								$g('f_' + lfocus).style.visibility = 'hidden';
								playList = new Array();
								nowMenu = 0;
							} else{
								playList = contentJson.playList;
								if(tempPageTotals < pageTotals){
									pageTotals = tempPageTotals;
									if(tempPageTotals < pageIndex){
										pageIndex--;
										var tmpIdx = lfocus.substring(1, 2);
										$g('f' + tmpIdx).style.visibility = 'hidden';
										$g('f_' + lfocus).style.visibility = 'hidden';
										lfocus = 'd9';
										tmpIdx = lfocus.substring(1, 2);
										$g('f' + tmpIdx).style.visibility = 'visible';
										$g('f_' + lfocus).style.visibility = 'visible';
									}
									loadSong(false);
								} else{
									loadSong(false);
									var nowPages = pageSize;
									for(var i = 1; i < 10; i++){
										var innerStr = $g('s' + i).innerHTML;
										if(innerStr == ''){
											nowPages = i - 1;
											break;
										}
									}
									var tempF = Number(lfocus.substr(1, lfocus.length - 1));
									if(tempF > nowPages){
										var tmpIdx = lfocus.substring(1, 2);
										$g('f' + tmpIdx).style.visibility = 'hidden';
										$g('f_' + lfocus).style.visibility = 'hidden';
										lfocus = 'd' + nowPages;
										tmpIdx = lfocus.substring(1, 2);
										$g('f' + tmpIdx).style.visibility = 'visible';
										$g('f_' + lfocus).style.visibility = 'visible';
									}
								}
							}
							WXSendMsg('dele,1');
							allowClick = true;
						}
					}
				}
			}

			function onkeyOK(){
				if(allowClick) moveDir('ok');
			}

			function onkeyLeft(){
				if(allowClick) moveDir('l');
			}

			function onkeyRight(){
				if(allowClick) moveDir('r');
			}

			function onkeyUp(){
				if(allowClick){
					if(nowMenu < 2) volUp();
					else directOnList('u');
				}
			}

			function onkeyDown(){
				if(allowClick){
					if(nowMenu < 2) volDown();
					else directOnList('d');
				}
			}

			function onkeyBack(){
				if(allowClick){
					if(nowMenu < 2){
						if(flagEnd){
							if(delayTimes > -1){
								clearTimeout(delayTimes);
								delayTimes = -1;
							}
							$g('begin').style.display = 'none';
							isEnd = 0;
							flagEnd = false;
							nowMenu = 0;
						} else{
							put('globle', 'nowRealPlay', '0'); // 退出去之前将播放下标舒适化,防止下次进来还是播放的上次的位置
							$g('begin').style.display = 'none';
							$g('status').style.display = 'none';
							isEnd = 0;
							exitPlayer();
						}
					} else{
						if(delayTimesList > -1){
							clearTimeout(delayTimesList);
							delayTimesList = -1;
						}
						$g('list').style.display = 'none';
						$g('f_' + lfocus).style.visibility = 'hidden';
						if(lfocus.indexOf('p') > -1 || lfocus.indexOf('d') > -1){
							var idx = lfocus.replace('p', '').replace('d', '');
							$g('f' + idx).style.visibility = 'hidden';
						}
						nowMenu = 0;
					}
				}
			}

			function onKeyOther(key){
				if(allowClick){
					if(key == 0x0300){
						if(goUtility() == 0) setTimeout('changeSong()', 500);
					} else{
						if(keyCode == 0x0103 || keyCode == 43) volUp();
						else if(keyCode == 0x0104 || keyCode == 45) volDown();
						else if(keyCode == 0x0105 || keyCode == 46) volMute();
						else if(keyCode == 0x0107 || keyCode == 42 || keyCode == 51) pauseOrPlay();
						else if(keyCode == 0x0108) fastForward();
						else if(keyCode == 0x0109) fastRewind();
						else if(keyCode == 0x010E) pause();
						else if(keyCode == 34 || keyCode == 93) changeSong();
					}
				}
			}

			// 键盘方向控制
			function moveDir(dir){
				if(dir == 'l' || dir == 'r' || dir == 'ok'){ // 功能键触发
					if(nowMenu < 2){
						nowMenu = 1;
						$g('begin').style.display = 'block';
						if(flagEnd){
							isEnd = 1;
						}
						flagEnd = true;
						if(delayTimes > -1){
							clearTimeout(delayTimes); 
							delayTimes = -1;
						}
						delayTimes = setTimeout(function(){
							$g('begin').style.display = 'none';
							isEnd = 0;
							flagEnd = false;
							nowMenu = 0;
						}, 10000);
					}
				}
				if(nowMenu == 1){
					if(isEnd == 1){
						if(dir == 'l'){
							if(vfocus == 'ele1'){
								$g('ele1').style.visibility = 'hidden';
								$g('ele1_b').style.visibility = 'visible';
								$g('ele9').style.visibility = 'visible';
								vfocus = 'ele9';
							} else if(vfocus == 'ele2'){
								$g('ele2').style.visibility = 'hidden';
								$g('ele2_b').style.visibility = 'visible';
								$g('ele1').style.visibility = 'visible';
								vfocus = 'ele1';
							} else if(vfocus == 'ele3'){
								$g('ele3').style.visibility = 'hidden';
								$g('ele3_b').style.visibility = 'visible';
								$g('ele2').style.visibility = 'visible';
								vfocus = 'ele2';
							} else if(vfocus == 'ele4'){
								$g('ele4').style.visibility = 'hidden';
								$g('ele4_b').style.visibility = 'visible';
								$g('ele3').style.visibility = 'visible';
								vfocus = 'ele3';
							} else if(vfocus == 'ele5'){
								$g('ele5').style.visibility = 'hidden';
								$g('ele5_b').style.visibility = 'visible';
								$g('ele4').style.visibility = 'visible';
								vfocus = 'ele4';
							} else if(vfocus == 'ele6'){
								$g('ele6').style.visibility = 'hidden';
								$g('ele6_b').style.visibility = 'visible';
								$g('ele5').style.visibility = 'visible';
								vfocus = 'ele5';
							} else if(vfocus == 'ele7'){
								$g('ele7').style.visibility = 'hidden';
								$g('ele7_b').style.visibility = 'visible';
								$g('ele6').style.visibility = 'visible';
								vfocus = 'ele6';
							} else if(vfocus == 'ele8'){
								$g('ele8').style.visibility = 'hidden';
								$g('ele8_b').style.visibility = 'visible';
								$g('ele7').style.visibility = 'visible';
								vfocus = 'ele7';
							} else if(vfocus == 'ele9'){
								$g('ele9').style.visibility = 'hidden';
								$g('ele9_b').style.visibility = 'visible';
								$g('ele8').style.visibility = 'visible';
								vfocus = 'ele8';
							}
						} else if(dir == 'r'){
							if(vfocus == 'ele1'){
								$g('ele1').style.visibility = 'hidden';
								$g('ele1_b').style.visibility = 'visible';
								$g('ele2').style.visibility = 'visible';
								vfocus = 'ele2';
							} else if(vfocus == 'ele2'){
								$g('ele2').style.visibility = 'hidden';
								$g('ele2_b').style.visibility = 'visible';
								$g('ele3').style.visibility = 'visible';
								vfocus = 'ele3';
							} else if(vfocus == 'ele3'){
								$g('ele3').style.visibility = 'hidden';
								$g('ele3_b').style.visibility = 'visible';
								$g('ele4').style.visibility = 'visible';
								vfocus = 'ele4';
							} else if(vfocus == 'ele4'){
								$g('ele4').style.visibility = 'hidden';
								$g('ele4_b').style.visibility = 'visible';
								$g('ele5').style.visibility = 'visible';
								vfocus = 'ele5';
							} else if(vfocus == 'ele5'){
								$g('ele5').style.visibility = 'hidden';
								$g('ele5_b').style.visibility = 'visible';
								$g('ele6').style.visibility = 'visible';
								vfocus = 'ele6';
							} else if(vfocus == 'ele6'){
								$g('ele6').style.visibility = 'hidden';
								$g('ele6_b').style.visibility = 'visible';
								$g('ele7').style.visibility = 'visible';
								vfocus = 'ele7';
							} else if(vfocus == 'ele7'){
								$g('ele7').style.visibility = 'hidden';
								$g('ele7_b').style.visibility = 'visible';
								$g('ele8').style.visibility = 'visible';
								vfocus = 'ele8';
							} else if(vfocus == 'ele8'){
								$g('ele8').style.visibility = 'hidden';
								$g('ele8_b').style.visibility = 'visible';
								$g('ele9').style.visibility = 'visible';
								vfocus = 'ele9';
							} else if(vfocus == 'ele9'){
								$g('ele9').style.visibility = 'hidden';
								$g('ele9_b').style.visibility = 'visible';
								$g('ele1').style.visibility = 'visible';
								vfocus = 'ele1';
							}
						} else doclick();
					}
				} else if(nowMenu == 2) directOnList(dir);
			}

			// 确认后执行的事情
			function doclick(){
				if(vfocus == 'ele1') fastRewind();
				else if(vfocus == 'ele2') pauseOrPlay();
				else if(vfocus == 'ele3') fastForward();
				else if(vfocus == 'ele4') collectSong();
				else if(vfocus == 'ele5') changeChannel();
				else if(vfocus == 'ele6') replay();
				else if(vfocus == 'ele7') changeSong();
				else if(vfocus == 'ele8') changeMode();
				else if(vfocus == 'ele9'){
					if(playList.length > 0) loadSong(true);
				}
				return false;
			}
		</script>
	</head>

	<body onload='start()' onunload='destoryMP()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 -->
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<img id='wait' src="images/application/player/theme/classic/ui_huge/wait.png" style="position:absolute;left:0px;top:0px;width:1280px;height:198px;z-index:10;visibility:hidden">
			<div id='BigDiv' style='position:absolute;width:<%=pageW %>px;height:<%=pageH  %>px;left:0px;top:0px'><%if(!isOnline.equals("y")){%>
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:0px' />
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1280px;height:1px;left:0px;top:719px' />
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1px;height:720px;left:0px;top:0px' />
				<img src='images/application/pages/index/commonly/line.png' style='position:absolute;width:1px;height:720px;left:1279px;top:0px' /><%}%>
				<!-- 机顶盒播放 -->
				<div id='begin' style='display:none'>
					<img src='images/application/player/theme/classic/ui_huge/bar.png' style='position:absolute;width:1280px;height:151px;left:0px;top:569px;z-index:2' />
					<img id='cpic' src='images/commonly/artist/c_default.png' onerror='this.src=images/commonly/artist/c_default.png' style='position:absolute;width:84px;height:84px;left:28px;top:623px;z-index:3' />
					<div id='np' style='position:absolute;width:370px;height:20px;left:138px;top:638px;color:#FFFFFF;font-size:26px;z-index:3'></div>
					<div id='npa' style='position:absolute;width:370px;height:20px;left:138px;top:672px;color:#B2AFAA;font-size:16px;z-index:3'></div>
					<div id='ns' style='position:absolute;width:550px;height:20px;left:365px;top:575px;color:#B2AFAA;font-size:18px;text-align:center;z-index:3'></div>
					<div id='rt' style='position:absolute;width:370px;height:20px;left:15px;top:575px;color:#B2AFAA;font-size:18px;z-index:3'></div>
					<img id='pbar' src='images/application/player/theme/classic/ui_huge/pro.png' style='position:absolute;width:0px;height:8px;left:0px;top:603px;z-index:3' />
					<img id='ele1_b' src='images/application/player/theme/classic/ui_huge/previous.png' style='position:absolute;width:62px;height:53px;left:530px;top:640px;z-index:3' />
					<img id='ele2_b' src='images/application/player/theme/classic/ui_huge/pause.png' style='position:absolute;width:66px;height:70px;left:607px;top:630px;z-index:3' />
					<img id='ele3_b' src='images/application/player/theme/classic/ui_huge/next.png' style='position:absolute;width:62px;height:53px;left:687px;top:640px;z-index:3' />
					<img id='ele4_b' src='images/application/player/theme/classic/ui_huge/collect.png' style='position:absolute;width:86px;height:73px;left:900px;top:640px;z-index:3' />
					<img id='ele5_b' src='images/application/player/theme/classic/ui_huge/channel0.png' style='position:absolute;width:86px;height:73px;left:960px;top:640px;z-index:3' />
					<img id='ele6_b' src='images/application/player/theme/classic/ui_huge/replay.png' style='position:absolute;width:86px;height:73px;left:1020px;top:640px;z-index:3' />
					<img id='ele7_b' src='images/application/player/theme/classic/ui_huge/change.png' style='position:absolute;width:86px;height:73px;left:1080px;top:640px;z-index:3' />
					<img id='ele8_b' src='images/application/player/theme/classic/ui_huge/mode1.png' style='position:absolute;width:86px;height:73px;left:1140px;top:640px;z-index:3' />
					<img id='ele9_b' src='images/application/player/theme/classic/ui_huge/list.png' style='position:absolute;width:86px;height:73px;left:1200px;top:640px;z-index:3' />
					<img id='ele1' src='images/application/player/theme/classic/ui_huge/focus/f_previous.png' style='position:absolute;width:62px;height:53px;left:530px;top:640px;z-index:4;visibility:hidden' />
					<img id='ele2' src='images/application/player/theme/classic/ui_huge/focus/f_pause.png' style='position:absolute;width:66px;height:70px;left:607px;top:630px;z-index:4;visibility:visible' />
					<img id='ele3' src='images/application/player/theme/classic/ui_huge/focus/f_next.png' style='position:absolute;width:62px;height:53px;left:687px;top:640px;z-index:4;visibility:hidden' />
					<img id='ele4' src='images/application/player/theme/classic/ui_huge/focus/f_collect.png' style='position:absolute;width:86px;height:73px;left:900px;top:640px;z-index:4;visibility:hidden' />
					<img id='ele5' src='images/application/player/theme/classic/ui_huge/focus/f_channel0.png' style='position:absolute;width:86px;height:73px;left:960px;top:640px;z-index:4;visibility:hidden' />
					<img id='ele6' src='images/application/player/theme/classic/ui_huge/focus/f_replay.png' style='position:absolute;width:86px;height:73px;left:1020px;top:640px;z-index:4;visibility:hidden' />
					<img id='ele7' src='images/application/player/theme/classic/ui_huge/focus/f_change.png' style='position:absolute;width:86px;height:73px;left:1080px;top:640px;z-index:4;visibility:hidden' />
					<img id='ele8' src='images/application/player/theme/classic/ui_huge/focus/f_mode1.png' style='position:absolute;width:86px;height:73px;left:1140px;top:640px;z-index:4;visibility:hidden' />
					<img id='ele9' src='images/application/player/theme/classic/ui_huge/focus/f_list.png' style='position:absolute;width:86px;height:73px;left:1200px;top:640px;z-index:4;visibility:hidden' />
				</div>
				<div id='list' style='display:none'>
					<img src='images/application/player/theme/classic/list/bar.png' style='position:absolute;width:498px;height:720px;left:782px;top:0px;z-index:2' />
					<div id='resultSrh' style='position:absolute;width:300px;height:20px;left:825px;top:58px;color:#FFFFFF;font-size:20px;z-index:3'></div><%int y = 0; for(int i = 1; i < 10; i++){ y = (i - 1) * 56 + 120; int idx = i - 1;%>
					<div id='s<%=i %>' style='position:absolute;width:200px;height:30px;left:825px;top:<%=y %>px;color:#FFFFFF;font-size:24px;z-index:4'></div>
					<div id='a<%=i %>' style='position:absolute;width:100px;height:25px;left:1020px;top:<%=y + 4 %>px;color:#B2AFAA;font-size:18px;text-align:right;z-index:4;overflow:hidden'></div>
					<img id='f<%=i %>' src='images/application/player/theme/classic/list/back.png' style='position:absolute;width:435px;height:56px;left:814px;top:<%=y - 12 %>px;z-index:3;visibility:hidden' />
					<img id='p<%=i %>' src='images/application/player/theme/classic/list/play.png' style='position:absolute;width:72px;height:72px;left:1135px;top:<%=y - 19 %>px;z-index:4;visibility:hidden' />
					<img id='d<%=i %>' src='images/application/player/theme/classic/list/del.png' style='position:absolute;width:72px;height:72px;left:1192px;top:<%=y - 19 %>px;z-index:4;visibility:hidden' />
					<img id='f_p<%=i %>' src='images/application/player/theme/classic/list/focus/f_play.png' style='position:absolute;width:72px;height:72px;left:1135px;top:<%=y - 19 %>px;z-index:5;visibility:hidden' />
					<img id='f_d<%=i %>' src='images/application/player/theme/classic/list/focus/f_del.png' style='position:absolute;width:72px;height:72px;left:1192px;top:<%=y - 19 %>px;z-index:5;visibility:hidden' /><%}%>
					<img src='images/application/player/theme/classic/list/l.png' style='position:absolute;width:50px;height:50px;left:1080px;top:620px;z-index:4' />
					<img src='images/application/player/theme/classic/list/n.png' style='position:absolute;width:50px;height:50px;left:1200px;top:620px;z-index:4' />
					<img id='f_l' src='images/application/player/theme/classic/list/focus/f_l.png' style='position:absolute;width:50px;height:50px;left:1080px;top:620px;z-index:5;visibility:hidden' />
					<img id='f_n' src='images/application/player/theme/classic/list/focus/f_n.png' style='position:absolute;width:50px;height:50px;left:1200px;top:620px;z-index:5;visibility:hidden' />
					<div id='pageInfo' style='position:absolute;width:90px;height:30px;left:1118px;top:628px;color:#FFFFFF;font-size:24px;;text-align:center;z-index:4'></div>
				</div>
				<!-- 预加载状态图片 -->
				<img src='images/application/player/theme/classic/status/p.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/p0.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/n.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/l.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />	
				<img src='images/application/player/theme/classic/status/sta_channel.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/sta_channel0.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/f1.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/f2.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/f4.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/f8.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/f16.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/f32.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/r1.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/r2.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/r4.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/r8.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/r16.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/r32.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/sta_clt.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/sta_clt0.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<img src='images/application/player/theme/classic/status/sta_err.png' style='position:absolute;left:0px;top:0px;z-index:10;visibility:hidden' />
				<!-- 状态栏 -->
				<div id='status' style='position:absolute;width:0px;height:0px;left:0px;top:0px;z-index:100;text-align:center'></div>
				<script type='text/javascript' src='javascript/player/player_full.js?r=<%=Math.random() %>'></script>
				<script type='text/javascript' src='javascript/apply.js?r=<%=Math.random() %>'></script>
			</div>
		</div><%@include file="common/footer.jsp" %>